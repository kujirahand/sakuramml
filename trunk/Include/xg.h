/*
=title       "xg.h" ver.0.902
=description ＸＧ音源特有の命令を定義した (2000/03/28)
=keywords    SAKURA Function
*/

/** 概要
◇YAMAHA XG 音源特有の命令をまとめた定義ファイルです。

**使い方
	Include(xg.h)
	の一文を、曲頭に書き加えてください。
*/

//------------------------------------------------------------------------------
/**ドラムノートエディット
◇ドラムのノートの音色をエディットする命令です。
	rr	楽器番号(0-127)
	mm	値(0-127)
** DrumFilterCutoff(rr,mm)
** DrumFilterResonance(rr,mm)
** DrumEGAttackRate(rr,mm)
** DrumEGDecayRate(rr,mm)
** DrumPitchCoarse(rr,mm)
** DrumPitch(rr,mm) = DrumPitchCoarse　に同じ
** DrumPitchFine(rr,mm)
** DrumLevel(rr,mm)
** DrumPan(rr,mm)
** DrumReverbSendLevel(rr,mm)
** DrumChorusSendLevel(rr,mm)
** DrumVariationSendLevel(rr,mm)
*/

Function DrumFilterCutoff(rr,mm)	{ NRPN=$14,(rr),(mm); }
Function DrumFilterResonance(rr,mm)	{ NRPN=$15,(rr),(mm); }
Function DrumEGAttackRate(rr,mm)	{ NRPN=$16,(rr),(mm); }
Function DrumEGDecayRate(rr,mm)		{ NRPN=$17,(rr),(mm); }
Function DrumPitchCoarse(rr,mm)		{ NRPN=$18,(rr),(mm); }
Function DrumPitch(rr,mm)		{ NRPN=$18,(rr),(mm); }
Function DrumPitchFine(rr,mm)		{ NRPN=$19,(rr),(mm); }
Function DrumLevel(rr,mm)		{ NRPN=$1A,(rr),(mm); }
Function DrumPan(rr,mm)			{ NRPN=$1C,(rr),(mm); }	//00H-40H-7FH(Random,L-Center-R)
Function DrumReverbSendLevel(rr,mm)	{ NRPN=$1D,(rr),(mm); }
Function DrumChorusSendLevel(rr,mm)	{ NRPN=$1E,(rr),(mm); }
Function DrumVariationSendLevel(rr,mm)	{ NRPN=$1F,(rr),(mm); }

//------------------------------------------------------------------------------
// NRPN
/** NRPN 関連の命令
◇XG 特有のＮＲＰＮパラメータの操作

**HPFCutoff(mm)		
**HPFResonance(mm)	
**EQBass(mm)		
**EQTreble(mm)		
**EQMidBass(mm)		
**EQMidTreble(mm)	
**EQBassFrequency(mm)	
**EQTrebleFrequency(mm)	
**EQMidBassFrequency(mm)	
**EQMidTrebleFrequency(mm)
**EQMidTrebleFrequency(mm)
**EQMidTrebleFrequency(mm)
**EQMidTrebleFrequency(mm)
**EQMidTrebleFrequency(mm)
	mm	値（0~127）
*/
Function HPFCutoff(mm)		{ NRPN=1,$24,(mm); }
Function HPFResonance(mm)	{ NRPN=1,$25,(mm); }
Function EQBass(mm)		{ NRPN=1,$30,(mm); }
Function EQTreble(mm)		{ NRPN=1,$31,(mm); }
Function EQMidBass(mm)		{ NRPN=1,$32,(mm); }
Function EQMidTreble(mm)	{ NRPN=1,$33,(mm); }
Function EQBassFrequency(mm)	{ NRPN=1,$34,(mm); }
Function EQTrebleFrequency(mm)	{ NRPN=1,$35,(mm); }
Function EQMidBassFrequency(mm)	{ NRPN=1,$36,(mm); }
Function EQMidTrebleFrequency(mm){ NRPN=1,$37,(mm); }

