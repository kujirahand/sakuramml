/*==============================================================================
               �e�L�X�g���y�u�T�N���v - �W���������얽�߂̒�`�W
================================================================================
=title        "stdmsg.h" ver.1.40
=description  �W���I�Ȗ��߂��`�����t�@�C���B�����I�ɓǂݍ��ގd�g�݁B
--------------------------------------------------------------------------------
[����]
2000/03/22 ver.1.32
�W���I�ȉ������얽�߂��`�����B

2003/01/25 ver.1.40
XG�����ɓ��������s�v�Ȗ��߂��폜���A�R�����g����t��������
------------------------------------------------------------------------------*/



//------------------------------------------------------------------------------
//_�������Z�b�g����
Int DeviceNumber = $10;// ���Z�b�g���߂� DeviceNumber ��ς������Ƃ��ɕς���

Function ResetGM(){ // GM���Z�b�g�𑗐M����
	SysEx$=f0,7E,7F,9,1,F7;
	SoundType = 0;
}
Function ResetGS(){ // GS���Z�b�g�𑗐M����
	SysEx$=F0,41,(DeviceNumber),42,12,40,00,7F,00,41,F7;
	SoundType = 1;
}
Function ResetXG(){ // XG���Z�b�g�𑗐M����
	SysEx$=f0,43,(DeviceNumber),4c,0,0,7e,0,f7;
	SoundType = 2;
}

//------------------------------------------------------------------------------
//_NRPN�`���F�̕ҏW(�����ˑ�)
Function VibratoRate(mm)      { NRPN=1,8,(mm);   } //���F�̕ҏW(GS/XG)// mm=0-127
Function VibratoDepth(mm)	{ NRPN=1,9,(mm);   } //���F�̕ҏW(GS/XG)// mm=0-127 
Function VibratoDelay(mm)	{ NRPN=1,$A,(mm);  } //���F�̕ҏW(GS/XG)// mm=0-127
Function FilterCutoff(mm)	{ NRPN=1,$20,(mm); } //���F�̕ҏW(GS/XG)// mm=0-127
Function FilterResonance(mm)	{ NRPN=1,$21,(mm); } //���F�̕ҏW(GS/XG)// mm=0-127
Function EGAttack(mm)		{ NRPN=1,$63,(mm); } //���F�̕ҏW(GS/XG)// mm=0-127
Function EGDecay(mm)		{ NRPN=1,$64,(mm); } //���F�̕ҏW(GS/XG)// mm=0-127
Function EGRelease(mm)		{ NRPN=1,$66,(mm); } //���F�̕ҏW(GS/XG)// mm=0-127



//------------------------------------------------------------------------------
//_RPN�`�s�b�`�x���h�Ɋւ��閽��
Function PitchBendSensitivity(mm)	{ RPN=0,0,(mm); } //�s�b�`�x���h�͈̔͂�ݒ肷��//mm=0-12����(�����ˑ�)
Function BR(mm)				{ RPN=0,0,(mm); } //�s�b�`�x���h�͈̔͂�ݒ肷��//mm=0-12����(�����ˑ�)
Function FineTune(mm)			{ RPN=0,1,(mm); } //�`���[�j���O�̔�����//mm=0-64-127 (-100 - 0 - +99.99�Z���g�j���Z���g�F1�̔����̉����̊Ԃ�100���������`���[�j���O�̒P��
Function CoarseTune(mm)			{ RPN=0,2,(mm); } //�����P�ʂ̃`���[�j���O//mm=40-64-88 (-24 - 0 - 24����)



