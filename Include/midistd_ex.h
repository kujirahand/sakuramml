//===========================================================================
//
//		Define for MIDI System Exclusive Message
//
//			Universal Real Time Message		( ID = $7E )
//			Universal Non Real Time Message	( ID = $7F )
//
//									Programmed by	A.Watanabe
//
//---------------------------------------------------------------------------
/****************************************************************/
/*																*/
/*								Common Define					*/
/*																*/
/****************************************************************/
//======================================================
//					Maker ID
//======================================================
//----------------------------------------------
//Japan			日本
//----------------------------------------------
Array MakerID_KAWAI_MUSICAL_INSTRUMENTS				= (	$40	);
Array MakerID_ROLAND								= (	$41	);
Array MakerID_KORG									= (	$42	);
Array MakerID_YAMAHA								= (	$43	);
Array MakerID_CASIO_COMPUTER						= (	$44	);
Array MakerID_KAMIYA_STUDIO							= (	$46	);
Array MakerID_AKAI_ELECTRIC							= (	$47	);
Array MakerID_VICTOR								= (	$48	);
Array MakerID_FUJITSU								= (	$4B	);
Array MakerID_SONY									= (	$4C	);
Array MakerID_TEAC									= (	$4E	);
Array MakerID_MATSUSHITA_ELECTRIC_INDUSTRIAL		= (	$50	);
Array MakerID_FOSTEX								= (	$51	);
Array MakerID_ZOOM									= (	$52	);
Array MakerID_MATSUSHITA_COMMUNICATION_INDUSTRIAL	= (	$54	);
Array MakerID_SUZUKI_MUSICAL_INSTRUMENTS_MFG		= (	$55	);
Array MakerID_FUJI_SOUND							= (	$56	);
Array MakerID_ACOUSTIC_TECHNICAL_LABORATORY			= (	$57	);
Array MakerID_FAITH									= (	$59	);
Array MakerID_INTERNET								= (	$5A	);
Array MakerID_SEEKERS								= (	$5C	);
Array MakerID_SD_CARD_ASSOCIATION_					= (	$5F	);
Array MakerID_CRIMSON_TECHNOLOGY					= (	$00,$40,$00	);

//----------------------------------------------
//Common		共通
//----------------------------------------------
Array MakerID_Test									= (	$7D	);
Array MakerID_NonRealTime							= (	$7E	);
Array MakerID_RealTime								= (	$7F	);



//======================================================
//					Functions
//======================================================
//==============================================
//		Send of System exclusive Message
//		（共通のエクスクルーシブ送信命令）
//----------------------------------------------
//		Input
//			Array	Data(MakerID,DeviceID,SubID,Data)
//		OutPut
//			nothing
//----------------------------------------------
Function SysExc(Array aSysExcData) {


	//--------------------------
	//Debug用　データ内容のチェック(数値が0～127の範囲であるか？)
	If(MidiStd_Debug & $01){
		For(Int SysExcLoop=0; SysExcLoop<SizeOf(aSysExcData); SysExcLoop++) {
			If((aSysExcData(SysExcLoop)<0) | (aSysExcData(SysExcLoop)>127)){
				Print("Wanning：数値が範囲を越えています。 Data=",aSysExcData(SysExcLoop));
				aSysExcData(SysExcLoop)=0;
			};
		};
	};


	//--------------------------
	//Debug用　送信内容の表示
	If(MidiStd_Debug & $02){
		Print("SysEx="+HEX($F0), HEX(aSysExcData), HEX($F7));		//Debug用
	};

	SysEx=$F0,aSysExcData,$F7;
};



/****************************************************************/
/*																*/
/*					Universal Exclusive Message					*/
/*																*/
/****************************************************************/
//
//	Format of Universal Exclusive Message
//
//		$F0				Start of System Exclusive Message
//		[MakerID]		$7E(NRT) or $7F(RT)
//		[DeviceID]		Alooted ID for MIDI Device （$7F:All Device）
//		[Sub-ID#1]		Command ID #1
//		[Sub-ID#2]		Command ID #2
//		[Data]			Data
//		$F7				End of System Exclusive Message
//
/****************************************************************/
//		Device ID
INT Universal_AllDevice				=	$7F;

//		デフォルトの設定
INT Universal_DefaultDevice		=	Universal_AllDevice;
INT Universal_targetDeviceID	=	Universal_DefaultDevice;

