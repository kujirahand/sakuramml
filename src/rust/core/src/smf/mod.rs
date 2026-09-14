//! Standard MIDI File construction.
//!
//! Events are collected per track with absolute times and serialised into
//! MThd/MTrk chunks. Byte layout follows the Pascal implementation
//! (`smf_types.pas`): format 1, one MTrk per used track, explicit note-off
//! (0x8n) with the note's own velocity, and no running status.

pub mod event;

pub use event::Event;

use crate::error::{MmlError, Result};

/// The largest value a MIDI variable-length quantity can hold, and so the
/// largest delta time or chunk length an SMF can express.
pub const MAX_VAR_LEN: i64 = 0x0fff_ffff;

/// A division (ticks per quarter note) is a 15-bit field in the header.
pub const MAX_TIMEBASE: i64 = 0x7fff;

/// One MIDI track: absolute-timed events plus the track's final time pointer.
#[derive(Debug, Default, Clone)]
pub struct Track {
    pub events: Vec<Event>,
    /// Time pointer at the end of the track; the End-of-Track delta is
    /// measured from the last event to here.
    pub end_time: i64,
}

impl Track {
    pub fn push(&mut self, event: Event) {
        self.events.push(event);
    }
}

/// A whole song: the division (timebase) and its tracks.
#[derive(Debug, Clone)]
pub struct Song {
    pub timebase: u16,
    pub tracks: Vec<Track>,
}

impl Song {
    pub fn new(timebase: u16) -> Self {
        Self {
            timebase,
            tracks: Vec::new(),
        }
    }

    /// Serialise to SMF bytes.
    ///
    /// Fails rather than writing a malformed file: the format cannot express
    /// a division above 15 bits, a delta time above 28, or more than 65535
    /// tracks, and silently truncating any of those would produce a file that
    /// plays back wrong.
    pub fn to_bytes(&self) -> Result<Vec<u8>> {
        if self.tracks.len() > u16::MAX as usize {
            return Err(MmlError::new(
                0,
                format!(
                    "トラック数が多すぎます(最大{}): {}",
                    u16::MAX,
                    self.tracks.len()
                ),
            ));
        }
        let mut out = Vec::new();
        out.extend_from_slice(b"MThd");
        out.extend_from_slice(&6u32.to_be_bytes());
        out.extend_from_slice(&1u16.to_be_bytes()); // format 1
        out.extend_from_slice(&(self.tracks.len() as u16).to_be_bytes());
        out.extend_from_slice(&self.timebase.to_be_bytes());
        for track in &self.tracks {
            out.extend_from_slice(&track_chunk(track)?);
        }
        Ok(out)
    }
}

fn track_chunk(track: &Track) -> Result<Vec<u8>> {
    let mut events = track.events.clone();
    let deferred_order = adjust_overlapping_notes(&mut events);
    // Stable sort keeps same-time events in the order they were written.
    // Note-offs generated from ordinary packed notes come last because the
    // Pascal build appends them during its finalisation pass. A low-level
    // NoteOff command is already a direct event and must retain its position.
    let mut indexed_events: Vec<_> = events.into_iter().enumerate().collect();
    indexed_events.sort_by_key(|(index, event)| {
        let order = if event.deferred_at_same_time {
            deferred_order[*index]
        } else {
            *index
        };
        (event.time, event.deferred_at_same_time as u8, order)
    });
    let mut events: Vec<_> = indexed_events.into_iter().map(|(_, event)| event).collect();
    remove_duplicate_controllers(&mut events);

    let mut body = Vec::new();
    let mut last_time = 0i64;
    for event in &events {
        if event.data.is_empty() {
            continue;
        }
        // A value written a tick ahead of a note at time 0 has a negative
        // time: it sorts before the note, but lands at 0 in the file.
        let time = event.time.max(0);
        write_delta(&mut body, time - last_time)?;
        body.extend_from_slice(&event.data);
        last_time = time;
    }
    // End of track
    write_delta(&mut body, track.end_time - last_time)?;
    body.extend_from_slice(&[0xff, 0x2f, 0x00]);

    if body.len() as u64 > u32::MAX as u64 {
        return Err(MmlError::new(0, "トラックが大きすぎます"));
    }
    let mut chunk = Vec::with_capacity(body.len() + 8);
    chunk.extend_from_slice(b"MTrk");
    chunk.extend_from_slice(&(body.len() as u32).to_be_bytes());
    chunk.extend_from_slice(&body);
    Ok(chunk)
}

/// Pascal drops the earlier of two adjacent, identical CC writes at one tick
/// after sorting the track.
fn remove_duplicate_controllers(events: &mut [Event]) {
    for index in 1..events.len() {
        let previous = &events[index - 1];
        let current = &events[index];
        let duplicate = previous.time == current.time
            && previous.data.len() == 3
            && previous.data[0] & 0xf0 == 0xb0
            && previous.data == current.data;
        if duplicate {
            events[index - 1].data.clear();
        }
    }
}

