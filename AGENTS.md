# Repository Guidelines

## Project structure

- `src/pascal/`: reference implementation written in Pascal/Delphi/FPC.
- `src/rust/`: Rust rewrite and Cargo workspace (`core`, `cli`, and `wasm`).
- `Include/`: macro and definition files loaded by `Include`.
- `doc/`: shared command documentation and reference material.
- `sample/`: shared sample MML files.
- `spec/`: the SakuraMML specification (see below).
- `plan.md`: Rust migration status and remaining work.

## Specification

`spec/` describes the language in detail, including what the Rust build
currently accepts:

- [`spec/README.md`](spec/README.md): how to read the spec, and which source
  wins when two disagree.
- [`01-language.md`](spec/01-language.md): lexical structure, comments, strings.
- [`02-notes.md`](spec/02-notes.md): notes, lengths, octaves, chords, key.
- [`03-tracks-and-time.md`](spec/03-tracks-and-time.md): tracks, channels,
  the time pointer, `Play`, `Sub`.
- [`04-midi-control.md`](spec/04-midi-control.md): voices, control changes,
  pitch bend, RPN/NRPN, SysEx.
- [`05-meta-and-encoding.md`](spec/05-meta-and-encoding.md): meta events and
  the UTF-8/CP932 rules.
- [`06-scripting.md`](spec/06-scripting.md): variables, expressions, control
  flow, functions.
- [`07-macros-and-includes.md`](spec/07-macros-and-includes.md): sutoton,
  rhythm mode, string macros, `Include`.
- [`08-system-and-limits.md`](spec/08-system-and-limits.md): `System.*` options
  and the compiler's resource limits.
- [`09-smf.md`](spec/09-smf.md): how events become Standard MIDI File bytes.
- [`10-compatibility.md`](spec/10-compatibility.md): where the Rust build
  differs from the Pascal one, and how to close a gap.
- [`11-command-index.md`](spec/11-command-index.md): implemented commands and
  their status.
- [`12-legacy-command-table.md`](spec/12-legacy-command-table.md): every
  command name in the original, extracted from `doc/`.

When implementing Rust compatibility, treat the Pascal implementation and the
command documentation as the source of truth. Check the command index and the
legacy command table for the syntax, then compare the relevant Pascal code and
generated MIDI bytes before changing behavior.

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
