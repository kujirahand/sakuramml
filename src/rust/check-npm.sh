#!/bin/sh
# Build and validate the exact package contents intended for npm.
set -eu

cd "$(dirname "$0")"
./build-npm.sh
cd wasm
node test-npm-package.mjs
npm pack ./pkg --dry-run --json --ignore-scripts