//==============================================
//		Send of Universal Non Real Time Message
//----------------------------------------------
//		Input
//			INT		DeviceID
//			INT		SubID#1
//			INT		SubID#2
//			Array	Data
//		OutPut
//			nothing
//----------------------------------------------
Function NRT_EX(INT idDevice,INT idSub1,INT idSub2,Array aNRTData){
	Array aNRTData2=(MakerID_NonRealTime,idDevice,idSub1,idSub2,aNRTData);
	SysExc(aNRTData2);
};
//==============================================
//		Send of Universal Non Real Time Message without SubID#2
//----------------------------------------------
//		Input
//			INT		DeviceID
//			INT		SubID#1
//			Array	Data
//		OutPut
//			nothing
//----------------------------------------------
Function NRT_EX2(INT idDevice,INT idSub1,Array aNRTData){
	Array aNRTData2=(MakerID_NonRealTime,idDevice,idSub1,aNRTData);
	SysExc(aNRTData2);
};
//==============================================
//		Send of Universal Real Time Message
//----------------------------------------------
//		Input
//			INT		DeviceID
//			INT		SubID#1
//			INT		SubID#2
//			Array	Data
//		OutPut
//			nothing
//----------------------------------------------
Function RT_EX(INT idDevice,INT idSub1,INT idSub2,Array aRtData){
	Array aRtData2=(MakerID_RealTime,idDevice,idSub1,idSub2,aRtData);
	SysExc(aRtData2);
};





/****************************************************************/
/*																*/
/*					Universal Non Real Time Message				*/
/*								Maker ID = $7E					*/
/*																*/
/****************************************************************/

//======================================================
//		Message for Sample/file Dump
//------------------------------------------------------
//		SubID#2 are not used.
//		SubID#2は使用されません。
//======================================================
//Sub-ID#1
INT NRT_DumpHeader					=	$01
INT NRT_DataPacket					=	$02
INT NRT_DumpRequest					=	$03
INT NRT_EOF							=	$7B
INT NRT_Wait						=	$7C
INT NRT_Cancel						=	$7D
INT NRT_NAK							=	$7E
INT NRT_ACK							=	$7F

//----------------------------------------------
//Functions
Function NRT_DumpHeader_EX(INT idDevice, INT I_Number, INT I_Format, INT I_Freqency, INT I_Lengs, INT STP_Loop, INT ENP_Loop, INT Tyoe_Loop) {
	Array	A_EX_NRT_DumpHeader	= DivValue(2,I_Number), I_Format, DivValue(3,I_Freqency), DivValue(3,I_Lengs), DivValue(3,STP_Loop), DivValue(3,ENP_Loop), Tyoe_Loop;
	NRT_EX2(idDevice, NRT_DumpHeader, A_EX_NRT_DumpHeader);
};
Function NRT_DataPacket_EX(INT idDevice, INT kk, Array A_DataPacket) {
	IF(SizeOf(A_DataPacket)!=120){Print("Warning：Data Packetが120Byteではありません。");};
	Array A_EX_NRT_DataPacket=kk,A_DataPacket,CheckSum(MakerID_NonRealTime,idDevice,NRT_DataPacket,kk,A_DataPacket);
	NRT_EX2(idDevice, NRT_DataPacket, A_EX_NRT_DataPacket);
};
Function NRT_DumpRequest_EX(INT idDevice, INT I_Number) {
	Array	A_EX_NRT_DumpRequest=DivValue(2,I_Number);
	NRT_EX2(idDevice, NRT_DumpRequest,A_EX_NRT_DumpRequest);
};
Function NRT_EOF_EX(INT idDevice, INT pp) {
	NRT_EX2(idDevice, NRT_EOF,pp);
};
Function NRT_Wait_EX(INT idDevice, INT pp) {
	NRT_EX2(idDevice, NRT_Wait,pp);
};
Function NRT_Cancel_EX(INT idDevice, INT pp) {
	NRT_EX2(idDevice, NRT_Cancel,pp);
};
Function NRT_NAK_EX(INT idDevice, INT pp) {
	NRT_EX2(idDevice, NRT_NAK,pp);
};
Function NRT_ACK_EX(INT idDevice) {
	NRT_EX2(idDevice, NRT_ACK,$00);
};

//======================================================
//		MIDI Time Code
//======================================================
//Sub-ID#1
INT NRT_MTC							=	$04

