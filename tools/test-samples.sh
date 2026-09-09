#!/bin/sh

# Compare the generated MIDI bytes and normalized event dumps from the Pascal
# and Rust compilers.
# A byte is different when it differs at the same offset, or exists only in
# one output. The denominator is the larger of the two file sizes.
# Event difference uses ordinary `diff`: the larger of removed/added lines,
# divided by the larger normalized-dump line count.

set -u

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
pascal_compiler="$repo_dir/src/pascal/csakura"
rust_compiler="$repo_dir/src/rust/target/debug/csakura"

if [ ! -x "$pascal_compiler" ]; then
    printf 'Pascal版が見つかりません: %s\n' "$pascal_compiler" >&2
    exit 2
fi
if [ ! -x "$rust_compiler" ]; then
    printf 'Rust版が見つかりません: %s\n' "$rust_compiler" >&2
    exit 2
fi

result_dir=$(mktemp -d "${TMPDIR:-/tmp}/sakuramml-test-samples.XXXXXX") || exit 2
trap 'rm -rf "$result_dir"' EXIT HUP INT TERM

sample_count=0
comparable_count=0
exact_count=0
total_different=0
total_compared=0
total_event_different=0
total_event_compared=0

printf '%-18s %8s %11s %11s %11s\n' 'sample' 'Pascal' 'Rust' 'byte差' 'event差'
printf '%-18s %8s %11s %11s %11s\n' '------------------' '--------' '-----------' '-----------' '-----------'

for source_file in "$repo_dir"/sample/*.mml; do
    [ -e "$source_file" ] || continue
    sample_count=$((sample_count + 1))
    sample_name=$(basename "$source_file")
    stem=${sample_name%.mml}
    pascal_midi="$result_dir/$stem.pascal.mid"
    rust_midi="$result_dir/$stem.rust.mid"
    pascal_log="$result_dir/$stem.pascal.log"
    rust_log="$result_dir/$stem.rust.log"

    (cd "$repo_dir" && "$pascal_compiler" "$source_file" "$pascal_midi") >"$pascal_log" 2>&1
    pascal_exit=$?
    (cd "$repo_dir" && "$rust_compiler" "$source_file" "$rust_midi") >"$rust_log" 2>&1
    rust_exit=$?

    if [ "$pascal_exit" -eq 0 ]; then
        pascal_result=OK
    elif [ -f "$pascal_midi" ]; then
        pascal_result="partial($pascal_exit)"
    else
        pascal_result="FAIL($pascal_exit)"
    fi

    if [ "$rust_exit" -eq 0 ]; then
        rust_result=OK
    elif [ -f "$rust_midi" ]; then
        error_count=$(grep -c '^\[エラー\]' "$rust_log" 2>/dev/null || true)
        rust_result="partial:$error_count"
    else
        rust_result="FAIL($rust_exit)"
    fi

    if [ -f "$pascal_midi" ] && [ -f "$rust_midi" ]; then
        pascal_size=$(wc -c <"$pascal_midi" | tr -d ' ')
        rust_size=$(wc -c <"$rust_midi" | tr -d ' ')
        if [ "$pascal_size" -ge "$rust_size" ]; then
            compared_bytes=$pascal_size
            size_difference=$((pascal_size - rust_size))
        else
            compared_bytes=$rust_size
            size_difference=$((rust_size - pascal_size))
        fi
        offset_difference=$(cmp -l "$pascal_midi" "$rust_midi" 2>/dev/null | wc -l | tr -d ' ')
        different_bytes=$((offset_difference + size_difference))
        if [ "$compared_bytes" -eq 0 ]; then
            difference_rate=0.00
        else
            difference_rate=$(awk -v different="$different_bytes" -v compared="$compared_bytes" \
                'BEGIN { printf "%.2f", different * 100 / compared }')
        fi
        comparable_count=$((comparable_count + 1))
        total_different=$((total_different + different_bytes))
        total_compared=$((total_compared + compared_bytes))
        if [ "$different_bytes" -eq 0 ]; then
            exact_count=$((exact_count + 1))
        fi
        byte_summary="${difference_rate}%"

        pascal_dump="$result_dir/$stem.pascal.txt"
        rust_dump="$result_dir/$stem.rust.txt"
        "$rust_compiler" --dump-midi "$pascal_midi" "$pascal_dump" > /dev/null 2>&1
        pascal_dump_exit=$?
        "$rust_compiler" --dump-midi "$rust_midi" "$rust_dump" > /dev/null 2>&1
        rust_dump_exit=$?
        if [ "$pascal_dump_exit" -eq 0 ] && [ "$rust_dump_exit" -eq 0 ]; then
            pascal_lines=$(wc -l <"$pascal_dump" | tr -d ' ')
            rust_lines=$(wc -l <"$rust_dump" | tr -d ' ')
            if [ "$pascal_lines" -ge "$rust_lines" ]; then
                event_compared=$pascal_lines
            else
                event_compared=$rust_lines
            fi
            event_diff="$result_dir/$stem.diff"
            diff "$pascal_dump" "$rust_dump" >"$event_diff" 2>/dev/null || true
            removed_lines=$(grep -c '^< ' "$event_diff" 2>/dev/null || true)
            added_lines=$(grep -c '^> ' "$event_diff" 2>/dev/null || true)
            if [ "$removed_lines" -ge "$added_lines" ]; then
                event_different=$removed_lines
            else
                event_different=$added_lines
            fi
            if [ "$event_compared" -eq 0 ]; then
                event_rate=0.00
            else
                event_rate=$(awk -v different="$event_different" -v compared="$event_compared" \
                    'BEGIN { printf "%.2f", different * 100 / compared }')
            fi
            total_event_different=$((total_event_different + event_different))
            total_event_compared=$((total_event_compared + event_compared))
            event_summary="${event_rate}%"
        else
            event_summary='-'
        fi
    else
        byte_summary='-'
        event_summary='-'
    fi

    printf '%-18s %8s %11s %11s %11s\n' \
        "$sample_name" "$pascal_result" "$rust_result" "$byte_summary" "$event_summary"
done

if [ "$total_compared" -eq 0 ]; then
    total_rate='-'
else
    total_rate=$(awk -v different="$total_different" -v compared="$total_compared" \
        'BEGIN { printf "%.2f%%", different * 100 / compared }')
fi
if [ "$total_event_compared" -eq 0 ]; then
    total_event_rate='-'
else
    total_event_rate=$(awk -v different="$total_event_different" -v compared="$total_event_compared" \
        'BEGIN { printf "%.2f%%", different * 100 / compared }')
fi

printf '\n合計: %s件 / 比較可能: %s件 / バイト完全一致: %s件\n' \
    "$sample_count" "$comparable_count" "$exact_count"
printf '加重差異率: byte=%s / event=%s\n' "$total_rate" "$total_event_rate"

if [ "$comparable_count" -ne "$sample_count" ]; then
    exit 2
fi
if [ "$exact_count" -ne "$sample_count" ]; then
    exit 1
fi
