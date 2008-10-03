unit gui_benri;
// 説　明：面倒な手続きをユニットにまとめたもの
// 作　者：山本峰章(mine@text2music.com)
// 公開日：2001/10/21

interface
uses
  SysUtils, Classes, Forms, Windows, ShellApi, ComObj, ActiveX, ShlObj, Registry;

function AppPath: string;

function MsgYesNo(msg: string): Boolean; overload;
function MsgYesNo(msg,cap: string): Boolean; overload;
function MsgYesNoCancel(msg: string): Integer; overload;
function MsgYesNoCancel(msg,cap: string): Integer; overload;
procedure ShowWarn(msg,cap: string);//警告ダイアログを表示
procedure ShowInfo(msg,cap: string);//情報ダイアログを表示


{Windowsフォルダを得る}
function WinDir:string;
{Systemフォルダを得る}
function SysDir:string;
{Tempフォルダを得る}
function TempDir:string;
{デスクトップフォルダを得る}
function DesktopDir:string;
{特殊フォルダを得る}
function GetSpecialFolder(const loc:Word): string;
function SendToDir:string;
function StartUpDir:string;
function StartMenuDir:string;
function MyDocumentDir:string;
function GomibakoDir:string;
function FavoritesDir:string;
function ProgramsDir:string;


{オリジナル一時ファイル名の取得(dirnameを省略で、TempDirを参照)}
function getOriginalFileName(dirname, header: string): string;

{ショートカットを作成する}
function CreateShortCut(Name, Target, Arg, WorkDir: string; State: TWindowState): Boolean;

function StrToDateDef(const StrDate, DefDate: string): TDateTime;

{chkDayが、baseDay以降なら、True を返す}
function DateAfter(const baseDay, chkDay: TDateTime): Boolean;

function makeShortcut(FilePath, Description, WorkDir: string): Boolean;
function makeShortcutDesktop(FilePath, Description, WorkDir: string): Boolean;

{サブフォルダまで一気にコピーする}
function SHFileCopy(const Sorce, Dest: string): Boolean;
function SHFileDelete(const Sorce: string): Boolean;
function SHFileMove(const Sorce, Dest: string): Boolean;
function SHFileRename(const Sorce, Dest: string): Boolean;


{Windows の XCopy.exe を使って、一気にコピー}
procedure XCopy(const Sorce, Dest: string);

{ファイルに任意の文字列を書きこむ}
function WriteTextFile(const fname, str:string):Boolean;
function ReadTextFile(const fname:string; var str:string):Boolean;

{ソフトを起動する}
function RunApp(const fname: String): Boolean;
function OpenApp(const fname: string): Integer;
function RunAppAndWait(const fname: string): Boolean;

{ディレクトリの選択：右下に表示されないバージョン：OwnerHandleを、フォームのものにする}
function SelectDirectoryEx(const Caption: string; const Root: WideString;
  out Directory: string; OwnerHandle: THandle): Boolean;

{長いファイル名を得る}
function ShortToLongFileName(ShortName: String):String;

{Windowsのバージョンを文字列で列挙}
function getWinVersion: string;


implementation

function OpenApp(const fname: string): Integer;
begin
    Result := ShellExecute(0, 'open', PChar(fname),'','',SW_SHOW);
end;

function RunAppAndWait(const fname: string): Boolean;
var
  SI :TStartupInfo;
  PI :TProcessInformation;
begin
    GetStartupInfo(SI);
    try
        if not CreateProcess(nil, PChar(fname), nil,nil,False, 0, nil, nil,
            SI, PI) then raise Exception.Create('Error!');

        while WaitForSingleObject(PI.hProcess, 0) = WAIT_TIMEOUT do
            Application.ProcessMessages;       // プロセス終了まで待機する

        Result := True;
    except
        Result := False;
    end;
end;





function getWinVersion: string;
var
    //s: string;
    major,minor: LongInt;
    Info: TOSVersionInfo;