//----------------------------------------------
//Sub-ID#2
INT NRT_MTC_Special									=	$00
INT NRT_MTC_PunchInPoints							=	$01
INT NRT_MTC_PunchOutPoints							=	$02
INT NRT_MTC_DeletePunchInPoint						=	$03
INT NRT_MTC_DeletePunchOutPoint						=	$04
INT NRT_MTC_EventStartPoint							=	$05
INT NRT_MTC_EventStopPoint							=	$06
INT NRT_MTC_EventStartPointsWithAddInfo				=	$07
INT NRT_MTC_EventStopPointsWithAddInfo				=	$08
INT NRT_MTC_DeleteEventStartPoint					=	$09
INT NRT_MTC_DeleteEventStopPoint					=	$0A
INT NRT_MTC_CuePoints								=	$0B
INT NRT_MTC_CuePointsWithAddInfo					=	$0C
INT NRT_MTC_DeleteCuePoint							=	$0D
INT NRT_MTC_EventNameInAddInfo						=	$0E

//----------------------------------------------
//Functions


//======================================================
//		Sample Dump Standard
//======================================================
//Sub-ID#1
INT NRT_SampleDamp					=	$05

//----------------------------------------------
//Sub-ID#2
INT NRT_SampleDamp_MultipleLoopPoints				=	$01
INT NRT_SampleDamp_LoopPointsRequest				=	$02
//Sample Dump Size, Rate and Name Extensions (CA-019)
INT NRT_SampleDamp_SampleNameTranceMission			=	$03
INT NRT_SampleDamp_SampleNameRequest				=	$04
INT NRT_SampleDamp_ExtendedDumpHeader				=	$05
INT NRT_SampleDamp_ExtendedLoopPointTranceMission	=	$06
INT NRT_SampleDamp_ExtendedLoopPointRequest			=	$07

//----------------------------------------------
//Functions



//======================================================
//		Device インクワイアリー
//======================================================
//Sub-ID#1
INT NRT_GeneralInfo					=	$06

//----------------------------------------------
//Sub-ID#2
INT NRT_GeneralInfo_IdentityRequest					=	$01	//これを送信すると、
INT NRT_GeneralInfo_IdentityReply					=	$02	//このメッセージが帰ってくる。

//----------------------------------------------
//Functions
Function NRT_GeneralInfo_IdentityRequest_EX(INT idDevice){
	NRT_EX(idDevice,NRT_GeneralInfo,NRT_GeneralInfo_IdentityRequest);
};

//======================================================
//		File Damp Standard
//======================================================
//Sub-ID#1
INT NRT_FileDamp					=	$07

//----------------------------------------------
//Sub-ID#2
INT NRT_FileDamp_Header								=	$01
INT NRT_FileDamp_DataPacket							=	$02
INT NRT_FileDamp_Request							=	$03

//----------------------------------------------
//Functions



//======================================================
//		MIDI Tuning Standard&quot;
//======================================================
//Sub-ID#1
INT NRT_Tuning						=	$08

//----------------------------------------------
//Sub-ID#2
INT NRT_Tuning_BulkTuningDumpRequest				=	$00	//これを送信すると、
INT NRT_Tuning_BulkTuningDumpReply					=	$01	//このメッセージが帰ってくる。
INT NRT_Tuning_SingleNoteTuningChange				=	$02
//MIDI TUNING Extensions (CA-020)
INT NRT_Tuning_BulkTuningDumpRequest_Bank			=	$03	//これを送信すると、
INT NRT_Tuning_KeyBasedTuningDump					=	$04	//このメッセージが帰ってくる。
INT NRT_Tuning_ScaleOctaveTuningDump1Byte			=	$05
INT NRT_Tuning_ScaleOctaveTuningDump2Byte			=	$06
INT NRT_Tuning_SingleNoteTuningChange_Bank			=	$07
//MIDI TUNING Extensions - Scale Octave Tuning (CA-021/RP-020)
INT NRT_Tuning_ScaleOctaveTuning1Byte				=	$08
INT NRT_Tuning_ScaleOctaveTuning2Byte				=	$09

//----------------------------------------------
//Functions
Function NRT_Tuning_BulkTuningDumpRequest_EX(INT idDevice, INT I_ProgramNo){
	NRT_EX(idDevice,NRT_Tuning,NRT_Tuning_BulkTuningDumpRequest,I_ProgramNo);
};

Function NRT_Tuning_SingleNoteTuningChange_EX(Int idDevice, INT I_ProgramNo, INT SZ_Change, Array A_Change){
	If(SizeOf(A_Change)!=(SZ_Change*4)){Print("Warning：データの数が合いません");};
	Array	A_EX_RT_Tuning_SingleNoteTuningChange=I_ProgramNo,SZ_Change,A_Change
	NRT_EX(idDevice,NRT_Tuning,NRT_Tuning_SingleNoteTuningChange,A_EX_RT_Tuning_SingleNoteTuningChange);
};
Function NRT_NoteTuning(INT I_ProgramNo, INT SZ_Change, Array A_Change){
	NRT_Tuning_SingleNoteTuningChange_EX(Universal_targetDeviceID,I_ProgramNo,SZ_Change,A_Change);
};

