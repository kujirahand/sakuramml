(*-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���F�c�k�k�̃G���g���|�C���g

�T�N�������F

2002/06/03 ver2.00��-100
�T�N��ver.1.xx�̃\�[�X�����ɋC�Â��B����āADelphi�ɂč�蒼���J�n

2002/09/29 ver2.11
���낢��ȋ@�\���}�����肵�Ă����B

���@���F

2002/06/03 15:13 ���^�쐬
-------------------------------------------------------------------------------*)

library dSakura;

uses
  Windows,
  SysUtils,
  Classes,
  mmsystem,
  mml_unit in 'mml_unit.pas',
  StrUnit in 'strunit.pas',
  wildcard in 'wildcard.pas',
  mml_base in 'mml_base.pas',
  mml_error in 'mml_error.pas',
  hashUnit in 'hashUnit.pas',
  mml_types in 'mml_types.pas',
  mml_const in 'mml_const.pas',
  mml_token in 'mml_token.pas',
  mml_system in 'mml_system.pas',
  mml_var in 'mml_var.pas',
  mml_calc in 'mml_calc.pas',
  smf_types in 'smf_types.pas',
  smf_const in 'smf_const.pas',
  mml_token2 in 'mml_token2.pas';


const
  MML_OPTION_NORMAL       =   0;
  MML_OPTION_LOG          =   1;// 0000 0001
  MML_OPTION_META_LOG     =   2;// 0000 0010
  MML_OPTION_SUTOTON_LOG  =   4;// 0000 0100
  MML_OPTION_RYTHM_LOG    =   8;// 0000 1000
  MML_OPTION_SHOW_TIME    = $10;// 0001 0000
  MML_OPTION_MLD_FILE     = $20;// 0010 0000
  MML_OPTION_NO_STDMSG_H  = $80;// 0100 0000

{$R *.res}

var
  MsgLen, MmlOption: Integer;

//�̈���m�ۂ�����������w�肷��ƁA�ڍ׃o�[�W������񕶎����Ԃ�
procedure GetVerInfo(s: PChar); stdcall;
begin
    StrCopy(s, VER_INFO);
end;
procedure GetDateInfo(s: PChar); stdcall;
begin
    StrCopy(s, DATE_INFO);
end;

//�I�v�V�����̎w��
procedure SetOption(opt: Integer); stdcall;
begin
    MmlOption := opt;
end;

//MML��������AMIDI�t�@�C���ɕϊ�����R�[���o�b�N�t��
function MMLtoMIDI2(
    MMLText: PChar;
    FileName: PChar;
    ErrMsg: PChar;
    FuncProgress: PMmlOnProgress): Boolean; stdcall;
var
    mml: TMml2Smf;
    s: string;
    p: PChar;

    procedure subOption;
    begin
        {--�I�v�V�������Z�b�g}
        if (MmlOption and MML_OPTION_LOG)>0         then mml.MmlOption.EventLog   := True;
        if (MmlOption and MML_OPTION_META_LOG)>0    then mml.MmlOption.MetaLog    := True;
        if (MmlOption and MML_OPTION_SUTOTON_LOG)>0 then mml.MmlOption.SutotonLog := True;
        if (MmlOption and MML_OPTION_RYTHM_LOG)>0   then mml.MmlOption.RythmLog   := True;
        if (MmlOption and MML_OPTION_SHOW_TIME)>0   then mml.MmlOption.TimeLog    := True;
        if (MmlOption and MML_OPTION_MLD_FILE)>0    then mml.MmlOption.MldFormat  := True;
        if (MmlOption and MML_OPTION_NO_STDMSG_H)>0 then mml.MmlOption.IncludeStdMsg := False;

        //Mml.MmlOption.IncludeStdMsg := False;
        //Mml.MmlOption.SutotonLog := True;
        //mml.MmlOption.MldFormat  := True;
        //mml.MmlOption.RythmLog  := True;
    end;

begin
    //_debug(IntToStr(Ord(True))); ����:1
    CompilerMessage := '';
    TimeCheck := timeGetTime ;

    //
    mml := TMml2Smf.Create ;
    try
        try
            Result := True;
            subOption;
            OnProgress := Pointer(FuncProgress) ;
            if mml.Execute(MMLText, FileName)=False then
            begin
                Result := False;
            end;
            WriteComTime('�I��');

            if CompilerMessage<>'' then
            begin
                p := PChar(CompilerMessage);
                StrLCopy(ErrMsg, p, MsgLen-1); //���b�Z�[�W���R�s�[
            end else
            begin
                ErrMsg^ := #0;
            end;
        except
            on E:Exception do begin //�R���p�C���̗�O�Ȃǂ����o
                Result :=False;
                s := E.Message + #13#10 + CompilerMessage;
                p := PChar(CompilerMessage);
                StrLCopy(ErrMsg, p, MsgLen-1);
            end;
        end;
    finally
        mml.Free ;
    end;

end;

//MML��������AMIDI�t�@�C���ɕϊ�����
function MMLtoMIDI(MMLText: PChar; FileName: PChar; ErrMsg: PChar): Boolean; stdcall;
begin
  Result := MMLtoMIDI2(MMLText, FileName, ErrMsg, nil);
end;

procedure SetErrMsgLen(mLen: Integer); stdcall;
begin
    MsgLen := mLen;
end;

procedure SutotonMode(mode: BOOL); stdcall;
begin
    //ver.2.xx
    //not support
end;


//�݊����̂���( for dSakura.dll ver.1.xx )
//----------------------------------------------------------------------
//�֐� for �Â��Ђ܂��
{
�wdSakura.dll�x�́A
�wDWORD MakeMidi(char*, char*)�x���A
�w?��,?�ցx�́A
�wMIDI�쐬�x�Ƃ��āADLL�𗘗p�B
}
function MakeMidi(MMLText: PChar; FileName:PChar): DWORD;
var
  temp: string;
begin
  SetLength(temp, MsgLen);
  if MMLtoMIDI(MMLText, FileName, PChar(temp)) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;
{
�wdSakura.dll�x�́A
�wDWORD GetLastMessage(char*, char*)�x���A
�w?��,?�o�C�g�x�́A
�wMIDI�쐬�G���[�擾�x�Ƃ��āADLL�𗘗p�B
}
function GetLastMessage(msg:PChar; len:PChar{�̂̂Ђ܂��͐������n���Ȃ���������}): DWORD;
var flen: string; l: Integer;
begin
  flen := string( len );
  l := StrToIntDef(flen, MsgLen);
  StrLCopy( msg, PChar(CompilerMessage), l);
  Result := 1;
end;
//----------------------------------------------------------------------

exports
  MMLtoMIDI,
  GetVerInfo,
  GetDateInfo,
  SetErrMsgLen,
  SutotonMode,
  SetOption,
  MMLtoMIDI2,
  MakeMidi,
  GetLastMessage;

begin
  MsgLen := 255;
  MmlOption := 0;
end.


