# SakuraMML Command Reference (Rust Implementation)

This document lists the commands actually accepted by the Rust implementation (`src/rust/`).
For the full official specification, see `spec/`. For the complete list of command names from the legacy (Pascal) version, see `spec/12-legacy-command-table.md`.

## Table of Contents

- [Basic Rules](#basic-rules)
- [Notes and Rests](#notes-and-rests)
- [Note Attributes](#note-attributes)
- [Structures (Chords, Tuplets, Repeats, and Simultaneous Writing)](#structures-chords-tuplets-repeats-and-simultaneous-writing)
- [Key and Transposition](#key-and-transposition)
- [Tracks, Channels, and Time](#tracks-channels-and-time)
- [Tempo](#tempo)
- [Voices and MIDI Control](#voices-and-midi-control)
- [Advance Specifications (`.onNote`, etc.)](#advance-specifications-onnote-etc)
- [Meta Events](#meta-events)
- [System Settings](#system-settings)
- [Scripting](#scripting)
- [Built-in Functions and Values](#built-in-functions-and-values)
- [Macros, Sutoton, and Include](#macros-sutoton-and-include)

## Basic Rules

### Separators and Comments

```mml
Tempo=120; o5 l8; c d e f     // ; spaces and line breaks act as separators
// Comment to end of line
/* Multi-line comment */
```

### Numbers

| Format | Meaning |
|---|---|
| `123` | Decimal integer (negative values allowed) |
| `$F0` | Hexadecimal integer |

Expressions are evaluated as signed 64-bit integers. Integer overflow is treated as an error.

### Lowercase Commands and Uppercase Commands

Single-letter lowercase commands (note attributes `v` `q` `o` `t`) and word commands beginning with an uppercase letter (`Tempo`, `Voice`, etc.) accept arguments differently.

**Lowercase commands (`v q o t`)** — “set or adjust” the current track state:

| Form | Example | Behavior |
|---|---|---|
| Direct | `v100` | Sets an absolute value |
| Relative | `v+` `v-` `q+++` | Increases/decreases the current value by the default increment (v=8, q=10, o and t=1; configurable via `System.vAdd`, etc.) |
| Relative with amount | `v+10` `t-5` | Adds/subtracts the specified amount from the current value |
| Parenthesized | `v(x)` `v(1+2)` | Evaluates the contents as a full expression |
| `=` | `v=100` | Accepts only numbers, `$hex`, or `!n`. **Variables and function calls are not allowed** (`v=x` is an error; use `v(x)`) |

**Uppercase commands (`Tempo`, `Voice`, `Track`, etc.)** — assign a value:

| Form | Example | Behavior |
|---|---|---|
| `=` | `Tempo=120` `Voice=Piano` `Tempo=Random(90,130)` | The right-hand side must be a **single value, variable, or function call**. Compound expressions are not allowed (`Tempo=100+20` is an error) |
| Parenthesized | `Tempo(100+20)` | Evaluates the contents as a full expression |
| Direct | `Tempo 120` | A value may be placed directly after the command. However, `Tempo120` is interpreted as a different command name and causes an error |
| Relative | — | Relative `+` / `-` syntax is **not supported** (`Tempo+5` is an error) |

In summary:

- Only lowercase commands support relative updates from the current value, such as `v+`.
- Only uppercase commands may use variables and function calls on the right-hand side of `=`. For lowercase commands, use parentheses such as `v(x)`.

### Three Argument Forms

| Form | Example | Notes |
|---|---|---|
| Direct | `v100`, `o5`, `l8` | Integer or note length |
| Parenthesized | `Tempo(60+60)`, `o(x)` | Expressions can be evaluated inside parentheses |
| Assignment | `Tempo=120`, `Voice=Piano` | The right-hand side must be a single value, variable, or function call |

`Tempo(100+20)` is valid, but `Tempo=100+20` is not.

### Main Default Values

| State | Default |
|---|---:|
| Current track | 1 |
| Time base | 96 ticks per quarter note |
| Time signature | 4/4 |
| Octave | 5 (`c` is MIDI note 60) |
| Default note length | `l4` = 96 ticks |
| Velocity | 100 |
| Gate | 80 |
| Timing offset | 0 ticks |
| `System.qMax` / `vMax` | 100 / 127 |
| Bend range | 2 |

Command names are not automatically case-insensitive. `Tempo` and `TEMPO` are valid, but spellings not explicitly listed here (for example, `tempo`) are not guaranteed to work.

## Notes and Rests

| Command | Syntax | Description |
|---|---|---|
| `a`–`g` | `c[length][,q,v,t,o]` | Note names. Do-Re-Mi... correspond to `c d e f g a b`. Immediately after the note name, `+` or `#` raises by a semitone and `-` lowers by a semitone. `*` disables KeyFlag for that note only |
| `n` | `n(note)[,attr...]` | Specifies a MIDI note number directly (0–127). Key transposition is applied, but accidentals are not |
| `r` | `r[length]` | Rest. Advances only the time pointer. A negative length such as `r-2.` may be used to move backward |
| `^` | `^[length]` | Tie. Extends the Note Off of the previous note |
| Chord | `'ceg'4` | Plays the notes inside single quotes simultaneously. The note length after the closing quote applies to the entire chord |

### Note Length Syntax

| Example | Meaning |
|---|---|
| `c4` | Quarter note (`timebase*4/n` ticks) |
| `c4.` / `c4..` | Dotted / double-dotted |
| `c%48` | Directly specifies 48 ticks |
| `c4^8` | Quarter note plus eighth note |
| `l8` | Sets the default note length to an eighth note from that point onward |

When tick mode is enabled with syntax such as `l%24`, subsequent numeric note lengths such as `c96` are also interpreted as ticks.

## Note Attributes

| Command | Syntax | Description |
|---|---|---|
| `o` | `o5` / `o(x)` | Sets the octave |
| `>` / `<` | — | Raises/lowers the octave by 1 (direction is reversed when `System.X68mode` is enabled) |
| `` ` `` / `"` | — | Raises/lowers the octave by 1 for the next note only |
| `l` | `l4` / `l%96` | Default note length |
| `q` | `q80` / `q%48` | Gate value (percentage of the note length, or direct tick value) |
| `v` | `v100` | Velocity (note strength) |
| `t` | `t0` | Timing offset for Note On, in ticks. The time pointer itself does not move |

### Per-Note Overrides

The standard order of note arguments is `l,q,v,t,o`. Use empty comma positions for omitted values. The order can be changed with `ArgOrder`.

```mml
c4,90,110,-2,5      // quarter-note length, q=90, v=110, t=-2, o=5
c(4,90,110,-2,5)    // parenthesized form
```

## Structures (Chords, Tuplets, Repeats, and Simultaneous Writing)

| Command | Syntax | Description |
|---|---|---|
| `Div` | `Div{cde}4` | Tuplet. Divides the total length equally among the notes in the body |
| `Sub` / `S` | `Sub{'ceg'1} cdef` | After playing the body, returns the time pointer to its starting position (for layering) |
| Repeat | `[4 cdef]` / `[2 cde:f]` | Repeats the body n times. The section after `:` is played only on the final iteration |
| `Stretch` | `Stretch{cdef}2` | Stretches or compresses the entire phrase to the specified note length |
| `Play` | `Play(mml0,mml1,...)` | Writes multiple MML strings simultaneously, using the argument position as a zero-based track number |

```mml
#Melody={"o5 cdef"}
#Bass={"o3 c2g2"}
Play(#Melody,#Bass)    // Empty argument positions are skipped
```

## Key and Transposition

| Command | Syntax | Description |
|---|---|---|
| `Key` / `KeyShift` | `Key=2` | Global semitone transposition shared by all tracks |
| `TrackKey` | `TrackKey(-1)` | Transposition for the current track only |
| `TimeKey` | `TimeKey((2:1:0),(3:1:0),3)` | Time-range transposition. The interval is half-open; the end position is excluded |
| `TimeKey2` | `TimeKey2(...)` | Secondary time-range transposition. At the same time position, it is added to TimeKey |
| `KeyFlag` | `KeyFlag+(fc)` / `KeyFlag=(0,0,-1,0,0,0,0)` | Default accidentals. In the `=` form, values are ordered `c,d,e,f,g,a,b` |
| `TimeKeyFlag` | `TimeKeyFlag((from),(to),(a,b,c,d,e,f,g))` | Time-range accidentals (the seven values are ordered `a` through `g`) |
| `UseKeyShift` | `UseKeyShift(on/off)` | Enables/disables the application of Key/TimeKey/TimeKey2/TrackKey |

```mml
TimeKey((2:1:0),(3:1:0),3)   // +3 semitones from the start of measure 2 to the start of measure 3
KeyFlag+(fc)                 // Sharpen F and C
```

## Tracks, Channels, and Time

| Command | Alias | Syntax | Description |
|---|---|---|---|
| `Track` | `TR` / `NowTrack` | `TR=2` | Selects the current logical track |
| `Channel` | `CH` | `CH=10` | MIDI channel 1–16. If omitted, the track number is used |
| `TimeBase` | — | `TimeBase=96` | Number of ticks per quarter note (1–32767) |
| `TimeSignature` | — | `TimeSignature=3,4` | Emits a time-signature meta event and also affects `Time` calculations |
| `Time` | — | `Time(384)` / `Time(2:1:0)` | Moves the time pointer to an absolute tick value or `measure:beat:tick` |
| `TrackSync` | — | `TrackSync` | Aligns all tracks to the furthest-advanced time pointer |
| `TrackMute` | — | `TrackMute(on)` | Temporarily suppresses note writing on the current track |
| `Solo` / `Mute` | — | `Solo(1,3)` | Keeps only the specified tracks / all tracks except those specified in the output (output filter) |
| `PlayFrom` | — | `PlayFrom(1:1:0)` | Plays from the specified position (output filter) |
| `PlayTo` | — | `PlayTo=(2:1:0)` | Keeps output only up to the specified position |
| `PrintTime` | — | `PrintTime([track])` | Writes the track number and time position to `messages` |
| `PrintTrack` | — | `PrintTrack([track])` | Writes detailed track state information to `messages` |

```mml
Time(2:1:0)     // Start of measure 2 (measures and beats are 1-based; ticks are 0-based)
```

## Tempo

| Command | Syntax | Description |
|---|---|---|
| `Tempo` | `Tempo=120` | Writes a tempo meta event at the current time of track 0 |
| `TempoChange` | `TempoChange(t1,t2,len)` | Changes from t1 to t2 over the specified length. `(t2,len)` starts from the current value, and `=t2` changes over the duration of a whole note |

## Voices and MIDI Control

| Command | Syntax | Description |
|---|---|---|
| `Voice` / `@` | `@1` / `Voice=25` / `@1,0,0` | Program Change. The second and third arguments also output Bank Select (CC0/CC32) |
| `y` | `y(7,100)` / `y10,64` / `y11=127` | Arbitrary Control Change |
| `RPN` | `RPN(msb,lsb[,data])` | Outputs CC#101 → #100 → #6 |
| `NRPN` | `NRPN(msb,lsb[,data])` | Outputs CC#99 → #98 → #6 |
| `p` | `p64` | Simplified pitch bend (0–127, with 64 as center) |
| `p%` | `p%(0)` | Full-range pitch bend (-8192 to 8191) |
| `PitchBend` | `PitchBend(-4096)` | Same 14-bit value as `p%` |
| `BR` | `BR(12)` | Bend range (sets RPN#0,0) |
| `NoteOn` | `NoteOn(64,127)` | Writes a raw Note On event (no gate or note length; pointer does not move) |
| `NoteOff` | `NoteOff(64,0)` | Writes a raw Note Off event |
| `KeyPressure` / `KP` | `KP(80)` | Applies polyphonic aftertouch to the previous note (0–127) |
| `SysEx` | `SysEx($F0,$7E,$7F,$09,$01,$F7)` | System Exclusive. Supports decimal/hexadecimal and `SysEx$=...;` forms |
| `ResetGM` | `ResetGM` | Outputs the GM Reset SysEx |
| `ResetGS` | `ResetGS` | Outputs the GS Reset SysEx |
| `ResetXG` | `ResetXG` | Outputs the XG Reset SysEx |
| `DeleteCC` | `DeleteCC(11)` | Deletes queued instances of the specified CC from the current position onward (256/257 for pitch bend) |
| `CCMute` | `CCMute(on)` | Temporarily suppresses CC and bend writing on the current track |
| `CCNoMute` | `CCNoMute(11,on)` | Suppresses writing for the specified CC number only |
| `Slur` | `Slur(type[,value[,range]])` | Slur. type 0: glissando, 1: bend, 2: gate, 3: arpeggio |
| `DirectSMF` | `DirectSMF($C0,$05)` | Writes the raw byte sequence directly as an event |
| `Cresc` | `Cresc=len[,v1][,v2]` | Increases Expression (CC11), default 40→127 |
| `Decresc` | `Decresc=len[,v1][,v2]` | Decreases Expression (CC11), default 127→40 |

### Named Control Changes

| Command | Short | CC Number | Purpose |
|---|---|---:|---|
| `Modulation` | `M` | 1 | Modulation |
| `PortamentoTime` | `PT` | 5 | Portamento time |
| `DataMSB` | `Y` | 6 | Data Entry MSB |
| `MainVolume` | `V` | 7 | Channel volume |
| `Panpot` | `P` | 10 | Pan position |
| `Expression` | `EP` | 11 | Expression |
| `DataLSB` | — | 38 | Data Entry LSB |
| `PortamentoSwitch` | `PS` | 65 | Portamento switch |
| `Reverb` | `REV` | 91 | Reverb send |
| `Chorus` | `CHO` | 93 | Chorus send |
| `Variation` | `VAR` | 94 | Variation send |

Note: `Sustain` (CC64), which appears in the legacy documentation, is not defined in the Rust implementation. Use `y64,127;` instead.

## Advance Specifications (`.onNote`, etc.)

Append `.` after a CC, bend, or note attribute to specify how values should be applied.

```mml
EP.onTime(40,127,!4)     // Linear transition from 40 to 127 over a quarter note
v.onNote(120,80,100) cdefg
```

| Specification | Alias | Syntax | Description |
|---|---|---|---|
| `.onNote` | `.N` | `(v1,v2,...)` | Cycles through values for each note |
| `.onTime` | `.T` | `(low,high,len,...)` | Immediately writes a linear transition at the current position |
| `.onCycle` | `.C` | `(len,v1,v2,...)` | Advances the value every `len` ticks |
| `.onNoteWave` | `.W` | `(low,high,len,...)` | Linear transition per note, truncated at the note length |
| `.onNoteWaveEx` | `.WE` | `(low,high,len,...)` | Per note; distributes segment lengths proportionally to the note length |
| `.onNoteWaveR` | `.WR` | `(low,high,len,...)` | Repeatedly writes values while the note is sounding |
| `.Sine` | — | `(type,low,high,len,times)` | Writes a sine curve at the current position |
| `.onNoteSine` | — | `(type,low,high,len,times)` | Writes a sine curve for each note |
| `.Delay` | — | `(v)` | Delays the effect by `v` ticks |
| `.Repeat` | — | `(0/1)` | If 0, does not repeat after the value list is exhausted |
| `.Random` | — | `(v)` | Adds variation of ±`v/2` to the value |
| `.Range` | — | `(low,high)` | Clamps written values to the specified range |
| `.Frequency` | — | `(v)` | Transition-writing interval (default: 2 ticks, global for the song) |
| `.Max` | — | `(v)` | `q.Max` / `v.Max` are equivalent to `System.qMax` / `vMax` |

Note attributes (`v q t l o`) support `.onNote/.onTime/.onCycle/.Delay/.Repeat/.Random/.Range`, but waveform specifications such as `.onNoteWave` are not available for them.

Within arguments, `!n` means “the length of an nth note” expressed in ticks (`!4` = quarter note). Combined forms such as `!1^1` are also supported.

## Meta Events

| Command | Meta Type | Syntax | Description |
|---|---|---|---|
| `TrackName` | FF 03 | `TrackName={"Song Title"}` | Song/track name |
| `Copyright` | FF 02 | `Copyright={"2026 ..."}` | Copyright |
| `MetaText` / `Text` | FF 01 | `MetaText={"..."}` | Generic text |
| `Lyric` | FF 05 | `Lyric={"lyrics"}` / `Lyric{A-melo}` | Lyrics |
| `Marker` | FF 06 | `Marker={"..."}` | Marker |
| `CuePoint` | FF 07 | `CuePoint={"..."}` | Cue point |
| `InstrumentName` | FF 04 | `InstrumentName={"..."}` | Instrument name |
| `ChannelPrefix` | FF 20 | `ChannelPrefix(1)` | Channel prefix (1–128; internally decremented by 1) |
| `Port` | FF 21 | `Port(0)` | MIDI port (0–255) |
| `MetaTextEOL` | — | `MetaTextEOL(0)` | Line breaks in text. 0=CRLF (default), 1=LF, 2=CR |

The payload of text-based meta events is always encoded as CP932. Characters unavailable in CP932 are replaced with `?` and produce a warning.

## System Settings

Use the form `System.name`.

| Setting | Default | Description |
|---|---:|---|
| `System.TimeBase=n` | 96 | Number of ticks per quarter note |
| `System.TimeSignature=n,d` | 4,4 | Same as `TimeSignature` |
| `System.KeyFlag...` | 0 | Same as `KeyFlag` |
| `System.KeyShift=n` | 0 | Same as `Key` |
| `System.qMax=n` | 100 | Value corresponding to 100% for q |
| `System.vMax=n` | 127 | Maximum-equivalent value for v |
| `System.vAdd=n` / `qAdd` / `q2Add` | 8 / 10 / 8 | Default increments for `v+` `q+` `q%+` |
| `System.MeasureShift=n` | 0 | Measure offset for `Time(measure:beat:tick)` |
| `System.RandomSeed=n` | Fixed | Random seed (reproducible) |
| `System.X68mode(on/off)` | off | Reverses the direction of `<` and `>` |
| `System.Stepmode(on/off)` | off | Initializes note lengths of subsequently created tracks as tick-based |
| `System.VoiceNoShift=n` | 0 | Offset added to program numbers |
| `System.OctaveRangeShift=n` | 0 | Offset applied to note-name octaves (not applied to `n`) |
| `System.ControllerShift=n` | 1 | Number of ticks by which CC and bend events are advanced |
| `System.GetKeyFlag` | — | Returns KeyFlag as an array in `c`–`g` order |
| `System.Include(file)` | — | Same as `Include` |
| `System.Div` / `Rythm` / `Sub` | — | Same as the corresponding normal commands |

Unimplemented `System.name` settings are skipped together with their arguments and generate a warning (for example, `System.LoadSMF`).

### Syntax Settings (also available via `System.`)

| Setting | Default | Description |
|---|---:|---|
| `ArgOrder(lqvto)` | `lqvto` | Order of comma-separated note arguments. Any subset of `l q v t o` |
| `AllowMultiLine(on/off)` | on | If off, chords containing line breaks are treated as errors |
| `UseKeyShift(on/off)` | on | Enables/disables key transposition |

## Scripting

### Variable Declarations

| Command | Syntax | Description |
|---|---|---|
| `Int` / `Integer` | `Int tempo=120` | Integer variable |
| `Str` | `Str s={"cdef"}` | String variable. When written by itself in command position, its contents are reinterpreted as MML |
| `Array` | `Array chord=(60,64,67)` | Array (zero-based indexing) |

Variables are global. Writing the name of a declared variable in command position performs assignment (`i=(i+1)`).

### Control Structures

| Command | Syntax | Description |
|---|---|---|
| `If` / `Else` | `If(cond){...} Else {...}` | Conditional branch |
| `While` | `While(cond){...}` | Loop |
| `For` | `For(i=0; i<4; i=(i+1)){...}` | Loop |
| `Switch` | `Switch(v){Case(1){...} Default{...}}` | Multi-way branch |
| `Exit` | `Exit` | Exits the current loop |
| `End` | `End` | Stops compilation |
| `Function` | `Function f(Int a=1){...}` | Defines a function. User-defined functions take precedence over built-ins according to execution order |
| `Result` | `Result=value` | Sets the function return value |
| `Print` | `Print(value)` | Writes to the result `messages` |
| `MsgBox` | `MsgBox("text")` | Writes to `messages`, like `Print` |

```mml
Function Arp(Int root, Int count=3) {
  n(root) n(root+4) n(root+7)
  Result=count
}
Int r=Arp(60)
```

A function that takes exactly one `Str` argument can receive unquoted MML, as in `Echo(ドレミ)`.

### Operators

Operator precedence, from highest to lowest, is `* / %` → `+ -` → comparison (`== != < <= > >=`) → `&&` → `||`.
Integer 0, an empty string, and an empty array are false; all other values are true. The `+` operator concatenates strings.

## Built-in Functions and Values

| Name | Syntax | Description |
|---|---|---|
| `on` / `off` | — | 1 / 0 |
| `SoundType` | — | Sound-source type variable (initial value 0 = GM) |
| `Random(n)` | `Random(10)` | Random integer from 0 to n |
| `Random(a,b)` | `Random(1,6)` | Random integer from a to b |
| `RandomSelect(...)` | `RandomSelect(a,b,c)` | Selects one argument |
| `Step(n)` | `Step(24)` | n ticks (same as `!n`) |
| `StrToLen(n)` | `StrToLen(4)` | Converts a note length with denominator n into ticks |
| `SizeOf(v)` | `SizeOf(arr)` | Number of array elements / string length / 4 for integers |
| `StrToNum(s)` | `StrToNum("10")` | Converts a decimal or `$`-prefixed hexadecimal string to a number. Returns 0 on failure |
| `HEX(n)` | `HEX(255)` | Hexadecimal string in `$FF` format. Arrays are also supported |
| `#STR(v)` | `#STR(42)` | Converts to a string |
| `ASC(s)` | `ASC("A")` | Code point of the first character |
| `CHR(n)` | `CHR(65)` | Converts a code point to a string |
| `MID(s,i,len)` | `MID("abc",2,1)` | Extracts a substring starting at a 1-based position |
| `POS(sub,s)` | `POS("b","abc")` | Returns a 1-based match position, or 0 if not found |
| `POSX(sub,s,start)` | `POSX(...)` | Searches from the specified position onward |
| `Replace(s,from,to,onoff)` | `Replace(s,"a","b",on)` | If off, replaces only the first match; if on, replaces all matches |
| `VarType(v)` | `VarType(x)` | Returns `Int`, `Str`, or `Array` |
| `ArraySortNum(a)` | — | Returns a new array sorted numerically in ascending order |
| `ArraySortStr(a)` | — | Returns a new array sorted lexicographically in ascending order |
| `VERSION()` | — | Compatibility version number |
| `NoteNo(mml)` | `NoteNo(o4c)` | Queries the MIDI note number of an MML note without playing it |
| `MML(name)` | `MML(v)` | Current command value. Supports `l v o q t @ BR p p% Key TimeKey TimeKey2 Port`, and CC queries such as `MML(y11)` |
| `Time(m:b:s)` | `Time(2:1:0)` | Converts `measure:beat:tick` to an absolute tick value without moving the pointer |
| `System.GetKeyFlag` | `Array f=System.GetKeyFlag` | Retrieves KeyFlag as an array in `c`–`g` order |

For string variables, `.s(from,to)` replaces all matching substrings (used by Include macros).

## Macros, Sutoton, and Include

### Sutoton Notation (Japanese Commands)

```mml
テンポ120 音階5 音符4 音量100
ドレミファソラシ↑ド
```

is approximately equivalent to `Tempo=120 o5 l4 v100 cdefgab>c`.
For the full list of supported words, see the “Sutoton notation” section of `spec/12-legacy-command-table.md`.
Japanese text inside strings is not replaced.

### Full-width Character Normalization

| Input | Converted To |
|---|---|
| `ｃｄｅ`, `１２３` | `cde`, `123` |
| Full-width space | ASCII space |
| `【】` / `『』` | `[]` / `{}` |
| `↑` / `↓` | `>` / `<` |
| `♯` / `♭` | `#` / `-` |
| `一`–`九`, `零` / `〇` | `1`–`9`, `0` |

### User-defined Macros

| Syntax | Description |
|---|---|
| `~{名前}={mml}` | Defines a Sutoton macro. The definition itself produces no sound |
| `#name={"mml"}` | String MML macro. When written in command position, its contents are executed as MML |
| `$x{mml}` | Rhythm macro. Assigns MML to one single-byte character |
| `Rythm{...}` / `Rhythm{...}` | Rhythm block. Expands rhythm macros inside the block |

```mml
~{上昇}={cdefg}
上昇 上昇          // cdefg twice

$b{n36,}
$s{n38,}
Rythm{b s b s}     // Bass drum and snare
```

### Include

```mml
Include(chord2.h)
Include{"chord2.h"}
```

The CLI searches, in order: the input file's directory, the current directory, each directory's `Include/` subdirectory, and the directory containing the executable.
Before compilation, `stdmsg.h` is loaded automatically, making GM voice names such as `GrandPiano` and `Strings1`, as well as drum names such as `Kick1` and `Snare1`, available as variables.

---

## Major Unimplemented Features

| Feature | Status |
|---|---|
| `System.LoadSMF` | Unsupported (warning is issued and it is skipped) |
| `Sustain` (named CC) | Undefined. Use `y64,value` |
| Unimplemented advance specifications `.*` | Warning is issued and they are skipped |

For additional compatibility information, see `spec/10-compatibility.md`.
