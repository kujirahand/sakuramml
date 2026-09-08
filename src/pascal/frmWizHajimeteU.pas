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
    { Private 宣言 }
  public
    { Public 宣言 }
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
  '// テキスト音楽「サクラ」音楽データ (dSakura.dll Version.'+mmlVersionInfo+')'#13#10+
  '//------------------------------------------------------------------------------'#13#10+
  '曲名{"'+edtTitle.Text+'"}'#13#10+
  '作者{"'+edtComposer.Text+'"}'#13#10+
  'コメント{"'+edtComment.Text+'"}'#13#10+
  '//------------------------------------------------------------------------------'#13#10+
  '音源初期化'#13#10+
  '拍子'+ edtKo.Text + ',' + edtOya.Text + #13#10+
  'テンポ('+edtTempo.Text + ')'#13#10+
  cmbKeyFlag.Text+#13#10+
  ''#13#10+
  'トラック１'#13#10+
  '音量(120)//←ダブルクリックで変更できます'#13#10+
  '音階5 音符4'#13#10+
  '//ここから書きます。'#13#10;
  Close;
end;

procedure TfrmWizHajimete.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

end.
