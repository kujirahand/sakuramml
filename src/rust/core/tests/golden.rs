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
fn note_arguments_follow_lqvto_order() {
    assert_same_bytes("c4,50,40", "l4 q50 v40 c");
    assert_same_bytes("c4,,,48,6", "t48 o6 c");
    // Per-note values affect only this note; the following note uses track state.
    assert_same_bytes("c4,50,40,48,6 c", "t48 o6 q50 v40 c t0 o5 q80 v100 c");
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

// --- Phase 2: voices, control changes, pitch bend, loops ---

#[test]
fn voice_is_one_based() {
    // @1 selects MIDI program 0.
    assert_golden(
        "@1 c",
        "4d546864000000060001000100604d54726b0000000f00c00000903c644b803c6415ff2f00",
    );
}

#[test]
fn voice_with_bank_select() {
    // @n,msb,lsb writes CC0 and CC32 before the program change.
    assert_golden(
        "@1,2,3 c",
        "4d546864000000060001000100604d54726b0000001700b0000200b0200300c00000903c644b803c6415ff2f00",
    );
}

#[test]
fn control_change_by_number() {
    assert_golden(
        "y1,64 c",
        "4d546864000000060001000100604d54726b0000001000b0014000903c644b803c6415ff2f00",
    );
}

#[test]
fn named_control_changes() {
    let cases = [
        ("M(10) c", "b0010a"),
        ("V(10) c", "b0070a"),
        ("P(10) c", "b00a0a"),
        ("EP(10) c", "b00b0a"),
        ("REV(10) c", "b05b0a"),
    ];
    for (mml, cc) in cases {
        assert_golden(
            mml,
            &format!("4d546864000000060001000100604d54726b0000001000{cc}00903c644b803c6415ff2f00"),
        );
    }
}

#[test]
fn simple_pitch_bend_writes_msb_only() {
    assert_golden(
        "p64 c",
        "4d546864000000060001000100604d54726b0000001000e0004000903c644b803c6415ff2f00",
    );
    assert_golden(
        "p0 c",
        "4d546864000000060001000100604d54726b0000001000e0000000903c644b803c6415ff2f00",
    );
    assert_golden(
        "p127 c",
        "4d546864000000060001000100604d54726b0000001000e0007f00903c644b803c6415ff2f00",
    );
}

#[test]
fn full_range_pitch_bend_centres_at_zero() {
    assert_golden(
        "PitchBend(0) c",
        "4d546864000000060001000100604d54726b0000001000e0004000903c644b803c6415ff2f00",
    );
}

#[test]
fn rpn_and_nrpn() {
    assert_golden(
        "RPN(0,0,2) c",
        "4d546864000000060001000100604d54726b0000001800b0650000b0640000b0060200903c644b803c6415ff2f00",
    );
    assert_golden(
        "NRPN(1,32,64) c",
        "4d546864000000060001000100604d54726b0000001800b0630100b0622000b0064000903c644b803c6415ff2f00",
    );
}

#[test]
fn repeat_loop() {
    assert_golden(
        "[2 c]",
        "4d546864000000060001000100604d54726b0000001400903c644b803c6415903c644b803c6415ff2f00",
    );
}

#[test]
fn repeat_loop_with_break_marker() {
    // [3 c:d] plays c d c d c — the tail is skipped on the final pass.
    assert_golden(
        "[3 c:d]",
        "4d546864000000060001000100604d54726b0000002c00903c644b803c6415903e644b803e6415903c64\
         4b803c6415903e644b803e6415903c644b803c6415ff2f00",
    );
}

#[test]
fn nested_repeat_loops() {
    assert_golden(
        "[2 [2 c]]",
        "4d546864000000060001000100604d54726b0000002400903c644b803c6415903c644b803c6415903c64\
         4b803c6415903c644b803c6415ff2f00",
    );
}

// --- Phase 2: variables, expressions, control flow ---

#[test]
fn variables_in_arguments() {
    assert_golden(
        "Int x=60; n(x)",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
    assert_golden(
        "Int x=5; o(x) c",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
}

#[test]
fn expressions_evaluate_inside_parentheses() {
    assert_golden(
        "Int x=2; Tempo=(x*60) c",
        "4d546864000000060001000100604d54726b0000001300ff510307a12000903c644b803c6415ff2f00",
    );
}

/// Bare expressions are rejected, exactly as the Pascal build rejects them.
/// This is what keeps `v100 <c` meaning "velocity, then octave down".
#[test]
fn bare_expressions_are_rejected() {
    assert!(compile("Tempo=100+20 c").is_err());
    assert!(compile("Int x=5; ox c").is_err());
}

#[test]
fn arrays() {
    assert_golden(
        "Array a=(60,64,67); n(a(0)) n(a(1)) n(a(2))",
        "4d546864000000060001000100604d54726b0000001c00903c644b803c64159040644b8040641590436\
         44b80436415ff2f00",
    );
}

#[test]
fn if_else() {
    assert_golden(
        "Int x=1; If(x==1){c}Else{d}",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
    assert_golden(
        "Int x=0; If(x==1){c}Else{d}",
        "4d546864000000060001000100604d54726b0000000c00903e644b803e6415ff2f00",
    );
}

#[test]
fn for_loop() {
    assert_golden(
        "Int i; For(i=0;i<3;i=i+1){c}",
        "4d546864000000060001000100604d54726b0000001c00903c644b803c6415903c644b803c6415903c6\
         44b803c6415ff2f00",
    );
}

#[test]
fn while_loop() {
    assert_golden(
        "Int i=0; While(i<3){c;i=(i+1)}",
        "4d546864000000060001000100604d54726b0000001c00903c644b803c6415903c644b803c6415903c6\
         44b803c6415ff2f00",
    );
}

#[test]
fn exit_breaks_out_of_a_loop() {
    // Without Exit this would be three notes.
    assert_golden(
        "Int i=0; While(i<3){c;Exit;i=(i+1)}",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
}

/// A runaway loop must fail rather than hang — a hung browser tab is worse
/// than an error message.
#[test]
fn runaway_loop_errors_instead_of_hanging() {
    let err = compile("Int i=0; While(i>=0){i=(i+1)}").unwrap_err();
    assert!(err.message.contains("繰り返し"));
}

// --- Phase 2: sutoton, System options, key signatures, resets ---

#[test]
fn sutoton_japanese_notation() {
    // ドレミ is cde, so this must match the ASCII form byte for byte.
    let japanese = compile("ドレミ").unwrap();
    let ascii = compile("cde").unwrap();
    assert_eq!(japanese.smf, ascii.smf);

    let japanese = compile("テンポ120 音量127 音階4 ドレミ").unwrap();
    let ascii = compile("Tempo=120 v127 o4 cde").unwrap();
    assert_eq!(japanese.smf, ascii.smf);
}

#[test]
fn time_signature() {
    assert_golden(
        "TimeSignature=3,4 c",
        "4d546864000000060001000100604d54726b0000001400ff58040302600c00903c644b803c6415ff2f00",
    );
}

#[test]
fn sound_module_resets() {
    assert_golden(
        "ResetGM c",
        "4d546864000000060001000100604d54726b0000001400f0057e7f0901f700903c644b803c6415ff2f00",
    );
    assert_golden(
        "ResetGS c",
        "4d546864000000060001000100604d54726b0000001900f00a4110421240007f0041f700903c644b803c\
         6415ff2f00",
    );
    assert_golden(
        "ResetXG c",
        "4d546864000000060001000100604d54726b0000001700f00843104c00007e00f700903c644b803c6415\
         ff2f00",
    );
}

#[test]
fn key_flag_applies_accidentals_and_writes_key_signature() {
    // Two sharps (c and f): c and f sound a semitone higher, d and e do not.
    assert_golden(
        "System.KeyFlag#(cf) cdef",
        "4d546864000000060001000100604d54726b0000002a00ff5902020000903d644b803d6415903e644b80\
         3e64159040644b804064159042644b80426415ff2f00",
    );
    assert_golden(
        "System.KeyFlag-(b) b",
        "4d546864000000060001000100604d54726b0000001200ff5902ff00009046644b80466415ff2f00",
    );
}

#[test]
fn key_shift_transposes() {
    assert_golden(
        "System.Keyshift=2 c",
        "4d546864000000060001000100604d54726b0000000c00903e644b803e6415ff2f00",
    );
}

#[test]
fn q_max_and_v_max_rescale() {
    // System.qMax=8 makes q8 a full-length note, for old MML dialects.
    assert_golden(
        "System.qMax=8 q8 c",
        "4d546864000000060001000100604d54726b0000000c00903c645f803c6401ff2f00",
    );
    assert_golden(
        "System.vMax=15 v15 c",
        "4d546864000000060001000100604d54726b0000000c00903c784b803c7815ff2f00",
    );
}

#[test]
fn time_pointer() {
    assert_golden(
        "Time(2:1:0) c",
        "4d546864000000060001000100604d54726b0000000d8300903c644b803c6415ff2f00",
    );
    // MeasureShift offsets the bar numbering.
    assert_golden(
        "System.MeasureShift(1) Time(1:1:0) c",
        "4d546864000000060001000100604d54726b0000000d8300903c644b803c6415ff2f00",
    );
}

#[test]
fn include_resolves_through_the_resolver() {
    use sakuramml_core::{compile_with, MemoryIncludes, NoIncludes};

    let includes = MemoryIncludes::new().with("notes.h", "Int base=60;".as_bytes().to_vec());
    let out = compile_with("Include(notes.h) n(base)", &includes).unwrap();
    let expected = compile("n60").unwrap();
    assert_eq!(out.smf, expected.smf);

    // Without a resolver the file is simply missing — an error, not a panic.
    assert!(compile_with("Include(notes.h) c", &NoIncludes).is_err());
}

/// Include files are read as bytes, so a CP932 one works as well as UTF-8.
#[test]
fn include_files_may_be_cp932() {
    use sakuramml_core::{compile_with, MemoryIncludes};

    // "テンポ150" in CP932, which is sutoton for Tempo=150.
    let mut cp932 = vec![0x83, 0x65, 0x83, 0x93, 0x83, 0x7c];
    cp932.extend_from_slice(b"150;");
    let includes = MemoryIncludes::new().with("tempo.h", cp932);

    let out = compile_with("Include(tempo.h) c", &includes).unwrap();
    let expected = compile("Tempo=150 c").unwrap();
    assert_eq!(out.smf, expected.smf);
}

// --- SysEx and hexadecimal literals ---

#[test]
fn sysex_hex_mode() {
    // SysEx$=... reads every value as hexadecimal; this is a GM reset.
    assert_golden(
        "SysEx$=f0,7E,7F,9,1,F7; c",
        "4d546864000000060001000100604d54726b0000001400f0057e7f0901f700903c644b803c6415ff2f00",
    );
    assert_golden(
        "SysEx$=f0,43,10,4c,0,0,7e,0,f7; c",
        "4d546864000000060001000100604d54726b0000001700f00843104c00007e00f700903c644b803c6415\
         ff2f00",
    );
}

#[test]
fn sysex_decimal_and_dollar_prefixed_forms() {
    let expected =
        "4d546864000000060001000100604d54726b0000001400f0057e7f0901f700903c644b803c6415ff2f00";
    assert_golden("SysEx=(240,126,127,9,1,247) c", expected);
    assert_golden("SysEx($F0,$7E,$7F,$09,$01,$F7) c", expected);
    // A leading F0 is the status byte either way, so omitting it changes nothing.
    assert_golden("SysEx=(126,127,9,1,247) c", expected);
}

/// A hand-written SysEx must produce the same bytes as the built-in reset.
#[test]
fn hand_written_sysex_matches_the_builtin_reset() {
    let by_hand = compile("SysEx$=f0,7E,7F,9,1,F7;").unwrap();
    let builtin = compile("ResetGM").unwrap();
    assert_eq!(by_hand.smf, builtin.smf);
}

#[test]
fn hexadecimal_literals() {
    assert_golden(
        "Int x=$10; n((x+48))",
        "4d546864000000060001000100604d54726b0000000c009040644b80406415ff2f00",
    );
    assert_golden(
        "n($3C)",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
    // Hex and decimal are the same number by another name.
    assert_eq!(
        compile("Int x=$FF; n((x-135))").unwrap().smf,
        compile("n120").unwrap().smf
    );
}

// --- one-shot octave shifts, and the Japanese symbol table ---

/// `` ` `` and `"` shift the octave for the next note only, then it reverts.
#[test]
fn temporary_octave_shifts() {
    assert_golden(
        "c `c c",
        "4d546864000000060001000100604d54726b0000001c00903c644b803c64159048644b80486415903c64\
         4b803c6415ff2f00",
    );
    assert_golden(
        "c \"c c",
        "4d546864000000060001000100604d54726b0000001c00903c644b803c64159030644b80306415903c64\
         4b803c6415ff2f00",
    );
}

/// A bare `"` is that octave operator, so only `{"` may open a string —
/// otherwise `q30 d"ad` would swallow the rest of the piece as text.
#[test]
fn a_bare_quote_does_not_start_a_string() {
    assert_same_bytes("q30 d\"ad", "q30 d <a >d");
    // A real string still works, and keeps its own punctuation.
    let out = compile(r#"TrackName={"テスト１"} c"#).unwrap();
    let needle = "テスト１".as_bytes();
    let cp932: Vec<u8> = {
        let (bytes, _) = sakuramml_core::encoding::encode_cp932("テスト１", 1);
        bytes
    };
    assert!(out.smf.windows(cp932.len()).any(|w| w == cp932));
    assert!(!out.smf.windows(needle.len()).any(|w| w == needle));
}

/// 【】 are brackets and ↑↓ are octave changes, so Japanese notation reaches
/// the same MML as the ASCII form.
#[test]
fn japanese_symbols_convert() {
    assert_same_bytes("【ドレミ】", "[cde]");
    assert_same_bytes("↑ド↓レ", ">c<d");
    assert_same_bytes("ド♯レ♭", "c#d-");
    assert_same_bytes("音量一二三 ドレミ", "v123 cde");
}

#[track_caller]
fn assert_same_bytes(actual: &str, expected: &str) {
    let left = compile(actual).unwrap_or_else(|e| panic!("failed to compile {actual:?}: {e}"));
    let right = compile(expected).unwrap_or_else(|e| panic!("failed to compile {expected:?}: {e}"));
    assert_eq!(
        hex_string(&left.smf),
        hex_string(&right.smf),
        "\n  {actual:?}\n  should equal {expected:?}"
    );
}
