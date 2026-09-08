unit frmReplaceU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TfrmReplace = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtKey: TEdit;
    edtReplace: TEdit;
    btnReplace: TButton;
    btnReplaceAll: TButton;
    chkSelectArea: TCheckBox;
    popRep: TPopupMenu;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    popPaste: TMenuItem;
    popAll: TMenuItem;
    N3: TMenuItem;
    procedure btnReplaceClick(Sender: TObject);
    procedure btnReplaceAllClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Copy1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure popPasteClick(Sender: TObject);
    procedure popAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtKeyEnter(Sender: TObject);
    procedure edtReplaceEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
    edts: array[0..1]of TEdit;
    FIndex: Integer;
  end;

var
  frmReplace: TfrmReplace;

implementation

uses sakurapadU, StrUnit, gui_benri, HEditor;

{$R *.dfm}

procedure TfrmReplace.btnReplaceClick(Sender: TObject);
var
    key, txt: string;
    idx,cur: Integer;
begin
    key := edtKey.Text ;
    txt := frmSakuraPad.ActiveEditor.Lines.Text ;
    cur := frmSakuraPad.ActiveEditor.SelStart +1;
    idx := JPosEx(key, txt , cur);
    if idx<=0 then begin
        cur := 0;
        idx := JPosEx(key, txt , cur+1);
        if idx<=0 then begin
            ShowMessage('検索語「'+key+'」は見つかりませんでした。');
            Exit;
        end;
    end;
    {if MsgYesNo('"'+key+'"が見つかりました。'#13#10+
        '"'+edtReplace.Text+'"に、置換しますか？') then}
    begin
        Delete(txt, idx, Length(key));
        Insert(edtReplace.Text, txt, idx);
        with frmSakuraPad.ActiveEditor do begin
            Lines.Text := txt;
            SetFocus ;
            SelStart := idx-1 + Length(Self.edtReplace.Text);
            SelLength := 0;//Length(Self.edtReplace.Text);
            frmSakuraPad.PlayModify := True;
        end;
    end;
end;

procedure TfrmReplace.btnReplaceAllClick(Sender: TObject);
begin
    //if MsgYesNo('全て置換します。よろしいですか？')=False then Exit;
    with frmSakuraPad.ActiveEditor do
    begin
        if chkSelectArea.Checked then
        begin
            SelText := JReplace(SelText, Self.edtKey.Text, Self.edtReplace.Text, True);
        end else
        begin
            Lines.Text := JReplace(Lines.Text, Self.edtKey.Text, Self.edtReplace.Text, True);
        end;
    end;
end;

procedure TfrmReplace.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_ESCAPE then Close;
end;

procedure TfrmReplace.Copy1Click(Sender: TObject);
begin
    edts[FIndex].CopyToClipboard ;
end;

procedure TfrmReplace.Cut1Click(Sender: TObject);
begin
    edts[FIndex].CutToClipboard  ;
end;

procedure TfrmReplace.popPasteClick(Sender: TObject);
begin
    edts[FIndex].PasteFromClipboard ;
end;

procedure TfrmReplace.popAllClick(Sender: TObject);
begin
    edts[FIndex].SelectAll ;
end;

procedure TfrmReplace.FormCreate(Sender: TObject);
begin
    if frmSakuraPad.FlagForceClose then Exit;
    frmSakuraPad.ini.LoadForm(Self);
    edts[0] := edtKey ;
    edts[1] := edtReplace ;
    FIndex := 0;
end;

procedure TfrmReplace.edtKeyEnter(Sender: TObject);
begin
    FIndex := 0;
end;

procedure TfrmReplace.edtReplaceEnter(Sender: TObject);
begin
    FIndex := 1;
end;

procedure TfrmReplace.FormDestroy(Sender: TObject);
begin
  if frmSakuraPad.FlagForceClose then Exit;
  frmSakuraPad.ini.SaveForm(Self);
end;

end.
