//! Expression parsing and evaluation.
//!
//! Expressions are only valid inside parentheses — `o(x)` and `Tempo=(x*60)`
//! work, while `ox` and `Tempo=100+20` are errors. That is not a
//! simplification: the Pascal build rejects the bare forms too, and the rule is
//! what keeps `v100 <c` unambiguous (the `<` is an octave change, not a
//! comparison).

use std::collections::HashMap;

use crate::error::{MmlError, Result};
use crate::lexer::Cursor;

/// A variable's value. MML has integers, strings and integer arrays.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Value {
    Int(i64),
    Str(String),
    Array(Vec<i64>),
}

impl Value {
    /// Numeric view of a value; strings and arrays are not numbers.
    pub fn as_int(&self, line: usize) -> Result<i64> {
        match self {
            Value::Int(v) => Ok(*v),
            Value::Str(s) => s
                .trim()
                .parse()
                .map_err(|_| MmlError::new(line, format!("数値ではありません: \"{s}\""))),
            Value::Array(_) => Err(MmlError::new(line, "配列は数値として使えません")),
        }
    }

    pub fn as_str(&self) -> String {
        match self {
            Value::Int(v) => v.to_string(),
            Value::Str(s) => s.clone(),
            Value::Array(items) => items
                .iter()
                .map(|v| v.to_string())
                .collect::<Vec<_>>()
                .join(","),
        }
    }

    pub fn truthy(&self) -> bool {
        match self {
            Value::Int(v) => *v != 0,
            Value::Str(s) => !s.is_empty(),
            Value::Array(items) => !items.is_empty(),
        }
    }
}

pub type Variables = HashMap<String, Value>;

/// Evaluate an expression at the cursor, stopping at the first character that
/// cannot continue it (typically the closing parenthesis).
pub fn eval(cur: &mut Cursor, vars: &Variables) -> Result<Value> {
    parse_or(cur, vars)
}

fn parse_or(cur: &mut Cursor, vars: &Variables) -> Result<Value> {
    let mut left = parse_and(cur, vars)?;
    loop {
        cur.skip_spaces();
        if cur.peek() == Some('|') && cur.peek_at(1) == Some('|') {
            cur.advance();
            cur.advance();
            let right = parse_and(cur, vars)?;
            left = Value::Int((left.truthy() || right.truthy()) as i64);
        } else {
            return Ok(left);
        }
    }
}

fn parse_and(cur: &mut Cursor, vars: &Variables) -> Result<Value> {
    let mut left = parse_comparison(cur, vars)?;
    loop {
        cur.skip_spaces();
        if cur.peek() == Some('&') && cur.peek_at(1) == Some('&') {
            cur.advance();
            cur.advance();
            let right = parse_comparison(cur, vars)?;
            left = Value::Int((left.truthy() && right.truthy()) as i64);
        } else {
            return Ok(left);
        }
    }
}

fn parse_comparison(cur: &mut Cursor, vars: &Variables) -> Result<Value> {
    let line = cur.line();
    let left = parse_additive(cur, vars)?;
    cur.skip_spaces();

    let op = match (cur.peek(), cur.peek_at(1)) {
        (Some('='), Some('=')) => "==",
        (Some('!'), Some('=')) => "!=",
        (Some('<'), Some('=')) => "<=",
        (Some('>'), Some('=')) => ">=",
        (Some('<'), _) => "<",
        (Some('>'), _) => ">",
        _ => return Ok(left),
    };
    for _ in 0..op.len() {
        cur.advance();
    }

    let right = parse_additive(cur, vars)?;
    // Strings compare as strings; anything else compares numerically.
    let result = match (&left, &right) {
        (Value::Str(a), Value::Str(b)) => match op {
            "==" => a == b,
            "!=" => a != b,
            "<" => a < b,
            ">" => a > b,
            "<=" => a <= b,
            _ => a >= b,
        },
        _ => {
            let (a, b) = (left.as_int(line)?, right.as_int(line)?);
            match op {
                "==" => a == b,
                "!=" => a != b,
                "<" => a < b,
                ">" => a > b,
                "<=" => a <= b,
                _ => a >= b,
            }
        }
    };
    Ok(Value::Int(result as i64))
}

fn parse_additive(cur: &mut Cursor, vars: &Variables) -> Result<Value> {
    let line = cur.line();
    let mut left = parse_multiplicative(cur, vars)?;
    loop {
        cur.skip_spaces();
        let op = match cur.peek() {
            // `||` is the or-operator, not two additions.
            Some('+') => '+',
            Some('-') => '-',
            _ => return Ok(left),
        };
        cur.advance();
        let right = parse_multiplicative(cur, vars)?;

        left = match (&left, op) {
            // `+` concatenates when either side is a string.
            (Value::Str(s), '+') => Value::Str(format!("{s}{}", right.as_str())),
            _ => {
                if op == '+' {
                    if let Value::Str(s) = &right {
                        Value::Str(format!("{}{s}", left.as_str()))
                    } else {
                        Value::Int(left.as_int(line)? + right.as_int(line)?)
                    }
                } else {
                    Value::Int(left.as_int(line)? - right.as_int(line)?)
                }
            }
        };
    }
}

fn parse_multiplicative(cur: &mut Cursor, vars: &Variables) -> Result<Value> {
    let line = cur.line();
    let mut left = parse_unary(cur, vars)?;
    loop {
        cur.skip_spaces();
        let op = match cur.peek() {
            Some('*') => '*',
            Some('/') => '/',
            Some('%') => '%',
            _ => return Ok(left),
        };
        cur.advance();
        let right = parse_unary(cur, vars)?;
        let (a, b) = (left.as_int(line)?, right.as_int(line)?);
        let value = match op {
            '*' => a.wrapping_mul(b),
            _ if b == 0 => return Err(MmlError::new(line, "0で割ることはできません")),
            '/' => a / b,
            _ => a % b,
        };
        left = Value::Int(value);
    }
}