//------------------------------------------------------------------------------
// EFFECT

/** XG エフェクトに関する関数
**XGEffectType(ad,dd,DD)
◇ エフェクトタイプの設定
*/
Function XGEffectType(ad,dd,DD){  // (dd)=(MSB) / (DD)=(LSB)
	SysEx$=F0,43,(DeviceNumber),4C,02,01,(ad),(dd),(DD),F7;
}

/*
**XGReverbType(dd,DD)
リバーブの種類を選びます。
	dd = MSB / DD = LSB
**XGChorusType(dd,DD)		
コーラスの種類を選びます。
	dd = MSB / DD = LSB
**XGVariationType(dd,DD)
バリエーションのエフェクト種類を選びます。
	dd = MSB / DD = LSB
**XGEffectConnection(VAL,INS)
*/
Function XGReverbType(dd,DD)		{ XGEffectType(0,dd,DD); }
Function XGChorusType(dd,DD)		{ XGEffectType($20,dd,DD); }
Int XGEffectSYS = 1;
Int XGEffectINS = 0;
Int InsertionNo = 0;//0:OFF 1:Effect1 2:Effect2
Function XGEffectConnection(VAL,INS){ //VAL(1:System / 0:Insertion)
	SysEx$=F0,43,(DeviceNumber),4C,02,01,5A,(VAL),F7;
	IF(VAL!=0){ InsertionNo = 0; }ELSE{ InsertionNo = INS; }
}
Function XGVariationType(dd,DD){
	IF(InsertionNo == 0){
		SysEx$=F0,43,(DeviceNumber),4C,02,01,40,(dd),(DD),F7;
	}ELSE{
		IF(InsertionNo == 1){
			SysEx$=F0,43,(DeviceNumber),4C,03,00,00,(dd),(DD),F7;
			SysEx$=F0,43,(DeviceNumber),4C,03,00,0C,(Channel),F7;
		}ELSE{
			SysEx$=F0,43,(DeviceNumber),4C,03,01,00,(dd),(DD),F7;
			SysEx$=F0,43,(DeviceNumber),4C,03,01,0C,(Channel),F7;			}
	}
}