begin
    Info.dwOSVersionInfoSize := SizeOf(Info);
    GetVersionEx(Info);
    Major := Info.dwMajorVersion ;
    Minor := Info.dwMinorVersion ;
    case major of
        4://95/98/ME/NT
            begin
                if Info.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then
                begin
                    case Minor of
                        0 :Result := 'Windows 95';
                        10:Result := 'Windows 98';
                        90:Result := 'Windows Me';
                    end;
                end else
                if Info.dwPlatformId = VER_PLATFORM_WIN32_NT then
                begin
                    Result := 'Windows NT 4.0';
                end;
            end;
        3://NT 3.51
            begin
                Result := 'Windows NT 3.51';
            end;
        5://2000/XP/.NET Server
            begin
                case Minor of
                    0: Result := 'Windows 2000';
                    1: Result := 'Windows XP';
                end;
            end;
        else begin
            Result := '不明 Version = '+ IntToStr(GetVersion);
        end;
    end;
    {上手く動かない
    s := string(PChar(@Info.szCSDVersion[1]));
    if s<>'' then
    begin
        Result := Result + s;
    end;}
end;


function ShortToLongFileName(ShortName: String):String;
var
  SearchRec: TSearchRec;
begin
  result:= '';
  // フルパス化
  ShortName:= ExpandFileName(ShortName);
  // 長い名前に変換（ディレクトリも）
  while LastDelimiter('\', ShortName) >= 3 do begin
    if FindFirst(ShortName, faAnyFile, SearchRec) = 0 then
      try
        result := '\' + SearchRec.Name + result;
      finally
        // 見つかったときだけ Close -> [Delphi-ML:17508] を参照

        Sysutils.FindClose(SearchRec);
      end
    else
      // ファイルが見つからなければそのまま
      result := '\' + ExtractFileName(ShortName) + result;
    ShortName := ExtractFilePath(ShortName);
    SetLength(ShortName, Length(ShortName)-1); // 最後の '\' を削除
  end;
  result := ShortName + result;
end;




{オリジナル一時ファイル名の取得}
function getOriginalFileName(dirname, header: string): string;
var
    i: Integer;
    fname,s,ext: string;
begin
    if dirname='' then dirname := TempDir;
    i   := 1;
    s   := header;
    ext := ExtractFileExt(header);
    s   := Copy(s,1, Length(s)-Length(ext));
    if Copy(dirname,Length(dirname),1)<>'\' then dirname := dirname + '\';
    while True do
    begin
        fname := dirname + s + IntToStr(i) + ext;
        if FileExists(fname) = False then
        begin
            Result := fname; Break;
        end;
        Inc(i);
    end;
end;


function SelectDirectoryEx(const Caption: string; const Root: WideString;
  out Directory: string; OwnerHandle: THandle): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
  s: string;
begin
  Result := False;
  Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    s := GetCurrentDir ;
    StrCopy(Buffer, PChar(s));
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
        hwndOwner := OwnerHandle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);
      end;
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;


{ソフトを起動する}
function RunApp(const fname: String): Boolean;
var
    retCode: Integer;
begin
    retCode := WinExec(PChar(fname), SW_SHOW);
    if retCode > 31 then
    begin
        Result:= True;
    end else
    begin
        Result :=False;
    end;
end;


{chkDayが、baseDay以降（その日を含む）なら、True を返す}
function DateAfter(const baseDay, chkDay: TDateTime): Boolean;
var
	y1,m1,d1,  y2,m2,d2: Word;
    v1, v2: DWORD;
begin
    Result := False;
	DecodeDate(baseDay, y1, m1, d1);
    DecodeDate(chkDay,  y2, m2, d2);
    v1 := y1*365 + m1*12 + d1;
    v2 := y2*365 + m2*12 + d2;
	if v1 <= v2 then Result := True;
end;

{Windowsフォルダを得る}
function WinDir:string;
var
 TempWin:array[0..MAX_PATH] of Char;
begin
 GetWindowsDirectory(TempWin,MAX_PATH);
 Result:=StrPas(TempWin);
 if Copy(Result,Length(Result),1)<>'\' then Result := Result + '\';
