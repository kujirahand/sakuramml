unit mml_unit;

{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 https://sakuramml.com
説　明：サクラのＭＭＬをＳＭＦに変換するメインユニット


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
  mml_error,
  mml_base;

type
  TMml2Smf=class(TMmlBase)
  public
    function Execute(str: string; out_file: string): Boolean;
    function GetMessage: string;
  end;

implementation

uses mml_variable, mml_system, mml_var, mml_types, smf_types;

{ TMml2Smf }


function TMml2Smf.Execute(str, out_file: string): Boolean;
var
    ms: TMStr;
    flg: Boolean;

    function chkf(f: string): Boolean;
    begin
      Result := FileExists( f + 'stdmsg.h' );
    end;

    procedure IncludeStdMsg; //標準ファイルを Include する処理
    begin

        if chkf('Include\')or chkf('')or chkf(ExtractFilePath(ParamStr(0)))or
          chkf(ExtractFilePath(ParamStr(0))+'Include\') then
        begin

          try
              Eval('Include(stdmsg.h)');
          except
              CompilerMessage := CompilerMessage + ('[ヒント](-1): 標準ファイル"stdmsg.h"のコンパイルに失敗'#13#10);
          end;

        end else
        begin
          CompilerMessage := CompilerMessage + '[ヒント](-1): stdmsg.h を読み飛ばしました。'#13#10;
        end;
    end;

    procedure CountLineNo;
    var p: PChar;
    begin
        LineCount := 0;
        LastLine := 0;
        p := PChar(str);
        while p^ <> #0 do
        begin
            if p^ in LeadBytes then
                Inc(p,2)
            else
            begin
                if p^ = #13 then Inc(LineCount);
                Inc(p);
            end;
        end;
    end;

begin
    Result := True;
    try
        //---- TMml2Smfのコンパイルメイン関数 ----------------------------------

        //コンパイル開始時間を記録
        if MmlOption.EventLog then
        begin
            if FileExists(MML_LOG) then DeleteFile(MML_LOG); //既存のログファイルがあれば削除
            WriteLog('イベントログ');
            WriteLog(DateTimeToStr(Now));
        end;
        if MmlOption.TimeLog then WriteComTime('初期設定完了');

        //"stdmsg.h"をインクルードするか？
        if MmlOption.IncludeStdMsg then IncludeStdMsg ;
        if MmlOption.TimeLog then WriteComTime('"stdmsg.h"の取込み完了');

        CountLineNo;
        ms := TMStr.Create ;
        ms.value := PreCompile(str, 0);//プリコンパイル

        //ストトンの変換結果をログに残すか?
        if MmlOption.SutotonLog then WriteLog(ms.value);//変換した結果をLOGに保存
        if MmlOption.TimeLog then WriteComTime('ストトンからMMLへ変換完了');

        //標準ファイルに内容をセット
        with nowpos do //現在位置をセット
        begin
            SetTempSource(ms.value) ;
            IncludedSource.Add(ms);
            fileNo := IncludedFiles.Add('');
            lineNo := 0;
        end;

        //コンパイル
        try
            Compile(nowpos);//コンパイル開始
            if FlagStopCompile then
            begin
                Result := False;
                Exit;
            end;
        except
            Result := False;
            Exit;
        end;

        WriteEndOfTrack;
        if MmlOption.TimeLog then WriteComTime('コンパイル完了');

        if Assigned(OnProgress) then
        begin
          flg := False;
          OnProgress(8,10,'コンパイル完了→MIDIデータ生成中',@flg);
          if flg then Exit;
        end;

        //---MIDIファイルへ書き出し
        SmfSong.DebugTime := MmlOption.TimeLog;
        if MmlOption.MldFormat then
        begin
            //SmfSong.SaveToMld(out_file); //Docomo MLD方式で書き出し
        end else
        begin
            SmfSong.SaveToFile(out_file);
        end;
        if MmlOption.TimeLog then WriteComTime('MIDIファイル書き出し完了');
    except
        Result := False;
    end;
end;

function TMml2Smf.GetMessage: string;
begin
    Result := CompilerMessage ;
end;



end.
