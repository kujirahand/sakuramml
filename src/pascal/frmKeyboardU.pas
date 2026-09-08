unit frmKeyboardU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, StdCtrls, NewCtrls, Spin;

const
  NoteMML     : Array[0..40]of String = ('c','c#','d','d#','e','f','f#','g','g#','a','a#','b', '`c','`c#','`d','`d#','`e','`f','`f#','`g','`g#','`a','`a#','`b','^','r','>','<', '"c','"c#','"d','"d#','"e','"f','"f#','"g','"g#','"a','"a#','"b','r*');
  NoteSutoton1: Array[0..40]of String = ('ド','ド＃','レ','レ＃','ミ','ファ','ファ＃','ソ','ソ＃','ラ','ラ＃','シ','`ド','`ド＃','`レ','`レ＃','`ミ','`ファ','`ファ＃','`ソ','`ソ＃','`ラ','`ラ＃','`シ','ー','ッ','↑','↓','"ド','"ド＃','"レ','"レ＃','"ミ','"ファ','"ファ＃','"ソ','"ソ＃','"ラ','"ラ＃','"シ','ッ*');
  NoteSutoton2: Array[0..40]of String = ('ど','ど＃','れ','れ＃','み','ふぁ','ふぁ＃','そ','そ＃','ら','ら＃','し','`ど','`ど＃','`れ','`れ＃','`み','`ふぁ','`ふぁ＃','`そ','`そ＃','`ら','`ら＃','`し','ー','っ','↑','↓','"ど','"ど＃','"れ','"れ＃','"み','"ふぁ','"ふぁ＃','"そ','"そ＃','"ら','"ら＃','"し','っ*');

