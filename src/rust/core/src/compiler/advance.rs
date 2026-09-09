//! 先行指定 — values written ahead of, or across, the notes they belong to.
//!
//! `P.onNote(0,127)` hands a control change a value per note; `M.onTime(0,64,96)`
//! sweeps one over time; `p.onNoteWaveEx(...)` draws a shape scaled to each
//! note's length. This module holds the state each such modifier carries and
//! works out *when* and *what* to write.
//!
//! The behaviour mirrors `WriteCCWave` and `TNoteInfo.GetValue` in the Pascal
//! build, quirks included — the odd loop bounds and the one-tick-early writes
//! are what make the output match, so they are reproduced rather than tidied.

use crate::rng::Rng;

/// Controller number 256 means a full-range pitch bend, 257 the simple form.
pub const BEND_FULL: i64 = 256;
pub const BEND_EASY: i64 = 257;

/// Default write frequency, in ticks (`SongInfo.CCFreq`).
pub const DEFAULT_FREQUENCY: i64 = 2;

/// Which kind of advance specification is in effect.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Kind {
    /// A value per note.
    OnNote,
    /// A ramp over time, written once when it is declared.
    OnTime,
    /// A sine written once when it is declared.
    CcSine,
    /// A sine per note.
    OnSine,
    /// A value every `len` ticks.
    OnCycle,
    /// A ramp per note, stopping at the note's end.
    OnWave,
    /// A ramp per note, scaled to fit the note's length.
    OnWaveEx,
    /// A ramp repeated for as long as the note sounds.
    OnWaveR,
    /// Declared, but finished: nothing more to write.
    Off,
}

/// One control change (or bend) with an advance specification attached.
#[derive(Debug, Clone)]
pub struct CcModifier {
    /// 0..=127 for a control change, or [`BEND_FULL`] / [`BEND_EASY`].
    pub no: i64,
    pub kind: Kind,
    pub reserve: Vec<i64>,
    /// Position in `reserve` for the per-note kinds.
    pub index: usize,
    /// `.Delay` — how far ahead of the note the values are written.
    pub delay: i64,
    /// `.Repeat(off)` stops the list cycling once it is used up.
    pub repeat: bool,
    /// `.Random` — spread added to each value.
    pub random: i64,
    /// `.Range(low,high)` — clamp applied to each value.
    pub range: Option<(i64, i64)>,
    /// The last value written, so an unchanged one is not written twice.
    pub last_value: i64,
    /// The time the specification was declared.
    pub time: i64,
}

impl CcModifier {
    pub fn new(no: i64) -> Self {
        Self {
            no,
            kind: Kind::Off,
            reserve: Vec::new(),
            index: 0,
            delay: 0,
            repeat: true,
            random: 0,
            range: None,
            last_value: i64::MIN,
            time: 0,
        }
    }

    /// Work out the (time, value) pairs to write for one note.
    ///
    /// `track_time` is where the note starts, `note_len` how long it lasts —
    /// zero when a specification writes itself at the point of declaration.
    pub fn events(
        &mut self,
        track_time: i64,
        note_len: i64,
        frequency: i64,
        rng: &mut Rng,
    ) -> Vec<(i64, i64)> {
        let mut out = Vec::new();
        let mut old = i64::MAX;
        let time_ptr = track_time + self.delay;
        let frequency = frequency.max(1);

        // A delayed bend leaves its centre value behind at the note's own
        // time, so the delay does not also bend the note's start.
        if self.delay > 0 {
            match self.no {
                BEND_EASY => push(&mut out, &mut old, track_time, 64, self, rng),
                BEND_FULL => push(&mut out, &mut old, track_time, 0, self, rng),
                _ => {}
            }
        }

        match self.kind {
            Kind::OnNote => self.sub_note(&mut out, &mut old, time_ptr, rng),
            Kind::OnCycle => self.sub_cycle(&mut out, &mut old, time_ptr, rng),
            Kind::OnTime | Kind::OnWave => {
                self.sub_time(&mut out, &mut old, time_ptr, note_len, frequency, rng)
            }
            Kind::OnWaveEx => {
                self.sub_wave_ex(&mut out, &mut old, time_ptr, note_len, frequency, rng)
            }
            Kind::OnWaveR => {
                self.sub_wave_r(&mut out, &mut old, time_ptr, note_len, frequency, rng)
            }
            Kind::CcSine | Kind::OnSine => {
                self.sub_sine(&mut out, &mut old, time_ptr, note_len, frequency, rng)
            }
            Kind::Off => {}
        }

        if old != i64::MAX {
            self.last_value = old;
        }
        out
    }