//REVERB TYPE FUNCTION
/** エフェクタの設定
**XGReverbType_HALL1()		
**XGReverbType_HALL2()		
**XGReverbType_ROOM1()		
**XGReverbType_ROOM2()		
**XGReverbType_ROOM3()		
**XGReverbType_STAGE1()	
**XGReverbType_STAGE2()	
**XGReverbType_PLATE()		
**XGReverbType_WHITE_ROOM()	
**XGReverbType_TUNNEL()	
**XGReverbType_CANYON()	
**XGReverbType_BASEMENT()	
**XGReverbType_BASEMENT()	
**XGReverbType_BASEMENT()	
**XGChorusType_CHORUS1()	
**XGChorusType_CHORUS2()	
**XGChorusType_CHORUS3()	
**XGChorusType_CHORUS4()	
**XGChorusType_CELESTA1()	
**XGChorusType_CELESTA2()	
**XGChorusType_CELESTA3()	
**XGChorusType_CELESTA4()	
**XGChorusType_FLANGER1()	
**XGChorusType_FLANGER2()	
**XGChorusType_FLANGER3()	
**XGChorusType_SYMPHONIC()	
**XGChorusType_ENSEMBLE_DETUNE()	
**XGChorusType_PHASER1()	
**XGChorusType_PHASER1()	
**XGChorusType_PHASER1()	
**XGEffectType_CHORUS1()	
**XGEffectType_CHORUS2()	
**XGEffectType_CHORUS3()	
**XGEffectType_CHORUS4()	
**XGEffectType_CELESTE1()	
**XGEffectType_CELESTE2()	
**XGEffectType_CELESTE3()	
**XGEffectType_CELESTE4()	
**XGEffectType_FLANGER1()	
**XGEffectType_FLANGER2()	
**XGEffectType_FLANGER3()	
**XGEffectType_SYMPHONIC()	
**XGEffectType_ROTARY_SPEAKER()	
**XGEffectType_TREMOLO()	
**XGEffectType_AUTO_PAN()	
**XGEffectType_PHASER1()	
**XGEffectType_PHASER2()	
**XGEffectType_DISTORTION()	
**XGEffectType_COMP_DISTORTION()	
**XGEffectType_PITCH_CHANGE1()	
**XGEffectType_PITCH_CHANGE2()	
**XGEffectType_AURAL_EXCITER()	
**XGEffectType_TOUCH_WAH()	
**XGEffectType_TOUCH_WAH_DIST()	
**XGEffectType_TOUCH_WAH_ODRV()	
**XGEffectType_TOUCH_WAH2()	
**XGEffectType_COMPRESSOR()	
**XGEffectType_NOISE_GATE()	
**XGEffectType_VOICE_CANCEL()	
**XGEffectType_2WAY_ROTARY_SPEAKER()	
**XGEffectType_ENSEMBLE_DETUNE()	
**XGEffectType_AMBIENCE()	
**XGEffectType_COMP_DIST_DELAY()	
**XGEffectType_COMP_OVERDRIVE_DELAY()	
**XGEffectType_WAH_DIST_DELAY()	
**XGEffectType_WAH_OVERDRIVE_DELAY()	
**XGEffectType_HALL1()	
**XGEffectType_HALL2()	
**XGEffectType_ROOM1()	
**XGEffectType_ROOM2()	
**XGEffectType_ROOM3()	
**XGEffectType_STAGE1()	
**XGEffectType_STAGE2()	
**XGEffectType_PLATE()	
**XGEffectType_DELAY_LCR()	
**XGEffectType_DELAY_LR()	
**XGEffectType_ECHO()	
**XGEffectType_CROSS_DELAY()	
**XGEffectType_KARAOKE1()	
**XGEffectType_KARAOKE2()	
**XGEffectType_KARAOKE3()	
**XGEffectType_KARAOKE3()	
**XGEffectType_KARAOKE3()
*/
Function XGReverbType_HALL1()		{ XGReverbType(1,0); }
Function XGReverbType_HALL2()		{ XGReverbType(1,1); }
Function XGReverbType_ROOM1()		{ XGReverbType(2,0); }
Function XGReverbType_ROOM2()		{ XGReverbType(2,1); }
Function XGReverbType_ROOM3()		{ XGReverbType(2,2); }
Function XGReverbType_STAGE1()	{ XGReverbType(3,0); }
Function XGReverbType_STAGE2()	{ XGReverbType(3,1); }
Function XGReverbType_PLATE()		{ XGReverbType(4,0); }
Function XGReverbType_WHITE_ROOM()	{ XGReverbType($10,0); }
Function XGReverbType_TUNNEL()	{ XGReverbType($11,0); }
Function XGReverbType_CANYON()	{ XGReverbType($12,0); }
Function XGReverbType_BASEMENT()	{ XGReverbType($13,0); }

//CHORUS TYPE FUNCTION
Function XGChorusType_CHORUS1()	{ XGChorusType($41,0); }
Function XGChorusType_CHORUS2()	{ XGChorusType($41,1); }
Function XGChorusType_CHORUS3()	{ XGChorusType($41,2); }
Function XGChorusType_CHORUS4()	{ XGChorusType($41,8); }
Function XGChorusType_CELESTA1()	{ XGChorusType($42,0); }
Function XGChorusType_CELESTA2()	{ XGChorusType($42,1); }
Function XGChorusType_CELESTA3()	{ XGChorusType($42,2); }
Function XGChorusType_CELESTA4()	{ XGChorusType($42,8); }
Function XGChorusType_FLANGER1()	{ XGChorusType($43,0); }
Function XGChorusType_FLANGER2()	{ XGChorusType($43,1); }
Function XGChorusType_FLANGER3()	{ XGChorusType($43,8); }
Function XGChorusType_SYMPHONIC()	{ XGChorusType($44,0); }
Function XGChorusType_ENSEMBLE_DETUNE()	{ XGChorusType($57,0); }
Function XGChorusType_PHASER1()	{ XGChorusType($48,0); }

