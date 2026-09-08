//! Errors and warnings returned by the compiler.
//!
//! The core never prints anything: every diagnostic travels back to the caller
//! as a value, so the same code works in a CLI, in WASI and in the browser.

use std::fmt;

/// A fatal problem that stopped compilation.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MmlError {
    /// 1-based source line, or 0 when the error is not tied to a line.
    pub line: usize,
    pub message: String,
}

impl MmlError {
    pub fn new(line: usize, message: impl Into<String>) -> Self {
        Self {
            line,
            message: message.into(),
        }
    }
}

impl fmt::Display for MmlError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.line > 0 {
            write!(f, "[エラー] ({}): {}", self.line, self.message)
        } else {
            write!(f, "[エラー] {}", self.message)
        }
    }
}

impl std::error::Error for MmlError {}

/// A non-fatal problem. Compilation continues and still produces a file.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Warning {
    /// 1-based source line, or 0 when the warning is not tied to a line.
    pub line: usize,
    pub message: String,
}

impl Warning {
    pub fn new(line: usize, message: impl Into<String>) -> Self {
        Self {
            line,
            message: message.into(),
        }
    }
}

impl fmt::Display for Warning {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.line > 0 {
            write!(f, "[警告] ({}): {}", self.line, self.message)
        } else {
            write!(f, "[警告] {}", self.message)
        }
    }
}

pub type Result<T> = std::result::Result<T, MmlError>;
