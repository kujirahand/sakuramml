//----------------------------------------------------------------------------------------------
//_bwb_guitar.h
//		by	�����F		(bluewhitebear@hotmail.com)
//		Hp	Blue Darkness	(http://www.nothing-kb.jp/~bluedarkness/)
//----------------------------------------------------------------------------------------------
//_���[�U�[�ϐ�
//	�����̕��т́u6��,5��,4��,3��,2��,1���v�̏��ł��B
Array	BG_STRINGS=0,0,0,0,0,0;			//�����Ƃ̃x���V�e�B�̒ǉ���
Int	BG_KEY=0;					//�S�̂̃`���[�j���O�A�J�|�i�����P�ʁj
Int	BG_LAG=!128;				//�X�g���[�N���̃Y��
Int	BG_PEDAL=off;				//����x�Ƀy�_���𓥂�ŁA�����[�X���Č�����
Int	BG_PRINT=off;				//�\���@�\
Int	BG_VELOCITY_FIRST=20;			//�ŏ��̉��̃x���V�e�B���Z�l�i�ŏ�����Q�Ԗڂ������̒l�����Z�j
Int	BG_VELOCITY_LAST=10;			//�Ō�̉��̃x���V�e�B���Z�l�i�Ōォ��Q�Ԗڂ������̒l�����Z�j
Int	BG_VELOCITY_MOMENTUM=-2;		//����炷���Ƃɉ��Z���Ă����x���V�e�B�l�i�������Ȃ��Ȃ�j
Int	BG_ARPEGGIO_MUTE_VELOCITY=-50;	//�A���y�W�I���t���̃~���[�g���t�̍ۂ̉��Z�x���V�e�B�̒l
Int	BG_ARPEGGIO_MUTE_GATE=-20;		//�A���y�W�I���t���̃~���[�g���t�̍ۂ̉��Z�Q�[�g�̒l
Int	BG_RHYTHM_MUTE_VELOCITY=-30;		//���Y�����t���̃~���[�g���t�̍ۂ̉��Z�x���V�e�B�̒l
Int	BG_RHYTHM_MUTE_GATE=-40;		//���Y�����t���̃~���[�g���t�̍ۂ̉��Z�Q�[�g�̒l
//----------------------------------------------------------------------------------------------
//_�V�X�e���ϐ�
Array	BG_FINGER=0,0,0,0,0,0;			//�������Ă���ӏ�
Int	BG_POSITION=1;				//�|�W�V�����̍����i�P�`�T�j
Array	BG_OPEN=40,45,50,55,59,64;		//�J�����̃m�[�g���w��
//----------------------------------------------------------------------------------------------
//_���������̊֐�
//_����[BG_GRASP(�����z��ϐ�)]
Function BG_GRASP(Array BG_GRASP_ARRAY){
	//�y�_������
	If(BG_PEDAL==on){
		y64,0;r*(%1);y64,127;r*(-%1);
		If(BG_PRINT==on){Print({"y64,0;r*(%1);y64,127;r*(-%1);"});}
		}

	//�z�񏈗�
	If(BG_GRASP_ARRAY(0)<0){BG_POSITION=1;}
	If(BG_GRASP_ARRAY(0)>5){BG_POSITION=5;}
	If( (BG_GRASP_ARRAY(0)>0)&(BG_GRASP_ARRAY(0)<6) ){BG_POSITION=BG_GRASP_ARRAY(0);}
	For(Int BG_GRASP_I=0;BG_GRASP_I<6;BG_GRASP_I++){
		BG_FINGER(BG_GRASP_I)=BG_GRASP_ARRAY( (BG_POSITION-1)*6 + 1 + BG_GRASP_I );}
}

