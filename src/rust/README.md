# sakuramml (Rust)

Rust rewrite of the SakuraMML compiler — MML text in, Standard MIDI File out.
WebAssembly is the primary target; the CLI exists for development and testing.

See [../../plan.md](../../plan.md) for the migration plan and
[SPEC.md](SPEC.md) for the command reference extracted from `doc/`.

## Layout

| crate | what it is |
|---|---|
| `core/` | `sakuramml-core` — the compiler. Does no I/O at all: text in, bytes and diagnostics out, so it runs unchanged in a CLI, under WASI and in a browser. |
| `cli/` | `csakura` — command line front end, the counterpart of `src/pascal/csakura.dpr`. All file handling lives here. |
| `wasm/` | `wasm-bindgen` bindings for the browser. |

## Build and test

```sh
cargo test --workspace     # unit tests + golden tests against the Pascal output
cargo run -p sakuramml-cli -- -e "cde" out.mid
./build-wasm.sh            # browser package into wasm/pkg/
./build-wasm.sh nodejs     # Node package (for the smoke test below)
```

From JavaScript:

```js
const { compileMml } = require('./wasm/pkg/sakuramml_wasm.js');
const { midi, warnings } = compileMml('cde');   // midi: Uint8Array
```

## Character encoding

* **Input** — `.mml` sources are auto-detected as UTF-8 or CP932 (Windows-31J),
  so both new UTF-8 files and the existing Shift_JIS ones work unchanged.
* **Internally** — always UTF-8. Unlike the Pascal version, no code anywhere
  needs to know about multi-byte lead bytes.
* **Output** — SMF meta text (track name, lyrics, copyright) is always written
  as CP932, matching what Japanese MIDI players expect. Characters CP932 cannot
  represent are replaced with `?` and reported as a warning; the compile still
  succeeds.

## Status

Phase 1 (vertical slice) is done: notes, rests, ties, octave/length/velocity/
gate attributes, tracks and channels, tempo, timebase, and the text meta
events. Output is byte-identical to the Pascal build for everything covered by
`core/tests/golden.rs`.

Still to port, in roughly this order: loops `[ ]`, variables and expressions,
`If`/`For`/`While`/`Function`, CC/SysEx/RPN, the sutoton (Japanese) notation
layer, and `#Include`.

## Regenerating golden test data

Expected bytes in `core/tests/golden.rs` come from the Pascal build:

```sh
cd ../pascal && ./csakura -e "cde" && xxd -p a.mid | tr -d '\n'
```
