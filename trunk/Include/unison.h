/*
=title        "unison.h" ver.0.70
=description  �t���[�Y�����j�]���Ŗ炷�֐�(1999/12/17)
=keywords     SAKURA Function unison
*/

/** �T�v
���{�t���[�Y�����j�]���Ŗ炷�֐��i�T�v�j

�t���[�Y�𕔕��I�ɂR�x��Ńn���点����A
�P�I�N�^�[�u���̉��𑫂��āA���Ɍ��݂��o�������肵�܂��B
*/

/** OctaveUnison(Str S)
���b�|�I�N�^�[�u���j�]���F�P�I�N�^�[�u��̉��𑫂��܂��B
	S	���ɂȂ�t���[�Y���w��
*/
Function OctaveUnison(Str S){
	Sub{ Key=12;  S; Key=0; } S;
}

/** Unison5th(Str S)
���b�|�T�������j�]���F�T�x��̉��𑫂��܂��B
	S	���ɂȂ�t���[�Y���w��
*/
Function Unison5th(Str S){
	Sub{ Key=7; S ;Key=0; } S;
}

/** Unison3th(Str S)
���b�|�R�������j�]���F�R�x��̉��𑫂��܂��B
	S	���ɂȂ�t���[�Y���w��
*/
Function Unison3th(Str S){
	Sub{ Key=4; S ;Key=0; } S;
}


/** Unison(Str S, Int Value)
���b�|�ėp���j�]���F�t���[�Y�ɔC�ӂ̉��𑫂��܂��B
	S	���ɂȂ�t���[�Y���w��
	Value	�����������𔼉��P�ʂŎw��

	��j// �T�x��̉�(=7������)�����j�]�����܂��B
	Unison({cdefg}, 7);
*/
Function Unison(Str S, Int Value){
	Sub{ Key(Value); S; Key(0); } S;
}