//_�ڐG�U��؂�̃x���V�e�B�C���̊֐�
//BG_TOUCHANDGO(�炷���̖{���i�����̃~���[�g���݁j,���[�v��,From,To,D:1 U:-1)
Function BG_TOUCHANDGO(Int BG_TOUCHANDGO_I,Int BG_TOUCHANDGO_FOR,Int BG_TOUCHANDGO_FRM,Int BG_TOUCHANDGO_MTO,Int BG_TOUCHANDGO_UD){
	Int	BG_TOUCHANDGO_RESULT
	Switch(BG_TOUCHANDGO_I){
		Case(0){BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST;}
		Case(1){Switch(BG_TOUCHANDGO_FOR){
			Case(BG_TOUCHANDGO_FRM){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST;}
			Case(BG_TOUCHANDGO_FRM+BG_TOUCHANDGO_UD){	BG_TOUCHANDGO_RESULT=BG_VELOCITY_LAST;}
		}	}
		Case(2){Switch(BG_TOUCHANDGO_FOR){
			Case(BG_TOUCHANDGO_FRM){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST;}
			Case(BG_TOUCHANDGO_FRM+BG_TOUCHANDGO_UD){	BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST/2;}
			Case(BG_TOUCHANDGO_MTO){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_LAST;}
		}	}
		Default{Switch(BG_TOUCHANDGO_FOR){
			Case(BG_TOUCHANDGO_FRM){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST;}
			Case(BG_TOUCHANDGO_FRM+BG_TOUCHANDGO_UD){	BG_TOUCHANDGO_RESULT=BG_VELOCITY_FIRST/2;}
			Case(BG_TOUCHANDGO_MTO-BG_TOUCHANDGO_UD){	BG_TOUCHANDGO_RESULT=BG_VELOCITY_LAST/2;}
			Case(BG_TOUCHANDGO_MTO){			BG_TOUCHANDGO_RESULT=BG_VELOCITY_LAST;}
			Default{		BG_TOUCHANDGO_RESULT=0;}
		}	}
	}
	
	Result=BG_TOUCHANDGO_RESULT;
}
//----------------------------------------------------------------------------------------------
//_���s����֐�
//_�R�[�h�t�H�[���֐�	BG_CHORDFORM
Function BG_CHORDFORM(){
	Str	BG_CHORDFORM_STR={"�U��,�T��,�S��,�R��,�Q��,�P�� = "};
	For(Int BG_CHORDFORM_I=0;BG_CHORDFORM_I<6;BG_CHORDFORM_I++){
		If(BG_FINGER(BG_CHORDFORM_I)==-1){
			BG_CHORDFORM_STR=BG_CHORDFORM_STR+{"M"};
			}Else{
			BG_CHORDFORM_STR=BG_CHORDFORM_STR+BG_FINGER(BG_CHORDFORM_I);
		}
		
		If(BG_CHORDFORM_I<5){BG_CHORDFORM_STR=BG_CHORDFORM_STR+{,};}
	}
	
	Print(BG_CHORDFORM_STR)

}
//----------------------------------------------------------------------------------------------
//_�_�E���X�g���[�N[BGD(l,q,v,t,h,LAG,FROM,TO)]
/*
	BGD(l,q,v,t,h,LAG,FROM,TO)
		l	(BGD_INT_LEN)	�E�E�E	����
		q	(BGD_INT_GAT)	�E�E�E	���Z�Q�[�g�l
		v	(BGD_INT_VEL)	�E�E�E	���Z�x���V�e�B�l
		t	(BGD_INT_TIM)	�E�E�E	���Z�^�C�~���O�l
		h	(BGD_INT_HAT)	�E�E�E	on���ƁA�Q�[�g���Z�����œ����ɉ����~�߂�
		LAG	(BGD_INT_LAG)	�E�E�E	�X�g���[�N���̃Y���̉��Z�l
		FROM	(BGD_INT_FRM)	�E�E�E	���Ԗڂ̌�����	�i�����l�U�j
		TO	(BGD_INT_MTO)	�E�E�E	���Ԗڂ܂ł̌���	�i�����l�P�j
*/
Function BGD(Int BGD_INT_LEN,Int BGD_INT_GAT,Int BGD_INT_VEL,Int BGD_INT_TIM,Int BGD_INT_HAT,Int BGD_INT_LAG,Int BGD_INT_FRM,Int BGD_INT_MTO){
	//���[�J���ϐ��錾
	Int	BGD_MML_VEL=MML(v);	//�f�t�H���g�x���V�e�B�擾
	Int	BGD_MML_TIM=MML(t);	//�f�t�H���g�^�C�~���O�擾
	Int	BGD_MML_GAT=MML(q);	//�f�t�H���g�Q�[�g�擾
	Int	BGD_MML_HAT=MML(h);	//�f�t�H���g�Q�[�g���Z�l�擾
	Int	BGD_FRM;			//�������t���J�n�ϐ��@[�U���P]��[�O���T]
	Int	BGD_MTO;			//�������t���I���ϐ��@[�U���P]��[�O���T]
	Str	BGD_RUN;			//���s������
	Int	BGD_TEMP;			//Temp
	
	//�e�����̖{���̒����@�����ē����ϐ��ɕϊ��@[�U���P]��[�O���T]
	If( (BGD_INT_FRM<1) | (BGD_INT_FRM>6) ){BGD_FRM=0;}
	If( (BGD_INT_FRM>0) & (BGD_INT_FRM<7) ){BGD_FRM=6-BGD_INT_FRM;}
	For(Int BGD_I=0;BGD_I<6;BGD_I++){	If( BG_FINGER(BGD_FRM)==-1 ){BGD_FRM++;}Else{BGD_I=6;}	}//�Œቹ�����~���[�g�̏ꍇ�A�e���Ȃ�

	If( (BGD_INT_MTO<1) | (BGD_INT_MTO>6) ){BGD_MTO=5;}
	If( (BGD_INT_MTO>0) & (BGD_INT_MTO<7) ){BGD_MTO=6-BGD_INT_MTO;}
	For(Int BGD_I=5;BGD_I>-1;BGD_I--){	If( BG_FINGER(BGD_MTO)==-1 ){BGD_MTO--;}Else{BGD_I=-1;}	}//�ō��������~���[�g�̏ꍇ�A�e���Ȃ�

	BGD_RUN=CHR(39)	//	BGD_RUN='

	//���[�v�ɂ�镶���񐶐�
	If(BGD_FRM<=BGD_MTO){
		For(Int BGD_I=BGD_FRM;BGD_I<=BGD_MTO;BGD_I++){
			If(BG_FINGER(BGD_I)!=-1){
				BGD_TEMP=BG_TOUCHANDGO(BGD_MTO-BGD_FRM,BGD_I,BGD_FRM,BGD_MTO,1)
				BGD_RUN=BGD_RUN+{"v("}+( BGD_MML_VEL+BGD_INT_VEL+BG_STRINGS(BGD_I)+BGD_TEMP+BG_VELOCITY_MOMENTUM*(BGD_I-BGD_FRM) )+{");"};
				BGD_RUN=BGD_RUN+{"t("}+( BGD_MML_TIM+BGD_INT_TIM+((BG_LAG+BGD_INT_LAG)*(BGD_I-BGD_FRM)) )+{");"};
				BGD_RUN=BGD_RUN+{"q("}+( BGD_MML_GAT+BGD_INT_GAT )+{");"};
If( BGD_INT_HAT==on ){	BGD_RUN=BGD_RUN+{"h("}+( BGD_MML_HAT+((BG_LAG+BGD_INT_LAG)*(BGD_I-BGD_FRM)) )+{");"};		}
				BGD_RUN=BGD_RUN+{"n("}+( BG_KEY+BG_OPEN(BGD_I)+BG_FINGER(BGD_I) )+{");"}//,%("}+BGD_INT_LEN+{");"};
			}Else{
				BGD_RUN=BGD_RUN+{"r;"}//(%("}+BGD_INT_LEN+{"));"};
			}
		}

	//���s������Ƀx���V�e�B�A�^�C�~���O�A�Q�[�g�A�����̏���␳
				BGD_RUN=BGD_RUN+{"v("}+BGD_MML_VEL+{");"}
				BGD_RUN=BGD_RUN+{"t("}+BGD_MML_TIM+{");"}
				BGD_RUN=BGD_RUN+{"q("}+BGD_MML_GAT+{");"}
If( BGD_INT_HAT==on ){	BGD_RUN=BGD_RUN+{"h("}+BGD_MML_HAT+{");"}	}
				BGD_RUN=BGD_RUN+CHR(39)+{"%("}+BGD_INT_LEN+{")"}

	//���s�@BG_PRINT==on�̎��A�\�������˂�
		If(BG_PRINT==on){Print(BGD_RUN);}
		BGD_RUN;

	}Else{Print({"BWB_GUITAR.H ERROR!!"})}	//	�u�@If(BGD_FRM<=BGD_MTO){�@�v����������Ȃ����B
}
//----------------------------------------------------------------------------------------------
//_�A�b�v�X�g���[�N[BGU(l,q,v,t,LAG,FROM,TO)]
/*
	BGU(l,q,v,t,LAG,FROM,TO)
		l	(BGU_INT_LEN)	�E�E�E	����
		q	(BGU_INT_GAT)	�E�E�E	���Z�Q�[�g�l
		v	(BGU_INT_VEL)	�E�E�E	���Z�x���V�e�B�l
		t	(BGU_INT_TIM)	�E�E�E	���Z�^�C�~���O�l
		LAG	(BGU_INT_LAG)	�E�E�E	�X�g���[�N���̃Y���̉��Z�l
		FROM	(BGU_INT_FRM)	�E�E�E	���Ԗڂ̌�����	�i�����l�P�j
		TO	(BGU_INT_MTO)	�E�E�E	���Ԗڂ܂ł̌���	�i�����l�U�j
*/
Function BGU(Int BGU_INT_LEN,Int BGU_INT_GAT,Int BGU_INT_VEL,Int BGU_INT_TIM,Int BGU_INT_HAT,Int BGU_INT_LAG,Int BGU_INT_FRM,Int BGU_INT_MTO){
	//���[�J���ϐ��錾
	Int	BGU_MML_VEL=MML(v);	//�f�t�H���g�x���V�e�B�擾
	Int	BGU_MML_TIM=MML(t);	//�f�t�H���g�^�C�~���O�擾
	Int	BGU_MML_GAT=MML(q);	//�f�t�H���g�Q�[�g�擾
	Int	BGU_MML_HAT=MML(h);	//�f�t�H���g�Q�[�g���Z�l�擾
	Int	BGU_FRM;			//�������t���J�n�ϐ��@[�P���U]��[�T���O]
	Int	BGU_MTO;			//�������t���I���ϐ��@[�P���U]��[�T���O]
	Str	BGU_RUN;			//���s������
	Int	BGU_TEMP;			//Temp
	
	//�e�����̖{���̒����@�����ē����ϐ��ɕϊ��@[�P���U]��[�T���O]
	If( (BGU_INT_FRM<1) | (BGU_INT_FRM>6) ){BGU_FRM=5;}
	If( (BGU_INT_FRM>0) & (BGU_INT_FRM<7) ){BGU_FRM=6-BGU_INT_FRM;}
	For(Int BGU_I=5;BGU_I>-1;BGU_I--){	If( BG_FINGER(BGU_FRM)==-1 ){BGU_FRM--;}Else{BGU_I=-1;}	}//�Œቹ�����~���[�g�̏ꍇ�A�e���Ȃ�

	If( (BGU_INT_MTO<1) | (BGU_INT_MTO>6) ){BGU_MTO=0;}
	If( (BGU_INT_MTO>0) & (BGU_INT_MTO<7) ){BGU_MTO=6-BGU_INT_MTO;}
	For(Int BGU_I=0;BGU_I<6;BGU_I++){	If( BG_FINGER(BGU_MTO)==-1 ){BGU_MTO++;}Else{BGU_I=6;}	}//�ō��������~���[�g�̏ꍇ�A�e���Ȃ�

	BGU_RUN=CHR(39)	//	BGU_RUN='

	//���[�v�ɂ�镶���񐶐�
	If(BGU_FRM>=BGU_MTO){
		For(Int BGU_I=BGU_FRM;BGU_I>=BGU_MTO;BGU_I--){
			If(BG_FINGER(BGU_I)!=-1){
				BGU_TEMP=BG_TOUCHANDGO(BGU_FRM-BGU_MTO,BGU_I,BGU_FRM,BGU_MTO,-1)
				BGU_RUN=BGU_RUN+{"v("}+( BGU_MML_VEL+BGU_INT_VEL+BG_STRINGS(BGU_I)+BGU_TEMP+BG_VELOCITY_MOMENTUM*(BGU_FRM-BGU_I) )+{");"};
				BGU_RUN=BGU_RUN+{"t("}+( BGU_MML_TIM+BGU_INT_TIM+((BG_LAG+BGU_INT_LAG)*(BGU_FRM-BGU_I)) )+{");"};
				BGU_RUN=BGU_RUN+{"q("}+( BGU_MML_GAT+BGU_INT_GAT )+{");"};
If( BGU_INT_HAT==on ){	BGU_RUN=BGU_RUN+{"h("}+( BGU_MML_HAT+((BG_LAG+BGU_INT_LAG)*(BGU_FRM-BGU_I)) )+{");"};		}
				BGU_RUN=BGU_RUN+{"n("}+( BG_KEY+BG_OPEN(BGU_I)+BG_FINGER(BGU_I) )+{");"};
			}Else{
				BGU_RUN=BGU_RUN+{"r;"};
			}
		}

	//���s������Ƀx���V�e�B�A�^�C�~���O�A�Q�[�g�A�����̏���␳
				BGU_RUN=BGU_RUN+{"v("}+BGU_MML_VEL+{");"}
				BGU_RUN=BGU_RUN+{"t("}+BGU_MML_TIM+{");"}
				BGU_RUN=BGU_RUN+{"q("}+BGU_MML_GAT+{");"}
If( BGU_INT_HAT==on ){	BGU_RUN=BGU_RUN+{"h("}+BGU_MML_HAT+{");"}	}
				BGU_RUN=BGU_RUN+CHR(39)+{"%("}+BGU_INT_LEN+{")"}

	//���s�@BG_PRINT==on�̎��A�\�������˂�
		If(BG_PRINT==on){Print(BGU_RUN);}
		BGU_RUN;

	}Else{Print({"BWB_GUITAR.H ERROR!!"})}	//	�u�@If(BGD_FRM<=BGD_MTO){�@�v����������Ȃ����B
}
//----------------------------------------------------------------------------------------------
//_�A���y�W�I�X�g���[�N
/*
	BGA{������}
		������̒��ɂ�bwb_guitar.h���L��MML���g����B
		�ȉ��ɂ��̃R�}���h�ƕ��@�����߂��B

	�R�}���h
		A�F�U����e���܂��B
		B�F�T����e���܂��B
		C�F�S����e���܂��B
		D�F�R����e���܂��B
		E�F�Q����e���܂��B
		F�F�P����e���܂��B
		a�F�U�����キ�e���܂��B
		b�F�T�����キ�e���܂��B
		c�F�S�����キ�e���܂��B
		d�F�R�����キ�e���܂��B
		e�F�Q�����キ�e���܂��B
		f�F�P�����キ�e���܂��B
		r�F�x��
		^�F�^�C
		<�F�A���y�W�I�R�}���h���̓��[�h����ꎞ�I�ɔ����o��
		>�F�A���y�W�I�R�}���h���̓��[�h�ɖ߂� 
*/
Function BGA(Str BGA_STR){
	Int	BGA_MML_VEL=MML(v);	//�f�t�H���g�x���V�e�B�擾
	Int	BGA_MML_GAT=MML(q);	//�f�t�H���g�Q�[�g�擾
	Str	BGA_RUN;			//���s������
	Int	BGA_MODE=0;			//0:����@1:�ʏ�

	For(Int BGA_I=1;BGA_I<=SizeOf(BGA_STR);BGA_I++){
		Switch(BGA_MODE){
			Case(0){
				Switch(MID(BGA_STR,BGA_I,1)){
					Case({A}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(0,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({B}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(1,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({C}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(2,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({D}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(3,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({E}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(4,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({F}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(5,BGA_MML_VEL,BGA_MML_GAT,off);}
					Case({a}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(0,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({b}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(1,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({c}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(2,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({d}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(3,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({e}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(4,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({f}){BGA_RUN=BGA_RUN+BGA_ADDNOTE(5,BGA_MML_VEL,BGA_MML_GAT,on);}
					Case({r}){BGA_RUN=BGA_RUN+{"r"};}
					Case({^}){BGA_RUN=BGA_RUN+{"^"};}
					Case({<}){BGA_MODE=1;}
					Default{BGA_RUN=BGA_RUN+MID(BGA_STR,BGA_I,1);}
				}
			}
			Case(1){
				If(MID(BGA_STR,BGA_I,1)=={>}){BGA_MODE=0;}
				Else{BGA_RUN=BGA_RUN+MID(BGA_STR,BGA_I,1);}
			}
		}
	}
	//���s�����񐶐�
	BGA_RUN=BGA_RUN+{";v("}+BGA_MML_VEL+{");q("}+BGA_MML_GAT+{");"}

	//���s�@BG_PRINT==on�̎��A�\�������˂�
	If(BG_PRINT==on){Print(BGA_RUN);}
	BGA_RUN;
}
Function BGA_ADDNOTE(Int BGA_ADDNOTE_NUMBER,Int BGA_VEL,Int BGA_GAT,Int BGA_ADDNOTE_MUTE){
	Str	BGA_ADDNOTE_STR;	//�Ԃ蕶����
	Int	BGA_ADDVEL		//���Z������
	Int	BGA_ADDGAT		//���Z�Q�[�g

	If(BG_FINGER(BGA_ADDNOTE_NUMBER)==-1){BGA_ADDNOTE_STR={r};}
	Else{
		BGA_ADDVEL=BGA_VEL+BG_STRINGS(BGA_ADDNOTE_NUMBER)
		BGA_ADDGAT=BGA_GAT
		
		If(BGA_ADDNOTE_MUTE==on){
			BGA_ADDVEL=BGA_ADDVEL+BG_ARPEGGIO_MUTE_VELOCITY;
			BGA_ADDGAT=BGA_ADDGAT+BG_ARPEGGIO_MUTE_GATE
		}

		BGA_ADDNOTE_STR={"v("}+BGA_ADDVEL+{")q("}+BGA_ADDGAT+{")n("}+( BG_KEY+BG_OPEN(BGA_ADDNOTE_NUMBER)+BG_FINGER(BGA_ADDNOTE_NUMBER) )+{"),"};

	}
	Result=BGA_ADDNOTE_STR;
}
//----------------------------------------------------------------------------------------------
//_���Y���X�g���[�N
/*
	BGR{������}
		������̒��ɂ�bwb_guitar.h���L��MML���g����B
		�ȉ��ɂ��̃R�}���h�ƕ��@�����߂��B

	�R�}���h
		A�F�S���_�E���X�g���[�N
		S�F�S���A�b�v�X�g���[�N
		Z�F�ቹ����{���_�E���X�g���[�N
		X�F�ቹ����{���A�b�v�X�g���[�N
		Q�F��������{���_�E���X�g���[�N
		W�F��������{���A�b�v�X�g���[�N
		a�F�S���_�E���X�g���[�N�i��߁j
		s�F�S���A�b�v�X�g���[�N�i��߁j
		z�F�ቹ����{���_�E���X�g���[�N�i��߁j
		x�F�ቹ����{���A�b�v�X�g���[�N�i��߁j
		q�F��������{���_�E���X�g���[�N�i��߁j
		w�F��������{���A�b�v�X�g���[�N�i��߁j
		r�F�x��
		^�F�^�C
		<�F�A���y�W�I�R�}���h���̓��[�h����ꎞ�I�ɔ����o��
		>�F�A���y�W�I�R�}���h���̓��[�h�ɖ߂� 


	���@�Ɋւ�����e
	Q:	�ቹ����{�Ƃ����̂͂ǂ��������Ƃł����H
	A:	�����Ⴂ�����猷���{�I�ԂƂ������Ƃł��B
		�Ⴆ�΁A�U�����珇�Ԃ�(1,3,1,1,1,1)�Ƃ����R�[�h�t�H�[���ł���΁A
		�U���ƂT����e�����ƂɂȂ�܂��B
		�܂��A�~���[�g���ꂽ��������ꍇ�A����̓J�E���g���܂���B
		�Ⴆ�΁A�U�����珇�Ԃ�(2,M,1,2,1,M)�Ƃ����R�[�h�t�H�[���ł���΁A
		�T�����~���[�g����Ă邽�߁A�J�E���g�����A
		�U���ƂS���݂̂�e�����ƂɂȂ�܂��B
		��������{�Ƃ����͓̂��l�̍�Ƃ������������̌����{�I�Ԃ��ƂɂȂ�܂��B
	
*/
Function BGR(Str BGR_STR){
	//���[�J���ϐ��錾
	Int	BGR_MML_VEL=MML(v);	//�f�t�H���g�x���V�e�B�擾
	Int	BGR_MML_TIM=MML(t);	//�f�t�H���g�^�C�~���O�擾
	Int	BGR_MML_GAT=MML(q);	//�f�t�H���g�Q�[�g�擾
	Str	BGR_RUN;			//���s������
	Int	BGR_MODE=0;			//�ǂݍ��݃��[�h
	
	Int	BGR_LO			//�Œቹ���̔ԍ�
	Int	BGR_HI			//�ō������̔ԍ�
	For(Int BGR_I=0;BGR_I<6;BGR_I++){	If(BG_FINGER(BGR_I)!=-1){BGR_LO=BGR_I;BGR_I=100;}	}
	For(Int BGR_I=5;BGR_I>-1;BGR_I--){	If(BG_FINGER(BGR_I)!=-1){BGR_HI=BGR_I;BGR_I=-10;}	}

	//�����񏈗�
	For(Int BGR_I=1;BGR_I<=SizeOf(BGR_STR);BGR_I++){
		Switch(BGR_MODE){
			Case(0){
				Switch(MID(BGR_STR,BGR_I,1)){
					Case({A}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,+1,0);}	//Mute,UD(1:D -1:U),Mode
					Case({S}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,-1,0);}	//	0:All 1:Lo 2:Hi
					Case({Z}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,+1,1);}
					Case({X}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,-1,1);}
					Case({Q}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,+1,2);}
					Case({W}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(off,-1,2);}
					Case({a}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,+1,0);}
					Case({s}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,-1,0);}
					Case({z}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,+1,1);}
					Case({x}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,-1,1);}
					Case({q}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,+1,2);}
					Case({w}){BGR_RUN=BGR_RUN+BGR_ADDNOTE(on ,-1,2);}
					Case({r}){BGR_RUN=BGR_RUN+{"r"};}
					Case({^}){BGR_RUN=BGR_RUN+{"^"};}
					Case({<}){BGR_MODE=1;}
					Default{BGR_RUN=BGR_RUN+MID(BGR_STR,BGR_I,1);}
				}
			}
			Case(1){
				If(MID(BGR_STR,BGR_I,1)=={>}){BGR_MODE=0;}
				Else{BGR_RUN=BGR_RUN+MID(BGR_STR,BGR_I,1);}
			}
		}
	}
	//���s�����񐶐�
	BGR_RUN=BGR_RUN+{";v("}+BGR_MML_VEL+{");q("}+BGR_MML_GAT+{");t("}+BGR_MML_TIM+{");"}

	//���s�@BG_PRINT==on�̎��A�\�������˂�
	If(BG_PRINT==on){Print(BGR_RUN);}
	BGR_RUN;
}

Function BGR_ADDNOTE(Int BGR_ADDNOTE_MUTE,Int BGR_ADDNOTE_UD,Int BGR_ADDNOTE_MODE){
	Str	BGR_ADDNOTE_STR;
	Int	BGR_TEMP=0;

	BGR_ADDNOTE_STR=CHR(39)

	Switch(BGR_ADDNOTE_MODE){
		Case(0){
			Switch(BGR_ADDNOTE_UD){
				Case(1){
					For(Int BGR_I=BGR_LO;BGR_I<=BGR_HI;BGR_I++){
						If(BG_FINGER(BGR_I)!=-1){
							BGR_TEMP=BG_TOUCHANDGO(BGR_HI-BGR_LO,BGR_I,BGR_LO,BGR_HI,BGR_ADDNOTE_UD)
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BGR_TEMP+BG_VELOCITY_MOMENTUM*(BGR_I-BGR_LO) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_I-BGR_LO)) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_I)+BG_FINGER(BGR_I) )+{");"};
						}Else{
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};
						}
					}
				}//Case(1)
				Case(-1){
					For(Int BGR_I=BGR_HI;BGR_I>=BGR_LO;BGR_I--){
						If(BG_FINGER(BGR_I)!=-1){
							BGR_TEMP=BG_TOUCHANDGO(BGR_HI-BGR_LO,BGR_I,BGR_HI,BGR_LO,BGR_ADDNOTE_UD)
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BGR_TEMP+BG_VELOCITY_MOMENTUM*(BGR_HI-BGR_I) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_HI-BGR_I)) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_I)+BG_FINGER(BGR_I) )+{");"};
						}Else{
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};
						}
					}
				}//Case(-1)
		}}
		Case(1){
			Switch(BGR_ADDNOTE_UD){
				Case(1){
					For(Int BGR_I=BGR_LO;BGR_TEMP<2;;BGR_I++){
						If(BG_FINGER(BGR_I)!=-1){
							If(BGR_TEMP==0){
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_FIRST+ BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BG_VELOCITY_MOMENTUM*(BGR_I-BGR_LO) )+{");"};
							}
							If(BGR_TEMP==1){
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_LAST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BG_VELOCITY_MOMENTUM*(BGR_I-BGR_LO) )+{");"};
							}
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_I-BGR_LO)) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_I)+BG_FINGER(BGR_I) )+{");"};
							BGR_TEMP++;		//�炷�񐔂̃R���g���[���i�Q��܂Łj
						}Else{
						BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};
						}
					}
				}
				Case(-1){
					For(Int BGR_I=BGR_LO+1;BGR_I<=BGR_HI;BGR_I++){
						If(BG_FINGER(BGR_I)!=-1){BGR_TEMP=BGR_I;BGR_I=BGR_HI+1;}	//�Q���ڂ̌��ԍ��̃R���g���[��
					}
					//�P���ڂ̍�����
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_FIRST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_TEMP) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_TEMP)+BG_FINGER(BGR_TEMP) )+{");"};
					//�ԂɃ~���[�g������̂��l��
					For(Int BGR_I=FRM+1;BGR_I<BGR_TEMP;BGR_I++){BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};}
					//�Q���ڂ̒Ⴂ��
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_LAST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_LO)+BG_VELOCITY_MOMENTUM*(BGR_TEMP-BGR_LO) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_TEMP-BGR_LO)) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_LO)+BG_FINGER(BGR_LO) )+{");"};
				}
			}
		}
		Case(2){
			Switch(BGR_ADDNOTE_UD){
				Case(1){
					For(Int BGR_I=BGR_HI-1;BGR_I>=BGR_LO;BGR_I--){
						If(BG_FINGER(BGR_I)!=-1){BGR_TEMP=BGR_I;BGR_I=BGR_LO-1;}	//�Q���ڂ̌��ԍ��̃R���g���[��
					}
					//�P���ڂ̒Ⴂ��
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_FIRST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_TEMP) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_TEMP)+BG_FINGER(BGR_TEMP) )+{");"};
					//�ԂɃ~���[�g������̂��l��
					For(Int BGR_I=FRM+1;BGR_I<BGR_TEMP;BGR_I++){BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};}
					//�Q���ڂ̍�����
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_LAST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_HI)+BG_VELOCITY_MOMENTUM*(BGR_HI-BGR_TEMP) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_HI-BGR_TEMP)) )+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
					BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_HI)+BG_FINGER(BGR_HI) )+{");"};
				}
				Case(-1){
					For(Int BGR_I=BGR_HI;BGR_TEMP<2;;BGR_I--){
						If(BG_FINGER(BGR_I)!=-1){
							If(BGR_TEMP==0){
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_FIRST+ BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BG_VELOCITY_MOMENTUM*(BGR_HI-BGR_I) )+{");"};
							}
							If(BGR_TEMP==1){
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"v("}+( BGR_MML_VEL + BG_VELOCITY_LAST + BG_RHYTHM_MUTE_VELOCITY*BGR_ADDNOTE_MUTE+BG_STRINGS(BGR_I)+BG_VELOCITY_MOMENTUM*(BGR_HI-BGR_I) )+{");"};
							}
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"t("}+( BGR_MML_TIM + (BG_LAG*(BGR_HI-BGR_I)) )+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"q("}+( BGR_MML_GAT + BG_RHYTHM_MUTE_GATE*BGR_ADDNOTE_MUTE)+{");"};
							BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"n("}+( BG_KEY+BG_OPEN(BGR_I)+BG_FINGER(BGR_I) )+{");"};
							BGR_TEMP++;		//�炷�񐔂̃R���g���[���i�Q��܂Łj
						}Else{
						BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+{"r;"};
						}
					}
				}
			}

		}
	}
	
	BGR_ADDNOTE_STR=BGR_ADDNOTE_STR+CHR(39)
	Result=BGR_ADDNOTE_STR;

}
/*
�|�W�V�����P�F�Œ�t���b�g���O�`�Q��ڈ�
�|�W�V�����Q�F�Œ�t���b�g���O�`�T��ڈ�
�|�W�V�����R�F�t���b�g�̕��ϒl���U��ڈ�
�|�W�V�����S�F�t���b�g�̕��ϒl���X��ڈ�
�|�W�V�����T�F�Œ�t���b�g�������悻�P�O�O���ڈ��@�P�U�͒����Ȃ��B�P�T���������B
*/
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_C
Function GC(Int BG_P){BG_GRASP(BG_P,		00,03,02,00,01,00,	-1,03,05,05,05,03,	08,07,05,05,05,08,	08,10,10,09,08,08,	-1,-1,10,12,13,12	)}
Function GCM7(Int BG_P){BG_GRASP(BG_P,		-1,03,02,00,00,00,	-1,03,05,04,05,03,	-1,-1,05,05,05,07,	08,-1,09,09,08,-1,	-1,-1,10,12,12,12	)}
Function GC7(Int BG_P){BG_GRASP(BG_P,		-1,03,02,03,01,00,	-1,03,05,03,05,03,	-1,-1,05,05,05,06,	08,10,08,09,08,08,	-1,-1,10,12,11,12	)}
Function GC6(Int BG_P){BG_GRASP(BG_P,		-1,03,02,02,01,00,	-1,03,05,05,05,05,	08,-1,07,09,08,-1,	-1,-1,10,09,10,08,	-1,-1,10,12,10,12	)}
Function GCm(Int BG_P){BG_GRASP(BG_P,		-1,03,01,00,01,-1,	-1,03,05,05,04,03,	-1,-1,05,08,08,08,	08,10,10,08,08,08,	-1,-1,10,12,13,11	)}
Function GCm7(Int BG_P){BG_GRASP(BG_P,		-1,03,01,03,01,03,	-1,03,05,03,04,03,	-1,-1,05,05,04,06,	08,10,08,08,08,08,	-1,-1,10,12,11,11	)}
Function GCmM7(Int BG_P){BG_GRASP(BG_P,		-1,03,01,04,-1,-1,	-1,03,05,04,04,03,	-1,-1,05,05,04,07,	08,10,09,08,08,08,	-1,-1,10,12,12,11	)}
Function GCm7b5(Int BG_P){BG_GRASP(BG_P,		-1,03,01,03,01,02,	-1,03,04,03,04,-1,	08,-1,08,08,07,-1,	08,09,08,08,-1,-1,	-1,-1,10,11,11,11	)}
Function GCsus4(Int BG_P){BG_GRASP(BG_P,		-1,03,03,-1,01,01,	-1,03,05,05,06,03,	-1,-1,05,05,06,08,	08,10,10,10,08,08,	-1,-1,10,12,13,13	)}
Function GC7sus4(Int BG_P){BG_GRASP(BG_P,		-1,03,03,03,01,01,	-1,03,05,03,06,03,	-1,-1,05,05,06,06,	08,10,08,10,08,08,	-1,-1,10,12,11,13	)}
Function GCaug(Int BG_P){BG_GRASP(BG_P,		00,03,02,01,01,04,	-1,03,-1,05,05,04,	-1,-1,06,05,05,04,	-1,-1,10,09,09,08,	-1,-1,10,09,09,08	)}
Function GCdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GCM7_9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,04,03,-1,	-1,03,05,04,03,03,	-1,-1,05,07,05,07,	-1,-1,09,09,08,10,	-1,-1,10,12,12,10	)}
Function GC7_9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,03,03,03,	-1,03,05,03,03,03,	-1,-1,05,07,05,06,	-1,-1,08,09,08,10,	-1,-1,10,12,11,10	)}
Function GCadd9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,00,03,00,	-1,03,05,05,03,03,	-1,03,05,05,03,03,	-1,-1,10,09,08,10,	-1,-1,10,12,13,10	)}
Function GCm7_9(Int BG_P){BG_GRASP(BG_P,		-1,03,01,03,03,-1,	-1,03,05,03,03,03,	-1,-1,05,07,04,06,	08,10,08,08,08,10,	-1,-1,10,12,11,10	)}
Function GC7_b9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,03,02,-1,	-1,03,02,03,02,-1,	-1,-1,05,06,05,06,	-1,-1,10,09,11,09,	-1,-1,10,12,11,09	)}
Function GC7_p9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,03,04,-1,	-1,03,02,03,04,-1,	-1,03,02,03,04,-1,	-1,-1,10,09,11,11,	-1,-1,10,09,11,11	)}
Function GCM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,03,02,04,03,02,	-1,03,02,04,03,02,	08,-1,-1,07,07,07,	-1,-1,10,11,12,10,	-1,-1,10,11,12,10	)}
Function GCm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,03,01,03,03,01,	-1,03,05,07,06,-1,	08,-1,08,08,06,-1,	-1,-1,10,12,11,13,	-1,-1,10,12,11,13	)}
Function GC6_9(Int BG_P){BG_GRASP(BG_P,		-1,03,02,02,03,03,	-1,03,02,02,03,03,	08,-1,07,07,08,08,	-1,-1,10,12,10,10,	-1,-1,10,12,10,10	)}
Function GC7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,03,02,03,03,05,	-1,03,05,03,03,05,	08,10,08,09,10,08,	08,10,08,09,10,08,	-1,-1,10,09,10,10	)}
Function GC7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,03,02,03,03,04,	-1,03,05,03,03,04,	08,-1,08,09,09,-1,	-1,-1,10,09,09,10,	-1,-1,10,09,09,10	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_C#
Function GCp(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,02,01,	-1,04,06,06,06,04,	09,08,06,06,06,09,	09,11,11,10,09,09,	-1,-1,11,13,14,13	)}
Function GCpM7(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,01,01,	-1,04,06,05,06,04,	-1,-1,06,06,06,08,	09,-1,10,10,09,-1,	-1,-1,11,13,13,13	)}
Function GCp7(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,02,-1,	-1,04,06,04,06,04,	-1,-1,06,06,06,07,	09,11,09,10,09,09,	-1,-1,11,13,12,13	)}
Function GCp6(Int BG_P){BG_GRASP(BG_P,		-1,04,03,03,02,-1,	-1,04,06,06,06,06,	09,-1,08,10,09,-1,	-1,-1,11,10,11,09,	-1,-1,11,13,11,13	)}
Function GCpm(Int BG_P){BG_GRASP(BG_P,		-1,04,02,01,02,-1,	-1,04,06,06,05,04,	-1,-1,06,09,09,09,	09,11,11,09,09,09,	-1,-1,11,13,14,12	)}
Function GCpm7(Int BG_P){BG_GRASP(BG_P,		-1,04,02,04,02,04,	-1,04,06,04,05,04,	-1,-1,06,06,05,07,	09,11,09,09,09,09,	-1,-1,11,13,12,12	)}
Function GCpmM7(Int BG_P){BG_GRASP(BG_P,		-1,04,02,05,-1,-1,	-1,04,06,05,05,04,	-1,-1,06,06,05,08,	09,11,10,09,09,09,	-1,-1,11,13,13,12	)}
Function GCpm7b5(Int BG_P){BG_GRASP(BG_P,		00,04,02,04,02,03,	-1,04,05,04,05,-1,	09,-1,09,09,08,-1,	09,10,09,09,-1,-1,	-1,-1,11,12,12,12	)}
Function GCpsus4(Int BG_P){BG_GRASP(BG_P,		-1,04,04,-1,02,02,	-1,04,06,06,07,04,	-1,-1,06,06,07,09,	09,11,11,11,09,09,	-1,-1,11,13,14,14	)}
Function GCp7sus4(Int BG_P){BG_GRASP(BG_P,	-1,04,04,04,02,02,	-1,04,06,04,07,04,	-1,-1,06,06,07,07,	09,11,09,11,09,09,	-1,-1,11,13,12,14	)}
Function GCpaug(Int BG_P){BG_GRASP(BG_P,		-1,04,03,02,02,05,	-1,04,-1,06,06,05,	-1,-1,07,06,06,05,	-1,-1,11,10,10,09,	-1,-1,11,10,10,09	)}
Function GCpdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GCpM7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,05,04,-1,	-1,04,06,05,04,04,	-1,-1,06,08,06,08,	-1,-1,10,10,09,11,	-1,-1,11,13,13,11	)}
Function GCp7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,04,04,	-1,04,06,04,04,04,	-1,-1,06,08,06,07,	-1,-1,09,10,09,11,	-1,-1,11,13,12,11	)}
Function GCpadd9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,04,-1,	-1,04,06,06,04,04,	-1,04,06,06,04,04,	-1,-1,11,10,09,11,	-1,-1,11,13,14,11	)}
Function GCpm7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,02,04,04,-1,	-1,04,06,04,04,04,	-1,-1,06,08,05,07,	09,11,09,09,09,11,	-1,-1,11,13,12,11	)}
Function GCp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,03,-1,	-1,04,03,04,03,-1,	-1,-1,06,07,06,07,	-1,-1,11,10,12,10,	-1,-1,11,13,12,10	)}
Function GCp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,05,-1,	-1,04,03,04,05,-1,	-1,04,03,04,05,-1,	-1,-1,11,10,12,12,	-1,-1,11,10,12,12	)}
Function GCpM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,04,03,05,04,03,	-1,04,03,05,04,03,	09,-1,-1,08,08,08,	-1,-1,11,12,13,11,	-1,-1,11,12,13,11	)}
Function GCpm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,04,02,04,04,02,	-1,04,06,08,07,-1,	09,-1,09,09,07,-1,	-1,-1,11,13,12,14,	-1,-1,11,13,12,14	)}
Function GCp6_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,03,04,04,	-1,04,03,03,04,04,	09,-1,08,08,09,09,	-1,-1,11,13,11,11,	-1,-1,11,13,11,11	)}
Function GCp7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,04,03,04,04,06,	-1,04,06,04,04,06,	09,11,09,10,11,09,	09,11,09,10,11,09,	-1,-1,11,10,11,11	)}
Function GCp7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,04,03,04,04,05,	-1,04,06,04,04,05,	09,-1,09,10,10,-1,	-1,-1,11,10,10,11,	-1,-1,11,10,10,11	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Db
Function GDb(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,02,01,	-1,04,06,06,06,04,	09,08,06,06,06,09,	09,11,11,10,09,09,	-1,-1,11,13,14,13	)}
Function GDbM7(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,01,01,	-1,04,06,05,06,04,	-1,-1,06,06,06,08,	09,-1,10,10,09,-1,	-1,-1,11,13,13,13	)}
Function GDb7(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,02,-1,	-1,04,06,04,06,04,	-1,-1,06,06,06,07,	09,11,09,10,09,09,	-1,-1,11,13,12,13	)}
Function GDb6(Int BG_P){BG_GRASP(BG_P,		-1,04,03,03,02,-1,	-1,04,06,06,06,06,	09,-1,08,10,09,-1,	-1,-1,11,10,11,09,	-1,-1,11,13,11,13	)}
Function GDbm(Int BG_P){BG_GRASP(BG_P,		-1,04,02,01,02,-1,	-1,04,06,06,05,04,	-1,-1,06,09,09,09,	09,11,11,09,09,09,	-1,-1,11,13,14,12	)}
Function GDbm7(Int BG_P){BG_GRASP(BG_P,		-1,04,02,04,02,04,	-1,04,06,04,05,04,	-1,-1,06,06,05,07,	09,11,09,09,09,09,	-1,-1,11,13,12,12	)}
Function GDbmM7(Int BG_P){BG_GRASP(BG_P,		-1,04,02,05,-1,-1,	-1,04,06,05,05,04,	-1,-1,06,06,05,08,	09,11,10,09,09,09,	-1,-1,11,13,13,12	)}
Function GDbm7b5(Int BG_P){BG_GRASP(BG_P,		00,04,02,04,02,03,	-1,04,05,04,05,-1,	09,-1,09,09,08,-1,	09,10,09,09,-1,-1,	-1,-1,11,12,12,12	)}
Function GDbsus4(Int BG_P){BG_GRASP(BG_P,		-1,04,04,-1,02,02,	-1,04,06,06,07,04,	-1,-1,06,06,07,09,	09,11,11,11,09,09,	-1,-1,11,13,14,14	)}
Function GDb7sus4(Int BG_P){BG_GRASP(BG_P,	-1,04,04,04,02,02,	-1,04,06,04,07,04,	-1,-1,06,06,07,07,	09,11,09,11,09,09,	-1,-1,11,13,12,14	)}
Function GDbaug(Int BG_P){BG_GRASP(BG_P,		-1,04,03,02,02,05,	-1,04,-1,06,06,05,	-1,-1,07,06,06,05,	-1,-1,11,10,10,09,	-1,-1,11,10,10,09	)}
Function GDbdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GDbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,05,04,-1,	-1,04,06,05,04,04,	-1,-1,06,08,06,08,	-1,-1,10,10,09,11,	-1,-1,11,13,13,11	)}
Function GDb7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,04,04,	-1,04,06,04,04,04,	-1,-1,06,08,06,07,	-1,-1,09,10,09,11,	-1,-1,11,13,12,11	)}
Function GDbadd9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,01,04,-1,	-1,04,06,06,04,04,	-1,04,06,06,04,04,	-1,-1,11,10,09,11,	-1,-1,11,13,14,11	)}
Function GDbm7_9(Int BG_P){BG_GRASP(BG_P,		-1,04,02,04,04,-1,	-1,04,06,04,04,04,	-1,-1,06,08,05,07,	09,11,09,09,09,11,	-1,-1,11,13,12,11	)}
Function GDb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,03,-1,	-1,04,03,04,03,-1,	-1,-1,06,07,06,07,	-1,-1,11,10,12,10,	-1,-1,11,13,12,10	)}
Function GDb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,04,05,-1,	-1,04,03,04,05,-1,	-1,04,03,04,05,-1,	-1,-1,11,10,12,12,	-1,-1,11,10,12,12	)}
Function GDbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,04,03,05,04,03,	-1,04,03,05,04,03,	09,-1,-1,08,08,08,	-1,-1,11,12,13,11,	-1,-1,11,12,13,11	)}
Function GDbm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,04,02,04,04,02,	-1,04,06,08,07,-1,	09,-1,09,09,07,-1,	-1,-1,11,13,12,14,	-1,-1,11,13,12,14	)}
Function GDb6_9(Int BG_P){BG_GRASP(BG_P,		-1,04,03,03,04,04,	-1,04,03,03,04,04,	09,-1,08,08,09,09,	-1,-1,11,13,11,11,	-1,-1,11,13,11,11	)}
Function GDb7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,04,03,04,04,06,	-1,04,06,04,04,06,	09,11,09,10,11,09,	09,11,09,10,11,09,	-1,-1,11,10,11,11	)}
Function GDb7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,04,03,04,04,05,	-1,04,06,04,04,05,	09,-1,09,10,10,-1,	-1,-1,11,10,10,11,	-1,-1,11,10,10,11	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_D
Function GD(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,03,02,	-1,05,04,02,03,02,	-1,05,07,07,07,05,	10,09,07,07,07,10,	10,12,12,11,10,10	)}
Function GDM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,02,02,	-1,05,04,02,02,02,	-1,05,07,06,07,05,	-1,-1,07,07,07,09,	10,-1,11,11,10,-1	)}
Function GD7(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,02,	-1,05,04,05,03,-1,	-1,05,07,05,07,05,	-1,-1,07,07,07,08,	10,12,10,11,10,10	)}
Function GD6(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,00,02,	-1,05,04,04,03,-1,	-1,05,07,07,07,07,	10,-1,09,11,10,-1,	-1,-1,12,11,12,10	)}
Function GDm(Int BG_P){BG_GRASP(BG_P,		-1,00,00,02,03,01,	-1,05,03,02,03,-1,	-1,05,07,07,06,05,	-1,-1,07,10,10,10,	10,12,12,10,10,10	)}
Function GDm7(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,01,	-1,05,03,05,03,05,	-1,05,07,05,06,05,	-1,-1,07,07,06,08,	10,12,10,10,10,10	)}
Function GDmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,02,01,	-1,05,03,06,-1,-1,	-1,05,07,06,06,05,	-1,-1,07,07,06,09,	10,12,11,10,10,10	)}
Function GDm7b5(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,01,01,01,	-1,05,03,05,03,04,	-1,05,06,05,06,-1,	10,-1,10,10,09,-1,	10,11,10,10,-1,-1	)}
Function GDsus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,03,03,	-1,05,05,-1,03,03,	-1,05,07,07,08,05,	-1,-1,07,07,08,10,	10,12,12,12,10,10	)}
Function GD7sus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,03,	-1,05,05,05,03,03,	-1,05,07,05,08,05,	-1,-1,07,07,08,08,	10,12,10,12,10,10	)}
Function GDaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,03,03,02,	-1,05,04,03,03,06,	-1,05,-1,07,07,06,	-1,-1,08,07,07,06,	-1,-1,12,15,15,14	)}
Function GDdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GDM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,02,00,	-1,05,04,06,05,-1,	-1,05,07,06,05,05,	-1,-1,07,09,07,09,	-1,-1,11,11,10,12	)}
Function GD7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,00,	-1,05,04,05,05,05,	-1,05,07,05,05,05,	-1,-1,07,09,07,08,	-1,-1,10,11,10,12	)}
Function GDadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,03,00,	-1,05,04,02,05,-1,	-1,05,07,07,05,05,	-1,05,07,07,07,05,	-1,-1,12,11,10,12	)}
Function GDm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,01,00,	-1,05,03,05,05,05,	-1,-1,07,09,06,08,	10,12,10,10,10,12,	-1,-1,12,10,13,12	)}
Function GD7_b9(Int BG_P){BG_GRASP(BG_P,		-1,05,04,05,04,-1,	-1,05,04,05,04,-1,	-1,05,04,05,04,-1,	-1,-1,07,08,07,08,	-1,-1,12,11,13,11	)}
Function GD7_p9(Int BG_P){BG_GRASP(BG_P,		-1,05,04,05,06,-1,	-1,05,04,05,06,-1,	-1,05,04,05,06,-1,	-1,-1,12,11,13,13,	-1,-1,12,11,13,13	)}
Function GDM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,00,01,02,00,	-1,05,04,06,05,04,	-1,05,04,06,05,04,	10,-1,-1,09,09,09,	10,-1,-1,09,09,09	)}
Function GDm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,00,02,01,03,	-1,05,03,05,05,03,	-1,05,07,09,08,-1,	10,-1,10,10,08,-1,	-1,-1,10,10,08,10	)}
Function GD6_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,00,00,	-1,05,04,04,05,05,	-1,05,04,04,05,05,	10,-1,09,09,10,10,	10,-1,09,09,10,10	)}
Function GD7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,05,04,05,05,07,	-1,05,04,05,05,07,	-1,05,07,05,05,07,	10,12,10,11,12,10,	-1,-1,12,11,12,12	)}
Function GD7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,05,04,05,05,06,	-1,05,04,05,05,06,	-1,05,07,05,05,06,	10,-1,10,11,11,-1,	-1,-1,12,11,11,12	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_D#
Function GDp(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,03,	-1,06,05,03,04,03,	-1,06,08,08,08,06,	11,10,08,08,08,11,	11,13,13,12,11,11	)}
Function GDpM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,03,	-1,06,05,03,03,03,	-1,06,08,07,08,06,	-1,-1,08,08,08,10,	11,-1,12,12,11,-1	)}
Function GDp7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,03,	-1,06,05,06,04,-1,	-1,06,08,06,08,06,	-1,-1,08,08,08,09,	11,13,11,12,11,11	)}
Function GDp6(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,03,	-1,06,05,05,04,-1,	-1,06,08,08,08,08,	11,-1,10,12,11,-1,	-1,-1,13,12,13,11	)}
Function GDpm(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,02,	-1,06,04,03,04,-1,	-1,06,08,08,07,06,	-1,-1,08,11,11,11,	11,13,13,11,11,11	)}
Function GDpm7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,02,	-1,06,04,06,04,06,	-1,06,08,06,07,06,	-1,-1,08,08,07,09,	11,13,11,11,11,11	)}
Function GDpmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,02,	-1,06,04,07,-1,-1,	-1,06,08,07,07,06,	-1,-1,08,08,07,10,	11,13,12,11,11,11	)}
Function GDpm7b5(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,02,02,	-1,06,04,06,04,05,	-1,06,07,06,07,-1,	11,-1,11,11,10,-1,	11,12,11,11,-1,-1	)}
Function GDpsus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,04,	-1,06,06,-1,04,04,	-1,06,08,08,09,06,	-1,-1,08,08,09,11,	11,13,13,13,11,11	)}
Function GDp7sus4(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,03,02,04,	-1,06,06,06,04,04,	-1,06,08,06,09,06,	-1,-1,08,08,09,09,	11,13,11,13,11,11	)}
Function GDpaug(Int BG_P){BG_GRASP(BG_P,		03,02,01,00,00,03,	-1,06,05,04,04,07,	-1,06,-1,08,08,07,	-1,-1,09,08,08,07,	-1,14,13,12,12,15	)}
Function GDpdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GDpM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,01,	-1,06,05,07,06,-1,	-1,06,08,07,06,06,	-1,-1,08,10,08,10,	-1,-1,12,12,11,13	)}
Function GDp7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,01,	-1,06,05,06,06,06,	-1,06,08,06,06,06,	-1,-1,08,10,08,09,	-1,-1,11,12,11,13	)}
Function GDpadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,01,	-1,06,05,03,06,-1,	-1,06,08,08,06,06,	-1,06,08,08,06,06,	-1,-1,13,12,11,13	)}
Function GDpm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,01,	-1,06,04,06,06,-1,	-1,06,08,06,06,06,	-1,-1,08,10,07,09,	-1,-1,13,11,14,13	)}
Function GDp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,06,05,06,05,-1,	-1,06,05,06,05,-1,	-1,06,05,06,05,-1,	-1,-1,08,09,08,09,	-1,-1,13,12,14,12	)}
Function GDp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,06,05,06,07,-1,	-1,06,05,06,07,-1,	-1,06,05,06,07,-1,	-1,-1,13,12,14,14,	-1,-1,13,12,14,14	)}
Function GDpM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,02,03,01,	-1,-1,01,02,03,01,	-1,06,05,07,06,05,	11,-1,-1,10,10,10,	11,-1,-1,10,10,10	)}
Function GDpm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,03,02,04,	-1,-1,01,03,02,04,	-1,06,04,06,06,04,	-1,06,08,10,09,-1,	-1,-1,11,11,09,11	)}
Function GDp6_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,01,	-1,-1,01,03,01,01,	-1,06,05,05,06,06,	11,-1,10,10,11,11,	11,-1,10,10,11,11	)}
Function GDp7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,00,01,01,	-1,-1,01,00,01,01,	-1,06,05,06,06,08,	-1,06,08,06,06,08,	-1,06,08,06,06,08	)}
Function GDp7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,00,00,01,	-1,-1,01,00,00,01,	-1,06,05,06,06,07,	-1,06,08,06,06,07,	11,-1,11,12,12,-1	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Eb
Function GEb(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,03,	-1,06,05,03,04,03,	-1,06,08,08,08,06,	11,10,08,08,08,11,	11,13,13,12,11,11	)}
Function GEbM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,03,	-1,06,05,03,03,03,	-1,06,08,07,08,06,	-1,-1,08,08,08,10,	11,-1,12,12,11,-1	)}
Function GEb7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,03,	-1,06,05,06,04,-1,	-1,06,08,06,08,06,	-1,-1,08,08,08,09,	11,13,11,12,11,11	)}
Function GEb6(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,03,	-1,06,05,05,04,-1,	-1,06,08,08,08,08,	11,-1,10,12,11,-1,	-1,-1,13,12,13,11	)}
Function GEbm(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,02,	-1,06,04,03,04,-1,	-1,06,08,08,07,06,	-1,-1,08,11,11,11,	11,13,13,11,11,11	)}
Function GEbm7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,02,	-1,06,04,06,04,06,	-1,06,08,06,07,06,	-1,-1,08,08,07,09,	11,13,11,11,11,11	)}
Function GEbmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,02,	-1,06,04,07,-1,-1,	-1,06,08,07,07,06,	-1,-1,08,08,07,10,	11,13,12,11,11,11	)}
Function GEbm7b5(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,02,02,	-1,06,04,06,04,05,	-1,06,07,06,07,-1,	11,-1,11,11,10,-1,	11,12,11,11,-1,-1	)}
Function GEbsus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,04,	-1,06,06,-1,04,04,	-1,06,08,08,09,06,	-1,-1,08,08,09,11,	11,13,13,13,11,11	)}
Function GEb7sus4(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,03,02,04,	-1,06,06,06,04,04,	-1,06,08,06,09,06,	-1,-1,08,08,09,09,	11,13,11,13,11,11	)}
Function GEbaug(Int BG_P){BG_GRASP(BG_P,		03,02,01,00,00,03,	-1,06,05,04,04,07,	-1,06,-1,08,08,07,	-1,-1,09,08,08,07,	-1,14,13,12,12,15	)}
Function GEbdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GEbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,03,01,	-1,06,05,07,06,-1,	-1,06,08,07,06,06,	-1,-1,08,10,08,10,	-1,-1,12,12,11,13	)}
Function GEb7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,01,	-1,06,05,06,06,06,	-1,06,08,06,06,06,	-1,-1,08,10,08,09,	-1,-1,11,12,11,13	)}
Function GEbadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,04,01,	-1,06,05,03,06,-1,	-1,06,08,08,06,06,	-1,06,08,08,06,06,	-1,-1,13,12,11,13	)}
Function GEbm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,02,01,	-1,06,04,06,06,-1,	-1,06,08,06,06,06,	-1,-1,08,10,07,09,	-1,-1,13,11,14,13	)}
Function GEb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,06,05,06,05,-1,	-1,06,05,06,05,-1,	-1,06,05,06,05,-1,	-1,-1,08,09,08,09,	-1,-1,13,12,14,12	)}
Function GEb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,06,05,06,07,-1,	-1,06,05,06,07,-1,	-1,06,05,06,07,-1,	-1,-1,13,12,14,14,	-1,-1,13,12,14,14	)}
Function GEbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,02,03,01,	-1,-1,01,02,03,01,	-1,06,05,07,06,05,	11,-1,-1,10,10,10,	11,-1,-1,10,10,10	)}
Function GEbm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,03,02,04,	-1,-1,01,03,02,04,	-1,06,04,06,06,04,	-1,06,08,10,09,-1,	-1,-1,11,11,09,11	)}
Function GEb6_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,01,	-1,-1,01,03,01,01,	-1,06,05,05,06,06,	11,-1,10,10,11,11,	11,-1,10,10,11,11	)}
Function GEb7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,00,01,01,	-1,-1,01,00,01,01,	-1,06,05,06,06,08,	-1,06,08,06,06,08,	-1,06,08,06,06,08	)}
Function GEb7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,00,00,01,	-1,-1,01,00,00,01,	-1,06,05,06,06,07,	-1,06,08,06,06,07,	11,-1,11,12,12,-1	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_E
Function GE(Int BG_P){BG_GRASP(BG_P,		00,02,02,01,00,00,	-1,-1,02,04,05,04,	-1,07,06,04,05,04,	-1,07,09,09,09,07,	12,11,09,09,09,12	)}
Function GEM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,04,04,04,	-1,07,06,04,04,04,	-1,07,09,08,09,07,	-1,-1,09,09,09,11,	12,-1,13,13,12,-1	)}
Function GE7(Int BG_P){BG_GRASP(BG_P,		00,02,00,01,00,00,	-1,-1,02,04,03,04,	-1,07,06,07,05,-1,	-1,07,09,07,09,07,	-1,-1,09,09,09,10	)}
Function GE6(Int BG_P){BG_GRASP(BG_P,		00,02,02,01,02,00,	-1,-1,02,04,02,04,	-1,07,06,06,05,-1,	-1,07,09,09,09,09,	12,-1,11,13,12,-1	)}
Function GEm(Int BG_P){BG_GRASP(BG_P,		00,02,02,00,00,00,	-1,-1,02,04,05,03,	-1,07,05,04,05,-1,	-1,07,09,09,08,07,	-1,-1,09,12,12,12	)}
Function GEm7(Int BG_P){BG_GRASP(BG_P,		00,02,00,00,00,00,	-1,-1,02,04,03,03,	-1,07,05,07,05,07,	-1,07,09,07,08,07,	-1,-1,09,09,08,10	)}
Function GEmM7(Int BG_P){BG_GRASP(BG_P,		00,02,01,00,00,00,	-1,-1,02,04,04,03,	-1,07,05,08,-1,-1,	-1,07,09,08,08,07,	-1,-1,09,09,08,11	)}
Function GEm7b5(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,03,03,03,	-1,07,05,07,05,06,	-1,07,08,07,08,-1,	12,-1,12,12,11,-1,	12,-1,12,12,11,-1	)}
Function GEsus4(Int BG_P){BG_GRASP(BG_P,		00,02,02,02,00,00,	-1,-1,02,04,05,05,	-1,07,07,-1,05,05,	-1,07,09,09,10,07,	-1,-1,09,09,10,12	)}
Function GE7sus4(Int BG_P){BG_GRASP(BG_P,		00,02,00,02,00,00,	-1,-1,02,04,03,05,	-1,07,07,07,05,05,	-1,07,09,07,10,07,	-1,-1,09,09,10,10	)}
Function GEaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,01,01,00,	00,03,02,01,01,04,	00,07,06,05,05,08,	-1,07,-1,09,09,08,	-1,-1,14,13,13,12	)}
Function GEdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GEM7_9(Int BG_P){BG_GRASP(BG_P,		00,02,01,01,00,02,	-1,-1,02,04,04,02,	-1,07,06,08,07,-1,	-1,07,09,08,07,07,	-1,-1,09,11,09,11	)}
Function GE7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,04,03,02,	-1,-1,02,04,05,02,	-1,07,06,04,07,-1,	-1,07,09,09,07,07,	-1,07,09,09,07,07	)}
Function GEadd9(Int BG_P){BG_GRASP(BG_P,		00,02,02,01,00,02,	-1,06,05,03,06,-1,	-1,06,08,06,06,06,	-1,-1,08,10,07,09,	-1,-1,13,12,11,13	)}
Function GEm7_9(Int BG_P){BG_GRASP(BG_P,		00,02,00,00,00,02,	-1,-1,02,04,03,02,	-1,07,05,07,07,-1,	-1,07,09,07,07,07,	-1,-1,09,11,08,10	)}
Function GE7_b9(Int BG_P){BG_GRASP(BG_P,		-1,07,06,07,06,-1,	-1,-1,07,06,07,06,	-1,-1,07,06,07,06,	-1,-1,09,10,09,10,	-1,-1,12,11,13,11	)}
Function GE7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,01,03,03,	-1,-1,02,01,03,03,	-1,07,06,07,08,-1,	-1,07,06,07,08,-1,	-1,07,06,07,08,-1	)}
Function GEM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,02,03,04,02,	-1,-1,02,03,04,02,	-1,07,06,08,07,06,	-1,07,06,08,07,06,	12,-1,-1,11,11,11	)}
Function GEm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,02,04,03,05,	-1,-1,02,04,03,05,	-1,07,05,07,07,05,	-1,07,09,11,10,-1,	-1,-1,12,12,10,12	)}
Function GE6_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,04,02,02,	-1,-1,02,04,02,02,	-1,07,06,06,07,07,	-1,07,06,06,07,07,	12,-1,11,11,12,12	)}
Function GE7_9_13(Int BG_P){BG_GRASP(BG_P,	00,02,00,01,02,00,	-1,-1,02,01,02,02,	-1,07,06,07,07,09,	-1,07,09,07,07,09,	-1,07,09,07,07,09	)}
Function GE7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,-1,02,01,01,02,	-1,-1,02,01,01,02,	-1,07,06,07,07,08,	-1,07,09,07,07,08,	12,-1,12,13,13,-1	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_F
Function GF(Int BG_P){BG_GRASP(BG_P,		01,03,03,02,01,01,	-1,-1,03,05,06,05,	-1,08,07,05,06,05,	-1,08,10,10,10,08,	13,12,10,10,10,13	)}
Function GFM7(Int BG_P){BG_GRASP(BG_P,		01,-1,02,02,01,-1,	-1,-1,03,05,05,05,	-1,08,07,05,05,05,	-1,08,10,09,10,08,	-1,-1,10,10,10,12	)}
Function GF7(Int BG_P){BG_GRASP(BG_P,		01,03,01,02,01,01,	-1,-1,03,05,04,05,	-1,08,07,08,06,-1,	-1,08,10,08,10,08,	-1,-1,10,10,10,11	)}
Function GF6(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,03,01,	-1,-1,03,05,03,05,	-1,08,07,07,06,-1,	-1,08,10,10,10,10,	13,-1,12,14,13,-1	)}
Function GFm(Int BG_P){BG_GRASP(BG_P,		01,03,03,01,01,01,	-1,-1,03,05,06,04,	-1,08,06,05,06,-1,	-1,08,10,10,09,08,	-1,-1,10,13,13,13	)}
Function GFm7(Int BG_P){BG_GRASP(BG_P,		01,03,01,01,01,01,	-1,-1,03,05,04,04,	-1,08,06,08,06,08,	-1,08,10,08,09,08,	-1,-1,10,10,09,11	)}
Function GFmM7(Int BG_P){BG_GRASP(BG_P,		01,03,02,01,01,01,	-1,-1,03,05,05,04,	-1,08,06,09,-1,-1,	00,08,10,09,09,08,	-1,-1,10,10,09,12	)}
Function GFm7b5(Int BG_P){BG_GRASP(BG_P,		01,-1,01,01,00,-1,	01,02,01,01,-1,-1,	-1,-1,03,04,04,04,	-1,08,06,08,06,07,	-1,08,09,08,09,-1	)}
Function GFsus4(Int BG_P){BG_GRASP(BG_P,		01,03,03,03,01,01,	-1,-1,03,05,06,06,	-1,08,08,-1,06,06,	-1,08,10,10,11,08,	-1,-1,10,10,11,13	)}
Function GF7sus4(Int BG_P){BG_GRASP(BG_P,		01,03,01,03,01,01,	-1,-1,03,05,04,06,	-1,08,08,08,06,06,	-1,08,10,08,11,08,	-1,-1,10,10,11,11	)}
Function GFaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,02,01,	-1,04,03,02,02,05,	-1,08,07,06,06,09,	-1,08,-1,10,10,09,	-1,08,-1,10,10,09	)}
Function GFdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GFM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,02,01,03,	-1,-1,03,05,05,03,	-1,08,07,09,08,-1,	-1,08,10,09,08,08,	-1,-1,10,12,10,12	)}
Function GF7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,01,03,	-1,-1,03,05,04,03,	-1,08,07,08,08,08,	-1,08,10,08,08,08,	-1,-1,10,12,10,11	)}
Function GFadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,01,03,	-1,-1,03,05,06,03,	-1,08,07,05,08,-1,	-1,08,07,05,08,-1,	-1,08,10,10,08,08	)}
Function GFm7_9(Int BG_P){BG_GRASP(BG_P,		01,03,01,01,01,03,	-1,-1,03,05,04,03,	-1,08,06,08,08,-1,	-1,08,10,08,08,08,	-1,-1,10,12,09,11	)}
Function GF7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,04,02,	-1,-1,03,02,04,02,	-1,08,07,08,07,-1,	-1,08,07,08,07,-1,	-1,-1,10,11,10,11	)}
Function GF7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,02,04,04,	-1,-1,03,02,04,04,	-1,08,07,08,09,-1,	-1,08,07,08,09,-1,	-1,08,07,08,09,-1	)}
Function GFM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,03,04,05,03,	-1,-1,03,04,05,03,	-1,08,07,09,08,07,	-1,08,07,09,08,07,	13,-1,-1,12,12,12	)}
Function GFm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,03,05,04,06,	-1,-1,03,05,04,06,	-1,08,06,08,08,06,	-1,08,10,12,11,-1,	13,-1,13,13,11,-1	)}
Function GF6_9(Int BG_P){BG_GRASP(BG_P,		01,00,00,00,01,01,	-1,-1,03,05,03,03,	-1,08,07,07,08,08,	-1,08,07,07,08,08,	-1,08,07,07,08,08	)}
Function GF7_9_13(Int BG_P){BG_GRASP(BG_P,	01,03,01,02,03,01,	-1,-1,03,02,03,03,	-1,08,07,08,08,10,	-1,08,10,08,08,10,	-1,08,10,08,08,10	)}
Function GF7_9_b13(Int BG_P){BG_GRASP(BG_P,	01,-1,01,02,02,-1,	-1,-1,03,02,02,03,	-1,08,07,08,08,09,	-1,08,10,08,08,09,	-1,08,10,08,08,09	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_F#
Function GFp(Int BG_P){BG_GRASP(BG_P,		02,04,04,03,02,02,	-1,-1,04,06,07,06,	-1,09,08,06,07,06,	-1,09,11,11,11,09,	14,13,11,11,11,14	)}
Function GFpM7(Int BG_P){BG_GRASP(BG_P,		02,-1,03,03,02,-1,	-1,-1,04,06,06,06,	-1,09,08,06,06,06,	-1,09,11,10,11,09,	-1,-1,11,11,11,13	)}
Function GFp7(Int BG_P){BG_GRASP(BG_P,		02,04,02,03,02,02,	-1,-1,04,06,05,06,	-1,09,08,09,07,-1,	-1,09,11,09,11,09,	-1,-1,11,11,11,12	)}
Function GFp6(Int BG_P){BG_GRASP(BG_P,		02,-1,01,03,02,-1,	-1,-1,04,03,04,02,	-1,-1,04,06,04,06,	-1,09,08,08,07,-1,	-1,09,11,11,11,11	)}
Function GFpm(Int BG_P){BG_GRASP(BG_P,		02,04,04,02,02,02,	-1,-1,04,06,07,05,	-1,09,07,06,07,-1,	-1,09,11,11,10,09,	-1,-1,11,14,14,14	)}
Function GFpm7(Int BG_P){BG_GRASP(BG_P,		02,04,02,02,02,02,	-1,-1,04,06,05,05,	-1,09,07,09,07,09,	-1,09,11,09,10,09,	-1,-1,11,11,10,12	)}
Function GFpmM7(Int BG_P){BG_GRASP(BG_P,		02,04,03,02,02,02,	-1,-1,04,06,06,05,	-1,09,07,10,-1,-1,	-1,09,11,10,10,09,	-1,-1,11,11,10,13	)}
Function GFpm7b5(Int BG_P){BG_GRASP(BG_P,		02,-1,02,02,01,-1,	02,03,02,02,-1,-1,	-1,-1,04,05,05,05,	-1,09,07,09,07,08,	-1,09,10,09,10,-1	)}
Function GFpsus4(Int BG_P){BG_GRASP(BG_P,		02,04,04,04,02,02,	-1,-1,04,06,07,07,	-1,09,09,-1,07,07,	-1,09,11,11,12,09,	-1,-1,11,11,12,14	)}
Function GFp7sus4(Int BG_P){BG_GRASP(BG_P,	02,04,02,04,02,02,	-1,-1,04,06,05,07,	-1,09,09,09,07,07,	-1,09,11,09,12,09,	-1,-1,11,11,12,12	)}
Function GFpaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,03,02,	-1,05,04,03,03,06,	-1,09,08,07,07,10,	-1,09,-1,11,11,10,	-1,09,-1,11,11,10	)}
Function GFpdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GFpM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,03,02,04,	-1,-1,04,06,06,04,	-1,09,08,10,09,-1,	-1,09,11,10,09,09,	-1,-1,11,13,11,13	)}
Function GFp7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,03,02,04,	-1,-1,04,06,05,04,	-1,09,08,09,09,09,	-1,09,11,09,09,09,	-1,-1,11,13,11,12	)}
Function GFpadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,02,04,	-1,-1,04,06,07,04,	-1,09,08,06,09,-1,	-1,09,08,06,09,-1,	-1,09,11,11,09,09	)}
Function GFpm7_9(Int BG_P){BG_GRASP(BG_P,		02,04,02,02,02,04,	-1,-1,04,06,05,04,	-1,09,07,09,09,-1,	-1,09,11,09,09,09,	-1,-1,11,13,10,12	)}
Function GFp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,05,03,	-1,-1,04,03,05,03,	-1,09,08,09,08,-1,	-1,09,08,09,08,-1,	-1,-1,11,12,11,12	)}
Function GFp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,05,05,	-1,-1,04,03,05,05,	-1,09,08,09,10,-1,	-1,09,08,09,10,-1,	-1,09,08,09,10,-1	)}
Function GFpM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,04,05,06,04,	-1,-1,04,05,06,04,	-1,09,08,10,09,08,	-1,09,08,10,09,08,	14,-1,-1,13,13,13	)}
Function GFpm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,04,06,05,07,	-1,-1,04,06,05,07,	-1,09,07,09,09,07,	-1,09,11,13,12,-1,	14,-1,14,14,12,-1	)}
Function GFp6_9(Int BG_P){BG_GRASP(BG_P,		02,-1,01,01,02,02,	-1,-1,04,06,04,04,	-1,09,08,08,09,09,	-1,09,08,08,09,09,	-1,09,08,08,09,09	)}
Function GFp7_9_13(Int BG_P){BG_GRASP(BG_P,	02,04,02,03,04,02,	-1,-1,04,03,04,04,	-1,09,08,09,09,11,	-1,09,11,09,09,11,	-1,09,11,09,09,11	)}
Function GFp7_9_b13(Int BG_P){BG_GRASP(BG_P,	02,-1,02,03,03,-1,	-1,-1,04,03,03,04,	-1,09,08,09,09,10,	-1,09,11,09,09,10,	-1,09,11,09,09,10	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Gb
Function GGb(Int BG_P){BG_GRASP(BG_P,		02,04,04,03,02,02,	-1,-1,04,06,07,06,	-1,09,08,06,07,06,	-1,09,11,11,11,09,	14,13,11,11,11,14	)}
Function GGbM7(Int BG_P){BG_GRASP(BG_P,		02,-1,03,03,02,-1,	-1,-1,04,06,06,06,	-1,09,08,06,06,06,	-1,09,11,10,11,09,	-1,-1,11,11,11,13	)}
Function GGb7(Int BG_P){BG_GRASP(BG_P,		02,04,02,03,02,02,	-1,-1,04,06,05,06,	-1,09,08,09,07,-1,	-1,09,11,09,11,09,	-1,-1,11,11,11,12	)}
Function GGb6(Int BG_P){BG_GRASP(BG_P,		02,-1,01,03,02,-1,	-1,-1,04,03,04,02,	-1,-1,04,06,04,06,	-1,09,08,08,07,-1,	-1,09,11,11,11,11	)}
Function GGbm(Int BG_P){BG_GRASP(BG_P,		02,04,04,02,02,02,	-1,-1,04,06,07,05,	-1,09,07,06,07,-1,	-1,09,11,11,10,09,	-1,-1,11,14,14,14	)}
Function GGbm7(Int BG_P){BG_GRASP(BG_P,		02,04,02,02,02,02,	-1,-1,04,06,05,05,	-1,09,07,09,07,09,	-1,09,11,09,10,09,	-1,-1,11,11,10,12	)}
Function GGbmM7(Int BG_P){BG_GRASP(BG_P,		02,04,03,02,02,02,	-1,-1,04,06,06,05,	-1,09,07,10,-1,-1,	-1,09,11,10,10,09,	-1,-1,11,11,10,13	)}
Function GGbm7b5(Int BG_P){BG_GRASP(BG_P,		02,-1,02,02,01,-1,	02,03,02,02,-1,-1,	-1,-1,04,05,05,05,	-1,09,07,09,07,08,	-1,09,10,09,10,-1	)}
Function GGbsus4(Int BG_P){BG_GRASP(BG_P,		02,04,04,04,02,02,	-1,-1,04,06,07,07,	-1,09,09,-1,07,07,	-1,09,11,11,12,09,	-1,-1,11,11,12,14	)}
Function GGb7sus4(Int BG_P){BG_GRASP(BG_P,	02,04,02,04,02,02,	-1,-1,04,06,05,07,	-1,09,09,09,07,07,	-1,09,11,09,12,09,	-1,-1,11,11,12,12	)}
Function GGbaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,03,02,	-1,05,04,03,03,06,	-1,09,08,07,07,10,	-1,09,-1,11,11,10,	-1,09,-1,11,11,10	)}
Function GGbdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GGbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,03,03,02,04,	-1,-1,04,06,06,04,	-1,09,08,10,09,-1,	-1,09,11,10,09,09,	-1,-1,11,13,11,13	)}
Function GGb7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,03,02,04,	-1,-1,04,06,05,04,	-1,09,08,09,09,09,	-1,09,11,09,09,09,	-1,-1,11,13,11,12	)}
Function GGbadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,02,04,	-1,-1,04,06,07,04,	-1,09,08,06,09,-1,	-1,09,08,06,09,-1,	-1,09,11,11,09,09	)}
Function GGbm7_9(Int BG_P){BG_GRASP(BG_P,		02,04,02,02,02,04,	-1,-1,04,06,05,04,	-1,09,07,09,09,-1,	-1,09,11,09,09,09,	-1,-1,11,13,10,12	)}
Function GGb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,05,03,	-1,-1,04,03,05,03,	-1,09,08,09,08,-1,	-1,09,08,09,08,-1,	-1,-1,11,12,11,12	)}
Function GGb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,05,05,	-1,-1,04,03,05,05,	-1,09,08,09,10,-1,	-1,09,08,09,10,-1,	-1,09,08,09,10,-1	)}
Function GGbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,-1,04,05,06,04,	-1,-1,04,05,06,04,	-1,09,08,10,09,08,	-1,09,08,10,09,08,	14,-1,-1,13,13,13	)}
Function GGbm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,-1,04,06,05,07,	-1,-1,04,06,05,07,	-1,09,07,09,09,07,	-1,09,11,13,12,-1,	14,-1,14,14,12,-1	)}
Function GGb6_9(Int BG_P){BG_GRASP(BG_P,		02,-1,01,01,02,02,	-1,-1,04,06,04,04,	-1,09,08,08,09,09,	-1,09,08,08,09,09,	-1,09,08,08,09,09	)}
Function GGb7_9_13(Int BG_P){BG_GRASP(BG_P,	02,04,02,03,04,02,	-1,-1,04,03,04,04,	-1,09,08,09,09,11,	-1,09,11,09,09,11,	-1,09,11,09,09,11	)}
Function GGb7_9_b13(Int BG_P){BG_GRASP(BG_P,	02,-1,02,03,03,-1,	-1,-1,04,03,03,04,	-1,09,08,09,09,10,	-1,09,11,09,09,10,	-1,09,11,09,09,10	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_G
Function GG(Int BG_P){BG_GRASP(BG_P,		03,02,00,00,00,03,	03,05,05,04,03,03,	-1,-1,05,07,08,07,	-1,10,09,07,08,07,	-1,10,12,12,12,10	)}
Function GGM7(Int BG_P){BG_GRASP(BG_P,		03,02,00,00,00,02,	03,-1,04,04,03,-1,	-1,-1,05,07,07,07,	-1,10,09,07,07,07,	-1,10,12,11,12,10	)}
Function GG7(Int BG_P){BG_GRASP(BG_P,		03,02,00,00,00,01,	03,05,03,04,03,03,	-1,-1,05,07,06,07,	-1,10,09,10,08,-1,	-1,10,12,10,12,10	)}
Function GG6(Int BG_P){BG_GRASP(BG_P,		03,-1,02,04,03,-1,	-1,-1,05,04,05,03,	-1,-1,05,07,05,07,	-1,10,09,09,08,-1,	-1,10,12,12,12,12	)}
Function GGm(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,03,03,03,	03,05,05,03,03,03,	-1,-1,05,07,08,06,	-1,10,08,07,08,-1,	-1,10,12,12,11,10	)}
Function GGm7(Int BG_P){BG_GRASP(BG_P,		03,05,03,03,03,03,	-1,-1,05,07,06,06,	-1,10,08,10,08,10,	-1,10,12,10,11,10,	-1,-1,12,12,11,13	)}
Function GGmM7(Int BG_P){BG_GRASP(BG_P,		03,05,04,03,03,03,	-1,-1,05,07,07,06,	-1,10,08,11,-1,-1,	-1,10,12,11,11,10,	-1,-1,12,12,11,14	)}
Function GGm7b5(Int BG_P){BG_GRASP(BG_P,		03,-1,03,03,02,-1,	03,04,03,03,-1,-1,	-1,-1,05,06,06,06,	-1,10,08,10,08,09,	-1,10,11,10,11,-1	)}
Function GGsus4(Int BG_P){BG_GRASP(BG_P,		03,-1,00,00,01,03,	03,05,05,05,03,03,	-1,-1,05,07,08,08,	-1,10,10,-1,08,08,	-1,10,12,12,13,10	)}
Function GG7sus4(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,00,01,01,	03,05,03,05,03,03,	-1,-1,05,07,06,08,	-1,10,10,10,08,08,	-1,10,12,10,13,10	)}
Function GGaug(Int BG_P){BG_GRASP(BG_P,		03,02,01,00,00,03,	-1,-1,05,04,04,03,	-1,06,05,04,04,07,	-1,10,09,08,08,11,	-1,10,09,08,08,11	)}
Function GGdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GGM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,00,02,	-1,-1,04,04,03,05,	-1,-1,05,07,07,05,	-1,10,09,11,10,-1,	-1,10,12,11,10,10	)}
Function GG7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,02,00,01,	-1,-1,03,04,03,05,	-1,-1,05,07,06,05,	-1,10,09,10,10,10,	-1,10,12,10,10,10	)}
Function GGadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,05,04,03,05,	-1,-1,05,04,03,05,	-1,-1,05,07,08,05,	-1,10,09,07,10,-1,	-1,10,12,12,10,10	)}
Function GGm7_9(Int BG_P){BG_GRASP(BG_P,		03,05,03,03,03,05,	-1,-1,05,03,06,05,	-1,-1,05,07,06,05,	-1,10,08,10,10,10,	-1,10,12,10,10,10	)}
Function GG7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,00,01,00,01,	-1,-1,05,04,06,04,	-1,-1,05,04,06,04,	-1,10,09,10,09,-1,	-1,10,09,10,09,-1	)}
Function GG7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,05,04,06,06,	-1,-1,05,04,06,06,	-1,-1,05,04,06,06,	-1,10,09,10,11,-1,	-1,10,09,10,11,-1	)}
Function GGM7_9_p11(Int BG_P){BG_GRASP(BG_P,	03,-1,-1,02,02,02,	-1,-1,05,06,07,05,	-1,-1,05,06,07,05,	-1,10,09,11,10,09,	-1,10,09,11,10,09	)}
Function GGm7_9_11(Int BG_P){BG_GRASP(BG_P,	03,-1,03,03,01,-1,	-1,-1,05,07,06,08,	-1,-1,05,07,06,08,	-1,10,08,10,10,08,	-1,10,12,14,13,-1	)}
Function GG6_9(Int BG_P){BG_GRASP(BG_P,		03,-1,02,02,03,03,	-1,-1,05,07,05,05,	-1,-1,05,07,05,05,	-1,10,09,09,10,10,	-1,10,09,09,10,10	)}
Function GG7_9_13(Int BG_P){BG_GRASP(BG_P,	03,05,03,04,05,03,	03,05,03,04,05,03,	-1,-1,05,04,05,05,	-1,10,09,10,10,12,	-1,10,12,10,10,12	)}
Function GG7_9_b13(Int BG_P){BG_GRASP(BG_P,	03,-1,03,04,04,-1,	03,-1,03,04,04,-1,	-1,-1,05,04,04,05,	-1,10,09,10,10,11,	-1,10,12,10,10,11	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_G# (yet)
Function GGp(Int BG_P){BG_GRASP(BG_P,		04,03,01,01,01,04,	04,06,06,05,04,04,	-1,-1,06,08,09,08,	-1,11,10,08,09,08,	-1,11,13,13,13,11	)}
Function GGpM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,01,03,	04,-1,05,05,04,-1,	-1,-1,06,08,08,08,	-1,11,10,08,08,08,	-1,11,13,12,13,11	)}
Function GGp7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,01,02,	04,06,04,05,04,04,	-1,-1,06,08,07,08,	-1,11,10,11,09,-1,	-1,11,13,11,13,11	)}
Function GGp6(Int BG_P){BG_GRASP(BG_P,		04,-1,03,05,04,-1,	-1,-1,06,05,06,04,	-1,-1,06,08,06,08,	-1,11,10,10,09,-1,	-1,11,13,13,13,13	)}
Function GGpm(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,04,04,04,	04,06,06,04,04,04,	-1,-1,06,08,09,07,	-1,11,09,08,09,-1,	-1,11,13,13,12,11	)}
Function GGpm7(Int BG_P){BG_GRASP(BG_P,		04,06,04,04,04,04,	-1,-1,06,08,07,07,	-1,11,09,11,09,11,	-1,11,13,11,12,11,	-1,-1,13,13,12,14	)}
Function GGpmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,00,03,	04,06,05,04,04,04,	-1,-1,06,08,08,07,	-1,11,09,12,-1,-1,	-1,11,13,12,12,11	)}
Function GGpm7b5(Int BG_P){BG_GRASP(BG_P,		04,-1,04,04,03,-1,	04,05,04,04,-1,-1,	-1,-1,06,07,07,07,	-1,11,09,11,09,10,	-1,11,12,11,12,-1	)}
Function GGpsus4(Int BG_P){BG_GRASP(BG_P,		04,-1,01,01,02,04,	04,06,06,06,04,04,	-1,-1,06,08,09,09,	-1,11,11,-1,09,09,	-1,11,13,13,14,11	)}
Function GGp7sus4(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,01,02,02,	04,06,04,06,04,04,	-1,-1,06,08,07,09,	-1,11,11,11,09,09,	-1,11,13,11,14,11	)}
Function GGpaug(Int BG_P){BG_GRASP(BG_P,		-1,03,02,01,01,04,	-1,03,-1,05,05,04,	-1,-1,06,05,05,04,	-1,-1,10,09,09,08,	-1,-1,10,09,09,08	)}
Function GGpdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GGpM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,03,	-1,-1,05,05,04,06,	-1,-1,06,08,08,06,	-1,11,10,12,11,-1,	-1,11,13,12,11,11	)}
Function GGp7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,02,	-1,-1,04,05,04,06,	-1,-1,06,08,07,06,	-1,11,10,11,11,11,	-1,11,13,11,11,11	)}
Function GGpadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,06,05,04,06,	-1,-1,06,05,04,06,	-1,-1,06,08,09,06,	-1,11,10,08,11,-1,	-1,11,13,13,11,11	)}
Function GGpm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,00,02,	-1,-1,06,04,07,06,	-1,-1,06,08,07,06,	-1,11,09,11,11,-1,	-1,11,13,11,11,11	)}
Function GGp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,01,02,	-1,-1,06,05,07,05,	-1,-1,06,05,07,05,	-1,11,10,11,10,-1,	-1,11,10,11,10,-1	)}
Function GGp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,06,05,07,07,	-1,-1,06,05,07,07,	-1,-1,06,05,07,07,	-1,11,10,11,12,-1,	-1,11,10,11,12,-1	)}
Function GGpM7_9_p11(Int BG_P){BG_GRASP(BG_P,	04,-1,-1,03,03,03,	-1,-1,06,07,08,06,	-1,-1,06,07,08,06,	-1,11,10,12,11,10,	-1,11,10,12,11,10	)}
Function GGpm7_9_11(Int BG_P){BG_GRASP(BG_P,	04,-1,04,04,02,-1,	-1,-1,06,08,07,09,	-1,-1,06,08,07,09,	-1,11,09,11,11,09,	-1,11,13,15,14,-1	)}
Function GGp6_9(Int BG_P){BG_GRASP(BG_P,		04,-1,03,03,04,04,	-1,-1,06,08,06,06,	-1,-1,06,08,06,06,	-1,11,10,10,11,11,	-1,11,10,10,11,11	)}
Function GGp7_9_13(Int BG_P){BG_GRASP(BG_P,	04,06,04,05,06,04,	04,06,04,05,06,04,	-1,-1,06,05,06,06,	-1,11,10,11,11,13,	-1,11,13,11,11,13	)}
Function GGp7_9_b13(Int BG_P){BG_GRASP(BG_P,	04,-1,04,05,05,-1,	04,-1,04,05,05,-1,	-1,-1,06,05,05,06,	-1,11,10,11,11,12,	-1,11,13,11,11,12	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Ab (yet)
Function GAb(Int BG_P){BG_GRASP(BG_P,		04,03,01,01,01,04,	04,06,06,05,04,04,	-1,-1,06,08,09,08,	-1,11,10,08,09,08,	-1,11,13,13,13,11	)}
Function GAbM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,01,03,	04,-1,05,05,04,-1,	-1,-1,06,08,08,08,	-1,11,10,08,08,08,	-1,11,13,12,13,11	)}
Function GAb7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,01,02,	04,06,04,05,04,04,	-1,-1,06,08,07,08,	-1,11,10,11,09,-1,	-1,11,13,11,13,11	)}
Function GAb6(Int BG_P){BG_GRASP(BG_P,		04,-1,03,05,04,-1,	-1,-1,06,05,06,04,	-1,-1,06,08,06,08,	-1,11,10,10,09,-1,	-1,11,13,13,13,13	)}
Function GAbm(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,04,04,04,	04,06,06,04,04,04,	-1,-1,06,08,09,07,	-1,11,09,08,09,-1,	-1,11,13,13,12,11	)}
Function GAbm7(Int BG_P){BG_GRASP(BG_P,		04,06,04,04,04,04,	-1,-1,06,08,07,07,	-1,11,09,11,09,11,	-1,11,13,11,12,11,	-1,-1,13,13,12,14	)}
Function GAbmM7(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,01,00,03,	04,06,05,04,04,04,	-1,-1,06,08,08,07,	-1,11,09,12,-1,-1,	-1,11,13,12,12,11	)}
Function GAbm7b5(Int BG_P){BG_GRASP(BG_P,		04,-1,04,04,03,-1,	04,05,04,04,-1,-1,	-1,-1,06,07,07,07,	-1,11,09,11,09,10,	-1,11,12,11,12,-1	)}
Function GAbsus4(Int BG_P){BG_GRASP(BG_P,		04,-1,01,01,02,04,	04,06,06,06,04,04,	-1,-1,06,08,09,09,	-1,11,11,-1,09,09,	-1,11,13,13,14,11	)}
Function GAb7sus4(Int BG_P){BG_GRASP(BG_P,	-1,-1,01,01,02,02,	04,06,04,06,04,04,	-1,-1,06,08,07,09,	-1,11,11,11,09,09,	-1,11,13,11,14,11	)}
Function GAbaug(Int BG_P){BG_GRASP(BG_P,		-1,03,02,01,01,04,	-1,03,-1,05,05,04,	-1,-1,06,05,05,04,	-1,-1,10,09,09,08,	-1,-1,10,09,09,08	)}
Function GAbdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GAbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,03,	-1,-1,05,05,04,06,	-1,-1,06,08,08,06,	-1,11,10,12,11,-1,	-1,11,13,12,11,11	)}
Function GAb7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,01,02,	-1,-1,04,05,04,06,	-1,-1,06,08,07,06,	-1,11,10,11,11,11,	-1,11,13,11,11,11	)}
Function GAbadd9(Int BG_P){BG_GRASP(BG_P,		-1,-1,06,05,04,06,	-1,-1,06,05,04,06,	-1,-1,06,08,09,06,	-1,11,10,08,11,-1,	-1,11,13,13,11,11	)}
Function GAbm7_9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,03,00,02,	-1,-1,06,04,07,06,	-1,-1,06,08,07,06,	-1,11,09,11,11,-1,	-1,11,13,11,11,11	)}
Function GAb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,01,02,01,02,	-1,-1,06,05,07,05,	-1,-1,06,05,07,05,	-1,11,10,11,10,-1,	-1,11,10,11,10,-1	)}
Function GAb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,06,05,07,07,	-1,-1,06,05,07,07,	-1,-1,06,05,07,07,	-1,11,10,11,12,-1,	-1,11,10,11,12,-1	)}
Function GAbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	04,-1,-1,03,03,03,	-1,-1,06,07,08,06,	-1,-1,06,07,08,06,	-1,11,10,12,11,10,	-1,11,10,12,11,10	)}
Function GAbm7_9_11(Int BG_P){BG_GRASP(BG_P,	04,-1,04,04,02,-1,	-1,-1,06,08,07,09,	-1,-1,06,08,07,09,	-1,11,09,11,11,09,	-1,11,13,15,14,-1	)}
Function GAb6_9(Int BG_P){BG_GRASP(BG_P,		04,-1,03,03,04,04,	-1,-1,06,08,06,06,	-1,-1,06,08,06,06,	-1,11,10,10,11,11,	-1,11,10,10,11,11	)}
Function GAb7_9_13(Int BG_P){BG_GRASP(BG_P,	04,06,04,05,06,04,	04,06,04,05,06,04,	-1,-1,06,05,06,06,	-1,11,10,11,11,13,	-1,11,13,11,11,13	)}
Function GAb7_9_b13(Int BG_P){BG_GRASP(BG_P,	04,-1,04,05,05,-1,	04,-1,04,05,05,-1,	-1,-1,06,05,05,06,	-1,11,10,11,11,12,	-1,11,13,11,11,12	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_A
Function GA(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,02,00,	05,04,02,02,02,05,	05,07,07,06,05,05,	-1,-1,07,09,10,09,	-1,12,11,09,10,09	)}
Function GAM7(Int BG_P){BG_GRASP(BG_P,		-1,00,02,01,02,00,	-1,-1,02,02,02,04,	05,-1,06,06,05,-1,	-1,-1,07,09,09,09,	-1,12,11,09,09,09	)}
Function GA7(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,02,00,	-1,-1,02,02,02,03,	05,07,05,06,05,05,	-1,-1,07,09,08,09,	-1,12,11,12,10,-1	)}
Function GA6(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,02,02,	05,-1,04,06,05,-1,	-1,-1,07,06,07,05,	-1,-1,07,09,07,09,	-1,12,11,11,10,-1	)}
Function GAm(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,01,00,	-1,-1,02,05,05,05,	05,07,07,05,05,05,	-1,-1,07,09,10,08,	-1,12,10,09,10,-1	)}
Function GAm7(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,01,00,	-1,-1,02,02,01,03,	-1,07,07,05,05,05,	-1,-1,07,09,08,08,	-1,12,10,12,10,12	)}
Function GAmM7(Int BG_P){BG_GRASP(BG_P,		-1,00,02,01,01,00,	-1,-1,02,02,01,04,	05,07,06,05,05,05,	-1,-1,07,09,09,08,	-1,12,10,13,-1,-1	)}
Function GAm7b5(Int BG_P){BG_GRASP(BG_P,		-1,00,01,00,01,-1,	05,-1,05,05,04,-1,	05,06,05,05,-1,-1,	-1,-1,07,08,08,08,	-1,12,10,12,10,11	)}
Function GAsus4(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,03,00,	-1,-1,02,02,03,05,	05,07,07,07,05,05,	-1,-1,07,09,10,10,	-1,12,12,-1,10,10	)}
Function GA7sus4(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,03,00,	-1,-1,02,02,03,03,	05,07,05,07,05,05,	-1,-1,07,09,08,10,	-1,12,12,12,10,10	)}
Function GAaug(Int BG_P){BG_GRASP(BG_P,		-1,00,03,02,02,01,	-1,04,-1,06,06,05,	-1,-1,07,06,06,05,	-1,08,07,06,06,09,	-1,08,07,06,06,09	)}
Function GAdim(Int BG_P){BG_GRASP(BG_P,		02,-1,01,02,01,-1,	05,-1,04,05,04,-1,	08,-1,07,08,07,-1,	08,-1,07,08,07,-1,	11,-1,10,11,10,-1	)}
Function GAM7_9(Int BG_P){BG_GRASP(BG_P,		-1,00,02,01,00,00,	-1,-1,02,04,02,04,	-1,-1,06,06,05,07,	-1,-1,07,09,09,07,	-1,12,11,13,12,-1	)}
Function GA7_9(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,00,00,	-1,-1,02,04,02,03,	-1,-1,05,06,05,07,	-1,-1,07,09,08,07,	-1,12,11,12,12,12	)}
Function GAadd9(Int BG_P){BG_GRASP(BG_P,		-1,00,02,02,00,00,	-1,00,02,02,00,00,	-1,-1,07,06,05,07,	-1,-1,07,09,10,07,	-1,12,11,09,12,-1	)}
Function GAm7_9(Int BG_P){BG_GRASP(BG_P,		-1,00,02,00,00,00,	-1,-1,02,04,01,03,	05,07,05,05,05,07,	-1,-1,07,09,08,07,	-1,12,10,12,12,-1	)}
Function GA7_b9(Int BG_P){BG_GRASP(BG_P,		-1,-1,02,03,02,03,	-1,-1,02,03,02,03,	-1,-1,07,06,08,06,	-1,-1,07,06,08,06,	-1,12,11,12,11,-1	)}
Function GA7_p9(Int BG_P){BG_GRASP(BG_P,		-1,-1,07,06,08,08,	-1,-1,07,06,08,08,	-1,-1,07,06,08,08,	-1,-1,07,06,08,08,	-1,12,11,12,13,-1	)}
Function GAM7_9_p11(Int BG_P){BG_GRASP(BG_P,	05,-1,-1,04,04,04,	05,-1,-1,04,04,04,	05,-1,-1,04,04,04,	-1,-1,07,08,09,07,	-1,12,11,13,12,11	)}
Function GAm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,00,02,04,03,00,	05,-1,05,05,03,-1,	-1,-1,05,05,03,05,	-1,-1,07,09,08,10,	-1,12,10,12,12,10	)}
Function GA6_9(Int BG_P){BG_GRASP(BG_P,		05,-1,04,04,05,05,	05,-1,04,04,05,05,	-1,-1,07,09,07,07,	-1,-1,07,09,07,07,	-1,12,11,11,12,12	)}
Function GA7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,00,02,00,00,02,	05,07,05,06,07,05,	05,07,05,06,07,05,	-1,-1,07,06,07,07,	-1,12,11,12,12,14	)}
Function GA7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,00,02,00,00,01,	05,-1,05,06,06,-1,	05,-1,05,06,06,-1,	-1,-1,07,06,06,07,	-1,12,11,12,12,13	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_A# (yet)
Function GAp(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,03,01,	06,05,03,03,03,06,	06,08,08,07,06,06,	-1,-1,08,10,11,10,	-1,13,12,10,11,10	)}
Function GApM7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,03,01,	-1,-1,03,03,03,05,	06,-1,07,07,06,-1,	-1,-1,08,10,10,10,	-1,13,12,10,10,10	)}
Function GAp7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,03,01,	-1,-1,03,03,03,04,	06,08,06,07,06,06,	-1,-1,08,10,09,10,	-1,13,12,13,11,-1	)}
Function GAp6(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,03,03,	06,-1,05,07,06,-1,	-1,-1,08,07,08,06,	-1,-1,08,10,08,10,	-1,13,12,12,11,-1	)}
Function GApm(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,02,01,	-1,-1,03,06,06,06,	06,08,08,06,06,06,	-1,-1,08,10,11,09,	-1,13,11,10,11,-1	)}
Function GApm7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,02,01,	-1,-1,03,03,02,04,	-1,08,08,06,06,06,	-1,-1,08,10,09,09,	-1,13,11,13,11,13	)}
Function GApmM7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,02,01,	-1,-1,03,03,02,05,	06,08,07,06,06,06,	-1,-1,08,10,10,09,	-1,13,11,14,-1,-1	)}
Function GApm7b5(Int BG_P){BG_GRASP(BG_P,		-1,01,02,01,02,-1,	06,-1,06,06,05,-1,	06,07,06,06,-1,-1,	-1,-1,08,09,09,09,	-1,13,11,13,11,12	)}
Function GApsus4(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,04,01,	-1,-1,03,03,04,06,	06,08,08,08,06,06,	-1,-1,08,10,11,11,	-1,13,13,-1,11,11	)}
Function GAp7sus4(Int BG_P){BG_GRASP(BG_P,	-1,01,03,01,04,01,	-1,-1,03,03,04,04,	06,08,06,08,06,06,	-1,-1,08,10,09,11,	-1,13,13,13,11,11	)}
Function GApaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,03,02,	-1,05,04,03,03,06,	-1,05,-1,07,07,06,	-1,09,08,07,07,10,	-1,09,08,07,07,10	)}
Function GApdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GApM7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,01,01,	-1,-1,03,05,03,05,	-1,-1,07,07,06,08,	-1,-1,08,10,10,08,	-1,13,12,14,13,-1	)}
Function GAp7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,01,01,	-1,-1,03,05,03,04,	-1,-1,06,07,06,08,	-1,-1,08,10,09,08,	-1,13,12,13,13,13	)}
Function GApadd9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,01,01,	-1,01,03,03,01,01,	-1,-1,08,07,06,08,	-1,-1,08,10,11,08,	-1,13,12,10,13,-1	)}
Function GApm7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,01,01,	-1,-1,03,05,02,04,	06,08,06,06,06,08,	-1,-1,08,10,09,08,	-1,13,11,13,13,-1	)}
Function GAp7_b9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,01,00,-1,	-1,-1,03,04,03,04,	-1,-1,03,04,03,04,	-1,-1,08,07,09,07,	-1,13,12,13,12,-1	)}
Function GAp7_p9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,01,02,-1,	-1,01,00,01,02,-1,	-1,-1,08,07,09,09,	-1,-1,08,07,09,09,	-1,13,12,13,14,-1	)}
Function GApM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,01,00,02,01,00,	-1,01,00,02,01,00,	06,-1,-1,05,05,05,	06,-1,-1,05,05,05,	-1,13,12,14,13,12	)}
Function GApm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,01,03,05,04,-1,	-1,01,03,05,04,-1,	-1,-1,08,08,06,08,	-1,-1,08,08,06,08,	-1,-1,08,10,09,11	)}
Function GAp6_9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,00,01,01,	06,-1,05,05,06,06,	-1,-1,08,10,08,10,	-1,-1,08,10,08,08,	-1,13,12,12,13,13	)}
Function GAp7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,01,00,01,01,03,	06,08,06,07,08,06,	06,08,06,07,08,06,	-1,-1,08,07,08,08,	-1,13,12,13,13,15	)}
Function GAp7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,01,00,01,01,02,	06,-1,06,07,07,-1,	06,-1,06,07,07,-1,	-1,-1,08,07,07,08,	-1,13,12,13,13,14	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_Bb (yet)
Function GBb(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,03,01,	06,05,03,03,03,06,	06,08,08,07,06,06,	-1,-1,08,10,11,10,	-1,13,12,10,11,10	)}
Function GBbM7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,03,01,	-1,-1,03,03,03,05,	06,-1,07,07,06,-1,	-1,-1,08,10,10,10,	-1,13,12,10,10,10	)}
Function GBb7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,03,01,	-1,-1,03,03,03,04,	06,08,06,07,06,06,	-1,-1,08,10,09,10,	-1,13,12,13,11,-1	)}
Function GBb6(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,03,03,	06,-1,05,07,06,-1,	-1,-1,08,07,08,06,	-1,-1,08,10,08,10,	-1,13,12,12,11,-1	)}
Function GBbm(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,02,01,	-1,-1,03,06,06,06,	06,08,08,06,06,06,	-1,-1,08,10,11,09,	-1,13,11,10,11,-1	)}
Function GBbm7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,02,01,	-1,-1,03,03,02,04,	-1,08,08,06,06,06,	-1,-1,08,10,09,09,	-1,13,11,13,11,13	)}
Function GBbmM7(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,02,01,	-1,-1,03,03,02,05,	06,08,07,06,06,06,	-1,-1,08,10,10,09,	-1,13,11,14,-1,-1	)}
Function GBbm7b5(Int BG_P){BG_GRASP(BG_P,		-1,01,02,01,02,-1,	06,-1,06,06,05,-1,	06,07,06,06,-1,-1,	-1,-1,08,09,09,09,	-1,13,11,13,11,12	)}
Function GBbsus4(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,04,01,	-1,-1,03,03,04,06,	06,08,08,08,06,06,	-1,-1,08,10,11,11,	-1,13,13,-1,11,11	)}
Function GBb7sus4(Int BG_P){BG_GRASP(BG_P,	-1,01,03,01,04,01,	-1,-1,03,03,04,04,	06,08,06,08,06,06,	-1,-1,08,10,09,11,	-1,13,13,13,11,11	)}
Function GBbaug(Int BG_P){BG_GRASP(BG_P,		-1,-1,04,03,03,02,	-1,05,04,03,03,06,	-1,05,-1,07,07,06,	-1,09,08,07,07,10,	-1,09,08,07,07,10	)}
Function GBbdim(Int BG_P){BG_GRASP(BG_P,		00,01,02,00,02,00,	03,-1,02,03,02,-1,	06,-1,05,06,05,-1,	09,-1,08,09,08,-1,	12,-1,11,12,11,-1	)}
Function GBbM7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,02,01,01,	-1,-1,03,05,03,05,	-1,-1,07,07,06,08,	-1,-1,08,10,10,08,	-1,13,12,14,13,-1	)}
Function GBb7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,01,01,	-1,-1,03,05,03,04,	-1,-1,06,07,06,08,	-1,-1,08,10,09,08,	-1,13,12,13,13,13	)}
Function GBbadd9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,03,01,01,	-1,01,03,03,01,01,	-1,-1,08,07,06,08,	-1,-1,08,10,11,08,	-1,13,12,10,13,-1	)}
Function GBbm7_9(Int BG_P){BG_GRASP(BG_P,		-1,01,03,01,01,01,	-1,-1,03,05,02,04,	06,08,06,06,06,08,	-1,-1,08,10,09,08,	-1,13,11,13,13,-1	)}
Function GBb7_b9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,01,00,-1,	-1,-1,03,04,03,04,	-1,-1,03,04,03,04,	-1,-1,08,07,09,07,	-1,13,12,13,12,-1	)}
Function GBb7_p9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,01,02,-1,	-1,01,00,01,02,-1,	-1,-1,08,07,09,09,	-1,-1,08,07,09,09,	-1,13,12,13,14,-1	)}
Function GBbM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,01,00,02,01,00,	-1,01,00,02,01,00,	06,-1,-1,05,05,05,	06,-1,-1,05,05,05,	-1,13,12,14,13,12	)}
Function GBbm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,01,03,05,04,-1,	-1,01,03,05,04,-1,	-1,-1,08,08,06,08,	-1,-1,08,08,06,08,	-1,-1,08,10,09,11	)}
Function GBb6_9(Int BG_P){BG_GRASP(BG_P,		-1,01,00,00,01,01,	06,-1,05,05,06,06,	-1,-1,08,10,08,10,	-1,-1,08,10,08,08,	-1,13,12,12,13,13	)}
Function GBb7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,01,00,01,01,03,	06,08,06,07,08,06,	06,08,06,07,08,06,	-1,-1,08,07,08,08,	-1,13,12,13,13,15	)}
Function GBb7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,01,00,01,01,02,	06,-1,06,07,07,-1,	06,-1,06,07,07,-1,	-1,-1,08,07,07,08,	-1,13,12,13,13,14	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//_B
Function GB(Int BG_P){BG_GRASP(BG_P,		02,02,04,04,04,02,	07,06,04,04,04,07,	07,09,09,08,07,07,	-1,-1,09,11,12,11,	-1,14,13,11,12,11	)}
Function GBM7(Int BG_P){BG_GRASP(BG_P,		-1,02,04,03,04,02,	-1,-1,04,04,04,06,	07,-1,08,08,07,-1,	-1,-1,09,11,11,11,	-1,14,13,11,11,11	)}
Function GB7(Int BG_P){BG_GRASP(BG_P,		-1,02,01,02,00,02,	-1,02,04,02,04,02,	07,09,07,08,07,07,	07,09,07,08,07,07,	-1,-1,09,11,10,11	)}
Function GB6(Int BG_P){BG_GRASP(BG_P,		-1,02,04,04,04,04,	07,-1,06,08,07,-1,	-1,-1,09,08,09,07,	-1,-1,09,11,09,11,	-1,14,13,13,12,-1	)}
Function GBm(Int BG_P){BG_GRASP(BG_P,		-1,02,04,04,03,02,	-1,-1,04,07,07,07,	07,09,09,07,07,07,	-1,-1,09,11,12,10,	-1,14,12,11,12,-1	)}
Function GBm7(Int BG_P){BG_GRASP(BG_P,		-1,02,00,02,00,02,	-1,02,04,02,03,02,	-1,-1,04,04,03,05,	07,09,07,07,07,07,	-1,-1,09,11,10,10	)}
Function GBmM7(Int BG_P){BG_GRASP(BG_P,		-1,02,00,03,-1,-1,	-1,02,04,03,03,02,	-1,-1,04,04,03,06,	07,09,08,07,07,07,	-1,-1,09,11,11,10	)}
Function GBm7b5(Int BG_P){BG_GRASP(BG_P,		-1,02,00,02,00,01,	-1,02,03,02,03,-1,	07,-1,07,07,06,-1,	07,08,07,07,-1,-1,	-1,-1,09,10,10,10	)}
Function GBsus4(Int BG_P){BG_GRASP(BG_P,		-1,02,04,04,05,02,	-1,-1,04,04,05,07,	07,09,09,09,07,07,	-1,-1,09,11,12,12,	-1,14,14,-1,12,12	)}
Function GB7sus4(Int BG_P){BG_GRASP(BG_P,		-1,02,04,02,05,02,	-1,-1,04,04,05,05,	07,09,07,09,07,07,	-1,-1,09,11,10,12,	-1,14,14,14,12,12	)}
Function GBaug(Int BG_P){BG_GRASP(BG_P,		-1,02,01,00,00,03,	-1,-1,05,04,04,03,	-1,06,05,04,04,07,	-1,-1,09,08,08,07,	-1,14,13,12,12,15	)}
Function GBdim(Int BG_P){BG_GRASP(BG_P,		04,-1,03,04,03,-1,	04,-1,03,04,03,-1,	07,-1,06,07,06,-1,	10,-1,09,10,09,-1,	13,-1,12,13,12,-1	)}
Function GBM7_9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,03,02,-1,	-1,02,04,03,02,02,	-1,-1,04,06,04,06,	-1,-1,08,08,07,09,	-1,-1,09,11,11,09	)}
Function GB7_9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,02,02,02,	-1,02,04,02,02,02,	-1,-1,04,06,04,05,	-1,-1,07,08,07,09,	-1,-1,09,11,10,09	)}
Function GBadd9(Int BG_P){BG_GRASP(BG_P,		-1,02,04,04,02,02,	-1,02,04,04,02,02,	-1,-1,09,08,07,09,	-1,-1,09,11,12,09,	-1,14,13,11,14,-1	)}
Function GBm7_9(Int BG_P){BG_GRASP(BG_P,		-1,02,00,02,02,02,	-1,02,04,02,02,02,	-1,-1,04,06,03,05,	07,09,07,07,07,09,	-1,-1,09,11,10,09	)}
Function GB7_b9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,02,01,-1,	-1,-1,04,05,04,05,	-1,-1,04,05,04,05,	-1,-1,09,08,10,08,	-1,-1,09,08,10,08	)}
Function GB7_p9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,02,03,-1,	-1,02,01,02,03,-1,	-1,-1,09,08,10,10,	-1,-1,09,08,10,10,	-1,-1,09,08,10,10	)}
Function GBM7_9_p11(Int BG_P){BG_GRASP(BG_P,	-1,02,01,03,02,01,	-1,02,01,03,02,01,	07,-1,-1,06,06,06,	07,-1,-1,06,06,06,	-1,-1,09,10,11,09	)}
Function GBm7_9_11(Int BG_P){BG_GRASP(BG_P,	-1,02,00,02,02,00,	-1,02,04,06,05,-1,	-1,-1,07,07,05,07,	-1,-1,07,07,05,07,	-1,-1,09,11,10,12	)}
Function GB6_9(Int BG_P){BG_GRASP(BG_P,		-1,02,01,01,02,02,	-1,02,01,01,02,02,	07,-1,06,06,07,07,	-1,-1,09,11,09,09,	-1,-1,09,11,09,09	)}
Function GB7_9_13(Int BG_P){BG_GRASP(BG_P,	-1,02,01,02,02,04,	-1,02,04,02,02,04,	07,09,07,08,09,07,	07,09,07,08,09,07,	-1,-1,09,08,09,09	)}
Function GB7_9_b13(Int BG_P){BG_GRASP(BG_P,	-1,02,01,02,02,03,	-1,02,04,02,02,03,	07,-1,07,08,08,-1,	-1,-1,09,08,08,09,	-1,-1,09,08,08,09	)}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
