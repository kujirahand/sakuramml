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

`System.Include`、`System.Div`、`System.Rythm`、`System.Sub` は対応する通常コマンドへ委譲します。

## 未実装 System 設定

現行 Rust は未知または未移植の `System.name` を、可能な範囲で引数ごと読み飛ばし、警告を返します。
これは既存曲を途中まで変換できるための移行動作であり、その設定が適用されたことを意味しません。
音響上重要な警告を無視して生成 MIDI を正式成果物にしてはいけません。

代表例は `ArgOrder`、`UseKeyShift`、`MetaTextEOL`、`AllowMultiLine`、`TimeKey` などです。
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
| トラックの絶対時刻 | `0x0FFFFFFF` tick |
| SMF delta time | `0x0FFFFFFF` tick |
| タイムベース | 32767 |
| SMF トラック数 | 65535 |

これらは不正入力や指数的な展開でネイティブ/WASM プロセスが停止することを防ぐ仕様です。
上限超過は値の切り捨てではなくエラーにします。

## 決定性

同じソース、同じ Include 内容、同じ乱数シードからは同じイベント列を生成するのが原則です。
コンパイラコアは時計、環境変数、ファイルシステム、OS の乱数源へ直接アクセスしません。
