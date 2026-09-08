//! Full-width to half-width normalisation.
//!
//! The Pascal version (`ConvToHalfSign` in `mml_token.pas`) walks SJIS bytes
//! and needs a lead-byte table to do this. On UTF-8 it is a plain per-`char`
//! mapping: full-width ASCII lives in a contiguous block, plus a handful of
//! punctuation marks that have no such mapping.

/// Convert a full-width character to its half-width equivalent, if it has one.
pub fn to_half_width(ch: char) -> Option<char> {
    match ch {
        // Full-width ASCII block: '！'(U+FF01) ..= '～'(U+FF5E) maps to '!'..='~'
        '\u{FF01}'..='\u{FF5E}' => {
            let offset = ch as u32 - 0xFF01;
            char::from_u32('!' as u32 + offset)
        }
        '\u{3000}' => Some(' '),  // ideographic space
        '\u{2019}' => Some('\''), // right single quotation
        '\u{201D}' => Some('"'),  // right double quotation
        '\u{2018}' => Some('\''),
        '\u{201C}' => Some('"'),
        '\u{2015}' | '\u{2500}' => Some('-'), // horizontal bar / box drawing
        _ => None,
    }
}

/// Normalise full-width symbols in a source string.
///
/// Text inside double quotes is left alone: it is user data (track names,
/// lyrics), not MML syntax.
pub fn normalize(src: &str) -> String {
    let mut out = String::with_capacity(src.len());
    let mut in_string = false;
    for ch in src.chars() {
        if ch == '"' {
            in_string = !in_string;
            out.push(ch);
            continue;
        }
        if in_string {
            out.push(ch);
            continue;
        }
        out.push(to_half_width(ch).unwrap_or(ch));
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn converts_full_width_ascii() {
        assert_eq!(normalize("ｃｄｅ"), "cde");
        assert_eq!(normalize("Ｔｅｍｐｏ＝１２０"), "Tempo=120");
        assert_eq!(normalize("（４：１：０）"), "(4:1:0)");
    }

    #[test]
    fn converts_ideographic_space() {
        assert_eq!(normalize("c　d"), "c d");
    }

    #[test]
    fn leaves_japanese_text_alone() {
        assert_eq!(normalize("ドレミ"), "ドレミ");
    }

    #[test]
    fn leaves_quoted_text_alone() {
        assert_eq!(
            normalize(r#"TrackName={"テスト１"}"#),
            r#"TrackName={"テスト１"}"#
        );
    }
}
