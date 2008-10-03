// -----------------------------------------------------------------------------
// Roland SC-8850 SYSTEM EXCLUSIVE �֐� "SC-8850.h" ver1.0 (2002/10/20)
//
//                                      programed by. 4neria (4neria@mcn.ne.jp)
// -----------------------------------------------------------------------------

// ���[�U�[��`(�C�ӂŕύX�\ ��������)----------------------------------------

/* -----------------------------------------------------------------------------
 �������̉����ɍ������f�o�C�X�i���o�[���w�肵�Ă��������B
 �l�͈̔�: [1�`32] �f�t�H���g�l: [17]
------------------------------------------------------------------------------*/
Int DeviceNumberGS = 17; //private

// �ύX�֎~(��������)-----------------------------------------------------------
If((DeviceNumberGS<1)||(DeviceNumberGS>32)) { MsgBox({" DeviceNumberGS�̒l�͈̔͂�1�`32�ł�."});  End; }
DeviceNumberGS -= 1;
// �ύX�֎~(�����܂�)-----------------------------------------------------------

/* -----------------------------------------------------------------------------
 �������̉����ɍ������|�[�g�̐����w�肵�Ă��������B
 SC-8850                                                                   �c 4
 SC-88,SC-88VL,SC-88ST,M-GS64,SC-88Pro,SC-88ST Pro,SK-88Pro,SC-880,SC-8820 �c 2
 SC-33,SC-55,SC-55mkII,��GS�݊�����                                        �c 1
------------------------------------------------------------------------------*/
Int PortNumberGS_MAX = 2; //private

// �ύX�֎~(��������)-----------------------------------------------------------
If((PortNumberGS_MAX<1)||(PortNumberGS_MAX>4)) { MsgBox ({"PortNumberGS_MAX�̒l��0�╉�̒l�A�܂���5�ȏ�̒l�͎w��ł��܂���."}); End; }
Int PortNumberGS = $00; Int ChannelNumberGS = $00; Int _Port_G = $00; Int _Channel = $00; Port(0); //private
// �ύX�֎~(�����܂�)-----------------------------------------------------------

// ���[�U�[��`(�C�ӂŕύX�\ �����܂�)----------------------------------------

