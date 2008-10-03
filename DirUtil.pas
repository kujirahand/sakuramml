unit DirUtil;
// 説　明：汎用ディレクトリ処理ユニット。PerlのGlobライクに使える
// 作　者：山本峰章(mine@text2music.com) http://www.text2music.com
// 公開日：2001/10/21
{------------------------------------------------
フォルダ内のファイルを列挙したり、サブディレクトリ以下の全ファイルを列挙。
PerlのGlobを目指して作ったユニット。

使い方：
var
  g: TGlob;
begin
  g := TGlob.Create( path );
  ShowMessage( g.FileList.Text ); //ファイル一覧
  ShowMessage( g.DirList.Text ); //フォルダ一覧
  g.Free;
end;

サブディレクトリ以下の全ファイルを列挙
var
  s: TStringList;
begin
  s := getAllFiles(path + filter);
  ShowMessage( s.Text ); //全ファイルを表示
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

{ファイルの拡張子を問わず、その名前ファイルがあるかどうかチェック
 あれば、そのファイル名を、なければ、''を返す}
function ExistsFileNameWE(path: string): string;

{ワイルドカードで似たファイルを適当に特定する。}
function FindLikeFile(path: string): string;

{ディレクトリ以下の完全コピー}
function DirCopy(const FromPath, ToPath: string):Boolean;
function DirCopy2(const FromPath, ToPath: string; proBar: TProgressBar; lbl:TLabel):Boolean;

{ディレクトリ以下の完全消去}
function DirDelete(path: string):Boolean;

{階層以下の全てのファイルを得る}
function getAllFiles(const path: string): TStringList;

{ファイルサイズの小さい順に並べる}
procedure SortFileSize(sl:TStringList);
function GetFileSizeEasy(fname: string): Integer;

{ファイルの更新履歴順に並べる}
procedure SortFileDate(sl:TStringList);

implementation

{ファイルの更新履歴順に並べる}
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

{ファイルサイズの小さい順に並べる}
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

{階層以下の全てのファイルを得る}
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

{ディレクトリ以下の完全消去}
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

{ディレクトリ以下の完全コピー}
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

{ワイルドカードで似たファイルを適当に特定する。}
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


{ファイルの拡張子を問わず、そのファイルがあるかどうかチェック
 あれば、そのファイル名を、なければ、''を返す}
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
            	//カレントディレクトリは、加えない。
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
                msg := ('"'+s1+'"から、'#13#10'"'+
                	s2+'" へのコピーに失敗しました。');
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
        ShowMessage('"'+nowPath+s+'\"のコピーでエラー');
        ShowMessage('インストールに失敗しました。再試行してください。');
        raise EFilerError.Create('"'+nowPath+s+'\"のコピーでエラー');
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
