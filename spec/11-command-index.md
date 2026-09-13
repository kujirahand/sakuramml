# コマンド索引

この索引は現行 Rust で受理する主要コマンドを中心にしています。従来版の全コマンド名と旧 HTML ページ番号は
[従来版の全コマンド表](12-legacy-command-table.md) を参照してください。状態の意味は [互換性表](10-compatibility.md) に従います。

## 音符と構造

| コマンド | 書式 | 状態 | 詳細 |
|---|---|---|---|
| `a`〜`g` | `c[length][,q,v,t,o]` | 実装済み | [02](02-notes.md) |
| `n` | `n(note)[,length,q,v,t,o]` | 実装済み | [02](02-notes.md) |
| `r` | `r[length]` | 実装済み | [02](02-notes.md) |
| `^` | `^[length]` | 実装済み | [02](02-notes.md) |
| `o` | `o(value)` | 実装済み | [02](02-notes.md) |
| `l` | `l(length)` | 実装済み | [02](02-notes.md) |
| `q` | `q(value)` | 実装済み | [02](02-notes.md) |
| `v` | `v(value)` | 実装済み | [02](02-notes.md) |
| `t` | `t(value)` | 実装済み | [02](02-notes.md) |
| `Div` | `Div{mml}length` | 実装済み | [02](02-notes.md) |
| `Sub` / `S` | `Sub{mml}` | 実装済み | [03](03-tracks-and-time.md) |
| 反復 | `[count body:final]` | 実装済み | [06](06-scripting.md) |
| 和音 | `'notes'length` | 実装済み | [02](02-notes.md) |

## 時間とトラック

| コマンド | 書式 | 状態 | 詳細 |
|---|---|---|---|
| `Track` / `TR` / `NowTrack` | `TR=n` | 実装済み | [03](03-tracks-and-time.md) |
| `Channel` / `CH` | `CH=n` | 実装済み | [03](03-tracks-and-time.md) |
| `TrackSync` | `TrackSync` | 実装済み | [03](03-tracks-and-time.md) |
| `Play` | `Play({track0},{track1},...)` | 実装済み | [03](03-tracks-and-time.md) |
| `TrackMute` | `TrackMute(on/off)` | 実装済み | [03](03-tracks-and-time.md) |
| `Solo` / `Mute` | `Solo(n1,n2,...)` | 実装済み | [03](03-tracks-and-time.md) |
| `Stretch` | `Stretch{mml}length` | 実装済み | [03](03-tracks-and-time.md) |
| `TimeBase` | `TimeBase=n` | 実装済み | [03](03-tracks-and-time.md) |
| `TimeSignature` | `TimeSignature=n,d` | 実装済み | [03](03-tracks-and-time.md) |
| `Time` | コマンドまたは式 `Time(tick)` / `Time(m:b:s)` | 実装済み | [03](03-tracks-and-time.md) |
| `PrintTime` | `PrintTime([track])` | 実装済み | [06](06-scripting.md) |
| `PrintTrack` | `PrintTrack([track])` | 実装済み | [06](06-scripting.md) |
| `Tempo` | `Tempo=bpm` | 実装済み | [09](09-smf.md) |
| `TempoChange` | `TempoChange(t1,t2,len)` / `(t2,len)` / `=t2` | 実装済み | [09](09-smf.md) |

## MIDI イベント

| コマンド | 書式 | 状態 | 詳細 |
|---|---|---|---|
| `Voice` / `@` | `@voice[,msb,lsb]` | 実装済み | [04](04-midi-control.md) |
| `y` | `y(cc,value)` / `ycc,value` | 実装済み | [04](04-midi-control.md) |
| 名前付き CC | `P(value)`, `EP(value)` など | 実装済み | [04](04-midi-control.md) |
| `p` | `p(value)` / `p%(value)` | 実装済み | [04](04-midi-control.md) |
| `PitchBend` | `PitchBend(value)` | 実装済み | [04](04-midi-control.md) |
| `BR` | `BR(value)` | 実装済み | [04](04-midi-control.md) |
| `RPN` / `NRPN` | `RPN(msb,lsb,data)` | 実装済み | [04](04-midi-control.md) |
| `DeleteCC` | `DeleteCC(no)` | 実装済み | [04](04-midi-control.md) |
| `CCMute` | `CCMute(on/off)` | 実装済み | [04](04-midi-control.md) |
| `CCNoMute` | `CCNoMute(no,on/off)` | 実装済み | [04](04-midi-control.md) |
| `SysEx` | `SysEx(...)` / `SysEx$=...;` | 実装済み | [04](04-midi-control.md) |
| `ResetGM/GS/XG` | `ResetGM` | 実装済み | [04](04-midi-control.md) |

## メタ、キー、外部定義