//VERIATION TYPE FUNCTION
Function XGEffectType_CHORUS1()	{ XGVariationType($41,0); }
Function XGEffectType_CHORUS2()	{ XGVariationType($41,1); }
Function XGEffectType_CHORUS3()	{ XGVariationType($41,2); }
Function XGEffectType_CHORUS4()	{ XGVariationType($41,8); }
Function XGEffectType_CELESTE1()	{ XGVariationType($42,0); }
Function XGEffectType_CELESTE2()	{ XGVariationType($42,1); }
Function XGEffectType_CELESTE3()	{ XGVariationType($42,2); }
Function XGEffectType_CELESTE4()	{ XGVariationType($42,8); }
Function XGEffectType_FLANGER1()	{ XGVariationType($43,0); }
Function XGEffectType_FLANGER2()	{ XGVariationType($43,1); }
Function XGEffectType_FLANGER3()	{ XGVariationType($43,8); }
Function XGEffectType_SYMPHONIC()	{ XGVariationType($44,0); }
Function XGEffectType_ROTARY_SPEAKER()	{ XGVariationType($45,0); }
Function XGEffectType_TREMOLO()	{ XGVariationType($46,0); }
Function XGEffectType_AUTO_PAN()	{ XGVariationType($47,0); }
Function XGEffectType_PHASER1()	{ XGVariationType($48,0); }
Function XGEffectType_PHASER2()	{ XGVariationType($48,8); }
Function XGEffectType_DISTORTION()	{ XGVariationType($49,0); }
Function XGEffectType_COMP_DISTORTION()	{ XGVariationType($49,1); }
Function XGEffectType_PITCH_CHANGE1()	{ XGVariationType($50,0); }
Function XGEffectType_PITCH_CHANGE2()	{ XGVariationType($50,1); }
Function XGEffectType_AURAL_EXCITER()	{ XGVariationType($51,0); }
Function XGEffectType_TOUCH_WAH()	{ XGVariationType($52,0); }
Function XGEffectType_TOUCH_WAH_DIST()	{ XGVariationType($52,1); }
Function XGEffectType_TOUCH_WAH_ODRV()	{ XGVariationType($52,2); }
Function XGEffectType_TOUCH_WAH2()	{ XGVariationType($52,8); }
Function XGEffectType_COMPRESSOR()	{ XGVariationType($53,0); }
Function XGEffectType_NOISE_GATE()	{ XGVariationType($54,0); }
Function XGEffectType_VOICE_CANCEL()	{ XGVariationType($55,0); }
Function XGEffectType_2WAY_ROTARY_SPEAKER()	{ XGVariationType($56,0); }
Function XGEffectType_ENSEMBLE_DETUNE()	{ XGVariationType($57,0); }
Function XGEffectType_AMBIENCE()	{ XGVariationType($58,0); }
Function XGEffectType_COMP_DIST_DELAY()	{ XGVariationType($60,0); }
Function XGEffectType_COMP_OVERDRIVE_DELAY()	{ XGVariationType($60,1); }
Function XGEffectType_WAH_DIST_DELAY()	{ XGVariationType($61,0); }
Function XGEffectType_WAH_OVERDRIVE_DELAY()	{ XGVariationType($61,1); }
Function XGEffectType_HALL1()	{ XGVariationType($1,0); }
Function XGEffectType_HALL2()	{ XGVariationType($1,1); }
Function XGEffectType_ROOM1()	{ XGVariationType($2,0); }
Function XGEffectType_ROOM2()	{ XGVariationType($2,1); }
Function XGEffectType_ROOM3()	{ XGVariationType($2,2); }
Function XGEffectType_STAGE1()	{ XGVariationType($3,0); }
Function XGEffectType_STAGE2()	{ XGVariationType($3,1); }
Function XGEffectType_PLATE()	{ XGVariationType($4,0); }
Function XGEffectType_DELAY_LCR()	{ XGVariationType($5,0); }
Function XGEffectType_DELAY_LR()	{ XGVariationType($6,0); }
Function XGEffectType_ECHO()	{ XGVariationType($7,0); }
Function XGEffectType_CROSS_DELAY()	{ XGVariationType($8,0); }
Function XGEffectType_KARAOKE1()	{ XGVariationType($14,0); }
Function XGEffectType_KARAOKE2()	{ XGVariationType($14,1); }
Function XGEffectType_KARAOKE3()	{ XGVariationType($14,2); }