//MIDI TUNING Extensions (CA-020)
Function NRT_Tuning_SingleNoteTuningChange_Bank_EX(Int idDevice, INT I_Bank, INT I_ProgramNo, INT SZ_Change, Array A_Change){
	If(SizeOf(A_Change)!=(SZ_Change*4)){Print("Warning：データの数が合いません");};
	Array	A_EX_RT_Tuning_SingleNoteTuningChange=I_Bank,I_ProgramNo,SZ_Change,A_Change
	NRT_EX(idDevice,NRT_Tuning,NRT_Tuning_SingleNoteTuningChange_Bank,A_EX_RT_Tuning_SingleNoteTuningChange);
};
Function NRT_NoteTuning_Bank(INT I_Bank, INT I_ProgramNo, INT SZ_Change, Array A_Change){
	NRT_Tuning_SingleNoteTuningChange_Bank_EX(Universal_targetDeviceID,I_Bank,I_ProgramNo,SZ_Change,A_Change);
};
Function NRT_Tuning_BulkTuningDumpRequest_Bank_EX(INT idDevice, INT I_Bank, INT I_ProgramNo){
	Array	A_EX_NRT_Tuning_BulkTuningDumpRequest_Bank=I_Bank,I_ProgramNo;
	NRT_EX(idDevice,NRT_Tuning,NRT_Tuning_BulkTuningDumpRequest_Bank,A_EX_NRT_Tuning_BulkTuningDumpRequest_Bank);
};

//MIDI TUNING Extensions - Scale Octave Tuning (CA-021/RP-020)
Function NRT_Tuning_ScaleOctaveTuning1Byte_EX(Int idDevice, INT I_Channel, Array A_Offset){
	If(SizeOf(A_Offset)!=12){Print("Warning：データの数が合いません",SizeOf(A_Offset));};
	Array	EX_NRT_Tuning_ScaleOctaveTuning=DivValueX(3,I_Channel),A_Offset;
	NRT_EX(idDevice,NRT_Tuning,NRT_Tuning_ScaleOctaveTuning1Byte,EX_NRT_Tuning_ScaleOctaveTuning);
};
Function NRT_Tuning_ScaleOctaveTuning2Byte_EX(Int idDevice, INT I_Channel, Array A_Offset){
	If(SizeOf(A_Offset)!=12){Print("Warning：データの数が合いません",SizeOf(A_Offset));};
	Array	A2_Offset;
	Array	A24_Offset;
	For(INT I_Loop=0;I_Loop<12;I_Loop++){
		A2_Offset=DivValue(2,A_Offset(I_Loop));
		A24_Offset(I_Loop*2+0)=A2_Offset(0);
		A24_Offset(I_Loop*2+1)=A2_Offset(1);
	};
	Array	EX_NRT_Tuning_ScaleOctaveTuning=DivValueX(3,I_Channel),A24_Offset
	NRT_EX(idDevice,NRT_Tuning,NRT_Tuning_ScaleOctaveTuning2Byte,EX_NRT_Tuning_ScaleOctaveTuning);
};
Function NRT_OctaveTuningB(INT I_Channel, Array A_Offset) {
	NRT_Tuning_ScaleOctaveTuning1Byte_EX(Universal_targetDeviceID,I_Channel,A_Offset);
};
Function NRT_OctaveTuningW(INT I_Channel, Array A_Offset) {
	NRT_Tuning_ScaleOctaveTuning2Byte_EX(Universal_targetDeviceID,I_Channel,A_Offset);
};


//======================================================
//		General MIDI
//======================================================
//Sub-ID#1
INT NRT_GM							=	$09

//----------------------------------------------
//Sub-ID#2
INT NRT_GM_SystemOn1								=	$01
INT NRT_GM_SystemOff								=	$02
INT NRT_GM_SystemOn2								=	$03

//----------------------------------------------
//Functions
Function GM_System(INT iSubID2) {
	NRT_EX(Universal_AllDevice,NRT_GM,iSubID2);
};
Function GM_SystemOff()	{	GM_System(NRT_GM_SystemOff);	};
Function GM_SystemOn()	{	GM_System(NRT_GM_SystemOn1);	};
Function GM_SystemOn1()	{	GM_System(NRT_GM_SystemOn1);	};
Function GM_SystemOn2()	{	GM_System(NRT_GM_SystemOn2);	};



//======================================================
//		File Reference System Exclusive Message
//======================================================
//Sub-ID#1
INT NRT_FileReference				=	$0B