//------------------------------------------------------------------------------
//_GM���x���̊y���`
Int GrandPiano = 1 ;
Int BrightPiano = 2 ;
Int ElectricGrandPiano = 3 ;
Int HonkyTonkPiano = 4 ;
Int ElectricPiano1 = 5 ;
Int ElectricPiano2 = 6 ;
Int Harpsichord = 7 ;
Int Clavi = 8 ;
Int CelestaStrings = 9 ;
Int Glockenspiel = 10 ;
Int MusicBox = 11 ;
Int Vibraphone = 12 ;
Int Marimba = 13 ;
Int Xylophone = 14 ;
Int TubularBells = 15 ;
Int Dulcimer = 16 ;
Int DrawbarOrgan = 17 ;
Int PercussiveOrgan = 18 ;
Int RockOrgan = 19 ;
Int ChurchOrgan = 20 ;
Int ReedOrgan = 21 ;
Int Accordion = 22 ;
Int Hamonica = 23 ;
Int TangoAccordion = 24 ;
Int NylonGuitar = 25 ;
Int SteelcGuitar = 26 ;
Int JazzGuitar = 27 ;
Int CleanGuitar = 28 ;
Int MutedGuitar = 29 ;
Int OverdrivenGuitar = 30 ;
Int DistortionGuitar = 31 ;
Int GuitarHarmonics = 32 ;
Int AcousticBass = 33 ;
Int FingerBase = 34 ;//�Ԃ�~�X-ver.1�݊��̂���
Int FingerBass = 34 ;
Int PickBass = 35 ;
Int FretlessBass = 36 ;
Int SlapBass1 = 37 ;
Int SlapBass2 = 38 ;
Int SynthBass1 = 39 ;
Int SynthBass2 = 40 ;
Int Violin = 41 ;
Int Viola = 42 ;
Int Cello = 43 ;
Int Contrabass = 44 ;
Int TremoloStrings = 45 ;
Int PizzicatoStrings = 46 ;
Int OrchestralHarp = 47 ;
Int Timpani = 48 ;
Int Strings1 = 49 ;
Int Strings2 = 50 ;
Int SynthStrings1 = 51 ;
Int SynthStrings2 = 52 ;
Int ChoirAahs = 53 ;
Int VoiceOohs = 54 ;
Int SynthVoice = 55 ;
Int OrchestraHit = 56 ;
Int Trumpet = 57 ;
Int Trombone = 58 ;
Int Tuba = 59 ;
Int MutedTrumpet = 60 ;
Int FrenchHorn = 61 ;
Int BrassSection = 62 ;
Int SynthBrass1 = 63 ;
Int SynthBrass2 = 64 ;
Int SopranoSax = 65 ;
Int AltoSax = 66 ;
Int TenorSax = 67 ;
Int BaritoneSax = 68 ;
Int Oboe = 69 ;
Int EnglishHorn = 70 ;
Int Bassoon = 71 ;
Int Clarinet = 72 ;
Int Piccolo = 73 ;
Int Flute = 74 ;
Int Recorder = 75 ;
Int PanFlute = 76 ;
Int BlownBottle = 77 ;
Int Shakuhachi = 78 ;
Int Whistle = 79 ;
Int Ocarina = 80 ;
Int SquareLead = 81 ;
Int SawtoothLead = 82 ;
Int CalliopeLead = 83 ;
Int ChiffLead = 84 ;
Int CharangLead = 85 ;
Int VoiceLead = 86 ;
Int FifthsLead = 87 ;
Int BassLead = 88 ;
Int NewAgePad = 89 ;
Int WarmPad = 90 ;
Int PolySynthPad = 91 ;
Int ChoirPad = 92 ;
Int BowedPad = 93 ;
Int MetallicPad = 94 ;
Int HaloPad = 95 ;
Int SweepPad = 96 ;
Int Rain = 97 ;
Int SoundTrack = 98 ;
Int Crystal = 99 ;
Int Atmosphere = 100 ;
Int Brightness = 101 ;
Int Goblins = 102 ;
Int Echoes = 103 ;
Int Sci_Fi = 104 ;
Int Sitar = 105 ;
Int Banjo = 106 ;
Int Shamisen = 107 ;
Int Koto = 108 ;
Int Kalimba = 109 ;
Int Bagpipe = 110 ;
Int Fiddle = 111 ;
Int Shanai = 112 ;
Int TibkleBell = 113 ; //�Ԃ�~�Xver.1.xx�݊����̂���
Int TinkleBell = 113 ;
Int Agogo = 114 ;
Int SteelDrums = 115 ;
Int Woodblock = 116 ;
Int TaikoDrum = 117 ;
Int MelodicTom = 118 ;
Int SynthDrum = 119 ;
Int ReverseCymbal = 120 ;
Int FretNoise = 121 ;
Int BreathNoise = 122 ;
Int Seashore = 123 ;
Int BirdTweet = 124 ;
Int TelephoneRing = 125 ;
Int Helicopter = 126 ;
Int Applause = 127 ;
Int Gunshot = 128 ;

//-----------------------------------------------------------------------------
//_GS��XG���ʂ̃h�����Z�b�g�ԍ�

Int StandardSet = 1;
Int StandardSet2 = 2;
Int RoomSet = 9;
Int PowerSet = 17;
Int ElectronicSet = 25;
Int AnalogSet = 26;
Int DanceSet = 27;
Int JazzSet = 33;
Int BrushSet = 41;
Int OrchestraSet = 49;

//-----------------------------------------------------------------------------
//_�h�����m�[�g�ԍ����`

Int SnareRoll = 25;
Int FingerSnap = 26;
Int HighQ = 27;
Int Slap = 28;
Int ScratchPush = 29;
Int ScratchPull = 30;
Int Sticks = 31;
Int SquareClick = 32;
Int MetronomeClick = 33;
Int MetronomeBell = 34;
Int Kick2 = 35;
Int Kick1 = 36;
Int SideStick = 37;
Int Snare1 = 38;
Int HandClap = 39;
Int Snare2 = 40;
Int LowTom2 = 41;
Int ClosedHiHat = 42;
Int LowTom1 = 43;
Int PedalHiHat = 44;
Int MidTom2 = 45;
Int OpenHiHat = 46;
Int MidTom1 = 47;
Int HighTom2 = 48;
Int CrashCymbal1 = 49;
Int HighTom1 = 50;
Int RideCymbal1 = 51;
Int ChineseCymbal = 52;
Int RideBell = 53;
Int Tambourine = 54;
Int SplashCymbal = 55;
Int Cowbell = 56;
Int CrashCymbal2 = 57;
Int VibraSlap = 58;
Int RideCymbal2 = 59;
Int HighBongo = 60;
Int LowBongo = 61;
Int MuteHighConga = 62;
Int OpenHighConga = 63;
Int LowConga = 64;
Int HighTimbale = 65;
Int LowTimbale = 66;
Int HighAgogo = 67;
Int LowAgogo = 68;
Int Cabasa = 69;
Int Maracas = 70;
Int ShortHiWhistle = 71;
Int LongLowWhistle = 72;
Int ShortGuiro = 73;
Int LongGuiro = 74;
Int Claves = 75;
Int HighWoodBlock = 76;
Int LowWoodBlock = 77;
Int MuteCuica = 78;
Int OpenCuica = 79;
Int MuteTriangle = 80;
Int OpenTriangle = 81;
Int Shaker = 82;
Int JingleBell = 83;
Int BellTree = 84;
Int Castanets = 85;
Int MuteSurdo = 86;
Int OpenSurdo = 87;

//------------------------------------------------------------------------------
