unit ini_util;

interface
uses
  SysUtils, Classes, Windows, IniFiles, Menus, StdCtrls, forms;

type
  TIniList = class; //前方宣言

  TIniVarType = class
  protected
    ini: TIniList;
  public
    Section,
    Ident: string;
    constructor Create(ini: TIniList; sec, ide: string);
    procedure Read; virtual; abstract;
    procedure Write; virtual; abstract;
  end;

  TIniMenu = class(TIniVarType)
  private
    FMenu: TMenuItem;
    Default: Boolean;
  public
    constructor Create(ini: TIniList; mnu: TMenuItem; sec, ide: string; def:Boolean);
    procedure Read;  override;
    procedure Write; override;
  end;

  TIniEdit = class(TIniVarType)
  private
    Obj: TEdit;
    Default: string;
  public
    constructor Create(ini: TIniList; o: TEdit; sec, ide: string; def:string);
    procedure Read;  override;
    procedure Write; override;
  end;

  TIniScroll = class(TIniVarType)
  private
    Obj: TScrollBar;
    Default: Integer;
  public
    constructor Create(ini: TIniList; o: TScrollBar; sec, ide: string; def:Integer);
    procedure Read;  override;
    procedure Write; override;
  end;

  TIniForm = class(TIniVarType)
  private
    Obj: TForm;
  public
    constructor Create(ini: TIniList; o: TForm; sec, ide: string);
    procedure Read;  override;
    procedure Write; override;
  end;

  TIniCheckBox = class(TIniVarType)
  private
    FCheck: TCheckBox;
    Default: Boolean;
  public
    constructor Create(ini: TIniList; chk: TCheckBox; sec, ide: string; def:Boolean);
    procedure Read;  override;
    procedure Write; override;
  end;

  TIniComboBox = class(TIniVarType)
  private
    FCombo: TComboBox;
    Default: Integer;
  public
    constructor Create(ini: TIniList; cmb: TComboBox; sec, ide: string; def:Integer);
    procedure Read;  override;
    procedure Write; override;
  end;

  TIniListBox = class(TIniVarType)
  private
    FList: TListBox;
    Default: Integer;
  public
    constructor Create(ini: TIniList; lst: TListBox; sec, ide: string; def:Integer);
    procedure Read;  override;
    procedure Write; override;
  end;

  PStr = ^AnsiString;
  TIniString = class(TIniVarType)
  private
    Ptr: PStr;
    Default: string;
  public
    constructor Create(ini: TIniList; p: PStr; sec, ide: string; def:string);
    procedure Read;  override;
    procedure Write; override;
  end;

  PInt = ^Integer;
  TIniInteger = class(TIniVarType)
  private
    Ptr: Pointer;
    Default: Integer;
  public
    constructor Create(ini: TIniList; p: Pointer; sec, ide: string; def:Integer);
    procedure Read;  override;
    procedure Write; override;
  end;

  PBool = ^Boolean;
  TIniBool = class(TIniVarType)
  private
    Ptr: PBool;
    Default: Boolean;
  public
    constructor Create(ini: TIniList; p: PBool; sec, ide: string; def:Boolean);
    procedure Read;  override;
    procedure Write; override;
  end;

  TIniList = class(TIniFile)
  private
    list: TList;
  public
    constructor Create(FileName: string);
    destructor Destroy; override;
    procedure Clear;
    procedure LoadAll;
    procedure SaveAll;
    procedure SaveForm(obj: TForm);
    function LoadForm(obj: TForm): Boolean; // 最大化なら TRUE を返す
    procedure Load(Section: string); //特定のセクションだけロード
    procedure Save(Section: string);
    function AddInt   ( p: Pointer; sec, ide: string; def: Integer): Integer;
    function AddStr   ( p: Pointer; sec, ide: string; def: string): Integer;
    function AddBool  ( p: Pointer; sec, ide: string; def: Boolean): Integer;
    function AddMenu  ( mnu: TMenuItem; sec, ide: string; def: Boolean ): Integer;
    function AddCheck ( chk: TCheckBox; sec, ide: string; def: Boolean ): Integer;
    function AddForm  ( obj: TForm; sec, ide: string): Integer; // サブフォームは追加できない
    function AddScroll( obj: TScrollbar; sec, ide: string; def: Integer ): Integer;
    function AddList  ( obj: TListBox; sec, ide: string; def: Integer ): Integer;
    function AddCombo ( obj: TComboBox; sec, ide: string; def: Integer ): Integer;
    function AddEdit  ( obj: TEdit; sec, ide: string; def: string ): Integer;
  end;

implementation

{ TIniList }

function TIniList.AddBool(p: Pointer; sec, ide: string;
  def: Boolean): Integer;
var
  c: TIniBool ;
begin
  c := TIniBool.Create(Self, p, sec, ide, def);
  Result := list.Add(c);  
end;

function TIniList.AddCheck(chk: TCheckBox; sec, ide: string;
  def: Boolean): Integer;
