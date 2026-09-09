//! Source cursor.
//!
//! The Pascal version walks the source with a `PChar` and has to know where
//! SJIS multi-byte characters start and end. Here the source is a `Vec<char>`,
//! so every position is a whole character and multi-byte text needs no special
//! handling at all.

pub mod sutoton;
pub mod zenkaku;

/// A character-wise cursor over the MML source, tracking the current line.
#[derive(Debug, Clone)]
pub struct Cursor {
    chars: Vec<char>,
    pos: usize,
    line: usize,
}

impl Cursor {
    pub fn new(src: &str) -> Self {
        Self::with_line(src, 1)
    }

    /// A cursor whose first line is numbered `start_line`, so diagnostics from
    /// a fragment (a loop body, say) still point at the original source.
    pub fn with_line(src: &str, start_line: usize) -> Self {
        Self {
            chars: src.chars().collect(),
            pos: 0,
            line: start_line.max(1),
        }
    }

    /// 1-based line number at the cursor.
    pub fn line(&self) -> usize {
        self.line
    }

    pub fn is_eof(&self) -> bool {
        self.pos >= self.chars.len()
    }

    pub fn peek(&self) -> Option<char> {
        self.chars.get(self.pos).copied()
    }

    pub fn peek_at(&self, offset: usize) -> Option<char> {
        self.chars.get(self.pos + offset).copied()
    }

    pub fn advance(&mut self) -> Option<char> {
        let ch = self.chars.get(self.pos).copied()?;
        self.pos += 1;
        if ch == '\n' {
            self.line += 1;
        }
        Some(ch)
    }

    /// Consume `ch` if it is next, reporting whether it was there.
    pub fn eat(&mut self, ch: char) -> bool {
        if self.peek() == Some(ch) {
            self.advance();
            true
        } else {
            false
        }
    }

    /// Consume whichever of `chars` is next, if any.
    pub fn eat_any(&mut self, chars: &[char]) -> Option<char> {
        let ch = self.peek()?;
        if chars.contains(&ch) {
            self.advance();
            Some(ch)
        } else {
            None
        }
    }

    /// Skip whitespace, line breaks, `;`, and `//` / `/* */` comments.
    pub fn skip_trivia(&mut self) {
        loop {
            match self.peek() {
                Some(c) if c.is_whitespace() || c == ';' => {
                    self.advance();
                }
                Some('/') if self.peek_at(1) == Some('/') => {
                    while let Some(c) = self.peek() {
                        if c == '\n' {
                            break;
                        }
                        self.advance();
                    }
                }
                Some('/') if self.peek_at(1) == Some('*') => {
                    self.advance();
                    self.advance();
                    while !self.is_eof() {
                        if self.peek() == Some('*') && self.peek_at(1) == Some('/') {
                            self.advance();
                            self.advance();
                            break;
                        }
                        self.advance();
                    }
                }
                _ => return,
            }
        }
    }

    /// Skip spaces and tabs only (not line breaks).
    pub fn skip_spaces(&mut self) {
        while matches!(self.peek(), Some(' ') | Some('\t')) {
            self.advance();
        }
    }

    /// Read a run of ASCII digits as an integer, if one is next.
    pub fn read_int(&mut self) -> Option<i64> {
        let negative =
            if self.peek() == Some('-') && self.peek_at(1).is_some_and(|c| c.is_ascii_digit()) {
                self.advance();
                true
            } else {
                false
            };
        let mut digits = String::new();
        while let Some(c) = self.peek() {
            if c.is_ascii_digit() {
                digits.push(c);
                self.advance();
            } else {
                break;
            }
        }
        if digits.is_empty() {
            return None;
        }
        let value: i64 = digits.parse().ok()?;
        Some(if negative { -value } else { value })
    }

    /// Read a run of hexadecimal digits as an integer, if one is next.
    pub fn read_hex(&mut self) -> Option<i64> {
        let mut digits = String::new();
        while let Some(c) = self.peek() {
            if c.is_ascii_hexdigit() {
                digits.push(c);
                self.advance();
            } else {
                break;
            }
        }
        i64::from_str_radix(&digits, 16).ok()
    }

    /// Read the text up to the `close` that matches an already-consumed
    /// `open`, honouring nesting and skipping over quoted strings.
    ///
    /// Returns `None` when the bracket is never closed.
    pub fn read_balanced(&mut self, open: char, close: char) -> Option<String> {
        let mut body = String::new();
        let mut depth = 1usize;
        let mut in_string = false;
        loop {
            let ch = self.advance()?;
            if in_string {
                body.push(ch);
                if ch == '"' {
                    in_string = false;
                }
                continue;
            }
            match ch {
                // A string starts at `{"`, both characters at once; a bare
                // `"` lowers the octave for one note, so it must not swallow
                // the rest of the block.
                '{' if self.peek() == Some('"') => {
                    self.advance();
                    in_string = true;
                    if open == '{' {
                        depth += 1;
                    }
                    body.push('{');
                    body.push('"');
                }
                c if c == open => {
                    depth += 1;
                    body.push(c);
                }
                c if c == close => {
                    depth -= 1;
                    if depth == 0 {
                        return Some(body);
                    }
                    body.push(c);
                }
                c => body.push(c),
            }
        }
    }

    /// Read an identifier: a letter or `_` followed by letters, digits or `_`.
    pub fn read_word(&mut self) -> Option<String> {
        let first = self.peek()?;
        if !(first.is_ascii_alphabetic() || first == '_') {
            return None;
        }
        let mut word = String::new();
        while let Some(c) = self.peek() {
            if c.is_ascii_alphanumeric() || c == '_' {
                word.push(c);
                self.advance();
            } else {
                break;
            }
        }
        Some(word)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn tracks_lines() {
        let mut cur = Cursor::new("c\nd\ne");
        assert_eq!(cur.line(), 1);
        cur.advance();
        cur.advance();
        assert_eq!(cur.line(), 2);
    }

    #[test]
    fn skips_comments_and_separators() {
        let mut cur = Cursor::new("  // comment\n /* block */ ; c");
        cur.skip_trivia();
        assert_eq!(cur.peek(), Some('c'));
    }

    #[test]
    fn reads_ints_and_words() {
        let mut cur = Cursor::new("Tempo=120");
        assert_eq!(cur.read_word().as_deref(), Some("Tempo"));
        assert!(cur.eat('='));
        assert_eq!(cur.read_int(), Some(120));
    }

    #[test]
    fn reads_hex_digits() {
        let mut cur = Cursor::new("F7,");
        assert_eq!(cur.read_hex(), Some(0xf7));
        assert_eq!(cur.peek(), Some(','));
        assert_eq!(Cursor::new("10").read_hex(), Some(0x10));
        assert_eq!(Cursor::new("zz").read_hex(), None);
    }

    #[test]
    fn handles_multibyte_chars_one_at_a_time() {
        let mut cur = Cursor::new("ドレミ");
        assert_eq!(cur.advance(), Some('ド'));
        assert_eq!(cur.advance(), Some('レ'));
        assert_eq!(cur.advance(), Some('ミ'));
        assert!(cur.is_eof());
    }
}
