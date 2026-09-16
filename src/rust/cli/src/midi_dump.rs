//! A deterministic, line-oriented view of an SMF file.
//!
//! Storage details such as delta-time VLQs and running status are normalized,
//! so ordinary text diff tools can compare the actual event streams. Events
//! that have a SakuraMML equivalent (`@`, `y`, `SysEx$`, `Tempo`, ...) are
//! printed as that command, and a track keeps the last `CH(n)` until the
//! channel actually changes.

use std::collections::{HashMap, VecDeque};

/// Comment line printed before every `TR(n)` header so that track boundaries
/// are easy to spot in a long dump.
const TRACK_SEPARATOR: &str = "// -------------------------------------------";

#[derive(Debug)]
struct MidiFile {
    format: u16,
    division: u16,
    tracks: Vec<Vec<Event>>,
}

#[derive(Debug)]
struct Event {
    time: u64,
    bytes: Vec<u8>,
}

pub fn dump(bytes: &[u8]) -> Result<String, String> {
    let midi = parse(bytes)?;
    let mut out = format!(
        "// SMF format={} timebase={} tracks={}\n",
        midi.format,
        midi.division,
        midi.tracks.len()
    );
    for (track_no, events) in midi.tracks.iter().enumerate() {
        out.push_str(&format!("{TRACK_SEPARATOR}\nTR({track_no})\n"));
        let durations = note_durations(events);
        let mut last_channel: Option<u8> = None;
        for (index, event) in events.iter().enumerate() {
            if is_note_off(&event.bytes) || is_end_of_track(&event.bytes) {
                continue;
            }
            let time = format_time(event.time, midi.division);
            if let Some((channel, note, velocity)) = note_on(&event.bytes) {
                let gate = durations.get(&index).copied().unwrap_or(0);
                let length = next_note_distance(events, index).unwrap_or(gate);
                out.push_str(&format!(
                    "TIME({time}) {}{}{},%{gate},{velocity}\n",
                    channel_label(&mut last_channel, channel),
                    note_name(note),
                    format_length(length, midi.division)
                ));
            } else if let Some((channel, command)) = event_command(&event.bytes, midi.division) {
                let label = match channel {
                    Some(channel) => channel_label(&mut last_channel, channel),
                    None => String::new(),
                };
                out.push_str(&format!("TIME({time}) {label}{command}\n"));
            } else {
                let payload = event
                    .bytes
                    .iter()
                    .map(|byte| format!("${byte:02X}"))
                    .collect::<Vec<_>>()
                    .join(",");
                out.push_str(&format!("TIME({time}) DirectSMF({payload})\n"));
            }
        }
    }
    Ok(out)
}

/// `CH(n) ` is printed only when the channel differs from the previous
/// channel event of the track, mirroring how SakuraMML keeps a channel alive.
fn channel_label(last: &mut Option<u8>, channel: u8) -> String {
    if *last == Some(channel) {
        String::new()
    } else {
        *last = Some(channel);
        format!("CH({}) ", channel + 1)
    }
}

/// The MML command form of a non-note event, with its channel when it is a
/// channel voice message. `None` means only raw `DirectSMF` bytes describe it.
fn event_command(bytes: &[u8], division: u16) -> Option<(Option<u8>, String)> {
    if let Some((channel, controller, value)) = control_change(bytes) {
        return Some((Some(channel), format!("y{controller},{value}")));
    }
    if let Some((channel, program)) = program_change(bytes) {
        return Some((Some(channel), format!("@{}", u16::from(program) + 1)));
    }
    if let Some((channel, value)) = pitch_bend(bytes) {
        return Some((Some(channel), format!("PitchBend({value})")));
    }
    if let Some(text) = sysex_command(bytes) {
        return Some((None, text));
    }
    Some((None, meta_command(bytes, division)?))
}

