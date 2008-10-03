unit DirUtil;
// ���@���F�ėp�f�B���N�g���������j�b�g�BPerl��Glob���C�N�Ɏg����
// ��@�ҁF�R�{���(mine@text2music.com) http://www.text2music.com
// ���J���F2001/10/21
{------------------------------------------------
�t�H���_���̃t�@�C����񋓂�����A�T�u�f�B���N�g���ȉ��̑S�t�@�C����񋓁B
Perl��Glob��ڎw���č�������j�b�g�B

�g�����F
var
  g: TGlob;
begin
  g := TGlob.Create( path );
  ShowMessage( g.FileList.Text ); //�t�@�C���ꗗ
  ShowMessage( g.DirList.Text ); //�t�H���_�ꗗ
  g.Free;
end;

�T�u�f�B���N�g���ȉ��̑S�t�@�C�����
var
  s: TStringList;
begin
  s := getAllFiles(path + filter);
  ShowMessage( s.Text ); //�S�t�@�C����\��
  s.Free;
end;
}
interface
uses
  SysUtils, Classes, Windows, FileCtrl,Forms, comctrls, stdctrls, Dialogs;

type
  TGlob = class
  private
    rec: TSearchRec;
    CurPath: string;
  public
    DirList: TStringList;
    FileList: TStringList;
    constructor Create(path: string);
    destructor Destroy; override;
    procedure ChangePath(path: string);
    function GetPath : string;
    function DeleteAllFile: Boolean;
    function DeleteForceDir: Boolean;
    function CopyDirectory(toPath: string):Boolean;
    function CopyDirectory2(path: String; proBar:TProgressBar; lbl:TLabel): Boolean;
  end;

{�t�@�C���̊g���q���킸�A���̖��O�t�@�C�������邩�ǂ����`�F�b�N
 ����΁A���̃t�@�C�������A�Ȃ���΁A''��Ԃ�}
function ExistsFileNameWE(path: string): string;

{���C���h�J�[�h�Ŏ����t�@�C����K���ɓ��肷��B}
function FindLikeFile(path: string): string;

{�f�B���N�g���ȉ��̊��S�R�s�[}
function DirCopy(const FromPath, ToPath: string):Boolean;
function DirCopy2(const FromPath, ToPath: string; proBar: TProgressBar; lbl:TLabel):Boolean;

{�f�B���N�g���ȉ��̊��S����}
function DirDelete(path: string):Boolean;

{�K�w�ȉ��̑S�Ẵt�@�C���𓾂�}
function getAllFiles(const path: string): TStringList;

{�t�@�C���T�C�Y�̏��������ɕ��ׂ�}
procedure SortFileSize(sl:TStringList);
function GetFileSizeEasy(fname: string): Integer;

{�t�@�C���̍X�V�������ɕ��ׂ�}
procedure SortFileDate(sl:TStringList);

implementation

{�t�@�C���̍X�V�������ɕ��ׂ�}
procedure SortFileDate(sl:TStringList);
var i,j,szi,szj:Integer; s: string;
begin
	if sl=nil then Exit;

    for i:=0 to sl.Count -1 do
    begin
    	for j:=0 to sl.Count - 1 do
        begin
            if i=j then Continue;
            try
            szi := FileAge(sl.Strings[i]);
            szj := FileAge(sl.Strings[j]);
            if szi < szj then
            begin //swap
            	s := sl.Strings[i];
                sl.Strings[i] := sl.Strings[j];
                sl.Strings[j] := s;
            end;
            except
            	Continue;
            end;
        end;
    end;
end;

{�t�@�C���T�C�Y�̏��������ɕ��ׂ�}
function GetFileSizeEasy(fname: string): Integer;
var f:File;
begin
  Result := 0;
  if FileExists(fname) then
  begin
    AssignFile(f, fname); Reset(f);
    Result := FileSize(f);
    closeFile(f);
  end;
end;

procedure SortFileSize(sl:TStringList);
var i,j,szi,szj:Integer; s: string; f:File;
begin
	if sl=nil then Exit;

    for i:=0 to sl.Count -1 do
    begin
    	for j:=0 to sl.Count - 1 do
        begin
            if i=j then Continue;
            try
            AssignFile(f, sl.Strings[i]); Reset(f);
            szi := FileSize(f);
            closeFile(f);
            AssignFile(f, sl.Strings[j]); Reset(f);
            szj := FileSize(f);
            closeFile(f);
			if szi < szj then
            begin //swap
            	s := sl.Strings[i];
                sl.Strings[i] := sl.Strings[j];
                sl.Strings[j] := s;
            end;
            except
            	Continue;
            end;
        end;
    end;
end;

{�K�w�ȉ��̑S�Ẵt�@�C���𓾂�}
function getAllFiles(const path: string): TStringList;
var
	sl: TStringList;
    filter, ps: string;

    procedure checkDir(path:string);
    var i:Integer; g:TGlob;
    begin

		g := TGlob.Create(path+Filter);
        try
        	for i:=0 to g.FileList.Count - 1 do
            begin
            	sl.Add(g.GetPath + g.FileList.Strings[i]);
            end;
        finally
            g.Free;
        end;

		g := TGlob.Create(path);
        try
        	for i:=0 to g.DirList.Count - 1 do
            begin
                if Copy(g.DirList.Strings[i],1,1)='.' then Continue;
                checkDir(g.GetPath + g.DirList.Strings[i]+'\');
            end;
        finally
            g.Free;
        end;
    end;

begin
    filter := ExtractFileName(path);
    ps := ExtractFilePath(path);

	sl := TStringList.Create;
    try
    	checkDir(ps);
    except
    	sl.Free;
        sl :=  nil;
    end;
    Result := sl;
end;

{�f�B���N�g���ȉ��̊��S����}
function DirDelete(path: string):Boolean;
var
	g:TGlob;
begin
	g := TGlob.Create(path);
    try
    	Result := g.DeleteForceDir;
    finally
    	g.Free;
    end;
end;

{�f�B���N�g���ȉ��̊��S�R�s�[}
function DirCopy(const FromPath, ToPath: string):Boolean;
var
	glob:TGlob;
begin
	glob := TGlob.Create(FromPath);
    try
    	Result := glob.CopyDirectory(ToPath);
    finally
    	glob.Free ;
    end;
end;

function DirCopy2(const FromPath, ToPath: string; proBar: TProgressBar; lbl:TLabel):Boolean;
var
	glob:TGlob;
begin
    Result := False;
	glob := TGlob.Create(FromPath);
    try
    	try
    		Result := glob.CopyDirectory2(ToPath, proBar, lbl);
        except
        	raise EFilerError.Create('');
        end;
    finally
    	glob.Free ;
    end;
end;

{���C���h�J�[�h�Ŏ����t�@�C����K���ɓ��肷��B}
function FindLikeFile(path: string): string;
var
    glob: TGlob;
begin
    glob := TGlob.Create(path);
    try
		if glob.FileList.Count > 0 then
        	Result := glob.GetPath + glob.FileList.Strings[0]
        else
        	Result := '';
    finally
    	glob.Free ;
    end;
end;


{�t�@�C���̊g���q���킸�A���̃t�@�C�������邩�ǂ����`�F�b�N
 ����΁A���̃t�@�C�������A�Ȃ���΁A''��Ԃ�}
