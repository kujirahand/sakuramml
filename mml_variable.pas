unit mml_variable;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 http://www.text2music.com
説　明：スクリプトで用いる基本型

履　歴：

2002/06/03 15:13 雛型作成
-------------------------------------------------------------------------------}

interface

uses
  SysUtils,
  Classes,
  hashUnit,
  mml_const,
  mml_error;

type
  //----------------------------------------------------------------------------
  TIntArray  = array of Integer;
  TPtrArray  = array of Pointer;

  //----------------------------------------------------------------------------
  // MML スクリプトの基本型

  TMVarType = (typeNil, typeInt, typeStr, typeArray, typeFunc, typeUserFunc, typeCalc);

  TMVariable = class
  public
    flag: Char;
    varType: TMVarType;
    constructor Create;
    function clone: TMVariable; virtual;
  end;

  TMBasicVar = class(TMVariable)//演算を容易にするメソッドを備えたクラス
  public
    function IntValue: Integer; virtual;
    function StrValue: string; virtual;
  end;

  TMStr = class(TMBasicVar)
  public
    value: string;
    constructor Create;
    function IntValue: Integer; override;
    function StrValue: string; override;
    function clone: TMVariable; override;
  end;

  TMInt = class(TMBasicVar)
  public
    value: Integer;
    constructor Create;
    function IntValue: Integer; override;
    function StrValue: string; override;
    function clone: TMVariable; override;
  end;

  TMVarArray = array of TMVariable;

  TMArray = class(TMBasicVar)
  private
    function GetValue(Index: Integer): TMVariable;
    procedure SetValue(Index: Integer; val: TMVariable);
  public
    value: TMVarArray;
    constructor Create;
    destructor Destroy; override;
    property Items[Index: Integer]: TMVariable read GetValue write SetValue;
    function Count: Integer;
    function Add(v:TMVariable): Integer;
    function AddArray(v: TMArray): Integer;
    function clone: TMVariable; override;
    function IntValue: Integer; override;
    function StrValue: string; override;
  end;



  //----------------------------------------------------------------------------
  // 関数、変数などを管理するハッシュクラス

  TMVarNode = class(THashNode)
  public
    value: TMVariable;
  end;


  //----------------------------------------------------------------------------
  // 計算式に用いるクラス

  TMCalc = class(TMVariable)
  public
    value: string;
    constructor Create;
    function Calc(a, b: TMBasicVar): TMVariable; virtual; abstract;
  end;

  TMPlus = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;

  TMMinus = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;

  TMMul = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;

  TMDiv = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;

  TMMod = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;

  TMEqual = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;
  TMNotEqual = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;
  TMGreat = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;
  TMSmall = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;
  TMGreatEqual = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;
  TMSmallEqual = class(TMCalc)
  public
    function Calc(a, b: TMBasicVar): TMVariable; override;
  end;

  //----------------------------------------------------------------------------
  //適当なスタック
  TMStack = class(TList)
  public
    procedure Clear; override;
    function GetFirst: TMVariable;
    function Pop: TMVariable;
    procedure Push(v: TMVariable);
  end;

  function CreateEnzansi(s: string): TMCalc;
  function CalcTMStack(stack: TMStack): TMVariable;


implementation


{ TMArray }

function TMArray.Add(v: TMVariable): Integer;
var
    i: Integer;
begin
    i := Length(value);
    SetLength( value, (i+1) );
    value[i] := v;
    Result := i;
end;

function TMArray.AddArray(v: TMArray): Integer;
var
    i, len1,len2 : Integer;
begin
    len1 := Count;
    len2 := v.Count;

    Result := len1 + len2;

    SetLength(value, Result);
    for i:=0 to len2-1 do
    begin
        value[ len1 + i ] := v.Items[i];
    end;
end;

function TMArray.clone: TMVariable;
begin
    with Result do begin
        Result := TMArray.Create ;
        varType := Self.varType;
        flag := Self.flag ;
        TMArray(Result).value := Copy(self.value, 0, Self.Count);
    end;
end;

function TMArray.Count: Integer;
begin
    Result := Length(value);
end;

constructor TMArray.Create;
begin
    inherited Create;
    varType := typeArray;
    value := nil;
end;

destructor TMArray.Destroy;
var
    i: Integer;
    n: TMVariable;
begin
    if value<>nil then
    begin
        for i:=0 to High(value) do
        begin
            n := value[i];
            if n<>nil then n.Free ;
        end;
    end;
    inherited;
end;

function TMArray.GetValue(Index: Integer): TMVariable;
begin
    if Index >= Length(value) then
    begin
        Result := nil; Exit;
    end;
    Result := value[Index];
end;

function TMArray.IntValue: Integer;
begin
    Result := Count ;
end;

