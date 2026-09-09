# Standard MIDI File 出力

## ファイル形式

現行 Rust は SMF format 1 を出力します。

```text
MThd + header length(6) + format(1) + track count + division
MTrk + track byte length + delta/event ... + End of Track
...
```

数値フィールドは MIDI 仕様に従いビッグエンディアンです。使用イベントのない論理トラックは出力しません。

## トラックイベント

コンパイル中は各イベントを絶対 tick として保持します。直列化時に安定ソートし、前イベントとの差を
可変長数値（VLQ）として書きます。同時刻イベントはソースから追加された順を維持します。

VLQ の最大値は 28 bit、`0x0FFFFFFF` です。超過時は不正な SMF を出さずエラーになります。

## ノート

ノートオンは `9n note velocity`、ノートオフは `8n note velocity` です。
ランニングステータスは使用しません。ノートオフにもノートオンと同じ変換後ベロシティを書きます。

```text
start = currentTime + timing
off   = start + scaledGate
next  = currentTime + noteLength
```

イベントの時刻が同じ場合でも、省略や統合は行いません。

## End of Track

各 MTrk の末尾には `FF 2F 00` を付けます。直前イベントから End of Track までの delta は、
そのトラックの最終タイムポインタとの差です。

## イベントデータ

| 種類 | バイト列の概要 |
|---|---|
| Note On | `9n note velocity` |
| Note Off | `8n note velocity` |
| Control Change | `Bn controller value` |
| Program Change | `Cn program` |
| Pitch Bend | `En lsb msb` |
| Tempo | `FF 51 03 tt tt tt` |
| Text meta | `FF type length cp932-bytes` |
| Time Signature | `FF 58 04 nn dd cc bb` |
| Key Signature | `FF 59 02 sf 00` |
| SysEx | `F0 length payload` |

テンポの 3 byte 値は `60,000,000 / BPM` マイクロ秒/四分音符です。BPM は正でなければなりません。

## 互換性検証

MIDI 互換性を変更する場合は、見た目のイベント名だけでなく生成バイト列を比較します。
`src/rust/core/tests/golden.rs` は Pascal 版で採取した期待値と MThd/MTrk 全体を比較する場所です。
スクリプト構文だけの変更でも、最終イベント時刻・同時刻順序・チャンネル・1起点/0起点変換を確認します。
