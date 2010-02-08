unit frmSplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmSplashWindow = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    timerClose: TTimer;
    procedure Image1Click(Sender: TObject);
    procedure timerCloseTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  frmSplashWindow: TfrmSplashWindow;

implementation

uses gui_benri, frmAboutU;

{$R *.dfm}

procedure TfrmSplashWindow.Image1Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmSplashWindow.timerCloseTimer(Sender: TObject);
begin
    timerClose.Enabled := False;
    Image1.Picture := nil;
    Close;
end;

procedure TfrmSplashWindow.FormCreate(Sender: TObject);
begin
    try
        if FileExists(AppPath + TITLE_JPG) then
        begin
          Image1.Picture.LoadFromFile(AppPath+TITLE_JPG);
          Image1.Invalidate ;
        end;
    finally
    end;
end;

end.
