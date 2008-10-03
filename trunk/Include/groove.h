/*
=title        "groove.h" ver.0.13
=description  �^�C�~���O�����炵����O���[�u����֐�(1999/12/27) �N�W����s��
=keywords     SAKURA Function Timing
*/

/** �T�v
�t���[�Y���X�B���O��������A��^�C�~���O�����炵���肵�܂��B 

* �g����
	Include(groove.h);
	�̈ꕶ���A�ȓ��ɏ��������Ă��������B
*/


/** ResetTiming()
���^�C�~���O���Z�b�g
*/
Function ResetTiming(){
	t__0 = 0;  t__5 = 0;
	t__1 = 0;  t__6 = 0;
	t__2 = 0;  t__7 = 0;
	t__3 = 0;  t__8 = 0;
	t__4 = 0;  t__9 = 0;
}


/** RndTiming(Val)
���^�C�~���O�������_���Ƀo����
	Val	�^�C�~���O���΂炷�l�A�X�e�b�v�l�Ŏw��B
*/
Function RndTiming(Val){
	t.Random(Val);
}


/** Swing16(Val)
��16beat Swing
	Val	�X�B���O����l�A�X�e�b�v�l�Ŏw��B
*/
Function Swing16(Val){
	t__9.onCycle(!16,0,Val);
}

/** Swing8(Val)
��8beat Swing
	Val	�X�B���O����l�A�X�e�b�v�l�Ŏw��B
*/
Function Swing8(Val){
	t__8.onCycle(!8,0,Val);
}


/** TimingForward(Val)
���S�̓I�ɑO�m���ȃ��Y��
	Val	�O�m���ɂ���l�B
*/
Function TimingForward(Val){
	Val = Val * -1;
	t__7.onTime(Val,0,!1);
}

/** TimingBack(Val)
���S�̓I�Ɍ�m���ȃ��Y��
	Val	��m���ɂ���l�B
*/
Function TimingBack(Val){
	t__7.onTime(0,Val,!1);
}

