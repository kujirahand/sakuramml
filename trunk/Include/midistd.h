//===========================================================================
//
//		Define for MIDI Standard
//
//
//									Programmed by	A.Watanabe
//
//---------------------------------------------------------------------------
//
//	Reference
//		(1)	MIDI Standard 1.0  v96.1
//		(2)	MIDI Standard 1.0  next edition		http://www.midi.org/
//
//===========================================================================
Include(midistd_cc.h);					//Control Change Message Define
Include(midistd_ex.h);					//System Exclusive Message Define

//Debug�p(Bit)
INT MidiStd_Debug = $0001;				//01 : �������e��Check����B(���Range)
										//02 : MML�ւ̕ϊ����ʂ�Prompt�ɏo�͂���B
										//04 : ����`
										//	�`
										//80 : ����`

//======================================================
//					Functions
//======================================================
//==============================================
//		���l�𕪉����܂�
//		�i���ʂ̃G�N�X�N���[�V�u���M���߁j
//----------------------------------------------
//		Input
//			INT	iSize	�����̔z��ϐ��ɂ��邩�H
//			INT	iValue	���l(LSB���ŏ�)
//		OutPut
//			Array	
//----------------------------------------------
Function DivValue(INT I_Size, INT I_Value){

	//���[�J���ϐ���`
	INT NumMul;						//���Z�p
	Array	A_Value=();				//�Ԃ�l�p�̔z��ϐ�

	//�����̃����WCheck
	If(MidiStd_Debug & $01){
		//�ő�l�̌v�Z
		INT	I_ValueMax=1;			//�ő�l�v�Z�p
		For(Int Loop=0; Loop<I_Size; Loop++) {
			I_ValueMax = (I_ValueMax*128);
		};

		//�ő�l�𒴂��Ă��邩Check
		If( (I_Value<0) | (I_Value=>I_ValueMax) ){
			Print("Wanning �����͈̔͂𒴂��Ă��܂��B Data=",I_Value);
			I_Value=0;
		};
	};

	//��������
	For(INT Loop=0; Loop<I_Size; Loop++){
		NumMul = 1;
		For(Int LoopMul=0; LoopMul<Loop; LoopMul++) {
			NumMul = (NumMul*128);
		};
		A_Value(Loop)=(I_Value & $7F*NumMul)/NumMul;
	};

	//�Ԃ�l
	Result = A_Value;
};
//==============================================
//		���l�𕪉����܂�
//		�i���ʂ̃G�N�X�N���[�V�u���M���߁j
//----------------------------------------------
//		Input
//			INT	iSize	�����̔z��ϐ��ɂ��邩�H
//			INT	iValue	���l(LSB���Ō�)
//		OutPut
//			Array	
//----------------------------------------------
Function DivValueX(INT I_Size, INT I_Value){

	//���[�J���ϐ���`
	INT NumMul;						//���Z�p
	Array	A_Value=();				//�Ԃ�l�p�̔z��ϐ�

	//�����̃����WCheck
	If(MidiStd_Debug & $01){
		//�ő�l�̌v�Z
		INT	I_ValueMax=1;			//�ő�l�v�Z�p
		For(Int Loop=0; Loop<I_Size; Loop++) {
			I_ValueMax = (I_ValueMax*128);
		};

		//�ő�l�𒴂��Ă��邩Check
		If( (I_Value<0) | (I_Value=>I_ValueMax) ){
			Print("Wanning �����͈̔͂𒴂��Ă��܂��B Data=",I_Value);
			I_Value=0;
		};
	};

	//��������
	For(INT Loop=0; Loop<I_Size; Loop++){
		NumMul = 1;
		For(Int LoopMul=0; LoopMul<Loop; LoopMul++) {
			NumMul = (NumMul*128);
		};
		A_Value(I_Size-Loop-1)=(I_Value & $7F*NumMul)/NumMul;
	};

	//�Ԃ�l
	Result = A_Value;
};
//==============================================
//		CheckSUM
//----------------------------------------------
//		Input
//			Array	A_Data		�f�[�^
//		OutPut
//			INT		CheckSum	�`�F�b�N�T��
//----------------------------------------------
Function CheckSum(Array A_Data){
	INT	A_Length=SizeOf(A_Data);
	INT	I_CheckSum=$00;

	For(INT I_Loop=0;I_Loop<A_Length;I_Loop++){
		I_CheckSum = I_CheckSum ^ A_Data(I_Loop);
	};
	Result = I_CheckSum;
};
