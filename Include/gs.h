/*
=title        "gs.h" ver.0.71
=description  ＧＳ音源特有の命令を定義した関数 (2003/07/02)
=keywords     SAKURA Function gs
*/

/** 概要
◇Roland GS 音源に特有の命令を定義した関数です。

** 使い方
	Include(gs.h);
	の一文を、曲頭に書いてください。
*/

Include(stdmsg.h);
//------------------------------------------------------------------------------
// EFFECT

Function GSEffect(num,val){
	SysEx$=F0, 41, (DeviceNumber), 42, 12, {40, 01, (num), (val)}, F7;
}

/** リバーブに関する命令
** GSReverbMacro(val)
◇リバーブ（残響音）マクロの変更をします。
	val =
		00：Room 1	01：Room 2	02：Room 3
		03：Hall 1	04：Hall 2	05：Plate
		06：Delay	07：Panning Delay
*/
Function GSReverbMacro(val)		{ GSEffect($30,val); }

/*** GSReverbCharacter(val)
◇リバーブ（残響音）の個性を変更をします。
	val =
		00：Room 1	01：Room 2	02：Room 3
		03：Hall 1	04：Hall 2	05：Plate
		06：Delay	07：Panning Delay
*/
Function GSReverbCharacter(val)	{ GSEffect($31,val); }
/*
** GSReverbPRE_LPE(val)
** GSReverbLevel(val)
** GSReverbTime(val)
** GSReverbFeedback(val)
** GSReverbSendToChorus(val)
*/
Function GSReverbPRE_LPE(val)		{ GSEffect($32,val); }
Function GSReverbLevel(val)		{ GSEffect($33,val); }
Function GSReverbTime(val)		{ GSEffect($34,val); }
Function GSReverbFeedback(val)		{ GSEffect($35,val); }
Function GSReverbSendToChorus(val)	{ GSEffect($36,val); }

/** コーラスに関する命令
** GSChorusMacro(val)
◇コーラスマクロの変更をします。
	val =
		00：Chorus 1      01：Chorus 2            02：Chorus 3
		03：Chorus 4      04：Feedback Chorus     05：Flanger
		06：Short Delay   07：Short Delay（FB
*/
Function GSChorusMacro(val)		{ GSEffect($38,val); }
/*
**GSChorusPRE_LPF(val)
**GSChorusLevel(val)
**GSChorusFeedback(val)
**GSChorusDelay(val)
**GSChorusRate(val)
**GSChorusDepth(val)
**GSChorusSendToReverb(val)
**GSChorusSendToDelay(val)
*/
Function GSChorusPRE_LPF(val)		{ GSEffect($39,val); }
Function GSChorusLevel(val)		{ GSEffect($3A,val); }
Function GSChorusFeedback(val)		{ GSEffect($3B,val); }
Function GSChorusDelay(val)		{ GSEffect($3C,val); }
Function GSChorusRate(val)		{ GSEffect($3D,val); }
Function GSChorusDepth(val)		{ GSEffect($3E,val); }
Function GSChorusSendToReverb(val)	{ GSEffect($3F,val); }
Function GSChorusSendToDelay(val)	{ GSEffect($40,val); }

/** リズムパートに関する命令
** GS_RHYTHM(val)
◇リズムパートの変更をします。
	val =
		00：楽器          01：ドラムパート１      02：ドラムパート２
*/
Function GS_RHYTHM(_D) {
 Int _TCH = Channel; //private
 Int _CH; //private
 If(_TCH==10) {
  _CH = $00;
 } Else {
  If(_TCH<10) { _CH = _TCH; } Else { _CH = _TCH -1; }
 }
 _CH = $10 + _CH;
 SysEx=$F0,$41,(DeviceNumber),$42,$12,{$40,(_CH),$15,(_D)},$F7;
}


//------------------------------------------------------------------------------
//  ScaleTune

Function GSScaleTuning(C,Cp,D,Dp,E,F,Fp,G,Gp,A,Ap,B){
	FOR(Int I=$11; I <= $1F ; I++){
		SysEx = $F0,$41,(DeviceNumber),$42,$12,{$40,(I),$40,(C),(Cp),(D),(Dp),(E),(F),(Fp),(G),(Gp),(A),(Ap),(B)},$F7;
	}
}
