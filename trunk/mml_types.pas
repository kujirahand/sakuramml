unit mml_types;
{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���FMML�̃g���b�N���A�\���O�����Ǘ�����N���X

���@���F

2002/06/03 15:13 ���^�쐬
-------------------------------------------------------------------------------}

interface

uses
  SysUtils,
  Classes,
  hashUnit,
  mml_const,
  mml_var,
  Math;

const
  MAX_NOTE_INFO = 11;//v �� v__0 ... v__9

type
  TNoteOnType = (noteNormal, noteOnNote, noteOnTime, noteOnCycle, noteOnWave,
        noteOnWaveEx, noteOnWaveR, noteOff, noteCCSine, noteOnSine);
  TTrackInfo = class;
  TMRange = class
    low, high: Integer;
    constructor Create(l,h: Integer);
  end;

  //�m�[�g���
  TNoteInfo = class
  private
    track:  TTrackInfo;
    FValue: Integer;
    FIndex: Integer;
  public
    ValueChangeTime: Integer; //��s�w��̋N�_
    DelayTime:       Integer; //��s�w��̒x������
    RepeatMode:      Integer; //0=off / 1=on
    RandomValue:     Integer; //�ŏI�I�Ȓl�֋y�ڂ������_���̒l
    StepMode:        Boolean; //Stepmode
    reserve:         TMArray;
    noteOnType:      TNoteOnType;
    constructor Create(tr: TTrackInfo);
    destructor  Destroy; override;
    function    GetValue: Integer;
    function    GetQGateValue(len: Integer; qmax: Integer): Integer;
    procedure   SetValue(value: Integer);
    procedure   SetReserveValue(nType: TNoteOnType; v:TMArray; timePtr: Integer);
    property    Value: Integer   read GetValue write SetValue;
    property    ROValue: Integer read FValue; //�~�ޖ������ڒl���Q�Ƃ������Ƃ�
  end;

  //�m�[�g���z��
  TNoteInfos = class
  private
    track: TTrackInfo;
  public
    Range: TMRange; //�l�̍ŏI�I�ȏ���Ɖ���(0,127)
    ArrayNote: array [0..MAX_NOTE_INFO-1] of TNoteInfo;//0 �� default�̃m�[�g��� �ŁAv__0 �́AArrayNote[1]�ɓ�����
    constructor Create(tr: TTrackInfo);
    destructor  Destroy; override;
    procedure   Clear;
    function    GetValue: Integer;
    function    GetQGateValue(len, qmax: Integer): Integer;
    procedure   SetValue(Index, value: Integer);
    procedure   IncValue(Index, value: Integer);
    procedure   CreateArrayNote(Index: Integer);
    procedure   SetReserveValue(Index: Integer; nType: TNoteOnType; v:TMArray; timePtr: Integer);
  end;

  //�R���g���[���`�F���W�̃C�x���g�Ǘ�
  TNoteCC = class
  public
    FIndex: Integer;
    Time: Integer;
    noteOnType : TNoteOnType ;
    No:          Integer;
    RandomValue: Integer;
    DelayTime:   Integer;
    RepeatMode:  Integer;
    LastValue:   Integer;
    reserve:     TMArray;
    Range:       TMRange;
    constructor  Create;
    destructor   Destroy; override;
    procedure    Clear;
  end;

  //�R���g���[���`�F���W���X�g
  TCCList = class(TList)
  public
    procedure Clear; override;
    function FindCC(no: Integer): TNoteCC;//�����̂�
    function GetCC(no: Integer): TNoteCC;//�Ȃ�������쐬���ĕԂ�
    destructor Destroy; override;
  end;

  //�g���b�N���
  TTrackInfo = class
  private
    FCCNoMute:           array[0..63] of Byte;
    function GetCCNoMute(Index: Integer): Boolean;
    procedure SetCCNoMute(Index: Integer; const Value: Boolean); //����̃R���g���[���`�F���W�̂݃~���[�g
  public
    TrackNo:            Integer;
    Channel:            Integer;              //channel = 1-15
    Port:               Integer;              //PORT�ԍ�
    Voice:              Integer;              //���F
    TimePtr:            Integer;              //�^�C���|�C���^
    Stepmode:           Boolean;              //StepMode
    Length:             TNoteInfos;           //Length
    Velocity:           TNoteInfos;           //velocity
    Qgate:              TNoteInfos;           //gate time
    Octave:             TNoteInfos;           //Octave
    Timing:             TNoteInfos;           //timing
    Mute:               Boolean;              //mute
    Q2:                 Integer;              //�Q�[�g���Z
    TieMode:            Integer;              //�X���[�̓���
    TieValue:           Integer;
    Key:                Integer;              //�g���b�N���Ƃ̃L�[
    ArgOrder:           string;               //�����̕��я�
    CCMute:             Boolean;              //�R���g���[���`�F���W�̃~���[�g
    constructor Create(SongStepmode: Boolean);
    destructor Destroy; override;
    procedure InitValue;
    property CCNoMute[Index: Integer]: Boolean read GetCCNoMute write SetCCNoMute;
  end;

  TTimeKeyFlag = class
  public
    KeyFlag: array [0..6] of Integer;
    timeFrom, timeTo: Integer;
    constructor Create;
  end;
  TTimeKey = class
    key,timeFrom, timeTo: Integer;
    constructor Create;
  end;

  //�g���b�N�Ǘ��N���X

  //�ȏ��
  TSongInfo = class(TList)
  public
    X68Mode:            Boolean;            //Octave�L��<>�����ւ��邩
    Stepmode:           Boolean;            //Step�P�ʂ�W���ɂ��邩(<-->n�������P��)
    qMax:               Integer;            //q(�Q�[�g�p�[�Z���g)�̍ő�l(100)
    vMax:               Integer;            //v(�x���V�e�B)�̍ő�l(127)
    vAdd:               Integer;            //v+�Ńx���V�e�B�̒ǉ��l(8)
    qAdd:               Integer;            //q+�p�[�Z���g�w�� "    (10)
    q2Add:              Integer;            //q �X�e�b�v�w��   "    (10)
    TimeBase:           Integer;            //�l����������\�̎w��  (96)
    RandomSeed:         Integer;            //�����̎�
    Keyshift:           Integer;            //�L�[�V�t�g�l
    MeasureShift:       Integer;            //���ߐ��̃V�t�g�l
    VoiceNoShift:       Integer;            //�v���O�����`�F���W�̃V�t�g�l(0) @=1~128
    OctaveRangeShift:   Integer;            //�I�N�^�[�u�̃V�t�g�l
    KeyFlag:            array [0..6] of Integer; //�L�[�t���O�l(a,b,c,d,e,f,g)
    TimeKeyFlag:        TList;              //Time�w��t���̃L�[�t���O
    TimeKey:            TList;              //Time�w��t���̃L�[�t���O
    TimeKey2:           TList;              //Time�w��t���̃L�[�t���O ����2
    ControllerShift:    Integer;            //�x���h��R���g���[���`�F���W�Ȃǂ̏o�̓^�C�~���O�𑁂߂邩(1)
    SoundType:          Integer;            //�����̎��
    CC:                 array [0..15] of TCCList; //�R���g���[���`�F���W�Ǘ��N���X
    CCFreq:             Integer;            //�������ݕp�x(3step)
    Tempo:              Integer;            //�e���|(120)
    TimeSigKo,TimeSigHa:Integer;            //���q,����(4,4)
    BendRange:          array [0..15] of Integer; //�x���h�����W�l(�����l�́A2)
    UseKeyShift:        Boolean;            //�L�[�V�t�g��K�p���邩�ǂ���
    TrackSyncTime:      Integer;            //�Ō��TrackSync���������o���Ă����B�V�����g���b�N�����ɔ�����
    constructor Create;
    destructor Destroy;override;
    procedure Clear; override;
    function GetTrack(Index: Integer; DefTimebase: Integer = 96): TTrackInfo;
    function GetTrackCount: Integer;
  end;



