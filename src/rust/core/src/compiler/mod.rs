//! Command dispatch and musical state.
//!
//! Phase 1 scope: notes, rests, ties, octave/length/velocity/gate attributes,
//! track & channel selection, tempo, timebase and the text meta events.
//! Everything here mirrors byte-for-byte behaviour measured from the Pascal
//! build (see `tests/golden.rs`).

pub mod advance;

use std::collections::{BTreeMap, BTreeSet};

use crate::compiler::advance::{self as advance_spec, CcModifier, Kind};
use crate::encoding::encode_cp932;
use crate::error::{MmlError, Result, Warning};
use crate::expr::{self, EvalContext, Value, Variables};
use crate::include::{IncludeResolver, NoIncludes};
use crate::lexer::rythm;
use crate::lexer::Cursor;
use crate::rng::Rng;
use crate::smf::{event, Event, Song, Track};

/// Default division (ticks per quarter note).
pub const DEFAULT_TIMEBASE: i64 = 96;

/// Ceiling on the events one compile may produce.
///
/// A loop nested a few deep can ask for billions of notes from a few lines of
/// MML. Native would grind; in a browser tab it is an out-of-memory crash, so
/// the compile stops with a diagnostic well before that. A million events is
/// far more than any real song — the largest sample here writes a few thousand.
pub const MAX_EVENTS: usize = 1_000_000;

/// Maximum number of elements held by one dynamically grown array.
///
/// An MML source can choose an arbitrary index, so resizing must be bounded
/// before allocating memory (especially in the WASM build).
pub const MAX_ARRAY_ELEMENTS: usize = 1_000_000;

/// Ceiling on a track's time pointer, so time arithmetic cannot run away
/// before the SMF writer would reject the delta anyway.
pub const MAX_TIME: i64 = crate::smf::MAX_VAR_LEN;

/// Maximum nesting depth for loops and other recursive constructs.
/// Matches `NestCountCompile` in the Pascal implementation, and keeps the
/// WASM stack out of trouble.
pub const MAX_NEST: usize = 128;

/// Stop recovery after this many diagnostics. This keeps a badly malformed
/// file from producing an unbounded error list in a browser tab.
pub const MAX_ERRORS: usize = 1_000;

/// What a compile produced, before serialisation.
pub struct CompileResult {
    pub song: Song,
    /// Recoverable errors encountered while producing a partial song.
    pub errors: Vec<MmlError>,
    pub warnings: Vec<Warning>,
    /// Output of `Print(...)` statements, in order.
    pub messages: Vec<String>,
}

/// Per-track musical state.
#[derive(Debug, Clone)]
struct TrackState {
    channel: u8,
    /// Transposition applied only to this track (`TrackKey`).
    key: i64,
    /// MIDI port selected by `Port`.
    port: i64,
    time: i64,
    octave: i64,
    length: i64,
    length_in_steps: bool,
    /// Effective step mode inherited from `System.Stepmode` or selected by `l%`.
    system_step_mode: bool,
    /// Order of the comma-separated note arguments (`ArgOrder`).
    arg_order: String,
    velocity: i64,
    gate_percent: i64,
    timing: i64,
    events: Vec<Event>,
    /// Time at which the most recent note ended, so `^` can extend it.
    last_note: Option<LastNote>,
    /// The last note number written on this track, used by `KeyPressure`.
    last_note_no: Option<u8>,
    /// One-shot octave shift from `` ` `` or `"`, applied to the next note.
    octave_once: i64,
    /// `q%n` gives the gate in ticks rather than as a percentage.
    gate_in_steps: bool,
    /// The voice last selected with `@`, for `MML(@)`.
    voice: i64,
    /// Last full/easy pitch-bend values, for `MML(p%)` and `MML(p)`.
    pitch_bend_full: i64,
    pitch_bend_easy: i64,
    /// Advance specifications attached to note attributes.
    note_modifiers: Vec<(OnNoteTarget, NoteModifier)>,
    /// Advance specifications attached to control changes and bends.
    cc_modifiers: Vec<CcModifier>,
    /// Set once any event is recorded, so a track PlayFrom trims to empty is
    /// still written out (an empty MTrk), matching the Pascal build.
    used: bool,
    /// Suppress note events while still advancing the time pointer.
    muted: bool,
    /// Suppress every control-change and pitch-bend write on this track.
    cc_muted: bool,
    /// Controllers individually suppressed by `CCNoMute`.
    cc_no_mute: [bool; 128],
    /// Legacy `n(...),0` chord notes, held until a positive-length note ends
    /// the chord and supplies their common gate.
    pending_zero_length_notes: Vec<PendingNote>,
    slur_mode: i64,
    slur_value: i64,
    slur_notes: Vec<SlurNote>,
}

#[derive(Debug, Clone, Copy)]
struct LastNote {
    /// Index into `events` of the note-off to move when a tie extends it.
    off_index: usize,
    start: i64,
}

#[derive(Debug, Clone, Copy)]
struct PendingNote {
    start: i64,
    channel: u8,
    note: u8,
    velocity: u8,
}

#[derive(Debug, Clone, Copy)]
struct SlurNote {
    start: i64,
    off: i64,
    note: u8,
    velocity: u8,
    transition: Option<i64>,
}

impl TrackState {
    fn new(track_no: i64, timebase: i64, step_mode: bool) -> Self {
        Self {
            channel: default_channel(track_no),
            key: 0,
            port: 0,
            time: 0,
            octave: 5,
            length: timebase, // l4 at the default timebase
            length_in_steps: false,
            system_step_mode: step_mode,
            arg_order: "lqvto".to_string(),
            velocity: 100,
            gate_percent: 80,
            timing: 0,
            events: Vec::new(),
            last_note: None,
            last_note_no: None,
            octave_once: 0,
            gate_in_steps: false,
            // Pascal reports zero until the first program change.
            voice: 0,
            pitch_bend_full: -1,
            pitch_bend_easy: -1,
            note_modifiers: Vec::new(),
            cc_modifiers: Vec::new(),
            muted: false,
            cc_muted: false,
            cc_no_mute: [false; 128],
            pending_zero_length_notes: Vec::new(),
            slur_mode: 0,
            slur_value: 12,
            slur_notes: Vec::new(),
            used: false,
        }
    }
}

#[derive(Debug, Clone, Copy)]
struct TimeKeyRule {
    from: i64,
    to: Option<i64>,
    key: i64,
}

#[derive(Debug, Clone, Copy)]
struct TimeKeyFlagRule {
    from: i64,
    to: Option<i64>,
    /// Stored in the compiler's c,d,e,f,g,a,b order.
    key_flags: [i64; 7],
}

/// Track number `n` defaults to MIDI channel `n - 1`.
fn default_channel(track_no: i64) -> u8 {
    (track_no - 1).clamp(0, 15) as u8
}

pub struct Compiler<'a> {
    includes: &'a dyn IncludeResolver,
    timebase: i64,
    /// Last tempo selected by `Tempo` or `TempoChange` (BPM).
    tempo: i64,
    tracks: BTreeMap<i64, TrackState>,
    current: i64,
    warnings: Vec<Warning>,
    errors: Vec<MmlError>,
    recover_errors: bool,
    stop_requested: bool,
    depth: usize,
    variables: Variables,
    functions: BTreeMap<String, FunctionDef>,
    /// Sharps/flats applied per pitch class (c d e f g a b), from `KeyFlag`.
    key_flags: [i64; 7],
    /// Global transpose, in semitones (`System.Keyshift`).
    key_shift: i64,
    /// Whether Key/TimeKey/TimeKey2/TrackKey affect subsequently read notes.
    use_key_shift: bool,
    x68_mode: bool,
    step_mode: bool,
    voice_no_shift: i64,
    octave_range_shift: i64,
    /// Time-scoped transpositions. Later matching declarations win.
    time_keys: Vec<TimeKeyRule>,
    time_keys2: Vec<TimeKeyRule>,
    time_key_flags: Vec<TimeKeyFlagRule>,
    /// Bend range per MIDI channel; GM defaults to two semitones.
    bend_ranges: [i64; 16],
    /// Value of `q` that means 100% gate (`System.qMax`).
    q_max: i64,
    /// Value of `v` that means full velocity (`System.vMax`).
    v_max: i64,
    /// Steps used by `q++` / `v++` (and `q%++`) in legacy MML.
    q_add: i64,
    q2_add: i64,
    v_add: i64,
    /// Offset applied to measure numbers in `Time` (`System.MeasureShift`).
    measure_shift: i64,
    /// How many ticks ordinary CC and pitch-bend events precede the cursor.
    /// Program changes always precede it by one tick in the Pascal build.
    controller_shift: i64,
    allow_multi_line: bool,
    meta_text_eol: i64,
    /// Time signature, used to turn `Time(m:b:t)` into ticks.
    time_signature: (i64, i64),
    /// Output of `Print(...)`, handed back to the caller instead of printed.
    messages: Vec<String>,
    /// Set by `Exit` to unwind out of the enclosing loop.
    exiting: bool,
    rng: Rng,
    /// Events written so far, against [`MAX_EVENTS`].
    event_count: usize,
    /// Event slots reserved by notes buffered in unfinished Slur chains.
    buffered_slur_events: usize,
    play_from: PlayFromSpec,
    /// Current `Stretch` multiplier. Pascal uses an Extended value and
    /// truncates every affected note/gate independently.
    stretch_rate: f64,
    /// Positive means Solo, negative means Mute, zero means no track filter.
    solo_or_mute: i8,
    selected_tracks: BTreeSet<i64>,
    /// While writing a chord, the time every note in it starts at.
    chord_start: Option<i64>,
    /// `.Frequency` — how often a ramp writes, in ticks.
    cc_frequency: i64,
    /// Single-character drum macros, from `$c{...}`.
    rythm_macros: rythm::Macros,
    /// Nested `Rythm{...}` depth, retained while string macros are expanded.
    rythm_depth: usize,
    /// User-defined Japanese macros, from `~{name}={mml}`.
    sutoton_macros: crate::lexer::sutoton::UserMacros,
}

impl Default for Compiler<'_> {
    fn default() -> Self {
        Self::new()
    }
}

impl<'a> Compiler<'a> {
    pub fn new() -> Self {
        Self {
            includes: &NoIncludes,
            timebase: DEFAULT_TIMEBASE,
            tempo: 120,
            tracks: BTreeMap::from([(0, TrackState::new(0, DEFAULT_TIMEBASE, false))]),
            // The Pascal compiler keeps global setup events in MTrk 0. An
            // explicit `Track 1` must therefore start a separate track.
            current: 0,
            warnings: Vec::new(),
            errors: Vec::new(),
            recover_errors: false,
            stop_requested: false,
            depth: 0,
            variables: builtin_variables(),
            functions: BTreeMap::new(),
            key_flags: [0; 7],
            key_shift: 0,
            use_key_shift: true,
            x68_mode: false,
            step_mode: false,
            voice_no_shift: 0,
            octave_range_shift: 0,
            time_keys: Vec::new(),
            time_keys2: Vec::new(),
            time_key_flags: Vec::new(),
            bend_ranges: [2; 16],
            q_max: 100,
            v_max: 127,
            q_add: 10,
            q2_add: 8,
            v_add: 8,
            measure_shift: 0,
            controller_shift: 1,
            allow_multi_line: true,
            meta_text_eol: 0,
            time_signature: (4, 4),
            messages: Vec::new(),
            exiting: false,
            rng: Rng::default(),
            event_count: 0,
            buffered_slur_events: 0,
            play_from: PlayFromSpec::default(),
            stretch_rate: 1.0,
            solo_or_mute: 0,
            selected_tracks: BTreeSet::new(),
            chord_start: None,
            cc_frequency: advance_spec::DEFAULT_FREQUENCY,
            rythm_macros: rythm::Macros::new(),
            rythm_depth: 0,
            sutoton_macros: crate::lexer::sutoton::UserMacros::new(),
        }
    }

    /// Supply the resolver used for `#Include`.
    pub fn with_includes(mut self, resolver: &'a dyn IncludeResolver) -> Self {
        self.includes = resolver;
        self
    }

    /// Continue after recoverable source errors and return a partial song.
    pub fn with_error_recovery(mut self) -> Self {
        self.recover_errors = true;
        self
    }

    pub fn warnings(&self) -> &[Warning] {
        &self.warnings
    }

    fn track(&mut self) -> &mut TrackState {
        let timebase = self.timebase;
        let step_mode = self.step_mode;
        let no = self.current;
        self.tracks
            .entry(no)
            .or_insert_with(|| TrackState::new(no, timebase, step_mode))
    }

    /// The standard definition file, loaded before the song itself.
    ///
    /// It defines the GM instrument names (`@(GrandPiano)`), the reset macros
    /// and much else, so songs use them without asking. The Pascal build does
    /// the same in `TMml2Smf.Execute`, and likewise carries on with a hint
    /// when the file is missing rather than failing.
    fn load_standard_includes(&mut self) {
        let Some(bytes) = self.includes.resolve(STANDARD_INCLUDE) else {
            self.warnings.push(Warning::new(
                0,
                format!("{STANDARD_INCLUDE} を読み飛ばしました。"),
            ));
            return;
        };
        let (text, _) = crate::encoding::decode_auto(&bytes);
        let normalized = self.preprocess(&text);
        if let Err(error) = self.run_fragment(&normalized, 1) {
            self.warnings.push(Warning::new(
                0,
                format!("標準ファイル\"{STANDARD_INCLUDE}\"のコンパイルに失敗: {error}"),
            ));
        }
    }

    /// Compile MML source into a [`Song`].
    pub fn compile(mut self, src: &str) -> Result<CompileResult> {
        self.load_standard_includes();
        let normalized = self.preprocess(src);
        let mut cur = Cursor::new(&normalized);
        self.run(&mut cur)?;
        if self
            .tracks
            .values()
            .any(|track| !track.slur_notes.is_empty())
        {
            let error = MmlError::new(cur.line(), "&の後に音符がありません");
            if !self.recover_errors {
                return Err(error);
            }
            if !self.errors.contains(&error) {
                self.errors.push(error);
            }
            for track in self.tracks.values_mut() {
                track.slur_notes.clear();
            }
            self.buffered_slur_events = 0;
        }
        self.apply_play_from()?;

        let mut song = Song::new(self.timebase as u16);
        for (track_no, state) in self.tracks {
            // A track PlayFrom trimmed to nothing is still written out (an
            // empty MTrk), the same way the Pascal build does: it was used,
            // even though nothing survived the cut.
            if !state.used {
                continue;
            }
            // The Pascal writer always preserves track 0. For the musical
            // tracks, Solo keeps the listed tracks and Mute drops them.
            if track_no != 0 {
                let selected = self.selected_tracks.contains(&track_no);
                if (self.solo_or_mute > 0 && !selected) || (self.solo_or_mute < 0 && selected) {
                    continue;
                }
            }
            song.tracks.push(Track {
                events: state.events,
                end_time: state.time,
            });
        }
        Ok(CompileResult {
            song,
            errors: self.errors,
            warnings: self.warnings,
            messages: self.messages,
        })
    }

    /// Apply `PlayFrom`/`PlayTo` as a post-process over every track's
    /// recorded events, matching `TSmfTrack.ExecutePlayFrom` in
    /// `smf_types.pas`.
    ///
    /// This runs once, after compiling, exactly as the Pascal build applies
    /// it at save time rather than as the source is read — so where in the
    /// song `PlayFrom` is written makes no difference to the result.
    ///
    fn apply_play_from(&mut self) -> Result<()> {
        let from_pos = self.play_from.from_pos;
        let to_pos = self.play_from.to_pos;
        // The Pascal build only runs any of this when one bound is set.
        if from_pos <= 0 && to_pos <= 0 {
            return Ok(());
        }
        let wait_time = self.play_from.wait_time;
        let sysex = self.play_from.sysex;
        let restore_rpn_nrpn = self.play_from.rpn_nrpn;

        // Apply PlayTo before calculating the final event budget.  The
        // following reconstruction can add events, so the parser's original
        // event count is no longer sufficient.
        for track in self.tracks.values_mut() {
            track.events.sort_by_key(|e| e.time);

            // PlayTo: drop the trailing run at or after `to_pos`.
            if to_pos > 0 {
                while matches!(track.events.last(), Some(e) if e.time >= to_pos) {
                    track.events.pop();
                }
            }
        }

        let mut final_event_count = 0usize;
        for track in self.tracks.values_mut() {
            // Reconstruct the state in effect just before `from_pos`, so
            // notes that survive the cut still sound with the right voice,
            // controller values and tempo.
            let mut cc = [None; 128];
            let mut pitch_bend: i64 = 0;
            let mut program: Option<u8> = None;
            let mut tempo: Option<u32> = None;
            let mut channel = track.channel;
            let mut rpn_selection: Option<(bool, u8, u8)> = None;
            // Pascal keeps RPN and NRPN in separate insertion-ordered lists.
            // A later Data Entry replaces the value for the same address and
            // channel without moving its position in that list.
            let mut restored_rpn: Vec<(u8, u8, u8, u8)> = Vec::new();
            let mut restored_nrpn: Vec<(u8, u8, u8, u8)> = Vec::new();
            for event in &track.events {
                if event.time >= from_pos {
                    break;
                }
                match event.data.first().map(|b| b & 0xf0) {
                    Some(0xb0) => {
                        if let (Some(&no), Some(&value)) = (event.data.get(1), event.data.get(2)) {
                            cc[no as usize] = Some(value);
                            channel = event.data[0] & 0x0f;
                            if restore_rpn_nrpn {
                                match no {
                                    101 => {
                                        let lsb = rpn_selection
                                            .filter(|(rpn, _, _)| *rpn)
                                            .map(|(_, _, lsb)| lsb)
                                            .unwrap_or(0);
                                        rpn_selection = Some((true, value, lsb));
                                        cc[no as usize] = None;
                                    }
                                    100 => {
                                        let msb = rpn_selection
                                            .filter(|(rpn, _, _)| *rpn)
                                            .map(|(_, msb, _)| msb)
                                            .unwrap_or(0);
                                        rpn_selection = Some((true, msb, value));
                                        cc[no as usize] = None;
                                    }
                                    99 => {
                                        let lsb = rpn_selection
                                            .filter(|(rpn, _, _)| !*rpn)
                                            .map(|(_, _, lsb)| lsb)
                                            .unwrap_or(0);
                                        rpn_selection = Some((false, value, lsb));
                                        cc[no as usize] = None;
                                    }
                                    98 => {
                                        let msb = rpn_selection
                                            .filter(|(rpn, _, _)| !*rpn)
                                            .map(|(_, msb, _)| msb)
                                            .unwrap_or(0);
                                        rpn_selection = Some((false, msb, value));
                                        cc[no as usize] = None;
                                    }
                                    6 => {
                                        if let Some((is_rpn, msb, lsb)) = rpn_selection {
                                            let parameter = (channel, msb, lsb, value);
                                            if is_rpn {
                                                Self::upsert_play_from_parameter(
                                                    &mut restored_rpn,
                                                    parameter,
                                                );
                                            } else {
                                                Self::upsert_play_from_parameter(
                                                    &mut restored_nrpn,
                                                    parameter,
                                                );
                                            }
                                            cc[no as usize] = None;
                                        }
                                    }
                                    _ => {}
                                }
                            }
                        }
                    }
                    Some(0xe0) => {
                        if let (Some(&lsb), Some(&msb)) = (event.data.get(1), event.data.get(2)) {
                            pitch_bend = (((msb as i64) << 7) | lsb as i64) - 8192;
                            channel = event.data[0] & 0x0f;
                        }
                    }
                    Some(0xc0) => {
                        if let Some(&prog) = event.data.get(1) {
                            program = Some(prog);
                            channel = event.data[0] & 0x0f;
                        }
                    }
                    _ => {}
                }
                if event.data.first() == Some(&0xff)
                    && event.data.get(1) == Some(&0x51)
                    && event.data.len() >= 6
                {
                    let usec = ((event.data[3] as u32) << 16)
                        | ((event.data[4] as u32) << 8)
                        | event.data[5] as u32;
                    tempo = Some(usec);
                }
            }

            let retained_events = track
                .events
                .iter()
                .filter(|event| {
                    event.time >= from_pos
                        || (event.data.first() == Some(&0xf0) && sysex)
                        || (event.data.first() == Some(&0xff) && event.data.get(1) != Some(&0x51))
                })
                .count();
            let reconstructed_events = if from_pos > 0 {
                cc.iter().flatten().count()
                    + usize::from(pitch_bend != 0)
                    + (restored_rpn.len() + restored_nrpn.len()).saturating_mul(3)
                    + usize::from(program.is_some())
                    + usize::from(tempo.is_some())
            } else {
                0
            };
            let track_final_count = retained_events + reconstructed_events;
            final_event_count = final_event_count.saturating_add(track_final_count);
            Self::ensure_play_from_event_capacity(final_event_count)?;

            // Discard what falls before the cut (keeping non-tempo meta at
            // time 0, and SysEx at an incrementing slot if `.SysEx(1)` asked
            // for it), and shift the rest back by the cut point.
            let mut pre_effect = 0i64;
            let mut rebuilt = Vec::with_capacity(track_final_count);
            for event in track.events.drain(..) {
                if event.time < from_pos {
                    let status = event.data.first().copied();
                    if status == Some(0xf0) && sysex {
                        rebuilt.push(event.at_time(pre_effect));
                        pre_effect += 1;
                    } else if status == Some(0xff) && event.data.get(1) != Some(&0x51) {
                        rebuilt.push(event.at_time(0));
                    }
                    // Anything else before the cut is dropped: ordinary
                    // events, and the tempo meta (reconstructed below).
                } else {
                    let shifted = (event.time - from_pos + wait_time).max(0);
                    rebuilt.push(event.at_time(shifted));
                }
            }

            // Write the reconstructed state back in, right at the start.
            if from_pos > 0 {
                for (no, value) in cc.iter().enumerate() {
                    if let Some(value) = value {
                        rebuilt.push(Event::control_change(pre_effect, channel, no as u8, *value));
                        pre_effect += 1;
                    }
                }
                if pitch_bend != 0 {
                    let raw = (pitch_bend + 8192).clamp(0, 16383);
                    rebuilt.push(Event::new(
                        pre_effect,
                        vec![
                            0xe0 | channel,
                            (raw & 0x7f) as u8,
                            ((raw >> 7) & 0x7f) as u8,
                        ],
                    ));
                    pre_effect += 1;
                }
                for (is_rpn, parameters) in [(true, restored_rpn), (false, restored_nrpn)] {
                    let (msb_cc, lsb_cc) = if is_rpn { (101, 100) } else { (99, 98) };
                    for (parameter_channel, msb, lsb, data) in parameters {
                        rebuilt.push(Event::control_change(
                            pre_effect,
                            parameter_channel,
                            msb_cc,
                            msb,
                        ));
                        pre_effect += 1;
                        rebuilt.push(Event::control_change(
                            pre_effect,
                            parameter_channel,
                            lsb_cc,
                            lsb,
                        ));
                        pre_effect += 1;
                        rebuilt.push(Event::control_change(
                            pre_effect,
                            parameter_channel,
                            6,
                            data,
                        ));
                        pre_effect += 1;
                    }
                }
                if let Some(prog) = program {
                    rebuilt.push(Event::program_change(pre_effect, channel, prog));
                }
                if let Some(usec) = tempo {
                    rebuilt.push(Event::tempo(0, usec));
                }
            }

            // The Pascal build places End-of-Track flush against whatever
            // event survives last, in both branches — LastTime is only
            // explicitly set in the PlayTo branch, and even there it ends up
            // smaller than the last surviving (shifted) event in every case
            // observed, which the SMF writer's own delta clamp already
            // turns into "immediately after". Using the true maximum here
            // reproduces that without depending on the clamp by luck.
            track.time = rebuilt.iter().map(|e| e.time).max().unwrap_or(0);
            track.events = rebuilt;
        }
        self.event_count = final_event_count;
        Ok(())
    }

