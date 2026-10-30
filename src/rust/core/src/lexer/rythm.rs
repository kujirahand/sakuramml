//! Rhythm mode: one character, one drum hit.
//!
//! `$b{n36,}` binds the character `b`, and inside `Rythm{ ... }` every `b`
//! expands to `n36,`. Like the Pascal build (`ReplaceRythm` in
//! `mml_base.pas`), this is a source-to-source pass: the body is rewritten
//! into ordinary MML and then compiled, so loops, lengths and everything else
//! keep working inside it.

use std::collections::HashMap;

/// Character to the MML it stands for.
pub type Macros = HashMap<char, String>;

/// The bindings every song starts with, from the Pascal build's
/// initialisation (`mml_system.pas`): the GM drum kit on single letters,
/// and `_` as a rest, which is what the underscores padding out rhythm
/// patterns are. A `$c{...}` definition replaces any of these.
pub fn default_macros() -> Macros {
    let mut macros = Macros::new();
    macros.insert('b', "n36,".to_string());
    macros.insert('s', "n38,".to_string());
    macros.insert('h', "n42,".to_string());
    macros.insert('m', "n46,".to_string());
    macros.insert('c', "n49,".to_string());
    macros.insert('H', "n50,".to_string());
    macros.insert('M', "n47,".to_string());
    macros.insert('L', "n43,".to_string());
    macros.insert('_', "r".to_string());
    macros
}

/// How deep `#name` inlining may nest before it is left as literal text.
/// Pascal recurses without a guard; a cycle there overflows the stack,
/// so any finite bound is strictly more forgiving.
const MAX_SHARP_DEPTH: usize = 32;

/// Rewrite a rhythm-mode body into ordinary MML.
///
/// Characters with no macro pass through untouched, which is what lets
/// `l16[4 brbr ]` mix note lengths and loops with drum hits.
///
/// `strings` resolves a `#name` to the text of the string macro it names:
/// Pascal's `ReplaceRythm` inlines a defined `#name` (recursively
/// rewritten) and leaves an undefined one as literal text for the
/// compiler's own macro expansion.
pub fn expand(body: &str, macros: &mut Macros, strings: &dyn Fn(&str) -> Option<String>) -> String {
    expand_at(body, macros, strings, 0)
}

fn expand_at(
    body: &str,
    macros: &mut Macros,
    strings: &dyn Fn(&str) -> Option<String>,
    depth: usize,
) -> String {
    let chars: Vec<char> = body.chars().collect();
    let mut out = String::with_capacity(body.len());
    let mut index = 0;
    // `Div` switches `{...}` from a Sub block to a plain group.
    let mut in_div = false;

    while index < chars.len() {
        let ch = chars[index];

        // `$c{...}` defines a macro for the rest of the pass, as
        // Pascal's scriptRythmChar does when ReplaceRythm meets `$`:
        // a `#name` inlined earlier on the same line can carry the
        // definitions the following patterns rely on. The definition
        // itself contributes nothing to the output.
        if ch == '$' {
            index += 1;
            if index >= chars.len() {
                break;
            }
            let name = chars[index];
            index += 1;
            if index < chars.len() && chars[index] == '=' {
                index += 1;
            }
            let (definition, next) = take_kakko(&chars, index);
            macros.insert(name, definition);
            index = next;
            continue;
        }

        // `#name` inlines the string macro it names, recursively
        // rewritten; an undefined name stays literal.
        if ch == '#' {
            let mut end = index + 1;
            while end < chars.len() && (chars[end].is_ascii_alphanumeric() || chars[end] == '_') {
                end += 1;
            }
            let name: String = chars[index..end].iter().collect();
            if depth < MAX_SHARP_DEPTH {
                if let Some(text) = strings(&name) {
                    out.push_str(&expand_at(&text, macros, strings, depth + 1));
                    index = end;
                    continue;
                }
            }
            out.push_str(&name);
            index = end;
            continue;
        }

        // `( ... )` is an escape back to ordinary MML.
        if ch == '(' {
            let (inner, next) = take_balanced(&chars, index, '(', ')');
            // `Sub` is dropped here: the pass adds its own below.
            out.push_str(&inner.replace("Sub", ""));
            // A trailing space keeps `(Track(1))l16` from running together.
            out.push(' ');
            if inner.contains("Div") {
                in_div = true;
            }
            index = next;
            continue;
        }

        // `{ ... }` becomes a Sub block, so the group plays without advancing
        // the time pointer — unless a Div is in play, where it is a plain group.
        if ch == '{' {
            let (inner, next) = take_balanced(&chars, index, '{', '}');
            let expanded = expand_at(&inner, macros, strings, depth);
            if in_div {
                out.push('{');
                out.push_str(&expanded);
                out.push('}');
                in_div = false;
            } else {
                out.push_str("Sub{");
                out.push_str(&expanded);
                out.push('}');
            }
            index = next;
            continue;
        }

        if starts_with(&chars, index, "Div") || starts_with(&chars, index, "DIV") {
            in_div = true;
            out.push_str("Div");
            index += 3;
            continue;
        }

        // Non-ASCII text is never a macro name, so it passes through whole.
        if !ch.is_ascii() {
            out.push(ch);
            index += 1;
            continue;
        }

        match macros.get(&ch) {
            Some(replacement) => {
                index += 1;
                if replacement.contains('?') {
                    // `$x{n?,}` takes the following number as its argument:
                    // `x36` becomes `n36,`.
                    let (argument, next) = take_argument(&chars, index);
                    index = next;
                    out.push_str(&replacement.replace('?', &argument));
                } else {
                    out.push_str(replacement);
                }
            }
            None => {
                out.push(ch);
                index += 1;
            }
        }
    }
    out
}

