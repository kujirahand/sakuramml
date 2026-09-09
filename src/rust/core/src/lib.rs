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
pub mod expr;
pub mod include;
pub mod lexer;
pub mod rng;
pub mod smf;

pub use encoding::SourceEncoding;
pub use error::{MmlError, Warning};
pub use include::{IncludeResolver, MemoryIncludes, NoIncludes};

/// What a successful compile produced.
#[derive(Debug, Clone)]
pub struct CompileOutput {
    /// The Standard MIDI File.
    pub smf: Vec<u8>,
    /// Source errors recovered from while producing a partial MIDI file.
    /// This is empty for the strict [`compile`] family.
    pub errors: Vec<MmlError>,
    /// Non-fatal diagnostics; the file is still valid.
    pub warnings: Vec<Warning>,
    /// Output of `Print(...)` statements, for the caller to display.
    pub messages: Vec<String>,
}

/// Compile MML source text into SMF bytes.
///
/// `#Include` is unavailable here; use [`compile_with`] to supply a resolver.
pub fn compile(src: &str) -> Result<CompileOutput, MmlError> {
    compile_with(src, &include::NoIncludes)
}

/// Compile MML source text, resolving `#Include` through `resolver`.
pub fn compile_with(src: &str, resolver: &dyn IncludeResolver) -> Result<CompileOutput, MmlError> {
    let result = compiler::Compiler::new()
        .with_includes(resolver)
        .compile(src)?;
    finish_compile(result)
}

/// Compile as much valid source as possible, returning source errors together
/// with the partial MIDI data instead of stopping at the first one.
pub fn compile_recovering(src: &str) -> Result<CompileOutput, MmlError> {
    compile_with_recovery(src, &include::NoIncludes)
}

/// As [`compile_recovering`], resolving `#Include` through `resolver`.
pub fn compile_with_recovery(
    src: &str,
    resolver: &dyn IncludeResolver,
) -> Result<CompileOutput, MmlError> {
    let result = compiler::Compiler::new()
        .with_includes(resolver)
        .with_error_recovery()
        .compile(src)?;
    finish_compile(result)
}

fn finish_compile(result: compiler::CompileResult) -> Result<CompileOutput, MmlError> {
    Ok(CompileOutput {
        smf: result.song.to_bytes()?,
        errors: result.errors,
        warnings: result.warnings,
        messages: result.messages,
    })
}

/// Compile MML source bytes, auto-detecting UTF-8 vs CP932 first.
///
/// Use this for file contents; use [`compile`] when you already have a string
/// (from JavaScript, say, where text is always UTF-8).
pub fn compile_bytes(bytes: &[u8]) -> Result<CompileOutput, MmlError> {
    compile_bytes_with(bytes, &include::NoIncludes)
}

/// As [`compile_bytes`], resolving `#Include` through `resolver`.
pub fn compile_bytes_with(
    bytes: &[u8],
    resolver: &dyn IncludeResolver,
) -> Result<CompileOutput, MmlError> {
    let (text, _encoding) = encoding::decode_auto(bytes);
    compile_with(&text, resolver)
}

/// Decode source bytes and compile as much valid input as possible.
pub fn compile_bytes_recovering(bytes: &[u8]) -> Result<CompileOutput, MmlError> {
    compile_bytes_with_recovery(bytes, &include::NoIncludes)
}

/// As [`compile_bytes_recovering`], resolving includes through `resolver`.
pub fn compile_bytes_with_recovery(
    bytes: &[u8],
    resolver: &dyn IncludeResolver,
) -> Result<CompileOutput, MmlError> {
    let (text, _encoding) = encoding::decode_auto(bytes);
    compile_with_recovery(&text, resolver)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn compiles_a_scale() {
        let out = compile("cdefg").unwrap();
        assert_eq!(&out.smf[..4], b"MThd");
        // Without a resolver the standard include is missing, which is a
        // hint rather than an error — the same as the Pascal build.
        assert!(out
            .warnings
            .iter()
            .all(|w| w.message.contains(compiler::STANDARD_INCLUDE)));
    }

    #[test]
    fn reports_unknown_command_without_panicking() {
        let err = compile("NotACommand").unwrap_err();
        assert!(err.message.contains("未定義"));
    }

    #[test]
    fn recovering_compile_reports_errors_and_keeps_later_notes() {
        let out = compile_recovering("c NotACommand d @ e").unwrap();
        assert_eq!(out.errors.len(), 2);
        assert!(out.errors[0].message.contains("NotACommand"));
        assert!(out.errors[1].message.contains("@"));
        for note in [60, 62, 64] {
            assert!(out.smf.windows(3).any(|event| event == [0x90, note, 100]));
        }
    }

    #[test]
    fn recovering_compile_skips_an_unknown_braced_group() {
        let out = compile_recovering("c {not mml} d").unwrap();
        assert_eq!(out.errors.len(), 1);
        assert!(out.smf.windows(3).any(|event| event == [0x90, 60, 100]));
        assert!(out.smf.windows(3).any(|event| event == [0x90, 62, 100]));
    }

    #[test]
    fn recovering_compile_deduplicates_loop_diagnostics() {
        let out = compile_recovering("[3 NotACommand] c").unwrap();
        assert_eq!(out.errors.len(), 1);
        assert!(out.errors[0].message.contains("NotACommand"));
        assert!(out.smf.windows(3).any(|event| event == [0x90, 60, 100]));
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
