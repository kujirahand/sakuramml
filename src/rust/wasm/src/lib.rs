//! Browser bindings: `compileMml(text)` returns the MIDI bytes and warnings.
//!
//! Nothing here can panic on bad input — a panic would poison the WASM
//! instance for the rest of the page — so compile errors come back as thrown
//! JS errors and everything else is returned as data.

use sakuramml_core::compile;
use wasm_bindgen::prelude::*;

/// Result of a successful compile, as seen from JavaScript.
#[wasm_bindgen]
pub struct CompileResult {
    midi: Vec<u8>,
    warnings: Vec<String>,
}

#[wasm_bindgen]
impl CompileResult {
    /// The Standard MIDI File bytes.
    #[wasm_bindgen(getter)]
    pub fn midi(&self) -> Vec<u8> {
        self.midi.clone()
    }

    /// Non-fatal diagnostics, one message per entry.
    #[wasm_bindgen(getter)]
    pub fn warnings(&self) -> Vec<JsValue> {
        self.warnings.iter().map(|w| JsValue::from_str(w)).collect()
    }
}

/// Compile MML text into a Standard MIDI File.
///
/// Throws a JS `Error` carrying the compiler message when the source does not
/// compile.
#[wasm_bindgen(js_name = compileMml)]
pub fn compile_mml(source: &str) -> Result<CompileResult, JsError> {
    match compile(source) {
        Ok(output) => Ok(CompileResult {
            midi: output.smf,
            warnings: output.warnings.iter().map(|w| w.to_string()).collect(),
        }),
        Err(error) => Err(JsError::new(&error.to_string())),
    }
}

/// The compiler version, for display in a UI.
#[wasm_bindgen(js_name = version)]
pub fn version() -> String {
    env!("CARGO_PKG_VERSION").to_string()
}
