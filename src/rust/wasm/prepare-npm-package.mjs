import { copyFile, readFile, writeFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import path from "node:path";

const wasmDir = path.dirname(fileURLToPath(import.meta.url));
const packageDir = path.join(wasmDir, "pkg");
const manifestPath = path.join(packageDir, "package.json");
const manifest = JSON.parse(await readFile(manifestPath, "utf8"));

Object.assign(manifest, {
  name: "sakuramml-v2",
  description:
    "Pascal-compatible SakuraMML compiler for browsers: convert MML text to MIDI with WebAssembly",
  license: "MIT",
  repository: {
    type: "git",
    url: "https://github.com/kujirahand/sakuramml.git",
    directory: "src/rust/wasm",
  },
  homepage: "https://sakuramml.com/",
  bugs: "https://github.com/kujirahand/sakuramml/issues",
  keywords: ["MML", "MIDI", "compiler", "music", "WebAssembly"],
  main: "./sakuramml.js",
  module: "./sakuramml.js",
  types: "./sakuramml.d.ts",
  exports: {
    ".": {
      types: "./sakuramml.d.ts",
      import: "./sakuramml.js",
      default: "./sakuramml.js",
    },
  },
  files: [
    "sakuramml_bg.wasm",
    "sakuramml.js",
    "sakuramml.d.ts",
    "README.md",
    "LICENSE",
  ],
  publishConfig: { access: "public" },
});

await writeFile(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`);
await copyFile(path.join(wasmDir, "README.md"), path.join(packageDir, "README.md"));
await copyFile(path.join(wasmDir, "LICENSE"), path.join(packageDir, "LICENSE"));
