//----------------------------------------------------------------------------------------------
//_bwb_scale.h
//		by	�����F		(bluewhitebear@hotmail.com)
//		Hp	Blue Darkness	(http://www.nothing-kb.jp/~bluedarkness/)
//----------------------------------------------------------------------------------------------
//�l�n�]��
Int	BS_RENEWAL_IKEY=0;			//�����]���̒l�P
Int	BS_RENEWAL_IKEY_2=0;			//�����]���̒l�Q
Int	BS_RENEWAL_IKEY_3=0;			//�����]���̒l�R
Int	BS_RENEWAL_FKEY=0;			//�T�x�]���œ]������l
Int	BS_RENEWAL_FVAL=0;			//�T�x�]���ő�����ꂽ�l
Int	BS_RENEWAL_TKEY=0;			//�Z�R�x�]���œ]������l
Int	BS_RENEWAL_TVAL=0;			//�Z�R�x�]���ő�����ꂽ�l
Int	BS_RENEWAL_OKEY=0;			//�I�N�^�[�u�V�t�g�ŃV�t�g����l
//Flag�錾�n�]��
Int	BS_RENEWAL_FKRR=0;			//���̒��̍���
Int	BS_RENEWAL_FKRC=0;			//���̒��̍����̃v���X�}�C�i�X�␳
Int	BS_RENEWAL_FKRP=0;			//���̒��̎��ۂ̓]���
Array	BS_RENEWAL_FLAG=0,0,0,0,0,0,0;	//���̃L�[�t���O
Str	BS_RENEWAL_MK={�b�@};			//����
//�X�P�[��
Array	BS_RENEWAL_SLAG=0,0,0,0,0,0,0;	//�X�P�[���̃L�[�t���O
Str	BS_RENEWAL_MS={Ionian(Major)};	//�X�P�[����
Int	BS_RENEWAL_SMMS=0;			//Major:0 Minor:1
Int	BS_RENEWAL_SNNM=7;			//�X�P�[���̉���
Str	BS_RENEWAL_SNSM={cdefgab};		//�X�P�[���̉�
Str	BS_RENEWAL_SEXN={};			//�W���ȏ�̃X�P�[���̎��ɒǉ�����m�[�g
Array	BS_RENEWAL_SPBE=0,0,0,0,0,0,0		//�X�P�[���C��
Array	BS_RENEWAL_SMBF=100,100,100,100,100	//�X�P�[���������[
Int	BS_RENEWAL_SMSW=on;			//�X�P�[���������[�X�C�b�`
//�ϐ��N���A
Function BS_CLEAR(){
	BS_RENEWAL_IKEY=0;			//�����]���̒l�P(BS_K)
	BS_RENEWAL_IKEY_2=0;			//�����]���̒l�Q(BS_K2)
	BS_RENEWAL_IKEY_3=0;			//�����]���̒l�R(BS_K3)
	BS_RENEWAL_FKEY=0;			//�T�x�]���œ]������l(BS_FK)
	BS_RENEWAL_FVAL=0;			//�T�x�]���ő�����ꂽ�l(BS_FK)
	BS_RENEWAL_TKEY=0;			//�Z�R�x�]���œ]������l(BS_TK)
	BS_RENEWAL_TVAL=0;			//�Z�R�x�]���ő�����ꂽ�l(BS_TK)
	BS_RENEWAL_OKEY=0;			//�I�N�^�[�u�V�t�g�ŃV�t�g����l(BS_O)
	BS_RENEWAL_FKRR=0;			//���̒��̍���(BS_C,BS_Cp...)
	BS_RENEWAL_FKRC=0;			//���̒��̍����̃v���X�}�C�i�X�␳(BS_C,BS_Cp...)
	BS_RENEWAL_FKRP=0;			//���̒��̎��ۂ̓]���(BS_C,BS_Cp...)
	BS_RENEWAL_FLAG=0,0,0,0,0,0,0;	//���̃L�[�t���O(BS_C,BS_Cp...)
	BS_RENEWAL_MK={�b�@};			//����(BS_C,BS_Cp...)
	BS_RENEWAL_SLAG=0,0,0,0,0,0,0;	//�X�P�[���̃L�[�t���O(BS_MODE...)
	BS_RENEWAL_MS={Ionian(Major)};	//�X�P�[����(BS_MODE...)
	BS_RENEWAL_SMMS=0;			//Major:0 Minor:1(BS_MODE...)
	BS_RENEWAL_SNNM=7;			//�X�P�[���̉���(BS_MODE...)
	BS_RENEWAL_SNSM={cdefgab};		//�X�P�[���̉�(BS_MODE...)
	BS_RENEWAL_SEXN={};			//�W���ȏ�̃X�P�[���̎��ɒǉ�����m�[�g(BS_MODE...)
	BS_RENEWAL_SPBE=0,0,0,0,0,0,0		//�X�P�[���C��(BS_MODE...)
	BS_RENEWAL_SMBF=100,100,100,100,100	//�X�P�[���������[(BS_MODE...)
	BS_RENEWAL_SMSW=on;			//�X�P�[���������[�X�C�b�`(BS_SCALE_UNDO)
	}
//�f�o�b�O�p�ϐ��\���@�\
Function BS_DEBUG_PRINT(){
	Print({"[���݂̃O���[�o���ϐ��̏�]"})
	Print({"IKEY(�����]���̒l�P)			:"}+BS_RENEWAL_IKEY);
	Print({"IKEY_2(�����]���̒l�Q)			:"}+BS_RENEWAL_IKEY_2);
	Print({"IKEY_3(�����]���̒l�R)			:"}+BS_RENEWAL_IKEY_3);
	Print({"FKEY(�T�x�]���œ]������l)		:"}+BS_RENEWAL_FKEY);
	Print({"FVAL(�T�x�]���ő�����ꂽ�l)		:"}+BS_RENEWAL_FVAL);
	Print({"TKEY(�Z�R�x�]���œ]������l)		:"}+BS_RENEWAL_TKEY);
	Print({"TVAL(�Z�R�x�]���ő�����ꂽ�l)		:"}+BS_RENEWAL_TVAL);
	Print({"OKEY(�I�N�^�[�u�V�t�g�ŃV�t�g����l)	:"}+BS_RENEWAL_OKEY);
	Print({"FKRR(���̒��̍���)			:"}+BS_RENEWAL_FKRR);
	Print({"FKRC(���̒��̍����̃v���X�}�C�i�X�␳)	:"}+BS_RENEWAL_FKRC);
	Print({"FKRP(���̒��̎��ۂ̓]���)		:"}+BS_RENEWAL_FKRP);
	Print({"FLAG(���̃L�[�t���O)			:"}+BS_RENEWAL_FLAG);
	Print({"MK(����)					:"}+BS_RENEWAL_MK);
	Print({"SLAG(�X�P�[���̃L�[�t���O)		:"}+BS_RENEWAL_SLAG);
	Print({"MS(�X�P�[����)				:"}+BS_RENEWAL_MS);
	Print({"SMMS(Major:1 Minor:2)			:"}+BS_RENEWAL_SMMS);
	Print({"SNNM(�X�P�[���̉���)			:"}+BS_RENEWAL_SNNM);
	Print({"SNSM(�X�P�[���̉�)			:"}+BS_RENEWAL_SNSM);
	Print({"SEXN(�ǉ�����m�[�g)			:"}+BS_RENEWAL_SEXN);
	Print({"SPBE(�X�P�[���C��)			:"}+BS_RENEWAL_SPBE);
	Print({"SMBF(�X�P�[���������[)			:"}+BS_RENEWAL_SMBF);
	Print({"SMSW(�X�P�[���������[�X�C�b�`)		:"}+BS_RENEWAL_SMSW);
	}

