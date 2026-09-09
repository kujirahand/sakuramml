# SakuraMML Rust移植計画

## 目的

`csakura.dpr`（テキストMML → 標準MIDIファイル(SMF)変換ツール）を、Delphi/FPC(Pascal)から
Rustで全面的に書き直す。

前提となる要件:
- **WASMでの動作がメインターゲット**（ブラウザ上でMML→MIDI変換を行う用途）。
  ネイティブCLIは副次的な位置づけだが、開発・テスト用に維持する。
- オリジナルはShift-JIS(SJIS)前提のコードだが、Rust版は**内部表現をUTF-8**とし、
  入力はUTF-8/CP932自動判定、SMFメタテキスト出力はCP932固定とする。

対象範囲は csakura.dpr のビルドパスに含まれるユニットのみ（GUIやWindows専用ユニットは対象外）：

```
csakura.dpr, mml_unit.pas, mml_base.pas, mml_token.pas, mml_token2.pas,
mml_calc.pas, mml_variable.pas, mml_var.pas, mml_types.pas, mml_const.pas,
mml_error.pas, mml_system.pas, smf_types.pas, smf_const.pas,
csakurautils.pas, strunit.pas, wildcard.pas, hashUnit.pas
```

※ 本ドキュメント中のPascalファイルのパス・行番号は、後述のディレクトリ再編**前**の
リポジトリ直下を基準に記載している（再編後は `src/pascal/` 配下に読み替えること）。

## ディレクトリ再編

Pascal実装とRust実装を明確に分離する。

```
sakuramml/
  src/
    pascal/     # 既存のDelphi/FPC実装一式（.dpr, .pas, プロジェクトファイル）を移動
    rust/       # 新規に作るRust実装（Cargoワークスペース）
  doc/          # 仕様書・リファレンス（両実装で共有するのでルートに残す）
  sample/       # サンプルMML（両実装のテストに使うのでルートに残す）
  Include/      # #Include用マクロファイル群（実行時リソースなのでルートに残す）
  plan.md
  ReadMe.md
```

再編時の注意点:
- `.pas`同士は同一ディレクトリ内の相対参照（`mml_base in 'mml_base.pas'`）なので、
  **まとめて移動すればビルドは壊れない**。既存の `wasm_make.sh`（FPCのWASIビルド用）も
  一緒に移動する。
- 現在 `csakura.dpr` と `mml_base.pas` に未コミットの変更があるため、**移動前にコミットまたは
  stashしておく**こと（`git mv` で履歴を保ちつつ移動する）。
- `.dcu` / `.o` / `.ppu` / `.exe` などのビルド生成物と `.DS_Store` は移動せず、
  `.gitignore` に追加して除外する（現状これらが未追跡ファイルとして大量に散らばっている）。

## WASM対応方針（設計の基本方針）

WASMが主用途であることが、アーキテクチャ上もっとも強い制約になる。以下を設計原則とする。

### 1. コアはI/Oを持たない純粋なライブラリにする
- **コアcrate（`sakuramml-core`）はファイルシステム・環境変数・標準出力に一切触らない**。
  入力は`&str`（MMLソース）、出力は`Vec<u8>`（SMFバイナリ）＋警告リストという形にする。
  これによりブラウザWASM・WASI・ネイティブCLIの全てで同じコアが使える。
- 現行Pascal版が `Writeln` でエラーを出したり `SaveToFile` で直接ファイルを書くのに対し、
  Rust版は**エラー・警告を構造体として返す**（`Result<CompileOutput, MmlError>`、
  `CompileOutput { smf: Vec<u8>, warnings: Vec<Warning> }`）。printは呼び出し側の責務。

### 2. `#Include` の解決はコールバック（trait）で抽象化
- WASMにはファイルシステムがないため、現行の「実行ファイルからの相対パスで`Include/*.h`を探す」
  という実装をそのまま移植できない。
