unit mml_system;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 https://sakuramml.com
説　明：サクラのＭＭＬをＳＭＦに変換するメインユニット mml_base の下請けクラス
　　　　メインの、mml_base が長くならないように、なるだけ、下請け的なものは、
　　　　こちらに書くようにした。

履　歴：

2002/06/03 15:13 雛型作成
-------------------------------------------------------------------------------}

interface
uses
  {$ifdef Win32}
  Windows,
  {$endif}
  Classes,
  SysUtils,
  mml_const,
  mml_error,
  mml_var,
  mml_types,
  mml_token,
  smf_types;

type

  TMWaon = record
    Enable: Boolean;
    Option: TMArray; //値省略時の初期値
    Time: Integer;
  end;

  TMTime = record
    mes,
    beat,
    tick: Integer;
  end;

  TMmlOption = packed record //Option
    IncludeStdMsg,
    SutotonLog,
    EventLog,
    RythmLog,
    TimeLog,
    MetaLog,
    MldFormat: Boolean;
  end;

  TMmlRpnShift = record //RPN/NRPNのDATA_ENTRYが同じCCなので被らないように注意
    time: Integer;
    shift: Integer;
    ch: Integer;
  end;

  TMmlSystem = class
  private
  protected
    LineCount,
    LastLine: Integer;
    NowFunc: string;                    // 現在実行中の関数の名前を得る
    FlagStopCompile: Boolean;           // コンパイルの中止を指令
    SongInfo: TSongInfo;                // 曲情報
    Commands,ParentCommands: TMVarHash; // 変数関数命令
    Structs: TMStruct;                  // スクリプトの構造化のためのスコープ管理クラス
    nowpos: TSrcPos;                    // 現在位置を表す
    SmfSong: TSmfSong;                  // SMF書き込み用
    CurSmfTrack: TSmfTrack;             // SMF書き込み用に現在書き込み予定のトラックのポインタを保持
    WaonStack: TList;                   // Length=0 の和音
    TieStack: TList;                    // タイ(&)があったとき、スタックに積んでおく
    FlagOctaveUpOnce: Integer;
    RecWaon: TMWaon;                    // 'ceg'の、和音コマンド
    IncludedSource: TList;
    CalcMode: Boolean;                  // 3+5 のような計算を行うかどうか
    //TokenType: TTokenType;              // トークの区切りをどのように区切るかを指定する
    RythmChar: array [0..127] of string;// Rythmモードで置換用に用いる
    StretchRate: Extended;              // Stretch rate
    RpnShift: TMmlRpnShift;             // RPN/NRPNが同タイムに来るとき、自動的にシフトする
    FuncResult: TMVarCustom ;           // 関数の返り値
    FuncBreak: Integer;
    function GetMaruKakko(var sp: TSrcPos): string;
    function GetNakaKakko(var sp: TSrcPos): string;
    procedure SetCurTrack(Index: Integer);
    function GetCurCCList: TCCList;
    function GetCurCCNote(no: Integer): TNoteCC;
    function SourceFileName(fno: Integer): string;
    procedure WriteEndOfTrack;
    function  ExecuteCommand(node: TMHashNode; var sp: TSrcPos): TMVarCustom; virtual; abstract;
  public
    //汎用的な計算メソッド
    function TimeToStep(mes,beat,tick:Integer):Integer;
    function StepToTime(step:Integer):TMTime;
    function NtoStep(n: Integer): Integer;
    function ErrMsg(msg: string; sp: TSrcPos): string;
    procedure ShowHint(msg: string; sp: TSrcPos);
    procedure PrintCon(msg: string; sp: TSrcPos);
    function GetVariable(var sp: TSrcPos): TMVarCustom;
  public
    CurTrack: TTrackInfo; //現在編集中のトラックへのポインタ
    ValueSplitChar: set of Char;        // 普段は、","
    IncludedFiles: TStringList;
    MmlOption: TMmlOption;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses StrUnit, smf_const;

{ TMmlSystem }

constructor TMmlSystem.Create;
var
    i:Integer;
begin
    Randomize;
    IncludedFiles := TStringList.Create ;
    IncludedSource := TList.Create ;
    nowpos := TSrcPos.Create ;
    LineCount := 0;
    FuncResult := nil;
    FuncBreak := 0;
    NowFunc := '';

    SongInfo := TSongInfo.Create ;
    SmfSong := TSmfSong.Create ; //
    WaonStack := TList.Create ;
    TieStack := TList.Create ;

    Structs := TMStruct.Create(nil, stNormal) ;
    Commands := Structs.varHash; //Commands は、Structs の中で自動生成される
    ParentCommands := Commands;

    FlagStopCompile := False;
    FlagOctaveUpOnce := 0;
    RecWaon.Enable := False;
    RecWaon.Option := nil;
    ValueSplitChar := [','];
    CalcMode := False;
    StretchRate := 1;
    OnProgress := nil;

    //とりあえず、Track(0)を作成してアサイン
    SetCurTrack(0);

    RpnShift.ch := -1; //RPNをクリア

    for i:=0 to High(RythmChar) do //リズムモード文字列を初期化
    begin
        RythmChar[i] := '';
    end;
    //リズムモード文字列の初期値
    RythmChar[Ord('b')] := 'n36,';
    RythmChar[Ord('s')] := 'n38,';
    RythmChar[Ord('h')] := 'n42,';
    RythmChar[Ord('m')] := 'n46,';
    RythmChar[Ord('c')] := 'n49,';
    RythmChar[Ord('H')] := 'n50,';
    RythmChar[Ord('M')] := 'n47,';
    RythmChar[Ord('L')] := 'n43,';
    RythmChar[Ord('_')] := 'r';


    //MML OPTION の初期値をセット
    with MmlOption do
    begin
        IncludeStdMsg := True;
        SutotonLog := False;
        EventLog := False;
        TimeLog := False;
        MetaLog := False;
    end;


