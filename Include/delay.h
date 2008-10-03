/*
=title       "delay.h" ver.1.00
=description  エフェクターなどを使わないで、ディレイを再現する関数群(2000/07/08)
=keywords SAKURA Function
*/

/** 概要
ディレイとは、音が少し遅れて聞こえてくる、やまびこのような効果のことです。
普通、ディレイを使うには、「エフェクター」を使います。
しかし、音源によっては、エフェクターのないものもあるので、
ここでは、エフェクターを使わないで、ＭＩＤＩ情報を駆使して、ディレイを再現します。

* 使い方

Include(delay.h);

の一文を、曲頭に書き加えてください。
*/

/**MidiDelayS(Str S)
◇シンプルディレイ
	S	ディレイ効果をかけたいフレーズを書きます。

	例）
	MidiDelayS( ドレミファソ );
*/
Function MidiDelayS(Str S){	// シンプルなディレイ
	Int Temp_v = MML(v);
	Int Dly = !8
	Int Dec_v = Temp_v / 8;
	Int J = Temp_v;
	J = J - (Dec_v * 2);
	v(J);
	For(Int I=1;I<=2;I++){
		Sub{ r%(Dly) v(J) S  }
		Dly=Dly*2;
		J=J-Dec_v;
	}
	v(Temp_v) S 
}


/** MidiDelay(Str S, Int Repeat, Int Delay)
◇汎用的なディレイ：リピート回数とタイムを指定できる汎用的なディレイ

	S	ディレイ効果をかけたいフレーズ
	Repeat	繰り返し回数を指定
	Delay	遅らせる時間を指定
	
	例）
	MidiDelay({v100o5l4cegedfaf},2,!8);
*/
Function MidiDelay(Str S,Int Repeat, Int Delay){
	Int Temp_v = MML(v);
	Int Dly = Delay;
	Int Dec_v = Temp_v / (Repeat+2);
	Int J = Temp_v;
	J = J - (Dec_v * 2);
	v(J);
	For(Int I=1;I<=Repeat;I++){
		Sub{ r%(Dly) v(J) S }
		Dly=Dly+Delay;
		J=J - Dec_v;
	}
	v(Temp_v) S 
}

/** MidiDelayKey(Str S,Int Repeat, Int Delay, Int KeyPlus)
◇キーディレイ：ディレイの遅れて出るノートの音程が変わる不思議なディレイ

	S	ディレイ効果をかけたいフレーズ
	Repeat	繰り返し回数を指定
	Delay	遅らせる時間を指定
	KeyPlus 音程の変化量を指定
*/
Function MidiDelayKey(Str S,Int Repeat, Int Delay, Int KeyPlus){
	Int Temp_v = MML(v);
	Int Dly = Delay;
	Int Dec_v = Temp_v / (Repeat+2);
	Int J = Temp_v;
	Int K = 0;
	J = J - (Dec_v * 2);
	v(J);
	For(Int I=1;I<=Repeat;I++){
		K=K + KeyPlus;
		Sub{
			Key(K)	
			r%(Dly) v(J) S 
		}
		Dly=Dly+Delay;
		J=J - Dec_v;
	}
	v(Temp_v) Key(0) S 
}


/**MidiDelayRev(Str S, Int Repeat, Int Delay)
◇逆回転ディレイ：ディレイがフレーズより前から始まるテープ逆回転のようなディレイ

	S	ディレイ効果をかけたいフレーズ
	Repeat	繰り返し回数を指定
	Delay	遅らせる時間を指定
*/
Function MidiDelayRev(Str S, Int Repeat, Int Delay){
	Int Temp_v = MML(v);
	Int Dly = Delay;
	Int Dec_v = Temp_v / (Repeat+2);
	Int J = Temp_v;
	J = J - (Dec_v * 2);
	v(J);
	For(Int I=1;I<=Repeat;I++){
		Dly=Dly-Delay;
		Sub{
			r%(Dly) v(J) S 
		}
		J=J - Dec_v;
	}
	v(Temp_v) Key(0) S 
}


/**MidiDelayTap(Str S, Int Repeat, Int Delay)
◇タップディレイ：ディレイタイムが短くなっていくディレイ

	S	ディレイ効果をかけたいフレーズ
	Repeat	繰り返し回数を指定
	Delay	遅らせる時間を指定
*/
Function MidiDelayTap(Str S, Int Repeat, Int Delay){
	Int Temp_v = MML(v);
	Int Dly = Delay;
	Int Dec_v = Temp_v / (Repeat+2);
	Int J = Temp_v;
	J = J - (Dec_v * 2);
	v(J);
	For(Int I=1;I<=Repeat;I++){
		Dly=Dly+Delay;
		Delay = Delay /2;
		Sub{
			r%(Dly) v(J) S 
		}
		J=J - Dec_v;
	}
	v(Temp_v) Key(0) S 
}

/** MidiDelayTap2(Str S, Int Repeat, Int Delay)
◇タップディレイ２：ディレイタイムが短くなっていくディレイ、ゲートが短くなる

	S	ディレイ効果をかけたいフレーズ
	Repeat	繰り返し回数を指定
	Delay	遅らせる時間を指定
*/
Function MidiDelayTap2(Str S, Int Repeat, Int Delay){
	Int Temp_v = MML(v);
	Int Temp_q = MML(q);
	Int Dly = Delay;
	Int Dec_v = Temp_v / (Repeat+2);
	Int J = Temp_v;
	J = J - (Dec_v * 2);
	v(J); q%1;
	For(Int I=1;I<=Repeat;I++){
		
		Dly=Dly+Delay;
		Delay = Delay /2;
		Sub{
			r%(Dly) v(J) S 
		}
		J=J - Dec_v;
	}
	v(Temp_v) q(Temp_q) Key(0) S 
}

