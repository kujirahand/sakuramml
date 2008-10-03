unit mml_token2;
{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���F
        TMmlBase �̉������ŁA�����񏈗����s���N���X

���@���F

2002/06/03 15:13 ���^�쐬
2002/06/16 11:03 �قڊ���
-------------------------------------------------------------------------------}

interface

uses
  Classes, SysUtils, mml_variable, mml_var;

type
  TMmlTokenBase = class
  private
    FMmlBase: TObject;
  public
    constructor Create(MmlBase: TObject); //�ϐ��Q�Ɨp�ɁATMmlBase�𓾂�
    destructor Destroy; override;
    function GetArg    (var sp: TSrcPos; CalcMode: Boolean): TMVarCustom; // �v�Z�Ȃ��ŁA�P��������
    function GetArgCalc(var sp: TSrcPos): TMVarCustom; // �����̌��Ɍv�Z��������Όv�Z����
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
    //�ۊ��ʂ�W�J���A���̒����v�Z���A�l��߂�
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
  Result := nil;
  skipSpace(sp.ptr);//

  case sp.ptr^ of
  //�}�C�i�X�̌�́A���l���ϐ��ł���
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
  //Int �̎�
  '$','0'..'9','=','%','+'{�����I�ȁ{}:
    begin
      if sp.ptr^ = '=' then Inc(sp.ptr);
      Result := Self.getInt(sp) ;
    end;
  //l �̂Ƃ�
  '!':
    begin
      Inc(sp.ptr); // skip !
      Result := TMInt.Create ;
      TMInt(Result).value := GetNoteLength(sp, False,
        (FMmlBase as TMmlSystem).CurTrack.Length.GetValue);
    end;
  //�v�Z��&�z��̂Ƃ�
  '(': subKakko;
  //������
  '{': subString;
  '"': subString2;
  //�A���t�@�x�b�g�̂Ƃ�
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
        if not (sp.ptr^ in ['!','$','%','0'..'9','(']) then //�ȗ����ꂽ�Ƃ��́A�f�t�H���g��Ԃ�
        begin
            v := def; huten; Result := Trunc(v);
            Exit;
        end;

        v := 0;
        try
            mv := getArg(sp, False);
        except
            raise EMml.Create(TMmlSystem(FMmlBase).ErrMsg(MML_ERR_SYNTAX+'�����̎w��B',sp));
        end;
        try
            if mv = nil then raise EMml.CreateFmt(TMmlSystem(FMmlBase).ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
            if mv.ClassType = TMInt then
            begin
                //StepMode�̔���
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
              Result := GetArg(sp, True);
              if Result = nil then
              begin
                  //��낪�v�Z�����Ǝv�������ǁA������悤�Ȃ̂ŁA
                  //�|�C���^�����ɖ߂�
                  sp.ptr := ppp;
                  stack.Delete(stack.Count -1);
                  (FMmlBase as TMmlSystem).ShowHint(Format('���̒���ɉ��Z�q`%s`���������̂ŁA�듮����N�������ꂪ����܂��B',[enzansi]),sp);
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
  //�P�߂̒l�𓾂�
  Result := GetArg(sp, True);

  if Result = nil then Exit;
  //skipSpace(sp.ptr); // <- '|'���X�L�b�v����Ă��܂��ꍇ������
  while sp.ptr^ in [#9, ' '] do Inc(sp.ptr);

  //�l�̌��Ɍv�Z��������Όv�Z����
  if Result.ClassType = TMStr then //������Ōv�Z�ł���̂́A�{ = ! ����
  begin
    if not (sp.ptr^ in ['+','=','!']) then Exit;
  end else
    if not(sp.ptr^ in ENZANSI_CHAR) then Exit;//���Z�q���Ȃ�����A������

  //���ۂɌv�Z
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

    Result := TMInt.Create;

    if sp.ptr^ = '%' then //�t���O�Z�b�g
    begin
      Result.Flag := '%'; Inc(sp.ptr);
      v := GetArg(sp, False);
      if v<>nil then Result.value := v.IntValue ;
      Exit;
    end;

    //--------------------------------------------------
    //�ϐ��Ȃ̂�?
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

    if sp.ptr^ = '!' then //(n)�������w��
    begin
        Inc(sp.ptr);
        {s := mml_token.GetNumber( sp.ptr );
        n := StrToInt( s );
        //�S�����̃^�C���x�[�X�𓾂āA���������Ŋ���
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
    if (sp.ptr^ in (FMmlBase as TMmlSystem).ValueSplitChar)and(sp.ptr^ <> #0) then //���������邩����
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
    repeat // �J���}���Ȃ��Ȃ�܂ŌJ��Ԃ�
      if sp.ptr^ = '(' then
      begin
        v := GetArgs(sp, 'a');
        Result.AddArray(v as TMArray);
      end else
      begin
        v := GetArgCalc(sp);
        if (v<>nil)and(v.ClassType = TMArray) then
        begin // �l��W�J����
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
  //�ǂݎ�肪�o���邩�ǂ������f
  skipSpace(sp.ptr);
  case sp.ptr^ of
  '(': begin getKakko; Exit; end;
  '=':
    begin
      Inc(sp.ptr);
    end;
  '%','!','$','0'..'9','{','-':;//���l,������Ȃ�OK
  else
    begin
      Result := nil; Exit;
    end;
  end;

  Result := TMArray.Create ;

  //���R�`���H
  if varType='' then begin
    getArray; Exit;
  end;

  //�������������(�^�w�肠��)
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
    if skipCommaOrBreak then Break; //�J���}���Ȃ���΃��[�v���I������
  end;
end;

end.