// �ėp�֐�(�ύX�֎~ ��������)--------------------------------------------------
Function GS_EX(Array _Data) { //private GS�d�l�̃G�N�X�N���[�V�u���M (ADR HIGH/MID/LOW,DATA)
 SysEx=$F0,$41,(DeviceNumberGS),$42,$12,{(_Data)},$F7;
}
Function GS_PartEX(_M,_L,Array _Data) { //private GS�d�l�̃G�N�X�N���[�V�u���MMultiPart�p (ADR HIGH/MID/LOW,DATA)
 If((PortNumberGS<0)||(PortNumberGS>PortNumberGS_MAX)) { MsgBox ({"PortNumberGS�̒l�ɕ��̒l�͎w��ł��܂���. �܂���PortNumberGS_MAX�̒l("}+PortNumberGS_MAX+{")�𒴂��Ă��܂�."}); End; }
 If(PortNumberGS==$00) {
  _Port_G = MML(Port);
  If((_Port_G<0)||(_Port_G>(PortNumberGS_MAX-1))) { MsgBox ({"Port();�̒l�ɕ��̒l�͎w��ł��܂���. �܂���PortNumberGS_MAX�̒l("}+PortNumberGS_MAX+{")�𒴂��Ă��܂�."}); End; }
 } Else {
  _Port_G = PortNumberGS - 1;
 }
 Int _H = (_Port_G * $10) + $40; //private
 If((ChannelNumberGS<0)||(ChannelNumberGS>16)) { MsgBox({"ChannelNumberGS�͈̔͂�0�`16�܂łł�."}); End; }
 If(ChannelNumberGS==$00) {
  Int _TmpChannel = Channel; //private
  If(_TmpChannel==10) {
   _Channel = $00;
  } Else {
   If(_TmpChannel<10) { _Channel = _TmpChannel; } Else { _Channel = _TmpChannel -1; }
  }
 } Else {
  If(ChannelNumberGS==10) {
   _Channel = $00;
  } Else {
   If(ChannelNumberGS<10) { _Channel = ChannelNumberGS; } Else { _Channel = ChannelNumberGS -1; }
  }
 }
 _M = _M + _Channel;
 SysEx=$F0,$41,(DeviceNumberGS),$42,$12,{(_H),(_M),(_L),(_Data)},$F7;
}
Function GS_DrumEX(_N,Str _DNoteNumber,_M,Array _Data) { //private GS�d�l�̃h�����Ɋւ��G�N�X�N���[�V�u���M (DrumMapNumber,DrumNoteNumber,ADR MID,DATA)
 If((PortNumberGS<0)||(PortNumberGS>PortNumberGS_MAX)) { MsgBox ({"PortNumberGS�̒l�ɕ��̒l�͎w��ł��܂���. �܂���PortNumberGS_MAX�̒l("}+PortNumberGS_MAX+{")�𒴂��Ă��܂�."}); End; }
 If(PortNumberGS==$00) {
  _Port_G = MML(Port);
  If((_Port_G<0)||(_Port_G>(PortNumberGS_MAX-1))) { MsgBox ({"Port();�̒l�ɕ��̒l�͎w��ł��܂���. �܂���PortNumberGS_MAX�̒l("}+PortNumberGS_MAX+{")�𒴂��Ă��܂�."}); End; }
 } Else {
  _Port_G = PortNumberGS - 1;
 }
 Int _H = (_Port_G * $10) + $41; //private
 If((_N<1)||(_N>2)) { MsgBox({"GS Drum�֘A��DrumMapNumber�̒l���s���ł�. �p�����[�^�͈̔͂�1�`2�܂łł�."}); End; }
 _M = ((_N - 1) * $10) + _M;
 Int _Tmp = StrOrNum(_DNoteNumber); //private
 Int _DNN; //private
 If(_Tmp==0) {
  _DNN = StrToNum(_DNoteNumber);
 } Else {
  _DNN = NoteNo(_DNoteNumber);
 }
 If((_DNN<$00)||(_DNN>$7F)) { MsgBox({"GS_DrumEX��NoteNumber�̎w��ɕs��������܂�."}); End; }
 SysEx=$F0,$41,(DeviceNumberGS),$42,$12,{(_H),(_M),(_DNN),(_Data)},$F7;
}
Function GS_UserDrumEX(_N,Str _DNoteNumber,_M,Array _Data) { //private GS�d�l�̃��[�U�[�h�����Ɋւ��G�N�X�N���[�V�u���M (DrumMapNumber,DrumNoteNumber,ADR MID,DATA)
 If((_N<1)||(_N>2)) { MsgBox({"GS UserDrum�֘A��DrumMapNumber�̒l���s���ł�. �p�����[�^�͈̔͂�1�`2�܂łł�."}); End; }
 _M = ((_N - 1) * $10) + _M;
 Int _Tmp = StrOrNum(_DNoteNumber); //private
 Int _DNN; //private
 If(_Tmp==0) {
  _DNN = StrToNum(_DNoteNumber);
 } Else {
  _DNN = NoteNo(_DNoteNumber);
 }
 If((_DNN<$00)||(_DNN>$7F)) { MsgBox({"GS_UserDrumEX��NoteNumber�̎w��ɕs��������܂�."}); End; }
 SysEx=$F0,$41,(DeviceNumberGS),$42,$12,{$21,(_M),(_DNN),(_Data)},$F7;
}
Function GS_UserInstEX(_N,_L,_M,_D) { //private GS�d�l�̃��[�U�[�C���X�g�D�������g�Ɋւ��G�N�X�N���[�V�u���M (DrumMapNumber,DrumNoteNumber,ADR MID,DATA)
 If((_N<1)||(_N>2)) { MsgBox({"GS UserInst�֘A��InstBankNumber�̒l���s���ł�. �p�����[�^�͈̔͂�1�`2�܂łł�."}); End; }
 _M = ((_N - 1) * $10) + _M;
 If((_L<$00)||(_L>$7F)) { MsgBox({"GS_UserInstEX��ProgramNumber�̒l���s���ł�. �p�����[�^�͈̔͂�0�`127�܂łł�."}); End; }
 SysEx=$F0,$41,(DeviceNumberGS),$42,$12,{$20,(_M),(_L),(_D)},$F7;
}