//----------------------------------------------
//Sub-ID#2
//File Reference System Exclusive Message (CA-018)
INT NRT_FileReference_OpenFile						=	$01
INT NRT_FileReference_SelectOrReselect				=	$02
INT NRT_FileReference_OpenFileAndSelect				=	$03
INT NRT_FileReference_CloseFile						=	$04

//----------------------------------------------
//Functions





/****************************************************************/
/*																*/
/*					Universal Real Time Message					*/
/*								Maker ID = $7F					*/
/*																*/
/****************************************************************/

//======================================================
//		MIDI Time Code
//======================================================
//Sub-ID#1
INT RT_MTC							=	$01

//----------------------------------------------
//Sub-ID#2
INT RT_MTC_FullMessage								=	$01
INT RT_MTC_UserBits									=	$02

//----------------------------------------------
//Functions



//======================================================
//		MIDI Show Control
//======================================================
//Sub-ID#1
INT RT_MSC							=	$02

//----------------------------------------------
//Sub-ID#2
INT RT_MSC_Extensions								=	$00

//----------------------------------------------
//Functions



//======================================================
//		Notation Information
//======================================================
//Sub-ID#1
INT RT_NotationInfo					=	$03

//----------------------------------------------
//Sub-ID#2
INT RT_NotationInfo_BarNumber						=	$01
INT RT_NotationInfo_TimeSignatureImmediate			=	$02
INT RT_NotationInfo_TimeSignatureDelayed			=	$42

//----------------------------------------------
//Functions



//======================================================
//		Device Control
//======================================================
//Sub-ID#1
INT RT_DeviceCont					=	$04

//----------------------------------------------
//Sub-ID#2
INT RT_DeviceCont_MasterVolume						=	$01
INT RT_DeviceCont_MasterBallance					=	$02
INT RT_DeviceCont_MasterFineTuning					=	$03
INT RT_DeviceCont_MasterCoarseTuning				=	$04

//----------------------
//Global Parameter Control (CA-024)
INT RT_DeviceCont_GlobalParameter					=	$05
//		Slot Path			sw	pw	vw	MSB	LSB
Array RT_Slot_Reverb	= (	$01,$01,$01,$01,$01	);
INT RT_Slot_Reverb_Type					=	$00
INT RT_Slot_Reverb_Time					=	$01
//		Slot Path			sw	pw	vw	MSB	LSB
Array RT_Slot_Chorus	= (	$01,$01,$01,$01,$02	);
INT RT_Slot_Chorus_Type					=	$00
INT RT_Slot_Chorus_ModRate				=	$01
INT RT_Slot_Chorus_ModDepth				=	$02
INT RT_Slot_Chorus_Feedback				=	$03
INT RT_Slot_Chorus_SendToReverb			=	$04

//----------------------------------------------
//Functions

//Device Control
Function RT_DeviceCont_Ex(INT idDevice, INT iSubID2, Array aDCExData) {
	RT_EX(idDevice,RT_DeviceCont,iSubID2,aDCExData);
};

//----------------------
//Master Volume
Function MasterVolume_Ex(INT idDevice, Int iVolume) {
	Array	aVolume = DivValue(2,iVolume);
	RT_DeviceCont_Ex(idDevice,RT_DeviceCont_MasterVolume,aVolume);
};
Function MasterVolume(Int iVolume) {
	MasterVolume_Ex(Universal_targetDeviceID,iVolume);
};

//Master Ballance
Function MasterBallance_Ex(INT idDevice, Int iBallance) {
	Array	aBallance = DivValue(2,iBallance);
	RT_DeviceCont_Ex(idDevice,RT_DeviceCont_MasterBallance,aBallance);
};
Function MasterBallance(Int iBallance) {
	MasterBallance_Ex(Universal_targetDeviceID,iBallance);
};

