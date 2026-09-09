# Build the Pascal CLI, Rust workspace, and browser WebAssembly package.
build: _build-pascal build-rust buld-wasm

# Build the Rust workspace.
build-rust:
    cd src/rust && cargo build --workspace

# Build only the Rust CLI.
build-cli:
    cd src/rust && cargo build -p sakuramml-cli

# Build the browser WebAssembly package.
buld-wasm:
    cd src/rust && ./build-wasm.sh

_build-pascal:
    cd src/pascal && fpc -Mdelphi -g -gv -vewh csakura.dpr

# Compare Pascal and Rust MIDI output for every top-level sample/*.mml file.
test-samples: _build-pascal build-cli
    ./tools/test-samples.sh