- コアは `trait IncludeResolver { fn resolve(&self, name: &str) -> Option<Vec<u8>>; }` を受け取る形にし、
  実装を差し替え可能にする:
  - **ネイティブCLI**: ファイルシステムから読む。
  - **ブラウザWASM**: 標準の`Include/*.h`を `include_dir!` / `include_str!` でバイナリに
    埋め込んだリゾルバを既定とする（ネットワークアクセス不要で自己完結する）。
    加えて、JS側から追加のインクルード内容を渡せるAPIも用意する。

### 3. WASMのビルドターゲット
- **主**: `wasm32-unknown-unknown` + `wasm-bindgen`（ブラウザ/JSからの利用）。
  JS API案:
  ```js
  const result = compileMml(mmlText);   // -> { midi: Uint8Array, warnings: string[] }
  ```
- **従**: `wasm32-wasip1`（WASI）。既存の`wasm_make.sh`がFPCでWASIを使っていた経緯に合わせ、
  CLIバイナリをそのままWASIで動かせるようにしておく（wasmtime等で検証可能）。
- コアがI/Oを持たない設計なので、両方を薄いラッパーで同時に満たせる。

### 4. WASM特有の注意点
- **panicさせない**: 不正なMMLでpanicするとWASMインスタンスが停止する。パーサ・評価器では
  `unwrap()`/`expect()`/添字直接アクセスを避け、全て`Result`で扱う。開発時のみ
  `console_error_panic_hook`を有効にする。
- **再帰の深さ**: 現行実装は`Compile`が再帰し`NestCountCompile`で128段に制限している。
  WASMはネイティブよりスタックが小さいため、**再帰段数の上限は明示的に持ち、
  超えたらエラーを返す**（可能な箇所はループ化する）。
- **バイナリサイズ**: 依存を最小に保つ。`encoding_rs`は全エンコーディングのテーブルを含むため
  サイズが気になる場合は、**CP932の変換表のみを自前生成した軽量モジュールに差し替える**
  余地を残す（Phase 1では`encoding_rs`で進め、サイズ計測後に判断）。
  リリースビルドは `opt-level = "z"`, `lto = true`, `panic = "abort"`（wasm-bindgen使用時は
  panic=abortの可否に注意）＋ `wasm-opt` を検討。
- **時刻・乱数**: 現行にはランダマイズ機能（`Random`、曖昧さ等）がある。WASMでは
  `std::time`や`getrandom`が使えない/追加設定が必要なため、**乱数はシード指定可能な
  自前の小さなPRNG（xorshift等）を使い、外部crateに依存しない**。これにより
  再現性のあるテストも書きやすくなる。

## 全体パイプライン（現行実装の把握）

1. `mml_unit.pas TMml2Smf.Execute` がエントリ。
2. `PreCompile`（mml_base.pas:678）— 「ストトン」記法（日本語MML: 音名をドレミで書く等）をMMLへ前処理変換。
3. `Compile` → `Analize`（mml_base.pas:695）— ソースを1行ずつ読み、コマンド名をハッシュテーブルで
   引いて対応する関数を呼ぶディスパッチループ（`Commands: THash`、約150コマンドを登録）。
4. `TSmfSong.SaveToFile`（smf_types.pas:933）— MThdヘッダと各トラックのMTrkチャンク
   （可変長デルタタイム、ビッグエンディアン数値）を書き出す。

Rust版もこの4段構成を踏襲する（ただし最終段はファイル書き出しではなく`Vec<u8>`を返す）:
`preprocess(sutoton) → tokenize → dispatch(150 commands, ミニ言語: 変数/式/If/For/While/Function) → SMF bytes`

## 文字コード方針（SJIS → UTF-8、CP932互換入出力）

**方針決定（確定）**:
- **入力**: `.mml`ソースファイル・`#Include`ファイルは **UTF-8 / CP932(Windows-31J) を自動判定**して
  読み込み、読み込んだ時点でRust内部表現（UTF-8の`String`）へ正規化する。判定ロジックは
  「バイト列としてstrict UTF-8デコードを試み、成功すればUTF-8、失敗すればCP932とみなして
  デコードする」というシンプルなヒューリスティックで十分（ASCIIのみのファイルはどちらでも
  同じ結果になるため問題なし）。UTF-8 BOMがあれば除去する。
  なおJSから文字列を渡す場合は既にUTF-8なので、判定はバイト列入力時のみ行う。