end;

destructor TMmlSystem.Destroy;
var
    i: Integer;
    MStr: TMStr;
    n: TSmfNoteOn ;
begin
    IncludedFiles.Free ;
    Structs.Free ;
    SongInfo.Free ;
    SmfSong.Free ;
    nowpos.Free ;
    if FuncResult <> nil then FuncResult.Free ;

    //和音スタックの解放
    for i:=0 to WaonStack.Count -1 do
    begin
        n := WaonStack.Items[i]; if n<>nil then n.Free ;
    end;
    WaonStack.Free ;

    //タイスタックの解放
    for i:=0 to TieStack.Count -1 do
    begin
        n := TieStack.Items[i]; if n<>nil then n.Free ;
    end;
    TieStack.Free ;

    //和音スタック２の解放
    if RecWaon.Option <> nil then RecWaon.Option.Free ;

    //ソースファイルを記憶しておく領域の解放
    for i:=0 to IncludedSource.Count -1 do //ソース
    begin
        MStr := IncludedSource.Items[i];
        if MStr<>nil then MStr.Free ;
    end;
    IncludedSource.Free ;

    inherited;
end;

function TMmlSystem.ErrMsg(msg: string; sp: TSrcPos): string;
var
    fname, ss: string;
    len: Integer;
begin
    //nilが渡されたとき
    if sp=nil then begin
        Result := '[エラー] システム: ' + msg + #13#10;
        Exit;
    end;

    //エラー近くの文字列を切り取って表示する
    len := StrLen(sp.ptr); if len > 32 then len := 32;
    if len > 0 then
    begin
      SetLength(ss,len);
      StrLCopy(PChar(ss), sp.ptr, len);
      ss := string(PChar(ss));
      ss := JReplace(ss,#13#10,'(改行)',True);
      ss := JReplace(ss,'%','%%',True);
    end else
    begin
      ss := '';
    end;
    //
    fname := SourceFileName(sp.fileNo);
    //
    if (NowFunc <> '') then msg := msg + '(関数:"'+NowFunc+'")';
    if (sp.cmd <> '')and(sp.cmd <> NowFunc) then ss := '(命令:"' + sp.cmd + '") "' + ss else ss := '"' + ss;

    if nowpos.fileNo = sp.fileNo then
    begin
        if nowpos.lineNo <> sp.lineNo then
        begin
            Result := '[エラー] '+ fname +
                '('+IntToStr(sp.lineNo)+'),('+IntToStr(nowpos.lineNo)+'): ' + msg + ss+'"の近く' + #13#10;
        end else
        begin
            Result := '[エラー] '+ fname +
                '('+IntToStr(sp.lineNo)+'): ' + msg + ss+'"の近く' + #13#10;
        end;
    end else
    begin
        Result := '[エラー] '+ fname +
            '('+IntToStr(sp.lineNo)+'),'+ SourceFileName(nowpos.fileNo)+
            '('+IntToStr(nowpos.lineNo)+'): ' + msg + ss+'"の近く' +#13#10;
    end;

    FlagStopCompile := True;
end;

function TMmlSystem.GetCurCCList: TCCList;
begin
    Result := SongInfo.CC[CurTrack.Channel];
end;

function TMmlSystem.GetCurCCNote(no: Integer): TNoteCC;
var
    cc: TCCList;
begin
    cc := GetCurCCList;
    Result := cc.FindCC(no);
    if Result=nil then
    begin
        Result := TNoteCC.Create ;
        cc.Add(Result); 
    end;
end;

function TMmlSystem.GetMaruKakko(var sp: TSrcPos): string;
begin
    try
        Result := mml_token.GetMaruKakko(sp.ptr, sp.lineNo);
    except
        on e: Exception do
            raise EMml.Create(ErrMsg(e.Message, sp));
    end;
end;

function TMmlSystem.GetNakaKakko(var sp: TSrcPos): string;
begin
    try
        Result := mml_token.GetNakaKakko(sp.ptr, sp.lineNo);
    except
        on e: Exception do
            raise EMml.Create(ErrMsg(e.Message, sp));
    end;
end;

function TMmlSystem.NtoStep(n: Integer): Integer;
// sakura ver.1.xx だと 4/4で固定した値を返す
{var
    base : Integer;
begin
    with SongInfo do
    begin
        base := Trunc( timebase * (4/TimeSigHa) );
        if n<>0 then
            Result := Trunc((base*TimeSigKo) / n)
        else
            Result := 0;
    end;
end;
}
begin
    with SongInfo do
    begin
        if n<>0 then
            Result := Trunc( (TimeBase * 4) / n )
        else
            Result := 0;
    end;
end;


procedure TMmlSystem.PrintCon(msg: string; sp: TSrcPos);
begin
    CompilerMessage := CompilerMessage + '[表示] '+
        IncludedFiles.Strings[sp.fileNo] + '('+IntToStr(sp.lineNo)+'): ' + msg + #13#10;
end;

procedure TMmlSystem.SetCurTrack(Index: Integer);
begin
    CurTrack := SongInfo.GetTrack(Index, SongInfo.TimeBase);
    CurSmfTrack := SmfSong.GetTrack(Index);
end;

procedure TMmlSystem.ShowHint(msg: string; sp: TSrcPos);
var
    txt: string;
begin
    if (sp.cmd <> '')and(sp.cmd <> NowFunc) then msg := msg + '(命令:"' + sp.cmd + '")';
    if NowFunc <> '' then msg := msg + '(関数:"'+NowFunc+'")';
    if sp=nil then
    begin
        txt := '[ヒント] (-1)' + msg;
    end else
    begin
        txt := '[ヒント] '+ IncludedFiles.Strings[sp.fileNo] + '('+IntToStr(sp.lineNo)+'): ' + msg + #13#10;
    end;

    if JPosEx(txt, CompilerMessage,1) = 0 then
    begin
        CompilerMessage := CompilerMessage + txt;
    end;
end;

function TMmlSystem.SourceFileName(fno: Integer): string;
begin
    if fno<0 then
    begin
        Result := 'システム';
    end else
    begin
        try
        Result := IncludedFiles.Strings[fno];
        except
        Result := 'システム';
        end;
    end;
end;

function TMmlSystem.StepToTime(step: Integer): TMTime;
var
    base: Integer;
    mes_step: Integer;
begin
    with SongInfo do
    begin
        base := Trunc( timebase * (4/TimeSigHa) );
        //小節数を求める
        mes_step := base*TimeSigKo;

        Result.mes := step div mes_step; //小節数を取得
        step       := step mod mes_step; //小節数の残りを得る
        Result.beat := step div base;    //拍数を取得
        Result.tick := step mod base;    //

        //1から数えるものは、１を足す
        Inc(Result.mes);
        Inc(Result.beat);

        Result.mes := Result.mes - SongInfo.MeasureShift ; // これにより、システム設定を１小節目以前にもってくることができる
    end;
end;

function TMmlSystem.TimeToStep(mes, beat, tick: Integer): Integer;
var
    base: Integer;
begin
    mes := mes + SongInfo.MeasureShift ; // これにより、システム設定を１小節目以前にもってくることができる


    // 4/4 ならば、
    // (mes-1)*(timebase*4) + (beat-1)*timebase + tick

    // 6/8 ならば、
    // base = timebase div 2
    // (mes-1)*(base*6) + (beat-1)*base + tick

    //よって、汎用的な計算式は、
    with SongInfo do
    begin
        base := Trunc( timebase * (4/TimeSigHa) );
        Result := (mes-1)*(base*TimeSigKo) + (beat-1)*base + tick;
    end;
    //※ mes-1 , beat-1 の理由は、これらは、普通、１から数えるので。
end;


procedure TMmlSystem.WriteEndOfTrack;
var
    i: Integer;
    p: TTrackInfo;
    ps: TSmfTrack ;

begin
    for i:=0 to SongInfo.Count -1 do
    begin
        p := SongInfo.Items[ i ];
        if p=nil then Continue;
        ps := SmfSong.GetTrack(i);
        ps.LastTime := p.TimePtr ;
    end;
    //LastTimeに、最後のポインタを入れているだけ
    //実際は、smf_types の、SmfSong.SaveToFileの中で書く
end;


function TMmlSystem.GetVariable(var sp: TSrcPos): TMVarCustom;
var
    key: string;
    node: TMHashNode;
begin
    //カンマまでを得る
    //key := getTokenMML(sp.ptr);
    key := mml_token.getTokenWord(sp.ptr);

    if Copy(key,1,1)='#' then //例外的な文字列、"#変数"の処理
    begin
        node := Commands.Items[ key ];
        if node=nil then begin //なければ作る
            node := TMhashNode.Create(key) ;
            node.value := TMStr.Create ;
            ParentCommands.Add(node);
        end;
    end else
    begin
        node := Commands.Items[ key ];
    end;
    if node=nil then
    begin
        //keyをそのまま返す
        Result := TMStr.Create ;
        TMStr(Result).value := key;
        Exit;
        //raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_NOT_FOUND,sp),[ key ]);
    end;
    //node を渡して、値を得る
    Result := ExecuteCommand(node, sp);
end;

end.