end;

{Systemフォルダを得る}
function SysDir:string;
var
 TempSys:array[0..MAX_PATH] of Char;
begin
 GetSystemDirectory(TempSys,MAX_PATH);
 Result:=StrPas(TempSys);
 if Copy(Result,Length(Result),1)<>'\' then Result := Result + '\';
end;

{Tempフォルダを得る}
function TempDir:string;
var
 TempTmp:array[0..MAX_PATH] of Char;
begin
 GetTemppath(MAX_PATH,TempTmp);
 Result:=StrPas(TempTmp);
 if Copy(Result,Length(Result),1)<>'\' then Result := Result + '\';
end;


function GetSpecialFolder(const loc:Word): string;
var
   PathID: PItemIDList;
   Path : array[0..MAX_PATH] of char;
begin
   SHGetSpecialFolderLocation(Application.Handle, loc, PathID);
   SHGetPathFromIDList(PathID, Path);
   Result := string(Path);
   if Copy(Result, Length(Result),1)<>'\' then
    Result := Result + '\';
end;

function DesktopDir:string;
begin
   Result := GetSpecialFolder(CSIDL_DESKTOPDIRECTORY);
end;
function SendToDir:string;
begin
   Result := GetSpecialFolder(CSIDL_SENDTO);
end;
function StartUpDir:string;
begin
   Result := GetSpecialFolder(CSIDL_STARTUP);
end;
function ProgramsDir:string;
begin
   Result := GetSpecialFolder(CSIDL_PROGRAMS);
end;
function StartMenuDir:string;
begin
   Result := GetSpecialFolder(CSIDL_STARTMENU);
end;
function MyDocumentDir:string;
begin
   Result := GetSpecialFolder(CSIDL_PERSONAL);
end;
function GomibakoDir:string;
begin
   Result := GetSpecialFolder(CSIDL_BITBUCKET);
end;
function FavoritesDir: string;
begin
   Result := GetSpecialFolder(CSIDL_FAVORITES);
end;

function CreateShortCut(Name, Target, Arg, WorkDir: string; State: TWindowState): Boolean;
var
  IU: IUnknown;
  W: PWideChar;
const
  ShowCmd: array[TWindowState] of Integer =
    (SW_SHOWNORMAL, SW_MINIMIZE, SW_MAXIMIZE);
begin
  Result := False;
  try
    IU := CreateComObject(CLSID_ShellLink);
    with IU as IShellLink do begin
      if SetPath(PChar(Target)) <> NOERROR then Abort;
      if SetArguments(PChar(Arg)) <> NOERROR then Abort;
      if SetWorkingDirectory(PChar(WorkDir)) <> NOERROR then Abort;
      if SetShowCmd(ShowCmd[State]) <> NOERROR then Abort
    end;
    W := PWChar(WideString(Name));
    if (IU as IPersistFile).Save(W, False) <> S_OK then Abort;
    Result := True
  except
  end
end;

function AppPath: string;
begin
	result := ExtractFilePath( ParamStr(0) );
end;

function MsgYesNo(msg: string): Boolean;
var
	i: Integer;
begin
	i := MessageBox(Application.Handle,PChar(msg), PChar(Application.Title), MB_YESNO + MB_ICONQUESTION);
	if i=IDYES then
    	Result := True
    else
    	Result := False;
end;

function MsgYesNo(msg,cap: string): Boolean; overload;
var
	i: Integer;
begin
	i := MessageBox(Application.Handle,PChar(msg),
        PChar(cap), MB_YESNO + MB_ICONQUESTION);
	if i=IDYES then
    	Result := True
    else
    	Result := False;
end;


function MsgYesNoCancel(msg: string): Integer;
begin
	Result := MessageBox(Application.Handle,PChar(msg), PChar(Application.Title), MB_YESNOCANCEL + MB_ICONQUESTION);
end;