//
Function XGSendChorusToReverb(dd)		{ SysEx$=F0,43,(DeviceNumber),4C,02,01,2E,(dd),F7; }
Function XGSendVariationToReverb(dd)	{ SysEx$=F0,43,(DeviceNumber),4C,02,01,58,(dd),F7; }
Function XGSendVariationToChorus(dd)	{ SysEx$=F0,43,(DeviceNumber),4C,02,01,59,(dd),F7; }

Function XGReverbReturnLevel(dd)	{ SysEx$=F0,43,(DeviceNumber),4C,02,01,0C,(dd),F7; } 
Function XGChorusReturnLevel(dd)	{ SysEx$=F0,43,(DeviceNumber),4C,02,01,2C,(dd),F7; } 
Function XGVariationReturnLevel(dd) { SysEx$=F0,43,(DeviceNumber),4C,02,01,56,(dd),F7; } 

Function XGAC1ControllerNumber(dd)		{ SysEx$=F0,43,(DeviceNumber),4C,08,00,59,(dd),F7; } 
Function XGAC1VariationControlDepth(dd)	{ SysEx$=F0,43,(DeviceNumber),4C,02,01,5F,(dd),F7; } 

//パラメータを１つずつ設定する
Function XGReverbParameter(No,Val){
	Int ADR;
	IF(No <= 10){ ADR = 1 + No; }ELSE{ No = No - 11; ADR = $10 + No; }
	SysEx$=F0,43,(DeviceNumber),4C,02,01,(ADR),(Val),F7; 
}
Function XGChorusParameter(No,Val){
	Int ADR;
	IF(No <= 10){ ADR = $21 + No; }ELSE{ No = No - 11; ADR = $30 + No; }
	SysEx$=F0,43,(DeviceNumber),4C,02,01,(ADR),(Val),F7; 
}
Function XGInsertion1Parameter(No,Val){
	Int ADR;
	IF(No <= 10){ ADR = 1 + No; }ELSE{ No = No - 11; ADR = $20 + No; }
	SysEx$=F0,43,(DeviceNumber),4C,03,00,(ADR),(Val),F7; 
} 
Function XGInsertion2Parameter(No,Val){
	Int ADR;
	IF(No <= 10){ ADR = 1 + No; }ELSE{ No = No - 11; ADR = $20 + No; }
	SysEx$=F0,43,(DeviceNumber),4C,03,01,(ADR),(Val),F7; 
} 


