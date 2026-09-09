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

/// Rewrite a rhythm-mode body into ordinary MML.
///
/// Characters with no macro pass through untouched, which is what lets
/// `l16[4 brbr ]` mix note lengths and loops with drum hits.
pub fn expand(body: &str, macros: &Macros) -> String {
    let chars: Vec<char> = body.chars().collect();
    let mut out = String::with_capacity(body.len());
    let mut index = 0;
    // `Div` switches `{...}` from a Sub block to a plain group.
    let mut in_div = false;

    while index < chars.len() {
        let ch = chars[index];

        // `$c{...}` defines a macro; it contributes nothing to the output.
        if ch == '$' {
            index += 1;
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
            let expanded = expand(&inner, macros);
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

    #[test]
    fn expands_defined_characters() {
        assert_eq!(expand("bb", &macros()), "n36,n36,");
        assert_eq!(expand("bs", &macros()), "n36,n38,");
    }

    #[test]
    fn leaves_everything_else_alone() {
        // Lengths, rests and loops still mean what they usually mean.
        assert_eq!(expand("l8 brbr", &macros()), "l8 n36,rn36,r");
        assert_eq!(expand("[4 bb]", &macros()), "[4 n36,n36,]");
    }

    #[test]
    fn substitutes_an_argument_for_a_question_mark() {
        let mut macros = Macros::new();
        macros.insert('x', "n?,".to_string());
        assert_eq!(expand("x36 x38", &macros), "n36, n38,");
        // With no number following, the placeholder simply empties.
        assert_eq!(expand("x", &macros), "n,");
    }

    #[test]
    fn parentheses_escape_to_ordinary_mml() {
        let expanded = expand("( Track(2) )bb", &macros());
        assert!(expanded.starts_with(" Track(2) "), "{expanded}");
        assert!(expanded.ends_with("n36,n36,"), "{expanded}");
    }

    #[test]
    fn braces_become_sub_blocks() {
        assert_eq!(expand("{bb}", &macros()), "Sub{n36,n36,}");
    }

    #[test]
    fn a_div_group_stays_a_plain_group() {
        assert_eq!(expand("Div{bb}4", &macros()), "Div{n36,n36,}4");
    }

    #[test]
    fn japanese_text_passes_through() {
        assert_eq!(expand("ドレミ", &macros()), "ドレミ");
    }
}
