//------------------------------------------------------------------------------ Header.
/*
コードジェネレータ『コード５』
ver.1.07 LastUpdate = 2002/12/23　みじんこ

『テンポラリスケーラサポート』
	モード系
	ハーモニック系
	メロディック系

	各種スケールは使用時、全トラックに対して
	有効になり、何を使用したのかがグローバル
	変数へ残ります。

『ディグリーネームサポート』
	トライアド
	Ｓｕｓ４
	７ｔｈ
	９ｔｈ

	Ⅰ,Ⅱ,Ⅲ,Ⅳ,Ⅴ,Ⅵ,Ⅶそれぞれに３和音、４和音
	９ｔｈ、サスペンド４が用意され、全ての和音は
	スケールマクロによって変形します。

『インバートサポート』
	トライアド
	７ｔｈ
	９ｔｈ
	オープンボイシング（＋インターバルスプレッダ）
	クローズボイシング

	和音全体の高さを自由に上下させる事が可能で
	更にオープン・クローズの選択、オープンの場合
	は開き具合を２段階で調節できます。

『インサートコードサポート（オートスケール）』
	セカンダリドミナント
	裏コード
	パッシングディミニッシュ
	ⅡⅤ（親コードマイナー時、Ⅱ＝ｍ７♭５）
	ⅡⅤ（Ⅴ＝裏コード）
	ドッペルドミナント
	ジャズスタイルのドミナント各種

	和音に対し、手前の小節へ様々な機能のコードを
	挿入する事が出来、それによって生じた調号の
	変化や移調は自動で全トラックに適用されます。

『フェイントサポート』
	インサートコード使用時、それを呼び出した
	親コードをミュートするフェイントが使用可能
	です。

『オールミュートサポート』
	曲が完成し chord5.h によるガイド音が
	必要なくなった時、スケールの設定だけを
	残してガイド音を消音する事が出来ます。

『ＴＳＤ指定サポート』
	Ｔ（メジャー系トニック）		１６種
	Ｓ（メジャー系サブドミナント）	１３種
	Ｄ（メジャー系ドミナント）		１２種
	Ｔｍ（マイナー系トニック）		１２種
	Ｓｍ（マイナー系サブドミナント）	１３種
	Ｄｍ（マイナー系ドミナント）		１５種

	コードを機能名で指定可能。
	ディグリーネーム指定でサポートされている
	
	・インバート
	・インサート（オートスケール）
	・フェイント
	・オールミュート
	
	これら全てにアクセス可能、スケールは
	自動設定で、調号の変化が全トラックに
	適用されます。

『オートトランスポジションサポート』
	５度圏への移調を「移調する幅（キーシフト値）」
	ではなく「転調感の強さ」として指定する事が
	出来ます。

	これにより、５度圏、近親調、同主調という
	概念を知らなくても正確に転調する事が出来、
	転調後スムーズに元の調へ戻って来る事が
	可能です。


 (Tab = 6)
*/
//------------------------------------------------------------------------------
Int Open		= 0				// オープンボイシングフラグ(1=open,2=more)
Int NowScale	= 0				// 現在のスケール
Int ModeNo		= 0				// モード指定用変数
Int RootBass	= 0				// ベース音ガイド発音(0=on)
Int Chord5_off	= 0				// 発音フラグ（オフ時、スケーラのみ動作）
Int Feint		= 0				// フェイントフラグ
Int Relative	= 0				// トランス用変数
Int Shift_val	= 0				// トランス用変数
Int InsertMode	= 0				// コンボ用変数
Int LenII		= 0				// コンボ用引数
Int InvII		= 0				// コンボ用引数
Int LenIII		= 0				// コンボ用引数
Int InvIII		= 0				// コンボ用引数
Int Disp		= 1				// ヘルプ表示用フラグ
Int Top		= 0				// トップノート用変数
//------------------------------------------------------------------------------ TransFunction.

Function Trans(Value){
	TimeKey2(,,Shift_val)						// 一旦キーを元へ戻す
	Relative = Value * 5						// 引数を５度圏へ変換
	Shift_val = Relative % 12					// オクターブシフト（余りが実際のKey値）
	If( Shift_val> 6 ){ Shift_val = Shift_val - 12 }	// 上方に対する補正
	If( Shift_val<-6 ){ Shift_val = Shift_val + 12 }	// 下方に対する補正
	TimeKey2(,,Shift_val)						// 目的のキーへシフト
//	Print (Shift_val)
	Shift_val = MML(TimeKey2) - Shift_val			// 次回元へ戻す為の情報を残す
}

