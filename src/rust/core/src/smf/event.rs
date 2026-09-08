//! MIDI events, stored with absolute times and pre-rendered bytes.

use super::write_var_len;

/// Meta event types used by the compiler (see `smf_const.pas`).
pub const META_TEXT: u8 = 0x01;
pub const META_COPYRIGHT: u8 = 0x02;
pub const META_TRACK_NAME: u8 = 0x03;
pub const META_INST_NAME: u8 = 0x04;
pub const META_LYRIC: u8 = 0x05;
pub const META_MARKER: u8 = 0x06;
pub const META_CUE_POINT: u8 = 0x07;
pub const META_TEMPO: u8 = 0x51;
pub const META_TIME_SIGNATURE: u8 = 0x58;

/// A single event at an absolute time, already serialised except its delta.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Event {
    pub time: i64,
    pub data: Vec<u8>,
}

impl Event {
    pub fn new(time: i64, data: Vec<u8>) -> Self {
        Self { time, data }
    }

    pub fn note_on(time: i64, channel: u8, note: u8, velocity: u8) -> Self {
        Self::new(time, vec![0x90 | (channel & 0x0f), note, velocity])
    }

    pub fn note_off(time: i64, channel: u8, note: u8, velocity: u8) -> Self {
        Self::new(time, vec![0x80 | (channel & 0x0f), note, velocity])
    }

    pub fn control_change(time: i64, channel: u8, controller: u8, value: u8) -> Self {
        Self::new(time, vec![0xb0 | (channel & 0x0f), controller, value])
    }

    pub fn program_change(time: i64, channel: u8, program: u8) -> Self {
        Self::new(time, vec![0xc0 | (channel & 0x0f), program])
    }

    /// Tempo in microseconds per quarter note.
    pub fn tempo(time: i64, usec_per_quarter: u32) -> Self {
        let v = usec_per_quarter.to_be_bytes();
        Self::meta(time, META_TEMPO, &[v[1], v[2], v[3]])
    }

    /// A meta event with an arbitrary payload.
    pub fn meta(time: i64, meta_type: u8, payload: &[u8]) -> Self {
        let mut data = vec![0xff, meta_type];
        write_var_len(&mut data, payload.len() as u32);
        data.extend_from_slice(payload);
        Self::new(time, data)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn tempo_event_matches_pascal_bytes() {
        // `csakura -e "Tempo=140 c"` starts with 00 ff 51 03 06 8a 1b
        let event = Event::tempo(0, 60_000_000 / 140);
        assert_eq!(event.data, vec![0xff, 0x51, 0x03, 0x06, 0x8a, 0x1b]);
    }

    #[test]
    fn meta_text_event_layout() {
        // `TrackName={"テスト"}` with a CP932 payload
        let event = Event::meta(0, META_TRACK_NAME, &[0x83, 0x65, 0x83, 0x58, 0x83, 0x67]);
        assert_eq!(
            event.data,
            vec![0xff, 0x03, 0x06, 0x83, 0x65, 0x83, 0x58, 0x83, 0x67]
        );
    }

    #[test]
    fn note_events_use_channel_nibble() {
        assert_eq!(Event::note_on(0, 1, 60, 100).data, vec![0x91, 0x3c, 0x64]);
        assert_eq!(Event::note_off(0, 1, 60, 100).data, vec![0x81, 0x3c, 0x64]);
    }
}