//�ϐ����܂Ƃ߁A���ۂɓ]�����s��
Function BS_RENEWAL(Int BS_RENEWAL_EDIT_I){
	Array BS_RENEWAL_A=0,0,0,0,0,0,0;

	If(BS_RENEWAL_EDIT_I==0){BS_RENEWAL_SPBE=0,0,0,0,0,0,0;}
	For(Int BS_F=0;BS_F<7;BS_F++){
		BS_RENEWAL_A(BS_F)=BS_RENEWAL_A(BS_F)+BS_RENEWAL_FLAG(BS_F)
		BS_RENEWAL_A(BS_F)=BS_RENEWAL_A(BS_F)+BS_RENEWAL_SLAG((BS_F-BS_RENEWAL_FKRR+7)%7)
		BS_RENEWAL_A(BS_F)=BS_RENEWAL_A(BS_F)+BS_RENEWAL_SPBE((BS_F-BS_RENEWAL_FKRR+7)%7);
		BS_RENEWAL_A(BS_F)=BS_RENEWAL_A(BS_F)+BS_RENEWAL_IKEY+BS_RENEWAL_IKEY_2+BS_RENEWAL_IKEY_3
		BS_RENEWAL_A(BS_F)=BS_RENEWAL_A(BS_F)+BS_RENEWAL_FKRC
		BS_RENEWAL_A(BS_F)=BS_RENEWAL_A(BS_F)+(BS_RENEWAL_OKEY*12)
		BS_RENEWAL_A(BS_F)=BS_RENEWAL_A(BS_F)+BS_RENEWAL_FKEY+BS_RENEWAL_TKEY
		}

	TimeKeyFlag(,,(BS_RENEWAL_A))
	}
//���^�C�x���g�������݋@�\
Function BS_META(){	//���^�C�x���g�������݋@�\
	Int	BS_META_K=(BS_RENEWAL_FKRP+BS_RENEWAL_TKEY+BS_RENEWAL_FKEY+BS_RENEWAL_IKEY+BS_RENEWAL_IKEY_2+BS_RENEWAL_IKEY_3)%12;
	If(BS_RENEWAL_SMMS==1){BS_META_K=BS_META_K+3;}
	BS_META_K=BS_META_K%12;
	If(BS_META_K<0){BS_META_K=BS_META_K+12}
	Int	BS_META_N=0;
	
	Switch(BS_META_K){
		Case( 0){BS_META_N=0;}
		Case( 1){BS_META_N=-5;}
		Case( 2){BS_META_N=2;}
		Case( 3){BS_META_N=-3;}
		Case( 4){BS_META_N=4;}
		Case( 5){BS_META_N=-1;}
		Case( 6){BS_META_N=-6;}
		Case( 7){BS_META_N=1;}
		Case( 8){BS_META_N=-4;}
		Case( 9){BS_META_N=3;}
		Case(10){BS_META_N=-2;}
		Case(11){BS_META_N=5;}
		}

	DirectSMF($FF,$59,$02,BS_META_N,BS_RENEWAL_SMMS);
	}

//�\���@�\
Function BS_PRINT(){	//�\���@�\
	Int	BS_PRINT_K=(BS_RENEWAL_FKRP+BS_RENEWAL_TKEY+BS_RENEWAL_FKEY+BS_RENEWAL_IKEY+BS_RENEWAL_IKEY_2+BS_RENEWAL_IKEY_3)%12;
	Str	BS_PRINT_N;
	Int	BS_PRINT_AK=BS_RENEWAL_TKEY+BS_RENEWAL_FKEY+BS_RENEWAL_IKEY+BS_RENEWAL_IKEY_2+BS_RENEWAL_IKEY_3+(BS_RENEWAL_OKEY*12)

	If(BS_PRINT_K<0){BS_PRINT_K+=12;}
	Switch(BS_PRINT_K){
		Case( 0){BS_PRINT_N={"�b�@"}}
		Case( 1){BS_PRINT_N={"�c��"}}
		Case( 2){BS_PRINT_N={"�c�@"}}
		Case( 3){BS_PRINT_N={"�d��"}}
		Case( 4){BS_PRINT_N={"�d�@"}}
		Case( 5){BS_PRINT_N={"�e�@"}}
		Case( 6){BS_PRINT_N={"�f��"}}
		Case( 7){BS_PRINT_N={"�f�@"}}
		Case( 8){BS_PRINT_N={"�`��"}}
		Case( 9){BS_PRINT_N={"�`�@"}}
		Case(10){BS_PRINT_N={"�a��"}}
		Case(11){BS_PRINT_N={"�a�@"}}
		}
	
Str	BS_PRINT_1={"�L�[�F("}+BS_RENEWAL_MK+{")"}+{"				�I�N�^�[�u�V�t�g(BS_O)�F"}+BS_RENEWAL_OKEY;
Str	BS_PRINT_2={"�Z�R�x�]��(BS_TK)�F"}+BS_RENEWAL_TVAL+{"�~3��"}+BS_RENEWAL_TKEY+{"		�T�x�]��(BS_FK)�F"}+BS_RENEWAL_FVAL+{"�~5��12��"}+BS_RENEWAL_FKEY;
Str	BS_PRINT_3={"�����]��(BS_K,BS_K2,BS_K3)�F("}+BS_RENEWAL_IKEY+{","}+BS_RENEWAL_IKEY_2+{","}+BS_RENEWAL_IKEY_3+{")"}+{"	�X�P�[���C���l�F("}+BS_RENEWAL_SPBE(0)+{","}+BS_RENEWAL_SPBE(1)+{","}+BS_RENEWAL_SPBE(2)+{","}+BS_RENEWAL_SPBE(3)+{","}+BS_RENEWAL_SPBE(4)+{","}+BS_RENEWAL_SPBE(5)+{","}+BS_RENEWAL_SPBE(6)+{")"};
Str	BS_PRINT_4={"�X�P�[���F"}+BS_RENEWAL_MS+{"("}+BS_RENEWAL_SLAG(0)+{","}+BS_RENEWAL_SLAG(1)+{","}+BS_RENEWAL_SLAG(2)+{","}+BS_RENEWAL_SLAG(3)+{","}+BS_RENEWAL_SLAG(4)+{","}+BS_RENEWAL_SLAG(5)+{","}+BS_RENEWAL_SLAG(6)+{")("}+BS_RENEWAL_SNNM+{"��)"};
Str	BS_PRINT_5={"�X�P�[���̍\�����F"}+{"("}+BS_RENEWAL_SNSM+{"):("}+BS_RENEWAL_SEXN+{")"};
Str	BS_PRINT_6={"���݂̌��ʁFKey�F["}+BS_PRINT_N+{"]	�]���l�F["}+BS_PRINT_AK+{"]"};
	Print({"[���݂̃p�����[�^(Time:"}+Time+{")]"})
	Print(BS_PRINT_1)
	Print(BS_PRINT_2)
	Print(BS_PRINT_3)
	Print(BS_PRINT_4)
	Print(BS_PRINT_5)
	Print(BS_PRINT_6)
	}

