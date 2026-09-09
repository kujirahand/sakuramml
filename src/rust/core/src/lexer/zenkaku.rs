//! Full-width and Japanese symbols to their half-width equivalents.
//!
//! The Pascal version (`ConvToHalfSign` in `mml_token.pas`) walks SJIS bytes
//! and needs a lead-byte table to do this. On UTF-8 it is a plain per-`char`
//! mapping: the full-width ASCII block converts arithmetically, and the rest
//! comes from the table below, taken from that same function.
//!
//! Note what it covers beyond punctuation: 【】 become brackets, ↑↓ become
//! octave changes, and kanji numerals become digits, so `音量１２７` and
//! `トラック三` are ordinary MML once converted.

/// Symbols with no arithmetic mapping, from `ConvToHalfSign`.
const SYMBOLS: &[(char, char)] = &[
    ('　', ' '),
    ('”', '"'),
    ('’', '\''),
    ('〜', '‾'),
    ('−', '-'),
    ('￥', '¥'),
    ('「', '\''),
    ('」', '\''),
    ('、', ','),
    ('。', '.'),
    ('‘', '`'),
    ('♯', '#'),
    ('♭', '-'),
    ('『', '{'),
    ('』', '}'),
    ('【', '['),
    ('】', ']'),
    ('一', '1'),
    ('二', '2'),
    ('三', '3'),
    ('四', '4'),
    ('五', '5'),
    ('六', '6'),
    ('七', '7'),
    ('八', '8'),
    ('九', '9'),
    ('零', '0'),
    ('壱', '1'),
    ('弐', '2'),
    ('参', '3'),
    ('〇', '0'),
    ('↑', '>'),
    ('↓', '<'),
];

/// Convert a full-width character to its half-width equivalent, if it has one.
pub fn to_half_width(ch: char) -> Option<char> {
    // Full-width ASCII: '！'(U+FF01) ..= '～'(U+FF5E) maps to '!'..='~'.
    if ('\u{FF01}'..='\u{FF5E}').contains(&ch) {
        return char::from_u32('!' as u32 + (ch as u32 - 0xFF01));
    }
    SYMBOLS
        .iter()
        .find(|(from, _)| *from == ch)
        .map(|(_, to)| *to)
}

/// Normalise full-width symbols in a source string.
///
/// Text inside double quotes is left alone: it is user data (track names,
/// lyrics), not MML syntax — and its digits and brackets must survive intact.
pub fn normalize(src: &str) -> String {
    let mut out = String::with_capacity(src.len());
    let chars: Vec<char> = src.chars().collect();
    let mut index = 0;
    let mut in_string = false;
    while index < chars.len() {
        let ch = chars[index];
        if in_string {
            out.push(ch);
            if ch == '"' {
                in_string = false;
            }
            index += 1;
            continue;
        }
        // A string starts at `{"`, both characters at once. A bare `"` is the
        // octave-down operator, so it must not open one — `q30 d"ad` is three
        // notes, not a string.
        if ch == '{' && chars.get(index + 1) == Some(&'"') {
            out.push('{');
            out.push('"');
            index += 2;
            in_string = true;
            continue;
        }
        out.push(to_half_width(ch).unwrap_or(ch));
        index += 1;
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
    fn converts_japanese_brackets_and_arrows() {
        // 【…】 group notes, ↑↓ change octave.
        assert_eq!(normalize("【ドレミ】"), "[ドレミ]");
        assert_eq!(normalize("↑ド↓レ"), ">ド<レ");
        assert_eq!(normalize("『a』"), "{a}");
    }

    #[test]
    fn converts_musical_signs() {
        assert_eq!(normalize("ド♯レ♭"), "ド#レ-");
    }

    #[test]
    fn converts_kanji_numerals() {
        assert_eq!(normalize("音量一二三"), "音量123");
        assert_eq!(normalize("トラック零"), "トラック0");
    }

    #[test]
    fn leaves_japanese_words_alone() {
        assert_eq!(normalize("ドレミ"), "ドレミ");
    }

    #[test]
    fn leaves_quoted_text_alone() {
        assert_eq!(
            normalize(r#"TrackName={"テスト１【】"}"#),
            r#"TrackName={"テスト１【】"}"#
        );
    }
}
