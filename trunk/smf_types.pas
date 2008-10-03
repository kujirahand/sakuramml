unit smf_types;

interface

uses
  Windows,
  SysUtils,
  Classes,
  smf_const,
  Math;

type
  //�l�h�c�h���̃X�[�p�[�N���X
  TSmfCustomNode = class
  public
    Time: Integer; //�C�x���g����
    Event: Byte; //����8bit ���A�`�����l���ԍ���\��
    //
    function CH: Integer; //�`�����l���ԍ��𓾂�
    function EventType: Integer; //�C�x���g�̎�ށF$F0�ȏ�͂��̂܂܁A�ȉ��́A����8bit ���}�X�N���ĕԂ�
    //
    function WriteStream(var stream: TStream): Integer; virtual; abstract; //�������񂾃o�C�g����Ԃ�
    procedure DivideEvent(var track: TList; shift: Integer); virtual; //NoteOn�ȂǁA�P�̃C�x���g�ŕ����̖��߂�\���C�x���g�𕪊�����
  end;

  //�r�����牉�t����ꍇ�̏������ݎw��
  TSmfPlayFrom = class
  public
    FromPos,
    ToPos: Integer; //�������݊J�n�^�C��(���w��́A�|�P)
    SysEx,
    CC,
    RPN_NRPN: Boolean;
    WaitTime: Integer; //�G�t�F�N�g�������݂̂��߂̑҂�����(48)
    constructor Create;
  end;

  //�l�h�c�h�f�[�^��ێ����Ă����g���b�N�E�N���X
  TSmfTrack = class(TList)
  public
    MuteTrack: Boolean;
    LastTime: Integer;//EndOfTrack�̏������݂̂���
    FTimeBase: Integer;
    constructor Create;
    destructor Destroy;override;
    procedure Delete(Index: Integer);
    procedure Clear; override;
    procedure DivideEvent(shift: Integer);//NoteOn �ȂǁA�P�̃C�x���g�ŕ����̖��߂�\���C�x���g�𕪊�����
    procedure Sort; //time �Ń\�[�g����
    procedure CheckNoteOn;//���d�m�[�g�I���̉���E�s�v�ȃC�x���g�̃g����
    procedure ExecutePlayFrom(playFrom: TSmfPlayFrom);
    procedure MergeTrack(tk: TSmfTrack);//�\�[�g���Ȃ�
    //���̃N���X���ȒP�Ɏg�����߂̕֋X�I�ȃN���X
    function WriteNoteOn(FTime: Integer; FChannel, FNoteNo, FVelocity: Byte; FNoteLen: Integer): TSmfCustomNode;
    function WriteProgramChange(FTime: Integer; FChannel, FProgNo, FMsb, FLsb: Byte): TSmfCustomNode;
    function WriteControlChange(FTime: Integer; FChannel, FCCNo, FValue: Byte): TSmfCustomNode;
    function WritePitchBend(FTime: Integer; FChannel, FValue: Byte): TSmfCustomNode;//-8192~0~8191
  end;

  //�������f�[�^�������ݗp
  TMFi2_SongHeader = packed record
    ID: array [1..4] of Char;
    FileLen: DWORD;
    HeaderLen: WORD;
    DataFormat: Byte;
    DataType: Byte;
    TrackCount: Byte; // (1:4�a��/2:8�a��/4:16�a��)
  end;
  TMFi2_InfoHeader = packed record
    ID: array [1..4] of Char;
    Len: WORD;
  end;

  //�g���b�N���Ǘ�����A�\���O�N���X
  TSmfSong = class(TList)
  public
    TimeBase: Integer;
    CCShift: Integer; //�C�x���g�̑��M������邽�߂̃V�t�g�������ɂ��邩
    Format: Integer; //���͖���`
    PlayFrom: TSmfPlayFrom;
    DebugTime: Boolean;
    TrackName: string;
    SoloOrMute: Integer;
    constructor Create;
    destructor Destroy;override;
    procedure Delete(Index: Integer);
    procedure Clear; override;
    procedure DivideEvent(shift: Integer);//NoteOn �ȂǁA�P�̃C�x���g�ŕ����̖��߂�\���C�x���g�𕪊�����
    procedure CreateTrack(Index: Integer);
    function GetTrack(Index: Integer): TSmfTrack;
    procedure Sort;
    procedure CheckNoteOn;
    procedure ExecutePlayFrom;
    procedure SaveToFile(FName: string);//MIDI�`���ŏ����o��
    //procedure SaveToMld(Fname: string);
    procedure LoadFromFile(FName: string);
    procedure MergeTracks;//<= merge and track0
  end;

  //�ȉ�SMF�C�x���g���N���X�Ƃ��Ē�`���Ă���
  TSmfNoteOn = class(TSmfCustomNode)
  public
    NoteNo: Byte;
    Velocity: Byte;
    Len: Integer;//Len>0�̎��ANoteOff���܂�(���ʁANoteOn,NoteOff�͕ʁX�̃C�x���g�ł���)
    OptionValue: Integer; //���ړI�ɗ��p����I�v�V�����̒l�B�i�^�C�̒l�Ȃǁj
    PackedNoteOff: Boolean;
    function WriteStream(var stream: TStream): Integer; override;
    procedure DivideEvent(var track: TList; shift: Integer); override;
  end;

  TSmfNoteOff = class(TSmfCustomNode)
    NoteNo,
    Velocity: Byte;
  public
    function WriteStream(var stream: TStream): Integer; override;
  end;

  TSmfProgramChange = class(TSmfCustomNode)
  public
    msb,lsb, {�����A�T�C������ĂȂ���Ԃ́A-1}
    value: Integer;
    procedure Assgin(c: TSmfProgramChange);
    function WriteStream(var stream: TStream): Integer; override;
    procedure DivideEvent(var track: TList; shift: Integer); override;
  end;

  TSmfControlChange = class(TSmfCustomNode)
  public
    No,Value: Byte;
    function WriteStream(var stream: TStream): Integer; override;
  end;

  TSmfKeyPressure = class(TSmfCustomNode)
  public
    NoteNo, velocity: Byte;
    function WriteStream(var stream: TStream): Integer; override;
  end;

  TSmfChannelPressure = class(TSmfCustomNode)
  public
    value: Byte;
    function WriteStream(var stream: TStream): Integer; override;
  end;

  TSmfPitchBend = class(TSmfCustomNode)
  public
    value: Integer;//-8192~0~8191 //���ۂɂ�,0~8192~16383
    function WriteStream(var stream: TStream): Integer; override;
  end;

  TRpnType = (typeRPN, typeNRPN, typeNone);
  TSmfRPN = class(TSmfCustomNode)
  public
    rpnType: TRpnType; // �C�x���g������ɂ́AtypeNone��
    msb,lsb,data: Byte;
    byteCount: Byte; // 2��3�o�C�g�B2�̏ꍇ�́ADataEntry���܂܂Ȃ�
    function WriteStream(var stream: TStream): Integer; override;
    procedure DivideEvent(var track: TList; shift: Integer); override;
  end;

  TSmfRPNList = class(TList)
  public
    function Add(rpn: TSmfRPN): Integer;
    function Find(msb,lsb,ch: Integer): TSmfRPN;
  end;

  TArrayOfByte = array of Byte;
  TSmfDirect = class(TSmfCustomNode) // Smf�C�x���g���_�C���N�g�ɏ������ޏꍇ
  public
    byteArray: TArrayOfByte;
    constructor Create;
    function WriteStream(var stream: TStream): Integer; override;
  end;

  TSmfSysEx = class(TSmfDirect)
  public
    function WriteStream(var stream: TStream): Integer; override;
  end;

  TSmfMeta = class(TSmfDirect)
  public
    MetaType: Byte;
    function WriteStream(var stream: TStream): Integer; override;
  end;

  TSmfTempo = class(TSmfMeta)
  public
    Tempo: Integer;
    procedure SetTempo(tp: Integer);
  end;

  TMergeList = class(TList)
  public
    procedure Sort(Compare: TListSortCompare);
  end;

