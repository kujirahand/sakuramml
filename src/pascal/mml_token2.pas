unit mml_token2;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 https://sakuramml.com
説　明：
        TMmlBase の下請けで、文字列処理を行うクラス

履　歴：

2002/06/03 15:13 雛型作成
2002/06/16 11:03 ほぼ完成
-------------------------------------------------------------------------------}

interface

uses
  Classes, SysUtils, mml_variable, mml_var;

type
  TMmlTokenBase = class
  private
    FMmlBase: TObject;
  public
    constructor Create(MmlBase: TObject); //変数参照用に、TMmlBaseを得る
    destructor Destroy; override;
    function GetArg    (var sp: TSrcPos; CalcMode: Boolean): TMVarCustom; // 計算なしで、１つだけ得る
    function GetArgCalc(var sp: TSrcPos): TMVarCustom; // 引数の後ろに計算式があれば計算する
    function GetArgs   (var sp: TSrcPos; varType: string): TMArray;
    function GetInt(var sp: TSrcPos): TMInt;
    function GetNoteLength(var sp: TSrcPos; stepmode: Boolean; def: Integer): Integer;
  end;

implementation

uses
  StrUnit, mml_token, mml_system, mml_error, mml_const, mml_calc;

{ TMmlTokenBase }

constructor TMmlTokenBase.Create(MmlBase: TObject);
begin
  FMmlBase := MmlBase;
end;

destructor TMmlTokenBase.Destroy;
begin
  inherited;
end;

function TMmlTokenBase.GetArg(var sp: TSrcPos; CalcMode: Boolean): TMVarCustom;

  procedure subKakko; //( ... )
  var s: string; ssp: TSrcPos;
  begin
    //丸括弧を展開し、その中を計算し、値を戻す
    s := GetMaruKakko(sp.Ptr, sp.lineNo);
    ssp := TSrcPos.Create ;
    try
      ssp.Assign(sp);
      ssp.SetTempSource(s);
      Result := GetArgCalc(ssp);
    finally
      ssp.Free ;
    end;
  end;

  procedure subString;
  var
      sp2: TSrcPos; //文字列の取得開始位置を覚えておく
  begin
      sp2 := TSrcPos.Create ;
      try
          sp2.Assign(sp); //文字列の取得開始位置をコピー
          Result := TMStr.Create ;
          try
              //文字列を取得
              TMStr(Result).value := getString(sp.ptr, sp.lineNo);
              //_debug(TMStr(Result).value);
          except
              //取得に失敗したらエラー
              raise;// EMml.Create(ErrMsg(MML_ERR_GET_STRING,sp2));
          end;
      finally
          sp2.Free ;
      end;
  end;
  //文字列の取得
  procedure subString2;
  var
      sp2: TSrcPos; //文字列の取得開始位置を覚えておく
  begin
      sp2 := TSrcPos.Create ;
      try
          sp2.Assign(sp); //文字列の取得開始位置をコピー
          Result := TMStr.Create ;
          try
              //文字列を取得
              if sp.ptr^ = '"' then Inc(sp.ptr);
              TMStr(Result).value := GetTokenChars(['"'],sp.ptr);
              //_debug(TMStr(Result).value);
          except
              //取得に失敗したらエラー
              raise;
          end;
      finally
          sp2.Free ;
      end;
  end;

begin
  Result := nil;
  skipSpace(sp.ptr);//

  case sp.ptr^ of
  //マイナスの後は、数値か変数である
  '-':
    begin
      Inc(sp.ptr);
      Result := GetArg(sp, True);
      if Result = nil then Exit;
      if Result.ClassType = TMInt then
      begin
        TMInt(Result).value := -1 * TMInt(Result).value ;
      end else
      if Result.ClassType = TMStr then
      begin
        TMStr(Result).value := '-' + TMStr(Result).value ;
      end;
    end;
  //Int の時
  '$','0'..'9','=','%','+'{明示的な＋}:
    begin
      if sp.ptr^ = '=' then Inc(sp.ptr);
      Result := Self.getInt(sp) ;
    end;
  //l のとき
  '!':
    begin
      Inc(sp.ptr); // skip !
      Result := TMInt.Create ;
      TMInt(Result).value := GetNoteLength(sp, False,
        (FMmlBase as TMmlSystem).CurTrack.Length.GetValue);
    end;
  //計算式&配列のとき
  '(': subKakko;
  //文字列
  '{': subString;
  '"': subString2;
  //アルファベットのとき
  'A'..'Z','a'..'z','#','_':
    begin
      if CalcMode = False then begin Exit; end;
      Result := (FMmlBase as TMmlSystem).GetVariable(sp);
    end;
  else
    begin
      //Result := nil;
      Exit;
    end;
  end;
