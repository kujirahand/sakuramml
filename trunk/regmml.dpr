program regmml;

uses
  System, SysUtils, Windows, Registry, shlobj;

{$R *.res}

function MsgYesNo(s: string; cap: string): Boolean;
begin
  Result := MessageBox(0, PChar(s), PChar(cap), MB_YESNO) = IDYES;
end;

procedure ShowMessage(s: string);
begin
  MessageBox(0, PChar(s), '', MB_OK);
end;

function AppPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure mnuUninstallClick(Sender: TObject);
var
    cnt: Integer;
begin
  cnt := 0;
  with TRegistry.Create do
  begin
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if KeyExists('\.mml') then
      begin
          Inc(cnt);
          DeleteKey('\.mml');                        // 拡張子.xxx を登録
      end;
      if KeyExists('\mmlFile') then
      begin
          Inc(cnt);
          DeleteKey('\mmlFile');                     // xxxFile を登録
      end;
      if cnt>0 then
      begin
        SHChangeNotify(SHCNE_ASSOCCHANGED,            //システムに変更を通知
                     SHCNF_FLUSH,nil,nil);
        ShowMessage('".mml" ファイルの関連付けを解除しました。');
      end;
    finally
      Free;
    end;
  end;
end;

begin
  if ParamCount > 0 then
  begin
    if ParamStr(1) = '/u' then
    begin
      mnuUninstallClick(nil);
    end;
    Exit;
  end;

  with TRegistry.Create do
  begin
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if KeyExists('\.mml') then
      begin
        if MsgYesNo('既に他のソフトに関連付けがされていますが、'#13#10+
            '関連付けをやり直しますか？','拡張子".mml"の関連付け') then
        begin
            mnuUninstallClick(nil);
        end else
        begin
            Exit;
        end;
      end;
      OpenKey('\.mml',True);                        // 拡張子.xxx を登録
      WriteString('','mmlFile');                    // 拡張子.xxx は xxxFile を参照
      OpenKey('\.mml\ShellNew',True);               // 拡張子.xxx を登録
      WriteString('NullFile','');                   // 新規作成にひまわりプログラムを追加
      OpenKey('\mmlFile',True);                     // xxxFile を登録
      WriteString('','「サクラ」用音楽テキスト');         // Explorer の説明用
      OpenKey('\mmlFile\DefaultIcon',True);         // Icon 参照キー
      WriteString('','"'+AppPath+'tools\mml.ico"'); // Icon の指定
      OpenKey('\mmlFile\shell\open\command',True);  // Application 参照キー
      WriteString('',                               // Application の指定
            '"'+AppPath+'sakura.exe'+'" "%1" %*');
      {もし、サブコマンドがあれば・・・
      OpenKey('\hmwFile\shell\編集\command',True);  // Application 参照キー
      WriteString('',                               // Application の指定
            '"'+AppPath+'himapad.exe'+'" "%1"');
      }
      SHChangeNotify(SHCNE_ASSOCCHANGED,            //システムに変更を通知
                     SHCNF_FLUSH,nil,nil);
      ShowMessage('".mml"ファイルに、サクラを関連付けました。'#13#10+
          'これから、".mml"ファイルをダブルクリックしただけで、演奏されます。');
    finally
      Free;
    end;
  end;
end.
