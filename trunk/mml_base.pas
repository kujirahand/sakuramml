unit mml_base;
{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���F�T�N���̂l�l�k���r�l�e�ɕϊ����郁�C�����j�b�g

���@���F

2002/06/03 15:13 ���^�쐬
2002/06/16 11:03 �قڊ���
-------------------------------------------------------------------------------}

interface
uses
  Windows,
  Classes,           
  SysUtils,
  mml_const,
  mml_error,
  mml_var,
  mml_calc,
  mml_system,
  smf_types,
  smf_const,
  mml_types,
  mml_token2,
  Math;

//------------------------------------------------------------------------------
const
  //TODO: �o�[�W�������
  VER_INFO   = '2.372';
  DATE_INFO  = '2006/11/03';
  VER_NUMBER = 2372;
//------------------------------------------------------------------------------

type
  TMmlBase = class(TMmlSystem)
  private
    //�V�X�e������
    function scriptInt(var sp: TSrcPos): TMVarCustom;
    function scriptStr(var sp: TSrcPos): TMVarCustom;
    function scriptArray(var sp: TSrcPos): TMVarCustom;
    function scriptPrint(var sp: TSrcPos): TMVarCustom;
    function scriptPrintTime(var sp: TSrcPos): TMVarCustom;
    function scriptPrintTrackStatus(var sp: TSrcPos): TMVarCustom;
    //
    function scriptArraySortStr(var sp: TSrcPos): TMVarCustom;
    function scriptArraySortNum(var sp: TSrcPos): TMVarCustom;
    //
    function scriptLoopFrom(var sp: TSrcPos): TMVarCustom;
    function scriptLoopTo(var sp: TSrcPos): TMVarCustom;
    function scriptLoopBreak(var sp: TSrcPos): TMVarCustom;
    //
    function scriptFor(var sp: TSrcPos): TMVarCustom;
    function scriptWhile(var sp: TSrcPos): TMVarCustom;
    function scriptIf(var sp: TSrcPos): TMVarCustom;
    function scriptNext(var sp: TSrcPos): TMVarCustom; //'}'�̂���
    function scriptExit(var sp: TSrcPos): TMVarCustom;
    function scriptSwitch(var sp: TSrcPos): TMVarCustom;
    //
    function scriptRandom (var sp: TSrcPos): TMVarCustom;
    function scriptRandomSelect (var sp: TSrcPos): TMVarCustom;
    function scriptStep (var sp: TSrcPos): TMVarCustom;
    function scriptNoteNo (var sp: TSrcPos): TMVarCustom;
    function scriptIntToStr (var sp: TSrcPos): TMVarCustom;
    function scriptMML (var sp: TSrcPos): TMVarCustom;
    function scriptStrToLen (var sp: TSrcPos): TMVarCustom;
    function scriptStrToNum (var sp: TSrcPos): TMVarCustom;
    function scriptSizeOf (var sp: TSrcPos): TMVarCustom;
    function scriptHEX (var sp: TSrcPos): TMVarCustom;
    function scriptVarType (var sp: TSrcPos): TMVarCustom;
    //
    function scriptFunction(var sp: TSrcPos): TMVarCustom;
    function scriptResult(var sp: TSrcPos): TMVarCustom;
    function scriptArgOrder(var sp: TSrcPos): TMVarCustom;
    //MML����
    function funcLength(var sp: TSrcPos): TMVarCustom;
    function funcOctave(var sp: TSrcPos): TMVarCustom;
    function funcQgate(var sp: TSrcPos): TMVarCustom;
    function funcQgate2(var sp: TSrcPos): TMVarCustom;
    function funcTiming(var sp: TSrcPos): TMVarCustom;
    function funcVelocity(var sp: TSrcPos): TMVarCustom;
    function funcNoteA(var sp: TSrcPos): TMVarCustom;
    function funcNoteB(var sp: TSrcPos): TMVarCustom;
    function funcNoteC(var sp: TSrcPos): TMVarCustom;
    function funcNoteD(var sp: TSrcPos): TMVarCustom;
    function funcNoteE(var sp: TSrcPos): TMVarCustom;
    function funcNoteF(var sp: TSrcPos): TMVarCustom;
    function funcNoteG(var sp: TSrcPos): TMVarCustom;
    function funcNoteR(var sp: TSrcPos): TMVarCustom;
    function funcNoteN(var sp: TSrcPos): TMVarCustom;
    function funcDirectSmf(var sp: TSrcPos): TMVarCustom;
    function funcNoteOn(var sp: TSrcPos): TMVarCustom;
    function funcNoteOff(var sp: TSrcPos): TMVarCustom;
    function funcOctaveUp(var sp: TSrcPos): TMVarCustom;
    function funcOctaveDown(var sp: TSrcPos): TMVarCustom;
    function funcOctaveUpOnece(var sp: TSrcPos): TMVarCustom;
    function funcOctaveDownOnece(var sp: TSrcPos): TMVarCustom;
    function funcWaon(var sp: TSrcPos): TMVarCustom;
    function funcDiv(var sp: TSrcPos): TMVarCustom;
    function scriptTieMode(var sp: TSrcPos): TMVarCustom;
    //
    function scriptTrack(var sp: TSrcPos): TMVarCustom;
    function scriptTrackKey(var sp: TSrcPos): TMVarCustom;
    function scriptChannel(var sp: TSrcPos): TMVarCustom;
    function scriptTime(var sp: TSrcPos): TMVarCustom;
    function scriptSub(var sp: TSrcPos): TMVarCustom;
    function scriptPlay(var sp: TSrcPos): TMVarCustom;
    function scriptSystem(var sp: TSrcPos): TMVarCustom;
    function scriptTimeBase(var sp: TSrcPos): TMVarCustom;
    function scriptInclude(var sp: TSrcPos): TMVarCustom;
    function scriptKeyShift(var sp: TSrcPos): TMVarCustom;
    function scriptKeyFlag(var sp: TSrcPos): TMVarCustom;
    function scriptTimeKeyFlag(var sp: TSrcPos): TMVarCustom;
    function scriptTimeKey(var sp: TSrcPos): TMVarCustom;
    function scriptTimeKey2(var sp: TSrcPos): TMVarCustom;
    function scriptRythm(var sp: TSrcPos): TMVarCustom;
    function scriptRythmChar(var sp: TSrcPos): TMVarCustom;
    function scriptTrackSync(var sp: TSrcPos): TMVarCustom;
    function scriptTrackMute(var sp: TSrcPos): TMVarCustom;
    function scriptTrackMute2(var sp: TSrcPos): TMVarCustom;
    function scriptTrackSolo(var sp: TSrcPos): TMVarCustom;
    function scriptStretch(var sp: TSrcPos): TMVarCustom;
    function scriptPlayFrom(var sp: TSrcPos): TMVarCustom;
    function scriptPlayTo(var sp: TSrcPos): TMVarCustom;
    function scriptEnd (var sp: TSrcPos): TMVarCustom;
    function scriptMsgBox (var sp: TSrcPos): TMVarCustom;
    function scriptASC(var sp: TSrcPos): TMVarCustom;
    function scriptCHR(var sp: TSrcPos): TMVarCustom;
    function scriptMID(var sp: TSrcPos): TMVarCustom;
    function scriptPos (var sp: TSrcPos): TMVarCustom;
    function scriptPosEx(var sp: TSrcPos): TMVarCustom;
    function scriptReplace(var sp: TSrcPos): TMVarCustom;
    function scriptUseKeyShift(var sp: TSrcPos): TMVarCustom;
    function scriptCCMute(var sp: TSrcPos): TMVarCustom;
    function scriptCCNoMute(var sp: TSrcPos): TMVarCustom;


    //
    function scriptVoice(var sp: TSrcPos): TMVarCustom;
    function scriptCC(var sp: TSrcPos): TMVarCustom;
    function scriptBend(var sp: TSrcPos): TMVarCustom;
    function scriptBendFull(var sp: TSrcPos): TMVarCustom;
    function scriptRPN(var sp: TSrcPos): TMVarCustom;
    function scriptNRPN(var sp: TSrcPos): TMVarCustom;
    function scriptSysEx(var sp: TSrcPos): TMVarCustom;

    function scriptCC_M(var sp: TSrcPos): TMVarCustom;
    function scriptCC_PT(var sp: TSrcPos): TMVarCustom;
    function scriptCC_DataMSB(var sp: TSrcPos): TMVarCustom;
    function scriptCC_DataLSB(var sp: TSrcPos): TMVarCustom;
    function scriptCC_MainVolume(var sp: TSrcPos): TMVarCustom;
    function scriptCC_Panpot(var sp: TSrcPos): TMVarCustom;
    function scriptCC_Expression(var sp: TSrcPos): TMVarCustom;
    function scriptCC_PortamentoSwitch(var sp: TSrcPos): TMVarCustom;
    function scriptCC_Reverb(var sp: TSrcPos): TMVarCustom;
    function scriptCC_Chorus(var sp: TSrcPos): TMVarCustom;
    function scriptCC_VAR(var sp: TSrcPos): TMVarCustom;
    //���^�C�x���g
    function scriptTempo(var sp: TSrcPos): TMVarCustom;
    function scriptTempoChange(var sp: TSrcPos): TMVarCustom;
    function scriptTimeSig(var sp: TSrcPos): TMVarCustom;
    function scriptChPrefix(var sp: TSrcPos): TMVarCustom;
    function scriptMetaText (var sp: TSrcPos): TMVarCustom;
    function scriptCopyright (var sp: TSrcPos): TMVarCustom;
    function scriptTrackName (var sp: TSrcPos): TMVarCustom;
    function scriptInstrumentName (var sp: TSrcPos): TMVarCustom;
    function scriptLyric (var sp: TSrcPos): TMVarCustom;
    function scriptMarker  (var sp: TSrcPos): TMVarCustom;
    function scriptCuePoint (var sp: TSrcPos): TMVarCustom;
    function scriptPort (var sp: TSrcPos): TMVarCustom;
    function scriptExpressionChange(var sp: TSrcPos): TMVarCustom;
    function scriptExpressionChangeDecresc(var sp: TSrcPos): TMVarCustom;
    function scriptDeleteCC(var sp: TSrcPos): TMVarCustom;
    function scriptVersion(var sp: TSrcPos): TMVarCustom;
  private
    //��ȍ\����͂ɕK�v�ȉ�����(�N���X)
    TokenBase: TMmlTokenBase ;
    function  getArgs(var sp: TSrcPos): TMArray;   // �����z��𓾂�
    function  getArgsHex(var sp: TSrcPos): TMArray;// SysEx$ �΍�
    function  getArg(var sp: TSrcPos): TMVarCustom;// �����𓾂�
    function  getArgAndCalc(var sp: TSrcPos): TMVarCustom; // �v�Z�\�ȃp�����[�^�[���������𓾂�
    function  getArgsWithType(var sp: TSrcPos; varType: string): TMArray; //�ϐ��̌^���w�肵�Ēl�𓾂�
    function  GetNoteLength(var sp: TSrcPos; stepmode: Boolean; def: Integer): Integer; //�X�e�b�v�l�ň����𓾂�
    //�\����͂̉������I�Ȋ֐�
    function  GetIntValue(var sp: TSrcPos): Integer;
    function  GetIntValueAndCalc(var sp: TSrcPos): Integer;
    //function  getNumberM(var sp: TSrcPos): TMInt;
    //function  getArg_sub(var sp: TSrcPos): TMVarCustom;
    //function  GetTokenComma(var sp: TSrcPos): string; //�J���}������Ƃ���܂ł̃g�[�N���𓾂�
    function  GetTimeValue(var sp: TSrcPos): Integer; // Time(mes:beat:tick);�̈��������𓾂�
    //�V�X�e��/MML
    procedure AddSystemCommand;//�V�X�e�����߂��Ђ�����ǉ�����
    procedure makeVariable(var sp: TSrcPos; c:Char);
    procedure GetTrackDefaultValue(var len, gate, vel, tim, oct: Integer; var stepm: Boolean);
    //MML
    function  NoteOn(var sp: TSrcPos; NoteName: Char): TMInt; //NoteNo��Ԃ�
    function  SetNoteInfo(var sp: TSrcPos; var ni: TNoteInfos; pname:Char; IncValue: Integer): TMInt;//lqo�Ȃǂ̃p�������Z�b�g
    function  GetNowTimeKey(no: Integer): Integer; //MaxInt�Ȃ��K�p
    function  GetNoteNo(var sp: TSrcPos; NoteName: Char; UseKeyShift: Boolean): Integer;
    //�R���g���[���`�F���W�̏������݂Ȃ�
    procedure WriteCCWave(var ncc: TNoteCC; var track: TSmfTrack; noteLen, ch: Integer);
    procedure WriteCCOption(var sp: TSrcPos; cc: Integer);
    procedure WriteCCComand(var sp: TSrcPos; cc: Integer);
    procedure WritePicthBend(time,value: Integer);
    procedure WriteCCNoteOnTimeDirect(ccNo,time,fromValue,toValue,Len: Integer);
    procedure checkNoteOnCC(noteLen, ch: Integer);//�m�[�g�I�����̃C�x���g�`�F�b�N
    procedure WriteDirectSmf(byteArray: TArrayOfByte);
    procedure setRpnNrpn(var sp:TSrcPos; rpnType:TRpnType);
    procedure WriteMetaText(var sp: TSrcPos; mType: Byte);
    procedure WriteTempo(time, value: Integer);
    procedure cresc_sub(def1,def2: Integer; var sp: TSrcPos);//�N���b�V�F���h�A�f�N���b�V�F���h�̏���
    procedure DeleteCCAfterTime(track: TSmfTrack; ch, ccNo: Integer; time: Integer; CompleteDelete: Boolean); // �w��g���b�N�̃^�C���ȍ~�ɏ������܂ꂽ�R���g���[���`�F���W���폜����
  protected
    function  ExecuteCommand(node: TMHashNode; var sp: TSrcPos): TMVarCustom; override;// node ��n���Ēl�𓾂�
    procedure DebugMeta(text:string); //�f�o�b�O�p�̃��^�e�L�X�g
    function  PreCompile(src: string; lineNo: Integer): string;
    procedure Compile(var sp: TSrcPos);
    procedure Analize(var sp: TSrcPos);
    procedure Eval(src: string); //�������]���E���s����
  public
    constructor Create;
    destructor Destroy; override;
  private
    NestCountCompile: Integer; //Compile�֐����ċA�I�ɃR�[��������
  end;

implementation

uses StrUnit, mml_token;


{ TMmlBase }

constructor TMmlBase.Create;
begin
    inherited Create;
    AddSystemCommand;
    NestCountCompile := 0;
    TokenBase := TMmlTokenBase.Create(Self);
end;

destructor TMmlBase.Destroy;
begin
    TokenBase.Free ;
    inherited;
end;

procedure TMmlBase.AddSystemCommand;
var
  //���X�g�̐��l
  cmds: array [0..129] of Pointer;
  i: Integer;

    procedure tag_check(tag: Integer; p:Pointer; key:string);
    begin
      if (cmds[tag] <> nil)and(cmds[tag] <> p) then
      begin
        raise Exception.Create('���d��`"'+key+'"�FAddSystemCommand');
      end else
      begin
        cmds[tag] := p;
      end;
    end;

    function cmd( key: string; proc: TMFuncObj; tag: Integer ): TMHashNode;
    begin
      tag_check(tag, @proc, key);
      Result := TMHashNode.Create(key);
      Result.nodeType := ntSysFunc;
      Result.value := TMFunc.Create;
      Result.tag := tag;
      TMFunc(Result.value).funcPtr := proc;
      Commands.Add(Result);
    end;

    function v( key: string; val: Integer; tag: Integer ): TMHashNode;
    begin
      Result := TMHashNode.Create(key);
      Result.nodeType := ntInt;
      Result.value := TMInt.Create;
      Result.tag := tag;
      TMInt(Result.value).value := val;
      Commands.Add(Result);
    end;

    function vs( key: string; val: string; tag: Integer ): TMHashNode;
    begin
      Result := TMHashNode.Create(key);
      Result.nodeType := ntStr;
      Result.value := TMStr.Create;
      Result.tag := tag;
      TMStr(Result.value).value := val;
      Commands.Add(Result);
    end;