- **出力**: SMFメタイベント（TrackName/Lyric/Copyright/MetaText等）は**常にCP932(Windows-31J)
  バイト列で書き込む**。既存の日本語MIDIプレイヤー/カラオケ機との互換性を最優先するため、
  UTF-8出力オプションは設けない（従来のPascal版と同じ見え方を保証する）。
- 内部のトークナイザ・コマンドディスパッチ・式評価などのロジックは、入力段階でUTF-8に
  正規化済みのRust `String`/`char`を対象に処理するため、**SJIS/CP932のバイト境界を意識した
  処理は不要**。CP932を扱うのは「入力バイト列のデコード」と
  「SMFメタテキスト書き込み時のエンコード」の2箇所のみに閉じ込める。
- **CP932非対応文字（絵文字等）の扱い（確定）**: エラーで停止せず、`?`等の代替文字に
  **置換した上で警告を返す**（どの行のどの文字が置換されたかを示す）。コンパイル自体は成功させる。

### 1. ソース読み込み・トークナイザ
- 現行: `strunit.pas` の `LeadBytes := [#$80..#$FF]`（Delphi MBCS機構、SJISのリードバイト判定）、
  `mml_token.pas` の全角/半角変換・`GetMultiByteWord` が、SJISのバイト境界を前提に手書きで
  多バイト文字を読み飛ばしている。
- Rust版: **この手のバイト境界処理は一切不要**。`chars()` / `char_indices()` で素直に1文字ずつ
  処理すればよい。SJISリードバイト表・`jconvert.pas`（SJIS⇔JIS⇔EUC変換）は**移植せず廃止**する。
- 全角/半角正規化（`ConvToHalfSign`）は、SJISバイト表ではなく **Unicode文字の変換テーブル**
  （全角英数字 U+FF01–U+FF5E ↔ ASCII、全角スペース U+3000 → 半角スペース、'＃'→'#' 等）で
  再実装する。ロジックは単純化される。

### 2. 「ストトン」日本語コマンド表（`mml_token.pas` `addSutotonList`）
- ドレミ/曲名/音符/テンポ...等、日本語コマンド名のエイリアス表（約90エントリ）は文字列比較に
  過ぎないので、**UTF-8リテラルとしてそのままRustに移植可能**。

### 3. `#Include` / 「読む」コマンドで読み込む外部ファイル（`Include/*.h`）
- 現行はSJIS前提でファイルを読み `ConvToHalfSign` にかける。
- Rust版は上述の`IncludeResolver`経由で取得したバイト列を**UTF-8/CP932自動判定**でデコードする。
  既存の`Include/*.h`（SJIS/CP932のまま）も、新規にUTF-8で書かれたファイルも変換なしで扱える。

### 4. SMFメタイベントのテキスト出力（確定: CP932固定）
- `TrackName` / `Copyright` / `Lyric` / `MetaText` / `MetaCuePoint` / `MetaMarker` /
  `MetaInstrumentName` は `WriteMetaText`（mml_base.pas:218）経由でメタイベントに生バイト列として
  書き込まれる。Rust版は内部UTF-8を書き込み直前に**CP932へエンコード**する。

## Rustプロジェクト構成

WASM/CLIの両対応のため、**コア＋ラッパー**のワークスペース構成にする。