var
  m: TIniCheckBox;
begin
  m := TIniCheckBox.Create(Self, chk, sec, ide, def);
  Result := list.Add(m);
end;

function TIniList.AddCombo(obj: TComboBox; sec, ide: string;
  def: Integer): Integer;
var
  c: TIniComboBox;
begin
  c := TIniComboBox.Create(Self, obj, sec, ide, def);
  Result := list.Add(c);
end;

function TIniList.AddEdit(obj: TEdit; sec, ide, def: string): Integer;
var
  c: TIniEdit;
begin
  c := TIniEdit.Create(Self, obj, sec, ide, def);
  Result := list.Add(c);
end;

function TIniList.AddForm(obj: TForm; sec, ide: string): Integer;
var
  c: TIniForm;
begin
  c := TIniForm.Create(Self, obj, sec,ide);
  Result := list.Add(c);
end;

function TIniList.AddInt(p: Pointer; sec, ide: string;
  def: Integer): Integer;
var
  i: TIniInteger;
begin
  i := TIniInteger.Create(Self, p, sec,ide, def);
  Result := list.Add(i);
end;

function TIniList.AddList(obj: TListBox; sec, ide: string;
  def: Integer): Integer;
var
  c: TIniListBox;
begin
  c := TIniListBox.Create(Self, obj, sec, ide, def);
  Result := list.Add(c);
end;

function TIniList.AddMenu(mnu: TMenuItem; sec, ide: string;
  def: Boolean): Integer;
var
  m: TIniMenu;
begin
  m := TIniMenu.Create(Self, mnu, sec, ide, def);
  Result := list.Add(m);
end;

function TIniList.AddScroll(obj: TScrollbar; sec, ide: string;
  def: Integer): Integer;
var
  c: TIniScroll;
begin
  c := TIniScroll.Create(Self, obj, sec, ide, def);
  Result := list.Add(c);
end;

function TIniList.AddStr(p: Pointer; sec, ide: string;
  def: string): Integer;
var
  i: TIniString;
begin
  i := TIniString.Create(Self, p, sec,ide, def);
  Result := list.Add(i);
end;

procedure TIniList.Clear;
var
  i: Integer;
  p: TIniVarType;
begin
  for i:=0 to list.Count-1 do
  begin
    p := list.Items[i];
    if p<>nil then p.Free ;
  end;
  list.Clear;
end;

constructor TIniList.Create(FileName: string);
begin
  list := TList.Create ;
  inherited Create(FileName);
end;

destructor TIniList.Destroy;
begin
  Self.Clear ;
  list.Free ;
  inherited;
end;

procedure TIniList.Load(Section: string);
var
  i: Integer;
  p: TIniVarType;
begin
  for i:=0 to list.Count -1 do
  begin
    p := list.Items[i];
    if p.Section = Section then p.Read ;
  end;
end;

procedure TIniList.LoadAll;
var
  i: Integer;
  p: TIniVarType;
begin
  for i:=0 to list.Count -1 do
  begin
    p := list.Items[i];
    p.Read ;
  end;
end;

function TIniList.LoadForm(obj: TForm): Boolean;
var
  Section: string; i: Integer;
begin
  Section := obj.Name ;

  i := ReadInteger(Section, 'state', Ord(obj.WindowState));

  if i = 2 then // Maximize
  begin
    {
    obj.Width  := Trunc(Screen.Width * 0.8);
    obj.Height := Trunc(Screen.Height * 0.8);
    //
    obj.Top := (Screen.Height - obj.Height) div 2;
    obj.Left := (Screen.Width - obj.Width) div 2;
    }
    obj.WindowState := wsMaximized ;
    Result := True;
  end else
  begin
    obj.Top    := ReadInteger(Section, 'top',    obj.Top   );
    obj.Left   := ReadInteger(Section, 'left',   obj.Left  );
    obj.Width  := ReadInteger(Section, 'width',  obj.Width );
    obj.Height := ReadInteger(Section, 'height', obj.Height);
    obj.WindowState := wsNormal ;
    Result := False;
  end;
end;

procedure TIniList.Save(Section: string);
var
  i: Integer;
  p: TIniVarType;
begin
  for i:=0 to list.Count -1 do
  begin
    p := list.Items[i];
    if p.Section = Section then p.Write ;
  end;
end;

procedure TIniList.SaveAll;
var
  i: Integer;
  p: TIniVarType;
begin
  for i:=0 to list.Count -1 do
  begin
    p := list.Items[i];
    p.Write ;
  end;
end;

procedure TIniList.SaveForm(obj: TForm);
var
  Section: string;
begin
  Section := obj.Name ;
  WriteInteger(Section, 'top',    obj.Top   );
  WriteInteger(Section, 'left',   obj.Left  );
  WriteInteger(Section, 'width',  obj.Width );
  WriteInteger(Section, 'height', obj.Height);
  WriteInteger(Section, 'state',  Ord(obj.WindowState));