begin
    //todo: AddSystemCommand
    for i:=0 to High(cmds) do cmds[i] := nil;

    {�V�X�e�����߂�������}
    //��������
    cmd('l', funcLength,0);//l(n)//���̒�����n�������Ŏw��(�����l4)
    cmd('o', funcOctave,1);//o(n)//�I�N�^�[�u(���K)���w��(0~10�͈̔�)(�����l5)
    cmd('q', funcQgate,2);//q(n)//���̒����ɑ΂���Q�[�g�^�C���i�������ԁj�̊������p�[�Z���g�Ŏw��(0~100~���͈̔�)(�����l80)
    cmd('h', funcQgate2,113);//h(n)//�Q�[�g�l���X�e�b�v�l�Ō��Z�␳����(�����l0)
    cmd('v', funcVelocity,3);//v(n)//�x���V�e�B(���̋���)���w��(0~127�͈̔�)(�����l100)
    cmd('t', funcTiming,4); //t(n)//�����̃^�C�~���O���X�e�b�v�P�ʂŎw��(�����l0)
    cmd('<', funcOctaveDown,5); //<//�I�N�^�[�u���P������
    cmd('>', funcOctaveUp,6); //>//�I�N�^�[�u���P�グ��
    cmd('`', funcOctaveUpOnece,7); //`//�ꎞ�I�ɃI�N�^�[�u���P�グ��
    cmd('"', funcOctaveDownOnece,8); //"//�ꎞ�I�ɃI�N�^�[�u���P������
    cmd('''', funcWaon,9); //'mml'//'...'�̊Ԃ�a���Ƃ��Ĕ�������
    cmd('Div', funcDiv,10); //Div{mml}(n)//{...}�̊Ԃ�n�������̘A���Ƃ��Ĕ�������
    cmd('DIV', funcDiv,10); ////Div{mml}(n)//{...}�̊Ԃ�n�������̘A���Ƃ��Ĕ�������
    cmd( 'Slur', scriptTieMode,11 );//Slur(type[,value,range])//�^�C�L��"&"�̈ى���(�X���[)�̓����ύX����Btype=0:�O���b�T���h/1:�x���h/2:�Q�[�g/3:�A���y�W�I
    //����
    cmd('c', funcNoteC,12); //c[(l),(q),(v),(t),(o)]//�h�𔭉�����
    cmd('d', funcNoteD,13); //d[(l),(q),(v),(t),(o)]//���𔭉�����
    cmd('e', funcNoteE,14); //e[(l),(q),(v),(t),(o)]//�~�𔭉�����
    cmd('f', funcNoteF,15); //f[(l),(q),(v),(t),(o)]//�t�@�𔭉�����
    cmd('g', funcNoteG,16); //g[(l),(q),(v),(t),(o)]//�\�𔭉�����
    cmd('a', funcNoteA,17); //a[(l),(q),(v),(t),(o)]//���𔭉�����
    cmd('b', funcNoteB,18); //b[(l),(q),(v),(t),(o)]//�V�𔭉�����
    cmd('r', funcNoteR,19); //r//�x����\��
    cmd('^', funcNoteR,20); //^//�����Ɖ����̉��Z�L���B�����A�ˑR���ꂪ���ꂽ�Ƃ��́A�x���Ƃ��Ĉ���//
    cmd('n', funcNoteN,21); //n(NoteNo)[,(l),(q),(v),(t),(o)]//�m�[�g�ԍ����w�肵�Ĕ�������//
    //�g���b�N�E�`�����l��
    cmd( 'Track', scriptTrack,23 );//Track(n)//�g���b�N�ԍ����w�肷��(0~���͈̔�)�B�ǎ��B
    cmd( 'NowTrack', scriptTrack,23 );//Track(n)//�g���b�N�ԍ����w�肷��(0~���͈̔�)�B�ǎ��B
    cmd( 'TR', scriptTrack,23 );//Track(n)//�g���b�N�ԍ����w�肷��(0~���͈̔�)�ǎ��B
    cmd( 'Channel', scriptChannel,24 );//Channel(n)//�g���b�N�Ƀ`�����l����ݒ肷��(1~16�͈̔�)�B�ǎ��B
    cmd( 'CH', scriptChannel,24 );//Channel(n)//�g���b�N�Ƀ`�����l����ݒ肷��(1~16�͈̔�)�ǎ��B
    cmd( 'TrackSync', scriptTrackSync,25 );//TrackSync//�S�Ẵg���b�N�𓯃^�C���ɍ��킹��
    cmd( 'Time', scriptTime,26 );//Time((����:��:�X�e�b�v��)|(���X�e�b�v��))//�g���b�N�̃^�C���|�C���^���w�肷��B�ǎ��́A���X�e�b�v���B
    cmd( 'TIME', scriptTime,26 );//Time((����:��:�X�e�b�v��)|(���X�e�b�v��))//�g���b�N�̃^�C���|�C���^���w�肷��B�ǎ��́A���X�e�b�v���B
    cmd( 'Sub', scriptSub,27 );//Sub{(mml)}//mml�������݌�A�^�C���|�C���^��Sub�̑O�ɖ߂��B
    cmd( 'SUB', scriptSub,27 );//Sub{(mml)}//mml�������݌�A�^�C���|�C���^��Sub�̑O�ɖ߂��B
    cmd( 'S',   scriptSub,27 );//S{(mml)}//mml�������݌�A�^�C���|�C���^��Sub�̑O�ɖ߂��B
    cmd( 'Play', scriptPlay,28 );//Play({a},{b},{c}...)//�����g���b�N���P�x�ɏ�������
    cmd( 'PLAY', scriptPlay,28 );//Play({a},{b},{c}...)//�����g���b�N���P�x�ɏ�������
    cmd( 'Rythm', scriptRythm,29 );//Rhythm{...}//{...}�̒����A���Y�����[�h�ɂ���
    cmd( 'RYTHM', scriptRythm,29 );//Rhythm{...}//{...}�̒����A���Y�����[�h�ɂ���
    cmd( 'Rhythm', scriptRythm,29 );//Rhythm{...}//{...}�̒����A���Y�����[�h�ɂ���
    cmd( 'RHYTHM', scriptRythm,29 );//Rhythm{...}//{...}�̒����A���Y�����[�h�ɂ���
    cmd( '$', scriptRythmChar,30 );//$(char){...}//���Y�����[�h�ŗ��p����}�N����ݒ肷��
    cmd( 'Stretch', scriptStretch,31 );//Stretch{ mml }(len)//�t���[�Ymml���Alen�̒����ɃX�g���b�`���ď�������
    cmd( 'PlayFrom', scriptPlayFrom,32 );//PlayFrom(time|[.option])//�r�����牉�t����ꍇ�̐ݒ���s��
    cmd( 'PlayTo', scriptPlayTo,108 );//PlayTo(time)//���t��r���ŏI��点��ݒ���s��
    cmd( 'PrintTime', scriptPrintTime,33 );//PrintTime([n])//�w��g���b�N(�ȗ����̓J�����g�g���b�N)�́A�g���b�N�ԍ��y�у^�C���|�C���^�̏���\������
    cmd( 'PrintTrack', scriptPrintTrackStatus,34 );//PrintTrack([n])//�w��g���b�N(�ȗ����̓J�����g�g���b�N)�́A�g���b�N�����ڍׂɕ\������
    cmd( 'TrackMute', scriptTrackMute,35 );//TrackMute(on/off)//(on)�ł��̃R�}���h�ȍ~�̃g���b�N�̔������~���[�g(����)���A�^�C���|�C���^�̂ݐi�߂�
    cmd( 'Solo', scriptTrackSolo,36 );//Solo(n[,n,n...])//�w��g���b�N�݂̂�MIDI�t�@�C���ɏ����o��
    cmd( 'Mute', scriptTrackMute2,37 );//Mute(n[,n,n...])//�w��g���b�N��MIDI�t�@�C�������o�����~���[�g����
    cmd( 'TrackKey', scriptTrackKey,109 );//TrackKey(v)//�J�����g�g���b�N�̃L�[���Av�����グ��
    //���F�E�R���g���[���`�F���W
    cmd( 'Voice', scriptVoice,38 );//Voice(n[,msb,lsb])//���F���w�肷��(1~128�͈̔�)�ǎ��B
    cmd( '@', scriptVoice,38 );//@n[,msb,lsb]//���F���w�肷��(1~128�͈̔�)
    cmd( 'y', scriptCC,39 );//y(n),[(value)|.(option)]//�R���g���[���`�F���W����������(�S��0~127�͈̔�)
    cmd( 'p', scriptBend,40 );//p[%][(value)|.(option)]//�ȈՃs�b�`�x���h����������(0~63~127�͈̔�)(%�������-8192~0~8191)
    cmd( 'PitchBend', scriptBendFull,41 );//PitchBend[%][(value)|.(option)]//�s�b�`�x���h����������(-8192~0~8191�͈̔�)
    cmd( 'RPN', scriptRPN,42 );//RPN(msb,lsb,data)//RPN����������
    cmd( 'NRPN', scriptNRPN,43 );//NRPN(msb,lsb,data)//NRPN����������
    cmd( 'SysEx', scriptSysEx,44 );//SysEx[$]($F0,v1,v2,v3...,$F7)//SysEx���������ށB$���������͑S�Ă̐��l��16�i���Ƃ��Ĉ���
    cmd( 'Modulation', scriptCC_M,45 );//M(n)//���W�����[�V��������������
    cmd( 'M', scriptCC_M,45 );//M(n)//���W�����[�V��������������
    cmd( 'PortamentoTime', scriptCC_PT,46 );//PT(n)//�|���^�����g�^�C������������
    cmd( 'PT', scriptCC_PT,46 );//PT(n)//�|���^�����g�^�C������������
    cmd( 'DataMSB', scriptCC_DataMSB,47 );//DataMSB(n)//RPN/NRPN�̃f�[�^MSB����������
    cmd( 'Y', scriptCC_DataMSB,47 );//DataMSB(n)//RPN/NRPN�̃f�[�^MSB����������
    cmd( 'DataLSB', scriptCC_DataLSB,48 );//DataLSB(n)//RPN/NRPN�̃f�[�^LSB����������
    cmd( 'MainVolume', scriptCC_MainVolume,49 );//MainVolume(n)//���C���{�����[������������
    cmd( 'V', scriptCC_MainVolume,49 );//V(n)//���C���{�����[������������
    cmd( 'Panpot', scriptCC_Panpot,50 );//Panpot(n)//�p���|�b�g����������
    cmd( 'P', scriptCC_Panpot,50 );//P(n)//�p���|�b�g����������
    cmd( 'Expression', scriptCC_Expression,51 );//Expression(n)//�G�N�X�v���b�V��������������
    cmd( 'EP', scriptCC_Expression,51 );//EP(n)//�G�N�X�v���b�V��������������
    cmd( 'Cresc', scriptExpressionChange,118 );//Cresc([[[len],v1],v2])//���񂾂�傫���B�G�N�X�v���b�V������len(���������w���)�̊ԂɁAt1����t2�֕ύX����Blen���ȗ�����ƑS�����̒����ɂȂ�B
    cmd( 'Decresc', scriptExpressionChangeDecresc,119 );//Decresc([[[len],v1],v2])//���񂾂񏬂����B�G�N�X�v���b�V������len(���������w���)�̊ԂɁAt1����t2�֕ύX����Blen���ȗ�����ƑS�����̒����ɂȂ�B
    cmd( 'PortamentoSwitch', scriptCC_PortamentoSwitch,52 );//PortamentSwitch(n)//�|���^�����g�X�C�b�`����������
    cmd( 'PS', scriptCC_PortamentoSwitch,52 );//PS(n)//�|���^�����g�X�C�b�`����������
    cmd( 'Reverb', scriptCC_Reverb,53 );//Reverb(n)//���o�[�u����������
    cmd( 'REV', scriptCC_Reverb,53 );//REV(n)//���o�[�u����������
    cmd( 'Chorus', scriptCC_Chorus,54 );//Chorus(n)//�R�[���X����������
    cmd( 'CHO', scriptCC_Chorus,54 );//CHO(n)//�R�[���X����������
    cmd( 'VAR', scriptCC_VAR,55 );//VAR(n)//�o���G�[�V��������������
    cmd( 'DeleteCC', scriptDeleteCC,121 );//DeleteCC(n)//���̖��߈ȍ~�̃^�C���ɏ����ꂽ�R���g���[���`�F���W�E�s�b�`�x���h�����S�ɍ폜����B
    cmd( 'CCMute', scriptCCMute,123 );//CCMute(on/off)//�R���g���[���`�F���W�̏������݂��~���[�g����B�g���b�N���ƂɎw��ł���B
    cmd( 'CCNoMute', scriptCCNoMute,126 );//CCNoMute(no,on/off)//����̃R���g���[���`�F���W�i���o�[�̏������݂��~���[�g����B�g���b�N���ƂɎw��ł���B

    //���^�C�x���g
    cmd( 'Tempo', scriptTempo,56 );//Tempo(n)//�e���|��ݒ肷��(1~500�͈̔�)�B�ǎ��B
    cmd( 'TempoChange', scriptTempoChange,117 );//TempoChange(t1[[,t2],len])//�e���|��t1����t2��len(�X�e�b�v��)�̒����ŕύX����Bt2���ȗ�����ƁA���݂̃e���|����t1�܂ł̐��ځBlen���ȗ�����ƑS�����̒����ɂȂ�B
    cmd( 'TimeSignature', scriptTimeSig,57 );//TimeSignature(���q,����)//���q�L����ݒ肷��
    cmd( 'ChannelPrefix', scriptChPrefix,58 );//ChannelPrefix(n)//�`�����l���v���t�B�b�N�X��ݒ肷��(0~127�͈̔�)�B
    cmd( 'MetaText', scriptMetaText,59 );//MetaText={"text"}//���^�e�L�X�g���������ށB
    cmd( 'Copyright', scriptCopyright,60 );//Copyright={"text"}//���쌠�����������ށB
    cmd( 'TrackName', scriptTrackName,61 );//TrackName={"text"}//�g���b�N��/�Ȗ����������ށB
    cmd( 'InstrumentName', scriptInstrumentName,62 );//InstrumentName={"text"}//�y�햼���������ށB
    cmd( 'Lyric', scriptLyric,63 );//Lyric={"text"}//�̎����������ށB
    cmd( 'Marker', scriptMarker,64  );//Marker ={"text"}//�}�[�J�[���������ށB
    cmd( 'CuePoint', scriptCuePoint,65 );//CuePoint={"text"}//�L���[�|�C���g���������ށB
    cmd( 'Port', scriptPort,66 );//Port(n)//�|�[�g�ԍ����w�肷��i�A���|�[�g�ɑΉ������v���C���[���K�v�j
    cmd( 'PORT', scriptPort,66 );//PORT(n)//�|�[�g�ԍ����w�肷��i�A���|�[�g�ɑΉ������v���C���[���K�v�j

    //�V�X�e��
    cmd( 'System', scriptSystem,67 );//System.(�I�v�V����)//MML�V�X�e���̃J�X�^�}�C�Y�Ȃ�
    cmd( 'TimeBase', scriptTimeBase,68 );//TimeBase(n)//�^�C���x�[�X�i�l����������\�j��ݒ肷��
    cmd( 'Include', scriptInclude,69 );//Include(�t�@�C����)//�t�@�C������荞��Ŏ��s����
    cmd( 'Key', scriptKeyShift,70 );//Key(n)//�L�[��n�����グ��
    cmd( 'KeyFlag', scriptKeyFlag,72 );//KeyFlag[+|-](note)|KeyFlag=(a,b,c,d,e,f,g)//�Վ��L����ݒ肷��
    cmd( 'TimeKeyFlag', scriptTimeKeyFlag,73 );//TimeKeyFlag((fromTime),(toTime),(a,b,c,d,e,f,g))//���Ԃ��w�肵�ėՎ��L����ݒ肷��B(fromTime)���ȗ�����ƌ��݂̃^�C���A(toTime)���ȗ�����Ǝ��Ɏw�肪����܂ł��⊮�����
    cmd( 'TimeKey', scriptTimeKey,74 );//TimeKey((fromTime),(toTime),value)//���Ԃ��w�肵�ăL�[��valur�����グ��B(fromTime)���ȗ�����ƌ��݂̃^�C���A(toTime)���ȗ�����Ǝ��Ɏw�肪����܂ł��⊮�����
    cmd( 'TimeKey2', scriptTimeKey2,116 );//TimeKey2((fromTime),(toTime),value)//���Ԃ��w�肵�ăL�[��valur�����グ��(����2)�B(fromTime)���ȗ�����ƌ��݂̃^�C���A(toTime)���ȗ�����Ǝ��Ɏw�肪����܂ł��⊮�����
    v( 'SoundType',0, 75 );//SoundType=v//���[�U�[���g�p���Ă��鉹���̃^�C�v�𓾂�Bv=0:GM/1:GS/2:XG
    cmd('DirectSMF', funcDirectSmf,76); //DirectSMF(b1,b2,b3...)//����SMF�ɃC�x���g�𖄂ߍ���//
    cmd('NoteOn', funcNoteOn,77);  //NoteOn(noteno,velocity)//�m�[�g�I��������SMF�ɖ��ߍ���//
    cmd('NoteOff', funcNoteOff,78); //NoteOff(noteno,velocity)//�m�[�g�I�t������SMF�ɖ��ߍ���//
    cmd('UseKeyShift', scriptUseKeyShift,110); //UseKeyShift(on|off)//Key��TimeKey��TrackKey�̓K�p���I���I�t����
    cmd('ArgOrder', scriptArgOrder,114); //ArgOrder(lqvto)//�m�[�g(abcdefgn)�����̕��я����J�X�^�}�C�Y����

    //�X�N���v�g
    cmd( 'Int', scriptInt,79 );//Int name[=value];//�����^(32bit)�̕ϐ�(name)���쐬���A(value)�ŏ���������
    cmd( 'INT', scriptInt,79 );//Int name[=value];//�����^(32bit)�̕ϐ�(name)���쐬���A(value)�ŏ���������
    cmd( 'Integer', scriptInt,79 );//Integer name[=value];//�����^(32bit)�̕ϐ�(name)���쐬���A(value)�ŏ���������
    cmd( 'INTEGER', scriptInt,79 );//Integer name[=value];//�����^(32bit)�̕ϐ�(name)���쐬���A(value)�ŏ���������
    cmd( 'Str', scriptStr,80 );//Str name[=value];//������^�̕ϐ�(name)���쐬���A(value)�ŏ���������
    cmd( 'STR', scriptStr,80 );//Str name[=value];//������^�̕ϐ�(name)���쐬���A(value)�ŏ���������
    cmd( 'Array', scriptArray,81 );//Array name[=(value,value,value...)];//�z��ϐ�(name)���쐬���A(value,value,value...)�ŏ���������
    cmd( 'ARRAY', scriptArray,81 );//Array name[=(value,value,value...)];//�z��ϐ�(name)���쐬���A(value,value,value...)�ŏ���������
    cmd( 'Print', scriptPrint,82 );//Print(value);//value���A�R���\�[���ɕ\������
    cmd( 'PRINT', scriptPrint,82 );//Print(value);//value���A�R���\�[���ɕ\������
    //����\��
    cmd( '[', scriptLoopFrom,83 );//[n mml]//mml �� n����s����B�����Ō�̂P��̎�":"������΁A���[�v�̊O�֔�����
    cmd( ']', scriptLoopTo,84 );//[n mml]//mml �� n����s����B�����Ō�̂P��̎�":"������΁A���[�v�̊O�֔�����
    cmd( ':', scriptLoopBreak,85 );//[n mml]//mml �� n����s����B�����Ō�̂P��̎�":"������΁A���[�v�̊O�֔�����
    cmd( 'For', scriptFor,86 );//For(��������;������;�ď�����){ .. }//{ .. } �͈̔͂��I�����肪�^�ɂȂ�܂ŌJ��Ԃ�
    cmd( 'FOR', scriptFor,86 );//For(��������;������;�ď�����){ .. }//{ .. } �͈̔͂��I�����肪�^�ɂȂ�܂ŌJ��Ԃ�
    cmd( 'While', scriptWhile,87 );//For(��������;������;�ď�����){ .. }//{ .. } �͈̔͂��I�����肪�^�ɂȂ�܂ŌJ��Ԃ�
    cmd( 'WHILE', scriptWhile,87 );//For(��������;������;�ď�����){ .. }//{ .. } �͈̔͂��I�����肪�^�ɂȂ�܂ŌJ��Ԃ�
    cmd( 'If', scriptIf,88 );//If(������){ �^ }Else{ �U }//�������ɂ�菈���𕪂���
    cmd( 'IF', scriptIf,88 );//If(������){ �^ }Else{ �U }//�������ɂ�菈���𕪂���
    cmd( 'SWITCH', scriptSwitch,127 );//Switch(������){ Case (����){...} Default{...} }//�������ɂ�菈���𕪂���
    cmd( 'Switch', scriptSwitch,127 );//Switch(������){ Case (����){...} Default{...} }//�������ɂ�菈���𕪂���
    cmd( '}', scriptNext,89 );//{ .. }//{ .. }��΂ɂ��Ďg���A�͈͂�\��
    cmd( 'Exit', scriptExit,90 );//{ .. EXIT; }//For��While�̓r���ŁA�J��Ԃ��������甲����̂Ɏg��
    cmd( 'EXIT', scriptExit, 90);//{ .. EXIT; }//For��While�̓r���ŁA�J��Ԃ��������甲����̂Ɏg��
    cmd( 'Function', scriptFunction,91 );//Function ���O(�����錾){ ���e }//�֐����`����B�����錾�́A�w�^�� ���O[=�����l]�x�̂悤�ɏ���
    cmd( 'FUNCTION', scriptFunction,91 );//Function ���O(�����錾){ ���e }//�֐����`����B�����錾�́A�w�^�� ���O[=�����l]�x�̂悤�ɏ���
    cmd( 'Result', scriptResult,92 );//Result[=�ԋp�l]//�֐��̒l��ݒ肷��
    cmd( 'RESULT', scriptResult,92 );//Result[=�ԋp�l]//�֐��̒l��ݒ肷��
    //�ϐ�
    v('on', 1, 93); ////=1
    v('off', 0, 93); ////=0
    vs('?', ';PlayFrom(Time);', 120); //=PlayFrom(Time);//�������牉�t���J�n����
    
    //�g�ݍ��݊֐�
    cmd('Random', scriptRandom,94); //Random(num1[,num2])//num1~num2�̗�����Ԃ��B
    cmd('RandomSelect', scriptRandomSelect,95); //RandomSelect(n1,n2,n3...)//�����̒����烉���_���ɑI�񂾒l��Ԃ�
    cmd('Step', scriptStep,96); //Step(n)//"!���l"�Ɠ����B�O�o�[�W�����Ƃ̌݊����̂���
    cmd('STEP', scriptStep,96); //Step(n)//"!���l"�Ɠ����B�O�o�[�W�����Ƃ̌݊����̂���
    cmd('NoteNo', scriptNoteNo,97); //NoteNo(mml)//mml�ɏ����ꂽ�m�[�g�̃m�[�g�ԍ���Ԃ�
    cmd('#STR', scriptIntToStr,98); //#STR(num)//num�𕶎���ɕϊ����ĕԂ�
    cmd('MML', scriptMML,99); //MML(�R�}���h)//�R�}���h�Ɏw�肵���l�𓾂�B���p�ł���R�}���h(l|v|o|q|t|@|BR|p%|Key|TimeKey)
    cmd('StrToLen', scriptStrToLen,100); //StrToLen(n)//���ɏ������A���������w��̒������A�X�e�b�v�l�ɕϊ����ĕԂ�
    cmd('StrToNum', scriptStrToNum,101); //StrToNum(s)//s�ɏ�������������A���l�ɕϊ�����
    cmd('SizeOf', scriptSizeOf,102); //SizeOf(var)//var�ɏ������z��̃T�C�Y�𓾂�
    cmd('ASC', scriptASC,105); //ASC({str})//str�̕����R�[�h�𓾂�
    cmd('CHR', scriptCHR,129); //CHR(no)//�����R�[�hno�̕����𓾂�
    cmd('MID', scriptMID,106); //MID({str},Index,Len)//str��Index�Ԗڂ���ALen�����؂�o��
    cmd('POS', scriptPOS,115); //POS({sub},{str})//sub �� str�̉������ڂɂ��邩��������B������Ȃ��Ƃ��́A0��Ԃ��B
    cmd('POSX', scriptPOSEX,122); //POS({sub},{str})//sub �� str�̉������ڂɂ��邩��������B������Ȃ��Ƃ��́A0��Ԃ��B
    cmd('Replace', scriptReplace,107); //Replace({str},{A},{B},onoff)//str��A��B�ɒu������Bonoff�́A���߂̂P������u������ꍇ�́Aoff ���A���ׂĒu������ꍇ�� on ���Z�b�g����B
    cmd('HEX', scriptHEX,111); //HEX(n)//n ��16�i���ɕϊ�����
    cmd('VarType', scriptVarType,112); //VarType(var)//var �̌^�𔻕ʂ���

    cmd('ArraySortStr', scriptArraySortStr,124); //ArraySortStr(ary)//ary�𕶎���\�[�g����
    cmd('ArraySortNum', scriptArraySortNum,125); //ArraySortNum(ary)//ary�𐔒l�\�[�g����

    cmd('VERSION', scriptVersion,128); //VERSION//�o�[�W�������𐮐��ŕԂ�

    //���̑�
    cmd('End', scriptEnd,103); //End//�R���p�C���𒆎~����
    cmd('MsgBox', scriptMsgBox,104); //MsgBox({"str"})//�_�C�A���O�Ƀ��b�Z�[�W��\������

    {�V�X�e�����߂����܂�}
end;


function TMmlBase.getArgs(var sp: TSrcPos): TMArray;
begin
  Result := TokenBase.GetArgs(sp,'');
end;
//old ... 2002/10/31
(*
function TMmlBase.getArgs(var sp: TSrcPos): TMArray;
var
    sp2: TSrcPos;

    procedure getArray(var pp: TSrcPos);
    var
        mv: TMVarCustom;
        //sp3: TSrcPos;
    begin
        while True do
        begin
            skipSpace(pp.ptr);
            {if pp.ptr^ = '(' then      //todo: (a+b)-c�̂悤�ȂƂ�
            begin
                sp3 := TSrcPos.Create ;
                try
                    sp3.Assign(pp);
                    sp3.SetTempSource(GetMaruKakko(pp) );
                    getArray(sp3);
                finally
                    sp3.Free ;
                end;
            end else}
            begin
                mv := getArgAndCalc(pp) ;//�������P�擾
                if (mv<>nil)and(mv.ClassType = TMArray) then
                begin
                    Result.AddArray(mv as TMArray);
                end else
                begin
                    if mv=nil then
                    begin
                        //nil �Ȃ�A�_�~�[�̕������Ԃ�
                        Result.Add(TMStr.Create);
                    end else begin
                        Result.Add(mv) ;
                    end;
                end;
            end;
            skipSpace(pp.ptr);
            if pp.ptr^ in ValueSplitChar then //���������邩����
            begin
                Inc(pp.ptr);
            end else
                Break;//�I���
        end;
    end;

begin
    {�ȉ��́A���߂̈����ƌ��Ȃ�
        command num,arg,arg...
        command=arg,arg,arg...
        command(arg,arg,arg...) }

    // ���������邩���ʁB�Ȃ���΁A�m�h�k��Ԃ�
    skipSpace(sp.ptr);
    case sp.ptr^ of
    //��������
    '=':
        begin
            Inc(sp.ptr);
            Result := TMArray.Create ;
            getArray( sp );
        end;
    '(':
        begin //�J�b�R��W�J���āA�ϐ����Z�b�g����
            Result := TMArray.Create ;
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp);
                sp2.SetTempSource( getMaruKakko(sp) );
                try
                    getArray( sp2 );
                except
                    on e: Exception do raise EParserError.Create(e.Message);
                end;
            finally
                sp2.Free;
            end;
        end;
    '%','!','$','0'..'9','{','-':
        begin
            Result := TMArray.Create ;
            getArray(sp);
        end;
    //�����Ȃ�
    else
        begin
            Result := nil;
        end;
    end;
end;
*)

//�R�����g�̃g�����Ȃǈ�ʂ�I����Ă���\�[�X�ɑ΂��ĉ�͂��J��Ԃ��s��
procedure TMmlBase.Compile(var sp: TSrcPos);
var
  s: string;
  IsStopCompile: BOOL;
begin
  if FlagStopCompile then Exit;

  // �����ċA�Ăяo���̃`�F�b�N
  Inc(NestCountCompile);
  if NestCountCompile > 128 then
  begin
    FlagStopCompile := True;
    raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'�ċA�Ăяo���񐔂�128��𒴂��܂����B�B',sp));
  end;
  try
    if sp=nil then Exit;

    while sp.ptr^ <> #0 do
    begin
      if FlagStopCompile then Exit;

      skipSpace(sp.ptr);
      if sp.ptr^ = #13 then
      begin
        skipSpaceReturn(sp.ptr, sp.lineNo);
        // �r���o�߂̃��|�[�g
        if Assigned(OnProgress) then
        begin
          if nowpos <> nil then
          begin
            s := 'MML��͒� "' + nowpos.cmd + '"';
            if LastLine < nowpos.lineNo then LastLine := nowpos.lineNo;
            OnProgress(LastLine, LineCount, PChar(s), @IsStopCompile);
          end else
          begin
            OnProgress(-1, -1, nil, @IsStopCompile);
          end;
          // �R���p�C���̒��~
          if IsStopCompile then
          begin
            FlagStopCompile := True;
            sp := nil;
            raise EMml.Create(ErrMsg('���[�U�[�ɂ��R���p�C�������~����܂����B',sp));
          end;
        end;
      end;
      try
        // ���ۂ̎��s
        Analize(sp);
        if FuncBreak > 0 then
        begin
            Dec(FuncBreak);
            Exit;
        end;
      except
        //�R���p�C���̒��~���x�����A�G���[���đ��o
        FlagStopCompile := True;
        raise;
      end;
    end;
  finally
    if not FlagStopCompile then Dec(NestCountCompile);
  end;
end;

function TMmlBase.PreCompile(src: string; lineNo: Integer): string;
begin
    //�O�u����
    try
    //WriteComTime('���p��');
    Result := convToHalfSign(src, lineNo);//�S�p���p����
    //WriteLog(Result);
    //WriteComTime('�X�g�g����');
    Result := SutotonToMml(Result, lineNo);
    //WriteComTime('�v���v���I��');
    //WriteLog(Result);
    except
        on e: Exception do
            raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'�X�g�g���̋L�q�~�X�B'+e.Message,nil));
    end;
end;

procedure TMmlBase.Analize(var sp: TSrcPos);
var
    token: string;
    node: TMHashNode;
    ret: TMVarCustom;
    ArrayIndex: Integer;

    procedure LetVar; //�ϐ��֒l��������
    var
        v: TMVarCustom;
    begin
        node.DefinePos.Assign(sp);//�l���������ꏊ���擾

        //---������ׂ��l���擾����------------------------------------------
        //�z��ւ̑��������
        if node.nodeType <> ntArray then
        begin
            //�����A������ւ̎擾
            Inc(sp.ptr); // skip '='
            v := getArgAndCalc(sp);
        end else
        begin
            //�z��̎擾
            if ArrayIndex < 0 then
            begin //�z��̎擾
                v := getArgsWithType(sp,'a');
                //PrintCon(v.StrValue,sp);
            end else
            begin //�v�f�̎擾
                Inc(sp.ptr); // skip '='
                v := getArgAndCalc(sp);
                try try
                    if ArrayIndex >= TMArray(node.value).Count then
                    begin //Grow
                        TMArray(node.value).Items[ArrayIndex] := v.clone;
                    end else
                    begin
                        if TMArray(node.value).Items[ArrayIndex] <> nil then
                        begin
                          TMArray(node.value).Items[ArrayIndex].Assign(v);
                        end else
                        begin
                          TMArray(node.value).Items[ArrayIndex] := v.clone ;
                        end;
                    end;
                except //�^������Ȃ���΃G���[
                    on e: Exception do raise EMml.CreateFmt( ErrMsg(MML_ERR_VAR_ILLIGAL_TYPE+e.Message,sp),[node.key] );
                end;
                finally
                    v.Free ;
                end;
                Exit;
            end;
        end;

        //---���ۂɒl�̑�����s��-----------------------------------------
        try
            try
                //�^�ɕ����Ď����ϊ�
                if  v=nil then Exit;
                if node.value.ClassType = TMInt then
                begin
                    TMInt(node.value).value := v.IntValue ;
                    //_debug(IntToStr(TMInt(node.value).value));
                end else
                if node.value.ClassType = TMStr then
                begin
                    TMStr(node.value).value := v.StrValue ;
                end else
                if node.value.ClassType = TMArray then
                begin
                    if v.ClassType = TMArray then
                    begin //�z�񂩂�A�z��ւ̑��
                        TMArray(node.value).Assign(v) ;
                        //PrintCon(node.value.StrValue,sp);
                    end else
                    begin //������A���l���A�z��֑��
                        TMArray(node.value).Clear ;
                        TMArray(node.value).Add(v);
                    end;
                end else;
            except
                //�^������Ȃ���΃G���[
                on e: Exception do
                    raise EMml.CreateFmt( ErrMsg(MML_ERR_VAR_ILLIGAL_TYPE+e.Message,sp),[node.key] );
            end;
        finally
            v.Free ;
        end;

    end;

    procedure ExecuteStr;
    var
        sp2: TSrcPos;
        s: string;
        mv: TMArray;

        procedure extract_sharp_macro;
        var
            arg: TMArray; i: Integer; skey,ss,t: string;
            pp: PChar;
            v: TMStr;
        begin
            //�����𓾂�
            if sp.ptr^ = '(' then
            begin
                pp := sp.ptr;
                t := Trim(GetMaruKakko(sp));
                if Pos(',',t)=0 then
                begin
                    t := Trim(t);
                    if (Copy(t,1,1)='{')and(Copy(t,Length(t),1)='}') then
                    begin
                        t := Copy(t,2,Length(t)-2);
                    end;
                    v := TMStr.Create ;
                    v.value := t;
                    arg := TMArray.Create;
                    arg.Add(v);
                end else
                begin
                    sp.ptr := pp;
                    arg := getArgs(sp);
                    t := '';
                end;
            end else
                arg := nil;

            ss := node.value.StrValue ;
            if arg<>nil then
            begin
                if Pos('#?',ss)=0 then
                begin
                    ss := ss + arg.StrValue ;
                end else
                for i:=0 to arg.Count -1 do
                begin
                    skey := '#?' + IntToStr(i+1);
                    ss := JReplace(ss, skey, arg.Items[i].StrValue, True);
                end;
            end else
            begin
                ss := ss + t;
            end;
            //str�^�Ȃ�΁A�l��W�J����
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp);
                sp2.cmd := node.Key;
                node.DefinePos.cmd := node.Key ;
                sp2.SetTempSource( ss );
                try
                    Compile(sp2);
                except
                    raise EMml.CreateFmt( ErrMsg(MML_ERR_STR_EXPAND,node.DefinePos),[node.key] );
                end;
                sp2.cmd := '';
            finally
                sp2.Free ;
            end;
        
        end;

    begin
        //�I�v�V�������H
        if sp.ptr^ = '.' then
        begin
            Inc(sp.ptr);
            s := GetTokenChars(['(','=',' '],sp.ptr);
            Dec(sp.ptr); //'('�ȂǁA�i�߂���������A�P�߂�
            if s='s' then
            begin
                mv := getArgs(sp);
                if mv = nil     then raise EMml.CreateFmt( ErrMsg(MML_ERR_ARG,sp),[s] );
                if mv.Count < 2 then raise EMml.CreateFmt( ErrMsg(MML_ERR_ARG,sp),[s] );
                (node.value as TMStr).value := JReplace(
                    node.value.StrValue, mv.Items[0].StrValue,
                    mv.Items[1].StrValue, True);
                Exit;
            end else
                raise EMml.CreateFmt( ErrMsg(MML_ERR_UNKNOWN,sp),[s] );
        end;
        //#str(����)�ŁA�}�N���̓W�J���ł���
        if (Copy(node.Key,1,1)='#')and(sp.ptr^ = '(') then
        begin
            extract_sharp_macro;
            Exit;
        end;

        //str�^�Ȃ�΁A�l��W�J����
        sp2 := TSrcPos.Create ;
        try
            sp2.Assign(sp);
            sp2.cmd := node.Key;
            node.DefinePos.cmd := node.Key ;
            sp2.SetTempSource( (node.value as TMStr).value );
            try
                Compile(sp2);
            except
                raise EMml.CreateFmt( ErrMsg(MML_ERR_STR_EXPAND,node.DefinePos),[node.key] );
            end;
            sp2.cmd := '';
        finally
            sp2.Free ;
        end;
    end;

    procedure subIncDec; //�Ȃ񂿂���Ăb���ꕗ�́A���Z���Z
    var
        v,v2:TMVarCustom;
    begin
        v := node.value ;
        if v.ClassType <> TMInt then raise EMml.CreateFmt(ErrMsg(MML_ERR_NOT_INT,sp),[node.key]);
        if (sp.ptr^='+')and((sp.ptr+1)^='+') then //Inc����
        begin
            Inc(sp.ptr,2);
            Inc(TMInt(v).value);
        end else
        if (sp.ptr^='-')and((sp.ptr+1)^='-') then //Dec����
        begin
            Inc(sp.ptr,2);
            Dec(TMInt(v).value);
        end else
        if (sp.ptr^='+')and((sp.ptr+1)^='=') then //Var+=n
        begin
            Inc(sp.ptr,2);
            v2 := getArgAndCalc(sp); //�����P�̒l�𓾂�
            if v2 <> nil then
            begin
                Inc(TMInt(v).value, v2.IntValue);
                v2.Free ;
            end;
        end else
        if (sp.ptr^='-')and((sp.ptr+1)^='=') then //Var-=n
        begin
            Inc(sp.ptr,2);
            v2 := getArgAndCalc(sp); //�����P�̒l�𓾂�
            if v2 <> nil then
            begin
                Dec(TMInt(v).value, v2.IntValue);
                v2.Free ;
            end;
        end else
        if (sp.ptr^='*')and((sp.ptr+1)^='=') then //Var*=n
        begin
            Inc(sp.ptr,2);
            v2 := getArgAndCalc(sp); //�����P�̒l�𓾂�
            if v2 <> nil then
            begin
                TMInt(v).value := TMInt(v).value * v2.IntValue;
                v2.Free ;
            end;
        end else
        if (sp.ptr^='/')and((sp.ptr+1)^='=') then //Var/=n
        begin
            Inc(sp.ptr,2);
            v2 := getArgAndCalc(sp); //�����P�̒l�𓾂�
            if v2 <> nil then
            begin
                TMInt(v).value := TMInt(v).value div v2.IntValue;
                v2.Free ;
            end;
        end else
            raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[sp.ptr^+(sp.ptr+1)^])
    end;

    function getArrayIndex: Integer;
    var
        s: string; sp2: TSrcPos ;
    begin
        s := GetKakko(sp.ptr);
        sp2 := TSrcPos.Create ;
        try
            sp2.Assign(sp); 
            sp2.SetTempSource(s);
            try
            try
                ret := getArgAndCalc(sp2);
                Result := ret.IntValue;
            except
                Result := -1;
                raise EMml.CreateFmt(ErrMsg(MML_ERR_SYNTAX+'%s',sp),['�z��̗v�f�ԍ��̎擾�Ɏ��s']);
            end;
            finally
                ret.Free ;
            end;
        finally
            sp2.Free ;
        end;
    end;

    procedure makeStr2; // ������ϐ��𐶐�
    begin
        //'#'��
        node := TMHashNode.Create(token);
        node.DefinePos.Assign(sp);
        node.nodeType := ntStr ;
        node.value := TMStr.Create ;
        ParentCommands.Add(node);
    end;

begin
    //todo: analize
    //�󔒁A���s����
    skipSpaceReturn(sp.ptr, sp.lineNo);
    while sp.ptr^ in [' ',#9,';','|'] do Inc(sp.ptr);

    //1��ǂݏo��
    token := getTokenMML(sp.ptr);
    if token='' then Exit;
    //���O���c��
    if MmlOption.EventLog then WriteLog(SourceFileName(sp.fileNo)+'('+IntToStr(sp.lineNo)+'):'+token);

    //���߂��H
    node := Commands.Items[token];
    if node=nil then
    begin//"#�ϐ�"�� ���I��������
        //sp.cmd := '';
        if Copy(token,1,1)='#' then
        begin
            makeStr2;
        end;
    end;
    if node<>nil then
    begin
        case node.nodeType of
        ntSysFunc, ntUserFunc:
            begin
                //�֐������s����
                ret := ExecuteCommand(node, sp);
                if ret<>nil then
                begin
                    ret.Free ;
                    ret := nil;
                end;
            end;
        ntStr, ntInt, ntArray:
            begin
                skipSpace(sp.ptr);
                //�z��v�f�ւ̑�����H
                if (sp.ptr^ = '(')and(node.nodeType = ntArray) then
                begin
                    ArrayIndex := getArrayIndex;
                    skipSpace(sp.ptr);
                end else
                    ArrayIndex := -1;
                //������H
                if sp.ptr^ = '=' then
                begin
                    LetVar; Exit;
                end else
                //�ϐ��� Inc ������
                if (sp.ptr^='+')or(sp.ptr^='-') then
                begin
                    subIncDec; Exit;
                end else
                begin
                    //������̓W�J���H
                    if node.nodeType = ntStr then
                    begin
                        ExecuteStr;
                        Exit;
                    end;
                end;
                //����ł��A������̓W�J�ł��Ȃ��A�ˑR�A�ϐ������ꂽ��A�G���[�ɂ���
                raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_CANT_EXECUTE,sp),[token]);
            end;
        else
            begin//����`
            end;
        end;
    end else
    begin
        //���߂�������Ȃ�
        if token[1] in LeadBytes then
        begin
            ShowHint(Format(MML_ERR_UNKNOWN,[token]),sp);//�X�g�g���̏ꍇ�́A"Sakura v1"�ŃG���[�ɂȂ�Ȃ��B
        end else
        begin
            if token[1] in ['0'..'9'] then
            begin
                raise EMml.Create(ErrMsg('�ˑR��"'+token+'"�ł��B���߂��K�v�ł��B', sp));
            end else
            begin
                ShowHint('"'+token+'"�͖���`�ł��B�Â���m���߂Ă��������B', sp);
            end;
            //raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN, sp),[token]);
        end;
    end;
end;


function TMmlBase.scriptInt(var sp: TSrcPos): TMVarCustom;
begin
    makeVariable(sp, VAR_TYPE_INT);
    Result := nil;
end;

function TMmlBase.scriptStr(var sp: TSrcPos): TMVarCustom;
begin
    makeVariable(sp, VAR_TYPE_STR);
    Result := nil;
end;

function TMmlBase.scriptArray(var sp: TSrcPos): TMVarCustom;
begin
    makeVariable(sp, VAR_TYPE_ARRAY);
    Result := nil;
end;

function TMmlBase.scriptPrint(var sp: TSrcPos): TMVarCustom;
var
    v: TMArray;
begin
    v := getArgs(sp) ;
    try
        //_debug(v.StrValue);
        if v=nil then
        begin
            PrintCon('nil', sp);
        end else
        begin
            PrintCon(v.StrValue, sp);
        end;
    finally
        v.Free ;
    end;
    Result := nil;
end;

function TMmlBase.getArg(var sp: TSrcPos): TMVarCustom;
begin
  Result := TokenBase.GetArg(sp, False);
end;

(*
function TMmlBase.getNumberM(var sp: TSrcPos): TMInt;
var
    s: string;
    n: Integer;
    sign: Integer;
begin
    //�O�u�L�� ('-','+')
    sign := 1;
    if sp.ptr^ ='-' then
    begin
        Inc(sp.ptr); sign := -1;
    end else
    if sp.ptr^ = '+' then
    begin
        Inc(sp.ptr);
    end;

    if not(sp.ptr^ in ['$','0'..'9','!','%']) then
    begin
        Result := nil; Exit;
    end;
    Result := TMInt.Create;
    if sp.ptr^ = '%' then //�t���O�Z�b�g
    begin
        Result.Flag := '%'; Inc(sp.ptr);
    end;
    if sp.ptr^ = '!' then //(n)�������w��
    begin
        Inc(sp.ptr);
        s := GetNumber( sp.ptr );
        n := StrToInt( s );
        //�S�����̃^�C���x�[�X�𓾂āA���������Ŋ���
        Result.value := NtoStep(n);
    end else
    begin
        s := GetNumber( sp.ptr );
        Result.value := StrToIntDef( s, 0 ) * sign;
    end;
end;
*)

function TMmlBase.ExecuteCommand(node: TMHashNode; var sp: TSrcPos): TMVarCustom;
var
    nodeVar: TMVarCustom;
    n: TMVarCustom;
    i: Integer;
    tmp: TSrcPos;
    tmpS: string;

    procedure subUserFunc;
    var
        arg: TMArray;
        i,j: Integer;
        func: TMUserFunc;
        st: TMStruct;
        mv, temp: TMVarCustom;
        mv_node: TMHashNode;
    begin
        //todo: call UserFunc
        func := nodeVar as TMUserFunc;
        //�����̎擾
        skipSpace(sp.ptr);
        //���������邩�H
        if sp.ptr^ in ARG_CHAR then
        begin//�������擾
            try
                arg := getArgsWithType(sp, func.ArgType);
            except
                raise EMml.CreateFmt(ErrMsg(MML_ERR_CALL_FUNC+'�����̎擾�Ɏ��s���܂����B',sp),[node.key]);
            end;
        end else
        begin //�������Ȃ��ꍇ
            arg := TMArray.Create ; //�_�~�[���쐬
        end;
        //arg �ɏȗ�������΁A�����l���Z�b�g
        for i:=0 to Length(func.ArgType)-1 do
        begin
            if arg.Items[i] = nil then
            begin
                if func.ArgInit.Items[i]<>nil then
                    arg.Items[i] := func.ArgInit.Items[i].clone;
            end;
        end;
        //�֐��p�̍\���t���[�����쐬
        st := TMStruct.Create(Structs, stFunction);
        st.PosFrom.Assign(func.Src);
        st.PosTo.Assign(sp);
        //�t���ւ�
        Structs := st;
        Commands := st.varHash ;
        //�������A���[�J���ϐ��n�b�V���֓o�^
        for  i:= 0 to Length(func.ArgType)-1 do
        begin
            //�ϐ��n�b�V���m�[�h���쐬
            mv_node := TMHashNode.Create(func.ArgName[i]);

            //�^���Ƃɒl�𐶐�
            case func.ArgType[i+1] of//ArgType �́A�����񂾂��� +1 ����B�iPascal�̕�����́A�P����j
            'i':begin
                    mv := TMInt.Create ;
                    mv_node.nodeType := ntInt;
                    if arg.Items[i] <> nil then
                    begin
                        TMInt(mv).value := arg.Items[i].IntValue ;
                        //_debug(IntToStr(TMInt(mv).value));
                    end;
                end;
            's':begin
                    mv := TMStr.Create ;
                    mv_node.nodeType := ntStr;
                    if arg.Items[i] <> nil then
                        TMStr(mv).value := arg.Items[i].StrValue
                    else
                        TMStr(mv).value := '';
                end;
            'a':begin
                    mv := TMArray.Create ;
                    mv_node.nodeType := ntArray;
                    try
                        for j:=i to arg.Count -1 do
                        begin
                            TMArray(mv).Add(arg.Items[j]);
                        end;
                        mv_node.value := mv;
                        //�n�b�V���֓o�^
                        Commands.Add(mv_node);
                        Break;
                    except
                        raise EMml.CreateFmt(ErrMsg(MML_ERR_CALL_FUNC+' %d�Ԗڂ̈����̌^���Ⴂ�܂��B',sp),[node.key, i+1]);
                    end;
                end;
            else
                mv := TMInt.Create;
            end;
            mv_node.value := mv;
            //�n�b�V���֓o�^
            Commands.Add(mv_node);
        end;
        //�|�C���^���֐��̒���
        sp.Assign(func.Src);
        temp := FuncResult;
        FuncResult := nil;
        try
          Compile(sp);//���s
        finally
          //�Ԃ�l���Z�b�g���ă��[�U�[�֐��Ăяo������
          Result := FuncResult ;
          //_debug(Result.StrValue);
          FuncResult := temp;
        end;
    end;

    procedure getArrayValue;
    begin
        if sp.ptr^ = '(' then
        begin //�z��v�f�ւ̃A�N�Z�X
            n := getArg(sp) ;
            if n<>nil then
            begin
                i := n.IntValue ;
                n.Free;
                //n := nil;
                n := TMArray(nodeVar).Items[i];
                if n <> nil then Result := n.clone else Result := nil;
            end;
        end else
        begin
            Result := TMArray(nodeVar).clone ;
        end;
    end;

begin
    Result := nil;

    //�m�[�h�ɂԂ牺�����Ă���ϐ��𓾂�
    nodeVar := node.value ;
    if nodeVar = nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_SYSTEM+'�ϐ�"%s"�̒l���ݒ肳��Ă��܂���B',sp),[node.key]);

    //�ϐ��̃^�C�v�ʂɒl�𓾂�
    case node.nodeType of
        ntInt, ntStr:
        begin
            Result := nodeVar.clone ;
        end;
        ntArray:
        begin
            getArrayValue;
        end;
        ntSysFunc:
        begin
            try
                sp.cmd := node.Key ;
                Result := TMFunc(nodeVar).Execute(sp);
            except
              on e: Exception do
              begin
                raise EMml.CreateFmt(ErrMsg(MML_ERR_CALL_FUNC + e.Message,sp),[node.key]);
                Exit;
              end;
            end;
        end;
        ntUserFunc:
        begin
            tmp := TSrcPos.Create ;
            try
                try
                    sp.cmd := node.Key ;
                    tmpS := NowFunc;
                    NowFunc := node.Key ; //���݂̃��[�U�[�֐�
                    tmp.Assign(sp);
                    subUserFunc;
                    NowFunc := tmpS; //���݂̃��[�U�[�֐���߂�
                except
                    raise EMml.CreateFmt(ErrMsg(MML_ERR_CALL_USER_FUNC,tmp{�Ăяo���������}),[node.key]);
                end;
            finally
                tmp.Free ;
            end;
        end;
    end;

end;


procedure TMmlBase.makeVariable(var sp: TSrcPos; c:Char);
var
    node: TMHashNode;
    name: string;
    v: TMVarCustom;

    procedure CreateNodeValue;
    begin
        case c of
        VAR_TYPE_INT:
            begin
                node.value := TMInt.Create ;
                node.nodeType := ntInt;
            end;
        VAR_TYPE_STR:
            begin
                node.value := TMStr.Create ;
                node.nodeType := ntStr;
            end;
        VAR_TYPE_ARRAY:
            begin
                node.value := TMArray.Create ;
                node.nodeType := ntArray;
            end;
        end;
    end;

    procedure LetInitValue;
    begin
        // �����l���擾
        if sp.ptr^ = '(' then
        begin
            ShowHint('����ɂ́A"="���g���Ă��������B',sp); //�ȑO�̃o�[�W����
        end else
        if sp.ptr^ = '=' then
        begin
            Inc(sp.ptr); // skip '='
            skipSpaceReturn(sp.ptr, sp.lineNo);
            skipSpace(sp.ptr); 
        end;
        try
            case c of
            VAR_TYPE_INT:
                begin
                    v := getArgAndCalc(sp);
                    if v <> nil then
                    begin
                        TMInt(node.value).value := v.IntValue;
                        v.Free ;
                    end;
                end;
            VAR_TYPE_STR:
                begin
                    v := getArgAndCalc(sp);
                    if v<>nil then begin
                        TMStr(node.value).value := v.StrValue;
                        v.Free ;
                    end;
                end;
            VAR_TYPE_ARRAY:
                begin
                    skipSpace(sp.ptr);
                    if sp.ptr^ = '(' then
                    begin
                        v := getArgs(sp);
                        if v<>nil then
                        begin
                            TMArray(node.value).Assign(v);
                            v.Free ;
                        end;
                    end else begin //�z����ۓ���
                        //'='�܂Ŗ߂�
                        while sp.ptr^ <> '=' do Dec(sp.ptr);
                        v := getArgs(sp);
                        if v<>nil then
                        begin
                            if v.ClassType = TMArray then
                                TMArray(node.value).Assign(v)
                            else
                                TMArray(node.value).Add(v);
                            v.Free ;
                        end;
                    end;
                end;
            end;
        except
            //�擾�����l�����������^�ƈႦ�΃G���[
            raise EMml.CreateFmt(ErrMsg(MML_ERR_SYNTAX+'�ϐ�"%s"�̒l�̏������l�̎擾�Ɏ��s�B',sp),[name]);
        end;
    end;

begin
    skipSpace(sp.ptr);

    // �ϐ������擾
    name := getTokenWord(sp.ptr);
    if name='' then
    begin
        if sp.ptr^ in USER_DEFINE_CHAR then
        begin
            name := sp.ptr^;
            Inc(sp.ptr);
        end;
    end;
    if name='' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'���O������܂���B',sp),[sp.cmd]);

    //���[�J���ɓ������O���Ȃ����m�F
    if Commands.ExistsLocalKey(name) then
    begin
        ShowHint(Format(MML_ERR_VAR_ALREADY_EXISTS,[ name ]),sp);
        Commands.Delete(name);
        //raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_ALREADY_EXISTS,sp),[name]);
    end;

    // �ϐ��𐶐����A�n�b�V���ɒǉ�
    node := TMHashNode.Create(name);
    node.DefinePos.Assign(sp); //��`�ꏊ���L��

    //���ۂ̒l�𐶐�
    CreateNodeValue;
    Commands.Let( node ); // ���݂̕ϐ��Ǘ��p�̃n�b�V���ɓo�^

    // �����l�����邩
    skipSpace(sp.ptr);
    if sp.ptr^ in [ '=','(' ] then
    begin
        LetInitValue;
    end;
    //_debug(node.value.StrValue);
end;


function TMmlBase.scriptLoopFrom(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct;
    n : TMVarCustom ;
begin
    Result := nil;
    
    //�X�N���v�g�̉��w�\���𐶐�
    st := TMStruct.Create(Structs, stLoop);

    //���s�͈͂𓾂�  [n ... ] �l�X�Ƃ��ꂽ�J�b�R
    //�͈͐擪
    st.PosFrom.Assign(sp); // '['�̌� �A��ŁA[(n)... �� n �𓾂�

    //�͈͍Ō�
    Dec(sp.ptr);// back '['
    try
        skipKakko(sp.ptr, sp.lineNo, '[',']');
    except
        raise EMml.CreateFmt(ErrMsg(MML_ERR_KAKKO_NOT_PAIR,st.PosFrom),['[..]']);
    end;
    st.PosTo.Assign(sp);

    //���s�[�g�񐔂𓾂�
    try
        while st.PosFrom.ptr^ in [#9,' '] do Inc(st.PosFrom.ptr);
        if st.PosFrom.ptr^ in ARG_CHAR then
        begin
            n := getArg(st.PosFrom);
            if n=nil then st.LoopCount := 2 else
            begin
                st.LoopCount := n.IntValue ;
                n.Free ;
            end;
        end else
        begin
            st.LoopCount := 2;
        end;
    except
        raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE, sp),['[']);
    end;
    st.LoopIndex := 0;

    if st.LoopCount <= 0 then
    begin//���[�v���Ȃ�
        st.Free ;
        //sp�́A���s�[�g�̍Ō���w���Ă���̂ŁA���̂܂ܔ�����
        Exit;
    end;

    //�J�����g�\�����A�t���ւ���
    Commands := st.varHash ;
    Structs := st;
    sp.Assign(Structs.PosFrom);
end;

function TMmlBase.scriptLoopTo(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct;
begin
    Result := nil;

    //�������̃`�F�b�N
    if Structs.StructType <> stLoop then raise EMml.CreateFmt(ErrMsg(MML_ERR_KAKKO_NOT_PAIR,sp),['[..]']);

    //���s�[�g�񐔂��`�F�b�N
    Inc(Structs.LoopIndex);
    if Structs.LoopIndex >= Structs.LoopCount then
    begin
        //���[�v�I��
        st := Structs.Parent ;
        Structs.Free ;//�J�����g�\�����A�j��
        Structs := st;//�e�ɕt���ւ�
        Commands := Structs.varHash ;
        Exit;
    end;

    //���[�v�擪�֖߂�
    sp.Assign(Structs.PosFrom);
end;

function TMmlBase.scriptLoopBreak(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct;
begin
    Result := nil;

    //�������̃`�F�b�N
    if Structs.StructType <> stLoop then raise EMml.CreateFmt(ErrMsg(MML_ERR_KAKKO_NOT_PAIR,sp),['[ : ]']);

    //���s�[�g�񐔂��`�F�b�N
    if (Structs.LoopIndex+1) = Structs.LoopCount then //�Ō�̈�񂩁H
    begin
        //���[�v�I��
        sp.Assign(Structs.PosTo); // ] ���Ƀ|�C���^��t���ւ�

        st := Structs.Parent ;
        Structs.Free ;//�J�����g�\�����A�j��
        Structs := st;//�e�ɕt���ւ�
        Commands := Structs.varHash ;

        Exit;
    end;
end;

function TMmlBase.scriptFor(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    st: TMStruct;
    v: TMVarCustom;
begin
    //todo: FOR
    Result := nil;
    st := TMStruct.Create(Structs, stFor);

    //���������A�������A�ď��������𓾂�
    s := getMaruKakko(sp); //For �̌�́A(..) �𓾂�
    st.siki1 := GetToken(';', s);
    st.Jouken := GetToken(';', s);
    st.siki2 := s;

    //�J��Ԃ��͈͊J�n�𓾂�
    skipSpaceReturn(sp.ptr, sp.lineNo);
    if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('For�̌�� "{" ������܂���B',sp));
    st.PosFrom.Assign(sp);
    Inc(st.PosFrom.ptr); //skip '{'

    //�͈͏I���𓾂�
    skipKakko(sp.ptr, sp.lineNo, '{','}');
    st.PosTo.Assign(sp);

    //�X�N���v�g�\���̃X�R�[�v��For�ɕt���ւ�
    Structs := st;
    Commands := Structs.varHash ;

    //�������������s
    sp.ptr := PChar(Structs.siki1);
    try
        Compile(sp);
    except
        raise EMml.Create(ErrMsg('For�̏������Ɏ��s�B',sp));
    end;

    //��������]��
    sp.ptr := PChar(Structs.Jouken);
    v := getArgAndCalc(sp);
    try
        if v.IntValue = BOOL_FALSE then
        begin //For �����Ȃ���s���Ȃ��Ƃ�
            sp.Assign(Structs.PosTo);
            st := Structs.Parent ; // Structs ���A�e�ɕt���ւ���
            Structs.Free ;
            Structs := st;
            Commands := Structs.varHash ;
            Exit;
        end;
        sp.Assign(Structs.PosFrom); //�e�����擪�ɔ�� 
    finally
        v.Free ;
    end;
end;

function TMmlBase.scriptNext(var sp: TSrcPos): TMVarCustom;
const
  CHECK_MUGEN = 4096;

    procedure LoopLast;
    var
        st: TMStruct ;
    begin
        st := Structs.Parent ;
        Structs.Free ;
        Structs := st;
        Commands := Structs.varHash ;
    end;

    procedure subFor;
    var
        v: TMVarCustom;
    begin
        //�ď������������s
        sp.lineNo := Structs.PosFrom.lineNo ;
        sp.ptr := PChar( Structs.siki2 );
        Compile(sp);
        //��������]��
        sp.ptr := PChar( Structs.Jouken );
        v := getArgAndCalc(sp);
        if (v=nil) or (v.IntValue = BOOL_FALSE) then
        begin //For ���甲����
            sp.Assign(Structs.PosTo); //For ���Ƀ|�C���^��t���ւ�
            LoopLast;
            Exit;
        end else
        begin
            Inc(Structs.LoopCount);
            if Structs.LoopCount > CHECK_MUGEN then
            begin
                raise EMml.Create(ErrMsg(MML_ERR_SYSTEM+'FOR�Ŗ������[�v�̉\��������܂��B',sp));
            end;
        end;
        sp.Assign(Structs.PosFrom); //�J��Ԃ��擪�ɖ߂�
    end;

    procedure subWhile;
    var
        v: TMVarCustom;
    begin
        //��������]��
        sp.lineNo := Structs.PosFrom.lineNo ;
        sp.ptr := PChar( Structs.Jouken );
        v := getArgAndCalc(sp);
        if (v=nil) or (v.IntValue = BOOL_FALSE) then
        begin //While ���甲����
            sp.Assign(Structs.PosTo); //While ���Ƀ|�C���^��t���ւ�
            LoopLast;
            Exit;
        end else
        begin
            Inc(Structs.LoopCount);
            if Structs.LoopCount > CHECK_MUGEN then
            begin
                raise EMml.Create(ErrMsg(MML_ERR_SYSTEM+'WHILE�Ŗ������[�v�̉\��������܂��B',sp));
            end;
        end;
        sp.Assign(Structs.PosFrom); //�J��Ԃ��擪�ɖ߂�
    end;

    procedure subIF;
    begin
        sp.Assign(Structs.PosTo); //If ���Ƀ|�C���^��t���ւ�
        LoopLast;
        Exit;
    end;

    procedure subFunc;
    begin
        sp.Assign(Structs.PosTo); //���̈ʒu�ɖ߂�
        LoopLast;
        Inc(FuncBreak);
        Exit;
    end;

    procedure subSwitch;
    begin
        sp.Assign(Structs.PosTo); //If ���Ƀ|�C���^��t���ւ�
        LoopLast;
        Exit;
    end;

begin
    Result := nil;
    //�\�����������������f
    if Structs.StructType = stNormal then
    begin
        //raise EMml.CreateFmt(ErrMsg('�ˑR��"}"�B'+MML_ERR_KAKKO_NOT_PAIR,sp),['{ .. }']);
        ShowHint('�ˑR��"}"�B',sp);
        Exit;
    end;
    //�\�����ɂ���āA�����𕪊�
    case Structs.StructType of
        stFor: subFor;
        stWhile: subWhile;
        stIf: subIf;
        stSwitch: subSwitch;
        stFunction: subFunc;
    end;
end;

function TMmlBase.scriptWhile(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct ;
    v: TMVarCustom;
begin
    Result := nil;
    st := TMStruct.Create(Structs, stWhile);

    //�������𓾂�
    st.Jouken := getMaruKakko(sp);
    skipSpaceReturn(sp.ptr, sp.lineNo);

    //While�͈̔͊J�n�ʒu�𓾂�
    if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('While �̌�� "{" ������܂���B',sp));
    st.PosFrom.Assign(sp);
    Inc(st.PosFrom.ptr); // skip '{'

    //�͈͏I���ʒu�𓾂�
    skipKakko(sp.ptr, sp.lineNo, '{','}');
    st.PosTo.Assign(sp);

    //��������]��
    sp.lineNo := st.PosFrom.lineNo ;
    sp.ptr := PChar( st.Jouken );
    v := getArgAndCalc(sp);
    try
    if (v=nil)or(v.IntValue = BOOL_FALSE) then
    begin//���s���Ȃ�
        sp.Assign(st.PosTo);
        st.Free ;
        Exit;
    end;
    finally
        v.Free ;
    end;
    //�t���ւ�
    Structs := st;
    Commands := Structs.varHash ;
    sp.Assign(Structs.PosFrom);
end;

function TMmlBase.scriptIf(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct ;
    v: TMVarCustom;
begin
    Result := nil;
    st := TMStruct.Create(Structs, stIf);

    //�������𓾂�
    st.Jouken := getMaruKakko(sp);
    skipSpaceReturn(sp.ptr, sp.lineNo);

    //If�͈̔͊J�n�ʒu�𓾂�
    if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('If �̌�� "{" ������܂���B',sp));
    st.PosFrom.Assign(sp);
    Inc(st.PosFrom.ptr); // skip '{'

    //�͈͏I���ʒu�𓾂�
    skipKakko(sp.ptr, sp.lineNo, '{','}');
    st.PosTo.Assign(sp);

    //Else�����邩�H�H
    skipSpaceReturn(sp.ptr, sp.lineNo);
    skipSpace(sp.ptr);
    if (StrLcomp(sp.ptr, 'ELSE', 4) = 0)or(StrLcomp(sp.ptr, 'Else', 4) = 0) then
    begin //Else������
        Inc(sp.ptr,4); //skip "Else"

        //Else�J�n�ʒu�𓾂�
        skipSpaceReturn(sp.ptr, sp.lineNo);
        if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('If..Else �̌�� "{" ������܂���B',sp));
        st.PosElse.Assign(sp);
        Inc(st.PosElse.ptr); // skip '{'
        //Else�I���ʒu
        skipKakko(sp.ptr, sp.lineNo, '{','}');
        st.PosTo.Assign(sp);
    end else
    begin //Else���Ȃ�
        st.PosElse.ptr := nil; //���ʂł���悤�ɁAnil��
    end;

    //��������]��
    sp.lineNo := st.PosFrom.lineNo ;
    sp.ptr := PChar( st.Jouken );
    v := getArgAndCalc(sp);
    try
    if (v=nil)or(v.IntValue = BOOL_FALSE) then
    begin// Else�����s
        if st.PosElse.ptr = nil then
        begin//Else���Ȃ� = ������
            sp.Assign(st.PosTo) ;
            st.Free ;
            Exit;
        end;
        //set
        sp.Assign(st.PosElse);
    end else
        sp.Assign(st.PosFrom);
    finally
        v.Free ;
    end;
    //�t���ւ�
    Structs := st;
    Commands := Structs.varHash ;
end;

function TMmlBase.scriptExit(var sp: TSrcPos): TMVarCustom;

    procedure ExitCurStruct;
    var s: TMStruct;
    begin
        sp.Assign(Structs.PosTo);
        s := Structs.Parent ;
        Structs.Free ;
        Structs := s;
        Commands := Structs.varHash ;
    end;

begin
    Result := nil;
    //�Ƃ肠�����AIF �́A�������ɔ�����
    while True do
    begin
        if Structs.StructType <> stIf then Break;
        ExitCurStruct;
    end;
    //���Ȃ���΂P����������
    if Structs.StructType = stNormal then
    begin
        raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'Exit�����[�v�O�ɂ���܂��B',sp));
    end;
    ExitCurStruct;
end;

function TMmlBase.scriptFunction(var sp: TSrcPos): TMVarCustom;
var
    name, arg_s, s: string;
    func: TMUserFunc;
    p: PChar;
    idx: Integer;
    iv: TMVarCustom;
    node: TMHashNode;

    procedure getInitValue;
    var
        sp2: TSrcPos;
    begin
        sp2 := TSrcPos.Create ;
        try
            Inc(p);// skip '='
            sp2.Assign(sp);
            sp2.ptr := p;
            iv := getArg(sp2);
            func.ArgInit.Add(iv);
            p := sp2.ptr ;
        finally
            sp2.Free ;
        end;
    end;

const
    MAX_ARG = 64;
begin
    Result := nil;

    //�֐����̎擾
    name := getTokenWord(sp.ptr);
    if name='' then
    begin
        if sp.ptr^ in USER_DEFINE_CHAR then
        begin
            name := sp.ptr^;
            Inc(sp.ptr);
        end;
    end;

    if name='' then raise EMml.Create(ErrMsg(MML_ERR_DEF_FUNC+'�֐���������܂���B',sp));

    //���[�J���ɓ������O���Ȃ����m�F
    if Commands.ExistsLocalKey(name) then
    begin
        ShowHint(Format(MML_ERR_FUNCTION_ALREADY_EXISTS,[ name ]),sp);
        Commands.Delete(name);
        //raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_ALREADY_EXISTS,sp),[name]);
    end;

    func := TMUserFunc.Create ;
    func.ArgType := '';

    //�����̎擾
    skipSpace(sp.ptr);
    if sp.ptr^ = '(' then
    begin
        arg_s := getMaruKakko(sp);
        p := PChar(arg_s);
        idx := 0;
        SetLength(func.ArgName, MAX_ARG);//�K����64��\��
        func.ArgType := '';
        while p^ <> #0 do
        begin
            //�����̌^�𓾂� .. �^���̏ꍇ�́A���O�𓾂�
            skipSpace(p);
            s := GetTokenChars([' ',',','=','(',')',#9],p);
            Dec(p);//��؂蕶����߂�
            if s='' then Break;
            if (s='Int')or(s='INT') then
            begin
                func.ArgType := func.ArgType + 'i';
                s := getTokenWord(p);
            end else
            if (s='Str')or(s='STR') then
            begin
                func.ArgType := func.ArgType + 's';
                s := getTokenWord(p);
            end else
            if (s='Array')or(s='ARRAY') then
            begin
                func.ArgType := func.ArgType + 'a';
                s := getTokenWord(p);
            end else
            begin//�ȗ��́AINT�^
                func.ArgType := func.ArgType + 'i';
            end;
            //���������Z�b�g
            func.ArgName[idx] := s;
            Inc(idx);
            if MAX_ARG <= idx then raise EMml.CreateFmt(ErrMsg(MML_ERR_DEF_FUNC+'�����̐��� %i �𒴂��܂����B',sp),[MAX_ARG]);
            //�����l�����邩�H
            skipSpace(p);//
            if p^ = '=' then
                getInitValue
            else
                func.ArgInit.Add(nil);

            while p^ in [#9,#13,#10,' '] do Inc(p);
            if p^ = ',' then Inc(p) else Break;
            while p^ in [#9,#13,#10,' '] do Inc(p);

        end;
        if idx<>0 then //ArgName�̒��K���킹
        begin
            SetLength(func.ArgName, idx);
        end else
            func.ArgName := nil;
    end;
    //�֐����e�̎擾
    skipSpaceReturn(sp.ptr, sp.lineNo); 
    if sp.ptr^<>'{' then  raise EMml.CreateFmt(ErrMsg(MML_ERR_DEF_FUNC+'�֐��錾�� "{" ������܂���B',sp),[MAX_ARG]);

    //�\�[�X�擾
    func.Src.Assign(sp);
    func.Src.cmd := name;
    Inc(func.Src.ptr); // skip '{'
    skipKakko(sp.ptr, sp.lineNo, '{', '}');//�|�C���^�́A�֐��̍Ō�܂Ŏ����Ă���

    //�n�b�V���֓o�^
    node := TMHashNode.Create(name);
    node.DefinePos.Assign(func.Src);
    node.nodeType := ntUserFunc;
    node.value := func;
    Commands.Add(node);
end;


function TMmlBase.scriptResult(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
begin
    //��������邩�m�F
    skipSpace(sp.ptr);

    if sp.ptr^ = '=' then
    begin
        Inc(sp.ptr); // skip '='
        v := getArgAndCalc(sp);

        {
        if Structs.Parent <> nil then
            Structs.Parent.Result := v
        else
            if v<>nil then v.Free;
        }
        if FuncResult <> nil then FuncResult.Free ;
        FuncResult := v;
    end;
    //�ԋp�l���Z�b�g
    {
    if Structs.Parent <> nil then
        Result := Structs.Parent.Result.clone
    else
        Result := nil;
    }
    if FuncResult=nil then
    begin
        Result := nil;
    end else
    begin
        Result := FuncResult.clone ;
    end;
end;

function TMmlBase.funcLength(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Length, 'l', SongInfo.TimeBase);
end;

function TMmlBase.funcNoteA(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'a');
end;

function TMmlBase.funcNoteB(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'b');
end;

function TMmlBase.funcNoteC(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'c');
end;

function TMmlBase.funcNoteD(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'd');
end;

function TMmlBase.funcNoteE(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'e');
end;

function TMmlBase.funcNoteF(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'f');
end;

function TMmlBase.funcNoteG(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'g');
end;

function TMmlBase.funcOctave(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Octave, 'o', 1);
end;

function TMmlBase.funcQgate(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Qgate, 'q', SongInfo.qAdd);
end;

function TMmlBase.funcTiming(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Timing, 't', 1);
end;

function TMmlBase.funcVelocity(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Velocity, 'v', SongInfo.vAdd);
end;

function Div2(a,b: Integer): Integer;
begin
    if b=0 then begin Result := 0; Exit; end;
    Result := a div b;
end;

//NoteOn  Option [(l),(q),(v),(t),(o)]
function TMmlBase.NoteOn(var sp: TSrcPos; NoteName: Char): TMInt;
var
    l,q,v,t,o,nn: Integer; stepm,qstep: Boolean;

    procedure getNoteArg;
    var
        flag: Char;
        qq, qMax: Integer;
        r: Extended;
        mv: TMVarCustom ;
        order: string;
        i: Integer;

        procedure subL;
        begin
          l := GetNoteLength(sp, stepm, l);
        end;
        procedure subQ;
        begin
          //Gate
          if sp.ptr^ in ['+','-','*','/'] then begin flag := sp.ptr^; Inc(sp.ptr); end else flag := #0;
          if sp.ptr^ in ['%','!','$','(','0'..'9'] then
          begin
              mv := getArg(sp);
              if mv<>nil then
              begin
                  if mv.ClassType <> TMInt then
                      raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);

                  case flag of
                      '+': q := q + mv.IntValue ;
                      '-': q := q - mv.IntValue ;
                      '*': q := q * mv.IntValue ;
                      '/': q := Div2(q , mv.IntValue) ;
                      else q := mv.IntValue ;
                  end;
                  if TMInt(mv).Flag = '%' then qstep := True else qstep := False;
                  mv.Free ;
              end;
          end else qstep := False;
        end;
        procedure subV;
        begin
          if sp.ptr^ in ['+','-','*','/'] then begin flag := sp.ptr^; Inc(sp.ptr); end else flag := #0;
          if sp.ptr^ in ['!','$','(','0'..'9'] then
          begin
              mv := getArg(sp);
              if mv<>nil then begin
                  if mv.ClassType <> TMInt then
                      raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
                  case flag of
                      '+': v := v + mv.IntValue ;
                      '-': v := v - mv.IntValue ;
                      '*': v := v * mv.IntValue ;
                      '/': v := Div2(v , mv.IntValue) ;
                      else v := mv.IntValue ;
                  end;
                  mv.Free ;
              end;
          end;
        end;
        procedure subT;
        begin
          skipSpace(sp.ptr);
          if sp.ptr^ in ['+','-','*','/'] then begin flag := sp.ptr^; Inc(sp.ptr); end else flag := #0;
          if sp.ptr^ in ['!','$','(','0'..'9'] then
          begin
              mv := getArg(sp);
              if mv<>nil then begin
                  if mv.ClassType <> TMInt then
                      raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
                  case flag of
                      '+': t := t + mv.IntValue ;
                      '-': t := t - mv.IntValue ;
                      '*': t := t * mv.IntValue ;
                      '/': t := Div2(t , mv.IntValue) ;
                      else t := mv.IntValue ;
                  end;
                  mv.Free ;
              end;
          end;
        end;
        procedure subO;
        begin
          //Octave
          if sp.ptr^ in ['+','-','*','/'] then begin flag := sp.ptr^; Inc(sp.ptr); end else flag := #0;
          if sp.ptr^ in ['!','$','(','0'..'9'] then
          begin
              mv := getArg(sp);
              if mv<>nil then begin
                  if mv.ClassType <> TMInt then
                      raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
                  case flag of
                      '+': o := o + mv.IntValue ;
                      '-': o := o - mv.IntValue ;
                      '*': o := o * mv.IntValue ;
                      '/': o := Div2(o , mv.IntValue) ;
                      else o := mv.IntValue ;
                  end;
                  mv.Free ;
              end;
          end;
        end;

    begin
        // ArgOrder �ɉ����Ĉ������擾
        order := CurTrack.ArgOrder;

        // �����𓾂�
        for i:=1 to Length(order) do
        begin
          case order[i] of
            'l': subL;
            'q': subQ;
            'v': subV;
            't': subT;
            'o': subO;
            else
              raise EMml.CreateFmt(ErrMsg(MML_ERR_WRONG_ARG_ORDER,sp),[order[i]]);
          end;
          if sp.ptr^ <> ',' then Break;
          Inc(sp.ptr);
          skipSpace(sp.ptr);
        end;

        //�Q�[�g�̌v�Z
        qmax := SongInfo.qMax ;
        qq := CurTrack.Qgate.GetQGateValue(l, qmax);//__0~9�܂ł̒l���Z����΂悢
        if qstep then
        begin
            q := q+qq;
        end else
        begin
            // �Q�[�g���[�g���A�X�e�b�v�ɕϊ�
            r := q / qmax;
            q := Trunc(l * r) + qq;
            if (q=0)and(qmax>0)and(l>0) then q := 1;
        end;
        if l>0 then q := q - CurTrack.Q2; //�Q�[�g�̕␳
        //if q<=0 then q := 1;

        //�x���V�e�B�̌v�Z
        if SongInfo.vMax <> 127 then
        begin
            v := Trunc(v * (128 / (SongInfo.vMax+1)));
        end;

        //�I�N�^�[�u�̌v�Z
        if FlagOctaveUpOnce <> 0 then
        begin
            Inc(o,FlagOctaveUpOnce);
            FlagOctaveUpOnce := 0;
        end;

    end;


    procedure WriteTrack;
    var
        c, wc: TSmfNoteOn;
        i,sa: Integer;

        procedure subTie; //�^�C�̏���
        var i,len: Integer;

            procedure subGate;
            var blen: Integer;
            begin
                i := 1;
                while i < TieStack.Count do
                begin
                    c := TieStack.Items[i]; Inc(i);
                    //�P���ɉ��̒��������Z���ď������ށi�^�C���X���[���ʁj
                    sa := c.NoteNo - wc.NoteNo ; //�����Z�o
                    if sa=0 then
                    begin
                        wc.Len := Max((wc.Len + c.Len -1),1);
                        c.Free ;//�X�^�b�N�ɐς܂Ȃ�����A������Ă��܂�
                    end else
                    begin
                        len := c.Time - Trunc(wc.Time);
                        if wc.OptionValue = MaxInt then blen := CurTrack.TieValue else blen := wc.OptionValue;
                        if blen<0 then
                        begin
                            len := len + Trunc(len * (blen/100));
                        end else
                        begin
                            len := Trunc(len * (blen/100));
                        end;
                        wc.Len := len-1;
                        CurSmfTrack.Add(wc);
                        wc := c;
                    end;
                end;
                CurSmfTrack.Add(wc);//���ƂȂ鉹����������
            end;
            procedure subAlp;
            var i, maxN, j: Integer; wwc: TSmfNoteOn;
            begin
                maxN := CurTrack.TieValue -1;//�ő�a����
                if maxN<=0 then Exit;
                for i:=0 to TieStack.Count-1 do
                begin
                    c := TieStack.Items[i];
                    j := Min(i + maxN, TieStack.Count -1);
                    wwc := TieStack.Items[j];
                    c.len := (wwc.Time - c.Time) + wwc.Len ;
                    CurSmfTrack.Add(c);
                end;
            end;
            procedure subBend(griss: Boolean);
            var
                len,fromTime,i,saMax, oldP, blen: Integer;
                br: Integer; rpn: TSmfRpn; p: Integer; wwc: TSmfNoteOn;
            begin
                //���̍ő�l�𓾂�
                wwc := TieStack.Items[TieStack.Count-1];//�Ō�̃m�[�g����ɂ���
                saMax := 0;
                for i:=0 to TieStack.Count -2 do
                begin
                    c := TieStack.Items[i];
                    sa := abs(wwc.NoteNo - c.NoteNo);
                    if sa > saMax then saMax := sa;
                end;
                br := SongInfo.BendRange[CurTrack.Channel];
                if br < saMax then //�x���h����荷���傫��
                begin
                    if saMax > BEND_RANGE_MAX then //GM���x���ł́A�x���h�o���Ȃ�
                    begin
                        with CurTrack do begin
                            i := TieValue ; TieValue := 100;
                            subGate; TieValue := i; Exit;
                        end;
                    end;
                    //�x���h��������ɕύX���Ă��܂�
                    rpn := TSmfRpn.Create ;
                    rpn.rpnType := typeRpn;
                    rpn.msb := 0; rpn.lsb := 0; rpn.data := BEND_RANGE_MAX;
                    rpn.byteCount := 3;
                    rpn.Event := EVENT_CONTROL_CHANGE or CurTrack.Channel ;
                    rpn.Time := wc.Time - 2;
                    CurSmfTrack.Add(rpn);
                    br := BEND_RANGE_MAX ;
                    SongInfo.BendRange[CurTrack.Channel] := br;
                end;
                fromTime := wc.Time ;
                wc := TieStack.Items[TieStack.Count-1];//�Ō�̃m�[�g����ɂ���

                //top note
                c := TieStack.Items[0];
                sa := c.NoteNo - wc.NoteNo;
                p := Trunc(sa * (8192/br));
                WritePicthBend(c.Time-1, p);
                oldP := p;
                blen := c.OptionValue ;
                c.Free;

                for i:=1 to TieStack.Count -2 do
                begin
                    c := TieStack.Items[i];
                    sa := c.NoteNo - wc.NoteNo;
                    p := Trunc(sa * (8192/br));
                    if (oldP = p) then Continue;
                    if griss then
                    begin
                        //Wave�������ݏ���
                        if blen = MaxInt then blen := CurTrack.TieValue;
                        //
                        if blen<0 then
                        begin
                            blen := blen*-1;
                            WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,c.Time, oldP, p, blen);
                        end else
                        begin
                            WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,(c.Time - blen), oldP, p, blen);
                        end;
                    end else begin
                        WritePicthBend(c.Time, p);
                    end;
                    oldP := p;
                    blen := c.OptionValue ;
                    c.Free ; //�m�[�g�����x���h�ɕς����̂ŁA�폜
                end;
                //last Note
                if griss then
                begin
                    c := TieStack.Items[TieStack.Count-2];
                    sa := c.NoteNo - wc.NoteNo ;
                    p := Trunc(sa * (8192/br));
                    if p<>0 then
                    begin
                        //Wave�������ݏ���
                        if blen = MaxInt then blen := CurTrack.TieValue;
                        //
                        //WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,(wc.Time - len), p, 0, len);
                        if blen<0 then
                        begin
                            blen := blen*-1;
                            WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,wc.Time, p, 0, blen);
                        end else
                        begin
                            WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,(wc.Time - blen), p, 0, blen);
                        end;
                    end;
                end else
                begin
                    WritePicthBend(wc.Time, 0); //�Ō�x���h��0�ɖ߂�
                end;
                len := wc.Time - fromTime + wc.Len ;
                wc.Time := fromTime;
                wc.Len := len;
                CurSmfTrack.Add(wc);
            end;

        begin
            TieStack.Add(c); //����̉����X�^�b�N�ɐς�ł��܂��B
            wc := TieStack.Items[0]; //��{�ƂȂ�m�[�g
            //todo: �X���[�̏���
            case CurTrack.TieMode of
            TIE_GATE: subGate;
            TIE_BEND: subBend(False);
            TIE_PORT: subBend(True);
            TIE_ALP:  subAlp;
            end;
            TieStack.Clear ;
        end;

        procedure checkTieOrNot;
        begin
            //�^�C���ǂ����m�F����
            skipSpace(sp.ptr);
            if sp.ptr^ = '&' then
            begin
                Inc(sp.ptr);
                if sp.ptr^ = '&' then begin
                    {c.OptionValue := CurTrack.TieValue;
                    while sp.ptr^ = '&' do
                    begin
                        Inc(sp.ptr);
                        Inc(c.OptionValue,CurTrack.TieValue);
                    end;}//&&�ŁA�l���Q�{�̏���
                    //&&�ŁAl�̒l���̗p����
                    Inc(sp.ptr);
                    case CurTrack.TieMode of
                    TIE_BEND,TIE_PORT: c.OptionValue := c.Len;
                    TIE_GATE: c.OptionValue := 200;
                    else
                        c.OptionValue := CurTrack.TieValue * 2;
                    end;
                    if CurTrack.TieValue < 0 then c.OptionValue := -1 * c.OptionValue;
                end else
                if sp.ptr^ in ARG_CHAR then
                begin
                    c.OptionValue := GetIntValue(sp)
                end else
                    c.OptionValue := MaxInt;
                //�^�C�ł���
                TieStack.Add(c);
            end else
            begin
                //�^�C�ł͂Ȃ��B���ʂ̏�������
                if TieStack.Count > 0 then
                begin//�O�̉����^�C�̂Ƃ�
                    subTie;
                end else
                begin//�O�̉��̓^�C�ł͂Ȃ��Ƃ�
                    if c.Len > 1 then Dec(c.Len);
                    CurSmfTrack.Add(c);
                end;
            end;
        end;

    begin
        c := TSmfNoteOn.Create ;
        c.Time := CurTrack.TimePtr + t;//�^�C�~���O��Y�ꂸ��
        c.Event := EVENT_NOTE_ON or CurTrack.Channel ;
        c.NoteNo := Max(0, Min(nn,127));
        c.Velocity := Max(0, Min(v,127));
        c.Len := q;
        c.PackedNoteOff := True;

        //---���ۂ̏������ݏ����B�a��or�^�C�Ȃ�X�^�b�N�֏�������

        //�����O�̘a�����H
        if l=0 then
        begin
            WaonStack.Add(c);//�X�^�b�N��
        end else
        begin
            //�a���Ō�̉����Ȃ�A�X�^�b�N����a�������낷
            if WaonStack.Count = 0 then
            begin
                if c.Len <= 0 then
                begin
                    c.Free;
                    Exit; //�������O�ȉ��Ȃ�A�������܂Ȃ�
                end else
                    checkTieOrNot;
            end else
            begin
                // �a���X�^�b�N�ɉ������u����Ă���ꍇ
                for i:=0 to WaonStack.Count -1 do
                begin
                    wc := WaonStack.Items[i];
                    if wc.Len = 0 then wc.Len := c.Len ;
                    CurSmfTrack.Add(wc); //���̒��������������̂ŁA������Z�b�g���āA�r�l�e�ɏ�������
                end;
                //�a���X�^�b�N���������񂾂̂ŁA���́A���g����������
                CurSmfTrack.Add(c);// 
                WaonStack.Clear ;
            end;
        end;
    end;

    procedure SetWaonIniValue;
    var i: Integer;
    begin
        if RecWaon.Option <> nil then
        begin
            for i:=0 to RecWaon.Option.Count -1 do //�a�����̏����l���Z�b�g
            begin
                case i of
                    0: if RecWaon.Option.Items[0]<>nil then l := RecWaon.Option.IntItems[0];
                    1: if RecWaon.Option.Items[1]<>nil then q := RecWaon.Option.IntItems[1];
                    2: if RecWaon.Option.Items[2]<>nil then v := RecWaon.Option.IntItems[2];
                    3: if RecWaon.Option.Items[3]<>nil then t := RecWaon.Option.IntItems[3];
                    4: if RecWaon.Option.Items[4]<>nil then o := RecWaon.Option.IntItems[4];
                end;
            end;
        end;
    end;

begin
    //todo: NoteOn
    Result := nil;
    sp.cmd := NoteName; //�R�}���h�����A�T�C��//�G���[�\���p

    //�f�o�b�O�p�BMetaText�ցA���݂̎��s�s�𖄂ߍ���
    if MmlOption.MetaLog then
    begin
        DebugMeta(SourceFileName(sp.fileNo)+'('+IntToStr(sp.lineNo)+')');
    end;


    //�a���R�}���h('...')�����ǂ����`�F�b�N... (.onCycle�n�Ō덷���o��̂ł��̈ʒu�Ń|�C���^��ύX)
    if RecWaon.Enable then
    begin
        CurTrack.TimePtr := RecWaon.Time ; //�^�C���|�C���^��߂�
    end;

    //GetTrackDefaultValue(l,q,v,t,o,stepm);
    with CurTrack do //�J�����g�g���b�N�̃f�t�H���g�l�𓾂�
    begin
        l := Length.GetValue ;
        q := Qgate.ArrayNote[0].Value ;
        v := Velocity.GetValue ;
        t := Timing.GetValue ;
        o := Octave.GetValue ;
        stepm := Stepmode;
        qstep := QGate.ArrayNote[0].StepMode ;
    end;

    //�a���R�}���h('...')�Ȃ�΁A�a���̏����l�𓾂�
    if RecWaon.Enable then
    begin
        SetWaonIniValue;
    end;

    // �m�[�g�i���o�[�̌v�Z
    nn := getNoteNo(sp, NoteName, True);

    // �m�[�g�̈����𓾂�
    getNoteArg;

    //Stretch�R�}���h�ŗ��p����
    if StretchRate <> 1 then
    begin
        l := Trunc(l * StretchRate);
        q := Trunc(q * StretchRate);
    end;

    //�ŏI�I�ȃm�[�g�i���o�[���Z�o
    if NoteName <> 'n' then
    begin
        nn := (o + SongInfo.OctaveRangeShift)* 12 + nn;
    end;
    nn := Max(0,min(127, nn));//�ő�l�ƍŏ��l�ɂ��킹��
    {if CurTrack.Mute then
    begin
        Result := TMInt.Create; TMInt(Result).value := nn; //���������m�[�g�i���o�[��ԋp�l�Ƃ���ꍇ
    end;}

    //�g���b�N�Ƀf�[�^����������
    if CurTrack.Mute = False then WriteTrack;

    //�m�[�g���́A�R���g���[���`�F���W�̃`�F�b�N������
    checkNoteOnCC(l, CurTrack.Channel); //���ۂ̉����̒�����������Ȃ��ƁA.onNoteWaveEx���쓮�ł��Ȃ�����A���̈ʒu�ɒu��

    //�^�C���|�C���^��i�߂�
    Inc(CurTrack.TimePtr, l);
end;


function TMmlBase.GetNoteLength(var sp: TSrcPos;
  stepmode: Boolean; def: Integer): Integer;
begin
  Result := TokenBase.GetNoteLength(sp, stepmode, def); 
end;
(*
function TMmlBase.GetNoteLength(var sp: TSrcPos;
  stepmode: Boolean; def: Integer): Integer;
var
    vi: Integer;

    function getOne: Integer;
    var
        mv: TMVarCustom;
        v: Extended;
        stepm: Boolean;

        procedure huten;
        var el,divLen:Extended ;
        begin
            //�t�_�̏���
            el := 1;
            divLen := 0.5;
            while sp.ptr^ = '.' do
            begin
                Inc(sp.ptr);
                el := el + divLen;
                divLen := divLen / 2;
            end;
            v := v*el;
        end;

    begin
        //�l�̎擾
        skipSpace(sp.ptr);
        if not (sp.ptr^ in ['$','%','0'..'9','(']) then //�ȗ����ꂽ�Ƃ��́A�f�t�H���g��Ԃ�
        begin
            v := def; huten; Result := Trunc(v);
            Exit;
        end;

        v := 0;
        try
            mv := getArg(sp);
        except
            raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'�����̎w��B',sp));
        end;
        try
            if mv = nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
            if mv.ClassType = TMInt then
            begin
                //StepMode�̔���
                if TMInt(mv).Flag = '%' then stepm := not stepmode else stepm := stepmode;
                if stepm then
                begin
                    v := TMInt(mv).value
                end else begin
                    v := TMInt(mv).value ;
                    v := NtoStep(Trunc(v));
                end;
            end else
            begin
                //
                if stepmode then
                    v := mv.IntValue
                else
                    v := NtoStep(mv.IntValue);
            end;
        finally
            mv.Free ;
        end;
        huten;
        Result := Trunc(v);
    end;

begin
    vi := getOne;
    //�^�C�̏����E�E�E
    while True do
    begin
        //�^�C�����邩�H
        skipSpaceReturn(sp.ptr, sp.lineNo);
        //skipSpace(sp.ptr);
        if sp.ptr^ in ['^','+'] then
        begin
            Inc(sp.ptr);
            vi := vi + getOne;
        end else
        if sp.ptr^ = '-' then
        begin
            Inc(sp.ptr);
            vi := vi - getOne;
        end else
            Break;
    end;

    Result := vi;
end;
*)

function TMmlBase.SetNoteInfo(var sp: TSrcPos; var ni: TNoteInfos;
  pname: Char; IncValue: Integer): TMInt;
var
    v: TMVarCustom;
    idx,vi: Integer;
    Flag: Char;

    procedure setOption;
    var
        token: string;
        mv: TMVarCustom;
    begin
        Inc(sp.ptr);// skip '.'
        token := GetTokenChars([' ','=','('], sp.ptr); // .onNote �̂悤�ȃg�[�N���𓾂�
        if token='' then raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'"."�̌��ɂ̓I�v�V���������K�v�ł��B',sp));
        Dec(sp.ptr); //�ǂ݂����Ȃ̂ŁA�P�����߂�
        //�m�[�g���I�v�V�����ɂ�菈���𕪂���
        if (token=OPTION_ON_NOTE)or(token=OPTION_ON_NOTE2) then
        begin
            mv := getArgs(sp);
            if (mv=nil)or(mv.ClassType <> TMArray) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[token]);
            ni.SetReserveValue(idx, noteOnNote, mv as TMArray, CurTrack.TimePtr);
        end else
        if (token=OPTION_ON_TIME)or(token=OPTION_ON_TIME2) then
        begin
            mv := getArgs(sp);
            if (mv=nil)or(mv.ClassType <> TMArray) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[token]);
            ni.SetReserveValue(idx, noteOnTime, mv as TMArray, CurTrack.TimePtr);
        end else
        if (token=OPTION_ON_CYCLE)or(token=OPTION_ON_CYCLE2) then
        begin
            mv := getArgs(sp);
            if (mv=nil)or(mv.ClassType <> TMArray) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[token]);
            ni.SetReserveValue(idx, noteOnCycle, mv as TMArray, CurTrack.TimePtr);
        end else
        if (token=OPTION_DELAY) then
        begin
            sp.cmd := OPTION_DELAY;
            ni.CreateArrayNote(idx);
            ni.ArrayNote[idx].DelayTime := GetIntValueAndCalc(sp);
        end else
        if (token=OPTION_REPEAT) then
        begin
            sp.cmd := OPTION_REPEAT;
            ni.CreateArrayNote(idx);
            ni.ArrayNote[idx].RepeatMode := GetIntValueAndCalc(sp);
        end else
        if (token=OPTION_RANDOM) then
        begin
            sp.cmd := OPTION_RANDOM;
            ni.CreateArrayNote(idx);
            ni.ArrayNote[idx].RandomValue := GetIntValueAndCalc(sp);
        end else
        if (token=OPTION_MAX) then
        begin
            sp.cmd := OPTION_MAX;
            case pname of
            'q':
            begin
                SongInfo.qMax := GetIntValueAndCalc(sp);
                CurTrack.Qgate.SetValue(0,SongInfo.qMax);
            end;
            'v':
            begin
                SongInfo.vMax := GetIntValueAndCalc(sp);
                CurTrack.Velocity.SetValue(0,SongInfo.vMax);
            end;
            end;
        end else
        if (token=OPTION_RANGE) then
        begin
            mv := getArgs(sp);
            if (mv=nil)or(mv.ClassType <> TMArray) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[token]);
            if TMArray(mv).Count <> 2 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"(low,high)"�`���Ŏw�肵�Ă��������B',sp),[token]);
            if ni.Range <> nil then ni.Range.Free ;
            ni.Range := TMRange.Create(TMArray(mv).IntItems[0],TMArray(mv).IntItems[1]);
        end else
            raise  EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[token]);

        if Flag='%' then
            ni.ArrayNote[idx].StepMode := True  //step�w��
        else
            ni.ArrayNote[idx].StepMode := False;
    end;

    function subSoutai: Boolean;
    var
        p,v: Integer;
    begin
        Result := False;
        //���Ύw�肩�ǂ����`�F�b�N
        if not(sp.ptr^ in ['+','-']) then Exit;

        p := 0;
        while True do
        begin
            if sp.ptr^ = '+' then Inc(p) else
            if sp.ptr^ = '-' then Dec(p) else Break;
            Inc(sp.ptr);
        end;

        if not(sp.ptr^ in ['$','(','!','0'..'9']) then
        begin
            ni.IncValue(idx, p * IncValue); //���ΓI�ɑ��₷
        end else
        begin //���l�w�肪����
            v := GetIntValue(sp);
            ni.IncValue(idx, p * v);
        end;
        if Flag='%' then ni.ArrayNote[idx].StepMode := True;

        Result := True;
        Exit;
    end;

begin
    Result := nil ;

    sp.cmd := pname;
    idx := -1;
    if sp.ptr^ = '_' then //�Ɨ����� v__3=40 �̂悤�ȑ��d�K�w�p�����[�^�[
    begin
        Inc(sp.ptr);
        idx := 0;
        if sp.ptr^ = '_' then
        begin
            Inc(sp.ptr);
            v := getArg(sp); if (v=nil)or(v.ClassType <> TMInt) then raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
            idx := v.IntValue ;
            if (idx>=MAX_NOTE_INFO-1) then raise EMml.CreateFmt(ErrMsg(MML_ERR_RANGE_OVER+'(0~%d)',sp),[sp.cmd,MAX_NOTE_INFO-2{arrayNoteInfo �� 0 ���w��Ȃ���\���̂�}]);
        end;
    end;
    Inc(idx);// �m�[�}�����Aidx=0 �Ȃ̂ŁA1 ����

    //�X�e�b�v�w�肩�m�F
    if sp.ptr^ = '%' then //�X�e�b�v�w��ł���
    begin
        Flag := sp.ptr^;
        Inc(sp.ptr);
    end else begin
        Flag := #0;
    end;

    if sp.ptr^ = '.' then
    begin
        setOption;
        Result := nil; //option�w�莞�͌��݂̒l���s�肾����
        Exit;
    end;

    //---�l��ݒ�-----------------------------------------------------------

    if pname = 'l' then //"l"�̂Ƃ��B
    begin
        if Flag = '%' then //�X�e�b�v�w��ł���
        begin
            CurTrack.Stepmode := not SongInfo.Stepmode;
        end else
        begin
            CurTrack.Stepmode := SongInfo.Stepmode;
        end;
        vi := GetNoteLength(sp, CurTrack.Stepmode, -1);
        ni.SetValue(idx, vi) ;
        v := TMInt.Create ;
        TMInt(v).value := vi;
    end else
    begin //'l"�ȊO�̂Ƃ��B

        if sp.ptr^='=' then begin
            Inc(sp.ptr);
        end else
        if subSoutai then
        begin
            Exit;
        end;
        v := getArg(sp);
        if (v=nil)or(v.ClassType <> TMInt) then raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
        ni.SetValue(idx, v.IntValue) ;
        Result := v as TMInt;
    end;
    if Flag='%' then
        ni.ArrayNote[idx].StepMode := True  //step�w��
    else
        ni.ArrayNote[idx].StepMode := False;
end;

function TMmlBase.GetIntValue(var sp: TSrcPos): Integer;
var
    mv: TMVarCustom;
begin
    //if sp.ptr^ = '=' then Inc(sp.ptr);
    mv := getArg(sp);
    if (mv=nil)or(mv.ClassType <> TMInt) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    Result := mv.IntValue ;
    mv.Free ;
end;

function TMmlBase.scriptChannel(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    p: PChar;
begin
    skipSpace(sp.ptr);
    p := sp.ptr ;
    if (p^='(')or((p^='=')and(not((p+1)^in['!','='])))or(p^ in ['0'..'9']) then
    begin //���
        v :=GetIntValue(sp);
        if (v<=0)or(v>16) then raise EMml.CreateFmt(ErrMsg(MML_ERR_RANGE_OVER+'(1~16���͈�)',sp),['Channel']);
        CurTrack.Channel := v - 1;
    end;
    //�J�����g�g���b�N�̃`�����l���ԍ���Ԃ�
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.Channel + 1;
end;

function TMmlBase.scriptTrack(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    p: PChar;
begin
    skipSpace(sp.ptr);
    p := sp.ptr ;
    if (p^='(')or((p^='=')and(not((p+1)^in['!','='])))or(p^ in ['0'..'9']) then
    begin //���
        v :=GetIntValue(sp);
        SetCurTrack(v);
    end;
    //�J�����g�g���b�N�̔ԍ���Ԃ�
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.TrackNo ;
end;

function TMmlBase.scriptVoice(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    c: TSmfProgramChange;
    ary: TMArray;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ARG_CHAR then
        ary := getArgs(sp)
    else begin
        //@a,b,c �̂悤�ȂƂ��B�������R�}���h�̂悤�Ɏ擾
        ary := TMArray.Create ;
        ary.Add( getArgAndCalc(sp) ); skipSpace(sp.ptr);
        if sp.ptr^ = ',' then
        begin
            Inc(sp.ptr);
            ary.Add( getArgAndCalc(sp) ); skipSpace(sp.ptr);
            if sp.ptr^ = ',' then
            begin
                Inc(sp.ptr);
                ary.Add( getArgAndCalc(sp) );
            end;
        end;
    end;

    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Voice']);
    if ary.Count = 0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Voice']);

    v := ary.IntItems[0] - 1 + SongInfo.VoiceNoShift;
    if (v<0)or(v>127) then raise EMml.CreateFmt(ErrMsg(MML_ERR_RANGE_OVER+'(%d~%d)',sp),['Voice', (1+SongInfo.VoiceNoShift),(128+SongInfo.VoiceNoShift)]);

    CurTrack.Voice := ary.IntItems[0];//�L���p

    // SMF�ɃC�x���g��������
    c := TSmfProgramChange.Create ;
    c.Event := EVENT_PROGRAM_CHANGE or CurTrack.Channel ;
    c.Time := CurTrack.TimePtr - 1;//1step�O
    c.value := v ;

    //msb, lsb �̎擾
    c.msb := -1;
    c.lsb := -1;

    if ary.Items[1]<>nil then
    begin
        c.msb := ary.IntItems[1];
    end;
    if ary.Items[2]<> nil then
    begin
        c.lsb := ary.IntItems[2];
    end;

    CurSmfTrack.Add(c); //SMF ��������

    //�J�����g�g���b�N�̉��F�ԍ���Ԃ�
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.Voice ;
end;

function TMmlBase.funcNoteN(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'n');
end;

function TMmlBase.funcNoteR(var sp: TSrcPos): TMVarCustom;
var
    len, d: Integer;
    stepm: Boolean;
    flag,sign: Char;

    procedure chkWaon;
    begin
        if RecWaon.Enable then
        begin
            CurTrack.TimePtr := RecWaon.Time ; //�^�C���|�C���^��߂�
            if RecWaon.Option <> nil then
            begin
                if RecWaon.Option.Count >= 1 then
                    len := RecWaon.Option.Items[0].IntValue ;
            end;
        end;
    end;

begin
    Result := nil;

    if sp.ptr^ = '*' then
    begin
        flag := sp.ptr^;
        Inc(sp.ptr);
    end else begin
        flag := #0;
    end;
    if sp.ptr^ in ['-','+'] then
    begin
        sign := sp.ptr^;
        Inc(sp.ptr); // �t�����܂��́A���Z�B
    end else
        sign := #0;

    if flag<>'*' then
    begin // �C�x���g���N����
        GetTrackDefaultValue(len,d,d,d,d,stepm);
        //�a���R�}���h('...')�����ǂ����`�F�b�N
        chkWaon;
        len := GetNoteLength(sp, stepm, len);
        checkNoteOnCC(len, CurTrack.Channel);
    end else
    begin
        len := CurTrack.Length.GetValue ;
        chkWaon;
        len := GetNoteLength(sp, CurTrack.Stepmode, len);
    end;
    if sign='-' then
    begin
        Dec( CurTrack.TimePtr, len );
    end else
    begin
        Inc( CurTrack.TimePtr, len );
    end;
end;

function TMmlBase.scriptCC(var sp: TSrcPos): TMVarCustom;
var
    cc: Integer; //CC�ԍ�
{    v: Integer;
    ccc: TSmfControlChange ;}
begin
    Result := nil;

    cc := GetIntValue(sp); //CC�ԍ��𓾂�
    skipSpace(sp.ptr);

    if sp.ptr^ = '.' then
    begin
        WriteCCOption(sp, cc); Exit;
    end;

    if (sp.ptr^ = ',') then Inc(sp.ptr);

    //�s�b�`�x���h���̎w�肪����΁A���̔ԍ������s
    if cc=256 then
        scriptBendFull(sp)
    else if cc=257 then
        scriptBend(sp)
    else
        WriteCCComand(sp, cc);
    {
    if not(sp.ptr^ in [',','(','=','0'..'9','$']) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"y(no),(value)"�̏����Ŏw�肵�Ă��������B',sp),['y']);
    if (sp.ptr^ = ',') then Inc(sp.ptr);
    v := GetIntValue(sp); //�l�𓾂�

    //smf�ɏ�������
    ccc := TSmfControlChange.Create ;
    ccc.Time := CurTrack.TimePtr ;
    ccc.Event := EVENT_CONTROL_CHANGE or CurTrack.Channel ;
    ccc.No := cc;
    ccc.Value := v;
    CurSmfTrack.Add(ccc);
    }
end;

procedure TMmlBase.WriteCCWave(var ncc: TNoteCC; var track: TSmfTrack; noteLen, ch: Integer);
var
    Freq: Integer;
    TimePtr: Integer; //�J�����g�g���b�N�̃^�C���|�C���^
    oldV: Integer;

    procedure writeTrack(time, v: Integer);
    var
        c: TSmfCustomNode ;
    begin
        //Random
        if ncc.RandomValue <> 0 then
        begin
            v := v + Random(ncc.RandomValue*2) - ncc.RandomValue; 
        end;
        
        if ncc.Range <> nil then //Range�ɂ��l�␳
        begin
            v := Max(ncc.Range.low, Min(ncc.Range.high, v));
        end;
        if oldV = v then Exit;
        oldV := v;

        if ncc.No <= 127 then // CC (0~127)
        begin
            c := TSmfControlChange.Create ;
            c.Event := EVENT_CONTROL_CHANGE or ch ;
            TSmfControlChange(c).No := Byte(ncc.No) ;
            TSmfControlChange(c).Value := Min(127, Max(0,v));
        end else
        if ncc.No = 256 then // Bend FullRange(-8192~0~8191)
        begin
            c := TSmfPitchBend.Create ;
            c.Event := EVENT_PITCH_BEND or ch ;
            TSmfPitchBend(c).value := Min(8191, Max(-8192, v));
        end else
        if ncc.No = 257 then //easy Range BEND(0~63~127)
        begin
            c := TSmfPitchBend.Create ;
            c.Event := EVENT_PITCH_BEND or ch ;
            v := v * 128 - 8192;
            TSmfPitchBend(c).value := Min(8191, Max(-8192, v));
        end else
        begin
            Exit;
        end;
        c.Time := time;
        track.Add(c);
    end;

    procedure subTime;
    var
        len_add, total, cnt, i, j, low, high, len, takasa,v, n: Integer;
        a: Extended;
    begin
        i := 0;
        n := TimePtr;
        total := 0;
        while i < ncc.reserve.Count do
        begin
            low  := ncc.reserve.IntItems[i];
            high := ncc.reserve.IntItems[i+1];
            len  := ncc.reserve.IntItems[i+2];
            //
            takasa := high - low;
            if len<>0 then a := takasa / len else a := 0;
            //
            cnt := (len div Freq)-1;//1�񕪂�Ƃ����������
            for j:=0 to cnt-2 do
            begin
                v := Trunc(a * j * Freq)+low;
                len_add := Freq * j;
                writeTrack(n + len_add-1, v);

                //Break����
                Inc(total,Freq);
                if noteOnWave = ncc.noteOnType then begin
                    if total > noteLen then // noteLen �𒴂����Ƃ��ABreak
                        Break;
                end;
            end;
            if noteOnWave = ncc.noteOnType then begin
                if total > noteLen then // noteLen �𒴂����Ƃ��ABreak
                    Break;
            end;

            if cnt>0 then
            begin
                writeTrack(n + Freq*(cnt-1), high); //�Ō�ɒ��K���킹
            end;
            Inc(i, 3);
            Inc(n, len);
        end;
        //�Ō�̒l���L�����Ă���
        ncc.LastValue := oldV;
    end;

    procedure subCCWave;
    var
        cnt, waveType, low, high, len, times, takasa,v, n, break_cnt: Integer;

        procedure Sine;
        var i,flen: Integer;
        begin
            flen := (cnt div times)-1;

            for i:=0 to cnt-1 do
            begin
                if i > break_cnt then break;
                n := Trunc((len / cnt) * i);
                v := Trunc( takasa * sin( 3.14 * ((i mod flen)/flen)) ) + low;
                writeTrack(TimePtr+n, v);
            end;
        end;

        procedure SineUp;
        var i,flen: Integer;
        begin
            flen := (cnt div times)-1;

            for i:=0 to cnt-1 do
            begin
                if i > break_cnt then break;
                n := Trunc((len / cnt) * i);
                v := Trunc( takasa * sin( 3.14 * ((i mod flen)/flen)) );
                v := Trunc(v * (i/cnt));
                v := v + low;
                writeTrack(TimePtr+n, v);
            end;
        end;

        procedure SineDown;
        var i,flen: Integer;
        begin
            flen := (cnt div times)-1;

            for i:=0 to cnt-1 do
            begin
                if i > break_cnt then break;
                n := Trunc((len / cnt) * i);
                v := Trunc( takasa * sin( 3.14 * ((i mod flen)/flen)) );
                v := v - Trunc(v * (i/cnt));
                v := v + low;
                writeTrack(TimePtr+n, v);
            end;
        end;

    begin
        //(����).Wave(type,low,high,len,times)//�R���g���[���`�F���W�̘A���l�������ݖ���
        waveType := ncc.reserve.IntItems[0];
        low      := ncc.reserve.IntItems[1];
        high     := ncc.reserve.IntItems[2];
        len      := ncc.reserve.IntItems[3];
        times    := ncc.reserve.IntItems[4];


        cnt := len div Freq; //�������݉�
        if cnt<=0 then Exit;

        takasa := high - low;

        break_cnt := cnt;
        if noteOnSine = ncc.noteOnType then
        begin
            if noteLen < len then
            begin
                break_cnt := noteLen div Freq;
                if break_cnt <=0 then Exit;
            end;
        end;

        case waveType of
        0:Sine;
        1:SineUp;
        2:SineDown;
        end;

        //�Ō�̒l���L�����Ă���
        ncc.LastValue := oldV;
    end;

    procedure subNote;
    var v: Integer;
    begin
        if ncc.FIndex >= ncc.reserve.Count then
        begin //�͈͒���
            if ncc.RepeatMode = BOOL_FALSE then
            begin
                ncc.noteOnType := noteNormal; Exit;
            end else begin
                ncc.FIndex := 0;
            end;
        end;
        v := ncc.reserve.IntItems[ncc.FIndex];
        if ncc.LastValue <> v then writeTrack(TimePtr-1, v);
        //�Ō�̒l���L�����Ă���
        ncc.LastValue := v;
        Inc(ncc.FIndex);
    end;

    procedure subCycle;
    var v, len, idx: Integer;
    begin
        if ncc.reserve.Count = 0 then Exit;
        len := ncc.reserve.IntItems[0];
        if len=0 then Exit;
        idx := (TimePtr - ncc.Time) div len;
        v := ncc.reserve.IntItems[1 + (idx mod (ncc.reserve.Count-1))];
        writeTrack(timePtr-1, v);
        //�Ō�̒l���L�����Ă���
        ncc.LastValue := oldV;
    end;

    procedure subWaveEx;
    var
        n, v, len, alen, i, j, cnt, low, high, takasa, realLen: Integer;
        wlen,a: Extended;
    begin
        //�܂��AWaveTable�ɏ������܂ꂽ���������v���A�������v�Z����
        alen := 0;
        for i:=0 to (ncc.reserve.Count div 3)-1 do
        begin
            if (i*3+2) >= ncc.reserve.Count then Break;
            alen := alen + ncc.reserve.IntItems[i*3+2];
        end;
        if alen<=0 then alen := 1;

        //�����𓾂ď�������
        n := TimePtr;
        for i:=0 to (ncc.reserve.Count div 3)-1 do
        begin
            if (i*3+2) >= ncc.reserve.Count then Break;
            low  := ncc.reserve.IntItems[i*3+0];
            high := ncc.reserve.IntItems[i*3+1];
            len  := ncc.reserve.IntItems[i*3+2];
            wlen := len / alen; //�����̊���
            realLen := Trunc(wlen * noteLen);
            takasa := high -low;
            if realLen<>0 then
                a    := takasa / realLen
            else
                a    := 0;
            cnt  := (realLen div Freq)-1;//1�񕪂̂�Ƃ�
            for j:=0 to cnt-2 do
            begin
                v := Trunc((j*Freq) * a)+low; //���ۂ̒l
                writeTrack((n + j*Freq),v);
            end;
            if cnt>0 then
            begin
                writeTrack(n + Freq*(cnt-1), high); //�Ō�ɒ��K���킹
            end;
            Inc(n, realLen);
        end;
        //�Ō�̒l���L�����Ă���
        ncc.LastValue := oldV;
    end;

    procedure subWaveR;
    var
        lastPtr, v, len, i, j, cnt, low, high, takasa, total: Integer;
        a: Extended;
    begin
        if ncc.reserve.Count <= 0 then Exit;
        lastPtr := CurTrack.TimePtr + noteLen; //�������݃^�C���ŏI�l

        total := 0;
        i := 0;
        while timePtr < lastPtr do
        begin
            if (i+3) > ncc.reserve.Count then i := 0;
            //�l�̎擾
            low  := ncc.reserve.IntItems[i+0];
            high := ncc.reserve.IntItems[i+1];
            len  := ncc.reserve.IntItems[i+2];
            if len <= 0 then Break;
            Inc(i,3);

            if Freq >= len then begin //�����Alen �� �Z���Ƃ��́Ahigh�������ă��[�v�𑱂���
                writeTrack(timePtr, high);
                Inc(timePtr, Freq);
                Continue;
            end;

            //�X���𓾂�
            takasa := high - low;
            a := takasa / (len-1); //�� by 4neria (2002/10/22)

            //�������݉񐔂𓾂�
            cnt := (len div Freq);//-1; //�� by 4neria (2002/10/22)
            for j := 0 to cnt-1 do
            begin
                if timePtr >= lastPtr then Exit; //�Ō���z�����甲����
                v := Trunc((j*Freq)*a)+low;
                writeTrack(timePtr, v);
                Inc(timePtr, Freq);
                Inc(total, Freq);
                if total > noteLen then Break;
            end;
        end;
        //�Ō�̒l���L�����Ă���
        ncc.LastValue := oldV;
    end;


begin
    Freq := SongInfo.CCFreq ;
    TimePtr := CurTrack.TimePtr + ncc.DelayTime;
    oldV := MaxInt;

    if CurTrack.CCNoMute[ncc.No] then Exit;

    if (ncc.DelayTime > 0) then
    begin
        if (ncc.No = CC_NO_BEND) then
        begin
            writeTrack(CurTrack.TimePtr, 64);
        end;
        if (ncc.No = CC_NO_BEND_FULL) then
        begin
            writeTrack(CurTrack.TimePtr, 0);
        end;
    end;
    if CurTrack.CCMute then Exit;

    case ncc.noteOnType of
    noteOnTime:   subTime;
    noteCCSine:   subCCWave;
    noteOnSine:   subCCWave;
    noteOnNote:   subNote;
    noteOnCycle:  subCycle;
    noteOnWave:   subTime;
    noteOnWaveEx: subWaveEx;
    noteOnWaveR:  subWaveR;
    noteOff:;//�������Ȃ�
    end;

end;

function TMmlBase.scriptBend(var sp: TSrcPos): TMVarCustom;
var
    v,vv: Integer;
    flg: Char;
begin
    Result := nil;

    if sp.ptr^='%' then //Full Range Bend
    begin
        Inc(sp.ptr);
        ScriptBendFull(sp); Exit;
    end;

    skipSpace(sp.ptr);

    if sp.ptr^ = '.' then
    begin
        WriteCCOption(sp, CC_NO_BEND); Exit;
    end;

    if sp.ptr^ in ['+','-'] then
    begin
        flg := sp.ptr^;
        Inc(sp.ptr);
    end else
        flg := #0;

    vv := GetIntValueAndCalc(sp); //�l�𓾂�
    case flg of
    '+':
        begin
            vv := vv + SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND).LastValue ;
        end;
    '-':
        begin
            vv := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND).LastValue - vv;
        end;
    end;

    vv := Max(0, Min(128, vv));
    v := vv * 128 - 8192;

    WritePicthBend(CurTrack.TimePtr - SongInfo.ControllerShift, v);
end;

procedure TMmlBase.WriteCCOption(var sp: TSrcPos; cc: Integer);
var
  nc: TNoteCC;
  v: Integer;

    procedure subOnNote;
    var mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnNote ;
        nc.reserve.Assign(mv);
        nc.FIndex := 0;
        mv.Free ;
    end;

    procedure subOnTime;
    var
        mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnTime ;
        //��������������
        nc.Time := CurTrack.TimePtr ;
        nc.reserve.Assign(mv);
        mv.Free ;

        if (CurTrack.CCMute = False)and(CurTrack.CCNoMute[nc.No] = False) then
        begin
          //�g���b�N�̖��ʂɏ������܂��R���g���[���`�F���W���g��������(ver.2.32�ȍ~)
          DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, nc.No, CurTrack.TimePtr, False);
          WriteCCWave(nc, CurSmfTrack, 0, CurTrack.Channel);
        end;
        nc.noteOnType := noteOff;
    end;

    procedure subCCSine;
    var
        mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteCCSine ;
        //��������������
        nc.Time := CurTrack.TimePtr ;
        nc.reserve.Assign(mv);
        mv.Free ;

        if (CurTrack.CCMute = False)and(CurTrack.CCNoMute[nc.No] = False) then
        begin
          //�g���b�N�̖��ʂɏ������܂��R���g���[���`�F���W���g��������(ver.2.32�ȍ~)
          DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, nc.No, CurTrack.TimePtr, False);

          WriteCCWave(nc, CurSmfTrack, 0, CurTrack.Channel);
        end;
        nc.noteOnType := noteOff;
    end;

    procedure subOnSine;
    var
        mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnSine ;
        nc.Time := CurTrack.TimePtr ;
        nc.reserve.Assign(mv);
        mv.Free ;
    end;

	procedure subOnCycle;
  var mv: TMArray;
  begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnCycle ;
        nc.reserve.Assign(mv);
        nc.Time := CurTrack.TimePtr ;
        nc.FIndex := 0;
        mv.Free ;
	end;

	  procedure subOnWave;
    var mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnWave ;
        nc.reserve.Assign(mv);
        nc.Time := CurTrack.TimePtr ;
        nc.FIndex := 0;
        mv.Free ;
	  end;

	  procedure subOnWaveEx;
    var mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnWaveEx ;
        nc.reserve.Assign(mv);
        nc.Time := CurTrack.TimePtr ;
        nc.FIndex := 0;
        mv.Free ;
	  end;

	  procedure subOnWaveR;
    var mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnWaveR ;
        nc.reserve.Assign(mv);
        nc.Time := CurTrack.TimePtr ;
        nc.FIndex := 0;
        mv.Free ;
	end;

	procedure subDelay;
	begin
        v := GetIntValue(sp);
        nc.DelayTime := v;
	end;

	procedure subRepeat;
	begin
        v := GetIntValue(sp);
        nc.RepeatMode := v;
        nc.FIndex := 0;
	end;

	procedure subRandom;
	begin
        v := GetIntValue(sp);
        nc.RandomValue := v;
	end;

	procedure subRange;
    var mv: TMArray;
	begin
        mv := getArgs(sp);
        if (mv=nil)or(mv.ClassType <> TMArray)or(TMArray(mv).Count <> 2) then EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"(low,high)"�Ŏw�肵�Ă��������B',sp),[sp.cmd]);
        nc.Range := TMRange.Create(TMArray(mv).IntItems[0],TMArray(mv).IntItems[1]);
	end;

	procedure subFreq;
	begin//CC�������ݕp�x�̐ݒ�
        v := GetIntValueAndCalc(sp);
        SongInfo.CCFreq := v;
	end;

var
    s: string;
begin
    nc := GetCurCCNote(cc); // ���݂̃g���b�N�̃`�����l�����R���g���[���`�F���W�𓾂�
    nc.No := cc;
    Inc(sp.ptr);// skip "."
    //�I�v�V�������𓾂�
    s := GetTokenChars(['=','(',' '], sp.ptr);
    if s='' then raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'"."�̌��ɂ̓I�v�V���������K�v�ł��B',sp));
    sp.cmd := s;
    Dec(sp.ptr); //�ǂ݂����Ȃ̂ŁA�P�����߂�
    //�m�[�g���I�v�V�����ɂ�菈���𕪂���
    if (s=OPTION_ON_NOTE)or(s=OPTION_ON_NOTE2)      then subOnNote   else
    if (s=OPTION_ON_TIME)or(s=OPTION_ON_TIME2)      then subOnTime   else
    if (s=OPTION_CC_SINE)                           then subCCSine   else
    if (s=OPTION_ON_SINE)                           then subOnSine   else
    if (s=OPTION_ON_CYCLE)or(s=OPTION_ON_CYCLE)     then subOnCycle  else
    if (s=OPTION_ON_WAVE)or(s=OPTION_ON_WAVE2)      then subOnWave   else
    if (s=OPTION_ON_WAVE_EX)or(s=OPTION_ON_WAVE_EX2)then subOnWaveEx else
    if (s=OPTION_ON_WAVE_R)or(s=OPTION_ON_WAVE_R2)  then subOnWaveR  else
    if (s=OPTION_DELAY)                             then subDelay    else
    if (s=OPTION_REPEAT)                            then subRepeat   else
    if (s=OPTION_RANDOM)                            then subRandom   else
    if (s=OPTION_RANGE)                             then subRange    else
    if (s=OPTION_FREQUENCY)                         then subFreq     else
    raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[s]);
end;


function TMmlBase.scriptBendFull(var sp: TSrcPos): TMVarCustom;
var
    vv: Integer;
    flg:Char;
begin
    Result := nil;
{�t�͎g���Ȃ����낤����A���̏����́A�X�L�b�v
    if sp.ptr^='%' then //Full Range Bend
    begin
        Inc(sp.ptr);
        ScriptBend(sp); Exit;
    end;
}
    skipSpace(sp.ptr);

    if sp.ptr^ = '.' then
    begin
        WriteCCOption(sp, CC_NO_BEND_FULL); Exit;
    end;
    if sp.ptr^ = ',' then
    begin
        ShowHint(MML_WARN_VAR_SYNTAX+'�l�w���","�͎g���܂���B',sp);
        Inc(sp.ptr);
    end;

    if sp.ptr^ in ['+','-'] then
    begin
        flg := sp.ptr^;
        Inc(sp.ptr);
    end else
        flg := #0;

    vv := GetIntValueAndCalc(sp); //�l�𓾂�
    case flg of
    '+':
        begin
            vv := vv + SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND_FULL).LastValue ;
        end;
    '-':
        begin
            vv := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND_FULL).LastValue - vv;
        end;
    end;

    WritePicthBend(CurTrack.TimePtr - SongInfo.ControllerShift, vv);
end;

procedure TMmlBase.checkNoteOnCC(noteLen, ch: Integer);
var
    cc: TCCList;
    nc: TNoteCC;
    i: Integer;

begin
    cc := GetCurCCList;
    for i:=0 to cc.Count -1 do
    begin
        nc := cc.Items[i];
        if nc=nil then Continue;
        WriteCCWave(nc, CurSmfTrack, noteLen, ch);
    end;
end;

function TMmlBase.funcDirectSmf(var sp: TSrcPos): TMVarCustom;
var
    v: TMArray;
    i: Integer;
    b: TArrayOfByte;
begin
    //���ځASMF�C�x���g����������
    Result := nil;
    v := getArgs(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['DirectSMF']);
    if v.Count = 0 then Exit;

    SetLength(b, v.Count);
    for i:=0 to v.Count -1 do
    begin
        b[i] := Byte(v.IntItems[i]);
    end;

    WriteDirectSmf(b);
end;

procedure TMmlBase.WriteDirectSmf(byteArray: TArrayOfByte);
var
    c: TSmfDirect ;
begin
    c := TSmfDirect.Create ;
    c.Time := CurTrack.TimePtr ;
    c.Event := byteArray[0];
    c.byteArray := byteArray;
    CurSmfTrack.Add(c); 
end;

function TMmlBase.funcNoteOff(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    b: TArrayOfByte ;
begin
    Result := nil;
    ary := getArgs(sp);
    if (ary=nil)or(ary.Count <> 2) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['NoteOff']);
    SetLength(b, 3);
    b[0] := EVENT_NOTE_OFF or CurTrack.Channel ;
    b[1] := Byte(ary.IntItems[0]);
    b[2] := Byte(ary.IntItems[1]);
    WriteDirectSmf(b);
end;

function TMmlBase.funcNoteOn(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    b: TArrayOfByte ;
begin
    Result := nil;
    ary := getArgs(sp);
    if (ary=nil)or(ary.Count <> 2) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['NoteOff']);
    SetLength(b, 3);
    b[0] := EVENT_NOTE_ON or CurTrack.Channel ;
    b[1] := Byte(ary.IntItems[0]);
    b[2] := Byte(ary.IntItems[1]);
    WriteDirectSmf(b);
end;

function TMmlBase.funcOctaveDown(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    if SongInfo.X68Mode then
    begin
        CurTrack.Octave.SetValue(0, CurTrack.Octave.ArrayNote[0].ROValue+1);
    end else begin
        CurTrack.Octave.SetValue(0, CurTrack.Octave.ArrayNote[0].ROValue-1);
    end;
end;

function TMmlBase.funcOctaveUp(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    if SongInfo.X68Mode then
    begin
        CurTrack.Octave.SetValue(0, CurTrack.Octave.ArrayNote[0].ROValue-1);
    end else begin
        CurTrack.Octave.SetValue(0, CurTrack.Octave.ArrayNote[0].ROValue+1);
    end;
end;

function TMmlBase.funcOctaveUpOnece(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    Inc(FlagOctaveUpOnce);
end;

function TMmlBase.funcWaon(var sp: TSrcPos): TMVarCustom;
var
    s:string;
    sp2: TSrcPos;
    len: Integer;
    m,v: TMInt;
begin
    Result := nil;
    RecWaon.Enable := True;

    //�a���͈̔͂𓾂�
    s := GetTokenChars([''''], sp.ptr);
    //�I�v�V����������΁A�I�v�V�����𓾂�
    len := GetNoteLength(sp, CurTrack.Stepmode, CurTrack.Length.GetValue);

    m := TMInt.Create ;
    m.value := len;
    if RecWaon.Option = nil then RecWaon.Option := TMArray.Create else RecWaon.Option.Clear ;
    RecWaon.Option.Add(m); //�I�v�V������ Length ���Z�b�g

    skipSpace(sp.ptr);
    if sp.ptr^ = ',' then //","�����遁�Q�[�g�̎w�肪����
    begin
        Inc(sp.ptr); skipSpace(sp.ptr);
        if sp.ptr^ in ['+','-'] then
        begin
            v := getArg(sp) as TMInt;
            v.value := v.value + CurTrack.Qgate.GetValue ;
        end else
        begin
            v := getArg(sp) as TMInt;
        end;
        RecWaon.Option.Add( v ); //�Q�[�g���Z�b�g
        skipSpace(sp.ptr);
        if sp.ptr^ = ',' then
        begin
            Inc(sp.ptr); skipSpace(sp.ptr);
            if sp.ptr^ in ['+','-'] then
            begin
                v := getArg(sp) as TMInt;
                v.value := v.value + CurTrack.Velocity.GetValue ;
            end else
            begin
                v := getArg(sp) as TMInt;
            end;
            RecWaon.Option.Add( v ); //�x���V�e�B���Z�b�g
            skipSpace(sp.ptr);
            if sp.ptr^ = ',' then
            begin
                Inc(sp.ptr);
                RecWaon.Option.Add( getArg(sp) ); //�^�C�~���O���Z�b�g
                skipSpace(sp.ptr);
                if sp.ptr^ = ',' then
                begin
                    Inc(sp.ptr); skipSpace(sp.ptr);
                    if sp.ptr^ in ['+','-'] then
                    begin
                        v := getArg(sp) as TMInt;
                        v.value := v.value + CurTrack.Octave.GetValue ;
                    end else
                    begin
                        v := getArg(sp) as TMInt;
                    end;
                    RecWaon.Option.Add( v ); //�I�N�^�[�u���Z�b�g
                end;
            end;
        end;
    end;

    //�a���J�n���Ԃ��Z�b�g
    RecWaon.Time := CurTrack.TimePtr ;

    //�ϐ����R���p�C������
    sp2 := TSrcPos.Create ;
    try
        sp2.Assign(sp);
        sp2.SetTempSource(s); //�a���͈̔͂��Z�b�g
        Compile(sp2); // �a���͈̔͂��R���p�C��
    finally
        sp2.Free;
    end;
    RecWaon.Enable := False;
    if RecWaon.Option <> nil then RecWaon.Option.Free ;
    RecWaon.Option := nil;
end;

function TMmlBase.funcDiv(var sp: TSrcPos): TMVarCustom;
var
    temp,cnt,len, rLen, last: Integer;
    s: string;
    m: TMVarCustom;
    sp2: TSrcPos;
    p: PChar;
begin
    Result := nil;
    // Div{ (mml) }(n) �́Amml �����𓾂�
    skipSpace(sp.ptr);
    if sp.ptr^ <> '{' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"Div{ .. }(len)"�Ŏw�肵�Ă��������B',sp),['Div']);
    m := getArg(sp);
    if m.ClassType <> TMStr then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"Div{ .. }(len)"�Ŏw�肵�Ă��������B',sp),['Div']);
    s := m.StrValue ;
    m.Free ;
    // �����𓾂�
    len := GetNoteLength(sp, CurTrack.Stepmode, CurTrack.Length.GetValue);
    if s='' then Exit;

    //s�̒��ɉ�������������̂�������
    cnt := 0;
    p := PChar(s);
    while p^ <> #0 do
    begin
        if p^ in ['c','d','e','f','g','a','b','n','r'] then
        begin
            Inc(cnt);
            Inc(p);
        end else
        if p^ ='''' then begin
            Inc(cnt);
            Inc(p);
            while p^ <> '''' do Inc(p); Inc(p);
        end else
            Inc(p);
    end;
    //�����P�̃X�e�b�v���𓾂�
    if cnt=0 then rLen := len else rLen := len div cnt;
    last := CurTrack.TimePtr + len;
    temp := CurTrack.Length.GetValue ;

    //Div��MML�������R���p�C��
    CurTrack.Length.SetValue(0, rLen); //������ Div ���ɃZ�b�g
    sp2 := TSrcPos.Create;
    try
        sp2.Assign(sp);
        sp2.SetTempSource(s);
        Compile(sp2);
    finally
        sp2.Free ;
    end;
    CurTrack.Length.SetValue(0, temp); //������ ���ɖ߂�
    CurTrack.TimePtr := last; //�{�� Div �̌�̃^�C���|�C���^�ɖ߂� 
end;

function TMmlBase.scriptRPN(var sp: TSrcPos): TMVarCustom;
begin
    sp.cmd := 'RPN';
    setRpnNrpn(sp, typeRpn);
    Result := nil;
end;

function TMmlBase.scriptNRPN(var sp: TSrcPos): TMVarCustom;
begin
    sp.cmd := 'NRPN';
    setRpnNrpn(sp, typeNrpn);
    Result := nil;
end;

procedure TMmlBase.setRpnNrpn(var sp: TSrcPos; rpnType: TRpnType);
var
    ary: TMArray;
    rpn:TSmfRPN ;

    procedure chkBendRange;
    begin
        //�x���h�����W�́A�L�����Ă���
        if rpn.rpnType = typeRPN then
        begin
            if (rpn.msb=0)and(rpn.lsb=0) then
            begin
                SongInfo.BendRange[ CurTrack.Channel ] := rpn.data ;
            end;
        end;
    end;

begin
    //rpn(msb,lsb,data)
    ary := getArgs(sp);
    if (ary=nil)or(ary.Count<2) then begin
        raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"%s(msb,lsb[,data])"�Ŏw�肵�Ă��������B',sp),[sp.cmd,sp.cmd]);
    end;
    //
    //���^�C����RPN/NRPN���������܂Ȃ����߂�SHIFT
    if (RpnShift.ch = CurTrack.Channel)and(RpnShift.time = CurTrack.TimePtr) then
    begin
        Inc(RpnShift.shift,(ary.Count)*SongInfo.ControllerShift) ;
    end else
    begin
        RpnShift.shift := 0;
    end;

    rpn := TSmfRPN.Create ;
    rpn.Time := CurTrack.TimePtr - RpnShift.shift -1;//1step�O�ɏ�������
    rpn.rpnType := rpnType;
    rpn.Event := EVENT_CONTROL_CHANGE or CurTrack.Channel ;
    rpn.msb := Byte(ary.IntItems[0]);
    rpn.lsb := Byte(ary.IntItems[1]);
    if ary.Count >= 3 then
    begin
        rpn.data := Byte(ary.IntItems[2]);
        rpn.byteCount := 3;
        chkBendRange;
    end else
    begin
        rpn.byteCount := 2;
    end;
    CurSmfTrack.Add(rpn);

    RpnShift.ch    := CurTrack.Channel ;
    RpnShift.time  := CurTrack.TimePtr ;
end;

function TMmlBase.scriptSysEx(var sp: TSrcPos): TMVarCustom;
var
    mv, chk: TMArray;
    i,j,idx,sum,r: Integer;
    Flag: Char;
    ary: TArrayOfByte ;
    v: TMVarCustom;
    sp2: TSrcPos;
    sysex: TSmfSysEx ;
begin
    Result := nil;
    Flag := sp.ptr^;
    if Flag = '$' then //�Ȍ�S��16�i�����[�h
    begin
        inc(sp.ptr);
        mv := getArgsHex(sp);
    end else
    begin
        mv := getArgs(sp);
    end;
    if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);

    SetLength(ary, 1024); //�K���Ƀo�C�g���m��
    idx := 0;

    //�`�F�b�N�T���̏���
    for i:=0 to mv.Count -1 do
    begin
        v := mv.Items[i];
        if v.ClassType = TMInt then
        begin
            ary[idx] := Byte(v.IntValue);
            Inc(idx);
        end else
        if v.ClassType = TMStr then
        begin
            //�`�F�b�N�T���̌v�Z
            sp2 := TSrcPos.Create ;
            sp2.Assign(sp); 
            sp2.SetTempSource(v.StrValue);
            if Flag='$' then
                chk := getArgsHex(sp2)
            else begin
                sp2.src := '=' + sp2.src ;
                sp2.ptr := PChar(sp2.src);
                chk := getArgs(sp2);
            end;
            sp2.Free ;
            if chk<>nil then begin
                //_debug(chk.StrValue);
                sum := 0;
                for j:=0 to chk.Count -1 do
                begin
                    r := chk.IntItems[j];
                    sum := sum + r;
                    ary[idx] := r;
                    Inc(idx);
                end;
                r := 128 - (sum mod 128);
                ary[idx] := r; //�`�F�b�N�T���t��
                Inc(idx);
            end;
        end;
    end;
    //
    sysex := TSmfSysEx.Create ;
    sysex.Time := CurTrack.TimePtr ;
    sysex.Event := EVENT_SYS_EX ;
    if ary[0] = EVENT_SYS_EX then
        sysex.byteArray := Copy(ary, 1, idx-1)
    else
        sysex.byteArray := Copy(ary, 0, idx);
    ary := nil;
    CurSmfTrack.Add(sysex); 
