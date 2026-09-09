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

/// What an expression can reach outside itself: variables, and functions.
///
/// The compiler implements this; expressions stay independent of it so the
/// evaluator can be tested on its own.
pub trait EvalContext {
    fn lookup(&self, name: &str) -> Option<Value>;

    /// Call `name` with already-evaluated arguments. `Ok(None)` means the
    /// function exists but returned nothing.
    fn call(&mut self, name: &str, args: Vec<Value>, line: usize) -> Result<Option<Value>>;

    fn has_function(&self, name: &str) -> bool;
}

/// A plain variable map, for expressions that cannot call functions.
impl EvalContext for Variables {
    fn lookup(&self, name: &str) -> Option<Value> {
        self.get(name).cloned()
    }

    fn call(&mut self, name: &str, _args: Vec<Value>, line: usize) -> Result<Option<Value>> {
        Err(MmlError::new(
            line,
            format!("関数\"{name}\"は呼び出せません"),
        ))
    }

    fn has_function(&self, _name: &str) -> bool {
        false
    }
}

/// Evaluate an expression at the cursor, stopping at the first character that
/// cannot continue it (typically the closing parenthesis).
pub fn eval(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    parse_or(cur, ctx)
}

/// Evaluate a single term — a number, a variable, a function call or a
/// parenthesised expression — without consuming any binary operator.
///
/// This is what follows `=` in a command argument: the Pascal build accepts
/// `Tempo=x` and `Tempo=Random(90,130)` but rejects `Tempo=100+20`, so the
/// right-hand side is a term rather than a full expression.
pub fn eval_term(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    parse_primary(cur, ctx)
}

fn parse_or(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let mut left = parse_and(cur, ctx)?;
    loop {
        cur.skip_spaces();
        if cur.peek() == Some('|') && cur.peek_at(1) == Some('|') {
            cur.advance();
            cur.advance();
            let right = parse_and(cur, ctx)?;
            left = Value::Int((left.truthy() || right.truthy()) as i64);
        } else {
            return Ok(left);
        }
    }
}

fn parse_and(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let mut left = parse_comparison(cur, ctx)?;
    loop {
        cur.skip_spaces();
        if cur.peek() == Some('&') && cur.peek_at(1) == Some('&') {
            cur.advance();
            cur.advance();
            let right = parse_comparison(cur, ctx)?;
            left = Value::Int((left.truthy() && right.truthy()) as i64);
        } else {
            return Ok(left);
        }
    }
}

