//===========================================================================
//
//		Define for MIDI Standard
//
//
//									Programmed by	A.Watanabe
//
//---------------------------------------------------------------------------
//
//	Reference
//		(1)	MIDI Standard 1.0  v96.1
//		(2)	MIDI Standard 1.0  next edition		http://www.midi.org/
//
//===========================================================================
Include(midistd_cc.h);					//Control Change Message Define
Include(midistd_ex.h);					//System Exclusive Message Define

//Debug用(Bit)
INT MidiStd_Debug = $0001;				//01 : 引数内容をCheckする。(主にRange)
										//02 : MMLへの変換結果をPromptに出力する。
										//04 : 未定義
										//	～
										//80 : 未定義

//======================================================
//					Functions
//======================================================
//==============================================
//		数値を分解します
//		（共通のエクスクルーシブ送信命令）
//----------------------------------------------
//		Input
//			INT	iSize	いくつの配列変数にするか？
//			INT	iValue	数値(LSBが最初)
//		OutPut
//			Array	
//----------------------------------------------
Function DivValue(INT I_Size, INT I_Value){

	//ローカル変数定義
	INT NumMul;						//演算用
	Array	A_Value=();				//返り値用の配列変数

	//引数のレンジCheck
	If(MidiStd_Debug & $01){
		//最大値の計算
		INT	I_ValueMax=1;			//最大値計算用
		For(Int Loop=0; Loop<I_Size; Loop++) {
			I_ValueMax = (I_ValueMax*128);
		};

		//最大値を超えているかCheck
		If( (I_Value<0) | (I_Value=>I_ValueMax) ){
			Print("Wanning 引数の範囲を超えています。 Data=",I_Value);
			I_Value=0;
		};
	};

	//分解処理
	For(INT Loop=0; Loop<I_Size; Loop++){
		NumMul = 1;
		For(Int LoopMul=0; LoopMul<Loop; LoopMul++) {
			NumMul = (NumMul*128);
		};
		A_Value(Loop)=(I_Value & $7F*NumMul)/NumMul;
	};

	//返り値
	Result = A_Value;
};
//==============================================
//		数値を分解します
//		（共通のエクスクルーシブ送信命令）
//----------------------------------------------
//		Input
//			INT	iSize	いくつの配列変数にするか？
//			INT	iValue	数値(LSBが最後)
//		OutPut
//			Array	
//----------------------------------------------
Function DivValueX(INT I_Size, INT I_Value){

	//ローカル変数定義
	INT NumMul;						//演算用
	Array	A_Value=();				//返り値用の配列変数

	//引数のレンジCheck
	If(MidiStd_Debug & $01){
		//最大値の計算
		INT	I_ValueMax=1;			//最大値計算用
		For(Int Loop=0; Loop<I_Size; Loop++) {
			I_ValueMax = (I_ValueMax*128);
		};

		//最大値を超えているかCheck
		If( (I_Value<0) | (I_Value=>I_ValueMax) ){
			Print("Wanning 引数の範囲を超えています。 Data=",I_Value);
			I_Value=0;
		};
	};

	//分解処理
	For(INT Loop=0; Loop<I_Size; Loop++){
		NumMul = 1;
		For(Int LoopMul=0; LoopMul<Loop; LoopMul++) {
			NumMul = (NumMul*128);
		};
		A_Value(I_Size-Loop-1)=(I_Value & $7F*NumMul)/NumMul;
	};

	//返り値
	Result = A_Value;
};
//==============================================
//		CheckSUM
//----------------------------------------------
//		Input
//			Array	A_Data		データ
//		OutPut
//			INT		CheckSum	チェックサム
//----------------------------------------------
Function CheckSum(Array A_Data){
	INT	A_Length=SizeOf(A_Data);
	INT	I_CheckSum=$00;

	For(INT I_Loop=0;I_Loop<A_Length;I_Loop++){
		I_CheckSum = I_CheckSum ^ A_Data(I_Loop);
	};
	Result = I_CheckSum;
};
