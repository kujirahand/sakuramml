//! The "sutoton" (ストトン) layer: MML written in Japanese.
//!
//! `ドレミ` is `cde`, `テンポ120` is `Tempo=120`, and so on. The Pascal version
//! does this as a source-to-source pass before compiling (`SutotonToMml` in
//! `mml_token.pas`), and so do we — the table below is extracted from it.
//!
//! On UTF-8 this is plain longest-match string replacement. The Pascal
//! implementation has to walk SJIS bytes to do the same thing.

/// Japanese keyword to its MML equivalent, longest key first so that
/// `音量` matches before `音`.
pub const SUTOTON: &[(&str, &str)] = &[
    ("デクレッシェンド", "Cresc="),
    ("クレッシェンド", "Cresc="),
    ("ビブラートオフ", "M(0)"),
    ("ここから演奏", "PlayFrom(Time);"),
    ("チャンネル", "Channel="),
    (
        "音源初期化",
        "System.MeasureShift(1);ResetGM;Time(1:1:0);TrackSync;",
    ),
    ("ビブラート", "M.onNoteWaveEx(0,0,!4,0,96,!8);"),
    ("トラック", "Track="),
    ("コメント", "MetaText="),
    ("演奏位置", "PlayFrom"),
    ("音量戻す", "EP(127)"),
    ("方向左前", "P(32)"),
    ("方向右前", "P(96)"),
    ("方向回す", "P.onNoteWaveEx(0,127,!1,127,0,!1);"),
    ("テンポ改", "TempoChange="),
    ("ゲート", "q"),
    ("テンポ", "Tempo="),
    ("曖昧さ", ".Random="),
    ("リズム", "Rythm"),
    ("大きく", "Cresc="),
    ("小さく", "Decresc="),
    ("方向左", "P(0)"),
    ("方向前", "P(64)"),
    ("方向右", "P(127)"),
    ("ペダル", "y64,127;"),
    ("音階", "o"),
    ("時間", "Time"),
    ("読む", "Include"),
    ("予約", ".onNote="),
    ("拍子", "System.TimeSignature="),
    ("音色", "@"),
    ("音符", "l"),
    ("音量", "v"),
    ("連符", "Div"),
    ("曲名", "TrackName="),
    ("作者", "Copyright="),
    ("放す", "y64,0;"),
    ("調", "System.KeyFlag"),
    ("ー", "^"),
    ("上", ">"),
    ("下", "<"),
    ("ド", "c"),
    ("レ", "d"),
    ("ミ", "e"),
    ("フ", "f"),
    ("ァ", ""),
    ("ソ", "g"),
    ("ラ", "a"),
    ("シ", "b"),
    ("ン", "r"),
    ("ッ", "r"),
    ("ど", "c"),
    ("れ", "d"),
    ("み", "e"),
    ("ふ", "f"),
    ("ぁ", ""),
    ("そ", "g"),
    ("ら", "a"),
    ("し", "b"),
    ("ん", "r"),
    ("っ", "r"),
    ("イ", "a"),
    ("ロ", "b"),
    ("ハ", "c"),
    ("ニ", "d"),
    ("ホ", "e"),
    ("ヘ", "f"),
    ("ト", "g"),
    ("変", "-"),
    ("嬰", "+"),
    ("ず", "n36,"),
    ("た", "n38,"),
    ("つ", "n42,"),
    ("ち", "n46,"),
    ("ぱ", "n49,"),
    ("と", "n50,"),
    ("む", "n47,"),
    ("ろ", "n43,"),
];

/// A user-defined entry from `~{name}={mml}`, kept longest-key-first so a
/// longer name wins over a shorter one that prefixes it.
pub type UserMacros = Vec<(String, String)>;

/// Rewrite Japanese notation into plain MML.
pub fn to_mml(src: &str) -> String {
    let mut user = UserMacros::new();
    to_mml_with(src, &mut user)
}

