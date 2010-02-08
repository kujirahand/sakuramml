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
          DeleteKey('\.mml');                        // �g���q.xxx ��o�^
      end;
      if KeyExists('\mmlFile') then
      begin
          Inc(cnt);
          DeleteKey('\mmlFile');                     // xxxFile ��o�^
      end;
      if cnt>0 then
      begin
        SHChangeNotify(SHCNE_ASSOCCHANGED,            //�V�X�e���ɕύX��ʒm
                     SHCNF_FLUSH,nil,nil);
        ShowMessage('".mml" �t�@�C���̊֘A�t�����������܂����B');
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
        if MsgYesNo('���ɑ��̃\�t�g�Ɋ֘A�t��������Ă��܂����A'#13#10+
            '�֘A�t������蒼���܂����H','�g���q".mml"�̊֘A�t��') then
        begin
            mnuUninstallClick(nil);
        end else
        begin
            Exit;
        end;
      end;
      OpenKey('\.mml',True);                        // �g���q.xxx ��o�^
      WriteString('','mmlFile');                    // �g���q.xxx �� xxxFile ���Q��
      OpenKey('\.mml\ShellNew',True);               // �g���q.xxx ��o�^
      WriteString('NullFile','');                   // �V�K�쐬�ɂЂ܂��v���O������ǉ�
      OpenKey('\mmlFile',True);                     // xxxFile ��o�^
      WriteString('','�u�T�N���v�p���y�e�L�X�g');         // Explorer �̐����p
      OpenKey('\mmlFile\DefaultIcon',True);         // Icon �Q�ƃL�[
      WriteString('','"'+AppPath+'tools\mml.ico"'); // Icon �̎w��
      OpenKey('\mmlFile\shell\open\command',True);  // Application �Q�ƃL�[
      WriteString('',                               // Application �̎w��
            '"'+AppPath+'sakura.exe'+'" "%1" %*');
      {�����A�T�u�R�}���h������΁E�E�E
      OpenKey('\hmwFile\shell\�ҏW\command',True);  // Application �Q�ƃL�[
      WriteString('',                               // Application �̎w��
            '"'+AppPath+'himapad.exe'+'" "%1"');
      }
      SHChangeNotify(SHCNE_ASSOCCHANGED,            //�V�X�e���ɕύX��ʒm
                     SHCNF_FLUSH,nil,nil);
      ShowMessage('".mml"�t�@�C���ɁA�T�N�����֘A�t���܂����B'#13#10+
          '���ꂩ��A".mml"�t�@�C�����_�u���N���b�N���������ŁA���t����܂��B');
    finally
      Free;
    end;
  end;
end.
