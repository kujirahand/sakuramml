/*
=title        "bend.h" ver.0.63
=description  �s�b�`�x���h�Ɋւ���֐� (2001/04/08)
=keywords     SAKURA Function
*/
//--------------------------------------------------------------------
/** �T�v

�s�b�`�x���h�́A�������ꎞ�I�ɕς�����A�A���I�ɕω������邱�ƂŁA
�M�^�[�̃`���[�L���O�Ȃǂ̉��t���Č����邱�Ƃ��ł��܂��B

�Ⴆ�΁A"A"�̉����𔭉�����Ƃ��A�s�b�`�x���h���g����"G"����"A"�ɃX���[�Y
�ɉ�����ω������邱�Ƃ��ł��܂��B

* �g����

Include(bend.h);

���A�ȓ��ɏ��������Ă��������B
*/

/** BendUp(Len, Delay)

���x���h�A�b�v�F������������Ȃ߂炩�ɏグ�āA�w��̉����ɂ���B

	Len	�w�肵�������ɂȂ�܂ł̒������X�e�b�v���w�肵�܂��B
	Delay	�x���h�A�b�v���J�n�����܂ł̒������X�e�b�v�w�肵�܂��B

	��jBendUp�i48,96)

	�p�����[�^�̐擪��"!"���L�q�����n�������w�肷�邱�Ƃ��ł��܂��B
	��jBendUp(!8,!4)
*/
Function BendUp(Len, Delay){
	Sub{
		p%-$2000; r*%(Delay);
		PitchBend.onTime(-$2000,0,Len);
	}
}


/**BendDown(Len, Delay)

���x���h�_�E���F�������ォ��Ȃ߂炩�ɉ����āA�w��̉����ɂ���B

	Len	�w�肵�������ɂȂ�܂ł̒������X�e�b�v���w�肵�܂��B
	Delay	�x���h�A�b�v���J�n�����܂ł̒������X�e�b�v�w�肵�܂��B

	��jBendUp�i48,96)

	�p�����[�^�̐擪��"!"���L�q�����n�������w�肷�邱�Ƃ��ł��܂��B
	��jBendUp(!8,!4)
*/
Function BendDown(Len, Delay){
	Sub{
		p%$1FFF;
		r*%(Delay);
		PitchBend.onTime($1FFF,0,Len);
	}
}


/**BendEx(Len, Delay, Str Note1, Str Note2)

���x���h�g���P�FNote1 ���� Note2 �����炩�ɂȂ��B

	Len	�w�肵�������ɂȂ�܂ł̒������X�e�b�v���w�肵�܂��B
	Delay	�x���h�A�b�v���J�n�����܂ł̒������X�e�b�v�w�肵�܂��B
	Str Note1	�J�n���鉹��
	Str Note2	�I�����鉹��

	�p�����[�^�̐擪��"!"���L�q�����n�������w�肷�邱�Ƃ��ł��܂��B
�@�@�@�@�x���h�݂̂��������ނ̂ŁA Note2 �́A���̊֐��̌�ɏ����Ă��������B
	��jBendEx(!4,!4,{o4c},{o5c}) o5c1
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

�������_���x���h�F�������ƂɃ����_���ȃx���h�l���������ށB

	ON_OR_OFF	on�Ń����_�����J�n�Aoff�Œ�~���܂��B
	Value		�x���h�̍ő�l���w�肵�܂��B�ȗ���

	��jRandomBend(on,2000)
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
			Print({"RandomBend�̈����ɂ́A(on)��(off)���w�肵�Ă��������B"});
		}
	}
}