fn parse(bytes: &[u8]) -> Result<MidiFile, String> {
    if bytes.len() < 14 || &bytes[..4] != b"MThd" {
        return Err("MThdヘッダーがありません".to_string());
    }
    let header_len = be_u32(bytes, 4)? as usize;
    if header_len < 6 || 8usize.saturating_add(header_len) > bytes.len() {
        return Err("MThdヘッダー長が不正です".to_string());
    }
    let format = be_u16(bytes, 8)?;
    let track_count = be_u16(bytes, 10)? as usize;
    let division = be_u16(bytes, 12)?;
    if division == 0 || division & 0x8000 != 0 {
        return Err("SMPTE形式または0のtimebaseには対応していません".to_string());
    }

    let mut offset = 8 + header_len;
    let mut tracks = Vec::with_capacity(track_count);
    for track_no in 0..track_count {
        if offset + 8 > bytes.len() || &bytes[offset..offset + 4] != b"MTrk" {
            return Err(format!("MTrk({track_no})がありません"));
        }
        let length = be_u32(bytes, offset + 4)? as usize;
        offset += 8;
        let end = offset
            .checked_add(length)
            .filter(|end| *end <= bytes.len())
            .ok_or_else(|| format!("MTrk({track_no})の長さがファイルを超えています"))?;
        tracks.push(parse_track(&bytes[offset..end], track_no)?);
        offset = end;
    }
    Ok(MidiFile {
        format,
        division,
        tracks,
    })
}

fn parse_track(data: &[u8], track_no: usize) -> Result<Vec<Event>, String> {
    let mut offset = 0;
    let mut time = 0u64;
    let mut running_status = None;
    let mut events = Vec::new();
    while offset < data.len() {
        let delta = read_vlq(data, &mut offset)?;
        time = time
            .checked_add(u64::from(delta))
            .ok_or_else(|| format!("MTrk({track_no})の時刻がオーバーフローしました"))?;
        let first = *data
            .get(offset)
            .ok_or_else(|| format!("MTrk({track_no})のイベントが途中で終わっています"))?;
        let status = if first & 0x80 != 0 {
            offset += 1;
            first
        } else {
            running_status
                .ok_or_else(|| format!("MTrk({track_no})でランニングステータスを復元できません"))?
        };

        let bytes = match status {
            0x80..=0xEF => {
                running_status = Some(status);
                let count = if status & 0xE0 == 0xC0 { 1 } else { 2 };
                let payload = take(data, &mut offset, count, track_no)?;
                if payload.iter().any(|byte| byte & 0x80 != 0) {
                    return Err(format!(
                        "MTrk({track_no})のチャンネルイベントに不正なデータバイトがあります"
                    ));
                }
                let mut event = Vec::with_capacity(count + 1);
                event.push(status);
                event.extend_from_slice(payload);
                event
            }
            0xFF => {
                running_status = None;
                let meta_type = *take(data, &mut offset, 1, track_no)?
                    .first()
                    .expect("one byte was requested");
                let length = read_vlq(data, &mut offset)? as usize;
                let payload = take(data, &mut offset, length, track_no)?;
                let mut event = vec![0xFF, meta_type];
                write_vlq(length as u32, &mut event);
                event.extend_from_slice(payload);
                event
            }
            0xF0 | 0xF7 => {
                running_status = None;
                let length = read_vlq(data, &mut offset)? as usize;
                let payload = take(data, &mut offset, length, track_no)?;
                let mut event = vec![status];
                write_vlq(length as u32, &mut event);
                event.extend_from_slice(payload);
                event
            }
            _ => {
                return Err(format!(
                    "MTrk({track_no})に未対応のステータス ${status:02X} があります"
                ))
            }
        };
        events.push(Event { time, bytes });
    }
    Ok(events)
}

fn take<'a>(
    data: &'a [u8],
    offset: &mut usize,
    count: usize,
    track_no: usize,
) -> Result<&'a [u8], String> {
    let end = offset
        .checked_add(count)
        .filter(|end| *end <= data.len())
        .ok_or_else(|| format!("MTrk({track_no})のイベントデータが途中で終わっています"))?;
    let result = &data[*offset..end];
    *offset = end;
    Ok(result)
}

