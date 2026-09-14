# Rust版・未実装コマンド TODO

2026-09-14に `origin/master`（`4740b98`）へ同期後、
`spec/12-legacy-command-table.md`、Pascal版の `src/pascal/mml_base.pas`、
Rust版の `src/rust/core/src/compiler/mod.rs` を照合した一覧です。GM音色名・ドラム名などの
定数表は対象外です。

## 受理するが未実装・一部実装

| コマンド・機能 | 現状 | TODO |
|---|---|---|
| `System.LoadSMF(file)` | 警告して無視する。Pascal版にも処理本体はない | ファイルI/Oを含む仕様を決め、実装するか未対応仕様として維持するか決める |

## 同期で実装済みになった項目

前回の調査後に取り込んだリモート更新により、次はTODOから除外しました。

- `NoteOn` / `NoteOff`
- `ChannelPrefix`
- `TimeKeyFlag`
- `TrackKey`
- `UseKeyShift`
- `TempoChange` の推移形式
- `KeyPressure` / `KP`
- `Switch`
- `End`
- `MsgBox`（コアでは `CompileOutput.messages` に格納し、ホスト側で表示する）
- `PlayFrom.RPN_NRPN` の状態復元

`spec/10-compatibility.md` もこれらを実装済みとして更新済みです。

## 未実装ではないもの

次は `Include/stdmsg.h` を起動時に読み込むことで Rust版でも利用できるため、TODOから除外しました。

- `DeviceNumber`（標準定義の変数）
- `VibratoRate`、`VibratoDepth`、`VibratoDelay`、`FilterCutoff`、`FilterResonance`、`EGAttack`、`EGDecay`、`EGRelease`（`NRPN` を呼ぶ標準関数）
- `PitchBendSensitivity`、`FineTune`、`CoarseTune`（`RPN` を呼ぶ標準関数）

## 実装時の確認

1. `doc/command/*.htm` と Pascal版の実装を確認する。
2. 最小MMLをPascal版とRust版で変換し、正規化イベントとSMFバイトを比較する。
3. `src/rust/core/tests/golden.rs` にMIDI出力の回帰テストを追加する。
4. 構文・異常系は `src/rust/core/tests/script.rs` に追加し、panicしないことを確認する。
