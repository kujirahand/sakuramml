unit frmWizHajimeteU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls;

type
  TfrmWizHajimete = class(TForm)
    imgBack: TImage;
    lblTitle: TLabel;
    Label1: TLabel;
    edtTitle: TEdit;
    edtComposer: TEdit;
    Label2: TLabel;
    edtComment: TEdit;
    Label3: TLabel;
    scrTempo: TScrollBar;
    Shape1: TShape;
    edtTempo: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnOK: TButton;
    Label7: TLabel;
    edtOya: TEdit;
    edtKo: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cmbKeyFlag: TComboBox;
    procedure scrTempoChange(Sender: TObject);
    procedure edtTempoChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private �錾 }
  public
    { Public �錾 }
  end;

var
  frmWizHajimete: TfrmWizHajimete;

implementation

uses sakurapadU, use_sakura_dll;

{$R *.dfm}

procedure TfrmWizHajimete.scrTempoChange(Sender: TObject);
begin
  edtTempo.Text := IntToStr( scrTempo.Position );
end;

procedure TfrmWizHajimete.edtTempoChange(Sender: TObject);
var
  i: Integer;
begin
  i := StrToIntDef( edtTempo.Text, -1 );
  if i < 0 then
  begin
    i := 120;
    scrTempo.Position := i;
    //edtTempo.Text := '120';
  end;
  scrTempo.Position := i;
end;

procedure TfrmWizHajimete.btnOKClick(Sender: TObject);
begin
  frmSakuraPad.ActiveEditor.Lines.Text := ''+
  '//------------------------------------------------------------------------------'#13#10+
  '// �e�L�X�g���y�u�T�N���v���y�f�[�^ (dSakura.dll Version.'+mmlVersionInfo+')'#13#10+
  '//------------------------------------------------------------------------------'#13#10+
  '�Ȗ�{"'+edtTitle.Text+'"}'#13#10+
  '���{"'+edtComposer.Text+'"}'#13#10+
  '�R�����g{"'+edtComment.Text+'"}'#13#10+
  '//------------------------------------------------------------------------------'#13#10+
  '����������'#13#10+
  '���q'+ edtKo.Text + ',' + edtOya.Text + #13#10+
  '�e���|('+edtTempo.Text + ')'#13#10+
  cmbKeyFlag.Text+#13#10+
  ''#13#10+
  '�g���b�N�P'#13#10+
  '����(120)//���_�u���N���b�N�ŕύX�ł��܂�'#13#10+
  '���K5 ����4'#13#10+
  '//�������珑���܂��B'#13#10;
  Close;
end;

procedure TfrmWizHajimete.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

end.
