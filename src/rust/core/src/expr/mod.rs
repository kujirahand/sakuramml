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
    Array(Vec<Value>),
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
                .map(Value::as_str)
                .collect::<Vec<_>>()
                .join(", "),
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

    /// Convert an `!n` script literal to ticks. Plain expression contexts do
    /// not know the song timebase and retain `!` as logical negation.
    fn length_literal(&self, _denominator: i64) -> Option<i64> {
        None
    }
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
    // A leading sign belongs to the term: `System.Keyshift=-2` is accepted by
    // the Pascal build.
    parse_unary(cur, ctx)
}

/// Apply one binary operator to two evaluated operands. Every reader below
/// (the precedence-climbing `eval` and the Pascal-shaped `eval_calc`) goes
/// through this, so a value means the same thing whichever one produced it.
fn apply_binary(op: &str, left: Value, right: Value, line: usize) -> Result<Value> {
    match op {
        "||" => Ok(Value::Int((left.truthy() || right.truthy()) as i64)),
        "&&" => Ok(Value::Int((left.truthy() && right.truthy()) as i64)),
        "==" | "!=" | "<" | ">" | "<=" | ">=" => {
            // Strings compare as strings; anything else compares numerically.
            let result = match (&left, &right) {
                (Value::Str(a), Value::Str(b)) => compare(op, a, b),
                _ => compare(op, &left.as_int(line)?, &right.as_int(line)?),
            };
            Ok(Value::Int(result as i64))
        }
        "+" => match (&left, &right) {
            // `+` concatenates when either side is a string.
            (Value::Str(s), _) => Ok(Value::Str(format!("{s}{}", right.as_str()))),
            (_, Value::Str(s)) => Ok(Value::Str(format!("{}{s}", left.as_str()))),
            _ => left
                .as_int(line)?
                .checked_add(right.as_int(line)?)
                .map(Value::Int)
                .ok_or_else(|| MmlError::new(line, "整数の加算結果が範囲を超えました")),
        },
        "-" => left
            .as_int(line)?
            .checked_sub(right.as_int(line)?)
            .map(Value::Int)
            .ok_or_else(|| MmlError::new(line, "整数の減算結果が範囲を超えました")),
        _ => {
            let (a, b) = (left.as_int(line)?, right.as_int(line)?);
            let value = match op {
                "*" => a
                    .checked_mul(b)
                    .ok_or_else(|| MmlError::new(line, "整数の乗算結果が範囲を超えました"))?,
                _ if b == 0 => return Err(MmlError::new(line, "0で割ることはできません")),
                "/" => a
                    .checked_div(b)
                    .ok_or_else(|| MmlError::new(line, "整数の除算結果が範囲を超えました"))?,
                _ => a
                    .checked_rem(b)
                    .ok_or_else(|| MmlError::new(line, "整数の剰余演算結果が範囲を超えました"))?,
            };
            Ok(Value::Int(value))
        }
    }
}

fn compare<T: PartialOrd>(op: &str, a: &T, b: &T) -> bool {
    match op {
        "==" => a == b,
        "!=" => a != b,
        "<" => a < b,
        ">" => a > b,
        "<=" => a <= b,
        _ => a >= b,
    }
}

/// Evaluate a value the way Pascal's `GetArgCalc` reads one: a first term,
/// then operator-and-term pairs for as long as they parse, folded by
/// `CalcTMStack`'s pass order (`* / %`, then `+ -`, then comparisons, then
/// and/or).
///
/// An operator with no term after it is not part of the value: the cursor
/// rewinds to before the operator, so `CHO=5 >c` leaves `>c` (an octave
/// shift) for the caller. Each term is evaluated once, on a probe cursor that
/// is adopted when the term parses, so terms with side effects (`Random`,
/// user functions) never run twice. Errors from the calculation itself, such
/// as division by zero, are returned.
///
/// `^` is not an operator here even though Pascal lists it: in MML it is the
/// tie mark, as in `CHO=5 ^c`.
pub fn eval_calc(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    let mut terms = vec![parse_unary(cur, ctx)?];
    let mut ops: Vec<&'static str> = Vec::new();
    loop {
        let mut probe = cur.clone();
        probe.skip_spaces();
        let Some((op, len)) = peek_calc_operator(&probe) else {
            break;
        };
        for _ in 0..len {
            probe.advance();
        }
        match parse_unary(&mut probe, ctx) {
            Ok(term) => {
                *cur = probe;
                ops.push(op);
                terms.push(term);
            }
            // No term after the operator: it belongs to the next command.
            Err(_) => break,
        }
    }

    for level in 0..=3 {
        let mut terms_in = terms.into_iter();
        let mut folded = vec![terms_in.next().expect("a first term was read")];
        let mut rest_ops = Vec::new();
        for (op, term) in ops.into_iter().zip(terms_in) {
            if op_level(op) == level {
                let left = folded.pop().expect("folded is never empty");
                folded.push(apply_binary(op, left, term, line)?);
            } else {
                rest_ops.push(op);
                folded.push(term);
            }
        }
        terms = folded;
        ops = rest_ops;
    }
    Ok(terms.remove(0))
}