    fn upsert_play_from_parameter(
        parameters: &mut Vec<(u8, u8, u8, u8)>,
        (channel, msb, lsb, data): (u8, u8, u8, u8),
    ) {
        if let Some((_, _, _, existing_data)) =
            parameters
                .iter_mut()
                .find(|(entry_channel, entry_msb, entry_lsb, _)| {
                    (*entry_channel, *entry_msb, *entry_lsb) == (channel, msb, lsb)
                })
        {
            *existing_data = data;
        } else {
            parameters.push((channel, msb, lsb, data));
        }
    }

    /// `PlayFrom` replaces the event set after parsing, so enforce the same
    /// global limit before allocating its rebuilt event vectors.
    fn ensure_play_from_event_capacity(final_event_count: usize) -> Result<()> {
        if final_event_count > MAX_EVENTS {
            return Err(MmlError::new(
                0,
                format!("生成イベント数が上限({MAX_EVENTS})を超えました"),
            ));
        }
        Ok(())
    }

    /// Record an event on the current track, against the compile's budget.
    fn push_event(&mut self, event: Event) -> Result<()> {
        self.push_event_to_track(self.current, event)
    }

    /// Record an event on a specific track, against the compile's budget.
    ///
    /// Global meta events such as tempo are always kept in MTrk 0 by the
    /// Pascal implementation, even when a musical track is selected.
    fn push_event_to_track(&mut self, track_no: i64, event: Event) -> Result<()> {
        if self.event_count >= MAX_EVENTS.saturating_sub(self.buffered_slur_events) {
            self.stop_requested = true;
            let error = MmlError::new(0, format!("生成イベント数が上限({MAX_EVENTS})を超えました"));
            // Some legacy event helpers cannot propagate a Result. Preserve
            // the diagnostic here as well as returning it to callers that can.
            if self.recover_errors && !self.errors.contains(&error) {
                self.errors.push(error.clone());
            }
            return Err(error);
        }
        self.event_count += 1;
        let timebase = self.timebase;
        let step_mode = self.step_mode;
        let track = self
            .tracks
            .entry(track_no)
            .or_insert_with(|| TrackState::new(track_no, timebase, step_mode));
        track.used = true;
        track.events.push(event);
        Ok(())
    }

    /// Refuse a bulk event operation before it starts allocating or looping.
    fn ensure_event_capacity(&mut self, additional: usize, line: usize) -> Result<()> {
        let available = MAX_EVENTS
            .saturating_sub(self.event_count)
            .saturating_sub(self.buffered_slur_events);
        if additional > available {
            self.stop_requested = true;
            let error = MmlError::new(
                line,
                format!("生成イベント数が上限({MAX_EVENTS})を超えました"),
            );
            if self.recover_errors && !self.errors.contains(&error) {
                self.errors.push(error.clone());
            }
            return Err(error);
        }
        Ok(())
    }

    /// Reserve the two MIDI event slots an unfinished Slur note may emit.
    fn reserve_slur_note(&mut self, line: usize) -> Result<()> {
        self.ensure_event_capacity(2, line)?;
        self.buffered_slur_events += 2;
        Ok(())
    }

    fn clear_current_slur_notes(&mut self) {
        let released = self.track().slur_notes.len().saturating_mul(2);
        self.track().slur_notes.clear();
        self.buffered_slur_events = self.buffered_slur_events.saturating_sub(released);
    }

    /// Add to a time value, refusing a result the SMF format cannot express.
    fn checked_time(&self, base: i64, delta: i64, line: usize) -> Result<i64> {
        let total = base
            .checked_add(delta)
            .ok_or_else(|| MmlError::new(line, "時間の計算があふれました"))?;
        if !(-MAX_TIME..=MAX_TIME).contains(&total) {
            return Err(MmlError::new(
                line,
                format!("時間が上限({MAX_TIME})を超えました: {total}"),
            ));
        }
        // Not clamped to 0: a rest with a negative length (`r-2.`) rewinds the
        // pointer, and the Pascal build lets it go negative internally — only
        // the SMF writer clamps, one event at a time, which is what makes a
        // later positive-length event land at the right position relative to
        // the rewound one rather than at an arbitrary reset point.
        Ok(total)
    }

    /// Turn source into plain ASCII MML: symbols first, then the Japanese
    /// notation layer.
    ///
    /// That order is the Pascal build's (`PreCompile` calls `ConvToHalfSign`
    /// then `SutotonToMml`) and it matters: `~` arrives as a full-width tilde,
    /// and only becomes the macro-definition marker once symbols are folded.
    fn preprocess(&mut self, src: &str) -> String {
        let normalized = crate::lexer::zenkaku::normalize(src);
        crate::lexer::sutoton::to_mml_with(&normalized, &mut self.sutoton_macros)
    }

    /// Run a cursor to exhaustion.
    fn run(&mut self, cur: &mut Cursor) -> Result<()> {
        loop {
            cur.skip_trivia();
            if cur.is_eof() || self.exiting || self.stop_requested {
                break;
            }
            let start = cur.position();
            if let Err(error) = self.step(cur) {
                if !self.recover_errors {
                    return Err(error);
                }
                // Loops and reused fragments can encounter the same defect
                // many times. Report each distinct diagnostic once so a
                // partial compile remains useful instead of flooding callers.
                if !self.errors.contains(&error) {
                    self.errors.push(error);
                }
                if self.errors.len() >= MAX_ERRORS {
                    self.errors.push(MmlError::new(
                        cur.line(),
                        format!("エラー数が上限({MAX_ERRORS})に達したため解析を打ち切りました"),
                    ));
                    self.stop_requested = true;
                }
                if self.stop_requested {
                    break;
                }
                Self::recover_cursor(cur, start);
            }
        }
        Ok(())
    }

    /// Move past the construct that caused an error. Most command parsers
    /// have already consumed their name and bad argument, so in that case we
    /// retain the current position and let the next token run. A completely
    /// unknown opening delimiter is skipped as a unit to avoid cascades.
    fn recover_cursor(cur: &mut Cursor, start: usize) {
        if cur.position() == start {
            match cur.peek() {
                Some('(') => {
                    cur.advance();
                    let _ = cur.read_balanced('(', ')');
                }
                Some('{') => {
                    cur.advance();
                    let _ = cur.read_balanced('{', '}');
                }
                Some('[') => {
                    cur.advance();
                    let _ = cur.read_balanced('[', ']');
                }
                Some(_) => {
                    cur.advance();
                }
                None => {}
            }
        } else if matches!(cur.peek(), Some(')') | Some(']') | Some('}') | Some(',')) {
            cur.advance();
        }
    }

    /// Compile a fragment of source (a loop body) as if it appeared inline.
    ///
    /// The depth limit is deliberate: WASM has a much smaller stack than
    /// native, so deeply nested loops must fail with an error rather than
    /// overflow it. The Pascal version caps nesting at 128 the same way.
    fn run_fragment(&mut self, src: &str, start_line: usize) -> Result<()> {
        if self.depth >= MAX_NEST {
            return Err(MmlError::new(
                start_line,
                format!("ネストが深すぎます(最大{MAX_NEST})"),
            ));
        }
        self.depth += 1;
        let mut cur = Cursor::with_line(src, start_line);
        let result = self.run(&mut cur);
        self.depth -= 1;
        result
    }

