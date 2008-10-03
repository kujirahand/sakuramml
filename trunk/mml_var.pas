unit mml_var;
{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���F�T�N���̊�{�^�^�C�v��錾���Ă��郆�j�b�g
�@�@�@�@�i�݌v�I�ɂ͂ǂ����Ȃ��E�E�E�A�R���p�C�����x�������Ă��錴�������B�v�����j
���@���F

2002/06/03 15:13 ���^�쐬
-------------------------------------------------------------------------------}

interface
uses
  Windows,
  SysUtils,
  Classes,
  hashUnit,
  mml_const,
  mml_error;

type
  PMmlOnProgress = ^TMmlOnProgress;
  TMmlOnProgress = procedure (NowLine, LineCount: Integer; msg: PChar; StopCompile: PBOOL); stdcall;

  TIntArray = array of Integer;
  //----------------------------------------------------------------------------
  //��{�^�i���l�A�����A�z��j
  TMVarCustom = class
    function clone: TMVarCustom; virtual; abstract;
    procedure Assign(c: TMVarCustom); virtual;
    function IntValue: Integer; virtual;
    function StrValue: string; virtual;
  end;

  //4�r�b�g����
  TMInt = class(TMVarCustom)
  public
    Flag: Char; // % �ȂǁA���l�̑O�ɕt��MML���L�̃t���O��ێ�����
    value: Integer;
    function clone: TMVarCustom; override;
    procedure Assign(c: TMVarCustom); override;
    function IntValue: Integer; override;
    function StrValue: string; override;
  end;

  //������^
  TMStr = class(TMVarCustom)
  public
    value: string;
    function clone: TMVarCustom; override;
    procedure Assign(c: TMVarCustom); override;
    function IntValue: Integer; override;
    function StrValue: string; override;
    function LoadFromFile(const fname: string): Integer;
  end;

  //�z����F�����ƕ�����̍������\
  TArrayOfByte = array of Byte;
  TMArray = class(TMVarCustom)
  private
    list: TList;
    function getValue(Index: Integer): TMVarCustom;
    procedure setValue( Index: Integer; v: TMVarCustom );
    function getInt(Index: Integer): Integer;
    procedure setInt(Index: Integer; v: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add( v: TMVarCustom ): Integer;
    procedure Delete( Index: Integer);
    function AddInt( v: Integer): Integer;
    property Items[Index: Integer]: TMVarCustom read getValue write setValue;
    property IntItems[ Index: Integer]: Integer read getInt write setint;
    function AddArray(v: TMArray): Integer;
    function Count: Integer;
    function clone: TMVarCustom; override;
    procedure Assign(c: TMVarCustom); override;
    procedure AssignToArrayOfByte(var ary: TArrayOfByte);
    function StrValue: string; override;
    procedure Insert(Index: Integer; value: TMVarCustom);
    procedure SortStr;
    procedure SortNum;
  end;

  //----------------------------------------------------------------------------
  //���s�\�[�X����
  TSrcPos = class
    src: string; //�ꎞ�I�ȃ\�[�X�L���̈�
  public
    ptr: PChar; //���s���̃|�C���^������
    lineNo: Integer;
    fileNo: Integer;
    cmd: string; //���s���̃R�}���h��
    procedure Assign(v: TSrcPos);
    procedure SetTempSource(s: string);
  end;

  //----------------------------------------------------------------------------
  //�V�X�e���֐�
  TMFuncObj = function (var sp: TSrcPos): TMVarCustom of Object;//��{�^

  TMFunc = class(TMVarCustom)
  public
    funcPtr: TMFuncObj;
    function Execute( var sp: TSrcPos ): TMVarCustom;
    function clone: TMVarCustom; override;
  end;

  TArrayStr = array of string;

  TMUserFunc = class(TMVarCustom)
  public
    ArgType: string;
    ArgName: TArrayStr;
    ArgInit: TMArray;
    Src: TSrcPos;
    constructor Create;
    destructor Destroy; override;
    function clone: TMVarCustom; override;
  end;

  //----------------------------------------------------------------------------
  //�ϐ��Ǘ�
  TMNodeType = (ntInt, ntStr, ntArray, ntSysFunc, ntUserFunc);
  TMHashNode = class(THashNode)
  public
    DefinePos: TSrcPos;//�錾���ꂽ�ꏊ������
    nodeType: TMNodeType;
    value: TMVarCustom;
    tag: Integer;
    constructor Create(key: string);
    destructor Destroy; override;
  end;

  TMVarHash = class(THash)
  protected
    function GetValue(key: string): TMHashNode;
  public
    Parent: TMVarHash;
    property Items[key: string]: TMHashNode read GetValue;
    function ExistsLocalKey(key: string): Boolean;//���[�J���G���A�ɓ����̃L�[���Ȃ����`�F�b�N
  end;

  //----------------------------------------------------------------------------
  //�X�N���v�g�K�w�N���X
  TMStructType = (stNormal, stFunction, stFor, stLoop, stWhile, stIf, stSwitch);

  TMStruct = class
  public
    Parent: TMStruct;
    StructType: TMStructType;
    PosFrom,
    PosTo: TSrcPos;//While For �ȂǂŎ��s�͈͂�����(Create �Ő���)
    PosElse: TSrcPos;//IF �� FALSE �ȂǂŎ��s�͈͂�����(If �̎��������������)
    LoopIndex: Integer;
    LoopCount: Integer;
    Jouken, siki1, siki2: string;
    varHash: TMVarHash ; //���̊K�w�́ACommands���o���Ă���
    constructor Create(parent: TMStruct; tp: TMStructType);
    destructor Destroy; override;
  end;

var
  OnProgress: TMmlOnProgress; //--- PROGRESS

implementation


{ TMVarHash }

function TMVarHash.ExistsLocalKey(key: string): Boolean;
begin
    if nil = TMHashNode( Self.Find( key ) ) then
        Result := False
    else
        Result := True;
end;

function TMVarHash.GetValue(key: string): TMHashNode;
begin
    Result := TMHashNode( Self.Find( key ) );
    if Result=nil then
    begin
        //�ċN�I�ɐe�𒲂ׂ�
        if Self.Parent = nil then Exit;
        Result := Self.Parent.GetValue( key );
    end;
end;


{ TSrcPos }

procedure TSrcPos.Assign(v: TSrcPos);
begin
    ptr := v.ptr;
    lineNo := v.lineNo;
    fileNo := v.fileNo;
    src := v.src;
    cmd := v.cmd ;
end;

procedure TSrcPos.SetTempSource(s: string);
begin
    src := s;
    ptr := PChar(src);
end;

{ TMArray }

function TMArray.Add(v: TMVarCustom): Integer;
begin
    Result := list.Add(v);
end;

function TMArray.AddArray(v: TMArray): Integer;
var
    i,c: Integer;
    vc: TMVarCustom;
begin
    c := Count;
    Result := c + v.Count;
    list.Count := Result;
    for i:=0 to v.Count -1 do
    begin
        vc := v.Items[i];
        if vc<>nil then
            Items[c + i] := vc.clone
        else
            Items[c + i] := nil;
    end;
end;

function TMArray.AddInt(v: Integer): Integer;
var
    i: TMInt;
begin
     i := TMInt.Create ;
     i.value := v;
     Result := Add(i);
end;

procedure TMArray.Assign(c: TMVarCustom);
begin
    inherited;
    Self.Clear ;
    Self.AddArray(c as TMArray); 
end;

procedure TMArray.AssignToArrayOfByte(var ary: TArrayOfByte);
var
    i: Integer;
begin
    if Count=0 then
    begin
        ary := nil; Exit;
    end;
    SetLength(ary, Count);
    for i:=0 to Count-1 do
    begin
        ary[i] := Byte( IntItems[ i ] );
    end;
end;

procedure TMArray.Clear;
var
    i: Integer;
    v: TMVarCustom ;
begin
    for i:=0 to list.Count -1 do
    begin
        v := list.Items[i];
        if v<> nil then v.Free ;
    end;
    list.Clear ;
end;

function TMArray.clone: TMVarCustom;
begin
    Result := TMArray.Create ;
    TMArray(Result).Assign(Self); 
end;

function TMArray.Count: Integer;
begin
    Result := list.Count ;
end;

constructor TMArray.Create;
begin
    list := TList.Create ;
end;

procedure TMArray.Delete(Index: Integer);
begin
    list.Delete(Index);
end;

destructor TMArray.Destroy;
begin
    Clear;
    list.Free ;
    inherited;
end;

function TMArray.getInt(Index: Integer): Integer;
var v: TMVarCustom;
begin
    Result := 0;
    v := Items[Index];
    if v<>nil then
    if v.ClassType = TMInt then
    begin
        Result := (v as TMInt).value ;
    end;
end;

function TMArray.getValue(Index: Integer): TMVarCustom;
begin
    if ( Index < 0) or ( Index >= list.Count ) then
    begin
        Result := nil;
    end else
        Result := list.Items[Index];
end;

procedure TMArray.Insert(Index: Integer; value: TMVarCustom);
begin
    list.Insert(Index, value); 
end;

procedure TMArray.setInt(Index, v: Integer);
var vc: TMVarCustom;
begin
    vc := Items[Index];
    if vc<>nil then vc.Free ;
    vc := TMInt.Create ;
    TMInt(vc).value := v;
    Items[Index] := vc;
end;

procedure TMArray.setValue(Index: Integer; v: TMVarCustom);
begin
    if Index >= list.Count then
    begin
        list.Count := Index+1;
    end;
    list.Items[ Index ] := v;
end;


function sort_num(Item1, Item2: Pointer): Integer;
var
  i1, i2: TMVarCustom;
begin
  i1 := TMVarCustom(Item1);
  i2 := TMVarCustom(Item2);

  Result := i1.IntValue - i2.IntValue ;
end;
function sort_str(Item1, Item2: Pointer): Integer;
var
  i1, i2: TMVarCustom;
begin
  i1 := TMVarCustom(Item1);
  i2 := TMVarCustom(Item2);

  Result := AnsiCompareStr(i1.StrValue, i2.StrValue) ;
end;
procedure TMArray.SortNum;
begin
  list.Sort(sort_num);
end;
procedure TMArray.SortStr;
begin
  list.Sort(sort_str);
end;

function TMArray.StrValue: string;
var
    i: Integer;
    o: TMVarCustom ;
begin
    Result := '';
    for i:=0 to Count-1 do
    begin
        o := Items[i];
        if o <> nil then
            Result := Result + o.StrValue ;
        if (i <> Count-1) then
            Result := Result + ', ';
    end;
end;

{ TMFunc }

function TMFunc.clone: TMVarCustom;
begin
    Result := TMFunc.Create ;
    TMFunc(Result).funcPtr := Self.funcPtr ;
end;

function TMFunc.Execute(var sp: TSrcPos): TMVarCustom;
begin
    Result := funcPtr(sp);
end;

{ TMInt }

procedure TMInt.Assign(c: TMVarCustom);
begin
    inherited;
    value := TMInt(c).value;
    Flag := TMInt(c).Flag;
end;

function TMInt.clone: TMVarCustom;
begin
    Result := TMInt.Create ;
    TMInt(Result).Assign(Self);
end;


function TMInt.IntValue: Integer;
begin
    Result := value;
end;

function TMInt.StrValue: string;
begin
    Result := IntToStr(value);
end;

{ TMStr }

procedure TMStr.Assign(c: TMVarCustom);
begin
    inherited;
    value := TMStr(c).value;
end;

function TMStr.clone: TMVarCustom;
begin
    Result := TMStr.Create ;
    TMStr(Result).value := value;
end;

function TMStr.IntValue: Integer;
begin
    Result := StrToIntDef(value, 0);
end;

function TMStr.LoadFromFile(const fname: string): Integer;
var
    s: TStringList;
begin
    s := TStringList.Create ;
    try
    try
        s.LoadFromFile(fname);
        value := s.Text ;
        Result := s.Count ;
    except
        Result := -1;
    end;
    finally
        s.Free ;
    end;
end;

function TMStr.StrValue: string;
begin
    Result := value;
end;

{ TMVarCustom }

procedure TMVarCustom.Assign(c: TMVarCustom);
begin
    if c.ClassType <> ClassType then raise EInvalidOperation.Create('Assign�ł��܂���B');
end;

function TMVarCustom.IntValue: Integer;
begin
    Result := 0;
end;

function TMVarCustom.StrValue: string;
begin
    Result := '';
end;

{ TMUserFunc }

function TMUserFunc.clone: TMVarCustom;
begin
    Result := TMUserFunc.Create ;
    TMUserFunc(Result).Src := Src ;
    TMUserFunc(Result).ArgType := ArgType ;

    if ArgInit<> nil then
        TMUserFunc(Result).ArgInit := ArgInit.clone as TMArray
    else
        TMUserFunc(Result).ArgInit := nil;

    if ArgName <> nil then
        TMUserFUnc(Result).ArgName := Copy(ArgName,0, Length(ArgName));

end;

constructor TMUserFunc.Create;
begin
    ArgName := nil;
    ArgInit := TMArray.Create ;
    Src := TSrcPos.Create ;
end;

destructor TMUserFunc.Destroy;
begin
    if ArgInit <> nil then ArgInit.Free;
    Src.Free ;
  inherited;
end;

{ TMStruct }

constructor TMStruct.Create(parent: TMStruct; tp: TMStructType);
begin
    StructType := tp;

    //�K�w�\�����L�����邽�߂ɕK�v�Ȉʒu�N���X����
    PosFrom := TSrcPos.Create ;
    PosTo := TSrcPos.Create ;
    if tp = stIf then
    begin
        PosElse := TSrcPos.Create ;
    end;
    //�ϐ����Ǘ�����n�b�V���𐶐�
    varHash := TMVarHash.Create ;

    //�e�Ǝq�����т���
    Self.Parent := parent; //Self�e
    if parent<>nil then
    begin
        varHash.Parent := parent.varHash ;//�ϐ��Ǘ��p�̐e
    end;

    //���[�v�񐔋L���p
    LoopCount := 0;
    LoopIndex := -1;

end;

destructor TMStruct.Destroy;
begin
    //varHash�́A�j��������ACommands�̒l��t���ւ���K�v������
    varHash.Free ;
    PosFrom.Free ;
    PosTo.Free ;
    if StructType = stIf then
    begin
        PosElse.Free ;
    end;

    inherited;
end;

{ TMHashNode }

constructor TMHashNode.Create(key: string);
begin
    inherited Create(key);
    DefinePos := TSrcPos.Create ;
    value := nil;
end;

destructor TMHashNode.Destroy;
begin
    DefinePos.Free ;
    if value <> nil then value.Free ;
    inherited;
end;

end.
