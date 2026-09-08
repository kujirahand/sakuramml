unit mml_error;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 https://sakuramml.com
説　明：MML構文エラーを管理する


履　歴：

2002/06/03 15:13 雛型作成
-------------------------------------------------------------------------------}

interface

uses
  {$ifdef Win32}
  Windows,
  mmsystem,
  {$endif}
  SysUtils,
  Classes;

type
  EMml = class(Exception)
    constructor Create(const Msg: string);
    constructor CreateFmt(const Msg: string; const Args: array of const);
  end;

  procedure _debug(s: string); overload;
  procedure _debug(i: Integer); overload;
  procedure WriteLog(s: string);
  procedure WriteComTime(mes: string); //コメント入りで現在までの実行時間を記録する

var
  CompilerMessage: string;
  TimeCheck: DWORD;

const
    MML_LOG = 'log_sakura.txt';//ログファイルの名前

//エラーメッセージリスト
const
  //引数なしメッセージのみのエラー
  MML_ERR_SYSTEM = 'サクラのシステムエラー。';
  MML_ERR_GET_STRING = '文字列の取得に失敗';
  MML_ERR_SYNTAX = '文法エラー。';
  MML_ERR_DEF_FUNC = '関数の定義に失敗しました。';
  MML_ERR_DEF_MACRO = 'マクロの定義に失敗しました。';

  //"%s"の引数つきエラー
  MML_ERR_UNKNOWN = '"%s"は未定義です。つづりを確かめてください。';
  MML_ERR_VAR_NOT_FOUND = '変数"%s"は未定義です。つづりを確かめてください。';
  MML_ERR_RANGE_OVER = '命令"%s"で、値が範囲を超えて指定されました。';
  MML_ERR_ARG = '命令"%s"の引数の指定が不正です。';
  MML_ERR_CALC = '計算式に誤りがあります。';
  MML_ERR_VAR_ILLIGAL_TYPE = '変数"%s"に不正な型を代入しようとしました。';
  MML_ERR_VAR_CANT_EXECUTE = '変数"%s"は、実行できません。';
  MML_ERR_KAKKO_NOT_PAIR = 'カッコ"%s"が、対応していません。';
  MML_ERR_CANT_READ_INT_VALUE = '命令"%s"で、引数が読めません。整数を指定してください。';
  MML_ERR_NOT_INT = '変数"%s"は、整数ではありません。';
  MML_ERR_CALL_FUNC = '関数"%s"の呼び出しに失敗しました。';
  MML_ERR_CALL_USER_FUNC = 'ユーザー関数"%s"の呼び出しに失敗しました。';
  MML_ERR_STR_EXPAND = '"文字列"%s"に記述ミスがあります。';
  MML_ERR_WRONG_ARG_ORDER = 'ノート定義引数"%s"は、未定義の引数指定子です。';
  //"%d"つきエラー
  MML_ERR_PLAY = '"PLAY"文のトラック(%d)"%s"中に記述ミスがあります。';
  //WARNING
  MML_ERR_VAR_ALREADY_EXISTS = '変数"%s"を、再定義しています。';
  MML_ERR_FUNCTION_ALREADY_EXISTS = '関数"%s"を、再定義しています。';
  MML_WARN_VAR_SYNTAX = '非推奨な文法の警告。';

  {$ifdef Win32}
  {$else}
  function timeGetTime: Int64;
  {$endif}

implementation

{$ifdef Win32}
{$else}
uses dateutils;
function timeGetTime: Int64;
begin
  Result := DateTimeToUnix(Now);
end;
{$endif}

procedure _debug(s: string); 
begin
    {$ifdef Win32}
    MessageBox(0, PChar(s), 'debug', MB_OK);
    {$else}
    Writeln(s);
    {$endif}
end;
procedure _debug(i: Integer);
var
    s: string;
begin
    s := IntToStr(i);
    {$ifdef Win32}
    MessageBox(0, PChar(s), 'debug', MB_OK);
    {$else}
    Writeln(s);
    {$endif}
end;

procedure WriteLog(s: string);
var
    f: TextFile;
begin
    AssignFile(f, MML_LOG);

    if FileExists(MML_LOG) then
    begin
        Append(f);
        writeln(f,s);
    end else
    begin
        Rewrite(f);
        writeln(f,s);
    end;
    CloseFile(f);
end;

procedure WriteComTime(mes: string); //コメント入りで現在までの実行時間を記録する
begin
    CompilerMessage := CompilerMessage +
        Format('[%s] %.2f 秒',[mes,((timeGetTime-TimeCheck)/1000)])+#13#10;
end;

{ EMml }

//ただただ、CompilierMessageにエラーを加えたいが為の継承
constructor EMml.Create(const Msg: string);
begin
    if Pos(Msg, CompilerMessage) > 0 then
    begin
        inherited Create(Msg);
        Exit;
    end;

    CompilerMessage := CompilerMessage + Msg;
    inherited Create(Msg);
end;

constructor EMml.CreateFmt(const Msg: string; const Args: array of const);
var
    s: string;
begin
    s := Format(Msg,Args);
    
    if Pos(s, CompilerMessage) > 0 then
    begin
        inherited CreateFmt(Msg, Args);
        Exit;
    end;

    CompilerMessage := CompilerMessage + s;
    inherited CreateFmt(Msg, Args);
end;

initialization
  CompilerMessage := '';
  TimeCheck := timeGetTime;

end.