function MsgYesNoCancel(msg,cap: string): Integer; overload;
begin
	Result := MessageBox(Application.Handle,PChar(msg), PChar(cap), MB_YESNOCANCEL + MB_ICONQUESTION);
end;

procedure ShowWarn(msg,cap: string);//警告ダイアログを表示
begin
    if cap='' then cap := Application.Title ;
	MessageBox(
        Application.Handle,
        PChar(msg),
        PChar(cap),
        MB_ICONWARNING or MB_OK);
end;
procedure ShowInfo(msg,cap: string);//情報ダイアログを表示
begin
	if cap='' then cap := Application.Title ;
	MessageBox(
        Application.Handle,
        PChar(msg),
        PChar(cap),
        MB_ICONINFORMATION or MB_OK);
end;

function StrToDateDef(const StrDate, DefDate: string): TDateTime;
begin
    if StrDate='' then
    begin
    	Result := StrToDate(DefDate);
        Exit;
    end;
	try
    	Result := StrToDate(StrDate);
    except
    	try
        	Result := StrToDate(DefDate);
        except
        	Result := Date;
        end;
    end;
end;

function makeShortcut(FilePath, Description, WorkDir: string): Boolean;
var
	AnObj: IUnknown;
    ShLink: IShellLink;
    PFile: IPersistFile;
    Reg: TRegIniFile;
    WFilename: WideString ;
begin
	try
	AnObj := CreateComObject(CLSID_ShellLink) as IShellLink;
    ShLink := AnObj as IShellLink;
	PFile := ShLink as IPersistFile;
    ShLink.SetPath (PChar(FilePath));
    ShLink.SetDescription(PChar(Description));
    ShLink.SetWorkingDirectory(PChar(WorkDir));
	//save Desktop
    Reg := TRegIniFile.Create(
    	'Software\MicroSoft\Windows\CurrentVersion\Explorer');
	WFilename := Reg.ReadString('Shell Folders','Desktop','')+
    	'\' + Description + '.lnk';
    Reg.Free ;
    PFile.Save(PWChar(WFilename), False);
    //save StartMenu
    Reg := TRegIniFile.Create(
    	'Software\MicroSoft\Windows\CurrentVersion\Explorer');
	WFilename := Reg.ReadString('Shell Folders','Start Menu','')+
    	'\' + Description + '.lnk';
    Reg.Free ;
    PFile.Save(PWChar(WFilename), False);
    except
    	Result := False; Exit;
    end;
    Result := True;
end;

function makeShortcutDesktop(FilePath, Description, WorkDir: string): Boolean;
var
	AnObj: IUnknown;
    ShLink: IShellLink;
    PFile: IPersistFile;
    Reg: TRegIniFile;
    WFilename: WideString ;
begin
	try
	AnObj := CreateComObject(CLSID_ShellLink) as IShellLink;
    ShLink := AnObj as IShellLink;
	PFile := ShLink as IPersistFile;
    ShLink.SetPath (PChar(FilePath));
    ShLink.SetDescription(PChar(Description));
    ShLink.SetWorkingDirectory(PChar(WorkDir));
	//save Desktop
    Reg := TRegIniFile.Create(
    	'Software\MicroSoft\Windows\CurrentVersion\Explorer');
	WFilename := Reg.ReadString('Shell Folders','Desktop','')+
    	'\' + Description + '.lnk';
    Reg.Free ;
    PFile.Save(PWChar(WFilename), False);
    except
    	Result := False; Exit;
    end;
    Result := True;
end;


function SHFileCopy(const Sorce, Dest: string): Boolean;
var
	foStruct: TSHFileOpStruct;
