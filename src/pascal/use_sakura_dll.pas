unit use_sakura_dll;

interface
uses
  {$ifdef Win32}
  Windows,
  {$endif}
  SysUtils,
  Classes;

const
  MML_OPTION_NORMAL       =   0;
  MML_OPTION_LOG          =   1;// 0000 0001
  MML_OPTION_META_LOG     =   2;// 0000 0010
  MML_OPTION_SUTOTON_LOG  =   4;// 0000 0100
  MML_OPTION_RYTHM_LOG    =   8;// 0000 1000
  MML_OPTION_SHOW_TIME    = $10;// 0001 0000
  MML_OPTION_MLD_FILE     = $20;// 0010 0000

  //MAX_TEXT = 65536;
  MAX_TEXT = 4096;

type
  PMmlOnProgress = ^TMmlOnProgress;
  TMmlOnProgress = procedure(NowLine, LineCount: Integer; msg: PChar; var StopCompile: Boolean); stdcall;

function mmlCompile(source, fname: string): Boolean;
function mmlErrorMessage: string;
procedure mmlOption(opt: Integer);
function mmlVersionInfo: string;
function mmlDateInfo: string;
function mmlCompile2(source, fname: string; func: PMmlOnProgress): Boolean;

implementation

const
  {$ifdef Win32}
  DSAKURA = 'plug-ins\dSakura.dll';
  {$else}
    {$ifdef DARWIN}
    DSAKURA = 'libdSakura.dylib';
    {$else}
    DSAKURA = 'dSakura.so';
    {$endif}
  {$endif}
function MMLtoMIDI(MMLText: PChar; FileName: PChar; ErrMsg: PChar): Boolean; stdcall; external DSAKURA;
procedure SetErrMsgLen(mLen: Integer); stdcall; external DSAKURA;
procedure SetOption(opt: Integer); stdcall; external DSAKURA;
procedure GetVerInfo(s: PChar); stdcall; external DSAKURA;
procedure GetDateInfo(s: PChar); stdcall; external DSAKURA;
function MMLtoMIDI2( MMLText: PChar; FileName: PChar; ErrMsg: PChar;
    FuncProgress: PMmlOnProgress): Boolean; stdcall; external DSAKURA;

var
  ErrMsg: string;

function mmlVersionInfo: string;
begin
  try
    SetLength(Result,256);
    GetVerInfo(PChar(Result));
    Result := string(PChar(Result));
  except
    Result := 'バージョン取得エラー';
  end;
end;
function mmlDateInfo: string;
begin
  try
    SetLength(Result,256);
    GetDateInfo(PChar(Result));
    Result := string(PChar(Result));
  except
    Result := '日付取得エラー';
  end;
end;

procedure mmlOption(opt: Integer);
begin
    SetOption(opt);
end;

function mmlCompile(source, fname: string): Boolean;
var
    err: string;
    p: PChar;
begin
    SetLength(err, MAX_TEXT);
    SetErrMsgLen(MAX_TEXT);
    p := PChar(err);
    Result := MMLtoMIDI( PChar(source), PChar(fname), p );
    ErrMsg := string(p);
end;

function mmlCompile2(source, fname: string; func: PMmlOnProgress): Boolean;
var
    p: PChar;
begin
    SetErrMsgLen(MAX_TEXT);
    GetMem(p, MAX_TEXT);
    try
        Result := MMLtoMIDI2( PChar(source), PChar(fname), p, func);
        ErrMsg := string(p);
    finally
        FreeMem(p);
    end;
end;


function mmlErrorMessage: string;
begin
    Result := ErrMsg;
end;



end.
