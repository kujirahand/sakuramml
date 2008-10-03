(*-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 http://www.text2music.com
説　明：ＤＬＬのエントリポイント

サクラ履歴：

2002/06/03 ver2.00β-100
サクラver.1.xxのソース紛失に気づく。よって、Delphiにて作り直し開始

2002/09/29 ver2.11
いろいろな機能が凡そ安定してきた。

履　歴：

2002/06/03 15:13 雛型作成
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
    s: string;
    p: PChar;

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

procedure SutotonMode(mode: BOOL); stdcall;
begin
    //ver.2.xx
    //not support
end;


//互換性のため( for dSakura.dll ver.1.xx )
//----------------------------------------------------------------------
//関数 for 古いひまわり
{
『dSakura.dll』の、
『DWORD MakeMidi(char*, char*)』を、
『?を,?へ』の、
『MIDI作成』として、DLLを利用。
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
『dSakura.dll』の、
『DWORD GetLastMessage(char*, char*)』を、
『?へ,?バイト』の、
『MIDI作成エラー取得』として、DLLを利用。
}
function GetLastMessage(msg:PChar; len:PChar{昔のひまわりは整数が渡せなかったため}): DWORD;
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


