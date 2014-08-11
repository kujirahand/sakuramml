unit frmAboutU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls;

const
  HISTORY = 'history.txt';
  TITLE_JPG = 'doc\title.jpg';
  WEB_URL = 'http://oto.chu.jp/';

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Button1: TButton;
    Panel2: TPanel;
    lblVersion: TLabel;
    Label5: TLabel;
    lblDLLVer: TLabel;
    Label1: TLabel;
    btnDevelopper: TButton;
    imgBack: TImage;
    lblInfoAuthor: TLabel;
    lblHide: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDevelopperClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Image1Click(Sender: TObject);
    procedure lblInfoAuthorClick(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
    cmd: string;
  end;

var
  frmAbout: TfrmAbout;

implementation

uses gui_benri, use_sakura_dll, sakurapadU;

{$R *.dfm}

procedure TfrmAbout.Button1Click(Sender: TObject);
begin
    frmSakuraPad.PlayWave(WAV_PI);
    Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
var
    s: TStringList;
    i: Integer;
    ss: string;
begin
    s := TStringList.Create;
    try
      try
        lblDLLVer.Caption := mmlDateInfo + ' ver.' + mmlVersionInfo;
      except
        lblDLLVer.Caption := '�擾�Ɏ��s';
      end;
      try
        if FileExists(AppPath+HISTORY)=False then Exit;
        s.LoadFromFile(AppPath+HISTORY);
        ss := '';
        for i:=0 to s.Count -1 do
        begin
            ss := Trim(s.Strings[i]);
            if Copy(ss,1,2)='20' then
            begin
                Break;
            end;
        end;
        lblVersion.Caption := ss;
      except
        lblVersion.Caption := '�擾�Ɏ��s';
      end;
    finally
        s.Free ;
    end;
end;

procedure TfrmAbout.Label2Click(Sender: TObject);
begin
    OpenApp(WEB_URL);
end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  try
    try
      if FileExists(AppPath+TITLE_JPG) then
      begin
        Image1.Picture.LoadFromFile(AppPath+TITLE_JPG);
      end;
    except
    end;
    cmd := '';
    Button1.Caption := '���� (&O)';
  except
  end;
end;

procedure TfrmAbout.btnDevelopperClick(Sender: TObject);
begin
    OpenApp(AppPath + 'doc\about\developer.htm');
end;

procedure TfrmAbout.FormKeyPress(Sender: TObject; var Key: Char);
begin
    cmd := cmd + key;
    if UpperCase(cmd)=#$53#$41#$4B#$55#$52#$41 then
    begin
        lblInfoAuthor.Caption := #$82#$C6#$82#$E0#$82#$BF#$82#$E1#$82#$F1#$8D#$44#$82#$AB;
        cmd := '';
    end else
    if UpperCase(cmd)='KUJIRA' then
    begin
        lblInfoAuthor.Caption := #$4D#$4D#$4C#$8D#$C5#$8D#$82;
    end;
end;

procedure TfrmAbout.Image1Click(Sender: TObject);
var
    s: array [0..4] of string;
begin
    Image1.Visible := False;
    frmSakuraPad.PlayWave(WAV_B);
    s[0] := '���y�͐_���^�����ō��̖��₵';
    s[1] := 'MML�Ŋy����'#13#10'�y�����f�G�� MML!!!';
    s[2] := '�T�N���Ŋy�������y���悤�I';
    s[3] := '�T�E���h�v���O���~���O�̓T�N����';
    s[4] := '�T�N���ł��ł��ǂ��ł�'#13#10'�y�������y���悤�I';
    lblHide.Caption := s[Random(5)];
    Application.ProcessMessages ;
    sleep(600);
    Image1.Visible := True;
end;

procedure TfrmAbout.lblInfoAuthorClick(Sender: TObject);
begin
    OpenApp(WEB_URL);
end;

end.
