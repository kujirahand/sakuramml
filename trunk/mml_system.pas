unit mml_system;
{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���F�T�N���̂l�l�k���r�l�e�ɕϊ����郁�C�����j�b�g mml_base �̉������N���X
�@�@�@�@���C���́Amml_base �������Ȃ�Ȃ��悤�ɁA�Ȃ邾���A�������I�Ȃ��̂́A
�@�@�@�@������ɏ����悤�ɂ����B

���@���F

2002/06/03 15:13 ���^�쐬
-------------------------------------------------------------------------------}

interface
uses
  Windows,
  Classes,
  SysUtils,
  mml_const,
  mml_error,
  mml_var,
  mml_types,
  mml_token,
  smf_types;

type

  TMWaon = record
    Enable: Boolean;
    Option: TMArray; //�l�ȗ����̏����l
    Time: Integer;
  end;

  TMTime = record
    mes,
    beat,
    tick: Integer;
  end;

  TMmlOption = packed record //Option
    IncludeStdMsg,
    SutotonLog,
    EventLog,
    RythmLog,
    TimeLog,
    MetaLog,
    MldFormat: Boolean;
  end;

  TMmlRpnShift = record //RPN/NRPN��DATA_ENTRY������CC�Ȃ̂Ŕ��Ȃ��悤�ɒ���
    time: Integer;
    shift: Integer;
    ch: Integer;
  end;

  TMmlSystem = class
  private
  protected
    LineCount,
    LastLine: Integer;
    NowFunc: string;                    // ���ݎ��s���̊֐��̖��O�𓾂�
    FlagStopCompile: Boolean;           // �R���p�C���̒��~���w��
    SongInfo: TSongInfo;                // �ȏ��
    Commands,ParentCommands: TMVarHash; // �ϐ��֐�����
    Structs: TMStruct;                  // �X�N���v�g�̍\�����̂��߂̃X�R�[�v�Ǘ��N���X
    nowpos: TSrcPos;                    // ���݈ʒu��\��
    SmfSong: TSmfSong;                  // SMF�������ݗp
    CurSmfTrack: TSmfTrack;             // SMF�������ݗp�Ɍ��ݏ������ݗ\��̃g���b�N�̃|�C���^��ێ�
    WaonStack: TList;                   // Length=0 �̘a��
    TieStack: TList;                    // �^�C(&)���������Ƃ��A�X�^�b�N�ɐς�ł���
    FlagOctaveUpOnce: Integer;
    RecWaon: TMWaon;                    // 'ceg'�́A�a���R�}���h
    IncludedSource: TList;
    CalcMode: Boolean;                  // 3+5 �̂悤�Ȍv�Z���s�����ǂ���
    //TokenType: TTokenType;              // �g�[�N�̋�؂���ǂ̂悤�ɋ�؂邩���w�肷��
    RythmChar: array [0..127] of string;// Rythm���[�h�Œu���p�ɗp����
    StretchRate: Extended;              // Stretch rate
    RpnShift: TMmlRpnShift;             // RPN/NRPN�����^�C���ɗ���Ƃ��A�����I�ɃV�t�g����
    FuncResult: TMVarCustom ;           // �֐��̕Ԃ�l
    FuncBreak: Integer;
    function GetMaruKakko(var sp: TSrcPos): string;
    function GetNakaKakko(var sp: TSrcPos): string;
    procedure SetCurTrack(Index: Integer);
    function GetCurCCList: TCCList;
    function GetCurCCNote(no: Integer): TNoteCC;
    function SourceFileName(fno: Integer): string;
    procedure WriteEndOfTrack;
    function  ExecuteCommand(node: TMHashNode; var sp: TSrcPos): TMVarCustom; virtual; abstract;
  public
    //�ėp�I�Ȍv�Z���\�b�h
    function TimeToStep(mes,beat,tick:Integer):Integer;
    function StepToTime(step:Integer):TMTime;
    function NtoStep(n: Integer): Integer;
    function ErrMsg(msg: string; sp: TSrcPos): string;
    procedure ShowHint(msg: string; sp: TSrcPos);
    procedure PrintCon(msg: string; sp: TSrcPos);
    function GetVariable(var sp: TSrcPos): TMVarCustom;
  public
    CurTrack: TTrackInfo; //���ݕҏW���̃g���b�N�ւ̃|�C���^
    ValueSplitChar: set of Char;        // ���i�́A","
    IncludedFiles: TStringList;
    MmlOption: TMmlOption;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses StrUnit, smf_const;

