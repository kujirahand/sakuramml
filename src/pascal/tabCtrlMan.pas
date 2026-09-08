unit tabCtrlMan;

interface
uses
  Windows, SysUtils, Classes, ComCtrls, HEditor;

const
  TAB_ID     = '//<テキスト音楽「サクラ」ver.2>';
  TAB_HEADER = '//<HEAD';
  PAGE_FROM  = '//<PAGE';     //ページの区切り
  PAGE_TO    = '//</PAGE>';

type
  PTabPage = ^TTabPage;
  TTabPage = record
    TabName: string;
    TabText: string;
    Caret: TPoint;
  end;

  TTabMan = class(TList)
  private
    FActivePage: Integer;
  public
    Tabs: TTabControl;
    Editor: TEditor;
    property ActivePage: Integer read FActivePage;
    constructor Create(c:TTabControl; e: TEditor);
    destructor  Destroy; override;
    procedure Clear; override;
    procedure AddTabPage(name,text: string; car: TPoint);
    procedure DeleteTabPage(Index: Integer);
    procedure ChangeName(Index: Integer; name: string);
    procedure ChangeActivePage(Index: Integer; OldText: string; OldCaret: TPoint);
    procedure LoadFromFile(fname: string);
    procedure SaveToFile(fname: string);
    procedure SetActivePageText(text: string);
    function GetAllText: string;
    procedure GotoLine(lineNo: Integer; var page, line: Integer);
    procedure SetAllText(text: string);
  end;



implementation

uses StrUnit;

{ TTabMan }

procedure TTabMan.AddTabPage(name, text: string; car: TPoint);
var
    p: PTabPage;
begin
    New(p);
    p^.TabName := name;
    p^.TabText := text;
    p^.Caret := car;
    Add(p);
    Tabs.Tabs.Add(name);
end;

procedure TTabMan.ChangeActivePage(Index: Integer; OldText: string; OldCaret: TPoint);
var
    p: PTabPage ;
begin
    if Count <= Index then Exit;

    if FActivePage >= 0 then
    begin
        p := Items[FActivePage]; //前の状態を記憶
        p^.Caret := OldCaret;
        p^.TabText := OldText;
    end;

    p := Items[Index]; //今度の状態を取得
    Editor.Lines.Text := p^.TabText ;
    Editor.Col := p^.Caret.X ;
    Editor.Row := p^.Caret.Y ;
    FActivePage := Index;
    Tabs.TabIndex := Index;
end;

procedure TTabMan.ChangeName(Index: Integer; name: string);
var
    p: PTabPage ;
begin
    if Count <= Index then Exit;
    p := Items[Index];
    p.TabName := name;
    Tabs.Tabs.Strings[Index] := name;
end;

procedure TTabMan.Clear;
var
    i: Integer;
    p: PTabPage ;
begin
    for i:=0 to Count-1 do
    begin
        p := Items[i];
        if p=nil then Continue;
        Dispose(p);
        Items[i] := nil;
    end;
    Tabs.Tabs.Clear ;
    inherited Clear;
    FActivePage := -1;
    Editor.Lines.Text := '';
end;

constructor TTabMan.Create(c:TTabControl; e: TEditor);
begin
    Tabs := c;
    Editor := e;
    c.Tabs.Clear ;
    c.Tabs.Add('Main');
    e.Lines.Text := '';
    FActivePage := -1;
end;

procedure TTabMan.DeleteTabPage(Index: Integer);
var
    p: PTabPage ;
begin
    if Count <= Index then Exit;

    p := Items[Index];
    Dispose(p);
    Self.Delete(Index);
    Tabs.Tabs.Delete(Index);

    if Index=FActivePage then
    begin
        if Index = Count then Index := Count-1;
        FActivePage := -1;
        ChangeActivePage(Index,'',POINT(0,0));
    end;
end;

destructor TTabMan.Destroy;
begin
    Clear ;
    inherited;
end;

function TTabMan.GetAllText: string;
var
    i: Integer;
    p: PTabPage;
begin
    Result := '';
    Result := Result + TAB_ID + #13#10;
    Result := Result + TAB_HEADER+' ACTIVE='+IntToStr(FActivePage)+'/>'#13#10;
    for i:=0 to Count-1 do
    begin
        p := Items[i];
        Result := Result + PAGE_FROM + ' NAME="' + p^.TabName + '" ' +
        'COL=' + IntToStr(p^.Caret.X)+' ROW='+ IntToStr(p^.Caret.Y) + '>'#13#10;
        Result := Result + p^.TabText + #13#10;
        Result := Result + PAGE_TO + #13#10;
    end;
end;

procedure TTabMan.GotoLine(lineNo: Integer; var page, line: Integer);
var
    sl: TStringList;
    i: Integer;
    s: string;
    cnt: Integer;
    ln: Integer;
