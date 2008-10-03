unit frmMML2MidiU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NewCtrls, StdCtrls;

type
  TfrmMML2Midi = class(TForm)
    Label1: TLabel;
    lstMML: TListBox;
    btnConvert: TButton;
    FileDrop1: TFileDrop;
    btnClear: TButton;
    procedure FileDrop1FileDrop(Sender: TObject; Num: Integer;
      Files: TStrings; X, Y: Integer);
    procedure btnConvertClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private éŒ¾ }
  public
    { Public éŒ¾ }
  end;

var
  frmMML2Midi: TfrmMML2Midi;

implementation

uses use_sakura_dll, gui_benri, StrUnit, jconvert;

{$R *.dfm}

procedure TfrmMML2Midi.FileDrop1FileDrop(Sender: TObject; Num: Integer;
  Files: TStrings; X, Y: Integer);
begin
  lstMML.Items.AddStrings(Files);
end;

procedure TfrmMML2Midi.btnConvertClick(Sender: TObject);
var
  i: Integer;
  fIn, fOut: string;
  txt: string;
begin
  for i := 0 to lstMML.Items.Count -1 do
  begin
    fIn := lstMMl.Items.Strings[i];
    if Copy(fIn,1,2) = '**' then Continue;
    fOut := ChangeFileExt(fIn, '.mid');
    txt := '';
    ReadTextFile(fIn, txt);

    txt := ConvertReturnCode(txt, CRLF_R);
    try
    if mmlCompile(txt, fOut) then
    begin
      fIn := '** OK ** ' + fOut;
    end else
    begin
      fIn := '** ERROR ** ' + fIn;
    end;
    except
    end;
    {
    if Pos('ƒGƒ‰[', mmlErrorMessage) > 0 then
    begin
      SHowMessage(mmlErrorMessage);
    end;
    }
    lstMML.Items.Strings[i] := fIn;
    Application.ProcessMessages ;
  end;
  ShowMessage('END');
end;

procedure TfrmMML2Midi.btnClearClick(Sender: TObject);
begin
  lstMML.Clear ;
end;

end.
