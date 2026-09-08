//! `#Include` resolution.
//!
//! The Pascal version looks include files up relative to the executable, which
//! is meaningless in a browser. Instead the caller supplies a resolver, so the
//! CLI can read the filesystem while a WASM build serves files bundled into
//! the binary or handed over from JavaScript.

use std::collections::HashMap;

/// Supplies the contents of `#Include`d files.
///
/// Bytes, not text: include files may be UTF-8 or CP932, and the compiler
/// auto-detects which after the resolver hands them over.
pub trait IncludeResolver {
    fn resolve(&self, name: &str) -> Option<Vec<u8>>;
}

/// Resolves nothing; `Include` reports the file as missing.
pub struct NoIncludes;

impl IncludeResolver for NoIncludes {
    fn resolve(&self, _name: &str) -> Option<Vec<u8>> {
        None
    }
}

/// An in-memory set of include files, keyed by file name.
///
/// This is how a WASM build ships the standard `Include/*.h` macros: embed
/// them at build time, with no filesystem and no network fetch at runtime.
#[derive(Debug, Default, Clone)]
pub struct MemoryIncludes {
    files: HashMap<String, Vec<u8>>,
}

impl MemoryIncludes {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn insert(&mut self, name: impl Into<String>, contents: impl Into<Vec<u8>>) {
        self.files.insert(name.into(), contents.into());
    }

    pub fn with(mut self, name: impl Into<String>, contents: impl Into<Vec<u8>>) -> Self {
        self.insert(name, contents);
        self
    }
}

impl IncludeResolver for MemoryIncludes {
    fn resolve(&self, name: &str) -> Option<Vec<u8>> {
        // Match on the bare file name too, so "Include/foo.h" finds "foo.h".
        self.files.get(name).cloned().or_else(|| {
            let base = name.rsplit(['/', '\\']).next()?;
            self.files.get(base).cloned()
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn memory_resolver_matches_bare_file_name() {
        let includes = MemoryIncludes::new().with("chord.h", b"Int x=1;".to_vec());
        assert!(includes.resolve("chord.h").is_some());
        assert!(includes.resolve("Include/chord.h").is_some());
        assert!(includes.resolve("nope.h").is_none());
    }
}
