# Repository Guidelines

## Project structure

- `src/pascal/`: reference implementation written in Pascal/Delphi/FPC.
- `src/rust/`: Rust rewrite and Cargo workspace (`core`, `cli`, and `wasm`).
- `Include/`: macro and definition files loaded by `Include`.
- `doc/`: shared command documentation and reference material.
- `sample/`: shared sample MML files.
- `plan.md`: Rust migration status and remaining work.

When implementing Rust compatibility, treat the Pascal implementation and the
command documentation as the source of truth. Check `src/rust/SPEC.md` for the
extracted command syntax, then compare the relevant Pascal code and generated
MIDI bytes before changing behavior.

## Rust development

Run Rust commands from `src/rust/`:

```sh
cargo fmt --all -- --check
cargo test --workspace
cargo clippy --workspace --all-targets -- -D warnings
cargo build --target wasm32-unknown-unknown -p sakuramml-wasm
```

Add focused regression tests for every behavior change. Use
`core/tests/golden.rs` for byte-for-byte MIDI compatibility and
`core/tests/script.rs` for scripting behavior and invalid-input handling.
Invalid MML must return an error rather than panic, especially because WASM is
the primary target.

Do not edit generated files under `src/rust/target/` or `src/rust/wasm/pkg/`.
Build the WASM package with `src/rust/build-wasm.sh` when generated browser
artifacts are explicitly required.

## Character encoding

Rust code and internal strings use UTF-8. Source and include files may be UTF-8
or CP932, while SMF meta text is emitted as CP932 for compatibility. Preserve
this boundary when changing file loading, preprocessing, or MIDI serialization.

## Working tree hygiene

Preserve unrelated staged, modified, untracked, and generated files. Stage only
the paths changed for the current task. Do not commit build products, generated
MIDI files, or sample outputs unless the task explicitly requires them.
