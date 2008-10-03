/*
=title "fadeio.h" ver.1.00
=description フェードイン・フェードアウトを定義した関数(1999/12/17)
=keywords SAKURA Function fadein fadeout
*/

/** 概要
フェードイン・フェードアウトを定義したファイルです。
フェードインは、音量が次第に大きくなる効果のことです。
フェードアウトは、音量が次第に小さくなる効果のことです。

* 使い方
	Include(fadeio.h);
	の一文を、曲頭に書き加えてください。
*/

/** Fadein(Mes)
◇フェードイン：音量が次第に大きくなる効果
	Mes	小節数を指定。
*/
Function Fadein(Mes){
	Str I = {!1};
	If(Mes>1){
		Mes--;[(Mes) I=I+{^1} ]
	}
	Str CMD = { Expression.onTime(0,127,LEN); }
	CMD.s({LEN},I);
	CMD;
}

/** Fadeout(Mes)
◇フェードアウト：音量が次第に小さくなる効果
	Mes	小節数を指定。
*/
Function Fadeout(Mes){
	Str I = {!1};
	If(Mes>1){
		Mes--;[(Mes) I=I+{^1} ]
	}
	Str CMD = { Expression.onTime(127,0,LEN); }
	CMD.s({LEN},I);
	CMD;
}

/** Cresc(FROM, TO, LEN)
◇クレッシェンド、デクレッシェンド
	FROM ... 開始音量(エクスプレッション)
	TO   ... 終了音量
	LEN  ... 音の長さ(n 分音符指定する場合は、!4 のように指定する)
*/
/*
Function Cresc(FROM, TO, LEN){
　　Expression.onTime(FROM,TO,LEN);
}
*/

/** FadeoutSlowly
◇フェードアウトスローリー：音量とテンポが次第に小さくなる効果
	Mes	小節数を指定。
*/
Function FadeoutSlowly(Mes){
	Fadeout(Mes);
	Int TT = Tempo;
	Int T = Tempo / Mes ;
	T = T / 8;
	For(Int I=1; I <= Mes; I++){
		Sub{ [4
			TT = TT - T;
			Tempo = TT; r4
		]}
	}
}

/** AllTrack(Str CMD)
オールトラック：全てのチャンネルに同じＭＭＬを書き込みます。
これをかますと全てのトラックにフェードイン・アウトがかかります
	例）AllTrack(Fadein(4))
*/
Function AllTrack(Str CMD){
	Int T = Time;
	For(Int I=1; I<=16; I++){
		Track(I); Channel(I);
		Time(T);
		CMD;
	}
}

/** FadeinAll(Mes)
◇フェードインオール：全てのトラックをフェードインさせます。
	Mes	小節数を指定
*/
Function FadeinAll(Mes){
	AllTrack({Fadein(Mes)});
}

/** FadeoutAll(Mes)
◇フェードアウトオール：全てのトラックをフェードアウトさせます。
	Mes	小節数を指定
*/
Function FadeoutAll(Mes){
	AllTrack({Fadeout(Mes)});
}

/** FadeoutSlowlyAll(Mes)
◇フェードアウトスローリーオール：全てのトラックをフェードアウトオールさせます。
	Mes	小節数を指定
*/
Function FadeoutSlowlyAll(Mes){
	FadeoutAll(Mes);
	Int TT = Tempo;
	Int T = Tempo / Mes ;
	T = T / 8;
	For(Int I=1; I <= Mes; I++){
		Sub{ [4
			TT = TT - T;
			Tempo = TT; r4
		]}
	}
}