    fn step(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let Some(ch) = cur.peek() else { return Ok(()) };

        // A user-defined function wins over the built-in meaning of its name,
        // so `Function f(){...}` makes a later `f` a call, not the note F.
        // The Pascal build behaves the same way: definitions overwrite the
        // command table.
        if ch.is_ascii_alphabetic() || ch == '_' || ch == '#' {
            let mut probe = cur.clone();
            if let Some(word) = probe.read_word() {
                if self.functions.contains_key(&word) {
                    *cur = probe;
                    let args = self.read_call_args(cur, &word)?;
                    self.call_function(&word, args, line)?;
                    return Ok(());
                }
            }
        }

        match ch {
            'a'..='g' => self.note(cur),
            'r' => {
                cur.advance();
                self.rest(cur)
            }
            'n' => {
                cur.advance();
                self.note_number(cur)
            }
            '^' => {
                cur.advance();
                self.tie(cur)
            }
            'o' => {
                cur.advance();
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Octave)? {
                    return Ok(handled);
                }
                let current = self.track().octave;
                let value = self.expect_note_info_value(cur, "o", current, 1)?;
                self.track().octave = value;
                self.reset_note_modifier(OnNoteTarget::Octave);
                Ok(())
            }
            'l' => {
                cur.advance();
                let modifier_in_steps = cur.peek() == Some('%') && cur.peek_at(1) == Some('.');
                if modifier_in_steps {
                    cur.advance();
                }
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Length)? {
                    return Ok(handled);
                }
                let in_steps = cur.peek() == Some('%');
                if in_steps {
                    cur.advance();
                }
                let step_mode = if in_steps {
                    !self.step_mode
                } else {
                    self.step_mode
                };
                let value = self
                    .read_length_in_mode(cur, step_mode)
                    .ok_or_else(|| MmlError::new(line, "lコマンドには音長を指定してください"))?;
                let track = self.track();
                track.length = value;
                track.length_in_steps = in_steps;
                track.system_step_mode = step_mode;
                self.reset_note_modifier(OnNoteTarget::Length);
                Ok(())
            }
            'q' => {
                cur.advance();
                let modifier_in_steps = cur.peek() == Some('%') && cur.peek_at(1) == Some('.');
                if modifier_in_steps {
                    cur.advance();
                }
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Gate)? {
                    if let Some((_, modifier)) = self
                        .track()
                        .note_modifiers
                        .iter_mut()
                        .find(|(target, _)| *target == OnNoteTarget::Gate)
                    {
                        modifier.in_steps = modifier_in_steps;
                    }
                    return Ok(handled);
                }
                // `q%n` gives the gate in ticks; a later plain `q` goes back
                // to reading it as a percentage.
                let in_steps = cur.peek() == Some('%');
                if in_steps {
                    cur.advance();
                }
                let current = self.track().gate_percent;
                let increment = if in_steps { self.q2_add } else { self.q_add };
                let value = self.expect_note_info_value(cur, "q", current, increment)?;
                let track = self.track();
                track.gate_in_steps = in_steps;
                track.gate_percent = value;
                self.reset_note_modifier(OnNoteTarget::Gate);
                Ok(())
            }
            'v' => {
                cur.advance();
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Velocity)? {
                    return Ok(handled);
                }
                let current = self.track().velocity;
                let value = self.expect_note_info_value(cur, "v", current, self.v_add)?;
                self.track().velocity = value;
                self.reset_note_modifier(OnNoteTarget::Velocity);
                Ok(())
            }
            't' => {
                cur.advance();
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Timing)? {
                    return Ok(handled);
                }
                let current = self.track().timing;
                let value = self.expect_note_info_value(cur, "t", current, 1)?;
                self.track().timing = value;
                self.reset_note_modifier(OnNoteTarget::Timing);
                Ok(())
            }
            '@' => {
                cur.advance();
                self.voice(cur)
            }
            'y' => {
                cur.advance();
                self.control_change_direct(cur)
            }
            'p' => {
                cur.advance();
                if cur.eat('%') {
                    if let Some(handled) = self.modifier(cur, OnNoteTarget::PitchBend)? {
                        return Ok(handled);
                    }
                    let value = self.expect_int_arg(cur, "p%")?;
                    self.write_pitch_bend(value);
                    return Ok(());
                }
                if let Some(handled) = self.modifier(cur, OnNoteTarget::PitchBend)? {
                    return Ok(handled);
                }
                self.simple_pitch_bend(cur)
            }
            '\'' => {
                cur.advance();
                self.chord(cur)
            }
            '[' => {
                cur.advance();
                self.repeat(cur)
            }
            '$' => {
                cur.advance();
                self.define_rythm_macro(cur)
            }
            // `` ` `` and `"` shift the octave for the next note only.
            '`' => {
                cur.advance();
                self.track().octave_once += 1;
                Ok(())
            }
            '"' => {
                cur.advance();
                self.track().octave_once -= 1;
                Ok(())
            }
            '>' => {
                cur.advance();
                self.track().octave += if self.x68_mode { -1 } else { 1 };
                Ok(())
            }
            '<' => {
                cur.advance();
                self.track().octave += if self.x68_mode { 1 } else { -1 };
                Ok(())
            }
            c if c.is_ascii_alphabetic() || c == '_' || c == '#' => self.word_command(cur),
            other => Err(MmlError::new(
                line,
                format!("解釈できない文字です: '{other}'"),
            )),
        }
    }

    /// A named command: `Tempo=120`, `TR=2`, `TrackName={"..."}` and friends.
    fn word_command(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let word = cur
            .read_word()
            .ok_or_else(|| MmlError::new(line, "コマンド名を読み取れませんでした"))?;

        // A user definition wins over the built-in meaning of its name, the
        // same way it does for note letters: `Str S={"c"}` makes a later `S`
        // the variable, not the `Sub` alias.
        if self.functions.contains_key(&word) {
            let args = self.read_call_args(cur, &word)?;
            self.call_function(&word, args, line)?;
            return Ok(());
        }
        if !word.starts_with('#') && matches!(self.variables.get(&word), Some(Value::Str(_))) {
            let name = word.clone();
            return self.string_variable(cur, &name, line);
        }
        if self.variables.contains_key(&word) {
            let mut probe = cur.clone();
            probe.skip_spaces();
            let is_assignment = probe.peek() == Some('=')
                || matches!(probe.peek(), Some('+') | Some('-'))
                    && probe.peek() == probe.peek_at(1)
                || matches!(self.variables.get(&word), Some(Value::Array(_)))
                    && probe.peek() == Some('(');
            if is_assignment {
                return self.assign(cur, &word);
            }
        }

        match word.as_str() {
            "Tempo" | "TEMPO" => {
                let bpm = self.expect_int_arg(cur, &word)?;
                let usec = Self::tempo_usec(bpm, line)?;
                self.tempo = bpm;
                let time = self.track().time;
                self.push_event_to_track(0, Event::tempo(time, usec))
            }
            "TempoChange" => self.tempo_change(cur, line),
            "Track" | "TRACK" | "TR" | "NowTrack" => {
                let no = self.expect_int_arg(cur, &word)?;
                self.current = no;
                let timebase = self.timebase;
                let step_mode = self.step_mode;
                self.tracks
                    .entry(no)
                    .or_insert_with(|| TrackState::new(no, timebase, step_mode));
                Ok(())
            }
            "Channel" | "CHANNEL" | "CH" => {
                let no = self.expect_int_arg(cur, &word)?;
                if !(1..=16).contains(&no) {
                    return Err(MmlError::new(
                        line,
                        format!("チャンネルは1〜16の範囲で指定してください: {no}"),
                    ));
                }
                self.track().channel = (no - 1) as u8;
                Ok(())
            }
            "TimeBase" | "TIMEBASE" | "Timebase" => {
                let value = self.expect_int_arg(cur, &word)?;
                self.set_timebase_checked(value, line)?;
                Ok(())
            }
            "System" | "SYSTEM" => {
                cur.skip_spaces();
                if !cur.eat('.') {
                    return Err(MmlError::new(line, "System の後には . が必要です"));
                }
                let sub = cur
                    .read_word()
                    .ok_or_else(|| MmlError::new(line, "System.の後にコマンド名が必要です"))?;
                self.system_command(cur, &sub, line)
            }
            "Include" | "INCLUDE" => self.include(cur),
            "Div" | "DIV" => self.div(cur),
            "Play" | "PLAY" => self.play(cur),
            "Stretch" => self.stretch(cur),
            "PlayFrom" => self.play_from_command(cur, line),
            "PlayTo" => self.play_to_command(cur, line),
            "TrackMute" => {
                let value = self.expect_int_arg(cur, &word)?;
                self.track().muted = value != 0;
                Ok(())
            }
            "PrintTime" => self.print_time(cur, line),
            "PrintTrack" => self.print_track(cur, line),
            "Solo" | "Mute" => {
                let tracks = self.read_args(cur, usize::MAX)?;
                if tracks.is_empty() {
                    return Err(MmlError::new(
                        line,
                        format!("{word}にはトラック番号を指定してください"),
                    ));
                }
                self.solo_or_mute = if word == "Solo" { 1 } else { -1 };
                self.selected_tracks.extend(tracks);
                Ok(())
            }
            "DeleteCC" => {
                let no = self.expect_int_arg(cur, &word)?;
                if no < 0 {
                    return Err(MmlError::new(
                        line,
                        "DeleteCCには0以上の番号を指定してください",
                    ));
                }
                // Plain CC/bend writes are stored ControllerShift ticks ahead
                // of the cursor. Advance specifications already account for
                // their own leading event, which Pascal preserves here.
                let has_modifier = self.track().cc_modifiers.iter().any(|item| item.no == no);
                let time = self.track().time
                    - if has_modifier {
                        0
                    } else {
                        self.controller_shift
                    };
                self.delete_cc_after(no, time);
                Ok(())
            }
            "CCMute" => {
                let value = self.expect_int_arg(cur, &word)?;
                self.track().cc_muted = value != 0;
                Ok(())
            }
            "CCNoMute" => {
                let args = self.read_args(cur, 2)?;
                if args.len() < 2 || !(0..=127).contains(&args[0]) {
                    return Err(MmlError::new(
                        line,
                        "CCNoMuteにはCC番号(0〜127)とon/offを指定してください",
                    ));
                }
                self.track().cc_no_mute[args[0] as usize] = args[1] != 0;
                Ok(())
            }
            "Cresc" | "CRESC" => self.cresc(cur, 40, 127, line),
            "Decresc" | "DECRESC" => self.cresc(cur, 127, 40, line),
            "Rythm" | "RYTHM" | "Rhythm" | "RHYTHM" => self.rythm(cur),
            "Sub" | "SUB" | "S" => self.sub(cur),
            "TimeSignature" => self.time_signature(cur),
            "KeyFlag" => self.key_flag(cur),
            "ArgOrder" => self.arg_order(cur, line),
            "AllowMultiLine" => {
                self.allow_multi_line = self.expect_int_arg(cur, &word)? != 0;
                Ok(())
            }
            "MetaTextEOL" => {
                self.meta_text_eol = self.expect_int_arg(cur, &word)?;
                Ok(())
            }
            "Keyshift" | "KeyShift" => {
                self.key_shift = self.expect_int_arg(cur, &word)?;
                Ok(())
            }
            "Key" | "KEY" => {
                self.key_shift = self.expect_int_arg(cur, &word)?;
                Ok(())
            }
            "TimeKey" => self.time_key(cur, false, line),
            "TimeKey2" => self.time_key(cur, true, line),
            "TimeKeyFlag" => self.time_key_flag(cur, line),
            "TrackKey" => {
                let value = self.expect_int_arg(cur, &word)?;
                self.track().key = value;
                Ok(())
            }
            "UseKeyShift" => {
                self.use_key_shift = self.expect_int_arg(cur, &word)? != 0;
                Ok(())
            }
            "NoteOn" => self.direct_note(cur, true, line),
            "NoteOff" => self.direct_note(cur, false, line),
            "KeyPressure" | "KP" => self.key_pressure(cur, line),
            "ChannelPrefix" => self.channel_prefix(cur, line),
            "Port" | "PORT" => self.port(cur, line),
            "Time" | "TIME" => self.time_command(cur),
            "TrackSync" => {
                // Align every track to the latest time pointer.
                let latest = self.tracks.values().map(|t| t.time).max().unwrap_or(0);
                for state in self.tracks.values_mut() {
                    state.time = latest;
                    state.last_note = None;
                }
                Ok(())
            }
            "ResetGM" => self.reset(cur, &[0x7e, 0x7f, 0x09, 0x01]),
            "ResetGS" => self.reset(cur, &[0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7f, 0x00, 0x41]),
            "ResetXG" => self.reset(cur, &[0x43, 0x10, 0x4c, 0x00, 0x00, 0x7e, 0x00]),
            "Int" | "INT" | "Integer" | "INTEGER" => self.declare(cur, VarKind::Int),
            "Str" | "STR" => self.declare(cur, VarKind::Str),
            "Array" | "ARRAY" => self.declare(cur, VarKind::Array),
            "Print" | "PRINT" => {
                let value = self.read_value(cur)?;
                self.messages.push(value.as_str());
                Ok(())
            }
            "Function" | "FUNCTION" => self.define_function(cur),
            "Result" | "RESULT" => {
                let value = self.read_value(cur)?;
                self.variables.insert(RESULT_VAR.to_string(), value);
                Ok(())
            }
            "If" | "IF" => self.if_statement(cur),
            "While" | "WHILE" => self.while_statement(cur),
            "For" | "FOR" => self.for_statement(cur),
            "Exit" | "EXIT" => {
                self.exiting = true;
                Ok(())
            }
            "End" => {
                self.stop_requested = true;
                Ok(())
            }
            "MsgBox" => self.msg_box(cur, line),
            "Switch" | "SWITCH" => self.switch_statement(cur, line),
            "SysEx" | "SYSEX" => self.sysex(cur),
            "DirectSMF" => self.direct_smf(cur),
            "Voice" => self.voice(cur),
            "Slur" => {
                let args = self.read_args(cur, 3)?;
                let Some(&mode) = args.first() else {
                    return Err(MmlError::new(line, "Slurにはtypeを指定してください"));
                };
                if !(0..=3).contains(&mode) {
                    return Err(MmlError::new(line, "Slurのtypeは0〜3で指定してください"));
                }
                if args.get(1) == Some(&i64::MIN) {
                    return Err(MmlError::new(line, "Slurのvalueが範囲外です"));
                }
                let track = self.track();
                track.slur_mode = mode;
                if let Some(&value) = args.get(1) {
                    track.slur_value = value;
                }
                if let Some(&range) = args.get(2) {
                    if !(1..=12).contains(&range) {
                        return Err(MmlError::new(line, "Slurのrangeは1〜12で指定してください"));
                    }
                    let channel = track.channel as usize;
                    self.bend_ranges[channel] = range;
                }
                Ok(())
            }
            "BR" => {
                let value = self.expect_int_arg(cur, "BR")?;
                let channel = self.track().channel as usize;
                self.bend_ranges[channel] = value;
                self.write_cc(101, 0);
                self.write_cc(100, 0);
                self.write_cc(6, value);
                Ok(())
            }
            "PitchBend" => {
                if let Some(handled) = self.modifier(cur, OnNoteTarget::PitchBend)? {
                    return Ok(handled);
                }
                self.pitch_bend(cur)
            }
            "RPN" | "NRPN" => {
                let is_rpn = word == "RPN";
                let args = self.read_args(cur, 3)?;
                if args.len() < 3 {
                    return Err(MmlError::new(
                        line,
                        format!("{word}には3つの値(msb,lsb,data)を指定してください"),
                    ));
                }
                let (msb_cc, lsb_cc) = if is_rpn { (101, 100) } else { (99, 98) };
                if is_rpn && args[0] == 0 && args[1] == 0 {
                    let channel = self.track().channel as usize;
                    self.bend_ranges[channel] = args[2];
                }
                self.write_cc(msb_cc, args[0]);
                self.write_cc(lsb_cc, args[1]);
                self.write_cc(6, args[2]);
                Ok(())
            }
            _ if control_change_number(&word).is_some() => {
                let cc = control_change_number(&word).expect("checked");
                let target = OnNoteTarget::ControlChange(cc.clamp(0, 127) as u8);
                if let Some(handled) = self.modifier(cur, target)? {
                    return Ok(handled);
                }
                let value = self.expect_int_arg(cur, &word)?;
                self.write_cc(cc, value);
                Ok(())
            }
            "TrackName" => self.meta_text(cur, event::META_TRACK_NAME, line),
            "Copyright" => self.meta_text(cur, event::META_COPYRIGHT, line),
            "MetaText" | "Text" => self.meta_text(cur, event::META_TEXT, line),
            "Lyric" => self.meta_text(cur, event::META_LYRIC, line),
            "Marker" => self.meta_text(cur, event::META_MARKER, line),
            "CuePoint" => self.meta_text(cur, event::META_CUE_POINT, line),
            "InstrumentName" => self.meta_text(cur, event::META_INST_NAME, line),
            // `#name` is a string macro: it defines itself on first mention,
            // and a bare mention plays its contents.
            other if other.starts_with('#') => {
                let name = other.to_string();
                self.variables
                    .entry(name.clone())
                    .or_insert_with(|| Value::Str(String::new()));
                self.string_variable(cur, &name, line)
            }
            // A bare mention of a Str variable plays its contents too.
            other
                if matches!(self.variables.get(other), Some(Value::Str(_)))
                    && !self.functions.contains_key(other) =>
            {
                let name = other.to_string();
                self.string_variable(cur, &name, line)
            }
            // A user-defined function, called as a command: `f` or `f(1,2)`.
            other if self.functions.contains_key(other) => {
                let name = other.to_string();
                let args = self.read_call_args(cur, &name)?;
                self.call_function(&name, args, line)?;
                Ok(())
            }
            // A known variable name here is an assignment: `i=(i+1)`.
            other if self.variables.contains_key(other) => {
                let name = other.to_string();
                self.assign(cur, &name)
            }
            other => Err(MmlError::new(
                line,
                format!("\"{other}\"は未定義です。綴りを確かめてください。"),
            )),
        }
    }

    /// `Function name(Int a, Str b=\"x\"){ ... }`
    fn define_function(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_trivia();
        let name = cur
            .read_word()
            .ok_or_else(|| MmlError::new(line, "関数名を指定してください"))?;

        cur.skip_trivia();
        let params = if cur.eat('(') {
            let source = cur
                .read_balanced('(', ')')
                .ok_or_else(|| MmlError::new(line, "関数の引数宣言が閉じていません"))?;
            self.parse_params(&source, line)?
        } else {
            Vec::new()
        };

        let body = self.read_block(cur, line)?;
        self.functions
            .insert(name, FunctionDef { params, body, line });
        Ok(())
    }

    /// Parse `Int a, Str b=\"x\", c` into parameters.
    ///
    /// The type name is accepted and ignored: values carry their own type, so
    /// the declaration only matters for readability.
    fn parse_params(&mut self, source: &str, line: usize) -> Result<Vec<Param>> {
        let mut params = Vec::new();
        for part in source.split(',') {
            let part = part.trim();
            if part.is_empty() {
                continue;
            }
            let mut cur = Cursor::with_line(part, line);
            let mut name = cur
                .read_word()
                .ok_or_else(|| MmlError::new(line, format!("引数宣言を読み取れません: {part}")))?;
            let mut kind = VarKind::Int;

            cur.skip_spaces();
            // "Int x" — the first word was the type, so the next is the name.
            if let Some(second) = cur.read_word() {
                kind = match name.as_str() {
                    "Str" | "STR" => VarKind::Str,
                    "Array" | "ARRAY" => VarKind::Array,
                    _ => VarKind::Int,
                };
                name = second;
                cur.skip_spaces();
            }

            let default = if cur.eat('=') {
                Some(expr::eval(&mut cur, self)?)
            } else {
                None
            };
            params.push(Param {
                name,
                kind,
                default,
            });
        }
        Ok(params)
    }

    /// Read the arguments of a call in statement position: `f`, `f()`, `f(1,2)`.
    fn read_call_args(&mut self, cur: &mut Cursor, name: &str) -> Result<Vec<Value>> {
        cur.skip_spaces();
        if !cur.eat('(') {
            return Ok(Vec::new());
        }
        let line = cur.line();
        let source = cur
            .read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "関数呼び出しの括弧が閉じられていません"))?;
        let params = self
            .functions
            .get(name)
            .map(|function| function.params.clone())
            .unwrap_or_default();
        if source.trim().is_empty() {
            return Ok(Vec::new());
        }
        let raw_args = if params.len() == 1 && params[0].kind == VarKind::Str {
            vec![source.as_str()]
        } else {
            split_function_args(&source)
        };
        let mut args = Vec::new();
        for (index, raw) in raw_args.into_iter().enumerate() {
            let raw = raw.trim();
            if raw.is_empty() {
                args.push(Value::Int(0));
                continue;
            }
            if matches!(
                params.get(index).map(|param| param.kind),
                Some(VarKind::Str)
            ) {
                let is_string_value = raw.starts_with('{')
                    || raw.starts_with('"')
                    || raw.starts_with('(')
                    || matches!(self.variables.get(raw), Some(Value::Str(_)));
                if !is_string_value {
                    args.push(Value::Str(raw.to_string()));
                    continue;
                }
            }
            if matches!(raw.chars().next(), Some('!') | Some('%')) {
                let mut length_cur = Cursor::with_line(raw, line);
                if let Some(length) = self.read_joined_argument_length(&mut length_cur)? {
                    length_cur.skip_trivia();
                    if length_cur.is_eof() {
                        args.push(Value::Int(length));
                        continue;
                    }
                }
            }
            args.push(self.eval_source(raw, line)?);
        }
        Ok(args)
    }

    /// The built-in functions (`Random`, `SizeOf`, …).
    fn call_builtin(&mut self, name: &str, args: Vec<Value>, line: usize) -> Result<Option<Value>> {
        let int_arg = |index: usize| -> Result<i64> {
            args.get(index)
                .ok_or_else(|| {
                    MmlError::new(line, format!("{name}の{}番目の引数がありません", index + 1))
                })?
                .as_int(line)
        };

        let value = match name {
            // Random(n) is 0..n; Random(a,b) is a..b.
            "Random" => {
                let value = match args.len() {
                    0 => return Err(MmlError::new(line, "Randomには範囲を指定してください")),
                    1 => self.rng.range(0, int_arg(0)?),
                    _ => self.rng.range(int_arg(0)?, int_arg(1)?),
                };
                Value::Int(value)
            }
            "RandomSelect" => {
                if args.is_empty() {
                    return Err(MmlError::new(
                        line,
                        "RandomSelectには候補を指定してください",
                    ));
                }
                let index = self.rng.range(0, args.len() as i64 - 1) as usize;
                args[index].clone()
            }
            // `Step(n)` and `!n` are the same thing: a length in raw ticks.
            "Step" | "STEP" => Value::Int(int_arg(0)?),
            "StrToLen" => Value::Int(self.timebase * 4 / int_arg(0)?.max(1)),
            "SizeOf" => match args.first() {
                Some(Value::Array(items)) => Value::Int(items.len() as i64),
                Some(Value::Str(text)) => Value::Int(text.chars().count() as i64),
                Some(Value::Int(_)) => Value::Int(4),
                None => Value::Int(0),
            },
            "StrToNum" => {
                let value = match args.first() {
                    Some(Value::Int(value)) => *value,
                    Some(Value::Str(text)) => parse_legacy_integer(text).unwrap_or(0),
                    _ => 0,
                };
                Value::Int(value)
            }
            "HEX" => match args.first() {
                Some(Value::Array(items)) => {
                    let values = items
                        .iter()
                        .map(|item| item.as_int(line).map(format_legacy_hex))
                        .collect::<Result<Vec<_>>>()?;
                    Value::Str(values.join(", "))
                }
                _ => Value::Str(format_legacy_hex(int_arg(0)?)),
            },
            "#STR" => Value::Str(args.first().map(|v| v.as_str()).unwrap_or_default()),
            "ASC" => Value::Int(
                args.first()
                    .map(|v| v.as_str())
                    .and_then(|s| s.chars().next())
                    .map(|c| c as i64)
                    .unwrap_or(0),
            ),
            "CHR" => Value::Str(
                char::from_u32(int_arg(0)? as u32)
                    .map(String::from)
                    .unwrap_or_default(),
            ),
            "MID" => {
                let text = args.first().map(Value::as_str).unwrap_or_default();
                let index = int_arg(1)?;
                let count = int_arg(2)?;
                Value::Str(legacy_mid(&text, index, count))
            }
            "POS" | "POSX" => {
                let needle = args.first().map(Value::as_str).unwrap_or_default();
                let text = args.get(1).map(Value::as_str).unwrap_or_default();
                let start = if name == "POSX" && args.len() >= 3 {
                    int_arg(2)?
                } else {
                    1
                };
                Value::Int(string_position(&needle, &text, start))
            }
            "Replace" => {
                let text = args.first().map(Value::as_str).unwrap_or_default();
                let from = args.get(1).map(Value::as_str).unwrap_or_default();
                let to = args.get(2).map(Value::as_str).unwrap_or_default();
                let replace_all = int_arg(3)? == 1;
                let replaced = if from.is_empty() {
                    text
                } else if replace_all {
                    text.replace(&from, &to)
                } else {
                    text.replacen(&from, &to, 1)
                };
                Value::Str(replaced)
            }
            "VarType" => Value::Str(
                match args.first() {
                    Some(Value::Int(_)) => "Int",
                    Some(Value::Str(_)) => "Str",
                    Some(Value::Array(_)) => "Array",
                    None => "",
                }
                .to_string(),
            ),
            "ArraySortNum" => {
                let Some(Value::Array(items)) = args.first() else {
                    return Err(MmlError::new(
                        line,
                        "ArraySortNumには配列を指定してください",
                    ));
                };
                if items.is_empty() {
                    return Err(MmlError::new(
                        line,
                        "ArraySortNumには空でない配列を指定してください",
                    ));
                }
                let mut keyed = items
                    .iter()
                    .map(|item| item.as_int(line).map(|key| (key, item)))
                    .collect::<Result<Vec<_>>>()?;
                keyed.sort_by_key(|(key, _)| *key);
                Value::Array(keyed.into_iter().map(|(_, item)| item.clone()).collect())
            }
            "ArraySortStr" => {
                let Some(Value::Array(items)) = args.first() else {
                    return Err(MmlError::new(
                        line,
                        "ArraySortStrには配列を指定してください",
                    ));
                };
                if items.is_empty() {
                    return Err(MmlError::new(
                        line,
                        "ArraySortStrには空でない配列を指定してください",
                    ));
                }
                let mut sorted = items.clone();
                sorted.sort_by_key(Value::as_str);
                Value::Array(sorted)
            }
            "VERSION" => Value::Int(VERSION_NUMBER),
            // `NoteNo(o4c)` reads a note the way the compiler would and gives
            // back its MIDI number, without playing it.
            "NoteNo" => {
                let text = args.first().map(|v| v.as_str()).unwrap_or_default();
                Value::Int(self.note_number_of(&text, line)?)
            }
            // `MML(v)` reports what a command is currently set to.
            "MML" => {
                let name = args.first().map(|v| v.as_str()).unwrap_or_default();
                Value::Int(self.command_value(&name, line)?)
            }
            "Time" => {
                let source = args.first().map(Value::as_str).unwrap_or_default();
                Value::Int(self.time_value(&source, line)?)
            }
            "System.GetKeyFlag" => {
                Value::Array(self.key_flags.iter().copied().map(Value::Int).collect())
            }
            _ => return Err(MmlError::new(line, format!("関数\"{name}\"は未定義です"))),
        };
        Ok(Some(value))
    }

    /// The MIDI note number a fragment of MML would play, starting from the
    /// track's current octave. Used by `NoteNo(...)`.
    fn note_number_of(&mut self, text: &str, line: usize) -> Result<i64> {
        let mut octave = self.track().octave;
        let mut chars = text.chars().peekable();
        let mut class: Option<usize> = None;
        let mut accidental: i64 = 0;
        let mut suppress_key_flag = false;

        while let Some(ch) = chars.next() {
            match ch {
                'o' => {
                    let mut digits = String::new();
                    while let Some(c) = chars.peek() {
                        if c.is_ascii_digit() {
                            digits.push(*c);
                            chars.next();
                        } else {
                            break;
                        }
                    }
                    if let Ok(value) = digits.parse::<i64>() {
                        octave = value;
                    }
                }
                '>' => octave += if self.x68_mode { -1 } else { 1 },
                '<' => octave += if self.x68_mode { 1 } else { -1 },
                '+' | '#' if class.is_some() => accidental += 1,
                '-' if class.is_some() => accidental -= 1,
                '*' if class.is_some() => suppress_key_flag = true,
                'n' => {
                    let mut digits = String::new();
                    while let Some(c) = chars.peek() {
                        if c.is_ascii_digit() {
                            digits.push(*c);
                            chars.next();
                        } else {
                            break;
                        }
                    }
                    if let Ok(value) = digits.parse::<i64>() {
                        return Ok(value);
                    }
                }
                c => {
                    if let Some(index) = pitch_class_index(c) {
                        class = Some(index);
                        accidental = 0;
                        suppress_key_flag = false;
                    }
                }
            }
        }
        let note = if let Some(class) = class {
            if !suppress_key_flag {
                let time = self.track().time;
                let flags = self.active_key_flags(time);
                accidental = accidental
                    .checked_add(flags[class])
                    .ok_or_else(|| Self::note_number_overflow(line))?;
            }
            pitch_class_semitone(class)
        } else {
            0
        };
        octave
            .checked_add(self.octave_range_shift)
            .and_then(|value| value.checked_mul(12))
            .and_then(|value| value.checked_add(note))
            .and_then(|value| value.checked_add(accidental))
            .ok_or_else(|| Self::note_number_overflow(line))
    }

    /// What a command is currently set to, for `MML(...)`.
    fn command_value(&mut self, name: &str, line: usize) -> Result<i64> {
        let name = name.trim();
        if name == "p%" {
            return Ok(self.track().pitch_bend_full);
        }
        if name == "p" {
            return Ok(self.track().pitch_bend_easy);
        }
        let controller = name
            .strip_prefix('y')
            .and_then(|digits| digits.parse::<i64>().ok())
            .or_else(|| control_change_number(name));
        if let Some(controller) = controller {
            let value = self.cc_modifier_entry(controller).last_value;
            return Ok(if value == i64::MIN { 0 } else { value });
        }
        let key_shift = self.key_shift;
        let time = self.track().time;
        let time_key = self.active_time_key(false, time);
        let time_key2 = self.active_time_key(true, time);
        let channel = self.track().channel as usize;
        let bend_range = self.bend_ranges[channel];
        let track = self.track();
        Ok(match name {
            "l" => track.length,
            "v" => track.velocity,
            "o" => track.octave,
            "q" => track.gate_percent,
            "t" => track.timing,
            "@" => track.voice,
            "Key" => key_shift,
            "TimeKey" => time_key,
            "TimeKey2" => time_key2,
            "BR" => bend_range,
            "Port" => track.port,
            other => return Err(MmlError::new(line, format!("MML({other})は取得できません"))),
        })
    }

    fn active_time_key(&self, second: bool, time: i64) -> i64 {
        let rules = if second {
            &self.time_keys2
        } else {
            &self.time_keys
        };
        rules
            .iter()
            .rev()
            .find(|rule| rule.from <= time && rule.to.is_none_or(|to| time < to))
            .map(|rule| rule.key)
            .unwrap_or(0)
    }

    fn active_key_flags(&self, time: i64) -> [i64; 7] {
        self.time_key_flags
            .iter()
            .rev()
            .find(|rule| rule.from <= time && rule.to.is_none_or(|to| time < to))
            .map(|rule| rule.key_flags)
            .unwrap_or(self.key_flags)
    }

    fn current_transposition(&mut self, line: usize) -> Result<i64> {
        if !self.use_key_shift {
            return Ok(0);
        }
        let time = self.track().time;
        let track_key = self.track().key;
        self.key_shift
            .checked_add(self.active_time_key(false, time))
            .and_then(|value| value.checked_add(self.active_time_key(true, time)))
            .and_then(|value| value.checked_add(track_key))
            .ok_or_else(|| Self::note_number_overflow(line))
    }

    fn note_number_overflow(line: usize) -> MmlError {
        MmlError::new(
            line,
            "ノート番号が範囲外です(0〜127): 計算結果が整数範囲を超えました",
        )
    }

    /// Run a function body with its parameters bound.
    ///
    /// Variables are global in MML, so a call saves the names it shadows and
    /// puts them back afterwards rather than building a fresh scope — that way
    /// a function can still read and write the song's globals.
    fn call_function(
        &mut self,
        name: &str,
        args: Vec<Value>,
        line: usize,
    ) -> Result<Option<Value>> {
        let function = self
            .functions
            .get(name)
            .ok_or_else(|| MmlError::new(line, format!("関数\"{name}\"は未定義です")))?
            .clone();

        let mut shadowed: Vec<(String, Option<Value>)> = Vec::new();
        for (index, param) in function.params.iter().enumerate() {
            // An argument the caller left out falls back to the parameter's
            // default, or to 0 — the Pascal build accepts `f(1)` for a
            // two-parameter function, and Include/bend.h relies on it.
            let value = match (args.get(index), &param.default) {
                (Some(value), _) => value.clone(),
                (None, Some(default)) => default.clone(),
                (None, None) => Value::Int(0),
            };
            shadowed.push((param.name.clone(), self.variables.get(&param.name).cloned()));
            self.variables.insert(param.name.clone(), value);
        }
        let previous_result = self.variables.remove(RESULT_VAR);

        let outcome = self.run_fragment(&function.body, function.line);
        // EXIT at function scope returns from that function. Loops inside the
        // function consume their own EXIT before control reaches here.
        self.take_exit();

        // Restore what the call shadowed, whether or not the body succeeded.
        for (param_name, previous) in shadowed {
            match previous {
                Some(value) => self.variables.insert(param_name, value),
                None => self.variables.remove(&param_name),
            };
        }
        let result = self.variables.remove(RESULT_VAR);
        if let Some(previous) = previous_result {
            self.variables.insert(RESULT_VAR.to_string(), previous);
        }
        outcome?;
        Ok(result)
    }

    /// A `.modifier` after a command, such as `v.onNote(120,50)` or
    /// `P.onTime(0,127,96)` — the 先行指定 family.
    ///
    /// Returns `Some(())` when one was there and handled, `None` when the
    /// command carries an ordinary argument instead.
    fn modifier(&mut self, cur: &mut Cursor, target: OnNoteTarget) -> Result<Option<()>> {
        if cur.peek() != Some('.') {
            return Ok(None);
        }
        let line = cur.line();
        let mut probe = cur.clone();
        probe.advance();
        let Some(name) = probe.read_word() else {
            return Ok(None);
        };
        *cur = probe;

        // `.Frequency` is a song-wide setting rather than a per-command one.
        if name == "Frequency" {
            let value = self.expect_int_arg(cur, &name)?;
            self.cc_frequency = value.max(1);
            return Ok(Some(()));
        }
        // `q.Max` / `v.Max` change what a full value means.
        if name == "Max" {
            let value = self.expect_int_arg(cur, &name)?;
            match target {
                OnNoteTarget::Gate => {
                    self.q_max = value.max(1);
                    self.track().gate_percent = self.q_max;
                    self.reset_note_modifier(target);
                }
                OnNoteTarget::Velocity => {
                    self.v_max = value.max(1);
                    self.track().velocity = self.v_max;
                    self.reset_note_modifier(target);
                }
                _ => {
                    self.warnings
                        .push(Warning::new(line, ".Max はこのコマンドでは無視しました"));
                }
            }
            return Ok(Some(()));
        }

        let controller = cc_number_of(target);
        match controller {
            Some(no) => self.cc_modifier(cur, no, &name, line),
            None => self.note_modifier(cur, target, &name, line),
        }
    }

    /// A modifier on a control change or bend.
    fn cc_modifier(
        &mut self,
        cur: &mut Cursor,
        no: i64,
        name: &str,
        line: usize,
    ) -> Result<Option<()>> {
        let kind = match name {
            "onNote" | "N" => Some(Kind::OnNote),
            "onTime" | "T" => Some(Kind::OnTime),
            "Sine" => Some(Kind::CcSine),
            "onNoteSine" => Some(Kind::OnSine),
            "onCycle" | "C" => Some(Kind::OnCycle),
            "onNoteWave" | "W" => Some(Kind::OnWave),
            "onNoteWaveEx" | "WE" => Some(Kind::OnWaveEx),
            "onNoteWaveR" | "WR" => Some(Kind::OnWaveR),
            _ => None,
        };

        if let Some(kind) = kind {
            let values = self.read_args(cur, usize::MAX)?;
            let time = self.track().time;
            let modifier = self.cc_modifier_entry(no);
            modifier.kind = kind;
            modifier.reserve = values;
            modifier.index = 0;
            modifier.time = time;

            // `.onTime` and `.Sine` write themselves out where they stand and
            // are then finished; the rest wait for the notes they apply to.
            if matches!(kind, Kind::OnTime | Kind::CcSine) {
                self.delete_cc_after(no, time);
                self.write_cc_modifier(no, time, 0)?;
                self.cc_modifier_entry(no).kind = Kind::Off;
            }
            return Ok(Some(()));
        }

        match name {
            "Delay" => {
                let value = self.expect_single_modifier_arg(cur, name)?;
                self.cc_modifier_entry(no).delay = value;
            }
            "Repeat" => {
                let value = self.expect_single_modifier_arg(cur, name)?;
                let modifier = self.cc_modifier_entry(no);
                modifier.repeat = value != 0;
                modifier.index = 0;
            }
            "Random" => {
                let value = self.expect_single_modifier_arg(cur, name)?;
                self.cc_modifier_entry(no).random = value;
            }
            "Range" => {
                let args = self.read_args(cur, 2)?;
                if args.len() < 2 {
                    return Err(MmlError::new(line, ".Rangeは(low,high)で指定してください"));
                }
                self.cc_modifier_entry(no).range = Some((args[0], args[1]));
            }
            other => {
                let _ = self.read_args(cur, 16)?;
                self.warnings.push(Warning::new(
                    line,
                    format!(".{other} は未実装のため無視しました"),
                ));
            }
        }
        Ok(Some(()))
    }

    /// A modifier on a note attribute (`v`, `q`, `t`, `l`, `o`).
    fn note_modifier(
        &mut self,
        cur: &mut Cursor,
        target: OnNoteTarget,
        name: &str,
        line: usize,
    ) -> Result<Option<()>> {
        match name {
            "onNote" | "N" | "onTime" | "T" | "onCycle" | "C" => {
                let values = self.read_args(cur, usize::MAX)?;
                let kind = match name {
                    "onNote" | "N" => NoteModifierKind::OnNote,
                    "onTime" | "T" => NoteModifierKind::OnTime,
                    _ => NoteModifierKind::OnCycle,
                };
                if kind == NoteModifierKind::OnTime && values.len() % 3 != 0 {
                    return Err(MmlError::new(
                        line,
                        ".onTimeの引数は3個単位で指定してください",
                    ));
                }
                if kind == NoteModifierKind::OnCycle && values.is_empty() {
                    return Err(MmlError::new(line, ".onCycleには引数を指定してください"));
                }
                let time = self.track().time;
                let modifier = self.note_modifier_entry(target);
                modifier.kind = kind;
                modifier.values = values;
                modifier.next = 0;
                modifier.origin = time;
                Ok(Some(()))
            }
            "Delay" => {
                let value = self.expect_single_modifier_arg(cur, name)?;
                self.note_modifier_entry(target).delay = value;
                Ok(Some(()))
            }
            "Repeat" => {
                let value = self.expect_single_modifier_arg(cur, name)?;
                let modifier = self.note_modifier_entry(target);
                modifier.repeat = value != 0;
                modifier.next = 0;
                Ok(Some(()))
            }
            "Random" => {
                let value = self.expect_single_modifier_arg(cur, name)?;
                self.note_modifier_entry(target).random = value;
                Ok(Some(()))
            }
            "Range" => {
                let values = self.read_args(cur, 2)?;
                if values.len() != 2 {
                    return Err(MmlError::new(line, ".Rangeは(low,high)で指定してください"));
                }
                self.note_modifier_entry(target).range = Some((values[0], values[1]));
                Ok(Some(()))
            }
            other => {
                let _ = self.read_args(cur, 16)?;
                Err(MmlError::new(
                    line,
                    format!("音符属性では未定義のオプションです: .{other}"),
                ))
            }
        }
    }

    fn note_modifier_entry(&mut self, target: OnNoteTarget) -> &mut NoteModifier {
        let track = self.track();
        if let Some(index) = track
            .note_modifiers
            .iter()
            .position(|(existing, _)| *existing == target)
        {
            return &mut track.note_modifiers[index].1;
        }
        track.note_modifiers.push((target, NoteModifier::default()));
        &mut track.note_modifiers.last_mut().expect("just pushed").1
    }

    fn reset_note_modifier(&mut self, target: OnNoteTarget) {
        if let Some((_, modifier)) = self
            .track()
            .note_modifiers
            .iter_mut()
            .find(|(existing, _)| *existing == target)
        {
            modifier.kind = NoteModifierKind::Normal;
        }
    }

    fn expect_single_modifier_arg(&mut self, cur: &mut Cursor, name: &str) -> Result<i64> {
        let line = cur.line();
        let values = self.read_args(cur, 1)?;
        values
            .first()
            .copied()
            .ok_or_else(|| MmlError::new(line, format!(".{name}には数値を指定してください")))
    }

    /// The modifier state for a controller, created on first use.
    fn cc_modifier_entry(&mut self, no: i64) -> &mut CcModifier {
        let track = self.track();
        if let Some(position) = track.cc_modifiers.iter().position(|m| m.no == no) {
            return &mut track.cc_modifiers[position];
        }
        track.cc_modifiers.push(CcModifier::new(no));
        track.cc_modifiers.last_mut().expect("just pushed")
    }

    /// Write out one controller's advance specification for a note.
    fn write_cc_modifier(&mut self, no: i64, track_time: i64, note_len: i64) -> Result<()> {
        let frequency = self.cc_frequency;
        let mut rng = std::mem::take(&mut self.rng);
        let events = {
            let track = self.track();
            match track.cc_modifiers.iter_mut().find(|m| m.no == no) {
                Some(modifier) => modifier.events(track_time, note_len, frequency, &mut rng),
                None => Vec::new(),
            }
        };
        self.rng = rng;

        let suppressed = {
            let track = self.track();
            track.cc_muted || (0..=127).contains(&no) && track.cc_no_mute[no as usize]
        };
        if suppressed {
            return Ok(());
        }

        let channel = self.track().channel;
        for (time, value) in events {
            let value = advance_spec::clamp_for(no, value);
            let event = match no {
                advance_spec::BEND_FULL | advance_spec::BEND_EASY => {
                    self.track().pitch_bend_full = value;
                    self.track().pitch_bend_easy = (value + 8192) / 128;
                    let raw = (value + 8192).clamp(0, 16383);
                    Event::new(
                        time,
                        vec![
                            0xe0 | (channel & 0x0f),
                            (raw & 0x7f) as u8,
                            ((raw >> 7) & 0x7f) as u8,
                        ],
                    )
                }
                _ => Event::control_change(time, channel, no as u8, value as u8),
            };
            self.push_event(event)?;
        }
        Ok(())
    }

    /// Run every advance specification on this track for one note or rest.
    fn write_cc_modifiers(&mut self, track_time: i64, note_len: i64) -> Result<()> {
        let numbers: Vec<i64> = self
            .track()
            .cc_modifiers
            .iter()
            .filter(|m| m.kind != Kind::Off)
            .map(|m| m.no)
            .collect();
        for no in numbers {
            self.write_cc_modifier(no, track_time, note_len)?;
        }
        Ok(())
    }

    /// Drop control-change events for `no` at or after `time`, as the Pascal
    /// build does before writing a fresh ramp over the same ground.
    fn delete_cc_after(&mut self, no: i64, time: i64) {
        let channel = self.track().channel;
        let status = if matches!(no, advance_spec::BEND_FULL | advance_spec::BEND_EASY) {
            0xe0 | (channel & 0x0f)
        } else {
            0xb0 | (channel & 0x0f)
        };
        self.track().events.retain(|event| {
            if event.time < time || event.data.first() != Some(&status) {
                return true;
            }
            // Pascal treats the bend pseudo controllers 256/257 as the same
            // MIDI event class. Values 128..255 likewise select all CCs.
            (0..=127).contains(&no) && event.data.get(1) != Some(&(no as u8))
        });
    }

    fn note_value(&mut self, target: OnNoteTarget, base: i64, time: i64) -> i64 {
        let mut rng = std::mem::take(&mut self.rng);
        let value = self
            .track()
            .note_modifiers
            .iter_mut()
            .find(|(existing, _)| *existing == target)
            .map(|(_, modifier)| modifier.value(time, base, &mut rng))
            .unwrap_or(base);
        self.rng = rng;
        value
    }

    fn note_modifier_step_mode(&mut self, target: OnNoteTarget) -> Option<bool> {
        self.track()
            .note_modifiers
            .iter()
            .find(|(existing, modifier)| {
                *existing == target && modifier.kind != NoteModifierKind::Normal
            })
            .map(|(_, modifier)| modifier.in_steps)
    }

    /// `$c{mml}` — bind one character for use in rhythm mode.
    fn define_rythm_macro(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        let name = cur
            .advance()
            .ok_or_else(|| MmlError::new(line, "$の後にマクロ文字を指定してください"))?;
        if !name.is_ascii() {
            return Err(MmlError::new(
                line,
                "リズムマクロは半角で指定してください。",
            ));
        }
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        if !cur.eat('{') {
            return Err(MmlError::new(line, "リズムマクロは{ }で囲んでください"));
        }
        let body = cur
            .read_balanced('{', '}')
            .ok_or_else(|| MmlError::new(line, "リズムマクロが } で閉じられていません"))?;
        self.rythm_macros.insert(name, body);
        Ok(())
    }

    /// `Rythm{ ... }` — expand the drum macros, then compile the result.
    fn rythm(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let body = self.read_block(cur, line)?;
        let expanded = rythm::expand(&body, &self.rythm_macros);
        self.rythm_depth += 1;
        let result = self.run_fragment(&expanded, line);
        self.rythm_depth -= 1;
        result
    }

    /// A string variable in command position: assign to it, or play it.
    ///
    /// `#Melody={cde}` assigns; a later `#Melody` compiles those contents as
    /// MML. Plain `Str` variables behave the same way.
    fn string_variable(&mut self, cur: &mut Cursor, name: &str, line: usize) -> Result<()> {
        cur.skip_spaces();
        if cur.peek() == Some('=') {
            return self.assign(cur, name);
        }
        if cur.eat('.') {
            let method = cur
                .read_word()
                .ok_or_else(|| MmlError::new(line, "文字列メソッド名を指定してください"))?;
            if method != "s" {
                return Err(MmlError::new(
                    line,
                    format!("文字列メソッド.{method}は未実装です"),
                ));
            }
            cur.skip_spaces();
            if !cur.eat('(') {
                return Err(MmlError::new(
                    line,
                    ".sには(検索文字列,置換文字列)が必要です",
                ));
            }
            let source = cur
                .read_balanced('(', ')')
                .ok_or_else(|| MmlError::new(line, ".sの括弧が閉じられていません"))?;
            let parts = split_function_args(&source);
            if parts.len() != 2 {
                return Err(MmlError::new(line, ".sには2つの引数が必要です"));
            }
            let from = self.eval_source(parts[0].trim(), line)?.as_str();
            let to = self.eval_source(parts[1].trim(), line)?.as_str();
            let current = self
                .variables
                .get(name)
                .map(Value::as_str)
                .unwrap_or_default();
            self.variables
                .insert(name.to_string(), Value::Str(current.replace(&from, &to)));
            return Ok(());
        }
        let contents = match self.variables.get(name) {
            Some(value) => value.as_str(),
            None => return Ok(()),
        };
        if contents.is_empty() {
            return Ok(());
        }
        let expanded = self.preprocess(&contents);
        let expanded = if self.rythm_depth > 0 {
            rythm::expand(&expanded, &self.rythm_macros)
        } else {
            expanded
        };
        self.run_fragment(&expanded, line)
    }

    /// `'ceg'4` — a chord: every note starts together and shares one length.
    fn chord(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let mut body = String::new();
        loop {
            match cur.advance() {
                Some('\'') => break,
                Some(c) => body.push(c),
                None => return Err(MmlError::new(line, "和音が ' で閉じられていません")),
            }
        }
        if !self.allow_multi_line && (body.contains('\n') || body.contains('\r')) {
            return Err(MmlError::new(line, "和音内に改行があります"));
        }
        cur.skip_spaces();
        let length = if cur.peek() == Some('(') {
            let value = self.expect_int(cur, "和音の音長")?;
            if self.track().system_step_mode {
                Some(value)
            } else {
                Some(self.timebase * 4 / value.max(1))
            }
        } else {
            self.read_length(cur)
        };

        let start = self.track().time;
        let previous_length = self.track().length;
        if let Some(length) = length {
            self.track().length = length;
        }

        // Every note in the body starts at `start`; the pointer moves once,
        // afterwards, by the chord's own length.
        let outer = self.chord_start.replace(start);
        let outcome = self.run_fragment(&body, line);
        self.chord_start = outer;

        let length = length.unwrap_or(previous_length);
        let length = self.scale_stretch(length, line)?;
        let end = self.checked_time(start, length, line)?;
        let track = self.track();
        track.length = previous_length;
        track.time = end;
        track.last_note = None;
        outcome
    }

    /// Convert BPM to the 24-bit tempo payload value.
    fn tempo_usec(bpm: i64, line: usize) -> Result<u32> {
        if !(4..=60_000_000).contains(&bpm) {
            return Err(MmlError::new(
                line,
                format!("テンポには4〜60000000の値を指定してください: {bpm}"),
            ));
        }
        Ok((60_000_000 / bpm) as u32)
    }

    /// `TempoChange(t1,t2,len)`, `(t2,len)`, or `=t2` — write a tempo ramp
    /// in sixteenth-note intervals without advancing the time pointer.
    fn tempo_change(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        let args = self.read_args(cur, 3)?;
        let (t1, t2, len) = match args.as_slice() {
            [t2] => (self.tempo, *t2, self.timebase * 4),
            [t2, len] => (self.tempo, *t2, *len),
            [t1, t2, len] => (*t1, *t2, *len),
            _ => {
                return Err(MmlError::new(
                    line,
                    "TempoChangeには1〜3個の引数を指定してください",
                ));
            }
        };

        Self::tempo_usec(t1, line)?;
        Self::tempo_usec(t2, line)?;
        if len <= 0 {
            return Err(MmlError::new(
                line,
                format!("TempoChangeの期間には正の値を指定してください: {len}"),
            ));
        }
        let tstep = self.timebase / 4;
        if tstep <= 0 {
            return Err(MmlError::new(
                line,
                "TempoChangeには4以上のTimeBaseが必要です",
            ));
        }
        let count = len / tstep;
        if count == 0 {
            return Err(MmlError::new(
                line,
                format!("TempoChangeの期間は{tstep}tick以上にしてください: {len}"),
            ));
        }
        let event_count = usize::try_from(count).map_err(|_| {
            MmlError::new(
                line,
                format!("生成イベント数が上限({MAX_EVENTS})を超えました"),
            )
        })?;
        self.ensure_event_capacity(event_count, line)?;

        let start = self.track().time;
        let end = self.checked_time(start, len, line)?;
        let slope = (t2 as f64 - t1 as f64) / count as f64;
        for i in 0..count.saturating_sub(1) {
            let offset = i
                .checked_mul(tstep)
                .ok_or_else(|| MmlError::new(line, "TempoChangeの時刻計算があふれました"))?;
            let time = self.checked_time(start, offset, line)?;
            let bpm = (i as f64 * slope + t1 as f64).trunc() as i64;
            let usec = Self::tempo_usec(bpm, line)?;
            self.push_event_to_track(0, Event::tempo(time, usec))?;
        }
        self.push_event_to_track(0, Event::tempo(end, Self::tempo_usec(t2, line)?))?;
        self.tempo = t2;
        Ok(())
    }

    /// `Cresc`/`Decresc` — ramp Expression (CC 11) from `def1` to `def2` over
    /// a length, written where the pointer stands without advancing it.
    ///
    /// The Pascal build (`cresc_sub` in `mml_base.pas`) has a real quirk here
    /// worth reproducing rather than fixing: written as `Cresc(len,v1,v2)`,
    /// only the length is read — the parenthesised value list is silently
    /// dropped and the defaults are used instead. Only the `Cresc=len,v1,v2`
    /// form reads its values; the sutoton aliases (大きく／小さく) always use
    /// that form, so real songs are unaffected.
    fn cresc(&mut self, cur: &mut Cursor, def1: i64, def2: i64, line: usize) -> Result<()> {
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();

        let (len, t1, t2) = if cur.peek() == Some('(') {
            cur.advance();
            let raw = cur
                .read_balanced('(', ')')
                .ok_or_else(|| MmlError::new(line, "Crescの括弧が閉じられていません"))?;
            let mut sub = Cursor::with_line(&raw, line);
            let len = self.read_length(&mut sub).filter(|v| *v > 0);
            (len, def1, def2)
        } else {
            let len = self.read_length(cur).filter(|v| *v > 0);
            cur.skip_spaces();
            if cur.eat(',') {
                let mut values = Vec::new();
                loop {
                    cur.skip_spaces();
                    match self.read_number(cur)? {
                        Some(v) => values.push(v),
                        None => break,
                    }
                    cur.skip_spaces();
                    if !cur.eat(',') {
                        break;
                    }
                }
                match values.as_slice() {
                    [] => (len, def1, def2),
                    [v2] => (len, self.expression_last_value(), *v2),
                    [v1, v2, ..] => (len, *v1, *v2),
                }
            } else {
                (len, def1, def2)
            }
        };
        let len = len.unwrap_or(self.timebase * 4);

        let tstep = self.cc_frequency.max(1);
        let cnt = len / tstep;
        let slope = if cnt != 0 {
            (t2 - t1) as f64 / cnt as f64
        } else {
            0.0
        };
        let tm = self.track().time;
        let channel = self.track().channel;

        let mut previous: Option<i64> = None;
        for i in 0..(cnt - 1).max(0) {
            let value = ((i as f64) * slope + t1 as f64).trunc() as i64;
            let value = value.clamp(0, 127);
            if previous != Some(value) {
                self.push_event(Event::control_change(
                    tm + i * tstep,
                    channel,
                    11,
                    value as u8,
                ))?;
            }
            previous = Some(value);
        }
        // The final value is always written, even if it repeats the last one.
        self.push_event(Event::control_change(
            tm + len,
            channel,
            11,
            t2.clamp(0, 127) as u8,
        ))?;
        self.cc_modifier_entry(11).last_value = t2;
        Ok(())
    }

    /// The last value written to Expression (CC 11), or 0 if none has been.
    fn expression_last_value(&mut self) -> i64 {
        let value = self.cc_modifier_entry(11).last_value;
        if value == i64::MIN {
            0
        } else {
            value
        }
    }

    /// `Div{mml}(len)` — fit the block's notes into `len`, as a tuplet.
    ///
    /// The block's notes share the length equally, so `Div{cde}4` is a triplet
    /// filling one quarter note.
    fn div(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let body = self.read_block(cur, line)?;
        cur.skip_spaces();
        let total = self.read_length(cur).unwrap_or_else(|| self.track().length);

        let count = count_notes(&body).max(1);
        let previous = self.track().length;
        let start = self.track().time;
        self.track().length = (total / count).max(1);
        let outcome = self.run_fragment(&body, line);

        // The tuplet occupies exactly `total`, however much the body played:
        // `Div{c^d}4` writes past the end but the pointer still lands there.
        let end = self.checked_time(start, total, line)?;
        let track = self.track();
        track.length = previous;
        track.time = end;
        outcome
    }

    /// `Stretch{mml}len` — measure a phrase, then replay it scaled to `len`.
    ///
    /// The first pass deliberately runs on the real compiler state with note
    /// output muted. That reproduces the Pascal implementation: variables and
    /// non-note events in the phrase are evaluated in both passes, while the
    /// first pass exists primarily to advance the clock and measure the body.
    fn stretch(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let body = self.read_block(cur, line)?;
        let target = self
            .read_stretch_length(cur)?
            .unwrap_or_else(|| self.track().length);
        if target < 0 {
            return Err(MmlError::new(
                line,
                "Stretchの長さには0以上を指定してください",
            ));
        }

        let original_track = self.current;
        let start = self.track().time;
        let previous_mute = self.track().muted;
        let previous_rate = self.stretch_rate;

        self.track().muted = true;
        let measured = self.run_fragment(&body, line);
        self.current = original_track;
        self.track().muted = previous_mute;
        if let Err(error) = measured {
            self.stretch_rate = previous_rate;
            self.track().time = start;
            return Err(MmlError::new(
                error.line,
                format!("Stretch: {}", error.message),
            ));
        }

        let duration = self.track().time - start;
        if duration <= 0 {
            self.track().time = start;
            return Err(MmlError::new(line, "Stretchの対象フレーズの長さが0です"));
        }
        self.stretch_rate = target as f64 / duration as f64;
        self.track().time = start;
        self.track().last_note = None;

        let result = self.run_fragment(&body, line);
        self.current = original_track;
        self.stretch_rate = previous_rate;
        self.track().muted = previous_mute;
        self.track().time = self.checked_time(start, target, line)?;
        self.track().last_note = None;
        result.map_err(|error| MmlError::new(error.line, format!("Stretch: {}", error.message)))
    }

    /// Read Stretch's target length. Parentheses are an expression wrapper,
    /// while `%` inside them retains the legacy raw-tick meaning.
    fn read_stretch_length(&mut self, cur: &mut Cursor) -> Result<Option<i64>> {
        cur.skip_spaces();
        if cur.peek() != Some('(') {
            return Ok(self.read_length(cur));
        }
        let line = cur.line();
        let source = self.read_paren_source(cur, line)?;
        let source = source.trim();
        let (raw_ticks, source) = match source.strip_prefix('%') {
            Some(rest) => (true, rest.trim()),
            None => (false, source),
        };
        let value = self.eval_source(source, line)?.as_int(line)?;
        if raw_ticks || self.track().system_step_mode {
            Ok(Some(value))
        } else if value <= 0 {
            Ok(Some(0))
        } else {
            Ok(Some(self.timebase * 4 / value))
        }
    }

    /// `Sub{ ... }` — play the block, then put the time pointer back.
    fn sub(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let body = self.read_block(cur, line)?;
        let before = self.track().time;
        self.run_fragment(&body, line)?;
        let track = self.track();
        track.time = before;
        track.last_note = None;
        Ok(())
    }

    /// `Play({track 0},{track 1},...)` — compile several tracks in parallel.
    ///
    /// Each non-empty string argument is compiled on the track identified by
    /// its zero-based argument position. All target time pointers start at the
    /// caller's current time, and the caller's current track is restored when
    /// the command finishes. This follows `scriptPlay` in the Pascal build.
    fn play(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        if !cur.eat('(') {
            return Err(MmlError::new(
                line,
                "Playには(トラック...)を指定してください",
            ));
        }
        let body = cur
            .read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "Playの括弧が閉じていません"))?;

        let original_track = self.current;
        let start_time = self.track().time;
        let step_mode = self.step_mode;

        for (track_no, source) in split_play_args(&body).into_iter().enumerate() {
            let source = source.trim();
            if source.is_empty() {
                continue;
            }
            let value = match self.eval_source(source, line) {
                Ok(value) => value,
                Err(error) => {
                    self.current = original_track;
                    return Err(MmlError::new(
                        error.line,
                        format!("Playのトラック{track_no}: {}", error.message),
                    ));
                }
            };
            let Value::Str(source) = value else {
                // The Pascal implementation ignores non-string arguments.
                continue;
            };

            self.current = track_no as i64;
            let timebase = self.timebase;
            let track = self
                .tracks
                .entry(self.current)
                .or_insert_with(|| TrackState::new(track_no as i64, timebase, step_mode));
            track.time = start_time;
            track.last_note = None;

            let normalized = self.preprocess(&source);
            if let Err(error) = self.run_fragment(&normalized, line) {
                self.current = original_track;
                return Err(MmlError::new(
                    error.line,
                    format!("Playのトラック{track_no}: {}", error.message),
                ));
            }
        }

        self.current = original_track;
        Ok(())
    }

    /// `PlayFrom(time)` or `PlayFrom.option(v)` — where a partial render
    /// should start. Applied once, after the whole song is compiled (see
    /// [`Self::apply_play_from`]), matching the Pascal build's post-process
    /// (`TSmfTrack.ExecutePlayFrom` in `smf_types.pas`).
    fn play_from_command(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        cur.skip_spaces();
        if cur.peek() == Some('.') {
            cur.advance();
            let name = cur
                .read_word()
                .ok_or_else(|| MmlError::new(line, ".の後にはオプション名が必要です"))?;
            let value = self.expect_int_arg(cur, &name)?;
            match name.as_str() {
                "SysEx" => self.play_from.sysex = value != 0,
                // Pascal keeps this compatibility option, although its CC
                // setting is otherwise unused by the PlayFrom post-process.
                "CtrlChg" => {}
                "RPN_NRPN" => self.play_from.rpn_nrpn = value != 0,
                "Wait" => self.play_from.wait_time = value,
                other => return Err(MmlError::new(line, format!("\"{other}\"は未定義です"))),
            }
            return Ok(());
        }
        cur.eat('=');
        cur.skip_spaces();
        if !cur.eat('(') {
            return Err(MmlError::new(line, "PlayFromには時間を指定してください"));
        }
        let body = cur
            .read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "PlayFromの括弧が閉じていません"))?;
        self.play_from.from_pos = self.time_value(&body, line)?;
        Ok(())
    }

    /// `PlayTo(time)` — where a partial render should stop.
    fn play_to_command(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        if !cur.eat('(') {
            return Err(MmlError::new(line, "PlayToには時間を指定してください"));
        }
        let body = cur
            .read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "PlayToの括弧が閉じていません"))?;
        self.play_from.to_pos = self.time_value(&body, line)?;
        Ok(())
    }

    /// `Include(file)` — pull in a definition file through the resolver.
    fn include(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        let name = if cur.eat('(') {
            cur.read_balanced('(', ')')
                .ok_or_else(|| MmlError::new(line, "Includeの括弧が閉じていません"))?
        } else if cur.eat('{') {
            cur.read_balanced('{', '}')
                .ok_or_else(|| MmlError::new(line, "Includeの括弧が閉じていません"))?
        } else {
            return Err(MmlError::new(
                line,
                "Includeにはファイル名を指定してください",
            ));
        };
        let name = name.trim().trim_matches('"').trim();

        let bytes = self
            .includes
            .resolve(name)
            .ok_or_else(|| MmlError::new(line, format!("ファイル\"{name}\"が見つかりません")))?;
        let (text, _) = crate::encoding::decode_auto(&bytes);
        // Included files are ordinary MML, sutoton notation and all.
        let normalized = self.preprocess(&text);
        self.run_fragment(&normalized, 1)
    }

    /// `System.xxx` options. The ones that change how notes or timing are
    /// computed are implemented; the rest are accepted with a warning so that
    /// existing songs still compile instead of failing outright.
    fn system_command(&mut self, cur: &mut Cursor, name: &str, line: usize) -> Result<()> {
        match name {
            "Include" | "INCLUDE" => self.include(cur),
            "KeyFlag" => self.key_flag(cur),
            "Div" | "DIV" => self.div(cur),
            "PlayFrom" => self.play_from_command(cur, line),
            "PlayTo" => self.play_to_command(cur, line),
            "Cresc" | "CRESC" => self.cresc(cur, 40, 127, line),
            "Decresc" | "DECRESC" => self.cresc(cur, 127, 40, line),
            "Rythm" | "RYTHM" | "Rhythm" | "RHYTHM" => self.rythm(cur),
            "Sub" | "SUB" | "S" => self.sub(cur),
            "TimeSignature" => self.time_signature(cur),
            "TimeBase" | "Timebase" => {
                let value = self.expect_int_arg(cur, name)?;
                self.set_timebase_checked(value, line)?;
                Ok(())
            }
            "Keyshift" | "KeyShift" => {
                self.key_shift = self.expect_int_arg(cur, name)?;
                Ok(())
            }
            "qMax" => {
                let value = self.expect_int_arg(cur, name)?;
                self.q_max = value.max(1);
                Ok(())
            }
            "vMax" => {
                let value = self.expect_int_arg(cur, name)?;
                self.v_max = value.max(1);
                Ok(())
            }
            "vAdd" => {
                self.v_add = self.expect_int_arg(cur, name)?;
                Ok(())
            }
            "qAdd" => {
                self.q_add = self.expect_int_arg(cur, name)?;
                Ok(())
            }
            "q2Add" => {
                self.q2_add = self.expect_int_arg(cur, name)?;
                Ok(())
            }
            "RandomSeed" => {
                let seed = self.expect_int_arg(cur, name)?;
                self.rng.reseed(seed);
                Ok(())
            }
            "MeasureShift" => {
                self.measure_shift = self.expect_int_arg(cur, name)?;
                Ok(())
            }
            "X68mode" | "X68Mode" => {
                self.x68_mode = self.expect_int_arg(cur, name)? != 0;
                Ok(())
            }
            "Stepmode" | "StepMode" => {
                self.step_mode = self.expect_int_arg(cur, name)? != 0;
                Ok(())
            }
            "VoiceNoShift" => {
                self.voice_no_shift = self.expect_system_i32(cur, name, line)?;
                Ok(())
            }
            "OctaveRangeShift" => {
                self.octave_range_shift = self.expect_system_i32(cur, name, line)?;
                Ok(())
            }
            "ControllerShift" => {
                self.controller_shift = self.expect_system_i32(cur, name, line)?;
                Ok(())
            }
            "ArgOrder" => self.arg_order(cur, line),
            "AllowMultiLine" => {
                self.allow_multi_line = self.expect_int_arg(cur, name)? != 0;
                Ok(())
            }
            "MetaTextEOL" => {
                self.meta_text_eol = self.expect_int_arg(cur, name)?;
                Ok(())
            }
            other => {
                // Skip the argument as raw text: it may be a file name or a
                // symbol, which must not be evaluated as an expression.
                cur.skip_spaces();
                cur.eat('=');
                cur.skip_spaces();
                if cur.eat('(') {
                    let _ = cur.read_balanced('(', ')');
                } else {
                    while let Some(c) = cur.peek() {
                        if c == ';' || c == '\n' {
                            break;
                        }
                        cur.advance();
                    }
                }
                self.warnings.push(Warning::new(
                    line,
                    format!("System.{other} は未実装のため無視しました"),
                ));
                Ok(())
            }
        }
    }

    fn arg_order(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        if !cur.eat('(') {
            return Err(MmlError::new(line, "ArgOrderには(...)が必要です"));
        }
        let order = cur
            .read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "ArgOrderの括弧が閉じられていません"))?;
        let order = order.trim();
        if order
            .chars()
            .any(|ch| !matches!(ch, 'l' | 'q' | 'v' | 't' | 'o'))
        {
            return Err(MmlError::new(
                line,
                format!("ArgOrderに指定できない項目があります: {order}"),
            ));
        }
        self.track().arg_order = order.to_string();
        Ok(())
    }

    fn expect_system_i32(&mut self, cur: &mut Cursor, name: &str, line: usize) -> Result<i64> {
        let value = self.expect_int_arg(cur, name)?;
        if !(i32::MIN as i64..=i32::MAX as i64).contains(&value) {
            return Err(MmlError::new(
                line,
                format!("System.{name}は32bit整数の範囲で指定してください: {value}"),
            ));
        }
        Ok(value)
    }

    /// `TimeSignature=n,d` — also recorded, since `Time` is measured in bars.
    fn time_signature(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let args = self.read_args(cur, 2)?;
        if args.len() < 2 {
            return Err(MmlError::new(line, "拍子は 分子,分母 で指定してください"));
        }
        let (numerator, denominator) = (args[0], args[1]);
        if numerator <= 0 || denominator <= 0 {
            return Err(MmlError::new(
                line,
                "拍子の分子と分母は正の整数で指定してください",
            ));
        }
        let beat_ticks = self.timebase * 4 / denominator;
        if beat_ticks <= 0 || numerator.checked_mul(beat_ticks).is_none() {
            return Err(MmlError::new(
                line,
                format!(
                    "現在のTimeBase({})では拍子 {numerator}/{denominator} を表現できません",
                    self.timebase
                ),
            ));
        }
        self.time_signature = (numerator, denominator);

        // ff 58 04 nn dd cc bb, with cc/bb derived from the timebase — the
        // Pascal build writes the timebase itself and an eighth of it.
        let dd = (denominator as f64).log2().round() as u8;
        let timebase = self.timebase;
        let payload = [
            numerator.clamp(0, 255) as u8,
            dd,
            timebase.clamp(0, 255) as u8,
            (timebase / 8).clamp(0, 255) as u8,
        ];
        let time = self.track().time;
        self.push_event(Event::meta(time, event::META_TIME_SIGNATURE, &payload))
    }

    /// `KeyFlag[+|-|#](notes)` or `KeyFlag=(a,b,c,d,e,f,g)`.
    fn key_flag(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        let sign = match cur.eat_any(&['+', '#', '-']) {
            Some('-') => -1,
            _ => 1,
        };
        cur.skip_spaces();

        if cur.eat('=') {
            // Explicit per-pitch-class values.
            let args = self.read_args(cur, 7)?;
            for (index, value) in args.iter().enumerate().take(7) {
                self.key_flags[index] = *value;
            }
        } else {
            if !cur.eat('(') {
                return Err(MmlError::new(line, "KeyFlagには(音名)を指定してください"));
            }
            let names = cur
                .read_balanced('(', ')')
                .ok_or_else(|| MmlError::new(line, "KeyFlagの括弧が閉じていません"))?;
            self.key_flags = [0; 7];
            for ch in names.chars() {
                if let Some(index) = pitch_class_index(ch) {
                    self.key_flags[index] = sign;
                }
            }
        }

        // ff 59 02 sf mi — the count of sharps (positive) or flats (negative).
        let total: i64 = self.key_flags.iter().sum();
        let payload = [(total as i8) as u8, 0];
        let time = self.track().time;
        self.push_event(Event::meta(time, 0x59, &payload))
    }

    /// `Time(measure:beat:step)` — move the track's time pointer.
    fn time_command(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        if !cur.eat('(') {
            return Err(MmlError::new(
                line,
                "Timeには(小節:拍:ステップ)を指定してください",
            ));
        }
        let body = cur
            .read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "Timeの括弧が閉じていません"))?;

        let time = self.time_value(&body, line)?;
        let track = self.track();
        track.time = time;
        track.last_note = None;
        Ok(())
    }

    /// `TimeKey((from),(to),key)` / `TimeKey2(...)` record a time-scoped
    /// transposition. Empty bounds mean the current cursor and no end.
    fn time_key(&mut self, cur: &mut Cursor, second: bool, line: usize) -> Result<()> {
        cur.skip_spaces();
        if !cur.eat('(') {
            return Err(MmlError::new(
                line,
                "TimeKeyには(開始,終了,値)を指定してください",
            ));
        }
        let body = cur
            .read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "TimeKeyの括弧が閉じていません"))?;
        let args = split_function_args(&body);
        if args.len() < 3 || args[2].trim().is_empty() {
            return Err(MmlError::new(
                line,
                "TimeKeyには(開始,終了,値)を指定してください",
            ));
        }
        let now = self.track().time;
        let parse_time = |compiler: &mut Self, text: &str| -> Result<i64> {
            let text = text.trim();
            if text.is_empty() {
                return Ok(now);
            }
            let text = text
                .strip_prefix('(')
                .and_then(|s| s.strip_suffix(')'))
                .unwrap_or(text);
            compiler.time_value(text, line)
        };
        let from = parse_time(self, args[0])?;
        let to = if args[1].trim().is_empty() {
            None
        } else {
            Some(parse_time(self, args[1])?)
        };
        if to.is_some_and(|to| to <= from) {
            return Err(MmlError::new(
                line,
                "TimeKeyの終了位置は開始位置より後にしてください",
            ));
        }
        let key = self.eval_source(args[2].trim(), line)?.as_int(line)?;
        let rule = TimeKeyRule { from, to, key };
        if second {
            self.time_keys2.push(rule);
        } else {
            self.time_keys.push(rule);
        }
        Ok(())
    }

    /// `TimeKeyFlag((from),(to),(a,b,c,d,e,f,g))` records time-scoped
    /// accidentals. Empty bounds follow the same rules as `TimeKey`.
    fn time_key_flag(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        cur.skip_spaces();
        if !cur.eat('(') {
            return Err(MmlError::new(
                line,
                "TimeKeyFlagには(開始,終了,(a,b,c,d,e,f,g))を指定してください",
            ));
        }
        let body = cur
            .read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "TimeKeyFlagの括弧が閉じていません"))?;
        let args = split_function_args(&body);
        if args.len() != 3 || args[2].trim().is_empty() {
            return Err(MmlError::new(
                line,
                "TimeKeyFlagには(開始,終了,(a,b,c,d,e,f,g))を指定してください",
            ));
        }

        let now = self.track().time;
        let parse_time = |compiler: &mut Self, text: &str| -> Result<i64> {
            let text = text.trim();
            if text.is_empty() {
                return Ok(now);
            }
            let text = text
                .strip_prefix('(')
                .and_then(|s| s.strip_suffix(')'))
                .unwrap_or(text);
            compiler.time_value(text, line)
        };
        let from = parse_time(self, args[0])?;
        let to = if args[1].trim().is_empty() {
            None
        } else {
            Some(parse_time(self, args[1])?)
        };
        if to.is_some_and(|to| to <= from) {
            return Err(MmlError::new(
                line,
                "TimeKeyFlagの終了位置は開始位置より後にしてください",
            ));
        }

        let values = args[2]
            .trim()
            .strip_prefix('(')
            .and_then(|text| text.strip_suffix(')'))
            .ok_or_else(|| {
                MmlError::new(line, "TimeKeyFlagのKeyFlag値は括弧で囲んで指定してください")
            })?;
        let values = split_function_args(values);
        if values.len() != 7 || values.iter().any(|value| value.trim().is_empty()) {
            return Err(MmlError::new(
                line,
                "TimeKeyFlagにはa,b,c,d,e,f,gの7値を指定してください",
            ));
        }
        let mut key_flags = [0; 7];
        for (offset, source) in values.iter().enumerate() {
            let note = (b'a' + offset as u8) as char;
            let index = pitch_class_index(note).expect("a through g are note names");
            key_flags[index] = self.eval_source(source.trim(), line)?.as_int(line)?;
        }
        self.time_key_flags.push(TimeKeyFlagRule {
            from,
            to,
            key_flags,
        });
        Ok(())
    }

    /// Write a low-level Note On/Off event without advancing the time pointer.
    fn direct_note(&mut self, cur: &mut Cursor, on: bool, line: usize) -> Result<()> {
        let command = if on { "NoteOn" } else { "NoteOff" };
        let args = self.read_args(cur, 3)?;
        if args.len() != 2 {
            return Err(MmlError::new(
                line,
                format!("{command}にはノート番号とvelocityを指定してください"),
            ));
        }
        let note = args[0];
        let velocity = args[1];
        if !(0..=127).contains(&note) {
            return Err(MmlError::new(
                line,
                format!("{command}のノート番号は0〜127の範囲で指定してください: {note}"),
            ));
        }
        if !(0..=127).contains(&velocity) {
            return Err(MmlError::new(
                line,
                format!("{command}のvelocityは0〜127の範囲で指定してください: {velocity}"),
            ));
        }
        let time = self.track().time;
        let channel = self.track().channel;
        let status = if on { 0x90 } else { 0x80 } | (channel & 0x0f);
        self.push_event(Event::new(time, vec![status, note as u8, velocity as u8]))?;
        if on {
            self.track().last_note_no = Some(note as u8);
        }
        Ok(())
    }

    /// `KeyPressure(value)` / `KP(value)` writes polyphonic aftertouch for
    /// the most recently written note, as `TSmfKeyPressure` does in Pascal.
    fn key_pressure(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        let value = self.expect_int_arg(cur, "KeyPressure")?;
        if !(0..=127).contains(&value) {
            return Err(MmlError::new(
                line,
                format!("KeyPressureは0〜127の範囲で指定してください: {value}"),
            ));
        }
        let (time, channel, note) = {
            let track = self.track();
            (
                track.time,
                track.channel,
                track.last_note_no.ok_or_else(|| {
                    MmlError::new(line, "KeyPressureの前に音符またはNoteOnが必要です")
                })?,
            )
        };
        self.push_event(Event::new(time, vec![0xa0 | channel, note, value as u8]))
    }

    /// The Rust core has no native dialog. Preserve the command's observable
    /// compile-time output as a message, so CLI/WASM hosts can render it.
    fn msg_box(&mut self, cur: &mut Cursor, _line: usize) -> Result<()> {
        cur.skip_spaces();
        let text = if cur.peek().is_none() || matches!(cur.peek(), Some(';') | Some('\n')) {
            "nil".to_string()
        } else {
            self.read_value(cur)?.as_str()
        };
        self.messages.push(text);
        Ok(())
    }

    fn switch_statement(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        let value = self.read_condition(cur)?;
        let body = self.read_block(cur, line)?;
        let arms = parse_switch_arms(&body, line)?;
        let mut fallback = None;
        for (condition, source) in arms {
            match condition {
                Some(condition)
                    if self.eval_source(&condition, line)?.as_str() == value.as_str() =>
                {
                    return self.run_fragment(&source, line);
                }
                Some(_) => {}
                None => fallback = Some(source),
            }
        }
        if let Some(source) = fallback {
            self.run_fragment(&source, line)
        } else {
            Ok(())
        }
    }

    /// Pascal accepts ChannelPrefix as a one-based value and stores `n - 1`.
    fn channel_prefix(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        let value = self.expect_int_arg(cur, "ChannelPrefix")?;
        if !(1..=128).contains(&value) {
            return Err(MmlError::new(
                line,
                format!("ChannelPrefixは1〜128の範囲で指定してください: {value}"),
            ));
        }
        let time = self.track().time;
        self.push_event(Event::meta(
            time,
            event::META_CHANNEL_PREFIX,
            &[(value - 1) as u8],
        ))
    }

    /// `Port(n)` stores the current port and emits the SMF port meta event.
    fn port(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        let value = self.expect_int_arg(cur, "Port")?;
        if !(0..=255).contains(&value) {
            return Err(MmlError::new(
                line,
                format!("Portは0〜255の範囲で指定してください: {value}"),
            ));
        }
        let time = self.track().time;
        self.track().port = value;
        self.push_event(Event::meta(time, event::META_PORT, &[value as u8]))
    }

    fn requested_track(&mut self, cur: &mut Cursor, command: &str, line: usize) -> Result<i64> {
        let args = self.read_args(cur, 1)?;
        let no = args.first().copied().unwrap_or(self.current);
        if no < 0 || !self.tracks.contains_key(&no) {
            return Err(MmlError::new(
                line,
                format!("{command}のトラック番号が不正です: {no}"),
            ));
        }
        Ok(no)
    }

    fn time_parts(&self, time: i64, line: usize) -> Result<(i64, i64, i64)> {
        let (numerator, denominator) = self.time_signature;
        let beat_ticks = self.timebase * 4 / denominator.max(1);
        let bar_ticks = numerator.max(1).checked_mul(beat_ticks).unwrap_or(0);
        if beat_ticks <= 0 || bar_ticks <= 0 {
            return Err(MmlError::new(
                line,
                format!(
                    "現在のTimeBase({})では拍子 {numerator}/{denominator} を表現できません",
                    self.timebase
                ),
            ));
        }
        let measure = time
            .checked_div(bar_ticks)
            .and_then(|measure| measure.checked_add(1))
            .and_then(|measure| measure.checked_sub(self.measure_shift))
            .ok_or_else(|| MmlError::new(line, "時刻表示の計算があふれました"))?;
        let rest = time % bar_ticks;
        Ok((measure, rest / beat_ticks + 1, rest % beat_ticks))
    }

    fn print_time(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        let no = self.requested_track(cur, "PrintTime", line)?;
        let track = &self.tracks[&no];
        let (measure, beat, tick) = self.time_parts(track.time, line)?;
        self.messages.push(format!(
            "Track({no});Time({measure}:{beat}:{tick});//={}(PrintTime)",
            track.time
        ));
        Ok(())
    }

    fn print_track(&mut self, cur: &mut Cursor, line: usize) -> Result<()> {
        let no = self.requested_track(cur, "PrintTrack", line)?;
        let track = &self.tracks[&no];
        let (measure, beat, tick) = self.time_parts(track.time, line)?;
        let length_mode = if track.length_in_steps {
            "ステップモード"
        } else {
            "n分音符モード"
        };
        let gate = if track.gate_in_steps {
            format!("q%{}(ステップモード)", track.gate_percent)
        } else {
            format!("q{}(％指定モード)", track.gate_percent)
        };
        let bend = track.pitch_bend_full;
        let slur_mode = track.slur_mode;
        let slur_value = track.slur_value;
        let event_count = track
            .events
            .iter()
            .filter(|event| !event.deferred_at_same_time)
            .count();
        let mute = if track.muted { "on" } else { "off" };
        self.messages.extend([
            format!(
                "Track({no}) Channel({}) Voice({}) Time({measure}:{beat}:{tick}) Time={}",
                track.channel + 1,
                track.voice,
                track.time
            ),
            format!(
                "l%{}({length_mode}) {gate} v{} t{} o{} ",
                track.length, track.velocity, track.timing, track.octave
            ),
            format!(
                "Slur({slur_mode},{slur_value}) BR({}) PitchBend({bend})",
                self.bend_ranges[track.channel as usize]
            ),
            format!("イベント数={event_count} TrackMute({mute}) "),
        ]);
        Ok(())
    }

    /// Convert `totalTicks` or `measure:beat:step` into an absolute time.
    /// Used by both the Time command and the readable `Time(...)` function.
    fn time_value(&mut self, body: &str, line: usize) -> Result<i64> {
        let parts: Vec<i64> = body
            .split(':')
            .map(|part| {
                let mut cursor = Cursor::with_line(part.trim(), line);
                expr::eval(&mut cursor, self).and_then(|v| v.as_int(line))
            })
            .collect::<Result<Vec<_>>>()?;

        let (numerator, denominator) = self.time_signature;
        let beat_ticks = self.timebase * 4 / denominator.max(1);
        // Checked throughout: `Time(999999999:1:0)` must be a diagnostic, not
        // a time pointer that has wrapped around.
        let overflow = || MmlError::new(line, "Timeの計算があふれました");
        let position = |measure: i64, beat: i64, step: i64| -> Result<i64> {
            let bars = measure
                .checked_sub(1)
                .and_then(|m| m.checked_add(self.measure_shift))
                .and_then(|m| m.checked_mul(numerator))
                .and_then(|m| m.checked_mul(beat_ticks))
                .ok_or_else(overflow)?;
            let beats = beat
                .checked_sub(1)
                .and_then(|b| b.checked_mul(beat_ticks))
                .ok_or_else(overflow)?;
            bars.checked_add(beats)
                .and_then(|t| t.checked_add(step))
                .ok_or_else(overflow)
        };
        let time = match parts.as_slice() {
            [total] => *total,
            [measure, beat] => position(*measure, *beat, 0)?,
            [measure, beat, step, ..] => position(*measure, *beat, *step)?,
            [] => return Err(MmlError::new(line, "Timeの引数が空です")),
        };
        self.checked_time(time.max(0), 0, line)
    }

    /// A GM/GS/XG reset, written as a SysEx message.
    fn reset(&mut self, cur: &mut Cursor, body: &[u8]) -> Result<()> {
        // Accept and ignore an optional argument list, e.g. ResetGM().
        cur.skip_spaces();
        if cur.peek() == Some('(') {
            let _ = self.read_args(cur, 4)?;
        }
        let mut data = vec![0xf0];
        crate::smf::write_var_len(&mut data, body.len() as u32 + 1);
        data.extend_from_slice(body);
        data.push(0xf7);
        let time = self.track().time;
        self.push_event(Event::new(time, data))
    }

    /// `Int name[=value];`, `Str name[={"..."}];`, `Array name[=(a,b,c)];`
    fn declare(&mut self, cur: &mut Cursor, kind: VarKind) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        let parenthesised_name = cur.eat('(');
        cur.skip_spaces();
        let name = cur
            .read_word()
            .ok_or_else(|| MmlError::new(line, "変数名を指定してください"))?;
        if parenthesised_name {
            cur.skip_spaces();
            if !cur.eat(')') {
                return Err(MmlError::new(line, "変数名の括弧が閉じられていません"));
            }
        }

        let initial = match kind {
            VarKind::Int => Value::Int(0),
            VarKind::Str => Value::Str(String::new()),
            VarKind::Array => Value::Array(Vec::new()),
        };
        self.variables.insert(name.clone(), initial);

        cur.skip_spaces();
        if cur.peek() == Some('=') {
            if kind == VarKind::Array {
                cur.advance();
                cur.skip_spaces();
                if cur.eat('(') {
                    let source = cur
                        .read_balanced('(', ')')
                        .ok_or_else(|| MmlError::new(line, "配列の初期値が閉じていません"))?;
                    let raw_items = split_array_initializer(&source, line, MAX_ARRAY_ELEMENTS)?;
                    let mut items = Vec::with_capacity(raw_items.len());
                    for raw in raw_items {
                        items.push(self.eval_source(raw.trim(), line)?);
                    }
                    self.variables.insert(name, Value::Array(items));
                    return Ok(());
                }
                let value = expr::eval(cur, self)?;
                if !matches!(value, Value::Array(_)) {
                    return Err(MmlError::new(line, "配列には配列値を代入してください"));
                }
                self.variables.insert(name, value);
                return Ok(());
            }
            self.assign(cur, &name)?;
        }
        Ok(())
    }

    /// `name = <value>` or `name(index) = <value>`, where the value is a
    /// literal, a `{"string"}` or a parenthesised expression; also `name++`
    /// and `name--`.
    fn assign(&mut self, cur: &mut Cursor, name: &str) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();

        let array_index =
            if matches!(self.variables.get(name), Some(Value::Array(_))) && cur.eat('(') {
                let index = expr::eval(cur, self)?.as_int(line)?;
                cur.skip_spaces();
                if !cur.eat(')') {
                    return Err(MmlError::new(line, "配列の添字が ) で閉じられていません"));
                }
                if index < 0 {
                    return Err(MmlError::new(
                        line,
                        format!("配列\"{name}\"の添字に負の値は指定できません: {index}"),
                    ));
                }
                let index = usize::try_from(index).map_err(|_| {
                    MmlError::new(line, format!("配列\"{name}\"の添字が大きすぎます: {index}"))
                })?;
                if index >= MAX_ARRAY_ELEMENTS {
                    return Err(MmlError::new(
                        line,
                        format!("配列\"{name}\"の要素数が上限({MAX_ARRAY_ELEMENTS})を超えます"),
                    ));
                }
                cur.skip_spaces();
                Some(index)
            } else {
                None
            };

        // `I++` and `I--` step a variable by one.
        if array_index.is_none() {
            for (sign, step) in [('+', 1), ('-', -1)] {
                if cur.peek() != Some(sign) || cur.peek_at(1) != Some(sign) {
                    continue;
                }
                cur.advance();
                cur.advance();
                let current = self
                    .variables
                    .get(name)
                    .map(|value| value.as_int(line))
                    .transpose()?
                    .unwrap_or(0);
                self.variables
                    .insert(name.to_string(), Value::Int(current + step));
                return Ok(());
            }
        }

        if !cur.eat('=') {
            if array_index.is_some() {
                return Err(MmlError::new(line, "配列要素の代入には = が必要です"));
            }
            return Ok(()); // a bare mention of a variable does nothing
        }
        let value = self.read_value(cur)?;
        if let Some(index) = array_index {
            let Some(Value::Array(items)) = self.variables.get_mut(name) else {
                return Err(MmlError::new(
                    line,
                    format!("\"{name}\"は配列ではありません"),
                ));
            };
            if items.len() <= index {
                items.resize(index + 1, Value::Int(0));
            }
            items[index] = value;
        } else {
            self.variables.insert(name.to_string(), value);
        }
        Ok(())
    }

    /// `If(cond){ ... }Else{ ... }`
    fn if_statement(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let condition = self.read_condition(cur)?;
        let then_body = self.read_block(cur, line)?;

        cur.skip_trivia();
        let else_body = {
            let mut probe = cur.clone();
            match probe.read_word().as_deref() {
                Some("Else") | Some("ELSE") => {
                    *cur = probe;
                    Some(self.read_block(cur, line)?)
                }
                _ => None,
            }
        };

        if condition.truthy() {
            self.run_fragment(&then_body, line)?;
        } else if let Some(body) = else_body {
            self.run_fragment(&body, line)?;
        }
        Ok(())
    }

    /// `While(cond){ ... }`
    fn while_statement(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let condition_src = self.read_paren_source(cur, line)?;
        let body = self.read_block(cur, line)?;

        let mut iterations = 0u32;
        while self.eval_source(&condition_src, line)?.truthy() {
            self.run_fragment(&body, line)?;
            if self.take_exit() {
                break;
            }
            iterations += 1;
            if iterations > MAX_ITERATIONS {
                return Err(MmlError::new(
                    line,
                    format!("Whileの繰り返しが{MAX_ITERATIONS}回を超えました"),
                ));
            }
        }
        Ok(())
    }

    /// `For(init; cond; update){ ... }`
    fn for_statement(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let header = self.read_paren_source(cur, line)?;
        let body = self.read_block(cur, line)?;

        let parts: Vec<&str> = header.split(';').collect();
        if parts.len() < 3 {
            return Err(MmlError::new(
                line,
                "Forは For(初期化;条件;更新) の形で指定してください",
            ));
        }
        self.run_statement(parts[0], line)?;

        let mut iterations = 0u32;
        while self.eval_source(parts[1], line)?.truthy() {
            self.run_fragment(&body, line)?;
            if self.take_exit() {
                break;
            }
            self.run_statement(parts[2], line)?;
            iterations += 1;
            if iterations > MAX_ITERATIONS {
                return Err(MmlError::new(
                    line,
                    format!("Forの繰り返しが{MAX_ITERATIONS}回を超えました"),
                ));
            }
        }
        Ok(())
    }

    /// Consume and report a pending `Exit`, so it stops one loop, not all.
    fn take_exit(&mut self) -> bool {
        std::mem::take(&mut self.exiting)
    }

    /// Run a single `name=expr` statement (a For header clause).
    fn run_statement(&mut self, src: &str, line: usize) -> Result<()> {
        let src = src.trim();
        if src.is_empty() {
            return Ok(());
        }
        let mut cur = Cursor::with_line(src, line);
        let name = cur
            .read_word()
            .ok_or_else(|| MmlError::new(line, format!("代入文を読み取れません: {src}")))?;

        // `For(Int J=0; ...)` — the clause may declare its own counter.
        let kind = match name.as_str() {
            "Int" | "INT" | "Integer" | "INTEGER" => Some(VarKind::Int),
            "Str" | "STR" => Some(VarKind::Str),
            "Array" | "ARRAY" => Some(VarKind::Array),
            _ => None,
        };
        if let Some(kind) = kind {
            return self.declare(&mut cur, kind);
        }
        self.assign(&mut cur, &name)
    }

    fn eval_source(&mut self, src: &str, line: usize) -> Result<Value> {
        let mut cur = Cursor::with_line(src.trim(), line);
        let value = expr::eval(&mut cur, self)?;
        cur.skip_trivia();
        if !cur.is_eof() {
            return Err(MmlError::new(
                cur.line(),
                "式の末尾に解釈できない文字があります",
            ));
        }
        Ok(value)
    }

    /// Read a parenthesised condition and evaluate it.
    fn read_condition(&mut self, cur: &mut Cursor) -> Result<Value> {
        let line = cur.line();
        let src = self.read_paren_source(cur, line)?;
        self.eval_source(&src, line)
    }

    /// Read the raw text inside `( ... )`.
    fn read_paren_source(&mut self, cur: &mut Cursor, line: usize) -> Result<String> {
        cur.skip_trivia();
        if !cur.eat('(') {
            return Err(MmlError::new(line, "( が必要です"));
        }
        cur.read_balanced('(', ')')
            .ok_or_else(|| MmlError::new(line, "( が ) で閉じられていません"))
    }

    /// Read the raw text inside `{ ... }`.
    fn read_block(&mut self, cur: &mut Cursor, line: usize) -> Result<String> {
        cur.skip_trivia();
        if !cur.eat('{') {
            return Err(MmlError::new(line, "{ が必要です"));
        }
        cur.read_balanced('{', '}')
            .ok_or_else(|| MmlError::new(line, "{ が } で閉じられていません"))
    }

    /// Read a value: `(expression)`, `{"string"}`, `"string"` or a literal.
    fn read_value(&mut self, cur: &mut Cursor) -> Result<Value> {
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        expr::eval(cur, self)
    }

    /// Set the timebase, refusing a value the SMF header cannot hold.
    fn set_timebase_checked(&mut self, value: i64, line: usize) -> Result<()> {
        if value <= 0 || value > crate::smf::MAX_TIMEBASE {
            return Err(MmlError::new(
                line,
                format!(
                    "TimeBaseは1〜{}の範囲で指定してください: {value}",
                    crate::smf::MAX_TIMEBASE
                ),
            ));
        }
        self.set_timebase(value);
        Ok(())
    }

    /// Changing the timebase rescales the default note length of every track
    /// that has not been given an explicit one yet.
    fn set_timebase(&mut self, value: i64) {
        let old = self.timebase;
        self.timebase = value;
        for state in self.tracks.values_mut() {
            if state.length == old {
                state.length = value;
            }
        }
    }

    /// `[n mml]` — repeat `n` times. A `:` marks where the final pass stops.
    fn repeat(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        let count = self.read_number(cur)?.unwrap_or(2);
        let body = cur
            .read_balanced('[', ']')
            .ok_or_else(|| MmlError::new(line, "ループが ] で閉じられていません"))?;

        let (body, tail) = split_loop_break(&body);
        for iteration in 0..count.max(0) {
            self.run_fragment(body, line)?;
            if self.take_exit() {
                break;
            }
            let is_last = iteration == count - 1;
            if let Some(tail) = tail {
                if !is_last {
                    self.run_fragment(tail, line)?;
                }
            }
        }
        Ok(())
    }

    /// `SysEx(v1,v2,...)`, or `SysEx$=v1,v2,...;` where every value is
    /// hexadecimal.
    ///
    /// The message is always written with an F0 status byte and a
    /// variable-length payload count; a leading F0 in the list is the same
    /// status byte written out, so it is not counted twice.
    fn sysex(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        let hex_mode = cur.eat('$');
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        let parenthesised = cur.eat('(');

        let values = self.read_sysex_values(cur, hex_mode)?;
        if parenthesised {
            cur.skip_spaces();
            if !cur.eat(')') {
                return Err(MmlError::new(line, "SysExの括弧が閉じられていません"));
            }
        }
        if values.is_empty() {
            return Err(MmlError::new(line, "SysExには値を指定してください"));
        }

        let mut payload: Vec<u8> = values.iter().map(|v| (*v).clamp(0, 255) as u8).collect();
        if payload.first() == Some(&0xf0) {
            payload.remove(0);
        }

        let mut data = vec![0xf0];
        crate::smf::write_var_len(&mut data, payload.len() as u32);
        data.extend_from_slice(&payload);

        let time = self.track().time;
        self.push_event(Event::new(time, data))
    }

    /// Read a SysEx value list. A `{...}` group writes its values and then a
    /// Roland-style checksum, reproducing Pascal's `128 - (sum mod 128)`
    /// calculation (including 128 when the remainder is zero).
    fn read_sysex_values(&mut self, cur: &mut Cursor, hex_mode: bool) -> Result<Vec<i64>> {
        let mut values = Vec::new();
        loop {
            cur.skip_spaces();
            if cur.eat('{') {
                let line = cur.line();
                let source = cur
                    .read_balanced('{', '}')
                    .ok_or_else(|| MmlError::new(line, "SysExチェックサム範囲が閉じていません"))?;
                let mut group_cur = Cursor::with_line(&source, line);
                let group = self.read_sysex_values(&mut group_cur, hex_mode)?;
                group_cur.skip_trivia();
                if !group_cur.is_eof() {
                    return Err(MmlError::new(line, "SysExチェックサム範囲を解釈できません"));
                }
                let sum = group.iter().try_fold(0i64, |sum, value| {
                    sum.checked_add(*value).ok_or_else(|| {
                        MmlError::new(line, "SysExチェックサムの計算が範囲を超えました")
                    })
                })?;
                values.extend(group);
                values.push(128 - sum.rem_euclid(128));
            } else {
                let value = if hex_mode {
                    // Even in hex mode a parenthesised value is an ordinary
                    // expression. A `$` prefix is allowed but redundant.
                    if cur.peek() == Some('(') {
                        let line = cur.line();
                        Some(expr::eval(cur, self)?.as_int(line)?)
                    } else {
                        cur.eat('$');
                        cur.read_hex()
                    }
                } else {
                    self.read_number(cur)?
                };
                let Some(value) = value else { break };
                values.push(value);
            }
            cur.skip_spaces();
            if !cur.eat(',') {
                break;
            }
        }
        Ok(values)
    }

    /// `DirectSMF(b1,b2,...)` — put raw bytes into the track as one event.
    fn direct_smf(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let values = self.read_args(cur, usize::MAX)?;
        if values.is_empty() {
            return Err(MmlError::new(line, "DirectSMFには値を指定してください"));
        }
        let data: Vec<u8> = values.iter().map(|v| (*v & 0xff) as u8).collect();
        let time = self.track().time;
        self.push_event(Event::new(time, data))
    }

    /// `@n[,msb,lsb]` — program change, with optional bank select first.
    ///
    /// Voice numbers are 1-based in MML and 0-based in MIDI.
    fn voice(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let args = self.read_args(cur, 3)?;
        let Some(&voice) = args.first() else {
            return Err(MmlError::new(line, "@には音色番号を指定してください"));
        };
        self.track().voice = voice;
        let shifted = voice
            .checked_sub(1)
            .and_then(|value| value.checked_add(self.voice_no_shift))
            .ok_or_else(|| MmlError::new(line, "音色番号の計算が範囲を超えました"))?;
        if !(0..=127).contains(&shifted) {
            return Err(MmlError::new(
                line,
                format!("音色番号が範囲外です(0〜127): {shifted}"),
            ));
        }
        let program = shifted as u8;
        let (time, channel, muted, cc_muted) = {
            let track = self.track();
            (
                track.time - 1,
                track.channel,
                track.cc_muted,
                track.cc_no_mute,
            )
        };
        // Pascal stores bank select inside the program-change node and expands
        // it at save time. Supplying either bank value emits both CC0 and CC32
        // (the omitted value defaults to zero), spaced by ControllerShift.
        if args.len() > 1 && !muted {
            let msb = args.get(1).copied().unwrap_or(0).clamp(0, 127) as u8;
            let lsb = args.get(2).copied().unwrap_or(0).clamp(0, 127) as u8;
            if !cc_muted[0] {
                self.push_event(Event::control_change(
                    time - self.controller_shift * 2,
                    channel,
                    0,
                    msb,
                ))?;
            }
            if !cc_muted[32] {
                self.push_event(Event::control_change(
                    time - self.controller_shift,
                    channel,
                    32,
                    lsb,
                ))?;
            }
        }
        self.push_event(Event::program_change(time, channel, program))
    }

    /// `y(n),(value)` — write a control change by number.
    fn control_change_direct(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        {
            let mut probe = cur.clone();
            probe.skip_spaces();
            if let Some(no) = probe.read_int() {
                probe.skip_spaces();
                if probe.eat('=') {
                    let value = self.expect_int_arg(&mut probe, "y")?;
                    *cur = probe;
                    self.write_cc(no, value);
                    return Ok(());
                }
            }
        }
        // `y256.Frequency(1)` — the number may be followed by a modifier
        // rather than a value. 256 and 257 are the bend pseudo-controllers.
        {
            let mut probe = cur.clone();
            probe.skip_spaces();
            if let Some(no) = probe.read_int() {
                if probe.peek() == Some('.') {
                    *cur = probe;
                    let target = match no {
                        advance_spec::BEND_FULL | advance_spec::BEND_EASY => {
                            OnNoteTarget::PitchBend
                        }
                        _ => OnNoteTarget::ControlChange(no.clamp(0, 127) as u8),
                    };
                    if let Some(handled) = self.modifier(cur, target)? {
                        return Ok(handled);
                    }
                }
            }
        }
        let mut args = self.read_args(cur, 2)?;
        // `y0((value))` — the value may follow the number without a comma.
        if args.len() == 1 {
            cur.skip_spaces();
            if let Some(value) = self.read_number(cur)? {
                args.push(value);
            }
        }
        if args.len() < 2 {
            return Err(MmlError::new(
                line,
                "yにはコントロールチェンジ番号と値を指定してください",
            ));
        }
        self.write_cc(args[0], args[1]);
        Ok(())
    }

    /// `p(value)` — simple pitch bend, 0..63..127 written as the MSB.
    /// `p%(value)` takes the full -8192..8191 range instead.
    fn simple_pitch_bend(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        if cur.eat('%') {
            let value = self.expect_int_arg(cur, "p%")?;
            self.write_pitch_bend(value);
            return Ok(());
        }
        let value = self
            .expect_int(cur, "p")
            .map_err(|_| MmlError::new(line, "pには値を指定してください"))?;
        // The simple form sets only the MSB: LSB stays 0.
        self.write_pitch_bend_raw(0, value.clamp(0, 127) as u8);
        Ok(())
    }

    /// `PitchBend(value)` — full range, -8192..0..8191.
    fn pitch_bend(&mut self, cur: &mut Cursor) -> Result<()> {
        cur.skip_spaces();
        cur.eat('%');
        let value = self.expect_int_arg(cur, "PitchBend")?;
        self.write_pitch_bend(value);
        Ok(())
    }

    fn write_pitch_bend(&mut self, value: i64) {
        let raw = (value + 8192).clamp(0, 16383);
        self.write_pitch_bend_raw((raw & 0x7f) as u8, ((raw >> 7) & 0x7f) as u8);
    }

    fn write_pitch_bend_raw(&mut self, lsb: u8, msb: u8) {
        let controller_shift = self.controller_shift;
        let (time, channel, muted) = {
            let track = self.track();
            (track.time - controller_shift, track.channel, track.cc_muted)
        };
        let raw = ((msb as i64) << 7) | lsb as i64;
        self.track().pitch_bend_full = raw - 8192;
        self.track().pitch_bend_easy = msb as i64;
        if muted {
            return;
        }
        let _ = self.push_event(Event::new(time, vec![0xe0 | (channel & 0x0f), lsb, msb]));
    }

    fn write_cc(&mut self, controller: i64, value: i64) {
        let controller = controller.clamp(0, 127) as u8;
        let value = value.clamp(0, 127) as u8;
        let controller_shift = self.controller_shift;
        let (time, channel, muted) = {
            let track = self.track();
            (
                track.time - controller_shift,
                track.channel,
                track.cc_muted || track.cc_no_mute[controller as usize],
            )
        };
        if !muted {
            let _ = self.push_event(Event::control_change(time, channel, controller, value));
        }
        // Cresc/Decresc's 1-argument form reads a controller's last value, so
        // a plain write must be visible to it too, the way the Pascal build's
        // single TNoteCC.LastValue field is shared by every path that writes.
        self.cc_modifier_entry(controller as i64).last_value = value as i64;
    }

    /// Read up to `max` comma-separated integers, with or without parentheses:
    /// `(1,2,3)`, `=1,2,3` or a bare `1,2,3`.
    fn read_args(&mut self, cur: &mut Cursor, max: usize) -> Result<Vec<i64>> {
        cur.skip_spaces();
        let assigned = cur.eat('=');
        cur.skip_spaces();
        let parenthesised = cur.eat('(');
        let mut args = Vec::new();
        loop {
            // Inside parentheses a list may run over several lines.
            if parenthesised {
                cur.skip_trivia();
            } else {
                cur.skip_spaces();
            }
            let value = if assigned && !parenthesised {
                // `Voice=Vo` — a bare term, which may be a variable or a call.
                let line = cur.line();
                match cur.peek() {
                    Some(c)
                        if c.is_ascii_alphanumeric()
                            || c == '_'
                            || c == '$'
                            || c == '-'
                            || c == '(' =>
                    {
                        Some(expr::eval_term(cur, self)?.as_int(line)?)
                    }
                    _ => None,
                }
            } else if parenthesised && matches!(cur.peek(), Some('!') | Some('%')) {
                self.read_joined_argument_length(cur)?
            } else if parenthesised {
                // Inside parentheses each argument may be an expression.
                match cur.peek() {
                    Some(c)
                        if c.is_ascii_digit()
                            || c == '-'
                            || c == '('
                            || c == '$'
                            || c.is_ascii_alphabetic() =>
                    {
                        let line = cur.line();
                        Some(expr::eval(cur, self)?.as_int(line)?)
                    }
                    _ => None,
                }
            } else {
                self.read_number(cur)?
            };
            let Some(value) = value else { break };
            args.push(value);
            if parenthesised {
                cur.skip_trivia();
            } else {
                cur.skip_spaces();
            }
            if args.len() >= max || !cur.eat(',') {
                break;
            }
        }
        if parenthesised {
            cur.skip_trivia();
        } else {
            cur.skip_spaces();
        }
        if parenthesised && !cur.eat(')') {
            return Err(MmlError::new(cur.line(), "引数の括弧が閉じられていません"));
        }
        Ok(args)
    }

    fn meta_text(&mut self, cur: &mut Cursor, meta_type: u8, line: usize) -> Result<()> {
        let mut text = self.read_text_value(cur, line)?;
        // Pascal writes a single space for an empty meta-text payload.
        if text.is_empty() {
            text.push(' ');
        }
        let logical = text.replace("\r\n", "\n").replace('\r', "\n");
        let text = match self.meta_text_eol {
            1 => logical,
            2 => logical.replace('\n', "\r"),
            _ => logical.replace('\n', "\r\n"),
        };
        let (bytes, warnings) = encode_cp932(&text, line);
        self.warnings.extend(warnings);
        let time = self.track().time;
        self.push_event(Event::meta(time, meta_type, &bytes))
    }

    /// Read the text for a meta event: a literal `{"..."}`, or an expression
    /// such as a `Str` variable (`TrackName=s`).
    fn read_text_value(&mut self, cur: &mut Cursor, line: usize) -> Result<String> {
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        match cur.peek() {
            Some('{') | Some('"') | Some('(') => self.read_braced_string(cur, line),
            _ => Ok(expr::eval(cur, self)?.as_str()),
        }
    }

    /// Read `={"..."}`, `{"..."}` or `("...")`.
    fn read_braced_string(&mut self, cur: &mut Cursor, line: usize) -> Result<String> {
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        if cur.eat('{') {
            let body = cur
                .read_balanced('{', '}')
                .ok_or_else(|| MmlError::new(line, "文字列が } で閉じられていません"))?;
            let trimmed = body.trim();
            if trimmed.len() >= 2 && trimmed.starts_with('"') && trimmed.ends_with('"') {
                return Ok(trimmed[1..trimmed.len() - 1].to_string());
            }
            return Ok(body);
        }
        let closing = match cur.peek() {
            Some('(') => {
                cur.advance();
                ')'
            }
            _ => '\0',
        };
        cur.skip_spaces();
        if !cur.eat('"') {
            return Err(MmlError::new(line, "文字列は \" で囲んで指定してください"));
        }
        let mut text = String::new();
        loop {
            match cur.advance() {
                Some('"') => break,
                Some(c) => text.push(c),
                None => return Err(MmlError::new(line, "文字列が閉じられていません")),
            }
        }
        cur.skip_spaces();
        if closing != '\0' && !cur.eat(closing) {
            return Err(MmlError::new(
                line,
                format!("文字列が {closing} で閉じられていません"),
            ));
        }
        Ok(text)
    }

    fn note(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let letter = cur.advance().expect("caller checked");
        let class = pitch_class_index(letter)
            .ok_or_else(|| MmlError::new(line, format!("音名ではありません: {letter}")))?;
        let base = pitch_class_semitone(class);

        // A `*` immediately after the note suppresses KeyFlag for that note.
        // Legacy chord helpers rely on the accidental following it (`a*+`).
        // A second `*`, after the accidental, has the same suppressing effect.
        let mut suppress_key_flag = cur.eat('*');
        let mut accidental: i64 = 0;
        while let Some(sign) = cur.eat_any(&['+', '-', '#']) {
            accidental += if sign == '-' { -1 } else { 1 };
        }
        suppress_key_flag |= cur.eat('*');
        if !suppress_key_flag {
            let time = self.track().time;
            let flags = self.active_key_flags(time);
            accidental = accidental
                .checked_add(flags[class])
                .ok_or_else(|| Self::note_number_overflow(line))?;
        }

        cur.skip_spaces();
        let (length, options) = self.read_note_options(cur, true)?;
        let slur = self.read_slur_marker(cur)?;
        let time = self.track().time;
        let base_octave = self.track().octave;
        let advanced_octave = self.note_value(OnNoteTarget::Octave, base_octave, time);
        let octave = {
            let track = self.track();
            options.octave.unwrap_or(advanced_octave) + std::mem::take(&mut track.octave_once)
        };
        let transposition = self.current_transposition(line)?;
        let note_no = octave
            .checked_add(self.octave_range_shift)
            .and_then(|value| value.checked_mul(12))
            .and_then(|value| value.checked_add(base))
            .and_then(|value| value.checked_add(accidental))
            .and_then(|value| value.checked_add(transposition))
            .ok_or_else(|| Self::note_number_overflow(line))?;
        self.write_note(note_no, length, options, slur, line)
    }

    fn note_number(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        // Keep the underlying error: it says which variable or expression
        // failed, which is more useful than "n needs a note number".
        let note_no = self.expect_int_arg(cur, "nコマンドのノート番号")?;
        // `n60,` — the Pascal syntax allows a comma before the options.
        cur.eat(',');
        let (length, options) = self.read_note_options(cur, true)?;
        let slur = self.read_slur_marker(cur)?;
        let time = self.track().time;
        let octave = self.track().octave;
        let _ = self.note_value(OnNoteTarget::Octave, octave, time);
        let transposition = self.current_transposition(line)?;
        let note_no = note_no
            .checked_add(transposition)
            .ok_or_else(|| Self::note_number_overflow(line))?;
        self.write_note(note_no, length, options, slur, line)
    }

    fn rest(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        // A leading sign rewinds instead of advancing: `r-2.` moves the
        // pointer backward by a dotted half note. `+` is accepted too, and
        // is simply the ordinary direction — `r+2` and `r2` are identical.
        let rewind = cur.eat('-');
        if !rewind {
            cur.eat('+');
        }
        let expression_length = if cur.peek() == Some('(') {
            let value = self.read_number(cur)?.unwrap_or(0);
            Some(if self.track().system_step_mode {
                value
            } else {
                self.timebase * 4 / value.max(1)
            })
        } else {
            None
        };
        let (length, _) = if expression_length.is_some() {
            (None, NoteOptions::default())
        } else {
            self.read_note_options(cur, false)?
        };
        let explicit = expression_length.or(length);
        // Pascal's funcNoteR scales the default rest length, but an explicit
        // rest length is read after that default and therefore stays literal.
        let length = match explicit {
            Some(length) => length,
            None => {
                let default_length = self.track().length;
                self.scale_stretch(default_length, line)?
            }
        };
        let signed = if rewind { -length } else { length };
        let time = self.track().time;
        // A rest advances the specifications as a note does — the Pascal
        // build calls checkNoteOnCC for both.
        self.write_cc_modifiers(time, length.max(0))?;
        let next = self.checked_time(time, signed, line)?;
        let track = self.track();
        track.time = next;
        track.last_note = None;
        Ok(())
    }

    /// `^` extends the previous note; with no preceding note it is a rest.
    fn tie(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        // As with `r`, a leading sign only makes sense when there is no
        // previous note to extend — the Pascal build routes both through the
        // same handler (funcNoteR).
        let no_previous_note = self.track().last_note.is_none();
        let rewind = no_previous_note && cur.peek() == Some('-');
        if rewind || (no_previous_note && cur.peek() == Some('+')) {
            cur.advance();
        }
        let (length, _) = self.read_note_options(cur, false)?;
        let length = match length {
            Some(length) => length,
            None => {
                let default_length = self.track().length;
                self.scale_stretch(default_length, line)?
            }
        };
        let signed = if rewind { -length } else { length };
        let gate_percent = self.track().gate_percent;
        let q_max = self.q_max;
        let time = self.track().time;
        let next = self.checked_time(time, signed, line)?;
        let track = self.track();
        track.time = next;

        let Some(last) = track.last_note else {
            return Ok(()); // no note to extend: behaves as a rest
        };
        let total = track.time - last.start;
        let gate = gate_ticks_scaled(total, gate_percent, q_max);
        if let Some(Event { time, .. }) = track.events.get_mut(last.off_index) {
            *time = last.start + gate;
        }
        Ok(())
    }

    fn read_slur_marker(&mut self, cur: &mut Cursor) -> Result<Option<Option<i64>>> {
        cur.skip_spaces();
        if !cur.eat('&') {
            return Ok(None);
        }
        if cur.eat('&') {
            let mode = self.track().slur_mode;
            let value = if matches!(mode, 0 | 1) {
                self.track().length
            } else if mode == 2 {
                200
            } else {
                self.track().slur_value.saturating_mul(2)
            };
            let magnitude = value
                .checked_abs()
                .ok_or_else(|| MmlError::new(cur.line(), "Slurの時間が範囲外です"))?;
            let value = if self.track().slur_value < 0 {
                -magnitude
            } else {
                magnitude
            };
            return Ok(Some(Some(value)));
        }
        cur.skip_spaces();
        let has_value = matches!(
            cur.peek(),
            Some('!') | Some('%') | Some('$') | Some('0'..='9')
        );
        let value = if has_value {
            self.read_number(cur)?
        } else {
            None
        };
        Ok(Some(value))
    }

    fn write_note(
        &mut self,
        note_no: i64,
        length: Option<i64>,
        options: NoteOptions,
        slur: Option<Option<i64>>,
        line: usize,
    ) -> Result<()> {
        if !(0..=127).contains(&note_no) {
            return Err(MmlError::new(
                line,
                format!("ノート番号が範囲外です(0〜127): {note_no}"),
            ));
        }
        let time = self.track().time;
        let (base_length, base_velocity, base_gate, base_timing) = {
            let track = self.track();
            (
                track.length,
                track.velocity,
                track.gate_percent,
                track.timing,
            )
        };
        let advanced_length = self.note_value(OnNoteTarget::Length, base_length, time);
        let advanced_velocity = self.note_value(OnNoteTarget::Velocity, base_velocity, time);
        let gate_modifier_in_steps = self.note_modifier_step_mode(OnNoteTarget::Gate);
        let advanced_gate = self.note_value(OnNoteTarget::Gate, base_gate, time);
        let advanced_timing = self.note_value(OnNoteTarget::Timing, base_timing, time);
        let length = length.unwrap_or(advanced_length);
        let raw_velocity = options.velocity.unwrap_or(advanced_velocity);
        let gate_value = options.gate_percent.unwrap_or(advanced_gate);
        let (q_max, v_max) = (self.q_max, self.v_max);
        let velocity = scale_velocity(raw_velocity, v_max);
        let gate_in_steps = if options.gate_percent.is_some() {
            options.gate_in_steps
        } else {
            gate_modifier_in_steps.unwrap_or(self.track().gate_in_steps)
        };
        let (length, gate) = if self.stretch_rate != 1.0 {
            // Pascal scales the duration and the pre-NoteOff gate separately,
            // then applies the one-tick packed-note adjustment.
            let raw_gate = if gate_in_steps {
                gate_value
            } else {
                length.saturating_mul(gate_value) / q_max.max(1)
            };
            (
                self.scale_stretch(length, line)?,
                (self.scale_stretch(raw_gate, line)? - 1).max(1),
            )
        } else if gate_in_steps {
            (length, (gate_value - 1).max(1))
        } else {
            (length, gate_ticks_scaled(length, gate_value, q_max))
        };
        let (timing, channel) = {
            let track = self.track();
            (options.timing.unwrap_or(advanced_timing), track.channel)
        };
        // Inside a chord every note starts together.
        let time = self.chord_start.unwrap_or(time);
        let start = self.checked_time(time, timing, line)?;
        let end = self.checked_time(start, gate, line)?;
        let next = self.checked_time(time, length, line)?;

        let muted = self.track().muted;
        let slur_participates = slur.is_some() || !self.track().slur_notes.is_empty();
        let mut wrote_note = false;
        let mut slur_note = None;
        if length == 0 {
            if !muted {
                self.track().pending_zero_length_notes.push(PendingNote {
                    start,
                    channel,
                    note: note_no as u8,
                    velocity,
                });
            }
        } else if slur_participates {
            // Keep slurred notes out of the mutable event list until the
            // chain closes. DeleteCC and immediate CC ramps may retain-filter
            // that list between `c&` and the following note.
            if !muted {
                slur_note = Some(SlurNote {
                    start,
                    off: end,
                    note: note_no as u8,
                    velocity,
                    transition: slur.flatten(),
                });
            }
        } else {
            let pending = std::mem::take(&mut self.track().pending_zero_length_notes);
            // Taking the pending notes terminates the legacy chord even when
            // muted, so it cannot leak past Mute/TrackMute.
            if !muted && pending.is_empty() {
                self.push_event(Event::note_on(start, channel, note_no as u8, velocity))?;
                self.push_event(Event::note_off(end, channel, note_no as u8, velocity))?;
                wrote_note = true;
            } else if !muted {
                // Pascal's WaonStack bypasses the ordinary packed-note
                // one-tick shortening for every member, including the final
                // positive-length note.
                let chord_gate = gate.saturating_add(1);
                for note in pending {
                    let note_end = self.checked_time(note.start, chord_gate, line)?;
                    self.push_event(Event::note_on(
                        note.start,
                        note.channel,
                        note.note,
                        note.velocity,
                    ))?;
                    self.push_event(Event::note_off(
                        note_end,
                        note.channel,
                        note.note,
                        note.velocity,
                    ))?;
                }
                let chord_end = self.checked_time(start, chord_gate, line)?;
                self.push_event(Event::note_on(start, channel, note_no as u8, velocity))?;
                self.push_event(Event::note_off(chord_end, channel, note_no as u8, velocity))?;
                wrote_note = true;
            }
        }
        // Advance specifications run after the note, which is the only point
        // at which its length is known — the Pascal build calls
        // checkNoteOnCC here for the same reason. Values meant to arrive
        // before the note carry an earlier time and sort ahead of it.
        self.write_cc_modifiers(time, length)?;

        if let Some(slur_note) = slur_note {
            if slur.is_some() {
                self.reserve_slur_note(line)?;
            }
            self.handle_slur_note(slur_note, slur.is_some(), channel)?;
        } else if slur.is_none() {
            self.clear_current_slur_notes();
        }

        let track = self.track();
        if !muted {
            track.last_note_no = Some(note_no as u8);
        }
        track.last_note = if !wrote_note {
            None
        } else {
            Some(LastNote {
                off_index: track.events.len() - 1,
                start,
            })
        };
        // A chord moves the pointer once, when it closes.
        if self.chord_start.is_none() {
            self.track().time = next;
        }
        Ok(())
    }

    fn handle_slur_note(&mut self, note: SlurNote, continues: bool, channel: u8) -> Result<()> {
        if continues {
            self.track().slur_notes.push(note);
            return Ok(());
        }
        if self.track().slur_notes.is_empty() {
            return Ok(());
        }
        let mut notes = std::mem::take(&mut self.track().slur_notes);
        let reserved = notes.len().saturating_mul(2);
        notes.push(note);
        let mut mode = self.track().slur_mode;
        let mut configured = self.track().slur_value;
        let final_note = *notes.last().expect("slur has at least two notes");
        let max_distance = notes
            .iter()
            .map(|item| (item.note as i64 - final_note.note as i64).abs())
            .max()
            .unwrap_or(0);
        if matches!(mode, 0 | 1) && max_distance > 12 {
            mode = 2;
            configured = 100;
        }

        if mode == 2 {
            let note_runs = 1 + notes
                .windows(2)
                .filter(|pair| pair[0].note != pair[1].note)
                .count();
            self.buffered_slur_events = self.buffered_slur_events.saturating_sub(reserved);
            self.ensure_event_capacity(note_runs.saturating_mul(2), 0)?;
            let mut anchor = 0usize;
            let mut anchor_off = notes[0].off;
            let mut anchor_merged = false;
            for index in 1..notes.len() {
                let previous = notes[anchor];
                let current = notes[index];
                if previous.note == current.note {
                    let previous_gate = anchor_off - previous.start + 1;
                    let current_gate = current.off - current.start + 1;
                    anchor_off = previous
                        .start
                        .saturating_add(previous_gate)
                        .saturating_add(current_gate)
                        .saturating_sub(1);
                    anchor_merged = true;
                    continue;
                }
                let percent = previous.transition.unwrap_or(configured);
                let span = current.start.saturating_sub(previous.start);
                let gate = if percent < 0 {
                    span.saturating_add(span.saturating_mul(percent) / 100)
                } else {
                    span.saturating_mul(percent) / 100
                };
                let off = previous
                    .start
                    .saturating_add(gate)
                    .saturating_sub(1)
                    .max(previous.start);
                self.push_event(Event::note_on(
                    previous.start,
                    channel,
                    previous.note,
                    previous.velocity,
                ))?;
                self.push_event(Event::note_off(
                    off,
                    channel,
                    previous.note,
                    previous.velocity,
                ))?;
                anchor = index;
                anchor_off = current.off;
                anchor_merged = false;
            }
            let last = notes[anchor];
            let off = if anchor_merged {
                anchor_off
            } else {
                last.off.saturating_add(1)
            };
            self.push_event(Event::note_on(
                last.start,
                channel,
                last.note,
                last.velocity,
            ))?;
            self.push_event(Event::note_off(off, channel, last.note, last.velocity))?;
            return Ok(());
        }

        if mode == 3 {
            self.buffered_slur_events = self.buffered_slur_events.saturating_sub(reserved);
            self.ensure_event_capacity(notes.len().saturating_mul(2), 0)?;
            let maximum = configured.saturating_sub(1).max(0) as usize;
            if maximum == 0 {
                for note in &notes {
                    self.push_event(Event::note_on(
                        note.start,
                        channel,
                        note.note,
                        note.velocity,
                    ))?;
                    self.push_event(Event::note_off(note.off, channel, note.note, note.velocity))?;
                }
                return Ok(());
            }
            for index in 0..notes.len() {
                let end_note = notes[(index + maximum).min(notes.len() - 1)];
                let note = notes[index];
                self.push_event(Event::note_on(
                    note.start,
                    channel,
                    note.note,
                    note.velocity,
                ))?;
                self.push_event(Event::note_off(
                    end_note.off.saturating_add(1),
                    channel,
                    note.note,
                    note.velocity,
                ))?;
            }
            return Ok(());
        }

        let range_index = channel as usize;
        let mut range = self.bend_ranges[range_index].max(1);
        let needs_range_change = max_distance > range;
        if max_distance > range {
            range = 12;
        }
        let cc_muted = self.track().cc_muted;
        let bend_value = |pitch: u8| -> i64 {
            (pitch as i64 - final_note.note as i64).saturating_mul(8192) / range
        };
        let mut ramp_events = Vec::new();
        if !cc_muted && mode == 0 {
            for (note_index, item) in notes.iter().enumerate().skip(1) {
                let target = bend_value(item.note);
                let previous_note = notes[note_index - 1];
                let previous = bend_value(previous_note.note);
                let duration = previous_note.transition.unwrap_or(configured);
                let length = duration
                    .checked_abs()
                    .ok_or_else(|| MmlError::new(0, "Slurの時間が範囲外です"))?
                    .max(1);
                let from = if duration < 0 {
                    item.start
                } else {
                    item.start - length
                };
                let mut modifier = CcModifier::new(advance_spec::BEND_FULL);
                modifier.kind = Kind::OnTime;
                modifier.reserve = vec![previous, target, length];
                let mut rng = std::mem::take(&mut self.rng);
                ramp_events.extend(modifier.events(from, 0, self.cc_frequency, &mut rng));
                self.rng = rng;
            }
        }
        let bend_events = if cc_muted {
            0
        } else if mode == 1 {
            notes.len()
        } else {
            1usize.saturating_add(ramp_events.len())
        };
        let rpn_events = usize::from(!cc_muted && needs_range_change).saturating_mul(3);
        let required = 2usize
            .saturating_add(bend_events)
            .saturating_add(rpn_events);
        self.buffered_slur_events = self.buffered_slur_events.saturating_sub(reserved);
        self.ensure_event_capacity(required, 0)?;
        if needs_range_change {
            self.bend_ranges[range_index] = range;
            let at = notes[0].start.saturating_sub(2);
            if !cc_muted {
                self.push_event(Event::control_change(at, channel, 101, 0))?;
                self.push_event(Event::control_change(at, channel, 100, 0))?;
                self.push_event(Event::control_change(at, channel, 6, range as u8))?;
            }
        }
        self.push_event(Event::note_on(
            notes[0].start,
            channel,
            final_note.note,
            final_note.velocity,
        ))?;
        self.push_event(Event::note_off(
            final_note.off.saturating_add(1),
            channel,
            final_note.note,
            final_note.velocity,
        ))?;
        self.push_slur_bend(
            notes[0].start.saturating_sub(1),
            bend_value(notes[0].note),
            channel,
        )?;
        if mode == 1 {
            for item in notes.iter().skip(1) {
                let target = bend_value(item.note);
                self.push_slur_bend(item.start, target, channel)?;
            }
        } else {
            for (time, value) in ramp_events {
                self.push_slur_bend(time, value, channel)?;
            }
        }
        Ok(())
    }

    fn push_slur_bend(&mut self, time: i64, value: i64, channel: u8) -> Result<()> {
        if self.track().cc_muted {
            return Ok(());
        }
        let raw = (value + 8192).clamp(0, 16383);
        self.push_event(Event::new(
            time,
            vec![
                0xe0 | (channel & 0x0f),
                (raw & 0x7f) as u8,
                ((raw >> 7) & 0x7f) as u8,
            ],
        ))
    }

    fn scale_stretch(&self, value: i64, line: usize) -> Result<i64> {
        let scaled = (value as f64 * self.stretch_rate).trunc();
        if !scaled.is_finite() || scaled < i64::MIN as f64 || scaled > i64::MAX as f64 {
            return Err(MmlError::new(line, "Stretchの時間計算が範囲を超えました"));
        }
        Ok(scaled as i64)
    }

    /// Note suffixes: a length spec and/or `(l,q,v,t,o)` options.
    fn read_note_options(
        &mut self,
        cur: &mut Cursor,
        use_arg_order: bool,
    ) -> Result<(Option<i64>, NoteOptions)> {
        let mut options = NoteOptions::default();
        let mut length = None;

        // The two forms differ, as they do in the Pascal build: `c(4,...)`
        // sets only the length and ignores the rest, while `c4,80,100,0,5`
        // follows the current track's ArgOrder.
        if cur.peek() == Some('(') {
            let line = cur.line();
            cur.advance();
            let mut index = 0;
            loop {
                cur.skip_spaces();
                if cur.eat(')') {
                    break;
                }
                if index == 0 {
                    self.read_note_option(cur, index, &mut length, &mut options)?;
                } else {
                    // Skip it: past the length these values have no effect,
                    // and they may be written in forms a number parser would
                    // reject (`c(4,%10)`).
                    while !matches!(cur.peek(), Some(',') | Some(')') | None) {
                        cur.advance();
                    }
                }
                cur.skip_spaces();
                if cur.eat(')') {
                    break;
                }
                if !cur.eat(',') {
                    return Err(MmlError::new(line, "音符引数の括弧が閉じられていません"));
                }
                index += 1;
            }
        } else if use_arg_order {
            let order = self.track().arg_order.clone();
            for (position, field) in order.chars().enumerate() {
                let index = match field {
                    'l' => 0,
                    'q' => 1,
                    'v' => 2,
                    't' => 3,
                    'o' => 4,
                    _ => continue,
                };
                self.read_note_option(cur, index, &mut length, &mut options)?;
                cur.skip_spaces();
                if position + 1 >= order.len() || !cur.eat(',') {
                    break;
                }
                cur.skip_spaces();
            }
        } else {
            self.read_note_option(cur, 0, &mut length, &mut options)?;
        }
        Ok((length, options))
    }

    fn read_note_option(
        &mut self,
        cur: &mut Cursor,
        index: usize,
        length: &mut Option<i64>,
        options: &mut NoteOptions,
    ) -> Result<()> {
        // A `%` on the gate means it is given in ticks, as `q%n` does. Only
        // the comma form accepts it; `c(4,%10)` ignores everything past the
        // length, so this is never reached from there.
        let in_steps = index == 1 && cur.peek() == Some('%');
        if in_steps {
            cur.advance();
        }
        let value = if index == 0 {
            self.read_length(cur)
        } else if index == 1 && cur.peek() == Some('!') {
            self.read_joined_argument_length(cur)?
        } else if matches!(cur.peek(), Some(',') | Some(')') | None) {
            None
        } else {
            let base = match index {
                1 => self.track().gate_percent,
                2 => self.track().velocity,
                3 => self.track().timing,
                4 => self.track().octave,
                _ => 0,
            };
            self.read_adjusted_number(cur, base)?
        };
        if in_steps {
            options.gate_in_steps = true;
        }
        match (index, value) {
            (0, Some(v)) => *length = Some(v),
            (1, Some(v)) => options.gate_percent = Some(v),
            (2, Some(v)) => options.velocity = Some(v),
            (3, Some(v)) => options.timing = Some(v),
            (4, Some(v)) => options.octave = Some(v),
            _ => {}
        }
        Ok(())
    }

    /// A length spec: `4`, `8.`, `%48` (raw ticks), or a `^`-joined sum.
    fn read_length(&mut self, cur: &mut Cursor) -> Option<i64> {
        let step_mode = self.track().system_step_mode;
        self.read_length_in_mode(cur, step_mode)
    }

    fn read_length_in_mode(&mut self, cur: &mut Cursor, step_mode: bool) -> Option<i64> {
        let mut total: Option<i64> = None;
        let mut subtract = false;
        loop {
            // `*` introduces a length that may be an expression: `r*%(Delay)`
            // is a rest of `Delay` ticks, `c*3` a third note. Only there does
            // a bare `(` mean a length — elsewhere it opens note options.
            let starred = cur.peek() == Some('*');
            if starred {
                cur.advance();
            }
            let part = if cur.peek() == Some('%') || cur.peek() == Some('!') {
                cur.advance();
                self.read_number(cur).ok().flatten().map(|n| {
                    if step_mode {
                        if n <= 0 {
                            0
                        } else {
                            self.timebase * 4 / n
                        }
                    } else {
                        n
                    }
                })
            } else if matches!(cur.peek(), Some(c) if c.is_ascii_digit()) {
                let n = cur.read_int()?;
                if step_mode {
                    Some(n)
                } else if n <= 0 {
                    Some(0)
                } else {
                    Some(self.timebase * 4 / n)
                }
            } else if starred && cur.peek() == Some('(') {
                match self.read_number(cur).ok().flatten() {
                    Some(n) if n > 0 => Some(self.timebase * 4 / n),
                    other => other,
                }
            } else if total.is_some() && cur.peek() == Some('.') {
                Some(0)
            } else {
                None
            };

            let mut part = match (part, total) {
                (Some(p), _) => p,
                (None, Some(_)) => break,
                (None, None) => {
                    // A bare dot after no digits means "the default length,
                    // dotted"; anything else is not a length at all.
                    if cur.peek() == Some('.') {
                        self.track().length
                    } else {
                        return None;
                    }
                }
            };

            // Dots: each adds half of the running value.
            let mut dotted = part;
            let mut half = part;
            while cur.peek() == Some('.') {
                cur.advance();
                half /= 2;
                dotted += half;
            }
            part = dotted;

            total = Some(if subtract {
                total.unwrap_or(0) - part
            } else {
                total.unwrap_or(0) + part
            });

            match cur.peek() {
                Some('^') | Some('+') => {
                    subtract = false;
                    cur.advance();
                    continue;
                }
                Some('-') => {
                    subtract = true;
                    cur.advance();
                    continue;
                }
                _ => {}
            }
            break;
        }
        total
    }

    /// Length-valued numeric arguments use `!n` for an n-th note, and may
    /// join another ordinary note length with `^`: `!1^1` is two whole notes.
    /// This differs from the note-length grammar, where `!4` historically
    /// behaves like the raw-tick spelling `%4`.
    fn read_joined_argument_length(&mut self, cur: &mut Cursor) -> Result<Option<i64>> {
        let mut total = 0i64;
        let mut found = false;
        loop {
            let mut part = if cur.eat('%') || cur.peek() == Some('!') {
                self.read_number(cur)?
            } else if matches!(cur.peek(), Some(c) if c.is_ascii_digit()) {
                cur.read_int().map(|n| self.timebase * 4 / n.max(1))
            } else {
                None
            };
            let Some(mut part_value) = part.take() else {
                break;
            };
            let mut half = part_value;
            while cur.eat('.') {
                half /= 2;
                part_value += half;
            }
            total = total
                .checked_add(part_value)
                .ok_or_else(|| MmlError::new(cur.line(), "結合音長が範囲を超えました"))?;
            found = true;
            if !cur.eat('^') {
                break;
            }
        }
        Ok(found.then_some(total))
    }

    /// A note-attribute argument: a literal, or a parenthesised expression.
    ///
    /// The single-letter attributes (`o`, `l`, `q`, `v`, `p`) take no `=`
    /// form — the Pascal build rejects `o=x` — and a bare name is not a
    /// variable here, which is what keeps `v100 <c` meaning "velocity, then
    /// octave down".
    fn expect_int(&mut self, cur: &mut Cursor, name: &str) -> Result<i64> {
        let line = cur.line();
        cur.skip_spaces();
        self.read_number(cur)?
            .ok_or_else(|| MmlError::new(line, format!("{name}には数値を指定してください")))
    }

    /// Set or adjust an `o/q/v/t` track value. Repeated bare signs use the
    /// command's configured increment (`v++` is `2 * System.vAdd`), while a
    /// following number is the amount itself (`v+10`).
    fn expect_note_info_value(
        &mut self,
        cur: &mut Cursor,
        name: &str,
        current: i64,
        increment: i64,
    ) -> Result<i64> {
        let line = cur.line();
        cur.skip_spaces();
        if cur.eat('=') {
            return self.expect_int(cur, name);
        }
        let mut signs = 0i64;
        let mut had_sign = false;
        while let Some(sign) = cur.eat_any(&['+', '-']) {
            had_sign = true;
            signs += if sign == '+' { 1 } else { -1 };
        }
        if !had_sign {
            return self.expect_int(cur, name);
        }
        let amount = self.read_number(cur)?.unwrap_or(increment);
        let delta = signs
            .checked_mul(amount)
            .and_then(|delta| current.checked_add(delta))
            .ok_or_else(|| MmlError::new(line, format!("{name}の相対値が範囲を超えました")))?;
        Ok(delta)
    }

    /// Note comma options use their current track value as the base for
    /// `+`, `-`, `*`, and `/`, matching Pascal's `NoteOn.getNoteArg`.
    fn read_adjusted_number(&mut self, cur: &mut Cursor, base: i64) -> Result<Option<i64>> {
        let line = cur.line();
        cur.skip_spaces();
        let operator = cur.eat_any(&['+', '-', '*', '/']);
        let Some(value) = self.read_number(cur)? else {
            return Ok(None);
        };
        let adjusted = match operator {
            Some('+') => base.checked_add(value),
            Some('-') => base.checked_sub(value),
            Some('*') => base.checked_mul(value),
            Some('/') => Some(if value == 0 { 0 } else { base / value }),
            _ => Some(value),
        }
        .ok_or_else(|| MmlError::new(line, "音符引数の相対値が範囲を超えました"))?;
        Ok(Some(adjusted))
    }

    /// A named command's argument, which may be written `Cmd=value`.
    ///
    /// After `=` the value may be a variable or a function call (`Tempo=x`,
    /// `Voice=Vo`, `Tempo=Random(90,130)`) but not a compound expression:
    /// `Tempo=100+20` is an error in the Pascal build too.
    fn expect_int_arg(&mut self, cur: &mut Cursor, name: &str) -> Result<i64> {
        let line = cur.line();
        cur.skip_spaces();
        if cur.eat('=') {
            cur.skip_spaces();
            return expr::eval_term(cur, self)?.as_int(line);
        }
        self.expect_int(cur, name)
    }

    /// Read a numeric argument: a bare integer literal, or — inside
    /// parentheses — a full expression, which is the only place variables may
    /// appear (`o(x)` works, `ox` does not, matching the Pascal build).
    fn read_number(&mut self, cur: &mut Cursor) -> Result<Option<i64>> {
        let line = cur.line();
        cur.skip_spaces();
        // `-$2000` and `-(expr)`: the sign belongs to the value, whatever
        // form the value takes.
        if cur.peek() == Some('-') && matches!(cur.peek_at(1), Some('$') | Some('(')) {
            cur.advance();
            let value = self
                .read_number(cur)?
                .ok_or_else(|| MmlError::new(line, "-の後に値がありません"))?;
            return Ok(Some(-value));
        }
        // `!8` is a length in n-th notes, given where a tick count is wanted:
        // the same thing `Step(8)` and `StrToLen(8)` produce.
        if cur.peek() == Some('!') {
            cur.advance();
            let divisor = self
                .read_number(cur)?
                .ok_or_else(|| MmlError::new(line, "!の後には音長を指定してください"))?;
            return Ok(Some(self.timebase * 4 / divisor.max(1)));
        }
        if cur.peek() == Some('(') {
            let value = expr::eval(cur, self)?;
            return Ok(Some(value.as_int(line)?));
        }
        if cur.peek() == Some('$') {
            cur.advance();
            return cur
                .read_hex()
                .map(Some)
                .ok_or_else(|| MmlError::new(line, "$の後には16進数を指定してください"));
        }
        Ok(cur.read_int())
    }
}