//------------------------------------------------------------------------------ InvertFunction.

//=================================
//　トライアドインバート
//=================================
Function Invert3(){
	Int O_value = Inv / 3;			// インバート値は３単位でオクターブアップなので…
	Int O_shift = O_value * 12;		// ３で割った値がオクターブ値になる
	Note1 = Note1 + O_shift;		// それぞれのノートをオクターブ調整
	Note2 = Note2 + O_shift;
	Note3 = Note3 + O_shift;
	Int AAA = O_value * 3;			// オクターブ値に３をかけて…
	Inv = Inv - AAA				// インバート値から引くと「余り」が出る
	/* 「余り」値によってインバート（回転）させる */
	If(Inv==-2){Note3 = Note3 - 12; Note2 = Note2 - 12}
	If(Inv==-1){Note3 = Note3 - 12}
	If(Inv==1){Note1 = Note1 + 12}
	If(Inv==2){Note1 = Note1 + 12; Note2 = Note2 + 12}
	/* オープン化 */
	If(Open==1){
		Note3 = Note3 - 12;
	}
	If(Open==2){
		Note3 = Note3 - 12;
		Note2 = Note2 + 12;
	}
}

//=================================
//　７ｔｈインバート
//=================================
Function Invert4(){
	Int O_value = Inv / 4;			// インバート値は４単位でオクターブアップなので…
	Int O_shift = O_value * 12;		// ４で割った値がオクターブ値になる
	Note1 = Note1 + O_shift;		// それぞれのノートをオクターブ調整
	Note2 = Note2 + O_shift;
	Note3 = Note3 + O_shift;
	Note4 = Note4 + O_shift;
	Int AAA = O_value * 4;			// オクターブ値に４をかけて…
	Inv = Inv - AAA				// インバート値から引くと「余り」が出る
	/* 「余り」値によってインバート（回転）させる */
	If(Inv==-3){Note4 = Note4 - 12; Note3 = Note3 - 12; Note2 = Note2 - 12}
	If(Inv==-2){Note4 = Note4 - 12; Note3 = Note3 - 12}
	If(Inv==-1){Note4 = Note4 - 12}
	If(Inv==1){Note1 = Note1 + 12}
	If(Inv==2){Note1 = Note1 + 12; Note2 = Note2 + 12}
	If(Inv==3){Note1 = Note1 + 12; Note2 = Note2 + 12; Note3 = Note3 + 12}
	/* オープン化 */
	If(Open==1){
		Note3 = Note3 - 12;
	}
	If(Open==2){
		Note3 = Note3 - 12;
		Note2 = Note2 + 12;
	}
}

//=================================
//　９ｔｈインバート
//=================================
Function Invert5(){
	Int O_value = Inv / 4;			// インバート値は４単位でオクターブアップなので…
	Int O_shift = O_value * 12;		// ４で割った値がオクターブ値になる
	Note1 = Note1 + O_shift;		// それぞれのノートをオクターブ調整
	Note2 = Note2 + O_shift;
	Note3 = Note3 + O_shift;
	Note4 = Note4 + O_shift;
	Int AAA = O_value * 4;			// オクターブ値に４をかけて…
	Inv = Inv - AAA				// インバート値から引くと「余り」が出る
	/* 「余り」値によってインバート（回転）させる */
	If(Inv==-3){Note4 = Note4 - 12; Note3 = Note3 - 12; Note2 = Note2 - 12}
	If(Inv==-2){Note4 = Note4 - 12; Note3 = Note3 - 12}
	If(Inv==-1){Note4 = Note4 - 12}
	If(Inv==1){Note1 = Note1 + 12}
	If(Inv==2){Note1 = Note1 + 12; Note2 = Note2 + 12}
	If(Inv==3){Note1 = Note1 + 12; Note2 = Note2 + 12; Note3 = Note3 + 12}
	/* オープン化 */
	If(Open==1){
		Note3 = Note3 - 12;
	}
	If(Open==2){
		Note3 = Note3 - 12;
		Note2 = Note2 + 12;
	}
}
//------------------------------------------------------------------------------ KeyMacro.
/* chord3.h compatible */
#KEY_C	= {TimeKey(,,0)}
#KEY_Cp	= {TimeKey(,,1)}
#KEY_D	= {TimeKey(,,2)}
#KEY_Dp	= {TimeKey(,,3)}
#KEY_E	= {TimeKey(,,4)}
#KEY_F	= {TimeKey(,,5)}
#KEY_Fp	= {TimeKey(,,6)}
#KEY_G	= {TimeKey(,,-5)}
#KEY_Gp	= {TimeKey(,,-4)}
#KEY_A	= {TimeKey(,,-3)}
#KEY_Ap	= {TimeKey(,,-2)}
#KEY_B	= {TimeKey(,,-1)}
/* extension */
#KEY_Dm	= {TimeKey(,,1)}
#KEY_Em	= {TimeKey(,,3)}
#KEY_Gm	= {TimeKey(,,6)}
#KEY_Am	= {TimeKey(,,-4)}
#KEY_Bm	= {TimeKey(,,-2)}
//------------------------------------------------------------------------------ ModeMacro.
/* Major scale */
#Major = {
	TimeKeyFlag(,,0,0,0,0,0,0,0);			/* Major scale */
	NowScale = 0
}