fn read_vlq(data: &[u8], offset: &mut usize) -> Result<u32, String> {
    let mut value = 0u32;
    for _ in 0..4 {
        let byte = *data
            .get(*offset)
            .ok_or_else(|| "VLQが途中で終わっています".to_string())?;
        *offset += 1;
        value = (value << 7) | u32::from(byte & 0x7F);
        if byte & 0x80 == 0 {
            return Ok(value);
        }
    }
    Err("VLQが4バイトを超えています".to_string())
}

fn write_vlq(mut value: u32, out: &mut Vec<u8>) {
    let mut buffer = [0u8; 4];
    let mut index = 3;
    buffer[index] = (value & 0x7F) as u8;
    while {
        value >>= 7;
        value != 0
    } {
        index -= 1;
        buffer[index] = ((value & 0x7F) as u8) | 0x80;
    }
    out.extend_from_slice(&buffer[index..]);
}

fn be_u16(bytes: &[u8], offset: usize) -> Result<u16, String> {
    let data = bytes
        .get(offset..offset + 2)
        .ok_or_else(|| "SMFが途中で終わっています".to_string())?;
    Ok(u16::from_be_bytes([data[0], data[1]]))
}

fn be_u32(bytes: &[u8], offset: usize) -> Result<u32, String> {
    let data = bytes
        .get(offset..offset + 4)
        .ok_or_else(|| "SMFが途中で終わっています".to_string())?;
    Ok(u32::from_be_bytes([data[0], data[1], data[2], data[3]]))
}

fn note_on(bytes: &[u8]) -> Option<(u8, u8, u8)> {
    (bytes.len() == 3 && bytes[0] & 0xF0 == 0x90 && bytes[2] != 0)
        .then(|| (bytes[0] & 0x0F, bytes[1], bytes[2]))
}

fn is_note_off(bytes: &[u8]) -> bool {
    bytes.len() == 3 && (bytes[0] & 0xF0 == 0x80 || (bytes[0] & 0xF0 == 0x90 && bytes[2] == 0))
}

/// A control change (`$Bn`) reads more clearly as the `y` command
/// (`y{controller},{value}`) than as raw `DirectSMF` bytes.
fn control_change(bytes: &[u8]) -> Option<(u8, u8, u8)> {
    (bytes.len() == 3 && bytes[0] & 0xF0 == 0xB0).then(|| (bytes[0] & 0x0F, bytes[1], bytes[2]))
}

/// A program change (`$Cn`) is the 1-based `@` voice command.
fn program_change(bytes: &[u8]) -> Option<(u8, u8)> {
    (bytes.len() == 2 && bytes[0] & 0xF0 == 0xC0).then(|| (bytes[0] & 0x0F, bytes[1]))
}

/// A pitch bend (`$En`) as the signed -8192..8191 value `PitchBend()` takes.
fn pitch_bend(bytes: &[u8]) -> Option<(u8, i64)> {
    (bytes.len() == 3 && bytes[0] & 0xF0 == 0xE0).then(|| {
        let raw = i64::from(bytes[2] & 0x7F) * 128 + i64::from(bytes[1] & 0x7F);
        (bytes[0] & 0x0F, raw - 8192)
    })
}

/// An `$F0` SysEx event as the hex-mode `SysEx$(...)` command. The leading
/// `F0` is kept in the value list because the compiler consumes exactly one
/// from the front and then writes the status byte itself.
fn sysex_command(bytes: &[u8]) -> Option<String> {
    if bytes.first() != Some(&0xF0) {
        return None;
    }
    let mut offset = 1;
    let length = read_vlq(bytes, &mut offset).ok()? as usize;
    let payload = bytes.get(offset..offset.checked_add(length)?)?;
    let mut values: Vec<String> = Vec::new();
    if payload.first() != Some(&0xF0) {
        values.push("F0".to_string());
    }
    values.extend(payload.iter().map(|byte| format!("{byte:02X}")));
    Some(format!("SysEx$({})", values.join(",")))
}

