//! Command dispatch and musical state.
//!
//! Phase 1 scope: notes, rests, ties, octave/length/velocity/gate attributes,
//! track & channel selection, tempo, timebase and the text meta events.
//! Everything here mirrors byte-for-byte behaviour measured from the Pascal
//! build (see `tests/golden.rs`).

use std::collections::BTreeMap;

use crate::encoding::encode_cp932;
use crate::error::{MmlError, Result, Warning};
use crate::expr::{self, EvalContext, Value, Variables};
use crate::include::{IncludeResolver, NoIncludes};
use crate::lexer::Cursor;
use crate::smf::{event, Event, Song, Track};

/// Default division (ticks per quarter note).
pub const DEFAULT_TIMEBASE: i64 = 96;

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
    events: Vec<Event>,
    /// Time at which the most recent note ended, so `^` can extend it.
    last_note: Option<LastNote>,
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
            events: Vec::new(),
            last_note: None,
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
            variables: Variables::new(),
            functions: BTreeMap::new(),
            key_flags: [0; 7],
            key_shift: 0,
            q_max: 100,
            v_max: 127,
            measure_shift: 0,
            time_signature: (4, 4),
            messages: Vec::new(),
            exiting: false,
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

    /// Compile MML source into a [`Song`].
    pub fn compile(mut self, src: &str) -> Result<CompileResult> {
        // Japanese notation first, then full-width symbol normalisation —
        // the same order as the Pascal build's PreCompile.
        let converted = crate::lexer::sutoton::to_mml(src);
        let normalized = crate::lexer::zenkaku::normalize(&converted);
        let mut cur = Cursor::new(&normalized);
        self.run(&mut cur)?;

        let mut song = Song::new(self.timebase as u16);
        for state in self.tracks.into_values() {
            if state.events.is_empty() {
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
        if ch.is_ascii_alphabetic() || ch == '_' {
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
                let value = self.expect_int(cur, "o")?;
                self.track().octave = value;
                Ok(())
            }
            'l' => {
                cur.advance();
                let value = self
                    .read_length(cur)
                    .ok_or_else(|| MmlError::new(line, "lコマンドには音長を指定してください"))?;
                self.track().length = value;
                Ok(())
            }
            'q' => {
                cur.advance();
                let value = self.expect_int(cur, "q")?;
                self.track().gate_percent = value;
                Ok(())
            }
            'v' => {
                cur.advance();
                let value = self.expect_int(cur, "v")?;
                self.track().velocity = value;
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
                self.simple_pitch_bend(cur)
            }
            '[' => {
                cur.advance();
                self.repeat(cur)
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
            c if c.is_ascii_alphabetic() || c == '_' => self.word_command(cur),
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

        match word.as_str() {
            "Tempo" | "TEMPO" | "TempoChange" => {
                let bpm = self.expect_int(cur, &word)?;
                if bpm <= 0 {
                    return Err(MmlError::new(line, "テンポには正の値を指定してください"));
                }
                let usec = (60_000_000 / bpm) as u32;
                let time = self.track().time;
                self.track().events.push(Event::tempo(time, usec));
                Ok(())
            }
            "Track" | "TRACK" | "TR" | "NowTrack" => {
                let no = self.expect_int(cur, &word)?;
                self.current = no;
                let timebase = self.timebase;
                self.tracks
                    .entry(no)
                    .or_insert_with(|| TrackState::new(no, timebase));
                Ok(())
            }
            "Channel" | "CHANNEL" | "CH" => {
                let no = self.expect_int(cur, &word)?;
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
                let value = self.expect_int(cur, &word)?;
                if value <= 0 {
                    return Err(MmlError::new(line, "TimeBaseには正の値を指定してください"));
                }
                self.set_timebase(value);
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
            "TimeSignature" => self.time_signature(cur),
            "KeyFlag" => self.key_flag(cur),
            "Keyshift" | "KeyShift" => {
                self.key_shift = self.expect_int(cur, &word)?;
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
            "Voice" => self.voice(cur),
            "PitchBend" => self.pitch_bend(cur),
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
                let value = self.expect_int(cur, &word)?;
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
            cur.eat(')');
            return Ok(args);
        }
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
            let value = match (args.get(index), &param.default) {
                (Some(value), _) => value.clone(),
                (None, Some(default)) => default.clone(),
                (None, None) => {
                    return Err(MmlError::new(
                        line,
                        format!("関数\"{name}\"の引数\"{}\"が指定されていません", param.name),
                    ))
                }
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
        let converted = crate::lexer::sutoton::to_mml(&text);
        let normalized = crate::lexer::zenkaku::normalize(&converted);
        self.run_fragment(&normalized, 1)
    }

    /// `System.xxx` options. The ones that change how notes or timing are
    /// computed are implemented; the rest are accepted with a warning so that
    /// existing songs still compile instead of failing outright.
    fn system_command(&mut self, cur: &mut Cursor, name: &str, line: usize) -> Result<()> {
        match name {
            "Include" | "INCLUDE" => self.include(cur),
            "KeyFlag" => self.key_flag(cur),
            "TimeSignature" => self.time_signature(cur),
            "TimeBase" | "Timebase" => {
                let value = self.expect_int(cur, name)?;
                if value <= 0 {
                    return Err(MmlError::new(line, "TimeBaseには正の値を指定してください"));
                }
                self.set_timebase(value);
                Ok(())
            }
            "Keyshift" | "KeyShift" => {
                self.key_shift = self.expect_int(cur, name)?;
                Ok(())
            }
            "qMax" => {
                let value = self.expect_int(cur, name)?;
                self.q_max = value.max(1);
                Ok(())
            }
            "vMax" => {
                let value = self.expect_int(cur, name)?;
                self.v_max = value.max(1);
                Ok(())
            }
            "MeasureShift" => {
                self.measure_shift = self.expect_int(cur, name)?;
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
        self.track()
            .events
            .push(Event::meta(time, event::META_TIME_SIGNATURE, &payload));
        Ok(())
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
        self.track().events.push(Event::meta(time, 0x59, &payload));
        Ok(())
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

        let parts: Vec<i64> = body
            .split(':')
            .map(|part| {
                let mut cursor = Cursor::with_line(part.trim(), line);
                expr::eval(&mut cursor, self).and_then(|v| v.as_int(line))
            })
            .collect::<Result<Vec<_>>>()?;

        let (numerator, denominator) = self.time_signature;
        let beat_ticks = self.timebase * 4 / denominator.max(1);
        let time = match parts.as_slice() {
            [total] => *total,
            [measure, beat] => {
                (measure - 1 + self.measure_shift) * numerator * beat_ticks
                    + (beat - 1) * beat_ticks
            }
            [measure, beat, step, ..] => {
                (measure - 1 + self.measure_shift) * numerator * beat_ticks
                    + (beat - 1) * beat_ticks
                    + step
            }
            [] => return Err(MmlError::new(line, "Timeの引数が空です")),
        };
        let track = self.track();
        track.time = time.max(0);
        track.last_note = None;
        Ok(())
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
        self.track().events.push(Event::new(time, data));
        Ok(())
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
    /// parenthesised expression.
    fn assign(&mut self, cur: &mut Cursor, name: &str) -> Result<()> {
        cur.skip_spaces();
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
        self.assign(&mut cur, &name)
    }

    fn eval_source(&mut self, src: &str, line: usize) -> Result<Value> {
        let mut cur = Cursor::with_line(src.trim(), line);
        expr::eval(&mut cur, self)
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
        let count = cur.read_int().unwrap_or(2);
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
                // In hex mode a `$` prefix is allowed but redundant.
                cur.eat('$');
                cur.read_hex()
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
            cur.eat(')');
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
        self.track().events.push(Event::new(time, data));
        Ok(())
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
        let program = (voice - 1).clamp(0, 127) as u8;
        let (time, channel) = {
            let track = self.track();
            (track.time, track.channel)
        };
        self.track()
            .events
            .push(Event::program_change(time, channel, program));
        Ok(())
    }

    /// `y(n),(value)` — write a control change by number.
    fn control_change_direct(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let args = self.read_args(cur, 2)?;
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
        let value = self.expect_int(cur, "PitchBend")?;
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
        self.track()
            .events
            .push(Event::new(time, vec![0xe0 | (channel & 0x0f), lsb, msb]));
    }

    fn write_cc(&mut self, controller: i64, value: i64) {
        let (time, channel) = {
            let track = self.track();
            (track.time, track.channel)
        };
        let controller = controller.clamp(0, 127) as u8;
        let value = value.clamp(0, 127) as u8;
        self.track()
            .events
            .push(Event::control_change(time, channel, controller, value));
    }

    /// Read up to `max` comma-separated integers, with or without parentheses:
    /// `(1,2,3)`, `=1,2,3` or a bare `1,2,3`.
    fn read_args(&mut self, cur: &mut Cursor, max: usize) -> Result<Vec<i64>> {
        cur.skip_spaces();
        cur.eat('=');
        cur.skip_spaces();
        let parenthesised = cur.eat('(');
        let mut args = Vec::new();
        loop {
            cur.skip_spaces();
            let value = if parenthesised {
                // Inside parentheses each argument may be an expression.
                match cur.peek() {
                    Some(c)
                        if c.is_ascii_digit()
                            || c == '-'
                            || c == '('
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
            cur.skip_spaces();
            if args.len() >= max || !cur.eat(',') {
                break;
            }
        }
        cur.skip_spaces();
        if parenthesised {
            cur.eat(')');
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
        if closing != '\0' {
            cur.eat(closing);
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

        let (length, options) = self.read_note_options(cur);
        let note_no = self.track().octave * 12 + base + accidental + self.key_shift;
        self.write_note(note_no, length, options, line)
    }

    fn note_number(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let note_no = self
            .read_number(cur)?
            .ok_or_else(|| MmlError::new(line, "nコマンドにはノート番号を指定してください"))?;
        // `n60,` — the Pascal syntax allows a comma before the options.
        cur.eat(',');
        let (length, options) = self.read_note_options(cur);
        self.write_note(note_no + self.key_shift, length, options, line)
    }

    fn rest(&mut self, cur: &mut Cursor) -> Result<()> {
        let (length, _) = self.read_note_options(cur);
        let length = length.unwrap_or_else(|| self.track().length);
        let track = self.track();
        track.time += length;
        track.last_note = None;
        Ok(())
    }

    /// `^` extends the previous note; with no preceding note it is a rest.
    fn tie(&mut self, cur: &mut Cursor) -> Result<()> {
        let (length, _) = self.read_note_options(cur);
        let length = length.unwrap_or_else(|| self.track().length);
        let gate_percent = self.track().gate_percent;
        let q_max = self.q_max;
        let track = self.track();
        track.time += length;

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
        let track = self.track();
        let length = length.unwrap_or(track.length);
        let raw_velocity = options.velocity.unwrap_or(track.velocity);
        let gate_value = options.gate_percent.unwrap_or(track.gate_percent);
        let (q_max, v_max) = (self.q_max, self.v_max);
        let velocity = scale_velocity(raw_velocity, v_max);
        let gate = gate_ticks_scaled(length, gate_value, q_max);
        let track = self.track();

        let start = track.time;
        let channel = track.channel;
        track
            .events
            .push(Event::note_on(start, channel, note_no as u8, velocity));
        track.events.push(Event::note_off(
            start + gate,
            channel,
            note_no as u8,
            velocity,
        ));
        track.last_note = Some(LastNote {
            off_index: track.events.len() - 1,
            start,
        });
        track.time = start + length;
        Ok(())
    }

    /// Note suffixes: a length spec and/or `(l,q,v,t,o)` options.
    fn read_note_options(&mut self, cur: &mut Cursor) -> (Option<i64>, NoteOptions) {
        let mut options = NoteOptions::default();
        let mut length = self.read_length(cur);

        if cur.peek() == Some('(') {
            cur.advance();
            let mut index = 0;
            loop {
                cur.skip_spaces();
                if cur.eat(')') {
                    break;
                }
                let value = if index == 0 {
                    self.read_length(cur)
                } else {
                    cur.read_int()
                };
                match (index, value) {
                    (0, Some(v)) => length = Some(v),
                    (1, Some(v)) => options.gate_percent = Some(v),
                    (2, Some(v)) => options.velocity = Some(v),
                    _ => {}
                }
                cur.skip_spaces();
                if !cur.eat(',') && !cur.eat(')') {
                    break;
                }
                index += 1;
            }
        }
        (length, options)
    }

    /// A length spec: `4`, `8.`, `%48` (raw ticks), or a `^`-joined sum.
    fn read_length(&mut self, cur: &mut Cursor) -> Option<i64> {
        let mut total: Option<i64> = None;
        loop {
            let part = if cur.peek() == Some('%') {
                cur.advance();
                cur.read_int()
            } else if matches!(cur.peek(), Some(c) if c.is_ascii_digit()) {
                let n = cur.read_int()?;
                if n <= 0 {
                    Some(0)
                } else {
                    Some(self.timebase * 4 / n)
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

    fn expect_int(&mut self, cur: &mut Cursor, name: &str) -> Result<i64> {
        let line = cur.line();
        cur.skip_spaces();
        cur.eat('=');
        self.read_number(cur)?
            .ok_or_else(|| MmlError::new(line, format!("{name}には数値を指定してください")))
    }

    /// Read a numeric argument: a bare integer literal, or — inside
    /// parentheses — a full expression, which is the only place variables may
    /// appear (`o(x)` works, `ox` does not, matching the Pascal build).
    fn read_number(&mut self, cur: &mut Cursor) -> Result<Option<i64>> {
        let line = cur.line();
        cur.skip_spaces();
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
        self.call_function(name, args, line)
    }

    fn has_function(&self, name: &str) -> bool {
        self.functions.contains_key(name)
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
    for (index, ch) in body.char_indices() {
        match ch {
            '"' => in_string = !in_string,
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
    velocity: Option<i64>,
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
    let gate = length * gate_value / q_max.max(1) - 1;
    gate.max(1)
}

/// Scale `v` against `System.vMax`. With the default 127 this is the identity;
/// `System.vMax=15` maps v15 to 120, matching the Pascal build.
fn scale_velocity(velocity: i64, v_max: i64) -> u8 {
    let factor = 128 / v_max.max(1);
    (velocity * factor).clamp(0, 127) as u8
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