{ TMmlSystem }

constructor TMmlSystem.Create;
var
    i:Integer;
begin
    Randomize;
    IncludedFiles := TStringList.Create ;
    IncludedSource := TList.Create ;
    nowpos := TSrcPos.Create ;
    LineCount := 0;
    FuncResult := nil;
    FuncBreak := 0;
    NowFunc := '';

    SongInfo := TSongInfo.Create ;
    SmfSong := TSmfSong.Create ; //
    WaonStack := TList.Create ;
    TieStack := TList.Create ;

    Structs := TMStruct.Create(nil, stNormal) ;
    Commands := Structs.varHash; //Commands �́AStructs �̒��Ŏ������������
    ParentCommands := Commands;

    FlagStopCompile := False;
    FlagOctaveUpOnce := 0;
    RecWaon.Enable := False;
    RecWaon.Option := nil;
    ValueSplitChar := [','];
    CalcMode := False;
    StretchRate := 1;
    OnProgress := nil;

    //�Ƃ肠�����ATrack(0)���쐬���ăA�T�C��
    SetCurTrack(0);

    RpnShift.ch := -1; //RPN���N���A

    for i:=0 to High(RythmChar) do //���Y�����[�h�������������
    begin
        RythmChar[i] := '';
    end;
    //���Y�����[�h������̏����l
    RythmChar[Ord('b')] := 'n36,';
    RythmChar[Ord('s')] := 'n38,';
    RythmChar[Ord('h')] := 'n42,';
    RythmChar[Ord('m')] := 'n46,';
    RythmChar[Ord('c')] := 'n49,';
    RythmChar[Ord('H')] := 'n50,';
    RythmChar[Ord('M')] := 'n47,';
    RythmChar[Ord('L')] := 'n43,';
    RythmChar[Ord('_')] := 'r';


    //MML OPTION �̏����l���Z�b�g
    with MmlOption do
    begin
        IncludeStdMsg := True;
        SutotonLog := False;
        EventLog := False;
        TimeLog := False;
        MetaLog := False;
    end;
end;

destructor TMmlSystem.Destroy;
var
    i: Integer;
    MStr: TMStr;
    n: TSmfNoteOn ;
begin
    IncludedFiles.Free ;
    Structs.Free ;
    SongInfo.Free ;
    SmfSong.Free ;
    nowpos.Free ;
    if FuncResult <> nil then FuncResult.Free ;

    //�a���X�^�b�N�̉��
    for i:=0 to WaonStack.Count -1 do
    begin
        n := WaonStack.Items[i]; if n<>nil then n.Free ;
    end;
    WaonStack.Free ;

    //�^�C�X�^�b�N�̉��
    for i:=0 to TieStack.Count -1 do
    begin
        n := TieStack.Items[i]; if n<>nil then n.Free ;
    end;
    TieStack.Free ;

    //�a���X�^�b�N�Q�̉��
    if RecWaon.Option <> nil then RecWaon.Option.Free ;

    //�\�[�X�t�@�C�����L�����Ă����̈�̉��
    for i:=0 to IncludedSource.Count -1 do //�\�[�X
    begin
        MStr := IncludedSource.Items[i];
        if MStr<>nil then MStr.Free ;
    end;
    IncludedSource.Free ;

    inherited;
end;

function TMmlSystem.ErrMsg(msg: string; sp: TSrcPos): string;
var
    fname, ss: string;
    len: Integer;
