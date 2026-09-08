//! Command dispatch and musical state.
//!
//! Phase 1 scope: notes, rests, ties, octave/length/velocity/gate attributes,
//! track & channel selection, tempo, timebase and the text meta events.
//! Everything here mirrors byte-for-byte behaviour measured from the Pascal
//! build (see `tests/golden.rs`).

use std::collections::BTreeMap;

use crate::encoding::encode_cp932;
use crate::error::{MmlError, Result, Warning};
use crate::lexer::Cursor;
use crate::smf::{event, Event, Song, Track};

/// Default division (ticks per quarter note).
pub const DEFAULT_TIMEBASE: i64 = 96;

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

pub struct Compiler {
    timebase: i64,
    tracks: BTreeMap<i64, TrackState>,
    current: i64,
    warnings: Vec<Warning>,
}

impl Default for Compiler {
    fn default() -> Self {
        Self::new()
    }
}

impl Compiler {
    pub fn new() -> Self {
        Self {
            timebase: DEFAULT_TIMEBASE,
            tracks: BTreeMap::new(),
            current: 1,
            warnings: Vec::new(),
        }
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
    pub fn compile(mut self, src: &str) -> Result<(Song, Vec<Warning>)> {
        let normalized = crate::lexer::zenkaku::normalize(src);
        let mut cur = Cursor::new(&normalized);

        loop {
            cur.skip_trivia();
            if cur.is_eof() {
                break;
            }
            self.step(&mut cur)?;
        }

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
        Ok((song, self.warnings))
    }

    fn step(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        let Some(ch) = cur.peek() else { return Ok(()) };

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
            "TrackName" => self.meta_text(cur, event::META_TRACK_NAME, line),
            "Copyright" => self.meta_text(cur, event::META_COPYRIGHT, line),
            "MetaText" | "Text" => self.meta_text(cur, event::META_TEXT, line),
            "Lyric" => self.meta_text(cur, event::META_LYRIC, line),
            "Marker" => self.meta_text(cur, event::META_MARKER, line),
            "CuePoint" => self.meta_text(cur, event::META_CUE_POINT, line),
            "InstrumentName" => self.meta_text(cur, event::META_INST_NAME, line),
            other => Err(MmlError::new(
                line,
                format!("\"{other}\"は未定義です。綴りを確かめてください。"),
            )),
        }
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

    fn meta_text(&mut self, cur: &mut Cursor, meta_type: u8, line: usize) -> Result<()> {
        let text = self.read_braced_string(cur, line)?;
        let (bytes, warnings) = encode_cp932(&text, line);
        self.warnings.extend(warnings);
        let time = self.track().time;
        self.track()
            .events
            .push(Event::meta(time, meta_type, &bytes));
        Ok(())
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
        let base = match letter {
            'c' => 0,
            'd' => 2,
            'e' => 4,
            'f' => 5,
            'g' => 7,
            'a' => 9,
            'b' => 11,
            _ => return Err(MmlError::new(line, format!("音名ではありません: {letter}"))),
        };

        let mut accidental = 0;
        while let Some(sign) = cur.eat_any(&['+', '-', '#']) {
            accidental += if sign == '-' { -1 } else { 1 };
        }

        let (length, options) = self.read_note_options(cur);
        let note_no = self.track().octave * 12 + base + accidental;
        self.write_note(note_no, length, options, line)
    }

    fn note_number(&mut self, cur: &mut Cursor) -> Result<()> {
        let line = cur.line();
        cur.skip_spaces();
        let note_no = cur
            .read_int()
            .ok_or_else(|| MmlError::new(line, "nコマンドにはノート番号を指定してください"))?;
        // `n60,` — the Pascal syntax allows a comma before the options.
        cur.eat(',');
        let (length, options) = self.read_note_options(cur);
        self.write_note(note_no, length, options, line)
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
        let track = self.track();
        track.time += length;

        let Some(last) = track.last_note else {
            return Ok(()); // no note to extend: behaves as a rest
        };
        let total = track.time - last.start;
        let gate = gate_ticks(total, gate_percent);
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
        let velocity = options.velocity.unwrap_or(track.velocity).clamp(0, 127) as u8;
        let gate_percent = options.gate_percent.unwrap_or(track.gate_percent);
        let gate = gate_ticks(length, gate_percent);

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
        cur.skip_spaces();
        let parenthesised = cur.eat('(');
        cur.skip_spaces();
        let value = cur
            .read_int()
            .ok_or_else(|| MmlError::new(line, format!("{name}には数値を指定してください")))?;
        cur.skip_spaces();
        if parenthesised {
            cur.eat(')');
        }
        Ok(value)
    }
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
fn gate_ticks(length: i64, gate_percent: i64) -> i64 {
    let gate = length * gate_percent / 100 - 1;
    gate.max(1)
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