end;

{ TIniVarType }

constructor TIniVarType.Create(ini: TIniList; sec, ide: string);
begin
  Section := sec;
  Ident   := ide;
  Self.ini := ini;
end;


{ TIniMenu }

constructor TIniMenu.Create(ini: TIniList; mnu: TMenuItem; sec, ide: string;
  def: Boolean);
begin
  FMenu := mnu;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniMenu.Read;
begin
  FMenu.Checked := ini.ReadBool(Section, Ident, Default);
end;

procedure TIniMenu.Write;
begin
  ini.WriteBool(Section, Ident, FMenu.Checked);
end;

{ TIniCheckBox }

constructor TIniCheckBox.Create(ini: TIniList; chk: TCheckBox; sec,
  ide: string; def: Boolean);
begin
  FCheck := chk;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniCheckBox.Read;
begin
  FCheck.Checked := ini.ReadBool(Section, Ident, Default);
end;

procedure TIniCheckBox.Write;
begin
  ini.WriteBool(Section, Ident, FCheck.Checked);
end;

{ TIniString }

constructor TIniString.Create(ini: TIniList; p: PStr; sec, ide,
  def: string);
begin
  Ptr := p;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniString.Read;
begin
  PStr(Ptr)^ := ini.ReadString(Section, Ident, Default);
end;

procedure TIniString.Write;
begin
  ini.WriteString(Section, Ident, PStr(Ptr)^);
end;

{ TIniInteger }


constructor TIniInteger.Create(ini: TIniList; p: Pointer; sec, ide: string;
  def: Integer);
begin
  Ptr := p;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniInteger.Read;
begin
  PInt(Ptr)^ := ini.ReadInteger(Section, Ident, Default);
end;

procedure TIniInteger.Write;
begin
  ini.WriteInteger(Section, Ident, PInt(Ptr)^);
end;

{ TIniComboBox }

constructor TIniComboBox.Create(ini: TIniList; cmb: TComboBox; sec,
  ide: string; def: Integer);
begin
  FCombo := cmb;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniComboBox.Read;
begin
  FCombo.ItemIndex := ini.ReadInteger(Section, Ident, Default);
end;

procedure TIniComboBox.Write;
begin
  ini.WriteInteger(Section, Ident, FCombo.ItemIndex);
end;

{ TIniListBox }

constructor TIniListBox.Create(ini: TIniList; lst: TListBox; sec,
  ide: string; def: Integer);
begin
  FList := lst;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniListBox.Read;
begin
  FList.ItemIndex := ini.ReadInteger(Section, Ident, Default);
end;

procedure TIniListBox.Write;
begin
  ini.WriteInteger(Section, Ident, FList.ItemIndex);
end;

{ TIniBool }

constructor TIniBool.Create(ini: TIniList; p: PBool; sec, ide: string;
  def: Boolean);
begin
  ptr := p;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniBool.Read;
begin
  ptr^ := ini.ReadBool(Section, Ident, Default);
end;

procedure TIniBool.Write;
begin
  ini.WriteBool(Section, Ident, ptr^);
end;

{ TIniEdit }

constructor TIniEdit.Create(ini: TIniList; o: TEdit; sec, ide,
  def: string);
begin
  obj := o;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniEdit.Read;
begin
  obj.Text := ini.ReadString(Section, Ident, Default);
end;

procedure TIniEdit.Write;
begin
  ini.WriteString(Section, Ident, obj.Text);
end;

{ TIniScroll }

constructor TIniScroll.Create(ini: TIniList; o: TScrollBar; sec,
  ide: string; def: Integer);
begin
  obj := o;
  Default := def;
  inherited Create(ini, sec, ide);
end;

procedure TIniScroll.Read;
begin
  obj.Position := ini.ReadInteger(Section, Ident, Default);
end;

procedure TIniScroll.Write;
begin
  ini.WriteInteger(Section, Ident, obj.Position);
end;

{ TIniForm }


constructor TIniForm.Create(ini: TIniList; o: TForm; sec, ide: string);
begin
  obj := o;
  inherited Create(ini, sec, ide);
end;

procedure TIniForm.Read;
begin
  obj.Top    := ini.ReadInteger(Section, Ident+'.top',    obj.Top   );
  obj.Left   := ini.ReadInteger(Section, Ident+'.left',   obj.Left  );
  obj.Width  := ini.ReadInteger(Section, Ident+'.width',  obj.Width );
  obj.Height := ini.ReadInteger(Section, Ident+'.height', obj.Height);
end;

procedure TIniForm.Write;
begin
  ini.WriteInteger(Section, Ident+'.top',    obj.Top   );
  ini.WriteInteger(Section, Ident+'.left',   obj.Left  );
  ini.WriteInteger(Section, Ident+'.width',  obj.Width );
  ini.WriteInteger(Section, Ident+'.height', obj.Height);
end;

end.
