unit frmSelListU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSelList = class(TForm)
    lstMain: TListBox;
    edtKey: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstMainClick(Sender: TObject);
    procedure lstMainDblClick(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    ResultStr: string;
  end;

var
  frmSelList: TfrmSelList;

implementation

{$R *.dfm}

procedure TfrmSelList.btnOkClick(Sender: TObject);
begin
    ResultStr := edtKey.Text ;
    Close;
end;

procedure TfrmSelList.btnCancelClick(Sender: TObject);
begin
    ResultStr := '' ;
    Close;
end;

procedure TfrmSelList.FormShow(Sender: TObject);
begin
    edtKey.Text := '';
    ResultStr := '';
end;

procedure TfrmSelList.lstMainClick(Sender: TObject);
begin
    edtKey.Text := lstMain.Items[lstMain.ItemIndex];
end;

procedure TfrmSelList.lstMainDblClick(Sender: TObject);
begin
    btnOkClick(nil); 
end;

end.