//�֐��S
Function BS_K(Int BS_I){	BS_RENEWAL_IKEY=BS_I;					BS_RENEWAL(0);}	//(Int BS_I=�]������l)
Function BS_KEY(Int BS_I){	BS_RENEWAL_IKEY=BS_I;					BS_RENEWAL(0);}	//(Int BS_I=�]������l)
Function BS_UP(){			BS_RENEWAL_IKEY+=1;					BS_RENEWAL(0);}	//�P������ɓ]��
Function BS_KUP(){		BS_RENEWAL_IKEY+=1;					BS_RENEWAL(0);}	//�P������ɓ]��
Function BS_DOWN(){		BS_RENEWAL_IKEY-=1;					BS_RENEWAL(0);}	//�P�������ɓ]��
Function BS_KDOWN(){		BS_RENEWAL_IKEY-=1;					BS_RENEWAL(0);}	//�P�������ɓ]��
Function BS_K2(Int BS_I){	BS_RENEWAL_IKEY_2=BS_I;					BS_RENEWAL(0);}	//(Int BS_I=�]������l)
Function BS_KEY2(Int BS_I){	BS_RENEWAL_IKEY_2=BS_I;					BS_RENEWAL(0);}	//(Int BS_I=�]������l)
Function BS_K2UP(){		BS_RENEWAL_IKEY_2+=1;					BS_RENEWAL(0);}	//�P������ɓ]��
Function BS_K2DOWN(){		BS_RENEWAL_IKEY_2-=1;					BS_RENEWAL(0);}	//�P�������ɓ]��
Function BS_K3(Int BS_I){	BS_RENEWAL_IKEY_3=BS_I;					BS_RENEWAL(0);}	//(Int BS_I=�]������l)
Function BS_KEY3(Int BS_I){	BS_RENEWAL_IKEY_3=BS_I;					BS_RENEWAL(0);}	//(Int BS_I=�]������l)
Function BS_K3UP(){		BS_RENEWAL_IKEY_3+=1;					BS_RENEWAL(0);}	//�P������ɓ]��
Function BS_K3DOWN(){		BS_RENEWAL_IKEY_3-=1;					BS_RENEWAL(0);}	//�P�������ɓ]��
Function BS_O(Int BS_I){	BS_RENEWAL_OKEY=BS_I;					BS_RENEWAL(0);}	//(Int BS_I=�㉺������I�N�^�[�u)
Function BS_OCTAVE(Int BS_I){	BS_RENEWAL_OKEY=BS_I;					BS_RENEWAL(0);}	//(Int BS_I=�㉺������I�N�^�[�u)
Function BS_OUP(){		BS_RENEWAL_OKEY+=1;					BS_RENEWAL(0);}	//�P�I�N�^�[�u���
Function BS_ODOWN(){		BS_RENEWAL_OKEY-=1;					BS_RENEWAL(0);}	//�P�I�N�^�[�u����
Function BS_FK(Int BS_I){	BS_RENEWAL_FVAL=BS_I;BS_RENEWAL_FKEY=BS_I*5%12;
					If(BS_RENEWAL_FKEY>6){BS_RENEWAL_FKEY-=12;}	BS_RENEWAL(0);}	//(Int BS_I=�T�x��(5������)�]��������l)
Function BS_FKEY(Int BS_I){	BS_RENEWAL_FVAL=BS_I;BS_RENEWAL_FKEY=BS_I*5%12;
					If(BS_RENEWAL_FKEY>6){BS_RENEWAL_FKEY-=12;}	BS_RENEWAL(0);}	//(Int BS_I=�T�x��(5������)�]��������l)
Function BS_TK(Int BS_I){	BS_RENEWAL_TVAL=BS_I;BS_RENEWAL_TKEY=BS_I*3;	BS_RENEWAL(0);}	//(Int BS_I=�Z�R�x�]��������l)
Function BS_TKEY(Int BS_I){	BS_RENEWAL_TVAL=BS_I;BS_RENEWAL_TKEY=BS_I*3;	BS_RENEWAL(0);}	//(Int BS_I=�Z�R�x�]��������l)