begin
    Result := False;
    if (Sorce='')or(Dest='') then Exit;
    with foStruct do
    begin
        wnd:=Application.Handle;
        wFunc:=FO_COPY;  //フラグ（コピーの場合はFO_COPY）
        pFrom:=PChar(Sorce+#0#0);  //するフォルダ
        pTo:=PChar(Dest+#0#0);
        fFlags:=FOF_SILENT or FOF_NOCONFIRMATION or FOF_MULTIDESTFILES ;  //ダイアログ非表示
        fAnyOperationsAborted:=False;
        hNameMappings:=nil;
        lpszProgressTitle:=nil;
    end;

    Result := (SHFileOperation(foStruct)=0);
end;

function SHFileDelete(const Sorce: string): Boolean;
var
	foStruct: TSHFileOpStruct;
begin
    with foStruct do
    begin
        wnd:=Application.Handle;
        wFunc:=FO_DELETE;  //フラグ（コピーの場合はFO_COPY）
        pFrom:=PChar(Sorce+#0#0);  //するフォルダ
        pTo:=Nil;
        fFlags:=FOF_SILENT or FOF_NOCONFIRMATION or FOF_ALLOWUNDO or FOF_MULTIDESTFILES;  //ダイアログ非表示
        {fAnyOperationsAborted:=False;
        hNameMappings:=nil;
        lpszProgressTitle:=nil;}
    end;

    Result := (SHFileOperation(foStruct)=0);
(*
  //FileOpの初期化
  //複数ファイルをごみ箱へ削除
  with FileOp do
  begin
    Wnd := Handle;
    wFunc := FO_DELETE;
    pFrom := PChar( FNames);
    pTo := Nil;
    fFlags := FOF_ALLOWUNDO;
  end;

  SHFileOperation( FileOp);
*)
end;
function SHFileMove(const Sorce, Dest: string): Boolean;
var
	foStruct: TSHFileOpStruct;
begin
    with foStruct do
    begin
        wnd:=Application.Handle;
        wFunc:=FO_MOVE;  //フラグ（コピーの場合はFO_COPY）
        pFrom:=PChar(Sorce+#0#0);  //するフォルダ
        pTo:=PChar(Dest + #0#0);
        fFlags:=FOF_NOCONFIRMATION or FOF_ALLOWUNDO;  //ダイアログ非表示
        fAnyOperationsAborted:=False;
        hNameMappings:=nil;
        lpszProgressTitle:=nil;
    end;

    Result := (SHFileOperation(foStruct)=0);
end;

//なんだか、コピーされてしまうようですよ・・・要調査
function SHFileRename(const Sorce, Dest: string): Boolean;
var
	foStruct: TSHFileOpStruct;
begin
    with foStruct do
    begin
        wnd:=Application.Handle;
        wFunc:=FO_RENAME;  //フラグ（コピーの場合はFO_COPY）
        pFrom:=PChar(Sorce+#0#0);  //するフォルダ
        pTo:=PChar(Dest + #0#0);
        fFlags:=FOF_SILENT or FOF_NOCONFIRMATION or FOF_MULTIDESTFILES or FOF_ALLOWUNDO;  //ダイアログ非表示
        fAnyOperationsAborted:=False;
        hNameMappings:=nil;
        lpszProgressTitle:=nil;
    end;

    Result := (SHFileOperation(foStruct)=0);
end;


{Windows の XCopy.exe を使って、一気にコピー}
procedure XCopy(const Sorce, Dest: string);
var s:string;
begin
	s := 'XCOPY.EXE "'+Sorce+'" "'+dest+'" /E';
    WinExec(PChar(s),SW_NORMAL);
end;

{ファイルに任意の文字列を書きこむ}
function WriteTextFile(const fname, str:string):Boolean;
var
	s: TStringList;
begin
	Result := True;
	s := TStringList.Create;
    try
    try
    	s.Text := str;
        s.SaveToFile(fname);
    except
    	Result := False;
    end;
    finally
    	s.Free;
    end;
end;
function ReadTextFile(const fname:string; var str:string):Boolean;
var
	s: TMemoryStream;
begin
	Result := True;
	s := TMemoryStream.Create;
    try
    try
        s.LoadFromFile(fname);
        if s.Size=0 then Exit;
        SetLength(str, s.Size);
        s.Position := 0;
        s.Read(str[1], s.Size);
    except
    	Result := False;
    end;
    finally
    	s.Free;
    end;
end;


end.
