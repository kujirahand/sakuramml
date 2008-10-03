/*
=title "fadeio.h" ver.1.00
=description �t�F�[�h�C���E�t�F�[�h�A�E�g���`�����֐�(1999/12/17)
=keywords SAKURA Function fadein fadeout
*/

/** �T�v
�t�F�[�h�C���E�t�F�[�h�A�E�g���`�����t�@�C���ł��B
�t�F�[�h�C���́A���ʂ�����ɑ傫���Ȃ���ʂ̂��Ƃł��B
�t�F�[�h�A�E�g�́A���ʂ�����ɏ������Ȃ���ʂ̂��Ƃł��B

* �g����
	Include(fadeio.h);
	�̈ꕶ���A�ȓ��ɏ��������Ă��������B
*/

/** Fadein(Mes)
���t�F�[�h�C���F���ʂ�����ɑ傫���Ȃ����
	Mes	���ߐ����w��B
*/
Function Fadein(Mes){
	Str I = {!1};
	If(Mes>1){
		Mes--;[(Mes) I=I+{^1} ]
	}
	Str CMD = { Expression.onTime(0,127,LEN); }
	CMD.s({LEN},I);
	CMD;
}

/** Fadeout(Mes)
���t�F�[�h�A�E�g�F���ʂ�����ɏ������Ȃ����
	Mes	���ߐ����w��B
*/
Function Fadeout(Mes){
	Str I = {!1};
	If(Mes>1){
		Mes--;[(Mes) I=I+{^1} ]
	}
	Str CMD = { Expression.onTime(127,0,LEN); }
	CMD.s({LEN},I);
	CMD;
}

/** Cresc(FROM, TO, LEN)
���N���b�V�F���h�A�f�N���b�V�F���h
	FROM ... �J�n����(�G�N�X�v���b�V����)
	TO   ... �I������
	LEN  ... ���̒���(n �������w�肷��ꍇ�́A!4 �̂悤�Ɏw�肷��)
*/
/*
Function Cresc(FROM, TO, LEN){
�@�@Expression.onTime(FROM,TO,LEN);
}
*/

/** FadeoutSlowly
���t�F�[�h�A�E�g�X���[���[�F���ʂƃe���|������ɏ������Ȃ����
	Mes	���ߐ����w��B
*/
Function FadeoutSlowly(Mes){
	Fadeout(Mes);
	Int TT = Tempo;
	Int T = Tempo / Mes ;
	T = T / 8;
	For(Int I=1; I <= Mes; I++){
		Sub{ [4
			TT = TT - T;
			Tempo = TT; r4
		]}
	}
}

/** AllTrack(Str CMD)
�I�[���g���b�N�F�S�Ẵ`�����l���ɓ����l�l�k���������݂܂��B
��������܂��ƑS�Ẵg���b�N�Ƀt�F�[�h�C���E�A�E�g��������܂�
	��jAllTrack(Fadein(4))
*/
Function AllTrack(Str CMD){
	Int T = Time;
	For(Int I=1; I<=16; I++){
		Track(I); Channel(I);
		Time(T);
		CMD;
	}
}

/** FadeinAll(Mes)
���t�F�[�h�C���I�[���F�S�Ẵg���b�N���t�F�[�h�C�������܂��B
	Mes	���ߐ����w��
*/
Function FadeinAll(Mes){
	AllTrack({Fadein(Mes)});
}

/** FadeoutAll(Mes)
���t�F�[�h�A�E�g�I�[���F�S�Ẵg���b�N���t�F�[�h�A�E�g�����܂��B
	Mes	���ߐ����w��
*/
Function FadeoutAll(Mes){
	AllTrack({Fadeout(Mes)});
}

/** FadeoutSlowlyAll(Mes)
���t�F�[�h�A�E�g�X���[���[�I�[���F�S�Ẵg���b�N���t�F�[�h�A�E�g�I�[�������܂��B
	Mes	���ߐ����w��
*/
Function FadeoutSlowlyAll(Mes){
	FadeoutAll(Mes);
	Int TT = Tempo;
	Int T = Tempo / Mes ;
	T = T / 8;
	For(Int I=1; I <= Mes; I++){
		Sub{ [4
			TT = TT - T;
			Tempo = TT; r4
		]}
	}
}
