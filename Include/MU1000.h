// -----------------------------------------------------------------------------
// YAMAHA MU1000 SYSTEM EXCLUSIVE 関数 "MU1000.h" ver1.0 (2002/10/20)
//
//                                      programed by. 4neria (4neria@mcn.ne.jp)
// -----------------------------------------------------------------------------

// ユーザー定義(任意で変更可能 ここから)----------------------------------------

/* -----------------------------------------------------------------------------
 ご自分の音源に合ったデバイスナンバーを指定してください。
 値の範囲: [1～16] デフォルト値: [1]
------------------------------------------------------------------------------*/
Int DeviceNumberXG = 1; //private

// 変更禁止(ここから)-----------------------------------------------------------
If((DeviceNumberXG<1)||(DeviceNumberXG>16)) { MsgBox({" DeviceNumberXGの値の範囲は1～16です."});  End; }
Int DeviceNumberXG_Blk = DeviceNumberXG - 1; DeviceNumberXG = DeviceNumberXG - 1 + $10;  //private
// 変更禁止(ここまで)-----------------------------------------------------------

/* -----------------------------------------------------------------------------
 ご自分の音源に合ったポートの数を指定してください。
 MU2000,MU2000EX,MU2000EX R1,MU1000,MU1000EX,MU1000EX R1                           … 4
 MU500,MU128,MU100,MU100B,MU100Bs,MU100R,SW1000XG,SW1000XG/P,MU90,MU90B,MU90R,MU80 … 2
 MU50,MU15,MU10,DB50XG,DB60XG,その他XG互換音源                                     … 1
------------------------------------------------------------------------------*/
Int PortNumberXG_MAX = 4;  //private

// 変更禁止(ここから)-----------------------------------------------------------
If((PortNumberXG_MAX<1)||(PortNumberXG_MAX>4)) { MsgBox ({"PortNumberXG_MAXの値に0や負の値、または5以上の値は指定できません."}); End; }
Int PortNumberXG = $00; Int ChannelNumberXG = $00; Int _MultiPart = $00; Int _Port = $00; Port(0);  //private
// 変更禁止(ここまで)-----------------------------------------------------------

/* -----------------------------------------------------------------------------
 ご自分の音源に合ったインサーションエフェクトの数を指定してください。
 MU2000,MU2000EX,MU2000EX R1,MU1000,MU1000EX,MU1000EX R1                      … 4
 MU500,MU128,MU100,MU100B,MU100Bs,MU100R,SW1000XG,SW1000XG/P,MU90,MU90B,MU90R … 2
 MU80                                                                         … 1
 MU50/MU15/MU10,その他XG互換音源                                              … 0 (要するに使えません)
------------------------------------------------------------------------------*/
Int XG_InsertionType_MAX = 4;  //private

// 変更禁止(ここから)-----------------------------------------------------------
If(XG_InsertionType_MAX<0) { MsgBox ({"XG_InsertionType_MAXの値に負の値は指定できません."}); End; }
// 変更禁止(ここまで)-----------------------------------------------------------
// ユーザー定義(任意で変更可能 ここまで)----------------------------------------