/// Pass number of an operator in `CalcTMStack`.
fn op_level(op: &str) -> u8 {
    match op {
        "*" | "/" | "%" => 0,
        "+" | "-" => 1,
        "==" | "!=" | "<" | ">" | "<=" | ">=" => 2,
        _ => 3,
    }
}

/// The binary operator at the cursor and its length in characters, limited to
/// those `apply_binary` implements. A lone `=` is equality, as in Pascal; a
/// lone `&` or `|` is the logical operator; a lone `!` is not an operator.
fn peek_calc_operator(cur: &Cursor) -> Option<(&'static str, usize)> {
    Some(match (cur.peek()?, cur.peek_at(1)) {
        ('*', _) => ("*", 1),
        // `//` and `/*` start comments.
        ('/', Some('/') | Some('*')) => return None,
        ('/', _) => ("/", 1),
        ('%', _) => ("%", 1),
        ('+', _) => ("+", 1),
        ('-', _) => ("-", 1),
        ('=', Some('=')) => ("==", 2),
        ('=', _) => ("==", 1),
        ('!', Some('=')) => ("!=", 2),
        ('<', Some('=')) => ("<=", 2),
        ('<', _) => ("<", 1),
        ('>', Some('=')) => (">=", 2),
        ('>', _) => (">", 1),
        ('&', Some('&')) => ("&&", 2),
        ('&', _) => ("&&", 1),
        ('|', Some('|')) => ("||", 2),
        ('|', _) => ("||", 1),
        _ => return None,
    })
}

fn parse_or(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    let mut left = parse_and(cur, ctx)?;
    loop {
        cur.skip_spaces();
        if cur.peek() == Some('|') && cur.peek_at(1) == Some('|') {
            cur.advance();
            cur.advance();
            let right = parse_and(cur, ctx)?;
            left = apply_binary("||", left, right, line)?;
        } else {
            return Ok(left);
        }
    }
}