end;

function TMmlBase.getArgsHex(var sp: TSrcPos): TMArray;
var
    sp2: TSrcPos;

    procedure getArray(pp: TSrcPos);

        procedure getNum;
        var s: string; m: TMInt;
        begin
            s := '';
            while pp.ptr^ in ['0'..'9','A'..'F','a'..'f'] do begin s := s + pp.ptr^; Inc(pp.ptr); end;
            s := '$' + s; //
            m := TMInt.Create ;
            m.value := StrToIntDef(s, 0);
            Result.Add(m);
        end;

    begin
        Result := TMArray.Create ;
        while True do
        begin
            skipSpace(pp.ptr); 
            case pp.ptr^ of
                '(': Result.Add( getArg(pp) ) ; //�ϐ�or�v�Z�����P�擾
                '{': Result.Add( getArg(pp)) ; //��������P�擾
                '0'..'9','A'..'F','a'..'f':
                begin
                    getNum;
                end;
            end;

            skipSpace(pp.ptr);
            if pp.ptr^ = ',' then //���������邩����
            begin
                Inc(pp.ptr);
            end else
                Break;//�I���
        end;
    end;

begin
    // ���������邩���ʁB�Ȃ���΁A�m�h�k��Ԃ�
    skipSpace(sp.ptr);
    case sp.ptr^ of
    //��������
    '=':
        begin
            Inc(sp.ptr);
            getArray( sp );
        end;
    '(':
        begin //�J�b�R��W�J���āA�ϐ����Z�b�g����
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp);
                sp2.SetTempSource( getMaruKakko(sp) );
                getArray( sp2 );
            finally
                sp2.Free;
            end;
        end;
    '0'..'9','A'..'F','a'..'f':
        begin
            getArray(sp);
        end;
    //�����Ȃ�
    else
        begin
            Result := nil;
        end;
    end;