/// Meta events that have a SakuraMML command are written as that command.
fn meta_command(bytes: &[u8], division: u16) -> Option<String> {
    if bytes.first() != Some(&0xFF) {
        return None;
    }
    let kind = *bytes.get(1)?;
    let mut offset = 2;
    let length = read_vlq(bytes, &mut offset).ok()? as usize;
    let data = bytes.get(offset..offset.checked_add(length)?)?;
    match kind {
        0x01..=0x07 => text_command(kind, data),
        0x20 if data.len() == 1 && data[0] < 0x80 => {
            Some(format!("ChannelPrefix({})", data[0] + 1))
        }
        0x21 if data.len() == 1 => Some(format!("Port({})", data[0])),
        0x51 => tempo_command(data),
        0x58 => time_signature_command(data, division),
        0x59 => key_signature_command(data),
        _ => None,
    }
}

const META_TEXT_NAMES: [(u8, &str); 7] = [
    (0x01, "MetaText"),
    (0x02, "Copyright"),
    (0x03, "TrackName"),
    (0x04, "InstrumentName"),
    (0x05, "Lyric"),
    (0x06, "Marker"),
    (0x07, "CuePoint"),
];

/// SMF meta text is stored as CP932. The decoded string is quoted back into
/// the command that emits the same bytes, but only when that round trip is
/// exact (and the text survives the parser, which has no quote escapes).
fn text_command(kind: u8, data: &[u8]) -> Option<String> {
    let name = META_TEXT_NAMES
        .into_iter()
        .find_map(|(code, name)| (code == kind).then_some(name))?;
    let text = sakuramml_core::encoding::decode_cp932(data);
    if text.contains('"') {
        return None;
    }
    let (encoded, warnings) = sakuramml_core::encoding::encode_cp932(&text, 0);
    (encoded == data && warnings.is_empty()).then(|| format!("{name}(\"{text}\")"))
}

/// `Tempo=n` takes whole BPM; convert the 24-bit microsecond value back only
/// when the compiler reproduces it exactly.
fn tempo_command(data: &[u8]) -> Option<String> {
    let [hi, mid, lo] = <[u8; 3]>::try_from(data).ok()?;
    let usec = (u64::from(hi) << 16) | (u64::from(mid) << 8) | u64::from(lo);
    if usec == 0 {
        return None;
    }
    let bpm = (60_000_000 + usec / 2) / usec;
    ((4..=60_000_000).contains(&bpm) && 60_000_000 / bpm == usec).then(|| format!("Tempo={bpm}"))
}

/// `TimeSignature=分子,分母` — the SMF denominator byte is a power of two.
/// The value is skipped when the grid could not hold the resulting beat.
fn time_signature_command(data: &[u8], division: u16) -> Option<String> {
    let data = <[u8; 4]>::try_from(data).ok()?;
    let (numerator, denominator) = (u64::from(data[0]), 1u64 << data[1]);
    (numerator >= 1 && u64::from(division) * 4 >= denominator)
        .then(|| format!("TimeSignature={numerator},{denominator}"))
}

/// `$FF,$59` is emitted by `KeyFlag`; the sharp (or flat) count maps back to
/// the leading note letters in circle-of-fifths order.
fn key_signature_command(data: &[u8]) -> Option<String> {
    let data = <[u8; 2]>::try_from(data).ok()?;
    let sharps_or_flats = i8::try_from(data[0]).ok()?;
    if data[1] != 0 || !(-7..=7).contains(&sharps_or_flats) {
        return None;
    }
    const SHARP_ORDER: &str = "fcgdaeb";
    const FLAT_ORDER: &str = "beadgcf";
    Some(match sharps_or_flats {
        0 => "KeyFlag()".to_string(),
        count if count > 0 => format!("KeyFlag({})", &SHARP_ORDER[..count as usize]),
        count => format!("KeyFlag-({})", &FLAT_ORDER[..(-count) as usize]),
    })
}

fn is_end_of_track(bytes: &[u8]) -> bool {
    bytes == [0xFF, 0x2F, 0x00]
}