implementation

{ TSongInfo }

procedure TSongInfo.Clear;
var
    i: Integer;
    p: TTrackInfo ;
begin
    for i:=0 to Count-1 do
    begin
        p := Items[i];
        if p<>nil then p.Free ;
    end;
    inherited Clear;

    //Song �̏����ݒ�
    X68Mode   := False; // Octave�L��<>�����ւ��邩
    Stepmode  := False; //Step�P�ʂ�W���ɂ��邩(<-->n�������P��)
    qMax      :=100;
    vMax      :=127;
    vAdd      := 8;
    qAdd      := 10;
    q2Add     := 8;
    TimeBase  := 96;
    RandomSeed       := RandSeed;
    Keyshift         := 0;
    MeasureShift     := 0;
    VoiceNoShift     := 0;
    OctaveRangeShift := 0;
    for i:=0 to 6 do KeyFlag[i] := 0;
    ControllerShift  := 1; //�x���h��R���g���[���`�F���W�Ȃǂ̏o�̓^�C�~���O�𑁂߂邩(1)
    SoundType := SOUND_TYPE_GM; //�命���̐l�́AGM����
    CCFreq := 2;
    Tempo := 120;
    TimeSigKo := 4;
    TimeSigHa := 4;
    UseKeyShift := True;
    TrackSyncTime := 0; //���ݒ�
end;

constructor TSongInfo.Create;
var
    i: Integer;
begin
    inherited;
    for i:=0 to 15 do
    begin
        CC[i] := TCCList.Create ;
    end;
    for i:=0 to 15 do
    begin
        BendRange[i] := 2;
    end;
    TimeKeyFlag := TList.Create ;
    TimeKey     := TList.Create ;
    TimeKey2    := TList.Create ;
    Clear; //�����̏������́A������
end;

destructor TSongInfo.Destroy;
var
    i: Integer;
    t: TTimeKeyFlag;
    tk: TTimeKey;
begin
    for i:=0 to 15 do
    begin
        CC[i].Free ;
    end;
    for i:=0 to TimeKeyFlag.Count -1 do
    begin
        t := TimeKeyFlag.Items[i];
        if t<>nil then t.Free ;
    end;
    for i:=0 to TimeKey.Count -1 do
    begin
        tk := TimeKey.Items[i];
        if tk<>nil then tk.Free ;
    end;
    for i:=0 to TimeKey2.Count -1 do
    begin
        tk := TimeKey2.Items[i];
        if tk<>nil then tk.Free ;
    end;
    TimeKeyFlag.Free ;
    TimeKey.Free ;
    TimeKey2.Free ;
    inherited;
end;

function TSongInfo.GetTrack(Index: Integer; DefTimebase: Integer = 96): TTrackInfo;
begin
    //�Ȃ���΍��
    if Index >= Count then
    begin
        Count := Index + 1;
    end;
    if Items[Index]=nil then
    begin
        Items[Index] := TTrackInfo.Create(Stepmode);
        TTrackInfo(Items[Index]).TrackNo := Index;
        TTrackInfo(Items[Index]).Length.ArrayNote[0].Value := DefTimebase;

        //�g���b�N�ɂ��`�����l���̏����ݒ��K���Ɍ��߂�
        if Index=0 then
            TTrackInfo(Items[Index]).Channel := 0
        else
            TTrackInfo(Items[Index]).Channel := (Index-1) mod 16;
        //�����^�C���|�C���^���Z�b�g
        TTrackInfo(Items[Index]).TimePtr := TrackSyncTime;
    end;

    Result := Items[Index];
end;

function TSongInfo.GetTrackCount: Integer;
begin
  Result := Self.Count;
end;

{ TTrackInfo }

constructor TTrackInfo.Create(SongStepmode: Boolean);
begin
    Stepmode := SongStepmode;

    Length   := TNoteInfos.Create(Self) ;
    Velocity := TNoteInfos.Create(Self) ;
    Qgate    := TNoteInfos.Create(Self) ;
    Timing   := TNoteInfos.Create(Self) ;
    Octave   := TNoteInfos.Create(Self) ;

    InitValue;
end;

destructor TTrackInfo.Destroy;
begin
    Velocity.Free ;
    Qgate.Free ;
    Timing.Free ;
    Octave.Free ;
    Length.Free ;
    inherited;
end;