//Master Fine Tuning
Function MasterFineTuning_Ex(INT idDevice, Int iTuning) {
	Array	aTuning = DivValue(2,iTuning);
	RT_DeviceCont_Ex(idDevice,RT_DeviceCont_MasterFineTuning,aTuning);
};
Function MasterFineTuning(Int iTuning) {
	MasterFineTuning_Ex(Universal_targetDeviceID,iTuning);
};
//Master Coarse Tuning
Function MasterCoarseTuning_Ex(INT idDevice, Int iTuning) {
	Array	aTuning = 00,DivValue(1,iTuning)
	RT_DeviceCont_Ex(idDevice,RT_DeviceCont_MasterCoarseTuning,aTuning);
};
Function MasterCoarseTuning(Int iTuning) {
	MasterCoarseTuning_Ex(Universal_targetDeviceID,iTuning);
};
//Master Tuning
Function MasterTuning(Int iTuning){
	INT	I_Tuning = iTuning+$80000	//レンジを修正する。
	INT	HSB_iTuning = (I_Tuning/$2000);
	INT	LSB_iTuning = I_Tuning-((HSB_iTuning)*$2000)+$2000
	//LSB, MSBが0x3000を越えていたら、HSBの方を繰り上げる。
	//LSB, MSBは、0x1000～0x3000の範囲になるようにする。
	If((LSB_iTuning>$3000) | (HSB_iTuning<0)){
		LSB_iTuning = LSB_iTuning - $2000;
		HSB_iTuning++;
	};
	If(HSB_iTuning>127){
		LSB_iTuning = LSB_iTuning + $2000;
		HSB_iTuning--;
	};
	MasterFineTuning(LSB_iTuning);
	MasterCoarseTuning(HSB_iTuning);
};

//Device Control / Global Parameter Control
Function RT_DeviceCont_GlobalParameter_Ex(INT idDevice, Array aData) {
	RT_DeviceCont_Ex(idDevice,RT_DeviceCont_GlobalParameter,aData)
};

//----------------------
//Reverb
Function RT_Reverb_Ex(INT idDevice,INT pp,INT vv) {
	Array aReverbData=RT_Slot_Reverb,pp,vv;
	RT_DeviceCont_GlobalParameter_Ex(idDevice, aReverbData);
};
Function RT_Reverb(INT pp,INT vv) {
	RT_Reverb_Ex(Universal_targetDeviceID,pp,vv);
};
Function RT_Reverb_Type(INT vv) {
	RT_Reverb(RT_Slot_Reverb_Type,vv);
};
Function RT_Reverb_Time(INT vv) {
	RT_Reverb(RT_Slot_Reverb_Time,vv);
};
Function RT_Reverb_All(INT iType, INT iTime){
	RT_Reverb_Type(iType);
	RT_Reverb_Time(iTime);
};

//----------------------
//Chorus
Function RT_Chorus_Ex(INT idDevice,INT pp,INT vv) {
	Array aReverbData=RT_Slot_Chorus,pp,vv;
	RT_DeviceCont_GlobalParameter_Ex(idDevice, aReverbData);
};
Function RT_Chorus(INT pp,INT vv) {
	RT_Chorus_Ex(Universal_targetDeviceID,pp,vv)
};
Function RT_Chorus_Type(INT vv) {
	RT_Chorus(RT_Slot_Chorus_Type,vv);
};
Function RT_Chorus_ModRate(INT vv) {
	RT_Chorus(RT_Slot_Chorus_ModRate,vv);
};
Function RT_Chorus_ModDepth(INT vv) {
	RT_Chorus(RT_Slot_Chorus_ModDepth,vv);
};
Function RT_Chorus_Feedback(INT vv) {
	RT_Chorus(RT_Slot_Chorus_Feedback,vv);
};
Function RT_Chorus_SendToReverb(INT vv) {
	RT_Chorus(RT_Slot_Chorus_SendToReverb,vv);
};
Function RT_Chorus_All(INT iType,INT iMRate,INT iMDepth,INT iFB,INT iReverb) {
	RT_Chorus_Type(iType);
	RT_Chorus_ModRate(iMRate);
	RT_Chorus_ModDepth(iMDepth);
	RT_Chorus_Feedback(iFB);
	RT_Chorus_SendToReverb(iReverb);
};



//======================================================
//		Real Time MTC Cueing
//======================================================
//Sub-ID#1
INT RT_MTCC							=	$05

//----------------------------------------------
//Sub-ID#2
INT RT_MTCC_Special									=	$00
INT RT_MTCC_PunchInPoints							=	$01
INT RT_MTCC_PunchOutPoints							=	$02
INT RT_MTCC_EventStartPoints						=	$05
INT RT_MTCC_EventStopPoints							=	$06
INT RT_MTCC_EventStartPointsWithAddInfo				=	$07
INT RT_MTCC_EventStopPointsWithAddInfo				=	$08
INT RT_MTCC_CuePoints								=	$0B
INT RT_MTCC_CuePointsWithAddInfo					=	$0C
INT RT_MTCC_EventNameInAddInfo						=	$0E

//----------------------------------------------
//Functions



//======================================================
//		MIDI Machine Control Commands
//======================================================
//Sub-ID#1
INT RT_MMCC							=	$06

//----------------------------------------------
//Sub-ID#2


//----------------------------------------------
//Functions



//======================================================
//		MIDI Machine Control Responses 
//======================================================
//Sub-ID#1
INT RT_MMCR							=	$07

