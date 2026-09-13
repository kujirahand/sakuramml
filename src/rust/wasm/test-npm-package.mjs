import assert from "node:assert/strict";
import { access, readFile } from "node:fs/promises";

const manifest = JSON.parse(
  await readFile(new URL("./pkg/package.json", import.meta.url), "utf8"),
);
assert.equal(manifest.name, "sakuramml-v2");
assert.equal(manifest.version, "0.1.0");
assert.equal(manifest.license, "MIT");
assert.deepEqual(manifest.files, [
  "sakuramml_bg.wasm",
  "sakuramml.js",
  "sakuramml.d.ts",
  "README.md",
  "LICENSE",
]);
await Promise.all(
  ["package.json", ...manifest.files].map((name) =>
    access(new URL(`./pkg/${name}`, import.meta.url)),
  ),
);

const wasm = await readFile(new URL("./pkg/sakuramml_bg.wasm", import.meta.url));
const { default: init, compileMml, version } = await import(
  "./pkg/sakuramml.js"
);
await init({ module_or_path: wasm });

const result = compileMml("Tempo=120 cde");
assert.deepEqual(Array.from(result.midi.slice(0, 4)), [0x4d, 0x54, 0x68, 0x64]);
assert.deepEqual(result.errors, []);
assert.equal(version(), manifest.version);
console.log(`npm smoke test passed: ${manifest.name}@${manifest.version}`);