function ExistsFileNameWE(path: string): string;
var
	p, fname, d: string;
    glob: TGlob;
begin
	p := ExtractFilePath(path);
    fname := ExtractFileName(path);
    d := ExtractFileExt(path);
    path := p + Copy(fname, 1, Length(fname)-Length(d));
	path := path + '.*';
    glob := TGlob.Create(path);
    try
		if glob.FileList.Count > 0 then
        	Result := p + glob.FileList.Strings[0]
        else
        	Result := '';
    finally
    	glob.Free ;
    end;
end;


{ TGlob }

procedure TGlob.ChangePath(path: string);
	procedure chkType;
    var s: string;
    begin
        s := rec.Name ;
        if (rec.Attr and faDirectory) = faDirectory	then
        begin
        	if Copy(rec.Name,1,1) = '.' then
            begin
            	//�J�����g�f�B���N�g���́A�����Ȃ��B
            end else begin
        	    DirList.Add( s );
            end;
        end else begin
        	FileList.Add( s );
        end;
    end;
begin
	CurPath := ExtractFilePath(path);
    DirList.Clear;
    FileList.Clear;
	if FindFirst(path, faAnyFile, rec) = 0 then
    begin
        chkType;
        while FindNext(rec) = 0 do
        begin
            chkType;
        end;
        SysUtils.FindClose(rec);
    end;
end;