// �ėp�֐�(�ύX�֎~ �����܂�)--------------------------------------------------

// SC SYSTEM--------------------------------------------------------------------
Function GS_SYSTEM_MODE_SET() {
 GS_EX($00,$00,$7F,$00);
}
Function GS_CHANNEL_MSG_RX_PORT(_A,_B,_C) {
 NumberCheck(_A,1,PortNumberGS_MAX); _A -= 1;
 NumberCheck(_B,1,16)
 If(_B==10) {
  _B = $00;
 } Else {
  If(_B>10) { _B -= 1; }
 }
 Int _D = (_A * $10) + _B; //private
 GS_EX($00,$01,_D,_C)
}
Function GS_MASTER_TUNE(_A,_B,_C,_D){
 GS_EX($40,$00,$00,_A,_B,_C,_D);
}
Function GS_MASTER_VOLUME(_D) {
 GS_EX($40,$00,$04,_D);
}
Function GS_MASTER_KEY_SHIFT(_D) {
 GS_EX($40,$00,$05,_D);
}
Function GS_MASTER_PAN(_D) {
 GS_EX($40,$00,$06,_D);
}
Function GS_MODE_SET() {
 GS_EX($40,$00,$7F,$00);
}
// ���o�[�u---------------------------------------------------------------------
Function GS_REVERB_MACRO(_D) {
 GS_EX($40,$01,$30,_D);
}
Function GS_REVERB_CHARACTER(_D) {
 GS_EX($40,$01,$31,_D);
}
Function GS_REVERB_PRE_LPF(_D) {
 GS_EX($40,$01,$32,_D);
}
Function GS_REVERB_LEVEL(_D) {
 GS_EX($40,$01,$33,_D);
}
Function GS_REVERB_TIME(_D) {
 GS_EX($40,$01,$34,_D);
}
Function GS_REVERB_DELAY_FEEDBACK(_D) {
 GS_EX($40,$01,$35,_D);
}
Function GS_REVERB_PREDELAY_TIME(_D) {
 GS_EX($40,$01,$37,_D);
}
// �R�[���X---------------------------------------------------------------------
Function GS_CHORUS_MACRO(_D) {
 GS_EX($40,$01,$38,_D);
}
Function GS_CHORUS_PRE_LPF(_D) {
 GS_EX($40,$01,$39,_D);
}
Function GS_CHORUS_LEVEL(_D) {
 GS_EX($40,$01,$3A,_D);
}
Function GS_CHORUS_FEEDBACK(_D) {
 GS_EX($40,$01,$3B,_D);
}
Function GS_CHORUS_DELAY(_D) {
 GS_EX($40,$01,$3C,_D);
}
Function GS_CHORUS_RATE(_D) {
 GS_EX($40,$01,$3D,_D);
}
Function GS_CHORUS_DEPTH(_D) {
 GS_EX($40,$01,$3E,_D);
}
Function GS_CHORUS_SEND_LEVEL_TO_REVERB(_D) {
 GS_EX($40,$01,$3F,_D);
}
Function GS_CHORUS_SEND_LEVEL_TO_DELAY(_D) {
 GS_EX($40,$01,$40,_D);
}
// �f�B���C---------------------------------------------------------------------
Function GS_DELAY_MACRO(_D) {
 GS_EX($40,$01,$50,_D);
}
Function GS_DELAY_PRE_LPF(_D) {
 GS_EX($40,$01,$51,_D);
}
Function GS_DELAY_TIME_CENTER(_D) {
 GS_EX($40,$01,$52,_D);
}
Function GS_DELAY_TIME_RAITO_LEFT(_D) {
 GS_EX($40,$01,$53,_D);
}
Function GS_DELAY_TIME_RAITO_RIGHT(_D) {
 GS_EX($40,$01,$54,_D);
}
Function GS_DELAY_LEVEL_CENTER(_D) {
 GS_EX($40,$01,$55,_D);
}
Function GS_DELAY_LEVEL_LEFT(_D) {
 GS_EX($40,$01,$56,_D);
}
Function GS_DELAY_LEVEL_RIGHT(_D) {
 GS_EX($40,$01,$57,_D);
}
Function GS_DELAY_LEVEL(_D) {
 GS_EX($40,$01,$58,_D);
}
Function GS_DELAY_FEEDBACK(_D) {
 GS_EX($40,$01,$59,_D);
}
Function GS_DELAY_SEND_LEVEL_TO_REVERB(_D) {
 GS_EX($40,$01,$5A,_D);
}
// �d�p-------------------------------------------------------------------------
Function GS_EQ_LOW_FREQ(_D) {
 GS_EX($40,$02,$00,_D);
}
Function GS_EQ_LOW_GAIN(_D) {
 GS_EX($40,$02,$01,_D);
}
Function GS_EQ_HIGH_FREQ(_D) {
 GS_EX($40,$02,$02,_D);
}
Function GS_EQ_HIGH_GAIN(_D) {
 GS_EX($40,$02,$03,_D);
}
// �d�e�w-----------------------------------------------------------------------
Function GS_EFX_TYPE(_A,_B) {
 GS_EX($40,$03,$00,_A,_B);
}
Function GS_EFX_PARAMETER(_A,_B) {
 GS_EX($40,$03,_A,_B);
}
Function GS_EFX_SEND_LEVEL_TO_REVERB(_D) {
 GS_EX($40,$03,$17,_D);
}
Function GS_EFX_SEND_LEVEL_TO_CHORUS(_D) {
 GS_EX($40,$03,$18,_D);
}
Function GS_EFX_SEND_LEVEL_TO_DELAY(_D) {
 GS_EX($40,$03,$19,_D);
}
Function GS_EFX_COTROL_SOURCE1(_D) {
 GS_EX($40,$03,$1B,_D);
}
Function GS_EFX_COTROL_DEPTH1(_D) {
 GS_EX($40,$03,$1C,_D);
}
Function GS_EFX_COTROL_SOURCE2(_D) {
 GS_EX($40,$03,$1D,_D);
}
Function GS_EFX_COTROL_DEPTH2(_D) {
 GS_EX($40,$03,$1E,_D);
}
Function GS_EFX_SEND_EQ_SWITCH(_D) {
 GS_EX($40,$03,$1F,_D);
}
// �p�[�g-----------------------------------------------------------------------
Function GS_TONE_NUMBER(_A,_B) {
 GS_PartEX($10,$00,_A,_B);
}
Function GS_RX_CHANNNEL(_D) {
 GS_PartEX($10,$02,_D);
}
Function GS_RX_PITCH_BEND(_D) {
 GS_PartEX($10,$03,_D);
}
Function GS_RX_CH_PRESSURE(_D) {
 GS_PartEX($10,$04,_D);
}
Function GS_RX_PROGRAM_CHANGE(_D) {
 GS_PartEX($10,$05,_D);
}
Function GS_RX_CONTROL_CHANGE(_D) {
 GS_PartEX($10,$06,_D);
}
Function GS_RX_POLY_PRESSURE(_D) {
 GS_PartEX($10,$07,_D);
}
Function GS_RX_NOTE_MESSAGE(_D) {
 GS_PartEX($10,$08,_D);
}
Function GS_RX_RPN(_D) {
 GS_PartEX($10,$09,_D);
}
Function GS_RX_NRPN(_D) {
 GS_PartEX($10,$0A,_D);
}
Function GS_RX_MODULATION(_D) {
 GS_PartEX($10,$0B,_D);
}
Function GS_RX_VOLUME(_D) {
 GS_PartEX($10,$0C,_D);
}
Function GS_RX_PANPOT(_D) {
 GS_PartEX($10,$0D,_D);
}
Function GS_RX_EXPRESSION(_D) {
 GS_PartEX($10,$0E,_D);
}
Function GS_RX_HOLD1(_D) {
 GS_PartEX($10,$0F,_D);
}
Function GS_RX_PORTAMENTO(_D) {
 GS_PartEX($10,$10,_D);
}
Function GS_RX_SOSTENUTO(_D) {
 GS_PartEX($10,$11,_D);
}
Function GS_RX_SOFT(_D) {
 GS_PartEX($10,$12,_D);
}
Function GS_MONO_POLY_MODE(_D) {
 GS_PartEX($10,$13,_D);
}
Function GS_ASSIGN_MODE(_D) {
 GS_PartEX($10,$14,_D);
}
Function GS_USE_FOR_RHYTHM_PART(_D) {
 GS_PartEX($10,$15,_D);
}
Function GS_PITCH_KEY_SHIFT(_D) {
 GS_PartEX($10,$16,_D);
}
Function GS_PITCH_OFFSET_FINE(_A,_B) {
 GS_PartEX($10,$17,_A,_B);
}
Function GS_PART_LEVEL(_D) {
 GS_PartEX($10,$19,_D);
}
Function GS_VELOCITY_SENSE_DEPTH(_D) {
 GS_PartEX($10,$1A,_D);
}
Function GS_VELOCITY_SENSE_OFFSET(_D) {
 GS_PartEX($10,$1B,_D);
}
Function GS_PART_PANPOT(_D) {
 GS_PartEX($10,$1C,_D);
}
Function GS_KEYBOARD_RANGE_LOW(_D) {
 GS_PartEX($10,$1D,_D);
}
Function GS_KEYBOARD_RANGE_HIGH(_D) {
 GS_PartEX($10,$1E,_D);
}
Function GS_CC1_CONTROLLER_NUMBER(_D) {
 GS_PartEX($10,$1F,_D);
}
Function GS_CC2_CONTROLLER_NUMBER(_D) {
 GS_PartEX($10,$20,_D);
}
Function GS_CHORUS_SEND_LEVEL(_D) {
 GS_PartEX($10,$21,_D);
}
Function GS_REVERB_SEND_LEVEL(_D) {
 GS_PartEX($10,$22,_D);
}
Function GS_RX_BANK_SELECT(_D) {
 GS_PartEX($10,$23,_D);
}
Function GS_RX_BANK_SELECT_LSB(_D) {
 GS_PartEX($10,$24,_D);
}
Function GS_PITCH_FINE_TUNE(_A,_B) {
 GS_PartEX($10,$2A,_A,_B);
}
Function GS_DELAY_SEND_LEVEL(_D) {
 GS_PartEX($10,$2C,_D);
}
Function GS_VIBRATO_RATE(_D) {
 GS_PartEX($10,$30,_D);
}
Function GS_VIBRATO_DEPTH(_D) {
 GS_PartEX($10,$31,_D);
}
Function GS_TVF_CUTOFF_FREQ(_D) {
 GS_PartEX($10,$32,_D);
}
Function GS_TVF_RESONANCE(_D) {
 GS_PartEX($10,$33,_D);
}
Function GS_TVF_TVA_ENV_ATTACK(_D) {
 GS_PartEX($10,$34,_D);
}
Function GS_TVF_TVA_ENV_DECAY(_D) {
 GS_PartEX($10,$35,_D);
}
Function GS_TVF_TVA_ENV_RELEASE(_D) {
 GS_PartEX($10,$36,_D);
}
Function GS_VIBRATO_DELAY(_D) {
 GS_PartEX($10,$37,_D);
}
Function GS_SCALE_TUNING(_A,_B,_C,_D,_E,_F,_G,_H,_I,_J,_K,_L) {
 GS_PartEX($10,$40,_A,_B,_C,_D,_E,_F,_G,_H,_I,_J,_K,_L);
}
Function GS_MOD_PITCH_CONTROL(_D) {
 GS_PartEX($20,$00,_D);
}
Function GS_MOD_TVF_CUTOFF_CONTROL(_D) {
 GS_PartEX($20,$01,_D);
}
Function GS_MOD_AMPLITUDE_CONTROL(_D) {
 GS_PartEX($20,$02,_D);
}
Function GS_MOD_LFO1_RATE_CONTROL(_D) {
 GS_PartEX($20,$03,_D);
}
Function GS_MOD_LFO1_PITCH_DEPTH(_D) {
 GS_PartEX($20,$04,_D);
}
Function GS_MOD_LFO1_TVF_DEPTH(_D) {
 GS_PartEX($20,$05,_D);
}
Function GS_MOD_LFO1_TVA_DEPTH(_D) {
 GS_PartEX($20,$06,_D);
}
Function GS_MOD_LFO2_RATE_CONTROL(_D) {
 GS_PartEX($20,$07,_D);
}
Function GS_MOD_LFO2_PITCH_DEPTH(_D) {
 GS_PartEX($20,$08,_D);
}
Function GS_MOD_LFO2_TVF_DEPTH(_D) {
 GS_PartEX($20,$09,_D);
}
Function GS_MOD_LFO2_TVA_DEPTH(_D) {
 GS_PartEX($20,$0A,_D);
}
Function GS_BEND_PITCH_CONTROL(_D) {
 GS_PartEX($20,$10,_D);
}
Function GS_BEND_TVF_CUTOFF_CONTROL(_D) {
 GS_PartEX($20,$11,_D);
}
Function GS_BEND_AMPLITUDE_CONTROL(_D) {
 GS_PartEX($20,$12,_D);
}
Function GS_BEND_LFO1_RATE_CONTROL(_D) {
 GS_PartEX($20,$13,_D);
}
Function GS_BEND_LFO1_PITCH_DEPTH(_D) {
 GS_PartEX($20,$14,_D);
}
Function GS_BEND_LFO1_TVF_DEPTH(_D) {
 GS_PartEX($20,$15,_D);
}
Function GS_BEND_LFO1_TVA_DEPTH(_D) {
 GS_PartEX($20,$16,_D);
}
Function GS_BEND_LFO2_RATE_CONTROL(_D) {
 GS_PartEX($20,$17,_D);
}
Function GS_BEND_LFO2_PITCH_DEPTH(_D) {
 GS_PartEX($20,$18,_D);
}
Function GS_BEND_LFO2_TVF_DEPTH(_D) {
 GS_PartEX($20,$19,_D);
}
Function GS_BEND_LFO2_TVA_DEPTH(_D) {
 GS_PartEX($20,$1A,_D);
}
Function GS_CAF_PITCH_CONTROL(_D) {
 GS_PartEX($20,$20,_D);
}
Function GS_CAF_TVF_CUTOFF_CONTROL(_D) {
 GS_PartEX($20,$21,_D);
}
Function GS_CAF_AMPLITUDE_CONTROL(_D) {
 GS_PartEX($20,$22,_D);
}
Function GS_CAF_LFO1_RATE_CONTROL(_D) {
 GS_PartEX($20,$23,_D);
}
Function GS_CAF_LFO1_PITCH_DEPTH(_D) {
 GS_PartEX($20,$24,_D);
}
Function GS_CAF_LFO1_TVF_DEPTH(_D) {
 GS_PartEX($20,$25,_D);
}
Function GS_CAF_LFO1_TVA_DEPTH(_D) {
 GS_PartEX($20,$26,_D);
}
Function GS_CAF_LFO2_RATE_CONTROL(_D) {
 GS_PartEX($20,$27,_D);
}
Function GS_CAF_LFO2_PITCH_DEPTH(_D) {
 GS_PartEX($20,$28,_D);
}
Function GS_CAF_LFO2_TVF_DEPTH(_D) {
 GS_PartEX($20,$29,_D);
}
Function GS_CAF_LFO2_TVA_DEPTH(_D) {
 GS_PartEX($20,$2A,_D);
}
Function GS_PAF_PITCH_CONTROL(_D) {
 GS_PartEX($20,$30,_D);
}
Function GS_PAF_TVF_CUTOFF_CONTROL(_D) {
 GS_PartEX($20,$31,_D);
}
Function GS_PAF_AMPLITUDE_CONTROL(_D) {
 GS_PartEX($20,$32,_D);
}
Function GS_PAF_LFO1_RATE_CONTROL(_D) {
 GS_PartEX($20,$33,_D);
}
Function GS_PAF_LFO1_PITCH_DEPTH(_D) {
 GS_PartEX($20,$34,_D);
}
Function GS_PAF_LFO1_TVF_DEPTH(_D) {
 GS_PartEX($20,$35,_D);
}
Function GS_PAF_LFO1_TVA_DEPTH(_D) {
 GS_PartEX($20,$36,_D);
}
Function GS_PAF_LFO2_RATE_CONTROL(_D) {
 GS_PartEX($20,$37,_D);
}
Function GS_PAF_LFO2_PITCH_DEPTH(_D) {
 GS_PartEX($20,$38,_D);
}
Function GS_PAF_LFO2_TVF_DEPTH(_D) {
 GS_PartEX($20,$39,_D);
}
Function GS_PAF_LFO2_TVA_DEPTH(_D) {
 GS_PartEX($20,$3A,_D);
}
Function GS_CC1_PITCH_CONTROL(_D) {
 GS_PartEX($20,$40,_D);
}
Function GS_CC1_TVF_CUTOFF_CONTROL(_D) {
 GS_PartEX($20,$41,_D);
}
Function GS_CC1_AMPLITUDE_CONTROL(_D) {
 GS_PartEX($20,$42,_D);
}
Function GS_CC1_LFO1_RATE_CONTROL(_D) {
 GS_PartEX($20,$43,_D);
}
Function GS_CC1_LFO1_PITCH_DEPTH(_D) {
 GS_PartEX($20,$44,_D);
}
Function GS_CC1_LFO1_TVF_DEPTH(_D) {
 GS_PartEX($20,$45,_D);
}
Function GS_CC1_LFO1_TVA_DEPTH(_D) {
 GS_PartEX($20,$46,_D);
}
Function GS_CC1_LFO2_RATE_CONTROL(_D) {
 GS_PartEX($20,$47,_D);
}
Function GS_CC1_LFO2_PITCH_DEPTH(_D) {
 GS_PartEX($20,$48,_D);
}
Function GS_CC1_LFO2_TVF_DEPTH(_D) {
 GS_PartEX($20,$49,_D);
}
Function GS_CC1_LFO2_TVA_DEPTH(_D) {
 GS_PartEX($20,$4A,_D);
}
Function GS_CC2_PITCH_CONTROL(_D) {
 GS_PartEX($20,$50,_D);
}
Function GS_CC2_TVF_CUTOFF_CONTROL(_D) {
 GS_PartEX($20,$51,_D);
}
Function GS_CC2_AMPLITUDE_CONTROL(_D) {
 GS_PartEX($20,$52,_D);
}
Function GS_CC2_LFO1_RATE_CONTROL(_D) {
 GS_PartEX($20,$53,_D);
}
Function GS_CC2_LFO1_PITCH_DEPTH(_D) {
 GS_PartEX($20,$54,_D);
}
Function GS_CC2_LFO1_TVF_DEPTH(_D) {
 GS_PartEX($20,$55,_D);
}
Function GS_CC2_LFO1_TVA_DEPTH(_D) {
 GS_PartEX($20,$56,_D);
}
Function GS_CC2_LFO2_RATE_CONTROL(_D) {
 GS_PartEX($20,$57,_D);
}
Function GS_CC2_LFO2_PITCH_DEPTH(_D) {
 GS_PartEX($20,$58,_D);
}
Function GS_CC2_LFO2_TVF_DEPTH(_D) {
 GS_PartEX($20,$59,_D);
}
Function GS_CC2_LFO2_TVA_DEPTH(_D) {
 GS_PartEX($20,$5A,_D);
}
Function GS_TONE_MAP_NUMBER(_D) {
 GS_PartEX($40,$00,_D);
}
Function GS_TONE_MAP0_NUMBER(_D) {
 GS_PartEX($40,$01,_D);
}
Function GS_EQ_ON_OFF(_D) {
 GS_PartEX($40,$20,_D);
}
Function GS_OUTPUT_ASSIGN(_D) {
 GS_PartEX($40,$21,_D);
}
Function GS_PART_EFX_ASSIGN(_D) {
 GS_PartEX($40,$22,_D);
}
// �h����-----------------------------------------------------------------------
Function GS_DRUM_PLAY_NOTE_NUMBER(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$01,_B);
}
Function GS_DRUM_LEVEL(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$02,_B);
}
Function GS_DRUM_ASSIGN_GROUP_NUMBER(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$03,_B);
}
Function GS_DRUM_PANPOT(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$04,_B);
}
Function GS_DRUM_REVERB_SEND_LEVEL(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$05,_B);
}
Function GS_DRUM_CHORUS_SEND_LEVEL(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$06,_B);
}
Function GS_DRUM_RX_NOTE_OFF(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$07,_B);
}
Function GS_DRUM_RX_NOTE_ON(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$08,_B);
}
Function GS_DRUM_DELAY_SEND_LEVEL(_N,Str _A,_B) {
 GS_DrumEX(_N,_A,$09,_B);
}
// ���[�U�[�C���X�g�D�������g---------------------------------------------------
Function GS_USERINST_SOURCE_TONE_BANK_LSB(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$00,_B);
}
Function GS_USERINST_SOURCE_TONE_BANK_MSB(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$01,_B);
}
Function GS_USERINST_SOURCE_TONE_NUMBER(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$02,_B);
}
Function GS_USERINST_VIBRATO_RATE(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$03,_B);
}
Function GS_USERINST_VIBRATO_DEPTH(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$04,_B);
}
Function GS_USERINST_TVF_CUTOFF_FREQ(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$05,_B);
}
Function GS_USERINST_TVF_RESONANCE(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$06,_B);
}
Function GS_USERINST_TVF_TVA_ENV_ATTACK(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$07,_B);
}
Function GS_USERINST_TVF_TVA_ENV_DECAY(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$08,_B);
}
Function GS_USERINST_TVF_TVA_ENV_RELEASE(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$09,_B);
}
Function GS_USERINST_VIBRATO_DELAY(_N,_A,_B) {
 GS_UserInstEX(_N,_A,$0A,_B);
}
// ���[�U�[�h����---------------------------------------------------------------
Function GS_USERDRUM_PLAY_NOTE(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$01,_B);
}
Function GS_USERDRUM_LEVEL(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$02,_B);
}
Function GS_USERDRUM_ASSIGN_GROUP(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$03,_B);
}
Function GS_USERDRUM_PAN(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$04,_B);
}
Function GS_USERDRUM_REVERB_SEND_LEVEL(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$05,_B);
}
Function GS_USERDRUM_CHORUS_SEND_LEVEL(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$06,_B);
}
Function GS_USERDRUM_RX_NOTE_OFF(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$07,_B);
}
Function GS_USERDRUM_RX_NOTE_ON(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$08,_B);
}
Function GS_USERDRUM_DELAY_SEND_LEVEL(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$09,_B);
}
Function GS_USERDRUM_SOURCE_DRUM_BANK_LSB(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$0A,_B);
}
Function GS_USERDRUM_SOURCE_DRUM_TONE_NUMBER(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$0B,_B);
}
Function GS_USERDRUM_SOURCE_DRUM_NOTE_NUMBER(_N,Str _A,_B) {
 GS_UserDrumEX(_N,_A,$0C,_B);
}
//------------------------------------------------------------------------------
//EOF