//----------------------------------------------
//Sub-ID#2


//----------------------------------------------
//Functions



//======================================================
//		MIDI Tuning Standard&quot;
//======================================================
//Sub-ID#1
INT RT_Tuning						=	$08

//----------------------------------------------
//Sub-ID#2
INT RT_Tuning_SingleNoteTuningChange				=	$02
//MIDI TUNING Extensions (CA-020)
INT RT_Tuning_SingleNoteTuningChange_Bank			=	$07
//MIDI TUNING Extensions - Scale Octave Tuning (CA-021/RP-020)
INT RT_Tuning_ScaleOctaveTuning1Byte				=	$08
INT RT_Tuning_ScaleOctaveTuning2Byte				=	$09

//----------------------------------------------
//Functions
Function RT_Tuning_SingleNoteTuningChange_EX(Int idDevice, INT I_ProgramNo, INT SZ_Change, Array A_Change){
	If(SizeOf(A_Change)!=(SZ_Change*4)){Print("Warning：データの数が合いません");};
	Array	A_EX_RT_Tuning_SingleNoteTuningChange=I_ProgramNo,SZ_Change,A_Change
	RT_EX(idDevice,RT_Tuning,RT_Tuning_SingleNoteTuningChange,A_EX_RT_Tuning_SingleNoteTuningChange);
};
Function RT_NoteTuning(INT I_ProgramNo, INT SZ_Change, Array A_Change){
	RT_Tuning_SingleNoteTuningChange_EX(Universal_targetDeviceID,I_ProgramNo,SZ_Change,A_Change);
};

//MIDI TUNING Extensions (CA-020)
Function RT_Tuning_SingleNoteTuningChange_Bank_EX(Int idDevice, INT I_Bank, INT I_ProgramNo, INT SZ_Change, Array A_Change){
	If(SizeOf(A_Change)!=(SZ_Change*4)){Print("Warning：データの数が合いません");};
	Array	A_EX_RT_Tuning_SingleNoteTuningChange=I_Bank,I_ProgramNo,SZ_Change,A_Change
	RT_EX(idDevice,RT_Tuning,RT_Tuning_SingleNoteTuningChange_Bank,A_EX_RT_Tuning_SingleNoteTuningChange);
};
Function RT_NoteTuning_Bank(INT I_Bank, INT I_ProgramNo, INT SZ_Change, Array A_Change){
	RT_Tuning_SingleNoteTuningChange_Bank_EX(Universal_targetDeviceID,I_Bank,I_ProgramNo,SZ_Change,A_Change);
};

//MIDI TUNING Extensions - Scale Octave Tuning (CA-021/RP-020)
Function RT_Tuning_ScaleOctaveTuning1Byte_EX(Int idDevice, INT I_Channel, Array A_Offset){
	If(SizeOf(A_Offset)!=12){Print("Warning：データの数が合いません",SizeOf(A_Offset));};
	Array	EX_RT_Tuning_ScaleOctaveTuning=DivValueX(3,I_Channel),A_Offset;
	RT_EX(idDevice,RT_Tuning,RT_Tuning_ScaleOctaveTuning1Byte,EX_RT_Tuning_ScaleOctaveTuning);
};
Function RT_Tuning_ScaleOctaveTuning2Byte_EX(Int idDevice, INT I_Channel, Array A_Offset){
	If(SizeOf(A_Offset)!=12){Print("Warning：データの数が合いません",SizeOf(A_Offset));};
	Array	A2_Offset;
	Array	A24_Offset;
	For(INT I_Loop=0;I_Loop<12;I_Loop++){
		A2_Offset=DivValue(2,A_Offset(I_Loop));
		A24_Offset(I_Loop*2+0)=A2_Offset(0);
		A24_Offset(I_Loop*2+1)=A2_Offset(1);
	};
	Array	EX_RT_Tuning_ScaleOctaveTuning=DivValueX(3,I_Channel),A24_Offset
	RT_EX(idDevice,RT_Tuning,RT_Tuning_ScaleOctaveTuning2Byte,EX_RT_Tuning_ScaleOctaveTuning);
};
Function RT_OctaveTuningB(INT I_Channel, Array A_Offset) {
	RT_Tuning_ScaleOctaveTuning1Byte_EX(Universal_targetDeviceID,I_Channel,A_Offset);
};
Function RT_OctaveTuningW(INT I_Channel, Array A_Offset) {
	RT_Tuning_ScaleOctaveTuning2Byte_EX(Universal_targetDeviceID,I_Channel,A_Offset);
};


//======================================================
//		Controller Destination Setting
//======================================================
//Sub-ID#1
INT RT_ControllerDestination		=	$09

