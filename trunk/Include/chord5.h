//------------------------------------------------------------------------------ Header.
/*
�R�[�h�W�F�l���[�^�w�R�[�h�T�x
ver.1.07 LastUpdate = 2002/12/23�@�݂���

�w�e���|�����X�P�[���T�|�[�g�x
	���[�h�n
	�n�[���j�b�N�n
	�����f�B�b�N�n

	�e��X�P�[���͎g�p���A�S�g���b�N�ɑ΂���
	�L���ɂȂ�A�����g�p�����̂����O���[�o��
	�ϐ��֎c��܂��B

�w�f�B�O���[�l�[���T�|�[�g�x
	�g���C�A�h
	�r�����S
	�V����
	�X����

	�T,�U,�V,�W,�X,�Y,�Z���ꂼ��ɂR�a���A�S�a��
	�X�����A�T�X�y���h�S���p�ӂ���A�S�Ă̘a����
	�X�P�[���}�N���ɂ���ĕό`���܂��B

�w�C���o�[�g�T�|�[�g�x
	�g���C�A�h
	�V����
	�X����
	�I�[�v���{�C�V���O�i�{�C���^�[�o���X�v���b�_�j
	�N���[�Y�{�C�V���O

	�a���S�̂̍��������R�ɏ㉺�����鎖���\��
	�X�ɃI�[�v���E�N���[�Y�̑I���A�I�[�v���̏ꍇ
	�͊J������Q�i�K�Œ��߂ł��܂��B

�w�C���T�[�g�R�[�h�T�|�[�g�i�I�[�g�X�P�[���j�x
	�Z�J���_���h�~�i���g
	���R�[�h
	�p�b�V���O�f�B�~�j�b�V��
	�U�X�i�e�R�[�h�}�C�i�[���A�U�����V��T�j
	�U�X�i�X�����R�[�h�j
	�h�b�y���h�~�i���g
	�W���Y�X�^�C���̃h�~�i���g�e��

	�a���ɑ΂��A��O�̏��߂֗l�X�ȋ@�\�̃R�[�h��
	�}�����鎖���o���A����ɂ���Đ�����������
	�ω���ڒ��͎����őS�g���b�N�ɓK�p����܂��B

�w�t�F�C���g�T�|�[�g�x
	�C���T�[�g�R�[�h�g�p���A������Ăяo����
	�e�R�[�h���~���[�g����t�F�C���g���g�p�\
	�ł��B

�w�I�[���~���[�g�T�|�[�g�x
	�Ȃ������� chord5.h �ɂ��K�C�h����
	�K�v�Ȃ��Ȃ������A�X�P�[���̐ݒ肾����
	�c���ăK�C�h�����������鎖���o���܂��B

�w�s�r�c�w��T�|�[�g�x
	�s�i���W���[�n�g�j�b�N�j		�P�U��
	�r�i���W���[�n�T�u�h�~�i���g�j	�P�R��
	�c�i���W���[�n�h�~�i���g�j		�P�Q��
	�s���i�}�C�i�[�n�g�j�b�N�j		�P�Q��
	�r���i�}�C�i�[�n�T�u�h�~�i���g�j	�P�R��
	�c���i�}�C�i�[�n�h�~�i���g�j		�P�T��

	�R�[�h���@�\���Ŏw��\�B
	�f�B�O���[�l�[���w��ŃT�|�[�g����Ă���
	
	�E�C���o�[�g
	�E�C���T�[�g�i�I�[�g�X�P�[���j
	�E�t�F�C���g
	�E�I�[���~���[�g
	
	�����S�ĂɃA�N�Z�X�\�A�X�P�[����
	�����ݒ�ŁA�����̕ω����S�g���b�N��
	�K�p����܂��B

�w�I�[�g�g�����X�|�W�V�����T�|�[�g�x
	�T�x���ւ̈ڒ����u�ڒ����镝�i�L�[�V�t�g�l�j�v
	�ł͂Ȃ��u�]�����̋����v�Ƃ��Ďw�肷�鎖��
	�o���܂��B

	����ɂ��A�T�x���A�ߐe���A���咲�Ƃ���
	�T�O��m��Ȃ��Ă����m�ɓ]�����鎖���o���A
	�]����X���[�Y�Ɍ��̒��֖߂��ė��鎖��
	�\�ł��B


 (Tab = 6)
*/
//------------------------------------------------------------------------------
Int Open		= 0				// �I�[�v���{�C�V���O�t���O(1=open,2=more)
Int NowScale	= 0				// ���݂̃X�P�[��
Int ModeNo		= 0				// ���[�h�w��p�ϐ�
Int RootBass	= 0				// �x�[�X���K�C�h����(0=on)
Int Chord5_off	= 0				// �����t���O�i�I�t���A�X�P�[���̂ݓ���j
Int Feint		= 0				// �t�F�C���g�t���O
Int Relative	= 0				// �g�����X�p�ϐ�
Int Shift_val	= 0				// �g�����X�p�ϐ�
Int InsertMode	= 0				// �R���{�p�ϐ�
Int LenII		= 0				// �R���{�p����
Int InvII		= 0				// �R���{�p����
Int LenIII		= 0				// �R���{�p����
Int InvIII		= 0				// �R���{�p����
Int Disp		= 1				// �w���v�\���p�t���O
Int Top		= 0				// �g�b�v�m�[�g�p�ϐ�
//------------------------------------------------------------------------------ TransFunction.