end;

function TMmlBase.scriptTempo(var sp: TSrcPos): TMVarCustom;  //20~240�͈̔͂ɂ��ׂ�
var
    meta: TSmfTempo ;
    v: DWORD;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ARG_CHAR then
    begin
        //��������
        while True do
        begin
          skipSpace(sp.ptr);
          if sp.ptr^ = '=' then
            Inc(sp.ptr) // Tempo= = 50 �̂悤�� ver.1 �݊����̂���
          else
            Break;
        end;

        if sp.ptr^ in ['0'..'9'] then
          v := GetIntValue(sp)
        else
          v := GetIntValueAndCalc(sp);

        if v<=0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"Tempo(n)"�Ŏw�肵�Ă��������B(20~240�͈̔͂��]�܂���)',sp),['Tempo']);
        SongInfo.Tempo := v;
        meta := TSmfTempo.Create ;
        with meta do
        begin
            Time := CurTrack.TimePtr ;
            SetTempo(SongInfo.Tempo);
        end;
        //CurSmfTrack.Add(meta); //�e���|�g���b�N�́A�O�Ɏ����Ă���ׂ�
        SmfSong.GetTrack(0).Add(meta);
    end;

    Result := TMInt.Create;
    TMInt(Result).value := SongInfo.Tempo ;
