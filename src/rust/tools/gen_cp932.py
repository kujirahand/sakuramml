#!/usr/bin/env python3
"""Regenerate core/src/encoding/cp932_table.rs.

The compiler only ever converts CP932 (Windows-31J), so it carries its own
tables rather than depending on encoding_rs, which costs ~190 KB of WASM for
encodings this project never touches.

Run from src/rust:

    python3 tools/gen_cp932.py
"""

from pathlib import Path

OUTPUT = Path(__file__).resolve().parent.parent / "core/src/encoding/cp932_table.rs"

HEADER = """//! CP932 (Windows-31J) conversion tables.
//!
//! Generated from Python's `cp932` codec; see `tools/gen_cp932.py`. Carrying
//! these ~9,600 mappings ourselves costs about 45 KB, where pulling in
//! `encoding_rs` for the same job cost 190 KB of WASM — most of it tables for
//! encodings this compiler never touches.
"""


def double_byte_mappings():
    """Every two-byte CP932 sequence and the character it decodes to."""
    for lead in list(range(0x81, 0xA0)) + list(range(0xE0, 0xFD)):
        for trail in range(0x40, 0xFD):
            if trail == 0x7F:
                continue
            code = (lead << 8) | trail
            try:
                text = bytes([lead, trail]).decode("cp932")
            except UnicodeDecodeError:
                continue
            if len(text) != 1 or ord(text) > 0xFFFF:
                continue
            yield code, ord(text)


def main() -> None:
    pairs = sorted(double_byte_mappings())

    # Several CP932 codes map to the same character; encode via the lowest,
    # which is the one Windows itself produces.
    best: dict[int, int] = {}
    for code, uni in pairs:
        if uni not in best or code < best[uni]:
            best[uni] = code

    lines = [HEADER]
    lines.append("/// Double-byte CP932 code to Unicode, sorted by CP932 code.")
    lines.append("pub static CP932_TO_UNICODE: &[(u16, u16)] = &[")
    lines += [f"    (0x{code:04x}, 0x{uni:04x})," for code, uni in pairs]
    lines.append("];")
    lines.append("")
    lines.append("/// Unicode to double-byte CP932 code, sorted by Unicode scalar.")
    lines.append("pub static UNICODE_TO_CP932: &[(u16, u16)] = &[")
    lines += [f"    (0x{uni:04x}, 0x{code:04x})," for uni, code in sorted(best.items())]
    lines.append("];")

    OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"wrote {OUTPUT} ({len(pairs)} mappings)")


if __name__ == "__main__":
    main()