Function BS_Cb(){	BS_RENEWAL_FLAG=-0,-0,-0,-0,-0,-0,-0;BS_RENEWAL_FKRR= 0;BS_RENEWAL_FKRC=-1;BS_RENEWAL_FKRP=-1;BS_RENEWAL_MK={�b��};BS_RENEWAL(0);}	//�L�[���a�@��
Function BS_C(){	BS_RENEWAL_FLAG=-0,-0,-0,-0,-0,-0,-0;BS_RENEWAL_FKRR= 0;BS_RENEWAL_FKRC= 0;BS_RENEWAL_FKRP= 0;BS_RENEWAL_MK={�b�@};BS_RENEWAL(0);}	//�L�[���b�@��
Function BS_Cp(){	BS_RENEWAL_FLAG=-0,-0,-0,-0,-0,-0,-0;BS_RENEWAL_FKRR= 0;BS_RENEWAL_FKRC= 1;BS_RENEWAL_FKRP= 1;BS_RENEWAL_MK={�b��};BS_RENEWAL(0);}	//�L�[���b���
Function BS_Db(){	BS_RENEWAL_FLAG=-0,-0,+1,-0,-0,+1,-0;BS_RENEWAL_FKRR= 1;BS_RENEWAL_FKRC=-1;BS_RENEWAL_FKRP= 1;BS_RENEWAL_MK={�c��};BS_RENEWAL(0);}	//�L�[���c���
Function BS_D(){	BS_RENEWAL_FLAG=-0,-0,+1,-0,-0,+1,-0;BS_RENEWAL_FKRR= 1;BS_RENEWAL_FKRC= 0;BS_RENEWAL_FKRP= 2;BS_RENEWAL_MK={�c�@};BS_RENEWAL(0);}	//�L�[���c�@��
Function BS_Dp(){	BS_RENEWAL_FLAG=-0,-0,+1,-0,-0,+1,-0;BS_RENEWAL_FKRR= 1;BS_RENEWAL_FKRC= 1;BS_RENEWAL_FKRP= 3;BS_RENEWAL_MK={�c��};BS_RENEWAL(0);}	//�L�[���c���
Function BS_Eb(){	BS_RENEWAL_FLAG=-0,-0,+1,+1,-0,+1,+1;BS_RENEWAL_FKRR= 2;BS_RENEWAL_FKRC=-1;BS_RENEWAL_FKRP= 3;BS_RENEWAL_MK={�d��};BS_RENEWAL(0);}	//�L�[���d���
Function BS_E(){	BS_RENEWAL_FLAG=-0,-0,+1,+1,-0,+1,+1;BS_RENEWAL_FKRR= 2;BS_RENEWAL_FKRC= 0;BS_RENEWAL_FKRP= 4;BS_RENEWAL_MK={�d�@};BS_RENEWAL(0);}	//�L�[���d�@��
Function BS_Ep(){	BS_RENEWAL_FLAG=-0,-0,+1,+1,-0,+1,+1;BS_RENEWAL_FKRR= 2;BS_RENEWAL_FKRC= 1;BS_RENEWAL_FKRP= 5;BS_RENEWAL_MK={�d��};BS_RENEWAL(0);}	//�L�[���e�@��
Function BS_Fb(){	BS_RENEWAL_FLAG=-0,-1,-0,-0,-0,-0,-0;BS_RENEWAL_FKRR= 3;BS_RENEWAL_FKRC=-1;BS_RENEWAL_FKRP= 4;BS_RENEWAL_MK={�e��};BS_RENEWAL(0);}	//�L�[���d�@��
Function BS_F(){	BS_RENEWAL_FLAG=-0,-1,-0,-0,-0,-0,-0;BS_RENEWAL_FKRR= 3;BS_RENEWAL_FKRC= 0;BS_RENEWAL_FKRP= 5;BS_RENEWAL_MK={�e�@};BS_RENEWAL(0);}	//�L�[���e�@��
Function BS_Fp(){	BS_RENEWAL_FLAG=-0,-1,-0,-0,-0,-0,-0;BS_RENEWAL_FKRR= 3;BS_RENEWAL_FKRC= 1;BS_RENEWAL_FKRP= 6;BS_RENEWAL_MK={�e��};BS_RENEWAL(0);}	//�L�[���e���
Function BS_Gb(){	BS_RENEWAL_FLAG=-0,-0,-0,-0,-0,+1,-0;BS_RENEWAL_FKRR= 4;BS_RENEWAL_FKRC=-1;BS_RENEWAL_FKRP= 6;BS_RENEWAL_MK={�f��};BS_RENEWAL(0);}	//�L�[���f���
Function BS_G(){	BS_RENEWAL_FLAG=-0,-0,-0,-0,-0,+1,-0;BS_RENEWAL_FKRR= 4;BS_RENEWAL_FKRC= 0;BS_RENEWAL_FKRP= 7;BS_RENEWAL_MK={�f�@};BS_RENEWAL(0);}	//�L�[���f�@��
Function BS_Gp(){	BS_RENEWAL_FLAG=-0,-0,-0,-0,-0,+1,-0;BS_RENEWAL_FKRR= 4;BS_RENEWAL_FKRC= 1;BS_RENEWAL_FKRP= 8;BS_RENEWAL_MK={�f��};BS_RENEWAL(0);}	//�L�[���f���
Function BS_Ab(){	BS_RENEWAL_FLAG=-0,-0,+1,-0,-0,+1,+1;BS_RENEWAL_FKRR= 5;BS_RENEWAL_FKRC=-1;BS_RENEWAL_FKRP= 8;BS_RENEWAL_MK={�`��};BS_RENEWAL(0);}	//�L�[���`���
Function BS_A(){	BS_RENEWAL_FLAG=-0,-0,+1,-0,-0,+1,+1;BS_RENEWAL_FKRR= 5;BS_RENEWAL_FKRC= 0;BS_RENEWAL_FKRP= 9;BS_RENEWAL_MK={�`�@};BS_RENEWAL(0);}	//�L�[���`�@��
Function BS_Ap(){	BS_RENEWAL_FLAG=-0,-0,+1,-0,-0,+1,+1;BS_RENEWAL_FKRR= 5;BS_RENEWAL_FKRC= 1;BS_RENEWAL_FKRP=10;BS_RENEWAL_MK={�`��};BS_RENEWAL(0);}	//�L�[���`���
Function BS_Bb(){	BS_RENEWAL_FLAG=+1,-0,+1,+1,-0,+1,+1;BS_RENEWAL_FKRR= 6;BS_RENEWAL_FKRC=-1;BS_RENEWAL_FKRP=10;BS_RENEWAL_MK={�a��};BS_RENEWAL(0);}	//�L�[���a���
Function BS_B(){	BS_RENEWAL_FLAG=+1,-0,+1,+1,-0,+1,+1;BS_RENEWAL_FKRR= 6;BS_RENEWAL_FKRC= 0;BS_RENEWAL_FKRP=11;BS_RENEWAL_MK={�a�@};BS_RENEWAL(0);}	//�L�[���a�@��
Function BS_Bp(){	BS_RENEWAL_FLAG=+1,-0,+1,+1,-0,+1,+1;BS_RENEWAL_FKRR= 6;BS_RENEWAL_FKRC= 1;BS_RENEWAL_FKRP=12;BS_RENEWAL_MK={�a��};BS_RENEWAL(0);}	//�L�[���b�@��

Function BS_SCALE_UNDO(Int BS_SCALE_UNDO_R){	//�X�P�[����߂�
	If(BS_SCALE_UNDO_R==0){	BS_RENEWAL_SMBF(0)=BS_RENEWAL_SMBF(1);
					BS_RENEWAL_SMBF(1)=BS_RENEWAL_SMBF(2);
					BS_RENEWAL_SMBF(2)=BS_RENEWAL_SMBF(3);
					BS_RENEWAL_SMBF(3)=BS_RENEWAL_SMBF(4);
					BS_RENEWAL_SMBF(4)=100;}
	If(BS_SCALE_UNDO_R>0){
		For(Int BS_SCALE_UNDO_F=0;BS_SCALE_UNDO_F<BS_SCALE_UNDO_R;BS_SCALE_UNDO_F++){
			BS_RENEWAL_SMBF(0)=BS_RENEWAL_SMBF(1);
			BS_RENEWAL_SMBF(1)=BS_RENEWAL_SMBF(2);
			BS_RENEWAL_SMBF(2)=BS_RENEWAL_SMBF(3);
			BS_RENEWAL_SMBF(3)=BS_RENEWAL_SMBF(4);
			BS_RENEWAL_SMBF(4)=100;}
				}

	BS_RENEWAL_SMSW=off;
	
	Switch(BS_RENEWAL_SMBF(0)/100){
	Case(1){BS_MODE(BS_RENEWAL_SMBF(0)%100)}
	Case(2){BS_HMINOR(BS_RENEWAL_SMBF(0)%100)}
	Case(3){BS_MMINOR(BS_RENEWAL_SMBF(0)%100)}
	Case(4){BS_OTHER(BS_RENEWAL_SMBF(0)%100)}
	Case(5){BS_WORLD(BS_RENEWAL_SMBF(0)%100)}
		}
	}
Function BS_SCALE_MEMORY(Int BS_SCALE_MEMORY_I){
	Switch(BS_RENEWAL_SMSW){
	Case(on){
	BS_RENEWAL_SMBF(4)=BS_RENEWAL_SMBF(3);
	BS_RENEWAL_SMBF(3)=BS_RENEWAL_SMBF(2);
	BS_RENEWAL_SMBF(2)=BS_RENEWAL_SMBF(1);
	BS_RENEWAL_SMBF(1)=BS_RENEWAL_SMBF(0);
	BS_RENEWAL_SMBF(0)=BS_SCALE_MEMORY_I;
		}
	Case(off){BS_RENEWAL_SMSW=on;}
		}
	}

Function BS_MODE(Int BS_I){Switch(BS_I){	//���[�h�i������@�j�X�P�[����
Case(00){BS_SCALE_MEMORY(100);BS_RENEWAL_SLAG=0,0,0,0,0,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefgab};		BS_RENEWAL_MS={Ionian(Major)};}
Case(01){BS_SCALE_MEMORY(101);BS_RENEWAL_SLAG=0,-1,0,0,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-fgab-};		BS_RENEWAL_MS={Dorian};}
Case(02){BS_SCALE_MEMORY(102);BS_RENEWAL_SLAG=-1,-1,0,-1,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-fga-b-};	BS_RENEWAL_MS={Phrygian};}
Case(03){BS_SCALE_MEMORY(103);BS_RENEWAL_SLAG=0,0,0,0,0,1,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdef+gab};		BS_RENEWAL_MS={Lydian};}
Case(04){BS_SCALE_MEMORY(104);BS_RENEWAL_SLAG=0,-1,0,0,0,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefgab-};		BS_RENEWAL_MS={Mixolydian};}
Case(05){BS_SCALE_MEMORY(105);BS_RENEWAL_SLAG=-1,-1,0,0,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-fga-b-};		BS_RENEWAL_MS={Aeolian(Minor)};}
Case(06){BS_SCALE_MEMORY(106);BS_RENEWAL_SLAG=-1,-1,0,-1,-1,0,-1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-fg-a-b-};	BS_RENEWAL_MS={Locrian};}
 Default{BS_SCALE_MEMORY(100);BS_RENEWAL_SLAG=0,0,0,0,0,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefgab};		BS_RENEWAL_MS={Ionian(Major)};}
}BS_RENEWAL(0);}
Function BS_HMINOR(Int BS_I){Switch(BS_I){	//�n�[���j�b�N�}�C�i�[�X�P�[����
Case(00){BS_SCALE_MEMORY(200);BS_RENEWAL_SLAG=-1,0,0,0,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-fga-b};		BS_RENEWAL_MS={Harmonic Minor};}
Case(01){BS_SCALE_MEMORY(201);BS_RENEWAL_SLAG=0,-1,0,-1,-1,0,-1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-fg-ab-};	BS_RENEWAL_MS={Locrian 6};}
Case(02){BS_SCALE_MEMORY(202);BS_RENEWAL_SLAG=0,0,0,0,0,0,1;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefg+ab};		BS_RENEWAL_MS={Ionian #5};}
Case(03){BS_SCALE_MEMORY(203);BS_RENEWAL_SLAG=0,-1,0,0,-1,1,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-f+gab-};		BS_RENEWAL_MS={Dorian #11};}
Case(04){BS_SCALE_MEMORY(204);BS_RENEWAL_SLAG=-1,-1,0,-1,0,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-efga-b-};		BS_RENEWAL_MS={Harmonic Minor P5th Below};}
Case(05){BS_SCALE_MEMORY(205);BS_RENEWAL_SLAG=0,0,0,1,0,1,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd+ef+gab};		BS_RENEWAL_MS={Lydian #9};}
Case(06){BS_SCALE_MEMORY(206);BS_RENEWAL_SLAG=-1,-2,0,-1,-1,-1,-1;BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-eg-a-a};	BS_RENEWAL_MS={Altered b7};}
 Default{BS_SCALE_MEMORY(200);BS_RENEWAL_SLAG=-1,0, 0,0,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-fga-b};		BS_RENEWAL_MS={Harmonic Minor};}
}BS_RENEWAL(0);}
Function BS_MMINOR(Int BS_I){Switch(BS_I){	//�����f�B�b�N�}�C�i�[�X�P�[����
Case(00){BS_SCALE_MEMORY(300);BS_RENEWAL_SLAG=0,0,0,0,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-fgab};		BS_RENEWAL_MS={Melodic Minor};}
Case(01){BS_SCALE_MEMORY(301);BS_RENEWAL_SLAG=0,-1,0,-1,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-fgab-};		BS_RENEWAL_MS={Dorian -9};}
Case(02){BS_SCALE_MEMORY(302);BS_RENEWAL_SLAG=0,0,0,0,0,1,1;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdef+g+ab};		BS_RENEWAL_MS={Lydian #5};}
Case(03){BS_SCALE_MEMORY(303);BS_RENEWAL_SLAG=0,-1,0,0,0,1,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdef+gab-};		BS_RENEWAL_MS={Mixolydian #11 (Lyd 7)};}
Case(04){BS_SCALE_MEMORY(304);BS_RENEWAL_SLAG=-1,-1,0,0,0,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefga-b-};		BS_RENEWAL_MS={Mixolydian -13};}
Case(05){BS_SCALE_MEMORY(305);BS_RENEWAL_SLAG=-1,-1,0,0,-1,0,-1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-fg-a-b-};	BS_RENEWAL_MS={Aeolian -5 (SLoc)};}
Case(06){BS_SCALE_MEMORY(306);BS_RENEWAL_SLAG=-1,-1,0,-1,-1,-1,-1;BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-eg-a-b-};	BS_RENEWAL_MS={Altered};}
 Default{BS_SCALE_MEMORY(300);BS_RENEWAL_SLAG=0,0,0,0,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-fgab};		BS_RENEWAL_MS={Melodic Minor};}
}BS_RENEWAL(0);}
Function BS_OTHER(Int BS_I){Switch(BS_I){	//����ȃX�P�[����
Case(00){BS_SCALE_MEMORY(400);BS_RENEWAL_SLAG=3,3,0,0,0,2,2;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdega};		BS_RENEWAL_MS={Pentatonic};}
Case(01){BS_SCALE_MEMORY(401);BS_RENEWAL_SLAG=3,3,0,1,1,2,3;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={ce-ff+gb-};		BS_RENEWAL_MS={Pentatonic Minor Blues};}
Case(02){BS_SCALE_MEMORY(402);BS_RENEWAL_SLAG=3,4,0,1,1,2,3;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={ce-fgb-};		BS_RENEWAL_MS={Bluenote Pentatonic};}
Case(03){BS_SCALE_MEMORY(403);BS_RENEWAL_SLAG=0,-1,0,0,-1,0,-1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-ff+ab-};		BS_RENEWAL_MS={Bluenote -3,-7};}
Case(04){BS_SCALE_MEMORY(404);BS_RENEWAL_SLAG=-2,-2,0,-1,-1,-1,-1;BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=8;BS_RENEWAL_SEXN={c--|b+};	BS_RENEWAL_SNSM={cd-e-eg-ga|b-};	BS_RENEWAL_MS={Combination Diminish};}
Case(05){BS_SCALE_MEMORY(405);BS_RENEWAL_SLAG=1,1,0,0,0,1,1;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=6;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdef+g+a+};		BS_RENEWAL_MS={Wholetone Scale};}
Case(06){BS_SCALE_MEMORY(406);BS_RENEWAL_SLAG=-1,-2,0,0,-1,0,-1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=8;BS_RENEWAL_SEXN={c-|b++};	BS_RENEWAL_SNSM={cde-fg-a-a|b};	BS_RENEWAL_MS={Diminish Scale};}
Case(07){BS_SCALE_MEMORY(407);BS_RENEWAL_SLAG=-1,0,0,0,0,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefga-b};		BS_RENEWAL_MS={Harmonic Major};}
 Default{BS_SCALE_MEMORY(100);BS_RENEWAL_SLAG=0,0,0,0,0,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefgab};		BS_RENEWAL_MS={Ionian(Major)};}
}BS_RENEWAL(0);}
Function BS_WORLD(Int BS_I){Switch(BS_I){	//�����X�P�[����
Case(00){BS_SCALE_MEMORY(500);BS_RENEWAL_SLAG=3,3,0,0,1,2,2;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdfga};		BS_RENEWAL_MS={"�����@1"};}
Case(01){BS_SCALE_MEMORY(501);BS_RENEWAL_SLAG=0,-1,0,0,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-fgab-};		BS_RENEWAL_MS={"�����@2"};}
Case(02){BS_SCALE_MEMORY(502);BS_RENEWAL_SLAG=3,3,0,0,0,2,2;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdega};		BS_RENEWAL_MS={"�C���@1"};}
Case(03){BS_SCALE_MEMORY(503);BS_RENEWAL_SLAG=0,0,0,0,0,1,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdef+gab};		BS_RENEWAL_MS={"�C���@2"};}
Case(04){BS_SCALE_MEMORY(504);BS_RENEWAL_SLAG=3,2,0,-1,1,2,3;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-fga+};		BS_RENEWAL_MS={"�A���@(��s�`)"};}
Case(05){BS_SCALE_MEMORY(505);BS_RENEWAL_SLAG=3,3,0,-1,1,2,1;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-fga-};		BS_RENEWAL_MS={"�A���@(���s�`)"};}
Case(06){BS_SCALE_MEMORY(506);BS_RENEWAL_SLAG=3,3,0,0,1,2,3;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdfga+};		BS_RENEWAL_MS={"�z���@(��s�`)"};}
Case(07){BS_SCALE_MEMORY(507);BS_RENEWAL_SLAG=3,3,0,0,1,2,1;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdfga};		BS_RENEWAL_MS={"�z���@(���s�`)"};}
Case(08){BS_SCALE_MEMORY(508);BS_RENEWAL_SLAG=3,2,0,-1,-1,2,1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-ga-};		BS_RENEWAL_MS={"�o���X�P�[��"};}
Case(09){BS_SCALE_MEMORY(509);BS_RENEWAL_SLAG=3,2,0,-1,-1,0,1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-fa-};		BS_RENEWAL_MS={"�W�����X�P�[��"};}
Case(10){BS_SCALE_MEMORY(510);BS_RENEWAL_SLAG=-2,-3,0,-1,-1,-1,-2;BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=8;BS_RENEWAL_SEXN={c--|b++};	BS_RENEWAL_SNSM={cd-e-efga-|b-};	BS_RENEWAL_MS={"�X�p�j�b�V���X�P�[��"};}
Case(11){BS_SCALE_MEMORY(511);BS_RENEWAL_SLAG=-1,0,0,-1,0,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-efga-b};		BS_RENEWAL_MS={"�y���V�����X�P�[��"};}
Case(12){BS_SCALE_MEMORY(512);BS_RENEWAL_SLAG=-1,0,0,0,-1,1,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-f+ga-b};		BS_RENEWAL_MS={"�n���K���A���X�P�[��"};}
Case(13){BS_SCALE_MEMORY(513);BS_RENEWAL_SLAG=1,0,0,1,0,1,1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd+ef+g+a+b};	BS_RENEWAL_MS={"�G�j�O�}�`�b�N�X�P�[��"};}
Case(14){BS_SCALE_MEMORY(514);BS_RENEWAL_SLAG=0,0,0,-1,-1,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-fgab};		BS_RENEWAL_MS={"�i�|���^���X�P�[��"};}
Case(15){BS_SCALE_MEMORY(515);BS_RENEWAL_SLAG=-1,-1,0,0,0,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefga-b-};		BS_RENEWAL_MS={"�q���Y�[�X�P�[��1"};}
Case(16){BS_SCALE_MEMORY(516);BS_RENEWAL_SLAG=0,-1,0,-1,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-fgab-};		BS_RENEWAL_MS={"�q���Y�[�X�P�[��2"};}
Case(17){BS_SCALE_MEMORY(517);BS_RENEWAL_SLAG=-1,0,0,0,-1,1,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-f+ga-b};		BS_RENEWAL_MS={"�W�v�V�[�X�P�[��"};}
Case(18){BS_SCALE_MEMORY(518);BS_RENEWAL_SLAG=3,2,0,-1,-1,2,1;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-ga-};		BS_RENEWAL_MS={"�y���O�X�P�[��"};}
Case(19){BS_SCALE_MEMORY(519);BS_RENEWAL_SLAG=3,3,0,0,0,2,2;;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdega};		BS_RENEWAL_MS={"�X�����h���X�P�[��"};}
Case(20){BS_SCALE_MEMORY(520);BS_RENEWAL_SLAG=-2,-2,0,-1,-1,-1,-1;BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=8;BS_RENEWAL_SEXN={c--|b+};	BS_RENEWAL_SNSM={cd-e-ef+ga|b-};	BS_RENEWAL_MS={"���V�A��"};}
Case(21){BS_SCALE_MEMORY(521);BS_RENEWAL_SLAG=0,-1,0,0,-1,1,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cde-f+gab-};		BS_RENEWAL_MS={"�A���u(�}�J�[���E�q�W���[�Y)"};}
Case(22){BS_SCALE_MEMORY(522);BS_RENEWAL_SLAG=-1,-1,0,-1,-1,0,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-fga-b-};	BS_RENEWAL_MS={"�C���h(���[�K�E�o�C�����B)"};}
Case(23){BS_SCALE_MEMORY(523);BS_RENEWAL_SLAG=0,0,0,-1,-1,1,0;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-e-f+ga-b};	BS_RENEWAL_MS={"�C���h(���[�K�E�g�[�f�B)"};}
Case(24){BS_SCALE_MEMORY(524);BS_RENEWAL_SLAG=0,0,0,-1,0,1,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cd-ef+gab};		BS_RENEWAL_MS={"�C���h(���[�K�E�}����)"};}
Case(25){BS_SCALE_MEMORY(525);BS_RENEWAL_SLAG=3,3,0,0,1,2,3;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdfgb-};		BS_RENEWAL_MS={"�G�W�v�g�X�P�[��"};}
Case(26){BS_SCALE_MEMORY(526);BS_RENEWAL_SLAG=3,5,0,2,1,2,4;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cefgb};		BS_RENEWAL_MS={"����X�P�[��"};}
Case(27){BS_SCALE_MEMORY(527);BS_RENEWAL_SLAG=5,4,2,1,3,4,3;	BS_RENEWAL_SMMS=1;BS_RENEWAL_SNNM=5;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={de-gab-};		BS_RENEWAL_MS={"����"};}
 Default{BS_SCALE_MEMORY(100);BS_RENEWAL_SLAG=0,0,0,0,0,0,0;	BS_RENEWAL_SMMS=0;BS_RENEWAL_SNNM=7;BS_RENEWAL_SEXN={};		BS_RENEWAL_SNSM={cdefgab};		BS_RENEWAL_MS={"Ionian(Major)"};}
}BS_RENEWAL(0);}