end;

function TMmlBase.scriptTimeSig(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    ha,haha,ko: Integer;
    meta: TSmfMeta ;

    function pow(v, cnt: Integer): Integer;
    var i: Integer;
    begin
        Result := 1;
        for i:=1 to cnt do
            Result := Result * v;
    end;
    procedure subHaha;
    var i,n: Integer;
    begin
        i := 1;
        while True do begin
            n := pow(2,i);
            if n>=haha then Break;
            Inc(i);
        end;
        ha := i;
    end;

begin
    Result := nil;
    ary := getArgs(sp);
    ko   := ary.IntItems[0];
    haha := ary.IntItems[1];
    if (ko=0)or(haha=0) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"TimeSignature(���q,����)"�Ŏw�肵�Ă��������B',sp),['TimeSignature']);
    //
    subHaha;
    SongInfo.TimeSigKo := ko;
    SongInfo.TimeSigHa := haha;
    meta := TSmfMeta.Create ;
    with meta do
    begin
        Time := CurTrack.TimePtr ;
        Event := EVENT_META ;
        MetaType := META_TIME_SIG;
        SetLength(byteArray,4);
        byteArray[0] := Byte(ko);
        byteArray[1] := Byte(ha);
        byteArray[2] := Byte(SongInfo.TimeBase);        // ���g���m�[��Step
        byteArray[3] := (SongInfo.TimeBase div 8);// 32������Step
    end;
    CurSmfTrack.Add(meta);
end;

function TMmlBase.scriptTime(var sp: TSrcPos): TMVarCustom;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ = '=' then
    begin // ���X�e�b�v���̑��
        CurTrack.TimePtr := GetIntValueAndCalc(sp) ;
    end else
    if sp.ptr^ = '(' then
    begin //�Z�b�g
        CurTrack.TimePtr := GetTimeValue(sp);
    end;

    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.TimePtr ;
end;

function TMmlBase.scriptChPrefix(var sp: TSrcPos): TMVarCustom;
var
    meta: TSmfMeta ;
    v: Integer;
begin
    skipSpace(sp.ptr);
    //��������
    v := GetIntValue(sp);
    if v<=0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['ChannelPrefix']);
    meta := TSmfMeta.Create ;
    with meta do
    begin
        Time := CurTrack.TimePtr ;
        Event := EVENT_META ;
        MetaType := META_CH_PREFIX;
        SetLength(byteArray,1);
        byteArray[0] := Byte(v-1);
    end;
    CurSmfTrack.Add(meta);
    Result := nil;
