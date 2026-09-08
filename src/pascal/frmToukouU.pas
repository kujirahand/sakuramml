unit frmToukouU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, StdCtrls, ComCtrls, IdFTP;

type
  TfrmToukou = class(TForm)
    grpToukou: TGroupBox;
    Label2: TLabel;
    edtID: TEdit;
    Label3: TLabel;
    edtPw: TEdit;
    Label4: TLabel;
    edtName: TEdit;
    Label5: TLabel;
    edtEMail: TEdit;
    Label6: TLabel;
    edtWeb: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    memComment: TMemo;
    cmbCopy: TComboBox;
    btnToukou: TButton;
    cmbType: TComboBox;
    cmbGenre: TComboBox;
    cmbSynth: TComboBox;
    Label7: TLabel;
    http: TIdHTTP;
    Label14: TLabel;
    edtTitle: TEdit;
    chkChange: TCheckBox;
    Button1: TButton;
    ftp: TIdFTP;
    bar: TProgressBar;
    lblInfo: TLabel;
    btnHelp: TButton;
    procedure btnToukouClick(Sender: TObject);
    procedure chkChangeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ftpWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure ftpWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure ftpWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure httpWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure httpWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure httpWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  frmToukou: TfrmToukou;

implementation

uses StrUtils, StrUnit, sakurapadU, gui_benri;

{$R *.dfm}

const
    CGI_PATH = 'https://sakuramml.com/midi/midi.cgi';
    //CGI_PATH = 'http://localhost/cgi/midi.cgi';

procedure TfrmToukou.btnToukouClick(Sender: TObject);
var
  id,i: integer;
  s:TStringList;
  str: string;
begin
  //CheckForm
  id := StrToIntDef(edtID.Text, -1);
  if id<0 then
  begin
    edtID.Text := '';
  end;
  lblInfo.Caption := '';

  if cmbCopy.ItemIndex = 1 then
  begin
    i := MessageBox(Handle,
      '他人の曲を投稿する場合には、'#13#10+
      '著作権が問題となります。'#13#10+
      '直接著作者に許可をとった場合、もしくは、'#13#10+
      '作者の死後一定期間経過し、著作権の期限が切れたもののみ'#13#10+
      '投稿が出来ます。'#13#10+
      '著作権に問題がないと確信した場合は、[はい]をクリックしてください。',
      '著作権チェック',
      MB_YESNO);
    if i=IDNo then
    begin
      ShowMessage('著作者の許可をとってから投稿してください。');
      Exit;
    end;
  end;
  if (edtName.Text = '') then begin
    ShowMessage('名前がありません。'); Exit;
  end;
  if (edtTitle.Text = '') then begin
    ShowMessage('曲名がありません。'); Exit;
  end;
  if (edtEMail.Text = '') then begin
    ShowMessage('Eメールがありません。'); Exit;
  end;
  if (memComment.Text = '') then begin
    ShowMessage('コメントがありません。'); Exit;
  end;

  http.HTTPOptions := [];
  btnToukou.Enabled := False;
  try
    //IDの取得
    if id<0 then
    begin
        try
          lblInfo.Caption := 'IDの取得';   Application.ProcessMessages ;
          str := http.Get(CGI_PATH+'?mode=issue');
        except
        end;
        str := GetTag(str, 'BODY');
        str := DeleteTag(str);
        id := StrToIntDef(Trim(str),-1);
        if id<0 then
        begin
          ShowMessage('サーバーへの接続が確立できません。'); Exit;
        end;
    end;
    edtID.Text := IntToStr(id);
    //データのポスト
    s := TStringList.Create ;
    s.Add('id='+edtID.Text);
    s.Add('pw='+edtPw.Text);
    s.Add('name='+edtName.Text);
    s.Add('email='+edtEMail.Text);
    s.Add('web='+edtWeb.Text);
    s.Add('title='+edtTitle.Text);
    s.Add('copy='+cmbCopy.Text);
    s.Add('type='+cmbType.Text);
    s.Add('genre='+cmbGenre.Text);
    s.Add('synth='+cmbSynth.Text);
    str := memComment.Text ;
    str := AnsiReplaceStr(str, #13#10,'');
    str := AnsiReplaceStr(str, #9,'');
    s.Add('comment='+str);
    s.Add('mode=write');
    try
      lblInfo.Caption := 'データの書込み';
      Application.ProcessMessages ;
      str := http.Post(CGI_PATH,s);
      str := GetTag(str, 'BODY');
      str := DeleteTag(str);
      //ShowMessage(str);
      if (Pos('ok',str)>0)and(Pos('error',str)=0) then
      begin
        ftp.Connect;
        try
        try
          lblInfo.Caption := 'MIDIファイルの送信';
          Application.ProcessMessages ;
          ftp.ChangeDir('midi');
          ftp.Put(frmSakuraPad.TempMidiFile,IntToStr(id)+'.mid');
          ftp.ChangeDirUp ;
          lblInfo.Caption := 'MMLファイルの送信';
          Application.ProcessMessages ;
          ftp.ChangeDir('mml');
          ftp.Put(frmSakuraPad.BackupFile, IntToStr(id)+'.mml');
        except
        end;
        finally
          ftp.Disconnect ;
        end;
      end else
      begin
        lblInfo.Caption := 'error';
        ShowMessage('投稿に失敗しました。'#13#10+str); exit;
      end;
    except
      raise;
    end;
    lblInfo.Caption := 'ok.';
    ShowMessage('投稿できました。');
    s.Free ;
  finally
    btnToukou.Enabled := True;
  end;
end;

procedure TfrmToukou.chkChangeClick(Sender: TObject);
begin
  edtID.ReadOnly := not chkChange.Checked ;
end;

procedure TfrmToukou.Button1Click(Sender: TObject);
begin
  ShowMessage('以前投稿した曲の内容を修正したいときは、'#13#10+
  '修正したい曲のID番号と、パスワードを入力してください。');
end;

procedure TfrmToukou.FormShow(Sender: TObject);
begin
  with frmSakuraPad do
  begin
    edtName.Text := ini.ReadString('form','edtName','');
    edtEMail.Text := ini.ReadString('form','edtEmail','');
    edtWeb.Text := ini.ReadString('form','edtWeb','');
    edtPw.Text := ini.ReadString('form','edtPw','');
  end;
end;

procedure TfrmToukou.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with frmSakuraPad do
  begin
    ini.WriteString('form','edtName',edtName.Text);
    ini.WriteString('form','edtEmail',edtEMail.Text);
    ini.WriteString('form','edtWeb',edtWeb.Text);
    ini.WriteString('form','edtPw',edtPw.Text);
  end;
end;

procedure TfrmToukou.ftpWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  bar.Max := AWorkCountMax;
end;

procedure TfrmToukou.ftpWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  bar.Position := AWorkCount;
  Application.ProcessMessages ;
end;

procedure TfrmToukou.ftpWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  bar.Position := 0;
end;

procedure TfrmToukou.httpWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  bar.Max := AWorkCountMax;
end;

procedure TfrmToukou.httpWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  bar.Position := 0;
  lblInfo.Caption := '';
end;

procedure TfrmToukou.httpWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  bar.Position := AWorkCount;
  Application.ProcessMessages ;
end;

procedure TfrmToukou.btnHelpClick(Sender: TObject);
begin
  //
  OpenApp(AppPath+'doc\edit\toukou.htm');
end;

end.
