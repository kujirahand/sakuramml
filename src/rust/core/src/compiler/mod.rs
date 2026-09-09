//! Command dispatch and musical state.
//!
//! Phase 1 scope: notes, rests, ties, octave/length/velocity/gate attributes,
//! track & channel selection, tempo, timebase and the text meta events.
//! Everything here mirrors byte-for-byte behaviour measured from the Pascal
//! build (see `tests/golden.rs`).

pub mod advance;

use std::collections::BTreeMap;

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

/// Ceiling on a track's time pointer, so time arithmetic cannot run away
/// before the SMF writer would reject the delta anyway.
pub const MAX_TIME: i64 = crate::smf::MAX_VAR_LEN;

/// Maximum nesting depth for loops and other recursive constructs.
/// Matches `NestCountCompile` in the Pascal implementation, and keeps the
/// WASM stack out of trouble.
pub const MAX_NEST: usize = 128;

/// What a compile produced, before serialisation.
pub struct CompileResult {
    pub song: Song,
    pub warnings: Vec<Warning>,
    /// Output of `Print(...)` statements, in order.
    pub messages: Vec<String>,
}

/// Per-track musical state.
#[derive(Debug, Clone)]
struct TrackState {
    channel: u8,
    time: i64,
    octave: i64,
    length: i64,
    velocity: i64,
    gate_percent: i64,
    timing: i64,
    events: Vec<Event>,
    /// Time at which the most recent note ended, so `^` can extend it.
    last_note: Option<LastNote>,
    /// One-shot octave shift from `` ` `` or `"`, applied to the next note.
    octave_once: i64,
    /// `q%n` gives the gate in ticks rather than as a percentage.
    gate_in_steps: bool,
    /// The voice last selected with `@`, for `MML(@)`.
    voice: i64,
    /// Values queued by `.onNote`, cycled one per note.
    on_note: Vec<(OnNoteTarget, OnNote)>,
    /// Advance specifications attached to control changes and bends.
    cc_modifiers: Vec<CcModifier>,
    /// Set once any event is recorded, so a track PlayFrom trims to empty is
    /// still written out (an empty MTrk), matching the Pascal build.
    used: bool,
    /// `.Random` spread per note attribute.
    random: Vec<(OnNoteTarget, i64)>,
}

#[derive(Debug, Clone, Copy)]
struct LastNote {
    /// Index into `events` of the note-off to move when a tie extends it.
    off_index: usize,
    start: i64,
}

impl TrackState {
    fn new(track_no: i64, timebase: i64) -> Self {
        Self {
            channel: default_channel(track_no),
            time: 0,
            octave: 5,
            length: timebase, // l4 at the default timebase
            velocity: 100,
            gate_percent: 80,
            timing: 0,
            events: Vec::new(),
            last_note: None,
            octave_once: 0,
            gate_in_steps: false,
            voice: 1,
            on_note: Vec::new(),
            cc_modifiers: Vec::new(),
            random: Vec::new(),
            used: false,
        }
    }
}

/// Track number `n` defaults to MIDI channel `n - 1`.
fn default_channel(track_no: i64) -> u8 {
    (track_no - 1).clamp(0, 15) as u8
}