procedure TMArray.SetValue(Index: Integer; val: TMVariable);
begin
    if Index >= Length(value) then
    begin
        SetLength(value, (Index+1));
    end;
    value[Index] := val;
end;

{ TMVarNode }


function TMArray.StrValue: string;
var
    i: Integer;
    v: TMBasicVar;
begin
    Result := '';
    for i:=0 to Count-1 do
    begin
        if value[i] <> nil then
        begin
            v := TMBasicVar(value[i]);
            if v.ClassType = TMStr then
            begin
                Result := Result + '{' + v.StrValue + '}';
            end else
            begin
                Result := Result + v.StrValue ;
            end;
            if i <> Count-1 then
                Result := Result + ', ';
        end;
    end;
    //Result := Result;
end;

{ TMVarHash }



{ TMVariable }

function TMVariable.clone: TMVariable;
begin
    with Result do begin
        Result := TMVariable.Create ;
        varType := Self.varType;
        flag := Self.flag ;
    end;
end;

constructor TMVariable.Create;
begin
    flag := #0;
end;


{ TMStr }

function TMStr.clone: TMVariable;
begin
    Result := TMStr.Create ;
    Result.varType := Self.varType;
    Result.flag := Self.flag ;
    TMStr(Result).value := Self.value ;
end;

constructor TMStr.Create;
begin
    inherited Create;
    varType := typeStr;
end;

function TMStr.IntValue: Integer;
begin
    Result := StrToIntDef(value, 0);
end;

function TMStr.StrValue: string;
begin
    Result := value;
end;

{ TMInt }

function TMInt.clone: TMVariable;
begin
    with Result do begin
        Result := TMInt.Create ;
        varType := Self.varType;
        flag := Self.flag ;
        TMInt(Result).value := Self.value ;
    end;
end;

constructor TMInt.Create;
begin
    inherited Create;
    varType := typeInt;
end;

function TMInt.IntValue: Integer;
begin
    Result := value;
end;

function TMInt.StrValue: string;
begin
    Result := IntToStr(value);
end;


{ TMStack }


procedure TMStack.Clear;
var
    i: Integer;
    m: TMVariable;
begin
    for i:=0 to Count-1 do
    begin
        m := Items[i];
        if m<>nil then m.Free ;
    end;
    inherited Clear;
end;

function TMStack.GetFirst: TMVariable;
begin
    Result := nil;
    if Count=0 then Exit;
    Result := Items[0];
    Self.Delete(0); 
end;

function TMStack.Pop: TMVariable;
begin
    Result := nil;
    if Count=0 then Exit;
    Result := Items[Count-1];
    Self.Delete(Count-1);
end;

procedure TMStack.Push(v: TMVariable);
begin
    Self.Add(v);
end;

{ TMPlus }

function TMPlus.Calc(a, b: TMBasicVar): TMVariable;
var
    s1,s2: string;
begin
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
            if b=nil then Result := nil else Result := b.clone
        else
            Result := a.clone ;
        Exit;
    end;

    //どちらかが配列なら、配列を加算する
    if (a.ClassType = TMArray) then
    begin
        Result := TMArray.Create ;

        if b.ClassType = TMArray then
            TMArray(Result).AddArray(b as TMArray)
        else
            TMArray(Result).Add(b);
        Exit;
    end;

    if a.varType = typeInt then
    begin
        Result := TMInt.Create ;
        TMInt(Result).value := a.IntValue + b.IntValue ;
    end else if a.varType = typeStr then
    begin
        Result := a.clone ;
        s1 := a.StrValue ;
        s2 := b.StrValue ;
        (Result as TMStr).value := s1 + s2;
    end else
    begin
        Result := nil;
    end;
end;


{ TMBasicVar }

function TMBasicVar.IntValue: Integer;
begin
    Result := 0;
end;

function TMBasicVar.StrValue: string;
begin
    Result := '';
end;

{ TMMinus }

function TMMinus.Calc(a, b: TMBasicVar): TMVariable;
begin
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
            if b=nil then
                Result := nil
            else
                begin
                    Result := b.clone;
                    if Result.ClassType = TMInt then
                    begin
                        TMInt(Result).value := - TMInt(Result).value;
                    end;
                end
        else
            Result := a.clone ;
        Exit;
    end;

    if a.varType = typeInt then
    begin
        Result := TMInt.Create ;
        TMInt(Result).value := a.IntValue - b.IntValue ;
    end else if a.varType = typeStr then
    begin
        raise EInvalidOperation.Create('文字列同士の引き算は出来ません。');
    end else
    begin
        Result := nil;
    end;
end;

{ TMMul }

function TMMul.Calc(a, b: TMBasicVar): TMVariable;
var
    i: Integer;