fn parse_comparison(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    let left = parse_additive(cur, ctx)?;
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

    let right = parse_additive(cur, ctx)?;
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

fn parse_additive(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    let mut left = parse_multiplicative(cur, ctx)?;
    loop {
        cur.skip_spaces();
        let op = match cur.peek() {
            // `||` is the or-operator, not two additions.
            Some('+') => '+',
            Some('-') => '-',
            _ => return Ok(left),
        };
        cur.advance();
        let right = parse_multiplicative(cur, ctx)?;

        left =
            match (&left, op) {
                // `+` concatenates when either side is a string.
                (Value::Str(s), '+') => Value::Str(format!("{s}{}", right.as_str())),
                _ => {
                    if op == '+' {
                        if let Value::Str(s) = &right {
                            Value::Str(format!("{}{s}", left.as_str()))
                        } else {
                            let a = left.as_int(line)?;
                            let b = right.as_int(line)?;
                            Value::Int(a.checked_add(b).ok_or_else(|| {
                                MmlError::new(line, "整数の加算結果が範囲を超えました")
                            })?)
                        }
                    } else {
                        let a = left.as_int(line)?;
                        let b = right.as_int(line)?;
                        Value::Int(a.checked_sub(b).ok_or_else(|| {
                            MmlError::new(line, "整数の減算結果が範囲を超えました")
                        })?)
                    }
                }
            };
    }
}

fn parse_multiplicative(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    let mut left = parse_unary(cur, ctx)?;
    loop {
        cur.skip_spaces();
        let op = match cur.peek() {
            Some('*') => '*',
            Some('/') => '/',
            Some('%') => '%',
            _ => return Ok(left),
        };
        cur.advance();
        let right = parse_unary(cur, ctx)?;
        let (a, b) = (left.as_int(line)?, right.as_int(line)?);
        let value = match op {
            '*' => a
                .checked_mul(b)
                .ok_or_else(|| MmlError::new(line, "整数の乗算結果が範囲を超えました"))?,
            _ if b == 0 => return Err(MmlError::new(line, "0で割ることはできません")),
            '/' => a
                .checked_div(b)
                .ok_or_else(|| MmlError::new(line, "整数の除算結果が範囲を超えました"))?,
            _ => a
                .checked_rem(b)
                .ok_or_else(|| MmlError::new(line, "整数の剰余演算結果が範囲を超えました"))?,
        };
        left = Value::Int(value);
    }
}

fn parse_unary(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    cur.skip_spaces();
    match cur.peek() {
        Some('-') => {
            cur.advance();
            let value = parse_unary(cur, ctx)?;
            Ok(Value::Int(value.as_int(line)?.checked_neg().ok_or_else(
                || MmlError::new(line, "整数の符号反転結果が範囲を超えました"),
            )?))
        }
        Some('+') => {
            cur.advance();
            parse_unary(cur, ctx)
        }
        Some('!') if cur.peek_at(1) != Some('=') => {
            cur.advance();
            let value = parse_unary(cur, ctx)?;
            Ok(Value::Int(!value.truthy() as i64))
        }
        _ => parse_primary(cur, ctx),
    }
}

fn parse_primary(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    cur.skip_spaces();

    match cur.peek() {
        Some('(') => {
            cur.advance();
            let value = eval(cur, ctx)?;
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
        // `$10` is hexadecimal, as in `Int DeviceNumber = $10;`.
        Some('$') => {
            cur.advance();
            cur.read_hex()
                .map(Value::Int)
                .ok_or_else(|| MmlError::new(line, "$の後には16進数を指定してください"))
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
            cur.skip_spaces();

            // `name(index)` indexes an array; `name(args)` calls a function.
            if let Some(Value::Array(items)) = ctx.lookup(&name) {
                if cur.eat('(') {
                    let index = eval(cur, ctx)?.as_int(line)?;
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

            if ctx.has_function(&name) {
                let args = if cur.peek() == Some('(') {
                    cur.advance();
                    parse_call_args(cur, ctx)?
                } else {
                    Vec::new()
                };
                return ctx
                    .call(&name, args, line)?
                    .ok_or_else(|| MmlError::new(line, format!("関数\"{name}\"は値を返しません")));
            }

            ctx.lookup(&name)
                .ok_or_else(|| MmlError::new(line, format!("変数\"{name}\"は未定義です")))
        }
        _ => Err(MmlError::new(line, "式を読み取れません")),
    }
}

/// Parse `a, b, c)` — the opening parenthesis is already consumed.
fn parse_call_args(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Vec<Value>> {
    let mut args = Vec::new();
    cur.skip_spaces();
    if cur.eat(')') {
        return Ok(args);
    }
    loop {
        args.push(eval(cur, ctx)?);
        cur.skip_spaces();
        if cur.eat(',') {
            continue;
        }
        if !cur.eat(')') {
            return Err(MmlError::new(
                cur.line(),
                "関数呼び出しの括弧が閉じられていません",
            ));
        }
        return Ok(args);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Evaluate `src` against a plain variable map (no functions available).
    fn eval_str(src: &str, vars: &Variables) -> Result<Value> {
        let mut cur = Cursor::new(src);
        let mut vars = vars.clone();
        eval(&mut cur, &mut vars)
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
    fn integer_overflow_is_an_error_not_a_panic() {
        let vars = Variables::new();
        assert!(eval_str("9223372036854775807+1", &vars).is_err());
        assert!(eval_str("-9223372036854775807-2", &vars).is_err());
        assert!(eval_str("9223372036854775807*2", &vars).is_err());
        assert!(eval_str("(-9223372036854775807-1)/-1", &vars).is_err());
        assert!(eval_str("-(-9223372036854775807-1)", &vars).is_err());
    }

    #[test]
    fn undefined_variable_is_an_error() {
        assert!(eval_str("nope", &Variables::new()).is_err());
    }
}
