//! The scripting layer: variables, expressions, control flow and functions.
//!
//! Most assertions compare a script against the plain MML it should be
//! equivalent to, which says what the script *means* rather than restating a
//! byte string. A few cases are pinned to bytes captured from the Pascal
//! build, and the semantics of every case here was checked against it.

use sakuramml_core::{compile, MemoryIncludes};

/// Compiling `script` must produce exactly what `equivalent` produces.
#[track_caller]
fn assert_same(script: &str, equivalent: &str) {
    let actual = compile(script).unwrap_or_else(|e| panic!("failed to compile {script:?}: {e}"));
    let expected =
        compile(equivalent).unwrap_or_else(|e| panic!("failed to compile {equivalent:?}: {e}"));
    assert_eq!(
        hex(&actual.smf),
        hex(&expected.smf),
        "\n  script:     {script:?}\n  equivalent: {equivalent:?}"
    );
}

#[track_caller]
fn assert_error_contains(script: &str, needle: &str) {
    let error = compile(script)
        .err()
        .unwrap_or_else(|| panic!("expected {script:?} to fail"));
    assert!(
        error.message.contains(needle),
        "expected error about {needle:?}, got: {}",
        error.message
    );
}

fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

fn from_hex(s: &str) -> Vec<u8> {
    let s: String = s.chars().filter(|c| !c.is_whitespace()).collect();
    (0..s.len())
        .step_by(2)
        .map(|i| u8::from_str_radix(&s[i..i + 2], 16).unwrap())
        .collect()
}

// --- variables -------------------------------------------------------------

#[test]
fn int_declaration_and_use() {
    assert_same("Int x=60; n(x)", "n60");
    assert_same("Int x; n((x+60))", "n60");
    assert_same("Int x=5; o(x) c", "o5 c");
}

#[test]
fn assignment_updates_a_variable() {
    assert_same("Int x=60; x=(x+2); n(x)", "n62");
    assert_same("Int x=1; Int y=2; x=(y); n((x+60))", "n62");
}

#[test]
fn assignment_to_a_variable_wins_over_a_builtin_with_the_same_name() {
    assert_same("Int KEY=2; KEY=3; n((60+KEY))", "n63");
}

#[test]
fn comment_after_an_assignment_is_not_parsed_as_division() {
    assert_same("#KEY_C={KEY=0;} // comment\n#KEY_C c", "Key=0; c");
    assert_same("Int I=8; I=I / 2; n((60+I))", "n64");
}

#[test]
fn string_variables() {
    assert_same(
        r#"Str s={"タイトル"}; TrackName=s; c"#,
        r#"TrackName={"タイトル"} c"#,
    );
    assert_same(
        r#"Str a={"あ"}; Str b=(a+"い"); TrackName=b; c"#,
        r#"TrackName={"あい"} c"#,
    );
}

#[test]
fn string_replace_method_updates_an_mml_template() {
    assert_same(
        "Str COMMAND={cLEN}; Str LENGTH={4}; COMMAND.s({LEN},LENGTH); COMMAND",
        "c4",
    );
}

#[test]
fn string_assignment_concatenates_a_bare_expression() {
    assert_same(
        "Str I={!1}; I=I+{^1}; TrackName=I; c",
        "TrackName={!1^1}; c",
    );
}