begin
    Result := nil;

    if (a=nil)or(b=nil) then
    begin
        Exit;
    end;

    //どちらかが配列なら、配列を加算する
    if (a.ClassType = TMArray) then
    begin
        Result := TMArray.Create ;

        if b.ClassType = TMArray then
            raise EInvalidOperation.Create('配列と配列を掛け合わせることは出来ません。');

        for i:=0 to b.IntValue -1 do
        begin
            TMArray(Result).AddArray(a as TMArray);
        end;
        Exit;
    end else
    if (b.ClassType = TMArray) then
    begin
        if a.ClassType = TMArray then
            raise EInvalidOperation.Create('配列と配列を掛け合わせることは出来ません。');

        for i:=0 to a.IntValue -1 do
        begin
            TMArray(Result).AddArray(b as TMArray);
        end;
        Exit;
    end;

    if a.varType = typeInt then
    begin
        Result := TMInt.Create ;
        TMInt(Result).value := a.IntValue * b.IntValue ;
    end else if a.varType = typeStr then
    begin
        Result := TMStr.Create ;
        for i:=0 to b.IntValue -1 do
        begin
            TMStr(Result).value := TMStr(Result).value + a.StrValue;
        end;
    end else
    begin
        Result := nil;
    end;
end;

{ TMDiv }

function TMDiv.Calc(a, b: TMBasicVar): TMVariable;
begin
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
            if b=nil then
                Result := nil
            else
                begin
                    Result := b.clone;
                end
        else
            Result := a.clone ;
        Exit;
    end;

    if a.varType = typeInt then
    begin
        Result := TMInt.Create ;
        try
            TMInt(Result).value := a.IntValue div b.IntValue ;
        except
            TMInt(Result).value := 0;
        end;
    end else if a.varType = typeStr then
    begin
        raise EInvalidOperation.Create('文字列同士の引き算は出来ません。');
    end else
    begin
        Result := nil;
    end;
end;

{ TMMod }

function TMMod.Calc(a, b: TMBasicVar): TMVariable;
begin
    if (a=nil)or(b=nil) then
    begin
        Result := nil;
        Exit;
    end;

    if a.varType = typeInt then
    begin
        Result := TMInt.Create ;
        try
            TMInt(Result).value := a.IntValue mod b.IntValue ;
        except
            TMInt(Result).value := 0;
        end;
    end else if a.varType = typeStr then
    begin
        raise EInvalidOperation.Create('文字列を使って余りを求めることはできません。');
    end else
    begin
        Result := nil;
    end;
end;

{ TMEqual }

function TMEqual.Calc(a, b: TMBasicVar): TMVariable;
begin
    Result := TMInt.Create ;

    if (a=nil)and(b=nil) then
    begin
        TMInt(Result).value := BOOL_TRUE; Exit;
    end else
    if (a=nil)or(b=nil) then
    begin
        TMInt(Result).value := BOOL_FALSE; Exit;
    end;

    if a.varType = typeArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.varType = typeInt then
    begin
        if a.IntValue = b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.varType = typeStr then
    begin
        if a.StrValue = b.StrValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else
    begin
        Result := nil;
    end;
end;

{ TMNotEqual }

function TMNotEqual.Calc(a, b: TMBasicVar): TMVariable;
begin
    Result := TMInt.Create ;

    if (a=nil)and(b=nil) then
    begin
        TMInt(Result).value := BOOL_FALSE; Exit;
    end else
    if (a=nil)or(b=nil) then
    begin
        TMInt(Result).value := BOOL_TRUE; Exit;
    end;

    if a.varType = typeArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.varType = typeInt then
    begin
        if a.IntValue <> b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.varType = typeStr then
    begin
        if a.StrValue <> b.StrValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else
    begin
        Result := nil;
    end;

end;

{ TMGreat }

function TMGreat.Calc(a, b: TMBasicVar): TMVariable;
begin
    Result := TMInt.Create ;

    if (a=nil)and(b=nil) then
    begin
        TMInt(Result).value := BOOL_FALSE; Exit;
    end else
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE
    end;

    if a.varType = typeArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.varType = typeInt then
    begin
        if a.IntValue > b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.varType = typeStr then
    begin
        if a.StrValue > b.StrValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else
    begin
        Result := nil;
    end;

end;

{ TMSmall }

function TMSmall.Calc(a, b: TMBasicVar): TMVariable;
begin
    Result := TMInt.Create ;

    if (a=nil)and(b=nil) then
    begin
        TMInt(Result).value := BOOL_FALSE; Exit;
    end else
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
            TMInt(Result).value := BOOL_FALSE
        else
            TMInt(Result).value := BOOL_TRUE
    end;

    if a.varType = typeArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.varType = typeInt then
    begin
        if a.IntValue < b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.varType = typeStr then
    begin
        if a.StrValue < b.StrValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else
    begin
        Result := nil;
    end;


end;

{ TMGreatEqual }