    /// One value per note, written a tick ahead of it.
    fn sub_note(&mut self, out: &mut Vec<(i64, i64)>, old: &mut i64, time_ptr: i64, rng: &mut Rng) {
        if self.index >= self.reserve.len() {
            if !self.repeat {
                self.kind = Kind::Off;
                return;
            }
            self.index = 0;
        }
        let Some(&value) = self.reserve.get(self.index) else {
            return;
        };
        if self.last_value != value {
            push(out, old, time_ptr - 1, value, self, rng);
        }
        self.last_value = value;
        self.index += 1;
    }

    /// `(len, v1, v2, ...)` — step to the next value every `len` ticks.
    fn sub_cycle(
        &mut self,
        out: &mut Vec<(i64, i64)>,
        old: &mut i64,
        time_ptr: i64,
        rng: &mut Rng,
    ) {
        if self.reserve.len() < 2 {
            return;
        }
        let len = self.reserve[0];
        if len == 0 {
            return;
        }
        let step = (time_ptr - self.time).div_euclid(len);
        let index = 1 + (step.rem_euclid(self.reserve.len() as i64 - 1)) as usize;
        let value = self.reserve[index];
        push(out, old, time_ptr - 1, value, self, rng);
    }

    /// `(low, high, len, ...)` — a straight ramp through each triple.
    fn sub_time(
        &mut self,
        out: &mut Vec<(i64, i64)>,
        old: &mut i64,
        time_ptr: i64,
        note_len: i64,
        frequency: i64,
        rng: &mut Rng,
    ) {
        let mut at = time_ptr;
        let mut total = 0i64;
        let mut index = 0usize;

        while index + 2 < self.reserve.len() {
            let (low, high, len) = (
                self.reserve[index],
                self.reserve[index + 1],
                self.reserve[index + 2],
            );
            let slope = if len != 0 {
                (high - low) as f64 / len as f64
            } else {
                0.0
            };
            // One step of slack at the end, as the Pascal build leaves.
            let count = (len / frequency) - 1;
            let mut stopped = false;
            for step in 0..(count - 1).max(0) {
                let value = (slope * (step * frequency) as f64) as i64 + low;
                push(out, old, at + step * frequency - 1, value, self, rng);

                total += frequency;
                if self.kind == Kind::OnWave && total > note_len {
                    stopped = true;
                    break;
                }
            }
            if stopped || (self.kind == Kind::OnWave && total > note_len) {
                break;
            }
            if count > 0 {
                // Land exactly on the target value at the end of the ramp.
                push(out, old, at + frequency * (count - 1), high, self, rng);
            }
            index += 3;
            at += len;
        }
    }

