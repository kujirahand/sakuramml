unit frmRythmBoxU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, Grids, StdCtrls, Spin,  csvDB, clipbrd;

type
  TfrmRythmBox = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
    N1: TMenuItem;
    mnuClose: TMenuItem;
    mnuNew: TMenuItem;
    imgKoma0: TImage;
    imgKoma1: TImage;
    mnuMakeAndCopy: TMenuItem;
    mnuPasteToEdit: TMenuItem;
    imgKomaZ: TImage;
    mnuPlay: TMenuItem;
    mnuStop: TMenuItem;
    panelBottom: TPanel;
    Label1: TLabel;
    spnLength: TSpinEdit;
    Label2: TLabel;
    spnWidth: TSpinEdit;
    Label3: TLabel;
    spnV: TSpinEdit;
    Label4: TLabel;
    spnRepeat: TSpinEdit;
    imgBack: TImage;
    Panel1: TPanel;
    grdCanvas: TStringGrid;
    N3: TMenuItem;
    N4: TMenuItem;
    P1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    mnuRandom: TMenuItem;
    Label5: TLabel;
    spnTempo: TSpinEdit;
    mnuCopyHalf: TMenuItem;
    mnuRep4Koma: TMenuItem;
    Edit1: TMenuItem;
    mnuShowVelocity: TMenuItem;
    N7: TMenuItem;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure mnuNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdCanvasDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdCanvasMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdCanvasMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdCanvasMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mnuMakeAndCopyClick(Sender: TObject);
    procedure mnuPasteToEditClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuPlayClick(Sender: TObject);
    procedure mnuStopClick(Sender: TObject);
    procedure mnuRandomClick(Sender: TObject);
    procedure mnuCopyHalfClick(Sender: TObject);
    procedure mnuRep4KomaClick(Sender: TObject);
    procedure mnuShowVelocityClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure spnWidthChange(Sender: TObject);
  private
    { Private 宣言 }
    IsMouse: Boolean;
    oldX, oldY: Integer;
    PicLoaded: Boolean;
    FIndex: Integer;
    PatternNo: Integer;
    procedure patternInit;
    procedure patternHeadInit;
    procedure CheckCell(X,Y: Integer);
    function MakePattern(header:Boolean): string;
    procedure SetToGrid;
  public
    { Public 宣言 }
    csv: TCsvDb;
  end;

var
  frmRythmBox: TfrmRythmBox;

implementation

uses gui_benri, sakurapadU, use_sakura_dll;

{$R *.dfm}

const
  BK_PICTURE = 'skin\rbox_bk.jpg';
  KOMA_PIC0 = 'skin\koma0.jpg';
  KOMA_PIC1 = 'skin\koma1.jpg';
  KOMA_PICZ = 'skin\komaz.jpg';
  RYTHM_TYPE = 8;

procedure TfrmRythmBox.FormShow(Sender: TObject);
begin
    if PicLoaded = False then
    if FileExists(AppPath + BK_PICTURE) then
    begin
        imgBack.Picture.LoadFromFile(AppPath + BK_PICTURE);
        imgKoma0.Picture.LoadFromFile(AppPath + KOMA_PIC0);
        imgKoma1.Picture.LoadFromFile(AppPath + KOMA_PIC1);
        imgKomaz.Picture.LoadFromFile(AppPath + KOMA_PICZ);
        PicLoaded := True;
    end;
    IsMouse := False;
    oldX := -1;
    oldY := -1;
end;

procedure TfrmRythmBox.mnuCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmRythmBox.mnuNewClick(Sender: TObject);
begin
    //
    if not MsgYesNo('パターンを初期化してもよいですか？') then Exit;
    frmSakuraPad.PlayWave(0);
    patternInit;
end;

procedure TfrmRythmBox.patternInit;
var
    i,j,w: Integer;
begin
    Inc(PatternNo);
    w := spnWidth.Value ;

    patternHeadInit;

    for j:=0 to RYTHM_TYPE-1 do
    begin
        for i:=1 to w do
        begin
            csv.Cells[i,j] := '0';
        end;
    end;
    SetToGrid;
end;

procedure TfrmRythmBox.FormCreate(Sender: TObject);
begin
    frmSakuraPad.ini.LoadForm(Self);
    csv := TCsvDb.Create ;
    csv.UseHeader := False;
    PicLoaded := False;
    patternInit;
    FIndex := -1;
    PatternNo := 1;
end;

procedure TfrmRythmBox.grdCanvasDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
    i: Integer;