impl EvalContext for Compiler<'_> {
    fn lookup(&self, name: &str) -> Option<Value> {
        self.variables.get(name).cloned()
    }

    fn call(&mut self, name: &str, args: Vec<Value>, line: usize) -> Result<Option<Value>> {
        // A user definition of the same name wins, as it does for commands.
        if self.functions.contains_key(name) {
            return self.call_function(name, args, line);
        }
        self.call_builtin(name, args, line)
    }

    fn has_function(&self, name: &str) -> bool {
        self.functions.contains_key(name) || is_builtin_function(name)
    }
}

/// The controller number an advance specification would write to, when the
/// target is a control change or a bend rather than a note attribute.
fn cc_number_of(target: OnNoteTarget) -> Option<i64> {
    match target {
        OnNoteTarget::ControlChange(no) => Some(no as i64),
        OnNoteTarget::PitchBend => Some(advance_spec::BEND_EASY),
        _ => None,
    }
}

/// Count the notes in a tuplet body, so they can share its length.
///
/// Note letters, `n` and `r` each count once; a tie adds length to the note
/// before it rather than being a note of its own.
fn count_notes(body: &str) -> i64 {
    let chars: Vec<char> = body.chars().collect();
    let mut count = 0;
    let mut index = 0;
    while index < chars.len() {
        let ch = chars[index];
        match ch {
            'a'..='g' | 'n' | 'r' => {
                count += 1;
                index += 1;
                // Skip the note's own suffixes so a length is not miscounted.
                while matches!(chars.get(index), Some(c) if c.is_ascii_digit()
                    || *c == '.' || *c == '+' || *c == '-' || *c == '#' || *c == '%')
                {
                    index += 1;
                }
            }
            _ => index += 1,
        }
    }
    count
}