```
src/rust/
  Cargo.toml              # workspace
  core/                   # sakuramml-core: I/Oを持たない純粋なコンパイラ
    Cargo.toml            #   依存: encoding_rs のみ（サイズ次第で自前CP932表に差し替え可）
    src/
      lib.rs              # compile(src: &str, resolver: &dyn IncludeResolver) -> Result<CompileOutput, MmlError>
      encoding.rs         # UTF-8/CP932自動判定デコード、CP932エンコード（警告付き置換）
      include.rs          # IncludeResolver trait と埋め込み/空リゾルバ
      rng.rs              # 自前PRNG（Random/曖昧さ用、シード指定可）
      lexer/              # トークナイザ（mml_token.pas, mml_token2.pas相当）
        mod.rs
        sutoton.rs        # ストトン変換テーブル・前処理（UTF-8版）
        zenkaku.rs        # 全角/半角正規化（Unicode版）
      compiler/           # コマンドディスパッチ・ミニ言語（mml_base.pas他相当）
        mod.rs
        commands/         # コマンドを機能グループごとにファイル分割
          note.rs         # 音符/休符/オクターブ/音長/ゲート/音量
          track.rs        # Track/Channel/トラック同期
          loop_repeat.rs  # [ ] ループ、リピート
          variable.rs     # Int/Str/Array、代入・式評価
          control.rs      # If/For/While/Function
          cc_sysex.rs     # ControlChange/SysEx/RPN/NRPN
          meta.rs         # メタイベント(TrackName/Lyric/Copyright/MetaText等)
          tempo_time.rs   # Tempo/TimeSignature/Time
      expr/               # 式パーサ・評価器（mml_calc.pas相当）
        mod.rs
      smf/                # SMFバイナリ生成（smf_types.pas, smf_const.pas相当）
        mod.rs
        event.rs
        writer.rs
      error.rs            # エラー・警告型（mml_error.pas相当）
    tests/                # コアのユニット/ゴールデンテスト
  cli/                    # csakura: ネイティブCLI + WASI（csakura.dpr相当の薄いラッパー）
    src/main.rs           #   ファイル読み書き・引数解析・メッセージ表示のみ
  wasm/                   # wasm-bindgenラッパー（ブラウザ向け、主ターゲット）
    src/lib.rs            #   compileMml(text) -> { midi: Uint8Array, warnings: string[] }
    pkg/                  #   wasm-pack出力（gitignore）
  README.md               # Rust実装の概要とビルド手順
  build-wasm.sh           # wasm-pack / cargo build --target wasm32-unknown-unknown
```

## フェーズ分割

### Phase 0: ディレクトリ再編・仕様抽出（着手前の下ごしらえ）
1. 未コミットの変更（`csakura.dpr`, `mml_base.pas`）をコミットする。
2. `.gitignore` にビルド生成物（`*.dcu`, `*.o`, `*.ppu`, `*.exe`, `.DS_Store`, `target/`, `pkg/`等）を追加。
3. `git mv` で既存Pascal実装一式を `src/pascal/` へ移動し、Pascal版がビルドできることを確認。
4. `doc/command.txt` / `doc/command2.txt` / `doc/reference/*.htm` からコマンド一覧・構文・
   デフォルト値を抽出し、コマンドごとの仕様表としてまとめる
   （現在は `spec/12-legacy-command-table.md`）
   （150コマンドを一気に読むと破綻するので、後続フェーズのタスクリストを兼ねる）。
5. `sample/*.mml` をゴールデンテスト用コーパスとして整理。

### Phase 1: 垂直スライス（最小動作版・WASMで動くところまで）
- ワークスペース作成（`core` / `cli` / `wasm` の3crate）。
- エンコーディング層（UTF-8/CP932自動判定デコード、CP932エンコード）。
- SMFバイナリ生成層（ヘッダ/トラックチャンク/NoteOn・NoteOff/EndOfTrackのみ）。
- 最小トークナイザ（UTF-8、全角半角正規化）。
- 最小コマンド: 音符(`a`-`g`,`n`,`r`)、`o`/`<`/`>`（オクターブ）、`l`（音長）、`,`（トラック分割）、
  `Tempo`。
- CLI: `csakura mmlfile [midifile]` の基本形。
- **WASMビルドを最初から通す**: `wasm-pack build`が成功し、ブラウザ（またはNode）から
  `compileMml("cdefg")` を呼んでUint8ArrayのMIDIが返ることを確認する。
  ここでバイナリサイズも計測しておく（`encoding_rs`を残すか判断する材料にする）。
- ゴール: `sample/4.mml` 相当の単純な曲から、妥当なSMFバイナリを生成できる（CLI・WASM両方）。