function TTrackInfo.GetCCNoMute(Index: Integer): Boolean;
var
  b: Byte;
  shift: Integer;
begin
  // ����̃o�C�g��I�яo�����̂Ȃ��Ńr�b�g�𓾂�
  b := FCCNoMute[Trunc(Index / 8)];
  shift := Index mod 8;
  b := (b shr shift) and 1;
  Result := (b = 1);
end;

procedure TTrackInfo.InitValue;
var
  i: Integer;
begin
    Length.ArrayNote[0].Value   :=  96;//n=4
    Velocity.ArrayNote[0].Value := 100;
    Qgate.ArrayNote[0].Value    :=  80;
    Octave.ArrayNote[0].Value   :=   5;
    Timing.ArrayNote[0].Value   :=   0;
    Mute := False;
    TimePtr := 0;
    TieMode := TIE_PORT;
    TieValue := 12;
    Key := 0;
    Port := 0;
    Q2 := 0;
    ArgOrder := 'lqvto';
    CCMute := False;
    for i := 0 to High(FCCNoMute) do FCCNoMute[i] := 0;
end;

procedure TTrackInfo.SetCCNoMute(Index: Integer; const Value: Boolean);
var
  m: Byte;
  ai, bi: Integer;
begin
  // ����̃o�C�g��I�яo�����̂Ȃ��Ńr�b�g�𓾂�
  ai := Trunc(Index / 8);
  bi := Index mod 8;
  m  := 1 shl bi;

  // ���]�����������ǂ���
  if ((FCCNoMute[ai] shr bi) <> 0) <> Value then
  begin // ���]������
    FCCNoMute[ai] := FCCNoMute[ai] xor m;
  end;

end;

{ TNoteInfo }

constructor TNoteInfo.Create(tr: TTrackInfo);
begin
    noteOnType  := noteNormal ;
    reserve     := TMArray.Create ;
    track       := tr;
    RepeatMode  := BOOL_TRUE;
    RandomValue := 0;
    FValue      := 0;
    Stepmode    := False;
end;

destructor TNoteInfo.Destroy;
begin
    reserve.Free ;
    inherited;
end;

function TNoteInfo.GetQGateValue(len: Integer; qmax: Integer): Integer;
var
    r: Extended;
    v: Integer;
begin
    if StepMode then
    begin
        Result := GetValue;
    end else
    begin
        v := GetValue ;
        r := v / qmax;
        Result := Trunc(len * r);
        if (Result=0)and(v>0)and(len>0) then Result := 1;
    end;
end;