Function Trans(Value){
	TimeKey2(,,Shift_val)						// ��U�L�[�����֖߂�
	Relative = Value * 5						// �������T�x���֕ϊ�
	Shift_val = Relative % 12					// �I�N�^�[�u�V�t�g�i�]�肪���ۂ�Key�l�j
	If( Shift_val> 6 ){ Shift_val = Shift_val - 12 }	// ����ɑ΂���␳
	If( Shift_val<-6 ){ Shift_val = Shift_val + 12 }	// �����ɑ΂���␳
	TimeKey2(,,Shift_val)						// �ړI�̃L�[�փV�t�g
//	Print (Shift_val)
	Shift_val = MML(TimeKey2) - Shift_val			// ���񌳂֖߂��ׂ̏����c��
}

//------------------------------------------------------------------------------ InvertFunction.

//=================================
//�@�g���C�A�h�C���o�[�g
//=================================
Function Invert3(){
	Int O_value = Inv / 3;			// �C���o�[�g�l�͂R�P�ʂŃI�N�^�[�u�A�b�v�Ȃ̂Łc
	Int O_shift = O_value * 12;		// �R�Ŋ������l���I�N�^�[�u�l�ɂȂ�
	Note1 = Note1 + O_shift;		// ���ꂼ��̃m�[�g���I�N�^�[�u����
	Note2 = Note2 + O_shift;
	Note3 = Note3 + O_shift;
	Int AAA = O_value * 3;			// �I�N�^�[�u�l�ɂR�������āc
	Inv = Inv - AAA				// �C���o�[�g�l��������Ɓu�]��v���o��
	/* �u�]��v�l�ɂ���ăC���o�[�g�i��]�j������ */
	If(Inv==-2){Note3 = Note3 - 12; Note2 = Note2 - 12}
	If(Inv==-1){Note3 = Note3 - 12}
	If(Inv==1){Note1 = Note1 + 12}
	If(Inv==2){Note1 = Note1 + 12; Note2 = Note2 + 12}
	/* �I�[�v���� */
	If(Open==1){
		Note3 = Note3 - 12;
	}
	If(Open==2){
		Note3 = Note3 - 12;
		Note2 = Note2 + 12;
	}
}

//=================================
//�@�V�����C���o�[�g
//=================================
Function Invert4(){
	Int O_value = Inv / 4;			// �C���o�[�g�l�͂S�P�ʂŃI�N�^�[�u�A�b�v�Ȃ̂Łc
	Int O_shift = O_value * 12;		// �S�Ŋ������l���I�N�^�[�u�l�ɂȂ�
	Note1 = Note1 + O_shift;		// ���ꂼ��̃m�[�g���I�N�^�[�u����
	Note2 = Note2 + O_shift;
	Note3 = Note3 + O_shift;
	Note4 = Note4 + O_shift;
	Int AAA = O_value * 4;			// �I�N�^�[�u�l�ɂS�������āc
	Inv = Inv - AAA				// �C���o�[�g�l��������Ɓu�]��v���o��
	/* �u�]��v�l�ɂ���ăC���o�[�g�i��]�j������ */
	If(Inv==-3){Note4 = Note4 - 12; Note3 = Note3 - 12; Note2 = Note2 - 12}
	If(Inv==-2){Note4 = Note4 - 12; Note3 = Note3 - 12}
	If(Inv==-1){Note4 = Note4 - 12}
	If(Inv==1){Note1 = Note1 + 12}
	If(Inv==2){Note1 = Note1 + 12; Note2 = Note2 + 12}
	If(Inv==3){Note1 = Note1 + 12; Note2 = Note2 + 12; Note3 = Note3 + 12}
	/* �I�[�v���� */
	If(Open==1){
		Note3 = Note3 - 12;
	}
	If(Open==2){
		Note3 = Note3 - 12;
		Note2 = Note2 + 12;
	}
}