/// Split a `Play(...)` body on top-level commas or semicolons.
///
/// Separators inside a track's MML or an expression belong to that argument.
/// Empty fields are retained because their positions are track numbers.
fn split_play_args(source: &str) -> Vec<&str> {
    let mut args = Vec::new();
    let mut start = 0usize;
    let mut round = 0usize;
    let mut curly = 0usize;
    let mut square = 0usize;
    let mut in_string = false;

    for (index, ch) in source.char_indices() {
        // A quote inside `{mml}` may be Sakura's one-note octave-down
        // operator. Curly braces already protect their separators, so only a
        // top-level quote needs string tracking here.
        if ch == '"' && curly == 0 {
            in_string = !in_string;
            continue;
        }
        if in_string {
            continue;
        }
        match ch {
            '(' => round += 1,
            ')' => round = round.saturating_sub(1),
            '{' => curly += 1,
            '}' => curly = curly.saturating_sub(1),
            '[' => square += 1,
            ']' => square = square.saturating_sub(1),
            ',' | ';' if round == 0 && curly == 0 && square == 0 => {
                args.push(&source[start..index]);
                start = index + ch.len_utf8();
            }
            _ => {}
        }
    }
    args.push(&source[start..]);
    args
}

/// Split a function call on top-level commas. Unlike `Play`, semicolons are
/// part of an MML string argument and never delimit function parameters.
fn split_function_args(source: &str) -> Vec<&str> {
    let mut args = Vec::new();
    let mut start = 0usize;
    let mut round = 0usize;
    let mut curly = 0usize;
    let mut square = 0usize;

    for (index, ch) in source.char_indices() {
        match ch {
            '(' => round += 1,
            ')' => round = round.saturating_sub(1),
            '{' => curly += 1,
            '}' => curly = curly.saturating_sub(1),
            '[' => square += 1,
            ']' => square = square.saturating_sub(1),
            ',' if round == 0 && curly == 0 && square == 0 => {
                args.push(&source[start..index]);
                start = index + ch.len_utf8();
            }
            _ => {}
        }
    }
    args.push(&source[start..]);
    args
}

