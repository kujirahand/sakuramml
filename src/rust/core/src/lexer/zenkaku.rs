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
    // Pascal's table converts the full-width punctuation and digits,
    // but NOT the full-width alphabet: `Ｔ` stays `Ｔ`, so a user
    // sutoton keyed on it can never rewrite the `T` of `TR` or `Time`.
    let converts = matches!(ch,
        '\u{FF01}'..='\u{FF0F}'
        | '\u{FF10}'..='\u{FF19}'
        | '\u{FF1A}'..='\u{FF20}'
        | '\u{FF3E}' | '\u{FF3F}'
        | '\u{FF5B}'..='\u{FF5E}');
    if converts {
        return char::from_u32('!' as u32 + (ch as u32 - 0xFF01));
    }
    SYMBOLS
        .iter()
        .find(|(from, _)| *from == ch)
        .map(|(_, to)| *to)
}

/// Copy a comment starting at `index` (which points at `/`) verbatim into
/// `out`, returning the position just past it. Block comments nest, as they
/// do in the Pascal build's `skipComment`.
pub(crate) fn push_comment(chars: &[char], index: usize, out: &mut String) -> Option<usize> {
    let mut position = index;
    if chars.get(position + 1) == Some(&'/') {
        while position < chars.len() {
            let ch = chars[position];
            out.push(ch);
            position += 1;
            if ch == '\n' {
                break;
            }
        }
        return Some(position);
    }
    if chars.get(position + 1) == Some(&'*') {
        let mut nest = 0;
        while position < chars.len() {
            let ch = chars[position];
            let next = chars.get(position + 1);
            out.push(ch);
            position += 1;
            if ch == '/' && next == Some(&'*') {
                out.push('*');
                position += 1;
                nest += 1;
            } else if ch == '*' && next == Some(&'/') {
                out.push('/');
                position += 1;
                nest -= 1;
                if nest <= 0 {
                    break;
                }
            }
        }
        return Some(position);
    }
    None
}

/// Normalise full-width symbols in a source string.
///
/// Text inside double quotes is left alone: it is user data (track names,
/// lyrics), not MML syntax — and its digits and brackets must survive intact.
/// Comments are likewise copied verbatim: Pascal's `ConvToHalfSign` skips
/// them, and converting prose could manufacture `/*` or `*/` sequences that
/// corrupt the comment's extent.
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
        if ch == '/' {
            if let Some(next) = push_comment(&chars, index, &mut out) {
                index = next;
                continue;
            }
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
        // Punctuation and digits convert; the full-width alphabet does
        // not — Pascal's `ConvToHalfSign` table has no letters in it, so
        // `ｃｄｅ` stays an (undefined) word and `Ｔ` stays available as a
        // sutoton key that cannot collide with ASCII commands.
        assert_eq!(normalize("ｃｄｅ"), "ｃｄｅ");
        assert_eq!(normalize("Ｔｅｍｐｏ＝１２０"), "Ｔｅｍｐｏ=120");
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
