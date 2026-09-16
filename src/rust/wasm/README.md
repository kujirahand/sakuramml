# sakuramml-v2

SakuraMML compiles MML (Music Macro Language) text into Standard MIDI File
bytes in the browser. The compiler is written in Rust and distributed as a
WebAssembly ES module.

This package prioritizes compatibility with the original Pascal version of
SakuraMML. It is distributed separately from the existing `sakuramml` package.

## Install

```sh
npm install sakuramml-v2
```

## Usage

```js
import init, { compileMml } from "sakuramml-v2";

await init();

const result = compileMml("Tempo=120 o5 l4 cdefgab>c");
if (result.errors.length > 0) {
  console.error(result.errors);
}

// result.midi is a Uint8Array containing a Standard MIDI File.
const midiBlob = new Blob([result.midi], { type: "audio/midi" });
```

`compileMml` returns `midi`, `errors`, `warnings`, and `messages`. Recoverable
source errors are returned together with partial MIDI data. A fatal error that
prevents MIDI serialization is thrown.

Every standard `Include/*.h` macro file is embedded in the package, so
`Include(chord2.h)` works with no extra setup:

```js
import init, { compileMml } from "sakuramml-v2";

await init();
const result = compileMml("Include(chord2.h) ドレミ");
```

Definition files outside `Include/` can be registered before a compile:

```js
import init, { addInclude, compileMml } from "sakuramml-v2";

await init();
const bytes = new Uint8Array(await fetch("/my-defs.h").then((r) => r.arrayBuffer()));
addInclude("my-defs.h", bytes);
const result = compileMml("Include(my-defs.h) ドレミ");
```

The package targets browsers and browser-oriented bundlers. Input is accepted
as UTF-8 text; generated MIDI meta text is encoded as CP932 for compatibility
with Japanese MIDI software.

- [Project website](https://sakuramml.com/)
- [Source and issue tracker](https://github.com/kujirahand/sakuramml)
- [Language specification](https://github.com/kujirahand/sakuramml/tree/master/spec)
