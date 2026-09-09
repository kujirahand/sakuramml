# SakuraMML 詳細仕様書

このディレクトリは、SakuraMML の最終版仕様を、現在の Rust 実装からも参照できる形で再整理したものです。
旧版の `doc/` は Shift_JIS で書かれた利用者向けリファレンス、Pascal 実装は従来動作の基準、
`src/rust/` は UTF-8/WASM 対応を含む現行実装です。

## 仕様の読み方

本文では次の語を使います。

- **必須**: 適合実装が満たす動作です。
- **推奨**: 互換性のために従うべき動作です。
- **現行 Rust**: `src/rust/core/` で確認できる現在の実装です。
- **従来仕様**: `src/pascal/` と `doc/` に記録された最終 Pascal 版の動作です。

同じ項目で記述が食い違う場合、従来互換性の判断には Pascal 実装と生成された MIDI バイト列を優先します。
Rust 版の利用可否については [互換性と実装状況](10-compatibility.md) を優先します。

## 文書一覧

1. [言語の全体像](01-language.md) — 入力、前処理、字句、コメント、値、引数
2. [音符・休符・音長](02-notes.md) — 音高、音長、ゲート、ベロシティ、和音、連符
3. [トラック・チャンネル・時間](03-tracks-and-time.md) — タイムポインタ、拍子、同期
4. [音色と MIDI 制御](04-midi-control.md) — Program Change、CC、ベンド、SysEx、リセット
5. [メタイベントと文字コード](05-meta-and-encoding.md) — 曲名、歌詞、CP932 境界
6. [変数・式・制御構文](06-scripting.md) — 型、演算子、条件分岐、反復、関数
7. [マクロ・ストトン・Include](07-macros-and-includes.md) — 日本語表記、リズム、外部定義
8. [System 設定と安全制限](08-system-and-limits.md) — `System.*`、診断、WASM 向け上限
9. [Standard MIDI File 出力](09-smf.md) — MThd/MTrk、時刻、イベント順序
10. [互換性と実装状況](10-compatibility.md) — 従来仕様と現行 Rust の対応表
11. [コマンド索引](11-command-index.md) — 現行コマンドの書式と参照先

## 仕様の根拠

| 優先度 | 根拠 | 用途 |
|---:|---|---|
| 1 | `src/pascal/*.pas` と Pascal 版の MIDI 出力 | 従来動作の最終判断 |
| 2 | `doc/command/*.htm`、`doc/reference/*.htm` | コマンドの意図、名称、利用例 |
| 3 | `src/rust/core/tests/golden.rs` | MIDI バイト単位の移植確認 |
| 4 | `src/rust/core/tests/script.rs`、`limits.rs` | スクリプトと異常系の現行動作 |
| 5 | `src/rust/SPEC.md` | 旧 HTML から抽出した全コマンド一覧 |

`src/rust/SPEC.md` は網羅的な索引として残します。この `spec/` は、その表を置き換えるのではなく、
各機能の状態遷移、MIDI への変換、エラー条件まで説明する詳細版です。

## 最小例

```mml
Tempo=120
TimeSignature=4,4
TrackName={"SakuraMML sample"}

TR=1 CH=1 @1
o5 l4 q80 v100
cdef; gab>c
```

空白、改行、`;` は区切りとして使用できます。上の例は標準 MIDI ファイルを生成します。