Function BS_SCALE_b1(){		BS_RENEWAL_SPBE(2)=BS_RENEWAL_SPBE(2)-1;BS_RENEWAL(1);}	//1st���P��������
Function BS_SCALE_b2(){		BS_RENEWAL_SPBE(3)=BS_RENEWAL_SPBE(3)-1;BS_RENEWAL(1);}	//2nd(=9th)���P��������
Function BS_SCALE_b3(){		BS_RENEWAL_SPBE(4)=BS_RENEWAL_SPBE(4)-1;BS_RENEWAL(1);}	//3rd���P��������
Function BS_SCALE_b4(){		BS_RENEWAL_SPBE(5)=BS_RENEWAL_SPBE(5)-1;BS_RENEWAL(1);}	//4th(=11th)���P��������
Function BS_SCALE_b5(){		BS_RENEWAL_SPBE(6)=BS_RENEWAL_SPBE(6)-1;BS_RENEWAL(1);}	//5th���P��������
Function BS_SCALE_b6(){		BS_RENEWAL_SPBE(0)=BS_RENEWAL_SPBE(0)-1;BS_RENEWAL(1);}	//6th(=13th)���P��������
Function BS_SCALE_b7(){		BS_RENEWAL_SPBE(1)=BS_RENEWAL_SPBE(1)-1;BS_RENEWAL(1);}	//7th���P��������
Function BS_SCALE_b9(){		BS_RENEWAL_SPBE(3)=BS_RENEWAL_SPBE(3)-1;BS_RENEWAL(1);}	//9th(=2rd)���P��������
Function BS_SCALE_b11(){	BS_RENEWAL_SPBE(5)=BS_RENEWAL_SPBE(5)-1;BS_RENEWAL(1);}	//11th(=4th)���P��������
Function BS_SCALE_b13(){	BS_RENEWAL_SPBE(0)=BS_RENEWAL_SPBE(0)-1;BS_RENEWAL(1);}	//13th(=6th)���P��������
Function BS_SCALE_p1(){		BS_RENEWAL_SPBE(2)=BS_RENEWAL_SPBE(2)+1;BS_RENEWAL(1);}	//1st���P�������
Function BS_SCALE_p2(){		BS_RENEWAL_SPBE(3)=BS_RENEWAL_SPBE(3)+1;BS_RENEWAL(1);}	//2nd(=9th)���P�������
Function BS_SCALE_p3(){		BS_RENEWAL_SPBE(4)=BS_RENEWAL_SPBE(4)+1;BS_RENEWAL(1);}	//3rd���P�������
Function BS_SCALE_p4(){		BS_RENEWAL_SPBE(5)=BS_RENEWAL_SPBE(5)+1;BS_RENEWAL(1);}	//4th(=11th)���P�������
Function BS_SCALE_p5(){		BS_RENEWAL_SPBE(6)=BS_RENEWAL_SPBE(6)+1;BS_RENEWAL(1);}	//5th���P�������
Function BS_SCALE_p6(){		BS_RENEWAL_SPBE(0)=BS_RENEWAL_SPBE(0)+1;BS_RENEWAL(1);}	//6th(=13th)���P�������
Function BS_SCALE_p7(){		BS_RENEWAL_SPBE(1)=BS_RENEWAL_SPBE(1)+1;BS_RENEWAL(1);}	//7th���P�������
Function BS_SCALE_p9(){		BS_RENEWAL_SPBE(3)=BS_RENEWAL_SPBE(3)+1;BS_RENEWAL(1);}	//9th(=2rd)���P�������
Function BS_SCALE_p11(){	BS_RENEWAL_SPBE(5)=BS_RENEWAL_SPBE(5)+1;BS_RENEWAL(1);}	//11th(=4th)���P�������
Function BS_SCALE_p13(){	BS_RENEWAL_SPBE(0)=BS_RENEWAL_SPBE(0)+1;BS_RENEWAL(1);}	//13th(=6th)���P�������

Function BS_SCALE_MAJOR(){			BS_MODE(0);}	//Major Scale(cdefgab)(CM7)
Function BS_SCALE_MINOR(){			BS_MODE(5);}	//Minor Scale(cde-fga-b-)(Am7)

Function BS_SCALE_IONIAN(){			BS_MODE(0);}	//Ionian (cdefgab)(CM7)
Function BS_SCALE_DORIAN(){			BS_MODE(1);}	//Dorian (cde-fgab-)(Dm7)
Function BS_SCALE_PHRYGIAN(){			BS_MODE(2);}	//Phrygian (cd-e-fga-b-)(Em7)
Function BS_SCALE_LYDIAN(){			BS_MODE(3);}	//Lydian (cdef+gab)(FM7)
Function BS_SCALE_MIXOLYDIAN(){		BS_MODE(4);}	//Mixolydian (cdefgab-)(G7)
Function BS_SCALE_AEOLIAN(){			BS_MODE(5);}	//Aeolian (cde-fga-b-)(Am7)
Function BS_SCALE_LOCRIAN(){			BS_MODE(6);}	//Locrian (cd-e-fg-a-b-)(Bm7b5)

Function BS_SCALE_HMINOR(){				BS_HMINOR(0);}	//Harmonic Minor (cde-fga-b)(Cm7)
Function BS_SCALE_LOCRIAN_6(){			BS_HMINOR(1);}	//Locrian 6 (cd-e-fg-ab-)(Dm7b5)
Function BS_SCALE_LOCRIAN_13(){			BS_HMINOR(1);}	//Locrian 13 (cd-e-fg-ab-)(Dm7b5)
Function BS_SCALE_IONIAN_p5(){			BS_HMINOR(2);}	//Ionian #5 (cdefg+ab)(EbM7#5)
Function BS_SCALE_IONIANAUGEMENTED(){		BS_HMINOR(2);}	//Ionian Augemented (cdefg+ab)(EbM7#5)
Function BS_SCALE_DORIAN_p11(){			BS_HMINOR(3);}	//Dorian #11 (cde-f+gab-)(Fm7)
Function BS_SCALE_HMINORP5B(){			BS_HMINOR(4);}	//Harmonic Minor Perfect 5th Below (cd-efga-b-)(G7)
Function BS_SCALE_HMINORPERFECT5THBELOW(){	BS_HMINOR(4);}	//Harmonic Minor Perfect 5th Below (cd-efga-b-)(G7)
Function BS_SCALE_LYDIAN_p9(){			BS_HMINOR(5);}	//Lydian #9 (cd+ef+gab)(AbM7)
Function BS_SCALE_LYDIAN_p2(){			BS_HMINOR(5);}	//Lydian #2 (cd+ef+gab)(AbM7)
Function BS_SCALE_ALTERED_b7(){			BS_HMINOR(6);}	//Altered b7 (cd-e-eg-a-a)(Bdim)

