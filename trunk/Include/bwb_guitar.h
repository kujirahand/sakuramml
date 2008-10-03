//----------------------------------------------------------------------------------------------
//_bwb_guitar.h
//		by	青い白熊		(bluewhitebear@hotmail.com)
//		Hp	Blue Darkness	(http://www.nothing-kb.jp/~bluedarkness/)
//----------------------------------------------------------------------------------------------
//_ユーザー変数
//	※弦の並びは「6弦,5弦,4弦,3弦,2弦,1弦」の順です。
Array	BG_STRINGS=0,0,0,0,0,0;			//弦ごとのベロシティの追加量
Int	BG_KEY=0;					//全体のチューニング、カポ（半音単位）
Int	BG_LAG=!128;				//ストローク時のズレ
Int	BG_PEDAL=off;				//握る度にペダルを踏んで、リリースを再現する
Int	BG_PRINT=off;				//表示機能
Int	BG_VELOCITY_FIRST=20;			//最初の音のベロシティ加算値（最初から２番目も半分の値が加算）
Int	BG_VELOCITY_LAST=10;			//最後の音のベロシティ加算値（最後から２番目も半分の値が加算）
Int	BG_VELOCITY_MOMENTUM=-2;		//音を鳴らすごとに加算していくベロシティ値（勢いがなくなる）
Int	BG_ARPEGGIO_MUTE_VELOCITY=-50;	//アルペジオ演奏時のミュート演奏の際の加算ベロシティの値
Int	BG_ARPEGGIO_MUTE_GATE=-20;		//アルペジオ演奏時のミュート演奏の際の加算ゲートの値
Int	BG_RHYTHM_MUTE_VELOCITY=-30;		//リズム演奏時のミュート演奏の際の加算ベロシティの値
Int	BG_RHYTHM_MUTE_GATE=-40;		//リズム演奏時のミュート演奏の際の加算ゲートの値
//----------------------------------------------------------------------------------------------
//_システム変数
Array	BG_FINGER=0,0,0,0,0,0;			//押さえている箇所
Int	BG_POSITION=1;				//ポジションの高さ（１～５）
Array	BG_OPEN=40,45,50,55,59,64;		//開放弦のノートを指定
//----------------------------------------------------------------------------------------------
//_内部処理の関数
//_握る[BG_GRASP(内部配列変数)]
Function BG_GRASP(Array BG_GRASP_ARRAY){
	//ペダル処理
	If(BG_PEDAL==on){
		y64,0;r*(%1);y64,127;r*(-%1);
		If(BG_PRINT==on){Print({"y64,0;r*(%1);y64,127;r*(-%1);"});}
		}

	//配列処理
	If(BG_GRASP_ARRAY(0)<0){BG_POSITION=1;}
	If(BG_GRASP_ARRAY(0)>5){BG_POSITION=5;}
	If( (BG_GRASP_ARRAY(0)>0)&(BG_GRASP_ARRAY(0)<6) ){BG_POSITION=BG_GRASP_ARRAY(0);}
	For(Int BG_GRASP_I=0;BG_GRASP_I<6;BG_GRASP_I++){
		BG_FINGER(BG_GRASP_I)=BG_GRASP_ARRAY( (BG_POSITION-1)*6 + 1 + BG_GRASP_I );}
}