fn parse_and(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    let mut left = parse_comparison(cur, ctx)?;
    loop {
        cur.skip_spaces();
        if cur.peek() == Some('&') && cur.peek_at(1) == Some('&') {
            cur.advance();
            cur.advance();
            let right = parse_comparison(cur, ctx)?;
            left = apply_binary("&&", left, right, line)?;
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
    apply_binary(op, left, right, line)
}

fn parse_additive(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    let mut left = parse_multiplicative(cur, ctx)?;
    loop {
        cur.skip_spaces();
        let op = match cur.peek() {
            Some('+') => "+",
            Some('-') => "-",
            _ => return Ok(left),
        };
        cur.advance();
        let right = parse_multiplicative(cur, ctx)?;
        left = apply_binary(op, left, right, line)?;
    }
}

fn parse_multiplicative(cur: &mut Cursor, ctx: &mut dyn EvalContext) -> Result<Value> {
    let line = cur.line();
    let mut left = parse_unary(cur, ctx)?;
    loop {
        cur.skip_spaces();
        let op = match cur.peek() {
            Some('*') => "*",
            Some('/') if !matches!(cur.peek_at(1), Some('/') | Some('*')) => "/",
            Some('%') => "%",
            _ => return Ok(left),
        };
        cur.advance();
        let right = parse_unary(cur, ctx)?;
        left = apply_binary(op, left, right, line)?;
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
        Some('!') if cur.peek_at(1).is_some_and(|ch| ch.is_ascii_digit()) => {
            let mut probe = cur.clone();
            probe.advance();
            let denominator = probe
                .read_int()
                .ok_or_else(|| MmlError::new(line, "!の後には音長を指定してください"))?;
            if let Some(mut value) = ctx.length_literal(denominator) {
                let mut half = value;
                while probe.eat('.') {
                    half /= 2;
                    value = value
                        .checked_add(half)
                        .ok_or_else(|| MmlError::new(line, "音長リテラルの値が範囲を超えました"))?;
                }
                while probe.eat('^') {
                    let nested_literal = probe.eat('!');
                    let joined_denominator = probe
                        .read_int()
                        .ok_or_else(|| MmlError::new(line, "^の後には音長を指定してください"))?;
                    // Pascal recursively parses a second `!` as the
                    // denominator: `!1^!1` is 384 + NtoStep(384) = 385.
                    let joined_denominator = if nested_literal {
                        ctx.length_literal(joined_denominator).ok_or_else(|| {
                            MmlError::new(line, "入れ子の音長リテラルをtick値へ変換できません")
                        })?
                    } else {
                        joined_denominator
                    };
                    let mut joined = ctx
                        .length_literal(joined_denominator)
                        .ok_or_else(|| MmlError::new(line, "結合音長をtick値へ変換できません"))?;
                    let mut joined_half = joined;
                    while probe.eat('.') {
                        joined_half /= 2;
                        joined = joined.checked_add(joined_half).ok_or_else(|| {
                            MmlError::new(line, "音長リテラルの値が範囲を超えました")
                        })?;
                    }
                    value = value
                        .checked_add(joined)
                        .ok_or_else(|| MmlError::new(line, "結合音長の値が範囲を超えました"))?;
                }
                *cur = probe;
                Ok(Value::Int(value))
            } else {
                cur.advance();
                let value = parse_unary(cur, ctx)?;
                Ok(Value::Int(!value.truthy() as i64))
            }
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
        // `#` leads a string macro's name, as in `#STR(n)` or `#Melody`.
        Some(c) if c.is_ascii_alphabetic() || c == '_' || c == '#' => {
            let mut name = cur
                .read_word()
                .ok_or_else(|| MmlError::new(line, "変数名を読み取れません"))?;
            // The legacy API exposes one value-returning System member:
            // `Array a=System.GetKeyFlag`. Keep the dotted name intact so the
            // compiler can implement it like the other built-in functions.
            if name == "System" && cur.eat('.') {
                let member = cur
                    .read_word()
                    .ok_or_else(|| MmlError::new(line, "System.の後に名前が必要です"))?;
                name.push('.');
                name.push_str(&member);
            }
            match name.as_str() {
                "on" | "ON" => return Ok(Value::Int(1)),
                "off" | "OFF" => return Ok(Value::Int(0)),
                _ => {}
            }
            cur.skip_spaces();

            // `Time(measure:beat:step)` uses colons rather than ordinary
            // comma-separated function arguments. Preserve its body as text
            // so the compiler can evaluate it using the same rules as the
            // Time command.
            if name == "Time" && ctx.has_function(&name) && cur.eat('(') {
                let body = cur
                    .read_balanced('(', ')')
                    .ok_or_else(|| MmlError::new(line, "Timeの括弧が閉じられていません"))?;
                return ctx
                    .call(&name, vec![Value::Str(body)], line)?
                    .ok_or_else(|| MmlError::new(line, "Timeは値を返しません"));
            }

            // `name(index)` indexes an array; `name(args)` calls a function.
            if let Some(Value::Array(items)) = ctx.lookup(&name) {
                if cur.eat('(') {
                    let index = eval(cur, ctx)?.as_int(line)?;
                    cur.skip_spaces();
                    cur.eat(')');
                    return items.get(index as usize).cloned().ok_or_else(|| {
                        MmlError::new(line, format!("配列\"{name}\"の範囲外です: {index}"))
                    });
                }
            }

            if ctx.has_function(&name) {
                // A few built-ins take MML text rather than a value:
                // `NoteNo(o4c)` and `MML(v)` are read, not evaluated.
                if takes_raw_text(&name) && cur.peek() == Some('(') {
                    cur.advance();
                    let text = cur
                        .read_balanced('(', ')')
                        .ok_or_else(|| MmlError::new(line, "括弧が閉じられていません"))?;
                    return ctx
                        .call(&name, vec![Value::Str(text)], line)?
                        .ok_or_else(|| {
                            MmlError::new(line, format!("関数\"{name}\"は値を返しません"))
                        });
                }
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

/// Built-ins whose argument is MML text to be read, not an expression.
fn takes_raw_text(name: &str) -> bool {
    matches!(name, "NoteNo" | "MML")
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
        vars.insert(
            "a".into(),
            Value::Array(vec![Value::Int(10), Value::Int(20), Value::Int(30)]),
        );
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
