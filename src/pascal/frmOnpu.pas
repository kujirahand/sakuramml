unit frmOnpu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, NewCtrls, Menus;

type
  TfrmOnpu1 = class(TForm)
    pbGosen: TPaintBox;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mnuMML: TMenuItem;
    mnuSutoton: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    btnTo: TSpeedButton;
    btnHe: TSpeedButton;
    btn1: TSpeedButton;
    btn4: TSpeedButton;
    btn3: TSpeedButton;
    btn2: TSpeedButton;
    btn5: TSpeedButton;
    btnHuten: TSpeedButton;
    btnRest: TButton;
    btnTie: TButton;
    btnBackSpace: TButton;
    lblMML: TLabel;
    N2: TMenuItem;
    mnuHelp: TMenuItem;
    N3: TMenuItem;
    C1: TMenuItem;
    btn6: TSpeedButton;
    btn7: TSpeedButton;
    procedure pbGosenPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbGosenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbGosenMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRestClick(Sender: TObject);
    procedure btnTieClick(Sender: TObject);
    procedure pbGosenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure chkMMLClick(Sender: TObject);
    procedure btnBackSpaceClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuMMLClick(Sender: TObject);
    procedure mnuSutotonClick(Sender: TObject);
    procedure mnuHelpClick(Sender: TObject);
    procedure C1Click(Sender: TObject);
  private
    { Private declarations }
    MouseX,MouseY: Integer;
    Koma,noteno: Integer;
    Rythm: String;
    ShiftClick: Boolean;
    procedure PutMML;
    procedure SendToEditor(Value: String);
    function getMML(const koma: Integer; sharp: Boolean): string;
    procedure OutputTypeSutoton(IsSutoton: Boolean);
  public
    { Public declarations }
  end;

const
  onpu : Array[0..20]of String = (
  '``ミ','``レ','``ド','`シ','`ラ','`ソ','`ファ','`ミ','`レ','`ド',
  'シ','ラ','ソ','ファ','ミ','レ','ド','"シ','"ラ','"ソ',
  '"ファ');
  onpu2 : Array[0..20]of String = (
  '``e','``d','``c','`b','`a','`g','`f','`e','`d','`c',
  'b','a','g','f','e','d','c','"b','"a','"g','"f');
  onpu_no : Array[0..20]of Integer = (
  88,86,84,83,81,79,77,76,74,72,
  71,69,67,65,64,62,60,59,57,55,
  53);
  onpu_he : Array[0..20]of String = (
  'ソ','ファ',
  'ミ','レ','ド','"シ','"ラ','"ソ','"ファ','"ミ','"レ','"ド',
  '""シ','""ラ','""ソ','""ファ','""ミ','""レ','""ド','"""シ','"""ラ'
  );
  onpu_he2 : Array[0..20]of String = (
  'g','f',
  'e','d','c','"b','"a','"g','"f','"e','"d','"c',
  '""b','""a','""g','""f','""e','""d','""c','"""b','"""a'
  );
  onpu_he_no : Array[0..20]of Integer = (
  67,65,
  64,62,60,59,57,55,53,52,50,48,
  47,45,43,41,40,38,36,35,33);
  rythm_str : Array[1..7] of String = (
  '1','2','4','8','16','12','24'
  );

var
  frmOnpu1: TfrmOnpu1;

implementation

uses sakurapadU;

{$R *.DFM}

procedure TfrmOnpu1.pbGosenPaint(Sender: TObject);
var
	H,W,i,ih,iw,ii: Integer;
    lh,ch: Double;
begin
	with pbGosen do
  begin
    H := pbGosen.Height ;
    W := pbGosen.Width;
    Canvas.Brush.Color := clWhite;
    Canvas.Rectangle(0,0,W,H);
		lh := H / 10;
    ch := H / 20;
    Canvas.Pen.Color := clBlack;
    for i := 3 to 7 do
    begin
      ih := Round(lh * i);
      Canvas.MoveTo (0, ih);
      Canvas.LineTo (W, ih);
    end;
    //Tama
    Koma := -1;
    if (MouseX > 0)and(MouseY > 0) then
    begin
        koma := Round(MouseY / ch);
        iw := W div 2;
        ii := Round(ch);
        if Koma < 6 then
        begin
          Canvas.Pen.Color := clBlack;
          for i:=(koma div 2) to 2 do
            begin
              ih := Round(lh * i);
              Canvas.MoveTo (iw-ii*2, ih);
              Canvas.LineTo (iw+ii*2, ih);
            end;
        end else
        if Koma > 14 then
        begin
          Canvas.Pen.Color := clBlack;
          for i:=7 to (koma div 2) do
            begin
              ih := Round(lh * i);
              Canvas.MoveTo (iw-ii*2, ih);
              Canvas.LineTo (iw+ii*2, ih);
            end;
        end;
        Canvas.Brush.Color := clRed;
        ih := Round(ch * koma);
        Canvas.Ellipse (iw-ii,ih-ii,iw+ii,ih+ii);
        PutMML;
    end;
  end;
end;

procedure TfrmOnpu1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
	with pbGosen do
    begin
		if (X > Left)and(X < Left+Width) and (Y > Top)and(Y < Top+Height) then
        begin
        	//
        end else
        begin
        	MouseX := -1;
            MouseY := -1;
            pbGosenPaint (nil);
        end;
    end;
end;

procedure TfrmOnpu1.pbGosenMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
    if ssShift in Shift then ShiftClick := True else ShiftClick := False;
    MouseX := X;
    MouseY := Y;
    pbGosenPaint(nil);