Function BS_SCALE_MMINOR(){			BS_MMINOR(0);}	//Melodic Minor (cde-fgab)(Cm7)
Function BS_SCALE_DORIAN_b9(){		BS_MMINOR(1);}	//Dorian -9 (cd-e-fgab-)(Dm7)
Function BS_SCALE_DORIAN_b2(){		BS_MMINOR(1);}	//Dorian -2 (cd-e-fgab-)(Dm7)
Function BS_SCALE_LYDIAN_p5(){		BS_MMINOR(2);}	//Lydian #5 (cdef+g+ab)(EbM7#5)
Function BS_SCALE_LYDIANAUGEMENTED(){	BS_MMINOR(2);}	//Lydian Augemented (cdef+g+ab)(EbM7#5)
Function BS_SCALE_MIXOLYDIAN_p11(){		BS_MMINOR(3);}	//Mixolydian #11 (cdef+gab-)(F7)
Function BS_SCALE_LYDIAN_b7(){		BS_MMINOR(3);}	//Lydian -7 (cdef+gab-)(F7)
Function BS_SCALE_MIXOLYDIAN_b6(){		BS_MMINOR(4);}	//Mixolydian -6 (cdefga-b-)(G7)
Function BS_SCALE_MIXOLYDIAN_b13(){		BS_MMINOR(4);}	//Mixolydian -13 (cdefga-b-)(G7)
Function BS_SCALE_AEOLIAN_b5(){		BS_MMINOR(5);}	//Aeolian -5 (cde-fg-a-b-)(Abm7b5)
Function BS_SCALE_SUPERLOCRIAN(){		BS_MMINOR(5);}	//Super Locrian (cde-fg-a-b-)(Abm7b5)
Function BS_SCALE_LOCRIAN_2(){		BS_MMINOR(5);}	//Locrian 2 (cde-fg-a-b-)(Abm7b5)
Function BS_SCALE_ALTERED(){			BS_MMINOR(6);}	//Altered (cd-e-eg-a-b-)(B7)
Function BS_SCALE_ALTEREDDOMINANT(){	BS_MMINOR(6);}	//Altered Dominant (cd-e-eg-a-b-)(B7)
//----------------------------------------------------------------------------------------------
//	End Of bwb_scale.h
//----------------------------------------------------------------------------------------------