    /// As a ramp, but each triple's length is a share of the note's length.
    fn sub_wave_ex(
        &mut self,
        out: &mut Vec<(i64, i64)>,
        old: &mut i64,
        time_ptr: i64,
        note_len: i64,
        frequency: i64,
        rng: &mut Rng,
    ) {
        let triples = self.reserve.len() / 3;
        let mut total_len: i64 = (0..triples).map(|i| self.reserve[i * 3 + 2]).sum();
        if total_len <= 0 {
            total_len = 1;
        }

        let mut at = time_ptr;
        for i in 0..triples {
            let (low, high, len) = (
                self.reserve[i * 3],
                self.reserve[i * 3 + 1],
                self.reserve[i * 3 + 2],
            );
            let share = len as f64 / total_len as f64;
            let real_len = (share * note_len as f64) as i64;
            let slope = if real_len != 0 {
                (high - low) as f64 / real_len as f64
            } else {
                0.0
            };
            let count = (real_len / frequency) - 1;
            for step in 0..(count - 1).max(0) {
                let value = (slope * (step * frequency) as f64) as i64 + low;
                push(out, old, at + step * frequency, value, self, rng);
            }
            if count > 0 {
                push(out, old, at + frequency * (count - 1), high, self, rng);
            }
            at += real_len;
        }
    }

    /// A ramp repeated for as long as the note sounds.
    fn sub_wave_r(
        &mut self,
        out: &mut Vec<(i64, i64)>,
        old: &mut i64,
        time_ptr: i64,
        note_len: i64,
        frequency: i64,
        rng: &mut Rng,
    ) {
        if self.reserve.is_empty() {
            return;
        }
        let last = time_ptr + note_len;
        let mut at = time_ptr;
        let mut total = 0i64;
        let mut index = 0usize;

        while at < last {
            if index + 3 > self.reserve.len() {
                index = 0;
            }
            let (low, high, len) = (
                self.reserve[index],
                self.reserve[index + 1],
                self.reserve[index + 2],
            );
            if len <= 0 {
                break;
            }
            index += 3;

            // A segment shorter than one step just writes its target.
            if frequency >= len {
                push(out, old, at, high, self, rng);
                at += frequency;
                continue;
            }

            let slope = (high - low) as f64 / (len - 1) as f64;
            let count = len / frequency;
            for step in 0..count {
                if at >= last {
                    return;
                }
                let value = (slope * (step * frequency) as f64) as i64 + low;
                push(out, old, at, value, self, rng);
                at += frequency;
                total += frequency;
                if total > note_len {
                    break;
                }
            }
        }
    }

    /// `(type, low, high, len, times)` — a sine, optionally fading in or out.
    fn sub_sine(
        &mut self,
        out: &mut Vec<(i64, i64)>,
        old: &mut i64,
        time_ptr: i64,
        note_len: i64,
        frequency: i64,
        rng: &mut Rng,
    ) {
        if self.reserve.len() < 5 {
            return;
        }
        let (wave_type, low, high, len, times) = (
            self.reserve[0],
            self.reserve[1],
            self.reserve[2],
            self.reserve[3],
            self.reserve[4],
        );
        let count = len / frequency;
        if count <= 0 {
            return;
        }
        let height = (high - low) as f64;

        // A per-note sine stops when the note does.
        let mut break_count = count;
        if self.kind == Kind::OnSine && note_len < len {
            break_count = note_len / frequency;
            if break_count <= 0 {
                return;
            }
        }

        let cycle = (count / times.max(1)) - 1;
        if cycle <= 0 {
            return;
        }
        for i in 0..count {
            if i > break_count {
                break;
            }
            let at = ((len as f64 / count as f64) * i as f64) as i64;
            // Deliberately 3.14 and not π: the Pascal build uses the rounded
            // constant, and the slightly-off curve is the shape songs were
            // written against. Using π here would change existing music.
            #[allow(clippy::approx_constant)]
            let phase = 3.14 * ((i % cycle) as f64 / cycle as f64);
            let mut value = (height * phase.sin()) as i64;
            match wave_type {
                1 => value = (value as f64 * (i as f64 / count as f64)) as i64,
                2 => value -= (value as f64 * (i as f64 / count as f64)) as i64,
                _ => {}
            }
            push(out, old, time_ptr + at, value + low, self, rng);
        }
    }
}