//�r�b�O�G���f�B�A���ƁA���g���G���f�B�A�������ւ���
function SwapEndian4(x: DWORD): DWORD; overload;
function SwapEndian2(x: WORD): WORD; overload;

implementation

uses mml_error, mml_var;

function SwapEndian4(x: DWORD): DWORD;
begin
    Result := ( x shl 24 ) or ( ( x and $ff00 ) shl 8 ) or
            ( ( x shr 8 ) and $ff00 ) or ( x shr 24 );
end;

function SwapEndian2(x: WORD): WORD;
begin
    Result := ( (x and $FF) shl 8) or (x shr 8);
end;

{*** ���������Ŏg�����[�J���Ȋ֐� ********}
function write3byte(var stream: TStream; b1, b2, b3: Byte): Integer;
var
    b: array [0..2] of Byte;
begin
    b[0] := b1;
    b[1] := b2;
    b[2] := b3;
    Result := stream.Write(b, 3);
end;
function write2byte(var stream: TStream; b1, b2: Byte): Integer;
var
    b: array [0..1] of Byte;
begin
    b[0] := b1;
    b[1] := b2;
    Result := stream.Write(b, 2);
end;

{�ϒ����l�\�����A�X�g���[���ɏ�������}
function writeVarLen(var stream: TStream; v: DWORD): Integer;
var
    b: DWORD;
    cnt: Integer;
begin
    b := v and $7f;
    cnt := 1;
    v := v shr 7;
    while v > 0 do
    begin
        b := b shl 8;
        b := b or ( v and $7f) or $80;
        v := v shr 7;
        Inc(cnt);
    end;
    Result := stream.Write(b, cnt);
end;


{*****************************************}



// FDelphi �T���v�����A�ׂ�����́A�}�[�W�\�[�g�N���X
procedure TMergeList.Sort(Compare: TListSortCompare);
var Tmp:PPointerList;
  procedure MergeSort(First,Last: Integer);
  var
    I,J,K,P,Mid:Integer;
  begin
    if First < Last then begin
      Mid :=(First + Last) div 2;
      MergeSort(First,Mid);
      MergeSort(Mid+1,Last);
      P := Mid - First + 1;
      System.Move(List^[First],Tmp^[0], P * SizeOf(Pointer) );
      i := Mid + 1; J := 0 ; k := first;
      while (i <= Last) and (J < P) do
        if Compare(Tmp^[J],List^[I]) > 0
          then begin
            List^[k] := List^[i];
            //�㔼���珑���߂��B
            Inc(k);Inc(i);
          end else begin
            List^[k] := Tmp^[j];
            //��Ɨ̈悩�珑���߂��B�����A�Ԉ���Ă܂����Bm(__)m
            Inc(k);Inc(J);
          end;
      while j < P do begin
        List^[K] := Tmp^[j];
        inc(k);inc(j);
      end;
    end;
  end;
begin
  GetMem(Tmp,(count div 2 + 1) * SizeOf(Pointer));
  try
    MergeSort(0,Count-1);
  finally
    FreeMem(Tmp);
  end;
end;


{ TSmfCustomNode }

function TSmfCustomNode.CH: Integer;
begin
    Result := Event and $0F;//�`�����l���ԍ��𓾂�
end;

procedure TSmfCustomNode.DivideEvent(var track: TList; shift: Integer);
begin
    // �������ׂ��C�x���g���Ȃ���΁A�������Ȃ�
end;

function TSmfCustomNode.EventType: Integer;
begin
    if Event >= $F0 then
        Result := Event
    else
        Result := Event and $F0;
end;

{ TSmfTrack }

procedure TSmfTrack.CheckNoteOn;
var
    i,j: Integer;
    c,b: TSmfCustomNode ;
    fromPtr, toPtr: Integer;
begin
    i := 0;
    while i < Count do
    begin
        c := Items[i];
        if c=nil then begin Inc(i); Continue; end;

        if i>=1 then
        begin
            b := Items[i-1];
            if (c.Time = b.Time)and(c.Event = b.Event) then //�����A���^�C���A���C�x���g�A�����e������Ȃ�A�g����
            begin
                if c.ClassType = TSmfControlChange then
                begin
                    if (TSmfControlChange(c).No = TSmfControlChange(b).No)and(TSmfControlChange(c).Value = TSmfControlChange(b).Value) then
                    begin
                        //Delete(i-1); Continue;
                        b.Event := 0;
                        Inc(i); Continue;
                    end;
                end;
            end;
        end;

        if c.ClassType = TSmfNoteOn then
        for j := i-1 downto 0 do //�f�[�^��������Ƀ`�F�b�N
        begin
            b := Items[j];
            if b=nil then Continue;
            //���d�m�[�g���̉\�������邩�H
            if (b.Time + 768) < c.Time then Break; //���܂�ɂ�Time������Ă���ꍇ�̃`�F�b�N�͖��Ӗ�
            if b.ClassType <> TSmfNoteOn then Continue;

            if (TSmfNoteOn(b).NoteNo <> TSmfNoteOn(c).NoteNo) then Continue;

            //����Ă��邩�`�F�b�N
            fromPtr := b.Time ;
            toPtr   := b.Time + TSmfNoteOn(b).Len;
            if (fromPtr <= c.Time) and (c.Time <= toPtr) then
            begin //�B�B�B����Ă�E�E�E
                TSmfNoteOn(b).Len := c.Time - fromPtr - 1;
                if TSmfNoteOn(b).Len <= 0 then
                begin
                    b.Event := 0;
                    TSmfNoteOn(b).PackedNoteOff := False;
                end;
            end;
        end;
        Inc(i);
    end;
end;

procedure TSmfTrack.Clear;
var
    i: Integer;
    p: TSmfCustomNode;
begin
    for i:=0 to Count-1 do
    begin
        p := Items[i];
        if p<>nil then p.Free ;
    end;
    inherited Clear;
end;

constructor TSmfTrack.Create;
begin
    MuteTrack := False;
end;

procedure TSmfTrack.Delete(Index: Integer);
var
    p: TSmfCustomNode;
begin
    p := Items[Index];
    if p<>nil then p.Free ;
    inherited Delete(Index);
end;

destructor TSmfTrack.Destroy;
begin
    Clear;
    inherited;
end;

procedure TSmfTrack.DivideEvent(shift: Integer);
var
    i: Integer;
    p: TSmfCustomNode;
begin
    for i:=0 to Count-1 do
    begin
        p := Items[i];
        if p<> nil then
            p.DivideEvent(TList(Self),  shift);
    end;
end;


function SmfTimeSort(Item1, Item2: Pointer): Integer;
begin
    Result := TSmfCustomNode(Item1).Time - TSmfCustomNode(Item2).Time;
end;

{�w��^�C���|�C���^�ȑO�̃m�[�g���폜���A���̕��^�C���|�C���^������}
procedure TSmfTrack.ExecutePlayFrom(playFrom: TSmfPlayFrom);
var
    fromPos: Integer;
    n: TSmfCustomNode ;
    cc: array [0..127] of Integer;
    ch: Integer;
    pb: Integer;
    PreEffectI: Integer;
    Tempo: Integer;
    rpnList: TSmfRpnList;
    nrpnList: TSmfRpnList;
    ProgChange: TSmfProgramChange ;

    procedure TrimSysEx;
    var i: Integer;
    begin
        i := 0;
        while i < Count do
        begin
            n := Items[i]; if n=nil then begin Inc(i); Continue; end;
            if n.Time >= fromPos then Break;
            if n.ClassType = TSmfSysEx then begin Self.Delete(i); Continue; end;
            Inc(i);
        end;
    end;

    procedure CheckCC;
    var
        i, rpn_msb, rpn_lsb, nrpn_msb, nrpn_lsb: Integer;
        rpn_nrpn: TRpnType ;

        function CheckRpnNrpn: Boolean;
        var r: TSmfRPN ;
        begin
            Result := False;
            if playFrom.RPN_NRPN = False then Exit;
            case TSmfControlChange(n).No of
            CC_RPN_MSB:
                begin
                    rpn_msb := TSmfControlChange(n).Value ;
                    //rpn_lsb := -1;
                    rpn_nrpn := typeRPN;
                    Result := True;
                end;
            CC_RPN_LSB:
                begin
                    rpn_lsb := TSmfControlChange(n).Value ;
                    Result := True;
                end;
            CC_NRPN_MSB:
                begin
                    nrpn_msb := TSmfControlChange(n).Value ;
                    //nrpn_lsb := -1;
                    rpn_nrpn := typeNRPN;
                    Result := True;
                end;
            CC_NRPN_LSB:
                begin
                    nrpn_lsb := TSmfControlChange(n).Value ;
                    Result := True;
                end;
            CC_DATA_ENTRY:
                begin
                    r := TSmfRPN.Create ;
                    r.Time := n.Time ;
                    r.Event := n.Event ;
                    r.rpnType := rpn_nrpn;
                    r.byteCount := 3;
                    if rpn_nrpn = typeRPN then
                    begin
                        r.msb := rpn_msb;
                        r.lsb := rpn_lsb;
                        r.data := TSmfControlChange(n).Value ;
                        rpnList.Add(r);
                    end else
                    if rpn_nrpn = typeNRPN then
                    begin
                        r.msb := nrpn_msb;
                        r.lsb := nrpn_lsb;
                        r.data := TSmfControlChange(n).Value ;
                        nrpnList.Add(r);
                    end;
                    Result := True;
                end;
            end;
        end;

    begin
        //CC�̏�����(�ȗ����̂��߁A�g���b�N�ɂ́A�`�����l�����P�����A�T�C������Ă��Ȃ����̂Ƃ��čl����)
        for i:=0 to 127 do cc[i] := -1; //CC���ݒ�
        pb := 0;                        //PB���ݒ�

        rpn_msb := -1;
        rpn_lsb := -1;
        nrpn_msb := -1;
        nrpn_lsb := -1;
        rpn_nrpn := typeNone;

        //CC/PB�̒l���`�F�b�N
        for i:=0 to Count-1 do
        begin
            n := Items[i]; if n=nil then Continue;
            if n.Time >= fromPos then Break;
            if n.ClassType = TSmfPitchBend then
            begin
                pb := TSmfPitchBend(n).value ;
                ch := TSmfPitchBend(n).CH ;
            end else
            if n.ClassType = TSmfTempo then
            begin
                Tempo := TSmfTempo(n).Tempo ;
            end else
            if n.ClassType = TSmfProgramChange then
            begin
                ProgChange.Assgin(n as TSmfProgramChange) ;
            end else
            if n.ClassType = TSmfControlChange then
            begin
                if CheckRpnNrpn=False then
                begin
                    cc[ TSmfControlChange(n).No ] := TSmfControlChange(n).Value ; //���[���ƃ`�F�b�N
                end;
                ch := TSmfControlChange(n).CH ;
            end else
            if n.ClassType = TSmfRpn then
            begin
                //���ɃC�x���g�́A���f����Ă���̂ŁA���Ӗ�
            end else;
        end;
    end;

    procedure TrimBeforeEvent;
    var i: Integer;
    begin
        // PlayTo �̐ݒ�
        if playFrom.ToPos > 0 then
        begin
            for i := Count-1 downto 0 do
            begin
                n := Items[i];
                if n=nil then Continue;
                if n.Time >= PlayFrom.ToPos then
                begin
                    n.Event := 0;
                end else Break;
            end;
            Self.LastTime := playFrom.ToPos - playFrom.FromPos;
        end;
        // PlayFrom �̃^�C���߂�
        i := 0;
        while i < Count do
        begin
            n := Items[i]; if n=nil then begin Inc(i); Continue; end;
            if n.Time < fromPos then
            begin //�C�x���g���Ԉ���
                if n.ClassType = TSmfSysEx then
                begin
                    if playFrom.SysEx then
                    begin//�Ԉ����Ȃ��ŁA�^�C�������ړ�
                        n.Time := PreEffectI;
                        Inc(PreEffectI, 1); //�K���ɊԊu
                        Inc(i);
                        Continue;
                    end;
                end else
                if n.ClassType = TSmfMeta then
                begin
                    {if TSmfMeta(n).MetaType = META_PORT then
                    begin
                        n.Time := PreEffectI;
                        Inc(PreEffectI, 1);
                        Inc(i);
                        Continue;
                    end;}
                    //�e���|�ȊO�Ȃ�A�O�ɃC�x���g���Z�b�g
                    if TSmfMeta(n).MetaType <> META_TEMPO then
                    begin
                        n.Time := 0;
                        Inc(i);
                        Continue;
                    end;
                end;
                //�Ԉ���
                //Delete(i);
                n.Event := 0;
                Inc(i);
            end else
            begin // �^�C����߂�
                n.Time := n.Time - fromPos + PlayFrom.WaitTime;
                Inc(i);
            end;
        end;
    end;

    procedure WriteCC;
    var i: Integer; c: TSmfControlChange ; r:TSmfRpn; p: TSmfPitchBend ;
    begin
        if playFrom.SysEx then Inc(PreEffectI, FTimeBase div 4);
        for i := 0 to 127 do
        begin
            if cc[i] < 0 then Continue;
            c := TSmfControlChange.Create ;
            c.Event := EVENT_CONTROL_CHANGE + ch ;
            c.No := i;
            c.Value := cc[i];
            c.Time := PreEffectI;
            Inc(PreEffectI, 1);
            Self.Add(c);
        end;
        if pb <> 0 then // �s�b�`�x���h��ǉ� 2004/04/06
        begin
            p := TSmfPitchBend.Create ;
            p.Event := EVENT_PITCH_BEND + ch;
            p.value := pb;
            p.Time := PreEffectI;
            Inc(PreEffectI, 1);
            Self.Add(p);
        end;

        for i:= 0 to RpnList.Count -1 do
        begin
            r := RpnList.Items[i];
            if r.rpnType = typeRpn then
            begin
                r.Time := PreEffectI;
                Self.Add(r);
                Inc(PreEffectI, 3);
            end;
        end;
        for i:= 0 to NrpnList.Count -1 do
        begin
            r := NrpnList.Items[i];
            if r.rpnType = typeNRpn then
            begin
                r.Time := PreEffectI;
                Self.Add(r);
                Inc(PreEffectI, 3);
            end;
        end;
        if (RpnList.Count > 0)or(NrpnList.Count > 0) then
        begin
            Self.DivideEvent(1);
        end;
        if ProgChange.value >= 0 then
        begin
            ProgChange.Time := PreEffectI;
            Self.Add(ProgChange); 
            Inc(PreEffectI,3);
        end;
    end;

    procedure WriteTempo;
    var c: TSmfTempo;
    begin
        if Tempo > 0 then
        begin
            c := TSmfTempo.Create ;
            c.Event := EVENT_META ;
            c.SetTempo(Tempo);
            c.Time := 0;
            Add(c);
        end;
    end;

begin
  //todo: PlayFrom
  ch := 0; //�K���ɏ�����
  fromPos := playFrom.FromPos ; //�J�n�ʒu
  PreEffectI := 0;
  Tempo := -1;
  ProgChange := nil;
  rpnList  := TSmfRPNList.Create ;
  nrpnList := TSmfRPNList.Create ;
  ProgChange := TSmfProgramChange.Create ;
  ProgChange.value := -1;
  try

    //�R���g���[���`�F���W&�s�b�`�x���h�̒l���`�F�b�N
    if playFrom.FromPos > 0 then CheckCC;
    //WriteComTime('PlayFrom CC&Bend �̒l�`�F�b�N����:'+IntToStr(Count)+')');

    //�S�Ẵ^�C���|�C���^��߂��A���̎��_�ŁA�O�ȑO�̃C�x���g�͊Ԉ���
    TrimBeforeEvent;
    //WriteComTime('PlayFrom �w��ȑO�̃C�x���g�̍폜��������'+IntToStr(Count)+')');

    //WaitTime�ȑO�ɃR���g���[���`�F���W�Ȃǂ���������
    if playFrom.FromPos > 0 then WriteCC;
    //Tempo������������
    if playFrom.FromPos > 0 then WriteTempo;
    //WriteComTime('PlayFrom �t�����̏������ݏ���'+IntToStr(Count)+')');

  finally
    rpnList.Free;
    nrpnList.Free ;
    if ProgChange.value < 0 then
        ProgChange.Free ;
  end;
end;

procedure TSmfTrack.MergeTrack(tk: TSmfTrack);
var
    i: Integer;
    c: TSmfCustomNode ;
begin
    if tk=nil then Exit;
    for i:=0 to tk.Count -1 do
    begin
        c := tk.Items[i];
        Add(c);
        tk.Items[i] := nil;
    end;
end;

procedure TSmfTrack.Sort;
begin
    // �C�x���g�̏��Ԃ��΂�΂�ɂȂ�Ȃ��悤�Ƀ}�[�W�\�[�g
    TMergeList(Self).Sort(SmfTimeSort);
end;

function TSmfTrack.WriteControlChange(FTime: Integer; FChannel, FCCNo,
  FValue: Byte): TSmfCustomNode;
begin
    Result := TSmfControlChange.Create ;
    with TSmfControlChange(Result) do
    begin
        Time  := FTime;
        Event := EVENT_CONTROL_CHANGE or FChannel;
        No    := FCCNo;
        value := FValue;
    end;
    Self.Add(Result);
end;

function TSmfTrack.WriteNoteOn(FTime: Integer; FChannel, FNoteNo, FVelocity: Byte; FNoteLen: Integer): TSmfCustomNode;
begin
    with TSmfNoteOn(Result) do
    begin
        Result := TSmfNoteOn.Create ;
        Event  := EVENT_NOTE_ON or FChannel;
        Time   := FTime;
        NoteNo := FNoteNo ;
        Velocity := FVelocity;
        Len    := FNoteLen;
        PackedNoteOff := True;
    end;
    Self.Add(Result);
end;

function TSmfTrack.WritePitchBend(FTime: Integer; FChannel, FValue: Byte): TSmfCustomNode;
begin
    Result := TSmfPitchBend.Create ;
    with TSmfPitchBend(Result) do
    begin
        Event := EVENT_PITCH_BEND or FChannel;
        Time  := FTime;
        value := FValue;
    end;
    Self.Add(Result); 
end;

function TSmfTrack.WriteProgramChange(FTime: Integer; FChannel, FProgNo, FMsb,
  FLsb: Byte): TSmfCustomNode;
begin
    Result := TSmfProgramChange.Create ;
    with TSmfProgramChange(Result) do
    begin
        Event := EVENT_PROGRAM_CHANGE or FChannel;
        Time  := FTime;
        value := FProgNo;
        msb   := FMsb ;
        lsb   := FLsb ;
    end;
    Self.Add(Result); 
end;

{ TSmfSong }

procedure TSmfSong.CheckNoteOn;
var
    i: Integer;
    p: TSmfTrack;
begin
    for i:=0 to Count-1 do
    begin
        p := Items[i];
        if p<>nil then p.CheckNoteOn ;
    end;
end;

procedure TSmfSong.Clear;
var
    i: Integer;
    p: TSmfTrack ;
begin
    For i:=0 to Count-1 do
    begin
        p := Items[i];
        if p<>nil then p.Free ;
    end;
    inherited Clear;
end;

constructor TSmfSong.Create;
begin
    TimeBase := 96;
    CCShift := 1;
    Format := 1;
    PlayFrom := TSmfPlayFrom.Create ;
    SoloOrMute := 0;
end;

procedure TSmfSong.CreateTrack(Index: Integer);
begin
    if Index >= Count then
    begin
        Count := Index+1; // 0 �ŏ���������Ă�悤���B
    end;
    if Items[Index] = nil then
    begin
        Items[Index] := TSmfTrack.Create;
    end;
end;

procedure TSmfSong.Delete(Index: Integer);
var
    p: TSmfTrack ;
begin
    p := Items[Index];
    if p<>nil then p.Free ;
    inherited Delete(Index);
end;

destructor TSmfSong.Destroy;
begin
    Clear;
    PlayFrom.Free ;
    inherited;
end;

procedure TSmfSong.DivideEvent(shift: Integer);
var
    i: Integer;
    p: TSmfTrack;
begin
    for i := 0 to Count-1 do
    begin
        p := Items[i];
        if p<>nil then
            p.DivideEvent(shift) ;
    end;
end;

procedure TSmfSong.ExecutePlayFrom;
var
    i: Integer;
    p: TSmfTrack;
begin
    for i := 0 to Count-1 do
    begin
        p := Items[i];
        if p<>nil then
        begin
            if DebugTime then WriteComTime('Track'+IntToStr(i)); 
            p.FTimeBase := TimeBase;
            p.ExecutePlayFrom(PlayFrom) ;
        end;
    end;
    Sort;
end;

function TSmfSong.GetTrack(Index: Integer): TSmfTrack;
begin
    CreateTrack(Index); //�Ȃ���΍��
    Result := Items[Index];
end;

procedure TSmfSong.LoadFromFile(FName: string);
begin
    //todo:LoadSMF
end;

procedure TSmfSong.MergeTracks;
var
    trk, t: TSmfTrack;
    i: Integer;
begin
    trk := TSmfTrack.Create ;
    try
        for i:=0 to Count-1 do
        begin
            t := Items[i];
            trk.MergeTrack(t);
        end;
        Self.Clear ;
        Add(trk);
    finally
    //self�ɂȂ邩��
    end;
end;

procedure TSmfSong.SaveToFile(FName: string);
var
    i: Integer;
    f: TMemoryStream;

    procedure writeWord(w: WORD);
    begin
        w := SwapEndian2(w);
        f.Write(w, 2);
    end;
    procedure writeDWord(dw: DWORD);
    begin
        dw := SwapEndian4(dw);
        f.Write(dw, 4);
    end;
{
    function writeTime(v: DWORD): Integer;
    var
        b: DWORD;
        cnt: Integer;
    begin
        b := v and $7f;
        cnt := 1;
        v := v shr 7;
        while v > 0 do
        begin
            b := b shl 8;
            b := b or ( v and $7f) or $80;
            v := v shr 7;
            Inc(cnt);
        end;
        Result := f.Write(b, cnt);
    end;
}

    procedure WriteMThdHeader;
    begin
        f.Seek(0, soFromBeginning);
        // write head and headLen
        f.Write('MThd'#0#0#0#6,8);
        writeWord(format);    // smf-format
        writeWord(Count);     // track count
        writeWord(TimeBase);  // timebase
    end;

    procedure WriteMTrk(track: TSmfTrack);
    var
        idx_datalen: Int64;
        dataLen: Integer;
        i, oldTime:Integer;

        function writeEvent(e: TSmfCustomNode): Integer;
        var v: Integer;
        begin
            if (e=nil)or(e.Event=0)or(e.ClassType = TSmfRPN) then begin Result := 0; Exit; end; //�������܂Ȃ��n�C�x���g

            //write Time
            v := Max(0, e.Time - oldTime);
            Result := writeVarLen(TStream(f), v);
            oldTime := Max(0, e.Time) ;
            //write event
            Result := Result + e.WriteStream(TStream(f));
        end;

    begin
        if track = nil then Exit;
        if track.Count = 0 then Exit;

        //�w�b�_�̏�������
        f.Write('MTrk',4);
        //�f�[�^�̒����ʒu���L�^�����ۏ�������Ō��Ȃ����Ƃɂ́A�f�[�^�̒�����������Ȃ�����
        idx_datalen := f.Position ;
        f.Write(#0#0#0#0,4);//dummy

        //�C�x���g����������
        dataLen := 0;
        oldTime := 0;
        for i:=0 to track.Count -1 do
        begin
            dataLen := dataLen + writeEvent(track.Items[i]);
        end;
        //EndOfTrack�̏�������
        if PlayFrom.FromPos > 0 then
        begin
            track.LastTime := track.LastTime - PlayFrom.FromPos ;
        end;
        oldTime := track.LastTime - oldTime;
        if oldTime<0 then oldTime := 0;
        dataLen := dataLen + writeVarLen(TStream(f), DWORD(oldTime));
        dataLen := dataLen + f.Write(META_END_OF_TRACK, 3);

        //�f�[�^�̒��������������̂ŁA�ēx��������������
        f.Position := idx_datalen;
        writeDWord(dataLen);
        f.Seek(0, soFromEnd);//�|�C���^���X�g���[���̍Ō��
    end;

    procedure subSolo;//Solo/Mute�R�}���h�p
    var
        i: Integer;
        trk: TSmfTrack;
    begin
        //Mute�R�}���h
        if SoloOrMute<>0 then
        if SoloOrMute<0 then
        begin
            for i:=1 to Count-1 do
            begin
                trk := Items[i];
                if trk=nil then Continue;
                if trk.MuteTrack then trk.Clear ;
            end;
        end else begin
            //Solo�R�}���h
            for i:=1 to Count-1 do
            begin
                trk := Items[i];
                if trk=nil then Continue;
                if trk.MuteTrack=False then trk.Clear ;
            end;
        end;

        //nil�g���b�N���폜����
        i := 0;
        while i < Count do
        begin
            trk := Items[i];
            if (trk=nil)or(trk.Count = 0) then
            begin
                Self.Delete(i);
            end else
                Inc(i);
        end;
    end;

    function CheckProgress(per: Integer; str: string): Boolean;
    var flg: Boolean;
    begin
      Result := False;
      if Assigned(OnProgress) then
      begin
        OnProgress(per,100,'Sort',@flg);
        Result := flg;
      end;
    end;

begin
    if CheckProgress(50,'Solo/Mute�R�}���h�̏���') then Exit;
    subSolo;                // Solo/Mute�R�}���h���g�������H

    if CheckProgress(55,'���ԏ��ɕ��ёւ�') then Exit;
    Sort;                   // Time���ɕ��ёւ���

    if CheckProgress(60,'���d�m�[�g�I���̌��o') then Exit;
    CheckNoteOn;            // ���d�m�[�g�I���̌��o

    if DebugTime then WriteComTime('���d�m�[�g�I���̃`�F�b�N����');
    DivideEvent(CCShift);   // NoteOn�ȂǁA�����̃C�x���g���܂Ƃ܂��ēo�^����Ă���̂��ANoteOn,NoteOff�ɕ�������

    if CheckProgress(60,'���ԏ��ɕ��ёւ� Part2') then Exit;
    Sort;                   // ���߂�Time���ɕ��ёւ�

    if Count=0 then Exit;
    if DebugTime then WriteComTime('SMF�����o����������');

    //�r�����牉�t�H
    if (PlayFrom.FromPos > 0)or(PlayFrom.ToPos > 0) then
    begin
        if CheckProgress(70,'PlayFrom�ɂ�鉉�t�g��������') then Exit;
        ExecutePlayFrom; //���t�J�n�ʒu�����炷
        if DebugTime then WriteComTime('PlayFrom�ɂ�鉉�t�̃g������������');
    end;

    //�����A���悢��SMF�̍쐬�E�E�E�E
    f := TMemoryStream.Create ;
    try
        //�\���O�w�b�_�̏�������
        WriteMThdHeader;

        //�g���b�N���ɏ�������
        for i:=0 to Count-1 do
        begin
            if CheckProgress(70+Trunc(20 * Count / (i+1)),'�g���b�N'+IntToStr(i+1)+' �̏�������') then Exit;
            WriteMTrk(Items[i]);
        end;

        //���ۂɃt�@�C���֏�������
        if CheckProgress(90,'�t�@�C���֏o��') then Exit;
        f.SaveToFile(FName);
    finally
        f.Free ;
    end;
    if CheckProgress(100,'����') then Exit;
end;

(*
procedure TSmfSong.SaveToMld(Fname: string);
var
    f: TMemoryStream;
    i: Integer;
    ch_no: array [0..15] of Integer;//smf_ch <-> mld_tr
    track_count:Byte;
    SongHeader: TMFi2_SongHeader ;
    baseR: Extended;
    trk: TSmfTrack;
    LastTime: Integer;

    procedure writeWord(w: WORD);
    begin
        w := SwapEndian2(w);
        f.Write(w, 2);
    end;
    procedure writeDWord(dw: DWORD);
    begin
        dw := SwapEndian4(dw);
        f.Write(dw, 4);
    end;

    function getTrackCount: Byte;
    var
        cc, i,j:Integer;
        c: TSmfCustomNode ;
        EventCount: array [0..15] of Integer;
    begin
        //�e�`�����l���ɂ���C�x���g�����m�F����
        for i:=0 to 15 do
        begin
            EventCount[i] := 0;
            ch_no[i] := -1;
        end;

        for j:=0 to trk.Count -1 do
        begin
            c := trk.Items[j];
            if c<>nil then
            case c.EventType of
            EVENT_NOTE_ON:
                begin
                    Inc(EventCount[c.CH]);
                    if LastTime < (c.Time+TSmfNoteOn(c).Len) then LastTime := c.Time+TSmfNoteOn(c).Len ;
                end;
            EVENT_META:
                begin
                    Inc(EventCount[c.CH]);
                    if LastTime < c.Time then LastTime := c.Time ;
                end;
            end;
        end;

        cc := 0;
        for i:=0 to 15 do
        begin
            if EventCount[i]>0 then
            begin
                ch_no[i] := cc;
                Inc(cc);
            end;
        end;
        case cc of
        0..4:  Result := 1; //4�a��
        5..8:  Result := 2; //8
        9..16: Result := 4; //16
        else   Result := 4; //16
        end;
        track_count := Result * 4; //�L�����Ă���
    end;

    procedure WriteSongHeader;
    begin
        with SongHeader do
        begin
            ID := 'melo'; // mld(Melo for iMode) �� ID
            FileLen := 0; // dummy
            HeaderLen := 0; //dummy
            DataFormat := 2; // MFi2
            DataType := 1; //Song
            TrackCount := getTrackCount ;
        end;
        f.Write(SongHeader, SizeOf(SongHeader));
    end;

    procedure WriteInfoHeader;
    var pp: Integer;

        procedure writeMeta(id: string; text: string);
        var
            h:TMFi2_InfoHeader;
            i: Integer;
        begin
            for i:=1 to 4 do h.ID[i] := id[i];
            h.Len := SwapEndian2(Length(text));
            f.Write(h, SizeOf(h)); //header
            f.Write(text[1], Length(text));//���ۂ̓��e���L��
        end;

    begin
        pp := f.Position ;
        //titl
        if TrackName='' then TrackName := ' ';
        writeMeta('titl', TrackName);
        //protect
        writeMeta('sorc', #0);//�_�E�����[�h�E���쌠���Ȃ�
        //version
        writeMeta('vers', '0200');
        //note(velocity��L���ɂ���)
        writeMeta('note', #0#1);
        //HeaderLen�̌v�Z
        SongHeader.HeaderLen := SwapEndian2( f.Position - pp + 3 );
    end;

    procedure WriteTrackData(trkNo: Integer);
    const
        EOT =       #$FF#$DF#0;
        START_POS = #0#$FF#$D0#0;
        END_POS =   #$FF#$D0#1;
    var
        cnt, i, lastLen, no: Integer;
        tp: Integer;
        c: TSmfCustomNode ;
        header_pos: Integer;

        function sub_writeTime(v: Integer): Integer;
        const NOP = #$FF#$DE#0;
        begin
            v := Trunc( baseR * v ); //�^�C���x�[�X48�ɍ��킹��

            Result := 0;
            while v > 255 do
            begin
                f.Write(#255+NOP,4); //NOP�Ńf���^�^�C��
                Dec(v,255);
                Inc(Result);
            end;
            f.Write(v,1);
            Inc(Result);
        end;

        procedure writeTime;
        var
            time: Integer;
        begin
            time := c.Time - tp;
            cnt := cnt + sub_writeTime(time); tp := c.Time ;
        end;

        function writeNote: Integer;
        var
            n,len: Integer; v:Byte;
        begin
            //check
            Result := 0;
            n := TSmfNoteOn(c).NoteNo - 24+3;
            if n<0 then Exit;
            if n>75 then Exit;//�͈͊O�̃m�[�g�Ȃ甲����
            len := Min(255,Trunc(TSmfNoteOn(c).Len * baseR));
            //(1)time
            writeTime;
            //(2)velocity
            v := Trunc(TSmfNoteOn(c).Velocity * 0.5);
            v := v shl 2;
            //(3)note
            {if c.CH = 9 then
            begin
                n := TSmfNoteOn(c).NoteNo + 10;
            end else begin}
                Dec(n,24);
            //end;
            case n of
            -24..-13: begin Inc(n,24); v := v or 2; end;
            -12..-1 : begin Inc(n,12); v := v or 3; end;
              0.. 62: begin end;
             63.. 75: begin Dec(n,12); v := v or 1; end;
            end;
            //(4)track
            n := n or ((no mod 4)shl 6); //note�ԍ��ɁA�g���b�N�ԍ�������
            //(5)write
            f.Write(n,1);//note
            f.Write(len,1);//len
            lastLen := Min(255,Trunc(TSmfNoteOn(c).Len));
            f.Write(v,1);//velocity & octave
            Inc(Result,3);
        end;

        function writeVoice: Integer;
        const VC1=#$FF#$E0; VC2=#$FF#$E1;
        var vc: Integer; v1,v2: Byte;
        begin
            Result := 0;
            vc := TSmfProgramChange(c).value ;
            v1 := Byte(vc and $3F);
            v2 := Byte( $2 or (vc and $40)) shr 2;
            v1 := v1 or ((no mod 4)shl 6); //�g���b�N�ԍ�������
            v2 := v2 or ((no mod 4)shl 6); //�g���b�N�ԍ�������
            writeTime ;
            f.Write(VC2,2); f.Write (v2,1); Inc(Result,3); //$E1���珑���Ȃ��ƃG���[�ɂȂ�@�킪����
            writeTime ;
            f.Write(VC1,2); f.Write (v1,1); Inc(Result,3);
        end;

        function writeTempo: Integer;
        var t: Integer; b: array [0..2] of Byte;
        begin
            t := TSmfTempo(c).Tempo ;
            writeTime;
            b[0] := $FF;
            b[1] := $C3;
            b[2] := Byte(t);
            f.Write(b, 3);
            Result := 3;
        end;

        function writeMainVolume: Integer;
        const MV= #$FF#$E2;
        var v, n: Byte;
        begin
            Result := 0;
            n := TSmfControlChange(c).No ;
            if n <> 7 then Exit;
            v := TSmfControlChange(c).value ;
            v := v div 2;//range 0~64
            v := v or ((no mod 4)shl 6); //�g���b�N�ԍ�������
            writeTime ;
            f.Write(MV,2); //ID
            f.Write (v,1); //value
            Result := 3;
        end;

{
�����F�����Y���̃o���N�؂�ւ�(FFBA)
00 FFBA n1

n1(7,6,5,4,3,2,1,0bit)
5�`6bit �g���b�N�w��(0�`3)
3�`4bit ���[�J���`�����l���w��(0�`3)
0bit    ���Y���w��(0=���F�A1=���Y��)

�h�R�������au��C404S,C406S,C408P�̂ݎg�p��
�����f�B�ƃh�����̓r���؂�ւ����L��(D503i)
}
        function SetRythmMode: Integer;
        var b: array[ 0..3] of Byte;
        begin
            b[0] := 0;   // time
            b[1] := $FF; // �g���X�e�[�^�X
            b[2] := $BA; // Drums
            b[3] := 1;   // is Drum
            b[3] := b[3] or ((ch_no[9]mod 4) shl 4); //�`�����l���ԍ�����������
            b[3] := b[3] or ((ch_no[9]div 4) shl 6); //�g���b�N�ԍ�����������
            f.Write(b,4);
            Result := 4;
        end;

    begin

        if SongHeader.TrackCount <= trkNo then Exit;

        f.Write('trac',4);//ID
        header_pos := f.Position ;
        f.Write(#0#0#0#0,4);//track-len
        lastLen := 0;

        cnt := 0;
        if trkNo = 0 then //�擪�g���b�N�ł��鏈��
        begin
            //if ch_no[9] >= 0 then cnt := cnt + SetRythmMode; //���Y��
            cnt := cnt + f.Write(#0#$FF#$B0#$7F,4); //�}�X�^�[�{�����[��
            cnt := cnt + f.Write(START_POS,4);
        end;

        //---
        tp := 0;
        for i:=0 to trk.Count -1 do
        begin
            c := trk.Items[i];
            if c=nil then Continue;

            no := ch_no[c.CH];
            if no<0 then Continue;
            if (no div 4)<>trkNo then Continue;

            if c.ClassType = TSmfNoteOn then
            begin
                cnt := cnt + writeNote;
            end
            else if c.ClassType = TSmfProgramChange then
            begin
                cnt := cnt + writeVoice;
            end
            else if c.ClassType = TSmfTempo then
            begin
                cnt := cnt + writeTempo;
            end else if c.ClassType = TSmfControlChange then
            begin
                cnt := cnt + writeMainVolume;
            end;
        end;
        //cnt := cnt + sub_writeTime(LastLen);//����
        if trkNo=0 then
        begin
            cnt := cnt + sub_writeTime(LastTime-tp);  //wirte END_POS time
            cnt := cnt + f.Write(END_POS,3);
        end;
        cnt := cnt + f.Write(#0+EOT, 4); //write END OF TRACK

        f.Position := header_pos; //�w�b�_�̒������C��
        writeDWord(cnt);
        f.Seek(0, soFromEnd);

    end;

begin
    //todo: MLD�����o��
    //http://homepage2.nifty.com/cstation/mfi_1.html ���Q�l�ɂ��܂����B
    MergeTracks; //smf format=0 �ɕϊ�
    Sort; //Time���ɕ��т�����
    LastTime := 0;
    //
    baseR := 48 / TimeBase ;
    trk := Items[0];//�g���b�N�}�[�W���Ă��邩��A�O�ɑS�Ẵf�[�^
    f := TMemoryStream.Create ;
    try
        f.Position := 0;
        WriteSongHeader;
        WriteInfoHeader;
        for i:=0 to 3 do WriteTrackData(i);//MIDI��4�g���b�N�����P�ɂ܂Ƃ߂ď���
        //�w�b�_�̏C��
        f.Position := 0;
        SongHeader.FileLen := SwapEndian4( f.Size-8 );
        f.Write(SongHeader, SizeOf(SongHeader));
        f.SaveToFile(FName);
    finally
        f.Free ;
    end;
end;
*)

procedure TSmfSong.Sort;
var
    i: Integer;
    p: TSmfTrack;
begin
    for i:=0 to Count-1 do
    begin
      p := Items[i];
      if p<>nil then p.Sort ;
    end;
end;

{ TSmfNoteOn }

procedure TSmfNoteOn.DivideEvent(var track: TList; shift: Integer);
var
    p: TSmfNoteOff;
begin
    if PackedNoteOff = False then Exit; //���ɕ�������Ă���΁A������

    if Len<=0 then
    begin
        Len := 1;
    end;

    //NoteOff�̍쐬
    p := TSmfNoteOff.Create ;
    p.Time := Self.Time + len;
    p.NoteNo := Self.NoteNo;
    p.Velocity := Self.Velocity ;
    p.Event := Byte($80 + Self.CH) ;
    //�g���b�N�ɒǉ�
    track.Add(p);
    PackedNoteOff := False;//�΂炵���؂ɁA0���Z�b�g
end;

function TSmfNoteOn.WriteStream(var stream: TStream): Integer;
begin
    Result := write3byte(stream, Event, NoteNo, Velocity);
end;

{ TSmfNoteOff }

function TSmfNoteOff.WriteStream(var stream: TStream): Integer;
begin
    Result := write3byte(stream, Event, NoteNo, Velocity);
end;

{ TSmfProgramChange }

procedure TSmfProgramChange.Assgin(c: TSmfProgramChange);
begin
    msb := c.msb ;
    lsb := c.lsb ;
    value := c.value ;
    Time := c.Time ;
    Event := c.Event ;
end;

procedure TSmfProgramChange.DivideEvent(var track: TList; shift: Integer);
var
    p: TSmfControlChange ;
begin
    if (msb<0)and(lsb<0) then Exit;
    //msb �̏�������
    p := TSmfControlChange.Create ;
    p.Time := Self.Time - shift * 2;
    p.Event := EVENT_CONTROL_CHANGE + CH;
    p.No := CC_BANK_MSB ;
    if msb<0 then msb := 0;
    p.Value := msb;
    track.Add(p);
    //lsb �̏�������
    if lsb<0 then lsb := 0;
    p := TSmfControlChange.Create ;
    p.Time := Self.Time - shift;
    p.Event := EVENT_CONTROL_CHANGE + CH;
    p.No := CC_BANK_LSB ;
    p.Value := lsb;
    track.Add(p);
    //
    msb := -1; lsb := -1; //= Not Assign
end;

function TSmfProgramChange.WriteStream(var stream: TStream): Integer;
begin
    Result := write2byte(stream, Event, Byte(value));
end;

{ TSmfControlChange }

function TSmfControlChange.WriteStream(var stream: TStream): Integer;
begin
    Result := write3byte(stream, Event, No, Value);
end;

{ TSmfKeyPressure }

function TSmfKeyPressure.WriteStream(var stream: TStream): Integer;
begin
    Result := write3byte(stream, Event, NoteNo, velocity);
end;

{ TSmfChannelPressure }

function TSmfChannelPressure.WriteStream(var stream: TStream): Integer;
begin
    Result := write2byte(stream, Event, value);
end;

{ TSmfPitchBend }

function TSmfPitchBend.WriteStream(var stream: TStream): Integer;
var
    v: Integer;
    msb,lsb: Byte;
begin
    //�s�b�`�x���h�́A14bit�ŕ\�����
    v := value + 8192;
    v := Max(0, Min(v, 16383)); //�͈͓��Ɏ��߂�
    msb := (v shr 7) and $7F; //��ʂV�r�b�g
    lsb := v and $7F;//���ʂV�r�b�g
    Result := write3byte(stream, event, lsb, msb);//�������ޏ��Ԃ́A��ʂƉ��ʂ��t�Ȃ̂Œ���
end;

{ TSmfRPN }

procedure TSmfRPN.DivideEvent(var track: TList; shift: Integer);
var
    p: TSmfControlChange ;
begin
    if rpnType = typeNone then Exit; //�����ς݂��H

    if rpnType = typeRPN then
    begin
         //msb
         p := TSmfControlChange.Create ;
         p.Time := Self.Time - shift * 2;
         p.Event := EVENT_CONTROL_CHANGE + CH;
         p.No := CC_RPN_MSB;
         p.Value := msb;
         track.Add(p);
         //lsb
         p := TSmfControlChange.Create ;
         p.Time := Self.Time - shift ;
         p.Event := EVENT_CONTROL_CHANGE + CH;
         p.No := CC_RPN_LSB;
         p.Value := lsb;
         track.Add(p);
    end else
    // typeNRPN
    begin
         //msb
         p := TSmfControlChange.Create ;
         p.Time := Self.Time - shift * 2;
         p.Event := EVENT_CONTROL_CHANGE + CH;
         p.No := CC_NRPN_MSB;
         p.Value := msb;
         track.Add(p);
         //lsb
         p := TSmfControlChange.Create ;
         p.Time := Self.Time - shift ;
         p.Event := EVENT_CONTROL_CHANGE + CH;
         p.No := CC_NRPN_LSB;
         p.Value := lsb;
         track.Add(p);
    end;
    // Data Entry
    if ByteCount >= 3 then
    begin
        p := TSmfControlChange.Create ;
        p.Time := Self.Time ;
        p.Event := EVENT_CONTROL_CHANGE + CH;
        p.No := CC_DATA_ENTRY;
        p.Value := Byte(data);
        track.Add(p);
    end;
    rpnType := typeNone;
end;

function TSmfRPN.WriteStream(var stream: TStream): Integer;
begin
    Result := 0;
end;

{ TSmfDirect }

constructor TSmfDirect.Create;
begin
    byteArray := nil;
end;

function TSmfDirect.WriteStream(var stream: TStream): Integer;
begin
    Result := 0;
    if byteArray=nil then Exit;
    Result := stream.Write(byteArray[0], Length(byteArray));
end;

{ TSmfSysEx }

function TSmfSysEx.WriteStream(var stream: TStream): Integer;
var
    len: Integer;
    c: Byte;
begin
    //---   $F0 (�ϒ�) data ... $F7
    //---   $F7 (�ϒ�) data
    Result := 0;
    len := Length(byteArray);
    if len<=0 then Exit;

    //write status
    c := $F0;
    Result := stream.Write(c, 1);
    //write length
    Result := Result + writeVarLen(stream, len);
    //write data
    Result := Result + stream.Write(byteArray[0], len);
end;

{ TSmfMeta }

function TSmfMeta.WriteStream(var stream: TStream): Integer;
var
    len: Integer;
    c: array [0..1] of Byte;
begin
    Result := 0;
    len := Length(byteArray);
    if len<=0 then Exit;

    //write status
    c[0] := $FF;
    c[1] := MetaType ;
    Result := stream.Write(c[0], 2);
    //write length
    Result := Result + writeVarLen(stream, len);
    //write data
    Result := Result + stream.Write(byteArray[0], len);
end;

{ TSmfPlayFrom }

constructor TSmfPlayFrom.Create;
begin
    FromPos  := -1; //���w��
    ToPos    := -1;
    SysEx    := False; //�f�t�H���g�ő��M���Ȃ�
    CC       := True;
    RPN_NRPN := True;
    WaitTime := 192;
end;

{ TSmfTempo }
procedure TSmfTempo.SetTempo(tp: Integer);
var
    v: DWORD;
begin
    v := tp;
    v := 60000000 div v;
    MetaType := META_TEMPO;
    Event := EVENT_META ;
    Tempo := tp;
    SetLength(byteArray,3);
    byteArray[0] := (v shr 16);
    byteArray[1] := (v shr 8) and $FF;
    byteArray[2] := v and $FF;
end;

{ TSmfRPNList }

function TSmfRPNList.Add(rpn: TSmfRPN): Integer;
var
    r: TSmfRPN;
begin
    r := Find(rpn.msb, rpn.lsb, rpn.CH);
    if r=nil then
    begin
        Result := inherited Add(rpn);
    end else
    begin
        Result := Count;
        r.data := rpn.data ;
        r.byteCount := rpn.byteCount ;
        r.Time := rpn.Time ;
        r.Event := rpn.Event ;
        r.rpnType := rpn.rpnType ;
        rpn.Free;
    end;
end;


function TSmfRPNList.Find(msb, lsb, ch: Integer): TSmfRPN;
var
    i: Integer;
    r: TSmfRPN;
begin
    Result:=nil;
    for i:=0 to Count-1 do
    begin
        r := Self.Items[i];
        if r=nil then Continue;
        if (r.msb = msb)and(r.lsb = lsb)and(r.CH = ch) then
        begin
            Result := r;
            Break;
        end;
    end;
end;

end.