/* Minor scale */
#Minor = {
	TimeKeyFlag(,,-1,-1,0,0,-1,0,0);		/* Minor scale */
	NowScale = 5
}

/* Mode */
#Mode = {
	ModeNo = #?1
	If(ModeNo==0){
	TimeKeyFlag(,,0,0,0,0,0,0,0);			/* Ionian */
	NowScale = 0
	}
	If(ModeNo==1){
	TimeKeyFlag(,,0,-1,0,0,-1,0,0);		/* Dorian */
	NowScale = 1
	}
	If(ModeNo==2){
	TimeKeyFlag(,,-1,-1,0,-1,-1,0,0);		/* Phrygian */
	NowScale = 2
	}
	If(ModeNo==3){
	TimeKeyFlag(,,0,0,0,0,0,1,0);			/* Lydian */
	NowScale = 3
	}
	If(ModeNo==4){
	TimeKeyFlag(,,0,-1,0,0,0,0,0);		/* Mixo-Lydian */
	NowScale = 4
	}
	If(ModeNo==5){
	TimeKeyFlag(,,-1,-1,0,0,-1,0,0);		/* Aeolian */
	NowScale = 5
	}
	If(ModeNo==6){
	TimeKeyFlag(,,-1,-1,0,-1,-1,0,-1);		/* Locrian */
	NowScale = 6
	}
	If(ModeNo==7){
	TimeKeyFlag(,,1,0,0,1,1,1,0);			/* Pentatonic minor blues */
	NowScale = 7
	}
}

/* Harmonic minor class */
#HMinor = {
	ModeNo = #?1
	If(ModeNo==0){
	TimeKeyFlag(,,-1,0, 0,0,-1,0,0);		/* Harmonic minor */
	NowScale = 10
	}
	If(ModeNo==1){
	TimeKeyFlag(,,0,-1,0,-1,-1,0,-1);		/* Locrian natural13 */
	NowScale = 11
	}
	If(ModeNo==2){
	TimeKeyFlag(,,0,0,0,0,0,0,1);			/* Ionian #5 */
	NowScale = 12
	}
	If(ModeNo==3){
	TimeKeyFlag(,,0,-1,0,0,-1,1,0);		/* Dorian #11 */
	NowScale = 13
	}
	If(ModeNo==4){
	TimeKeyFlag(,,-1,-1,0,-1,0,0,0);		/* Harmonic minor perfect 5th below */
	NowScale = 14
	}
	If(ModeNo==5){
	TimeKeyFlag(,,0,0,0,1,0,1,0);			/* Lydian #9 */
	NowScale = 15
	}
	If(ModeNo==6){
	TimeKeyFlag(,,-1,-2,0,-1,-1,-1,-1);		/* Altered -7 */
	NowScale = 16
	}
}

