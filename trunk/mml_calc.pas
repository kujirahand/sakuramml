unit mml_calc;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 http://www.text2music.com
説　明：計算の下請けをするクラス。計算速度や、効率は悪いけれど、
　　　　分かりやすくするために、演算子ごとクラスに分けてみた
履　歴：

2002/06/03 15:13 雛型作成
-------------------------------------------------------------------------------}

interface
uses
  SysUtils,
  Classes,
  mml_const,
  mml_error,
  mml_var;

type
  //----------------------------------------------------------------------------
  // 計算式に用いるクラス
  TMCalc = class(TMVarCustom)
  public
    value: string;
    function Calc(a, b: TMVarCustom): TMVarCustom; virtual;
    function clone: TMVarCustom; override;
  end;

  TMPlus = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;

  TMMinus = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;

  TMMul = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;

  TMDiv = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;

  TMMod = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;

  TMEqual = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;
  TMNotEqual = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;
  TMGreat = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;
  TMSmall = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;
  TMGreatEqual = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;
  TMSmallEqual = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;
  TMAnd = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;
  TMOr = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;
  TMXor = class(TMCalc)
  public
    function Calc(a, b: TMVarCustom): TMVarCustom; override;
  end;

  //----------------------------------------------------------------------------
  //適当なスタック
  TMStack = class(TList)
  public
    procedure Clear; override;
    function GetFirst: TMVarCustom;
    function Pop: TMVarCustom;
    procedure Push(v: TMVarCustom);
  end;

  //----------------------------------------------------------------------------
  //計算式を行う
  function CreateEnzansi(s: string): TMCalc;
  function CalcTMStack(stack: TMStack): TMVarCustom;

implementation



{ TMStack }


procedure TMStack.Clear;
var
    i: Integer;
    m: TMVarCustom;
begin
    for i:=0 to Count-1 do
    begin
        m := Items[i];
        if m<>nil then m.Free ;
    end;
    inherited Clear;
end;

function TMStack.GetFirst: TMVarCustom;
begin
    Result := nil;
    if Count=0 then Exit;
    Result := Items[0];
    Self.Delete(0); 
end;

function TMStack.Pop: TMVarCustom;
begin
    Result := nil;
    if Count=0 then Exit;
    Result := Items[Count-1];
    Self.Delete(Count-1);
end;

procedure TMStack.Push(v: TMVarCustom);
begin
    Self.Add(v);
end;

{ TMPlus }

function TMPlus.Calc(a, b: TMVarCustom): TMVarCustom;
var
    s1,s2: string;
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
            TMArray(Result).AddArray(b as TMArray)
        else
            TMArray(Result).Add(b);
        Exit;
    end;

    if a.ClassType = TMInt then
    begin
        Result := TMInt.Create ;
        TMInt(Result).value := a.IntValue + b.IntValue ;
    end else if a.ClassType = TMStr then
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


{ TMMinus }

function TMMinus.Calc(a, b: TMVarCustom): TMVarCustom;
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

    if a.ClassType = TMInt then
    begin
        Result := TMInt.Create ;
        TMInt(Result).value := a.IntValue - b.IntValue ;
    end else if a.ClassType = TMStr then
    begin
        raise EInvalidOperation.Create('文字列同士の引き算は出来ません。');
    end else
    begin
        Result := nil;
    end;
end;

{ TMMul }

function TMMul.Calc(a, b: TMVarCustom): TMVarCustom;
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

    if a.ClassType = TMInt then
    begin
        Result := TMInt.Create ;
        TMInt(Result).value := Integer(a.IntValue * b.IntValue) ;
    end else if a.ClassType = TMStr then
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

function TMDiv.Calc(a, b: TMVarCustom): TMVarCustom;
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

    if a.ClassType = TMInt then
    begin
        Result := TMInt.Create ;
        if b.IntValue<>0 then
            TMInt(Result).value := a.IntValue div b.IntValue 
        else
            TMInt(Result).value := 0;
    end else if a.ClassType = TMStr then
    begin
        raise EInvalidOperation.Create('文字列同士の引き算は出来ません。');
    end else
    begin
        Result := nil;
    end;
end;

{ TMMod }

