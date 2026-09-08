unit frmKeyMapU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  TfrmKeyMap = class(TForm)
    btnOk: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label8: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Edit10: TEdit;
    procedure Edit7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  frmKeyMap: TfrmKeyMap;

implementation

uses sakurapadU;


{$R *.dfm}

procedure TfrmKeyMap.Edit7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    w: Word;
begin
    w := Key;
    Key := 0;
    TEdit(Sender).Text := ShortCutToText( ShortCut(w, Shift) );
end;

procedure TfrmKeyMap.FormShow(Sender: TObject);
begin

    with frmSakurapad do
    begin
        self.Edit1.Text := ShortcutToText(actZ.ShortCut);
        self.Edit2.Text := ShortcutToText(actY.ShortCut);
        self.Edit3.Text := ShortcutToText(actX.ShortCut);
        self.Edit4.Text := ShortcutToText(actC.ShortCut);
        self.Edit5.Text := ShortcutToText(actV.ShortCut);
        self.Edit6.Text := ShortcutToText(actRun.ShortCut);
        self.Edit7.Text := ShortcutToText(actStop.ShortCut);
        self.Edit8.Text := ShortcutToText(actPlayPrev.ShortCut);
        self.Edit9.Text := ShortcutToText(actReplace.ShortCut);
        self.Edit10.Text := ShortcutToText(actRunFirst.ShortCut);
    end;

end;

procedure TfrmKeyMap.btnOkClick(Sender: TObject);
begin

    with frmSakurapad do
    begin
        actZ.ShortCut    := TextToShortCut(self.Edit1.Text);
        actY.ShortCut    := TextToShortCut(self.Edit2.Text);
        actX.ShortCut    := TextToShortCut(self.Edit3.Text);
        actC.ShortCut    := TextToShortCut(self.Edit4.Text);
        actV.ShortCut    := TextToShortCut(self.Edit5.Text);
        actRun.ShortCut  := TextToShortCut(self.Edit6.Text);
        actStop.ShortCut := TextToShortCut(self.Edit7.Text);
        actPlayPrev.ShortCut := TextToShortCut(self.Edit8.Text);
        actReplace.ShortCut  := TextToShortCut(self.Edit9.Text);
        actRunFirst.ShortCut := TextToShortCut(self.Edit10.Text);
    end;

    Close;

end;

procedure TfrmKeyMap.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
    key := #0;
end;

end.