/// Split a parenthesised array initializer without collecting more entries
/// than the array can hold. Empty positions are ignored, matching the legacy
/// initializer, and nested commas stay inside their expression or string.
fn split_array_initializer(source: &str, line: usize, max: usize) -> Result<Vec<&str>> {
    let mut args = Vec::new();
    let mut start = 0usize;
    let mut round = 0usize;
    let mut curly = 0usize;
    let mut square = 0usize;

    for (index, ch) in source.char_indices() {
        match ch {
            '(' => round += 1,
            ')' => round = round.saturating_sub(1),
            '{' => curly += 1,
            '}' => curly = curly.saturating_sub(1),
            '[' => square += 1,
            ']' => square = square.saturating_sub(1),
            ',' if round == 0 && curly == 0 && square == 0 => {
                let raw = &source[start..index];
                if !raw.trim().is_empty() {
                    if args.len() >= max {
                        return Err(MmlError::new(
                            line,
                            format!("配列の要素数が上限({max})を超えます"),
                        ));
                    }
                    args.push(raw);
                }
                start = index + ch.len_utf8();
            }
            _ => {}
        }
    }

    let raw = &source[start..];
    if !raw.trim().is_empty() {
        if args.len() >= max {
            return Err(MmlError::new(
                line,
                format!("配列の要素数が上限({max})を超えます"),
            ));
        }
        args.push(raw);
    }
    Ok(args)
}