//パラメータを一気に設定する関数
Function XGReverbParameter_1to10(Array DD){
	Int ID = DeviceNumber & $0F;
	Int Len = SizeOf(DD);
	SysEx = $F0,$43,(ID),$4C, {0,(Len), 2,1,2,(DD) },$F7;	
}
Function XGReverbParameter_11to16(Array DD){
	Int ID = DeviceNumber & $0F;
	Int Len = SizeOf(DD);
	SysEx = $F0,$43,(ID),$4C, {0,(Len), 2,1,$10,(DD) },$F7;	
}
Function XGChorusParameter_1to10(Array DD){
	Int ID = DeviceNumber & $0F;
	Int Len = SizeOf(DD);
	SysEx = $F0,$43,(ID),$4C, {0,(Len), 2,1,$22,(DD) },$F7;	
}
Function XGChorusParameter_11to16(Array DD){
	Int ID = DeviceNumber & $0F;
	Int Len = SizeOf(DD);
	SysEx = $F0,$43,(ID),$4C, {0,(Len), 2,1,$30,(DD) },$F7;	
}
Function XGVariationParameter_1to10(Array DD){
	Int ID = DeviceNumber & $0F;
	Int Len = SizeOf(DD);
	SysEx = $F0,$43,(ID),$4C, {0,(Len), 2,1,$42,(DD) },$F7;	
}
Function XGVariationParameter_11to16(Array DD){
	Int ID = DeviceNumber & $0F;
	Int Len = SizeOf(DD);
	SysEx = $F0,$43,(ID),$4C, {0,(Len), 2,1,$70,(DD) },$F7;	
}

//------------------------------------------------------------------------------
// OTHER

//  スケールチューニング
Function XGScaleTuning(C,Cp,D,Dp,E,F,Fp,G,Gp,A,Ap,B){
	Int ID = DeviceNumber & $0F;
	FOR(Int I=0; I < 16; I++){
		SysEx = $F0,$43,(ID),$4c, {0,$0c, $8,(I),$41, (C),(Cp),(D),(Dp),(E),(F),(Fp),(G),(Gp),(A),(Ap),(B)},$F7;
	}
}

/** XGRcvChannelMute(Ch)
◇チャンネルミュート
	Ch	チャンネルの番号
*/
Function XGRcvChannelMute(Ch){
	Ch=Ch-1;
	SysEx$=f0,43,(DeviceNumber),4c,08,(Ch),04,7f,f7; //Value 7F = OFF
}

/*
**ＡＤインプット・コントロール
◇AD インプットの操作

** AD_InputGain(Chl, MIC_LINE)
■｜－ゲイン切り替え
	Chl / チャンネル(0,1)
	MIC_LINE / MIC = 0, LINE = 1
*/
Function AD_InputGain(Chl, MIC_LINE){
	Int CHL = Chl + $10;
	SysEx$=f0,43,10,4c,(CHL),00,00,(MIC_LINE),f7;//AD1 Gain-Mic
}
/*** AD_Volume(Chl, Val)
■｜－ボリュームコントロール
	Chl / Channel
	Val / Value
*/
Function AD_Volume(Chl, Val){
	Int CHL = Chl + $10;
	SysEx$=f0,43,10,4c,(CHL),00,0b,(Val),f7;
}
/*** AD_MONO_STEREO(Val)
■｜－モード（ステレオ・モノ）
	０＝ＭＯＮＯ　１＝ＳＴＥＲＥＯ
*/
Function AD_MONO_STEREO(Val){
	SysEx$=f0,43,10,4c,11,00,00,(Val),f7;
}
/*** AD_Chorus(Chl,Val)
■｜－コーラス
*/
Function AD_Chorus(Chl,Val){
	Chl = $10 + Chl;
	SysEx$=f0,43,10,4c,(Chl),00,12,(Val),f7;
}
/*** AD_Reverb(Chl,Val)
■｜－リバーブ
*/
Function AD_Reverb(Chl,Val){
	Chl = $10 + Chl;
	SysEx$=f0,43,10,4c,(Chl),00,13,(Val),f7;
}
/*** AD_Variation(Chl,Val)
■｜－バリエーション
*/
Function AD_Variation(Chl,Val){
	Chl = $10 + Chl;
	SysEx$=f0,43,10,4c,(Chl),00,14,(Val),f7;
}

/*** AD_Expression(Chl,Val)
■｜－エクスプレッション
*/
Function AD_Expression(Chl,Val){
	Chl = $10 + Chl;
	SysEx$=f0,43,10,4c,(Chl),00,3b,(Val),f7;
}
