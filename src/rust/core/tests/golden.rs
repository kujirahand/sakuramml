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
fn note_info_commands_accept_legacy_relative_values() {
    assert_same_bytes("v100 v+10 c", "v110 c");
    assert_same_bytes("v100 v-- c", "v84 c");
    assert_same_bytes("System.vAdd(10) v100 v++ c", "v120 c");
    assert_same_bytes("System.qAdd(7) q80 q++ c", "q94 c");
    assert_same_bytes("System.q2Add(3) q%20 q%++ c", "q%26 c");
    assert_same_bytes("o5 o-1 c", "o4 c");
    assert_same_bytes("t5 t+2 c", "t7 c");
}

#[test]
fn note_options_accept_relative_arithmetic() {
    assert_same_bytes("v100 c4,,+20", "v100 c4,,120");
    assert_same_bytes("q80 c4,-20", "q80 c4,60");
    assert_same_bytes("t5 c4,,,-2", "t5 c4,,,3");
    assert_same_bytes("o5 c4,,,,-1", "o5 c4,,,,4");
    assert_same_bytes("v30 c4,,*2", "v30 c4,,60");
    assert_same_bytes("v30 c4,,/0", "v30 c4,,0");
}

#[test]
fn full_pitch_bend_accepts_the_equals_form() {
    assert_same_bytes("p%=0 c", "p%0 c");
}

#[test]
fn note_arguments_follow_lqvto_order() {
    assert_same_bytes("c4,50,40", "l4 q50 v40 c");
    assert_same_bytes("c4,,,48,6", "t48 o6 c");
    // Per-note values affect only this note; the following note uses track state.
    assert_same_bytes("c4,50,40,48,6 c", "t48 o6 q50 v40 c t0 o5 q80 v100 c");
}

