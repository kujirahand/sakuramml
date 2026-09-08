unit testUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ToolWin, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ToolBar1: TToolBar;
    Button1: TButton;
    Splitter1: TSplitter;
    memErr: TMemo;
    ToolButton1: TToolButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    playing: Boolean;
  end;

function MMLtoMIDI(MMLText: PChar; FileName: PChar; ErrMsg: PChar): BOOL; stdcall; external 'dSakura.dll';
procedure SetErrMsgLen(mLen: Integer); stdcall; external 'dSakura.dll';


var
  Form1: TForm1;

implementation

uses mci_cmd;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
    s,ss,txt: string; p: PChar;
begin
    if playing then mciClose;
    SetErrMsgLen(4096);
    SetLength(ss,4096);
    s := Memo1.Text ;
    p := PChar(ss);
    MMLtoMIDI(PChar(s),'test.mid', p);
    memErr.Text := string(p);
    mciPlayFile('test.mid');
    playing := True;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    playing := False;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    memo1.Clear ;
end;

end.