function TGlob.CopyDirectory(toPath: string): Boolean;
var
	nowPath, s: string;
    i: Integer;
    procedure copyAllFile(glob:TGlob; des:string);
    var i:integer; s,s1,s2:string;
    begin
    	des := ExtractFilePath(des);
		if false=DirectoryExists(des) then
        begin
            ForceDirectories(des);
        end;
    	for i:=0 to glob.FileList.Count - 1 do
        begin
            s  := glob.FileList.Strings[i];
            s1 := glob.GetPath + s;
            s2 := des + s;
            if CopyFile(PChar(s1), PChar(s2), False)=False then
            	Result := False
            else begin
        		FileSetAttr(s2, 0);
            end;
        end;
    end;
    procedure subCopy(src,des:string);
    var glob: TGlob; i:Integer; s:string;
    begin
    	glob := TGlob.Create(src);
        try
    		for i:=0 to glob.DirList.Count - 1 do
            begin
                s := glob.DirList.Strings[i];
            	subCopy(glob.GetPath+s+'\', des+s+'\');
            end;
            copyAllFile(glob, des);
        finally
        	glob.Free;
        end;
    end;
begin
    Result := True;
	nowPath := GetPath ;
	for i:=0 to DirList.Count - 1 do
    begin
    	s := DirList.Strings[i];
        subCopy(nowPath+s+'\', ExtractFilePath(toPath)+s+'\');
        Application.ProcessMessages;
    end;
    copyAllFile(self, toPath);
end;

function TGlob.CopyDirectory2(path: String; proBar: TProgressBar;
  lbl: TLabel): Boolean;
var
	nowPath, s: string;
    i, cnt: Integer;
    sl: TStringList;
    procedure copyAllFile(glob:TGlob; des:string);
    var i:integer; msg,s,s1,s2:string;
    begin
    	des := ExtractFilePath(des);
		if false=DirectoryExists(des) then
        begin
            ForceDirectories(des);
        end;
    	for i:=0 to glob.FileList.Count - 1 do
        begin
            s  := glob.FileList.Strings[i];
            s1 := glob.GetPath + s;
            s2 := des + s;

            if FileExists(s2) then
            begin
            	FileSetAttr(s2, 0);
            	DeleteFile(PChar(s2));
            end;
            FileSetAttr(s2, 0);
            if CopyFile(PChar(s1), PChar(s2), False)=False then
            begin
            	Result := False;
                msg := ('"'+s1+'"����A'#13#10'"'+
                	s2+'" �ւ̃R�s�[�Ɏ��s���܂����B');
                ShowMessage(msg);
                raise EFilerError.Create(msg);
            end else begin
        		FileSetAttr(s2, 0);
            end;
            proBar.Position := cnt; Inc(cnt);
            lbl.Caption := ExtractFileName(s1);
            Application.ProcessMessages ;
        end;
    end;
    procedure subCopy(src,des:string);
    var glob: TGlob; i:Integer; s:string;
    begin
    	glob := TGlob.Create(src);
        try
    		for i:=0 to glob.DirList.Count - 1 do
            begin
                s := glob.DirList.Strings[i];
            	subCopy(glob.GetPath+s+'\', des+s+'\');
            end;
            copyAllFile(glob, des);
        finally
        	glob.Free;
        end;
    end;
begin
    Result := True;
    sl := GetAllFiles(nowPath+'*');
    try
    try
	nowPath := GetPath ;
    proBar.Max := sl.Count;
    cnt := 0;

	for i:=0 to DirList.Count - 1 do
    begin
    	s := DirList.Strings[i];
        subCopy(nowPath+s+'\', ExtractFilePath(Path)+s+'\');
        Application.ProcessMessages;
    end;
    copyAllFile(self, Path);
    proBar.Position := proBar.Max ;
    except
        ShowMessage('"'+nowPath+s+'\"�̃R�s�[�ŃG���[');
        ShowMessage('�C���X�g�[���Ɏ��s���܂����B�Ď��s���Ă��������B');
        raise EFilerError.Create('"'+nowPath+s+'\"�̃R�s�[�ŃG���[');
    end;
    finally
        sl.Free;
    end;
end;

constructor TGlob.Create(path: string);
begin
	DirList := TStringList.Create ;
    FileList := TStringList.Create;
    if Copy(path,Length(path),1)='\' then
    	path := path + '*';
    ChangePath(path);
end;

function TGlob.DeleteAllFile: Boolean;
var
	i: Integer;
    s: string;
begin
    Result := True;
	for i:=0 to FileList.Count - 1 do
    begin
    	s := CurPath + FileList.Strings[i];
        if SysUtils.DeleteFile(s) = False then
        	Result := False;
    end;
end;

function TGlob.DeleteForceDir: Boolean;
var
	i: Integer;
    path: string;
    function DelDir(path: string): Boolean;
    var g:TGlob;
    begin
        path := ExtractFilePath(path)+'*.*';
    	g := TGlob.Create(path);
        try
        	Result := g.DeleteForceDir;
        finally
        	g.Free;
        end;
    end;
begin
    Result := True;
	for i:=0 to DirList.Count - 1 do
    begin
    	path := CurPath + DirList.Strings[i] + '\';
		if DelDir(path)=False then
        	Result := False;
    end;
    if DeleteAllFile=False then Result := False;
    if RemoveDir(CurPath)=False then Result := False;
end;

destructor TGlob.Destroy;
begin
	inherited;
    DirList.Free;
    FileList.Free;
end;

function TGlob.GetPath: string;
begin
	Result := ExtractFilePath(CurPath);
end;

end.