end;

function TMmlBase.scriptCopyright(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_COPYRIGHT);
    Result := nil;
end;

function TMmlBase.scriptCuePoint(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_CUE_POINT);
    Result := nil;
end;

function TMmlBase.scriptInstrumentName(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_INST_NAME);
    Result := nil;
end;

function TMmlBase.scriptLyric(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_LYRIC);
    Result := nil;
end;

function TMmlBase.scriptMarker(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_MARKER);
    Result := nil;
end;

function TMmlBase.scriptMetaText(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_TEXT);
    Result := nil;
end;

function TMmlBase.scriptTrackName(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_TRACK_NAME);
    Result := nil;
end;

procedure TMmlBase.WriteMetaText(var sp: TSrcPos; mType: Byte);
var
    mv: TMVarCustom ;
    txt: string;
    meta: TSmfMeta ;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ = '=' then Inc(sp.ptr);
    skipSpace(sp.ptr);
    if sp.ptr^ = '=' then Inc(sp.ptr);
    
    if sp.ptr^ = '"' then
    begin //ver.xx�݊��̂���
      Inc(sp.ptr);
      mv := TMStr.Create ;
      TMStr(mv).value := GetTokenChars(['"'], sp.ptr);  
    end else begin
      mv := getArgAndCalc(sp);
    end;
    if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'`MetaText={"text"}`�̌`���Ŏw�肵�Ă��������B',sp),['���^�C�x���g']);
    txt := mv.StrValue ;

    if mType=META_TRACK_NAME then // MLD�̃^�C�g�������o���悤�Ɋo���Ă���
    begin
        SmfSong.TrackName := txt;
    end;

    if (Copy(txt,1,1)='"')and(Copy(txt,Length(txt),1)='"') then
    begin
        txt := Copy(txt,2, Length(txt)-2);
    end;

    meta := TSmfMeta.Create ;
    with meta do
    begin
        Event := EVENT_META ;
        Time := CurTrack.TimePtr ;
        MetaType := mType;
        if txt='' then txt := ' ';
        SetLength(byteArray, Length(txt));
        Move(txt[1], byteArray[0], Length(txt));
    end;
    CurSmfTrack.Add(meta);
end;

function TMmlBase.scriptSub(var sp: TSrcPos): TMVarCustom;
var
    sp2: TSrcPos;
    t: Integer;
begin
    skipSpace(sp.ptr);//
    sp2 := TSrcPos.Create ;
    try
        sp2.Assign(sp);
        sp2.SetTempSource(GetNakaKakko(sp));

        //�^�C���|�C���^���L��
        t := CurTrack.TimePtr ;
        //{ } �̒������s
        Compile(sp2);
        //�^�C���|�C���^��߂�
        CurTrack.TimePtr := t;

    finally
        sp2.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptPlay(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    i, nowTr, nowPtr: Integer;
    sp2: TSrcPos;
    mv: TMVarCustom ;
    sc: set of Char;
begin
    Result := nil;
    sp2 := TSrcPos.Create ;
    try

    sp2.Assign(sp);//

    // Play( A; B; C; D... ) �𓾂�
    sc := ValueSplitChar ;
    ValueSplitChar := [',',';'];
    ary := getArgs(sp);
    ValueSplitChar := sc;

    if ary=nil then Exit;

    //�g���b�N���ɏ�������
    nowTr  := CurTrack.TrackNo ;
    nowPtr := CurTrack.TimePtr ;
    //_debug(ary.count);
    for i := 0 to ary.Count -1 do
    begin
        mv := ary.Items[i];
        if mv=nil then Continue;
        if mv.ClassType <> TMStr then Continue;

        SetCurTrack(i); //�g���b�N��ύX
        CurTrack.TimePtr := nowPtr; //�|�C���^�����킹��
        sp2.Assign(sp); 
        sp2.SetTempSource(mv.StrValue);
        try
            Compile(sp2);
        except
            raise EMml.CreateFmt(ErrMsg(MML_ERR_PLAY,sp),[i, sp2.src]);
        end;
    end;
    //�g���b�N�����ɖ߂�
    SetCurTrack(nowTr);

    finally
        sp2.Free;
    end;

end;

function TMmlBase.scriptSystem(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;

    procedure subInclude;
    begin
        Result := scriptInclude(sp);
    end;

    procedure subX68mode;
    begin
        SongInfo.X68Mode := (BOOL_FALSE <> GetIntValue(sp));
    end;

    procedure subStepmode;
    begin
        SongInfo.Stepmode := (BOOL_FALSE <> GetIntValue(sp));
    end;

    procedure subqMax;
    begin
        SongInfo.qMax := GetIntValue(sp);
    end;

    procedure subvMax;
    begin
        SongInfo.vMax := GetIntValue(sp);
    end;

    procedure subvAdd;
    begin
        SongInfo.vAdd := GetIntValue(sp);
    end;

    procedure subqAdd;
    begin
        SongInfo.qAdd := GetIntValue(sp);
    end;

    procedure subq2Add;
    begin
        SongInfo.q2Add := GetIntValue(sp);
    end;

    procedure subTimeBase;
    begin
        Result := scriptTimeBase(sp);
    end;

    procedure subRandomSeed;
    begin
        v := GetIntValue(sp);
        RandSeed := v;
    end;

    procedure subKeyshift;
    begin
        SongInfo.Keyshift := GetIntValue(sp); 
    end;

    procedure subMeasureShift;
    begin
        SongInfo.MeasureShift := GetIntValue(sp);
    end;

    procedure subVoiceNoShift;
    begin
        SongInfo.VoiceNoShift := GetIntValue(sp);
    end;

    procedure subOctaveRangeShift;
    begin
        SongInfo.OctaveRangeShift := GetIntValue(sp); 
    end;

    procedure subKeyFlag;
    begin
        Result := scriptKeyFlag(sp);
    end;

    procedure subControllerShift;
    begin
        SongInfo.ControllerShift := GetIntValue(sp); //�R���g���[���̏������݃^�C�~���O
        SmfSong.CCShift := SongInfo.ControllerShift;
    end;

    procedure subTimeSignature;
    begin
        scriptTimeSig(sp); 
    end;

{System �I�v�V����
Include
LoadSMF
X68mode
Stepmode
qMax
vMax
vAdd
qAdd
q2Add
TimeBase
TimeSignature
RandomSeed
Keyshift
MeasureShift
VoiceNoShift
OctaveRangeShift
KeyFlag
GetKeyFlag
ControllerShift
}

var
    s: string;
begin
    Result := nil;
    if sp.ptr^<>'.' then Exit;
    Inc(sp.ptr);
    //s := Trim(GetTokenChars(['+','-','=','(','#'], sp.ptr));
    //Dec(sp.ptr); //back +-=(
    s := Trim(getTokenWord(sp.ptr)); 
    {System�I�v�V����}
    if s='Include' then subInclude else //Include(fname)//��`�t�@�C������荞��Ŏ��s����
    if s='LoadSMF' then {����`} else //System.LoadSMF(fname)//����`
    if s='X68mode' then subX68mode else //System.X68mode(on/off)//�I�N�^�[�u�̏㉺�L��<>�����ւ���B�����l�́Aoff
    if s='Stepmode' then subStepmode else //System.Stepmode(on/off)//�X�e�b�v�w�����{�Ƃ���B�����l�́Aoff
    if s='qMax' then subqMax else //System.qMax=value//q��100%���̒l���w�肷��B�����l�́A100�B����MML�Ȃǂ̍Č��p�B�i��jSystem.qMax=8
    if s='vMax' then subvMax else //Sysytem.vMax=value//v�̍ő�l���w�肷��B�����l�́A127�B����MML�Ȃǂ̍Č��p�B�i��jSystem.vMax=15
    if s='vAdd' then subvAdd else ////v++�ŉ��Z����l���w�肷��
    if s='qAdd' then subqAdd else ////q++�ŉ��Z����l���w�肷��
    if s='q2Add' then subq2Add else ////q%++�ŁA���Z����l���w�肷��
    if s='TimeBase' then subTimeBase else //TimeBase=value//�l����������\�B�^�C���x�[�X���w�肷��B�����l�́A96�B48,96,120,196,240,480�Ȃǂ���ʓI�B
    if s='TimeSignature' then subTimeSignature else //TimeSignature=���q,����//���q�L���̐ݒ���s��
    if s='RandomSeed' then subRandomSeed else //RandomSeed=v//�����̎���w�肵�āA���񓯂�������������悤�ɂ���B
    if s='Keyshift' then subKeyshift else //System.Keyshift=v//�L�[��v�����グ��
    if s='MeasureShift' then subMeasureShift else //System.MeasureShift=v//���ߐ������炵��Time(1:1:0)�ȑO�ɏ����ݒ肪�o����悤�ɂ���B
    if s='VoiceNoShift' then subVoiceNoShift else //System.VoiceNoShift=v//���F�ԍ����A0����n�܂鉹���̏ꍇ�ɁA-1���w�肷��A�����l�́A0
    if s='OctaveRangeShift' then subOctaveRangeShift else //System.OctaveRangeShift=v//�I�N�^�[�u�����W�̃V�t�g�l�B�����l�́A0�B
    if s='KeyFlag' then subKeyFlag else //KeyFlag[+|-](mml)|KeyFlag=(a,b,c,d,e,f,g)//�Վ��L����K�p����B�z��ɑ������ƁA�L�[�t���O�̒l�𓾂���B
    if s='GetKeyFlag' then subKeyFlag else//Array (name) = System.GetKeyFlag//�L�[�t���O�̒l��z��ɓǂݍ���
    if s='ControllerShift' then subControllerShift else//System.ControllerShift=v//�e��G�t�F�N�g�̏������݃^�C�~���O�̐���B�����l�́A3�B
    {/System�I�v�V����}
    raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[s]) ;

end;

function TMmlBase.scriptInclude(var sp: TSrcPos): TMVarCustom;
var
    sp2: TSrcPos;
    fname, s: string;
    fno: Integer;
    ms: TMStr;

    function FindPath(fname: string; var s: string): Boolean;
    var
      AppPath, CurDir, Up, ss, p: string;
    begin
      Result := False;

      // AppPath ������
      AppPath := ExtractFilePath( ParamStr(0) );
      s := AppPath + fname;
      if FileExists(s) then begin Result := True; Exit; end;
      s := AppPath + 'Include\' + fname;
      if FileExists(s) then begin Result := True; Exit; end;

      // CurDir ������
      CurDir := GetCurrentDir + '\';
      s := CurDir + fname;
      if FileExists(s) then begin Result := True; Exit; end;
      s := CurDir + 'Include\' + fname;
      if FileExists(s) then begin Result := True; Exit; end;

      // ../Include ������
      Up := ExtractFilePath(Copy(AppPath, 1, Length(AppPath) -1));
      s := Up + fname;
      if FileExists(s) then begin Result := True; Exit; end;
      s := Up + 'Include\' + fname;
      if FileExists(s) then begin Result := True; Exit; end;

      // ../Include ������ (2)
      Up := ExtractFilePath(Copy(CurDir, 1, Length(CurDir) -1));
      s := Up + fname;
      if FileExists(s) then begin Result := True; Exit; end;
      s := Up + 'Include\' + fname;
      if FileExists(s) then begin Result := True; Exit; end;

      // ���ϐ������`�F�b�N
      ss := GetEnvironmentVariable('Path');
      while ss<> '' do
      begin
        p := GetToken(';', ss);
        s := p + fname;
        if FileExists(s) then begin Result := True; Exit; end;
        s := p + 'Include\' + fname;
        if FileExists(s) then begin Result := True; Exit; end;
      end;
    end;


begin
    Result := nil;

    //�t�@�C�����𓾂�
    skipSpace(sp.ptr);
    if sp.ptr^ = '(' then
    begin
        fname := GetMaruKakko(sp);
    end else raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Include']);

    //fname : ���ʗp�̖��O
    //s     : �t���p�X�̃t�@�C����
    if FindPath(fname, s)=False then
    begin
      raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'�t�@�C��"%s"��������܂���B',sp),['Include',fname]);
    end;

    //�\�[�X�̓�d��荞�݃`�F�b�N
    if IncludedFiles.IndexOf(fname)>=0 then
    begin
        //��荞��ł��邩�甲����
        Exit;
    end;

    //�t�@�C���ԍ��ɒǉ�
    fno := IncludedFiles.Add(fname);

    ms := TMStr.Create ;
    ms.LoadFromFile(s);
    ms.value := PreCompile(ms.value, 0);
    IncludedSource.Add(ms);

    //
    sp2 := TSrcPos.Create ;
    try
        sp2.ptr := PChar(ms.value);
        sp2.lineNo := 0;
        sp2.fileNo := fno;
        sp2.cmd := 'Include';
        Compile(sp2);
    finally
        sp2.Free ;
    end;

end;


function TMmlBase.scriptKeyShift(var sp: TSrcPos): TMVarCustom;
begin
    skipSpace(sp.ptr);

    if sp.ptr^ in ARG_CHAR then
        SongInfo.Keyshift := GetIntValue(sp);

    Result := TMInt.Create ;
    TMInt(Result).value := SongInfo.Keyshift;
end;

function TMmlBase.scriptPort(var sp: TSrcPos): TMVarCustom;
var
    meta: TSmfMeta ;
    v: Integer;
begin
    skipSpace(sp.ptr);
    //��������
    v := GetIntValue(sp);
    if v<0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Port']);
    meta := TSmfMeta.Create ;
    with meta do
    begin
        Event := EVENT_META;
        Time := CurTrack.TimePtr ;
        MetaType := META_PORT;
        SetLength(byteArray,1);
        byteArray[0] := Byte(v);
    end;
    CurTrack.Port := v; // set port
    CurSmfTrack.Add(meta);
    Result := nil;
end;

function TMmlBase.funcOctaveDownOnece(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    Dec(FlagOctaveUpOnce);
end;

function TMmlBase.scriptCC_M(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,1);
    Result := nil;
end;

procedure TMmlBase.WriteCCComand(var sp: TSrcPos; cc: Integer);
var
    ccc: TSmfControlChange;
    v: Integer;
    n: TNoteCC;
    s: string;
    sp2: TSrcPos;
begin
    if sp.ptr^ = '.' then
    begin
        WriteCCOption(sp, cc); Exit;
    end else
    if sp.ptr^ = ',' then
    begin
        ShowHint(MML_WARN_VAR_SYNTAX+'�l�w��Ŗ��Ӗ���","�͎g���܂���B',sp);
        Inc(sp.ptr);
    end;
    v := 0;
    if sp.ptr^ = '(' then
    begin
        s := GetMaruKakko(sp);
        sp2 := TSrcPos.Create ;
        try
            sp2.SetTempSource(s);
            v := GetIntValueAndCalc(sp2);
        except
            sp2.Free ;
        end;
    end else
    begin
        v := GetIntValueAndCalc(sp); //�l�𓾂�
    end;

    //
    v := Min(v,127); //�ő�l���A127�Ɏ��߂�
    n := SongInfo.CC[CurTrack.Channel].GetCC(cc);
    n.No := cc;
    n.noteOnType := noteNormal ;
    n.Time := CurTrack.TimePtr ;
    n.LastValue := v; //�l���L������

    //
    if CurTrack.CCMute then Exit;
    if CurTrack.CCNoMute[cc] then Exit;

    //�g���b�N�֖��ʂɏ������܂��R���g���[���`�F���W���g��������(ver.2.32�ȍ~)
    DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, cc, CurTrack.TimePtr, False);

    //smf�ɏ�������
    ccc := TSmfControlChange.Create ;
    ccc.Time := CurTrack.TimePtr - SongInfo.ControllerShift;//1step�O�ɏ�������
    ccc.Event := EVENT_CONTROL_CHANGE or CurTrack.Channel ;
    ccc.No := cc;
    ccc.Value := Byte(v);
    CurSmfTrack.Add(ccc);
end;

function TMmlBase.scriptCC_PT(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,5);
    Result := nil;
end;

function TMmlBase.scriptCC_Chorus(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,93);
    Result := nil;
end;

function TMmlBase.scriptCC_DataLSB(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,38);
    Result := nil;

end;

function TMmlBase.scriptCC_DataMSB(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,6);
    Result := nil;

end;

function TMmlBase.scriptCC_Expression(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,11);
    Result := nil;
end;

function TMmlBase.scriptCC_MainVolume(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,7);
    Result := nil;

end;

function TMmlBase.scriptCC_Panpot(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,10);
    Result := nil;

end;

function TMmlBase.scriptCC_PortamentoSwitch(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,65);
    Result := nil;

end;

function TMmlBase.scriptCC_Reverb(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,91);
    Result := nil;

end;

function TMmlBase.scriptCC_VAR(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,94);
    Result := nil;

end;

function TMmlBase.scriptRythm(var sp: TSrcPos): TMVarCustom;

    function ReplaceRythm(src: string): string;
    var
      sp3: TSrcPos;
      s, ss: string;
      node: TMHashNode;
      IsDiv: Boolean;

        procedure get_arg_num; // ss �� ? ��, ���������ɒu������
        var a: string;
        begin
          //�����𓾂�
          a := '';
          if sp3.ptr^ in ['0'..'9','$','^'] then
          begin
            while sp3.ptr^ in ['0'..'9','$','.','^'] do begin
              a := a + sp3.ptr^; Inc(sp3.ptr);
            end;
          end;
          //�}�N����u��
          ss := JReplace(ss, '?', a, True);
        end;

    begin
        Result := '';
        IsDiv := False;
        sp3 := TSrcPos.Create ;
        try
            sp3.Assign(sp);
            sp3.SetTempSource(src);
            while sp3.ptr^<>#0 do
            begin
                if sp3.ptr^ in LeadBytes then
                begin
                    Result := Result + sp3.ptr^ + (sp3.ptr+1)^;
                    Inc(sp3.ptr,2);
                end else
                begin //Rythm���[�h�ł́A1�����A1���߂ɂȂ�
                    if sp3.ptr^ = '$' then
                    begin //���Y��macro��`
                        Inc(sp3.ptr);
                        scriptRythmChar(sp3); Continue;
                    end else
                    if sp3.ptr^ = '(' then
                    begin //�J�b�R�̒������́A�񃊃Y�����[�h
                        s := GetMaruKakko(sp3);
                        s := JReplace(s,'Sub','',True);
                        Result := Result + s + ' ';//(v1)�Ƃ̌݊����̂��ߍŌ�ɃX�y�[�X���K�v
                        if Pos('Div',s)>0 then IsDiv := True;
                        Continue;
                    end else
                    if sp3.ptr^ = '#' then
                    begin
                        s := getTokenWord(sp3.ptr);
                        node := Commands.Items[s];
                        if node<>nil then
                        begin
                            s := ReplaceRythm(node.value.StrValue);
                            Result := Result + s ;
                        end else
                        begin
                            Result := Result + s;
                        end;
                        Continue;
                    end else
                    if sp3.ptr^ = '{' then //�[��Sub����
                    begin
                        s := GetNakaKakko(sp3);
                        if IsDiv then
                        begin
                          Result := Result + '{'+ ReplaceRythm(s) + '}'; IsDiv := False;
                        end else
                        begin
                          Result := Result + 'Sub{'+ ReplaceRythm(s) + '}';
                        end;
                        Continue;
                    end else
                    if (strLComp(sp3.ptr, 'Div', 3) = 0)or(strLComp(sp3.ptr, 'DIV', 3) = 0) then
                    begin
                        IsDiv := True;
                        Inc(sp3.ptr, 3);
                        Result := Result + 'Div';
                        Continue;
                    end else
                    if RythmChar[Ord(sp3.ptr^)] <> '' then
                    begin
                        //�}�N����W�J����
                        ss := RythmChar[Ord(sp3.ptr^)]; Inc(sp3.ptr);
                        if Pos('?', ss)>0 then get_arg_num;
                        Result := Result + ss;
                    end else begin
                        Result := Result + sp3.ptr^;
                        Inc(sp3.ptr);
                    end;
                end;
            end;
        finally
            sp3.Free ;
        end;
    end;

var
    sp2: TSrcPos;
    s: string;
begin
    //���Y�����[�h
    sp2 := TSrcPos.Create ;
    try
        sp2.Assign(sp);
        s := GetNakaKakko(sp);
        s := ReplaceRythm(s);
        //_debug(s);
        if MmlOption.RythmLog then
        begin
            WriteLog('// ---[Rythm���[�h�u��]--->');
            WriteLog(s);
            WriteLog('//<---[Rythm���[�h�u��]');
        end;
        sp2.SetTempSource(s);//{..}���擾
        try
            Compile(sp2);
        except
            raise;//�G���[���đ��o
        end;
    finally
        sp2.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptRythmChar(var sp: TSrcPos): TMVarCustom;
var
    c: Char;
    s: string;
begin
    //�}�N�������𓾂�
    if sp.ptr^ in LeadBytes then
    begin//�S�p��������A�G���[
        raise EMml.Create(ErrMsg(MML_ERR_DEF_MACRO+'���Y���}�N���͔��p�Ŏw�肵�Ă��������B',sp));
    end;
    c := sp.ptr^; Inc(sp.ptr);
    if(sp.ptr^='=')then Inc(sp.ptr);
    s := GetNakaKakko(sp);
    //�}�N���ɓ��e���Z�b�g
    RythmChar[Ord(c)] := s;
    Result := nil;
end;

procedure TMmlBase.DebugMeta(text: string);
var
    meta: TSmfMeta ;
begin
    text := Trim(text);
    meta := TSmfMeta.Create ;
    with meta do
    begin
        Time := CurTrack.TimePtr ;
        Event := EVENT_META ;
        MetaType := META_TEXT;
        if text='' then text := ' ';
        SetLength(byteArray, Length(text));
        Move(text[1], byteArray[0], Length(text));
    end;
    CurSmfTrack.Add(meta);
end;

