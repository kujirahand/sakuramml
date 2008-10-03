/*
=title        "unison.h" ver.0.70
=description  フレーズをユニゾンで鳴らす関数(1999/12/17)
=keywords     SAKURA Function unison
*/

/** 概要
■＋フレーズをユニゾンで鳴らす関数（概要）

フレーズを部分的に３度上でハモらせたり、
１オクターブ下の音を足して、音に厚みを出させたりします。
*/

/** OctaveUnison(Str S)
■｜－オクターブユニゾン：１オクターブ上の音を足します。
	S	元になるフレーズを指定
*/
Function OctaveUnison(Str S){
	Sub{ Key=12;  S; Key=0; } S;
}

/** Unison5th(Str S)
■｜－５ｔｈユニゾン：５度上の音を足します。
	S	元になるフレーズを指定
*/
Function Unison5th(Str S){
	Sub{ Key=7; S ;Key=0; } S;
}

/** Unison3th(Str S)
■｜－３ｔｈユニゾン：３度上の音を足します。
	S	元になるフレーズを指定
*/
Function Unison3th(Str S){
	Sub{ Key=4; S ;Key=0; } S;
}


/** Unison(Str S, Int Value)
■｜－汎用ユニゾン：フレーズに任意の音を足します。
	S	元になるフレーズを指定
	Value	足したい音を半音単位で指定

	例）// ５度上の音(=7半音上)をユニゾンします。
	Unison({cdefg}, 7);
*/
Function Unison(Str S, Int Value){
	Sub{ Key(Value); S; Key(0); } S;
}
