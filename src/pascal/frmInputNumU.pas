unit frmInputNumU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmInputNum = class(TForm)
    bar: TScrollBar;
    Shape1: TShape;
    lblNum: TLabel;
    procedure barChange(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    procedure ToEdit;
  end;

var
  frmInputNum: TfrmInputNum;

implementation

uses sakurapadU;

{$R *.dfm}

procedure TfrmInputNum.barChange(Sender: TObject);
begin
    lblNum.Caption := Format('%0.3d',[ bar.Position] );
end;

procedure TfrmInputNum.FormDeactivate(Sender: TObject);
begin
    ToEdit;
end;

procedure TfrmInputNum.ToEdit;
begin
    frmSakuraPad.ActiveEditor.SelText := lblNum.Caption ;
    Close;
end;

end.
