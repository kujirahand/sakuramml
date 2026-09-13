# System 設定と安全制限

## 実装済み System 設定

| 設定 | 既定値 | 動作 |
|---|---:|---|
| `System.TimeBase=n` | 96 | 四分音符あたりの tick 数 |
| `System.TimeSignature=n,d` | 4,4 | 拍子イベントと `Time` 計算 |
| `System.KeyFlag...` | すべて 0 | 音名別の臨時記号 |
| `System.KeyShift=n` / `Keyshift` | 0 | 全ノートの半音移調 |
| `System.qMax=n` | 100 | q の 100% 相当値。最低 1 |
| `System.vMax=n` | 127 | v の最大相当値。最低 1 |
| `System.MeasureShift=n` | 0 | `Time(小節:拍:step)` の小節オフセット |
| `System.RandomSeed=n` | 固定初期値 | 再現可能な乱数列のシード |
| `System.X68mode(on/off)` | off | `<` と `>` の上下方向を入れ替える |
| `System.Stepmode(on/off)` | off | 以後に作るトラックの音長を tick 指定として初期化する |
| `System.VoiceNoShift=n` | 0 | `@` の音色番号へ加えるオフセット |
| `System.OctaveRangeShift=n` | 0 | 音名のオクターブへ加えるオフセット |
| `System.ControllerShift=n` | 1 | CC とピッチベンドを現在位置より先行させる tick 数 |
| `System.GetKeyFlag` | - | 現在の `c,d,e,f,g,a,b` の KeyFlag を配列として返す |

`System.Include`、`System.Div`、`System.Rythm`、`System.Sub` は対応する通常コマンドへ委譲します。

`Stepmode` は既存トラックを書き換えず、設定後に初めて選択・生成したトラックだけが値を継承します。
起動時に存在するトラック0も既定の音長モードのままです。`%` / `!` を付けた個別音長は、その音長に
限ってモードを反転します。

`VoiceNoShift` はMMLの1起点音色番号をMIDIの0起点番号へ直す際に加算します。変換結果が0〜127を
外れればエラーです。`OctaveRangeShift` は `a`〜`g` と `NoteNo(...)` に適用し、絶対音高を指定する
`n` には適用しません。

`ControllerShift` は通常のCCとピッチベンドへ適用します。音色変更自体は従来どおり常に1 tick前です。
Bank Selectを伴う音色変更では、CC0、CC32、音色をこの順に `ControllerShift` tickずつ離します。
先行時刻が負になるイベントは並び順を保ったままSMF上の時刻0へ置きます。

`System.GetKeyFlag` は値を返すため、`Array (flags)=System.GetKeyFlag` の形で使います。配列の順番は
`c,d,e,f,g,a,b` です。

## 関連する構文設定

| 設定 | 既定値 | 適用範囲 |
|---|---:|---|
| `ArgOrder(lqvto)` | `lqvto` | 現在のトラック。音符のカンマ引数の順番 |
| `AllowMultiLine(on/off)` | on | 曲全体。offなら改行を含む `'...'` 和音をエラーにする |
| `MetaTextEOL(n)` | 0 | 曲全体。0=CRLF、1=LF、2=CR |
| `UseKeyShift(on/off)` | on | 曲全体。Key/TimeKey/TimeKey2/TrackKeyの適用を切り替える |

これらはPascal版と同じ裸のコマンド名に加え、移植期に既に受理していた
`System.ArgOrder`、`System.AllowMultiLine`、`System.MetaTextEOL` も同じ動作の別名として扱います。
`ArgOrder` に指定できる文字は `l`（音長）、`q`（ゲート）、`v`（ベロシティ）、`t`（タイミング）、
`o`（オクターブ）です。部分集合や順序変更が可能です。

## 未実装 System 設定

現行 Rust は未知または未移植の `System.name` を、可能な範囲で引数ごと読み飛ばし、警告を返します。
これは既存曲を途中まで変換できるための移行動作であり、その設定が適用されたことを意味しません。
音響上重要な警告を無視して生成 MIDI を正式成果物にしてはいけません。

`System.LoadSMF` はPascal側にも処理本体がなく、ファイルI/Oにも依存するため未対応のままです。
最新の区分は [互換性表](10-compatibility.md) を参照してください。

## エラーと警告

致命的な問題は `MmlError { line, message }` でコンパイルを停止します。警告は
`Warning { line, message }` として成功結果に含まれます。行に結び付かない診断の line は 0 です。

エラーになる代表例:

- 未定義コマンド、変数、関数
- 閉じていない括弧、文字列、ブロック
- ノート番号またはチャンネルの範囲外
- 0 除算、整数オーバーフロー、配列範囲外
- Include ファイルが見つからない
- ネスト、反復、イベント数、時刻の上限超過

警告になる代表例:

- 自動読込の `stdmsg.h` がない
- CP932 に変換できない文字を `?` に置換した
- 未実装の `System.*` または先行指定を無視した

## 安全制限

| 対象 | 現行 Rust の上限 |
|---|---:|
| 1 コンパイルの MIDI イベント | 1,000,000 |
| 再帰的なブロック実行の深さ | 128 |
| 1 反復構文の実行回数 | 100,000 |
| 1 配列の要素数 | 1,000,000 |
| トラックの絶対時刻 | `0x0FFFFFFF` tick |
| SMF delta time | `0x0FFFFFFF` tick |
| タイムベース | 32767 |
| SMF トラック数 | 65535 |

これらは不正入力や指数的な展開でネイティブ/WASM プロセスが停止することを防ぐ仕様です。
上限超過は値の切り捨てではなくエラーにします。

## 決定性

同じソース、同じ Include 内容、同じ乱数シードからは同じイベント列を生成するのが原則です。
コンパイラコアは時計、環境変数、ファイルシステム、OS の乱数源へ直接アクセスしません。