fn note_durations(events: &[Event]) -> HashMap<usize, u64> {
    let mut pending: HashMap<(u8, u8), VecDeque<usize>> = HashMap::new();
    let mut durations = HashMap::new();
    for (index, event) in events.iter().enumerate() {
        if let Some((channel, note, _)) = note_on(&event.bytes) {
            pending.entry((channel, note)).or_default().push_back(index);
        } else if is_note_off(&event.bytes) {
            let key = (event.bytes[0] & 0x0F, event.bytes[1]);
            if let Some(start_index) = pending.get_mut(&key).and_then(VecDeque::pop_front) {
                durations.insert(
                    start_index,
                    event.time.saturating_sub(events[start_index].time),
                );
            }
        }
    }
    durations
}

fn next_note_distance(events: &[Event], index: usize) -> Option<u64> {
    let start = events[index].time;
    events[index + 1..]
        .iter()
        .filter_map(|event| note_on(&event.bytes).map(|_| event.time))
        .find(|time| *time > start)
        .map(|time| time - start)
}

fn format_time(time: u64, division: u16) -> String {
    let division = u64::from(division);
    let measure = division * 4;
    let bar = time / measure + 1;
    let within = time % measure;
    let beat = within / division + 1;
    let tick = within % division;
    format!("{bar}:{beat}:{tick}")
}

fn note_name(note: u8) -> String {
    const NAMES: [&str; 12] = [
        "c", "c+", "d", "d+", "e", "f", "f+", "g", "g+", "a", "a+", "b",
    ];
    let octave = i16::from(note) / 12;
    format!("o{octave}{}", NAMES[usize::from(note % 12)])
}

