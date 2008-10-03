unit frmHokanU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type
  TfrmHokan = class(TForm)
    grdWord: TStringGrid;
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdWordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdWordDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdWordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private éŒ¾ }
  public
    { Public éŒ¾ }
    procedure Filter(key: string);
  end;

var
  frmHokan: TfrmHokan;

implementation

uses sakurapadU, csvDB, StrUnit;

{$R *.dfm}

procedure TfrmHokan.FormDeactivate(Sender: TObject);
begin
    Close;
end;

procedure TfrmHokan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    frmSakuraPad.IsShowHokan := False;
end;

procedure TfrmHokan.Filter(key: string);
var
    c,cmd: TCsvDb;
    i,j: Integer;
    s, sk: string;
begin
    c := TCsvDb.Create ;
    try
        cmd := frmSakuraPad.cmd ;
        //c.SetRowCommaText(0,'ƒRƒ}ƒ“ƒh, à–¾');
        sk := LowerCaseEx(key);
        for i:=0 to cmd.Count -1 do
        begin
            s := LowerCaseEx(cmd.Cells[0,i]);
            if Copy(s,1,2)='//' then Continue;
            if (Pos(sk,s) > 0)or(sk='') then
            begin
                j := c.Count ;
                c.Cells[0, j] := cmd.Cells[0,i];
                c.Cells[1, j] := cmd.Cells[2,i];
            end;
        end;
        if c.Count = 0 then begin
          if Length(key) > 4 then begin
            Filter(Copy(key,1,4)); Exit;
          end else begin
            Close; Exit;
          end;
        end;
        c.UseHeader := False;
        c.MergeSort(0);
        c.SetStringGrid(grdWord, True);
        grdWord.FixedRows := 0;
        j := c.FindWildMatch(key+'*',0,0);
        if j>0 then grdWord.Row := j;
    finally
        c.Free ;
    end;
end;

procedure TfrmHokan.grdWordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_RETURN then
    begin
        grdWordDblClick(nil); Exit;
    end;
end;

procedure TfrmHokan.grdWordDblClick(Sender: TObject);
var
    s: string;
    i: Integer;
begin
    i := grdWord.Row ;
    if i<0 then Exit;
    s := grdWord.Cells[0, i];
    frmSakuraPad.ActiveEditor.SelText := s;
    frmSakuraPad.edtMainDblClick(nil);
    Close; 
end;

procedure TfrmHokan.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_ESCAPE then Close;
    if Key = VK_BACK then Close;
end;

procedure TfrmHokan.grdWordKeyPress(Sender: TObject; var Key: Char);
var
    i: Integer;
    c,ch: string;
begin
    ch := UpperCase(Key);
    for i:=1 to grdWord.RowCount -1 do
    begin
        c := Copy(grdWord.Cells[0,i],1,1);
        if c = ch then
        begin
            grdWord.Row := i;
            Break;
        end;
    end;
end;

end.
