//! Browser bindings: `compileMml(text)` returns MIDI bytes and diagnostics.
//!
//! Nothing here can panic on bad input — a panic would poison the WASM
//! instance for the rest of the page. Recoverable source errors are returned
//! with partial MIDI data; only failures that prevent serialisation are thrown.

use sakuramml_core::{compile_with_recovery, MemoryIncludes};
use wasm_bindgen::prelude::*;

include!(concat!(env!("OUT_DIR"), "/embedded_includes.rs"));

use std::cell::RefCell;

thread_local! {
    /// Include files added from JavaScript, on top of the embedded ones.
    static EXTRA_INCLUDES: RefCell<Vec<(String, Vec<u8>)>> = const { RefCell::new(Vec::new()) };
}

/// Every standard `Include/*.h` macro file is embedded at build time so a
/// page is self-contained; anything else the song asks for comes from
/// [`add_include`].
fn includes() -> MemoryIncludes {
    let mut includes = MemoryIncludes::new();
    for (name, contents) in EMBEDDED_INCLUDES {
        includes.insert(*name, contents.to_vec());
    }
    EXTRA_INCLUDES.with(|extra| {
        for (name, contents) in extra.borrow().iter() {
            includes.insert(name.clone(), contents.clone());
        }
    });
    includes
}

/// Make an `Include`-able file available to later compiles.
///
/// Use it for the definition files under `Include/` that are not embedded —
/// fetch one in JavaScript, hand it over here, then `Include(chord2.h)` works.
#[wasm_bindgen(js_name = addInclude)]
pub fn add_include(name: &str, contents: &[u8]) {
    EXTRA_INCLUDES.with(|extra| {
        let mut extra = extra.borrow_mut();
        extra.retain(|(existing, _)| existing != name);
        extra.push((name.to_string(), contents.to_vec()));
    });
}

/// Forget every file added with [`add_include`].
#[wasm_bindgen(js_name = clearIncludes)]
pub fn clear_includes() {
    EXTRA_INCLUDES.with(|extra| extra.borrow_mut().clear());
}

/// Result of a compile attempt, including partial MIDI when errors were recovered.
#[wasm_bindgen]
pub struct CompileResult {
    midi: Vec<u8>,
    errors: Vec<String>,
    warnings: Vec<String>,
    messages: Vec<String>,
}

#[wasm_bindgen]
impl CompileResult {
    /// The Standard MIDI File bytes.
    #[wasm_bindgen(getter)]
    pub fn midi(&self) -> Vec<u8> {
        self.midi.clone()
    }

    /// Recoverable source errors. MIDI still contains every event that could
    /// be compiled safely.
    #[wasm_bindgen(getter)]
    pub fn errors(&self) -> Vec<JsValue> {
        self.errors.iter().map(|e| JsValue::from_str(e)).collect()
    }

    /// Non-fatal diagnostics, one message per entry.
    #[wasm_bindgen(getter)]
    pub fn warnings(&self) -> Vec<JsValue> {
        self.warnings.iter().map(|w| JsValue::from_str(w)).collect()
    }

    /// Output of `Print(...)` statements in the MML.
    #[wasm_bindgen(getter)]
    pub fn messages(&self) -> Vec<JsValue> {
        self.messages.iter().map(|m| JsValue::from_str(m)).collect()
    }
}

/// Compile MML text into a Standard MIDI File.
///
/// Recoverable source errors are available through [`CompileResult::errors`].
/// Throws only when even a partial Standard MIDI File cannot be serialised.
#[wasm_bindgen(js_name = compileMml)]
pub fn compile_mml(source: &str) -> Result<CompileResult, JsError> {
    match compile_with_recovery(source, &includes()) {
        Ok(output) => Ok(CompileResult {
            midi: output.smf,
            errors: output.errors.iter().map(|e| e.to_string()).collect(),
            warnings: output.warnings.iter().map(|w| w.to_string()).collect(),
            messages: output.messages,
        }),
        Err(error) => Err(JsError::new(&error.to_string())),
    }
}

/// The compiler version, for display in a UI.
#[wasm_bindgen(js_name = version)]
pub fn version() -> String {
    env!("CARGO_PKG_VERSION").to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn wrapper_compiles_mml_on_the_host() {
        let result = match compile_mml("Print(1) c") {
            Ok(result) => result,
            Err(_) => panic!("WASM wrapper should return a successful result"),
        };
        assert_eq!(&result.midi[..4], b"MThd");
        assert_eq!(result.messages, vec!["1"]);
    }

    #[test]
    fn wrapper_returns_partial_midi_and_errors() {
        let result = match compile_mml("c NotACommand d") {
            Ok(result) => result,
            Err(_) => panic!("recoverable source errors must not be thrown"),
        };
        assert_eq!(&result.midi[..4], b"MThd");
        assert_eq!(result.errors.len(), 1);
        assert!(result.errors[0].contains("NotACommand"));
    }

    #[test]
    fn standard_includes_are_embedded_and_need_no_add_include() {
        let result = compile_mml("Include(chord2.h) c").expect("should compile");
        assert!(result.errors.is_empty(), "errors: {:?}", result.errors);
    }
}
