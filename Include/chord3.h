//------------------------------------------------------------------------------ Header.
//
//　らくちんぷろぐれっしょん関数　ver.1.00 LastUpdate = 2000/05/26　みづぃんこ
//
//　　Ｔ，ＳＤ，Ｄ，ＳＤＭ，Ｔｍ，Ｓｍ，Ｄｍ指定サポート (For Sakura)
//　　Ｔ，Ｓ，Ｄ，ＳＭ，Ｔｍ，Ｓｍ，Ｄｍ指定サポート (For Sakura)
//　　※劇物につき使いすぎ注意
//
//------------------------------------------------------------------------------ KeyPosition.
Int KEY = 0;					// 調指定用受け渡し変数
Int Disp = 0;					// コード構成音＆ノーテーション表示フラグ
Int Open = 0;					// オープンボイシングフラグ
Int Mode = 0;					// チャーチモード指定用変数
Int Minor = 0;					// ナチュラルマイナーフラグ
Int Minor_Sw = 0;					// モード表示用切り替えスイッチ
Int C  = 0;						// 調指定用代数
Int Cp = 1;
Int D  = 2;
Int Dp = 3;
Int E  = 4;
Int F  = 5;
Int Fp = -6;
Int G  = -5;
Int Gp = -4;
Int A  = -3;
Int Ap = -2;
Int B  = -1;
#KEY_C	= {KEY = C;}			// 調指定用文字列マクロ
#KEY_Cp	= {KEY = Cp;}
#KEY_D	= {KEY = D;}
#KEY_Dp	= {KEY = Dp;}
#KEY_E	= {KEY = E;}
#KEY_F	= {KEY = F;}
#KEY_Fp	= {KEY = Fp;}
#KEY_G	= {KEY = G;}
#KEY_Gp	= {KEY = Gp;}
#KEY_A	= {KEY = A;}
#KEY_Ap	= {KEY = Ap;}
#KEY_B	= {KEY = B;}
//------------------------------------------------------------------------------ InvertFunction.
Function Invert(){
	Note0 = Note0 + KEY;			// 指定された調へノート値をシフト
	Note1 = Note1 + KEY;
	Note2 = Note2 + KEY;
	Note3 = Note3 + KEY;
	Note4 = Note4 + KEY;
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
//------------------------------------------------------------------------------ OptionChordFunction.
Function Ins_opt(){
	If(SecD_SW==1){
	  If(TwoF_SW==1){
	    If(Bass==0){n(NoteA),0}; n(NoteB),0; n(NoteC),0; n(NoteD),0; n(NoteE),%(TwoF_Len);
	    If(Disp==1){
	      If(Minor_Sw==1){
	        Mode=6;#Ch={ m7(-5)  };#Op={Two_F};NumToNote(NoteA,NoteB,NoteC,NoteD,NoteE);
	      }Else{
	        Mode=1;#Ch={ m7      };#Op={Two_F};NumToNote(NoteA,NoteB,NoteC,NoteD,NoteE);
	      }
	    }
	  }
	  If(Bass==0){n(Note5),0}; n(Note6),0; n(Note7),0; n(Note8),0; n(Note9),%(SecD_Len);
	  If(Disp==1){
	    If(Minor_Sw==1){
	      Mode=7;#Ch={ 7       };#Op={Sec_D};NumToNote(Note5,Note6,Note7,Note8,Note9);
	    }Else{
	      Mode=4;#Ch={ 7       };#Op={Sec_D};NumToNote(Note5,Note6,Note7,Note8,Note9);
	    }
	  }
	}
	If(SecD_SW==2){
	  If(TwoF_SW==1){
	    If(Bass==0){n(NoteA),0}; n(NoteB),0; n(NoteC),0; n(NoteD),0; n(NoteE),%(TwoF_Len);
	    If(Disp==1){
	      If(Minor_Sw==1){
	        Mode=6;#Ch={ m7(-5)  };#Op={Two_F};NumToNote(NoteA,NoteB,NoteC,NoteD,NoteE);
	      }Else{
	        Mode=1;#Ch={ m7      };#Op={Two_F};NumToNote(NoteA,NoteB,NoteC,NoteD,NoteE);
	      }
	    }
	  }
	  If(Bass==0){n(NoteF),0}; n(NoteG),0; n(NoteH),0; n(NoteI),0; n(NoteJ),%(SecD_Len);
	  If(Disp==1){
	    Mode=4;#Ch={ 7       };#Op={Rep_D};NumToNote(NoteF,NoteG,NoteH,NoteI,NoteJ);
	  }
	}
}
//------------------------------------------------------------------------------ PrintNoteFunction.
Function NumToNote(Int N0,Int N1,Int N2,Int N3,Int N4){
	N0 = N0 % 12;N1 = N1 % 12;N2 = N2 % 12;N3 = N3 % 12;N4 = N4 % 12;
	If(N0==0){#N0={C }};If(N0==1){#N0={C#}};If(N0==2){#N0={D }}; If(N0==3){#N0={D#}};
	If(N0==4){#N0={E }};If(N0==5){#N0={F }};If(N0==6){#N0={F#}}; If(N0==7){#N0={G }};
	If(N0==8){#N0={G#}};If(N0==9){#N0={A }};If(N0==10){#N0={A#}};If(N0==11){#N0={B }};

	If(N1==0){#N1={C ,}};If(N1==1){#N1={C#,}};If(N1==2){#N1={D ,}}; If(N1==3){#N1={D#,}};
	If(N1==4){#N1={E ,}};If(N1==5){#N1={F ,}};If(N1==6){#N1={F#,}}; If(N1==7){#N1={G ,}};
	If(N1==8){#N1={G#,}};If(N1==9){#N1={A ,}};If(N1==10){#N1={A#,}};If(N1==11){#N1={B ,}};

	If(N2==0){#N2={C ,}};If(N2==1){#N2={C#,}};If(N2==2){#N2={D ,}}; If(N2==3){#N2={D#,}};
	If(N2==4){#N2={E ,}};If(N2==5){#N2={F ,}};If(N2==6){#N2={F#,}}; If(N2==7){#N2={G ,}};
	If(N2==8){#N2={G#,}};If(N2==9){#N2={A ,}};If(N2==10){#N2={A#,}};If(N2==11){#N2={B ,}};

	If(N3==0){#N3={C ,}};If(N3==1){#N3={C#,}};If(N3==2){#N3={D ,}}; If(N3==3){#N3={D#,}};
	If(N3==4){#N3={E ,}};If(N3==5){#N3={F ,}};If(N3==6){#N3={F#,}}; If(N3==7){#N3={G ,}};
	If(N3==8){#N3={G#,}};If(N3==9){#N3={A ,}};If(N3==10){#N3={A#,}};If(N3==11){#N3={B ,}};

	If(N4==0){#N4={C  }};If(N4==1){#N4={C# }};If(N4==2){#N4={D  }}; If(N4==3){#N4={D# }};
	If(N4==4){#N4={E  }};If(N4==5){#N4={F  }};If(N4==6){#N4={F# }}; If(N4==7){#N4={G  }};
	If(N4==8){#N4={G# }};If(N4==9){#N4={A  }};If(N4==10){#N4={A# }};If(N4==11){#N4={B  }};

	Print(#N0+#Ch+#N1+#N2+#N3+#N4+#Nm+#Op);		// コード構成音表示

	Array Ioni  = (0,2,4,5,7,9,11);		// アイオニアン
	Array Dori  = (0,2,3,5,7,9,10);		// ドリアン
	Array Phry  = (0,1,3,5,7,8,10);		// フリジアン
	Array Lydi  = (0,2,4,6,7,9,11);		// リディアン
	Array Mixo  = (0,2,4,5,7,9,10);		// ミクソリディアン
	Array Aeol  = (0,2,3,5,7,8,10);		// エオリアン
	Array Hypo  = (0,1,3,5,6,8,10);		// ロクリアン
	Array Mix6  = (0,2,4,5,7,8,10);		// ミクソリディアン♭６ｔｈ
	Array Phr3  = (0,1,4,5,7,8,10);		// フリジアン・ナチュラル３ｒｄ
	Array Hyp7  = (0,1,3,4,6,8,9);		// スーパーロクリアン♭♭７ｔｈ
	Array Hyp4  = (0,1,3,4,6,8,10);		// ロクリアン♭４ｔｈ
	Array Scale = (0,0,0,0,0,0,0);		// スケールの器
	If(Mode==0){Scale=Ioni;#Spn={   Ionian}};
	If(Mode==1){Scale=Dori;#Spn={   Dorian}};
	If(Mode==2){Scale=Phry;#Spn={   Phrygian}};
	If(Mode==3){Scale=Lydi;#Spn={   Lydian}};
	If(Mode==4){Scale=Mixo;#Spn={   Mixo-Lydian}};
	If(Mode==5){Scale=Aeol;#Spn={   Aeolian}};
	If(Mode==6){Scale=Hypo;#Spn={   Locrian}};
	If(Mode==7){Scale=Mix6;#Spn={   Mixo-Lydian(-6)}};
	If(Mode==8){Scale=Phr3;#Spn={   Phrygian(nat.3)}};
	If(Mode==9){Scale=Hyp7;#Spn={   Super Locrian(--7)}};
	If(Mode==10){Scale=Hyp4;#Spn={   Locrian(-4)}};
	Int M1 = N0;
	Int M2 = N0 + Scale(1);Int M3 = N0 + Scale(2);Int M4 = N0 + Scale(3);
	Int M5 = N0 + Scale(4);Int M6 = N0 + Scale(5);Int M7 = N0 + Scale(6);
	M1 = M1 % 12;M2 = M2 % 12;M3 = M3 % 12;M4 = M4 % 12;
	M5 = M5 % 12;M6 = M6 % 12;M7 = M7 % 12;

	If(M1==0){#M1={C ,}};If(M1==1){#M1={C#,}};If(M1==2){#M1={D ,}}; If(M1==3){#M1={D#,}};
	If(M1==4){#M1={E ,}};If(M1==5){#M1={F ,}};If(M1==6){#M1={F#,}}; If(M1==7){#M1={G ,}};
	If(M1==8){#M1={G#,}};If(M1==9){#M1={A ,}};If(M1==10){#M1={A#,}};If(M1==11){#M1={B ,}};

	If(M2==0){#M2={C ,}};If(M2==1){#M2={C#,}};If(M2==2){#M2={D ,}}; If(M2==3){#M2={D#,}};
	If(M2==4){#M2={E ,}};If(M2==5){#M2={F ,}};If(M2==6){#M2={F#,}}; If(M2==7){#M2={G ,}};
	If(M2==8){#M2={G#,}};If(M2==9){#M2={A ,}};If(M2==10){#M2={A#,}};If(M2==11){#M2={B ,}};

	If(M3==0){#M3={C ,}};If(M3==1){#M3={C#,}};If(M3==2){#M3={D ,}}; If(M3==3){#M3={D#,}};
	If(M3==4){#M3={E ,}};If(M3==5){#M3={F ,}};If(M3==6){#M3={F#,}}; If(M3==7){#M3={G ,}};
	If(M3==8){#M3={G#,}};If(M3==9){#M3={A ,}};If(M3==10){#M3={A#,}};If(M3==11){#M3={B ,}};

	If(M4==0){#M4={C ,}};If(M4==1){#M4={C#,}};If(M4==2){#M4={D ,}}; If(M4==3){#M4={D#,}};
	If(M4==4){#M4={E ,}};If(M4==5){#M4={F ,}};If(M4==6){#M4={F#,}}; If(M4==7){#M4={G ,}};
	If(M4==8){#M4={G#,}};If(M4==9){#M4={A ,}};If(M4==10){#M4={A#,}};If(M4==11){#M4={B ,}};

	If(M5==0){#M5={C ,}};If(M5==1){#M5={C#,}};If(M5==2){#M5={D ,}}; If(M5==3){#M5={D#,}};
	If(M5==4){#M5={E ,}};If(M5==5){#M5={F ,}};If(M5==6){#M5={F#,}}; If(M5==7){#M5={G ,}};
	If(M5==8){#M5={G#,}};If(M5==9){#M5={A ,}};If(M5==10){#M5={A#,}};If(M5==11){#M5={B ,}};

	If(M6==0){#M6={C ,}};If(M6==1){#M6={C#,}};If(M6==2){#M6={D ,}}; If(M6==3){#M6={D#,}};
	If(M6==4){#M6={E ,}};If(M6==5){#M6={F ,}};If(M6==6){#M6={F#,}}; If(M6==7){#M6={G ,}};
	If(M6==8){#M6={G#,}};If(M6==9){#M6={A ,}};If(M6==10){#M6={A#,}};If(M6==11){#M6={B ,}};

	If(M7==0){#M7={C }};If(M7==1){#M7={C#}};If(M7==2){#M7={D }}; If(M7==3){#M7={D#}};
	If(M7==4){#M7={E }};If(M7==5){#M7={F }};If(M7==6){#M7={F#}}; If(M7==7){#M7={G }};
	If(M7==8){#M7={G#}};If(M7==9){#M7={A }};If(M7==10){#M7={A#}};If(M7==11){#M7={B }};

	Print(#M1+#M2+#M3+#M4+#M5+#M6+#M7+#Spn);
}
//------------------------------------------------------------------------------ MainFunction.
/* T1 I(c,e,g,c)  SecD V7(g,b,d,f)  TwoF IIm7(d,f,a,c)  RepD I#7(c+,f,g+,b) */
Function T1(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<T1>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5e);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 1; Int NoteC = Note2 + 1; Int NoteH = Note2 + 1;
	Int Note8 = Note3;     Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 - 1; Int NoteE = Note4;     Int NoteJ = Note4 - 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=0;#Ch={ maj     };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* T2 Isus4(c,f,g,c)  SecD V7(g,b,d,f)  TwoF IIm7(d,f,a,c)  RepD I#7(c+,f,g+,b) */
Function T2(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<T2>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2    ; Int NoteC = Note2    ; Int NoteH = Note2    ;
	Int Note8 = Note3;     Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 - 1; Int NoteE = Note4;     Int NoteJ = Note4 - 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=0;#Ch={ sus4    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* T3 Imaj7(c,e,g,b)  SecD V7(g,b,d,f)  TwoF IIm7(d,f,a,c)  RepD I#7(c+,f,g+,b) */
Function T3(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<T3>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5e);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 1; Int NoteC = Note2 + 1; Int NoteH = Note2 + 1;
	Int Note8 = Note3    ; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4    ; Int NoteE = Note4 + 1; Int NoteJ = Note4    ;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=0;#Ch={ maj7    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* T4 VIm7(a,c,e,g)  SecD III7(e,g,b,d)  TwoF VIIm7(b,d,f+,a)  RepD VI#7(a+,d,f,g+) */
Function T4(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<T4>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 - 2; Int NoteB = Note1 - 2; Int NoteG = Note1 - 2;
	Int Note7 = Note2 - 3; Int NoteC = Note2 - 1; Int NoteH = Note2 - 2;
	Int Note8 = Note3 - 1; Int NoteD = Note3    ; Int NoteI = Note3 - 1;
	Int Note9 = Note4 - 1; Int NoteE = Note4 - 1; Int NoteJ = Note4 - 2;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=5;#Ch={ m7      };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* T5 IIIm7(e,g,b,d)  SecD VII7(b,d+,f+,a)  TwoF IV#m7(f+,a,c+,e)  RepD IV7(f,a,c,d+) */
Function T5(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<T5>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5e);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 1; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 2; Int NoteC = Note2 + 2; Int NoteH = Note2 + 1;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 2;
	Int Note9 = Note4    ; Int NoteE = Note4 + 2; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=2;#Ch={ m7      };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* T6 I7(c,e,g,a+)  SecD V7(g,b,d,f)  TwoF IIm7(d,f,a,c)  RepD I#7(c+,f,g+,b) */
Function T6(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<T6>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5a+);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 - 2; Int NoteB = Note1 - 2; Int NoteG = Note1 - 3;
	Int Note7 = Note2 - 2; Int NoteC = Note2 - 2; Int NoteH = Note2 - 2;
	Int Note8 = Note3 - 3; Int NoteD = Note3 - 1; Int NoteI = Note3 - 2;
	Int Note9 = Note4 - 1; Int NoteE = Note4    ; Int NoteJ = Note4 - 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=4;#Ch={ 7       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* T7 Isus4_7(c,f,g,a+)  SecD V7(g,b,d,f)  TwoF IIm7(d,f,a,c)  RepD I#7(c+,f,g+,b) */
Function T7(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<T7>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5a+);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 - 3; Int NoteB = Note1 - 3; Int NoteG = Note1 - 4;
	Int Note7 = Note2 - 2; Int NoteC = Note2 - 2; Int NoteH = Note2 - 2;
	Int Note8 = Note3 - 3; Int NoteD = Note3 - 1; Int NoteI = Note3 - 2;
	Int Note9 = Note4 - 1; Int NoteE = Note4    ; Int NoteJ = Note4 - 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=4;#Ch={ sus4+7  };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* S1 IV(f,a,c,f)  SecD I7(c,e,g,a+)  TwoF Vm7(g,a+,d,f)  RepD IV#7(f+,a+,c+,e) */
Function S1(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<S1>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 4; Int NoteB = Note1 + 2; Int NoteG = Note1 + 4;
	Int Note7 = Note2 + 2; Int NoteC = Note2    ; Int NoteH = Note2 + 1;
	Int Note8 = Note3 + 1; Int NoteD = Note3 - 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4    ; Int NoteE = Note4 - 2; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=3;#Ch={ maj     };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SD1(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	S1(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len);
}

/* S2 IVmaj7(f,a,c,e)  SecD I7(c,e,g,a+)  TwoF Vm7(g,a+,d,f)  RepD IV#7(f+,a+,c+,e) */
Function S2(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<S2>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1    ; Int NoteB = Note1 - 2; Int NoteG = Note1 - 3;
	Int Note7 = Note2 + 2; Int NoteC = Note2    ; Int NoteH = Note2 - 1;
	Int Note8 = Note3 + 1; Int NoteD = Note3 - 2; Int NoteI = Note3 - 3;
	Int Note9 = Note4    ; Int NoteE = Note4 - 2; Int NoteJ = Note4 - 2;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=3;#Ch={ maj7    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SD2(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	S2(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len);
}

/* S3 IIm7(d,f,a,c)  SecD VI7(a,c+,e,g)  TwoF IIIm7(e,g,b,d)  RepD II#7(d+,g,a+,c+) */
Function S3(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<S3>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 2; Int NoteC = Note2 + 2; Int NoteH = Note2 + 2;
	Int Note8 = Note3    ; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 + 1; Int NoteE = Note4 + 2; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=1;#Ch={ m7      };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SD3(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	S3(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len);
}

/* S4 IV7(f,a,c,d+)  SecD I7(c,e,g,a+)  TwoF Vm7(g,a+,d,f)  RepD IV#7(f+,a+,c+,e) */
Function S4(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<S4>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5d+);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 1; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 2; Int NoteC = Note2 + 2; Int NoteH = Note2 + 1;
	Int Note8 = Note3 + 1; Int NoteD = Note3 + 1; Int NoteI = Note3 + 1;
	Int Note9 = Note4    ; Int NoteE = Note4 + 2; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=4;#Ch={ 7       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SD4(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	S4(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len);
}

/* D1 V(g,b,d,g)  SecD II7(d,f+,a,c)  TwoF VIm7(a,c,e,g)  RepD V#7(g+,c,d+,f+) */
Function D1(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<D1>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o4b);
	Int Note2 = NoteNo(o5d);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 3; Int NoteB = Note1 + 5; Int NoteG = Note1 + 4;
	Int Note7 = Note2 + 4; Int NoteC = Note2 + 5; Int NoteH = Note2 + 4;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 + 1; Int NoteE = Note4 + 1; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=4;#Ch={ maj     };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* D2 Vsus4(g,c,d,g)  SecD II7(d,f+,a,c)  TwoF VIm7(a,c,e,g)  RepD V#7(g+,c,d+,f+) */
Function D2(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<D2>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5d);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 4; Int NoteG = Note1 + 3;
	Int Note7 = Note2 + 4; Int NoteC = Note2 + 5; Int NoteH = Note2 + 4;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4    ; Int NoteE = Note4    ; Int NoteJ = Note4    ;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=4;#Ch={ sus4    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* D3 V7(g,b,d,f)  SecD II7(d,f+,a,c)  TwoF VIm7(a,c,e,g)  RepD V#7(g+,c,d+,f+) */
Function D3(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<D3>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1    ; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 1; Int NoteC = Note2 + 2; Int NoteH = Note2 + 1;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 + 1; Int NoteE = Note4 + 1; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=4;#Ch={ 7       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* D4 V6(g,b,d,e)  SecD II7(d,f+,a,c)  TwoF VIm7(a,c,e,g)  RepD V#7(g+,c,d+,f+) */
Function D4(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	If(Minor==0){#Nm={<D4>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5e);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1    ; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 2; Int NoteC = Note2 + 3; Int NoteH = Note2 + 2;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 + 1; Int NoteE = Note4 + 1; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=4;#Ch={ 6       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* SM1 IVm(f,g+,c,f) */
Function SM1(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM1>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=1;#Ch={ m       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM1(Len,Inv,Bass){
	SM1(Len,Inv,Bass);
}

/* SM2 IVm6(f,g+,c,d) */
Function SM2(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM2>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=1;#Ch={ m6      };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM2(Len,Inv,Bass){
	SM2(Len,Inv,Bass);
}

/* SM3 IVm7(f,g+,c,d+) */
Function SM3(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM3>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5d+);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=1;#Ch={ m7      };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM3(Len,Inv,Bass){
	SM3(Len,Inv,Bass);
}

/* SM4 I#maj7(c+,f,g+,c) */
Function SM4(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM4>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c+);
	Int Note1 = NoteNo(o5c+);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=3;#Ch={ maj7    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM4(Len,Inv,Bass){
	SM4(Len,Inv,Bass);
}

/* SM5 V#maj7(g+,c,d+,g) */
Function SM5(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM5>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3g+);
	Int Note1 = NoteNo(o5d+);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=3;#Ch={ maj7    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM5(Len,Inv,Bass){
	SM5(Len,Inv,Bass);
}

/* SM6 VI#6(a+,d,f,g) */
Function SM6(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM6>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3a+);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5a+);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=4;#Ch={ 6       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM6(Len,Inv,Bass){
	SM6(Len,Inv,Bass);
}

/* SM7 IIm7(-5)(d,f,g+,c) */
Function SM7(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM7>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=6;#Ch={ m7(-5)  };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM7(Len,Inv,Bass){
	SM7(Len,Inv,Bass);
}

/* S_D1 IVonV(g,f,a,c,e) */
Function S_D1(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<S_D1>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=4;#Ch={ +IVmaj7 };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SD_D1(Len,Inv,Bass){
	S_D1(Len,Inv,Bass);
}

/* S_D2 IIm7onV(g,d,f,a,c) */
Function S_D2(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<S_D2>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=4;#Ch={ +IIm7   };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SD_D2(Len,Inv,Bass){
	S_D2(Len,Inv,Bass);
}

/* D_T V6onVI(a,g,b,d,f) */
Function D_T(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<D_T>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5e);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=5;#Ch={ +V6     };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* T_S VIm7onII(d,a,c,e,g) */
Function T_S(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<T_S>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=1;#Ch={ +VIm7   };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function T_SD(Len,Inv,Bass){
	T_S(Len,Inv,Bass);
}

/* SM_T1 V#maj7onI(c,g+,c,d+,g) */
Function SM_T1(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM_T1>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5d+);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=5;#Ch={ +V#maj7 };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM_T1(Len,Inv,Bass){
	SM_T1(Len,Inv,Bass);
}

/* SM_T2 VI#6onI(c,a+,d,f,g) */
Function SM_T2(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM_T2>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5a+);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=5;#Ch={ +VI#6   };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM_T2(Len,Inv,Bass){
	SM_T2(Len,Inv,Bass);
}

/* SM_T3 I#maj7onI(c,c+,f,g+,c) */
Function SM_T3(Int Len,Int Inv,Int Bass){
	If(Minor==0){#Nm={<SM_T3>};}
	Minor_Sw = 0;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c+);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(Bass==0){
		n(Note0),0; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	}
	If(Disp==1){Mode=2;#Ch={ +I#maj7 };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}
Function SDM_T3(Len,Inv,Bass){
	SM_T3(Len,Inv,Bass);
}

/* Tm1 Im(c,c,d+,g,c) */
Function Tm1(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Tm1>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5d+);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 2; Int NoteC = Note2 + 2; Int NoteH = Note2 + 2;
	Int Note8 = Note3;     Int NoteD = Note3 + 1; Int NoteI = Note3 + 1;
	Int Note9 = Note4 - 1; Int NoteE = Note4;     Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=5;#Ch={ m       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Tm2 Isus4(c,c,f,g,c) */
Function Tm2(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Tm2>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2;     Int NoteC = Note2;     Int NoteH = Note2;
	Int Note8 = Note3;     Int NoteD = Note3 + 1; Int NoteI = Note3 + 1;
	Int Note9 = Note4 - 1; Int NoteE = Note4;     Int NoteJ = Note4 - 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=5;#Ch={ sus4    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Tm3 Im7(c,d+,g,a+,c) */
Function Tm3(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Tm3>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5d+);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5a+);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 - 1; Int NoteB = Note1 - 1; Int NoteG = Note1 - 2;
	Int Note7 = Note2 - 2; Int NoteC = Note2 - 2; Int NoteH = Note2 - 2;
	Int Note8 = Note3 - 3; Int NoteD = Note3 - 2; Int NoteI = Note3 - 2;
	Int Note9 = Note4 - 1; Int NoteE = Note4;     Int NoteJ = Note4 - 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=5;#Ch={ m7      };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Tm4 II#maj7(d+,d+,g,a+,d) */
Function Tm4(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Tm4>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o4d+);
	Int Note1 = NoteNo(o5d+);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5a+);
	Int Note4 = NoteNo(o6d);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 1; Int NoteC = Note2 + 1; Int NoteH = Note2 + 1;
	Int Note8 = Note3;     Int NoteD = Note3 + 1; Int NoteI = Note3 + 1;
	Int Note9 = Note4;     Int NoteE = Note4 + 1; Int NoteJ = Note4;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=0;#Ch={ maj7    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Tm5 V#maj7(g+,d+,g,g+,c) */
Function Tm5(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Tm5>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3g+);
	Int Note1 = NoteNo(o5d+);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1;     Int NoteB = Note1 + 1; Int NoteG = Note1 + 1;
	Int Note7 = Note2;     Int NoteC = Note2 + 1; Int NoteH = Note2;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 + 1; Int NoteE = Note4 + 1; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=3;#Ch={ maj7    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Sm1 IV(f,c,f,g+,c) */
Function Sm1(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Sm1>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 -10; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 4; Int NoteB = Note1 + 5; Int NoteG = Note1 + 4;
	Int Note7 = Note2 + 2; Int NoteC = Note2 + 2; Int NoteH = Note2 + 1;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 2;
	Int Note9 = Note4;     Int NoteE = Note4 + 1; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=1;#Ch={ m       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Sm2 IVm7(f,d+,f,g+,c) */
Function Sm2(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Sm2>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5d+);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 -10; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 1; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 2; Int NoteC = Note2 + 2; Int NoteH = Note2 + 1;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 2;
	Int Note9 = Note4;     Int NoteE = Note4 + 1; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=1;#Ch={ m7      };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Sm3 IIm7-5(d,d,f,g+,c) */
Function Sm3(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Sm3>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 - 5; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 2; Int NoteC = Note2 + 2; Int NoteH = Note2 + 2;
	Int Note8 = Note3 + 1; Int NoteD = Note3 + 2; Int NoteI = Note3 + 2;
	Int Note9 = Note4 + 1; Int NoteE = Note4 + 2; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=6;#Ch={ m7(-5)  };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Dm1 Vm(g,d,g,a+,d) */
Function Dm1(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Dm1>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5a+);
	Int Note4 = NoteNo(o6d);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 -10; Int NoteF = Note0 + 1;
	Int Note6 = Note1;     Int NoteB = Note1 + 1; Int NoteG = Note1 + 1;
	Int Note7 = Note2 - 1; Int NoteC = Note2;     Int NoteH = Note2 - 1;
	Int Note8 = Note3 - 1; Int NoteD = Note3 - 1; Int NoteI = Note3 - 2;
	Int Note9 = Note4 - 2; Int NoteE = Note4 - 2; Int NoteJ = Note4 - 2;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=2;#Ch={ m       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Dm2 Vsus4(g,c,d,g,c) */
Function Dm2(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Dm2>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5d);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o6c);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 3; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 4; Int NoteC = Note2 + 5; Int NoteH = Note2 + 3;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4;     Int NoteE = Note4;     Int NoteJ = Note4;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=2;#Ch={ sus4    };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Dm3 Vm7(g,f,g,a+,d) */
Function Dm3(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Dm3>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5a+);
	Int Note4 = NoteNo(o6d);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 -10; Int NoteF = Note0 + 1;
	Int Note6 = Note1 - 3; Int NoteB = Note1 - 2; Int NoteG = Note1 - 2;
	Int Note7 = Note2 - 1; Int NoteC = Note2;     Int NoteH = Note2 - 1;
	Int Note8 = Note3 - 1; Int NoteD = Note3 - 1; Int NoteI = Note3 - 2;
	Int Note9 = Note4 - 2; Int NoteE = Note4 - 2; Int NoteJ = Note4 - 2;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=2;#Ch={ m7      };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Dm4 V7(g,d,f,g,b) */
Function Dm4(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Dm4>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1;     Int NoteB = Note1 + 2; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 1; Int NoteC = Note2 + 2; Int NoteH = Note2 + 1;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 + 1; Int NoteE = Note4 + 1; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=7;#Ch={ 7       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Dm5 V7(g,d,f,g,b) */
Function Dm5(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Dm5>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1;     Int NoteB = Note1 + 1; Int NoteG = Note1 + 1;
	Int Note7 = Note2 + 1; Int NoteC = Note2 + 2; Int NoteH = Note2 + 1;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 + 1; Int NoteE = Note4 + 1; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=8;#Ch={ 7       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Dm6 VI#7(a+,f,g+,a+,d) */
Function Dm6(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Dm6>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3a+);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g+);
	Int Note3 = NoteNo(o5a+);
	Int Note4 = NoteNo(o6d);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 - 2; Int NoteB = Note1 - 2; Int NoteG = Note1 - 2;
	Int Note7 = Note2 - 3; Int NoteC = Note2 - 2; Int NoteH = Note2 - 2;
	Int Note8 = Note3 - 1; Int NoteD = Note3;     Int NoteI = Note3 - 1;
	Int Note9 = Note4 - 2; Int NoteE = Note4 - 2; Int NoteJ = Note4 - 3;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=4;#Ch={ 7       };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Dm7 VIIdim(b,d,f,g+,b) */
Function Dm7(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Dm7>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5g+);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 2;
	Int Note7 = Note2 + 1; Int NoteC = Note2 + 2; Int NoteH = Note2 + 2;
	Int Note8 = Note3 + 2; Int NoteD = Note3 + 3; Int NoteI = Note3 + 2;
	Int Note9 = Note4 + 2; Int NoteE = Note4 + 2; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=9;#Ch={ dim     };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}

/* Dm8 VIIdim(b,d,f,a,b) */
Function Dm8(Len,Inv,Bass,SecD_SW,SecD_Len,TwoF_SW,TwoF_Len){
	#Nm={<Dm8>}
	Minor_Sw = 1;
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o5b);
	Invert()
	/*  SecD                   TwoF               RepD                */
	Int Note5 = Note0 + 7; Int NoteA = Note0 + 2; Int NoteF = Note0 + 1;
	Int Note6 = Note1 + 2; Int NoteB = Note1 + 2; Int NoteG = Note1 + 2;
	Int Note7 = Note2 + 1; Int NoteC = Note2 + 2; Int NoteH = Note2 + 2;
	Int Note8 = Note3 + 1; Int NoteD = Note3 + 2; Int NoteI = Note3 + 1;
	Int Note9 = Note4 + 2; Int NoteE = Note4 + 2; Int NoteJ = Note4 + 1;
	If(Len==0){Len = MML(l)};			// もしレングスが省略されてたらＬ値から取得
	If(SecD_Len==0){SecD_Len = Len};
	If(TwoF_Len==0){TwoF_Len = Len};
	Ins_opt()
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
	If(Disp==1){Mode=10;#Ch={ m7(-5)  };#Op={};NumToNote(Note0,Note1,Note2,Note3,Note4);}
}


//Disp = 0;
//Open = 0;

//#KEY_C;
//v100 q99 r8 y0,0 r8 @50;
//EP(127);
//l1 T1; D1; S3; T5; Tm4; Dm1(,,,2,,1); Tm1;



