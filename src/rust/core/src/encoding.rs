//! Character encoding boundary.
//!
//! Everything inside the compiler is UTF-8 (Rust `String`/`char`). Legacy
//! encodings are confined to this module:
//!
//! * input  — MML sources and `#Include` files may be UTF-8 or CP932
//!   (Windows-31J / Shift_JIS), auto-detected.
//! * output — SMF meta text is always written as CP932, so files stay
//!   readable on the Japanese MIDI players the Pascal version targets.

use crate::error::Warning;

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
        Err(_) => {
            let (cow, _, _) = encoding_rs::SHIFT_JIS.decode(bytes);
            (cow.into_owned(), SourceEncoding::Cp932)
        }
    }
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
        let mut buf = [0u8; 4];
        let s = ch.encode_utf8(&mut buf);
        let (encoded, _, had_errors) = encoding_rs::SHIFT_JIS.encode(s);
        if had_errors {
            out.push(b'?');
            unmappable.push(ch);
        } else {
            out.extend_from_slice(&encoded);
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
}