/* Melodic minor class */
#MMinor = {
	ModeNo = #?1
	If(ModeNo==0){
	TimeKeyFlag(,,0,0,0,0,-1,0,0);		/* Melodic minor */
	NowScale = 20
	}
	If(ModeNo==1){
	TimeKeyFlag(,,0,-1,0,-1,-1,0,0);		/* Dorian -9 */
	NowScale = 21
	}
	If(ModeNo==2){
	TimeKeyFlag(,,0,0,0,0,0,1,1);			/* Lydian #5 */
	NowScale = 22
	}
	If(ModeNo==3){
	TimeKeyFlag(,,0,-1,0,0,0,1,0);		/* Mixo-Lydian #11 (Lydian 7) */
	NowScale = 23
	}
	If(ModeNo==4){
	TimeKeyFlag(,,-1,-1,0,0,0,0,0);		/* Mixo-Lydian -13 */
	NowScale = 24
	}
	If(ModeNo==5){
	TimeKeyFlag(,,-1,-1,0,0,-1,0,-1);		/* Aeolian -5 (Super Locrian) */
	NowScale = 25
	}
	If(ModeNo==6){
	TimeKeyFlag(,,-1,-1,0,-1,-1,-1,-1);		/* Altered */
	NowScale = 26
	}
	If(ModeNo==7){
	TimeKeyFlag(,,-1,-1,-1,-1,-1,0,0);		/* G Altered */
	NowScale = 27
	}
}