function TNoteInfo.GetValue: Integer;

    function CalcOnNote: Integer;
    begin
        if reserve.Count = 0 then
        begin
          Result := FValue;
          Exit;
        end;
        Result := reserve.IntItems[ FIndex ];
        Inc(FIndex);
        if reserve.Count <= FIndex then
        begin
            if RepeatMode = BOOL_FALSE then //�J��Ԃ��w�肩
            begin
                SetValue(Result);
            end;
            FIndex := 0;
        end;
    end;

    function CalcOnTime: Integer;
    var
        kiten, n, len, i,idx, x1, x2, x3, kyori, takasa, low, high: Integer;
        a: Extended;
    { kiten           i           i+1
        |-------------+----+------+--------|
                      x1   x3     x2                 }
    begin
        kiten := ValueChangeTime + DelayTime ;
        n := track.TimePtr ;//���݈ʒu

        //�����A�N�_�ȑO��������A�ȑO�̒l���Q�Ƃ��Ĕ�����
        if kiten > n then begin Result := FValue; Exit; end;

        //low,high,len, low,high,len... �́A�ǂ͈̔͂�����
        i := 0; x1 := kiten; x2 := kiten; low:=0; high:=0;

        //�����Ȃ��̃_�~�[�Ȃ甲����
        if reserve.Count = 0 then begin Result := FValue; Exit; end;
        if (reserve.Count mod 3) <> 0 then
        begin
          raise Exception.Create('".onTime"�ň����̌����s���ł��B');
        end;

        while True do begin
            idx := i * 3 + 2; //len
            if idx>=reserve.Count then
            begin // RangeOver
                if RepeatMode <> BOOL_FALSE then
                begin
                    kiten := x1;
                    i := 0; Continue; //Index���O�ɖ߂��čČv�Z
                end else begin //������
                    Result := FValue; Exit;
                end;
            end;
            len := reserve.IntItems[idx];
            x2 := x1 + len;
            if (x1<=n)and(n<=x2) then
            begin
                low  := reserve.IntItems[i*3+0];
                high := reserve.IntItems[i*3+1];
                Break;
            end;
            FValue := reserve.IntItems[idx-1]; //�O��̍ő�l
            Inc(i);
            x1 := x2;
        end;

        //�N�_(x1)�I�_(x2)������ꂽ�̂Ŋp�xa�����߁A���݈ʒu�̒l������o��
        kyori := x2 - x1;
        x3 := n - kiten;
        takasa := high - low;
        if kyori=0 then a:=0 else a := takasa / kyori;
        Result := Trunc( x3 * a ) + low;
    end;

    function CalcOnCycle: Integer;
    var
        kiten, n, len, i,idx: Integer;
    { kiten len
          |---+---+---+---+---|
          x1  x2  x3  x4  x5  x6    }
    begin
        kiten := ValueChangeTime + DelayTime ;
        n := track.TimePtr ;//���݈ʒu

        //�����A�N�_�ȑO��������A�ȑO�̒l���Q�Ƃ��Ĕ�����
        if kiten > n then begin Result := FValue; Exit; end;

        len := reserve.IntItems[0]; // int
        n := n - kiten;
        if len=0 then
            i := 0
        else
            i := n div len;
        if reserve.Count >= 0 then
        begin
            if reserve.Count = 1 then
                idx := 0
            else
                idx := ( i mod (reserve.Count-1) ) + 1;
            Result := reserve.IntItems[idx];
        end else
            Result := FValue;
    end;

begin
    case noteOnType of
    noteNormal:
        begin
            Result := FValue;
        end;
    noteOnNote:
        begin
            Result := CalcOnNote;
        end;
    noteOnTime:
        begin
            Result := CalcOnTime;
        end;
    noteOnCycle:
        begin
            Result := CalcOnCycle;
        end;
    else
        Result := 0;
    end;
    //Random
    if RandomValue > 0 then Result := Result - (RandomValue div 2) + Random(RandomValue);
end;

procedure TNoteInfo.SetReserveValue(nType: TNoteOnType; v:TMArray; timePtr: Integer);
begin
    noteOnType := nType;
    reserve.Assign(v);
    ValueChangeTime := timePtr;
    FIndex := 0;
end;

procedure TNoteInfo.SetValue(value: Integer);
begin
    noteOnType := noteNormal ;
    FValue := value;
end;

{ TNoteInfos }


procedure TNoteInfos.Clear;
var
    i: Integer;
begin
    for i:=0 to MAX_NOTE_INFO -1 do
    begin
        if ArrayNote[i] <> nil then
        begin
            ArrayNote[i].Free ;
            ArrayNote[i] := nil;
        end;
    end;
    if Range <> nil then Range.Free;
    Range := nil;
end;

constructor TNoteInfos.Create(tr: TTrackInfo);
var
    i: Integer;
begin
    for i:=1 to MAX_NOTE_INFO -1 do
    begin
        ArrayNote[i] := nil;
    end;
    track := tr;
    ArrayNote[0] := TNoteInfo.Create(tr) ;
    Range := nil;
end;

procedure TNoteInfos.CreateArrayNote(Index: Integer);
begin
    if ArrayNote[Index] = nil then
    begin
        ArrayNote[Index] := TNoteInfo.Create(track) ;
    end;
end;

destructor TNoteInfos.Destroy;
begin
    Clear;
    inherited;
end;

function TNoteInfos.GetQGateValue(len, qmax: Integer): Integer;
var
    i: Integer;
begin
    //�I�v�V����__0~9 �܂ł́A�Q�[�g�X�e�b�v�𓾂�
    Result := 0;
    for i:=1 to MAX_NOTE_INFO -1 do //default��0�́ANoteOn�C�x���g�Ōv�Z����̂ŁB
    begin
        if ArrayNote[i] <> nil then
        begin
            Result := Result + ArrayNote[i].GetQGateValue(len,qmax) ;
        end;
    end;
    if Range<>nil then //�͈͂̐���
    begin
        Result := Max(Range.low, Min(Range.high, Result));
    end;