function TMMod.Calc(a, b: TMVarCustom): TMVarCustom;
begin
    if (a=nil)or(b=nil) then
    begin
        Result := nil;
        Exit;
    end;

    if a.ClassType = TMInt then
    begin
        Result := TMInt.Create ;
        try
            TMInt(Result).value := a.IntValue mod b.IntValue ;
        except
            TMInt(Result).value := 0;
        end;
    end else if a.ClassType = TMStr then
    begin
        raise EInvalidOperation.Create('文字列を使って余りを求めることはできません。');
    end else
    begin
        Result := nil;
    end;
end;

{ TMEqual }

function TMEqual.Calc(a, b: TMVarCustom): TMVarCustom;
begin
    Result := TMInt.Create ;

    if (a=nil)and(b=nil) then
    begin
        TMInt(Result).value := BOOL_TRUE; Exit;
    end else
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
        begin
            if b.StrValue = '' then
                TMInt(Result).value := BOOL_TRUE
            else
                TMInt(Result).value := BOOL_FALSE;
        end;
        if b=nil then
        begin
            if a.StrValue = '' then
                TMInt(Result).value := BOOL_TRUE
            else
                TMInt(Result).value := BOOL_FALSE;
        end;
        Exit;
    end;

    if a.ClassType = TMArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.ClassType = TMInt then
    begin
        if a.IntValue = b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.ClassType = TMStr then
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

function TMNotEqual.Calc(a, b: TMVarCustom): TMVarCustom;
begin
    Result := TMInt.Create ;

    if (a=nil)and(b=nil) then
    begin
        TMInt(Result).value := BOOL_FALSE; Exit;
    end else
    if (a=nil)or(b=nil) then
    begin
        if a=nil then
        begin
            if b.StrValue = '' then
                TMInt(Result).value := BOOL_FALSE
            else
                TMInt(Result).value := BOOL_TRUE;
        end;
        if b=nil then
        begin
            if a.StrValue = '' then
                TMInt(Result).value := BOOL_FALSE
            else
                TMInt(Result).value := BOOL_TRUE;
        end;
        Exit;
    end;

    if a.ClassType = TMArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.ClassType = TMInt then
    begin
        if a.IntValue <> b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.ClassType = TMStr then
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

function TMGreat.Calc(a, b: TMVarCustom): TMVarCustom;
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

    if a.ClassType = TMArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.ClassType = TMInt then
    begin
        if a.IntValue > b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.ClassType = TMStr then
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

function TMSmall.Calc(a, b: TMVarCustom): TMVarCustom;
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

    if a.ClassType = TMArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.ClassType = TMInt then
    begin
        if a.IntValue < b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.ClassType = TMStr then
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

function TMGreatEqual.Calc(a, b: TMVarCustom): TMVarCustom;
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

    if a.ClassType = TMArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.ClassType = TMInt then
    begin
        if a.IntValue >= b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.ClassType = TMStr then
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

function TMSmallEqual.Calc(a, b: TMVarCustom): TMVarCustom;
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

    if a.ClassType = TMArray then
    begin
        raise EInvalidOperation.Create('配列と配列を比較することはできません。');
    end;

    if a.ClassType = TMInt then
    begin
        if a.IntValue <= b.IntValue then
            TMInt(Result).value := BOOL_TRUE
        else
            TMInt(Result).value := BOOL_FALSE;
    end else if a.ClassType = TMStr then
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
         if s='*'  then Result := TMMul.Create
    else if s='/'  then Result := TMDiv.Create
    else if s='+'  then Result := TMPlus.Create
    else if s='-'  then Result := TMMinus.Create
    else if s='='  then Result := TMEqual.Create
    else if s='%'  then Result := TMMod.Create
    else if s='>'  then Result := TMGreat.Create
    else if s='<'  then Result := TMSmall.Create
    else if s='<>' then Result := TMNotEqual.Create
    else if s='><' then Result := TMNotEqual.Create
    else if s='!=' then Result := TMNotEqual.Create
    else if s='>=' then Result := TMGreatEqual.Create
    else if s='=>' then Result := TMGreatEqual.Create
    else if s='<=' then Result := TMSmallEqual.Create
    else if s='=<' then Result := TMSmallEqual.Create
    else if s='==' then Result := TMEqual.Create
    else if s='&'  then Result := TMAnd.Create
    else if s='&&' then Result := TMAnd.Create
    else if s='|'  then Result := TMOr.Create
    else if s='||' then Result := TMOr.Create
    else if s='^'  then Result := TMXor.Create
    else Result := nil;