pub struct Compiler<'a> {
    includes: &'a dyn IncludeResolver,
    timebase: i64,
    tracks: BTreeMap<i64, TrackState>,
    current: i64,
    warnings: Vec<Warning>,
    depth: usize,
    variables: Variables,
    functions: BTreeMap<String, FunctionDef>,
    /// Sharps/flats applied per pitch class (c d e f g a b), from `KeyFlag`.
    key_flags: [i64; 7],
    /// Global transpose, in semitones (`System.Keyshift`).
    key_shift: i64,
    /// Value of `q` that means 100% gate (`System.qMax`).
    q_max: i64,
    /// Value of `v` that means full velocity (`System.vMax`).
    v_max: i64,
    /// Offset applied to measure numbers in `Time` (`System.MeasureShift`).
    measure_shift: i64,
    /// Time signature, used to turn `Time(m:b:t)` into ticks.
    time_signature: (i64, i64),
    /// Output of `Print(...)`, handed back to the caller instead of printed.
    messages: Vec<String>,
    /// Set by `Exit` to unwind out of the enclosing loop.
    exiting: bool,
    rng: Rng,
    /// Events written so far, against [`MAX_EVENTS`].
    event_count: usize,
    play_from: PlayFromSpec,
    /// While writing a chord, the time every note in it starts at.
    chord_start: Option<i64>,
    /// `.Frequency` — how often a ramp writes, in ticks.
    cc_frequency: i64,
    /// Single-character drum macros, from `$c{...}`.
    rythm_macros: rythm::Macros,
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
            tracks: BTreeMap::new(),
            current: 1,
            warnings: Vec::new(),
            depth: 0,
            variables: builtin_variables(),
            functions: BTreeMap::new(),
            key_flags: [0; 7],
            key_shift: 0,
            q_max: 100,
            v_max: 127,
            measure_shift: 0,
            time_signature: (4, 4),
            messages: Vec::new(),
            exiting: false,
            rng: Rng::default(),
            event_count: 0,
            play_from: PlayFromSpec::default(),
            chord_start: None,
            cc_frequency: advance_spec::DEFAULT_FREQUENCY,
            rythm_macros: rythm::Macros::new(),
            sutoton_macros: crate::lexer::sutoton::UserMacros::new(),
        }
    }

    /// Supply the resolver used for `#Include`.
    pub fn with_includes(mut self, resolver: &'a dyn IncludeResolver) -> Self {
        self.includes = resolver;
        self
    }

    pub fn warnings(&self) -> &[Warning] {
        &self.warnings
    }

    fn track(&mut self) -> &mut TrackState {
        let timebase = self.timebase;
        let no = self.current;
        self.tracks
            .entry(no)
            .or_insert_with(|| TrackState::new(no, timebase))
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
        self.apply_play_from();

        let mut song = Song::new(self.timebase as u16);
        for state in self.tracks.into_values() {
            // A track PlayFrom trimmed to nothing is still written out (an
            // empty MTrk), the same way the Pascal build does: it was used,
            // even though nothing survived the cut.
            if !state.used {
                continue;
            }
            song.tracks.push(Track {
                events: state.events,
                end_time: state.time,
            });
        }
        Ok(CompileResult {
            song,
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
    /// Not reproduced: RPN/NRPN reconstruction at the cut point (rare, and
    /// no sample song exercises it — see spec/10-compatibility.md).
    fn apply_play_from(&mut self) {
        let from_pos = self.play_from.from_pos;
        let to_pos = self.play_from.to_pos;
        // The Pascal build only runs any of this when one bound is set.
        if from_pos <= 0 && to_pos <= 0 {
            return;
        }
        let wait_time = self.play_from.wait_time;
        let sysex = self.play_from.sysex;

        for track in self.tracks.values_mut() {
            track.events.sort_by_key(|e| e.time);

            // PlayTo: drop the trailing run at or after `to_pos`.
            if to_pos > 0 {
                while matches!(track.events.last(), Some(e) if e.time >= to_pos) {
                    track.events.pop();
                }
            }

            // Reconstruct the state in effect just before `from_pos`, so
            // notes that survive the cut still sound with the right voice,
            // controller values and tempo.
            let mut cc = [None; 128];
            let mut pitch_bend: i64 = 0;
            let mut program: Option<u8> = None;
            let mut tempo: Option<u32> = None;
            let mut channel = track.channel;
            for event in &track.events {
                if event.time >= from_pos {
                    break;
                }
                match event.data.first().map(|b| b & 0xf0) {
                    Some(0xb0) => {
                        if let (Some(&no), Some(&value)) = (event.data.get(1), event.data.get(2)) {
                            cc[no as usize] = Some(value);
                            channel = event.data[0] & 0x0f;
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

            // Discard what falls before the cut (keeping non-tempo meta at
            // time 0, and SysEx at an incrementing slot if `.SysEx(1)` asked
            // for it), and shift the rest back by the cut point.
            let mut pre_effect = 0i64;
            let mut rebuilt = Vec::with_capacity(track.events.len());
            for event in track.events.drain(..) {
                if event.time < from_pos {
                    let status = event.data.first().copied();
                    if status == Some(0xf0) && sysex {
                        rebuilt.push(Event::new(pre_effect, event.data));
                        pre_effect += 1;
                    } else if status == Some(0xff) && event.data.get(1) != Some(&0x51) {
                        rebuilt.push(Event::new(0, event.data));
                    }
                    // Anything else before the cut is dropped: ordinary
                    // events, and the tempo meta (reconstructed below).
                } else {
                    let shifted = (event.time - from_pos + wait_time).max(0);
                    rebuilt.push(Event::new(shifted, event.data));
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
    }

    /// Record an event on the current track, against the compile's budget.
    fn push_event(&mut self, event: Event) -> Result<()> {
        self.event_count += 1;
        if self.event_count > MAX_EVENTS {
            return Err(MmlError::new(
                0,
                format!("生成イベント数が上限({MAX_EVENTS})を超えました"),
            ));
        }
        let track = self.track();
        track.used = true;
        track.events.push(event);
        Ok(())
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
            if cur.is_eof() || self.exiting {
                break;
            }
            self.step(cur)?;
        }
        Ok(())
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
                    let args = self.read_call_args(cur)?;
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
                let value = self.expect_int(cur, "o")?;
                self.track().octave = value;
                Ok(())
            }
            'l' => {
                cur.advance();
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Length)? {
                    return Ok(handled);
                }
                let value = self
                    .read_length(cur)
                    .ok_or_else(|| MmlError::new(line, "lコマンドには音長を指定してください"))?;
                self.track().length = value;
                Ok(())
            }
            'q' => {
                cur.advance();
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Gate)? {
                    return Ok(handled);
                }
                // `q%n` gives the gate in ticks; a later plain `q` goes back
                // to reading it as a percentage.
                let in_steps = cur.peek() == Some('%');
                if in_steps {
                    cur.advance();
                }
                let value = self.expect_int(cur, "q")?;
                let track = self.track();
                track.gate_in_steps = in_steps;
                track.gate_percent = value;
                Ok(())
            }
            'v' => {
                cur.advance();
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Velocity)? {
                    return Ok(handled);
                }
                let value = self.expect_int(cur, "v")?;
                self.track().velocity = value;
                Ok(())
            }
            't' => {
                cur.advance();
                if let Some(handled) = self.modifier(cur, OnNoteTarget::Timing)? {
                    return Ok(handled);
                }
                let value = self.expect_int(cur, "t")?;
                self.track().timing = value;
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
                self.track().octave += 1;
                Ok(())
            }
            '<' => {
                cur.advance();
                self.track().octave -= 1;
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
            let args = self.read_call_args(cur)?;
            self.call_function(&word, args, line)?;
            return Ok(());
        }
        if !word.starts_with('#') && matches!(self.variables.get(&word), Some(Value::Str(_))) {
            let name = word.clone();
            return self.string_variable(cur, &name, line);
        }

        match word.as_str() {
            "Tempo" | "TEMPO" | "TempoChange" => {
                let bpm = self.expect_int_arg(cur, &word)?;
                if bpm <= 0 {
                    return Err(MmlError::new(line, "テンポには正の値を指定してください"));
                }
                let usec = (60_000_000 / bpm) as u32;
                let time = self.track().time;
                self.push_event(Event::tempo(time, usec))
            }
            "Track" | "TRACK" | "TR" | "NowTrack" => {
                let no = self.expect_int_arg(cur, &word)?;
                self.current = no;
                let timebase = self.timebase;
                self.tracks
                    .entry(no)
                    .or_insert_with(|| TrackState::new(no, timebase));
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
            "PlayFrom" => self.play_from_command(cur, line),
            "PlayTo" => self.play_to_command(cur, line),
            "Cresc" | "CRESC" => self.cresc(cur, 40, 127, line),
            "Decresc" | "DECRESC" => self.cresc(cur, 127, 40, line),
            "Rythm" | "RYTHM" | "Rhythm" | "RHYTHM" => self.rythm(cur),
            "Sub" | "SUB" | "S" => self.sub(cur),
            "TimeSignature" => self.time_signature(cur),
            "KeyFlag" => self.key_flag(cur),
            "Keyshift" | "KeyShift" => {
                self.key_shift = self.expect_int_arg(cur, &word)?;
                Ok(())
            }
            "Key" | "KEY" => {
                self.key_shift = self.expect_int_arg(cur, &word)?;
                Ok(())
            }
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
            "SysEx" | "SYSEX" => self.sysex(cur),
            "DirectSMF" => self.direct_smf(cur),
            "Voice" => self.voice(cur),
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
                let args = self.read_call_args(cur)?;
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

            cur.skip_spaces();
            // "Int x" — the first word was the type, so the next is the name.
            if let Some(second) = cur.read_word() {
                name = second;
                cur.skip_spaces();
            }

            let default = if cur.eat('=') {
                Some(expr::eval(&mut cur, self)?)
            } else {
                None
            };
            params.push(Param { name, default });
        }
        Ok(params)
    }

    /// Read the arguments of a call in statement position: `f`, `f()`, `f(1,2)`.
    fn read_call_args(&mut self, cur: &mut Cursor) -> Result<Vec<Value>> {
        cur.skip_spaces();
        if !cur.eat('(') {
            return Ok(Vec::new());
        }
        let mut args = Vec::new();
        cur.skip_spaces();
        if cur.eat(')') {
            return Ok(args);
        }
        loop {
            args.push(expr::eval(cur, self)?);
            cur.skip_spaces();
            if cur.eat(',') {
                continue;
            }
            if !cur.eat(')') {
                return Err(MmlError::new(
                    cur.line(),
                    "関数呼び出しの括弧が閉じられていません",
                ));
            }
            return Ok(args);
        }
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
                _ => Value::Int(0),
            },
            "StrToNum" => Value::Int(
                args.first()
                    .map(|v| v.as_int(line))
                    .transpose()?
                    .unwrap_or(0),
            ),
            "HEX" => Value::Str(format!("{:X}", int_arg(0)?)),
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
            "VERSION" => Value::Int(VERSION_NUMBER),
            // `NoteNo(o4c)` reads a note the way the compiler would and gives
            // back its MIDI number, without playing it.
            "NoteNo" => {
                let text = args.first().map(|v| v.as_str()).unwrap_or_default();
                Value::Int(self.note_number_of(&text))
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
            _ => return Err(MmlError::new(line, format!("関数\"{name}\"は未定義です"))),
        };
        Ok(Some(value))
    }

    /// The MIDI note number a fragment of MML would play, starting from the
    /// track's current octave. Used by `NoteNo(...)`.
    fn note_number_of(&mut self, text: &str) -> i64 {
        let mut octave = self.track().octave;
        let mut chars = text.chars().peekable();
        let mut note: Option<i64> = None;
        let mut accidental = 0;

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
                '>' => octave += 1,
                '<' => octave -= 1,
                '+' | '#' if note.is_some() => accidental += 1,
                '-' if note.is_some() => accidental -= 1,
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
                        return value;
                    }
                }
                c => {
                    if let Some(class) = pitch_class_index(c) {
                        note = Some(pitch_class_semitone(class));
                    }
                }
            }
        }
        octave * 12 + note.unwrap_or(0) + accidental
    }

    /// What a command is currently set to, for `MML(...)`.
    fn command_value(&mut self, name: &str, line: usize) -> Result<i64> {
        let key_shift = self.key_shift;
        let track = self.track();
        Ok(match name.trim() {
            "l" => track.length,
            "v" => track.velocity,
            "o" => track.octave,
            "q" => track.gate_percent,
            "t" => track.timing,
            "@" => track.voice,
            "Key" | "TimeKey" => key_shift,
            other => return Err(MmlError::new(line, format!("MML({other})は取得できません"))),
        })
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
                OnNoteTarget::Gate => self.q_max = value.max(1),
                OnNoteTarget::Velocity => self.v_max = value.max(1),
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
                let value = self.expect_int_arg(cur, name)?;
                self.cc_modifier_entry(no).delay = value;
            }
            "Repeat" => {
                let value = self.expect_int_arg(cur, name)?;
                let modifier = self.cc_modifier_entry(no);
                modifier.repeat = value != 0;
                modifier.index = 0;
            }
            "Random" => {
                let value = self.expect_int_arg(cur, name)?;
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
            "onNote" | "N" => {
                let values = self.read_args(cur, usize::MAX)?;
                let track = self.track();
                track.on_note.retain(|(existing, _)| *existing != target);
                track.on_note.push((target, OnNote { values, next: 0 }));
                Ok(Some(()))
            }
            "Random" => {
                let value = self.expect_int_arg(cur, name)?;
                let track = self.track();
                track.random.retain(|(existing, _)| *existing != target);
                track.random.push((target, value));
                Ok(Some(()))
            }
            other => {
                // Note attributes have no meaningful ramp over time here yet.
                let _ = self.read_args(cur, 16)?;
                self.warnings.push(Warning::new(
                    line,
                    format!(".{other} は音符属性では未実装のため無視しました"),
                ));
                Ok(Some(()))
            }
        }
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

        let channel = self.track().channel;
        for (time, value) in events {
            let value = advance_spec::clamp_for(no, value);
            let event = match no {
                advance_spec::BEND_FULL | advance_spec::BEND_EASY => {
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
        if !(0..=127).contains(&no) {
            return;
        }
        let channel = self.track().channel;
        let status = 0xb0 | (channel & 0x0f);
        self.track().events.retain(|event| {
            !(event.time >= time
                && event.data.first() == Some(&status)
                && event.data.get(1) == Some(&(no as u8)))
        });
    }

    /// Apply the `.Random` spread for a target, if one was set.
    fn spread(&mut self, target: OnNoteTarget, value: i64) -> i64 {
        let amount = self
            .track()
            .random
            .iter()
            .find(|(existing, _)| *existing == target)
            .map(|(_, amount)| *amount)
            .unwrap_or(0);
        if amount <= 0 {
            return value;
        }
        value - amount / 2 + self.rng.range(0, amount - 1)
    }

    /// Take the next `.onNote` value for `target`, if a list is running.
    fn next_on_note(&mut self, target: OnNoteTarget) -> Option<i64> {
        let track = self.track();
        track
            .on_note
            .iter_mut()
            .find(|(existing, _)| *existing == target)
            .and_then(|(_, list)| list.take())
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
        self.run_fragment(&expanded, line)
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
        let contents = match self.variables.get(name) {
            Some(value) => value.as_str(),
            None => return Ok(()),
        };
        if contents.is_empty() {
            return Ok(());
        }
        let expanded = self.preprocess(&contents);
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
        cur.skip_spaces();
        let length = self.read_length(cur);

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
        let end = self.checked_time(start, length, line)?;
        let track = self.track();
        track.length = previous_length;
        track.time = end;
        track.last_note = None;
        outcome
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
                .or_insert_with(|| TrackState::new(track_no as i64, timebase));
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
                // Parsed for compatibility; the Pascal build never actually
                // reads this field either (a dead option there too).
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
            "RandomSeed" => {
                let seed = self.expect_int_arg(cur, name)?;
                self.rng.reseed(seed);
                Ok(())
            }
            "MeasureShift" => {
                self.measure_shift = self.expect_int_arg(cur, name)?;
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

    /// `TimeSignature=n,d` — also recorded, since `Time` is measured in bars.
    fn time_signature(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let args = self.read_args(cur, 2)?;
        if args.len() < 2 {
            return Err(MmlError::new(line, "拍子は 分子,分母 で指定してください"));
        }
        let (numerator, denominator) = (args[0].max(1), args[1].max(1));
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
        let name = cur
            .read_word()
            .ok_or_else(|| MmlError::new(line, "変数名を指定してください"))?;

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
                let items = self.read_args(cur, usize::MAX)?;
                self.variables.insert(name, Value::Array(items));
                return Ok(());
            }
            self.assign(cur, &name)?;
        }
        Ok(())
    }

    /// `name = <value>` where the value is a literal, a `{"string"}` or a
    /// parenthesised expression; also `name++` and `name--`.
    fn assign(&mut self, cur: &mut Cursor, name: &str) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();

        // `I++` and `I--` step a variable by one.
        for (sign, step) in [('+', 1), ('-', -1)] {
            if cur.peek() == Some(sign) && cur.peek_at(1) == Some(sign) {
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
            return Ok(()); // a bare mention of a variable does nothing
        }
        let value = self.read_value(cur)?;
        self.variables.insert(name.to_string(), value);
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

        let mut values: Vec<i64> = Vec::new();
        loop {
            cur.skip_spaces();
            let value = if hex_mode {
                // Even in hex mode a parenthesised value is an ordinary
                // expression, as in stdmsg.h's
                // `SysEx$=F0,41,(DeviceNumber),42,...`.
                if cur.peek() == Some('(') {
                    let line = cur.line();
                    Some(expr::eval(cur, self)?.as_int(line)?)
                } else {
                    // A `$` prefix is allowed here but redundant.
                    cur.eat('$');
                    cur.read_hex()
                }
            } else {
                self.read_number(cur)?
            };
            let Some(value) = value else { break };
            values.push(value);
            cur.skip_spaces();
            if !cur.eat(',') {
                break;
            }
        }
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
        if let Some(&msb) = args.get(1) {
            self.write_cc(0, msb);
        }
        if let Some(&lsb) = args.get(2) {
            self.write_cc(32, lsb);
        }
        self.track().voice = voice;
        let program = (voice - 1).clamp(0, 127) as u8;
        let (time, channel) = {
            let track = self.track();
            (track.time, track.channel)
        };
        self.push_event(Event::program_change(time, channel, program))
    }

    /// `y(n),(value)` — write a control change by number.
    fn control_change_direct(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
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
            let value = self.expect_int(cur, "p%")?;
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
        let (time, channel) = {
            let track = self.track();
            (track.time, track.channel)
        };
        let _ = self.push_event(Event::new(time, vec![0xe0 | (channel & 0x0f), lsb, msb]));
    }

    fn write_cc(&mut self, controller: i64, value: i64) {
        let (time, channel) = {
            let track = self.track();
            (track.time, track.channel)
        };
        let controller = controller.clamp(0, 127) as u8;
        let value = value.clamp(0, 127) as u8;
        let _ = self.push_event(Event::control_change(time, channel, controller, value));
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
            } else if parenthesised && cur.peek() == Some('!') {
                self.read_number(cur)?
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
        let text = self.read_text_value(cur, line)?;
        let (bytes, warnings) = encode_cp932(&text, line);
        self.warnings.extend(warnings);
        let time = self.track().time;
        self.track()
            .events
            .push(Event::meta(time, meta_type, &bytes));
        Ok(())
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
        let closing = match cur.peek() {
            Some('{') => {
                cur.advance();
                '}'
            }
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

        let mut accidental = 0;
        let mut explicit = false;
        while let Some(sign) = cur.eat_any(&['+', '-', '#']) {
            accidental += if sign == '-' { -1 } else { 1 };
            explicit = true;
        }
        // An explicit accidental overrides the key signature.
        if !explicit {
            accidental = self.key_flags[class];
        }

        let (length, options) = self.read_note_options(cur)?;
        let octave = {
            let track = self.track();
            options.octave.unwrap_or(track.octave) + std::mem::take(&mut track.octave_once)
        };
        let note_no = octave * 12 + base + accidental + self.key_shift;
        self.write_note(note_no, length, options, line)
    }

    fn note_number(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        // Keep the underlying error: it says which variable or expression
        // failed, which is more useful than "n needs a note number".
        let note_no = self.expect_int_arg(cur, "nコマンドのノート番号")?;
        // `n60,` — the Pascal syntax allows a comma before the options.
        cur.eat(',');
        let (length, options) = self.read_note_options(cur)?;
        self.write_note(note_no + self.key_shift, length, options, line)
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
        let (length, _) = self.read_note_options(cur)?;
        let length = length.unwrap_or_else(|| self.track().length);
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
        let (length, _) = self.read_note_options(cur)?;
        let length = length.unwrap_or_else(|| self.track().length);
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

    fn write_note(
        &mut self,
        note_no: i64,
        length: Option<i64>,
        options: NoteOptions,
        line: usize,
    ) -> Result<()> {
        if !(0..=127).contains(&note_no) {
            return Err(MmlError::new(
                line,
                format!("ノート番号が範囲外です(0〜127): {note_no}"),
            ));
        }
        // `.onNote` values are consumed one per note, before the track's own
        // settings are consulted.
        let on_velocity = self.next_on_note(OnNoteTarget::Velocity);
        let on_gate = self.next_on_note(OnNoteTarget::Gate);
        let on_timing = self.next_on_note(OnNoteTarget::Timing);
        let on_length = self.next_on_note(OnNoteTarget::Length);
        let track = self.track();
        let length = on_length.or(length).unwrap_or(track.length);
        let raw_velocity = options.velocity.or(on_velocity).unwrap_or(track.velocity);
        let gate_value = options
            .gate_percent
            .or(on_gate)
            .unwrap_or(track.gate_percent);
        // `.Random` spreads a value either side of what was asked for.
        let raw_velocity = self.spread(OnNoteTarget::Velocity, raw_velocity);
        let gate_value = self.spread(OnNoteTarget::Gate, gate_value);
        let (q_max, v_max) = (self.q_max, self.v_max);
        let velocity = scale_velocity(raw_velocity, v_max);
        let gate = if options.gate_in_steps || self.track().gate_in_steps {
            (gate_value - 1).max(1)
        } else {
            gate_ticks_scaled(length, gate_value, q_max)
        };
        let (time, timing, channel) = {
            let track = self.track();
            (
                track.time,
                options.timing.or(on_timing).unwrap_or(track.timing),
                track.channel,
            )
        };
        // Inside a chord every note starts together.
        let time = self.chord_start.unwrap_or(time);
        let start = self.checked_time(time, timing, line)?;
        let end = self.checked_time(start, gate, line)?;
        let next = self.checked_time(time, length, line)?;

        self.push_event(Event::note_on(start, channel, note_no as u8, velocity))?;
        self.push_event(Event::note_off(end, channel, note_no as u8, velocity))?;
        // Advance specifications run after the note, which is the only point
        // at which its length is known — the Pascal build calls
        // checkNoteOnCC here for the same reason. Values meant to arrive
        // before the note carry an earlier time and sort ahead of it.
        self.write_cc_modifiers(time, length)?;

        let track = self.track();
        track.last_note = Some(LastNote {
            off_index: track.events.len() - 1,
            start,
        });
        // A chord moves the pointer once, when it closes.
        if self.chord_start.is_none() {
            self.track().time = next;
        }
        Ok(())
    }

    /// Note suffixes: a length spec and/or `(l,q,v,t,o)` options.
    fn read_note_options(&mut self, cur: &mut Cursor) -> Result<(Option<i64>, NoteOptions)> {
        let mut options = NoteOptions::default();
        let mut length = self.read_length(cur);

        // The two forms differ, as they do in the Pascal build: `c(4,...)`
        // sets only the length and ignores the rest, while `c4,80,100,0,5`
        // sets length, gate, velocity, timing and octave in turn.
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
        } else {
            let mut index = 1;
            while index <= 4 && cur.eat(',') {
                cur.skip_spaces();
                self.read_note_option(cur, index, &mut length, &mut options)?;
                index += 1;
            }
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
        } else if matches!(cur.peek(), Some(',') | Some(')') | None) {
            None
        } else {
            self.read_number(cur)?
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
        let mut total: Option<i64> = None;
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
                self.read_number(cur).ok().flatten()
            } else if matches!(cur.peek(), Some(c) if c.is_ascii_digit()) {
                let n = cur.read_int()?;
                if n <= 0 {
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

            total = Some(total.unwrap_or(0) + part);

            if cur.peek() == Some('^') {
                cur.advance();
                continue;
            }
            break;
        }
        total
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

/// A list of values handed out one per note, cycling when it runs out.
#[derive(Debug, Clone)]
struct OnNote {
    values: Vec<i64>,
    next: usize,
}

impl OnNote {
    fn take(&mut self) -> Option<i64> {
        if self.values.is_empty() {
            return None;
        }
        let value = self.values[self.next % self.values.len()];
        self.next += 1;
        Some(value)
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
            | "NoteNo"
            | "MML"
            | "#STR"
            | "ASC"
            | "CHR"
            | "VERSION"
            | "Time"
    )
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
    /// Parsed for compatibility; RPN/NRPN reconstruction at the cut point is
    /// not implemented (see spec/10-compatibility.md), so this has no effect.
    #[allow(dead_code)]
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
}
