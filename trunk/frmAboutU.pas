unit frmAboutU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls;

const
  HISTORY = 'history.txt';
  TITLE_JPG = 'doc\title.jpg';

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
    { Private êÈåæ }
  public
    { Public êÈåæ }
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
        lblDLLVer.Caption := 'éÊìæÇ…é∏îs';
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
        lblVersion.Caption := 'éÊìæÇ…é∏îs';
      end;
    finally
        s.Free ;
    end;
end;

procedure TfrmAbout.Label2Click(Sender: TObject);
begin
    OpenApp('http://oto.chu.jp/');
end;

procedure TfrmAbout.FormShow(Sender: TObject);
var
    g: TGraphic;
    xx,yy:Integer;
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
    Button1.Caption := 'óπâ (&O)';
    g := frmSakuraPad.cbarTop.Picture.Graphic;
    for yy:=0 to (Self.Height div g.Height) do
    begin
        for xx:=0 to (Self.Width div g.Width) do
        begin
            imgBack.Canvas.Draw(xx*g.width, yy*g.Height, g);
        end;
    end;
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
    s: array [0..2] of string;
begin
    Image1.Visible := False;
    frmSakuraPad.PlayWave(WAV_B);
    s[0] := 'ÇøÇÂÇ¡Ç∆ÇæÇØÇÊÅ`ÇÒ'#13#10'Ç€Ç¡ÅEÅEÅE';
    s[1] := 'MMLÇ…âhåıÇ†ÇÍÅI'#13#10'äyÇµÇ≠ëfìGÇ… MML!!!';
    s[2] := 'Ç™ÇµÇ„Ç¡ÅB';
    lblHide.Caption := s[Random(3)];
    Application.ProcessMessages ;
    sleep(600);
    Image1.Visible := True;
end;

procedure TfrmAbout.lblInfoAuthorClick(Sender: TObject);
begin
    OpenApp('http://oto.chu.jp/');
end;

end.