begin
    //nil���n���ꂽ�Ƃ�
    if sp=nil then begin
        Result := '[�G���[] �V�X�e��: ' + msg + #13#10;
        Exit;
    end;

    //�G���[�߂��̕������؂����ĕ\������
    len := StrLen(sp.ptr); if len > 32 then len := 32;
    if len > 0 then
    begin
      SetLength(ss,len);
      StrLCopy(PChar(ss), sp.ptr, len);
      ss := string(PChar(ss));
      ss := JReplace(ss,#13#10,'(���s)',True);
      ss := JReplace(ss,'%','%%',True);
    end else
    begin
      ss := '';
    end;
    //
    fname := SourceFileName(sp.fileNo);
    //
    if (NowFunc <> '') then msg := msg + '(�֐�:"'+NowFunc+'")';
    if (sp.cmd <> '')and(sp.cmd <> NowFunc) then ss := '(����:"' + sp.cmd + '") "' + ss else ss := '"' + ss;

    if nowpos.fileNo = sp.fileNo then
    begin
        if nowpos.lineNo <> sp.lineNo then
        begin
            Result := '[�G���[] '+ fname +
                '('+IntToStr(sp.lineNo)+'),('+IntToStr(nowpos.lineNo)+'): ' + msg + ss+'"�̋߂�' + #13#10;
        end else
        begin
            Result := '[�G���[] '+ fname +
                '('+IntToStr(sp.lineNo)+'): ' + msg + ss+'"�̋߂�' + #13#10;
        end;
    end else
    begin
        Result := '[�G���[] '+ fname +
            '('+IntToStr(sp.lineNo)+'),'+ SourceFileName(nowpos.fileNo)+
            '('+IntToStr(nowpos.lineNo)+'): ' + msg + ss+'"�̋߂�' +#13#10;
    end;

    FlagStopCompile := True;
end;

function TMmlSystem.GetCurCCList: TCCList;
begin
    Result := SongInfo.CC[CurTrack.Channel];
end;

function TMmlSystem.GetCurCCNote(no: Integer): TNoteCC;
var
    cc: TCCList;
begin
    cc := GetCurCCList;
    Result := cc.FindCC(no);
    if Result=nil then
    begin
        Result := TNoteCC.Create ;
        cc.Add(Result); 
    end;
end;

function TMmlSystem.GetMaruKakko(var sp: TSrcPos): string;
begin
    try
        Result := mml_token.GetMaruKakko(sp.ptr, sp.lineNo);
    except
        on e: Exception do
            raise EMml.Create(ErrMsg(e.Message, sp));
    end;
end;

function TMmlSystem.GetNakaKakko(var sp: TSrcPos): string;
begin
    try
        Result := mml_token.GetNakaKakko(sp.ptr, sp.lineNo);
    except
        on e: Exception do
            raise EMml.Create(ErrMsg(e.Message, sp));
    end;
end;

function TMmlSystem.NtoStep(n: Integer): Integer;
// sakura ver.1.xx ���� 4/4�ŌŒ肵���l��Ԃ�
{var
    base : Integer;
begin
    with SongInfo do
    begin
        base := Trunc( timebase * (4/TimeSigHa) );
        if n<>0 then
            Result := Trunc((base*TimeSigKo) / n)
        else
            Result := 0;
    end;
end;
}
begin
    with SongInfo do
    begin
        if n<>0 then
            Result := Trunc( (TimeBase * 4) / n )
        else
            Result := 0;
    end;
end;


procedure TMmlSystem.PrintCon(msg: string; sp: TSrcPos);
begin
    CompilerMessage := CompilerMessage + '[�\��] '+
        IncludedFiles.Strings[sp.fileNo] + '('+IntToStr(sp.lineNo)+'): ' + msg + #13#10;
end;

procedure TMmlSystem.SetCurTrack(Index: Integer);
begin
    CurTrack := SongInfo.GetTrack(Index, SongInfo.TimeBase);
    CurSmfTrack := SmfSong.GetTrack(Index);
end;

procedure TMmlSystem.ShowHint(msg: string; sp: TSrcPos);
var
    txt: string;
begin
    if (sp.cmd <> '')and(sp.cmd <> NowFunc) then msg := msg + '(����:"' + sp.cmd + '")';
    if NowFunc <> '' then msg := msg + '(�֐�:"'+NowFunc+'")';
    if sp=nil then
    begin
        txt := '[�q���g] (-1)' + msg;
    end else
    begin
        txt := '[�q���g] '+ IncludedFiles.Strings[sp.fileNo] + '('+IntToStr(sp.lineNo)+'): ' + msg + #13#10;
    end;

    if JPosEx(txt, CompilerMessage,1) = 0 then
    begin
        CompilerMessage := CompilerMessage + txt;
    end;
end;

function TMmlSystem.SourceFileName(fno: Integer): string;
begin
    if fno<0 then
    begin
        Result := '�V�X�e��';
    end else
    begin
        try
        Result := IncludedFiles.Strings[fno];
        except
        Result := '�V�X�e��';
        end;
    end;
end;

function TMmlSystem.StepToTime(step: Integer): TMTime;
var
    base: Integer;
    mes_step: Integer;
begin
    with SongInfo do
    begin
        base := Trunc( timebase * (4/TimeSigHa) );
        //���ߐ������߂�
        mes_step := base*TimeSigKo;

        Result.mes := step div mes_step; //���ߐ����擾
        step       := step mod mes_step; //���ߐ��̎c��𓾂�
        Result.beat := step div base;    //�������擾
        Result.tick := step mod base;    //

        //1���琔������̂́A�P�𑫂�
        Inc(Result.mes);
        Inc(Result.beat);

        Result.mes := Result.mes - SongInfo.MeasureShift ; // ����ɂ��A�V�X�e���ݒ���P���ߖڈȑO�ɂ����Ă��邱�Ƃ��ł���
    end;
end;

function TMmlSystem.TimeToStep(mes, beat, tick: Integer): Integer;
var
    base: Integer;
begin
    mes := mes + SongInfo.MeasureShift ; // ����ɂ��A�V�X�e���ݒ���P���ߖڈȑO�ɂ����Ă��邱�Ƃ��ł���


    // 4/4 �Ȃ�΁A
    // (mes-1)*(timebase*4) + (beat-1)*timebase + tick

    // 6/8 �Ȃ�΁A
    // base = timebase div 2
    // (mes-1)*(base*6) + (beat-1)*base + tick

    //����āA�ėp�I�Ȍv�Z���́A
    with SongInfo do
    begin
        base := Trunc( timebase * (4/TimeSigHa) );
        Result := (mes-1)*(base*TimeSigKo) + (beat-1)*base + tick;
    end;
    //�� mes-1 , beat-1 �̗��R�́A�����́A���ʁA�P���琔����̂ŁB
end;


procedure TMmlSystem.WriteEndOfTrack;
var
    i: Integer;
    p: TTrackInfo;
    ps: TSmfTrack ;

begin
    for i:=0 to SongInfo.Count -1 do
    begin
        p := SongInfo.Items[ i ];
        if p=nil then Continue;
        ps := SmfSong.GetTrack(i);
        ps.LastTime := p.TimePtr ;
    end;
    //LastTime�ɁA�Ō�̃|�C���^�����Ă��邾��
    //���ۂ́Asmf_types �́ASmfSong.SaveToFile�̒��ŏ���
end;


function TMmlSystem.GetVariable(var sp: TSrcPos): TMVarCustom;
var
    key: string;
    node: TMHashNode;
begin
    //�J���}�܂ł𓾂�
    //key := getTokenMML(sp.ptr);
    key := mml_token.getTokenWord(sp.ptr);

    if Copy(key,1,1)='#' then //��O�I�ȕ�����A"#�ϐ�"�̏���
    begin
        node := Commands.Items[ key ];
        if node=nil then begin //�Ȃ���΍��
            node := TMhashNode.Create(key) ;
            node.value := TMStr.Create ;
            ParentCommands.Add(node);
        end;
    end else
    begin
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

end.
