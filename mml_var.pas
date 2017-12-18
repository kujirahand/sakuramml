unit mml_var;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 https://sakuramml.com
説　明：サクラの基本型タイプを宣言しているユニット
　　　　（設計的にはどうかなぁ・・・、コンパイル速度を下げている原因かも。要調査）
履　歴：

2002/06/03 15:13 雛型作成
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
  //基本型（数値、文字、配列）
  TMVarCustom = class
    function clone: TMVarCustom; virtual; abstract;
    procedure Assign(c: TMVarCustom); virtual;
    function IntValue: Integer; virtual;
    function StrValue: string; virtual;
  end;

  //4ビット整数
  TMInt = class(TMVarCustom)
  public
    Flag: Char; // % など、数値の前に付くMML特有のフラグを保持する
    value: Integer;
    function clone: TMVarCustom; override;
    procedure Assign(c: TMVarCustom); override;
    function IntValue: Integer; override;
    function StrValue: string; override;
  end;

  //文字列型
  TMStr = class(TMVarCustom)
  public
    value: string;
    function clone: TMVarCustom; override;
    procedure Assign(c: TMVarCustom); override;
    function IntValue: Integer; override;
    function StrValue: string; override;
    function LoadFromFile(const fname: string): Integer;
  end;

  //配列方：整数と文字列の混同が可能
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
  //実行ソース制御
  TSrcPos = class
    src: string; //一時的なソース記憶領域
  public
    ptr: PChar; //実行中のポインタをさす
    lineNo: Integer;
    fileNo: Integer;
    cmd: string; //実行中のコマンド名
    procedure Assign(v: TSrcPos);
    procedure SetTempSource(s: string);
  end;

  //----------------------------------------------------------------------------
  //システム関数
  TMFuncObj = function (var sp: TSrcPos): TMVarCustom of Object;//基本型

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
  //変数管理
  TMNodeType = (ntInt, ntStr, ntArray, ntSysFunc, ntUserFunc);
  TMHashNode = class(THashNode)
  public
    DefinePos: TSrcPos;//宣言された場所を示す
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
    function ExistsLocalKey(key: string): Boolean;//ローカルエリアに同名のキーがないかチェック
  end;

  //----------------------------------------------------------------------------
  //スクリプト階層クラス
  TMStructType = (stNormal, stFunction, stFor, stLoop, stWhile, stIf, stSwitch);

  TMStruct = class
  public
    Parent: TMStruct;
    StructType: TMStructType;
    PosFrom,
    PosTo: TSrcPos;//While For などで実行範囲を示す(Create で生成)
    PosElse: TSrcPos;//IF の FALSE などで実行範囲を示す(If の時だけ生成される)
    LoopIndex: Integer;
    LoopCount: Integer;
    Jouken, siki1, siki2: string;
    varHash: TMVarHash ; //その階層の、Commandsを覚えておく
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
        //再起的に親を調べる
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
    if c.ClassType <> ClassType then raise EInvalidOperation.Create('Assignできません。');
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

    //階層構造を記憶するために必要な位置クラス生成
    PosFrom := TSrcPos.Create ;
    PosTo := TSrcPos.Create ;
    if tp = stIf then
    begin
        PosElse := TSrcPos.Create ;
    end;
    //変数を管理するハッシュを生成
    varHash := TMVarHash.Create ;

    //親と子を結びつける
    Self.Parent := parent; //Self親
    if parent<>nil then
    begin
        varHash.Parent := parent.varHash ;//変数管理用の親
    end;

    //ループ回数記憶用
    LoopCount := 0;
    LoopIndex := -1;

end;

destructor TMStruct.Destroy;
begin
    //varHashは、破棄したら、Commandsの値を付け替える必要がある
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
