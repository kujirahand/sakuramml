# SakuraMML

SakuraMML（テキスト音楽「サクラ」）は、MML（Music Macro Language）で書いたテキストを
Standard MIDI File（SMF）へ変換するコンパイラです。

このリポジトリでは、従来の Pascal 版を互換性の基準として保守しながら、Rust 版への移植を進めています。
Rust 版はブラウザ向け WebAssembly（WASM）を主対象とし、同じコンパイラコアをコマンドライン版でも利用します。

Windows 向けの配布版は [sakuramml.com](https://sakuramml.com/) からダウンロードできます。

## 現在の状況

- `src/rust/core/`: 入出力に依存しない現行の Rust コンパイラコア
- `src/rust/cli/`: Rust 製コマンドラインコンパイラ `csakura`
- `src/rust/wasm/`: ブラウザ向け WASM バインディングとデモ
- `src/pascal/`: 従来動作の基準となる Pascal/Delphi/FPC 版

Rust 版では、基本的な音符・トラック・MIDI 制御に加え、変数、式、制御構文、関数、マクロ、
ストトン表記、リズム、`Include`、`SysEx`、先行指定などを実装しています。
2026年9月9日時点では `sample/` の21曲中10曲をコンパイルできますが、Pascal 版との完全互換にはまだ達していません。

未実装機能と移植状況は [plan.md](plan.md) を参照してください。言語仕様と互換性については、
[詳細仕様](spec/README.md)、[互換性と実装状況](spec/10-compatibility.md)、
[コマンド索引](spec/11-command-index.md) にまとめています。

## 必要なツール

一括ビルドには次のツールが必要です。

- [just](https://github.com/casey/just)
- Rust / Cargo
- [wasm-pack](https://rustwasm.github.io/wasm-pack/)
- Free Pascal Compiler（FPC）

Rust CLI だけをビルドする場合、FPC と `wasm-pack` は不要です。

## ビルド

リポジトリのルートで `just` を実行します。

| コマンド | 内容 |
|---|---|
| `just build` | Pascal CLI、Rust ワークスペース、ブラウザ向け WASM をすべてビルド |
| `just build-rust` | Rust ワークスペースをビルド |
| `just build-cli` | Rust CLI のみをビルド |
| `just buld-wasm` | ブラウザ向け WASM パッケージをビルド |
| `just test-samples` | `sample/*.mml`を両実装で変換し、MIDIのバイト差異率を表示 |

生成物の主な出力先は次のとおりです。

- Pascal CLI: `src/pascal/csakura`
- Rust CLI: `src/rust/target/debug/csakura`
- WASM パッケージ: `src/rust/wasm/pkg/`

## Rust CLI の使い方

MMLファイルをMIDIファイルへ変換します。

```sh
just build-cli
src/rust/target/debug/csakura sample/scale.mml scale.mid
```

短いMMLをコマンドラインから直接コンパイルすることもできます。

```sh
src/rust/target/debug/csakura -e "Tempo=120 o5 l4 cdefgab>c" scale.mid
```

引数を省略した使い方は `--help` で確認できます。

```sh
src/rust/target/debug/csakura --help
```

## ブラウザ版を試す

WASMパッケージをビルドして、デモをHTTPサーバーで配信します。

```sh
just buld-wasm
cd src/rust/wasm
python3 -m http.server 8000
```

ブラウザで <http://localhost:8000/demo/> を開くと、MMLのコンパイルとMIDIファイルの
ダウンロードを試せます。

## MMLの例

```mml
Tempo=120
TimeSignature=4,4
TrackName={"SakuraMML sample"}

TR=1 CH=1 @1
o5 l4 q80 v100
cdef gab>c
```

## 文字コード

- Rust 版の入力は UTF-8 と CP932（Windows-31J）を自動判定します。
- Rust 内部では UTF-8 を使用します。
- MIDIのメタテキストは、従来版との互換性のため CP932 で出力します。
- CP932で表現できない文字は代替文字へ置き換え、警告を返します。
- Pascal 版のソースと従来資料には Shift_JIS/CP932 のファイルがあります。

## 開発とテスト

Rust の開発コマンドは `src/rust/` で実行します。

```sh
cd src/rust
cargo fmt --all -- --check
cargo test --workspace
cargo clippy --workspace --all-targets -- -D warnings
cargo build --target wasm32-unknown-unknown -p sakuramml-wasm
```

互換機能を追加するときは、Pascal 実装とコマンド資料を仕様の基準とし、生成されるMIDIバイト列を比較します。
詳しい開発方針は [AGENTS.md](AGENTS.md) を参照してください。

## ディレクトリ構成

```text
Include/      Includeで読み込むマクロ・定義ファイル
doc/          従来のコマンド資料とリファレンス
sample/       MMLサンプル
spec/         現行仕様、互換性表、コマンド索引
src/pascal/   Pascal版と旧README
src/rust/     Rust版のcore、CLI、WASM
tools/        開発支援ツール
```

旧バージョンのREADMEは
[src/pascal/README-v2.385.md](src/pascal/README-v2.385.md) に保存しています。