//=================================
//�@�X�����C���o�[�g
//=================================
Function Invert5(){
	Int O_value = Inv / 4;			// �C���o�[�g�l�͂S�P�ʂŃI�N�^�[�u�A�b�v�Ȃ̂Łc
	Int O_shift = O_value * 12;		// �S�Ŋ������l���I�N�^�[�u�l�ɂȂ�
	Note1 = Note1 + O_shift;		// ���ꂼ��̃m�[�g���I�N�^�[�u����
	Note2 = Note2 + O_shift;
	Note3 = Note3 + O_shift;
	Note4 = Note4 + O_shift;
	Int AAA = O_value * 4;			// �I�N�^�[�u�l�ɂS�������āc
	Inv = Inv - AAA				// �C���o�[�g�l��������Ɓu�]��v���o��
	/* �u�]��v�l�ɂ���ăC���o�[�g�i��]�j������ */
	If(Inv==-3){Note4 = Note4 - 12; Note3 = Note3 - 12; Note2 = Note2 - 12}
	If(Inv==-2){Note4 = Note4 - 12; Note3 = Note3 - 12}
	If(Inv==-1){Note4 = Note4 - 12}
	If(Inv==1){Note1 = Note1 + 12}
	If(Inv==2){Note1 = Note1 + 12; Note2 = Note2 + 12}
	If(Inv==3){Note1 = Note1 + 12; Note2 = Note2 + 12; Note3 = Note3 + 12}
	/* �I�[�v���� */
	If(Open==1){
		Note3 = Note3 - 12;
	}
	If(Open==2){
		Note3 = Note3 - 12;
		Note2 = Note2 + 12;
	}
}
//------------------------------------------------------------------------------ KeyMacro.
/* chord3.h compatible */
#KEY_C	= {TimeKey(,,0)}
#KEY_Cp	= {TimeKey(,,1)}
#KEY_D	= {TimeKey(,,2)}
#KEY_Dp	= {TimeKey(,,3)}
#KEY_E	= {TimeKey(,,4)}
#KEY_F	= {TimeKey(,,5)}
#KEY_Fp	= {TimeKey(,,6)}
#KEY_G	= {TimeKey(,,-5)}
#KEY_Gp	= {TimeKey(,,-4)}
#KEY_A	= {TimeKey(,,-3)}
#KEY_Ap	= {TimeKey(,,-2)}
#KEY_B	= {TimeKey(,,-1)}
/* extension */
#KEY_Dm	= {TimeKey(,,1)}
#KEY_Em	= {TimeKey(,,3)}
#KEY_Gm	= {TimeKey(,,6)}
#KEY_Am	= {TimeKey(,,-4)}
#KEY_Bm	= {TimeKey(,,-2)}
//------------------------------------------------------------------------------ ModeMacro.
/* Major scale */
#Major = {
	TimeKeyFlag(,,0,0,0,0,0,0,0);			/* Major scale */
	NowScale = 0
}

/* Minor scale */
#Minor = {
	TimeKeyFlag(,,-1,-1,0,0,-1,0,0);		/* Minor scale */
	NowScale = 5
}

/* Mode */
#Mode = {
	ModeNo = #?1
	If(ModeNo==0){
	TimeKeyFlag(,,0,0,0,0,0,0,0);			/* Ionian */
	NowScale = 0
	}
	If(ModeNo==1){
	TimeKeyFlag(,,0,-1,0,0,-1,0,0);		/* Dorian */
	NowScale = 1
	}
	If(ModeNo==2){
	TimeKeyFlag(,,-1,-1,0,-1,-1,0,0);		/* Phrygian */
	NowScale = 2
	}
	If(ModeNo==3){
	TimeKeyFlag(,,0,0,0,0,0,1,0);			/* Lydian */
	NowScale = 3
	}
	If(ModeNo==4){
	TimeKeyFlag(,,0,-1,0,0,0,0,0);		/* Mixo-Lydian */
	NowScale = 4
	}
	If(ModeNo==5){
	TimeKeyFlag(,,-1,-1,0,0,-1,0,0);		/* Aeolian */
	NowScale = 5
	}
	If(ModeNo==6){
	TimeKeyFlag(,,-1,-1,0,-1,-1,0,-1);		/* Locrian */
	NowScale = 6
	}
	If(ModeNo==7){
	TimeKeyFlag(,,1,0,0,1,1,1,0);			/* Pentatonic minor blues */
	NowScale = 7
	}
}

/* Harmonic minor class */
#HMinor = {
	ModeNo = #?1
	If(ModeNo==0){
	TimeKeyFlag(,,-1,0, 0,0,-1,0,0);		/* Harmonic minor */
	NowScale = 10
	}
	If(ModeNo==1){
	TimeKeyFlag(,,0,-1,0,-1,-1,0,-1);		/* Locrian natural13 */
	NowScale = 11
	}
	If(ModeNo==2){
	TimeKeyFlag(,,0,0,0,0,0,0,1);			/* Ionian #5 */
	NowScale = 12
	}
	If(ModeNo==3){
	TimeKeyFlag(,,0,-1,0,0,-1,1,0);		/* Dorian #11 */
	NowScale = 13
	}
	If(ModeNo==4){
	TimeKeyFlag(,,-1,-1,0,-1,0,0,0);		/* Harmonic minor perfect 5th below */
	NowScale = 14
	}
	If(ModeNo==5){
	TimeKeyFlag(,,0,0,0,1,0,1,0);			/* Lydian #9 */
	NowScale = 15
	}
	If(ModeNo==6){
	TimeKeyFlag(,,-1,-2,0,-1,-1,-1,-1);		/* Altered -7 */
	NowScale = 16
	}
}

