unit frmMidiPortU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, midi_out;

type
  TfrmMidiPort = class(TForm)
    panelSetMidi: TPanel;
    btnOk: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    ComboBox3: TComboBox;
    Label4: TLabel;
    ComboBox4: TComboBox;
    Label5: TLabel;
    ComboBox5: TComboBox;
    Label6: TLabel;
    ComboBox6: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    midi: TMidiOut;
  end;

var
  frmMidiPort: TfrmMidiPort;

implementation

uses sakurapadU;

{$R *.dfm}

procedure TfrmMidiPort.FormCreate(Sender: TObject);
begin
  midi := frmSakuraPad.midiOut ;
  
end;

procedure TfrmMidiPort.FormShow(Sender: TObject);
var
  i: Integer;
  c: TComboBox;
  s: string;
begin
  frmSakuraPad.mciClose ;
  s := '-- óòópÇµÇ»Ç¢ --'#13#10+midi.GetDviceList ;
  for i:=0 to MAX_PORT-1 do
  begin
    c := TComboBox( FindComponent('ComboBox'+IntToStr(i+1)) );
    c.Items.Text := s;
    c.ItemIndex := frmSakurapad.ini.MidiPort[i]+2;
  end;
end;

procedure TfrmMidiPort.btnOkClick(Sender: TObject);
var
  i,n: Integer;
  c: TComboBox;
begin
  for i:=0 to MAX_PORT-1 do
  begin
    c := TComboBox( FindComponent('ComboBox'+IntToStr(i+1)) );
    n := c.ItemIndex -2;
    if n=-3 then n:=-2;
    frmSakurapad.ini.MidiPort[i] := n;
  end;
  Close;
end;

end.
