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

テンポの 3 byte 値は `60,000,000 / BPM` マイクロ秒/四分音符です。この値を符号なし24 bitに
格納でき、かつ0にならないよう、BPMは4〜60,000,000でなければなりません。

`TempoChange`は次の3形式を受理します。

- `TempoChange(t1,t2,len)` — `t1`から`t2`へ推移します。
- `TempoChange(t2,len)` — 現在のテンポから`t2`へ推移します。
- `TempoChange=t2` — 現在のテンポから`t2`へ全音符の長さで推移します。

`len`はtick数で、`!1`などの音長指定も使用できます。従来版と同様に16分音符
（`TimeBase / 4` tick）ごとにBPMを線形補間し、端数を0方向へ切り捨てます。終端だけは
`start + len`へ`t2`を必ず書きます。推移イベントはMTrk 0に置き、現在トラックの時間ポインタを
進めません。同じ時刻・同じBPMのイベントも統合しません。

期間は正で、かつ16分音符以上でなければなりません。`TimeBase`が4未満の場合や、期間から
算出したイベント数がコンパイラ上限を超える場合も、panicせずコンパイルエラーにします。

## 互換性検証

MIDI 互換性を変更する場合は、見た目のイベント名だけでなく生成バイト列を比較します。
`src/rust/core/tests/golden.rs` は Pascal 版で採取した期待値と MThd/MTrk 全体を比較する場所です。
スクリプト構文だけの変更でも、最終イベント時刻・同時刻順序・チャンネル・1起点/0起点変換を確認します。

## CLIのイベントダンプ

Rust CLIはSMFを行単位のテキストへ変換できます。

```sh
src/rust/target/debug/csakura --dump-midi song.mid
src/rust/target/debug/csakura --dump-midi song.mid song.txt
diff -u pascal.txt rust.txt
```

MTrkはファイル内の0起点順で`TR(n)`、時刻は既定の4/4グリッドによる
`TIME(小節:拍:tick)`で表示します。各`TR(n)`の前には`// -------------------------------------------`
の区切りコメントが入ります。ノートオンと対応するノートオフはまとめて、例えば
`TIME(1:1:0) CH(1) o5c4,%95,100`と表示します。最初の音長は次のノートオンまでの間隔
（最後の音はゲート長）、`%95`は実際のノートオンからオフまでのtick、最後はベロシティです。
対応するノートオフがない場合のゲート長は0になります。

`CH(n)`はそのトラック内でチャンネルが変わった時だけ表示し、同じチャンネルが
続く間は省略します。

MMLコマンドへ変換できるイベントは`DirectSMF`ではなくコマンドで表示します。

| SMFイベント | ダンプ表記 |
|---|---|
| プログラムチェンジ `$Cn,p` | `@p+1`(1起点) |
| コントロールチェンジ `$Bn` | `y番号,値` |
| ピッチベンド `$En` | `PitchBend(-8192..8191)` |
| SysEx `$F0` | `SysEx$(F0,...)`(16進) |
| テンポ `$FF,$51` | `Tempo=BPM`(正確に戻らない値は`DirectSMF`) |
| 拍子 `$FF,$58` | `TimeSignature=分子,分母` |
| 調号 `$FF,$59` | `KeyFlag(...)`(五度圏の音名) |
| 文字列メタ `$FF,$01..$07` | `MetaText("...")`、`TrackName("...")`など(CP932をUTF-8へ復号、往復が一致しないものは`DirectSMF`) |
| チャンネルプレフィックス `$FF,$20` | `ChannelPrefix(n+1)` |
| ポート `$FF,$21` | `Port(n)` |

これらで表現できないイベントは`TIME(1:1:0) DirectSMF($C0,$05)`のように、イベント本体を
16進数で表示します。デルタタイムのVLQ、MTrk長、ランニングステータスは正規化されるため、格納方式の
違いで後続バイトがすべてずれることなく、イベントの追加・欠落・時刻差を通常のテキスト差分で
確認できます。`TIME`は拍子メタイベントに追従せず、比較用の固定4/4表示です。
