#!/bin/sh
# Build the WebAssembly package.
#
#   ./build-wasm.sh          # browser (ES modules), the main target
#   ./build-wasm.sh nodejs   # Node.js, used by the smoke test below
#
# Output lands in wasm/pkg/.
set -e

TARGET="${1:-web}"
cd "$(dirname "$0")/wasm"
wasm-pack build --target "$TARGET" --out-dir pkg

echo
echo "Built wasm/pkg for target '$TARGET':"
ls -la pkg/*.wasm