/// As [`to_mml`], also honouring (and collecting) `~{name}={mml}` definitions.
///
/// The table is threaded through the whole compile, so a macro defined in an
/// include file is available to the song that included it.
///
/// Text inside double quotes is left untouched: it is song titles and lyrics,
/// not notation.
pub fn to_mml_with(src: &str, user: &mut UserMacros) -> String {
    let chars: Vec<char> = src.chars().collect();
    let mut out = String::with_capacity(src.len());
    let mut index = 0;
    let mut in_string = false;

    'outer: while index < chars.len() {
        let ch = chars[index];
        if in_string {
            out.push(ch);
            if ch == '"' {
                in_string = false;
            }
            index += 1;
            continue;
        }
        // A string starts at `{"`, both characters at once; a bare `"` is the
        // octave-down operator.
        if ch == '{' && chars.get(index + 1) == Some(&'"') {
            out.push('{');
            out.push('"');
            index += 2;
            in_string = true;
            continue;
        }
        // `~{name}={mml}` defines a macro and produces nothing itself.
        if ch == '~' {
            if let Some((name, replacement, next)) = read_definition(&chars, index) {
                user.push((name, replacement));
                // Longest first, so `方向左前` wins over `方向左`.
                user.sort_by(|a, b| b.0.chars().count().cmp(&a.0.chars().count()));
                index = next;
                continue;
            }
        }

        // User definitions take precedence over the built-in table.
        for (key, value) in user.iter() {
            let key_len = key.chars().count();
            if index + key_len <= chars.len()
                && chars[index..index + key_len]
                    .iter()
                    .copied()
                    .eq(key.chars())
            {
                out.push_str(value);
                index += key_len;
                continue 'outer;
            }
        }

        if ch.is_ascii() {
            out.push(ch);
            index += 1;
            continue;
        }
        for (key, value) in SUTOTON {
            let key_len = key.chars().count();
            if index + key_len <= chars.len()
                && chars[index..index + key_len]
                    .iter()
                    .copied()
                    .eq(key.chars())
            {
                out.push_str(value);
                index += key_len;
                continue 'outer;
            }
        }
        out.push(ch);
        index += 1;
    }
    out
}

/// Parse `~{name}={mml}` at `index`, returning the pair and the position
/// just past it.
fn read_definition(chars: &[char], index: usize) -> Option<(String, String, usize)> {
    let mut position = index + 1; // skip `~`
    while matches!(chars.get(position), Some(c) if *c == ' ' || *c == '\t') {
        position += 1;
    }
    let (name, position) = read_braced(chars, position)?;
    let mut position = position;
    while matches!(chars.get(position), Some(c) if *c == ' ' || *c == '\t') {
        position += 1;
    }
    if chars.get(position) == Some(&'=') {
        position += 1;
    }
    while matches!(chars.get(position), Some(c) if *c == ' ' || *c == '\t') {
        position += 1;
    }
    let (replacement, position) = read_braced(chars, position)?;
    if name.is_empty() {
        return None;
    }
    Some((name, replacement, position))
}

/// Read a `{ ... }` group, returning its contents and the position past it.
fn read_braced(chars: &[char], index: usize) -> Option<(String, usize)> {
    if chars.get(index) != Some(&'{') {
        return None;
    }
    let mut depth = 0usize;
    let mut body = String::new();
    let mut position = index;
    while let Some(&ch) = chars.get(position) {
        position += 1;
        if ch == '{' {
            depth += 1;
            if depth == 1 {
                continue;
            }
        } else if ch == '}' {
            depth -= 1;
            if depth == 0 {
                return Some((body, position));
            }
        }
        body.push(ch);
    }
    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn note_names() {
        assert_eq!(to_mml("ドレミ"), "cde");
        assert_eq!(to_mml("ドーレ"), "c^d");
    }

    #[test]
    fn longest_match_wins() {
        // 音量 must not be read as 音 + 量.
        assert_eq!(to_mml("音量127"), "v127");
        assert_eq!(to_mml("音階5"), "o5");
        assert_eq!(to_mml("テンポ120"), "Tempo=120");
    }

    #[test]
    fn ascii_passes_through() {
        assert_eq!(to_mml("cde Tempo=120"), "cde Tempo=120");
    }

    #[test]
    fn user_macros_define_and_expand() {
        // The definition itself disappears; later uses expand.
        assert_eq!(to_mml("~{G調}={Key(-5);}G調"), "Key(-5);");
        assert_eq!(to_mml("~{ドン}={c}ドン"), "c");
    }

    #[test]
    fn a_longer_user_macro_wins() {
        let src = "~{方向左}={P(0);}~{方向左前}={P(32);}方向左前 方向左";
        assert_eq!(to_mml(src), "P(32); P(0);");
    }

    #[test]
    fn user_macros_override_the_builtin_table() {
        // ド is normally c.
        assert_eq!(to_mml("~{ド}={n60}ド"), "n60");
    }

    #[test]
    fn quoted_text_is_left_alone() {
        assert_eq!(
            to_mml(r#"曲名{"ドレミの歌"}"#),
            r#"TrackName={"ドレミの歌"}"#
        );
    }
}
