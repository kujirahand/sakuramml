// -----------------------------------------------------------------------------
// �ėp�֐� "4neria.h" ver1.0 (2002/10/20)
//
//                                      programed by. 4neria (4neria@mcn.ne.jp)
// -----------------------------------------------------------------------------

// �ėp�֐�(�ύX�֎~ ��������)--------------------------------------------------
Function NumberCheck(_N,_Min,_Max) { // _N�̒l��_Min�ȏ�_Max�ȉ��ł��邩�`�F�b�N
 If((_N<_Min)||(_N>_Max)) { MsgBox({"�p�����[�^�̒l���s���ł�. �p�����[�^�͈̔͂�"}+_Min+{"�`"}+_Max+{"�܂łł�."}); End; }
}
Function DataSizeCheck(_SizeA,_SizeB) { // _SizeA�̒l��_SizeB�̒l�Ɠ����ł��邩�`�F�b�N
 If(_SizeA!=_SizeB) { MsgBox({"�p�����[�^�̐����s���ł�. �p�����[�^�̐���"}+_SizeB+{"�K�v�ł�."}); End; }
}
Function StrOrNum(Str _SON) { // Str�����l��������ł��邩���`�F�b�N (�Ԃ�l:[0]���l�A[1]������)
 // ACSII CODE [0]48 [9]57 [-]45
 Int _STmpA = ASC(MID(_SON,1,1););
 Int _STmpB = ASC(MID(_SON,2,1););

 If((_STmpA<48)||(_STmpA>57)) {
  Result = 1;
  If(_STmpA==45) { // ���̒l�`�F�b�N
   Result = 0;
   If((_STmpB<48)||(_STmpB>57)) { Result = 1; }
  }
 } Else {
  Result = 0;
 }
}

// �ėp�֐�(�ύX�֎~ �����܂�)--------------------------------------------------
//EOF