//Controlled parameter
INT RT_CD_PitchControl				=	$00
INT RT_CD_FilterCutoffControl		=	$01
INT RT_CD_AmplitudeControl			=	$02
INT RT_CD_LFOPitchDepth				=	$03
INT RT_CD_LFOFilterDepth			=	$04
INT RT_CD_LFOAmplitudeDepth			=	$05

//----------------------------------------------
//Sub-ID#2
//Controller Destination Setting (CA-022)
INT RT_ControllerDestination_ChannelPressure		=	$01
INT RT_ControllerDestination_PolyhonicPressure		=	$02
INT RT_ControllerDestination_ControlChangeMessage	=	$03

//----------------------------------------------
//Functions
Function RT_ControllerDestination_EX(Int idDevice, INT iSubID2, Array A_Data){
	RT_EX(idDevice,RT_ControllerDestination,iSubID2,A_Data);
};
//Channel Pressure
Function RT_ControllerDestination_ChannelPressure_EX(Int idDevice, INT I_Channel, Array A_Data){
	If((I_Channel<1)|(I_Channel>16)){Print("Warning：チャンネルの値が不正です。", I_Channel);};
	If((SizeOf(A_Data)%2)!=0){Print("Warning：データの数が合いません", SizeOf(A_Data));};
	Array A_Data2 = I_Channel-1, A_Data;
	RT_ControllerDestination_EX(idDevice, RT_ControllerDestination_ChannelPressure, A_Data2)
};
Function RT_CD_ChPressure(Array A_Data){
	RT_ControllerDestination_ChannelPressure_EX(Universal_targetDeviceID, Channel, A_Data)
};
//Polyhonic Pressure
Function RT_ControllerDestination_PolyhonicPressure_EX(Int idDevice, INT I_Channel, Array A_Data){
	If((I_Channel<1)|(I_Channel>16)){Print("Warning：チャンネルの値が不正です。", I_Channel);};
	If((SizeOf(A_Data)%2)!=0){Print("Warning：データの数が合いません", SizeOf(A_Data));};
	Array A_Data2 = I_Channel-1, A_Data;
	RT_ControllerDestination_EX(idDevice, RT_ControllerDestination_PolyhonicPressure, A_Data2)
};
Function RT_CD_PolyPressure(Array A_Data){
	RT_ControllerDestination_PolyhonicPressure_EX(Universal_targetDeviceID, Channel, A_Data)
};
//Control Change Message
Function RT_ControllerDestination_ControlChangeMessage_EX(Int idDevice, INT I_Channel, INT I_CC, Array A_Data){
	If((I_Channel<1)|(I_Channel>16)){Print("Warning：チャンネルの値が不正です。", I_Channel);};
	If((SizeOf(A_Data)%2)!=0){Print("Warning：データの数が合いません", SizeOf(A_Data));};
	Array A_Data2 = I_Channel-1, I_CC, A_Data;
	RT_ControllerDestination_EX(idDevice, RT_ControllerDestination_ControlChangeMessage, A_Data2)
};
Function RT_CD_CC(INT I_CC, Array A_Data){
	RT_ControllerDestination_ControlChangeMessage_EX(Universal_targetDeviceID, Channel, I_CC, A_Data)
};

//======================================================
//		Key-Based Instrument Controllers
//======================================================
//Sub-ID#1
INT RT_KeyBasedInstrument			=	$0A

//----------------------------------------------
//Sub-ID#2
//Key-Based Instrument Controllers (CA-023)
INT RT_KeyBasedInstrument_Basic						=	$01

//----------------------------------------------
//Functions
Function RT_KeyBasedInstrument_EX(Int idDevice, INT iSubID2, Array A_Data){
	RT_EX(idDevice,RT_KeyBasedInstrument,iSubID2,A_Data);
};
//BASIC
Function RT_KeyBasedInstrument_Basic_EX(Int idDevice, INT I_Channel, INT I_Key, Array A_Data){
	If((I_Channel<1)|(I_Channel>16)){Print("Warning：チャンネルの値が不正です。",I_Channel);};
	If((SizeOf(A_Data)%2)!=0){Print("Warning：データの数が合いません",SizeOf(A_Data));};
	Array A_Data2 = I_Channel-1, I_Key, A_Data;
	RT_KeyBasedInstrument_EX(idDevice, RT_KeyBasedInstrument_Basic, A_Data2);
};
Function RT_KeyBased_Basic(INT I_Key, Array A_Data){
	RT_KeyBasedInstrument_Basic_EX(Universal_targetDeviceID, Channel, I_Key, A_Data)
};

