program cSakura;

uses
  SysUtils, classes, windows, ShellAPI;

{$APPTYPE CONSOLE}

function MMLtoMIDI(MMLText, FileName, ErrMsg: PChar):Boolean; stdcall external 'dSakura.dll';
procedure GetVerInfo(s: PChar); stdcall external 'dSakura.dll';
procedure SetErrMsgLen(mLen: Integer); stdcall external 'dSakura.dll';

const MsgLen = 4096;
var
  i, j: Integer;
  c: Array [0..MsgLen-1] of Char;
  ss, s, inFile, outFile, ErrMsg, ver: String;
  cmsg : Array[ 1..MsgLen ] of Char;
  OptionP, OptionMsg, Result: Boolean;
  sl: TStringList;
begin
    ErrMsg := '';
    SetErrMsgLen(MsgLen);// SetErrMsgLength
    GetVerInfo(@c); s := c;
    ver := 'cSakura ---------------------------------'#13#10+
           '           since Oct.1999 (c)クジラ飛行机'#13#10+
           '-----------------------------------------'#13#10+
           '    Console  Ver.1.019 (2002/08/15)'#13#10+
    	   '    Compiler Ver.'+s+#13#10+
           '--------------------------------- cSakura'#13#10;
    Writeln(ver);
    if ParamCount = 0 then begin // Show USES
        Writeln('USES:'#13#10'cSakura MML-File [MIDI-File] [Option]');
        Writeln('Option');
        Writeln('-p     Compile & Play with MediaPlayer');
        Writeln('-msg   Save message to "ErrMsg.txt" & Open Text');
        Exit;
    end;
    j := 0;
    OptionP := False;
    OptionMsg := False;
    Result := False;
    for i:=1 to ParamCount do begin
        s := Trim(ParamStr(i));
        if s='' then Continue;
        if s[1] = '-' then begin
            if s = '-p' then OptionP := True
            else if s = '-msg' then begin
            	OptionMsg := True;
            end else begin
            	ErrMsg := ErrMsg + 'サポートしていないオプション"'+s+'"が指定されました。'#13#10;
            end;
        end else begin
            case j of
                0:begin
                    inFile := s; Inc(j);
                end;
                1:begin
                    outFile := s; Inc(j);
                end;
            end;
        end;
    end;
    if inFile = '' then begin
        ErrMsg := ErrMsg + 'error (-1) : 入力MMLファイルがありません。'#13#10;
    end else begin
        if outFile = '' then begin//自動的に出力ファイルを作る
            s := ExtractFileExt(inFile);
            if s = '' then outFile := inFile + '.mid'
            else begin
                s := ExtractFileName(inFile);
                s := Copy(s,1, (pos('.',s)));
                outFile := ExtractFilePath(inFile) + s + 'mid';
            end;
        end;
        //
        sl := TStringList.Create ;
        s := '';
        try
        try
            sl.LoadFromFile(inFile);
            s := sl.Text;
        except
            ErrMsg := ErrMsg + '入力ファイルが開けません。'#13#10;
        end;
        finally
        	sl.Free ;
        end;
        if s = '' then begin
        	ErrMsg := ErrMsg + '入力ファイルが空です。'#13#10;
        end else begin
            FillChar (cmsg, MsgLen, #0);
            //Compile
            Writeln('Compile Start ...');
            Result := MMLtoMIDI(PChar(s), PChar(outFile), PChar(@cmsg[1]));
            ss := String(PChar(@cmsg[1]));
            if Result then
                ErrMsg := ErrMsg + ss
            else
                ErrMsg := 'error : コンパイルに失敗しました。'#13#10 + ErrMsg + #13#10 + ss;
        end;
    end;
    ErrMsg := ErrMsg + 'ok.'#13#10;
    //last
    if OptionP then
    	if Result then
        begin
        	ShellExecute(0,'open',PChar(outFile),'','',SW_SHOW );
    	end else
        	ErrMsg := ErrMsg + 'そのため曲の演奏は出来ません。';
    if OptionMsg then
    begin
        sl := TStringList.Create ;
        try
        try
            sl.Text := ErrMsg +#13#10+ ver;
            s := ExtractFilePath(ParamStr(0))+'ErrMsg.txt';
            sl.SaveToFile( s );
        except
            Writeln('error : エラーメッセージ出力ファイル　ErrMsg.txt の作成に失敗しました。');
        end;
        finally
        sl.Free ;
        end;
        if pos('error',ErrMsg) > 0 then
            ShellExecute(0,'open',PChar(s),'','',SW_SHOW);
    end else begin
        Writeln(ErrMsg);
    end;
end.