#[test]
fn meta_text_accepts_legacy_unquoted_braces() {
    assert_same(r#"Lyric{A-melo} c"#, r#"Lyric={"A-melo"} c"#);
}

#[test]
fn arrays_declare_and_index() {
    assert_same("Array a=(60,64,67); n(a(0)) n(a(1)) n(a(2))", "n60 n64 n67");
    assert_same("Array a=(1,2); n((a(0)+a(1)+57))", "n60");
}

#[test]
fn array_index_out_of_range_is_an_error() {
    assert_error_contains("Array a=(60); n(a(5))", "範囲外");
}

#[test]
fn undefined_variable_is_an_error() {
    assert_error_contains("n(nope)", "未定義");
}

// --- expressions -----------------------------------------------------------

#[test]
fn arithmetic_precedence() {
    assert_same("n((2+3*4+46))", "n60");
    assert_same("n(((2+3)*12))", "n60");
    assert_same("n((120/2))", "n60");
    assert_same("n((121%61))", "n60");
    assert_same("n((-1+61))", "n60");
}

#[test]
fn comparisons_and_logic() {
    assert_same("If(1==1){c}Else{d}", "c");
    assert_same("If(1!=1){c}Else{d}", "d");
    assert_same("If(2>1){c}Else{d}", "c");
    assert_same("If(2<=1){c}Else{d}", "d");
    assert_same("If(1&&0){c}Else{d}", "d");
    assert_same("If(1||0){c}Else{d}", "c");
    assert_same("If(!0){c}Else{d}", "c");
    assert_same("If(on){c}Else{d}", "c");
    assert_same("If(off){c}Else{d}", "d");
}

#[test]
fn strings_compare_as_strings() {
    assert_same(r#"Str s={"ab"}; If(s=="ab"){c}Else{d}"#, "c");
    assert_same(r#"Str s={"ab"}; If(s=="zz"){c}Else{d}"#, "d");
}

/// Bare expressions are rejected — the Pascal build rejects them too, and the
/// rule is what keeps `v100 <c` meaning "velocity, then octave down".
#[test]
fn expressions_need_parentheses() {
    // The message differs from the Pascal build's, but both reject it.
    assert!(compile("Tempo=100+20 c").is_err());
    assert!(compile("Int x=5; ox c").is_err());
    assert_same("v100 <c", "v100 o4 c");
}

#[test]
fn division_by_zero_is_an_error_not_a_panic() {
    assert_error_contains("n((1/0))", "0で割る");
    assert_error_contains("n((1%0))", "0で割る");
}

#[test]
fn integer_overflow_is_an_error_not_a_panic() {
    assert_error_contains("Print((9223372036854775807+1))", "範囲");
    assert_error_contains("Print(((-9223372036854775807-1)/-1))", "範囲");
}

#[test]
fn malformed_delimiters_and_trailing_expression_text_are_errors() {
    assert_error_contains("Voice(1 c", "括弧");
    assert_error_contains("TrackName={\"x\" c", "閉じられていません");
    assert_error_contains("c(4,80,100", "括弧");
    assert_error_contains("Print(Random(1,2)", "括弧");
    assert_error_contains("If(1 xyz){c}", "式の末尾");
}

// --- control flow ----------------------------------------------------------

#[test]
fn if_else_branches() {
    assert_same("Int x=1; If(x==1){c}Else{d}", "c");
    assert_same("Int x=0; If(x==1){c}Else{d}", "d");
    // An If with no Else and a false condition emits nothing.
    assert_same("Int x=0; If(x==1){c} d", "d");
}

#[test]
fn nested_if() {
    assert_same("Int x=1; If(x==1){If(x>0){c}Else{d}}Else{e}", "c");
    assert_same("Int x=1; If(x==2){c}Else{If(x==1){d}Else{e}}", "d");
}

#[test]
fn for_loop_runs_its_body() {
    assert_same("Int i; For(i=0;i<3;i=i+1){c}", "c c c");
    assert_same("Int i; For(i=0;i<3;i=i+1){n((60+i))}", "n60 n61 n62");
}

#[test]
fn for_loop_with_a_false_condition_never_runs() {
    assert_same("Int i; For(i=0;i<0;i=i+1){c} d", "d");
}

#[test]
fn while_loop_runs_its_body() {
    assert_same("Int i=0; While(i<3){c;i=(i+1)}", "c c c");
    assert_same("Int i=5; While(i<3){c} d", "d");
}

#[test]
fn exit_leaves_the_enclosing_loop() {
    assert_same("Int i=0; While(i<3){c;Exit;i=(i+1)}", "c");
    assert_same("Int i; For(i=0;i<3;i=i+1){c;Exit}", "c");
}

#[test]
fn exit_returns_from_a_function_without_stopping_the_song() {
    assert_same("Function f(){c;Exit;d} f e", "c e");
}

#[test]
fn exit_leaves_a_repeat_loop() {
    assert_same("[4 c Exit d] e", "c e");
}

/// A runaway loop must fail rather than hang: a frozen browser tab is worse
/// than an error message.
#[test]
fn runaway_loops_error_instead_of_hanging() {
    assert_error_contains("Int i=0; While(i>=0){i=(i+1)}", "繰り返し");
    assert_error_contains("Int i; For(i=0;i>=0;i=i+1){}", "繰り返し");
}

#[test]
fn loops_and_repeats_nest() {
    assert_same("Int i; For(i=0;i<2;i=i+1){[2 c]}", "c c c c");
    assert_same("[2 Int i; For(i=0;i<2;i=i+1){c}]", "c c c c");
}

// --- functions -------------------------------------------------------------

#[test]
fn function_without_arguments() {
    // Both call forms work, and match the Pascal build's bytes.
    let expected = from_hex("4d546864000000060001000100604d54726b0000000c00903c644b803c6415ff2f00");
    assert_eq!(compile("Function f(){c} f").unwrap().smf, expected);
    assert_eq!(compile("Function f(){c} f()").unwrap().smf, expected);
}

/// A definition overrides the built-in meaning of its name, so `f` is a call
/// rather than the note F. The Pascal build overwrites its command table the
/// same way.
#[test]
fn function_name_shadows_a_note_letter() {
    assert_same("Function f(){c} f", "c");
    assert_same("Function e(){n60} e e", "n60 n60");
}

#[test]
fn function_arguments() {
    assert_same("Function f(Int x){n(x)} f(60)", "n60");
    assert_same("Function f(Int a,Int b){n(a) n(b)} f(60,64)", "n60 n64");
    assert_same("Function f(Int a,Int b){n((a+b))} f(20,40)", "n60");
}

#[test]
fn string_parameter_accepts_raw_mml() {
    assert_same("Function f(Str S){S} f(cde)", "cde");
    assert_same("Function f(Str S){S} f(ドレミ)", "cde");
    assert_same("Function f(Str S){S} f(c4,80,100)", "c4,80,100");
    assert_same("Function f(Str S, Int N){S n(N)} f(c,62)", "c n62");
}

#[test]
fn numeric_function_parameter_accepts_a_joined_length() {
    assert_same("Function F(L){r%(L)c} F(!1^1)", "r%768 c");
}

#[test]
fn function_argument_defaults() {
    let expected = from_hex("4d546864000000060001000100604d54726b0000000c00903e644b803e6415ff2f00");
    assert_eq!(
        compile("Function f(Int x=62){n(x)} f").unwrap().smf,
        expected
    );
    // An explicit argument wins over the default.
    assert_same("Function f(Int x=62){n(x)} f(60)", "n60");
    // A later parameter may default while an earlier one is given.
    assert_same("Function f(Int a,Int b=64){n(a) n(b)} f(60)", "n60 n64");
}

/// An argument the caller leaves out is 0, not an error — the Pascal build
/// accepts `f(1)` for a two-parameter function, and `Include/bend.h` calls
/// its own helpers that way.
#[test]
fn a_missing_argument_defaults_to_zero() {
    assert_same("Function f(A,B){n((60+B))} f(1)", "n60");
    assert_same("Function f(A,B){n((60+A))} f()", "n60");
    // A declared default still wins over the zero.
    assert_same("Function f(A,B=5){n((60+B))} f(1)", "n65");
}

#[test]
fn result_returns_a_value() {
    assert_same("Function f(){Result=60} n(f())", "n60");
    assert_same("Function f(Int x){Result=(x*2)} n(f(30))", "n60");
    assert_same("Function f(){Result=1} If(f()==1){c}Else{d}", "c");
}

#[test]
fn function_without_result_cannot_be_used_as_a_value() {
    assert_error_contains("Function f(){c} n(f())", "値を返しません");
}

#[test]
fn functions_call_other_functions() {
    assert_same("Function g(){e} Function f(){c g} f", "c e");
    assert_same(
        "Function g(Int x){Result=(x+1)} Function f(){Result=(g(59))} n(f())",
        "n60",
    );
}

#[test]
fn recursion_works() {
    // fib(10) = 55, so this is n95. Byte-identical to the Pascal build.
    let expected = from_hex("4d546864000000060001000100604d54726b0000000c00905f644b805f6415ff2f00");
    let script = "Function fib(Int n){If(n<2){Result=n}Else{Result=(fib(n-1)+fib(n-2))}} \
                  n((fib(10)+40))";
    assert_eq!(compile(script).unwrap().smf, expected);
}

/// Deep recursion must produce an error, not a stack overflow — under WASM an
/// overflow would take down the whole instance.
#[test]
fn runaway_recursion_errors_instead_of_overflowing() {
    assert_error_contains("Function f(){f} f", "ネスト");
}

#[test]
fn functions_see_and_change_globals() {
    assert_same("Int x=60; Function f(){n(x)} f", "n60");
    assert_same("Int x=0; Function f(){x=60} f n(x)", "n60");
}

/// A parameter shadows a global of the same name only while the call runs.
#[test]
fn parameters_shadow_globals_only_during_the_call() {
    assert_same(
        "Int x=99; Function f(Int x){n(x)} f(60) n((x-39))",
        "n60 n60",
    );
}

#[test]
fn functions_work_inside_loops_and_conditionals() {
    assert_same("Function f(){c} [3 f]", "c c c");
    assert_same("Int i; Function f(){c} For(i=0;i<2;i=i+1){f}", "c c");
    assert_same("Function f(){c} If(1==1){f}Else{d}", "c");
}

/// An unknown name is an error. (A name starting with a note letter is
/// reported against that command instead — the Pascal build does the same,
/// since `nosuch(1)` parses as the note-number command `n`.)
#[test]
fn calling_an_undefined_function_is_an_error() {
    assert_error_contains("Zzz(1)", "未定義");
    assert!(compile("nosuch(1)").is_err());
}

#[test]
fn functions_may_be_defined_in_an_include_file() {
    use sakuramml_core::compile_with;

    let includes =
        MemoryIncludes::new().with("lib.h", "Function middle_c(){n60}".as_bytes().to_vec());
    let out = compile_with("Include(lib.h) middle_c", &includes).unwrap();
    assert_eq!(out.smf, compile("n60").unwrap().smf);
}

// --- Print -----------------------------------------------------------------

#[test]
fn print_returns_messages_as_data() {
    let out = compile("Print((1+2)) c").unwrap();
    assert_eq!(out.messages, vec!["3".to_string()]);

    let out = compile(r#"Str s={"やあ"}; Print(s) c"#).unwrap();
    assert_eq!(out.messages, vec!["やあ".to_string()]);

    let out = compile("Int i; For(i=0;i<3;i=i+1){Print((i))}").unwrap();
    assert_eq!(out.messages, vec!["0", "1", "2"]);
}

// --- Japanese notation interop ---------------------------------------------

#[test]
fn scripts_work_with_sutoton_notation() {
    assert_same("Int i; For(i=0;i<2;i=i+1){ドレミ}", "cde cde");
    assert_same("Function f(){ドレミ} f", "cde");
    assert_same("テンポ120 Int x=60; n(x)", "Tempo=120 n60");
}

// --- built-in variables and the `=` argument form ---

/// `SoundType` is a built-in variable (mml_base.pas registers it, along with
/// `on` and `off`); assigning to an *undeclared* name stays an error, as it is
/// in the Pascal build.
#[test]
fn builtin_variables() {
    assert_same("SoundType=0; c", "c");
    assert_same("If(SoundType==0){c}Else{d}", "c");
    assert_same("SoundType=1; If(SoundType==1){c}Else{d}", "c");
    assert_same("SoundType=2; If(SoundType==2){c}Else{d}", "c");
    assert!(compile("undeclared=5; c").is_err());
}

/// After `=`, a named command takes a term — a variable or a call — but not a
/// compound expression. The single-letter note attributes take neither, which
/// is what keeps `v100 <c` meaning "velocity, then octave down".
#[test]
fn equals_form_accepts_a_variable_but_not_an_expression() {
    assert_same("Int x=5; Tempo=x c", "Tempo=5 c");
    assert_same("Int vo=5; Voice=vo c", "@5 c");
    assert_same("Int x=60; n=x", "n60");

    assert!(compile("Tempo=100+20 c").is_err());
    assert!(compile("Int x=5; o=x c").is_err()); // `o` has no `=` form
    assert!(compile("Int x=5; ox c").is_err());
    assert_same("v100 <c", "v100 o4 c");
}

// --- built-in functions ---

#[test]
fn random_stays_within_its_range() {
    // A single-value range is deterministic, so this pins an exact result.
    assert_same("Tempo=Random(120,120) c", "Tempo=120 c");
    assert_same("n(Random(60,60))", "n60");

    // Over a real range, every draw must still land inside it.
    for _ in 0..20 {
        let out = compile("Int x; x=(Random(90,130)); Print((x))").unwrap();
        let value: i64 = out.messages[0].parse().unwrap();
        assert!((90..=130).contains(&value), "out of range: {value}");
    }
}

/// Compiles are reproducible: the generator is seeded, not drawn from the OS,
/// which also means WASM needs no randomness plumbing.
#[test]
fn random_is_reproducible_across_compiles() {
    let script = "Int i; For(i=0;i<5;i=i+1){Print((Random(0,1000)))}";
    let first = compile(script).unwrap().messages;
    let second = compile(script).unwrap().messages;
    assert_eq!(first, second);
}

#[test]
fn random_seed_changes_the_sequence() {
    let with_seed = |seed: i64| {
        compile(&format!(
            "System.RandomSeed={seed}; Int i; For(i=0;i<5;i=i+1){{Print((Random(0,1000)))}}"
        ))
        .unwrap()
        .messages
    };
    assert_eq!(with_seed(1), with_seed(1));
    assert_ne!(with_seed(1), with_seed(2));
}

#[test]
fn random_select_picks_one_of_its_arguments() {
    for _ in 0..20 {
        let out = compile("Print((RandomSelect(10,20,30)))").unwrap();
        assert!(["10", "20", "30"].contains(&out.messages[0].as_str()));
    }
}

#[test]
fn size_of_and_string_functions() {
    let out = compile(r#"Array a=(1,2,3); Print((SizeOf(a))) Print((HEX(255))) Print((CHR(65)))"#)
        .unwrap();
    assert_eq!(out.messages, vec!["3", "$FF", "A"]);

    let out = compile(r#"Print((ASC({"A"})))"#).unwrap();
    assert_eq!(out.messages, vec!["65"]);
}

#[test]
fn mid_uses_legacy_one_based_character_positions() {
    let out = compile(
        r#"Print(MID({cdefg},1,3)) Print(MID({cdefg},0,2)) Print(MID({cdefg},6,2)) Print(MID({あいう},2,1))"#,
    )
    .unwrap();
    assert_eq!(out.messages, vec!["cde", "c", "", "い"]);
}

#[test]
fn pos_and_posx_return_one_based_character_positions() {
    let out = compile(
        r#"Print(POS({cd},{abcdef})) Print(POS({xx},{abcdef})) Print(POSX({a},{banana},3)) Print(POS({い},{あいう}))"#,
    )
    .unwrap();
    assert_eq!(out.messages, vec!["3", "0", "4", "2"]);
}

#[test]
fn replace_can_change_the_first_or_every_match() {
    let out = compile(
        r#"Print(Replace({eye},{e},{s},on)) Print(Replace({eye},{e},{s},off)) Print(Replace({abc},{},{x},on))"#,
    )
    .unwrap();
    assert_eq!(out.messages, vec!["sys", "sye", "abc"]);
}

#[test]
fn type_and_array_sort_functions_match_pascal() {
    let out = compile(
        r#"
        Int I=1 Str T={x}
        Array N=(30,20,10,0,1,2,3,4,5)
        Array S=({mml},{panda},{dragon},{zzz})
        Print(VarType(I)) Print(VarType(T)) Print(VarType(N))
        Print(ArraySortNum(N)) Print(ArraySortStr(S)) Print(S(1))
        "#,
    )
    .unwrap();
    assert_eq!(
        out.messages,
        vec![
            "Int",
            "Str",
            "Array",
            "0, 1, 2, 3, 4, 5, 10, 20, 30",
            "dragon, mml, panda, zzz",
            "panda",
        ]
    );
}

#[test]
fn legacy_number_size_and_hex_conversions() {
    let out = compile(
        r#"Int I=1 Array A=(127,0,50,100,11) Print(SizeOf(I)) Print(StrToNum({123})) Print(StrToNum({$10})) Print(HEX(A))"#,
    )
    .unwrap();
    assert_eq!(
        out.messages,
        vec!["4", "123", "16", "$7F, $00, $32, $64, $0B"]
    );
}

#[test]
fn array_sort_functions_validate_their_argument() {
    assert_error_contains("Print(ArraySortNum({x}))", "配列");
    assert_error_contains("Array A=() Print(ArraySortStr(A))", "空でない配列");
}

/// `StrToLen(4)` is a quarter note in ticks — 96 at the default timebase.
#[test]
fn str_to_len_converts_note_lengths_to_ticks() {
    let out = compile("Print((StrToLen(4))) Print((StrToLen(8)))").unwrap();
    assert_eq!(out.messages, vec!["96", "48"]);
}

#[test]
fn time_function_returns_ticks_without_moving_the_pointer() {
    assert_same("Int start=Time(2:1:0); Time(start); c", "Time(384) c");
    assert_same(
        "TimeSignature=3,4; Int start=Time(2:1:0); Time(start); c",
        "TimeSignature=3,4; Time(288) c",
    );
    assert_same("Int start=Time(96); n((start-36))", "n60");
}

#[test]
fn a_user_function_overrides_a_built_in_one() {
    assert_same(
        "Function Random(Int a,Int b){Result=60} n(Random(1,2))",
        "n60",
    );
}

// --- the standard include ---

/// `stdmsg.h` is loaded before the song, the way `TMml2Smf.Execute` does it in
/// the Pascal build. That is where the GM instrument names come from, so
/// `@(GrandPiano)` works without the song asking for anything.
#[test]
fn standard_include_is_loaded_automatically() {
    use sakuramml_core::compile_with;

    let includes = MemoryIncludes::new().with(
        "stdmsg.h",
        "Int GrandPiano = 1; Function Middle(){n60}"
            .as_bytes()
            .to_vec(),
    );

    let out = compile_with("@(GrandPiano) c", &includes).unwrap();
    assert_eq!(out.smf, compile("@1 c").unwrap().smf);

    // Its functions are available too.
    let out = compile_with("Middle", &includes).unwrap();
    assert_eq!(out.smf, compile("n60").unwrap().smf);
}

#[test]
fn standard_include_rpn_wrappers_accept_a_parenthesised_parameter() {
    use sakuramml_core::compile_with;

    let includes = MemoryIncludes::new().with(
        "stdmsg.h",
        "Function BR(mm){RPN=0,0,(mm)}".as_bytes().to_vec(),
    );

    let out = compile_with("BR(12)", &includes).unwrap();
    assert_eq!(out.smf, compile("RPN(0,0,12)").unwrap().smf);
}

/// A missing standard include is a warning, not a failure — the Pascal build
/// prints a hint and carries on the same way.
#[test]
fn a_missing_standard_include_only_warns() {
    let out = compile("c").unwrap();
    assert!(
        out.warnings.iter().any(|w| w.message.contains("stdmsg.h")),
        "expected a hint about stdmsg.h, got {:?}",
        out.warnings
    );
}

/// A parenthesised value inside a hex-mode SysEx is an ordinary expression,
/// which is how stdmsg.h writes its GS reset:
/// `SysEx$=F0,41,(DeviceNumber),42,...`
#[test]
fn hex_sysex_accepts_parenthesised_values() {
    let by_hand = compile("Int D=$10; SysEx$=F0,41,(D),42,12,40,00,7F,00,41,F7;").unwrap();
    let builtin = compile("ResetGS").unwrap();
    assert_eq!(by_hand.smf, builtin.smf);
}

// --- increment and decrement ---

/// `I++` and `I--` step a variable by one.
#[test]
fn increment_and_decrement() {
    assert_same("Int I=0; I++; n((60+I))", "n61");
    assert_same("Int I=5; I--; n((60+I))", "n64");
    assert_same("Int I=0; I++; I++; n((60+I))", "n62");
    // The same thing written out longhand.
    assert_same("Int I=0; I++; n((60+I))", "Int I=0; I=I+1; n((60+I))");
}

/// A `For` loop can step its counter with `++`.
#[test]
fn a_for_loop_can_increment_with_plus_plus() {
    assert_same("Int i; For(i=0;i<3;i++){c}", "c c c");
}

// --- NoteNo, MML, and negative values ---

/// `NoteNo(...)` reads MML the way the compiler would and gives back the
/// number, without playing anything.
#[test]
fn note_no_reads_a_note_without_playing_it() {
    assert_same("Int x=NoteNo(o4c); n(x)", "n48");
    // With no octave of its own it uses the track's.
    assert_same("Int x=NoteNo(c); n(x)", "n60");
    assert_same("o3 Int x=NoteNo(c); n(x)", "o3 n36");
    assert_same("Int x=NoteNo(o4c+); n(x)", "n49");
    assert_same("Int x=NoteNo(n70); n(x)", "n70");
}

/// `MML(...)` reports what a command is currently set to.
#[test]
fn mml_reports_the_current_setting() {
    assert_same("v100 Int x=MML(v); n(x)", "n100");
    assert_same("o4 Int x=MML(o); n((x+56))", "n60");
    // q50 is still in effect for the note itself, so compare like for like.
    assert_same("q50 Int x=MML(q); n((x+10))", "q50 n60");
    assert_same("@5 Int x=MML(@); n((x+55))", "@5 n60");
    // A length comes back in ticks, so l8 is 48 at the default timebase.
    assert_same("l8 Int x=MML(l); n((x+12))", "l8 n60");
    assert_same("y11,42 Int x=MML(y11); n((x+18))", "y11,42 n60");
}

/// Defaults and state changes match values measured from Pascal v2.385.
#[test]
fn mml_reports_legacy_track_state() {
    let out = compile(
        "Print(MML(@)) Print(MML(BR)) Print(MML(p%)) Print(MML(p)) Print(MML(Key)) \
         Print(MML(TimeKey)) Print(MML(TimeKey2)) Print(MML(Port)) Print(MML(y11))",
    )
    .unwrap();
    assert_eq!(
        out.messages,
        ["0", "2", "-1", "-1", "0", "0", "0", "0", "0"]
    );

    let out = compile(
        "@5 RPN(0,0,12) p%=123 Key=4 TimeKey(,,3) TimeKey2(,,2) Port(7) y11,42 \
         Print(MML(@)) Print(MML(BR)) Print(MML(p%)) Print(MML(p)) Print(MML(Key)) \
         Print(MML(TimeKey)) Print(MML(TimeKey2)) Print(MML(Port)) Print(MML(y11))",
    )
    .unwrap();
    assert_eq!(
        out.messages,
        ["5", "12", "123", "64", "4", "3", "2", "7", "42"]
    );
}

#[test]
fn time_key_queries_follow_the_current_track_time() {
    let out = compile(
        "TimeKey((1:2:0),(1:3:0),3) Print(MML(TimeKey)) \
         Time(1:2:0) Print(MML(TimeKey)) c Time(1:3:0) Print(MML(TimeKey)) c",
    )
    .unwrap();
    assert_eq!(out.messages, ["0", "3", "0"]);
    assert_eq!(
        out.smf,
        compile("Time(1:2:0) n63 Time(1:3:0) n60").unwrap().smf
    );
}

#[test]
fn numeric_notes_apply_time_key_transposition() {
    assert_same("TimeKey(,,3) TimeKey2(,,2) n60", "n65");
}

#[test]
fn overflowing_note_transposition_is_an_error_not_a_panic() {
    assert_error_contains("TimeKey(,,1) n(9223372036854775807)", "ノート番号が範囲外");
    assert_error_contains(
        "TimeKey(,,9223372036854775807) TimeKey2(,,1) n60",
        "ノート番号が範囲外",
    );
}

#[test]
fn print_time_and_track_return_pascal_style_messages() {
    let out = compile("Track=1 c4 Track=2 l8 d PrintTime(1) PrintTime PrintTrack(1)").unwrap();
    assert_eq!(
        out.messages,
        [
            "Track(1);Time(1:2:0);//=96(PrintTime)",
            "Track(2);Time(1:1:48);//=48(PrintTime)",
            "Track(1) Channel(1) Voice(0) Time(1:2:0) Time=96",
            "l%96(n分音符モード) q80(％指定モード) v100 t0 o5 ",
            "Slur(0,12) BR(2) PitchBend(-1)",
            "イベント数=1 TrackMute(off) ",
        ]
    );
}

#[test]
fn print_time_accounts_for_measure_shift() {
    let out = compile("System.MeasureShift(1) Time(1:1:0) PrintTime").unwrap();
    assert_eq!(out.messages, ["Track(0);Time(1:1:0);//=384(PrintTime)"]);
}

#[test]
fn track_diagnostics_reject_unrepresentable_time_signatures_without_panicking() {
    assert_error_contains("TimeSignature=4,1024 PrintTime", "表現できません");
    assert_error_contains(
        "TimeSignature=4,16 System.TimeBase=1 PrintTime",
        "表現できません",
    );
}

#[test]
fn track_information_rejects_invalid_tracks_without_panicking() {
    assert_error_contains("PrintTime(-1)", "トラック番号が不正");
    assert_error_contains("PrintTrack(99)", "トラック番号が不正");
    assert_error_contains("Port(-1)", "0〜255");
}

#[test]
fn an_unknown_mml_query_is_an_error() {
    assert_error_contains("Int x=MML(nope); c", "取得できません");
}

/// A `For` clause may declare its own counter.
#[test]
fn a_for_loop_can_declare_its_counter() {
    assert_same("For(Int J=0;J<2;J=J+1){c}", "c c");
    assert_same("For(Int J=0;J<3;J++){n((60+J))}", "n60 n61 n62");
}

/// A definition wins over the built-in meaning of its name, for commands as
/// well as note letters: `Str S={"c"}` makes a later `S` the variable rather
/// than the `Sub` alias.
#[test]
fn a_definition_shadows_a_command_name() {
    assert_same(r#"Str S={"c"}; S"#, "c");
    assert_same(r#"Str P={"c"}; P"#, "c");
    assert_same("Function S(){n60} S", "n60");
    // Without a definition in the way, the commands still work.
    assert_same("Sub{c} d", "Sub{c} d");
}

#[test]
fn stretch_rejects_a_zero_length_phrase() {
    assert_error_contains("Stretch{}4", "長さが0");
    assert_error_contains("Stretch{TrackName={\"x\"}}4", "長さが0");
}