/// Read a `{...}` body with Pascal's `GetNakaKakko` rules: the scan does
/// not insist on an opening brace, it collects text with brace nesting
/// and stops at the close that returns the nesting to zero, or at the
/// end of the input. Returns the body and the position just past it.
fn take_kakko(chars: &[char], index: usize) -> (String, usize) {
    let mut nest: i64 = 0;
    let mut body = String::new();
    let mut position = index;
    while position < chars.len() {
        let ch = chars[position];
        position += 1;
        match ch {
            '{' => {
                if nest != 0 {
                    body.push(ch);
                }
                nest += 1;
            }
            '}' => {
                nest -= 1;
                if nest <= 0 {
                    break;
                }
                body.push(ch);
            }
            _ => body.push(ch),
        }
    }
    (body, position)
}

/// Read the text between `open` at `index` and its matching `close`.
/// Returns the inner text and the position just past the closing character.
fn take_balanced(chars: &[char], index: usize, open: char, close: char) -> (String, usize) {
    let mut depth = 0usize;
    let mut inner = String::new();
    let mut position = index;
    while position < chars.len() {
        let ch = chars[position];
        position += 1;
        if ch == open {
            depth += 1;
            if depth == 1 {
                continue;
            }
        } else if ch == close {
            depth -= 1;
            if depth == 0 {
                return (inner, position);
            }
        }
        inner.push(ch);
    }
    (inner, position)
}

/// Read a macro argument: digits, `$`, `.` and `^`, as the Pascal build does.
fn take_argument(chars: &[char], index: usize) -> (String, usize) {
    let mut argument = String::new();
    let mut position = index;
    if !matches!(chars.get(position), Some(c) if c.is_ascii_digit() || *c == '$' || *c == '^') {
        return (argument, position);
    }
    while let Some(&ch) = chars.get(position) {
        if ch.is_ascii_digit() || ch == '$' || ch == '.' || ch == '^' {
            argument.push(ch);
            position += 1;
        } else {
            break;
        }
    }
    (argument, position)
}

fn starts_with(chars: &[char], index: usize, word: &str) -> bool {
    word.chars()
        .enumerate()
        .all(|(offset, expected)| chars.get(index + offset) == Some(&expected))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn macros() -> Macros {
        let mut macros = Macros::new();
        macros.insert('b', "n36,".to_string());
        macros.insert('s', "n38,".to_string());
        macros
    }

    fn no_strings(_: &str) -> Option<String> {
        None
    }

    #[test]
    fn expands_defined_characters() {
        assert_eq!(expand("bb", &mut macros(), &no_strings), "n36,n36,");
        assert_eq!(expand("bs", &mut macros(), &no_strings), "n36,n38,");
    }

    #[test]
    fn leaves_everything_else_alone() {
        // Lengths, rests and loops still mean what they usually mean.
        assert_eq!(
            expand("l8 brbr", &mut macros(), &no_strings),
            "l8 n36,rn36,r"
        );
        assert_eq!(expand("[4 bb]", &mut macros(), &no_strings), "[4 n36,n36,]");
    }

    #[test]
    fn substitutes_an_argument_for_a_question_mark() {
        let mut macros = Macros::new();
        macros.insert('x', "n?,".to_string());
        assert_eq!(expand("x36 x38", &mut macros, &no_strings), "n36, n38,");
        // With no number following, the placeholder simply empties.
        assert_eq!(expand("x", &mut macros, &no_strings), "n,");
    }

    #[test]
    fn parentheses_escape_to_ordinary_mml() {
        let expanded = expand("( Track(2) )bb", &mut macros(), &no_strings);
        assert!(expanded.starts_with(" Track(2) "), "{expanded}");
        assert!(expanded.ends_with("n36,n36,"), "{expanded}");
    }

    #[test]
    fn braces_become_sub_blocks() {
        assert_eq!(expand("{bb}", &mut macros(), &no_strings), "Sub{n36,n36,}");
    }

    #[test]
    fn a_div_group_stays_a_plain_group() {
        assert_eq!(
            expand("Div{bb}4", &mut macros(), &no_strings),
            "Div{n36,n36,}4"
        );
    }

    #[test]
    fn japanese_text_passes_through() {
        assert_eq!(expand("ドレミ", &mut macros(), &no_strings), "ドレミ");
    }

    #[test]
    fn dollar_definitions_apply_within_the_pass() {
        // A definition carried in by an inlined `#name` registers its
        // character for the patterns that follow in the same block.
        let strings = |name: &str| -> Option<String> {
            match name {
                "#Defs" => Some("$R={n36,}".to_string()),
                _ => None,
            }
        };
        let mut map = Macros::new();
        assert_eq!(expand("#Defs R R", &mut map, &strings), " n36, n36,");
        assert_eq!(map.get(&'R').map(String::as_str), Some("n36,"));
    }

    #[test]
    fn sharp_names_inline_string_macros() {
        let strings = |name: &str| -> Option<String> {
            match name {
                "#Ptn" => Some("bb".to_string()),
                "#Nest" => Some("#Ptn s".to_string()),
                _ => None,
            }
        };
        // Defined names are inlined and rhythm-expanded recursively.
        assert_eq!(expand("#Ptn", &mut macros(), &strings), "n36,n36,");
        assert_eq!(expand("#Nest", &mut macros(), &strings), "n36,n36, n38,");
        // Undefined names stay literal for the compiler to expand.
        assert_eq!(expand("#Other", &mut macros(), &strings), "#Other");
    }
}