/// What a `.onNote` list drives.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum OnNoteTarget {
    Velocity,
    Gate,
    Timing,
    Octave,
    Length,
    /// A control change, by controller number.
    ControlChange(u8),
    PitchBend,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
enum NoteModifierKind {
    #[default]
    Normal,
    Holding,
    OnNote,
    OnTime,
    OnCycle,
}

#[derive(Debug, Clone)]
struct NoteModifier {
    kind: NoteModifierKind,
    in_steps: bool,
    values: Vec<i64>,
    next: usize,
    origin: i64,
    delay: i64,
    repeat: bool,
    random: i64,
    range: Option<(i64, i64)>,
    last: i64,
}

impl Default for NoteModifier {
    fn default() -> Self {
        Self {
            kind: NoteModifierKind::Normal,
            in_steps: false,
            values: Vec::new(),
            next: 0,
            origin: 0,
            delay: 0,
            repeat: true,
            random: 0,
            range: None,
            last: 0,
        }
    }
}

impl NoteModifier {
    fn value(&mut self, time: i64, base: i64, rng: &mut Rng) -> i64 {
        let start = self.origin.saturating_add(self.delay);
        let mut value = match self.kind {
            NoteModifierKind::Normal => base,
            NoteModifierKind::Holding => self.last,
            NoteModifierKind::OnNote => {
                if self.values.is_empty() {
                    base
                } else if self.next >= self.values.len() && !self.repeat {
                    self.kind = NoteModifierKind::Holding;
                    self.last
                } else {
                    let value = self.values[self.next % self.values.len()];
                    self.next += 1;
                    self.last = value;
                    value
                }
            }
            NoteModifierKind::OnTime => self.on_time(time, start, base),
            NoteModifierKind::OnCycle => {
                if time < start || self.values.is_empty() {
                    base
                } else if self.values.len() == 1 {
                    self.values[0]
                } else {
                    let len = self.values[0];
                    let step = if len == 0 { 0 } else { (time - start) / len };
                    self.values[1 + step.rem_euclid((self.values.len() - 1) as i64) as usize]
                }
            }
        };
        if self.random > 0 {
            value = value - self.random / 2 + rng.range(0, self.random - 1);
        }
        if let Some((low, high)) = self.range {
            value = value.max(low).min(high);
        }
        value
    }

