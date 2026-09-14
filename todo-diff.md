# sample MML の Pascal/Rust 差異 TODO

調査日: 2026-09-15
対象: `sample/*.mml`（`random.mml` は比較対象外）
基準: `src/pascal/csakura` が生成する MIDI と正規化イベント列

## 調査方法

`just test-samples` で両コンパイラをビルドし、各サンプルについて生成可否、MIDI バイト列、
Rust CLI の `--dump-midi` で正規化したイベント列を比較した。

`169.mml` は曲中で `v.Random(3)` を多数使うため、velocity の値そのものは修正対象にしない。
ただし、同ファイルで見つかった構文エラー、音長、ゲート、時刻の差は乱数と無関係なので対象に含める。

## 結果

`23.mml`、`230.mml`、`4.mml`、`40.mml`、`47.mml`、`66.mml`、`hy_joe.mml`、
`sakura2.mml`、`seija.mml`、`sutoton-9.mml`、`test_01.mml` は、MIDIバイト列と
正規化イベント列が完全一致した。

`169.mml` はPascal版とRust版で乱数系列が異なるため、MIDIバイト列とvelocity値は実行ごとに異なる。
ノートイベントのvelocity列を正規化して比較すると、音高、音長、ゲート、時刻、イベント数、イベント順は
すべて一致した。

## 残課題

対象としていた非乱数サンプルと、`169.mml`の乱数以外の差異はすべて解消した。
`random.mml`と乱数系列そのものの一致は比較対象外とする。
