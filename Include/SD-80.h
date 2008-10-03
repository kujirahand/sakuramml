/*
	SD-80 NativeMode 定義ファイル
*/
//------------------------------------------------------------------------------
//MEMO:
//SysEx 雛型
//SysEx=$F0,$41,(DeviceNumber),0,$48,$12,{ (ADDR),(DATA) },$F7;

//------------------------------------------------------------------------------
//_NATIVE_MODE
Function SD80NativeMode(){SysEx$=f0,41,(DeviceNumber),00,48,12,0,0,0,0,0,0,f7;}

//------------------------------------------------------------------------------
//_VOICE_BANK_FOR_NATIVE_MODE
Int BANK_CLASSIC = 96;
Int BANK_CONTEMP = 97;
Int BANK_SOLO = 98;
Int BANK_ENHANCED = 99;
Int BANK_SPECIAL1 = 80;
Int BANK_SPECIAL2 = 81;
/* sample:Voice
SD80NativeMode(); r2;
Voice(SynthBass1, BANK_CLASSIC, 0);
*/

//------------------------------------------------------------------------------
//_REVERB
//------------------------------------------------------------------------------
//REVERB TYPE
Int RT_OFF         = 0;
Int RT_REVERB      = 1;
Int RT_SRV_ROOM    = 2;
Int RT_SRV_HALL    = 3;
Int RT_SRV_PLATE   = 4;
Int RT_GM2_REVERB  = 5;
Function SD80ReverbType(V){//0~5
	SysEx=$F0,$41,(DeviceNumber),0,$48,$12,{$10,00,$04,00,(V)},$F7;}
Function SD80ReverbTime(V){//0~127
	SysEx$=F0,41,10,00,48,12,{10,00,04,07,08,00,(HIGH(V)),(LOW(V))},F7;}

/* sample: Reverb
SD80ReverbType(RT_REVERB);r8
REV(127) l8
SD80ReverbTime(0);
cdefgfed cdefgfed
SD80ReverbTime(127);
cdefgfed cegec^^^^^^
*/