end;

procedure TfrmOnpu1.PutMML;
var
	s: String;
begin
	if Koma >= 0 then
  begin
    s := getMML(koma, ShiftClick);
    lblMML.Caption := s;
  end else
    lblMML.Caption := '音符';
end;

procedure TfrmOnpu1.pbGosenMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    frmSakurapad.midiOut.OutNoteOff (0,noteno,100);
    if ShiftClick then
    begin
    	ShiftClick := False;
        dec(noteno);
    end;
end;

procedure TfrmOnpu1.btn1Click(Sender: TObject);
var
	tag: Integer;
begin
	tag := TSpeedButton(Sender).Tag ;
	if TSpeedButton(Sender).Down = False then
    begin
    	Rythm := '';
    end else begin
    	Rythm := rythm_str[tag];
    end;
end;

procedure TfrmOnpu1.FormCreate(Sender: TObject);
var
    w,h: Integer;
begin
    if frmSakuraPad.FlagForceClose then Exit; 

    w := Self.Width ;
    h := Self.Height ;
    frmSakuraPad.ini.LoadForm(Self);
    Self.Width := w;
    Self.Height := h;
    
	  rythm := '';
    ShiftClick := False;

end;

procedure TfrmOnpu1.btnRestClick(Sender: TObject);
var
	s: string;
begin
    if mnuMML.Checked then
        s := 'r' + rythm
    else
        s := 'ッ' + rythm;
	if btnHuten.Down then s := s + '.';
   	SendToEditor(s);
end;

procedure TfrmOnpu1.btnTieClick(Sender: TObject);
var
	s: string;
begin
    if mnuMML.Checked then
        s := '^' + rythm
    else
        s := 'ー' + rythm;
	if btnHuten.Down then s := s + '.';
   	SendToEditor(s);
end;

procedure TfrmOnpu1.pbGosenMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
	s: String;
begin
    if frmSakurapad.midiOut.IsOutDevOpen = False then frmSakurapad.midiOut.Open(-1);
    pbGosenMouseMove(Sender, Shift, X, Y);

    if btnHe.Down then
        noteno := onpu_he_no[koma]
    else
        noteno := onpu_no[koma];

    if ShiftClick then Inc(noteno);
    frmSakurapad.midiOut.OutNoteOn (0,noteno,100);
    PutMML;
    if Button = mbLeft then
    if koma >= 0 then
    begin
        s := getMML(koma, ShiftClick) + s;
        SendToEditor(s);
    end;
end;

procedure TfrmOnpu1.SendToEditor(Value: String);
begin
    frmSakuraPad.ActiveEditor.SelText := Value;
    frmSakuraPad.ActiveEditor.SetFocus ;
end;

function TfrmOnpu1.getMML(const koma: Integer; sharp: Boolean): string;
var
    s,ss: string;
begin
	if sharp then ss := '#' else ss := '';
  if btnTo.Down then
  begin
      if mnuMML.Checked then
          s := onpu2[koma] + s + ss + rythm
      else
          s := onpu[koma] + s + ss + rythm;
  end else begin
      if mnuMML.Checked then
          s := onpu_he2[koma] + s + ss + rythm
      else
          s := onpu_he[koma] + s + ss + rythm;
  end;
  if btnHuten.Down then
      s := s + '.';
  Result := s;
end;

procedure TfrmOnpu1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    pbGosenMouseMove(nil,Shift,MouseX,MouseY);
    //Beep;
end;

procedure TfrmOnpu1.FormShow(Sender: TObject);
begin
  OutputTypeSutoton( (frmSakuraPad.ini.OutMML=1) );
end;

procedure TfrmOnpu1.chkMMLClick(Sender: TObject);
begin
    frmSakuraPad.ini.OutMML := Ord(mnuMML.Checked);
end;

procedure TfrmOnpu1.btnBackSpaceClick(Sender: TObject);
begin
{
  frmSakuraPad.ActiveEditor.SetFocus ;
  keybd_event(VK_BACK, 0, 0, 0);
  keybd_event(VK_BACK, 0, KEYEVENTF_KEYUP, 0);
}
  frmSakuraPad.ActiveEditor.Undo ;
end;

procedure TfrmOnpu1.FormDestroy(Sender: TObject);
begin
  if frmSakuraPad.FlagForceClose then Exit;
  frmSakuraPad.ini.SaveForm(Self);
end;

procedure TfrmOnpu1.OutputTypeSutoton(IsSutoton: Boolean);
begin
  mnuMML.Checked     := False;
  mnuSutoton.Checked := False;

  if IsSutoton then
  begin
    mnuSutoton.Checked := True;
  end else
  begin
    mnuMML.Checked := True;
  end;
end;

procedure TfrmOnpu1.mnuMMLClick(Sender: TObject);
begin
  OutputTypeSutoton(False);
end;

procedure TfrmOnpu1.mnuSutotonClick(Sender: TObject);
begin
  OutputTypeSutoton(True);
end;

procedure TfrmOnpu1.mnuHelpClick(Sender: TObject);
begin
	ShowMessage('リズムを選んで、五線符の上で、左クリックでエディタへ貼りつけ、'#13#10+
    '右クリックで音程の確認ができます。'#13#10+
    'Shift押したまま+クリックで、半音上（＃の音）になります。');
end;

procedure TfrmOnpu1.C1Click(Sender: TObject);
begin
  Close;
end;

end.