end;



//スタック上に積まれた式を計算する
function CalcTMStack(stack: TMStack): TMVarCustom;
var
  ch: TMVarCustom ;
  i: Integer;

  procedure Keisan(Idx: Integer);
  var a, b: TMVarCustom;
  begin
    a := stack.Items[idx-1];
    b := stack.Items[idx+1];
    stack.Items[idx-1] := TMCalc(ch).Calc(a, b);
    stack.Delete(idx);
    stack.Delete(idx);
  end;

  procedure Kakezan;
  begin
    i := 0;
    while i < stack.Count do
    begin
      ch := stack.Items[i];
      if (ch.ClassType = TMMul)or(ch.ClassType = TMDiv)or(ch.ClassType = TMMod) then
        Keisan(i) else Inc(i);
    end;
  end;

  procedure Tasizan;
  begin
    i := 0;
    while i < stack.Count do
    begin
      ch := stack.Items[i];
      if (ch.ClassType = TMPlus)or(ch.ClassType = TMMinus) then
        Keisan(i) else Inc(i);
    end;
  end;

  procedure Hikaku;
  begin
    i := 0;
    while i < stack.Count do
    begin
      ch := stack.Items[i];
      if (ch.ClassType = TMEqual)or(ch.ClassType = TMNotEqual)or
         (ch.ClassType = TMGreat)or(ch.ClassType = TMGreatEqual)or
         (ch.ClassType = TMSmall)or(ch.ClassType = TMSmallEqual) then
        Keisan(i) else Inc(i);
    end;
  end;

  procedure AndOrXor;
  begin
    i := 0;
    while i < stack.Count do
    begin
      ch := stack.Items[i];
      if (ch.ClassType = TMAnd)or(ch.ClassType = TMOr)or(ch.ClassType = TMXor) then
        Keisan(i) else Inc(i);
    end;
  end;

begin
    Result := nil;
    if stack=nil then Exit;
    if stack.Count = 0 then Exit;
    if stack.Count = 1 then begin
        Result := TMVarCustom(stack.Items[0]).clone;
        Exit;
    end;

    try
      Kakezan;
      Tasizan;
      Hikaku;
      AndOrXor;
      Result := TMVarCustom(stack.Items[0]).clone;
    except
      raise EParserError.Create('計算式が不正です。');
    end;


    //_debug((Result as TMVarCustom).StrValue);
    //raise EParserError.Create('式が不正です。演算子が足りません');
end;

{ TMCalc }

function TMCalc.Calc(a, b: TMVarCustom): TMVarCustom;
begin
    Result := nil;
end;

function TMCalc.clone: TMVarCustom;
begin
    Result := TMCalc.Create ;
end;

{ TMAnd }

function TMAnd.Calc(a, b: TMVarCustom): TMVarCustom;
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
            TMInt(Result).value := BOOL_TRUE
    end;

    if a.ClassType <> TMInt then
    begin
        raise EInvalidOperation.Create('整数以外の論理演算はできません。');
    end;

    if a.ClassType = TMInt then
    begin
        TMInt(Result).value := a.IntValue and b.IntValue;
    end;
end;

{ TMOr }

function TMOr.Calc(a, b: TMVarCustom): TMVarCustom;
begin
    Result := TMInt.Create ;

    if (a=nil)or(b=nil) then
    begin
        TMInt(Result).value := BOOL_False; Exit;
    end;

    if a.ClassType <> TMInt then
    begin
        raise EInvalidOperation.Create('整数以外の論理演算はできません。');
    end;

    if a.ClassType = TMInt then
    begin
        TMInt(Result).value := a.IntValue or b.IntValue;
    end;
end;

{ TMXor }

function TMXor.Calc(a, b: TMVarCustom): TMVarCustom;
begin
    Result := TMInt.Create ;

    if (a=nil)or(b=nil) then
    begin
        TMInt(Result).value := BOOL_False; Exit;
    end;

    if a.ClassType <> TMInt then
    begin
        raise EInvalidOperation.Create('整数以外の論理演算はできません。');
    end;

    if a.ClassType = TMInt then
    begin
        TMInt(Result).value := a.IntValue xor b.IntValue;
    end;
end;

end.