begin
    sl := TStringList.Create ;
    try
        sl.Text := GetAllText;
        cnt := 0;
        ln  := 0;
        for i:=0 to sl.Count-1 do
        begin
            if i = lineNo then Break;
            s := sl.Strings[i];
            if s=PAGE_TO then
            begin
                Inc(cnt);
            end else
            if Copy(s,1,Length(PAGE_FROM))=PAGE_FROM then
            begin
                ln := -1;
            end;
            Inc(ln);
        end;
        page := cnt;
        line := ln;
    finally
        sl.Free ;
    end;
end;

procedure TTabMan.LoadFromFile(fname: string);
var
    s: TStringList;
begin
    s := TStringList.Create ;
    try
        s.LoadFromFile(fname);
        SetAllText(s.Text);
    finally
        s.Free ;
    end;
end;

procedure TTabMan.SaveToFile(fname: string);
var
    s: TStringList;
begin
    s := TStringList.Create ;
    try
        s.Text := GetAllText ;
        s.SaveToFile(fname);
    finally
        s.Free ;
    end;
end;

procedure TTabMan.SetActivePageText(text: string);
var
    p: PTabPage;
begin
    if FActivePage>=0 then
    begin
        p := Items[FActivePage];
        p^.TabText := text;
    end;
end;

procedure TTabMan.SetAllText(text: string);
var
    ptr: PChar;
    InitActivePage: Integer;

    procedure skipSpace(var ptr: PChar);
    begin
        while ptr^ in [' ',#9,#13,#10] do Inc(ptr);
    end;

    procedure readTabPage;
    var ss, key,val: string; tabname, tabtext: string; acol,arow: Integer;
    begin
        skipSpace(ptr);
        //get active page
        if StrLComp(ptr, 'ACTIVE', Length('ACTIVE'))=0 then
        begin
            Inc(ptr, Length('ACTIVE'));
            skipSpace(ptr); if ptr^ = '=' then Inc(ptr);
            ss := '';
            while ptr^ in ['0'..'9'] do begin
                ss := ss + ptr^; Inc(ptr);
            end;
            InitActivePage:=StrToIntDef(ss,0);
        end;
        skipSpace(ptr);
        if ptr^ = '/' then Inc(ptr);
        if ptr^ = '>' then Inc(ptr);
        //get pages
        while ptr^ <> #0 do
        begin
            skipSpace(ptr);
            if StrLComp(ptr, PChar(PAGE_FROM), Length(PAGE_FROM)) = 0 then
            begin
                Inc(ptr, Length(PAGE_FROM));
                //属性を取得
                tabname := 'page'; tabtext := ''; acol := 0; arow := 0;
                while ptr^ <> #0 do
                begin
                    skipSpace(ptr);
                    if ptr^='>' then Break;
                    key  := UpperCase(GetTokenChars([' ','=','>'],ptr));
                    if (ptr-1)^ = '>' then Break;
                    val := GetTokenChars([' ','=','>'],ptr);
                    if (ptr-1)^ = '>' then Dec(ptr);

                    if key='NAME' then
                    begin
                        if Copy(val,1,1)='"' then System.delete(val,1,1);
                        if Copy(val,Length(val),1)='"' then System.delete(val,Length(val),1);
                        tabname := val;
                    end else
                    if key='COL' then
                    begin
                        acol := Trunc(StrToValue(val));
                    end else
                    if key='ROW' then
                    begin
                        arow := Trunc(StrToValue(val));
                    end;
                end;
                skipSpace(ptr);
                if ptr^ = '>' then Inc(ptr);
                skipSpace(ptr);
                
                //本文を取得
                ss := '';
                while ptr^ <> #0 do
                begin
                    if StrLComp(ptr, PAGE_TO, Length(PAGE_TO)) = 0 then
                    begin
                        Inc(ptr, Length(PAGE_TO));
                        Break;
                    end;
                    if ptr^ in LeadBytes then
                    begin
                        ss := ss + ptr^ + (ptr+1)^;
                        Inc(ptr,2);
                    end else begin
                        ss := ss + ptr^;
                        Inc(ptr);
                    end;
                end;
                AddTabPage(tabname, ss, POINT(acol,arow));
            end else
            begin
                Inc(ptr);
            end;
        end;
    end;

begin
    Clear;
    InitActivePage := 0;
    ptr := PChar(text);
    skipSpace(ptr);
    if StrLComp(ptr, PChar(TAB_ID), Length(TAB_ID))=0 then
    begin
        Inc(ptr, Length(TAB_ID));
        readTabPage;
    end else
    begin //ただのテキスト
        Self.AddTabPage('main', text, POINT(0,0));
    end;
    ChangeActivePage(InitActivePage,'',POINT(0,0));
end;

end.