/* Mode Undo */
#ModeUndo = {
	If(NowScale==0){ #Mode(0) }
	If(NowScale==1){ #Mode(1) }
	If(NowScale==2){ #Mode(2) }
	If(NowScale==3){ #Mode(3) }
	If(NowScale==4){ #Mode(4) }
	If(NowScale==5){ #Mode(5) }
	If(NowScale==6){ #Mode(6) }
	If(NowScale==7){ #Mode(7) }
	If(NowScale==10){ #HMinor(0) }
	If(NowScale==11){ #HMinor(1) }
	If(NowScale==12){ #HMinor(2) }
	If(NowScale==13){ #HMinor(3) }
	If(NowScale==14){ #HMinor(4) }
	If(NowScale==15){ #HMinor(5) }
	If(NowScale==16){ #HMinor(6) }
	If(NowScale==20){ #MMinor(0) }
	If(NowScale==21){ #MMinor(1) }
	If(NowScale==22){ #MMinor(2) }
	If(NowScale==23){ #MMinor(3) }
	If(NowScale==24){ #MMinor(4) }
	If(NowScale==25){ #MMinor(5) }
	If(NowScale==26){ #MMinor(6) }
	If(NowScale==27){ #MMinor(7) }
}

//------------------------------------------------------------------------------ MainFunction.

/* Ⅱ */
Function Two(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert4()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Chord5_off==0){
		If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		r%(Len);
	}
}

/* Ⅴ */
Function Domi(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert4()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Chord5_off==0){
		If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		r%(Len);
	}
}

/* dim */
Function Dimi(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert4()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Chord5_off==0){
		If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		r%(Len)
	}
}



/* Secondry dominant insert */
Function SecD(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	/* 元コードがマイナーだったらドミナントはハーモニック */
	If(Which_is==4){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==3){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(Which_is==-8){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==-9){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レ・ファの和音　Combo!!"} }
	Domi(LenII,InvII+DefInv+Inv)			// ドミナントを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
}

/* Secondry dominant sub-chord insert */
Function SubD(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,-1,-1,-1,-1,-1,0,0)		// オルタード・パーフェクト５thビロウ
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音　Combo!!"} }
	Two(LenII,InvII+DefInv+Inv)			// 裏ドミナントを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
}

/* Passing diminished insert */
Function P_Dim(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,-1,0,0,0,-1,0,0)		// ハーモニックマイナー
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝シ　　シ・レ・ファ・ラの和音　Combo!!"} }
	Dimi(LenII,InvII+DefInv+Inv)			// パッシングを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
}

/* ⅡⅤ insert */
Function SecD_2(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	/* 元コードがマイナーだったらドミナントはハーモニック */
	//Int Which_is = 4
	If(Which_is==4){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==3){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(Which_is==-8){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==-9){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音　Combo!!"} }
	Two(LenII,InvII+DefInv+Inv)			// Ⅱを挿入
	If(LenIII==0){LenIII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レ・ファの和音　Cool!!"} }
	Domi(LenIII,InvIII+DefInv+Inv)		// ドミナントを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
	LenIII = 0
	InvIII = 0
}

/* Ⅱ + Secondry dominant sub-chord insert */
Function SubD_2(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,0,0,0,0,0,0,0)			// アイオニアン
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音　Combo!!"} }
	Two(LenII,InvII+DefInv+Inv)			// Ⅱを挿入
	TimeKeyFlag(,,-1,-1,-1,-1,-1,0,0)		// Ⅴオルタード
	If(LenIII==0){LenIII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音　Cool!!"} }
	Two(LenIII,InvIII+DefInv+Inv)			// 裏ドミナントを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
	LenIII = 0
	InvIII = 0
}

/* Doppel insert */
Function DopD(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,0,0,0,0,0,1,0)			// リディアン
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音　Combo!!"} }
	Two(LenII,InvII+DefInv+Inv)			// Ⅱを挿入
	If(LenIII==0){LenIII = MML(l)}
	/* 元コードがマイナーだったらドミナントはハーモニック */
	If(Which_is==4){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==3){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(Which_is==-8){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==-9){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レ・ファの和音　Cool!!"} }
	Domi(LenIII,InvIII+DefInv+Inv)		// ドミナントを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
	LenIII = 0
	InvIII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD1(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,0,0,1,0,0,0,0)			// Ⅴ7リディアン７ｔｈ
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レ・ファの和音　Jazzy!!"} }
	Domi(LenII,InvII+DefInv+Inv)			// ドミナントを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD2(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,-1,-1,-1,-1,-1,0,0)		// Ⅴm7♭5オルタード
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レ・ファの和音　Jazzy!!"} }
	Domi(LenII,InvII+DefInv+Inv)			// ドミナントを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD3(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,0,-1,0,-1,-1,0,0)		// Ⅴm7♭5スーパーロクリアン（同ドリアン♭９）
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レ・ファの和音　Jazzy!!"} }
	Domi(LenII,InvII+DefInv+Inv)			// ドミナントを挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD4(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,0,0,1,0,0,0,0)			// Ⅴ7リディアン７ｔｈ
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音　Jazzy!!"} }
	Two(LenII,InvII+DefInv+Inv)			// ⅡmM7を挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD5(){
	Int KSValue = Note0 - NoteNo(o4c);		// ドとルートのインターバルを調べる
	If(KSValue<-4){KSValue=KSValue+12}		// ベースが低過ぎたらオクターブアップ
	Int NowKey = MML(TimeKey);			// キーシフト値を調べて
	Int KSTrue = KSValue + NowKey			// セカンダリのスケール開始地点を出す
	TimeKey(,,KSTrue);				// セカンダリのルートへ移調
	TimeKeyFlag(,,0,-1,0,-1,-1,0,0)		// Ⅴm7♭5スーパーロクリアン（同ドリアン♭９）
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音　Jazzy!!"} }
	Two(LenII,InvII+DefInv+Inv)			// ⅡaugM7を挿入
	TimeKey(,,NowKey)					// 調を元へ戻す
	#ModeUndo						// スケールも元へ戻す
	LenII = 0
	InvII = 0
}



/* C_ */
Function C_(Len,Inv){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o4e) - NoteNo(o4c)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ド　　ド・ミ・ソの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ド　　ド・ミ・ソの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* D_ */
Function D_(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o4f) - NoteNo(o4d)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* E_ */
Function E_(Len,Inv){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Which_is = NoteNo(o4g) - NoteNo(o4e)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ミ　　ミ・ソ・シの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ミ　　ミ・ソ・シの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* F_ */
Function F_(Len,Inv){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o4a) - NoteNo(o4f)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ファ　ファ・ラ・ドの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ファ　ファ・ラ・ドの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* G_ */
Function G_(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5b);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o4b) - NoteNo(o4g)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* A_ */
Function A_(Len,Inv){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o5c) - NoteNo(o4a)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ラ　　ラ・ド・ミの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ラ　　ラ・ド・ミの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* B_ */
Function B_(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5b);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o5d) - NoteNo(o4b)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝シ　　シ・レ・ファの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝シ　　シ・レ・ファの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* Csus4 */
Function C_4(Len,Inv){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o4e) - NoteNo(o4c)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ド　　ド・ファ・ソの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ド　　ド・ファ・ソの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* Dsus4 */
Function D_4(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o4f) - NoteNo(o4d)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝レ　　レ・ソ・ラの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝レ　　レ・ソ・ラの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* Esus4 */
Function E_4(Len,Inv){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Which_is = NoteNo(o4g) - NoteNo(o4e)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ミ　　ミ・ラ・シの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ミ　　ミ・ラ・シの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* Fsus4 */
Function F_4(Len,Inv){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5b);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o4a) - NoteNo(o4f)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ファ　ファ・シ・ドの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ファ　ファ・シ・ドの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* Gsus4 */
Function G_4(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o6c);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o4b) - NoteNo(o4g)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ソ　　ソ・ド・レの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ソ　　ソ・ド・レの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* Asus4 */
Function A_4(Len,Inv){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o5c) - NoteNo(o4a)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ラ　　ラ・レ・ミの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ラ　　ラ・レ・ミの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* Bsus4 */
Function B_4(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5b);
	Int Which_is = NoteNo(o5d) - NoteNo(o4b)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝シ　　シ・ミ・ファの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝シ　　シ・ミ・ファの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* C7 */
Function C_7(Len,Inv){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5e);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Int Which_is = NoteNo(o4e) - NoteNo(o4c)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ド　　ド・ミ・ソ・シの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ド　　ド・ミ・ソ・シの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* D7 */
Function D_7(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5c);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4f) - NoteNo(o4d)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝レ　　レ・ファ・ラ・ドの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* E7 */
Function E_7(Len,Inv){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4g) - NoteNo(o4e)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ミ　　ミ・ソ・シ・レの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ミ　　ミ・ソ・シ・レの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* F7 */
Function F_7(Len,Inv){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o4a) - NoteNo(o4f)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ファ　ファ・ラ・ド・ミの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ファ　ファ・ラ・ド・ミの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* G7 */
Function G_7(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4b) - NoteNo(o4g)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -3; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レ・ファの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ソ　　ソ・シ・レ・ファの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* A7 */
Function A_7(Len,Inv){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5c);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o5c) - NoteNo(o4a)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  2; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ラ　　ラ・ド・ミ・ソの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ラ　　ラ・ド・ミ・ソの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* B7 */
Function B_7(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o5d) - NoteNo(o4b)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝シ　　シ・レ・ファ・ラの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝シ　　シ・レ・ファ・ラの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* C9 */
Function C_9(Len,Inv){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4e) - NoteNo(o4c)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ド　　ミ・ソ・シ・レの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ド　　ミ・ソ・シ・レの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* D9 */
Function D_9(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o4f) - NoteNo(o4d)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝レ　　ファ・ラ・ド・ミの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝レ　　ファ・ラ・ド・ミの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* E9 */
Function E_9(Len,Inv){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4g) - NoteNo(o4e)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ミ　　ソ・シ・レ・ファの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ミ　　ソ・シ・レ・ファの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* F9 */
Function F_9(Len,Inv){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o4a) - NoteNo(o4f)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ファ　ラ・ド・ミ・ソの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ファ　ラ・ド・ミ・ソの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* G9 */
Function G_9(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4b) - NoteNo(o4g)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ソ　　シ・レ・ファ・ラの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ソ　　シ・レ・ファ・ラの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* A9 */
Function A_9(Len,Inv){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o5c) - NoteNo(o4a)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  1; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  1; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  1; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  2; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  1; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  1; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  1; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  1; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝ラ　　ド・ミ・ソ・シの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝ラ　　ド・ミ・ソ・シの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* B9 */
Function B_9(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o5d) - NoteNo(o4b)		// メジャーかマイナーかを残す
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// セカンダリドミナント
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// 裏コード
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// パッシングディミニッシュ
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// ⅡⅤ
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// ⅡⅤ（裏コード）
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// ドッペルドミナント
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// Ⅴリディアン７ｔｈ
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// Ⅴオルタード
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// Ⅴスーパーロクリアン（同ドリアン♭９）
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// Ⅴリディアン７ｔｈⅡmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// ⅤスーパーロクリアンⅡaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"ベース＝シ　　レ・ファ・ラ・ドの和音"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"ベース＝シ　　レ・ファ・ラ・ドの和音"} }
		r%(Len)
	}
	Feint = 0
}

/* Insert */
Function Combo1(val1,val2,val3,val4){
	InsertMode = 1
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo2(val1,val2,val3,val4){
	InsertMode = 2
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo3(val1,val2,val3,val4){
	InsertMode = 3
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo4(val1,val2,val3,val4){
	InsertMode = 4
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo5(val1,val2,val3,val4){
	InsertMode = 5
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo6(val1,val2,val3,val4){
	InsertMode = 6
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo7(val1,val2,val3,val4){
	InsertMode = 7
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo8(val1,val2,val3,val4){
	InsertMode = 8
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo9(val1,val2,val3,val4){
	InsertMode = 9
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo10(val1,val2,val3,val4){
	InsertMode = 10
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo11(val1,val2,val3,val4){
	InsertMode = 11
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}


/* Ⅰ */		Function T1(val1,val2){#Mode(0) C_(val1,val2)}
/* Ⅵm */		Function T2(val1,val2){#Mode(0) A_(val1,val2)}
/* Ⅲm */		Function T3(val1,val2){#Mode(0) E_(val1,val2)}
/* Ⅰsus4 */	Function T4(val1,val2){#Mode(0) C_4(val1,val2)}
/* Ⅵsus4 */	Function T5(val1,val2){#Mode(0) A_4(val1,val2)}
/* Ⅲsus4 */	Function T6(val1,val2){#Mode(0) E_4(val1,val2)}
/* Ⅰmaj7 */	Function T7(val1,val2){#Mode(0) C_7(val1,val2)}
/* Ⅵm7 */		Function T8(val1,val2){#Mode(0) A_7(val1,val2)}
/* Ⅲm7 */		Function T9(val1,val2){#Mode(0) E_7(val1,val2)}
/* Ⅰmaj9 */	Function T10(val1,val2){#Mode(0) C_9(val1,val2)}
/* Ⅵm9 */		Function T11(val1,val2){#Mode(0) A_9(val1,val2)}
/* Ⅲm9 */		Function T12(val1,val2){#Mode(0) E_9(val1,val2)}
/* Ⅰ7(-7) */	Function T13(val1,val2){#Mode(4) C_(val1,val2)}
/* Ⅰ7 */		Function T14(val1,val2){#Mode(4) C_7(val1,val2)}
/* Ⅲ7 */		Function T15(val1,val2){#HMinor(2) E_7(val1,val2)}
/* Ⅰaug */		Function T16(val1,val2){#HMinor(2) C_(val1,val2)}

/* Ⅳ */		Function S1(val1,val2){#Mode(0) F_(val1,val2)}
/* Ⅱm */		Function S2(val1,val2){#Mode(0) D_(val1,val2)}
/* Ⅱ */		Function S3(val1,val2){#Mode(3) D_(val1,val2)}
/* Ⅳsus4 */	Function S4(val1,val2){#Mode(4) F_4(val1,val2)}
/* Ⅱsus4 */	Function S5(val1,val2){#Mode(0) D_4(val1,val2)}
/* Ⅳmaj7 */	Function S6(val1,val2){#Mode(0) F_7(val1,val2)}
/* Ⅱm7 */		Function S7(val1,val2){#Mode(0) D_7(val1,val2)}
/* Ⅳ#m7♭5 */	Function S8(val1,val2){#MMinor(3) F_7(val1,val2)}
/* Ⅳmaj9 */	Function S9(val1,val2){#Mode(0) F_9(val1,val2)}
/* Ⅱm9 */		Function S10(val1,val2){#Mode(0) D_9(val1,val2)}
/* Ⅱ9 */		Function S11(val1,val2){#Mode(3) D_9(val1,val2)}
/* Ⅳ7 */		Function S12(val1,val2){#MMinor(0) F_7(val1,val2)}
/* Ⅱ7 */		Function S13(val1,val2){#Mode(3) D_7(val1,val2)}

/* Ⅴ */		Function D1(val1,val2){#Mode(0) G_(val1,val2)}
/* Ⅶm♭5 */	Function D2(val1,val2){#Mode(0) B_(val1,val2)}
/* Ⅶ♭ */		Function D3(val1,val2){#Mode(4) B_(val1,val2)}
/* Ⅴsus4 */	Function D4(val1,val2){#Mode(0) G_4(val1,val2)}
/* Ⅴ7 */		Function D5(val1,val2){#Mode(0) G_7(val1,val2)}
/* Ⅶm7♭5 */	Function D6(val1,val2){#Mode(0) B_7(val1,val2)}
/* Ⅶ♭maj7 */	Function D7(val1,val2){#Mode(4) B_7(val1,val2)}
/* Ⅴ9 */		Function D8(val1,val2){#Mode(0) G_9(val1,val2)}
/* Ⅶ♭maj9 */	Function D9(val1,val2){#Mode(4) B_9(val1,val2)}
/* Ⅴmaj7 */	Function D10(val1,val2){#Mode(3) G_7(val1,val2)}
/* Ⅶm */		Function D11(val1,val2){#Mode(3) B_(val1,val2)}
/* Ⅶm7 */		Function D12(val1,val2){#Mode(3) B_7(val1,val2)}

/* Ⅰm */		Function Tm1(val1,val2){#Mode(5) C_(val1,val2)}
/* Ⅲ♭ */		Function Tm2(val1,val2){#Mode(5) E_(val1,val2)}
/* Ⅰsus4 */	Function Tm3(val1,val2){#Mode(5) C_4(val1,val2)}
/* Ⅲ♭sus4 */	Function Tm4(val1,val2){#Mode(5) E_4(val1,val2)}
/* Ⅰm7 */		Function Tm5(val1,val2){#Mode(5) C_7(val1,val2)}
/* Ⅲ♭maj7 */	Function Tm6(val1,val2){#Mode(5) E_7(val1,val2)}
/* Ⅰm9 */		Function Tm7(val1,val2){#Mode(5) C_9(val1,val2)}
/* Ⅲ♭maj9 */	Function Tm8(val1,val2){#Mode(5) E_9(val1,val2)}
/* ⅠmM7 */		Function Tm9(val1,val2){#MMinor(0) C_7(val1,val2)}
/* Ⅲ♭7 */		Function Tm10(val1,val2){#Mode(2) E_7(val1,val2)}
/* Ⅰdim */		Function Tm11(val1,val2){#HMinor(6) C_7(val1,val2)}
/* Ⅲ♭augM7 */	Function Tm12(val1,val2){#MMinor(0) E_7(val1,val2)}

/* Ⅳm */		Function Sm1(val1,val2){#Mode(5) F_7(val1,val2)}
/* Ⅵ♭ */		Function Sm2(val1,val2){#Mode(5) A_(val1,val2)}
/* Ⅱm♭5 */	Function Sm3(val1,val2){#Mode(5) D_(val1,val2)}
/* Ⅳsus4 */	Function Sm4(val1,val2){#Mode(5) F_4(val1,val2)}
/* Ⅵ♭sus4 */	Function Sm5(val1,val2){#Mode(2) A_4(val1,val2)}
/* Ⅳm7 */		Function Sm6(val1,val2){#Mode(5) F_7(val1,val2)}
/* Ⅵ♭maj7 */	Function Sm7(val1,val2){#Mode(5) A_7(val1,val2)}
/* Ⅱm7♭5 */	Function Sm8(val1,val2){#Mode(5) D_7(val1,val2)}
/* Ⅳm9 */		Function Sm9(val1,val2){#Mode(5) F_9(val1,val2)}
/* Ⅵ♭maj9 */	Function Sm10(val1,val2){#Mode(5) A_9(val1,val2)}
/* Ⅳ7 */		Function Sm11(val1,val2){#Mode(1) F_7(val1,val2)}
/* Ⅵm7♭5 */	Function Sm12(val1,val2){#Mode(1) A_7(val1,val2)}
/* Ⅱm7 */		Function Sm13(val1,val2){#Mode(1) D_7(val1,val2)}

/* Ⅴm */		Function Dm1(val1,val2){#Mode(5) G_(val1,val2)}
/* Ⅴ */		Function Dm2(val1,val2){#HMinor(0) G_(val1,val2)}
/* Ⅶ♭ */		Function Dm3(val1,val2){#Mode(5) B_(val1,val2)}
/* Ⅱ♭ */		Function Dm4(val1,val2){#Mode(2) D_(val1,val2)}
/* Ⅴsus4 */	Function Dm5(val1,val2){#Mode(5) G_4(val1,val2)}
/* Ⅶ♭sus4 */	Function Dm6(val1,val2){#Mode(5) B_4(val1,val2)}
/* Ⅴm7 */		Function Dm7(val1,val2){#Mode(5) G_7(val1,val2)}
/* Ⅴ7 */		Function Dm8(val1,val2){#HMinor(0) G_7(val1,val2)}
/* Ⅶ♭7 */		Function Dm9(val1,val2){#Mode(5) B_7(val1,val2)}
/* Ⅱ♭maj7 */	Function Dm10(val1,val2){#Mode(2) D_7(val1,val2)}
/* Ⅶ♭maj7 */	Function Dm11(val1,val2){#Mode(1) B_7(val1,val2)}
/* Ⅴm9 */		Function Dm12(val1,val2){#Mode(1) G_9(val1,val2)}
/* Ⅱ♭maj9 */	Function Dm13(val1,val2){#Mode(2) D_9(val1,val2)}
/* Ⅶ♭m7 */	Function Dm14(val1,val2){#Mode(2) B_7(val1,val2)}
/* Ⅶdim */		Function Dm15(val1,val2){#HMinor(0) B_7(val1,val2)}

Function TopNote(val){ Top = val }



