#!/bin/sh
# Build the public npm package into wasm/pkg/ without publishing it.
set -eu

cd "$(dirname "$0")/wasm"
# Cargo does not always rebuild env!("CARGO_PKG_VERSION") after only a manifest
# version change. Remove this crate's generated release artifact so the JS
# manifest and the exported WASM version can never drift apart.
cargo clean -p sakuramml-wasm --release
wasm-pack build --target web --out-dir pkg --out-name sakuramml
node prepare-npm-package.mjs

echo
echo "Built npm package: wasm/pkg/"
echo "Run ./check-npm.sh before publishing."