function TMmlBase.scriptRandom(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    v1,v2: Integer;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Random']);
    if ary.Count = 0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Random']);


    Result := TMInt.Create ;
    if ary.Count = 1 then
    begin
        v1 := ary.IntItems[0];
        TMInt(Result).value := Random( v1 );
    end else
    begin
        v1 := ary.IntItems[0];
        v2 := ary.IntItems[1];
        if v1>v2 then
            TMInt(Result).value := Random( v1-v2 ) + v2
        else
            TMInt(Result).value := Random( v2-v1 ) + v1;
    end;
end;

function TMmlBase.scriptRandomSelect(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['RandomSelect']);

    Result := TMInt.Create ;
    TMInt(Result).value := ary.IntItems[Random(ary.Count)];
end;

function TMmlBase.scriptIntToStr(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom ;
begin
    v := getArg(sp);
    Result := TMStr.Create ;
    if v<>nil then
        TMStr(Result).value := v.StrValue ;
end;

function TMmlBase.scriptMML(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    p: PChar;
    v,i: Integer;
    n: TNoteCC;
    hn: TMHashNode ;

    procedure getWordsValue;
    var w: string;
    begin
        w := UpperCase(getTokenWord(p));
        if (w='BR') then
        begin
            v := SongInfo.BendRange[CurTrack.Channel];
        end else
        if (w='KEY') then
        begin
            v := SongInfo.Keyshift ;
        end else
        if (w='TIMEKEY') then
        begin
            v := GetNowTimeKey(0) ;
            if v=MaxInt then v := 0; //��K�p�̂Ƃ�
        end else
        if (w='TIMEKEY2') then
        begin
            v := GetNowTimeKey(1) ;
            if v=MaxInt then v := 0; //��K�p�̂Ƃ�
        end else
        if (w='PORT') then
        begin
            v := CurTrack.Port ;
        end else
        raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[w]);
    end;

    function NoteInfo(ni: TNoteInfos): Integer;
    var idx, no: Integer;
    begin
        idx := 0; Inc(p);
        if p^ = '_' then
        begin
            Inc(p);
            if p^ = '_' then
            begin
                Inc(p);
                no := StrToIntDef(GetNumber(p),-1);
                if no<0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['MML(�R�}���h__)�̂��Ƃɐ��l������܂���B']);
                idx := no + 1;
            end else
            begin
                idx := 1;
            end;
        end;
        try
            Result := ni.ArrayNote[idx].Value;
        except
            Result := 0;
        end;
    end;

begin
    s := GetMaruKakko(sp);
    hn := Commands.Items[s];
    if (hn<>nil)and(hn.nodeType = ntStr) then s := hn.value.StrValue;

    p := PChar(s);
    v := 0;
    skipSpace(p);//MML�l����
    case p^ of
    '@': v := CurTrack.Voice ;
    'v': v := NoteInfo(CurTrack.Velocity) ;
    'o': v := NoteInfo(CurTrack.Octave);
    'l': v := NoteInfo(CurTrack.Length);
    'q': v := NoteInfo(CurTrack.Qgate) ;
    't': v := NoteInfo(CurTrack.Timing) ;
    'h': v := CurTrack.Q2 ;
    'y':
        begin
            Inc(p);//skip 'y'
            i := StrToIntDef(GetNumber(p),-1);
            if i<0 then raise Emml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['MML']);
            n := SongInfo.CC[CurTrack.Channel].FindCC(i);
            if n=nil then
                v := 0
            else begin
                v := n.LastValue ;
                if v<0 then //�l�����ݒ�̂Ƃ��A���Z�b�g���̏����l������B
                begin
                    case n.No of
                    CC_NO_VOLUME:     v := 100;
                    CC_NO_EXPRESSION: v := 127;
                    CC_NO_PANPOT:     v :=  64;
                    end;
                end;
            end;
        end;
    'p':
        begin
            Inc(p);//skip 'p'
            if p^='%' then
                n := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND_FULL)
            else
                n := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND);
            v := n.LastValue ;
        end;
    'A'..'Z','_':
        begin
            getWordsValue;
        end;
    end;
    Result := TMInt.Create;
    TMInt(Result).value := v;
end;

function TMmlBase.scriptNoteNo(var sp: TSrcPos): TMVarCustom;
var
    o,v: Integer;
    s: string;
    hn: TMHashNode;
    nsp: TSrcPos;
    nn: Char;
begin
    //�m�[�g�i���o�[�𓾂镔��
    skipSpace(sp.ptr);
    s := GetMaruKakko(sp);
    hn := Commands.Items[s];
    if (hn<>nil)and(hn.nodeType = ntStr) then s := hn.value.StrValue;

    nsp := TSrcPos.Create ;
    nsp.Assign(sp);
    nsp.SetTempSource(s);
    o := CurTrack.Octave.GetValue ;
    v := 0;
    while nsp.ptr^ <> #0 do
    begin
        if nsp.ptr^='o' then
        begin
            Inc(nsp.ptr);
            o := GetIntValue(nsp);
        end else
        if nsp.ptr^ in ['a'..'g','n'] then
        begin
            nn := nsp.ptr^; Inc(nsp.ptr);
            v := GetNoteNo(nsp, nn, False);
        end else
            Inc(nsp.ptr);
    end;
    Result := TMInt.Create ;
    TMInt(Result).value := o*12 + v;
end;

function TMmlBase.scriptStep(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    sp2: TSrcPos;
begin
    s := '!'+GetMaruKakko(sp);
    sp2 := TSrcPos.Create;
    try
        sp2.Assign(sp);
        sp2.SetTempSource(s);
        Result := getArg(sp2);
    finally
        sp2.Free ;
    end;
end;

function TMmlBase.scriptStrToLen(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    sp2: TSrcPos;
begin
    s := GetMaruKakko(sp);

    sp2 := TSrcPos.Create;
    try
        sp2.Assign(sp);
        sp2.SetTempSource('!('+s+')');
        Result := TMInt.Create ;
        TMInt(Result).value := GetIntValueAndCalc(sp2);
    finally
        sp2.Free ;
    end;
end;

function TMmlBase.scriptStrToNum(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    sp2: TSrcPos;
begin
    s := GetMaruKakko(sp);
    sp2 := TSrcPos.Create;
    try
        sp2.Assign(sp);
        sp2.SetTempSource('('+s+')');
        Result := TMInt.Create ;
        TMInt(Result).value := GetIntValueAndCalc(sp2);
    finally
        sp2.Free ;
    end;
end;

function TMmlBase.scriptTrackSync(var sp: TSrcPos): TMVarCustom;
var
    i,tm: Integer;
begin
    tm := CurTrack.TimePtr ;
    for i:=0 to SongInfo.Count -1 do
    begin
        if SongInfo.Items[i] <> nil then
        begin
            TTrackInfo(SongInfo.Items[i]).TimePtr := tm;
        end;
    end;
    SongInfo.TrackSyncTime := tm; //���㐶�������g���b�N�ɔ�����
    Result:= nil;
end;

{function TMmlBase.GetTokenComma(var sp: TSrcPos): string;
begin
    Result := '';
    if sp.ptr^ = '{' then
    begin
        Result := getString(sp.ptr, sp.lineNo);
        Exit;
    end;
    while sp.ptr^ <> #0 do
    begin
        if sp.ptr^ in LeadBytes then
        begin
            Result := Result + sp.ptr^ + (sp.ptr+1)^;
            Inc(sp.ptr,2); Continue;
        end;
        if sp.ptr^ in [#13,#10] then Break;
        if sp.ptr^ in ValueSplitChar then Break;
        Result := Result + sp.ptr^;
        Inc(sp.ptr);
    end;
end;}


function TMmlBase.getArgsWithType(var sp: TSrcPos;
  varType: string): TMArray;
begin
  Result := TokenBase.GetArgs(sp, varType); 
end;

(*
function TMmlBase.getArgsWithType(var sp: TSrcPos;
  varType: string): TMArray;
var
    sp2: TSrcPos;
    s: string;
    node: TMHashNode;

    procedure getArray(var pp: TSrcPos);
    var
        i: Integer;
        v: TMVarCustom ;
        s: string;
        n: TMHashNode ;
        temp,p: PChar;
        sp3: TSrcPos;

        procedure getArrayType(var pp: TSrcPos);
        var spa: TSrcPos;
        begin
            begin
                while True do
                begin
                    if (pp.ptr^ = '(') then
                    begin
                        spa := TSrcPos.Create ;
                        try
                            spa.Assign(pp);
                            s := GetMaruKakko(pp);
                            spa.SetTempSource(s);
                            getArrayType(spa);
                        finally
                            spa.Free ;
                        end;
                    end else
                    begin
                        v := getArgAndCalc(pp);
                        if v=nil then
                        begin
                            if pp.ptr^ in ValueSplitChar then //�������ɃJ���}
                            begin
                                Result.AddInt(0);
                                Inc(pp.ptr);
                                Continue;
                            end else
                            begin
                                Result.AddInt(0);
                                Break;
                            end;
                        end;
                        if v.ClassType = TMArray then
                        begin
                            Result.AddArray(v as TMArray);
                        end else
                            Result.Add(v);
                    end;
                    skipSpace(pp.ptr);
                    if pp.ptr^ in ValueSplitChar then Inc(pp.ptr) else Break;
                end;
            end;
        end;

    begin
        //�^�ɕ����Ĉ����𓾂�
        Result := TMArray.Create ;
        for i:=1 to Length(varType) do
        begin
            skipSpace(pp.ptr);
            if pp.ptr^ = #0 then Break;
            case varType[i] of
            'i':
                begin
                    v := getArgAndCalc(pp);
                    if v<>nil then begin
                        if v.ClassType = TMArray then Result.AddArray(v as TMArray);
                    end;
                    Result.Add( v ) ; //�������P�擾
                end;
            'a':
                begin
                    if pp.ptr^ in ['A'..'Z','a'..'z','_','#'] then
                    begin
                        temp := pp.ptr;
                        s := getTokenWord(pp.ptr);
                        n := Commands.Items[s];
                        if n.nodeType = ntArray then
                        begin
                            Result.AddArray(n.value as TMArray);
                        end else
                        begin
                            pp.ptr := temp;
                            getArrayType(pp);
                        end;
                    end else
                        getArrayType(pp);
                end;
            's':
                begin
                    if pp.ptr^ = '{' then
                    begin
                        v := getArg(pp);
                    end else
                    begin
                        s := GetTokenComma(pp);
                        n := Commands.Items[s];
                        if (n=nil)or(n.nodeType <> ntStr) then
                        begin
                            sp3 := TSrcPos.Create ;
                            try
                                sp3.Assign(pp);
                                sp3.SetTempSource(s);
                                p := sp3.ptr;
                                {
                                if p^ in ['A'..'Z','a'..'z','_','#'] then
                                begin
                                    v := TMStr.Create ;
                                    TMStr(v).value := s;
                                end else
                                begin
                                    v := getArgAndCalc(sp3);
                                end;}
                                if p^ in ARG_CHAR then
                                begin
                                    v := getArgAndCalc(sp3);
                                end else
                                begin
                                    v := TMStr.Create ;
                                    TMStr(v).value := s;
                                end;
                                //raise Exception.CreateFmt(ErrMsg(MML_ERR_SYSTEM+'"%s"',pp),[p^]);
                            finally
                                sp3.Free ;
                            end;
                        end
                        else
                            v := n.value ;
                    end;
                    Result.Add(v);
                end;
            end;
            skipSpace(pp.ptr);
            if pp.ptr^ in ValueSplitChar then Inc(pp.ptr) else Break;
        end;
    end;

begin
    // ���������邩���ʁB�Ȃ���΁ANIL ��Ԃ�
    skipSpace(sp.ptr);
    case sp.ptr^ of
    //��������
    '=':
        begin
            Inc(sp.ptr);
            getArray( sp );
        end;
    '(':
        begin //�J�b�R��W�J���āA�ϐ����Z�b�g����
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp); 
                s := getMaruKakko(sp);
                if Pos(',',s) = 0 then
                begin
                    node := Commands.Items[s];
                    if node=nil then
                    begin
                        if not((Copy(s,1,1)='{')and(Copy(s,Length(s),1)='}')) then
                        begin
                            if Copy(varType,1,1)='s' then s := '{'+s+'}';
                        end;
                    end else
                    begin
                        Result := TMArray.Create ;
                        Result.Add(node.value.clone);
                    end;
                end;
                sp2.SetTempSource( s );
                try
                    getArray( sp2 );
                except
                    on e: Exception do raise EParserError.Create(e.Message); 
                end;
            finally
                sp2.Free;
            end;
        end;
    '%','!','$','0'..'9','{':
        begin
            getArray(sp);
        end;
    //�����Ȃ�
    else
        begin
            Result := nil;
        end;
    end;
end;
*)

procedure TMmlBase.GetTrackDefaultValue(var len, gate, vel, tim,
  oct: Integer; var stepm: Boolean);
begin
    with CurTrack do //�J�����g�g���b�N�̃f�t�H���g�l�𓾂�
    begin
        len    := Length.GetValue ;
        gate   := Qgate.GetValue ;
        vel    := Velocity.GetValue ;
        tim    := Timing.GetValue ;
        oct    := Octave.GetValue ;
        stepm  := Stepmode;
    end;
    if StretchRate <> 1 then
    begin
        len := Trunc(len * StretchRate );
    end;
end;

function TMmlBase.getArgAndCalc(var sp: TSrcPos): TMVarCustom;
begin
  Result := TokenBase.GetArgCalc(sp); 
end;

(*
function TMmlBase.getArg_sub(var sp: TSrcPos): TMVarCustom;
var
    debugPos: TSrcPos;

    //�ϐ��E�֐��𓾂�
    procedure VarOrCommand;
    var
        key: string;
        node: TMHashNode;

    begin
        //�J���}�܂ł𓾂�
        //key := getTokenMML(sp.ptr);
        key := getTokenWord(sp.ptr); 

        if Copy(key,1,1)='#' then //��O�I�ȕ�����A"#�ϐ�"�̏���
        begin
            node := Commands.Items[ key ];
            if node=nil then begin //�Ȃ���΍��
                node := TMhashNode.Create(key) ;
                node.value := TMStr.Create ;
                ParentCommands.Add(node);
            end;
        end else begin
            node := Commands.Items[ key ];
        end;
        if node=nil then
        begin
            //key�����̂܂ܕԂ�
            Result := TMStr.Create ;
            TMStr(Result).value := key;
            Exit;
            //raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_NOT_FOUND,sp),[ key ]);
        end;
        //node ��n���āA�l�𓾂�
        Result := ExecuteCommand(node, sp);
    end;

    //�l���P����
    procedure getOne;
    var
        temp: Boolean;

        //�J�b�R�̂���ꍇ�F�J�b�R�̒��g�𓾂�
        procedure subKakko;
        var
            sp2: TSrcPos;
            s: string;
            n: TMHashNode;
            mv: TMVarCustom;
        begin
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp);
                s := GetMaruKakko(sp);
                if (Copy(s,1,1)='(')and(Copy(s,Length(s),1)=')') then //���Ӗ��ȁA((A))�̂悤�ȃJ�b�R�̕��S�����炷
                begin
                    s := Copy(s,2,Length(s)-2);
                end;
                n := Commands.Items[s];
                if (n=nil)or(n.nodeType=ntSysFunc)or(n.nodeType=ntUserFunc) then
                begin
                    sp2.SetTempSource(s);
                    Result := getArgAndCalc(sp2);
                end else
                begin
                    mv := n.value ;
                    Result := mv.clone ;
                end;
            finally
                sp2.Free ;
            end;
        end;

        //������̎擾
        procedure subString;
        var
            sp2: TSrcPos; //������̎擾�J�n�ʒu���o���Ă���
        begin
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp); //������̎擾�J�n�ʒu���R�s�[
                Result := TMStr.Create ;
                try
                    //��������擾
                    TMStr(Result).value := getString(sp.ptr, sp.lineNo);
                    //_debug(TMStr(Result).value);
                except
                    //�擾�Ɏ��s������G���[
                    raise;// EMml.Create(ErrMsg(MML_ERR_GET_STRING,sp2));
                end;
            finally
                sp2.Free ;
            end;
        end;
        //������̎擾
        procedure subString2;
        var
            sp2: TSrcPos; //������̎擾�J�n�ʒu���o���Ă���
        begin
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp); //������̎擾�J�n�ʒu���R�s�[
                Result := TMStr.Create ;
                try
                    //��������擾
                    if sp.ptr^ = '"' then Inc(sp.ptr);
                    TMStr(Result).value := GetTokenChars(['"'],sp.ptr);
                    //_debug(TMStr(Result).value);
                except
                    //�擾�Ɏ��s������G���[
                    raise;
                end;
            finally
                sp2.Free ;
            end;
        end;

    begin
        skipSpace(sp.ptr);//
        case sp.ptr^ of
        '$','0'..'9':
            begin
                Result := getNumberM(sp) ;
            end;
        '+','=':
            begin
                Inc(sp.ptr);
                //Result := getNumberM(sp) ;//=�̂��Ƃ������Ƃ͌���Ȃ�
                temp := CalcMode ;
                CalcMode := True;
                getOne;
                CalcMode := temp;
                Exit;
            end;
        '-':
            begin
                Inc(sp.ptr);
                Result := getArgAndCalc(sp);
                if Result.ClassType = TMInt then
                    TMInt(Result).value := -1 * Result.IntValue ;
            end;
        '!':
            begin
                Inc(sp.ptr);
                Result := TMInt.Create ;
                TMInt(Result).value := GetNoteLength(sp, False, CurTrack.Length.GetValue);
            end;
        '%':
            begin
                Inc(sp.ptr); // skip '%'
                Result := getArg(sp);
                if Result=nil then
                begin
                    raise Exception.Create('[%]�̒l������܂���B'); 
                end else
                if Result.ClassType = TMInt then
                    TMInt(Result).Flag := '%' ;
            end;
        'A'..'Z','a'..'z','_','#':
            begin
                if CalcMode=False then
                begin
                    Result := nil; Exit;
                end;
                VarOrCommand;
            end;
        '(':
            begin //�v�Z��
                subKakko;
            end;
        '{':
            begin //������
                subString;
            end;
        '"':
            begin //������Q
                subString2;
            end;
        else
            begin
                Result := nil;
            end;
        end;
    end;

    procedure CalcVar;
    var
        stack: TMStack;
        enzansi: string;
        ppp: PChar;
    begin
        stack := TMStack.Create ;
        try
        try
            //���߂Ɏ擾�����l��������
            stack.Add(Result);
            while sp.ptr^ in ENZANSI_CHAR do
            begin
                //���Z�q���擾
                ppp := sp.ptr;
                enzansi := sp.ptr^;
                if (sp.ptr^ in ENZANSI_NEXT_CHAR)and((sp.ptr+1)^ in ENZANSI_NEXT_CHAR) then
                begin
                    enzansi := enzansi + (sp.ptr+1)^;
                    Inc(sp.ptr);
                end;
                stack.Add( CreateEnzansi(enzansi) );
                Inc(sp.ptr);//inc enzansi
                //�����擾
                getOne;
                if Result = nil then
                begin
                    //��낪�v�Z�����Ǝv�������ǁA������悤�Ȃ̂ŁA
                    //�|�C���^�����ɖ߂�
                    sp.ptr := ppp;
                    stack.Delete(stack.Count -1);
                    ShowHint(Format('���̒���ɉ��Z�q`%s`���������̂ŁA�듮����N�������ꂪ����܂��B',[enzansi]),sp);
                    Break;
                end else begin
                    stack.Add(Result);
                end;
                skipSpaceCalc(sp.ptr);
            end;
            //�X�^�b�N�ɓ����v�Z�����v�Z����
            Result := CalcTMStack( stack );
        except
            on e: Exception do
                raise EParserError.Create(e.Message);
        end;
        finally
            stack.Free ;
        end;
    end;

begin
    debugPos := TSrcPos.Create ;
    try
    debugPos.Assign(sp);

    //�l�𓾂�
    try
        getOne;
    except
        on e: Exception do raise EMml.Create(ErrMsg(e.Message, sp));
    end;
    if CalcMode = False then Exit;
    if Result = nil then Exit;

    //�l�̌��Ɍv�Z��������Όv�Z����
    skipSpaceCalc(sp.ptr);
    if Result.ClassType = TMStr then //������Ōv�Z�ł���̂́A�{ = ! ����
    begin
        if not (sp.ptr^ in ['+','=','!']) then Exit;
    end else
    if not(sp.ptr^ in ENZANSI_CHAR) then Exit;//���Z�q���Ȃ�����A������

    //���ۂɌv�Z
    try
        CalcVar;
    except
        on e: Exception do
        begin
            raise EMml.Create(ErrMsg(MML_ERR_SYSTEM+e.Message, debugPos));
        end;
    end;

    finally
        debugpos.Free ;
    end;
end;
*)

function TMmlBase.scriptSizeOf(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    //sp2: TSrcPos;
    v: TMHashNode ;
begin
    Result := TMInt.Create ;

    s := Trim(GetMaruKakko(sp));

    v := Commands.Items[s];
    if (v=nil)or(v.value=nil) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG, sp),['SizeOf']);

    TMInt(Result).value := TMArray(v).Count;

    if v.value.ClassType = TMInt then
    begin
        TMInt(Result).value := SizeOf(Integer);
    end else if v.value.ClassType = TMStr then
    begin
        TMInt(Result).value := Length(v.value.StrValue);
    end else if v.value.ClassType = TMArray then
    begin
        TMInt(Result).value := TMArray(v.value).Count ;
    end;
end;

function TMmlBase.scriptStretch(var sp: TSrcPos): TMVarCustom;
var
    sp2, spt: TSrcPos;
    len, tempPtr, timeCount: Integer;
    src: string;
    tempRate: Extended; tempMute: Boolean;
begin
    //Stretch�R�}���h�@�F�@�t���[�Y�̒������X�g���b�`������B
    Result := nil;
    skipSpace(sp.ptr);
    sp2 := TSrcPos.Create ;
    spt := TSrcPos.Create ;
    try
        sp2.Assign(sp); spt.Assign(sp); // ���݂̃^�C���|�C���^��ۑ�
        src := GetNakaKakko(sp);        // �X�g���b�`�͈͂̎擾
        sp2.SetTempSource( src );
        len := GetNoteLength(sp, CurTrack.Stepmode, CurTrack.Length.GetValue); // �f�t�H���g�����𓾂�
        //�g���b�N���~���[�g�ɂ���
        tempPtr := CurTrack.TimePtr ;
        tempMute := CurTrack.Mute ;
        CurTrack.Mute := True;
        //�g���b�N�̒����𓾂邽�߂Ɏ��s
        try
            Compile(sp2);
        except
            raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,spt),['Stretch']);
        end;
        timeCount := CurTrack.TimePtr - tempPtr;
        tempRate := StretchRate ;
        StretchRate := len / timeCount;
        CurTrack.Mute := tempMute;
        //���ۂɎ��s
        sp2.SetTempSource( src );
        CurTrack.TimePtr := tempPtr;
        try
            Compile(sp2);
        except
            raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,spt),['Stretch']);
        end;
        CurTrack.TimePtr := tempPtr + len;
        StretchRate := tempRate;
    finally
        sp2.Free ;
        spt.Free ;
    end;
end;

procedure TMmlBase.Eval(src: string);
var
    sp: TSrcPos;
begin
    sp := TSrcPos.Create ;
    try
    try
        sp.fileNo := -1;
        sp.lineNo := 0;
        sp.SetTempSource(src);
        Compile(sp);
    except
      raise; //�G���[
    end;
    finally
        sp.Free ;
    end;
end;

function TMmlBase.scriptPlayFrom(var sp: TSrcPos): TMVarCustom;
var
    i: Integer;

    procedure subSysEx;
    begin
        i := GetIntValue(sp);
        SmfSong.PlayFrom.SysEx := (BOOL_TRUE = i);
    end;

    procedure subCC;
    begin
        i := GetIntValue(sp);
        SmfSong.PlayFrom.CC := (BOOL_TRUE = i);
    end;

    procedure subRPN;
    begin
        i := GetIntValue(sp);
        SmfSong.PlayFrom.RPN_NRPN := (BOOL_TRUE = i);
    end;

    procedure subWait;
    begin
        i := GetIntValue(sp);
        SmfSong.PlayFrom.WaitTime := i;
    end;

    //�I�v�V�����擾
    procedure subOption;
    var s: string;
    begin
        Inc(sp.ptr); // skip '.'
        s := getTokenWord(sp.ptr);
        if s='SysEx'    then subSysEx else
        if s='CtrlChg'  then subCC    else
        if s='RPN_NRPN' then subRPN   else
        if s='Wait'     then subWait  else
        raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp), [s]);
    end;

begin
    Result := nil;

    //���Ԏw�肩�H�I�v�V���������邩�H
    skipSpace(sp.ptr);
    if sp.ptr^ = '.' then begin subOption; Exit; end;

    //���Ԏw��
    SmfSong.PlayFrom.FromPos := GetTimeValue(sp);
end;

function TMmlBase.GetTimeValue(var sp: TSrcPos): Integer;
var
    s: string;
    sp2: TSrcPos;
    mes,beat,tick: Integer;
begin
    if sp.ptr^ = '(' then //�J�b�R��W�J
    begin // ���X�e�b�v or ���ߐ�
        s := GetMaruKakko(sp);

        sp2 := TSrcPos.Create ;
        try
            sp2.Assign(sp);
            sp2.SetTempSource(s);
            if Pos(':',s)>0 then
            begin //���߁F���F�X�e�b�v�@�w��
                mes := GetIntValueAndCalc(sp2);
                skipSpace(sp2.ptr);
                if sp2.ptr^ = ':' then Inc(sp2.ptr);
                beat := GetIntValueAndCalc(sp2);
                skipSpace(sp2.ptr);
                if sp2.ptr^ = ':' then Inc(sp2.ptr);
                tick := GetIntValueAndCalc(sp2);
                Result := TimeToStep(mes,beat,tick);
            end else
            begin//���X�e�b�v�w��
                Result := GetIntValueAndCalc(sp2);
            end;
        finally
            sp2.Free ;
        end;
    end else
    begin
        raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    end;
end;

function TMmlBase.GetIntValueAndCalc(var sp: TSrcPos): Integer;
var
    mv: TMVarCustom;
begin
    //if sp.ptr^ = '=' then Inc(sp.ptr);
    mv := getArgAndCalc(sp);
    if (mv=nil){or(mv.ClassType <> TMInt)} then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    Result := mv.IntValue ;
    mv.Free ;
end;

function TMmlBase.scriptPrintTime(var sp: TSrcPos): TMVarCustom;
var
    m: TMTime;
    i: TMVarCustom;
    trk: TTrackInfo ;
begin
    i := nil;
    if sp.ptr^ in ARG_CHAR then
    begin
        i := getArg(sp);
    end;
    if i=nil then trk := CurTrack else trk := SongInfo.GetTrack(i.IntValue);

    m := StepToTime(trk.TimePtr);
    PrintCon(Format('Track(%d);Time(%d:%d:%d);//=%d(PrintTime)',
    [trk.TrackNo,
    m.mes, m.beat, m.tick,
    trk.TimePtr]),sp);
    Result := nil;
end;

function TMmlBase.scriptPrintTrackStatus(var sp: TSrcPos): TMVarCustom;
var
    m: TMTime;
    i: TMVarCustom;
    trk: TTrackInfo ;
    sk: TSmfTrack;
    s: string;
    n: TNoteCC;
begin
    //�قƂ�ǁA�f�o�b�O�p�̖��߂����˂��`�`�`
    i := nil;
    if sp.ptr^ in ['=','('] then
    begin
        i := getArg(sp);
    end;
    if i=nil then
    begin
        trk := CurTrack;
        sk  := CurSmfTrack ;
    end else begin
        trk := SongInfo.GetTrack(i.IntValue);
        sk  := SmfSong.GetTrack(i.IntValue);
    end;
    m := StepToTime(trk.TimePtr);
    PrintCon(
        Format('Track(%d) Channel(%d) Voice(%d) Time(%d:%d:%d) Time=%d',
        [trk.TrackNo,
        trk.Channel+1,
        trk.Voice,
        m.mes, m.beat, m.tick,
        trk.TimePtr]),sp);
    s := '';
    s := s + 'l%' + IntToStr(trk.Length.GetValue);
    if trk.Stepmode then s := s + '(�X�e�b�v���[�h) ' else s := s + '(n���������[�h) ';
    if trk.Qgate.ArrayNote[0].StepMode then
    begin
        s := s + 'q%' + IntToStr(trk.Qgate.GetValue)+ '(�X�e�b�v���[�h) '
    end else
    begin
        s := s + 'q' + IntToStr(trk.Qgate.GetValue)+ '(���w�胂�[�h) ';
    end;

    s := s + 'v' + IntToStr(trk.Velocity.GetValue)+' ';
    s := s + 't' + IntToStr(trk.Timing.GetValue)+ ' ';
    s := s + 'o' + IntToStr(trk.Octave.GetValue)+ ' ';

    PrintCon(s, sp);

    s := '';
    n := SongInfo.CC[trk.Channel].GetCC(CC_NO_BEND_FULL);
    s := s + Format('Slur(%d,%d) ',[trk.TieMode, trk.TieValue]);
    s := s + Format('BR(%d) PitchBend(%d)',[SongInfo.BendRange[trk.Channel], n.LastValue]);

    PrintCon(s, sp);

    s := '';
    s := s + '�C�x���g��=' + IntToStr(sk.Count)+' ';
    if trk.Mute then s := s + 'TrackMute(on) ' else s := s + 'TrackMute(off) ';

    PrintCon(s, sp);

    Result := nil;
end;

function TMmlBase.scriptTrackMute(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
begin
    v := getArg(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'(on)��(off)���w��',sp),[sp.cmd]);
    if v.IntValue <> BOOL_FALSE then
    begin // true
        CurTrack.Mute := True;
    end else
    begin
        CurTrack.Mute := False;
    end;
    v.Free;
    Result := nil;
end;

function TMmlBase.scriptTrackSolo(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
    i,no: Integer;
begin
    v := getArgs(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'�g���b�N�ԍ����w�肵�Ă��������B',sp),[sp.cmd]);
    SmfSong.SoloOrMute := 1;
    for i:=0 to TMArray(v).Count -1 do
    begin
        no := TMArray(v).IntItems[i];
        SmfSong.GetTrack(no).MuteTrack := True;
    end;
    v.Free;
    Result := nil;
end;

function TMmlBase.scriptTrackMute2(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
    i,no: Integer;
begin
    v := getArgs(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'�g���b�N�ԍ����w�肵�Ă��������B',sp),[sp.cmd]);
    SmfSong.SoloOrMute := -1;
    for i:=0 to TMArray(v).Count -1 do
    begin
        no := TMArray(v).IntItems[i];
        SmfSong.GetTrack(no).MuteTrack := True;
    end;
    v.Free;
    Result := nil;
end;

function TMmlBase.scriptKeyFlag(var sp: TSrcPos): TMVarCustom;
var
    flag, c: Char;
    src: string;
    m: TMArray;
    i: Integer;

    procedure getFlag;
    var i: Integer;
    begin
        for i:=0 to 6 do SongInfo.KeyFlag[i] := 0; //�O�ŏ�����
        for i:=1 to Length(src) do
        begin
            c := src[i];
            if c in ['a'..'g'] then
                case flag of
                '+','#': SongInfo.KeyFlag[Ord(c) - Ord('a')] := 1;
                '-': SongInfo.KeyFlag[Ord(c) - Ord('a')] := -1;
                end;
        end;
    end;

    //���^���Ƃ��āA�^�O�𖄂ߍ���
    procedure MetaTag;
    var
        i,cnt: Integer;
        c: TSmfMeta;
    begin
        cnt := 0;
        for i:=0 to 6 do
        begin
            if SongInfo.KeyFlag[i] > 0 then Inc(cnt) else
            if SongInfo.KeyFlag[i] < 0 then Dec(cnt);
        end;

        c := TSmfMeta.Create ;
        c.Event := EVENT_META ;
        c.Time := CurTrack.TimePtr;
        c.MetaType := META_KEY_SIG ;
        SetLength(c.ByteArray, 2);
        if cnt < 0 then
        begin
            c.byteArray[0] := Byte(cnt); //bit7�ɁA1���Z�b�g
        end else
        begin
            c.byteArray[0] := Byte(cnt);
        end;
        c.byteArray[1] := 0;
        CurSmfTrack.Add(c); 
    end;