#[test]
fn gate_in_steps_accepts_a_dotted_length_value() {
    assert_same_bytes("c8,%!4.", "c8,%144");
    assert_same_bytes("c8,!4.", "c8,144");
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
fn note_length_may_be_separated_by_spaces() {
    assert_same_bytes("c 4 d 8.", "c4 d8.");
}

#[test]
fn chord_notes_start_together_and_advance_once() {
    assert_golden(
        "'ceg'4 d",
        "4d546864000000060001000100604d54726b0000002400903c6400904064009043644b803c640080406400\
         80436415903e644b803e6415ff2f00",
    );
}

#[test]
fn an_unclosed_chord_is_an_error() {
    let error = compile("'ceg").unwrap_err();
    assert!(error.message.contains("和音"), "{}", error.message);
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
fn step_mode_applies_to_explicit_lengths_and_length_arithmetic() {
    assert_golden(
        "l%48 l4 c",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
    assert_golden(
        "l%48 c96 r100-4 d",
        "4d546864000000060001000100604d54726b0000001400903c644b803c6475903e6425803e640bff2f00",
    );
    assert_golden(
        "l%48 c%96 r%96 d",
        "4d546864000000060001000100604d54726b0000001400903c6402803c6406903e6425803e640bff2f00",
    );
    assert_same_bytes("l4 c4+8 d", "c4^8 d");
}

#[test]
fn an_omitted_joined_length_part_uses_the_current_default() {
    assert_golden(
        "l16 q100 c2^4^",
        "4d546864000000060001000100604d54726b0000000d00903c648237803c6401ff2f00",
    );
    assert_same_bytes("l16 c2+4+", "l16 c2^4^16");
    assert_same_bytes("l16 c2-4-", "l16 c%72");
    assert_same_bytes("l16 c2^4^.", "l16 c2^4^16.");
    assert_same_bytes("l16 c^", "l16 c8");
    assert_same_bytes("l16 c^,75", "l16 c8,75");
    assert_same_bytes("l16 r^ c", "l16 r8 c");
}

#[test]
fn omitted_joined_lengths_use_the_advanced_event_default() {
    assert_golden(
        "l.onNote(8) c^",
        "4d546864000000060001000100604d54726b0000000c00903c640b803c6405ff2f00",
    );
    assert_same_bytes("l.onNote(8) r^ c", "l%8 r^ c");
}

#[test]
fn arg_order_leaves_a_join_for_the_tie_handler_until_length_is_reached() {
    assert_same_bytes(
        "l.onNote(8,4) ArgOrder(qlvto) c50^c",
        "ArgOrder(qlvto) l%8 q50 c l%4 q80 r l%8 c",
    );
    assert_golden(
        "ArgOrder(qlvto) c50^c",
        "4d546864000000060001000100604d54726b0000001500903c642f803c648111903c644b803c6415ff2f00",
    );
}

#[test]
fn overflowing_joined_lengths_return_an_error() {
    let error = compile("c%9223372036854775807^").unwrap_err();
    assert!(error.message.contains("結合音長が範囲を超えました"));
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
fn plain_rest_advances_note_modifiers_but_eventless_rest_does_not() {
    assert_golden(
        "l4 t.onNote(0,4,12,0) 'ceg' r 'ceg'",
        "4d546864000000060001000100604d54726b0000003400903c6404904064089043643f803c64048040640880436469903c6404904064089043643f803c64048040640880436409ff2f00",
    );
    assert_golden(
        "l4 t.onNote(0,4,12,0) 'ceg' r* 'ceg'",
        "4d546864000000060001000100604d54726b0000003400903c6404904064089043643f803c64048040640880436469903c64009040640490436447803c64008040640480436411ff2f00",
    );
}

#[test]
fn packed_note_off_order_follows_note_on_time_after_a_rewind() {
    assert_golden(
        "q100 Time(1:2:0)c4 Time(1:1:0)e2",
        "4d546864000000060001000100604d54726b000000140090406460903c645f80406400803c6401ff2f00",
    );
}

#[test]
fn silent_packed_note_off_order_follows_note_on_time_after_a_rewind() {
    assert_golden(
        "v0 q100 Time(1:2:0)c4 Time(1:1:0)e2",
        "4d546864000000060001000100604d54726b000000140090400060903c005f80400000803c0001ff2f00",
    );
}

#[test]
fn identical_pitch_bends_at_one_tick_are_deduplicated() {
    assert_golden(
        "p0 p0",
        "4d546864000000060001000100604d54726b0000000800e0000000ff2f00",
    );
}

#[test]
fn direct_pitch_bends_cancel_both_modifier_forms() {
    let centred = "4d546864000000060001000100604d54726b0000001000e0004000903c644b803c6415ff2f00";
    assert_golden("PitchBend.onNote(-8192,8191); p64; c", centred);
    assert_golden("p.onNote(0,127); PitchBend(0); c", centred);
    assert_golden("PitchBend(0); p.onNote(64); c", centred);
    assert_golden("p64; PitchBend.onNote(0); c", centred);
}

#[test]
fn redeclared_bend_modifier_uses_the_direct_bends_current_value() {
    let rewritten = "4d546864000000060001000100604d54726b0000002000e0000000903c644b803c6414e0004000e0000001903e644b803e6415ff2f00";
    assert_golden("p.onNote(0); c; PitchBend(0); p.onNote(0); d", rewritten);
    assert_golden(
        "PitchBend.onNote(-8192); c; p64; PitchBend.onNote(-8192); d",
        rewritten,
    );
}

#[test]
fn direct_pitch_bend_uses_pascal_insertion_order_when_rewound() {
    assert_golden(
        "q100 PitchBend.onNote(-8000,-7000) Time(1:2:4)c Time(1:1:50)d Time(1:1:75)p64",
        "4d546864000000060001000100604d54726b0000002031e0280901903e6418e0004019e0400101903c642d803e6432803c6400ff2f00",
    );
}

#[test]
fn joined_length_extends_the_note() {
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
fn tempo_change_matches_pascal_for_all_argument_forms() {
    assert_golden(
        "Tempo=120 TempoChange(120,80,!1) c1",
        "4d546864000000060001000100604d54726b0000008300ff510307a12000ff510307a12000903c6418\
         ff510307d33418ff510307f60b18ff5103082ca218ff51030852ae18ff5103088e6b18ff510308b824\
         18ff510308f9cb18ff51030927c018ff510309703c18ff510309a31a18ff510309f38d18ff51030a2c2a\
         12803c6406ff51030a85f718ff51030ac55a30ff51030b71b000ff2f00",
    );
    assert_golden(
        "Tempo=100 TempoChange(80,!2) c2",
        "4d546864000000060001000100604d54726b0000004b00ff51030927c000ff51030927c000903c6418\
         ff510309703c18ff510309a31a18ff510309f38d18ff51030a2c2a18ff51030a85f718ff51030ac55a\
         08803c6428ff51030b71b000ff2f00",
    );
    assert_golden(
        "Tempo=120 TempoChange=160 c1",
        "4d546864000000060001000100604d54726b0000008300ff510307a12000ff510307a12000903c6418\
         ff510307811b18ff510307530018ff510307357818ff5103070ae218ff510306ef9118ff510306c81c\
         18ff510306aec418ff5103068a1b18ff510306728718ff510306506118ff5103063a6318ff5103061a80\
         12803c6406ff51030605f018ff510305e81830ff510305b8d800ff2f00",
    );
}

#[test]
fn tempo_change_uses_track_zero_without_moving_the_current_track() {
    assert_golden(
        "TR=2 r TempoChange(120,80,!16)c",
        "4d546864000000060001000200604d54726b0000000b78ff51030b71b000ff2f00\
         4d54726b0000000c60913c644b813c6415ff2f00",
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
fn overlapping_note_is_shortened_across_channel_changes() {
    assert_golden(
        "Channel(1) l1 c Time(1:2:0) Channel(2)c",
        "4d546864000000060001000100604d54726b0000001500903c645f803c6401913c648232813c644eff2f00",
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
fn play_writes_parallel_tracks_like_pascal() {
    assert_golden(
        "Play({c},{e},{g})",
        "4d546864000000060001000300604d54726b0000000c00903c644b803c6415ff2f004d54726b0000000c\
         009040644b80406415ff2f004d54726b0000000c009143644b81436415ff2f00",
    );
}

#[test]
fn play_accepts_string_macros_and_restores_the_callers_track() {
    assert_golden(
        "#A={cdef} #B={eg} Play(#A,#B)",
        "4d546864000000060001000200604d54726b0000002400903c644b803c6415903e644b803e64159040644b\
         804064159041644b80416415ff2f004d54726b00000014009040644b804064159043644b80436415ff2f00",
    );
    assert_same_bytes(
        "TR=3 r4 Play({c},{e}) g",
        "TR=0 Time(96) c TR=1 Time(96) e TR=3 Time(96) g",
    );
}

#[test]
fn play_keeps_empty_argument_positions_as_track_numbers() {
    assert_same_bytes("Play(,{e})", "TR=1 e");
    assert_same_bytes("Play({c};{e})", "Play({c},{e})");
    assert_same_bytes("PLAY({c},{e})", "Play({c},{e})");
    assert_same_bytes("Play({d\"ad},{c})", "TR=0 d\"ad TR=1 c");
    assert_same_bytes("Play({c4,50,40},{n(64)})", "TR=0 c4,50,40 TR=1 n64");
}

#[test]
fn play_reports_the_failing_track() {
    let error = compile("Play({c},{NotACommand})").unwrap_err();
    assert!(error.message.contains("Playのトラック1"), "{error}");
    assert!(error.message.contains("未定義"), "{error}");
}

#[test]
fn track_name_is_written_as_cp932() {
    assert_golden(
        r#"TrackName={"テスト"} c"#,
        "4d546864000000060001000100604d54726b0000001600ff030683658358836700903c644b803c6415ff2f00",
    );
}

#[test]
fn empty_meta_text_is_written_as_a_space() {
    assert_golden(
        r#"MetaText={""}"#,
        "4d546864000000060001000100604d54726b0000000900ff01012000ff2f00",
    );
}

#[test]
fn low_level_note_on_uses_the_current_channel_without_advancing_time() {
    // Both direct events and the following ordinary note start at tick 0.
    // The repeated 0x91 bytes also lock in Pascal's no-running-status output.
    assert_golden(
        "Channel(2) NoteOn(60,100) NoteOn(61,99) c",
        "4d546864000000060001000100604d54726b0000001400913c6400913d6300913c644b813c6415ff2f00",
    );
}

#[test]
fn low_level_note_off_retains_same_time_insertion_order() {
    assert_golden(
        "NoteOff(60,64) NoteOn(60,100)",
        "4d546864000000060001000100604d54726b0000000c00803c4000903c6400ff2f00",
    );
}

#[test]
fn play_from_preserves_packed_note_off_ordering() {
    assert_golden(
        "q100 c Time(95) NoteOn(61,100) PlayFrom(48)",
        "4d546864000000060001000100604d54726b0000000d816f903d6400803c6400ff2f00",
    );
}

#[test]
fn channel_prefix_is_a_one_based_legacy_meta_command() {
    assert_golden(
        "ChannelPrefix(1)",
        "4d546864000000060001000100604d54726b0000000900ff20010000ff2f00",
    );
    assert_golden(
        "ChannelPrefix(128)",
        "4d546864000000060001000100604d54726b0000000900ff20017f00ff2f00",
    );
}

#[test]
fn port_and_uppercase_alias_emit_midi_port_meta_events() {
    assert_golden(
        "Port(0) PORT(127) Port(255)",
        "4d546864000000060001000100604d54726b0000001300ff21010000ff21017f00ff2101ff00ff2f00",
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
fn voice_and_controllers_precede_the_current_time() {
    assert_golden(
        "r4 @2 c",
        "4d546864000000060001000100604d54726b0000000f5fc00101903c644b803c6415ff2f00",
    );
    assert_golden(
        "r4 y7=100 c",
        "4d546864000000060001000100604d54726b000000105fb0076401903c644b803c6415ff2f00",
    );
    assert_golden(
        "r4 p64 c",
        "4d546864000000060001000100604d54726b000000105fe0004001903c644b803c6415ff2f00",
    );
}

#[test]
fn controller_shift_moves_cc_and_bend_but_not_program_change() {
    assert_golden(
        "r4 System.ControllerShift=2 @2 y7=100 p64 c",
        "4d546864000000060001000100604d54726b000000175eb0076400e0004001c00101903c644b803c6415ff2f00",
    );
}

#[test]
fn zero_length_numeric_notes_form_a_legacy_chord() {
    assert_golden(
        "n60,0 n64,0 n67,4",
        "4d546864000000060001000100604d54726b0000001c00903c6400904064009043644c803c64008040640080436414ff2f00",
    );
    assert_golden(
        "q1 n60,0 n64,0 n67,16",
        "4d546864000000060001000100604d54726b0000001c00903c64009040640090436401803c64008040640080436417ff2f00",
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
fn direct_control_change_accepts_the_equals_form() {
    assert_same_bytes("y11=127", "y11,127");
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
fn full_range_pitch_bend_accepts_advance_modifiers() {
    assert_same_bytes(
        "p%.onTime(0,8191,!4); r4",
        "PitchBend.onTime(0,8191,!4); r4",
    );
}

#[test]
fn full_range_pitch_bend_modifier_is_not_clamped_as_easy_bend() {
    let out = compile("PitchBend.Frequency(24); PitchBend.onTime(-8192,0,!4); r4").unwrap();
    assert!(out.smf.windows(3).any(|bytes| bytes == [0xe0, 0x00, 0x00]));
    assert!(out.smf.windows(3).any(|bytes| bytes == [0xe0, 0x00, 0x10]));
    assert!(out.smf.windows(3).any(|bytes| bytes == [0xe0, 0x00, 0x40]));
}

#[test]
fn plain_cc_and_bend_writes_cancel_advance_modifiers() {
    let cc = compile("l4 M.onNoteWave(0,60,!2); c M(0) r1 c").unwrap();
    let cc_count = cc
        .smf
        .windows(2)
        .filter(|bytes| *bytes == [0xb0, 1])
        .count();
    assert_eq!(cc_count, 32);

    let bend = compile("l4 PitchBend.onNote(-8192,8191); c PitchBend(0) r1 c").unwrap();
    let bend_count = bend.smf.iter().filter(|byte| **byte == 0xe0).count();
    assert_eq!(bend_count, 2);
}

#[test]
fn rest_accepts_a_parenthesized_length_expression() {
    assert_golden(
        "l%48 Int N=48; r(N-6)c",
        "4d546864000000060001000100604d54726b0000000c2a903c6425803c640bff2f00",
    );
    assert_golden(
        "l%48 r%42 c",
        "4d546864000000060001000100604d54726b0000000c09903c6425803c640bff2f00",
    );
    assert_same_bytes("l4 Int N=4; r(N)c", "r4 c");
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
    // Explicit accidentals add to KeyFlag; the flat cancels F sharp.
    assert_golden(
        "System.KeyFlag#(f) f-",
        "4d546864000000060001000100604d54726b0000001200ff59020100009041644b80416415ff2f00",
    );
}

#[test]
fn note_star_suppresses_key_flag_before_an_accidental() {
    assert_same_bytes("System.KeyFlag#(c) c c* c*+", "System.KeyFlag#(c) c c- c");
}

#[test]
fn key_shift_transposes() {
    assert_golden(
        "System.Keyshift=2 c",
        "4d546864000000060001000100604d54726b0000000c00903e644b803e6415ff2f00",
    );
    assert_same_bytes("Key=2 c", "d");
}

#[test]
fn time_key_ranges_match_pascal_at_boundaries_and_when_overlapping() {
    // An omitted start uses the current time, and an omitted end stays open.
    assert_golden(
        "Time(1:2:0) TimeKey(,,2)c",
        "4d546864000000060001000100604d54726b0000000c60903e644b803e6415ff2f00",
    );
    // Later matching declarations win. When their half-open range ends, the
    // still-active earlier declaration becomes visible again.
    assert_golden(
        "TimeKey((1:1:0),(1:4:0),2) TimeKey((1:2:0),(1:3:0),4) \
         Time(1:1:0)c Time(1:2:0)c Time(1:3:0)c",
        "4d546864000000060001000100604d54726b0000001c00903e644b803e64159040644b80406415903e\
         644b803e6415ff2f00",
    );
}

#[test]
fn time_key_flag_ranges_override_key_flag_like_pascal() {
    // TimeKeyFlag uses the legacy a,b,c,d,e,f,g argument order. A matching
    // rule replaces (rather than adds to) the ordinary KeyFlag array.
    assert_golden(
        "KeyFlag+(c) TimeKeyFlag((1:2:0),(1:3:0),(0,0,0,1,0,0,0)) \
         Time(1:1:0)cd Time(1:2:0)cd Time(1:3:0)cd",
        "4d546864000000060001000100604d54726b0000003a00ff5902010000903d644b803d6415903f6400\
         903c644b803f6400803c6415903e6400903d644b803e6400803d6415903e644b803e6415ff2f00",
    );
    assert_golden(
        "TimeKeyFlag((1:1:0),(1:4:0),(0,0,1,0,0,0,0)) \
         TimeKeyFlag((1:2:0),(1:3:0),(0,0,0,1,0,0,0)) \
         Time(1:1:0)cd Time(1:2:0)cd Time(1:3:0)cd",
        "4d546864000000060001000100604d54726b0000003400903d644b803d6415903f6400903c644b803f\
         6400803c6415903e6400903d644b803e6400803d6415903e644b803e6415ff2f00",
    );
}

#[test]
fn track_key_is_kept_per_track() {
    assert_golden(
        "Track=1 TrackKey(2)c Track=2 c TrackKey(-1)c Track=1 c",
        "4d546864000000060001000200604d54726b0000001400903e644b803e6415903e644b803e6415ff2f\
         004d54726b0000001400913c644b813c6415913b644b813b6415ff2f00",
    );
}

#[test]
fn use_key_shift_disables_only_transposition() {
    assert_golden(
        "Key(2) TrackKey(3) TimeKey(,,4) TimeKey2(,,5) KeyFlag+(c) \
         c UseKeyShift(off)c UseKeyShift(on)c",
        "4d546864000000060001000100604d54726b0000002200ff5902010000904b644b804b6415903d644b\
         803d6415904b644b804b6415ff2f00",
    );
    // TimeKeyFlag, like KeyFlag, remains effective while transposition is off.
    assert_golden(
        "TimeKeyFlag((1:1:0),(2:1:0),(0,0,1,0,0,0,0)) UseKeyShift(off)c",
        "4d546864000000060001000100604d54726b0000000c00903d644b803d6415ff2f00",
    );
}

#[test]
fn chords_apply_time_track_and_flag_rules_to_each_note() {
    assert_golden(
        "TimeKey(,,2) TrackKey(3) TimeKeyFlag(,,(0,0,1,0,0,0,0)) 'ceg'",
        "4d546864000000060001000100604d54726b0000001c0090426400904564009048644b80426400804564\
         0080486415ff2f00",
    );
}

#[test]
fn legacy_system_note_settings_match_pascal() {
    assert_golden(
        "System.X68mode(on);o5>c<c",
        "4d546864000000060001000100604d54726b00000014009030644b80306415903c644b803c6415ff2f00",
    );
    assert_golden(
        "System.Stepmode(on);Track=1;c48",
        "4d546864000000060001000100604d54726b0000000c00903c6425803c640bff2f00",
    );
    assert_same_bytes(
        "System.Stepmode(on);Track=1;c%48",
        "System.Stepmode(off);Track=1;c48",
    );
    assert_golden(
        "System.Stepmode(on);c48",
        "4d546864000000060001000100604d54726b0000000c00903c6405803c6403ff2f00",
    );
    assert_golden(
        "System.VoiceNoShift=-1;@2c",
        "4d546864000000060001000100604d54726b0000000f00c00000903c644b803c6415ff2f00",
    );
    assert_golden(
        "System.OctaveRangeShift=1;o4c",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
}

#[test]
fn controller_shift_matches_pascal() {
    assert_golden(
        "r4 System.ControllerShift=2 @2 y7=100 p64 c",
        "4d546864000000060001000100604d54726b000000175eb0076400e0004001c00101903c644b803c6415ff2f00",
    );
}

#[test]
fn arg_order_is_track_local() {
    assert_golden(
        "ArgOrder(o);c4",
        "4d546864000000060001000100604d54726b0000000c009030644b80306415ff2f00",
    );
    assert_same_bytes("ArgOrder(lvqto);c4,120", "l4 v120 c");
    assert_golden(
        "ArgOrder(v);r8c",
        "4d546864000000060001000100604d54726b0000000c30903c644b803c6415ff2f00",
    );
    assert_golden(
        "ArgOrder(v);c^8",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6445ff2f00",
    );
}

#[test]
fn get_key_flag_returns_the_pitch_class_array() {
    let out = compile(
        "System.KeyFlag=(1,0,-1,0,1,0,-1);Array (flags)=System.GetKeyFlag;Print(flags(0));Print(flags(2));Print(flags(6))",
    )
    .unwrap();
    assert_eq!(out.messages, ["1", "-1", "-1"]);
    assert!(!out.warnings.iter().any(|w| w.message.contains("未実装")));
}

#[test]
fn key_flag_array_uses_legacy_a_through_g_order() {
    assert_same_bytes(
        "System.KeyFlag=(0,0,-1,0,0,0,0); l4 o5 cdefgab",
        "System.KeyFlag-(c); l4 o5 cdefgab",
    );
}

#[test]
fn allow_multi_line_controls_chords() {
    assert!(compile("AllowMultiLine(1);'c\ne'").is_ok());
    let err = compile("AllowMultiLine(0);'c\ne'").unwrap_err();
    assert!(err.message.contains("和音内に改行"));
}

#[test]
fn meta_text_eol_selects_the_output_bytes() {
    assert_golden(
        "System.MetaTextEOL(1);MetaText={\"a\r\nb\"}",
        "4d546864000000060001000100604d54726b0000000b00ff0103610a6200ff2f00",
    );
    assert_golden(
        "MetaTextEOL(2);MetaText={\"a\r\nb\"}",
        "4d546864000000060001000100604d54726b0000000b00ff0103610d6200ff2f00",
    );
}

#[test]
fn migrated_system_settings_no_longer_warn_as_unimplemented() {
    let out = compile(
        "System.X68mode(off);System.Stepmode(off);System.VoiceNoShift=0;System.OctaveRangeShift=0;System.ControllerShift=1;System.ArgOrder(lqvto);System.AllowMultiLine(1);System.MetaTextEOL(0);c",
    )
    .unwrap();
    assert!(!out.warnings.iter().any(|w| w.message.contains("未実装")));
    let out = compile("System.LoadSMF(dummy.mid);c").unwrap();
    assert!(out
        .warnings
        .iter()
        .any(|w| w.message.contains("System.LoadSMF") && w.message.contains("未実装")));
    assert!(compile("System.ControllerShift=2147483648;c").is_err());
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
fn sysex_checksum_group_matches_pascal() {
    assert_golden(
        "SysEx$=F0,41,10,42,12,{40,01,30,05},F7",
        "4d546864000000060001000100604d54726b0000001100f00a41104212400130050af700ff2f00",
    );
}

#[test]
fn joined_lengths_work_in_advance_arguments() {
    assert_same_bytes(
        "P.Frequency(96); P.onTime(0,127,!1^1); c1^1",
        "P.Frequency(96); P.onTime(0,127,%768); c1^1",
    );
    assert_same_bytes(
        "P.Frequency(96); EP.onTime(127,0,!1^1); c1^1",
        "P.Frequency(96); EP.onTime(127,0,%768); c1^1",
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

// --- rhythm mode, Sub, and user-defined Japanese macros ---

/// `Sub{...}` plays the block and puts the time pointer back, so what follows
/// starts where the Sub did.
#[test]
fn sub_restores_the_time_pointer() {
    assert_golden(
        "Sub{c} d",
        "4d546864000000060001000100604d54726b0000001400903c6400903e644b803c6400803e6415ff2f00",
    );
    assert_golden(
        "c Sub{e} d",
        "4d546864000000060001000100604d54726b0000001c00903c644b803c641590406400903e644b804064\
         00803e6415ff2f00",
    );
}

/// In rhythm mode one character is one drum hit.
#[test]
fn rythm_macros_expand_per_character() {
    assert_golden(
        "$b{n36,} Rythm{ bb }",
        "4d546864000000060001000100604d54726b00000014009024644b802464159024644b80246415ff2f00",
    );
    // `?` takes the number that follows: `x36` becomes `n36,`.
    assert_golden(
        "$x{n?,} Rythm{ x36 x38 }",
        "4d546864000000060001000100604d54726b00000014009024644b802464159026644b80266415ff2f00",
    );
}

#[test]
fn string_macros_expand_inside_rythm_mode() {
    assert_same_bytes("$b{n36,}; $h{n42,}; #F={b8h8}; Rythm{#F}", "n36,8 n42,8");
}

/// Characters with no macro keep their ordinary meaning, so lengths, rests and
/// loops work inside a rhythm block.
#[test]
fn rythm_mode_leaves_other_mml_alone() {
    assert_same_bytes("$b{n36,} Rythm{ l8 brbr }", "l8 n36,r n36,r");
    assert_same_bytes("$b{n36,} $s{n38,} Rythm{ [2 bs] }", "[2 n36,n38,]");
}

/// `~{name}={mml}` defines a Japanese macro; the definition writes nothing.
#[test]
fn user_defined_sutoton_macros() {
    assert_same_bytes("~{ドン}={c} ドン", "c");
    assert_same_bytes("~{ド}={n60} ド", "n60");
    // A longer name wins over one that prefixes it.
    assert_same_bytes(
        "~{方向左}={P(0);}~{方向左前}={P(32);} 方向左前 方向左",
        "P(32) P(0)",
    );
}

// --- 先行指定: .onNote ---

/// `.onNote` hands out one value per note, cycling when the list runs out.
#[test]
fn on_note_cycles_values_across_notes() {
    assert_golden(
        "v.onNote(120,50) cdef",
        "4d546864000000060001000100604d54726b0000002400903c784b803c7815903e324b803e32159040784\
         b804078159041324b80413215ff2f00",
    );
    assert_golden(
        "q.onNote(90,30) cd",
        "4d546864000000060001000100604d54726b0000001400903c6455803c640b903e641b803e6445ff2f00",
    );
    // Timing shifts the note's start without moving the track's own pointer.
    assert_golden(
        "t.onNote(0,2) cd",
        "4d546864000000060001000100604d54726b0000001400903c644b803c6417903e644b803e6413ff2f00",
    );
}

#[test]
fn on_note_accepts_the_equals_form() {
    // `音量予約120,50` expands to this, so both spellings must agree.
    assert_same_bytes("v.onNote=120,50 cd", "v.onNote(120,50) cd");
}

/// The two note-option forms differ, which is easy to get backwards: `c(4,...)`
/// sets only the length, so a `.onNote` velocity still applies, while the
/// comma form `c4,80,64` sets the velocity itself and wins.
#[test]
fn the_comma_form_sets_options_and_the_bracket_form_only_a_length() {
    assert_same_bytes("c(4,80,64)", "c");
    assert_same_bytes("c(4,30)", "c4");
    assert_same_bytes("v.onNote(120,50) c(4,80,64)", "v120 c");
    assert_same_bytes("v.onNote(120,50) c4,80,64", "q80 v64 c");
}

/// Wave modifiers belong to controllers; Pascal rejects them on note
/// attributes instead of silently dropping their musical effect.
#[test]
fn controller_only_modifiers_are_rejected_on_note_attributes() {
    let error = compile("v.onNoteWave(0,127,48) cd").unwrap_err();
    assert!(error.message.contains("onNoteWave"), "{error:?}");
    // On a control change the same modifier is implemented: it writes, and
    // says nothing about being unported. (The stdmsg.h hint is expected here,
    // since this compile has no include resolver.)
    let out = compile("P.onNote(0,127) cd").unwrap();
    assert!(
        !out.warnings.iter().any(|w| w.message.contains("未実装")),
        "{:?}",
        out.warnings
    );
    assert!(out.smf.windows(2).any(|w| w == [0xb0, 0x0a]));
}

#[test]
fn note_attribute_on_time_matches_pascal() {
    assert_golden(
        "v.onTime(40,100,!1) c1",
        "4d546864000000060001000100604d54726b0000000d00903c288232803c284eff2f00",
    );
    assert_golden(
        "v.T(40,100,!1) l2 cc",
        "4d546864000000060001000100604d54726b0000001600903c288118803c2828903c468118803c4628ff2f00",
    );
    assert_golden(
        "l.onTime(!4,!8,!4) cc",
        "4d546864000000060001000100604d54726b0000001400903c644b803c6415903c6425803c640bff2f00",
    );
    assert_golden(
        "o.onTime(5,6,!4) l4 cc",
        "4d546864000000060001000100604d54726b0000001400903c644b803c64159048644b80486415ff2f00",
    );
}

#[test]
fn nested_length_literal_in_on_time_matches_pascal_recursion() {
    assert_same_bytes(
        "l32 v.onTime(40,120,!1^!1) [32 c]",
        "l32 v.onTime(40,120,%385) [32 c]",
    );
}

#[test]
fn note_attribute_cycle_delay_repeat_and_range_match_pascal() {
    assert_golden(
        "q.onCycle(!4,20,80) l4 cc",
        "4d546864000000060001000100604d54726b0000001400903c6412803c644e903c644b803c6415ff2f00",
    );
    assert_golden(
        "v.Delay(!4) v.onTime(40,100,!1) l4 cc",
        "4d546864000000060001000100604d54726b0000001400903c644b803c6415903c284b803c2815ff2f00",
    );
    assert_golden("v.Repeat(0) v.onTime(40,100,!4) l4 ccc", "4d546864000000060001000100604d54726b0000001c00903c284b803c2815903c644b803c6415903c644b803c6415ff2f00");
    assert_golden("v.Range(50,80) v.onTime(0,127,!1) l4 ccccc", "4d546864000000060001000100604d54726b0000002c00903c324b803c3215903c324b803c3215903c3f4b803c3f15903c504b803c5015903c504b803c5015ff2f00");
}

#[test]
fn slur_gate_and_arpeggio_match_pascal() {
    assert_golden(
        "l4 Slur(2,100) q50 c&d",
        "4d546864000000060001000100604d54726b0000001400903c645f803c6401903e6430803e6430ff2f00",
    );
    assert_golden("l16 Slur(3,100) c&e&g", "4d546864000000060001000100604d54726b0000001c00903c64189040641890436413803c64008040640080436405ff2f00");
    assert_golden(
        "l4 Slur(2,100) q50 c&c",
        "4d546864000000060001000100604d54726b0000000c00903c645f803c6461ff2f00",
    );
}

#[test]
fn slur_bend_and_glissando_match_pascal() {
    assert_golden("l8 Slur(1,0) c&d&c", "4d546864000000060001000100604d54726b0000001800e0004000903c6430e07f7f30e0004026803c640aff2f00");
    assert_golden("l4 Slur(0,!8) c&e&g", "4d546864000000060001000100604d54726b000000d400b0650000b0640000b0060c00e0561a009043642fe0561a02e0471b02e0391c02e02b1d02e01d1e02e00e1f02e0002002e0722002e0642102e0552202e0472302e0392402e02b2502e01c2602e00e2702e0002802e0722802e0632902e0552a02e0472b02e0392c02e02a2d03e0003033e0003002e0553002e02a3102e0003202e0553202e02a3302e0003402e0553402e02a3502e0003602e0553602e02a3702e0003802e0553802e02a3902e0003a02e0553a02e02a3b02e0003c02e0553c02e02a3d02e0003e03e000405080436414ff2f00");
    assert_golden("l4 Slur(0,-20) c&e", "4d546864000000060001000100604d54726b0000004000b0650000b0640000b0060c00e0562a009040645fe0562a02e0672c02e0782e02e0093102e01a3302e02b3502e03c3702e04d3903e000403c80406414ff2f00");
}

#[test]
fn note_modifiers_and_slur_reject_invalid_arguments() {
    for (mml, expected) in [
        ("v.onTime(0,127) c", "3個単位"),
        ("v.onCycle() c", "引数"),
        ("v.Range(0) c", "low,high"),
        ("Slur(4,10) c&d", "0〜3"),
        ("Slur(0,10,13) c&d", "1〜12"),
        ("Slur(0,(-9223372036854775807-1)) c&d", "valueが範囲外"),
        ("Slur(3,-4611686018427387904) c&&d", "時間が範囲外"),
        ("Slur(2,100) c&", "音符"),
    ] {
        let error = compile(mml).unwrap_err();
        assert!(error.message.contains(expected), "{mml}: {error:?}");
    }
}

#[test]
fn slur_notes_survive_intervening_event_deletion() {
    let out = compile("P.onTime(0,127,!1) c& DeleteCC(10) d").unwrap();
    let note_ons: Vec<u8> = out
        .smf
        .windows(3)
        .filter(|event| event[0] == 0x90 && event[2] != 0)
        .map(|event| event[1])
        .collect();
    assert_eq!(note_ons, vec![62]);
}

#[test]
fn slur_respects_cc_mute_and_wide_fallback() {
    assert_golden(
        "CCMute(on) Slur(1,0) c&d",
        "4d546864000000060001000100604d54726b0000000d00903e64812c803e6414ff2f00",
    );
    assert_golden(
        "Slur(1,0)c&o7c",
        "4d546864000000060001000100604d54726b0000001400903c645f803c64019054644c80546414ff2f00",
    );
}

#[test]
fn nonrepeating_note_list_holds_its_final_value() {
    assert_golden(
        "v.Repeat(0) v.onNote(40,50) cccc",
        "4d546864000000060001000100604d54726b0000002400903c284b803c2815903c324b803c3215903c324b803c3215903c324b803c3215ff2f00",
    );
}

#[test]
fn gate_modifier_preserves_its_step_mode() {
    assert_golden(
        "l4 q%.onNote(50)c",
        "4d546864000000060001000100604d54726b0000000c00903c6431803c642fff2f00",
    );
    assert_golden(
        "l4 q%.onNote(50) q.Delay(0) c",
        "4d546864000000060001000100604d54726b0000000c00903c642f803c6431ff2f00",
    );
    assert_golden(
        "l4 q.onNote(50) q%.Delay(0) c",
        "4d546864000000060001000100604d54726b0000000c00903c6431803c642fff2f00",
    );
}

// --- Div (tuplets) and string macros ---

/// `Div{cde}4` fits three notes into one quarter note.
#[test]
fn div_shares_a_length_between_its_notes() {
    assert_golden(
        "Div{cde}4",
        "4d546864000000060001000100604d54726b0000001c00903c6418803c6408903e6418803e6408904064\
         1880406408ff2f00",
    );
    assert_golden(
        "Div{cd}4",
        "4d546864000000060001000100604d54726b0000001400903c6425803c640b903e6425803e640bff2f00",
    );
    // With no length given it uses the current default, so l8 halves it.
    assert_same_bytes("l8 Div{cde}", "Div{cde}8");
    // A rest counts as one of the shares.
    assert_same_bytes("Div{crd}4", "l12 c r d");
}

#[test]
fn a_chord_counts_as_one_div_element() {
    assert_same_bytes("Div{'ceg''dfa''egb'}4", "'ceg'12 'dfa'12 'egb'12");
}

/// The tuplet occupies exactly the length asked for, however much its body
/// actually plays — a tie inside writes past the end without moving the
/// pointer any further.
#[test]
fn div_leaves_the_pointer_after_the_stated_length() {
    assert_golden(
        "Div{c^d}4",
        "4d546864000000060001000100604d54726b0000001400903c644b803c6415903e6425803e6400ff2f00",
    );
    assert_same_bytes("Div{cde}4 e", "l12 cde l4 e");
    assert_same_bytes("l8 Div{cde}^ e^", "l8 Div{cde}4 e^");
}

/// `#name={mml}` defines a string macro; mentioning it plays its contents.
#[test]
fn string_macros_play_their_contents() {
    assert_golden(
        "#M={cde} #M",
        "4d546864000000060001000100604d54726b0000001c00903c644b803c6415903e644b803e6415904064\
         4b80406415ff2f00",
    );
    assert_same_bytes("#M={c} #M #M", "c c");
    assert_same_bytes("#A={c} #B={d} #A #B", "c d");
    // A plain Str variable behaves the same way.
    assert_same_bytes(r#"Str s={"cde"} s"#, "cde");
}

#[test]
fn string_macros_compose() {
    // #STR turns a number into text, so macros can be built up.
    let out = compile(r#"Int n=3; Print((#STR(n)+{"!"}))"#).unwrap();
    assert_eq!(out.messages, vec!["3!".to_string()]);
    assert_same_bytes(r#"#A={c} #B=(#A+{"d"}) #B"#, "c d");
}

// --- chords and Key ---

/// `'ceg'` sounds its notes together: one start, one shared length.
#[test]
fn chords_sound_their_notes_together() {
    assert_golden(
        "'ceg'",
        "4d546864000000060001000100604d54726b0000001c00903c64009040640090436\
         44b803c64008040640080436415ff2f00",
    );
    // A length after the closing quote applies to the whole chord.
    assert_golden(
        "'ceg'2",
        "4d546864000000060001000100604d54726b0000001d00903c64009040640090436\
         48118803c64008040640080436428ff2f00",
    );
}

#[test]
fn chord_length_accepts_a_parenthesized_variable() {
    assert_same_bytes("Function f(len){'ceg'(len)} f(4)", "'ceg'4");
    assert_same_bytes("l%24 Function f(len){'ceg'(len)} f(48)", "'ceg'%48");
}

#[test]
fn tied_chord_keeps_sounding_for_the_joined_length() {
    assert_same_bytes("q100 l4 'ceg'^", "q100 'ceg'2");
    assert_same_bytes("q100 l4 'ceg'^2", "q100 'ceg'*%288");
}

/// The pointer moves once for the chord, not once per note in it.
#[test]
fn a_chord_advances_the_pointer_once() {
    assert_same_bytes("'ce'4 'df'8", "'ce' l8 'df'");
    assert_same_bytes("'ceg' d", "'ceg' l4 d");
}

#[test]
fn key_transposes() {
    assert_same_bytes("Key(2) c", "n62");
    assert_same_bytes("Key(2) 'ceg'", "'df+a'");
}

/// `|` is a bar line: songs use it to mark measures and it carries no meaning,
/// so it is skipped like whitespace, as `mml_base.pas` does.
#[test]
fn bar_lines_are_ignored() {
    assert_same_bytes("c|d|e", "cde");
    assert_same_bytes("[2 c|d]", "[2 cd]");
}

// --- 先行指定: the full family ---

/// `.onNote` on a control change writes a value a tick ahead of each note.
#[test]
fn on_note_on_a_control_change() {
    assert_golden(
        "P.onNote(0,127) cd",
        "4d546864000000060001000100604d54726b0000001c00b00a0000903c644b803c6414b00a7f01903e644\
         b803e6415ff2f00",
    );
    // A rest drives the list too, as checkNoteOnCC does in the Pascal build.
    assert_same_bytes("P.onNote(10,20) r c d", "P.onNote(10,20) r c d");
    assert_same_bytes("P.N(0,127) cd", "P.onNote(0,127) cd");
}

/// `.onCycle(len,...)` steps to the next value every `len` ticks.
#[test]
fn on_cycle_steps_with_the_clock() {
    assert_golden(
        "P.onCycle(48,10,20) cd",
        "4d546864000000060001000100604d54726b0000001c00b00a0a00903c644b803c6414b00a0a01903e644\
         b803e6415ff2f00",
    );
}

/// `.onTime` writes its whole ramp where it stands, rather than per note.
#[test]
fn on_time_writes_a_ramp_immediately() {
    assert_golden(
        "P.onTime(0,64,48) c",
        "4d546864000000060001000100604d54726b0000006800b00a0000903c6401b00a0202b00a0502b00a080\
         2b00a0a02b00a0d02b00a1002b00a1202b00a1502b00a1802b00a1a02b00a1d02b00a2002b00a2202b00a\
         2502b00a2802b00a2a02b00a2d02b00a3002b00a3202b00a3502b00a3803b00a401f803c6415ff2f00",
    );
    assert_same_bytes("P.T(0,64,48) c", "P.onTime(0,64,48) c");
}

/// `.onNoteWaveEx` scales its shape to the length of each note.
#[test]
fn on_note_wave_ex_scales_to_the_note() {
    assert_golden(
        "P.onNoteWaveEx(0,127,48) c",
        "4d546864000000060001000100604d54726b000000c800903c6400b00a0002b00a0202b00a0502b00a070\
         2b00a0a02b00a0d02b00a0f02b00a1202b00a1502b00a1702b00a1a02b00a1d02b00a1f02b00a2202b00a\
         2502b00a2702b00a2a02b00a2c02b00a2f02b00a3202b00a3402b00a3702b00a3a02b00a3c02b00a3f02b\
         00a4202b00a4402b00a4702b00a4a02b00a4c02b00a4f02b00a5202b00a5402b00a5702b00a5902b00a5c\
         02b00a5f02b00a6101803c6401b00a6402b00a6702b00a6902b00a6c02b00a6f02b00a7102b00a7402b00\
         a7702b00a7f04ff2f00",
    );
}

/// Every documented alias reaches the same implementation.
#[test]
fn modifier_aliases() {
    assert_same_bytes("P.W(0,127,96) c", "P.onNoteWave(0,127,96) c");
    assert_same_bytes("P.WE(0,127,48) c", "P.onNoteWaveEx(0,127,48) c");
    assert_same_bytes("P.WR(0,127,48) c", "P.onNoteWaveR(0,127,48) c");
    // `.C` is defined and documented upstream, but its dispatch there tests
    // the same constant twice, so the alias never matched. It works here.
    assert_same_bytes("P.C(48,10,20) cd", "P.onCycle(48,10,20) cd");
}

#[test]
fn range_clamps_and_repeat_stops_the_cycle() {
    // Range holds the values inside (10,100).
    let out = compile("P.Range(10,100) P.onNote(0,127) cd").unwrap();
    let values: Vec<u8> = out
        .smf
        .windows(3)
        .filter(|w| w[0] == 0xb0 && w[1] == 0x0a)
        .map(|w| w[2])
        .collect();
    assert!(values.iter().all(|v| (10..=100).contains(v)), "{values:?}");

    // Repeat(0) stops after the list is used up, so four notes get two values.
    let out = compile("P.Repeat(0) P.onNote(10,20) cdef").unwrap();
    let count = out
        .smf
        .windows(2)
        .filter(|w| w[0] == 0xb0 && w[1] == 0x0a)
        .count();
    assert_eq!(count, 2);
}

/// `.Frequency` changes how often a ramp writes, so a coarser one writes less.
#[test]
fn frequency_controls_how_often_a_ramp_writes() {
    let fine = compile("P.onTime(0,127,96) c").unwrap();
    let coarse = compile("P.Frequency(8) P.onTime(0,127,96) c").unwrap();
    assert!(coarse.smf.len() < fine.smf.len());
}

/// `.Max` changes what a full value means for `q` and `v`.
#[test]
fn max_rescales_gate_and_velocity() {
    assert_same_bytes("q.Max(8) q8 c", "System.qMax=8 q8 c");
    assert_same_bytes("v.Max(15) v15 c", "System.vMax=15 v15 c");
}

// --- DirectSMF and q% ---

/// `DirectSMF(...)` puts its bytes into the track verbatim, at the current time.
#[test]
fn direct_smf_writes_raw_bytes() {
    assert_golden(
        "DirectSMF(144,60,100) r",
        "4d546864000000060001000100604d54726b0000000800903c6460ff2f00",
    );
    // It lands wherever the time pointer is, between other events.
    assert_golden(
        "c DirectSMF(176,10,64) d",
        "4d546864000000060001000100604d54726b0000001800903c644b803c6415b00a4000903e644b803e641\
         5ff2f00",
    );
    // Hexadecimal arguments mean the same thing.
    assert_same_bytes("DirectSMF($90,$3C,$64) r", "DirectSMF(144,60,100) r");
}

/// `q%n` gives the gate in ticks rather than as a percentage of the note.
#[test]
fn gate_in_steps() {
    assert_golden(
        "q%10 c",
        "4d546864000000060001000100604d54726b0000000c00903c6409803c6457ff2f00",
    );
    assert_golden(
        "q%48 c",
        "4d546864000000060001000100604d54726b0000000c00903c642f803c6431ff2f00",
    );
    // The gate no longer follows the note's length…
    assert_same_bytes("l8 q%10 c", "l8 q%10 c");
    let short = compile("l8 q%10 c").unwrap();
    let long = compile("l4 q%10 c").unwrap();
    assert_eq!(short.smf[22..26], long.smf[22..26]); // same note-on and gate
                                                     // …and a plain `q` goes back to percentages.
    assert_same_bytes("q%10 q4 c", "q4 c");
}

/// A negative value may be written in hex or parenthesised, and the sign
/// belongs to the value: `p%-$2000` is the lowest bend there is.
#[test]
fn negative_values_in_any_form() {
    assert_same_bytes("p%-$2000 c", "p%-8192 c");
    assert_same_bytes("p%$1000 c", "p%4096 c");
    assert_same_bytes("System.Keyshift=-(2) c", "System.Keyshift=-2 c");
}

// --- lengths written as expressions, and multi-line argument lists ---

/// `*` introduces a length that may be an expression, so a rest can last a
/// variable number of ticks — which is how Include/bend.h delays its bends.
#[test]
fn a_length_may_be_an_expression() {
    assert_same_bytes("r*%(48) c", "r%48 c");
    assert_same_bytes("Int d=48; r*%(d) c", "r%48 c");
    // `c*3` is a third note, the same as writing the length plainly.
    assert_same_bytes("c*3", "c3");
    assert_same_bytes("c*2", "c2");
    // It ignores the current default length, as a written length does.
    assert_same_bytes("l8 c*3", "c3");
}

#[test]
fn a_loop_count_may_be_an_expression() {
    assert_same_bytes("Int i=2; [(i) c]", "[2 c]");
}

#[test]
fn an_argument_list_may_span_lines() {
    assert_same_bytes("Array a=(1,\n2,3); n((a(0)+59))", "n60");
}

/// `y` takes its value in parentheses without a comma, as 169.mml writes it.
#[test]
fn a_control_change_value_may_follow_without_a_comma() {
    assert_same_bytes("Int b=10; y0((b)) c", "y0,10 c");
}

/// A control change chosen by number may carry a modifier instead of a value.
/// 256 and 257 are the bend pseudo-controllers, which is how test_01.mml
/// writes `y256.Frequency(1)`.
#[test]
fn a_numbered_control_change_takes_modifiers() {
    assert_same_bytes("y10.onNote(0,127) cd", "P.onNote(0,127) cd");
    // Frequency only changes how often ramps write, so on its own it is silent.
    assert_same_bytes("y256.Frequency(1) c", "c");
}

// --- Cresc / Decresc ---

/// `Cresc(len,v1,v2)` — the parenthesised form only reads the length: the
/// value list is silently dropped in the Pascal build and the defaults
/// (40, 127) are used regardless. Reproduced rather than fixed, since real
/// songs never hit it — the sutoton aliases always use the `=` form below.
#[test]
fn cresc_paren_form_ignores_its_value_list() {
    assert_golden(
        "Cresc(4,100) cd",
        "4d546864000000060001000100604d54726b000000d400b00b2800903c6402b00b2902b00b2b02b00b2d0\
         2b00b2f02b00b3102b00b3202b00b3402b00b3602b00b3802b00b3a02b00b3b02b00b3d02b00b3f02b00b4\
         102b00b4302b00b4502b00b4602b00b4802b00b4a02b00b4c02b00b4e02b00b4f02b00b5102b00b5302b00\
         b5502b00b5702b00b5802b00b5a02b00b5c02b00b5e02b00b6002b00b6202b00b6302b00b6502b00b6702b\
         00b6902b00b6b01803c6401b00b6c02b00b6e02b00b7002b00b7202b00b7402b00b7502b00b7702b00b790\
         2b00b7b04b00b7f00903e644b803e6415ff2f00",
    );
    assert_same_bytes("Cresc(4,0,100) cd", "Cresc(4,100) cd");
    assert_same_bytes("Cresc(4) cd", "Cresc(4,100) cd");
}

/// `Decresc` ramps the other way (127 down to 40 by default).
#[test]
fn decresc_ramps_downward() {
    assert_golden(
        "Decresc(4,20) cd",
        "4d546864000000060001000100604d54726b000000d400b00b7f00903c6402b00b7d02b00b7b02b00b790\
         2b00b7702b00b7502b00b7402b00b7202b00b7002b00b6e02b00b6c02b00b6b02b00b6902b00b6702b00b6\
         502b00b6302b00b6202b00b6002b00b5e02b00b5c02b00b5a02b00b5802b00b5702b00b5502b00b5302b00\
         b5102b00b4f02b00b4e02b00b4c02b00b4a02b00b4802b00b4602b00b4502b00b4302b00b4102b00b3f02b\
         00b3d02b00b3b01803c6401b00b3a02b00b3802b00b3602b00b3402b00b3202b00b3102b00b2f02b00b2d0\
         2b00b2b04b00b2800903e644b803e6415ff2f00",
    );
}

/// The `=` form reads its values correctly, which is the form the sutoton
/// aliases 大きく／小さく always expand to.
#[test]
fn cresc_equals_form_reads_its_values() {
    assert_golden(
        "Cresc=4,10,20 cd",
        "4d546864000000060001000100604d54726b0000004000b00b0a00903c640ab00b0b0ab00b0c0ab00b0d0\
         ab00b0e08b00b0f0ab00b100ab00b1107803c6403b00b120ab00b1308b00b1400903e644b803e6415ff2f00",
    );
    // A missing length defaults to a whole note (timebase * 4 ticks, written
    // as a raw tick count rather than the note-value "384").
    assert_same_bytes("Cresc=,10,20 cd", "Cresc=%384,10,20 cd");
    // `!4` in length position is raw ticks (same as `%4`), not a quarter note
    // in ticks — that StrToLen reading is specific to numeric arguments like
    // Random(!4,...), not to the length grammar.
    assert_same_bytes("Cresc=!4,10,20 cd", "Cresc=%4,10,20 cd");
    // A parenthesised value list after `=` hits the same quirk as the plain
    // paren form.
    assert_same_bytes("Cresc=(4,10,20) cd", "Cresc(4,100) cd");
}

/// With a single value, the starting point is whatever Expression (CC 11)
/// was last set to — by any command, not only a previous Cresc.
#[test]
fn cresc_single_value_starts_from_the_last_expression_value() {
    assert_golden(
        "EP(60); Cresc=4,100 cd",
        "4d546864000000060001000100604d54726b000000b800b00b3c00b00b3c00903c6404b00b3d02b00b3e0\
         2b00b3f02b00b4002b00b4104b00b4202b00b4302b00b4402b00b4502b00b4604b00b4702b00b4802b00b4\
         902b00b4a02b00b4b04b00b4c02b00b4d02b00b4e02b00b4f02b00b5004b00b5102b00b5202b00b5302b00\
         b5402b00b5504b00b5602b00b5702b00b5802b00b5902b00b5a03803c6401b00b5b02b00b5c02b00b5d02b\
         00b5e02b00b5f04b00b6002b00b6102b00b6204b00b6400903e644b803e6415ff2f00",
    );
}

/// Cresc/Decresc write ahead without moving the track's time pointer, so the
/// following note starts immediately rather than after the ramp finishes.
#[test]
fn cresc_does_not_advance_the_time_pointer() {
    let with_cresc = compile("Cresc(4,100) c").unwrap();
    let without = compile("c").unwrap();
    // Same note-on/off timing either way; Cresc only adds CC events around it.
    let note_bytes = |smf: &[u8]| -> Vec<u8> {
        smf.windows(3)
            .filter(|w| w[0] & 0xf0 == 0x80 || w[0] & 0xf0 == 0x90)
            .flatten()
            .copied()
            .collect()
    };
    assert_eq!(note_bytes(&with_cresc.smf), note_bytes(&without.smf));
}

// --- PlayFrom / PlayTo ---

/// `PlayFrom(1:1:0)` — the common "start from the beginning" idiom — resolves
/// to position 0, which the Pascal build treats as a genuine no-op: the whole
/// post-process only runs when `FromPos > 0` or `ToPos > 0`.
#[test]
fn play_from_the_start_is_a_no_op() {
    assert_same_bytes("PlayFrom(1:1:0) c", "c");
}

/// A note before the cut is discarded; one that straddles or follows it is
/// kept and shifted back — by `time - fromPos + waitTime`, not simply
/// `time - fromPos`. `waitTime` defaults to 192 ticks, room for the
/// reconstructed state PlayFrom writes ahead of the first surviving note.
#[test]
fn play_from_discards_and_shifts() {
    assert_golden(
        "c PlayFrom(96) d",
        "4d546864000000060001000100604d54726b0000000d8140903e644b803e6400ff2f00",
    );
}

/// Where in the source `PlayFrom` appears makes no difference: it is applied
/// once, after the whole song is compiled, exactly as the Pascal build
/// applies it at save time rather than as the source is read.
#[test]
fn play_from_position_in_source_does_not_matter() {
    assert_same_bytes("c PlayFrom(96) d", "PlayFrom(96) c d");
}

/// A track `PlayFrom` trims to nothing is still written out, as an empty
/// MTrk — it was used, even though nothing survived the cut.
#[test]
fn play_from_can_trim_a_track_to_nothing() {
    assert_golden(
        "PlayFrom(96) c",
        "4d546864000000060001000100604d54726b0000000400ff2f00",
    );
}

/// `PlayTo` drops the trailing events at or after the cut, without touching
/// anything at the start — usable on its own, with no `PlayFrom`.
#[test]
fn play_to_trims_the_end() {
    assert_golden(
        "PlayTo(200) c d e f",
        "4d546864000000060001000100604d54726b000000198141903c644b803c6415903e644b803e64159040\
         6400ff2f00",
    );
}

/// A control change, pitch bend and tempo in effect just before the cut are
/// all reconstructed and written back in, so a note that survives still
/// sounds the way it would have without the cut.
#[test]
fn play_from_reconstructs_state_across_the_cut() {
    assert_golden(
        "y10,64 c PlayFrom(96) d",
        "4d546864000000060001000100604d54726b0000001100b00a408140903e644b803e6400ff2f00",
    );
    assert_golden(
        "p%1000 c PlayFrom(96) d",
        "4d546864000000060001000100604d54726b0000001100e068478140903e644b803e6400ff2f00",
    );
    assert_golden(
        "Tempo=140 c PlayFrom(96) d",
        "4d546864000000060001000100604d54726b0000001400ff5103068a1b8140903e644b803e6400ff2f00",
    );
}

/// `.Wait` changes the gap left for the reconstructed state — small enough
/// here that the surviving note starts before its original position.
#[test]
fn play_from_wait_option_changes_the_gap() {
    assert_golden(
        "PlayFrom.Wait(48) c d PlayFrom(96) e",
        "4d546864000000060001000100604d54726b0000001430903e644b803e64159040644b80406400ff2f00",
    );
}

// --- negative-length rests: `r-2.` rewinds the time pointer ---

/// A leading `-` on a rest's length rewinds the pointer rather than
/// advancing it — `r-2.` moves back by a dotted half note. The Pascal build
/// lets the pointer go genuinely negative; only individual event writes are
/// clamped, which is what lets a later positive-length event land at the
/// right position relative to the rewound one.
#[test]
fn a_negative_rest_length_rewinds_the_pointer() {
    assert_golden(
        "r-2.c",
        "4d546864000000060001000100604d54726b0000000c00903c6400803c6400ff2f00",
    );
    assert_golden(
        "r-8c",
        "4d546864000000060001000100604d54726b0000000c00903c641b803c6415ff2f00",
    );
}

/// `+` is accepted too, and is simply the ordinary direction: `r+2` and `r2`
/// are identical.
#[test]
fn a_leading_plus_on_a_rest_is_the_ordinary_direction() {
    assert_golden(
        "r+2 c",
        "4d546864000000060001000100604d54726b0000000d8140903c644b803c6415ff2f00",
    );
    assert_same_bytes("r+2 c", "r2 c");
}

/// `^` with no preceding note behaves like a rest, sign included.
#[test]
fn a_tie_with_no_preceding_note_accepts_a_sign_too() {
    assert_same_bytes("^-2 c", "r-2 c");
}

/// The idiom 230.mml actually uses: rewind to write an effect, then advance
/// back by the same amount before the next note.
#[test]
fn the_rewind_then_advance_idiom() {
    assert_same_bytes("cd r-1 c r*1 e", "cd r-1 c r+1 e");
}

// --- track and controller muting/editing ---

#[test]
fn track_mute_suppresses_notes_but_advances_time() {
    assert_golden(
        "c TrackMute(on) d TrackMute(off) e",
        "4d546864000000060001000100604d54726b0000001400903c644b803c64759040644b80406415ff2f00",
    );
}

#[test]
fn solo_and_mute_filter_complete_tracks() {
    assert_golden(
        "Track 1 c Track 2 e Solo(2)",
        "4d546864000000060001000100604d54726b0000000c009140644b81406415ff2f00",
    );
    assert_golden(
        "Track 1 c Track 2 e Mute(2)",
        "4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00",
    );
    assert_golden(
        "Track 1 c Track 2 e Track 3 g Solo(1,3)",
        "4d546864000000060001000200604d54726b0000000c00903c644b803c6415ff2f004d54726b0000000c009243644b82436415ff2f00",
    );
}

#[test]
fn cc_mute_suppresses_controller_writes_only() {
    assert_golden(
        "CCMute(on) y11,10 CCMute(off) y11,20 c",
        "4d546864000000060001000100604d54726b0000001000b00b1400903c644b803c6415ff2f00",
    );
    assert_same_bytes("CCMute(on) p%=100 CCMute(off) p%=200 c", "p%=200 c");
}

#[test]
fn cc_no_mute_suppresses_one_controller() {
    assert_golden(
        "CCNoMute(11,on) y11,10 y10,30 CCNoMute(11,off) y11,20 c",
        "4d546864000000060001000100604d54726b0000001400b00a1e00b00b1400903c644b803c6415ff2f00",
    );
}

#[test]
fn delete_cc_removes_reserved_events_from_the_current_time() {
    assert_golden(
        "EP.onTime(96,0,127) DeleteCC=11 c",
        "4d546864000000060001000100604d54726b0000001000b00b6000903c644b803c6415ff2f00",
    );
    assert_same_bytes("p%=100 DeleteCC=256 p%=200 c", "p%=200 c");
    assert_same_bytes("p65 DeleteCC=257 p66 c", "p66 c");
}

// --- Stretch ---

#[test]
fn stretch_scales_a_phrase_to_the_requested_length() {
    assert_golden(
        "Stretch{cdef}2",
        "4d546864000000060001000100604d54726b0000002400903c6425803c640b903e6425803e640b904064258040640b904164258041640bff2f00",
    );
    assert_golden(
        "q100 Stretch{c8d4}2",
        "4d546864000000060001000100604d54726b0000001400903c643f803c6401903e647f803e6401ff2f00",
    );
}

#[test]
fn stretch_preserves_the_legacy_explicit_rest_quirk() {
    assert_golden(
        "q100 Stretch{c r4 d}1",
        "4d546864000000060001000100604d54726b0000001400903c647f803c6461903e647f803e6421ff2f00",
    );
}

#[test]
fn stretch_accepts_a_parenthesized_raw_tick_length() {
    assert_golden(
        "q100 Stretch{c}(%48) d",
        "4d546864000000060001000100604d54726b0000001400903c642f803c6401903e645f803e6401ff2f00",
    );
}

#[test]
fn stretch_leaves_the_pointer_at_the_requested_end() {
    assert_golden(
        "q100 Stretch{cde}4 c",
        "4d546864000000060001000100604d54726b0000002400903c641f803c6401903e641f803e64019040641f80406401903c645f803c6401ff2f00",
    );
}

#[test]
fn stretch_uses_state_changes_from_its_measurement_pass() {
    assert_golden(
        "o4 q100 Stretch{o5 c}2 c",
        "4d546864000000060001000100604d54726b0000001500903c64813f803c6401903c645f803c6401ff2f00",
    );
}

#[test]
fn nested_stretch_matches_pascal_rounding() {
    assert_golden(
        "q100 Stretch{Stretch{cd}4 ef}2",
        "4d546864000000060001000100604d54726b0000002400903c6447803c6401903e64189040642f803e6410804064019041643f80416400ff2f00",
    );
    assert_golden(
        "q100 Stretch{c^c}1",
        "4d546864000000060001000100604d54726b0000001500903c64817f803c6401903c647f803c6401ff2f00",
    );
    assert_golden(
        "q100 Stretch{'ceg'4 c}4",
        "4d546864000000060001000100604d54726b0000002400903c6400904064009043642f803c64008040640080436401903c642f803c6401ff2f00",
    );
}

// ---------------------------------------------------------------
// Join operators (^, +, -) in Stretch, Cresc, and chord lengths
// ---------------------------------------------------------------
// PR #37 review: Stretch, Cresc, and chords did not consume
// leading or trailing ^/+/- operators via extend_default_length_joins.

#[test]
fn stretch_consumes_trailing_join_operator() {
    // `Stretch{c}^` — the `^` adds one default length (quarter note) to the
    // implicit quarter-note target, giving a half-note (192 ticks) target.
    assert_golden(
        "q100 Stretch{c}^",
        "4d546864000000060001000100604d54726b0000000d00903c64813f803c6401ff2f00",
    );
    // `Stretch{c}4^8` — explicit quarter + eighth = 144 ticks.
    assert_golden(
        "q100 Stretch{c}4^8",
        "4d546864000000060001000100604d54726b0000000d00903c64810f803c6401ff2f00",
    );
}

#[test]
fn chord_consumes_plus_and_minus_join_operators() {
    // `'ceg'+8` — default quarter + eighth = 144 ticks.
    assert_golden(
        "q100 'ceg'+8",
        "4d546864000000060001000100604d54726b0000001d00903c640090406400904364810f803c64008040640080436401ff2f00",
    );
    // `'ceg'4-8` — quarter minus eighth = 48 ticks.
    assert_golden(
        "q100 'ceg'4-8",
        "4d546864000000060001000100604d54726b0000001c00903c6400904064009043642f803c64008040640080436401ff2f00",
    );
}