fn parse_unary(cur: &mut Cursor, vars: &Variables) -> Result<Value> {
    let line = cur.line();
    cur.skip_spaces();
    match cur.peek() {
        Some('-') => {
            cur.advance();
            let value = parse_unary(cur, vars)?;
            Ok(Value::Int(-value.as_int(line)?))
        }
        Some('+') => {
            cur.advance();
            parse_unary(cur, vars)
        }
        Some('!') if cur.peek_at(1) != Some('=') => {
            cur.advance();
            let value = parse_unary(cur, vars)?;
            Ok(Value::Int(!value.truthy() as i64))
        }
        _ => parse_primary(cur, vars),
    }
}

fn parse_primary(cur: &mut Cursor, vars: &Variables) -> Result<Value> {
    let line = cur.line();
    cur.skip_spaces();

    match cur.peek() {
        Some('(') => {
            cur.advance();
            let value = eval(cur, vars)?;
            cur.skip_spaces();
            if !cur.eat(')') {
                return Err(MmlError::new(line, "括弧が閉じられていません"));
            }
            Ok(value)
        }
        Some('"') => {
            cur.advance();
            let mut text = String::new();
            loop {
                match cur.advance() {
                    Some('"') => break,
                    Some(c) => text.push(c),
                    None => return Err(MmlError::new(line, "文字列が閉じられていません")),
                }
            }
            Ok(Value::Str(text))
        }
        Some('{') => {
            cur.advance();
            let body = cur
                .read_balanced('{', '}')
                .ok_or_else(|| MmlError::new(line, "{ が } で閉じられていません"))?;
            let trimmed = body.trim();
            let inner = trimmed
                .strip_prefix('"')
                .and_then(|s| s.strip_suffix('"'))
                .unwrap_or(trimmed);
            Ok(Value::Str(inner.to_string()))
        }
        Some(c) if c.is_ascii_digit() => {
            let value = cur
                .read_int()
                .ok_or_else(|| MmlError::new(line, "数値を読み取れません"))?;
            Ok(Value::Int(value))
        }
        Some(c) if c.is_ascii_alphabetic() || c == '_' => {
            let name = cur
                .read_word()
                .ok_or_else(|| MmlError::new(line, "変数名を読み取れません"))?;
            match name.as_str() {
                "on" | "ON" => return Ok(Value::Int(1)),
                "off" | "OFF" => return Ok(Value::Int(0)),
                _ => {}
            }
            let value = vars
                .get(&name)
                .ok_or_else(|| MmlError::new(line, format!("変数\"{name}\"は未定義です")))?;

            // `name(index)` indexes an array.
            cur.skip_spaces();
            if let Value::Array(items) = value {
                if cur.eat('(') {
                    let index = eval(cur, vars)?.as_int(line)?;
                    cur.skip_spaces();
                    cur.eat(')');
                    return items
                        .get(index as usize)
                        .copied()
                        .map(Value::Int)
                        .ok_or_else(|| {
                            MmlError::new(line, format!("配列\"{name}\"の範囲外です: {index}"))
                        });
                }
            }
            Ok(value.clone())
        }
        _ => Err(MmlError::new(line, "式を読み取れません")),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn eval_str(src: &str, vars: &Variables) -> Result<Value> {
        let mut cur = Cursor::new(src);
        eval(&mut cur, vars)
    }

    fn int(src: &str) -> i64 {
        eval_str(src, &Variables::new()).unwrap().as_int(1).unwrap()
    }

    #[test]
    fn arithmetic_and_precedence() {
        assert_eq!(int("1+2"), 3);
        assert_eq!(int("2+3*4"), 14);
        assert_eq!(int("(2+3)*4"), 20);
        assert_eq!(int("10/3"), 3);
        assert_eq!(int("10%3"), 1);
        assert_eq!(int("-5+2"), -3);
    }

    #[test]
    fn comparisons_and_logic() {
        assert_eq!(int("1==1"), 1);
        assert_eq!(int("1!=1"), 0);
        assert_eq!(int("2>1"), 1);
        assert_eq!(int("2<=1"), 0);
        assert_eq!(int("1&&0"), 0);
        assert_eq!(int("1||0"), 1);
        assert_eq!(int("on"), 1);
        assert_eq!(int("off"), 0);
    }

    #[test]
    fn variables_resolve() {
        let mut vars = Variables::new();
        vars.insert("x".into(), Value::Int(60));
        let value = eval_str("x*2", &vars).unwrap();
        assert_eq!(value, Value::Int(120));
    }

    #[test]
    fn array_indexing() {
        let mut vars = Variables::new();
        vars.insert("a".into(), Value::Array(vec![10, 20, 30]));
        assert_eq!(eval_str("a(1)", &vars).unwrap(), Value::Int(20));
        assert!(eval_str("a(9)", &vars).is_err());
    }

    #[test]
    fn strings_concatenate_and_compare() {
        let mut vars = Variables::new();
        vars.insert("s".into(), Value::Str("ab".into()));
        assert_eq!(
            eval_str(r#"s+"c""#, &vars).unwrap(),
            Value::Str("abc".into())
        );
        assert_eq!(eval_str(r#"s=="ab""#, &vars).unwrap(), Value::Int(1));
    }

    #[test]
    fn division_by_zero_is_an_error_not_a_panic() {
        assert!(eval_str("1/0", &Variables::new()).is_err());
        assert!(eval_str("1%0", &Variables::new()).is_err());
    }

    #[test]
    fn undefined_variable_is_an_error() {
        assert!(eval_str("nope", &Variables::new()).is_err());
    }
}
