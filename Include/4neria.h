// -----------------------------------------------------------------------------
// 汎用関数 "4neria.h" ver1.0 (2002/10/20)
//
//                                      programed by. 4neria (4neria@mcn.ne.jp)
// -----------------------------------------------------------------------------

// 汎用関数(変更禁止 ここから)--------------------------------------------------
Function NumberCheck(_N,_Min,_Max) { // _Nの値が_Min以上_Max以下であるかチェック
 If((_N<_Min)||(_N>_Max)) { MsgBox({"パラメータの値が不正です. パラメータの範囲は"}+_Min+{"～"}+_Max+{"までです."}); End; }
}
Function DataSizeCheck(_SizeA,_SizeB) { // _SizeAの値が_SizeBの値と同じであるかチェック
 If(_SizeA!=_SizeB) { MsgBox({"パラメータの数が不正です. パラメータの数は"}+_SizeB+{"個必要です."}); End; }
}
Function StrOrNum(Str _SON) { // Strが数値か文字列であるかをチェック (返り値:[0]数値、[1]文字列)
 // ACSII CODE [0]48 [9]57 [-]45
 Int _STmpA = ASC(MID(_SON,1,1););
 Int _STmpB = ASC(MID(_SON,2,1););

 If((_STmpA<48)||(_STmpA>57)) {
  Result = 1;
  If(_STmpA==45) { // 負の値チェック
   Result = 0;
   If((_STmpB<48)||(_STmpB>57)) { Result = 1; }
  }
 } Else {
  Result = 0;
 }
}

// 汎用関数(変更禁止 ここまで)--------------------------------------------------
//EOF