/// Pascal shortens a packed note when the same note number is retriggered
/// before its NoteOff, even when the channel has changed. This is especially
/// visible in delay helpers, where several copies of one phrase overlap at
/// fixed offsets.
fn adjust_overlapping_notes(events: &mut [Event]) -> Vec<usize> {
    let mut pairs = Vec::new();
    for on_index in 0..events.len() {
        let Some(status) = events[on_index].data.first().copied() else {
            continue;
        };
        if status & 0xf0 != 0x90 || events[on_index].data.get(2) == Some(&0) {
            continue;
        }
        let channel = status & 0x0f;
        let note = events[on_index].data.get(1).copied().unwrap_or(0);
        if let Some(off_index) = (on_index + 1 < events.len())
            .then_some(on_index + 1)
            .filter(|index| {
                let event = &events[*index];
                event.deferred_at_same_time
                    && event
                        .data
                        .first()
                        .is_some_and(|byte| byte & 0x0f == channel)
                    && event.data.get(1) == Some(&note)
            })
        {
            pairs.push((note, on_index, off_index));
        }
    }
    pairs.sort_by_key(|(_, on, _)| events[*on].time);
    let mut deferred_order = vec![usize::MAX; events.len()];
    for (order, &(_, _, off)) in pairs.iter().enumerate() {
        deferred_order[off] = order;
    }

    for index in 0..pairs.len() {
        let (note, current_on, _) = pairs[index];
        let current_time = events[current_on].time;
        for &(previous_note, previous_on, previous_off) in pairs[..index].iter().rev() {
            if previous_note != note {
                continue;
            }
            let previous_time = events[previous_on].time;
            if previous_time + 768 < current_time {
                break;
            }
            if previous_time <= current_time && current_time <= events[previous_off].time {
                let shortened = current_time - previous_time - 1;
                if shortened <= 0 {
                    events[previous_on].data.clear();
                    events[previous_off].data.clear();
                } else {
                    events[previous_off].time = previous_time + shortened;
                }
                break;
            }
        }
    }
    deferred_order
}

/// Write a delta time, refusing one the format cannot represent.
fn write_delta(out: &mut Vec<u8>, delta: i64) -> Result<()> {
    let delta = delta.max(0);
    if delta > MAX_VAR_LEN {
        return Err(MmlError::new(
            0,
            format!("デルタタイムが大きすぎます(最大{MAX_VAR_LEN}): {delta}"),
        ));
    }
    write_var_len(out, delta as u32);
    Ok(())
}

/// Write a MIDI variable-length quantity.
pub fn write_var_len(out: &mut Vec<u8>, mut value: u32) {
    let mut buffer = value & 0x7f;
    loop {
        value >>= 7;
        if value == 0 {
            break;
        }
        buffer <<= 8;
        buffer |= (value & 0x7f) | 0x80;
    }
    loop {
        out.push((buffer & 0xff) as u8);
        if buffer & 0x80 != 0 {
            buffer >>= 8;
        } else {
            break;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn var_len(value: u32) -> Vec<u8> {
        let mut out = Vec::new();
        write_var_len(&mut out, value);
        out
    }

    #[test]
    fn var_len_matches_midi_spec() {
        assert_eq!(var_len(0), vec![0x00]);
        assert_eq!(var_len(0x40), vec![0x40]);
        assert_eq!(var_len(0x7f), vec![0x7f]);
        assert_eq!(var_len(0x80), vec![0x81, 0x00]);
        assert_eq!(var_len(0x2000), vec![0xc0, 0x00]);
        assert_eq!(var_len(0x3fff), vec![0xff, 0x7f]);
        assert_eq!(var_len(0x100000), vec![0xc0, 0x80, 0x00]);
        assert_eq!(var_len(0x0fffffff), vec![0xff, 0xff, 0xff, 0x7f]);
    }

    #[test]
    fn empty_song_header() {
        let song = Song::new(96);
        assert_eq!(
            song.to_bytes().unwrap(),
            b"MThd\x00\x00\x00\x06\x00\x01\x00\x00\x00\x60".to_vec()
        );
    }

    #[test]
    fn single_note_track_matches_pascal_bytes() {
        // Reference bytes taken from the Pascal build: `csakura -e "c"`.
        let mut track = Track::default();
        track.push(Event::note_on(0, 0, 60, 100));
        track.push(Event::note_off(75, 0, 60, 100));
        track.end_time = 96;
        let mut song = Song::new(96);
        song.tracks.push(track);

        let expected = hex("4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00");
        assert_eq!(song.to_bytes().unwrap(), expected);
    }

    #[test]
    fn identical_controllers_at_the_same_time_keep_only_the_later_event() {
        let mut events = vec![
            Event::control_change(10, 0, 1, 64),
            Event::control_change(10, 0, 11, 127),
            Event::control_change(10, 0, 1, 64),
            Event::control_change(11, 0, 1, 32),
            Event::control_change(11, 0, 1, 32),
        ];
        remove_duplicate_controllers(&mut events);
        assert_eq!(events[0].data, [0xb0, 1, 64]);
        assert_eq!(events[1].data, [0xb0, 11, 127]);
        assert_eq!(events[2].data, [0xb0, 1, 64]);
        assert!(events[3].data.is_empty());
        assert_eq!(events[4].data, [0xb0, 1, 32]);
    }

    fn hex(s: &str) -> Vec<u8> {
        (0..s.len())
            .step_by(2)
            .map(|i| u8::from_str_radix(&s[i..i + 2], 16).unwrap())
            .collect()
    }

    #[test]
    fn a_delta_time_beyond_the_format_is_an_error() {
        let mut track = Track::default();
        track.push(Event::note_on(0, 0, 60, 100));
        track.push(Event::note_off(MAX_VAR_LEN + 1, 0, 60, 100));
        track.end_time = MAX_VAR_LEN + 1;
        let mut song = Song::new(96);
        song.tracks.push(track);

        let error = song.to_bytes().unwrap_err();
        assert!(error.message.contains("デルタタイム"), "{}", error.message);
    }

    #[test]
    fn the_largest_representable_delta_still_works() {
        let mut track = Track::default();
        track.push(Event::note_on(0, 0, 60, 100));
        track.push(Event::note_off(MAX_VAR_LEN, 0, 60, 100));
        track.end_time = MAX_VAR_LEN;
        let mut song = Song::new(96);
        song.tracks.push(track);

        assert!(song.to_bytes().is_ok());
    }
}
