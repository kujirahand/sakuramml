//------------------------------------------------------------------------------ Header.
//
//�@�炭����m�[�e�[�V�����֐��@ver.0.01 LastUpdate = 2000/07/08�@�݂Â���
//
//�@�X�P�[���֐��T�|�[�g
//�@�_�C�A�g�j�b�N�֐��T�|�[�g
//
//------------------------------------------------------------------------------
Int Open = 0;					// �I�[�v���{�C�V���O�t���O
//------------------------------------------------------------------------------ InvertFunction.
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
//------------------------------------------------------------------------------ ModeFunction.
/* Major scale */
Function Major(){
	System.KeyFlag=(0,0,0,0,0,0,0);		/* Major scale */
}

/* Minor scale */
Function Minor(){
	System.KeyFlag=(-1,-1,0,0,-1,0,0);		/* Minor scale */
}

/* Harmonic minor */
Function HMinor(){
	System.KeyFlag=(-1,0, 0,0,-1,0,0);		/* Harmonic minor */
}

/* Melodic minor */
Function MMinor(){
	System.KeyFlag=(0,0,0,0,-1,0,0);		/* Melodic minor */
}

Function Mode(ModeNo){
	If(ModeNo==0){
		System.KeyFlag=(0,0,0,0,0,0,0);		/* Ionian */
	}
	If(ModeNo==1){
		System.KeyFlag=(0,-1,0,0,-1,0,0);		/* Dorian */
	}
	If(ModeNo==2){
		System.KeyFlag=(-1,-1,0,-1,-1,0,0);		/* Phrygian */
	}
	If(ModeNo==3){
		System.KeyFlag=(0,0,0,0,0,1,0);		/* Lydian */
	}
	If(ModeNo==4){
		System.KeyFlag=(0,-1,0,0,0,0,0);		/* Mixo-Lydian */
	}
	If(ModeNo==5){
		System.KeyFlag=(-1,-1,0,0,-1,0,0);		/* Aeolian */
	}
	If(ModeNo==6){
		System.KeyFlag=(-1,-1,0,-1,-1,0,-1);	/* Locrian */
	}
	If(ModeNo==7){
		System.KeyFlag=(1,0,0,1,1,1,0);		/* Pentatonic minor blues */
	}
}

//------------------------------------------------------------------------------ MainFunction.
/* C_ */
Function C_(Len,Inv,Bass){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o6c);
	Invert3()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
}

/* D_ */
Function D_(Len,Inv,Bass){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6d);
	Invert3()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
}

/* E_ */
Function E_(Len,Inv,Bass){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Invert3()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
}

/* F_ */
Function F_(Len,Inv,Bass){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Invert3()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
}

/* G_ */
Function G_(Len,Inv,Bass){
	Int Note0 = NoteNo(o4g);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5b);
	Int Note3 = NoteNo(o6d);
	Invert3()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
}

/* A_ */
Function A_(Len,Inv,Bass){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Invert3()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
}

/* B_ */
Function B_(Len,Inv,Bass){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5b);
	Int Note3 = NoteNo(o6d);
	Invert3()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),%(Len);
}

/* C7 */
Function C7(Len,Inv,Bass){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6e);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* D7 */
Function D7(Len,Inv,Bass){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5c);
	Int Note4 = NoteNo(o6d);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* E7 */
Function E7(Len,Inv,Bass){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* F7 */
Function F7(Len,Inv,Bass){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5c);
	Int Note4 = NoteNo(o6e);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* G7 */
Function G7(Len,Inv,Bass){
	Int Note0 = NoteNo(o4g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* A7 */
Function A7(Len,Inv,Bass){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5c);
	Int Note4 = NoteNo(o6e);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* B7 */
Function B7(Len,Inv,Bass){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert4()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* C9 */
Function C9(Len,Inv,Bass){
	Int Note0 = NoteNo(o4c);
	Int Note1 = NoteNo(o5e);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert5()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* D9 */
Function D9(Len,Inv,Bass){
	Int Note0 = NoteNo(o4d);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Note4 = NoteNo(o6e);
	Invert5()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* E9 */
Function E9(Len,Inv,Bass){
	Int Note0 = NoteNo(o4e);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert5()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* F9 */
Function F9(Len,Inv,Bass){
	Int Note0 = NoteNo(o4f);
	Int Note1 = NoteNo(o5g);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o6c);
	Int Note4 = NoteNo(o6e);
	Invert5()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* G9 */
Function G9(Len,Inv,Bass){
	Int Note0 = NoteNo(o4g);
	Int Note1 = NoteNo(o5f);
	Int Note2 = NoteNo(o5a);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6d);
	Invert5()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* A9 */
Function A9(Len,Inv,Bass){
	Int Note0 = NoteNo(o3a);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5g);
	Int Note3 = NoteNo(o5b);
	Int Note4 = NoteNo(o6e);
	Invert5()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}

/* B9 */
Function B9(Len,Inv,Bass){
	Int Note0 = NoteNo(o3b);
	Int Note1 = NoteNo(o5c);
	Int Note2 = NoteNo(o5f);
	Int Note3 = NoteNo(o5a);
	Int Note4 = NoteNo(o6d);
	Invert5()
	If(Len==0){Len = MML(l)};			// ���������O�X���ȗ�����Ă���k�l����擾
	If(Bass==0){n(Note0),0}; n(Note1),0; n(Note2),0; n(Note3),0; n(Note4),%(Len);
}


//Open = 0;

//TR=1;CH=1;
//V=100 q99 @050 P=064 EP(127); l1 Mode(4) v080
//cdefgab>c