    fn on_time(&mut self, time: i64, start: i64, base: i64) -> i64 {
        if time < start || self.values.is_empty() {
            return base;
        }
        let total: i64 = self.values.chunks(3).map(|part| part[2]).sum();
        if total <= 0 {
            return self.values.last().copied().unwrap_or(base);
        }
        let elapsed = time - start;
        if !self.repeat && elapsed > total {
            self.last = self.values[self.values.len() - 2];
            return self.last;
        }
        let position = if self.repeat {
            let wrapped = elapsed.rem_euclid(total);
            if elapsed > 0 && wrapped == 0 {
                total
            } else {
                wrapped
            }
        } else {
            elapsed
        };
        let mut segment_start = 0;
        for part in self.values.chunks(3) {
            let (low, high, len) = (part[0], part[1], part[2]);
            let segment_end = segment_start + len;
            if position <= segment_end {
                if len == 0 {
                    return low;
                }
                return low
                    + ((position - segment_start) as f64 * (high - low) as f64 / len as f64)
                        as i64;
            }
            self.last = high;
            segment_start = segment_end;
        }
        self.last
    }
}

/// Index of a note letter in the key-flag table (c d e f g a b).
fn pitch_class_index(ch: char) -> Option<usize> {
    match ch.to_ascii_lowercase() {
        'c' => Some(0),
        'd' => Some(1),
        'e' => Some(2),
        'f' => Some(3),
        'g' => Some(4),
        'a' => Some(5),
        'b' => Some(6),
        _ => None,
    }
}

/// Semitone offset of each note letter from C.
fn pitch_class_semitone(index: usize) -> i64 {
    [0, 2, 4, 5, 7, 9, 11][index]
}

/// Guard against a runaway `For`/`While`: an MML typo should be an error, not
/// a hung browser tab.
const MAX_ITERATIONS: u32 = 100_000;

/// Loaded automatically before every compile, when the resolver has it.
pub const STANDARD_INCLUDE: &str = "stdmsg.h";

/// Reported by the `VERSION` function, matching the Pascal build's numbering.
const VERSION_NUMBER: i64 = 2385;

/// Functions the compiler provides itself.
fn is_builtin_function(name: &str) -> bool {
    matches!(
        name,
        "Random"
            | "RandomSelect"
            | "Step"
            | "STEP"
            | "StrToLen"
            | "SizeOf"
            | "StrToNum"
            | "HEX"
            | "MID"
            | "POS"
            | "POSX"
            | "Replace"
            | "VarType"
            | "ArraySortNum"
            | "ArraySortStr"
            | "NoteNo"
            | "MML"
            | "#STR"
            | "ASC"
            | "CHR"
            | "VERSION"
            | "Time"
            | "System.GetKeyFlag"
    )
}

fn parse_legacy_integer(text: &str) -> Option<i64> {
    if let Some(hex) = text.strip_prefix('$') {
        i64::from_str_radix(hex, 16).ok()
    } else {
        text.parse().ok()
    }
}

fn format_legacy_hex(value: i64) -> String {
    format!("${value:02X}")
}

/// Pascal's JCopy uses 1-based character positions, with the historical
/// consequence that index 0 and count 2 select only the first character.
fn legacy_mid(text: &str, index: i64, count: i64) -> String {
    if count <= 0 {
        return String::new();
    }
    let first = index.max(1);
    let last = index.saturating_add(count - 1);
    text.chars()
        .enumerate()
        .filter_map(|(offset, ch)| {
            let position = offset as i64 + 1;
            (first <= position && position <= last).then_some(ch)
        })
        .collect()
}

/// Return a 1-based character position, or zero when not found.
fn string_position(needle: &str, text: &str, start: i64) -> i64 {
    if needle.is_empty() || text.is_empty() {
        return 0;
    }
    let start = start.max(1) as usize;
    let Some((byte_start, _)) = text.char_indices().nth(start - 1) else {
        return 0;
    };
    let Some(relative) = text[byte_start..].find(needle) else {
        return 0;
    };
    text[..byte_start + relative].chars().count() as i64 + 1
}

/// Variables the compiler defines itself. `mml_base.pas` registers exactly
/// these three (`SoundType`, `on`, `off`); everything else must be declared,
/// so a bare `x=5` stays an error here as it is in the Pascal build.
fn builtin_variables() -> Variables {
    let mut variables = Variables::new();
    // 0:GM / 1:GS / 2:XG — set by the reset macros in Include/stdmsg.h.
    variables.insert("SoundType".to_string(), Value::Int(0));
    variables.insert("on".to_string(), Value::Int(1));
    variables.insert("off".to_string(), Value::Int(0));
    variables
}

/// `PlayFrom`/`PlayTo`'s settings, applied once after the whole song is
/// compiled. Defaults match `TSmfPlayFrom.Create` in `smf_types.pas`
/// (`FromPos`/`ToPos` at -1 mean "unset").
#[derive(Debug, Clone)]
struct PlayFromSpec {
    from_pos: i64,
    to_pos: i64,
    wait_time: i64,
    sysex: bool,
    /// Reconstruct selected RPN/NRPN values at the PlayFrom cut point.
    rpn_nrpn: bool,
}

impl Default for PlayFromSpec {
    fn default() -> Self {
        Self {
            from_pos: -1,
            to_pos: -1,
            wait_time: 192,
            sysex: false,
            rpn_nrpn: true,
        }
    }
}

/// Where a function's return value lives while it runs. `Result` is a
/// keyword, so it cannot collide with a user variable name.
const RESULT_VAR: &str = "\u{0}Result";

/// A user-defined `Function`: its parameters and its body, kept as source so
/// each call re-runs it in the caller's musical context.
#[derive(Debug, Clone)]
struct FunctionDef {
    params: Vec<Param>,
    body: String,
    line: usize,
}

#[derive(Debug, Clone)]
struct Param {
    name: String,
    kind: VarKind,
    default: Option<Value>,
}

/// Which kind of variable a declaration creates.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum VarKind {
    Int,
    Str,
    Array,
}

/// Named control changes and their controller numbers, measured from the
/// Pascal build (`M(10)` writes `b0 01 0a`, and so on).
fn control_change_number(name: &str) -> Option<i64> {
    Some(match name {
        "Modulation" | "M" => 1,
        "PortamentoTime" | "PT" => 5,
        "DataMSB" | "Y" => 6,
        "MainVolume" | "V" => 7,
        "Panpot" | "P" => 10,
        "Expression" | "EP" => 11,
        "PortamentoSwitch" | "PS" => 65,
        "Reverb" | "REV" => 91,
        "Chorus" | "CHO" => 93,
        "Variation" | "VAR" => 94,
        "DataLSB" => 38,
        _ => return None,
    })
}

/// Split a `Switch` body into `Case(condition){body}` and `Default{body}`
/// arms. The body has already been balanced by `read_block`; this scanner
/// only needs to recognize top-level keywords and their nested delimiters.
fn parse_switch_arms(source: &str, line: usize) -> Result<Vec<(Option<String>, String)>> {
    let mut cursor = Cursor::with_line(source, line);
    let mut arms = Vec::new();
    while !cursor.is_eof() {
        cursor.skip_trivia();
        if cursor.is_eof() {
            break;
        }
        let name = cursor.read_word().ok_or_else(|| {
            MmlError::new(
                cursor.line(),
                "Switch内にはCaseまたはDefaultを指定してください",
            )
        })?;
        match name.as_str() {
            "Case" | "CASE" => {
                cursor.skip_trivia();
                if !cursor.eat('(') {
                    return Err(MmlError::new(
                        cursor.line(),
                        "Caseには(condition)が必要です",
                    ));
                }
                let condition = cursor
                    .read_balanced('(', ')')
                    .ok_or_else(|| MmlError::new(cursor.line(), "Caseの括弧が閉じていません"))?;
                cursor.skip_trivia();
                if !cursor.eat('{') {
                    return Err(MmlError::new(cursor.line(), "Caseには{...}が必要です"));
                }
                let body = cursor.read_balanced('{', '}').ok_or_else(|| {
                    MmlError::new(cursor.line(), "Caseのブロックが閉じていません")
                })?;
                arms.push((Some(condition), body));
            }
            "Default" | "DEFAULT" => {
                cursor.skip_trivia();
                if !cursor.eat('{') {
                    return Err(MmlError::new(cursor.line(), "Defaultには{...}が必要です"));
                }
                let body = cursor.read_balanced('{', '}').ok_or_else(|| {
                    MmlError::new(cursor.line(), "Defaultのブロックが閉じていません")
                })?;
                arms.push((None, body));
            }
            _ => {
                return Err(MmlError::new(
                    cursor.line(),
                    "Switch内にはCaseまたはDefaultを指定してください",
                ));
            }
        }
    }
    Ok(arms)
}

/// Split a loop body at a top-level `:`.
///
/// The part before it runs on every pass; the part after runs on every pass
/// but the last, so `[3 c:d]` plays `c d c d c`.
fn split_loop_break(body: &str) -> (&str, Option<&str>) {
    let mut depth = 0i32;
    let mut in_string = false;
    let mut previous = ' ';
    for (index, ch) in body.char_indices() {
        let was_string_start = previous == '{' && ch == '"';
        previous = ch;
        match ch {
            // Strings start at `{"`; a bare `"` is the octave-down operator.
            '"' if was_string_start => in_string = true,
            '"' if in_string => in_string = false,
            _ if in_string => {}
            '[' | '{' | '(' => depth += 1,
            ']' | '}' | ')' => depth -= 1,
            ':' if depth == 0 => return (&body[..index], Some(&body[index + 1..])),
            _ => {}
        }
    }
    (body, None)
}

#[derive(Debug, Default, Clone, Copy)]
struct NoteOptions {
    gate_percent: Option<i64>,
    /// The gate was written `%n`, so it is a tick count.
    gate_in_steps: bool,
    velocity: Option<i64>,
    timing: Option<i64>,
    octave: Option<i64>,
}

/// Sounding length for a note: `trunc(length * q / 100) - 1`, at least 1 tick.
///
/// The `- 1` and the floor are not arbitrary — they reproduce the Pascal
/// output exactly (`q80 l4` at timebase 96 gives 75, not 76 or 77).
#[cfg(test)]
fn gate_ticks(length: i64, gate_percent: i64) -> i64 {
    gate_ticks_scaled(length, gate_percent, 100)
}

/// As [`gate_ticks`], but with `q` measured against `System.qMax` instead of
/// 100 — `System.qMax=8; q8` is a full-length note, for old MML dialects.
fn gate_ticks_scaled(length: i64, gate_value: i64, q_max: i64) -> i64 {
    // Saturating, not wrapping: an absurd length is caught downstream by the
    // time check, and must not overflow on the way there.
    let gate = length.saturating_mul(gate_value) / q_max.max(1) - 1;
    gate.max(1)
}

/// Scale `v` against `System.vMax`. With the default 127 this is the identity;
/// `System.vMax=15` maps v15 to 120, matching the Pascal build.
fn scale_velocity(velocity: i64, v_max: i64) -> u8 {
    let factor = 128 / v_max.max(1);
    velocity.saturating_mul(factor).clamp(0, 127) as u8
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn gate_matches_measured_pascal_values() {
        assert_eq!(gate_ticks(96, 80), 75);
        assert_eq!(gate_ticks(96, 100), 95);
        assert_eq!(gate_ticks(96, 50), 47);
        assert_eq!(gate_ticks(96, 33), 30);
        assert_eq!(gate_ticks(48, 80), 37);
        assert_eq!(gate_ticks(96, 1), 1); // clamped, not 0 or -1
    }

    #[test]
    fn default_channel_follows_track_number() {
        assert_eq!(default_channel(1), 0);
        assert_eq!(default_channel(2), 1);
        assert_eq!(default_channel(16), 15);
        assert_eq!(default_channel(99), 15);
    }

    #[test]
    fn array_initializer_limit_accepts_the_boundary_and_rejects_one_more() {
        let items = split_array_initializer("0,(1+2),,{a,b}", 1, 3).unwrap();
        assert_eq!(items, ["0", "(1+2)", "{a,b}"]);

        let error = split_array_initializer("0,(1+2),,{a,b},4", 1, 3).unwrap_err();
        assert!(error.message.contains("上限(3)"));
    }

    #[test]
    fn slur_reservation_respects_the_event_budget() {
        let mut compiler = Compiler::new();
        compiler.event_count = MAX_EVENTS - 1;
        let error = compiler.reserve_slur_note(7).unwrap_err();
        assert_eq!(error.line, 7);
        assert!(error.message.contains(&format!("上限({MAX_EVENTS})")));
        assert_eq!(compiler.buffered_slur_events, 0);
        assert!(compiler.stop_requested);
    }

    #[test]
    fn play_from_rebuild_checks_the_final_event_budget_before_allocating() {
        let error = Compiler::ensure_play_from_event_capacity(MAX_EVENTS + 1).unwrap_err();
        assert!(error.message.contains(&format!("上限({MAX_EVENTS})")));
    }

    #[test]
    fn closing_slur_checks_its_complete_event_cost_atomically() {
        let mut compiler = Compiler::new();
        compiler.event_count = MAX_EVENTS - 2;
        compiler.buffered_slur_events = 2;
        compiler.track().slur_notes.push(SlurNote {
            start: 0,
            off: 75,
            note: 60,
            velocity: 100,
            transition: None,
        });
        let error = compiler
            .handle_slur_note(
                SlurNote {
                    start: 96,
                    off: 171,
                    note: 84,
                    velocity: 100,
                    transition: None,
                },
                false,
                0,
            )
            .unwrap_err();
        assert!(error.message.contains(&format!("上限({MAX_EVENTS})")));
        assert!(compiler.track().events.is_empty());
        assert_eq!(compiler.buffered_slur_events, 0);
    }

    #[test]
    fn wide_slur_releases_only_its_own_reservation() {
        let mut compiler = Compiler::new();
        compiler.buffered_slur_events = 4;
        compiler.track().slur_notes.push(SlurNote {
            start: 0,
            off: 75,
            note: 60,
            velocity: 100,
            transition: None,
        });
        compiler
            .handle_slur_note(
                SlurNote {
                    start: 96,
                    off: 171,
                    note: 84,
                    velocity: 100,
                    transition: None,
                },
                false,
                0,
            )
            .unwrap();
        assert_eq!(compiler.buffered_slur_events, 2);
    }
}
