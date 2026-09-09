//! Resource limits and SMF range checks.
//!
//! A few lines of MML can ask for billions of notes, and the SMF format cannot
//! express arbitrarily large times. Both must end in a diagnostic: natively
//! they would grind or write a malformed file, and in a browser tab an
//! out-of-memory crash takes the whole page with it.
//!
//! Every case here asserts the compile *returns* an error — never a panic,
//! which under WASM would poison the module for the rest of the session.

use sakuramml_core::compile;

#[track_caller]
fn assert_error_contains(script: &str, needle: &str) {
    let error = compile(script)
        .err()
        .unwrap_or_else(|| panic!("expected {script:?} to fail"));
    assert!(
        error.message.contains(needle),
        "expected an error about {needle:?}, got: {}",
        error.message
    );
}

// --- the event budget ---

/// Nested loops multiply: this asks for ~10^8 notes from one line.
#[test]
fn nested_loops_asking_for_too_many_events_stop_with_an_error() {
    assert_error_contains("[10000 [10000 c]]", "イベント数");
}

/// Either guard may catch this first — the iteration cap or the event
/// budget. What matters is that it stops.
#[test]
fn a_runaway_for_loop_stops() {
    let error = compile("Int i; For(i=0;i<10000000;i=i+1){c}").unwrap_err();
    assert!(
        error.message.contains("イベント数") || error.message.contains("繰り返し"),
        "unexpected message: {}",
        error.message
    );
}

/// The budget is generous enough for real songs: a few thousand notes is
/// nothing like the limit.
#[test]
fn an_ordinary_song_is_nowhere_near_the_budget() {
    let out = compile("[500 cdefgab]").expect("3500 notes should compile");
    assert!(out.smf.len() > 1000);
}

// --- time and the SMF's own limits ---

#[test]
fn a_time_pointer_beyond_the_format_is_an_error() {
    assert_error_contains("Time(999999999:1:0) c", "時間");
    assert_error_contains("Time(99999999999999:1:0) c", "時間");
    // Far enough out that the position arithmetic itself overflows.
    assert_error_contains("Time(9223372036854775807:1:0) c", "あふれ");
}

#[test]
fn an_absurd_note_length_is_an_error() {
    assert_error_contains("c%999999999999 d", "時間");
}

/// The division is a 15-bit field in the header, so 32767 is the ceiling.
#[test]
fn timebase_must_fit_the_header_field() {
    assert!(compile("TimeBase=32767 c").is_ok());
    assert_error_contains("TimeBase=32768 c", "TimeBase");
    assert_error_contains("TimeBase=0 c", "TimeBase");
    assert_error_contains("TimeBase=-1 c", "TimeBase");
    assert_error_contains("System.TimeBase=100000 c", "TimeBase");
}

/// Right at the edge the compile still succeeds and the header carries the
/// value unchanged.
#[test]
fn the_largest_timebase_round_trips_into_the_header() {
    let out = compile("TimeBase=32767 c").unwrap();
    assert_eq!(&out.smf[12..14], &[0x7f, 0xff]);
}

// --- none of this may panic ---

#[test]
fn extreme_values_produce_errors_rather_than_panics() {
    // Each of these once had the potential to overflow or hang.
    let cases = [
        "Time(9223372036854775807:1:0)",
        "c%9223372036854775807",
        "TimeBase=9223372036854775807",
        "Int i; For(i=0;i<9223372036854775807;i=i+1){c}",
        "[999999 [999999 [999999 c]]]",
        "n(9223372036854775807)",
        "Tempo=(0-9223372036854775807) c",
    ];
    for case in cases {
        // Passing is fine, failing is fine; panicking is not.
        let _ = compile(case);
    }
}

/// A very long but legitimate piece still compiles, so the guards do not get
/// in the way of real music.
#[test]
fn a_long_piece_still_compiles() {
    let mml = "l16 ".to_string() + &"cdefgab".repeat(200);
    let out = compile(&mml).expect("1400 notes should compile");
    assert_eq!(&out.smf[..4], b"MThd");
}