begin
    if sp.ptr^ in ['+','-','#'] then
    begin
        flag := sp.ptr^;
        Inc(sp.ptr);
        src := GetMaruKakko(sp);
        getFlag;
        MetaTag;
    end else
    if sp.ptr^ = '=' then
    begin
        Inc(sp.ptr);
        for i:=0 to 6 do SongInfo.KeyFlag[i] := 0; //�O�ŏ�����
        m := getArgs(sp);
        if m<>nil then
        begin
            for i:=0 to 6 do
                SongInfo.KeyFlag[i] := m.IntItems[i];
        end;
        MetaTag;
    end;

    Result := TMArray.Create ;
    for i:=0 to 6 do
        TMArray(Result).IntItems[i] := SongInfo.KeyFlag[i];
end;

function TMmlBase.scriptTimeKeyFlag(var sp: TSrcPos): TMVarCustom;
var
    kf: TTimeKeyFlag;
    sp2: TSrcPos;

    procedure getFromTime;
    begin
        skipSpace(sp2.ptr);
        if sp2.ptr^ = '(' then
        begin
            kf.timeFrom := GetTimeValue(sp2);
        end else
        begin
            kf.timeFrom := CurTrack.TimePtr ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;
    procedure getToTime;
    begin
        if sp2.ptr^ = '(' then
        begin
            kf.timeTo := GetTimeValue(sp2);
        end else
        begin
            kf.timeTo := -1 ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;
    procedure getKeyFlag;
    var m: TMArray; i:Integer;
    begin
        m := getArgs(sp2);
        if m<>nil then
        begin
            for i:=0 to 6 do
                kf.KeyFlag[i] := m.IntItems[i];
        end;
    end;

begin
    skipSpace(sp.ptr);
    if sp.ptr^ <> '(' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    sp2 := TSrcPos.Create ;
    try
        kf := TTimeKeyFlag.Create ;
        sp2.Assign(sp);
        sp2.SetTempSource(GetMaruKakko(sp) );
        //�l�̓ǂݎ��
        getFromTime;
        getToTime;
        getKeyFlag;
        SongInfo.TimeKeyFlag.Add(kf);
    finally
        sp2.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptTimeBase(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    i: Integer;
    t: TTrackInfo;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ['=','('] then
    begin
        v := GetIntValue(sp);
        SmfSong.TimeBase := v ;
        SongInfo.TimeBase := v;
        //(v = 48)or(v=96)or(v=192)or(v=384)or(v=480)or(v=960)then
        if (v<12)or(v>65535) then
        begin
            raise Emml.CreateFmt(ErrMsg(MML_ERR_RANGE_OVER+'48,96,192,480,960�Ȃǂ��悭�g���܂��B',sp),['TimeBase']);
        end;
        //SongInfo.ControllerShift := SongInfo.TimeBase div 24; // ver.1.xx�̂���
        //--------------
        // �g���b�N��l�̏����l������������
        for i := 0 to SongInfo.GetTrackCount - 1 do
        begin
          t := SongInfo.GetTrack(i);
          t.Length.ArrayNote[0].Value := SongInfo.TimeBase;
        end;
    end;
    Result := TMInt.Create ;
    TMInt(Result).value := SongInfo.TimeBase ;
end;

function TMmlBase.scriptTimeKey(var sp: TSrcPos): TMVarCustom;
var
    kf: TTimeKey;
    sp2: TSrcPos;

    procedure getFromTime;
    begin
        skipSpace(sp2.ptr);
        if sp2.ptr^ = '(' then
        begin
            kf.timeFrom := GetTimeValue(sp2);
        end else
        begin
            kf.timeFrom := CurTrack.TimePtr ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;
    procedure getToTime;
    begin
        if sp2.ptr^ = '(' then
        begin
            kf.timeTo := GetTimeValue(sp2);
        end else
        begin
            kf.timeTo := -1 ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;

    procedure getKey;
    begin
        kf.key := GetIntValueAndCalc(sp2);
    end;

begin
    skipSpace(sp.ptr);
    if sp.ptr^ <> '(' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    sp2 := TSrcPos.Create ;
    try
        kf := TTimeKey.Create ;
        sp2.Assign(sp);
        sp2.SetTempSource(GetMaruKakko(sp) );
        //�l�̓ǂݎ��
        getFromTime;
        getToTime;
        getKey;
        SongInfo.TimeKey.Add(kf);
    finally
        sp2.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptTieMode(var sp: TSrcPos): TMVarCustom;
var
    v: TMArray ;
begin
    v := getArgs(sp);
    if (v=nil)or(v.Count < 1) then raise EMml.CreateFmt( ErrMsg(MML_ERR_ARG,sp),['TieMode'] );
    CurTrack.TieMode := v.IntItems[0];
    if v.Count >= 2 then
    begin
        CurTrack.TieValue := v.IntItems[1];
    end;
    if v.Count >= 3 then //�x���h�����W�����w��
    begin
        SongInfo.BendRange[CurTrack.Channel] := v.IntItems[2];
    end;
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.TieMode ;
end;

procedure TMmlBase.WritePicthBend(time,value: Integer);
var
    v: Integer;
    ccc: TSmfPitchBend ;
    n: TNoteCC;
begin
    v := Max(-8192, Min(8191, value));

    //-------------------------------------------------------
    //BEND�̎w���ނɊ֌W�Ȃ��A�I�v�V�������I�t�ɃZ�b�g
    //-------------------------------------------------------
    //BEND-MIN
    n := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND);
    n.noteOnType := noteNormal ;
    n.Time := time ;
    n.No := CC_NO_BEND;
    n.LastValue := (v+8192) div 128;
    n.FIndex := 0;

    //BEND-FULL
    n := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND_FULL);
    n.noteOnType := noteNormal ;
    n.Time := time ;
    n.No := CC_NO_BEND_FULL;
    n.LastValue := v;
    n.FIndex := 0;
    //-------------------------------------------------------

    if (CurTrack.CCMute = False)and(CurTrack.CCNoMute[n.No] = False) then
    begin
      //�g���b�N�֖��ʂɏ������܂��R���g���[���`�F���W���g��������(ver.2.32�ȍ~)
      DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, CC_NO_BEND, time, False);

      //SMF�ɏ�������
      ccc := TSmfPitchBend.Create ;
      ccc.Time := time ;
      ccc.Event := EVENT_PITCH_BEND or CurTrack.Channel ;
      ccc.Value := v;
      CurSmfTrack.Add(ccc);
    end;
end;

procedure TMmlBase.WriteCCNoteOnTimeDirect(ccNo, time, fromValue, toValue,
  Len: Integer);
var
    ncc: TNoteCC;
    temp: Integer;
begin
    ncc := SongInfo.CC[CurTrack.Channel].GetCC(ccNo);
    ncc.Time := time ;
    ncc.noteOnType := noteOnTime ;
    ncc.No := ccNo ;
    ncc.reserve := TMArray.Create ;
    ncc.reserve.AddInt(fromValue);
    ncc.reserve.AddInt(toValue);
    ncc.reserve.AddInt(Len);
    temp := CurTrack.TimePtr ;
    CurTrack.TimePtr := time;

    WriteCCWave(ncc, CurSmfTrack, len, CurTrack.Channel);
    CurTrack.TimePtr := temp;
    ncc.noteOnType := noteNormal ;
end;

function TMmlBase.GetNowTimeKey(no: Integer): Integer;
var
  i: Integer; kf: TTimeKey; tp: Integer;
  lst: TList;
begin
    Result := MaxInt;
    tp := CurTrack.TimePtr ;

    if (no=0) then
    begin
      lst := SongInfo.TimeKey;
    end else
    if (no=1) then
    begin
      lst := SongInfo.TimeKey2;
    end else
      raise Exception.Create('GetNowTimeKey �� ����`�� TimeKey �ԍ�');

    for i := (lst.Count -1) downto 0 do
    begin
        kf := lst.Items[i];
        if kf.timeTo > 0 then
        begin
            if (kf.timeFrom <= tp)and(tp < kf.timeTo) then
            begin
                Result := kf.key ;
                Break;
            end;
        end else
        begin
            if (kf.timeFrom <= tp) then
            begin
                Result := kf.key;
                Break;
            end;
        end;
    end;
end;

function TMmlBase.scriptEnd(var sp: TSrcPos): TMVarCustom;
begin
    //FlagStopCompile := True;
    Inc(FuncBreak,1);
    sp.ptr^ := #0;
    sp.ptr^ := #0;
    Result := nil;
end;

function TMmlBase.scriptMsgBox(var sp: TSrcPos): TMVarCustom;
var
    v: TMArray;
    s: string;
begin
    v := getArgs(sp) ;
    try
        if v=nil then
        begin
            s := 'nil';
            MessageBox(0, PChar(s),'���b�Z�[�W',MB_OK);
        end else
        begin
            s := v.StrValue;
            MessageBox(0, PChar(s),'���b�Z�[�W',MB_OK);
        end;
    finally
        v.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptASC(var sp: TSrcPos): TMVarCustom;
var
    mv: TMVarCustom ;
    s: string;
    sp2: TSrcPos;
begin
    Result := TMInt.Create ;

    sp2 := TSrcPos.Create ;
    try
      sp2.SetTempSource(GetKakko(sp.ptr));
      mv := getArgAndCalc(sp2);
    finally
      sp2.Free ;
    end;

    if mv<>nil then
    begin
      s := mv.StrValue ;
    end;
    if s='' then
    begin
        TMInt(Result).value := 0; Exit;
    end;
    if s[1] in LeadBytes then
    begin
        TMInt(Result).value := (Ord(s[1]) shl 8)or Ord(s[2]);
    end else
    begin
        TMInt(Result).value := Ord(s[1]);
    end;
end;

function TMmlBase.scriptMID(var sp: TSrcPos): TMVarCustom;
var
    mv: TMArray ;
    s: string;
begin
    Result := TMStr.Create ;;
    mv := getArgsWithType(sp,'sii');
    if mv<>nil then s := mv.StrValue ;
    if s='' then
    begin
        TMStr(Result).value := ''; Exit;
    end;
    TMStr(Result).value := JCopy(
        mv.Items[0].StrValue,
        mv.Items[1].IntValue,
        mv.Items[2].IntValue);
end;

function TMmlBase.scriptReplace(var sp: TSrcPos): TMVarCustom;
var
    mv: TMArray ;
    s: string;
begin
    Result := TMStr.Create ;;
    mv := getArgsWithType(sp,'sssi');
    if mv<>nil then s := mv.StrValue ;
    if s='' then
    begin
        TMStr(Result).value := ''; Exit;
    end;
    TMStr(Result).value := JReplace(
        mv.Items[0].StrValue,
        mv.Items[1].StrValue,
        mv.Items[2].StrValue,
        (1=mv.Items[3].IntValue));
end;

function TMmlBase.scriptPlayTo(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    //���Ԏw��
    SmfSong.PlayFrom.ToPos := GetTimeValue(sp);
end;

function TMmlBase.GetNoteNo(var sp: TSrcPos; NoteName: Char; UseKeyShift: Boolean): Integer;
var
    nn: Integer;
    mv: TMVarCustom;
    f: Char;

    function UseTimeKeyFlag : Boolean;
    var i: Integer; kf: TTimeKeyFlag; tp: Integer;
    begin
        Result := False;
        tp := CurTrack.TimePtr ;
        for i := (SongInfo.TimeKeyFlag.Count -1) downto 0 do
        begin
            kf := SongInfo.TimeKeyFlag.Items[i];
            if kf.timeTo > 0 then
            begin
                if (kf.timeFrom <= tp)and(tp < kf.timeTo) then
                begin
                    Result := True;
                    Inc(nn, kf.KeyFlag[Ord(NoteName) - Ord('a')]);
                    Break;
                end;
            end else
            begin
                if (kf.timeFrom <= tp) then
                begin
                    Result := True;
                    Inc(nn, kf.KeyFlag[Ord(NoteName) - Ord('a')]);
                    Break;
                end;
            end;
        end;
    end;

    function UseTimeKey: Boolean;
    var i1,i2: Integer;
    begin
        i1 := GetNowTimeKey(0) ;
        i2 := GetNowTimeKey(1) ;
        if (i1=MaxInt)and(i2=MaxInt) then begin
            Result := False;
            Exit;
        end;
        Result := True;
        if(i1 <> MaxInt)then Inc(nn, i1);
        if(i2 <> MaxInt)then Inc(nn, i2);
    end;

begin
    if NoteName='n' then
    begin
        mv := getArg(sp);
        if (mv=nil)or(mv.ClassType <> TMInt) then
                raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
        nn := mv.IntValue ;
        if sp.ptr^=',' then Inc(sp.ptr);
    end else
    begin
        //NoteNo �̃e�[�u�����t���b�g�Ȓl�𓾂�
        nn := NOTE_NO_TABLE[ Ord(NoteName) - Ord('a') ];

        //����ɗՎ��L����K�p���邩�H
        if sp.ptr^ = '*' then
        begin
            f := '*';
            Inc(sp.ptr);
        end else begin
            f := #0;
        end;

        while True do
        begin
            if sp.ptr^ in ['#','+'] then
                Inc(nn)
            else if sp.ptr^ = '-' then
                Dec(nn)
            else
                Break;
            Inc(sp.ptr);
        end;

        //�L�[�t���O��K�p���邩�H
        if sp.ptr^ = '*' then//�t���b�g
        begin
            Inc(sp.ptr);
        end else
        begin //�L�[�t���O�̓K�p
            if f<>'*' then
            begin
                if UseTimeKeyFlag=False then//�^�C�������̃L�[�t���O(TimeKeyFlag)���g�����H
                begin//�g��Ȃ��Ƃ��́AKeyFlag�̒l��K�p����
                    Inc(nn, SongInfo.KeyFlag[Ord(NoteName)-Ord('a')]);
                end;
            end;
        end;

    end;

    if UseKeyShift and SongInfo.UseKeyShift then
    begin
        //�V�X�e���S�̂� Key
        UseTimeKey; //if UseTimeKey=False then // ... ver2.35 �ŏC�� ... �v�]�ɂ�� TimeKey �� Key ������L���ɂ���
        begin //�ʏ��Keyshift
            Inc(nn, SongInfo.Keyshift);
            //�g���b�N���Ƃ� Key
            Inc(nn, CurTrack.Key);
        end;
    end;

    Result := nn;
end;

function TMmlBase.scriptTrackKey(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ARG_CHAR then
    begin //���
        v :=GetIntValue(sp);
        CurTrack.Key := v;
    end;
    //�J�����g�g���b�N�̔ԍ���Ԃ�
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.Key ;
end;

function TMmlBase.scriptUseKeyShift(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ARG_CHAR then
    begin //���
        v :=GetIntValue(sp);
        SongInfo.UseKeyShift := (v<>0);
    end;
    //�J�����g�g���b�N�̔ԍ���Ԃ�
    Result := TMInt.Create ;
    TMInt(Result).value := Ord(SongInfo.UseKeyShift) ;
end;

function TMmlBase.scriptHEX(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom ;
    i: Integer;
    s: string;
begin
    v := getArg(sp);
    Result := TMStr.Create ;
    if v<>nil then
    begin
      if v.ClassType = TMArray then
      begin
        s := '';
        for i:=0 to TMArray(v).Count -1 do
        begin
          s := s + '$' + IntToHex( TMArray(v).IntItems[ i ], 2 ) + ', ';
        end;
        if s<>'' then s := Copy(s,1,Length(s)-2); //����', ' ���폜
        TMStr(Result).value := s;
      end else
      begin
        TMStr(Result).value := '$'+IntToHex(v.IntValue,2) ;
      end;
    end;
end;

function TMmlBase.scriptVarType(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom ;
begin
    v := getArg(sp);
    Result := TMStr.Create ;
    if v<>nil then
    begin
      if v.ClassType = TMArray then TMStr(Result).value := 'Array' else
      if v.ClassType = TMStr   then TMStr(Result).value := 'Str' else
      if v.ClassType = TMInt   then TMStr(Result).value := 'Int' else;
    end else
    begin
      TMStr(Result).value := '';
    end;
end;

function TMmlBase.funcQgate2(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
begin
    Result := nil;
    skipSpace(sp.ptr);
    v :=GetIntValue(sp);
    CurTrack.Q2 := v;
end;


function TMmlBase.scriptArgOrder(var sp: TSrcPos): TMVarCustom;
var
  s: string;
begin
  Result := nil;
  s := GetMaruKakko(sp);
  CurTrack.ArgOrder := s;
end;

function TMmlBase.scriptPos(var sp: TSrcPos): TMVarCustom;
var
    mv: TMArray ;
    s: string;
begin
    Result := TMInt.Create ;;
    mv := getArgsWithType(sp,'ss');
    if mv<>nil then s := mv.StrValue ;
    if s='' then
    begin
        TMInt(Result).value := 0; Exit;
    end;
    TMInt(Result).value := JPosEx(
        mv.Items[0].StrValue,
        mv.Items[1].StrValue,0);
end;

function TMmlBase.scriptTimeKey2(var sp: TSrcPos): TMVarCustom;
var
    kf: TTimeKey;
    sp2: TSrcPos;

    procedure getFromTime;
    begin
        skipSpace(sp2.ptr);
        if sp2.ptr^ = '(' then
        begin
            kf.timeFrom := GetTimeValue(sp2);
        end else
        begin
            kf.timeFrom := CurTrack.TimePtr ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;
    procedure getToTime;
    begin
        if sp2.ptr^ = '(' then
        begin
            kf.timeTo := GetTimeValue(sp2);
        end else
        begin
            kf.timeTo := -1 ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;

    procedure getKey;
    begin
        kf.key := GetIntValueAndCalc(sp2);
    end;

begin
    skipSpace(sp.ptr);
    if sp.ptr^ <> '(' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    sp2 := TSrcPos.Create ;
    try
        kf := TTimeKey.Create ;
        sp2.Assign(sp);
        sp2.SetTempSource(GetMaruKakko(sp) );
        //�l�̓ǂݎ��
        getFromTime;
        getToTime;
        getKey;
        SongInfo.TimeKey2.Add(kf);
    finally
        sp2.Free ;
    end;
    Result := nil;
end;


function TMmlBase.scriptTempoChange(var sp: TSrcPos): TMVarCustom;
//�e���|�𐄈ړI�ɕύX����
var
  ary: TMArray;
  i, cnt, t1, t2, len, tm, tstep,v: Integer;
  a: Extended;
begin
  Result := nil;

  ary := getArgs(sp);
  case ary.Count of
    1:
      begin
        t1  := SongInfo.Tempo ;
        t2  := ary.IntItems[0];
        len := SongInfo.TimeBase * 4;
      end;
    2:
      begin
        t1  := SongInfo.Tempo ;
        t2  := ary.IntItems[0];
        len := ary.IntItems[1];
      end;
    3:
      begin
        t1  := ary.IntItems[0];
        t2  := ary.IntItems[1];
        len := ary.IntItems[2];
      end;
    else
      raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
  end;

  tstep := Trunc(SongInfo.TimeBase / 4); // 16�������P�ʂŏ�������
  cnt := Trunc(len / tstep);
  a   := (t2 - t1) / cnt;

  tm := CurTrack.TimePtr ;
  for i := 0 to cnt - 2 do
  begin
    v := Trunc(i * a + t1);
    WriteTempo(i * tstep + tm, v);
  end;
  WriteTempo(tm + len, t2);
end;

procedure TMmlBase.WriteTempo(time, value: Integer);
var
  meta: TSmfTempo ;
begin
  SongInfo.Tempo := value;

  meta := TSmfTempo.Create ;
  meta.Time := time ;
  meta.SetTempo(SongInfo.Tempo);

  //�e���|�g���b�N�́A0 �Ɏ����Ă���ׂ�
  SmfSong.GetTrack(0).Add(meta);
end;

function TMmlBase.scriptExpressionChange(var sp: TSrcPos): TMVarCustom;
//EP�𐄈ړI�ɕύX����
begin
  Result := nil;
  cresc_sub(40,127, sp);
end;

function TMmlBase.scriptExpressionChangeDecresc(var sp: TSrcPos): TMVarCustom;
begin
  Result := nil;
  cresc_sub(127,40, sp);
end;

procedure TMmlBase.cresc_sub(def1,def2: Integer; var sp: TSrcPos);
//(len),(v1),(v2)
var
  ary: TMArray;
  i, cnt, t1, t2, len, tm, tstep,v,ov: Integer;
  a: Extended;
  cc: TNoteCC;
begin
  // EP���擾
  cc := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_EXPRESSION);
  if cc.LastValue < -1 then cc.LastValue := 127;

  // ���̒������擾
  if sp.ptr^ = '=' then Inc(sp.ptr);
  len := GetNoteLength(sp,CurTrack.Stepmode, -1);
  if len<=0 then len := SongInfo.TimeBase * 4; // �������ꂽ��A�S�����Ŏw��B

  // �������擾
  skipSpace(sp.ptr);
  if sp.ptr^ = ',' then
  begin
    Inc(sp.ptr);
    ary := getArgs(sp);
    try
      case ary.Count of
        0:
          begin
            t1 := def1 ;
            t2 := def2; //Cresc
          end;
        1:
          begin
            t1 := cc.LastValue ;
            t2 := ary.IntItems[0];
          end;
        else // cnt >= 2
          begin
            t1 := ary.IntItems[0];
            t2 := ary.IntItems[1];
          end;
      end;
    finally
      ary.Free ;
    end;
  end else
  begin
    t1 := def1 ;
    t2 := def2; //Cresc
  end;


  // ���ڒl���v�Z
  tstep := SongInfo.CCFreq; // �������ݕp�x���`�F�b�N
  cnt := Trunc(len / tstep);
  a   := (t2 - t1) / cnt;

  tm := CurTrack.TimePtr ;
  ov := -1;
  for i := 0 to cnt - 2 do
  begin
    v := Trunc(i * a + t1);
    v := Max(0, Min(127, v));
    if ov<> v then
      CurSmfTrack.WriteControlChange((i * tstep + tm), CurTrack.Channel, CC_NO_EXPRESSION, v);
    ov := v;
  end;
  // �Ō�ɒ��K���킹������
  CurSmfTrack.WriteControlChange((tm+len), CurTrack.Channel, CC_NO_EXPRESSION, t2);
  cc.LastValue := t2;
end;

procedure TMmlBase.DeleteCCAfterTime(track: TSmfTrack; ch, ccNo, time: Integer; CompleteDelete: Boolean);
var
  i: Integer;
  n: TSmfCustomNode; cc: TSmfControlChange;
  des_event: Byte;
begin
  // ���S�ɍ폜����킯�ł͂Ȃ��A���O��CC�ɑ΂��Ă��̋@�\��L���ɂ��邩�ǂ���
  if CompleteDelete then
  begin
    track.Sort ;
  end;

  // �폜����C�x���g�^�C�v�𒲂ׂ�
  if (ccNo = CC_NO_BEND)or(ccNo = CC_NO_BEND_FULL) then
  begin
    des_event := ch or EVENT_PITCH_BEND ;
  end else
  begin
    des_event := ch or EVENT_CONTROL_CHANGE ;
  end;

  // �폜�ΏۃC�x���g���A�g���b�N�̌�둤���猟�����A�폜���Ă���
  i := track.Count - 1;
  while i >= 0 do
  begin
    // �w��^�C���ȑO�Ȃ甲����
    n := track.Items[i];

    if n.Event = des_event then // CC���H
    begin
      if ccNo < 128 then
      begin
        cc := TSmfControlChange(n);
        if cc.No = ccNo then // �w��� CC No �� ?
        begin
          if n.Time < time then Break;
          track.Delete(i); // �폜
        end;
      end else
      begin // �x���h
        if n.Time < time then Break;
        track.Delete(i); // �폜
      end;
    end;
    Dec(i);
  end;

end;

function TMmlBase.scriptDeleteCC(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
begin
    v := GetIntValue(sp);
    if v<0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['DeleteCC']);
    DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, v, CurTrack.TimePtr, True); 
    Result := nil;
end;

function TMmlBase.scriptPosEx(var sp: TSrcPos): TMVarCustom;
var
    mv: TMArray ;
    s: string;
begin
    Result := TMInt.Create ;;
    mv := getArgsWithType(sp,'ssi');
    if mv<>nil then s := mv.StrValue ;
    if s='' then
    begin
        TMInt(Result).value := 0; Exit;
    end;
    TMInt(Result).value := JPosEx(
        mv.Items[0].StrValue,
        mv.Items[1].StrValue,
        mv.Items[2].IntValue);
end;

function TMmlBase.scriptCCMute(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
begin
    v := getArg(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'(on)��(off)���w��',sp),[sp.cmd]);
    if v.IntValue <> BOOL_FALSE then
    begin // true
        CurTrack.CCMute := True;
    end else
    begin
        CurTrack.CCMute := False;
    end;
    v.Free;
    Result := nil;
end;

function TMmlBase.scriptArraySortNum(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['SortNum']);
    if ary.Count = 0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Random']);

    ary.SortNum ;
    Result := ary.clone ;
end;

function TMmlBase.scriptArraySortStr(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['SortStr']);
    if ary.Count = 0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Random']);

    ary.SortStr ;
    Result := ary.clone ;
end;

function TMmlBase.scriptCCNoMute(var sp: TSrcPos): TMVarCustom;
var
    ary  : TMArray;
    v1,v2: TMVarCustom;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['CCNoMute']);
    if ary.Count < 2 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['CCNoMute']);

    v1 := ary.Items[0];
    v2 := ary.Items[1];

    if (v1.IntValue < 0)or(v1.IntValue > 127) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['CCNoMute']);

    CurTrack.CCNoMute[v1.IntValue] := (v2.IntValue <> 0);

    { debug:::
    if CurTrack.CCNoMute[v1.IntValue] <> (v2.IntValue <> 0) then
    begin
      MessageBox(0, 'err','err',MB_OK);
    end;
    }

    Result := nil;
end;

function TMmlBase.scriptSwitch(var sp: TSrcPos): TMVarCustom;
var
    SwitchStruct: TMStruct ;
    JoukenValue, CaseValue: TMVarCustom;
    token, caseJouken: string;
    casePos : TSrcPos;
begin
    //todo: switch
    Result := nil;
    SwitchStruct := TMStruct.Create(Structs, stSwitch);

    //�������𓾂�
    SwitchStruct.Jouken := getMaruKakko(sp);
    skipSpaceReturn(sp.ptr, sp.lineNo);

    //Switch�͈̔͊J�n�ʒu�𓾂�
    if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('Switch �̌�� "{" ������܂���B',sp));
    SwitchStruct.PosFrom.Assign(sp);
    Inc(SwitchStruct.PosFrom.ptr); // skip '{'

    //�͈͏I���ʒu�𓾂�
    skipKakko(sp.ptr, sp.lineNo, '{','}');
    SwitchStruct.PosTo.Assign(sp);

    //��������]��
    sp.lineNo := SwitchStruct.PosFrom.lineNo ;
    sp.ptr := PChar( SwitchStruct.Jouken );
    JoukenValue := getArgAndCalc(sp);

    //CASE ���E���ď����ɂ�������I��
    sp.Assign( SwitchStruct.PosFrom );
    while sp.ptr^ <> #0 do
    begin
      skipSpaceReturn(sp.ptr, sp.lineNo);

      // �����𓾂�
      token := UpperCase( getTokenMML(sp.ptr) );
      if token = 'DEFAULT' then
      begin
        // �������ɂ��̌�̕������s����
        if sp.ptr^ = '{' then Inc(sp.ptr);
        Break;
      end else
      if token = '}' then
      begin
        // ���ǉ������s���Ȃ������Ƃ�
        Inc(sp.ptr); // skip '}'
        SwitchStruct.Free;
        Exit; // *** 
      end else
      if token <> 'CASE' then raise EMml.Create(ErrMsg('SWITCH�̒��ł�CASE��DEFAULT���L�q���Ă��������B',sp));
      caseJouken := GetMaruKakko(sp);
      if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('CASE(����) �̌�� "{" ������܂���B',sp));

      casePos := TSrcPos.Create;
      try
        casePos.Assign(sp);
        casePos.ptr := sp.ptr;
        // CASE ��]��
        sp.lineNo := casePos.lineNo; sp.ptr := PChar( caseJouken );
        CaseValue := getArgAndCalc(sp);

        if CaseValue.StrValue = JoukenValue.StrValue then
        begin
          // CASE �̒������s
          sp.Assign(casePos);
          Inc(sp.ptr); // skip '{'
          Break;
        end else
        begin
          // ����CASE�֐i�߂�
          sp.Assign(casePos);
          skipKakko(sp.ptr, sp.lineNo, '{','}');
        end;

      finally
        casePos.Free;
      end;
    end;

    //�t���ւ�
    Structs := SwitchStruct;
    Commands := Structs.varHash ;
end;

function TMmlBase.scriptVersion(var sp: TSrcPos): TMVarCustom;
begin
  // �o�[�W�������̕\��
  Result := TMInt.Create;
  TMInt(Result).value := VER_NUMBER;
end;

function TMmlBase.scriptCHR(var sp: TSrcPos): TMVarCustom;
var
    mv: TMVarCustom ;
    i: Integer;
    sp2: TSrcPos;
begin
    Result := TMStr.Create ;

    sp2 := TSrcPos.Create ;
    try
      sp2.SetTempSource(GetKakko(sp.ptr));
      mv := getArgAndCalc(sp2);
    finally
      sp2.Free ;
    end;

    if mv<>nil then
    begin
      i := mv.IntValue ;
    end else
    begin
      raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['CHR']);
    end;

    if (i >= 0)and(i <= $7F) then
    begin
        TMStr(Result).value := CHR(i);
    end else
    begin
      // �����R�[�h����
      TMStr(Result).value := CHR((i shr 8)and $FF) + CHR(i and $FF);
    end;
end;

end.