/* Melodic minor class */
#MMinor = {
	ModeNo = #?1
	If(ModeNo==0){
	TimeKeyFlag(,,0,0,0,0,-1,0,0);		/* Melodic minor */
	NowScale = 20
	}
	If(ModeNo==1){
	TimeKeyFlag(,,0,-1,0,-1,-1,0,0);		/* Dorian -9 */
	NowScale = 21
	}
	If(ModeNo==2){
	TimeKeyFlag(,,0,0,0,0,0,1,1);			/* Lydian #5 */
	NowScale = 22
	}
	If(ModeNo==3){
	TimeKeyFlag(,,0,-1,0,0,0,1,0);		/* Mixo-Lydian #11 (Lydian 7) */
	NowScale = 23
	}
	If(ModeNo==4){
	TimeKeyFlag(,,-1,-1,0,0,0,0,0);		/* Mixo-Lydian -13 */
	NowScale = 24
	}
	If(ModeNo==5){
	TimeKeyFlag(,,-1,-1,0,0,-1,0,-1);		/* Aeolian -5 (Super Locrian) */
	NowScale = 25
	}
	If(ModeNo==6){
	TimeKeyFlag(,,-1,-1,0,-1,-1,-1,-1);		/* Altered */
	NowScale = 26
	}
	If(ModeNo==7){
	TimeKeyFlag(,,-1,-1,-1,-1,-1,0,0);		/* G Altered */
	NowScale = 27
	}
}

