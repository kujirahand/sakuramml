//! A deterministic, line-oriented view of an SMF file.
//!
//! Storage details such as delta-time VLQs and running status are normalized,
//! so ordinary text diff tools can compare the actual event streams.

use std::collections::{HashMap, VecDeque};

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
        out.push_str(&format!("TR({track_no})\n"));
        let durations = note_durations(events);
        for (index, event) in events.iter().enumerate() {
            if is_note_off(&event.bytes) || is_end_of_track(&event.bytes) {
                continue;
            }
            let time = format_time(event.time, midi.division);
            if let Some((channel, note, velocity)) = note_on(&event.bytes) {
                let gate = durations.get(&index).copied().unwrap_or(0);
                let length = next_note_distance(events, index).unwrap_or(gate);
                out.push_str(&format!(
                    "TIME({time}) CH({}) {}{},%{gate},{velocity}\n",
                    channel + 1,
                    note_name(note),
                    format_length(length, midi.division)
                ));
            } else if let Some((channel, controller, value)) = control_change(&event.bytes) {
                out.push_str(&format!(
                    "TIME({time}) CH({}) y{controller},{value}\n",
                    channel + 1
                ));
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

    #[test]
    fn dumps_notes_and_normalizes_running_status() {
        let midi = b"MThd\0\0\0\x06\0\x01\0\x01\0\x60\
            MTrk\0\0\0\x12\0\x90\x3c\x0c\x30\x3e\x0d\0\x80\x3c\0\x30\x3e\0\0\xff\x2f\0";
        let text = dump(midi).expect("valid SMF should dump");
        assert!(text.contains("TIME(1:1:0) CH(1) o5c8,%48,12"));
        assert!(text.contains("TIME(1:1:48) CH(1) o5d8,%48,13"));
        assert!(!text.contains("$90"));
    }

    #[test]
    fn dumps_non_note_events_as_direct_smf() {
        let midi = b"MThd\0\0\0\x06\0\x01\0\x01\0\x60\
            MTrk\0\0\0\x07\0\xc0\x05\0\xff\x2f\0";
        let text = dump(midi).expect("valid SMF should dump");
        assert!(text.contains("TIME(1:1:0) DirectSMF($C0,$05)"));
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
