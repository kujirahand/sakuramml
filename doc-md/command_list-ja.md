# SakuraMML コマンドリファレンス（Rust実装版）

この文書は、Rust 実装（`src/rust/`）が実際に受理するコマンドの一覧です。
正式な仕様の詳細は `spec/` を、従来版（Pascal）の全コマンド名は `spec/12-legacy-command-table.md` を参照してください。

## 目次

- [基本ルール](#基本ルール)
- [音符・休符](#音符休符)
- [音符属性](#音符属性)
- [構造（和音・連符・反復・同時記述）](#構造和音連符反復同時記述)
- [キー・移調](#キー移調)
- [トラック・チャンネル・時間](#トラックチャンネル時間)
- [テンポ](#テンポ)
- [音色・MIDI制御](#音色midi制御)
- [先行指定（.onNote など）](#先行指定onnote-など)
- [メタイベント](#メタイベント)
- [System設定](#system設定)
- [スクリプト](#スクリプト)
- [組み込み関数・組み込み値](#組み込み関数組み込み値)
- [マクロ・ストトン・Include](#マクロストトンinclude)

## 基本ルール

### 区切りとコメント

```mml
Tempo=120; o5 l8; c d e f     // ; 空白 改行は区切り
// 行末までのコメント
/* 複数行コメント */
```

### 数値

| 書式 | 意味 |
|---|---|
| `123` | 10進数（負号可） |
| `$F0` | 16進数 |

式は符号付き 64bit 整数で評価され、オーバーフローはエラーになります。

### 小文字コマンドと大文字コマンド

小文字の単文字コマンド（音符属性 `v` `q` `o` `t`）と、大文字で始まる単語コマンド（`Tempo` `Voice` など）では、引数の受け取り方が異なります。

**小文字コマンド（`v q o t`）** — 現在のトラック状態に対する「設定・調整」:

| 書き方 | 例 | 動作 |
|---|---|---|
| 直結 | `v100` | 絶対値を設定 |
| 相対 | `v+` `v-` `q+++` | 現在値から既定増分だけ増減（v=8、q=10、oとt=1。`System.vAdd` 等で変更可） |
| 相対（量指定） | `v+10` `t-5` | 現在値から指定量を加減算 |
| 括弧 | `v(x)` `v(1+2)` | 括弧内を完全な式として評価 |
| `=` | `v=100` | 数値・`$16進`・`!n` のみ。**変数・関数呼び出しは書けない**（`v=x` はエラー。`v(x)` を使う） |

**大文字コマンド（`Tempo` `Voice` `Track` など）** — 値の「代入」:

| 書き方 | 例 | 動作 |
|---|---|---|
| `=` | `Tempo=120` `Voice=Piano` `Tempo=Random(90,130)` | 右辺は**単一の値・変数・関数呼び出し**。複合式は不可（`Tempo=100+20` はエラー） |
| 括弧 | `Tempo(100+20)` | 括弧内を完全な式として評価 |
| 直結 | `Tempo 120` | 値を直結できる。ただし単語と数字をくっつけた `Tempo120` は別のコマンド名と解釈されエラー |
| 相対 | — | `+`/`-` による相対指定は**不可**（`Tempo+5` はエラー） |

まとめ:

- 現在値からの相対指定（`v+` など）ができるのは小文字コマンドだけ
- `=` の右辺に変数・関数呼び出しを書けるのは大文字コマンドだけ（小文字は括弧 `v(x)` を使う）

### 引数の三つの形

| 形式 | 例 | 備考 |
|---|---|---|
| 直結 | `v100`, `o5`, `l8` | 整数または音長 |
| 括弧 | `Tempo(60+60)`, `o(x)` | 括弧内で式を評価できる |
| 代入形 | `Tempo=120`, `Voice=Piano` | 右辺は単一の値・変数・関数呼び出し |

`Tempo(100+20)` は書けますが `Tempo=100+20` は書けません。

### 主な既定値

| 状態 | 初期値 |
|---|---:|
| 現在トラック | 1 |
| タイムベース | 四分音符 96 tick |
| 拍子 | 4/4 |
| オクターブ | 5（`c` が MIDI 60） |
| 既定音長 | `l4` = 96 tick |
| ベロシティ | 100 |
| ゲート | 80 |
| タイミング補正 | 0 tick |
| `System.qMax` / `vMax` | 100 / 127 |
| ベンドレンジ | 2 |

大文字・小文字は自動的には無視されません。`Tempo`・`TEMPO` は有効ですが、
記載のない綴り（例: `tempo`）は保証されません。

## 音符・休符

| コマンド | 書式 | 説明 |
|---|---|---|
| `a`〜`g` | `c[length][,q,v,t,o]` | 音名。ドレミ…は `c d e f g a b`。音名の直後の `+`/`#` で半音上、`-` で半音下。`*` でその音だけ KeyFlag を無効 |
| `n` | `n(note)[,attr...]` | MIDI ノート番号（0〜127）を直接指定。キー移調は適用されるが臨時記号は適用されない |
| `r` | `r[length]` | 休符。タイムポインタだけ進める。`r-2.` のように負の音長で巻き戻しも可 |
| `^` | `^[length]` | タイ。直前の音のノートオフを延長する |
| 和音 | `'ceg'4` | 単引用符内の音を同時発音。閉じ引用符の後の音長が全体の長さ |

### 音長の書き方

| 例 | 意味 |
|---|---|
| `c4` | 四分音符（`timebase*4/n` tick） |
| `c4.` / `c4..` | 付点 / 複付点 |
| `c%48` | 48 tick を直接指定 |
| `c4^8` | 四分＋八分を加算 |
| `l8` | 以後の既定音長を八分音符に |

`l%24` のように tick モードにすると、以後の `c96` などの数値も tick として解釈します。

## 音符属性

| コマンド | 書式 | 説明 |
|---|---|---|
| `o` | `o5` / `o(x)` | オクターブを設定 |
| `>` / `<` | — | オクターブを 1 上下（`System.X68mode` で逆転） |
| `` ` `` / `"` | — | 次の 1 音だけオクターブを 1 上下 |
| `l` | `l4` / `l%96` | 既定音長 |
| `q` | `q80` / `q%48` | ゲート（音長に対する発音割合、または tick 指定） |
| `v` | `v100` | ベロシティ（音の強さ） |
| `t` | `t0` | ノートオン時刻の前後補正（tick）。ポインタ自体は動かない |

### 音符ごとの個別指定

音符引数は標準順で `l,q,v,t,o`。省略位置は空のカンマで表します（`ArgOrder` で順序変更可）。

```mml
c4,90,110,-2,5      // 音長4分、q=90、v=110、t=-2、o=5
c(4,90,110,-2,5)    // 括弧形式
```

## 構造（和音・連符・反復・同時記述）

| コマンド | 書式 | 説明 |
|---|---|---|
| `Div` | `Div{cde}4` | 連符。本体の音数で全体長を等分 |
| `Sub` / `S` | `Sub{'ceg'1} cdef` | 本体を演奏した後、タイムポインタを開始位置へ戻す（重ね書き用） |
| 反復 | `[4 cdef]` / `[2 cde:f]` | 本体を n 回反復。`:` 以降は最終回のみ |
| `Stretch` | `Stretch{cdef}2` | フレーズ全体を指定音長へ伸縮 |
| `Play` | `Play(mml0,mml1,...)` | 引数位置を 0 起点のトラック番号として、複数 MML を同時に書き込む |

```mml
#Melody={"o5 cdef"}
#Bass={"o3 c2g2"}
Play(#Melody,#Bass)    // 空の引数位置はスキップされる
```

## キー・移調

| コマンド | 書式 | 説明 |
|---|---|---|
| `Key` / `KeyShift` | `Key=2` | 全トラック共通の半音移調 |
| `TrackKey` | `TrackKey(-1)` | 現在トラックだけの移調 |
| `TimeKey` | `TimeKey((2:1:0),(3:1:0),3)` | 時間範囲つき移調（開区間・終了は含まない） |
| `TimeKey2` | `TimeKey2(...)` | 第二の時間範囲移調。同じ時刻では TimeKey と加算 |
| `KeyFlag` | `KeyFlag+(fc)` / `KeyFlag=(0,0,-1,0,0,0,0)` | 臨時記号の既定値。`=` の並びは `c,d,e,f,g,a,b` 順 |
| `TimeKeyFlag` | `TimeKeyFlag((from),(to),(a,b,c,d,e,f,g))` | 時間範囲つき臨時記号（7値は `a〜g` 順） |
| `UseKeyShift` | `UseKeyShift(on/off)` | Key/TimeKey/TimeKey2/TrackKey の適用のon/off |

```mml
TimeKey((2:1:0),(3:1:0),3)   // 第2小節頭から第3小節頭まで +3半音
KeyFlag+(fc)                 // FとCをシャープ
```

## トラック・チャンネル・時間

| コマンド | 別名 | 書式 | 説明 |
|---|---|---|---|
| `Track` | `TR` / `NowTrack` | `TR=2` | 現在の論理トラックを選ぶ |
| `Channel` | `CH` | `CH=10` | MIDIチャンネル 1〜16。未指定ならトラック番号と同じ |
| `TimeBase` | — | `TimeBase=96` | 四分音符あたりの tick 数（1〜32767） |
| `TimeSignature` | — | `TimeSignature=3,4` | 拍子メタイベントを出力し、`Time` 計算にも使う |
| `Time` | — | `Time(384)` / `Time(2:1:0)` | タイムポインタを絶対tickまたは `小節:拍:tick` へ移動 |
| `TrackSync` | — | `TrackSync` | 全トラックを最も進んだポインタへ揃える |
| `TrackMute` | — | `TrackMute(on)` | 現在トラックの音符の書き込みを一時停止 |
| `Solo` / `Mute` | — | `Solo(1,3)` | 指定トラックだけ / 以外を出力に残す（出力フィルタ） |
| `PlayFrom` | — | `PlayFrom(1:1:0)` | 指定位置から演奏（出力用フィルタ） |
| `PlayTo` | — | `PlayTo=(2:1:0)` | 指定位置までを出力に残す |
| `PrintTime` | — | `PrintTime([track])` | トラック番号・時刻を `messages` へ出力 |
| `PrintTrack` | — | `PrintTrack([track])` | トラック状態の詳細を `messages` へ出力 |

```mml
Time(2:1:0)     // 第2小節の先頭（小節・拍は1起点、tickは0起点）
```

## テンポ

| コマンド | 書式 | 説明 |
|---|---|---|
| `Tempo` | `Tempo=120` | テンポメタイベントをトラック0の現在時刻へ出力 |
| `TempoChange` | `TempoChange(t1,t2,len)` | t1→t2 へ推移。`(t2,len)` で現在値から、`=t2` で全音符の長さで推移 |

## 音色・MIDI制御

| コマンド | 書式 | 説明 |
|---|---|---|
| `Voice` / `@` | `@1` / `Voice=25` / `@1,0,0` | Program Change。第2・3引数で Bank Select（CC0/CC32）も出力 |
| `y` | `y(7,100)` / `y10,64` / `y11=127` | 任意の Control Change |
| `RPN` | `RPN(msb,lsb[,data])` | CC#101→#100→#6 の順に出力 |
| `NRPN` | `NRPN(msb,lsb[,data])` | CC#99→#98→#6 の順に出力 |
| `p` | `p64` | 簡易ピッチベンド（0〜127、64が中央） |
| `p%` | `p%(0)` | フルレンジのピッチベンド（-8192〜8191） |
| `PitchBend` | `PitchBend(-4096)` | `p%` と同じ 14bit 値 |
| `BR` | `BR(12)` | ベンドレンジ（RPN#0,0 を設定） |
| `NoteOn` | `NoteOn(64,127)` | 生の Note On を書く（ゲート・音長なし、ポインタ不動） |
| `NoteOff` | `NoteOff(64,0)` | 生の Note Off を書く |
| `KeyPressure` / `KP` | `KP(80)` | 直前の音へポリフォニックアフタタッチ（0〜127） |
| `SysEx` | `SysEx($F0,$7E,$7F,$09,$01,$F7)` | System Exclusive。10進/16進（`SysEx$=...;`）両形式 |
| `ResetGM` | `ResetGM` | GMリセット SysEx を出力 |
| `ResetGS` | `ResetGS` | GSリセット SysEx を出力 |
| `ResetXG` | `ResetXG` | XGリセット SysEx を出力 |
| `DeleteCC` | `DeleteCC(11)` | 現在位置以降の指定CC予約を削除（256/257でピッチベンド） |
| `CCMute` | `CCMute(on)` | 現在トラックのCC・ベンド書き込みを一時停止 |
| `CCNoMute` | `CCNoMute(11,on)` | 指定CC番号だけ書き込みを抑制 |
| `Slur` | `Slur(type[,value[,range]])` | スラー。type 0:グリッサンド 1:ベンド 2:ゲート 3:アルペジオ |
| `DirectSMF` | `DirectSMF($C0,$05)` | 生バイト列をそのままイベントとして書く |
| `Cresc` | `Cresc=len[,v1][,v2]` | Expression(CC11)を大きく（既定 40→127） |
| `Decresc` | `Decresc=len[,v1][,v2]` | Expression(CC11)を小さく（既定 127→40） |

### 名前付きコントロールチェンジ

| コマンド | 短縮 | CC番号 | 用途 |
|---|---|---:|---|
| `Modulation` | `M` | 1 | モジュレーション |
| `PortamentoTime` | `PT` | 5 | ポルタメント時間 |
| `DataMSB` | `Y` | 6 | Data Entry MSB |
| `MainVolume` | `V` | 7 | チャンネル音量 |
| `Panpot` | `P` | 10 | パンポジション |
| `Expression` | `EP` | 11 | エクスプレッション |
| `DataLSB` | — | 38 | Data Entry LSB |
| `PortamentoSwitch` | `PS` | 65 | ポルタメントスイッチ |
| `Reverb` | `REV` | 91 | リバーブセンド |
| `Chorus` | `CHO` | 93 | コーラスセンド |
| `Variation` | `VAR` | 94 | バリエーションセンド |

注意: 従来ドキュメントにある `Sustain`（CC64）は Rust 実装では未定義です。`y64,127;` を使ってください。

## 先行指定（.onNote など）

CC・ベンド・音符属性の後ろに `.` で続け、値の与え方を指定します。

```mml
EP.onTime(40,127,!4)     // 4分音符の間で40→127へ直線推移
v.onNote(120,80,100) cdefg
```

| 指定 | 別名 | 書式 | 説明 |
|---|---|---|---|
| `.onNote` | `.N` | `(v1,v2,...)` | ノートごとに値を巡回 |
| `.onTime` | `.T` | `(low,high,len,...)` | 記述位置で直線推移を即座に書く |
| `.onCycle` | `.C` | `(len,v1,v2,...)` | `len` tick ごとに値を進める |
| `.onNoteWave` | `.W` | `(low,high,len,...)` | ノートごとに直線推移、ノート長で打ち切り |
| `.onNoteWaveEx` | `.WE` | `(low,high,len,...)` | ノートごと、区間長をノート長に比例配分 |
| `.onNoteWaveR` | `.WR` | `(low,high,len,...)` | ノート発音中、繰り返し書く |
| `.Sine` | — | `(type,low,high,len,times)` | サインカーブを記述位置で書く |
| `.onNoteSine` | — | `(type,low,high,len,times)` | ノートごとにサインカーブ |
| `.Delay` | — | `(v)` | 効果を `v` tick 遅らせる |
| `.Repeat` | — | `(0/1)` | 0でリストを使い切ったら繰り返さない |
| `.Random` | — | `(v)` | 値に ±`v/2` の揺らぎを加える |
| `.Range` | — | `(low,high)` | 書き込む値を範囲内に丸める |
| `.Frequency` | — | `(v)` | 推移の書き込み間隔（既定 2 tick、曲全体） |
| `.Max` | — | `(v)` | `q.Max`/`v.Max` は `System.qMax`/`vMax` と同じ |

音符属性（`v q t l o`）は `.onNote/.onTime/.onCycle/.Delay/.Repeat/.Random/.Range` に対応しますが、
波形系（`.onNoteWave` 等）は使えません。

引数中の `!n` は「n分音符の長さ」を tick 値で書く記法です（`!4` = 四分音符。`!1^1` のような結合も可）。

## メタイベント

| コマンド | meta型 | 書式 | 説明 |
|---|---|---|---|
| `TrackName` | FF 03 | `TrackName={"曲名"}` | 曲名・トラック名 |
| `Copyright` | FF 02 | `Copyright={"2026 ..."}` | 著作権 |
| `MetaText` / `Text` | FF 01 | `MetaText={"..."}` | 汎用テキスト |
| `Lyric` | FF 05 | `Lyric={"歌詞"}` / `Lyric{A-melo}` | 歌詞 |
| `Marker` | FF 06 | `Marker={"..."}` | マーカー |
| `CuePoint` | FF 07 | `CuePoint={"..."}` | キューポイント |
| `InstrumentName` | FF 04 | `InstrumentName={"..."}` | 楽器名 |
| `ChannelPrefix` | FF 20 | `ChannelPrefix(1)` | チャンネルプリフィックス（1〜128、内部は -1） |
| `Port` | FF 21 | `Port(0)` | MIDIポート（0〜255） |
| `MetaTextEOL` | — | `MetaTextEOL(0)` | テキスト内改行。0=CRLF（既定）、1=LF、2=CR |

テキスト系メタイベントの payload は常に CP932 へ符号化されます（CP932 にない文字は `?` と警告）。

## System設定

`System.名前` の形式で指定します。

| 設定 | 既定値 | 説明 |
|---|---:|---|
| `System.TimeBase=n` | 96 | 四分音符の tick 数 |
| `System.TimeSignature=n,d` | 4,4 | `TimeSignature` と同じ |
| `System.KeyFlag...` | 0 | `KeyFlag` と同じ |
| `System.KeyShift=n` | 0 | `Key` と同じ |
| `System.qMax=n` | 100 | q の 100% 相当値 |
| `System.vMax=n` | 127 | v の最大相当値 |
| `System.vAdd=n` / `qAdd` / `q2Add` | 8 / 10 / 8 | `v+` `q+` `q%+` の既定増分 |
| `System.MeasureShift=n` | 0 | `Time(小節:拍:tick)` の小節オフセット |
| `System.RandomSeed=n` | 固定 | 乱数シード（再現可能） |
| `System.X68mode(on/off)` | off | `<` と `>` の方向を入れ替える |
| `System.Stepmode(on/off)` | off | 以後に生成するトラックの音長を tick 指定として初期化 |
| `System.VoiceNoShift=n` | 0 | 音色番号へ加えるオフセット |
| `System.OctaveRangeShift=n` | 0 | 音名のオクターブへのオフセット（`n` には適用しない） |
| `System.ControllerShift=n` | 1 | CC・ベンドを先行させる tick 数 |
| `System.GetKeyFlag` | — | KeyFlag を `c〜g` 順の配列で返す |
| `System.Include(file)` | — | `Include` と同じ |
| `System.Div` / `Rythm` / `Sub` | — | 対応する通常コマンドと同じ |

未実装の `System.name` は引数ごと読み飛ばして警告になります（`System.LoadSMF` など）。

### 構文設定（System. 経由でも可）

| 設定 | 既定値 | 説明 |
|---|---:|---|
| `ArgOrder(lqvto)` | `lqvto` | 音符のカンマ引数の順序。`l q v t o` の部分集合 |
| `AllowMultiLine(on/off)` | on | off なら改行を含む和音をエラーにする |
| `UseKeyShift(on/off)` | on | キー移調の適用可否 |

## スクリプト

### 変数宣言

| コマンド | 書式 | 説明 |
|---|---|---|
| `Int` / `Integer` | `Int tempo=120` | 整数変数 |
| `Str` | `Str s={"cdef"}` | 文字列変数。コマンド位置に単独で書くと中身を MML として再解釈 |
| `Array` | `Array chord=(60,64,67)` | 配列（0起点の添字） |

変数は大域です。宣言済み名をコマンド位置で書くと代入になります（`i=(i+1)`）。

### 制御構文

| コマンド | 書式 | 説明 |
|---|---|---|
| `If` / `Else` | `If(cond){...} Else {...}` | 条件分岐 |
| `While` | `While(cond){...}` | 反復 |
| `For` | `For(i=0; i<4; i=(i+1)){...}` | 反復 |
| `Switch` | `Switch(v){Case(1){...} Default{...}}` | 多分岐 |
| `Exit` | `Exit` | 現在の反復から抜ける |
| `End` | `End` | コンパイルを停止する |
| `Function` | `Function f(Int a=1){...}` | 関数定義。実行順で組み込みより優先 |
| `Result` | `Result=value` | 関数の戻り値を設定 |
| `Print` | `Print(value)` | 結果の `messages` へ出力 |
| `MsgBox` | `MsgBox("text")` | `Print` 同様 `messages` へ出力 |

```mml
Function Arp(Int root, Int count=3) {
  n(root) n(root+4) n(root+7)
  Result=count
}
Int r=Arp(60)
```

`Str` 引数を 1 つだけ取る関数は `Echo(ドレミ)` のように引用符なしで MML を渡せます。

### 演算子

優先順位は高い順に `* / %` → `+ -` → 比較（`== != < <= > >=`） → `&&` → `||`。
整数 0・空文字列・空配列は偽、それ以外は真です。文字列の `+` は連結です。

## 組み込み関数・組み込み値

| 名前 | 書式 | 説明 |
|---|---|---|
| `on` / `off` | — | 1 / 0 |
| `SoundType` | — | 音源タイプ変数（初期値 0 = GM） |
| `Random(n)` | `Random(10)` | 0〜n の整数乱数 |
| `Random(a,b)` | `Random(1,6)` | a〜b の整数乱数 |
| `RandomSelect(...)` | `RandomSelect(a,b,c)` | 引数から 1 個選ぶ |
| `Step(n)` | `Step(24)` | n tick（`!n` と同じ） |
| `StrToLen(n)` | `StrToLen(4)` | 分母 n の音長を tick へ変換 |
| `SizeOf(v)` | `SizeOf(arr)` | 配列要素数 / 文字数 / 整数なら 4 |
| `StrToNum(s)` | `StrToNum("10")` | 10進または `$` 16進文字列を数値化。不能なら 0 |
| `HEX(n)` | `HEX(255)` | `$FF` 形式の16進文字列。配列も可 |
| `#STR(v)` | `#STR(42)` | 文字列化 |
| `ASC(s)` | `ASC("A")` | 先頭文字のコードポイント |
| `CHR(n)` | `CHR(65)` | コードポイントから文字列化 |
| `MID(s,i,len)` | `MID("abc",2,1)` | 1起点位置から切り出す |
| `POS(sub,s)` | `POS("b","abc")` | 1起点の検索位置。見つからなければ 0 |
| `POSX(sub,s,start)` | `POSX(...)` | 指定位置以降を検索 |
| `Replace(s,from,to,onoff)` | `Replace(s,"a","b",on)` | off なら最初の 1 つ、on なら全置換 |
| `VarType(v)` | `VarType(x)` | `Int` / `Str` / `Array` を返す |
| `ArraySortNum(a)` | — | 数値昇順の新しい配列 |
| `ArraySortStr(a)` | — | 文字列昇順の新しい配列 |
| `VERSION()` | — | 互換用バージョン数 |
| `NoteNo(mml)` | `NoteNo(o4c)` | MML 音符の MIDI ノート番号を問い合わせ（演奏しない） |
| `MML(name)` | `MML(v)` | 現在の命令値。`l v o q t @ BR p p% Key TimeKey TimeKey2 Port` や `MML(y11)` などのCC |
| `Time(m:b:s)` | `Time(2:1:0)` | `小節:拍:tick` を絶対 tick へ変換（ポインタ不動） |
| `System.GetKeyFlag` | `Array f=System.GetKeyFlag` | KeyFlag を `c〜g` 順の配列で取得 |

文字列変数の `.s(from,to)` は一致する部分をすべて置換します（Include マクロ用）。

## マクロ・ストトン・Include

### ストトン表記（日本語命令）

```mml
テンポ120 音階5 音符4 音量100
ドレミファソラシ↑ド
```

は概ね `Tempo=120 o5 l4 v100 cdefgab>c` と同じです。全対応語は
`spec/12-legacy-command-table.md` の「ストトン表記」を参照してください。
文字列内の日本語は置換されません。

### 全角記号の正規化

| 入力 | 変換後 |
|---|---|
| `ｃｄｅ`、`１２３` | `cde`、`123` |
| 全角空白 | 半角空白 |
| `【】` / `『』` | `[]` / `{}` |
| `↑` / `↓` | `>` / `<` |
| `♯` / `♭` | `#` / `-` |
| `一`〜`九`、`零`/`〇` | `1`〜`9`、`0` |

### 利用者定義マクロ

| 書式 | 説明 |
|---|---|
| `~{名前}={mml}` | ストトンマクロ定義。定義自体は音を出さない |
| `#name={"mml"}` | 文字列 MML マクロ。コマンド位置に書くと内容を MML として実行 |
| `$x{mml}` | リズムマクロ。半角 1 文字へ MML を割り当て |
| `Rythm{...}` / `Rhythm{...}` | リズムブロック。中でリズムマクロを展開 |

```mml
~{上昇}={cdefg}
上昇 上昇          // cdefg を2回

$b{n36,}
$s{n38,}
Rythm{b s b s}     // バスドラムとスネア
```

### Include

```mml
Include(chord2.h)
Include{"chord2.h"}
```

CLI は入力ファイルのディレクトリ、カレントディレクトリ、その各 `Include/` サブディレクトリ、
実行ファイルと同じディレクトリの順に探索します。
コンパイル前に `stdmsg.h` を自動読込し、GM 音色名（`GrandPiano`、`Strings1` など）や
ドラム名（`Kick1`、`Snare1` など）を変数として利用できます。

---

## 未実装の主な機能

| 機能 | 状態 |
|---|---|
| `System.LoadSMF` | 未対応（警告して読み飛ばし） |
| `Sustain`（名前付きCC） | 未定義。`y64,value` を使用 |
| 未実装の先行指定 `.*` | 警告して読み飛ばし |

その他の互換性情報は `spec/10-compatibility.md` を参照してください。