// 汎用関数(変更禁止 ここから)--------------------------------------------------
Function INumberCheck(_N) {  //private _Nの値が1以上XG_InsertionType_MAX以下であるかチェック
 If(XG_InsertionType_MAX<1) { MsgBox({"XG_InsertionType_MAXの値が0なのでINSERTIONは使用できません."}); End; }
 If((_N<1)||(_N>XG_InsertionType_MAX)) { MsgBox({"XG_InsertionTypeの値が不正です. パラメータの範囲は1～"}+XG_InsertionType_MAX+{"までです."}); End; }
}
Function XG_MultiPart() {  //private ポートとチャンネルを取得し、XG仕様のMultiPartを生成
 _MultiPart = $00; // 初期化
 If((PortNumberXG<0)||(PortNumberXG>PortNumberXG_MAX)) { MsgBox ({"PortNumberXGの値に負の値は指定できません. またはPortNumberXG_MAXの値("}+PortNumberXG_MAX+{")を超えています."}); End; }
 If(PortNumberXG==$00) {
  _Port = MML(Port);
  If((_Port<0)||(_Port>(PortNumberXG_MAX-1))) { MsgBox ({"Port();の値に負の値は指定できません. またはPortNumberXG_MAXの値("}+PortNumberXG_MAX+{")を超えています."}); End; }
 } Else {
  _Port = PortNumberXG - 1;
 }
 If((ChannelNumberXG<0)||(ChannelNumberXG>16)) { MsgBox({"ChannelNumberXGの範囲は0～16までです."}); End; }
 If(ChannelNumberXG==$00) {
 _MultiPart = (Channel - 1) + (_Port * $10);
 } Else {
 _MultiPart = (ChannelNumberXG - 1) + (_Port * $10);
 }
}
Function XG_EX(Array _Data) {  //private XG仕様のエクスクルーシブ送信 (ADR HIGH/MID/LOW,DATA)
 SysEx=$F0,$43,(DeviceNumberXG),$4C,(_Data),$F7;
}
Function XG_BLK(Array _Data){  //private XG仕様のバルクダンプ送信 (ADR HIGH/MID/LOW,DATA)
 Int _DataSize = SizeOf(_Data) - 3; //private
 If(_DataSize<1) { MsgBox({"XG_BLKのパラメータにはADDRESS High/Middle/Lowの3つに加え、データ値が1つ以上必要です."}); End; }
 Int _DataSizeMSB = _DataSize & $FF00 / $0100; Int _DataSizeLSB = _DataSize & $00FF; //private
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{(_DataSizeMSB),(_DataSizeLSB),(_Data)},$F7;
}
Function MU_EX(Array _Data) {  //private XG仕様(MODEL ID:$49)のエクスクルーシブ送信 (ADR HIGH/MID/LOW,DATA)
 SysEx=$F0,$43,(DeviceNumberXG),$49,(_Data),$F7;
}
Function XG_DrumEX(_N,Str _DNoteNumber,_A,_B) {  //private XG仕様のドラムに関わるエクスクルーシブ送信 (DrumSetupNumber,DrumNoteNumber,ADR LOW,DATA)
 If((_N<1)||(_N>4)) { MsgBox({"XG Drum関連のDrumSetupNumberの値が不正です. パラメータの範囲は1～4までです."}); End; }
 _N = $30 + _N - 1;
 Int _Tmp = StrOrNum(_DNoteNumber); //private
 Int _DNN; //private
 If(_Tmp==0) {
  _DNN = StrToNum(_DNoteNumber);
 } Else {
  _DNN = NoteNo(_DNoteNumber);
 }
 If((_DNN < $0D)||(_DNN > $5B)) { MsgBox({"XG_DrumEXのNoteNumberの指定に不正があります."}); End; }
 XG_EX(_N,_DNN,_A,_B);
}

// 汎用関数(変更禁止 ここまで)--------------------------------------------------

