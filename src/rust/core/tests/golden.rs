//! Byte-for-byte comparison against the Pascal implementation.
//!
//! Each expected value was produced by the Pascal build and captured here as
//! hex, so these tests keep passing without a Pascal toolchain installed:
//!
//! ```sh
//! cd src/pascal && ./csakura -e "cde" && xxd -p a.mid | tr -d '\n'
//! ```

use sakuramml_core::compile;

fn hex(s: &str) -> Vec<u8> {
    (0..s.len())
        .step_by(2)
        .map(|i| u8::from_str_radix(&s[i..i + 2], 16).unwrap())
        .collect()
}

/// Assert that compiling `mml` produces exactly the bytes the Pascal build did.
fn assert_golden(mml: &str, expected_hex: &str) {
    let out = compile(mml).unwrap_or_else(|e| panic!("failed to compile {mml:?}: {e}"));
    let expected = hex(expected_hex);
    assert_eq!(
        out.smf,
        expected,
        "\nMML: {mml:?}\n  got: {}\n  want: {}",
        hex_string(&out.smf),
        expected_hex
    );
}

fn hex_string(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

#[test]
fn single_note() {
    assert_golden(
        "c",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
}

#[test]
fn three_notes() {
    assert_golden(
        "cde",
        "4d546864000000060001000100604d54726b0000001c00903c644b803c6415903e644b803e6415904064\
         4b80406415ff2f00",
    );
}

#[test]
fn gate_time() {
    assert_golden(
        "q100 c",
        "4d546864000000060001000100604d54726b0000000c00903c645f803c6401ff2f00",
    );
    assert_golden(
        "q50 c",
        "4d546864000000060001000100604d54726b0000000c00903c642f803c6431ff2f00",
    );
    assert_golden(
        "q33 c",
        "4d546864000000060001000100604d54726b0000000c00903c641e803c6442ff2f00",
    );
    // q1 would floor to a zero-length note; the Pascal build clamps it to 1.
    assert_golden(
        "q1 c",
        "4d546864000000060001000100604d54726b0000000c00903c6401803c645fff2f00",
    );
}

#[test]
fn velocity() {
    assert_golden(
        "v64 c",
        "4d546864000000060001000100604d54726b0000000c00903c404b803c4015ff2f00",
    );
}

#[test]
fn octave_and_accidentals() {
    assert_golden(
        "o4 c",
        "4d546864000000060001000100604d54726b0000000c009030644b80306415ff2f00",
    );
    assert_golden(
        "c+",
        "4d546864000000060001000100604d54726b0000000c00903d644b803d6415ff2f00",
    );
    assert_golden(
        "c-",
        "4d546864000000060001000100604d54726b0000000c00903b644b803b6415ff2f00",
    );
}

#[test]
fn note_number() {
    assert_golden(
        "n60",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
}

#[test]
fn lengths() {
    assert_golden(
        "l8 c",
        "4d546864000000060001000100604d54726b0000000c00903c6425803c640bff2f00",
    );
    assert_golden(
        "c8",
        "4d546864000000060001000100604d54726b0000000c00903c6425803c640bff2f00",
    );
    assert_golden(
        "c.",
        "4d546864000000060001000100604d54726b0000000c00903c6472803c641eff2f00",
    );
    assert_golden(
        "c(1)",
        "4d546864000000060001000100604d54726b0000000d00903c648232803c644eff2f00",
    );
}

#[test]
fn rest_advances_time() {
    assert_golden(
        "r c",
        "4d546864000000060001000100604d54726b0000000c60903c644b803c6415ff2f00",
    );
    // End-of-track sits at the end of the trailing rest, not at the note-off.
    assert_golden(
        "c r",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6475ff2f00",
    );
}

#[test]
fn tie_extends_previous_note() {
    assert_golden(
        "c^c",
        "4d546864000000060001000100604d54726b0000001500903c648118803c6428903c644b803c6415ff2f00",
    );
}

#[test]
fn tempo() {
    assert_golden(
        "Tempo=140 c",
        "4d546864000000060001000100604d54726b0000001300ff5103068a1b00903c644b803c6415ff2f00",
    );
}

#[test]
fn timebase_changes_division_and_lengths() {
    assert_golden(
        "TimeBase=48 c",
        "4d546864000000060001000100304d54726b0000000c00903c6425803c640bff2f00",
    );
}

#[test]
fn track_selects_channel() {
    assert_golden(
        "TR=2 c",
        "4d546864000000060001000100604d54726b0000000c00913c644b813c6415ff2f00",
    );
}

#[test]
fn two_tracks_produce_two_chunks() {
    assert_golden(
        "c TR=2 e",
        "4d546864000000060001000200604d54726b0000000c00903c644b803c6415ff2f004d54726b0000000c\
         009140644b81406415ff2f00",
    );
}

#[test]
fn track_name_is_written_as_cp932() {
    assert_golden(
        r#"TrackName={"テスト"} c"#,
        "4d546864000000060001000100604d54726b0000001600ff030683658358836700903c644b803c6415ff2f00",
    );
}