/// Record one value, after the random spread and range clamp, skipping it when
/// it repeats the value already written.
fn push(
    out: &mut Vec<(i64, i64)>,
    old: &mut i64,
    time: i64,
    value: i64,
    modifier: &CcModifier,
    rng: &mut Rng,
) {
    let mut value = value;
    if modifier.random != 0 {
        value += rng.range(0, modifier.random * 2 - 1) - modifier.random;
    }
    if let Some((low, high)) = modifier.range {
        value = value.max(low).min(high);
    }
    if *old == value {
        return;
    }
    *old = value;
    // Times may be negative: a value written a tick ahead of a note at time 0
    // must still sort before it. The SMF writer clamps the delta, not the time.
    out.push((time, value));
}

/// Clamp a value into the range its destination can carry.
pub fn clamp_for(no: i64, value: i64) -> i64 {
    match no {
        BEND_FULL => value.clamp(-8192, 8191),
        BEND_EASY => (value * 128 - 8192).clamp(-8192, 8191),
        _ => value.clamp(0, 127),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn modifier(kind: Kind, reserve: &[i64]) -> CcModifier {
        let mut m = CcModifier::new(10);
        m.kind = kind;
        m.reserve = reserve.to_vec();
        m
    }

    #[test]
    fn on_note_hands_out_one_value_per_note_a_tick_early() {
        let mut m = modifier(Kind::OnNote, &[10, 20]);
        let mut rng = Rng::default();
        assert_eq!(m.events(0, 96, 2, &mut rng), vec![(-1, 10)]);
        assert_eq!(m.events(96, 96, 2, &mut rng), vec![(95, 20)]);
        // The list cycles.
        assert_eq!(m.events(192, 96, 2, &mut rng), vec![(191, 10)]);
    }

    #[test]
    fn repeat_off_stops_at_the_end_of_the_list() {
        let mut m = modifier(Kind::OnNote, &[10, 20]);
        m.repeat = false;
        let mut rng = Rng::default();
        m.events(0, 96, 2, &mut rng);
        m.events(96, 96, 2, &mut rng);
        assert!(m.events(192, 96, 2, &mut rng).is_empty());
        assert_eq!(m.kind, Kind::Off);
    }

    #[test]
    fn on_cycle_steps_every_len_ticks() {
        let mut m = modifier(Kind::OnCycle, &[48, 10, 20]);
        let mut rng = Rng::default();
        assert_eq!(m.events(0, 96, 2, &mut rng), vec![(-1, 10)]);
        assert_eq!(m.events(48, 96, 2, &mut rng), vec![(47, 20)]);
        assert_eq!(m.events(96, 96, 2, &mut rng), vec![(95, 10)]);
    }

    #[test]
    fn range_clamps_and_repeats_are_skipped() {
        let mut m = modifier(Kind::OnNote, &[0, 200]);
        m.range = Some((10, 100));
        let mut rng = Rng::default();
        assert_eq!(m.events(0, 96, 2, &mut rng), vec![(-1, 10)]);
        assert_eq!(m.events(96, 96, 2, &mut rng), vec![(95, 100)]);
    }

    #[test]
    fn a_ramp_climbs_towards_its_target() {
        let mut m = modifier(Kind::OnTime, &[0, 127, 96]);
        let mut rng = Rng::default();
        let events = m.events(0, 0, 2, &mut rng);
        assert!(!events.is_empty());
        // Rises, and never past the target.
        assert!(events.windows(2).all(|w| w[0].1 <= w[1].1));
        assert!(events.iter().all(|(_, v)| *v <= 127));
        assert_eq!(events.last().unwrap().1, 127);
    }

    #[test]
    fn easy_bend_values_are_scaled_into_the_bend_range() {
        assert_eq!(clamp_for(BEND_EASY, 64), 0);
        assert_eq!(clamp_for(BEND_EASY, 0), -8192);
        assert_eq!(clamp_for(BEND_FULL, 9000), 8191);
        assert_eq!(clamp_for(10, 200), 127);
    }
}