/* Mode Undo */
#ModeUndo = {
	If(NowScale==0){ #Mode(0) }
	If(NowScale==1){ #Mode(1) }
	If(NowScale==2){ #Mode(2) }
	If(NowScale==3){ #Mode(3) }
	If(NowScale==4){ #Mode(4) }
	If(NowScale==5){ #Mode(5) }
	If(NowScale==6){ #Mode(6) }
	If(NowScale==7){ #Mode(7) }
	If(NowScale==10){ #HMinor(0) }
	If(NowScale==11){ #HMinor(1) }
	If(NowScale==12){ #HMinor(2) }
	If(NowScale==13){ #HMinor(3) }
	If(NowScale==14){ #HMinor(4) }
	If(NowScale==15){ #HMinor(5) }
	If(NowScale==16){ #HMinor(6) }
	If(NowScale==20){ #MMinor(0) }
	If(NowScale==21){ #MMinor(1) }
	If(NowScale==22){ #MMinor(2) }
	If(NowScale==23){ #MMinor(3) }
	If(NowScale==24){ #MMinor(4) }
	If(NowScale==25){ #MMinor(5) }
	If(NowScale==26){ #MMinor(6) }
	If(NowScale==27){ #MMinor(7) }
}

//------------------------------------------------------------------------------ MainFunction.

/* �U */
Function Two(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5d);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6c);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Chord5_off==0){
		If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		r%(Len);
	}
}

/* �X */
Function Domi(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Chord5_off==0){
		If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		r%(Len);
	}
}

/* dim */
Function Dimi(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Chord5_off==0){
		If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}Else{
		r%(Len)
	}
}



/* Secondry dominant insert */
Function SecD(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	/* ���R�[�h���}�C�i�[��������h�~�i���g�̓n�[���j�b�N */
	If(Which_is==4){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==3){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(Which_is==-8){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==-9){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���E�t�@�̘a���@Combo!!"} }
	Domi(LenII,InvII+DefInv+Inv)			// �h�~�i���g��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
}

/* Secondry dominant sub-chord insert */
Function SubD(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,-1,-1,-1,-1,-1,0,0)		// �I���^�[�h�E�p�[�t�F�N�g�Tth�r���E
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a���@Combo!!"} }
	Two(LenII,InvII+DefInv+Inv)			// ���h�~�i���g��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
}

/* Passing diminished insert */
Function P_Dim(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,-1,0,0,0,-1,0,0)		// �n�[���j�b�N�}�C�i�[
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X���V�@�@�V�E���E�t�@�E���̘a���@Combo!!"} }
	Dimi(LenII,InvII+DefInv+Inv)			// �p�b�V���O��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
}

/* �U�X insert */
Function SecD_2(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	/* ���R�[�h���}�C�i�[��������h�~�i���g�̓n�[���j�b�N */
	//Int Which_is = 4
	If(Which_is==4){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==3){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(Which_is==-8){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==-9){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a���@Combo!!"} }
	Two(LenII,InvII+DefInv+Inv)			// �U��}��
	If(LenIII==0){LenIII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���E�t�@�̘a���@Cool!!"} }
	Domi(LenIII,InvIII+DefInv+Inv)		// �h�~�i���g��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
	LenIII = 0
	InvIII = 0
}

/* �U + Secondry dominant sub-chord insert */
Function SubD_2(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,0,0,0,0,0,0,0)			// �A�C�I�j�A��
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a���@Combo!!"} }
	Two(LenII,InvII+DefInv+Inv)			// �U��}��
	TimeKeyFlag(,,-1,-1,-1,-1,-1,0,0)		// �X�I���^�[�h
	If(LenIII==0){LenIII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a���@Cool!!"} }
	Two(LenIII,InvIII+DefInv+Inv)			// ���h�~�i���g��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
	LenIII = 0
	InvIII = 0
}

/* Doppel insert */
Function DopD(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,0,0,0,0,0,1,0)			// ���f�B�A��
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a���@Combo!!"} }
	Two(LenII,InvII+DefInv+Inv)			// �U��}��
	If(LenIII==0){LenIII = MML(l)}
	/* ���R�[�h���}�C�i�[��������h�~�i���g�̓n�[���j�b�N */
	If(Which_is==4){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==3){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(Which_is==-8){TimeKeyFlag(,,0,0,0,0,0,0,0)}
	If(Which_is==-9){TimeKeyFlag(,,-1,0,0,0,-1,0,0)}
	If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���E�t�@�̘a���@Cool!!"} }
	Domi(LenIII,InvIII+DefInv+Inv)		// �h�~�i���g��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
	LenIII = 0
	InvIII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD1(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,0,0,1,0,0,0,0)			// �X7���f�B�A���V����
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���E�t�@�̘a���@Jazzy!!"} }
	Domi(LenII,InvII+DefInv+Inv)			// �h�~�i���g��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD2(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,-1,-1,-1,-1,-1,0,0)		// �Xm7��5�I���^�[�h
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���E�t�@�̘a���@Jazzy!!"} }
	Domi(LenII,InvII+DefInv+Inv)			// �h�~�i���g��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD3(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,0,-1,0,-1,-1,0,0)		// �Xm7��5�X�[�p�[���N���A���i���h���A����X�j
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���E�t�@�̘a���@Jazzy!!"} }
	Domi(LenII,InvII+DefInv+Inv)			// �h�~�i���g��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD4(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,0,0,1,0,0,0,0)			// �X7���f�B�A���V����
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a���@Jazzy!!"} }
	Two(LenII,InvII+DefInv+Inv)			// �UmM7��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
}

/* Secondry dominant insert (For jazz) */
Function JazzD5(){
	Int KSValue = Note0 - NoteNo(o4c);		// �h�ƃ��[�g�̃C���^�[�o���𒲂ׂ�
	If(KSValue<-4){KSValue=KSValue+12}		// �x�[�X����߂�����I�N�^�[�u�A�b�v
	Int NowKey = MML(TimeKey);			// �L�[�V�t�g�l�𒲂ׂ�
	Int KSTrue = KSValue + NowKey			// �Z�J���_���̃X�P�[���J�n�n�_���o��
	TimeKey(,,KSTrue);				// �Z�J���_���̃��[�g�ֈڒ�
	TimeKeyFlag(,,0,-1,0,-1,-1,0,0)		// �Xm7��5�X�[�p�[���N���A���i���h���A����X�j
	If(LenII==0){LenII = MML(l)}
	If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a���@Jazzy!!"} }
	Two(LenII,InvII+DefInv+Inv)			// �UaugM7��}��
	TimeKey(,,NowKey)					// �������֖߂�
	#ModeUndo						// �X�P�[�������֖߂�
	LenII = 0
	InvII = 0
}



/* C_ */
Function C_(Len,Inv){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o4e) - NoteNo(o4c)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���h�@�@�h�E�~�E�\�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���h�@�@�h�E�~�E�\�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* D_ */
Function D_(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o4f) - NoteNo(o4d)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* E_ */
Function E_(Len,Inv){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Which_is = NoteNo(o4g) - NoteNo(o4e)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���~�@�@�~�E�\�E�V�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���~�@�@�~�E�\�E�V�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* F_ */
Function F_(Len,Inv){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o4a) - NoteNo(o4f)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���t�@�@�t�@�E���E�h�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���t�@�@�t�@�E���E�h�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* G_ */
Function G_(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5b);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o4b) - NoteNo(o4g)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* A_ */
Function A_(Len,Inv){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o5c) - NoteNo(o4a)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X�����@�@���E�h�E�~�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X�����@�@���E�h�E�~�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* B_ */
Function B_(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5b);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o5d) - NoteNo(o4b)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���V�@�@�V�E���E�t�@�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���V�@�@�V�E���E�t�@�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* Csus4 */
Function C_4(Len,Inv){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o4e) - NoteNo(o4c)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���h�@�@�h�E�t�@�E�\�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���h�@�@�h�E�t�@�E�\�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* Dsus4 */
Function D_4(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o4f) - NoteNo(o4d)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X�����@�@���E�\�E���̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X�����@�@���E�\�E���̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* Esus4 */
Function E_4(Len,Inv){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Which_is = NoteNo(o4g) - NoteNo(o4e)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���~�@�@�~�E���E�V�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���~�@�@�~�E���E�V�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* Fsus4 */
Function F_4(Len,Inv){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5b);
	Int Note3 = NoteNo(o6c);
	Int Which_is = NoteNo(o4a) - NoteNo(o4f)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���t�@�@�t�@�E�V�E�h�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���t�@�@�t�@�E�V�E�h�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* Gsus4 */
Function G_4(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o6c);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o4b) - NoteNo(o4g)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�h�E���̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�h�E���̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* Asus4 */
Function A_4(Len,Inv){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6d);
	Int Which_is = NoteNo(o5c) - NoteNo(o4a)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X�����@�@���E���E�~�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X�����@�@���E���E�~�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* Bsus4 */
Function B_4(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5b);
	Int Which_is = NoteNo(o5d) - NoteNo(o4b)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert3()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���V�@�@�V�E�~�E�t�@�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���V�@�@�V�E�~�E�t�@�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* C7 */
Function C_7(Len,Inv){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5e);
	Int Note3 = NoteNo(o5g);
	Int Note4 = NoteNo(o5b);
	Int Which_is = NoteNo(o4e) - NoteNo(o4c)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���h�@�@�h�E�~�E�\�E�V�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���h�@�@�h�E�~�E�\�E�V�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* D7 */
Function D_7(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5c);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4f) - NoteNo(o4d)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X�����@�@���E�t�@�E���E�h�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* E7 */
Function E_7(Len,Inv){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4g) - NoteNo(o4e)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���~�@�@�~�E�\�E�V�E���̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���~�@�@�~�E�\�E�V�E���̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* F7 */
Function F_7(Len,Inv){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o4a) - NoteNo(o4f)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���t�@�@�t�@�E���E�h�E�~�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���t�@�@�t�@�E���E�h�E�~�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* G7 */
Function G_7(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4b) - NoteNo(o4g)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -3; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���E�t�@�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���\�@�@�\�E�V�E���E�t�@�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* A7 */
Function A_7(Len,Inv){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5c);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o5c) - NoteNo(o4a)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  2; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X�����@�@���E�h�E�~�E�\�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X�����@�@���E�h�E�~�E�\�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* B7 */
Function B_7(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o5d) - NoteNo(o4b)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert4()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���V�@�@�V�E���E�t�@�E���̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���V�@�@�V�E���E�t�@�E���̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* C9 */
Function C_9(Len,Inv){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4e) - NoteNo(o4c)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���h�@�@�~�E�\�E�V�E���̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���h�@�@�~�E�\�E�V�E���̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* D9 */
Function D_9(Len,Inv){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o4f) - NoteNo(o4d)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  0; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  0; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  0; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  0; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X�����@�@�t�@�E���E�h�E�~�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X�����@�@�t�@�E���E�h�E�~�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* E9 */
Function E_9(Len,Inv){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4g) - NoteNo(o4e)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���~�@�@�\�E�V�E���E�t�@�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���~�@�@�\�E�V�E���E�t�@�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* F9 */
Function F_9(Len,Inv){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o4a) - NoteNo(o4f)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���t�@�@���E�h�E�~�E�\�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���t�@�@���E�h�E�~�E�\�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* G9 */
Function G_9(Len,Inv){
	Int Note0 = NoteNo(o3g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o4b) - NoteNo(o4g)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv = -2; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv = -1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv = -2; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv = -2; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv = -1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv = -2; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv = -2; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv = -2; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv = -2; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv = -1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv = -1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���\�@�@�V�E���E�t�@�E���̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���\�@�@�V�E���E�t�@�E���̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* A9 */
Function A_9(Len,Inv){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6e);
	Int Which_is = NoteNo(o5c) - NoteNo(o4a)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  1; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  1; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  1; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  2; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  1; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  1; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  1; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  1; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X�����@�@�h�E�~�E�\�E�V�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X�����@�@�h�E�~�E�\�E�V�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* B9 */
Function B_9(Len,Inv){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6d);
	Int Which_is = NoteNo(o5d) - NoteNo(o4b)		// ���W���[���}�C�i�[�����c��
	If(InsertMode==1){ Int DefInv =  0; SecD() }	// �Z�J���_���h�~�i���g
	If(InsertMode==2){ Int DefInv =  1; SubD() }	// ���R�[�h
	If(InsertMode==3){ Int DefInv =  0; P_Dim() }	// �p�b�V���O�f�B�~�j�b�V��
	If(InsertMode==4){ Int DefInv =  0; SecD_2() }	// �U�X
	If(InsertMode==5){ Int DefInv =  1; SubD_2() }	// �U�X�i���R�[�h�j
	If(InsertMode==6){ Int DefInv =  0; DopD() }	// �h�b�y���h�~�i���g
	If(InsertMode==7){ Int DefInv =  0; JazzD1() }	// �X���f�B�A���V����
	If(InsertMode==8){ Int DefInv =  0; JazzD2() }	// �X�I���^�[�h
	If(InsertMode==9){ Int DefInv =  0; JazzD3() }	// �X�X�[�p�[���N���A���i���h���A����X�j
	If(InsertMode==10){Int DefInv =  1; JazzD4() }	// �X���f�B�A���V�����UmM7
	If(InsertMode==11){Int DefInv =  1; JazzD5() }	// �X�X�[�p�[���N���A���UaugM7
	Inv = Inv + Top
	Invert5()
	InsertMode = 0
	If(Len==0){Len = MML(l)}
	If(Chord5_off==0){
		If(Feint==0){
			If(Disp==1){ MetaText={"�x�[�X���V�@�@���E�t�@�E���E�h�̘a��"} }
			If(RootBass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
		}
		}Else{
		If(Disp==1){ MetaText={"�x�[�X���V�@�@���E�t�@�E���E�h�̘a��"} }
		r%(Len)
	}
	Feint = 0
}

/* Insert */
Function Combo1(val1,val2,val3,val4){
	InsertMode = 1
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo2(val1,val2,val3,val4){
	InsertMode = 2
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo3(val1,val2,val3,val4){
	InsertMode = 3
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo4(val1,val2,val3,val4){
	InsertMode = 4
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo5(val1,val2,val3,val4){
	InsertMode = 5
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo6(val1,val2,val3,val4){
	InsertMode = 6
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo7(val1,val2,val3,val4){
	InsertMode = 7
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo8(val1,val2,val3,val4){
	InsertMode = 8
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo9(val1,val2,val3,val4){
	InsertMode = 9
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo10(val1,val2,val3,val4){
	InsertMode = 10
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}

Function Combo11(val1,val2,val3,val4){
	InsertMode = 11
	LenII = val1
	InvII = val2
	LenIII = val3
	InvIII = val4
}


/* �T */		Function T1(val1,val2){#Mode(0) C_(val1,val2)}
/* �Ym */		Function T2(val1,val2){#Mode(0) A_(val1,val2)}
/* �Vm */		Function T3(val1,val2){#Mode(0) E_(val1,val2)}
/* �Tsus4 */	Function T4(val1,val2){#Mode(0) C_4(val1,val2)}
/* �Ysus4 */	Function T5(val1,val2){#Mode(0) A_4(val1,val2)}
/* �Vsus4 */	Function T6(val1,val2){#Mode(0) E_4(val1,val2)}
/* �Tmaj7 */	Function T7(val1,val2){#Mode(0) C_7(val1,val2)}
/* �Ym7 */		Function T8(val1,val2){#Mode(0) A_7(val1,val2)}
/* �Vm7 */		Function T9(val1,val2){#Mode(0) E_7(val1,val2)}
/* �Tmaj9 */	Function T10(val1,val2){#Mode(0) C_9(val1,val2)}
/* �Ym9 */		Function T11(val1,val2){#Mode(0) A_9(val1,val2)}
/* �Vm9 */		Function T12(val1,val2){#Mode(0) E_9(val1,val2)}
/* �T7(-7) */	Function T13(val1,val2){#Mode(4) C_(val1,val2)}
/* �T7 */		Function T14(val1,val2){#Mode(4) C_7(val1,val2)}
/* �V7 */		Function T15(val1,val2){#HMinor(2) E_7(val1,val2)}
/* �Taug */		Function T16(val1,val2){#HMinor(2) C_(val1,val2)}

/* �W */		Function S1(val1,val2){#Mode(0) F_(val1,val2)}
/* �Um */		Function S2(val1,val2){#Mode(0) D_(val1,val2)}
/* �U */		Function S3(val1,val2){#Mode(3) D_(val1,val2)}
/* �Wsus4 */	Function S4(val1,val2){#Mode(4) F_4(val1,val2)}
/* �Usus4 */	Function S5(val1,val2){#Mode(0) D_4(val1,val2)}
/* �Wmaj7 */	Function S6(val1,val2){#Mode(0) F_7(val1,val2)}
/* �Um7 */		Function S7(val1,val2){#Mode(0) D_7(val1,val2)}
/* �W#m7��5 */	Function S8(val1,val2){#MMinor(3) F_7(val1,val2)}
/* �Wmaj9 */	Function S9(val1,val2){#Mode(0) F_9(val1,val2)}
/* �Um9 */		Function S10(val1,val2){#Mode(0) D_9(val1,val2)}
/* �U9 */		Function S11(val1,val2){#Mode(3) D_9(val1,val2)}
/* �W7 */		Function S12(val1,val2){#MMinor(0) F_7(val1,val2)}
/* �U7 */		Function S13(val1,val2){#Mode(3) D_7(val1,val2)}

/* �X */		Function D1(val1,val2){#Mode(0) G_(val1,val2)}
/* �Zm��5 */	Function D2(val1,val2){#Mode(0) B_(val1,val2)}
/* �Z�� */		Function D3(val1,val2){#Mode(4) B_(val1,val2)}
/* �Xsus4 */	Function D4(val1,val2){#Mode(0) G_4(val1,val2)}
/* �X7 */		Function D5(val1,val2){#Mode(0) G_7(val1,val2)}
/* �Zm7��5 */	Function D6(val1,val2){#Mode(0) B_7(val1,val2)}
/* �Z��maj7 */	Function D7(val1,val2){#Mode(4) B_7(val1,val2)}
/* �X9 */		Function D8(val1,val2){#Mode(0) G_9(val1,val2)}
/* �Z��maj9 */	Function D9(val1,val2){#Mode(4) B_9(val1,val2)}
/* �Xmaj7 */	Function D10(val1,val2){#Mode(3) G_7(val1,val2)}
/* �Zm */		Function D11(val1,val2){#Mode(3) B_(val1,val2)}
/* �Zm7 */		Function D12(val1,val2){#Mode(3) B_7(val1,val2)}

/* �Tm */		Function Tm1(val1,val2){#Mode(5) C_(val1,val2)}
/* �V�� */		Function Tm2(val1,val2){#Mode(5) E_(val1,val2)}
/* �Tsus4 */	Function Tm3(val1,val2){#Mode(5) C_4(val1,val2)}
/* �V��sus4 */	Function Tm4(val1,val2){#Mode(5) E_4(val1,val2)}
/* �Tm7 */		Function Tm5(val1,val2){#Mode(5) C_7(val1,val2)}
/* �V��maj7 */	Function Tm6(val1,val2){#Mode(5) E_7(val1,val2)}
/* �Tm9 */		Function Tm7(val1,val2){#Mode(5) C_9(val1,val2)}
/* �V��maj9 */	Function Tm8(val1,val2){#Mode(5) E_9(val1,val2)}
/* �TmM7 */		Function Tm9(val1,val2){#MMinor(0) C_7(val1,val2)}
/* �V��7 */		Function Tm10(val1,val2){#Mode(2) E_7(val1,val2)}
/* �Tdim */		Function Tm11(val1,val2){#HMinor(6) C_7(val1,val2)}
/* �V��augM7 */	Function Tm12(val1,val2){#MMinor(0) E_7(val1,val2)}

/* �Wm */		Function Sm1(val1,val2){#Mode(5) F_7(val1,val2)}
/* �Y�� */		Function Sm2(val1,val2){#Mode(5) A_(val1,val2)}
/* �Um��5 */	Function Sm3(val1,val2){#Mode(5) D_(val1,val2)}
/* �Wsus4 */	Function Sm4(val1,val2){#Mode(5) F_4(val1,val2)}
/* �Y��sus4 */	Function Sm5(val1,val2){#Mode(2) A_4(val1,val2)}
/* �Wm7 */		Function Sm6(val1,val2){#Mode(5) F_7(val1,val2)}
/* �Y��maj7 */	Function Sm7(val1,val2){#Mode(5) A_7(val1,val2)}
/* �Um7��5 */	Function Sm8(val1,val2){#Mode(5) D_7(val1,val2)}
/* �Wm9 */		Function Sm9(val1,val2){#Mode(5) F_9(val1,val2)}
/* �Y��maj9 */	Function Sm10(val1,val2){#Mode(5) A_9(val1,val2)}
/* �W7 */		Function Sm11(val1,val2){#Mode(1) F_7(val1,val2)}
/* �Ym7��5 */	Function Sm12(val1,val2){#Mode(1) A_7(val1,val2)}
/* �Um7 */		Function Sm13(val1,val2){#Mode(1) D_7(val1,val2)}

/* �Xm */		Function Dm1(val1,val2){#Mode(5) G_(val1,val2)}
/* �X */		Function Dm2(val1,val2){#HMinor(0) G_(val1,val2)}
/* �Z�� */		Function Dm3(val1,val2){#Mode(5) B_(val1,val2)}
/* �U�� */		Function Dm4(val1,val2){#Mode(2) D_(val1,val2)}
/* �Xsus4 */	Function Dm5(val1,val2){#Mode(5) G_4(val1,val2)}
/* �Z��sus4 */	Function Dm6(val1,val2){#Mode(5) B_4(val1,val2)}
/* �Xm7 */		Function Dm7(val1,val2){#Mode(5) G_7(val1,val2)}
/* �X7 */		Function Dm8(val1,val2){#HMinor(0) G_7(val1,val2)}
/* �Z��7 */		Function Dm9(val1,val2){#Mode(5) B_7(val1,val2)}
/* �U��maj7 */	Function Dm10(val1,val2){#Mode(2) D_7(val1,val2)}
/* �Z��maj7 */	Function Dm11(val1,val2){#Mode(1) B_7(val1,val2)}
/* �Xm9 */		Function Dm12(val1,val2){#Mode(1) G_9(val1,val2)}
/* �U��maj9 */	Function Dm13(val1,val2){#Mode(2) D_9(val1,val2)}
/* �Z��m7 */	Function Dm14(val1,val2){#Mode(2) B_7(val1,val2)}
/* �Zdim */		Function Dm15(val1,val2){#HMinor(0) B_7(val1,val2)}

Function TopNote(val){ Top = val }