// MU Native SYSTEM-------------------------------------------------------------
Function VOICE_MAP(_D) {
 MU_EX($00,$00,$12,_D);
}
// XG SYSTEM--------------------------------------------------------------------
Function MASTER_TUNE(_A,_B,_C,_D) {
 XG_EX($00,$00,$00,_A,_B,_C,_D);
}
Function MASTER_VOLUME(_D) {
 XG_EX($00,$00,$04,_D);
}
Function MASTER_ATTENUATOR(_D) {
 XG_EX($00,$00,$05,_D);
}
Function TRANSPOSE(_D) {
 XG_EX($00,$00,$06,_D);
}
Function DRUM_SETUP_RESET(_D) {
 XG_EX($00,$00,$7D,_D);
}
Function XG_SYSTEM_ON() {
 XG_EX($00,$00,$7E,$00);
}
Function ALL_PARAMETER_RESET() {
 XG_EX($00,$00,$7F,$00);
}
// REVERB-----------------------------------------------------------------------
Function REVERB_TYPE(_A,_B) {
 XG_EX($02,$01,$00,_A,_B);
}
Function REVERB_RETURN(_D) {
 XG_EX($02,$01,$0C,_D);
}
Function REVERB_PAN(_D) {
 XG_EX($02,$01,$0D,_D);
}
Function REVERB_PARAMETER(_Num,_D) {
 NumberCheck(_Num,1,16); _Num -= 1;
 If(_Num<10) { _Num+=$02; } Else { _Num+=$06; }
 XG_EX($02,$01,_Num,_D);
}
Function REVERB_PARAMETER_ALL(Array _Data) {
 Int _DataSize = SizeOf(_Data); DataSizeCheck(_DataSize,16); //private
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$0A,$02,$01,$02,(_Data(0)),(_Data(1)),(_Data(2)),(_Data(3)),(_Data(4)),(_Data(5)),(_Data(6)),(_Data(7)),(_Data(8)),(_Data(9))},$F7;
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$06,$02,$01,$10,(_Data(10)),(_Data(11)),(_Data(12)),(_Data(13)),(_Data(14)),(_Data(15))},$F7;
}
// CHORUS-----------------------------------------------------------------------
Function CHORUS_TYPE(_A,_B) {
 XG_EX($02,$01,$20,_A,_B);
}
Function CHORUS_RETURN(_D) {
 XG_EX($02,$01,$2C,_D);
}
Function CHORUS_PAN(_D) {
 XG_EX($02,$01,$2D,_D);
}
Function SEND_CHORUS_TO_REVERB(_D) {
 XG_EX($02,$01,$2E,_D);
}
Function CHORUS_PARAMETER(_Num,_D) {
 NumberCheck(_Num,1,16); _Num -= 1;
 If(_Num<10) { _Num+=$22; } Else { _Num+=$26; }
 XG_EX($02,$01,_Num,_D);
}
Function CHORUS_PARAMETER_ALL(Array _Data) {
 Int _DataSize = SizeOf(_Data); DataSizeCheck(_DataSize,16); //private
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$0A,$02,$01,$22,(_Data(0)),(_Data(1)),(_Data(2)),(_Data(3)),(_Data(4)),(_Data(5)),(_Data(6)),(_Data(7)),(_Data(8)),(_Data(9))},$F7;
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$06,$02,$01,$30,(_Data(10)),(_Data(11)),(_Data(12)),(_Data(13)),(_Data(14)),(_Data(15))},$F7;
}
// VARIATION--------------------------------------------------------------------
Function VARIATION_TYPE(_A,_B) {
 XG_EX($02,$01,$40,_A,_B);
}
Function VARIATION_RETURN(_D) {
 XG_EX($02,$01,$56,_D);
}
Function VARIATION_PAN(_D) {
 XG_EX($02,$01,$57,_D);
}
Function SEND_VARIATION_TO_REVERB(_D) {
 XG_EX($02,$01,$58,_D);
}
Function SEND_VARIATION_TO_CHORUS(_D) {
 XG_EX($02,$01,$59,_D);
}
Function VARIATION_CONNECTION(_D) {
 XG_EX($02,$01,$5A,_D);
}
Function VARIATION_PART_NUMBER(_D) {
 XG_EX($02,$01,$5B,_D);
}
Function MW_VARIATION_COTROL_DEPTH(_D) {
 XG_EX($02,$01,$5C,_D);
}
Function BEND_VARIATION_COTROL_DEPTH(_D) {
 XG_EX($02,$01,$5D,_D);
}
Function CAT_VARIATION_COTROL_DEPTH(_D) {
 XG_EX($02,$01,$5E,_D);
}
Function AC1_VARIATION_COTROL_DEPTH(_D) {
 XG_EX($02,$01,$5F,_D);
}
Function AC2_VARIATION_COTROL_DEPTH(_D) {
 XG_EX($02,$01,$60,_D);
}
Function VARIATION_PARAMETER(Array _Data) {
 Int _DataSize = SizeOf(_Data); //private
 If(_DataSize<2){ MsgBox({"VARIATION_PARAMETERのDATA値が1つ以上必要です."}); End; }
 Int _Num = _Data(0); NumberCheck(_Num,1,16); _Num -= 1; //private
 If(_Num<10) {
  If(_DataSize<3) { MsgBox({"VARIATION_PARAMETERのNUMBERが1～10の範囲の場合、値にはMSBとLSB必要です"}); End; }
  _Num = _Num * 2 + $42;
  XG_EX($02,$01,_Num,_Data(1),_Data(2));
 } Else {
  _Num += $66;
  XG_EX($02,$01,_Num,_Data(1));
 }
}
Function VARIATION_PARAMETER_ALL(Array _Data) {
 Int _DataSize = SizeOf(_Data); DataSizeCheck(_DataSize,26); //private
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$0A,$02,$01,$42,(_Data(0)),(_Data(1)),(_Data(2)),(_Data(3)),(_Data(4)),(_Data(5)),(_Data(6)),(_Data(7)),(_Data(8)),(_Data(9))},$F7;
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$0A,$02,$01,$4C,(_Data(10)),(_Data(11)),(_Data(12)),(_Data(13)),(_Data(14)),(_Data(15)),(_Data(16)),(_Data(17)),(_Data(18)),(_Data(19))},$F7;
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$06,$02,$01,$70,(_Data(20)),(_Data(21)),(_Data(22)),(_Data(23)),(_Data(24)),(_Data(25))},$F7;
}
// EQ---------------------------------------------------------------------------
Function EQ_TYPE(_D) {
 XG_EX($02,$40,$00,_D);
}
Function EQ_GAIN1(_D) {
 XG_EX($02,$40,$01,_D);
}
Function EQ_FREQUENCY1(_D) {
 XG_EX($02,$40,$02,_D);
}
Function EQ_Q1(_D) {
 XG_EX($02,$40,$03,_D);
}
Function EQ_SHAPE1(_D) {
 XG_EX($02,$40,$04,_D);
}
Function EQ_GAIN2(_D) {
 XG_EX($02,$40,$05,_D);
}
Function EQ_FREQUENCY2(_D) {
 XG_EX($02,$40,$06,_D);
}
Function EQ_Q2(_D) {
 XG_EX($02,$40,$07,_D);
}
Function EQ_GAIN3(_D) {
 XG_EX($02,$40,$09,_D);
}
Function EQ_FREQUENCY3(_D) {
 XG_EX($02,$40,$0A,_D);
}
Function EQ_Q3(_D) {
 XG_EX($02,$40,$0B,_D);
}
Function EQ_GAIN4(_D) {
 XG_EX($02,$40,$0D,_D);
}
Function EQ_FREQUENCY4(_D) {
 XG_EX($02,$40,$0E,_D);
}
Function EQ_Q4(_D) {
 XG_EX($02,$40,$0F,_D);
}
Function EQ_GAIN5(_D) {
 XG_EX($02,$40,$11,_D);
}
Function EQ_FREQUENCY5(_D) {
 XG_EX($02,$40,$12,_D);
}
Function EQ_Q5(_D) {
 XG_EX($02,$40,$13,_D);
}
Function EQ_SHAPE5(_D) {
 XG_EX($02,$40,$14,_D);
}
Function EQ_ALL(Array _Data) {
 Int _DataSize = SizeOf(_Data); DataSizeCheck(_DataSize,17); //private
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$15,$02,$40,$00,$00,(_Data(0)),(_Data(1)),(_Data(2)),(_Data(3)),(_Data(4)),(_Data(5)),(_Data(6)),$00,(_Data(7)),(_Data(8)),(_Data(9)),$00,(_Data(10)),(_Data(11)),(_Data(12)),$00,(_Data(13)),(_Data(14)),(_Data(15)),(_Data(16))},$F7;
}
// INSERTION--------------------------------------------------------------------
Function INSERTION_EFFECT_TYPE(_N,_A,_B) {
 INumberCheck(_N); _N -= 1; XG_EX($03,_N,$00,_A,_B);
}
Function INSERTION_EFFECT_PART_NUMBER(_N,_D) {
 INumberCheck(_N); _N -= 1; XG_EX($03,_N,$0C,_D);
}
Function MW_INSERTION_CONTROL_DEPTH(_N,_D) {
 INumberCheck(_N); _N -= 1; XG_EX($03,_N,$0D,_D);
}
Function BEND_INSERTION_CONTROL_DEPTH(_N,_D) {
 INumberCheck(_N); _N -= 1; XG_EX($03,_N,$0E,_D);
}
Function CAT_INSERTION_CONTROL_DEPTH(_N,_D) {
 INumberCheck(_N); _N -= 1; XG_EX($03,_N,$0F,_D);
}
Function AC1_INSERTION_CONTROL_DEPTH(_N,_D) {
 INumberCheck(_N); _N -= 1; XG_EX($03,_N,$10,_D);
}
Function AC2_INSERTION_CONTROL_DEPTH(_N,_D) {
 INumberCheck(_N); _N -= 1; XG_EX($03,_N,$11,_D);
}
Function INSERTION__EFFECT_PARAMETER(Array _Data) {
 Int _DataSize = SizeOf(_Data); DataSizeCheck(_DataSize,3); //private
 Int _N = _Data(0); INumberCheck(_N); _N -= 1; //private
 Int _A = _Data(1); NumberCheck(_A,1,16); _A -= 1; //private
 If(_A<10) { _A += $02; } Else { _A += $16 ;}
 XG_EX($03,_N,_A,_Data(2));
}
Function INSERTION__EFFECT_PARAMETER_DOUBLE(Array _Data) {
 Int _DataSize = SizeOf(_Data); DataSizeCheck(_DataSize,4); //private
 Int _N = _Data(0); INumberCheck(_N); _N -= 1; //private
 Int _A = _Data(1); NumberCheck(_A,1,10); _A -= 1; //private
 _A = _A * 2 + $30;
 XG_EX($03,_N,_A,_Data(2),_Data(3));
}
Function INSERTION__EFFECT_PARAMETER_ALL(Array _Data) {
 Int _DataSize = SizeOf(_Data); DataSizeCheck(_DataSize,17); //private
 Int _N = _Data(0); INumberCheck(_N); _N -= 1; //private
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$0A,$03,_N,$02,(_Data(1)),(_Data(2)),(_Data(3)),(_Data(4)),(_Data(5)),(_Data(6)),(_Data(7)),(_Data(8)),(_Data(9)),(_Data(10))},$F7;
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$06,$03,_N,$20,(_Data(11)),(_Data(12)),(_Data(13)),(_Data(14)),(_Data(15)),(_Data(16))},$F7;
}
Function INSERTION__EFFECT_PARAMETER_DOUBLE_ALL(Array _Data) {
 Int _DataSize = SizeOf(_Data); DataSizeCheck(_DataSize,27); //private
 Int _N = _Data(0); INumberCheck(_N); _N -= 1; //private
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$0A,$03,_N,$30,(_Data(1)),(_Data(2)),(_Data(3)),(_Data(4)),(_Data(5)),(_Data(6)),(_Data(7)),(_Data(8)),(_Data(9)),(_Data(10))},$F7;
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$0A,$03,_N,$3A,(_Data(11)),(_Data(12)),(_Data(13)),(_Data(14)),(_Data(15)),(_Data(16)),(_Data(17)),(_Data(18)),(_Data(19)),(_Data(20))},$F7;
 SysEx=$F0,$43,(DeviceNumberXG_Blk),$4C,{$00,$06,$03,_N,$20,(_Data(21)),(_Data(22)),(_Data(23)),(_Data(24)),(_Data(25)),(_Data(26))},$F7;
}
// MULTI PART-------------------------------------------------------------------
Function ELEMENT_RESERVE(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$00,_D);
}
Function BANK_SELECT_MSB(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$01,_D);
}
Function BANK_SELECT_LSB(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$02,_D);
}
Function PROGRAM_NUMBER(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$03,_D);
}
Function RCV_CHANNEL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$04,_D);
}
Function MONO_POLY_MODE(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$05,_D);
}
Function SAME_NOTE_NUMBER_KEY_ON_ASSIGN(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$06,_D);
}
Function PART_MODE(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$07,_D);
}
Function NOTE_SHIFT(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$08,_D);
}
Function DETUNE(_A,_B) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$09,_A,_B);
}
Function VOLUME(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$0B,_D);
}
Function VELOCITY_SENSE_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$0C,_D);
}
Function VELOCITY_SENSE_OFFSET(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$0D,_D);
}
Function PAN(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$0E,_D);
}
Function NOTE_LIMIT_LOW(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$0F,_D);
}
Function NOTE_LIMIT_HIGH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$10,_D);
}
Function DRY_LEVEL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$11,_D);
}
Function CHORUS_SEND(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$12,_D);
}
Function REVERB_SEND(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$13,_D);
}
Function VARIATION_SEND(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$14,_D);
}
Function VIBRATO_RATE(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$15,_D);
}
Function VIBRATO_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$16,_D);
}
Function VIBRATO_DELAY(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$17,_D);
}
Function LOW_PASS_FILTER_CUTOFF_FREQUENCY(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$18,_D);
}
Function LOW_PASS_FILTER_RESONANCE(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$19,_D);
}
Function EG_ATTACK_TIME(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$1A,_D);
}
Function EG_DECAY_TIME(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$1B,_D);
}
Function EG_RELEASE_TIME(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$1C,_D);
}
Function MW_PITCH_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$1D,_D);
}
Function MW_LOW_PASS_FILTER_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$1E,_D);
}
Function MW_AMPLITUDE_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$1F,_D);
}
Function MW_LFO_PMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$20,_D);
}
Function MW_LFO_FMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$21,_D);
}
Function MW_LFO_AMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$22,_D);
}
Function BEND_PITCH_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$23,_D);
}
Function BEND_LOW_PASS_FILTER_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$24,_D);
}
Function BEND_AMPLITUDE_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$25,_D);
}
Function BEND_LFO_PMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$26,_D);
}
Function BEND_LFO_FMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$27,_D);
}
Function BEND_LFO_AMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$28,_D);
}
Function RCV_PITCH_BEND(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$30,_D);
}
Function RCV_CH_AFTER_TOUCH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$31,_D);
}
Function RCV_PROGRAM_CHANGE(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$32,_D);
}
Function RCV_COTROL_CHANGE(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$33,_D);
}
Function RCV_POLY_AFTER_TOUCH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$34,_D);
}
Function RCV_NOTE_MESSAGE(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$35,_D);
}
Function RCV_RPN(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$36,_D);
}
Function RCV_NRPN(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$37,_D);
}
Function RCV_MODURATION(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$38,_D);
}
Function RCV_VOLUME(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$39,_D);
}
Function RCV_PAN(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$3A,_D);
}
Function RCV_EXPRESSION(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$3B,_D);
}
Function RCV_HOLD1(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$3C,_D);
}
Function RCV_PORTAMENTO(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$3D,_D);
}
Function RCV_SOSTENUTO(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$3E,_D);
}
Function RCV_SOFT_PEDAL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$3F,_D);
}
Function RCV_BANK_SELECT(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$40,_D);
}
Function SCALE_TUNING_C(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$41,_D);
}
Function SCALE_TUNING_C_Sharp(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$42,_D);
}
Function SCALE_TUNING_D(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$43,_D);
}
Function SCALE_TUNING_D_Sharp(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$44,_D);
}
Function SCALE_TUNING_E(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$45,_D);
}
Function SCALE_TUNING_F(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$46,_D);
}
Function SCALE_TUNING_F_Sharp(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$47,_D);
}
Function SCALE_TUNING_G(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$48,_D);
}
Function SCALE_TUNING_G_Sharp(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$49,_D);
}
Function SCALE_TUNING_A(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$4A,_D);
}
Function SCALE_TUNING_A_Sharp(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$4B,_D);
}
Function SCALE_TUNING_B(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$4C,_D);
}
Function CAT_PITCH_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$4D,_D);
}
Function CAT_LOW_PASS_FILTER_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$4E,_D);
}
Function CAT_AMPLITUDE_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$4F,_D);
}
Function CAT_LFO_PMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$50,_D);
}
Function CAT_LFO_FMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$51,_D);
}
Function CAT_LFO_AMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$52,_D);
}
Function PAT_PITCH_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$53,_D);
}
Function PAT_LOW_PASS_FILTER_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$54,_D);
}
Function PAT_AMPLITUDE_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$55,_D);
}
Function PAT_LFO_PMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$56,_D);
}
Function PAT_LFO_FMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$57,_D);
}
Function PAT_LFO_AMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$58,_D);
}
Function AC1_COTROLLER_NUMBER(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$59,_D);
}
Function AC1_PITCH_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$5A,_D);
}
Function AC1_LOW_PASS_FILTER_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$5B,_D);
}
Function AC1_AMPLITUDE_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$5C,_D);
}
Function AC1_LFO_PMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$5D,_D);
}
Function AC1_LFO_FMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$5E,_D);
}
Function AC1_LFO_AMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$5F,_D);
}
Function AC2_COTROLLER_NUMBER(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$60,_D);
}
Function AC2_PITCH_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$61,_D);
}
Function AC2_LOW_PASS_FILTER_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$62,_D);
}
Function AC2_AMPLITUDE_COTROL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$63,_D);
}
Function AC2_LFO_PMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$64,_D);
}
Function AC2_LFO_FMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$65,_D);
}
Function AC2_LFO_AMOD_DEPTH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$66,_D);
}
Function PORTAMENTO_SWITCH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$67,_D);
}
Function PORTAMENTO_TIME(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$68,_D);
}
Function PITCH_EG_INITIAL_LEVEL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$69,_D);
}
Function PITCH_EG_ATTACK_TIME(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$6A,_D);
}
Function PITCH_EG_RELEASE_LEVEL(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$6B,_D);
}
Function PITCH_EG_RELEASE_TIME(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$6C,_D);
}
Function VELOCITY_LIMIT_LOW(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$6D,_D);
}
Function VELOCITY_LIMIT_HIGH(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$6E,_D);
}
Function EQ_BASS_GAIN(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$72,_D);
}
Function EQ_TREBLE_GAIN(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$73,_D);
}
Function EQ_BASS_FREQUENCY(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$76,_D);
}
Function EQ_TREBLE_FREQUENCY(_D) {
 XG_MultiPart(); XG_EX($08,_MultiPart,$77,_D);
}
Function HIGH_PASS_FILTER_CUTOFF_FREQUENCY(_D) {
 XG_MultiPart(); XG_EX($0A,_MultiPart,$20,_D);
}