function TMGreatEqual.Calc(a, b: TMBasicVar): TMVariable;
begin
    Result := TMInt.Create ;

    if (a=nil)and(b=nil) then
    begin
        TMInt(Result).value := BOOL_TRUE; Exit;
    end else
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE
    end;

    if a.varType = typeArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.varType = typeInt then
    begin
        if a.IntValue >= b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.varType = typeStr then
    begin
        if a.StrValue >= b.StrValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else
    begin
        Result := nil;
    end;

end;

{ TMSmallEqual }

function TMSmallEqual.Calc(a, b: TMBasicVar): TMVariable;
begin
    Result := TMInt.Create ;

    if (a=nil)and(b=nil) then
    begin
        TMInt(Result).value := BOOL_TRUE; Exit;
    end else
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
            TMInt(Result).value := BOOL_FALSE
        else
            TMInt(Result).value := BOOL_TRUE
    end;

    if a.varType = typeArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.varType = typeInt then
    begin
        if a.IntValue <= b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.varType = typeStr then
    begin
        if a.StrValue <= b.StrValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else
    begin
        Result := nil;
    end;

end;

function CreateEnzansi(s: string): TMCalc;
begin
         if s='*' then Result := TMMul.Create
    else if s='/' then Result := TMDiv.Create
    else if s='+' then Result := TMPlus.Create
    else if s='-' then Result := TMMinus.Create
    else if s='=' then Result := TMEqual.Create
    else if s='>' then Result := TMGreat.Create
    else if s='<' then Result := TMSmall.Create
    else if s='>=' then Result := TMGreatEqual.Create
    else if s='<=' then Result := TMSmallEqual.Create
    else if s='==' then Result := TMEqual.Create
    else Result := nil;
end;

//スタック上に積まれた式を計算する
function CalcTMStack(stack: TMStack): TMVariable;
{
    function getNum: TMBasicVar;
    var v: TMVariable;
    begin
        v := stack.GetFirst ;
        if v<>nil then
        begin
            if not (v.varType in [typeInt, typeStr, typeArray]) then raise EParserError.Create('計算式で、数値が要求される個所に数値でないものがありませす。');
        end;
        Result := v as TMBasicVar;
    end;

    function getOp: TMCalc;
    var v: TMVariable;
    begin
        v := stack.GetFirst ;
        if v<>nil then
        begin
            if not (v.varType = typeCalc ) then raise EParserError.Create('計算式で、演算子が要求される演算子でないものがありませす。');
        end;
        Result := v as TMCalc;
    end;
}
    procedure CalcClass(c: TClass);
    var
        i: Integer;
        op: TMVariable;
        v1,v2,v3: TMVariable;
    begin
        i := 1;
        if stack.Count <= 1 then Exit;
        while i < stack.Count -1 do
        begin
            op := stack.Items[i];
            if op.ClassType = c then
            begin
                try
                    v1 := stack.Items[i-1];
                    v2 := stack.Items[i+1];
                except on e: Exception do
                    raise EParserError.Create('式が不正です。'+e.Message);
                end;
                if not(v1.varType in [typeInt,typeStr,typeArray]) then
                    raise EParserError.Create('計算式で、数値が要求される個所に数値でないものがありませす。');
                if not(v2.varType in [typeInt,typeStr,typeArray]) then
                    raise EParserError.Create('計算式で、数値が要求される個所に数値でないものがありませす。');
                v3 := TMCalc(op).Calc(v1 as TMBasicVar,v2 as TMBasicVar);
                v1.Free ; v2.Free ;
                stack.Items[i-1] := v3;

                stack.Delete (i);//演算子のあったところ
                stack.Delete (i);//値２のあったところ
            end else
                Inc(i);
        end;
        {if c=TMPlus then
            _debug(TMBasicVar(stack.Items[0]).StrValue);}
    end;


begin
    Result := nil;
    if stack=nil then Exit;
    if stack.Count = 0 then Exit;
    if stack.Count = 1 then begin
        Result := TMBasicVar(stack.Items[0]).clone;
        Exit;
    end;

    //美しくない計算。時間のある時に、アルゴリズムを改良すること
    CalcClass(TMMul);
    CalcClass(TMDiv);
    CalcClass(TMPlus);
    CalcClass(TMMinus);
    CalcClass(TMEqual);
    CalcClass(TMNotEqual);
    CalcClass(TMGreat);
    CalcClass(TMSmall);
    CalcClass(TMGreatEqual);
    CalcClass(TMSmallEqual);
    if stack.Count = 1 then
    begin
        Result := TMBasicVar(stack.Items[0]);
        stack.Items[0] := nil;
        //_debug((Result as TMBasicVar).StrValue);
    end else
        raise EParserError.Create('式が不正です。演算子が足りません');
end;

{ TMCalc }

constructor TMCalc.Create;
begin
    varType := typeCalc;
end;

{ TMProc }


end.