begin
    if ARow >= RYTHM_TYPE then Exit;

    with grdCanvas.Canvas do
    begin
        Font.Color := clWhite;
        Brush.Style := bsClear ;
            
        if ACol=0 then
        begin
            Draw(Rect.Left,Rect.Top, imgKomaZ.Picture.Graphic);
            TextOut(Rect.Left+2, Rect.Top+2, csv.Cells[ACol,ARow]);
            if FIndex=ARow then
            begin
                Pen.Width := 1;
                Pen.Color := clYellow;
                Brush.Style := bsClear ;
                Rectangle(Rect);
            end;
            Exit;
        end;
        if csv.Cells[ACol, ARow] = '' then csv.Cells[ACol, ARow] := '0';
        if (csv.Cells[ACol, ARow] = '0') then
        begin
            Draw(Rect.Left,Rect.Top, imgKoma0.Picture.Graphic);
        end else
        begin
            Draw(Rect.Left,Rect.Top, imgKoma1.Picture.Graphic);
            if mnuShowVelocity.Checked then TextOut(Rect.Left+2, Rect.Top+2, csv.Cells[ACol,ARow]);
        end;
        i := (ACol - 1);
        if (i mod 16) = 0 then
        begin
            MoveTo(Rect.Left+1, Rect.Top);
            Pen.Width := 1;
            Pen.Color := clRed;
            LineTo(Rect.Left+1, Rect.Bottom);
        end else
        if (i mod 4) = 0 then
        begin
            MoveTo(Rect.Left+1, Rect.Top);
            Pen.Width := 1;
            Pen.Color := clBlue;
            LineTo(Rect.Left+1, Rect.Bottom);
        end;
        Pen.Color := clWhite;

    end;
end;

procedure TfrmRythmBox.grdCanvasMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    IsMouse := True;
    CheckCell(X,Y);
end;

procedure TfrmRythmBox.grdCanvasMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    IsMouse := False;
    oldX := -1;
    oldY := -1;
end;

procedure TfrmRythmBox.grdCanvasMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    if IsMouse then CheckCell(X,Y);
end;

procedure TfrmRythmBox.CheckCell(X, Y: Integer);
var
    col,row: Integer;
const
    nn : array [0..7] of Integer = (
    49,46,42,50,47,43,38,36);

    procedure Click;
    begin
        with frmSakuraPad do begin
            midiOut.Open(-1);
            midiOut.OutNoteOn(9, nn[row], spnV.Value);
            sleep(10);
            midiOut.OutNoteOff(9,nn[row], spnV.Value);
        end;
    end;

begin
    grdCanvas.MouseToCell(X,Y,col,row);

    if (oldX = col)and(oldY = row) then Exit;
    FIndex := row;

    try

    if col = 0 then
    begin //Preview
        click;
        Exit;
    end;

    if csv.Cells[col,row] = '0' then
    begin
        csv.Cells[col,row] := spnV.Text;
        click;
    end else
    begin
        csv.Cells[col,row] := '0';
    end;

    finally
    grdCanvas.Repaint ;
    oldX := col;
    oldY := row;
    end;
end;

procedure TfrmRythmBox.mnuMakeAndCopyClick(Sender: TObject);
var
    s: string;