//_接触振り切りのベロシティ修正の関数
//BG_TOUCHANDGO(鳴らす弦の本数（中弦のミュート込み）,ループ回数,From,To,D:1 U:-1)
Function BG_TOUCHANDGO(Int BG_TOUCHANDGO_I,Int BG_TOUCHANDGO_FOR,Int BG_TOUCHANDGO_FRM,Int BG_TOUCHANDGO_MTO,Int BG_TOUCHANDGO_UD){
	Int	BG_TOUCHANDGO_RESULT
	Switch(BG_TOUCHANDGO_I){
		Case(0){BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST;}
		Case(1){Switch(BG_TOUCHANDGO_FOR){
			Case(BG_TOUCHANDGO_FRM){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST;}
			Case(BG_TOUCHANDGO_FRM+BG_TOUCHANDGO_UD){	BG_TOUCHANDGO_RESULT=BG_VELOCITY_LAST;}
		}	}
		Case(2){Switch(BG_TOUCHANDGO_FOR){
			Case(BG_TOUCHANDGO_FRM){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST;}
			Case(BG_TOUCHANDGO_FRM+BG_TOUCHANDGO_UD){	BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST/2;}
			Case(BG_TOUCHANDGO_MTO){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_LAST;}
		}	}
		Default{Switch(BG_TOUCHANDGO_FOR){
			Case(BG_TOUCHANDGO_FRM){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST;}
			Case(BG_TOUCHANDGO_FRM+BG_TOUCHANDGO_UD){	BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST/2;}
			Case(BG_TOUCHANDGO_MTO-BG_TOUCHANDGO_UD){	BG_TOUCHANDGO_RESULT=BG_VELOCITY_LAST/2;}
			Case(BG_TOUCHANDGO_MTO){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_LAST;}
			Default{		BG_TOUCHANDGO_RESULT=0;}
		}	}
	}
	
	Result=BG_TOUCHANDGO_RESULT;
}
//----------------------------------------------------------------------------------------------
//_実行する関数
//_コードフォーム関数	BG_CHORDFORM
Function BG_CHORDFORM(){
	Str	BG_CHORDFORM_STR={"６弦,５弦,４弦,３弦,２弦,１弦 = "};
	For(Int BG_CHORDFORM_I=0;BG_CHORDFORM_I<6;BG_CHORDFORM_I++){
		If(BG_FINGER(BG_CHORDFORM_I)==-1){
			BG_CHORDFORM_STR=BG_CHORDFORM_STR+{"M"};
			}Else{
			BG_CHORDFORM_STR=BG_CHORDFORM_STR+BG_FINGER(BG_CHORDFORM_I);
		}
		
		If(BG_CHORDFORM_I<5){BG_CHORDFORM_STR=BG_CHORDFORM_STR+{,};}
	}
	
	Print(BG_CHORDFORM_STR)

}
//----------------------------------------------------------------------------------------------
//_ダウンストローク[BGD(l,q,v,t,h,LAG,FROM,TO)]
/*
	BGD(l,q,v,t,h,LAG,FROM,TO)
		l	(BGD_INT_LEN)	・・・	長さ
		q	(BGD_INT_GAT)	・・・	加算ゲート値
		v	(BGD_INT_VEL)	・・・	加算ベロシティ値
		t	(BGD_INT_TIM)	・・・	加算タイミング値
		h	(BGD_INT_HAT)	・・・	onだと、ゲート減算処理で同時に音を止める
		LAG	(BGD_INT_LAG)	・・・	ストローク時のズレの加算値
		FROM	(BGD_INT_FRM)	・・・	何番目の弦から	（初期値６）
		TO	(BGD_INT_MTO)	・・・	何番目までの弦を	（初期値１）
*/
Function BGD(Int BGD_INT_LEN,Int BGD_INT_GAT,Int BGD_INT_VEL,Int BGD_INT_TIM,Int BGD_INT_HAT,Int BGD_INT_LAG,Int BGD_INT_FRM,Int BGD_INT_MTO){
	//ローカル変数宣言
	Int	BGD_MML_VEL=MML(v);	//デフォルトベロシティ取得
	Int	BGD_MML_TIM=MML(t);	//デフォルトタイミング取得
	Int	BGD_MML_GAT=MML(q);	//デフォルトゲート取得
	Int	BGD_MML_HAT=MML(h);	//デフォルトゲート減算値取得
	Int	BGD_FRM;			//内部演奏弦開始変数　[６→１]⇒[０→５]
	Int	BGD_MTO;			//内部演奏弦終了変数　[６→１]⇒[０→５]
	Str	BGD_RUN;			//実行文字列
	Int	BGD_TEMP;			//Temp
	
	//弾く弦の本数の調整　そして内部変数に変換　[６→１]⇒[０→５]
	If( (BGD_INT_FRM<1) | (BGD_INT_FRM>6) ){BGD_FRM=0;}
	If( (BGD_INT_FRM>0) & (BGD_INT_FRM<7) ){BGD_FRM=6-BGD_INT_FRM;}
	For(Int BGD_I=0;BGD_I<6;BGD_I++){	If( BG_FINGER(BGD_FRM)==-1 ){BGD_FRM++;}Else{BGD_I=6;}	}//最低音弦がミュートの場合、弾かない

	If( (BGD_INT_MTO<1) | (BGD_INT_MTO>6) ){BGD_MTO=5;}
	If( (BGD_INT_MTO>0) & (BGD_INT_MTO<7) ){BGD_MTO=6-BGD_INT_MTO;}
	For(Int BGD_I=5;BGD_I>-1;BGD_I--){	If( BG_FINGER(BGD_MTO)==-1 ){BGD_MTO--;}Else{BGD_I=-1;}	}//最高音弦がミュートの場合、弾かない

	BGD_RUN=CHR(39)	//	BGD_RUN='

	//ループによる文字列生成
	If(BGD_FRM<=BGD_MTO){
		For(Int BGD_I=BGD_FRM;BGD_I<=BGD_MTO;BGD_I++){
			If(BG_FINGER(BGD_I)!=-1){
				BGD_TEMP=BG_TOUCHANDGO(BGD_MTO-BGD_FRM,BGD_I,BGD_FRM,BGD_MTO,1)
				BGD_RUN=BGD_RUN+{"v("}+( BGD_MML_VEL+BGD_INT_VEL+BG_STRINGS(BGD_I)+BGD_TEMP+BG_VELOCITY_MOMENTUM*(BGD_I-BGD_FRM) )+{");"};
				BGD_RUN=BGD_RUN+{"t("}+( BGD_MML_TIM+BGD_INT_TIM+((BG_LAG+BGD_INT_LAG)*(BGD_I-BGD_FRM)) )+{");"};
				BGD_RUN=BGD_RUN+{"q("}+( BGD_MML_GAT+BGD_INT_GAT )+{");"};
If( BGD_INT_HAT==on ){	BGD_RUN=BGD_RUN+{"h("}+( BGD_MML_HAT+((BG_LAG+BGD_INT_LAG)*(BGD_I-BGD_FRM)) )+{");"};		}
				BGD_RUN=BGD_RUN+{"n("}+( BG_KEY+BG_OPEN(BGD_I)+BG_FINGER(BGD_I) )+{");"}//,%("}+BGD_INT_LEN+{");"};
			}Else{
				BGD_RUN=BGD_RUN+{"r;"}//(%("}+BGD_INT_LEN+{"));"};
			}
		}

	//実行文字列にベロシティ、タイミング、ゲート、長さの情報を補正
				BGD_RUN=BGD_RUN+{"v("}+BGD_MML_VEL+{");"}
				BGD_RUN=BGD_RUN+{"t("}+BGD_MML_TIM+{");"}
				BGD_RUN=BGD_RUN+{"q("}+BGD_MML_GAT+{");"}
If( BGD_INT_HAT==on ){	BGD_RUN=BGD_RUN+{"h("}+BGD_MML_HAT+{");"}	}
				BGD_RUN=BGD_RUN+CHR(39)+{"%("}+BGD_INT_LEN+{")"}

	//実行　BG_PRINT==onの時、表示も兼ねる
		If(BG_PRINT==on){Print(BGD_RUN);}
		BGD_RUN;

	}Else{Print({"BWB_GUITAR.H ERROR!!"})}	//	「　If(BGD_FRM<=BGD_MTO){　」が満たされない時。
}
//----------------------------------------------------------------------------------------------
//_アップストローク[BGU(l,q,v,t,LAG,FROM,TO)]
/*
	BGU(l,q,v,t,LAG,FROM,TO)
		l	(BGU_INT_LEN)	・・・	長さ
		q	(BGU_INT_GAT)	・・・	加算ゲート値
		v	(BGU_INT_VEL)	・・・	加算ベロシティ値
		t	(BGU_INT_TIM)	・・・	加算タイミング値
		LAG	(BGU_INT_LAG)	・・・	ストローク時のズレの加算値
		FROM	(BGU_INT_FRM)	・・・	何番目の弦から	（初期値１）
		TO	(BGU_INT_MTO)	・・・	何番目までの弦を	（初期値６）
*/
Function BGU(Int BGU_INT_LEN,Int BGU_INT_GAT,Int BGU_INT_VEL,Int BGU_INT_TIM,Int BGU_INT_HAT,Int BGU_INT_LAG,Int BGU_INT_FRM,Int BGU_INT_MTO){
	//ローカル変数宣言
	Int	BGU_MML_VEL=MML(v);	//デフォルトベロシティ取得
	Int	BGU_MML_TIM=MML(t);	//デフォルトタイミング取得
	Int	BGU_MML_GAT=MML(q);	//デフォルトゲート取得
	Int	BGU_MML_HAT=MML(h);	//デフォルトゲート減算値取得
	Int	BGU_FRM;			//内部演奏弦開始変数　[１→６]⇒[５→０]
	Int	BGU_MTO;			//内部演奏弦終了変数　[１→６]⇒[５→０]
	Str	BGU_RUN;			//実行文字列
	Int	BGU_TEMP;			//Temp
	
	//弾く弦の本数の調整　そして内部変数に変換　[１→６]⇒[５→０]
	If( (BGU_INT_FRM<1) | (BGU_INT_FRM>6) ){BGU_FRM=5;}
	If( (BGU_INT_FRM>0) & (BGU_INT_FRM<7) ){BGU_FRM=6-BGU_INT_FRM;}
	For(Int BGU_I=5;BGU_I>-1;BGU_I--){	If( BG_FINGER(BGU_FRM)==-1 ){BGU_FRM--;}Else{BGU_I=-1;}	}//最低音弦がミュートの場合、弾かない

	If( (BGU_INT_MTO<1) | (BGU_INT_MTO>6) ){BGU_MTO=0;}
	If( (BGU_INT_MTO>0) & (BGU_INT_MTO<7) ){BGU_MTO=6-BGU_INT_MTO;}
	For(Int BGU_I=0;BGU_I<6;BGU_I++){	If( BG_FINGER(BGU_MTO)==-1 ){BGU_MTO++;}Else{BGU_I=6;}	}//最高音弦がミュートの場合、弾かない

	BGU_RUN=CHR(39)	//	BGU_RUN='

	//ループによる文字列生成
	If(BGU_FRM>=BGU_MTO){
		For(Int BGU_I=BGU_FRM;BGU_I>=BGU_MTO;BGU_I--){
			If(BG_FINGER(BGU_I)!=-1){
				BGU_TEMP=BG_TOUCHANDGO(BGU_FRM-BGU_MTO,BGU_I,BGU_FRM,BGU_MTO,-1)
				BGU_RUN=BGU_RUN+{"v("}+( BGU_MML_VEL+BGU_INT_VEL+BG_STRINGS(BGU_I)+BGU_TEMP+BG_VELOCITY_MOMENTUM*(BGU_FRM-BGU_I) )+{");"};
				BGU_RUN=BGU_RUN+{"t("}+( BGU_MML_TIM+BGU_INT_TIM+((BG_LAG+BGU_INT_LAG)*(BGU_FRM-BGU_I)) )+{");"};
				BGU_RUN=BGU_RUN+{"q("}+( BGU_MML_GAT+BGU_INT_GAT )+{");"};
If( BGU_INT_HAT==on ){	BGU_RUN=BGU_RUN+{"h("}+( BGU_MML_HAT+((BG_LAG+BGU_INT_LAG)*(BGU_FRM-BGU_I)) )+{");"};		}
				BGU_RUN=BGU_RUN+{"n("}+( BG_KEY+BG_OPEN(BGU_I)+BG_FINGER(BGU_I) )+{");"};
			}Else{
				BGU_RUN=BGU_RUN+{"r;"};
			}
		}

	//実行文字列にベロシティ、タイミング、ゲート、長さの情報を補正
				BGU_RUN=BGU_RUN+{"v("}+BGU_MML_VEL+{");"}
				BGU_RUN=BGU_RUN+{"t("}+BGU_MML_TIM+{");"}
				BGU_RUN=BGU_RUN+{"q("}+BGU_MML_GAT+{");"}
If( BGU_INT_HAT==on ){	BGU_RUN=BGU_RUN+{"h("}+BGU_MML_HAT+{");"}	}
				BGU_RUN=BGU_RUN+CHR(39)+{"%("}+BGU_INT_LEN+{")"}

	//実行　BG_PRINT==onの時、表示も兼ねる
		If(BG_PRINT==on){Print(BGU_RUN);}
		BGU_RUN;

	}Else{Print({"BWB_GUITAR.H ERROR!!"})}	//	「　If(BGD_FRM<=BGD_MTO){　」が満たされない時。
}
//----------------------------------------------------------------------------------------------
//_アルペジオストローク
/*
	BGA{文字列}
		文字列の中にはbwb_guitar.h特有のMMLが使われる。
		以下にそのコマンドと文法をしめす。

	コマンド
		A：６弦を弾きます。
		B：５弦を弾きます。
		C：４弦を弾きます。
		D：３弦を弾きます。
		E：２弦を弾きます。
		F：１弦を弾きます。
		a：６弦を弱く弾きます。
		b：５弦を弱く弾きます。
		c：４弦を弱く弾きます。
		d：３弦を弱く弾きます。
		e：２弦を弱く弾きます。
		f：１弦を弱く弾きます。
		r：休符
		^：タイ
		<：アルペジオコマンド入力モードから一時的に抜け出す
		>：アルペジオコマンド入力モードに戻る 
*/
Function BGA(Str BGA_STR){
	Int	BGA_MML_VEL=MML(v);	//デフォルトベロシティ取得
	Int	BGA_MML_GAT=MML(q);	//デフォルトゲート取得
	Str	BGA_RUN;			//実行文字列
	Int	BGA_MODE=0;			//0:特殊　1:通常

	For(Int BGA_I=1;BGA_I<=SizeOf(BGA_STR);BGA_I++){
		Switch(BGA_MODE){
			Case(0){
				Switch(MID(BGA_STR,BGA_I,1)){
					Case({A}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(0,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({B}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(1,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({C}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(2,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({D}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(3,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({E}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(4,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({F}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(5,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({a}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(0,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({b}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(1,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({c}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(2,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({d}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(3,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({e}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(4,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({f}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(5,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({r}){BGA_RUN=BGA_RUN+{"r"};}
					Case({^}){BGA_RUN=BGA_RUN+{"^"};}
					Case({<}){BGA_MODE=1;}
					Default{BGA_RUN=BGA_RUN+MID(BGA_STR,BGA_I,1);}
				}
			}
			Case(1){
				If(MID(BGA_STR,BGA_I,1)=={>}){BGA_MODE=0;}
				Else{BGA_RUN=BGA_RUN+MID(BGA_STR,BGA_I,1);}
			}
		}
	}
	//実行文字列生成
	BGA_RUN=BGA_RUN+{";v("}+BGA_MML_VEL+{");q("}+BGA_MML_GAT+{");"}

	//実行　BG_PRINT==onの時、表示も兼ねる
	If(BG_PRINT==on){Print(BGA_RUN);}
	BGA_RUN;
}
Function BGA_ADDNOTE(Int BGA_ADDNOTE_NUMBER,Int BGA_VEL,Int BGA_GAT,Int BGA_ADDNOTE_MUTE){
	Str	BGA_ADDNOTE_STR;	//返り文字列
	Int	BGA_ADDVEL		//加算文字列
	Int	BGA_ADDGAT		//加算ゲート

	If(BG_FINGER(BGA_ADDNOTE_NUMBER)==-1){BGA_ADDNOTE_STR={r};}
	Else{
		BGA_ADDVEL=BGA_VEL+BG_STRINGS(BGA_ADDNOTE_NUMBER)
		BGA_ADDGAT=BGA_GAT
		
		If(BGA_ADDNOTE_MUTE==on){
			BGA_ADDVEL=BGA_ADDVEL+BG_ARPEGGIO_MUTE_VELOCITY;
			BGA_ADDGAT=BGA_ADDGAT+BG_ARPEGGIO_MUTE_GATE
		}

		BGA_ADDNOTE_STR={"v("}+BGA_ADDVEL+{")q("}+BGA_ADDGAT+{")n("}+( BG_KEY+BG_OPEN(BGA_ADDNOTE_NUMBER)+BG_FINGER(BGA_ADDNOTE_NUMBER) )+{"),"};

	}
	Result=BGA_ADDNOTE_STR;
}
//----------------------------------------------------------------------------------------------
//_リズムストローク
/*
	BGR{文字列}
		文字列の中にはbwb_guitar.h特有のMMLが使われる。
		以下にそのコマンドと文法をしめす。

	コマンド
		A：全弦ダウンストローク
		S：全弦アップストローク
		Z：低音弦二本をダウンストローク
		X：低音弦二本をアップストローク
		Q：高音弦二本をダウンストローク
		W：高音弦二本をアップストローク
		a：全弦ダウンストローク（弱め）
		s：全弦アップストローク（弱め）
		z：低音弦二本をダウンストローク（弱め）
		x：低音弦二本をアップストローク（弱め）
		q：高音弦二本をダウンストローク（弱め）
		w：高音弦二本をアップストローク（弱め）
		r：休符
		^：タイ
		<：アルペジオコマンド入力モードから一時的に抜け出す
		>：アルペジオコマンド入力モードに戻る 


	文法に関する内容
	Q:	低音弦二本というのはどういうことですか？
	A:	音が低い方から弦を二本選ぶということです。
		例えば、６弦から順番に(1,3,1,1,1,1)というコードフォームであれば、
		６弦と５弦を弾くことになります。
		また、ミュートされた弦がある場合、それはカウントしません。
		例えば、６弦から順番に(2,M,1,2,1,M)というコードフォームであれば、
		５弦がミュートされてるため、カウントせず、
		６弦と４弦のみを弾くことになります。
		高音弦二本というのは同様の作業を音が高い方の弦を二本選ぶことになります。
	
*/
Function BGR(Str BGR_STR){
	//ローカル変数宣言
	Int	BGR_MML_VEL=MML(v);	//デフォルトベロシティ取得
	Int	BGR_MML_TIM=MML(t);	//デフォルトタイミング取得
	Int	BGR_MML_GAT=MML(q);	//デフォルトゲート取得
	Str	BGR_RUN;			//実行文字列
	Int	BGR_MODE=0;			//読み込みモード
	
	Int	BGR_LO			//最低音弦の番号
	Int	BGR_HI			//最高音弦の番号
	For(Int BGR_I=0;BGR_I<6;BGR_I++){	If(BG_FINGER(BGR_I)!=-1){BGR_LO=BGR_I;BGR_I=100;}	}
	For(Int BGR_I=5;BGR_I>-1;BGR_I--){	If(BG_FINGER(BGR_I)!=-1){BGR_HI=BGR_I;BGR_I=-10;}	}

	//文字列処理
	For(Int BGR_I=1;BGR_I<=SizeOf(BGR_STR);BGR_I++){
		Switch(BGR_MODE){
			Case(0){
				Switch(MID(BGR_STR,BGR_I,1)){
					Case({A}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,+1,0);}	//Mute,UD(1:D -1:U),Mode
					Case({S}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,-1,0);}	//	0:All 1:Lo 2:Hi
					Case({Z}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,+1,1);}
					Case({X}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,-1,1);}
					Case({Q}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,+1,2);}
					Case({W}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,-1,2);}
					Case({a}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,+1,0);}
					Case({s}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,-1,0);}
					Case({z}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,+1,1);}
					Case({x}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,-1,1);}
					Case({q}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,+1,2);}
					Case({w}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,-1,2);}
					Case({r}){BGR_RUN=BGR_RUN+{"r"};}
					Case({^}){BGR_RUN=BGR_RUN+{"^"};}
					Case({<}){BGR_MODE=1;}
					Default{BGR_RUN=BGR_RUN+MID(BGR_STR,BGR_I,1);}
				}
			}
			Case(1){
				If(MID(BGR_STR,BGR_I,1)=={>}){BGR_MODE=0;}
				Else{BGR_RUN=BGR_RUN+MID(BGR_STR,BGR_I,1);}
			}
		}
	}
	//実行文字列生成
	BGR_RUN=BGR_RUN+{";v("}+BGR_MML_VEL+{");q("}+BGR_MML_GAT+{");t("}+BGR_MML_TIM+{");"}

	//実行　BG_PRINT==onの時、表示も兼ねる
	If(BG_PRINT==on){Print(BGR_RUN);}
	BGR_RUN;
}

Function BGR_ADDNOTE(Int BGR_ADDNOTE_MUTE,Int BGR_ADDNOTE_UD,Int BGR_ADDNOTE_MODE){
	Str	BGR_ADDNOTE_STR;
	Int	BGR_TEMP=0;

	BGR_ADDNOTE_STR=CHR(39)

	Switch(BGR_ADDNOTE_MODE){
		Case(0){
			Switch(BGR_ADDNOTE_UD){
				Case(1){
					For(Int BGR_I=BGR_LO;BGR_I<=BGR_HI;BGR_I++){
						If(BG_FINGER(BGR_I)!=-1){
							BGR_TEMP=BG_TOUCHANDGO(BGR_HI-BGR_LO,BGR_I,BGR_LO,BGR_HI,BGR_ADDNOTE_UD)
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BGR_TEMP+BG_VELOCITY_MOMENTUM*(BGR_I-BGR_LO) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_I-BGR_LO)) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_I)+BG_FINGER(BGR_I) )+{");"};
						}Else{
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};
						}
					}
				}//Case(1)
				Case(-1){
					For(Int BGR_I=BGR_HI;BGR_I>=BGR_LO;BGR_I--){
						If(BG_FINGER(BGR_I)!=-1){
							BGR_TEMP=BG_TOUCHANDGO(BGR_HI-BGR_LO,BGR_I,BGR_HI,BGR_LO,BGR_ADDNOTE_UD)
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BGR_TEMP+BG_VELOCITY_MOMENTUM*(BGR_HI-BGR_I) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_HI-BGR_I)) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_I)+BG_FINGER(BGR_I) )+{");"};
						}Else{
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};
						}
					}
				}//Case(-1)
		}}
		Case(1){
			Switch(BGR_ADDNOTE_UD){
				Case(1){
					For(Int BGR_I=BGR_LO;BGR_TEMP<2;;BGR_I++){
						If(BG_FINGER(BGR_I)!=-1){
							If(BGR_TEMP==0){
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_FIRST+ BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BG_VELOCITY_MOMENTUM*(BGR_I-BGR_LO) )+{");"};
							}
							If(BGR_TEMP==1){
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_LAST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BG_VELOCITY_MOMENTUM*(BGR_I-BGR_LO) )+{");"};
							}
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_I-BGR_LO)) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_I)+BG_FINGER(BGR_I) )+{");"};
							BGR_TEMP++;		//鳴らす回数のコントロール（２回まで）
						}Else{
						BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};
						}
					}
				}
				Case(-1){
					For(Int BGR_I=BGR_LO+1;BGR_I<=BGR_HI;BGR_I++){
						If(BG_FINGER(BGR_I)!=-1){BGR_TEMP=BGR_I;BGR_I=BGR_HI+1;}	//２音目の弦番号のコントロール
					}
					//１音目の高い音
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_FIRST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_TEMP) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_TEMP)+BG_FINGER(BGR_TEMP) )+{");"};
					//間にミュートが入るのを考慮
					For(Int BGR_I=FRM+1;BGR_I<BGR_TEMP;BGR_I++){BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};}
					//２音目の低い音
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_LAST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_LO)+BG_VELOCITY_MOMENTUM*(BGR_TEMP-BGR_LO) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_TEMP-BGR_LO)) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_LO)+BG_FINGER(BGR_LO) )+{");"};
				}
			}
		}
		Case(2){
			Switch(BGR_ADDNOTE_UD){
				Case(1){
					For(Int BGR_I=BGR_HI-1;BGR_I>=BGR_LO;BGR_I--){
						If(BG_FINGER(BGR_I)!=-1){BGR_TEMP=BGR_I;BGR_I=BGR_LO-1;}	//２音目の弦番号のコントロール
					}
					//１音目の低い音
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_FIRST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_TEMP) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_TEMP)+BG_FINGER(BGR_TEMP) )+{");"};
					//間にミュートが入るのを考慮
					For(Int BGR_I=FRM+1;BGR_I<BGR_TEMP;BGR_I++){BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};}
					//２音目の高い音
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_LAST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_HI)+BG_VELOCITY_MOMENTUM*(BGR_HI-BGR_TEMP) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_HI-BGR_TEMP)) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_HI)+BG_FINGER(BGR_HI) )+{");"};
				}
				Case(-1){
					For(Int BGR_I=BGR_HI;BGR_TEMP<2;;BGR_I--){
						If(BG_FINGER(BGR_I)!=-1){
							If(BGR_TEMP==0){
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_FIRST+ BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BG_VELOCITY_MOMENTUM*(BGR_HI-BGR_I) )+{");"};
							}
							If(BGR_TEMP==1){
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_LAST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BG_VELOCITY_MOMENTUM*(BGR_HI-BGR_I) )+{");"};
							}
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_HI-BGR_I)) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_I)+BG_FINGER(BGR_I) )+{");"};
							BGR_TEMP++;		//鳴らす回数のコントロール（２回まで）
						}Else{
						BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};
						}
					}
				}
			}

		}
	}
	
	BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+CHR(39)
	Result=BGR_ADDNOTE_STR;

}
/*
ポジション１：最低フレットが０～２を目安
ポジション２：最低フレットが０～５を目安
ポジション３：フレットの平均値が６を目安
ポジション４：フレットの平均値が９を目安
ポジション５：最低フレットがおおよそ１０前後を目安　１６は超えない。１５がいくつか。
*/
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_C
Function GC(Int BG_P){BG_GRASP(BG_P,		00,03,02,00,01,00,	-1,03,05,05,05,03,	08,07,05,05,05,08,	08,10,10,09,08,08,	-1,-1,10,12,13,12	)}
Function GCM7(Int BG_P){BG_GRASP(BG_P,		-1,03,02,00,00,00,	-1,03,05,04,05,03,	-1,-1,05,05,05,07,	08,-1,09,09,08,-1,	-1,-1,10,12,12,12	)}
Function GC7(Int BG_P){BG_GRASP(BG_P,		-1,03,02,03,01,00,	-1,03,05,03,05,03,	-1,-1,05,05,05,06,	08,10,08,09,08,08,	-1,-1,10,12,11,12	)}
Function GC6(Int BG_P){BG_GRASP(BG_P,		-1,03,02,02,01,00,	-1,03,05,05,05,05,	08,-1,07,09,08,-1,	-1,-1,10,09,10,08,	-1,-1,10,12,10,12	)}
Function GCm(Int BG_P){BG_GRASP(BG_P,		-1,03,01,00,01,-1,	-1,03,05,05,04,03,	-1,-1,05,08,08,08,	08,10,10,08,08,08,	-1,-1,10,12,13,11	)}
Function GCm7(Int BG_P){BG_GRASP(BG_P,		-1,03,01,03,01,03,	-1,03,05,03,04,03,	-1,-1,05,05,04,06,	08,10,08,08,08,08,	-1,-1,10,12,11,11	)}
Function GCmM7(Int BG_P){BG_GRASP(BG_P,		-1,03,01,04,-1,-1,	-1,03,05,04,04,03,	-1,-1,05,05,04,07,	08,10,09,08,08,08,	-1,-1,10,12,12,11	)}
Function GCm7b5(Int BG_P){BG_GRASP(BG_P,		-1,03,01,03,01,02,	-1,03,04,03,04,-1,	08,-1,08,08,07,-1,	08,09,08,08,-1,-1,	-1,-1,10,11,11,11	)}
Function GCsus4(Int BG_P){BG_GRASP(BG_P,		-1,03,03,-1,01,01,	-1,03,05,05,06,03,	-1,-1,05,05,06,08,	08,10,10,10,08,08,	-1,-1,10,12,13,13	)}
Function GC7sus4(Int BG_P){BG_GRASP(BG_P,		-1,03,03,03,01,01,	-1,03,05,03,06,03,	-1,-1,05,05,06,06,	08,10,08,10,08,08,	-1,-1,10,12,11,13	)}
Function GCaug(Int BG_P){BG_GRASP(BG_P,		00,03,02,01,01,04,	-1,03,-1,05,05,04,	-1,-1,06,05,05,04,	-1,-1,10,09,09,08,	-1,-1,10,09,09,08	)}
Function GCdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GCM7_9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,04,03,-1,	-1,03,05,04,03,03,	-1,-1,05,07,05,07,	-1,-1,09,09,08,10,	-1,-1,10,12,12,10	)}
Function GC7_9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,03,03,03,	-1,03,05,03,03,03,	-1,-1,05,07,05,06,	-1,-1,08,09,08,10,	-1,-1,10,12,11,10	)}
Function GCadd9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,00,03,00,	-1,03,05,05,03,03,	-1,03,05,05,03,03,	-1,-1,10,09,08,10,	-1,-1,10,12,13,10	)}
Function GCm7_9(Int BG_P){BG_GRASP(BG_P,		-1,03,01,03,03,-1,	-1,03,05,03,03,03,	-1,-1,05,07,04,06,	08,10,08,08,08,10,	-1,-1,10,12,11,10	)}
Function GC7_b9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,03,02,-1,	-1,03,02,03,02,-1,	-1,-1,05,06,05,06,	-1,-1,10,09,11,09,	-1,-1,10,12,11,09	)}
Function GC7_p9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,03,04,-1,	-1,03,02,03,04,-1,	-1,03,02,03,04,-1,	-1,-1,10,09,11,11,	-1,-1,10,09,11,11	)}
Function GCM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,03,02,04,03,02,	-1,03,02,04,03,02,	08,-1,-1,07,07,07,	-1,-1,10,11,12,10,	-1,-1,10,11,12,10	)}
Function GCm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,03,01,03,03,01,	-1,03,05,07,06,-1,	08,-1,08,08,06,-1,	-1,-1,10,12,11,13,	-1,-1,10,12,11,13	)}
Function GC6_9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,02,03,03,	-1,03,02,02,03,03,	08,-1,07,07,08,08,	-1,-1,10,12,10,10,	-1,-1,10,12,10,10	)}
Function GC7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,03,02,03,03,05,	-1,03,05,03,03,05,	08,10,08,09,10,08,	08,10,08,09,10,08,	-1,-1,10,09,10,10	)}
Function GC7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,03,02,03,03,04,	-1,03,05,03,03,04,	08,-1,08,09,09,-1,	-1,-1,10,09,09,10,	-1,-1,10,09,09,10	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_C#
Function GCp(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,02,01,	-1,04,06,06,06,04,	09,08,06,06,06,09,	09,11,11,10,09,09,	-1,-1,11,13,14,13	)}
Function GCpM7(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,01,01,	-1,04,06,05,06,04,	-1,-1,06,06,06,08,	09,-1,10,10,09,-1,	-1,-1,11,13,13,13	)}
Function GCp7(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,02,-1,	-1,04,06,04,06,04,	-1,-1,06,06,06,07,	09,11,09,10,09,09,	-1,-1,11,13,12,13	)}
Function GCp6(Int BG_P){BG_GRASP(BG_P,		-1,04,03,03,02,-1,	-1,04,06,06,06,06,	09,-1,08,10,09,-1,	-1,-1,11,10,11,09,	-1,-1,11,13,11,13	)}
Function GCpm(Int BG_P){BG_GRASP(BG_P,		-1,04,02,01,02,-1,	-1,04,06,06,05,04,	-1,-1,06,09,09,09,	09,11,11,09,09,09,	-1,-1,11,13,14,12	)}
Function GCpm7(Int BG_P){BG_GRASP(BG_P,		-1,04,02,04,02,04,	-1,04,06,04,05,04,	-1,-1,06,06,05,07,	09,11,09,09,09,09,	-1,-1,11,13,12,12	)}
Function GCpmM7(Int BG_P){BG_GRASP(BG_P,		-1,04,02,05,-1,-1,	-1,04,06,05,05,04,	-1,-1,06,06,05,08,	09,11,10,09,09,09,	-1,-1,11,13,13,12	)}
Function GCpm7b5(Int BG_P){BG_GRASP(BG_P,		00,04,02,04,02,03,	-1,04,05,04,05,-1,	09,-1,09,09,08,-1,	09,10,09,09,-1,-1,	-1,-1,11,12,12,12	)}
Function GCpsus4(Int BG_P){BG_GRASP(BG_P,		-1,04,04,-1,02,02,	-1,04,06,06,07,04,	-1,-1,06,06,07,09,	09,11,11,11,09,09,	-1,-1,11,13,14,14	)}
Function GCp7sus4(Int BG_P){BG_GRASP(BG_P,	-1,04,04,04,02,02,	-1,04,06,04,07,04,	-1,-1,06,06,07,07,	09,11,09,11,09,09,	-1,-1,11,13,12,14	)}
Function GCpaug(Int BG_P){BG_GRASP(BG_P,		-1,04,03,02,02,05,	-1,04,-1,06,06,05,	-1,-1,07,06,06,05,	-1,-1,11,10,10,09,	-1,-1,11,10,10,09	)}
Function GCpdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GCpM7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,05,04,-1,	-1,04,06,05,04,04,	-1,-1,06,08,06,08,	-1,-1,10,10,09,11,	-1,-1,11,13,13,11	)}
Function GCp7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,04,04,	-1,04,06,04,04,04,	-1,-1,06,08,06,07,	-1,-1,09,10,09,11,	-1,-1,11,13,12,11	)}
Function GCpadd9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,04,-1,	-1,04,06,06,04,04,	-1,04,06,06,04,04,	-1,-1,11,10,09,11,	-1,-1,11,13,14,11	)}
Function GCpm7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,02,04,04,-1,	-1,04,06,04,04,04,	-1,-1,06,08,05,07,	09,11,09,09,09,11,	-1,-1,11,13,12,11	)}
Function GCp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,03,-1,	-1,04,03,04,03,-1,	-1,-1,06,07,06,07,	-1,-1,11,10,12,10,	-1,-1,11,13,12,10	)}
Function GCp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,05,-1,	-1,04,03,04,05,-1,	-1,04,03,04,05,-1,	-1,-1,11,10,12,12,	-1,-1,11,10,12,12	)}
Function GCpM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,04,03,05,04,03,	-1,04,03,05,04,03,	09,-1,-1,08,08,08,	-1,-1,11,12,13,11,	-1,-1,11,12,13,11	)}
Function GCpm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,04,02,04,04,02,	-1,04,06,08,07,-1,	09,-1,09,09,07,-1,	-1,-1,11,13,12,14,	-1,-1,11,13,12,14	)}
Function GCp6_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,03,04,04,	-1,04,03,03,04,04,	09,-1,08,08,09,09,	-1,-1,11,13,11,11,	-1,-1,11,13,11,11	)}
Function GCp7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,04,03,04,04,06,	-1,04,06,04,04,06,	09,11,09,10,11,09,	09,11,09,10,11,09,	-1,-1,11,10,11,11	)}
Function GCp7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,04,03,04,04,05,	-1,04,06,04,04,05,	09,-1,09,10,10,-1,	-1,-1,11,10,10,11,	-1,-1,11,10,10,11	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Db
Function GDb(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,02,01,	-1,04,06,06,06,04,	09,08,06,06,06,09,	09,11,11,10,09,09,	-1,-1,11,13,14,13	)}
Function GDbM7(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,01,01,	-1,04,06,05,06,04,	-1,-1,06,06,06,08,	09,-1,10,10,09,-1,	-1,-1,11,13,13,13	)}
Function GDb7(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,02,-1,	-1,04,06,04,06,04,	-1,-1,06,06,06,07,	09,11,09,10,09,09,	-1,-1,11,13,12,13	)}
Function GDb6(Int BG_P){BG_GRASP(BG_P,		-1,04,03,03,02,-1,	-1,04,06,06,06,06,	09,-1,08,10,09,-1,	-1,-1,11,10,11,09,	-1,-1,11,13,11,13	)}
Function GDbm(Int BG_P){BG_GRASP(BG_P,		-1,04,02,01,02,-1,	-1,04,06,06,05,04,	-1,-1,06,09,09,09,	09,11,11,09,09,09,	-1,-1,11,13,14,12	)}
Function GDbm7(Int BG_P){BG_GRASP(BG_P,		-1,04,02,04,02,04,	-1,04,06,04,05,04,	-1,-1,06,06,05,07,	09,11,09,09,09,09,	-1,-1,11,13,12,12	)}
Function GDbmM7(Int BG_P){BG_GRASP(BG_P,		-1,04,02,05,-1,-1,	-1,04,06,05,05,04,	-1,-1,06,06,05,08,	09,11,10,09,09,09,	-1,-1,11,13,13,12	)}
Function GDbm7b5(Int BG_P){BG_GRASP(BG_P,		00,04,02,04,02,03,	-1,04,05,04,05,-1,	09,-1,09,09,08,-1,	09,10,09,09,-1,-1,	-1,-1,11,12,12,12	)}
Function GDbsus4(Int BG_P){BG_GRASP(BG_P,		-1,04,04,-1,02,02,	-1,04,06,06,07,04,	-1,-1,06,06,07,09,	09,11,11,11,09,09,	-1,-1,11,13,14,14	)}
Function GDb7sus4(Int BG_P){BG_GRASP(BG_P,	-1,04,04,04,02,02,	-1,04,06,04,07,04,	-1,-1,06,06,07,07,	09,11,09,11,09,09,	-1,-1,11,13,12,14	)}
Function GDbaug(Int BG_P){BG_GRASP(BG_P,		-1,04,03,02,02,05,	-1,04,-1,06,06,05,	-1,-1,07,06,06,05,	-1,-1,11,10,10,09,	-1,-1,11,10,10,09	)}
Function GDbdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GDbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,05,04,-1,	-1,04,06,05,04,04,	-1,-1,06,08,06,08,	-1,-1,10,10,09,11,	-1,-1,11,13,13,11	)}
Function GDb7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,04,04,	-1,04,06,04,04,04,	-1,-1,06,08,06,07,	-1,-1,09,10,09,11,	-1,-1,11,13,12,11	)}
Function GDbadd9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,04,-1,	-1,04,06,06,04,04,	-1,04,06,06,04,04,	-1,-1,11,10,09,11,	-1,-1,11,13,14,11	)}
Function GDbm7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,02,04,04,-1,	-1,04,06,04,04,04,	-1,-1,06,08,05,07,	09,11,09,09,09,11,	-1,-1,11,13,12,11	)}
Function GDb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,03,-1,	-1,04,03,04,03,-1,	-1,-1,06,07,06,07,	-1,-1,11,10,12,10,	-1,-1,11,13,12,10	)}
Function GDb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,05,-1,	-1,04,03,04,05,-1,	-1,04,03,04,05,-1,	-1,-1,11,10,12,12,	-1,-1,11,10,12,12	)}
Function GDbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,04,03,05,04,03,	-1,04,03,05,04,03,	09,-1,-1,08,08,08,	-1,-1,11,12,13,11,	-1,-1,11,12,13,11	)}
Function GDbm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,04,02,04,04,02,	-1,04,06,08,07,-1,	09,-1,09,09,07,-1,	-1,-1,11,13,12,14,	-1,-1,11,13,12,14	)}
Function GDb6_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,03,04,04,	-1,04,03,03,04,04,	09,-1,08,08,09,09,	-1,-1,11,13,11,11,	-1,-1,11,13,11,11	)}
Function GDb7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,04,03,04,04,06,	-1,04,06,04,04,06,	09,11,09,10,11,09,	09,11,09,10,11,09,	-1,-1,11,10,11,11	)}
Function GDb7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,04,03,04,04,05,	-1,04,06,04,04,05,	09,-1,09,10,10,-1,	-1,-1,11,10,10,11,	-1,-1,11,10,10,11	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_D
Function GD(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,03,02,	-1,05,04,02,03,02,	-1,05,07,07,07,05,	10,09,07,07,07,10,	10,12,12,11,10,10	)}
Function GDM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,02,02,	-1,05,04,02,02,02,	-1,05,07,06,07,05,	-1,-1,07,07,07,09,	10,-1,11,11,10,-1	)}
Function GD7(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,02,	-1,05,04,05,03,-1,	-1,05,07,05,07,05,	-1,-1,07,07,07,08,	10,12,10,11,10,10	)}
Function GD6(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,00,02,	-1,05,04,04,03,-1,	-1,05,07,07,07,07,	10,-1,09,11,10,-1,	-1,-1,12,11,12,10	)}
Function GDm(Int BG_P){BG_GRASP(BG_P,		-1,00,00,02,03,01,	-1,05,03,02,03,-1,	-1,05,07,07,06,05,	-1,-1,07,10,10,10,	10,12,12,10,10,10	)}
Function GDm7(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,01,	-1,05,03,05,03,05,	-1,05,07,05,06,05,	-1,-1,07,07,06,08,	10,12,10,10,10,10	)}
Function GDmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,02,01,	-1,05,03,06,-1,-1,	-1,05,07,06,06,05,	-1,-1,07,07,06,09,	10,12,11,10,10,10	)}
Function GDm7b5(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,01,01,01,	-1,05,03,05,03,04,	-1,05,06,05,06,-1,	10,-1,10,10,09,-1,	10,11,10,10,-1,-1	)}
Function GDsus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,03,03,	-1,05,05,-1,03,03,	-1,05,07,07,08,05,	-1,-1,07,07,08,10,	10,12,12,12,10,10	)}
Function GD7sus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,03,	-1,05,05,05,03,03,	-1,05,07,05,08,05,	-1,-1,07,07,08,08,	10,12,10,12,10,10	)}
Function GDaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,03,03,02,	-1,05,04,03,03,06,	-1,05,-1,07,07,06,	-1,-1,08,07,07,06,	-1,-1,12,15,15,14	)}
Function GDdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GDM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,02,00,	-1,05,04,06,05,-1,	-1,05,07,06,05,05,	-1,-1,07,09,07,09,	-1,-1,11,11,10,12	)}
Function GD7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,00,	-1,05,04,05,05,05,	-1,05,07,05,05,05,	-1,-1,07,09,07,08,	-1,-1,10,11,10,12	)}
Function GDadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,03,00,	-1,05,04,02,05,-1,	-1,05,07,07,05,05,	-1,05,07,07,07,05,	-1,-1,12,11,10,12	)}
Function GDm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,00,	-1,05,03,05,05,05,	-1,-1,07,09,06,08,	10,12,10,10,10,12,	-1,-1,12,10,13,12	)}
Function GD7_b9(Int BG_P){BG_GRASP(BG_P,		-1,05,04,05,04,-1,	-1,05,04,05,04,-1,	-1,05,04,05,04,-1,	-1,-1,07,08,07,08,	-1,-1,12,11,13,11	)}
Function GD7_p9(Int BG_P){BG_GRASP(BG_P,		-1,05,04,05,06,-1,	-1,05,04,05,06,-1,	-1,05,04,05,06,-1,	-1,-1,12,11,13,13,	-1,-1,12,11,13,13	)}
Function GDM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,00,01,02,00,	-1,05,04,06,05,04,	-1,05,04,06,05,04,	10,-1,-1,09,09,09,	10,-1,-1,09,09,09	)}
Function GDm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,00,02,01,03,	-1,05,03,05,05,03,	-1,05,07,09,08,-1,	10,-1,10,10,08,-1,	-1,-1,10,10,08,10	)}
Function GD6_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,00,00,	-1,05,04,04,05,05,	-1,05,04,04,05,05,	10,-1,09,09,10,10,	10,-1,09,09,10,10	)}
Function GD7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,05,04,05,05,07,	-1,05,04,05,05,07,	-1,05,07,05,05,07,	10,12,10,11,12,10,	-1,-1,12,11,12,12	)}
Function GD7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,05,04,05,05,06,	-1,05,04,05,05,06,	-1,05,07,05,05,06,	10,-1,10,11,11,-1,	-1,-1,12,11,11,12	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_D#
Function GDp(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,03,	-1,06,05,03,04,03,	-1,06,08,08,08,06,	11,10,08,08,08,11,	11,13,13,12,11,11	)}
Function GDpM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,03,	-1,06,05,03,03,03,	-1,06,08,07,08,06,	-1,-1,08,08,08,10,	11,-1,12,12,11,-1	)}
Function GDp7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,03,	-1,06,05,06,04,-1,	-1,06,08,06,08,06,	-1,-1,08,08,08,09,	11,13,11,12,11,11	)}
Function GDp6(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,03,	-1,06,05,05,04,-1,	-1,06,08,08,08,08,	11,-1,10,12,11,-1,	-1,-1,13,12,13,11	)}
Function GDpm(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,02,	-1,06,04,03,04,-1,	-1,06,08,08,07,06,	-1,-1,08,11,11,11,	11,13,13,11,11,11	)}
Function GDpm7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,02,	-1,06,04,06,04,06,	-1,06,08,06,07,06,	-1,-1,08,08,07,09,	11,13,11,11,11,11	)}
Function GDpmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,02,	-1,06,04,07,-1,-1,	-1,06,08,07,07,06,	-1,-1,08,08,07,10,	11,13,12,11,11,11	)}
Function GDpm7b5(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,02,02,	-1,06,04,06,04,05,	-1,06,07,06,07,-1,	11,-1,11,11,10,-1,	11,12,11,11,-1,-1	)}
Function GDpsus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,04,	-1,06,06,-1,04,04,	-1,06,08,08,09,06,	-1,-1,08,08,09,11,	11,13,13,13,11,11	)}
Function GDp7sus4(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,03,02,04,	-1,06,06,06,04,04,	-1,06,08,06,09,06,	-1,-1,08,08,09,09,	11,13,11,13,11,11	)}
Function GDpaug(Int BG_P){BG_GRASP(BG_P,		03,02,01,00,00,03,	-1,06,05,04,04,07,	-1,06,-1,08,08,07,	-1,-1,09,08,08,07,	-1,14,13,12,12,15	)}
Function GDpdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GDpM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,01,	-1,06,05,07,06,-1,	-1,06,08,07,06,06,	-1,-1,08,10,08,10,	-1,-1,12,12,11,13	)}
Function GDp7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,01,	-1,06,05,06,06,06,	-1,06,08,06,06,06,	-1,-1,08,10,08,09,	-1,-1,11,12,11,13	)}
Function GDpadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,01,	-1,06,05,03,06,-1,	-1,06,08,08,06,06,	-1,06,08,08,06,06,	-1,-1,13,12,11,13	)}
Function GDpm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,01,	-1,06,04,06,06,-1,	-1,06,08,06,06,06,	-1,-1,08,10,07,09,	-1,-1,13,11,14,13	)}
Function GDp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,06,05,06,05,-1,	-1,06,05,06,05,-1,	-1,06,05,06,05,-1,	-1,-1,08,09,08,09,	-1,-1,13,12,14,12	)}
Function GDp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,06,05,06,07,-1,	-1,06,05,06,07,-1,	-1,06,05,06,07,-1,	-1,-1,13,12,14,14,	-1,-1,13,12,14,14	)}
Function GDpM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,02,03,01,	-1,-1,01,02,03,01,	-1,06,05,07,06,05,	11,-1,-1,10,10,10,	11,-1,-1,10,10,10	)}
Function GDpm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,03,02,04,	-1,-1,01,03,02,04,	-1,06,04,06,06,04,	-1,06,08,10,09,-1,	-1,-1,11,11,09,11	)}
Function GDp6_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,01,	-1,-1,01,03,01,01,	-1,06,05,05,06,06,	11,-1,10,10,11,11,	11,-1,10,10,11,11	)}
Function GDp7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,00,01,01,	-1,-1,01,00,01,01,	-1,06,05,06,06,08,	-1,06,08,06,06,08,	-1,06,08,06,06,08	)}
Function GDp7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,00,00,01,	-1,-1,01,00,00,01,	-1,06,05,06,06,07,	-1,06,08,06,06,07,	11,-1,11,12,12,-1	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Eb
Function GEb(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,03,	-1,06,05,03,04,03,	-1,06,08,08,08,06,	11,10,08,08,08,11,	11,13,13,12,11,11	)}
Function GEbM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,03,	-1,06,05,03,03,03,	-1,06,08,07,08,06,	-1,-1,08,08,08,10,	11,-1,12,12,11,-1	)}
Function GEb7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,03,	-1,06,05,06,04,-1,	-1,06,08,06,08,06,	-1,-1,08,08,08,09,	11,13,11,12,11,11	)}
Function GEb6(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,03,	-1,06,05,05,04,-1,	-1,06,08,08,08,08,	11,-1,10,12,11,-1,	-1,-1,13,12,13,11	)}
Function GEbm(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,02,	-1,06,04,03,04,-1,	-1,06,08,08,07,06,	-1,-1,08,11,11,11,	11,13,13,11,11,11	)}
Function GEbm7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,02,	-1,06,04,06,04,06,	-1,06,08,06,07,06,	-1,-1,08,08,07,09,	11,13,11,11,11,11	)}
Function GEbmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,02,	-1,06,04,07,-1,-1,	-1,06,08,07,07,06,	-1,-1,08,08,07,10,	11,13,12,11,11,11	)}
Function GEbm7b5(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,02,02,	-1,06,04,06,04,05,	-1,06,07,06,07,-1,	11,-1,11,11,10,-1,	11,12,11,11,-1,-1	)}
Function GEbsus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,04,	-1,06,06,-1,04,04,	-1,06,08,08,09,06,	-1,-1,08,08,09,11,	11,13,13,13,11,11	)}
Function GEb7sus4(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,03,02,04,	-1,06,06,06,04,04,	-1,06,08,06,09,06,	-1,-1,08,08,09,09,	11,13,11,13,11,11	)}
Function GEbaug(Int BG_P){BG_GRASP(BG_P,		03,02,01,00,00,03,	-1,06,05,04,04,07,	-1,06,-1,08,08,07,	-1,-1,09,08,08,07,	-1,14,13,12,12,15	)}
Function GEbdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GEbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,01,	-1,06,05,07,06,-1,	-1,06,08,07,06,06,	-1,-1,08,10,08,10,	-1,-1,12,12,11,13	)}
Function GEb7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,01,	-1,06,05,06,06,06,	-1,06,08,06,06,06,	-1,-1,08,10,08,09,	-1,-1,11,12,11,13	)}
Function GEbadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,01,	-1,06,05,03,06,-1,	-1,06,08,08,06,06,	-1,06,08,08,06,06,	-1,-1,13,12,11,13	)}
Function GEbm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,01,	-1,06,04,06,06,-1,	-1,06,08,06,06,06,	-1,-1,08,10,07,09,	-1,-1,13,11,14,13	)}
Function GEb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,06,05,06,05,-1,	-1,06,05,06,05,-1,	-1,06,05,06,05,-1,	-1,-1,08,09,08,09,	-1,-1,13,12,14,12	)}
Function GEb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,06,05,06,07,-1,	-1,06,05,06,07,-1,	-1,06,05,06,07,-1,	-1,-1,13,12,14,14,	-1,-1,13,12,14,14	)}
Function GEbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,02,03,01,	-1,-1,01,02,03,01,	-1,06,05,07,06,05,	11,-1,-1,10,10,10,	11,-1,-1,10,10,10	)}
Function GEbm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,03,02,04,	-1,-1,01,03,02,04,	-1,06,04,06,06,04,	-1,06,08,10,09,-1,	-1,-1,11,11,09,11	)}
Function GEb6_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,01,	-1,-1,01,03,01,01,	-1,06,05,05,06,06,	11,-1,10,10,11,11,	11,-1,10,10,11,11	)}
Function GEb7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,00,01,01,	-1,-1,01,00,01,01,	-1,06,05,06,06,08,	-1,06,08,06,06,08,	-1,06,08,06,06,08	)}
Function GEb7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,00,00,01,	-1,-1,01,00,00,01,	-1,06,05,06,06,07,	-1,06,08,06,06,07,	11,-1,11,12,12,-1	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_E
Function GE(Int BG_P){BG_GRASP(BG_P,		00,02,02,01,00,00,	-1,-1,02,04,05,04,	-1,07,06,04,05,04,	-1,07,09,09,09,07,	12,11,09,09,09,12	)}
Function GEM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,04,04,04,	-1,07,06,04,04,04,	-1,07,09,08,09,07,	-1,-1,09,09,09,11,	12,-1,13,13,12,-1	)}
Function GE7(Int BG_P){BG_GRASP(BG_P,		00,02,00,01,00,00,	-1,-1,02,04,03,04,	-1,07,06,07,05,-1,	-1,07,09,07,09,07,	-1,-1,09,09,09,10	)}
Function GE6(Int BG_P){BG_GRASP(BG_P,		00,02,02,01,02,00,	-1,-1,02,04,02,04,	-1,07,06,06,05,-1,	-1,07,09,09,09,09,	12,-1,11,13,12,-1	)}
Function GEm(Int BG_P){BG_GRASP(BG_P,		00,02,02,00,00,00,	-1,-1,02,04,05,03,	-1,07,05,04,05,-1,	-1,07,09,09,08,07,	-1,-1,09,12,12,12	)}
Function GEm7(Int BG_P){BG_GRASP(BG_P,		00,02,00,00,00,00,	-1,-1,02,04,03,03,	-1,07,05,07,05,07,	-1,07,09,07,08,07,	-1,-1,09,09,08,10	)}
Function GEmM7(Int BG_P){BG_GRASP(BG_P,		00,02,01,00,00,00,	-1,-1,02,04,04,03,	-1,07,05,08,-1,-1,	-1,07,09,08,08,07,	-1,-1,09,09,08,11	)}
Function GEm7b5(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,03,03,03,	-1,07,05,07,05,06,	-1,07,08,07,08,-1,	12,-1,12,12,11,-1,	12,-1,12,12,11,-1	)}
Function GEsus4(Int BG_P){BG_GRASP(BG_P,		00,02,02,02,00,00,	-1,-1,02,04,05,05,	-1,07,07,-1,05,05,	-1,07,09,09,10,07,	-1,-1,09,09,10,12	)}
Function GE7sus4(Int BG_P){BG_GRASP(BG_P,		00,02,00,02,00,00,	-1,-1,02,04,03,05,	-1,07,07,07,05,05,	-1,07,09,07,10,07,	-1,-1,09,09,10,10	)}
Function GEaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,01,01,00,	00,03,02,01,01,04,	00,07,06,05,05,08,	-1,07,-1,09,09,08,	-1,-1,14,13,13,12	)}
Function GEdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GEM7_9(Int BG_P){BG_GRASP(BG_P,		00,02,01,01,00,02,	-1,-1,02,04,04,02,	-1,07,06,08,07,-1,	-1,07,09,08,07,07,	-1,-1,09,11,09,11	)}
Function GE7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,04,03,02,	-1,-1,02,04,05,02,	-1,07,06,04,07,-1,	-1,07,09,09,07,07,	-1,07,09,09,07,07	)}
Function GEadd9(Int BG_P){BG_GRASP(BG_P,		00,02,02,01,00,02,	-1,06,05,03,06,-1,	-1,06,08,06,06,06,	-1,-1,08,10,07,09,	-1,-1,13,12,11,13	)}
Function GEm7_9(Int BG_P){BG_GRASP(BG_P,		00,02,00,00,00,02,	-1,-1,02,04,03,02,	-1,07,05,07,07,-1,	-1,07,09,07,07,07,	-1,-1,09,11,08,10	)}
Function GE7_b9(Int BG_P){BG_GRASP(BG_P,		-1,07,06,07,06,-1,	-1,-1,07,06,07,06,	-1,-1,07,06,07,06,	-1,-1,09,10,09,10,	-1,-1,12,11,13,11	)}
Function GE7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,01,03,03,	-1,-1,02,01,03,03,	-1,07,06,07,08,-1,	-1,07,06,07,08,-1,	-1,07,06,07,08,-1	)}
Function GEM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,02,03,04,02,	-1,-1,02,03,04,02,	-1,07,06,08,07,06,	-1,07,06,08,07,06,	12,-1,-1,11,11,11	)}
Function GEm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,02,04,03,05,	-1,-1,02,04,03,05,	-1,07,05,07,07,05,	-1,07,09,11,10,-1,	-1,-1,12,12,10,12	)}
Function GE6_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,04,02,02,	-1,-1,02,04,02,02,	-1,07,06,06,07,07,	-1,07,06,06,07,07,	12,-1,11,11,12,12	)}
Function GE7_9_13(Int BG_P){BG_GRASP(BG_P,	00,02,00,01,02,00,	-1,-1,02,01,02,02,	-1,07,06,07,07,09,	-1,07,09,07,07,09,	-1,07,09,07,07,09	)}
Function GE7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,-1,02,01,01,02,	-1,-1,02,01,01,02,	-1,07,06,07,07,08,	-1,07,09,07,07,08,	12,-1,12,13,13,-1	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_F
Function GF(Int BG_P){BG_GRASP(BG_P,		01,03,03,02,01,01,	-1,-1,03,05,06,05,	-1,08,07,05,06,05,	-1,08,10,10,10,08,	13,12,10,10,10,13	)}
Function GFM7(Int BG_P){BG_GRASP(BG_P,		01,-1,02,02,01,-1,	-1,-1,03,05,05,05,	-1,08,07,05,05,05,	-1,08,10,09,10,08,	-1,-1,10,10,10,12	)}
Function GF7(Int BG_P){BG_GRASP(BG_P,		01,03,01,02,01,01,	-1,-1,03,05,04,05,	-1,08,07,08,06,-1,	-1,08,10,08,10,08,	-1,-1,10,10,10,11	)}
Function GF6(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,03,01,	-1,-1,03,05,03,05,	-1,08,07,07,06,-1,	-1,08,10,10,10,10,	13,-1,12,14,13,-1	)}
Function GFm(Int BG_P){BG_GRASP(BG_P,		01,03,03,01,01,01,	-1,-1,03,05,06,04,	-1,08,06,05,06,-1,	-1,08,10,10,09,08,	-1,-1,10,13,13,13	)}
Function GFm7(Int BG_P){BG_GRASP(BG_P,		01,03,01,01,01,01,	-1,-1,03,05,04,04,	-1,08,06,08,06,08,	-1,08,10,08,09,08,	-1,-1,10,10,09,11	)}
Function GFmM7(Int BG_P){BG_GRASP(BG_P,		01,03,02,01,01,01,	-1,-1,03,05,05,04,	-1,08,06,09,-1,-1,	00,08,10,09,09,08,	-1,-1,10,10,09,12	)}
Function GFm7b5(Int BG_P){BG_GRASP(BG_P,		01,-1,01,01,00,-1,	01,02,01,01,-1,-1,	-1,-1,03,04,04,04,	-1,08,06,08,06,07,	-1,08,09,08,09,-1	)}
Function GFsus4(Int BG_P){BG_GRASP(BG_P,		01,03,03,03,01,01,	-1,-1,03,05,06,06,	-1,08,08,-1,06,06,	-1,08,10,10,11,08,	-1,-1,10,10,11,13	)}
Function GF7sus4(Int BG_P){BG_GRASP(BG_P,		01,03,01,03,01,01,	-1,-1,03,05,04,06,	-1,08,08,08,06,06,	-1,08,10,08,11,08,	-1,-1,10,10,11,11	)}
Function GFaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,02,01,	-1,04,03,02,02,05,	-1,08,07,06,06,09,	-1,08,-1,10,10,09,	-1,08,-1,10,10,09	)}
Function GFdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GFM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,02,01,03,	-1,-1,03,05,05,03,	-1,08,07,09,08,-1,	-1,08,10,09,08,08,	-1,-1,10,12,10,12	)}
Function GF7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,01,03,	-1,-1,03,05,04,03,	-1,08,07,08,08,08,	-1,08,10,08,08,08,	-1,-1,10,12,10,11	)}
Function GFadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,01,03,	-1,-1,03,05,06,03,	-1,08,07,05,08,-1,	-1,08,07,05,08,-1,	-1,08,10,10,08,08	)}
Function GFm7_9(Int BG_P){BG_GRASP(BG_P,		01,03,01,01,01,03,	-1,-1,03,05,04,03,	-1,08,06,08,08,-1,	-1,08,10,08,08,08,	-1,-1,10,12,09,11	)}
Function GF7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,04,02,	-1,-1,03,02,04,02,	-1,08,07,08,07,-1,	-1,08,07,08,07,-1,	-1,-1,10,11,10,11	)}
Function GF7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,04,04,	-1,-1,03,02,04,04,	-1,08,07,08,09,-1,	-1,08,07,08,09,-1,	-1,08,07,08,09,-1	)}
Function GFM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,03,04,05,03,	-1,-1,03,04,05,03,	-1,08,07,09,08,07,	-1,08,07,09,08,07,	13,-1,-1,12,12,12	)}
Function GFm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,03,05,04,06,	-1,-1,03,05,04,06,	-1,08,06,08,08,06,	-1,08,10,12,11,-1,	13,-1,13,13,11,-1	)}
Function GF6_9(Int BG_P){BG_GRASP(BG_P,		01,00,00,00,01,01,	-1,-1,03,05,03,03,	-1,08,07,07,08,08,	-1,08,07,07,08,08,	-1,08,07,07,08,08	)}
Function GF7_9_13(Int BG_P){BG_GRASP(BG_P,	01,03,01,02,03,01,	-1,-1,03,02,03,03,	-1,08,07,08,08,10,	-1,08,10,08,08,10,	-1,08,10,08,08,10	)}
Function GF7_9_b13(Int BG_P){BG_GRASP(BG_P,	01,-1,01,02,02,-1,	-1,-1,03,02,02,03,	-1,08,07,08,08,09,	-1,08,10,08,08,09,	-1,08,10,08,08,09	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_F#
Function GFp(Int BG_P){BG_GRASP(BG_P,		02,04,04,03,02,02,	-1,-1,04,06,07,06,	-1,09,08,06,07,06,	-1,09,11,11,11,09,	14,13,11,11,11,14	)}
Function GFpM7(Int BG_P){BG_GRASP(BG_P,		02,-1,03,03,02,-1,	-1,-1,04,06,06,06,	-1,09,08,06,06,06,	-1,09,11,10,11,09,	-1,-1,11,11,11,13	)}
Function GFp7(Int BG_P){BG_GRASP(BG_P,		02,04,02,03,02,02,	-1,-1,04,06,05,06,	-1,09,08,09,07,-1,	-1,09,11,09,11,09,	-1,-1,11,11,11,12	)}
Function GFp6(Int BG_P){BG_GRASP(BG_P,		02,-1,01,03,02,-1,	-1,-1,04,03,04,02,	-1,-1,04,06,04,06,	-1,09,08,08,07,-1,	-1,09,11,11,11,11	)}
Function GFpm(Int BG_P){BG_GRASP(BG_P,		02,04,04,02,02,02,	-1,-1,04,06,07,05,	-1,09,07,06,07,-1,	-1,09,11,11,10,09,	-1,-1,11,14,14,14	)}
Function GFpm7(Int BG_P){BG_GRASP(BG_P,		02,04,02,02,02,02,	-1,-1,04,06,05,05,	-1,09,07,09,07,09,	-1,09,11,09,10,09,	-1,-1,11,11,10,12	)}
Function GFpmM7(Int BG_P){BG_GRASP(BG_P,		02,04,03,02,02,02,	-1,-1,04,06,06,05,	-1,09,07,10,-1,-1,	-1,09,11,10,10,09,	-1,-1,11,11,10,13	)}
Function GFpm7b5(Int BG_P){BG_GRASP(BG_P,		02,-1,02,02,01,-1,	02,03,02,02,-1,-1,	-1,-1,04,05,05,05,	-1,09,07,09,07,08,	-1,09,10,09,10,-1	)}
Function GFpsus4(Int BG_P){BG_GRASP(BG_P,		02,04,04,04,02,02,	-1,-1,04,06,07,07,	-1,09,09,-1,07,07,	-1,09,11,11,12,09,	-1,-1,11,11,12,14	)}
Function GFp7sus4(Int BG_P){BG_GRASP(BG_P,	02,04,02,04,02,02,	-1,-1,04,06,05,07,	-1,09,09,09,07,07,	-1,09,11,09,12,09,	-1,-1,11,11,12,12	)}
Function GFpaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,03,02,	-1,05,04,03,03,06,	-1,09,08,07,07,10,	-1,09,-1,11,11,10,	-1,09,-1,11,11,10	)}
Function GFpdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GFpM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,03,02,04,	-1,-1,04,06,06,04,	-1,09,08,10,09,-1,	-1,09,11,10,09,09,	-1,-1,11,13,11,13	)}
Function GFp7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,03,02,04,	-1,-1,04,06,05,04,	-1,09,08,09,09,09,	-1,09,11,09,09,09,	-1,-1,11,13,11,12	)}
Function GFpadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,02,04,	-1,-1,04,06,07,04,	-1,09,08,06,09,-1,	-1,09,08,06,09,-1,	-1,09,11,11,09,09	)}
Function GFpm7_9(Int BG_P){BG_GRASP(BG_P,		02,04,02,02,02,04,	-1,-1,04,06,05,04,	-1,09,07,09,09,-1,	-1,09,11,09,09,09,	-1,-1,11,13,10,12	)}
Function GFp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,05,03,	-1,-1,04,03,05,03,	-1,09,08,09,08,-1,	-1,09,08,09,08,-1,	-1,-1,11,12,11,12	)}
Function GFp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,05,05,	-1,-1,04,03,05,05,	-1,09,08,09,10,-1,	-1,09,08,09,10,-1,	-1,09,08,09,10,-1	)}
Function GFpM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,04,05,06,04,	-1,-1,04,05,06,04,	-1,09,08,10,09,08,	-1,09,08,10,09,08,	14,-1,-1,13,13,13	)}
Function GFpm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,04,06,05,07,	-1,-1,04,06,05,07,	-1,09,07,09,09,07,	-1,09,11,13,12,-1,	14,-1,14,14,12,-1	)}
Function GFp6_9(Int BG_P){BG_GRASP(BG_P,		02,-1,01,01,02,02,	-1,-1,04,06,04,04,	-1,09,08,08,09,09,	-1,09,08,08,09,09,	-1,09,08,08,09,09	)}
Function GFp7_9_13(Int BG_P){BG_GRASP(BG_P,	02,04,02,03,04,02,	-1,-1,04,03,04,04,	-1,09,08,09,09,11,	-1,09,11,09,09,11,	-1,09,11,09,09,11	)}
Function GFp7_9_b13(Int BG_P){BG_GRASP(BG_P,	02,-1,02,03,03,-1,	-1,-1,04,03,03,04,	-1,09,08,09,09,10,	-1,09,11,09,09,10,	-1,09,11,09,09,10	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Gb
Function GGb(Int BG_P){BG_GRASP(BG_P,		02,04,04,03,02,02,	-1,-1,04,06,07,06,	-1,09,08,06,07,06,	-1,09,11,11,11,09,	14,13,11,11,11,14	)}
Function GGbM7(Int BG_P){BG_GRASP(BG_P,		02,-1,03,03,02,-1,	-1,-1,04,06,06,06,	-1,09,08,06,06,06,	-1,09,11,10,11,09,	-1,-1,11,11,11,13	)}
Function GGb7(Int BG_P){BG_GRASP(BG_P,		02,04,02,03,02,02,	-1,-1,04,06,05,06,	-1,09,08,09,07,-1,	-1,09,11,09,11,09,	-1,-1,11,11,11,12	)}
Function GGb6(Int BG_P){BG_GRASP(BG_P,		02,-1,01,03,02,-1,	-1,-1,04,03,04,02,	-1,-1,04,06,04,06,	-1,09,08,08,07,-1,	-1,09,11,11,11,11	)}
Function GGbm(Int BG_P){BG_GRASP(BG_P,		02,04,04,02,02,02,	-1,-1,04,06,07,05,	-1,09,07,06,07,-1,	-1,09,11,11,10,09,	-1,-1,11,14,14,14	)}
Function GGbm7(Int BG_P){BG_GRASP(BG_P,		02,04,02,02,02,02,	-1,-1,04,06,05,05,	-1,09,07,09,07,09,	-1,09,11,09,10,09,	-1,-1,11,11,10,12	)}
Function GGbmM7(Int BG_P){BG_GRASP(BG_P,		02,04,03,02,02,02,	-1,-1,04,06,06,05,	-1,09,07,10,-1,-1,	-1,09,11,10,10,09,	-1,-1,11,11,10,13	)}
Function GGbm7b5(Int BG_P){BG_GRASP(BG_P,		02,-1,02,02,01,-1,	02,03,02,02,-1,-1,	-1,-1,04,05,05,05,	-1,09,07,09,07,08,	-1,09,10,09,10,-1	)}
Function GGbsus4(Int BG_P){BG_GRASP(BG_P,		02,04,04,04,02,02,	-1,-1,04,06,07,07,	-1,09,09,-1,07,07,	-1,09,11,11,12,09,	-1,-1,11,11,12,14	)}
Function GGb7sus4(Int BG_P){BG_GRASP(BG_P,	02,04,02,04,02,02,	-1,-1,04,06,05,07,	-1,09,09,09,07,07,	-1,09,11,09,12,09,	-1,-1,11,11,12,12	)}
Function GGbaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,03,02,	-1,05,04,03,03,06,	-1,09,08,07,07,10,	-1,09,-1,11,11,10,	-1,09,-1,11,11,10	)}
Function GGbdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GGbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,03,02,04,	-1,-1,04,06,06,04,	-1,09,08,10,09,-1,	-1,09,11,10,09,09,	-1,-1,11,13,11,13	)}
Function GGb7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,03,02,04,	-1,-1,04,06,05,04,	-1,09,08,09,09,09,	-1,09,11,09,09,09,	-1,-1,11,13,11,12	)}
Function GGbadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,02,04,	-1,-1,04,06,07,04,	-1,09,08,06,09,-1,	-1,09,08,06,09,-1,	-1,09,11,11,09,09	)}
Function GGbm7_9(Int BG_P){BG_GRASP(BG_P,		02,04,02,02,02,04,	-1,-1,04,06,05,04,	-1,09,07,09,09,-1,	-1,09,11,09,09,09,	-1,-1,11,13,10,12	)}
Function GGb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,05,03,	-1,-1,04,03,05,03,	-1,09,08,09,08,-1,	-1,09,08,09,08,-1,	-1,-1,11,12,11,12	)}
Function GGb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,05,05,	-1,-1,04,03,05,05,	-1,09,08,09,10,-1,	-1,09,08,09,10,-1,	-1,09,08,09,10,-1	)}
Function GGbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,04,05,06,04,	-1,-1,04,05,06,04,	-1,09,08,10,09,08,	-1,09,08,10,09,08,	14,-1,-1,13,13,13	)}
Function GGbm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,04,06,05,07,	-1,-1,04,06,05,07,	-1,09,07,09,09,07,	-1,09,11,13,12,-1,	14,-1,14,14,12,-1	)}
Function GGb6_9(Int BG_P){BG_GRASP(BG_P,		02,-1,01,01,02,02,	-1,-1,04,06,04,04,	-1,09,08,08,09,09,	-1,09,08,08,09,09,	-1,09,08,08,09,09	)}
Function GGb7_9_13(Int BG_P){BG_GRASP(BG_P,	02,04,02,03,04,02,	-1,-1,04,03,04,04,	-1,09,08,09,09,11,	-1,09,11,09,09,11,	-1,09,11,09,09,11	)}
Function GGb7_9_b13(Int BG_P){BG_GRASP(BG_P,	02,-1,02,03,03,-1,	-1,-1,04,03,03,04,	-1,09,08,09,09,10,	-1,09,11,09,09,10,	-1,09,11,09,09,10	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_G
Function GG(Int BG_P){BG_GRASP(BG_P,		03,02,00,00,00,03,	03,05,05,04,03,03,	-1,-1,05,07,08,07,	-1,10,09,07,08,07,	-1,10,12,12,12,10	)}
Function GGM7(Int BG_P){BG_GRASP(BG_P,		03,02,00,00,00,02,	03,-1,04,04,03,-1,	-1,-1,05,07,07,07,	-1,10,09,07,07,07,	-1,10,12,11,12,10	)}
Function GG7(Int BG_P){BG_GRASP(BG_P,		03,02,00,00,00,01,	03,05,03,04,03,03,	-1,-1,05,07,06,07,	-1,10,09,10,08,-1,	-1,10,12,10,12,10	)}
Function GG6(Int BG_P){BG_GRASP(BG_P,		03,-1,02,04,03,-1,	-1,-1,05,04,05,03,	-1,-1,05,07,05,07,	-1,10,09,09,08,-1,	-1,10,12,12,12,12	)}
Function GGm(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,03,03,03,	03,05,05,03,03,03,	-1,-1,05,07,08,06,	-1,10,08,07,08,-1,	-1,10,12,12,11,10	)}
Function GGm7(Int BG_P){BG_GRASP(BG_P,		03,05,03,03,03,03,	-1,-1,05,07,06,06,	-1,10,08,10,08,10,	-1,10,12,10,11,10,	-1,-1,12,12,11,13	)}
Function GGmM7(Int BG_P){BG_GRASP(BG_P,		03,05,04,03,03,03,	-1,-1,05,07,07,06,	-1,10,08,11,-1,-1,	-1,10,12,11,11,10,	-1,-1,12,12,11,14	)}
Function GGm7b5(Int BG_P){BG_GRASP(BG_P,		03,-1,03,03,02,-1,	03,04,03,03,-1,-1,	-1,-1,05,06,06,06,	-1,10,08,10,08,09,	-1,10,11,10,11,-1	)}
Function GGsus4(Int BG_P){BG_GRASP(BG_P,		03,-1,00,00,01,03,	03,05,05,05,03,03,	-1,-1,05,07,08,08,	-1,10,10,-1,08,08,	-1,10,12,12,13,10	)}
Function GG7sus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,00,01,01,	03,05,03,05,03,03,	-1,-1,05,07,06,08,	-1,10,10,10,08,08,	-1,10,12,10,13,10	)}
Function GGaug(Int BG_P){BG_GRASP(BG_P,		03,02,01,00,00,03,	-1,-1,05,04,04,03,	-1,06,05,04,04,07,	-1,10,09,08,08,11,	-1,10,09,08,08,11	)}
Function GGdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GGM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,00,02,	-1,-1,04,04,03,05,	-1,-1,05,07,07,05,	-1,10,09,11,10,-1,	-1,10,12,11,10,10	)}
Function GG7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,00,01,	-1,-1,03,04,03,05,	-1,-1,05,07,06,05,	-1,10,09,10,10,10,	-1,10,12,10,10,10	)}
Function GGadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,05,04,03,05,	-1,-1,05,04,03,05,	-1,-1,05,07,08,05,	-1,10,09,07,10,-1,	-1,10,12,12,10,10	)}
Function GGm7_9(Int BG_P){BG_GRASP(BG_P,		03,05,03,03,03,05,	-1,-1,05,03,06,05,	-1,-1,05,07,06,05,	-1,10,08,10,10,10,	-1,10,12,10,10,10	)}
Function GG7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,01,00,01,	-1,-1,05,04,06,04,	-1,-1,05,04,06,04,	-1,10,09,10,09,-1,	-1,10,09,10,09,-1	)}
Function GG7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,05,04,06,06,	-1,-1,05,04,06,06,	-1,-1,05,04,06,06,	-1,10,09,10,11,-1,	-1,10,09,10,11,-1	)}
Function GGM7_9_p11(Int BG_P){BG_GRASP(BG_P,	03,-1,-1,02,02,02,	-1,-1,05,06,07,05,	-1,-1,05,06,07,05,	-1,10,09,11,10,09,	-1,10,09,11,10,09	)}
Function GGm7_9_11(Int BG_P){BG_GRASP(BG_P,	03,-1,03,03,01,-1,	-1,-1,05,07,06,08,	-1,-1,05,07,06,08,	-1,10,08,10,10,08,	-1,10,12,14,13,-1	)}
Function GG6_9(Int BG_P){BG_GRASP(BG_P,		03,-1,02,02,03,03,	-1,-1,05,07,05,05,	-1,-1,05,07,05,05,	-1,10,09,09,10,10,	-1,10,09,09,10,10	)}
Function GG7_9_13(Int BG_P){BG_GRASP(BG_P,	03,05,03,04,05,03,	03,05,03,04,05,03,	-1,-1,05,04,05,05,	-1,10,09,10,10,12,	-1,10,12,10,10,12	)}
Function GG7_9_b13(Int BG_P){BG_GRASP(BG_P,	03,-1,03,04,04,-1,	03,-1,03,04,04,-1,	-1,-1,05,04,04,05,	-1,10,09,10,10,11,	-1,10,12,10,10,11	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_G# (yet)
Function GGp(Int BG_P){BG_GRASP(BG_P,		04,03,01,01,01,04,	04,06,06,05,04,04,	-1,-1,06,08,09,08,	-1,11,10,08,09,08,	-1,11,13,13,13,11	)}
Function GGpM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,01,03,	04,-1,05,05,04,-1,	-1,-1,06,08,08,08,	-1,11,10,08,08,08,	-1,11,13,12,13,11	)}
Function GGp7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,01,02,	04,06,04,05,04,04,	-1,-1,06,08,07,08,	-1,11,10,11,09,-1,	-1,11,13,11,13,11	)}
Function GGp6(Int BG_P){BG_GRASP(BG_P,		04,-1,03,05,04,-1,	-1,-1,06,05,06,04,	-1,-1,06,08,06,08,	-1,11,10,10,09,-1,	-1,11,13,13,13,13	)}
Function GGpm(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,04,04,04,	04,06,06,04,04,04,	-1,-1,06,08,09,07,	-1,11,09,08,09,-1,	-1,11,13,13,12,11	)}
Function GGpm7(Int BG_P){BG_GRASP(BG_P,		04,06,04,04,04,04,	-1,-1,06,08,07,07,	-1,11,09,11,09,11,	-1,11,13,11,12,11,	-1,-1,13,13,12,14	)}
Function GGpmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,00,03,	04,06,05,04,04,04,	-1,-1,06,08,08,07,	-1,11,09,12,-1,-1,	-1,11,13,12,12,11	)}
Function GGpm7b5(Int BG_P){BG_GRASP(BG_P,		04,-1,04,04,03,-1,	04,05,04,04,-1,-1,	-1,-1,06,07,07,07,	-1,11,09,11,09,10,	-1,11,12,11,12,-1	)}
Function GGpsus4(Int BG_P){BG_GRASP(BG_P,		04,-1,01,01,02,04,	04,06,06,06,04,04,	-1,-1,06,08,09,09,	-1,11,11,-1,09,09,	-1,11,13,13,14,11	)}
Function GGp7sus4(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,01,02,02,	04,06,04,06,04,04,	-1,-1,06,08,07,09,	-1,11,11,11,09,09,	-1,11,13,11,14,11	)}
Function GGpaug(Int BG_P){BG_GRASP(BG_P,		-1,03,02,01,01,04,	-1,03,-1,05,05,04,	-1,-1,06,05,05,04,	-1,-1,10,09,09,08,	-1,-1,10,09,09,08	)}
Function GGpdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GGpM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,03,	-1,-1,05,05,04,06,	-1,-1,06,08,08,06,	-1,11,10,12,11,-1,	-1,11,13,12,11,11	)}
Function GGp7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,02,	-1,-1,04,05,04,06,	-1,-1,06,08,07,06,	-1,11,10,11,11,11,	-1,11,13,11,11,11	)}
Function GGpadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,06,05,04,06,	-1,-1,06,05,04,06,	-1,-1,06,08,09,06,	-1,11,10,08,11,-1,	-1,11,13,13,11,11	)}
Function GGpm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,00,02,	-1,-1,06,04,07,06,	-1,-1,06,08,07,06,	-1,11,09,11,11,-1,	-1,11,13,11,11,11	)}
Function GGp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,01,02,	-1,-1,06,05,07,05,	-1,-1,06,05,07,05,	-1,11,10,11,10,-1,	-1,11,10,11,10,-1	)}
Function GGp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,06,05,07,07,	-1,-1,06,05,07,07,	-1,-1,06,05,07,07,	-1,11,10,11,12,-1,	-1,11,10,11,12,-1	)}
Function GGpM7_9_p11(Int BG_P){BG_GRASP(BG_P,	04,-1,-1,03,03,03,	-1,-1,06,07,08,06,	-1,-1,06,07,08,06,	-1,11,10,12,11,10,	-1,11,10,12,11,10	)}
Function GGpm7_9_11(Int BG_P){BG_GRASP(BG_P,	04,-1,04,04,02,-1,	-1,-1,06,08,07,09,	-1,-1,06,08,07,09,	-1,11,09,11,11,09,	-1,11,13,15,14,-1	)}
Function GGp6_9(Int BG_P){BG_GRASP(BG_P,		04,-1,03,03,04,04,	-1,-1,06,08,06,06,	-1,-1,06,08,06,06,	-1,11,10,10,11,11,	-1,11,10,10,11,11	)}
Function GGp7_9_13(Int BG_P){BG_GRASP(BG_P,	04,06,04,05,06,04,	04,06,04,05,06,04,	-1,-1,06,05,06,06,	-1,11,10,11,11,13,	-1,11,13,11,11,13	)}
Function GGp7_9_b13(Int BG_P){BG_GRASP(BG_P,	04,-1,04,05,05,-1,	04,-1,04,05,05,-1,	-1,-1,06,05,05,06,	-1,11,10,11,11,12,	-1,11,13,11,11,12	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Ab (yet)
Function GAb(Int BG_P){BG_GRASP(BG_P,		04,03,01,01,01,04,	04,06,06,05,04,04,	-1,-1,06,08,09,08,	-1,11,10,08,09,08,	-1,11,13,13,13,11	)}
Function GAbM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,01,03,	04,-1,05,05,04,-1,	-1,-1,06,08,08,08,	-1,11,10,08,08,08,	-1,11,13,12,13,11	)}
Function GAb7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,01,02,	04,06,04,05,04,04,	-1,-1,06,08,07,08,	-1,11,10,11,09,-1,	-1,11,13,11,13,11	)}
Function GAb6(Int BG_P){BG_GRASP(BG_P,		04,-1,03,05,04,-1,	-1,-1,06,05,06,04,	-1,-1,06,08,06,08,	-1,11,10,10,09,-1,	-1,11,13,13,13,13	)}
Function GAbm(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,04,04,04,	04,06,06,04,04,04,	-1,-1,06,08,09,07,	-1,11,09,08,09,-1,	-1,11,13,13,12,11	)}
Function GAbm7(Int BG_P){BG_GRASP(BG_P,		04,06,04,04,04,04,	-1,-1,06,08,07,07,	-1,11,09,11,09,11,	-1,11,13,11,12,11,	-1,-1,13,13,12,14	)}
Function GAbmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,00,03,	04,06,05,04,04,04,	-1,-1,06,08,08,07,	-1,11,09,12,-1,-1,	-1,11,13,12,12,11	)}
Function GAbm7b5(Int BG_P){BG_GRASP(BG_P,		04,-1,04,04,03,-1,	04,05,04,04,-1,-1,	-1,-1,06,07,07,07,	-1,11,09,11,09,10,	-1,11,12,11,12,-1	)}
Function GAbsus4(Int BG_P){BG_GRASP(BG_P,		04,-1,01,01,02,04,	04,06,06,06,04,04,	-1,-1,06,08,09,09,	-1,11,11,-1,09,09,	-1,11,13,13,14,11	)}
Function GAb7sus4(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,01,02,02,	04,06,04,06,04,04,	-1,-1,06,08,07,09,	-1,11,11,11,09,09,	-1,11,13,11,14,11	)}
Function GAbaug(Int BG_P){BG_GRASP(BG_P,		-1,03,02,01,01,04,	-1,03,-1,05,05,04,	-1,-1,06,05,05,04,	-1,-1,10,09,09,08,	-1,-1,10,09,09,08	)}
Function GAbdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GAbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,03,	-1,-1,05,05,04,06,	-1,-1,06,08,08,06,	-1,11,10,12,11,-1,	-1,11,13,12,11,11	)}
Function GAb7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,02,	-1,-1,04,05,04,06,	-1,-1,06,08,07,06,	-1,11,10,11,11,11,	-1,11,13,11,11,11	)}
Function GAbadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,06,05,04,06,	-1,-1,06,05,04,06,	-1,-1,06,08,09,06,	-1,11,10,08,11,-1,	-1,11,13,13,11,11	)}
Function GAbm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,00,02,	-1,-1,06,04,07,06,	-1,-1,06,08,07,06,	-1,11,09,11,11,-1,	-1,11,13,11,11,11	)}
Function GAb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,01,02,	-1,-1,06,05,07,05,	-1,-1,06,05,07,05,	-1,11,10,11,10,-1,	-1,11,10,11,10,-1	)}
Function GAb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,06,05,07,07,	-1,-1,06,05,07,07,	-1,-1,06,05,07,07,	-1,11,10,11,12,-1,	-1,11,10,11,12,-1	)}
Function GAbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	04,-1,-1,03,03,03,	-1,-1,06,07,08,06,	-1,-1,06,07,08,06,	-1,11,10,12,11,10,	-1,11,10,12,11,10	)}
Function GAbm7_9_11(Int BG_P){BG_GRASP(BG_P,	04,-1,04,04,02,-1,	-1,-1,06,08,07,09,	-1,-1,06,08,07,09,	-1,11,09,11,11,09,	-1,11,13,15,14,-1	)}
Function GAb6_9(Int BG_P){BG_GRASP(BG_P,		04,-1,03,03,04,04,	-1,-1,06,08,06,06,	-1,-1,06,08,06,06,	-1,11,10,10,11,11,	-1,11,10,10,11,11	)}
Function GAb7_9_13(Int BG_P){BG_GRASP(BG_P,	04,06,04,05,06,04,	04,06,04,05,06,04,	-1,-1,06,05,06,06,	-1,11,10,11,11,13,	-1,11,13,11,11,13	)}
Function GAb7_9_b13(Int BG_P){BG_GRASP(BG_P,	04,-1,04,05,05,-1,	04,-1,04,05,05,-1,	-1,-1,06,05,05,06,	-1,11,10,11,11,12,	-1,11,13,11,11,12	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_A
Function GA(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,02,00,	05,04,02,02,02,05,	05,07,07,06,05,05,	-1,-1,07,09,10,09,	-1,12,11,09,10,09	)}
Function GAM7(Int BG_P){BG_GRASP(BG_P,		-1,00,02,01,02,00,	-1,-1,02,02,02,04,	05,-1,06,06,05,-1,	-1,-1,07,09,09,09,	-1,12,11,09,09,09	)}
Function GA7(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,02,00,	-1,-1,02,02,02,03,	05,07,05,06,05,05,	-1,-1,07,09,08,09,	-1,12,11,12,10,-1	)}
Function GA6(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,02,02,	05,-1,04,06,05,-1,	-1,-1,07,06,07,05,	-1,-1,07,09,07,09,	-1,12,11,11,10,-1	)}
Function GAm(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,01,00,	-1,-1,02,05,05,05,	05,07,07,05,05,05,	-1,-1,07,09,10,08,	-1,12,10,09,10,-1	)}
Function GAm7(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,01,00,	-1,-1,02,02,01,03,	-1,07,07,05,05,05,	-1,-1,07,09,08,08,	-1,12,10,12,10,12	)}
Function GAmM7(Int BG_P){BG_GRASP(BG_P,		-1,00,02,01,01,00,	-1,-1,02,02,01,04,	05,07,06,05,05,05,	-1,-1,07,09,09,08,	-1,12,10,13,-1,-1	)}
Function GAm7b5(Int BG_P){BG_GRASP(BG_P,		-1,00,01,00,01,-1,	05,-1,05,05,04,-1,	05,06,05,05,-1,-1,	-1,-1,07,08,08,08,	-1,12,10,12,10,11	)}
Function GAsus4(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,03,00,	-1,-1,02,02,03,05,	05,07,07,07,05,05,	-1,-1,07,09,10,10,	-1,12,12,-1,10,10	)}
Function GA7sus4(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,03,00,	-1,-1,02,02,03,03,	05,07,05,07,05,05,	-1,-1,07,09,08,10,	-1,12,12,12,10,10	)}
Function GAaug(Int BG_P){BG_GRASP(BG_P,		-1,00,03,02,02,01,	-1,04,-1,06,06,05,	-1,-1,07,06,06,05,	-1,08,07,06,06,09,	-1,08,07,06,06,09	)}
Function GAdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GAM7_9(Int BG_P){BG_GRASP(BG_P,		-1,00,02,01,00,00,	-1,-1,02,04,02,04,	-1,-1,06,06,05,07,	-1,-1,07,09,09,07,	-1,12,11,13,12,-1	)}
Function GA7_9(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,00,00,	-1,-1,02,04,02,03,	-1,-1,05,06,05,07,	-1,-1,07,09,08,07,	-1,12,11,12,12,12	)}
Function GAadd9(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,00,00,	-1,00,02,02,00,00,	-1,-1,07,06,05,07,	-1,-1,07,09,10,07,	-1,12,11,09,12,-1	)}
Function GAm7_9(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,00,00,	-1,-1,02,04,01,03,	05,07,05,05,05,07,	-1,-1,07,09,08,07,	-1,12,10,12,12,-1	)}
Function GA7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,03,02,03,	-1,-1,02,03,02,03,	-1,-1,07,06,08,06,	-1,-1,07,06,08,06,	-1,12,11,12,11,-1	)}
Function GA7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,07,06,08,08,	-1,-1,07,06,08,08,	-1,-1,07,06,08,08,	-1,-1,07,06,08,08,	-1,12,11,12,13,-1	)}
Function GAM7_9_p11(Int BG_P){BG_GRASP(BG_P,	05,-1,-1,04,04,04,	05,-1,-1,04,04,04,	05,-1,-1,04,04,04,	-1,-1,07,08,09,07,	-1,12,11,13,12,11	)}
Function GAm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,00,02,04,03,00,	05,-1,05,05,03,-1,	-1,-1,05,05,03,05,	-1,-1,07,09,08,10,	-1,12,10,12,12,10	)}
Function GA6_9(Int BG_P){BG_GRASP(BG_P,		05,-1,04,04,05,05,	05,-1,04,04,05,05,	-1,-1,07,09,07,07,	-1,-1,07,09,07,07,	-1,12,11,11,12,12	)}
Function GA7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,00,02,00,00,02,	05,07,05,06,07,05,	05,07,05,06,07,05,	-1,-1,07,06,07,07,	-1,12,11,12,12,14	)}
Function GA7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,00,02,00,00,01,	05,-1,05,06,06,-1,	05,-1,05,06,06,-1,	-1,-1,07,06,06,07,	-1,12,11,12,12,13	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_A# (yet)
Function GAp(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,03,01,	06,05,03,03,03,06,	06,08,08,07,06,06,	-1,-1,08,10,11,10,	-1,13,12,10,11,10	)}
Function GApM7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,03,01,	-1,-1,03,03,03,05,	06,-1,07,07,06,-1,	-1,-1,08,10,10,10,	-1,13,12,10,10,10	)}
Function GAp7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,03,01,	-1,-1,03,03,03,04,	06,08,06,07,06,06,	-1,-1,08,10,09,10,	-1,13,12,13,11,-1	)}
Function GAp6(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,03,03,	06,-1,05,07,06,-1,	-1,-1,08,07,08,06,	-1,-1,08,10,08,10,	-1,13,12,12,11,-1	)}
Function GApm(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,02,01,	-1,-1,03,06,06,06,	06,08,08,06,06,06,	-1,-1,08,10,11,09,	-1,13,11,10,11,-1	)}
Function GApm7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,02,01,	-1,-1,03,03,02,04,	-1,08,08,06,06,06,	-1,-1,08,10,09,09,	-1,13,11,13,11,13	)}
Function GApmM7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,02,01,	-1,-1,03,03,02,05,	06,08,07,06,06,06,	-1,-1,08,10,10,09,	-1,13,11,14,-1,-1	)}
Function GApm7b5(Int BG_P){BG_GRASP(BG_P,		-1,01,02,01,02,-1,	06,-1,06,06,05,-1,	06,07,06,06,-1,-1,	-1,-1,08,09,09,09,	-1,13,11,13,11,12	)}
Function GApsus4(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,04,01,	-1,-1,03,03,04,06,	06,08,08,08,06,06,	-1,-1,08,10,11,11,	-1,13,13,-1,11,11	)}
Function GAp7sus4(Int BG_P){BG_GRASP(BG_P,	-1,01,03,01,04,01,	-1,-1,03,03,04,04,	06,08,06,08,06,06,	-1,-1,08,10,09,11,	-1,13,13,13,11,11	)}
Function GApaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,03,02,	-1,05,04,03,03,06,	-1,05,-1,07,07,06,	-1,09,08,07,07,10,	-1,09,08,07,07,10	)}
Function GApdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GApM7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,01,01,	-1,-1,03,05,03,05,	-1,-1,07,07,06,08,	-1,-1,08,10,10,08,	-1,13,12,14,13,-1	)}
Function GAp7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,01,01,	-1,-1,03,05,03,04,	-1,-1,06,07,06,08,	-1,-1,08,10,09,08,	-1,13,12,13,13,13	)}
Function GApadd9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,01,01,	-1,01,03,03,01,01,	-1,-1,08,07,06,08,	-1,-1,08,10,11,08,	-1,13,12,10,13,-1	)}
Function GApm7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,01,01,	-1,-1,03,05,02,04,	06,08,06,06,06,08,	-1,-1,08,10,09,08,	-1,13,11,13,13,-1	)}
Function GAp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,01,00,-1,	-1,-1,03,04,03,04,	-1,-1,03,04,03,04,	-1,-1,08,07,09,07,	-1,13,12,13,12,-1	)}
Function GAp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,01,02,-1,	-1,01,00,01,02,-1,	-1,-1,08,07,09,09,	-1,-1,08,07,09,09,	-1,13,12,13,14,-1	)}
Function GApM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,01,00,02,01,00,	-1,01,00,02,01,00,	06,-1,-1,05,05,05,	06,-1,-1,05,05,05,	-1,13,12,14,13,12	)}
Function GApm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,01,03,05,04,-1,	-1,01,03,05,04,-1,	-1,-1,08,08,06,08,	-1,-1,08,08,06,08,	-1,-1,08,10,09,11	)}
Function GAp6_9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,00,01,01,	06,-1,05,05,06,06,	-1,-1,08,10,08,10,	-1,-1,08,10,08,08,	-1,13,12,12,13,13	)}
Function GAp7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,01,00,01,01,03,	06,08,06,07,08,06,	06,08,06,07,08,06,	-1,-1,08,07,08,08,	-1,13,12,13,13,15	)}
Function GAp7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,01,00,01,01,02,	06,-1,06,07,07,-1,	06,-1,06,07,07,-1,	-1,-1,08,07,07,08,	-1,13,12,13,13,14	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Bb (yet)
Function GBb(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,03,01,	06,05,03,03,03,06,	06,08,08,07,06,06,	-1,-1,08,10,11,10,	-1,13,12,10,11,10	)}
Function GBbM7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,03,01,	-1,-1,03,03,03,05,	06,-1,07,07,06,-1,	-1,-1,08,10,10,10,	-1,13,12,10,10,10	)}
Function GBb7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,03,01,	-1,-1,03,03,03,04,	06,08,06,07,06,06,	-1,-1,08,10,09,10,	-1,13,12,13,11,-1	)}
Function GBb6(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,03,03,	06,-1,05,07,06,-1,	-1,-1,08,07,08,06,	-1,-1,08,10,08,10,	-1,13,12,12,11,-1	)}
Function GBbm(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,02,01,	-1,-1,03,06,06,06,	06,08,08,06,06,06,	-1,-1,08,10,11,09,	-1,13,11,10,11,-1	)}
Function GBbm7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,02,01,	-1,-1,03,03,02,04,	-1,08,08,06,06,06,	-1,-1,08,10,09,09,	-1,13,11,13,11,13	)}
Function GBbmM7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,02,01,	-1,-1,03,03,02,05,	06,08,07,06,06,06,	-1,-1,08,10,10,09,	-1,13,11,14,-1,-1	)}
Function GBbm7b5(Int BG_P){BG_GRASP(BG_P,		-1,01,02,01,02,-1,	06,-1,06,06,05,-1,	06,07,06,06,-1,-1,	-1,-1,08,09,09,09,	-1,13,11,13,11,12	)}
Function GBbsus4(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,04,01,	-1,-1,03,03,04,06,	06,08,08,08,06,06,	-1,-1,08,10,11,11,	-1,13,13,-1,11,11	)}
Function GBb7sus4(Int BG_P){BG_GRASP(BG_P,	-1,01,03,01,04,01,	-1,-1,03,03,04,04,	06,08,06,08,06,06,	-1,-1,08,10,09,11,	-1,13,13,13,11,11	)}
Function GBbaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,03,02,	-1,05,04,03,03,06,	-1,05,-1,07,07,06,	-1,09,08,07,07,10,	-1,09,08,07,07,10	)}
Function GBbdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GBbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,01,01,	-1,-1,03,05,03,05,	-1,-1,07,07,06,08,	-1,-1,08,10,10,08,	-1,13,12,14,13,-1	)}
Function GBb7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,01,01,	-1,-1,03,05,03,04,	-1,-1,06,07,06,08,	-1,-1,08,10,09,08,	-1,13,12,13,13,13	)}
Function GBbadd9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,01,01,	-1,01,03,03,01,01,	-1,-1,08,07,06,08,	-1,-1,08,10,11,08,	-1,13,12,10,13,-1	)}
Function GBbm7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,01,01,	-1,-1,03,05,02,04,	06,08,06,06,06,08,	-1,-1,08,10,09,08,	-1,13,11,13,13,-1	)}
Function GBb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,01,00,-1,	-1,-1,03,04,03,04,	-1,-1,03,04,03,04,	-1,-1,08,07,09,07,	-1,13,12,13,12,-1	)}
Function GBb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,01,02,-1,	-1,01,00,01,02,-1,	-1,-1,08,07,09,09,	-1,-1,08,07,09,09,	-1,13,12,13,14,-1	)}
Function GBbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,01,00,02,01,00,	-1,01,00,02,01,00,	06,-1,-1,05,05,05,	06,-1,-1,05,05,05,	-1,13,12,14,13,12	)}
Function GBbm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,01,03,05,04,-1,	-1,01,03,05,04,-1,	-1,-1,08,08,06,08,	-1,-1,08,08,06,08,	-1,-1,08,10,09,11	)}
Function GBb6_9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,00,01,01,	06,-1,05,05,06,06,	-1,-1,08,10,08,10,	-1,-1,08,10,08,08,	-1,13,12,12,13,13	)}
Function GBb7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,01,00,01,01,03,	06,08,06,07,08,06,	06,08,06,07,08,06,	-1,-1,08,07,08,08,	-1,13,12,13,13,15	)}
Function GBb7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,01,00,01,01,02,	06,-1,06,07,07,-1,	06,-1,06,07,07,-1,	-1,-1,08,07,07,08,	-1,13,12,13,13,14	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_B
Function GB(Int BG_P){BG_GRASP(BG_P,		02,02,04,04,04,02,	07,06,04,04,04,07,	07,09,09,08,07,07,	-1,-1,09,11,12,11,	-1,14,13,11,12,11	)}
Function GBM7(Int BG_P){BG_GRASP(BG_P,		-1,02,04,03,04,02,	-1,-1,04,04,04,06,	07,-1,08,08,07,-1,	-1,-1,09,11,11,11,	-1,14,13,11,11,11	)}
Function GB7(Int BG_P){BG_GRASP(BG_P,		-1,02,01,02,00,02,	-1,02,04,02,04,02,	07,09,07,08,07,07,	07,09,07,08,07,07,	-1,-1,09,11,10,11	)}
Function GB6(Int BG_P){BG_GRASP(BG_P,		-1,02,04,04,04,04,	07,-1,06,08,07,-1,	-1,-1,09,08,09,07,	-1,-1,09,11,09,11,	-1,14,13,13,12,-1	)}
Function GBm(Int BG_P){BG_GRASP(BG_P,		-1,02,04,04,03,02,	-1,-1,04,07,07,07,	07,09,09,07,07,07,	-1,-1,09,11,12,10,	-1,14,12,11,12,-1	)}
Function GBm7(Int BG_P){BG_GRASP(BG_P,		-1,02,00,02,00,02,	-1,02,04,02,03,02,	-1,-1,04,04,03,05,	07,09,07,07,07,07,	-1,-1,09,11,10,10	)}
Function GBmM7(Int BG_P){BG_GRASP(BG_P,		-1,02,00,03,-1,-1,	-1,02,04,03,03,02,	-1,-1,04,04,03,06,	07,09,08,07,07,07,	-1,-1,09,11,11,10	)}
Function GBm7b5(Int BG_P){BG_GRASP(BG_P,		-1,02,00,02,00,01,	-1,02,03,02,03,-1,	07,-1,07,07,06,-1,	07,08,07,07,-1,-1,	-1,-1,09,10,10,10	)}
Function GBsus4(Int BG_P){BG_GRASP(BG_P,		-1,02,04,04,05,02,	-1,-1,04,04,05,07,	07,09,09,09,07,07,	-1,-1,09,11,12,12,	-1,14,14,-1,12,12	)}
Function GB7sus4(Int BG_P){BG_GRASP(BG_P,		-1,02,04,02,05,02,	-1,-1,04,04,05,05,	07,09,07,09,07,07,	-1,-1,09,11,10,12,	-1,14,14,14,12,12	)}
Function GBaug(Int BG_P){BG_GRASP(BG_P,		-1,02,01,00,00,03,	-1,-1,05,04,04,03,	-1,06,05,04,04,07,	-1,-1,09,08,08,07,	-1,14,13,12,12,15	)}
Function GBdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GBM7_9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,03,02,-1,	-1,02,04,03,02,02,	-1,-1,04,06,04,06,	-1,-1,08,08,07,09,	-1,-1,09,11,11,09	)}
Function GB7_9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,02,02,02,	-1,02,04,02,02,02,	-1,-1,04,06,04,05,	-1,-1,07,08,07,09,	-1,-1,09,11,10,09	)}
Function GBadd9(Int BG_P){BG_GRASP(BG_P,		-1,02,04,04,02,02,	-1,02,04,04,02,02,	-1,-1,09,08,07,09,	-1,-1,09,11,12,09,	-1,14,13,11,14,-1	)}
Function GBm7_9(Int BG_P){BG_GRASP(BG_P,		-1,02,00,02,02,02,	-1,02,04,02,02,02,	-1,-1,04,06,03,05,	07,09,07,07,07,09,	-1,-1,09,11,10,09	)}
Function GB7_b9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,02,01,-1,	-1,-1,04,05,04,05,	-1,-1,04,05,04,05,	-1,-1,09,08,10,08,	-1,-1,09,08,10,08	)}
Function GB7_p9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,02,03,-1,	-1,02,01,02,03,-1,	-1,-1,09,08,10,10,	-1,-1,09,08,10,10,	-1,-1,09,08,10,10	)}
Function GBM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,02,01,03,02,01,	-1,02,01,03,02,01,	07,-1,-1,06,06,06,	07,-1,-1,06,06,06,	-1,-1,09,10,11,09	)}
Function GBm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,02,00,02,02,00,	-1,02,04,06,05,-1,	-1,-1,07,07,05,07,	-1,-1,07,07,05,07,	-1,-1,09,11,10,12	)}
Function GB6_9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,01,02,02,	-1,02,01,01,02,02,	07,-1,06,06,07,07,	-1,-1,09,11,09,09,	-1,-1,09,11,09,09	)}
Function GB7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,02,01,02,02,04,	-1,02,04,02,02,04,	07,09,07,08,09,07,	07,09,07,08,09,07,	-1,-1,09,08,09,09	)}
Function GB7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,02,01,02,02,03,	-1,02,04,02,02,03,	07,-1,07,08,08,-1,	-1,-1,09,08,08,09,	-1,-1,09,08,08,09	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