### Phase 2以降: コマンド群を機能ブロックごとに移植
Phase 0で作った仕様表を使い、以下の順で拡張する（優先度は使用頻度・依存関係に基づく）：
1. 音量/ゲート/ベロシティ系（`v`, `q`, `y`, `@`, `p`等）
2. ループ・リピート `[ ]`, `:`
3. 変数・式評価（`mml_calc.pas`相当のミニ言語） — `Int`, `Str`, `Array`, 四則演算・比較
4. 制御構文 `If`/`For`/`While`/`Function`（再帰深さの上限を明示）
5. CC/SysEx/RPN/NRPN
6. メタイベント（TrackName/Lyric/Copyright/MetaText、CP932エンコードを適用）
7. ストトン（日本語）記法の前処理層
8. `#Include`（外部マクロファイル）— `IncludeResolver`経由。WASM向けに`Include/*.h`の埋め込みも実装
9. 乱数系（`Random`、曖昧さ）— 自前PRNG

各ブロックの完了条件は「該当コマンドを使うsample/*.mmlをコンパイルし、Pascal版の出力と
バイト単位で一致する」こととする。

### Phase 3: 仕上げ
- WASMバイナリサイズの最適化（`opt-level="z"` / `lto` / `wasm-opt`、必要なら自前CP932表へ差し替え）。
- ブラウザ用のデモページ（テキストエリアにMMLを書いて再生/ダウンロードできる簡単なもの）。
- エラーメッセージの日本語対応確認、CLIオプション（`-e`, `-pause`）の互換確認。
- ドキュメント更新（ReadMe、`doc/`配下にRust版・WASM版の使い方を追記）。

## 進捗（2026-09-09時点）

### 完了
- **Phase 0**: ディレクトリ再編（`src/pascal/`）、`.gitignore`整備、全コマンド表の生成（doc/から約500行抽出。現在は`spec/12-legacy-command-table.md`）。
- **Phase 1**: ワークスペース（core/cli/wasm）、SMF書き出し、トークナイザ、基本コマンド。
- **Phase 2**: 音色・CC・ピッチベンド・RPN/NRPN・リセット、ループ`[ ]`、変数と式評価、
  `If`/`For`/`While`/`Exit`/`Print`、`System.*`オプション、KeyFlag、拍子、Time、
  ストトン記法、`Include`（`IncludeResolver`経由）。
- **Phase 3**:
  - **サイズ最適化**: `encoding_rs`（WASMの318KB中190KBを占有）を自前のCP932変換表
    （`tools/gen_cp932.py`で生成、9,604マッピング）へ置換。**274KB → 168KB（39%減）、
    gzip 177KB → 113KB**。コアcrateの外部依存はゼロになった。
  - **デモページ**: `src/rust/wasm/demo/index.html`。ブラウザで実動作を確認済み
    （コンパイル・MIDIダウンロード・Print出力・CP932警告・エラー表示）。
  - **CLI互換**: `-e`、`-pause`、`--help`/`--version`、拡張子自動変換、終了コード。
  - **ドキュメント**: ルート`ReadMe.md`、`src/rust/README.md`を更新。

### 残作業（Rust版が実用に達するために必要）

`sample/`の21ファイル中**10ファイル**がコンパイルできる（`4` `40` `47` `random`
`scale` `EasyTest` `MidiDelayTest` `rythm-1` `rythm-2` `rythm-4`）。
以下は残り11ファイルをブロックしている項目を、実際のエラーから逆算したもの。

**完了済み**
- `Function`、`SysEx`と`$`16進、リズムマクロ、`Sub`、ユーザー定義ストトン（`~`）
- `Div`、`Play`、`Key`、`#`文字列マクロ、和音`'...'`、`DirectSMF`
- **先行指定の全ファミリ**（`core/src/compiler/advance.rs`）:
  `.onNote/.N`・`.onTime/.T`・`.onCycle/.C`・`.onNoteWave/.W`・`.onNoteWaveEx/.WE`・
  `.onNoteWaveR/.WR`・`.Sine`・`.onNoteSine`・`.Delay`・`.Repeat`・`.Random`・
  `.Range`・`.Frequency`・`.Max`
- `q%`（ステップ指定）、`I++`/`I--`、`For`ヘッダ内の宣言
- `NoteNo`/`MML`（引数をMMLテキストとして受け取る）、`!n`記法
- 式で書く音長（`c*3`、`r*%(Delay)`）、式のループ回数（`[(I) ...]`）、
  複数行にわたる引数リスト、`y0((v))`、`y256.Frequency(1)`
- 定義がコマンド名を上書きする規則（`Str S` が `Sub` の別名 `S` に優先）
- 資源制限とSMF範囲検証

**未完了**
1. `Cresc`/`Decresc`（230.mml）。実測済み: `Cresc=4` は EP(CC11) を
   現在値から127へ指定長で推移させる。`.onTime`の仕組みで実装できる。
2. `PlayFrom`/`PlayTo`（sakura2.mml）— 演奏開始位置の指定。
3. 音長の`-`記法（seija.mml、230.mml）。`r-2.` のような負値付き音長で、
   Pascal版の挙動が特異（時刻が戻る）。要調査。
4. `Stretch`、`Solo`/`Mute`/`TrackMute`、`DeleteCC`/`CCMute`
5. 組み込み関数の残り: `MID`/`POS`/`Replace`/`ArraySort*`/`StrToNum`等
6. 配列の動的な拡張（RndMake.mml が範囲外書き込みで落ちる）
7. `#`マクロ本体内で失敗するケース（23.mml、test_01.mml、sutoton-9.mml）—
   個別調査が必要。

**方針**
- 未実装のコマンド・修飾子は、**エラーで止めず警告してスキップ**する方針を継続する
  （曲全体がコンパイルできなくなるより、鳴らない部分を明示する方がよい）。
  ただし音が変わる実装を推測で入れるのは避ける。

テスト戦略は変更なし: 新コマンドは必ずPascal版の出力を実測し、
`core/tests/golden.rs`にバイト列を固定してから実装する。

## テスト戦略
- ユニットテスト: トークナイザ、式評価器、SMFイベントのバイト列化を個別に検証。
- ゴールデンテスト: 同じ`.mml`を既存のPascal版（ビルド済み`csakura`）とRust版でコンパイルし、
  生成MIDIバイナリを比較する。メタテキストは両者ともCP932なので、差分＝ロジック不一致と扱える。
- エンコーディング判定のテスト: UTF-8/CP932両方の`.mml`で自動判定が働くこと（BOM有無を含む）。
- CP932非対応文字を含むMMLで、警告付き置換が働きコンパイルが成功すること。
- **WASMテスト**: `wasm-bindgen-test`（Node/ヘッドレスブラウザ）でコアと同じゴールデンケースを
  実行し、ネイティブとWASMで**同一バイト列**が得られることを確認する。
- 異常系: 不正なMMLでpanicせず必ず`Result`のエラーとして返ること（WASM停止を防ぐため重点的に）。
- リグレッション: `sample/*.mml` 全件と `doc/reference` に載っている構文例をテストケース化。

## 確定事項（まとめ）
- **主ターゲット**: WASM（`wasm32-unknown-unknown` + wasm-bindgen）。WASI・ネイティブCLIも維持。
- **アーキテクチャ**: I/Oを持たないコアcrate ＋ CLI/WASMの薄いラッパー。
  コアはファイル・標準出力に触れず、SMFバイナリと警告リストを値として返す。
- **ディレクトリ**: 既存Pascal実装 → `src/pascal/`、新規Rust実装 → `src/rust/`。
  `doc/` `sample/` `Include/` はルートに残して共有。
- **入力**: UTF-8/CP932自動判定。**内部処理**: 常にUTF-8。
- **SMF出力のメタテキスト**: 常にCP932（Windows-31J）固定。
- **CP932非対応文字**: 警告を出して代替文字に置換（エラー停止しない）。
- **依存crate**: コアは`encoding_rs`のみ（サイズ次第で自前CP932表に差し替え）、
  WASMラッパーは`wasm-bindgen`。CLI引数解析は`std::env::args`（`clap`等は使わない）。
  乱数は外部crateを使わず自前PRNG。