| コマンド | 書式 | 状態 | 詳細 |
|---|---|---|---|
| `TrackName` | `TrackName={"text"}` | 実装済み | [05](05-meta-and-encoding.md) |
| `Copyright` | `Copyright={"text"}` | 実装済み | [05](05-meta-and-encoding.md) |
| `MetaText` / `Text` | `MetaText={"text"}` | 実装済み | [05](05-meta-and-encoding.md) |
| `Lyric` | `Lyric={"text"}` | 実装済み | [05](05-meta-and-encoding.md) |
| `Marker` | `Marker={"text"}` | 実装済み | [05](05-meta-and-encoding.md) |
| `CuePoint` | `CuePoint={"text"}` | 実装済み | [05](05-meta-and-encoding.md) |
| `InstrumentName` | `InstrumentName={"text"}` | 実装済み | [05](05-meta-and-encoding.md) |
| `Port` | `Port(n)` | 実装済み | [05](05-meta-and-encoding.md) |
| `Key` / `KeyShift` | `Key=n` | 実装済み | [02](02-notes.md) |
| `TimeKey` / `TimeKey2` | `TimeKey((from),(to),value)` | 実装済み | [02](02-notes.md) |
| `KeyFlag` | `KeyFlag+(notes)` / `=(...)` | 実装済み | [02](02-notes.md) |
| `Include` | `Include(file)` | 実装済み | [07](07-macros-and-includes.md) |

`MML(l|v|o|q|t|@|BR|p%|Key|TimeKey|TimeKey2|Port)`、`MML(yN)`、`SoundType`も
実装済みです。詳細は[06](06-scripting.md)を参照してください。

## System・構文設定

| コマンド | 書式 | 状態 | 詳細 |
|---|---|---|---|
| `X68mode` | `System.X68mode(on/off)` | 実装済み | [08](08-system-and-limits.md) |
| `Stepmode` | `System.Stepmode(on/off)` | 実装済み | [08](08-system-and-limits.md) |
| `VoiceNoShift` | `System.VoiceNoShift=n` | 実装済み | [08](08-system-and-limits.md) |
| `OctaveRangeShift` | `System.OctaveRangeShift=n` | 実装済み | [08](08-system-and-limits.md) |
| `GetKeyFlag` | `Array (name)=System.GetKeyFlag` | 実装済み | [08](08-system-and-limits.md) |
| `ControllerShift` | `System.ControllerShift=n` | 実装済み | [08](08-system-and-limits.md) |
| `ArgOrder` | `ArgOrder(lqvto)` | 実装済み | [08](08-system-and-limits.md) |
| `AllowMultiLine` | `AllowMultiLine(on/off)` | 実装済み | [08](08-system-and-limits.md) |
| `MetaTextEOL` | `MetaTextEOL(0/1/2)` | 実装済み | [05](05-meta-and-encoding.md) |
| `LoadSMF` | `System.LoadSMF(file)` | 未実装 | [08](08-system-and-limits.md) |

## スクリプトとマクロ

| コマンド | 書式 | 状態 | 詳細 |
|---|---|---|---|
| `Int` / `Integer` | `Int name=value` | 実装済み | [06](06-scripting.md) |
| `Str` | `Str name={"text"}` | 実装済み | [06](06-scripting.md) |
| `Array` | `Array name=(...)` | 実装済み | [06](06-scripting.md) |
| `If` / `Else` | `If(cond){...} Else {...}` | 実装済み | [06](06-scripting.md) |
| `While` | `While(cond){...}` | 実装済み | [06](06-scripting.md) |
| `For` | `For(init;cond;next){...}` | 実装済み | [06](06-scripting.md) |
| `Exit` | `Exit` | 実装済み | [06](06-scripting.md) |
| `Function` | `Function name(params){...}` | 実装済み | [06](06-scripting.md) |
| `Result` | `Result=value` | 実装済み | [06](06-scripting.md) |
| `Print` | `Print(value)` | 実装済み | [06](06-scripting.md) |
| `MID` / `POS` / `POSX` / `Replace` | 各文字列引数 | 実装済み | [06](06-scripting.md) |
| `ArraySortNum` / `ArraySortStr` | `ArraySortNum(array)` | 実装済み | [06](06-scripting.md) |
| `StrToNum` / `HEX` / `VarType` / `SizeOf` | 各値引数 | 実装済み | [06](06-scripting.md) |
| リズム | `$x{mml}`, `Rythm{...}` | 実装済み | [07](07-macros-and-includes.md) |
| ストトン定義 | `~{name}={mml}` | 実装済み | [07](07-macros-and-includes.md) |
| 文字列マクロ | `#name={"mml"}` | 実装済み | [07](07-macros-and-includes.md) |
