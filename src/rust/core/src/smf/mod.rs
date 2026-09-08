//! Standard MIDI File construction.
//!
//! Events are collected per track with absolute times and serialised into
//! MThd/MTrk chunks. Byte layout follows the Pascal implementation
//! (`smf_types.pas`): format 1, one MTrk per used track, explicit note-off
//! (0x8n) with the note's own velocity, and no running status.

pub mod event;

pub use event::Event;

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
    pub fn to_bytes(&self) -> Vec<u8> {
        let mut out = Vec::new();
        out.extend_from_slice(b"MThd");
        out.extend_from_slice(&6u32.to_be_bytes());
        out.extend_from_slice(&1u16.to_be_bytes()); // format 1
        out.extend_from_slice(&(self.tracks.len() as u16).to_be_bytes());
        out.extend_from_slice(&self.timebase.to_be_bytes());
        for track in &self.tracks {
            out.extend_from_slice(&track_chunk(track));
        }
        out
    }
}

fn track_chunk(track: &Track) -> Vec<u8> {
    let mut events = track.events.clone();
    // Stable sort keeps same-time events in the order they were written,
    // matching the Pascal implementation's insertion order.
    events.sort_by_key(|e| e.time);

    let mut body = Vec::new();
    let mut last_time = 0i64;
    for event in &events {
        write_var_len(&mut body, (event.time - last_time).max(0) as u32);
        body.extend_from_slice(&event.data);
        last_time = event.time;
    }
    // End of track
    write_var_len(&mut body, (track.end_time - last_time).max(0) as u32);
    body.extend_from_slice(&[0xff, 0x2f, 0x00]);

    let mut chunk = Vec::with_capacity(body.len() + 8);
    chunk.extend_from_slice(b"MTrk");
    chunk.extend_from_slice(&(body.len() as u32).to_be_bytes());
    chunk.extend_from_slice(&body);
    chunk
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
            song.to_bytes(),
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
        assert_eq!(song.to_bytes(), expected);
    }

    fn hex(s: &str) -> Vec<u8> {
        (0..s.len())
            .step_by(2)
            .map(|i| u8::from_str_radix(&s[i..i + 2], 16).unwrap())
            .collect()
    }
}