fn format_length(ticks: u64, division: u16) -> String {
    if ticks != 0 {
        let whole = u64::from(division) * 4;
        if whole % ticks == 0 {
            return (whole / ticks).to_string();
        }
    }
    format!("%{ticks}")
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Wrap pre-built track payloads into a format-1 file on a 96-tick grid.
    fn smf(tracks: &[&[u8]]) -> Vec<u8> {
        let mut out = Vec::new();
        out.extend_from_slice(b"MThd");
        out.extend_from_slice(&6u32.to_be_bytes());
        out.extend_from_slice(&1u16.to_be_bytes());
        out.extend_from_slice(&(tracks.len() as u16).to_be_bytes());
        out.extend_from_slice(&96u16.to_be_bytes());
        for track in tracks {
            out.extend_from_slice(b"MTrk");
            out.extend_from_slice(&(track.len() as u32).to_be_bytes());
            out.extend_from_slice(track);
        }
        out
    }

    const END_OF_TRACK: &[u8] = b"\x00\xff\x2f\0";

    #[test]
    fn dumps_notes_and_normalizes_running_status() {
        let midi = b"MThd\0\0\0\x06\0\x01\0\x01\0\x60\
            MTrk\0\0\0\x12\0\x90\x3c\x0c\x30\x3e\x0d\0\x80\x3c\0\x30\x3e\0\0\xff\x2f\0";
        let text = dump(midi).expect("valid SMF should dump");
        assert!(text.contains("TIME(1:1:0) CH(1) o5c8,%48,12"));
        assert!(text.contains("TIME(1:1:48) o5d8,%48,13"));
        assert!(!text.contains("$90"));
    }

    #[test]
    fn dumps_program_change_as_the_voice_command() {
        let text = dump(&smf(&[b"\x00\xc0\x50", END_OF_TRACK])).expect("valid SMF");
        assert!(text.contains("TIME(1:1:0) CH(1) @81"));
        assert!(!text.contains("DirectSMF"));
    }

    #[test]
    fn dumps_control_changes_as_the_y_command() {
        let midi = b"MThd\0\0\0\x06\0\x01\0\x01\0\x60\
            MTrk\0\0\0\x08\0\xb2\x0b\x40\0\xff\x2f\0";
        let text = dump(midi).expect("valid SMF should dump");
        assert!(text.contains("TIME(1:1:0) CH(3) y11,64"));
        assert!(!text.contains("DirectSMF"));
    }

    #[test]
    fn dumps_pitch_bend_as_the_pitchbend_command() {
        let text = dump(&smf(&[b"\x00\xe0\x00\x40", END_OF_TRACK])).expect("valid SMF");
        assert!(text.contains("TIME(1:1:0) CH(1) PitchBend(0)"));
        assert!(!text.contains("DirectSMF"));
    }

    #[test]
    fn omits_the_channel_until_it_changes_within_a_track() {
        // @6 on channel 1, a note on channel 1 (CH dropped), then channel 2.
        let track = b"\x00\xc0\x05\x00\x90\x3c\x0c\x60\x91\x3e\x0d";
        let text = dump(&smf(&[track, END_OF_TRACK])).expect("valid SMF");
        assert!(text.contains("TIME(1:1:0) CH(1) @6"));
        assert!(text.contains("TIME(1:1:0) o5c4,%0,12"));
        assert!(text.contains("TIME(1:2:0) CH(2) o5d%0,%0,13"));
        assert_eq!(text.matches("CH(1)").count(), 1);
    }

    #[test]
    fn dumps_sysex_as_the_hex_sysex_command() {
        let track = b"\x00\xf0\x05\x7e\x7f\x09\x01\xf7";
        let text = dump(&smf(&[track, END_OF_TRACK])).expect("valid SMF");
        assert!(text.contains("TIME(1:1:0) SysEx$(F0,7E,7F,09,01,F7)"));
        assert!(!text.contains("DirectSMF"));
    }

    #[test]
    fn dumps_meta_events_as_their_commands() {
        let track = b"\x00\xff\x51\x03\x07\x35\x78\
            \x00\xff\x58\x04\x02\x02\x60\x0c\
            \x00\xff\x59\x02\x02\x00\
            \x00\xff\x03\x05hello\
            \x00\xff\x20\x01\x02\
            \x00\xff\x21\x01\x03";
        let text = dump(&smf(&[track, END_OF_TRACK])).expect("valid SMF");
        assert!(text.contains("TIME(1:1:0) Tempo=127"));
        assert!(text.contains("TIME(1:1:0) TimeSignature=2,4"));
        assert!(text.contains("TIME(1:1:0) KeyFlag(fc)"));
        assert!(text.contains("TIME(1:1:0) TrackName(\"hello\")"));
        assert!(text.contains("TIME(1:1:0) ChannelPrefix(3)"));
        assert!(text.contains("TIME(1:1:0) Port(3)"));
        assert!(!text.contains("DirectSMF"));
    }

    #[test]
    fn keeps_meta_text_that_does_not_round_trip_as_direct_smf() {
        // $82,$4d,$22 cannot decode to text that re-encodes to the same bytes
        // and contains a quote, so it must stay raw.
        let track = b"\x00\xff\x05\x03\x82\x4d\x22";
        let text = dump(&smf(&[track, END_OF_TRACK])).expect("valid SMF");
        assert!(text.contains("TIME(1:1:0) DirectSMF($FF,$05,$03,$82,$4D,$22)"));
    }

    #[test]
    fn keeps_tempos_that_do_not_round_trip_as_direct_smf() {
        // 0x00FF41 microticks is not an exact whole-BPM tempo.
        let track = b"\x00\xff\x51\x03\x00\xff\x41";
        let text = dump(&smf(&[track, END_OF_TRACK])).expect("valid SMF");
        assert!(text.contains("TIME(1:1:0) DirectSMF($FF,$51,$03,$00,$FF,$41)"));
    }

    #[test]
    fn puts_a_separator_before_every_track() {
        let text = dump(&smf(&[END_OF_TRACK, END_OF_TRACK])).expect("valid SMF");
        assert_eq!(text.matches(TRACK_SEPARATOR).count(), 2);
        assert!(text.starts_with("// SMF format=1 timebase=96 tracks=2"));
    }

    #[test]
    fn rejects_truncated_input_without_panicking() {
        assert!(dump(b"MThd").is_err());
        let truncated = b"MThd\0\0\0\x06\0\x01\0\x01\0\x60MTrk\0\0\0\x02\x81";
        assert!(dump(truncated).is_err());
    }

    #[test]
    fn rejects_a_status_byte_where_channel_data_is_required() {
        let midi = b"MThd\0\0\0\x06\0\x01\0\x01\0\x60\
            MTrk\0\0\0\x04\0\x90\x3c\xff";
        assert!(dump(midi).is_err());
    }
}