begin
    s := MakePattern(False) ;
    Clipboard.AsText := s;
    ShowMessage('以下の文字列をコピーしました。'#13#10+'"'+s+'"');
end;

function TfrmRythmBox.MakePattern(header:Boolean): string;
var
    i,j,w,rc: Integer;
    s,c, pname: string;
begin
    pname := '#DRUM'+IntToStr(PatternNo);
    Result := '//<リズムパターンの定義>'#13#10 +pname+' = { '+Format('v%d l%d',[spnV.Value, spnLength.Value])+#13#10;

    w := spnWidth.Value ;
    for j:=0 to RYTHM_TYPE -1 do
    begin
        s := '';
        rc:=0;
        for i :=1 to w do
        begin
            if s<>'' then if ((i-1) mod 4)=0 then s := s+'|';

            if csv.Cells[i,j]='' then csv.Cells[i,j] := '0';

            if csv.Cells[i,j] <> '0' then
            begin
                c := csv.Cells[i,j];
                if c=spnV.Text then
                begin
                    s := s + csv.Cells[0,j];
                end else
                begin
                    s := s + csv.Cells[0,j] + ',,' + csv.Cells[i,j];
                end;
            end else
            begin //R
                s := s + 'っ';
                inc(rc);
            end;
        end;
        if s<>'' then
        begin
            if rc<>w then
            if j<> RYTHM_TYPE-1 then
            begin
                Result := Result + #9'Sub{ ' + s + ' }'#13#10;
            end else
            begin
                Result := Result + #9'     ' + s + #13#10;
            end;
        end;
    end;

    Result := Result + '}'#13#10'//</リズムパターンの定義>'#13#10;
    if header then
    begin
        Result := Result + #13#10 + Format('//<リズムヘッダ>'#13#10'Tempo=%d;CH(10);',[spnTempo.Value])+ #13#10+
            '//</リズムヘッダ>'#13#10#13#10'//パターン演奏'#13#10+
            '[' + spnRepeat.Text + ' ' + pname + ']'#13#10 ;
    end else
    begin
        //
    end;
    frmSakuraPad.PlayModify := True;
end;

procedure TfrmRythmBox.mnuPasteToEditClick(Sender: TObject);
begin
    frmSakuraPad.ActiveEditor.SelText := MakePattern(True);
    frmSakuraPad.PlayWave(0);
    Inc(PatternNo);
end;

procedure TfrmRythmBox.FormDestroy(Sender: TObject);
begin
    csv.Free ;
    frmSakuraPad.ini.SaveForm(Self);
end;

procedure TfrmRythmBox.mnuPlayClick(Sender: TObject);
begin
    //
    with frmSakuraPad do
    begin
        midiOut.CloseAll;
        mciClose ;
        
        if mmlCompile(MakePattern(True),TempMidiFile) then
        begin
            Application.ProcessMessages ;
            track.Position := 0;
            mnuPlayMidiClick(nil) ;
        end else
        begin
            ShowMessage(mmlErrorMessage);
        end;
    end;
end;

procedure TfrmRythmBox.mnuStopClick(Sender: TObject);
begin
    frmSakuraPad.mnuStopClick(nil); 
end;

procedure TfrmRythmBox.mnuRandomClick(Sender: TObject);
var
    i: Integer;
begin
    if FIndex < 0 then Exit;

    for i:=1 to csv.ColCount -1 do
    begin
        if Random(4) = 0 then
        begin
            csv.Cells[i,FIndex] := spnV.Text ;
        end else
        begin
            csv.Cells[i,FIndex] := '0';
        end;
    end;
    grdCanvas.Repaint ;
    frmSakuraPad.PlayWave(0);
end;

procedure TfrmRythmBox.mnuCopyHalfClick(Sender: TObject);
var
    i,j,w: Integer;
begin
    w := ((csv.ColCount-1) div 2);
    if w<=0 then Exit;

    for j := 0 to RYTHM_TYPE -1 do
    begin
        for i := 0 to w-1 do
        begin
            csv.Cells[w + i + 1, j] := csv.Cells[i + 1, j];
        end;
    end;
    grdCanvas.Repaint ;
    frmSakuraPad.PlayWave(0);
end;

procedure TfrmRythmBox.mnuRep4KomaClick(Sender: TObject);
var
    i,j,w,cnt: Integer;
begin
    if FIndex < 0 then Exit;

    w := csv.ColCount-1;
    if w<=0 then Exit;

    cnt := w div 4;

    for j:=0 to cnt-1 do
    begin
        for i:=0 to 3 do
            csv.Cells[ 1 + j*4 + i, FIndex] := csv.Cells[ 1 + i, FIndex];
    end;
    grdCanvas.Repaint ;
    frmSakuraPad.PlayWave(0);
end;

procedure TfrmRythmBox.mnuShowVelocityClick(Sender: TObject);
begin
    mnuShowVelocity.Checked := not mnuShowVelocity.Checked ;
    grdCanvas.Repaint ;
end;

procedure TfrmRythmBox.mnuOpenClick(Sender: TObject);
begin
    dlgOpen.InitialDir := AppPath + 'tools\rythm\';
    if not dlgOpen.Execute then Exit;
    csv.LoadFromFile(dlgOpen.FileName);
    patternHeadInit;
    spnWidth.Value := csv.ColCount -1;
    SetToGrid ;
end;

procedure TfrmRythmBox.mnuSaveClick(Sender: TObject);
begin
    dlgSave.InitialDir := AppPath + 'tools\rythm\';
    if not dlgSave.Execute then Exit;
    csv.SaveToFile(dlgSave.FileName);
    grdCanvas.Repaint ; 
end;

procedure TfrmRythmBox.spnWidthChange(Sender: TObject);
var
    i,j, v: Integer;
    tmp,csv2: TCsvDb;
    s: string;
begin
    v := spnWidth.Value ;
    if (csv.ColCount)=(v+1) then Exit;

    csv2 := TCsvDb.Create ;

    for j:=0 to RYTHM_TYPE -1 do
    begin
        for i:=0 to v do
        begin
            s := csv.Cells[i,j];
            if s='' then s := '0';
            csv2.Cells[i,j] := s;
        end;
    end;

    tmp := csv;
    csv := csv2;
    tmp.Free ;
    SetToGrid;
end;

procedure TfrmRythmBox.SetToGrid;
begin
    csv.SetStringGrid(grdCanvas, False);
    grdCanvas.FixedRows := 0;
    grdCanvas.FixedCols := 1;
    grdCanvas.DefaultColWidth := 20;
    grdCanvas.DefaultRowHeight := 20;
    grdCanvas.ColWidths[0] := 20;
    grdCanvas.RowCount := RYTHM_TYPE;
    grdCanvas.Repaint ;
end;

procedure TfrmRythmBox.patternHeadInit;
var
    j: Integer;
const
    sb : array [0..RYTHM_TYPE-1] of string = (
    'ぱ','ち','つ','と','む','ろ','た','ず');
begin
    for j:=0 to RYTHM_TYPE-1 do
    begin
        csv.Cells[0,j] := sb[j];
    end;
end;

end.
