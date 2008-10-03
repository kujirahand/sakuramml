/*
=title        "bend.h" ver.0.63
=description  ピッチベンドに関する関数 (2001/04/08)
=keywords     SAKURA Function
*/
//--------------------------------------------------------------------
/** 概要

ピッチベンドは、音程を一時的に変えたり、連続的に変化させることで、
ギターのチョーキングなどの演奏を再現することができます。

例えば、"A"の音程を発音するとき、ピッチベンドを使って"G"から"A"にスムーズ
に音程を変化させることができます。

* 使い方

Include(bend.h);

を、曲頭に書き加えてください。
*/

/** BendUp(Len, Delay)

◇ベンドアップ：音程を下からなめらかに上げて、指定の音程にする。

	Len	指定した音程になるまでの長さをステップを指定します。
	Delay	ベンドアップが開始されるまでの長さをステップ指定します。

	例）BendUp（48,96)

	パラメータの先頭に"!"を記述するとn分音符指定することができます。
	例）BendUp(!8,!4)
*/
Function BendUp(Len, Delay){
	Sub{
		p%-$2000; r*%(Delay);
		PitchBend.onTime(-$2000,0,Len);
	}
}


/**BendDown(Len, Delay)

◇ベンドダウン：音程を上からなめらかに下げて、指定の音程にする。

	Len	指定した音程になるまでの長さをステップを指定します。
	Delay	ベンドアップが開始されるまでの長さをステップ指定します。

	例）BendUp（48,96)

	パラメータの先頭に"!"を記述するとn分音符指定することができます。
	例）BendUp(!8,!4)
*/
Function BendDown(Len, Delay){
	Sub{
		p%$1FFF;
		r*%(Delay);
		PitchBend.onTime($1FFF,0,Len);
	}
}


/**BendEx(Len, Delay, Str Note1, Str Note2)

◇ベンド拡張１：Note1 から Note2 を滑らかにつなぐ。

	Len	指定した音程になるまでの長さをステップを指定します。
	Delay	ベンドアップが開始されるまでの長さをステップ指定します。
	Str Note1	開始する音程
	Str Note2	終了する音程

	パラメータの先頭に"!"を記述するとn分音符指定することができます。
　　　　ベンドのみを書き込むので、 Note2 は、この関数の後に書いてください。
	例）BendEx(!4,!4,{o4c},{o5c}) o5c1
*/
Function BendEx(Len, Delay, Str Note1, Str Note2){
	Int N1 = NoteNo(Note1);
	Int N2 = NoteNo(Note2);
	Int Sa = N2 - N1;
	Int Va = Sa;
	IF(Va<0){ Va = -Va };
	BR(Va);
	IF ( Sa > 0 ) {
		BendUp(Len,Delay);
	}ELSE{
		BendDown(Len,Delay);
	}
}



/**RandomBend(ON_OR_OFF,Value)

◇ランダムベンド：発音ごとにランダムなベンド値を書き込む。

	ON_OR_OFF	onでランダムを開始、offで停止します。
	Value		ベンドの最大値を指定します。省略可

	例）RandomBend(on,2000)
*/
Function RandomBend(ON_OR_OFF,Value){
	IF(Value == 0){ Value = $2000 }
	IF(ON_OR_OFF==(on)){
		PitchBend.Random(Value);
		PitchBend.onNote(0);
	}ELSE{
		IF(ON_OR_OFF==(off)){
			PitchBend = 0;
		}ELSE{
			Print({"RandomBendの引数には、(on)か(off)を指定してください。"});
		}
	}
}
