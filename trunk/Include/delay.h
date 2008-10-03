/*
=title       "delay.h" ver.1.00
=description  �G�t�F�N�^�[�Ȃǂ��g��Ȃ��ŁA�f�B���C���Č�����֐��Q(2000/07/08)
=keywords SAKURA Function
*/

/** �T�v
�f�B���C�Ƃ́A���������x��ĕ������Ă���A��܂т��̂悤�Ȍ��ʂ̂��Ƃł��B
���ʁA�f�B���C���g���ɂ́A�u�G�t�F�N�^�[�v���g���܂��B
�������A�����ɂ���ẮA�G�t�F�N�^�[�̂Ȃ����̂�����̂ŁA
�����ł́A�G�t�F�N�^�[���g��Ȃ��ŁA�l�h�c�h������g���āA�f�B���C���Č����܂��B

* �g����

Include(delay.h);

�̈ꕶ���A�ȓ��ɏ��������Ă��������B
*/

/**MidiDelayS(Str S)
���V���v���f�B���C
	S	�f�B���C���ʂ����������t���[�Y�������܂��B

	��j
	MidiDelayS( �h���~�t�@�\ );
*/
Function MidiDelayS(Str S){	// �V���v���ȃf�B���C
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
���ėp�I�ȃf�B���C�F���s�[�g�񐔂ƃ^�C�����w��ł���ėp�I�ȃf�B���C

	S	�f�B���C���ʂ����������t���[�Y
	Repeat	�J��Ԃ��񐔂��w��
	Delay	�x�点�鎞�Ԃ��w��
	
	��j
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
���L�[�f�B���C�F�f�B���C�̒x��ďo��m�[�g�̉������ς��s�v�c�ȃf�B���C

	S	�f�B���C���ʂ����������t���[�Y
	Repeat	�J��Ԃ��񐔂��w��
	Delay	�x�点�鎞�Ԃ��w��
	KeyPlus �����̕ω��ʂ��w��
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
���t��]�f�B���C�F�f�B���C���t���[�Y���O����n�܂�e�[�v�t��]�̂悤�ȃf�B���C

	S	�f�B���C���ʂ����������t���[�Y
	Repeat	�J��Ԃ��񐔂��w��
	Delay	�x�点�鎞�Ԃ��w��
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
���^�b�v�f�B���C�F�f�B���C�^�C�����Z���Ȃ��Ă����f�B���C

	S	�f�B���C���ʂ����������t���[�Y
	Repeat	�J��Ԃ��񐔂��w��
	Delay	�x�点�鎞�Ԃ��w��
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
���^�b�v�f�B���C�Q�F�f�B���C�^�C�����Z���Ȃ��Ă����f�B���C�A�Q�[�g���Z���Ȃ�

	S	�f�B���C���ʂ����������t���[�Y
	Repeat	�J��Ԃ��񐔂��w��
	Delay	�x�点�鎞�Ԃ��w��
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