// MULTI PART-------------------------------------------------------------------
Function DRUM_PITCH_COARSE(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$00,_B);
}
Function DRUM_PITCH_FINE(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$01,_B);
}
Function DRUM_LEVEL(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$02,_B);
}
Function DRUM_ALTERNATE_GROUP(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$03,_B);
}
Function DRUM_PAN(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$04,_B);
}
Function DRUM_REVERB_SEND(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$05,_B);
}
Function DRUM_CHORUS_SEND(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$06,_B);
}
Function DRUM_VARIATION_SEND(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$07,_B);
}
Function DRUM_KEY_ASSIGN(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$08,_B);
}
Function DRUM_RCV_NOTE_OFF(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$09,_B);
}
Function DRUM_RCV_NOTE_ON(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$0A,_B);
}
Function DRUM_LOW_PASS_FILTER_CUTOFF_FREQUENCY(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$0B,_B);
}
Function DRUM_LOW_PASS_FILTER_RESONANCE(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$0C,_B);
}
Function DRUM_EG_ATTACK_RATE(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$0D,_B);
}
Function DRUM_EG_DECAY1_RATE(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$0E,_B);
}
Function DRUM_EG_DECAY2_RATE(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$0F,_B);
}
Function DRUM_EQ_BASS_GAIN(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$20,_B);
}
Function DRUM_EQ_TREBLE_GAIN(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$21,_B);
}
Function DRUM_EQ_BASS_FREQUENCY(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$24,_B);
}
Function DRUM_EQ_TREBLE_FREQUENCY(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$25,_B);
}
Function DRUM_HIGH_PASS_FILTER_CUTOFF_FREQUENCY(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$50,_B);
}
Function DRUM_VELOCITY_SENSE_PITCH(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$60,_B);
}
Function DRUM_VELOCITY_SENSE_LPF_CUTOFF(_N,Str _A,_B) {
 XG_DrumEX(_N,_A,$61,_B);
}
//------------------------------------------------------------------------------
//EOF