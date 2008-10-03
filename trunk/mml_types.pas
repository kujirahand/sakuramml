unit mml_types;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 http://www.text2music.com
説　明：MMLのトラック情報、ソング情報を管理するクラス

履　歴：

2002/06/03 15:13 雛型作成
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
  MAX_NOTE_INFO = 11;//v と v__0 ... v__9

type
  TNoteOnType = (noteNormal, noteOnNote, noteOnTime, noteOnCycle, noteOnWave,
        noteOnWaveEx, noteOnWaveR, noteOff, noteCCSine, noteOnSine);
  TTrackInfo = class;
  TMRange = class
    low, high: Integer;
    constructor Create(l,h: Integer);
  end;

  //ノート情報
  TNoteInfo = class
  private
    track:  TTrackInfo;
    FValue: Integer;
    FIndex: Integer;
  public
    ValueChangeTime: Integer; //先行指定の起点
    DelayTime:       Integer; //先行指定の遅延時間
    RepeatMode:      Integer; //0=off / 1=on
    RandomValue:     Integer; //最終的な値へ及ぼすランダムの値
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
    property    ROValue: Integer read FValue; //止む無く直接値を参照したいとき
  end;

  //ノート情報配列
  TNoteInfos = class
  private
    track: TTrackInfo;
  public
    Range: TMRange; //値の最終的な上限と下限(0,127)
    ArrayNote: array [0..MAX_NOTE_INFO-1] of TNoteInfo;//0 が defaultのノート情報 で、v__0 は、ArrayNote[1]に当たる
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

  //コントロールチェンジのイベント管理
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

  //コントロールチェンジリスト
  TCCList = class(TList)
  public
    procedure Clear; override;
    function FindCC(no: Integer): TNoteCC;//検索のみ
    function GetCC(no: Integer): TNoteCC;//なかったら作成して返す
    destructor Destroy; override;
  end;

  //トラック情報
  TTrackInfo = class
  private
    FCCNoMute:           array[0..63] of Byte;
    function GetCCNoMute(Index: Integer): Boolean;
    procedure SetCCNoMute(Index: Integer; const Value: Boolean); //特定のコントロールチェンジのみミュート
  public
    TrackNo:            Integer;
    Channel:            Integer;              //channel = 1-15
    Port:               Integer;              //PORT番号
    Voice:              Integer;              //音色
    TimePtr:            Integer;              //タイムポインタ
    Stepmode:           Boolean;              //StepMode
    Length:             TNoteInfos;           //Length
    Velocity:           TNoteInfos;           //velocity
    Qgate:              TNoteInfos;           //gate time
    Octave:             TNoteInfos;           //Octave
    Timing:             TNoteInfos;           //timing
    Mute:               Boolean;              //mute
    Q2:                 Integer;              //ゲート加算
    TieMode:            Integer;              //スラーの動作
    TieValue:           Integer;
    Key:                Integer;              //トラックごとのキー
    ArgOrder:           string;               //引数の並び順
    CCMute:             Boolean;              //コントロールチェンジのミュート
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

  //トラック管理クラス

  //曲情報
  TSongInfo = class(TList)
  public
    X68Mode:            Boolean;            //Octave記号<>を入れ替えるか
    Stepmode:           Boolean;            //Step単位を標準にするか(<-->n分音符単位)
    qMax:               Integer;            //q(ゲートパーセント)の最大値(100)
    vMax:               Integer;            //v(ベロシティ)の最大値(127)
    vAdd:               Integer;            //v+でベロシティの追加値(8)
    qAdd:               Integer;            //q+パーセント指定 "    (10)
    q2Add:              Integer;            //q ステップ指定   "    (10)
    TimeBase:           Integer;            //四分音符分解能の指定  (96)
    RandomSeed:         Integer;            //乱数の種
    Keyshift:           Integer;            //キーシフト値
    MeasureShift:       Integer;            //小節数のシフト値
    VoiceNoShift:       Integer;            //プログラムチェンジのシフト値(0) @=1~128
    OctaveRangeShift:   Integer;            //オクターブのシフト値
    KeyFlag:            array [0..6] of Integer; //キーフラグ値(a,b,c,d,e,f,g)
    TimeKeyFlag:        TList;              //Time指定付きのキーフラグ
    TimeKey:            TList;              //Time指定付きのキーフラグ
    TimeKey2:           TList;              //Time指定付きのキーフラグ その2
    ControllerShift:    Integer;            //ベンドやコントロールチェンジなどの出力タイミングを早めるか(1)
    SoundType:          Integer;            //音源の種類
    CC:                 array [0..15] of TCCList; //コントロールチェンジ管理クラス
    CCFreq:             Integer;            //書き込み頻度(3step)
    Tempo:              Integer;            //テンポ(120)
    TimeSigKo,TimeSigHa:Integer;            //分子,分母(4,4)
    BendRange:          array [0..15] of Integer; //ベンドレンジ値(初期値は、2)
    UseKeyShift:        Boolean;            //キーシフトを適用するかどうか
    TrackSyncTime:      Integer;            //最後にTrackSyncした個所を覚えておく。新しいトラック生成に備える
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

    //Song の初期設定
    X68Mode   := False; // Octave記号<>を入れ替えるか
    Stepmode  := False; //Step単位を標準にするか(<-->n分音符単位)
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
    ControllerShift  := 1; //ベンドやコントロールチェンジなどの出力タイミングを早めるか(1)
    SoundType := SOUND_TYPE_GM; //大多数の人は、GM音源
    CCFreq := 2;
    Tempo := 120;
    TimeSigKo := 4;
    TimeSigHa := 4;
    UseKeyShift := True;
    TrackSyncTime := 0; //未設定
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
    Clear; //音源の初期化は、こちら
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
    //なければ作る
    if Index >= Count then
    begin
        Count := Index + 1;
    end;
    if Items[Index]=nil then
    begin
        Items[Index] := TTrackInfo.Create(Stepmode);
        TTrackInfo(Items[Index]).TrackNo := Index;
        TTrackInfo(Items[Index]).Length.ArrayNote[0].Value := DefTimebase;

        //トラックによるチャンネルの初期設定を適当に決める
        if Index=0 then
            TTrackInfo(Items[Index]).Channel := 0
        else
            TTrackInfo(Items[Index]).Channel := (Index-1) mod 16;
        //初期タイムポインタをセット
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
  // 特定のバイトを選び出しそのなかでビットを得る
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
  // 特定のバイトを選び出しそのなかでビットを得る
  ai := Trunc(Index / 8);
  bi := Index mod 8;
  m  := 1 shl bi;

  // 反転させたいかどうか
  if ((FCCNoMute[ai] shr bi) <> 0) <> Value then
  begin // 反転させる
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
            if RepeatMode = BOOL_FALSE then //繰り返し指定か
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
        n := track.TimePtr ;//現在位置

        //もし、起点以前だったら、以前の値を参照して抜ける
        if kiten > n then begin Result := FValue; Exit; end;

        //low,high,len, low,high,len... の、どの範囲か得る
        i := 0; x1 := kiten; x2 := kiten; low:=0; high:=0;

        //引数なしのダミーなら抜ける
        if reserve.Count = 0 then begin Result := FValue; Exit; end;
        if (reserve.Count mod 3) <> 0 then
        begin
          raise Exception.Create('".onTime"で引数の個数が不正です。');
        end;

        while True do begin
            idx := i * 3 + 2; //len
            if idx>=reserve.Count then
            begin // RangeOver
                if RepeatMode <> BOOL_FALSE then
                begin
                    kiten := x1;
                    i := 0; Continue; //Indexを０に戻して再計算
                end else begin //抜ける
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
            FValue := reserve.IntItems[idx-1]; //前回の最大値
            Inc(i);
            x1 := x2;
        end;

        //起点(x1)終点(x2)が得られたので角度aを求め、現在位置の値を割り出す
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
        n := track.TimePtr ;//現在位置

        //もし、起点以前だったら、以前の値を参照して抜ける
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
    //オプション__0~9 までの、ゲートステップを得る
    Result := 0;
    for i:=1 to MAX_NOTE_INFO -1 do //defaultの0は、NoteOnイベントで計算するので。
    begin
        if ArrayNote[i] <> nil then
        begin
            Result := Result + ArrayNote[i].GetQGateValue(len,qmax) ;
        end;
    end;
    if Range<>nil then //範囲の制限
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
    if Range<>nil then //範囲の制限
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
    LastValue := -1;// 2003/7/1 -1 から 0 に修正

    Clear ; //値の初期化
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
        Result.LastValue := -1; //未定義
        {
        //混乱の元だから、なし
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
