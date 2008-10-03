/*
=title        "bend2.h" 4neria�� ver��1.0
=description  �s�b�`�x���h�Ɋւ���֐� (2003/03/09)
=keywords     SAKURA Function
*/
//--------------------------------------------------------------------

/**BendTo(Len, Delay, Str Note1, Str Note2)
	���x���h�g���Q�F
		Note1 ���� Note2 �����炩�ɂȂ��B
		bend.h �� BendEx�֐��Ƃ̈Ⴂ�́ABendTo�֐������s���ꂽ���_�̃s�b�`
		�x���h�l��ǂݏo���A���̒l����s�b�`�x���h��ϓ������邱�Ƃ��ł���
		���B
		��Ȏg�����Ƃ��ẮASlur�R�}���h���g�p���Ĉى�����\�����Ă���Œ�
		�ł�BendEx�����̊֐����g�����Ƃ��\�ɂȂ�܂��B

			Len		�w�肵�������ɂȂ�܂ł̒������X�e�b�v���w�肵�܂��B
			Delay	�x���h�A�b�v���J�n�����܂ł̒������X�e�b�v�w�肵�܂��B
			Str		Note1	�J�n���鉹��
			Str		Note2	�I�����鉹��

		�p�����[�^�̐擪��"!"���L�q�����n�������w�肷�邱�Ƃ��ł��܂��B
		�x���h�݂̂��������ނ̂ŁA Note2 �́A���̊֐��̌�ɏ����Ă��������B

			��) BendTo(!4,!4,{o4c},{o5c}) o5c1
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
		MsgBox({"Note1��Note2�̉����̍����x���h�����W�𒴂��Ă��܂�."}); // ���������x���h�����W�𒴂����ꍇ�����I��
	} ELSE {
		Int _Pc = 8192 / _BR; // �x���h�����W��_BR�Ƃ����ꍇ��1������\������x���h�l
		Int _Pz = _Pa + (_Sa * _Pc); // �x���h�l�̍ŏI�l
		IF (_Pz>$1FFF) { // �x���h����̃`�F�b�N�A8191�𒴂����ꍇ�͋����I��
			MsgBox({"�s�b�`�x���h�l��8191�𒴂��܂���.�x���h�����W��傫���l�ɂ��Ă�������."});
		} ELSE {
			IF (_Pz<-$2000) { // �x���h�����̃`�F�b�N�A-8192�𒴂����ꍇ�͋����I��
				MsgBox({"�s�b�`�x���h�l��-8192�𒴂��܂���.�x���h�����W��傫���l�ɂ��Ă�������."});
			} ELSE {
				Sub{ r*%(Delay); PitchBend.onTime(_Pa,_Pz,Len); }
			}
		}
	}
}
