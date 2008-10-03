/*
=title        "bend2.h" 4neria版 verβ1.0
=description  ピッチベンドに関する関数 (2003/03/09)
=keywords     SAKURA Function
*/
//--------------------------------------------------------------------

/**BendTo(Len, Delay, Str Note1, Str Note2)
	◇ベンド拡張２：
		Note1 から Note2 を滑らかにつなぐ。
		bend.h の BendEx関数との違いは、BendTo関数が実行された時点のピッチ
		ベンド値を読み出し、その値からピッチベンドを変動させることができま
		す。
		主な使い道としては、Slurコマンドを使用して異音程を表現している最中
		でもBendEx相当の関数を使うことが可能になります。

			Len		指定した音程になるまでの長さをステップを指定します。
			Delay	ベンドアップが開始されるまでの長さをステップ指定します。
			Str		Note1	開始する音程
			Str		Note2	終了する音程

		パラメータの先頭に"!"を記述するとn分音符指定することができます。
		ベンドのみを書き込むので、 Note2 は、この関数の後に書いてください。

			例) BendTo(!4,!4,{o4c},{o5c}) o5c1
*/
Function BendTo(Len, Delay, Str Note1, Str Note2){
	Int _Pa = MML(p%);
	Int _BR = MML(BR);
	Int _N1 = NoteNo(Note1);
	Int _N2 = NoteNo(Note2);
	Int _Sa = _N2 - _N1;
	Int _Va = _Sa;
	IF (_Va<0) { _Va = -_Va };

	IF (_BR<_Va) {
		MsgBox({"Note1とNote2の音程の差がベンドレンジを超えています."}); // 音程差がベンドレンジを超えた場合強制終了
	} ELSE {
		Int _Pc = 8192 / _BR; // ベンドレンジを_BRとした場合の1音差を表現するベンド値
		Int _Pz = _Pa + (_Sa * _Pc); // ベンド値の最終値
		IF (_Pz>$1FFF) { // ベンド上限のチェック、8191を超えた場合は強制終了
			MsgBox({"ピッチベンド値が8191を超えました.ベンドレンジを大きい値にしてください."});
		} ELSE {
			IF (_Pz<-$2000) { // ベンド下限のチェック、-8192を超えた場合は強制終了
				MsgBox({"ピッチベンド値が-8192を超えました.ベンドレンジを大きい値にしてください."});
			} ELSE {
				Sub{ r*%(Delay); PitchBend.onTime(_Pa,_Pz,Len); }
			}
		}
	}
}