type
  TfrmKeyboard = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mnuOutSutoton: TMenuItem;
    mnuOutMML: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N1001: TMenuItem;
    N801: TMenuItem;
    N501: TMenuItem;
    N301: TMenuItem;
    N10: TMenuItem;
    N1271: TMenuItem;
    N1002: TMenuItem;
    N701: TMenuItem;
    N502: TMenuItem;
    N302: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    Label2: TLabel;
    Shape25: TShape;
    Shape26: TShape;
    Label1: TLabel;
    Label4: TLabel;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    mnuHint: TMenuItem;
    N26: TMenuItem;
    mnuPlayStart: TMenuItem;
    mnuPlayStop: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    Shape27: TShape;
    Shape28: TShape;
    Label3: TLabel;
    Label5: TLabel;
    Shape29: TShape;
    Shape30: TShape;
    Shape31: TShape;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    Shape35: TShape;
    Shape36: TShape;
    Shape37: TShape;
    Shape38: TShape;
    Shape39: TShape;
    Shape40: TShape;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edCH: TSpinEdit;
    Bevel1: TBevel;
    Label15: TLabel;
    btnBack: TButton;
    N23: TMenuItem;
    N24: TMenuItem;
    N34: TMenuItem;
    N41: TMenuItem;
    mnuBaseOctave: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    mnuOutSutoton2: TMenuItem;
    Shape41: TShape;
    Label16: TLabel;
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuOutSutotonClick(Sender: TObject);
    procedure mnuOutMMLClick(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuPlayStartClick(Sender: TObject);
    procedure mnuPlayStopClick(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuHintClick(Sender: TObject);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edCHChange(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure mnuBaseOctaveClick(Sender: TObject);
    procedure mnuOutSutoton2Click(Sender: TObject);
  private
    oldShape: TShape;
    ch: Byte;
    baseOctave: Integer;
    procedure SetSendToEditor(Value: String);
  public
    property SendToEditor : String write SetSendToEditor;
  end;

var
  frmKeyboard: TfrmKeyboard;

implementation

uses sakurapadU;

{$R *.DFM}

procedure TfrmKeyboard.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i, o:Integer;
    s:String;
begin
    i := TShape(Sender).Tag;

    case frmSakuraPad.ini.OutMML of
    0: s := NoteSutoton1[i];
    1: s := NoteMML[i];
    2: s := NoteSutoton2[i];
    end;

    o := 48 + (baseOctave - 4) * 12;

    if(i <= 23)then begin
        if frmSakurapad.midiOut.IsOutDevOpen = False then frmSakurapad.midiOut.Open(-1);
        frmSakurapad.midiOut.OutNoteOn(ch-1, o+i,120);
    end else
    begin
        //１オクターブ下
        if( i >= 28 )and(i<>40)then begin
            if frmSakurapad.midiOut.IsOutDevOpen = False then frmSakurapad.midiOut.Open(-1);
            frmSakurapad.midiOut.OutNoteOn(ch-1, o-12+(i-28),120);
        end;
    end;
    if mbLeft = Button then
    begin
        SendToEditor := s;
    end;
end;

procedure TfrmKeyboard.mnuOutSutotonClick(Sender: TObject);
begin
    mnuOutSutoton.Checked := True;
    mnuOutSutoton2.Checked := False;
    mnuOutMML.Checked := False;
    frmSakuraPad.ini.OutMML := 0;
end;

procedure TfrmKeyboard.mnuOutMMLClick(Sender: TObject);
begin
    mnuOutSutoton.Checked := False;
    mnuOutSutoton2.Checked := False;
    mnuOutMML.Checked := True;
    frmSakuraPad.ini.OutMML := 1;
end;

procedure TfrmKeyboard.N21Click(Sender: TObject);
var s:String;
begin
    s := TMenuItem(Sender).Caption;
    SendToEditor := s;
end;

procedure TfrmKeyboard.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i   : Integer;
begin
    i := TShape(Sender).Tag;
    if i <> 40 then
    if( i <= 23 )or(i>=28)then begin
        frmSakurapad.midiOut.OutAllNoteOff(ch-1);
        //frmSakurapad.midiOut.OutNoteOff(0, 48+i,120);
    end;
end;

procedure TfrmKeyboard.mnuPlayStartClick(Sender: TObject);
begin
    frmSakurapad.mnuRunClick(nil) ;
end;

procedure TfrmKeyboard.mnuPlayStopClick(Sender: TObject);
begin
    frmSakurapad.mnuStopClick(nil) ;
end;

procedure TfrmKeyboard.N22Click(Sender: TObject);
begin
    SendToEditor := '　';
end;

procedure TfrmKeyboard.N27Click(Sender: TObject);
begin
    SendToEditor := #13#10;
end;

procedure TfrmKeyboard.FormCreate(Sender: TObject);
var
    r: Integer;
begin
    if frmSakuraPad.FlagForceClose then Exit; 
    frmSakuraPad.ini.LoadForm(Self);

    oldShape := nil;
    r := shape28.Left + shape28.Width + 8;
    if Self.ClientWidth < r then Self.ClientWidth := r;
    r := shape28.Top + shape28.Height + 8;
    if Self.ClientHeight < r then Self.ClientHeight := r;
end;

procedure TfrmKeyboard.mnuHintClick(Sender: TObject);
begin
    ShowMessage('・"ー"はタイ（伸ばす）、"ッ"は休符です。'#13#10+
    '・左クリックで、貼りつけ。右クリックで、テスト演奏できます。'#13#10+
    '音符を間違えて貼り付けた場合は、[BackSpace]キーを押せば,'#13#10+
    'エディタに貼り付けた音符を消すことが出来ます(^v^)/');
end;

procedure TfrmKeyboard.SetSendToEditor(Value: String);
begin
    frmSakurapad.ActiveEditor.SelText := Value;
    frmSakurapad.ActiveEditor.SetFocus ;
end;

procedure TfrmKeyboard.Shape1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
    s: TShape;
begin
    if Sender.ClassType <> TShape then Exit;

    s := TShape(Sender);
    if (oldShape<>nil)and(oldShape.Tag <> s.Tag) then
    begin
        if oldShape.Height > 40 then
            oldShape.Brush.Color := clWhite
        else
            oldShape.Brush.Color := clBlack;
    end;

    s.Brush.Color := RGB(255,200,200);
    oldShape := s;
end;

procedure TfrmKeyboard.FormShow(Sender: TObject);
begin
    case frmSakuraPad.ini.OutMML of
    0:mnuOutSutotonClick(nil);
    1:mnuOutMMLClick(nil);
    2:mnuOutSutoton2Click(nil);
    end;
    //MIDI Device
    frmSakuraPad.midiOut.Open(-1);
    ch := edCH.Value ;
    baseOctave := 5;
end;

procedure TfrmKeyboard.FormDestroy(Sender: TObject);
begin
  if frmSakuraPad.FlagForceClose then Exit;
  frmSakuraPad.ini.SaveForm(Self);
end;

procedure TfrmKeyboard.edCHChange(Sender: TObject);
begin
  ch := edCH.Value ;
end;

procedure TfrmKeyboard.btnBackClick(Sender: TObject);
begin
  frmSakuraPad.ActiveEditor.Undo ;
end;

procedure TfrmKeyboard.mnuBaseOctaveClick(Sender: TObject);
begin
  baseOctave := TMenuItem(Sender).Tag;  
end;

procedure TfrmKeyboard.mnuOutSutoton2Click(Sender: TObject);
begin
    mnuOutSutoton.Checked := False;
    mnuOutMML.Checked := False;
    mnuOutSutoton2.Checked := True;
    frmSakuraPad.ini.OutMML := 2;
end;

end.
