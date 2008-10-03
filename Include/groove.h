/*
=title        "groove.h" ver.0.13
=description  タイミングをずらしたりグルーブ制御関数(1999/12/27) クジラ飛行机
=keywords     SAKURA Function Timing
*/

/** 概要
フレーズをスィングさせたり、やタイミングをずらしたりします。 

* 使い方
	Include(groove.h);
	の一文を、曲頭に書き加えてください。
*/


/** ResetTiming()
◇タイミングリセット
*/
Function ResetTiming(){
	t__0 = 0;  t__5 = 0;
	t__1 = 0;  t__6 = 0;
	t__2 = 0;  t__7 = 0;
	t__3 = 0;  t__8 = 0;
	t__4 = 0;  t__9 = 0;
}


/** RndTiming(Val)
◇タイミングをランダムにバラす
	Val	タイミングをばらす値、ステップ値で指定。
*/
Function RndTiming(Val){
	t.Random(Val);
}


/** Swing16(Val)
◇16beat Swing
	Val	スィングする値、ステップ値で指定。
*/
Function Swing16(Val){
	t__9.onCycle(!16,0,Val);
}

/** Swing8(Val)
◇8beat Swing
	Val	スィングする値、ステップ値で指定。
*/
Function Swing8(Val){
	t__8.onCycle(!8,0,Val);
}


/** TimingForward(Val)
◇全体的に前ノリなリズム
	Val	前ノリにする値。
*/
Function TimingForward(Val){
	Val = Val * -1;
	t__7.onTime(Val,0,!1);
}

/** TimingBack(Val)
◇全体的に後ノリなリズム
	Val	後ノリにする値。
*/
Function TimingBack(Val){
	t__7.onTime(0,Val,!1);
}