end;

function TMmlTokenBase.GetNoteLength(var sp: TSrcPos;
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
            //付点の処理
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
        //値の取得
        skipSpace(sp.ptr);
        if not (sp.ptr^ in ['!','$','%','0'..'9','(']) then //省略されたときは、デフォルトを返す
        begin
            v := def; huten; Result := Trunc(v);
            Exit;
        end;

        v := 0;
        try
            mv := getArg(sp, False);
        except
            raise EMml.Create(TMmlSystem(FMmlBase).ErrMsg(MML_ERR_SYNTAX+'音長の指定。',sp));
        end;
        try
            if mv = nil then raise EMml.CreateFmt(TMmlSystem(FMmlBase).ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
            if mv.ClassType = TMInt then
            begin
                //StepModeの判別
                if TMInt(mv).Flag = '%' then stepm := not stepmode else stepm := stepmode;
                if stepm then
                begin
                    v := TMInt(mv).value
                end else begin
                    v := TMInt(mv).value ;
                    v := TMmlSystem(FMmlBase).NtoStep(Trunc(v));
                end;
            end else
            begin
                //
                if stepmode then
                    v := mv.IntValue
                else
                    v := TMmlSystem(FMmlBase).NtoStep(mv.IntValue);
            end;
        finally
            mv.Free ;
        end;
        huten;
        Result := Trunc(v);
    end;

begin
    vi := getOne;
    //タイの処理・・・
    while True do
    begin
        //タイがあるか？
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


function TMmlTokenBase.GetArgCalc(var sp: TSrcPos): TMVarCustom;
var
  temp: TSrcPos;

  procedure CalcArg;
  var
      stack: TMStack;
      enzansi: string;
      ppp: PChar;
  begin
      stack := TMStack.Create ;
      try
      try
          //初めに取得した値を加える
          stack.Add(Result);
          while sp.ptr^ in ENZANSI_CHAR do
          begin
              //演算子を取得
              ppp := sp.ptr;
              enzansi := sp.ptr^;
              if (sp.ptr^ in ENZANSI_NEXT_CHAR)and((sp.ptr+1)^ in ENZANSI_NEXT_CHAR) then
              begin
                  enzansi := enzansi + (sp.ptr+1)^;
                  Inc(sp.ptr);
              end;
              stack.Add( CreateEnzansi(enzansi) );
              Inc(sp.ptr);//inc enzansi

              //項を取得
              Result := GetArg(sp, True);
              if Result = nil then
              begin
                  //後ろが計算式だと思ったけど、違ったようなので、
                  //ポインタを元に戻す
                  sp.ptr := ppp;
                  stack.Delete(stack.Count -1);
                  (FMmlBase as TMmlSystem).ShowHint(Format('式の直後に演算子`%s`があったので、誤動作を起こす恐れがあります。',[enzansi]),sp);
                  Break;
              end else begin
                  stack.Add(Result);
              end;
              skipSpaceCalc(sp.ptr);
          end;
          //スタックに得た計算式を計算する
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
  //１つめの値を得る
  Result := GetArg(sp, True);

  if Result = nil then Exit;
  //skipSpace(sp.ptr); // <- '|'がスキップされてしまう場合がある
  while sp.ptr^ in [#9, ' '] do Inc(sp.ptr);

  //値の後ろに計算式があれば計算する
  if Result.ClassType = TMStr then //文字列で計算できるのは、＋ = ! だけ
  begin
    if not (sp.ptr^ in ['+','=','!']) then Exit;
  end else
    if not(sp.ptr^ in ENZANSI_CHAR) then Exit;//演算子がないから、抜ける

  //実際に計算
  temp := TSrcPos.Create ;
  try
  try
    temp.Assign(sp);
    CalcArg;
  except
    on e: Exception do
    begin
      raise EMml.Create((FMmlBase as TMmlSystem).ErrMsg(MML_ERR_SYSTEM+e.Message, temp));
    end;
  end;
  finally
    temp.Free ;
  end;
end;

function TMmlTokenBase.GetInt(var sp: TSrcPos): TMInt;
var
    s: string;
//    n: Integer;
    sign: Integer;
    v: TMVarCustom;
begin
    skipSpace(sp.ptr);
    //--------------------------------------------------
    //前置記号 ('-','+')
    sign := 1;
    if sp.ptr^ ='-' then
    begin
        Inc(sp.ptr); sign := -1;
    end else
    if sp.ptr^ = '+' then
    begin
        Inc(sp.ptr);
    end;

    Result := TMInt.Create;

    if sp.ptr^ = '%' then //フラグセット
    begin
      Result.Flag := '%'; Inc(sp.ptr);
      v := GetArg(sp, False);
      if v<>nil then Result.value := v.IntValue ;
      Exit;
    end;

    //--------------------------------------------------
    //変数なのか?
    if sp.ptr^ in ['A'..'Z','a'..'z','_'] then
    begin
      v := (FMmlBase as TMmlSystem).GetVariable(sp);
      try
        Result.value := v.IntValue ;
      finally
        v.Free ;
      end;
      Exit;
    end;
    if sp.ptr^ = '(' then
    begin
      v := GetArg(sp, False);
      if v<>nil then Result.value := v.IntValue ;
      Exit;
    end;

    if sp.ptr^ = '!' then //(n)分音符指定
    begin
        Inc(sp.ptr);
        {s := mml_token.GetNumber( sp.ptr );
        n := StrToInt( s );
        //全音符のタイムベースを得て、ｎ分音符で割る
        Result.value := (FMmlBase as TMmlSystem).NtoStep(n);}
        Result.value := GetNoteLength(sp, (not(FMmlBase as TMmlSystem).CurTrack.Stepmode),0);
    end else
    begin
        s := GetNumber( sp.ptr );
        Result.value := StrToIntDef( s, 0 ) * sign;
    end;
end;


function TMmlTokenBase.GetArgs(var sp: TSrcPos; varType: string): TMArray;

  procedure getKakko;
  var s: string; sp2: TSrcPos;
  begin
    s := GetMaruKakko(sp.ptr, sp.lineNo);
    if (varType='s')and(Copy(s,1,1)<>'{') then
    begin
      if Pos(',',s)=0 then
      begin
        s := '{' + s + '}';
      end;
    end;
    sp2 := TSrcPos.Create ;
    try
      sp2.Assign(sp);
      sp2.SetTempSource('='+s);
      Result := GetArgs(sp2, varType);
    finally
      sp2.Free ;
    end;
  end;

  function skipCommaOrBreak: Boolean;
  begin
    skipSpace(sp.ptr);
    if (sp.ptr^ in (FMmlBase as TMmlSystem).ValueSplitChar)and(sp.ptr^ <> #0) then //続きがあるか判別
    begin
      Inc(sp.ptr);
      while sp.ptr^ in [#13,#10] do Inc(sp.ptr);
      Result := False;
    end else begin
      Result := True;
    end;
  end;

  procedure getArray;
  var v: TMVarCustom;
  begin
    skipSpace(sp.ptr);
    if sp.ptr^ = #0 then Exit;
    repeat // カンマがなくなるまで繰り返す
      if sp.ptr^ = '(' then
      begin
        v := GetArgs(sp, 'a');
        Result.AddArray(v as TMArray);
      end else
      begin
        v := GetArgCalc(sp);
        if (v<>nil)and(v.ClassType = TMArray) then
        begin // 値を展開する
          Result.AddArray(v as TMArray);
        end else
        begin
          Result.Add(v) ;
        end;
      end;
      skipSpace(sp.ptr);
    until skipCommaOrBreak;
  end;

var
  i: Integer;
  v: TMVarCustom;
begin
  //読み取りが出来るかどうか判断
  skipSpace(sp.ptr);
  case sp.ptr^ of
  '(': begin getKakko; Exit; end;
  '=':
    begin
      Inc(sp.ptr);
    end;
  '%','!','$','0'..'9','{','-':;//数値,文字列ならOK
  else
    begin
      Result := nil; Exit;
    end;
  end;

  Result := TMArray.Create ;

  //自由形か？
  if varType='' then begin
    getArray; Exit;
  end;

  //引数を一つずつ得る(型指定あり)
  for i:=1 to Length(varType) do
  begin
    case varType[i] of
    'i':
      begin
        v := GetArgCalc(sp);
        if v=nil then
        begin
          v := TMInt.Create ;
          Result.Add(v);
        end else begin
          Result.Add( v );
        end;
      end;
    's':
      begin
        v := GetArgCalc(sp);
        if v=nil then
        begin
          v := TMStr.Create ;
          Result.Add(v);
        end else begin
          Result.Add( v );
        end;
      end;
    'a':
      begin
        getArray;
        Break;
      end;
    end;
    if skipCommaOrBreak then Break; //カンマがなければループを終了する
  end;
end;

end.
