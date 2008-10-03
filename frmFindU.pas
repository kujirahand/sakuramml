unit frmFindU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TfrmFind = class(TForm)
    Label1: TLabel;
    edtKey: TEdit;
    chkUpperCase: TCheckBox;
    btnFind: TButton;
    PopupMenu1: TPopupMenu;
    mnuCut1: TMenuItem;
    mnuCopy1: TMenuItem;
    mnuPaste1: TMenuItem;
    procedure edtKeyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFindClick(Sender: TObject);
    procedure mnuCut1Click(Sender: TObject);
    procedure mnuCopy1Click(Sender: TObject);
    procedure mnuPaste1Click(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  frmFind: TfrmFind;

implementation

uses sakurapadU, StrUnit;

{$R *.dfm}

procedure TfrmFind.edtKeyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=VK_RETURN then
        btnFindClick(nil);
end;

procedure TfrmFind.btnFindClick(Sender: TObject);
var
    key,txt: string;
    i, idx: Integer;
begin
    key := edtKey.Text ;
    txt := frmSakuraPad.edtMain.Lines.Text ;
    if chkUpperCase.Checked=False then
    begin
        txt := UpperCase(txt);
        key := UpperCase(key);
    end;
    //検索
    i := frmSakuraPad.edtMain.SelStart + 1;
    idx := JPosEx(key, txt, i+1);
    if idx=0 then
    begin
        if i = 0 then
        begin
            ShowMessage('"'+key+'"は、見つかりませんでした。');
            Exit;
        end else
        begin
            idx := JPosEx(key, txt, 0);
            if idx = 0 then
            begin
                ShowMessage('"'+key+'"は、見つかりませんでした。');
                Exit;
            end;
        end;
    end;
    //
    with frmSakuraPad.edtMain do
    begin
        SetFocus ;
        SelStart := idx-1;
        SelLength := Length(key);
    end;
end;

procedure TfrmFind.mnuCut1Click(Sender: TObject);
begin
    edtKey.CutToClipboard ;
end;

procedure TfrmFind.mnuCopy1Click(Sender: TObject);
begin
    edtKey.CopyToClipboard ;
end;

procedure TfrmFind.mnuPaste1Click(Sender: TObject);
begin
    edtKey.PasteFromClipboard ;
end;

end.
