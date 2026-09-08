//! Character encoding boundary.
//!
//! Everything inside the compiler is UTF-8 (Rust `String`/`char`). Legacy
//! encodings are confined to this module:
//!
//! * input  — MML sources and `#Include` files may be UTF-8 or CP932
//!   (Windows-31J), auto-detected.
//! * output — SMF meta text is always written as CP932, so files stay
//!   readable on the Japanese MIDI players the Pascal version targets.
//!
//! The conversion tables are our own (see `tools/gen_cp932.py`) rather than a
//! dependency: `encoding_rs` was 190 KB of the WASM binary, nearly all of it
//! encodings this compiler never uses.

mod cp932_table;

use crate::error::Warning;
use cp932_table::{CP932_TO_UNICODE, UNICODE_TO_CP932};

/// Which encoding [`decode_auto`] decided the bytes were in.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SourceEncoding {
    Utf8,
    Cp932,
}

/// Decode MML source bytes, auto-detecting UTF-8 vs CP932.
///
/// Strict UTF-8 wins when it applies: pure ASCII and well-formed UTF-8 decode
/// as UTF-8, and anything else is treated as CP932. A UTF-8 BOM is stripped.
pub fn decode_auto(bytes: &[u8]) -> (String, SourceEncoding) {
    let bytes = bytes.strip_prefix(b"\xef\xbb\xbf").unwrap_or(bytes);
    match std::str::from_utf8(bytes) {
        Ok(s) => (s.to_string(), SourceEncoding::Utf8),
        Err(_) => (decode_cp932(bytes), SourceEncoding::Cp932),
    }
}

/// Decode CP932 bytes, substituting U+FFFD for anything malformed.
pub fn decode_cp932(bytes: &[u8]) -> String {
    let mut out = String::with_capacity(bytes.len());
    let mut index = 0;
    while index < bytes.len() {
        let byte = bytes[index];
        match byte {
            0x00..=0x7f => {
                out.push(byte as char);
                index += 1;
            }
            // Half-width katakana occupy a single byte.
            0xa1..=0xdf => {
                out.push(char::from_u32(0xff61 + (byte as u32 - 0xa1)).unwrap_or('\u{fffd}'));
                index += 1;
            }
            _ => {
                let trail = bytes.get(index + 1).copied();
                match trail.and_then(|t| lookup_unicode(u16::from_be_bytes([byte, t]))) {
                    Some(ch) => {
                        out.push(ch);
                        index += 2;
                    }
                    None => {
                        out.push('\u{fffd}');
                        index += 1;
                    }
                }
            }
        }
    }
    out
}

fn lookup_unicode(code: u16) -> Option<char> {
    let position = CP932_TO_UNICODE
        .binary_search_by_key(&code, |(cp932, _)| *cp932)
        .ok()?;
    char::from_u32(CP932_TO_UNICODE[position].1 as u32)
}

fn lookup_cp932(ch: char) -> Option<u16> {
    let scalar = u16::try_from(ch as u32).ok()?;
    let position = UNICODE_TO_CP932
        .binary_search_by_key(&scalar, |(unicode, _)| *unicode)
        .ok()?;
    Some(UNICODE_TO_CP932[position].1)
}

/// Encode text as CP932 for an SMF meta event.
///
/// Characters CP932 cannot represent (emoji, say) are replaced rather than
/// failing the compile; each replacement is reported as a warning so the user
/// knows the file does not say quite what they wrote.
pub fn encode_cp932(text: &str, line: usize) -> (Vec<u8>, Vec<Warning>) {
    let mut out = Vec::with_capacity(text.len());
    let mut warnings = Vec::new();
    let mut unmappable = Vec::new();

    for ch in text.chars() {
        match ch {
            '\0'..='\u{7f}' => out.push(ch as u8),
            '\u{ff61}'..='\u{ff9f}' => out.push((ch as u32 - 0xff61 + 0xa1) as u8),
            _ => match lookup_cp932(ch) {
                Some(code) => out.extend_from_slice(&code.to_be_bytes()),
                None => {
                    out.push(b'?');
                    unmappable.push(ch);
                }
            },
        }
    }

    if !unmappable.is_empty() {
        let chars: String = unmappable.iter().collect();
        warnings.push(Warning::new(
            line,
            format!("CP932で表現できない文字を \"?\" に置換しました: {chars}"),
        ));
    }
    (out, warnings)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ascii_is_utf8() {
        let (s, enc) = decode_auto(b"cdefg");
        assert_eq!(s, "cdefg");
        assert_eq!(enc, SourceEncoding::Utf8);
    }

    #[test]
    fn detects_utf8_japanese() {
        let (s, enc) = decode_auto("ドレミ".as_bytes());
        assert_eq!(s, "ドレミ");
        assert_eq!(enc, SourceEncoding::Utf8);
    }

    #[test]
    fn detects_cp932_japanese() {
        // "テスト" in CP932
        let (s, enc) = decode_auto(&[0x83, 0x65, 0x83, 0x58, 0x83, 0x67]);
        assert_eq!(s, "テスト");
        assert_eq!(enc, SourceEncoding::Cp932);
    }

    #[test]
    fn strips_utf8_bom() {
        let (s, enc) = decode_auto(b"\xef\xbb\xbfcde");
        assert_eq!(s, "cde");
        assert_eq!(enc, SourceEncoding::Utf8);
    }

    #[test]
    fn encodes_cp932_without_warning() {
        let (bytes, warnings) = encode_cp932("テスト", 1);
        assert_eq!(bytes, vec![0x83, 0x65, 0x83, 0x58, 0x83, 0x67]);
        assert!(warnings.is_empty());
    }

    #[test]
    fn replaces_unmappable_chars_with_warning() {
        let (bytes, warnings) = encode_cp932("a🎵b", 3);
        assert_eq!(bytes, b"a?b");
        assert_eq!(warnings.len(), 1);
        assert_eq!(warnings[0].line, 3);
    }

    #[test]
    fn half_width_katakana_round_trip() {
        let (bytes, warnings) = encode_cp932("ｱｲｳ", 1);
        assert_eq!(bytes, vec![0xb1, 0xb2, 0xb3]);
        assert!(warnings.is_empty());
        assert_eq!(decode_cp932(&bytes), "ｱｲｳ");
    }

    /// Every mapping in the table must survive a round trip, so meta text
    /// written by the compiler reads back as what the user typed.
    #[test]
    fn every_table_entry_round_trips() {
        for (code, unicode) in cp932_table::CP932_TO_UNICODE {
            let ch = char::from_u32(*unicode as u32).expect("table holds scalars");
            let decoded = decode_cp932(&code.to_be_bytes());
            assert_eq!(decoded.chars().next(), Some(ch), "decoding {code:#06x}");

            let (encoded, warnings) = encode_cp932(&ch.to_string(), 1);
            assert!(warnings.is_empty(), "{ch} should be encodable");
            // Duplicate codes exist; re-decoding must give the same character.
            assert_eq!(decode_cp932(&encoded), ch.to_string());
        }
    }

    #[test]
    fn malformed_cp932_decodes_to_replacement_not_panic() {
        assert_eq!(decode_cp932(&[0x81]), "\u{fffd}");
        assert_eq!(decode_cp932(&[0x81, 0x20]), "\u{fffd} ");
    }
}
