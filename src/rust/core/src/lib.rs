//! SakuraMML compiler core: MML text in, Standard MIDI File bytes out.
//!
//! The core performs no I/O of any kind — no files, no stdout, no clock — so
//! the same code runs in a native CLI, under WASI, and in a browser via
//! wasm-bindgen. Callers supply the source text and decide what to do with the
//! bytes and diagnostics that come back.
//!
//! ```
//! use sakuramml_core::compile;
//!
//! let result = compile("cde").unwrap();
//! assert_eq!(&result.smf[..4], b"MThd");
//! ```

pub mod compiler;
pub mod encoding;
pub mod error;
pub mod lexer;
pub mod smf;

pub use encoding::SourceEncoding;
pub use error::{MmlError, Warning};

/// What a successful compile produced.
#[derive(Debug, Clone)]
pub struct CompileOutput {
    /// The Standard MIDI File.
    pub smf: Vec<u8>,
    /// Non-fatal diagnostics; the file is still valid.
    pub warnings: Vec<Warning>,
}

/// Compile MML source text into SMF bytes.
pub fn compile(src: &str) -> Result<CompileOutput, MmlError> {
    let (song, warnings) = compiler::Compiler::new().compile(src)?;
    Ok(CompileOutput {
        smf: song.to_bytes(),
        warnings,
    })
}

/// Compile MML source bytes, auto-detecting UTF-8 vs CP932 first.
///
/// Use this for file contents; use [`compile`] when you already have a string
/// (from JavaScript, say, where text is always UTF-8).
pub fn compile_bytes(bytes: &[u8]) -> Result<CompileOutput, MmlError> {
    let (text, _encoding) = encoding::decode_auto(bytes);
    compile(&text)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn compiles_a_scale() {
        let out = compile("cdefg").unwrap();
        assert_eq!(&out.smf[..4], b"MThd");
        assert!(out.warnings.is_empty());
    }

    #[test]
    fn reports_unknown_command_without_panicking() {
        let err = compile("NotACommand").unwrap_err();
        assert!(err.message.contains("未定義"));
    }

    #[test]
    fn compiles_cp932_source_bytes() {
        // TrackName={"テスト"} c   in CP932
        let mut bytes = b"TrackName={\"".to_vec();
        bytes.extend_from_slice(&[0x83, 0x65, 0x83, 0x58, 0x83, 0x67]);
        bytes.extend_from_slice(b"\"} c");
        let out = compile_bytes(&bytes).unwrap();
        // The CP932 bytes round-trip back out into the meta event.
        let needle = [0x83, 0x65, 0x83, 0x58, 0x83, 0x67];
        assert!(out.smf.windows(needle.len()).any(|w| w == needle));
    }
}