end;

function TNoteInfos.GetValue: Integer;
var
    i: Integer;
begin
    Result := 0;
    for i:=0 to MAX_NOTE_INFO -1 do
    begin
        if ArrayNote[i] <> nil then
        begin
            Result := Result + ArrayNote[i].Value ;
        end;
    end;
    if Range<>nil then //�͈͂̐���
    begin
        Result := Max(Range.low, Min(Range.high, Result));
    end;
end;

procedure TNoteInfos.IncValue(Index, value: Integer);
begin
    if ArrayNote[Index] = nil then
    begin
        ArrayNote[Index] := TNoteInfo.Create(track) ;
    end;
    ArrayNote[Index].Value := ArrayNote[Index].Value + value;
end;

procedure TNoteInfos.SetReserveValue(Index: Integer; nType: TNoteOnType;
  v: TMArray; timePtr: Integer);
begin
    if ArrayNote[Index] = nil then
    begin
        ArrayNote[Index] := TNoteInfo.Create(track) ;
    end;
    ArrayNote[Index].SetReserveValue(nType, v, timePtr);
end;

procedure TNoteInfos.SetValue(Index, value: Integer);
begin
    if ArrayNote[Index] = nil then
    begin
        ArrayNote[Index] := TNoteInfo.Create(track) ;
    end;
    ArrayNote[Index].Value := value;
end;

{ TMRange }

constructor TMRange.Create(l, h: Integer);
begin
    low := l;
    high := h;
end;

{ TNoteCC }

procedure TNoteCC.Clear;
begin
    if Range <> nil then Range.Free ;
    Range := nil;
    RandomValue := 0;
    DelayTime := 0;
    RepeatMode := BOOL_TRUE;
    FIndex := 0;
    Reserve.Clear ;
end;

constructor TNoteCC.Create;
begin
    Reserve := TMArray.Create ;
    noteOnType := noteNormal ;
    no := -1;
    Time := 0;
    LastValue := -1;// 2003/7/1 -1 ���� 0 �ɏC��

    Clear ; //�l�̏�����
end;

destructor TNoteCC.Destroy;
begin
    Clear;
    Reserve.Free ;
    inherited;
end;

{ TCCList }

procedure TCCList.Clear;
var
    i: Integer;
    c: TNoteCC ;
begin
    for i:=0 to Count-1 do
    begin
        c := Items[i];
        if c<>nil then c.Free ;
    end;
    inherited;
end;

destructor TCCList.Destroy;
begin
    Clear;
    inherited;
end;

function TCCList.FindCC(no: Integer): TNoteCC;
var
    i: Integer;
begin
    for i:=0 to Count-1 do
    begin
        Result := Items[i];
        if Result <> nil then
        begin
            if Result.No = no then Exit;
        end;
    end;
    Result := nil;
end;

function TCCList.GetCC(no: Integer): TNoteCC;
begin
    Result := FindCC(no);
    if Result=nil then
    begin
        Result := TNoteCC.Create ;
        Result.No := no;
        Result.LastValue := -1; //����`
        {
        //�����̌�������A�Ȃ�
        case no of
        CC_NO_VOLUME:     Result.LastValue := 100;
        CC_NO_EXPRESSION: Result.LastValue := 127;
        CC_NO_PANPOT:     Result.LastValue :=  64;
        CC_NO_BEND  :     Result.LastValue :=  64;
        CC_NO_BEND_FULL:  Result.LastValue :=   0;
        end;
        }
        Add(Result);
    end;
end;

{ TTimeKeyFlag }

constructor TTimeKeyFlag.Create;
var
    i: Integer;
begin
    for i:=0 to 6 do
        KeyFlag[i] := 0;
    timeFrom := -1;
    timeTo := -1;
end;

{ TTimeKey }

constructor TTimeKey.Create;
begin
    timeFrom := -1;
    timeTo := -1;
    key := 0;
end;

end.
