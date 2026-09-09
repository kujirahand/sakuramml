# 音色と MIDI 制御

## 音色

`@n` または `Voice=n` は Program Change を出力します。MML の音色番号は 1〜128、MIDI データは 0〜127 です。
範囲外の値は現行 Rust では 1〜128 相当へ丸められます。

```mml
@1
Voice=25
@1,0,0
```

第2、第3引数を指定すると、Program Change の直前に Bank Select MSB（CC#0）と LSB（CC#32）を出力します。

## Control Change

任意の CC は `y(number,value)` または `ynumber,value` で書きます。番号と値は MIDI の 0〜127 へ丸められます。

```mml
y(7,100)
y10,64
```

よく使う CC には名前があります。

| コマンド | 短縮 | CC | 用途 |
|---|---|---:|---|
| `Modulation` | `M` | 1 | モジュレーション |
| `PortamentoTime` | `PT` | 5 | ポルタメント時間 |
| `DataMSB` | `Y` | 6 | Data Entry MSB |
| `MainVolume` | `V` | 7 | チャンネル音量 |
| `Panpot` | `P` | 10 | パン |
| `Expression` | `EP` | 11 | エクスプレッション |
| `DataLSB` | — | 38 | Data Entry LSB |
| `Sustain` | — | 64 | サステインペダル |
| `PortamentoSwitch` | `PS` | 65 | ポルタメントスイッチ |
| `Reverb` | `REV` | 91 | リバーブセンド |
| `Chorus` | `CHO` | 93 | コーラスセンド |
| `VAR` | — | 94 | バリエーションセンド |

## RPN と NRPN

```mml
RPN(0,0,12)
NRPN(1,8,64)
```

`RPN` は CC#101、CC#100、CC#6、`NRPN` は CC#99、CC#98、CC#6 の順に同時刻へ出力します。
data は MSB のみです。LSB まで必要な場合は `DataLSB` または `y38,value` を明示します。

## ピッチベンド

`p` は 0〜63〜127 の簡易指定で、指定値をピッチベンドの MSB、LSB を 0 として出力します。
`p%` と `PitchBend` は -8192〜0〜8191 の 14 bit 値です。

```mml
p64
p%(0)
PitchBend(-4096)
```

フルレンジ形式は `raw = clamp(value + 8192, 0, 16383)` とし、下位 7 bit、上位 7 bit の順に書きます。

## SysEx

SysEx は 10 進の引数形式と、`$` を用いた 16 進形式を受理します。

```mml
SysEx($F0,$7E,$7F,$09,$01,$F7)
SysEx$=F0,7E,7F,09,01,F7;
```

先頭の `$F0`/`F0` はデータ本体から取り除かれ、SMF の SysEx イベント `F0 length payload` として出力します。
終了バイト `$F7` は payload に含めます。

## 音源リセット

`ResetGM`、`ResetGS`、`ResetXG` は、それぞれ既定の System Exclusive メッセージを出力します。
これらは MIDI ポートへ直接送信する命令ではなく、生成する SMF にイベントとして記録されます。

## 値の範囲

ノート番号と MIDI チャンネルは範囲外をエラーにします。一方、音色、CC、ベンドの最終 MIDI 値は
現行 Rust では有効範囲へ丸めます。移植性の高いソースでは、最初から規定範囲内の値を指定してください。

## 先行指定

コマンドの後ろに `.` で続けて、値の与え方そのものを指定できます。CC とベンドに対しては
次の指定が使えます。

| 指定 | 別名 | 書式 | 意味 |
|---|---|---|---|
| `.onNote` | `.N` | `(v1,v2,...)` | ノート毎に1つずつ値を書く。音符の1tick前に書く |
| `.onTime` | `.T` | `(low,high,len,...)` | 直線的に推移する値を、**記述位置で即座に**書き出す |
| `.onCycle` | `.C` | `(len,v1,v2,...)` | `len` tick 毎に次の値へ進む |
| `.onNoteWave` | `.W` | `(low,high,len,...)` | ノート毎に直線推移。ノート長で打ち切る |
| `.onNoteWaveEx` | `.WE` | `(low,high,len,...)` | ノート毎。各区間の長さをノート長に比例配分する |
| `.onNoteWaveR` | `.WR` | `(low,high,len,...)` | ノートが鳴っている間、繰り返し書く |
| `.Sine` | — | `(type,low,high,len,times)` | サインカーブを記述位置で即座に書く |
| `.onNoteSine` | — | `(type,low,high,len,times)` | ノート毎にサインカーブを書く。ノート長で打ち切る |

`type` は `0`:サイン、`1`:徐々に大きく、`2`:徐々に小さく です。

値そのものではなく、書き方を調整する指定もあります。

| 指定 | 書式 | 意味 |
|---|---|---|
| `.Delay` | `.Delay(v)` | 効果を `v` tick 遅らせる。ベンドでは元の位置に中央値を残す |
| `.Repeat` | `.Repeat(0/1)` | `0` で、リストを使い切ったら繰り返さず終了する |
| `.Random` | `.Random(v)` | 書き込む値に ±`v/2` の揺らぎを加える |
| `.Range` | `.Range(low,high)` | 書き込む値を範囲内に丸める |
| `.Frequency` | `.Frequency(v)` | 推移の書き込み間隔（既定 2 tick）。曲全体の設定 |

音符属性（`v` `q` `t` `l` `o`）には `.onNote` と `.Random` が使えます。
`q.Max(v)` / `v.Max(v)` は `System.qMax` / `System.vMax` と同じです。

引数中の `!n` は「n分音符の長さ」を tick 値として書く記法です（`!4` は四分音符）。

推移の書き込みは、直前に書いた値と同じ値を重ねて書きません。`.onTime` と `.Sine` は、
同じ CC 番号について記述位置以降に既にあるイベントを削除してから書き出します。
