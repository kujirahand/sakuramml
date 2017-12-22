unit csakurautils;

interface

uses
  {$ifdef Win32}
  Windows,
  mmsystem,
  {$endif}
  SysUtils,
  Classes,
  mml_unit,
  StrUnit,
  wildcard,
  mml_base,
  mml_error,
  hashUnit ,
  mml_types,
  mml_const,
  mml_token,
  mml_system,
  mml_var ,
  mml_calc,
  smf_types,
  smf_const,
  mml_token2;


var
  SakuraError: String;

function mmlCompile(source: string; midifile: string): Boolean;
function MMLtoMIDI(MMLText: PChar; FileName: PChar; ErrMsg: PChar): Boolean; stdcall;
procedure GetVerInfo(s: PChar); stdcall;
procedure SetErrMsgLen(mLen: Integer); stdcall;

implementation

const
  MML_OPTION_NORMAL       =   0;
  MML_OPTION_LOG          =   1;// 0000 0001
  MML_OPTION_META_LOG     =   2;// 0000 0010
  MML_OPTION_SUTOTON_LOG  =   4;// 0000 0100
  MML_OPTION_RYTHM_LOG    =   8;// 0000 1000
  MML_OPTION_SHOW_TIME    = $10;// 0001 0000
  MML_OPTION_MLD_FILE     = $20;// 0010 0000
  MML_OPTION_NO_STDMSG_H  = $80;// 0100 0000

var
  MsgLen, MmlOption: Integer;

//領域を確保した文字列を指定すると、詳細バージョン情報文字列を返す
procedure GetVerInfo(s: PChar); stdcall;
begin
    StrCopy(s, VER_INFO);
end;
procedure GetDateInfo(s: PChar); stdcall;
begin
    StrCopy(s, DATE_INFO);
end;

//オプションの指定
procedure SetOption(opt: Integer); stdcall;
begin
    MmlOption := opt;
end;

//MML文字列を、MIDIファイルに変換するコールバック付き
function MMLtoMIDI2(
    MMLText: PChar;
    FileName: PChar;
    ErrMsg: PChar;
    FuncProgress: PMmlOnProgress): Boolean; stdcall;
var
    mml: TMml2Smf;
    p: PChar;
    s: string;

    procedure subOption;
    begin
        {--オプションをセット}
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
    //_debug(IntToStr(Ord(True))); 結果:1
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
            WriteComTime('終了');

            if CompilerMessage<>'' then
            begin
                p := PChar(CompilerMessage);
                StrLCopy(ErrMsg, p, MsgLen-1); //メッセージをコピー
            end else
            begin
                ErrMsg^ := #0;
            end;
        except
            on E:Exception do begin //コンパイラの例外などを検出
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

//MML文字列を、MIDIファイルに変換する
function MMLtoMIDI(MMLText: PChar; FileName: PChar; ErrMsg: PChar): Boolean; stdcall;
begin
  Result := MMLtoMIDI2(MMLText, FileName, ErrMsg, nil);
end;

procedure SetErrMsgLen(mLen: Integer); stdcall;
begin
    MsgLen := mLen;
end;

procedure SutotonMode(mode: Boolean); stdcall;
begin
    //ver.2.xx
    //not support
end;

function mmlCompile(source: string; midifile: string): Boolean;
var
  mml: TMml2Smf;
begin
    SakuraError := '';
    CompilerMessage := '';
    mml := TMml2Smf.Create ;
    try
        try
            Result := True;
            if mml.Execute(source, midifile) = False then
            begin
                Result := False;
                SakuraError := CompilerMessage;
            end;
            if CompilerMessage <> '' then
            begin
                Writeln(CompilerMessage);
            end;
        except
          on e: Exception do
          begin
            Result :=False;
            Writeln(CompilerMessage + e.Message);
          end;
        end;
    finally
        mml.Free ;
    end;
end;

end.
