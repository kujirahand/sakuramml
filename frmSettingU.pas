unit frmSettingU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, sakurapadU, mmsystem;

type
  TfrmSetting = class(TForm)
    page: TPageControl;
    btnOk: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    listSkin: TListBox;
    imgSkin: TImage;
    Bevel1: TBevel;
    btnSkinAdd: TButton;
    edtSkinPath: TEdit;
    chkSkinUse: TCheckBox;
    Memo1: TMemo;
    dlgPic: TOpenDialog;
    Panel1: TPanel;
    grpPlayer: TRadioGroup;
    Memo2: TMemo;
    dlgExe: TOpenDialog;
    grpTMidi: TGroupBox;
    edtTmidiPath: TEdit;
    btnTMidiGet: TButton;
    btnTMidiDownload: TButton;
    grpSmfPlayer: TGroupBox;
    Label1: TLabel;
    scrPlayerWaitTime: TScrollBar;
    lblPlayerWaitTime: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblPlayerDrawWaitTime: TLabel;
    Label7: TLabel;
    scrPlayerDrawWaitTime: TScrollBar;
    Panel2: TPanel;
    dlgColor: TColorDialog;
    imgMon: TImage;
    Label6: TLabel;
    grpPlayerSynthType: TRadioGroup;
    btnPlayerPort: TButton;
    btnCancel: TButton;
    GroupBox2: TGroupBox;
    memColor: TEdit;
    btnColorCopy: TButton;
    btnColorPaste: TButton;
    btnMemoToColor: TButton;
    GroupBox3: TGroupBox;
    lstColor: TListBox;
    btnColorRegLib: TButton;
    btnColorLoadLib: TButton;
    btnColorDelLib: TButton;
    grpTW: TGroupBox;
    edtTWPath: TEdit;
    btnTWGet: TButton;
    btnTWDownload: TButton;
    TabSheet4: TTabSheet;
    Panel3: TPanel;
    GroupBox4: TGroupBox;
    chkKansiMidiIn: TCheckBox;
    lstMidiIn: TListBox;
    GroupBox5: TGroupBox;
    chkMidiInToOut: TCheckBox;
    cmbMidiOut: TComboBox;
    Label8: TLabel;
    chkMidiInToEdit: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure listSkinClick(Sender: TObject);
    procedure btnSkinAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnTMidiGetClick(Sender: TObject);
    procedure grpPlayerClick(Sender: TObject);
    procedure chkSkinUseClick(Sender: TObject);
    procedure btnTMidiDownloadClick(Sender: TObject);
    procedure scrPlayerWaitTimeChange(Sender: TObject);
    procedure scrPlayerDrawWaitTimeChange(Sender: TObject);
    procedure imgMonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnPlayerPortClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnColorCopyClick(Sender: TObject);
    procedure btnMemoToColorClick(Sender: TObject);
    procedure btnColorPasteClick(Sender: TObject);
    procedure btnColorLoadLibClick(Sender: TObject);
    procedure btnColorRegLibClick(Sender: TObject);
    procedure lstColorClick(Sender: TObject);
    procedure btnColorDelLibClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTWDownloadClick(Sender: TObject);
    procedure btnTWGetClick(Sender: TObject);
    procedure chkKansiMidiInClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    oldSkin: string;
    procedure EnumSkinFile;
    procedure DrawMonColor;
    procedure ColorDataToMemo;
    procedure MemoToColorData;
  public
    { Public 宣言 }
    ini: TIniSakura;
  end;

var
  frmSetting: TfrmSetting;

implementation

uses DirUtil, gui_benri, frmPlayMonitorU, frmMidiPortU, StrUnit;

//=========================================================
var
  MidiInHandle: HMIDIIN ;
  MidiOutHandle: HMIDIOUT ;
  MidiToEdit: Boolean;
  LastOctave: Integer;

{$R *.dfm}

procedure TfrmSetting.FormShow(Sender: TObject);

  procedure procSkin;
  begin
    EnumSkinFile;
    chkSkinUse.Checked := ini.UseSkin;
    edtSkinPath.Text := ini.SkinPath;
    oldSkin := edtSkinPath.Text ;
  end;
  procedure procPlayer;
  begin
    grpPlayer.ItemIndex := Ord( ini.PlayerType );
    grpPlayerClick(nil);
    edtTmidiPath.Text := ini.TMidiPath ;
    edtTWPath.Text := ini.TWPath ;
    scrPlayerWaitTime.Position := ini.PlayerWaitTime ;
    scrPlayerDrawWaitTime.Position := ini.PlayerDrawWaitTime ;
    grpPlayerSynthType.ItemIndex := ini.SynthType;
  end;
  procedure procMon;
  begin
    drawMonColor;
  end;
  procedure procSys;
  begin
    //chkSysAutoPlay.Checked :=
  end;
  procedure procMidiIn;
  var
    devNum: DWORD;
    i: Integer;
    dev: TMidiInCaps;
    devOut: TMidiOutCaps ;
  begin
    if lstMidiIn.Items.Count > 0 then Exit;
    
    // MidiInPortを検出
    lstMidiIn.Clear ;
    devNum := midiInGetNumDevs;
    if devNum <= 0 then Exit;
    for i := 0 to devNum - 1 do
    begin
      if MMSYSERR_NOERROR = midiInGetDevCaps(i, @dev, sizeof(dev)) then
      begin
        lstMidiIn.Items.Add(dev.szPname);
      end;
    end;
    if lstMidiIn.Items.Count > 0 then lstMidiIn.ItemIndex := 0;
    // MidiOutを検出
    cmbMidiOut.Clear ;
    devNum := midiOutGetNumDevs ;
    for i := 0 to devNum - 1 do
    begin
      if MMSYSERR_NOERROR = midiOutGetDevCaps(i, @devOut, sizeof(devOut)) then
      begin
        cmbMidiOut.Items.Add(devOut.szPname);
      end;
    end;
    if cmbMidiOut.Items.Count > 0 then cmbMidiOut.ItemIndex := 0;
  end;

begin
  frmSakuraPad.ini.LoadForm(Self);
  //TODO:設定ロード
  procSkin;
  procPlayer;
  procMon;
  btnColorLoadLibClick(nil);
  procSys;
  procMidiIn;
end;

procedure TfrmSetting.listSkinClick(Sender: TObject);
var
  i: Integer;
begin
  i := listSkin.ItemIndex ;
  if i<0 then Exit;
  edtSkinPath.Text := AppPath + 'skin\' + listSkin.Items[i];
  imgSkin.Picture.LoadFromFile( edtSkinPath.Text );
end;

procedure TfrmSetting.btnSkinAddClick(Sender: TObject);
var
  src,des: string;
begin
  if not dlgPic.Execute then Exit;
  src := dlgPic.FileName ;
  des := AppPath + 'skin\' + ExtractFileName(src);
  while FileExists(des) do begin
    des := 'copy_' + des;
  end;
  SHFileCopy(src,des);
  EnumSkinFile;
end;

procedure TfrmSetting.EnumSkinFile;
var
  g: TGlob;
begin
  g := TGlob.Create(AppPath+'skin\*.jp*');
  try
    listSkin.Items.Text := g.FileList.Text;
  finally
    g.Free ;
  end;
end;

procedure TfrmSetting.FormCreate(Sender: TObject);
begin
  ini := frmSakuraPad.ini ;
end;

procedure TfrmSetting.btnOkClick(Sender: TObject);

  procedure procSkin;
  var s: string;
  begin
    s := edtSkinPath.Text;
    ini.UseSkin := chkSkinUse.Checked ;
    ini.SkinPath := s;
    if oldSkin <> s then frmSakuraPad.ChangeSkin(s);
  end;
  
  procedure procPlayer;
  begin
    ini.TMidiPath := edtTmidiPath.Text ;
    ini.TWPath := edtTWPath.Text ;
    ini.PlayerType := grpPlayer.ItemIndex;
    ini.PlayerWaitTime := scrPlayerWaitTime.Position ;
    ini.PlayerDrawWaitTime := scrPlayerDrawWaitTime.Position ;
    ini.SynthType := grpPlayerSynthType.ItemIndex ;
  end;

begin
  //TODO:設定保存
  frmSakuraPad.mciClose ; //音源を一度閉じる
  procSkin;
  procPlayer;
  //色選択
  frmPlayMonitor.ColorChange ;
  frmPlayMonitor.FormResize(nil) ;
  frmPlayMonitor.Invalidate ;
  //閉じる
  Close;
end;

procedure TfrmSetting.btnTMidiGetClick(Sender: TObject);
begin
  if not dlgExe.Execute then Exit;
  edtTmidiPath.Text := dlgExe.FileName;
end;

procedure TfrmSetting.grpPlayerClick(Sender: TObject);
begin
{
  if grpPlayer.ItemIndex <> 1 then
  begin //TMidi以外の時
    grpTMidi.Visible := False;
  end else begin
    grpTMidi.Visible := True;
  end;
}
end;

procedure TfrmSetting.chkSkinUseClick(Sender: TObject);
begin
  if chkSkinUse.Checked = False then
    edtSkinPath.Text := '';
end;

procedure TfrmSetting.btnTMidiDownloadClick(Sender: TObject);
begin
  if MsgYesNo('TMidiは、ふみぃさん作のMIDIプレイヤーです。'#13#10+
              'ふみぃさんのホームページからダウンロードしてください。') then
  begin
    OpenApp('http://hp.vector.co.jp/authors/VA010012/');
  end;
end;

procedure TfrmSetting.scrPlayerWaitTimeChange(Sender: TObject);
begin
  lblPlayerWaitTime.Caption := IntToStr( scrPlayerWaitTime.Position );
end;

procedure TfrmSetting.scrPlayerDrawWaitTimeChange(Sender: TObject);
begin
  lblPlayerDrawWaitTime.Caption := IntToStr(
    scrPlayerDrawWaitTime.Position );
end;

procedure TfrmSetting.DrawMonColor;
var
  i, cnt: Integer;
  e: Extended;
begin
  cnt := Length( ini.MonColor );
  e := imgMon.Height / cnt;

  with imgMon.Canvas do
  begin
    for i:=0 to cnt-1 do
    begin
      Pen.Color := ini.MonColor[i];
      Brush.Color := ini.MonColor[i];
      Rectangle(
        3, Trunc( i * e ),
        Trunc( e ), Trunc( (i+1) * e - 3)
      );
      Brush.Color := clWhite;
      TextOut(
        Trunc(e+4),
        Trunc(e*i),
        mon_text[i]
      );
    end;
  end;
  ColorDataToMemo;
end;


procedure TfrmSetting.imgMonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  cnt: Integer;
  e: Extended;
  idx: Integer;
begin
  cnt := Length( ini.MonColor );
  e := imgMon.Height / cnt;

  idx := Trunc(Y / e);
  if dlgColor.Execute then
  begin
    ini.MonColor[idx] := dlgColor.Color ;
    DrawMonColor ;
  end;
end;

procedure TfrmSetting.btnPlayerPortClick(Sender: TObject);
begin
  frmMidiPort.ShowModal ;  
end;

procedure TfrmSetting.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSetting.ColorDataToMemo;
var
  i: Integer;
  s: string;
begin
  s := '';
  for i:=0 to high(ini.MonColor) do
  begin
    s := s + IntToStr(ini.MonColor[i]) + ',';
  end;
  memColor.Text := s;
end;

procedure TfrmSetting.MemoToColorData;
var
  i: Integer;
  s: TStringList;
begin
  s := TStringList.Create ;
  try
    s.Text := Trim(JReplace(memColor.Text, ',', #13#10, True));
    for i:=0 to high(ini.MonColor) do
    begin
      if s.Count > i then
        ini.MonColor[i] := StrToIntDef(s.Strings[i],0);
    end;
  finally
    s.Free ;
  end;
  DrawMonColor;
end;

procedure TfrmSetting.btnColorCopyClick(Sender: TObject);
begin
  memColor.SelectAll ;
  memColor.CopyToClipboard ;
  Beep;
end;

procedure TfrmSetting.btnMemoToColorClick(Sender: TObject);
begin
  MemoToColorData;
end;

procedure TfrmSetting.btnColorPasteClick(Sender: TObject);
begin
  memColor.SelectAll ;
  memColor.PasteFromClipboard ;
  memColor.Text := Trim( memColor.Text );
  MemoToColorData;
  Beep;
end;

procedure TfrmSetting.btnColorLoadLibClick(Sender: TObject);
var
  path: string;
begin
  path := AppPath + 'skin\play_mon.txt';
  lstColor.Items.LoadFromFile(path);
end;

procedure TfrmSetting.btnColorRegLibClick(Sender: TObject);
var
  path: string;
  s: string;
begin
  s := InputBox('配色の名前は？','配色の名前','');
  s := JReplace(s,',','_',True);
  if s='' then Exit;
  path := AppPath + 'skin\play_mon.txt';
  lstColor.Items.Add(s + ',' + memColor.Text);
  lstColor.Items.SaveToFile(path);
end;

procedure TfrmSetting.lstColorClick(Sender: TObject);
var
  s: string;
begin
  if lstColor.ItemIndex < 0 then Exit;
  s := lstColor.Items[lstColor.ItemIndex];
  if s='' then Exit;
  GetToken(',',s); // trim name
  memColor.Text := Trim(s);
  btnMemoToColorClick(nil); 
end;

procedure TfrmSetting.btnColorDelLibClick(Sender: TObject);
var
  path: string;
begin
  if lstColor.ItemIndex < 0 then Exit;
  lstColor.Items.Delete(lstColor.ItemIndex);

  path := AppPath + 'skin\play_mon.txt';
  lstColor.Items.SaveToFile(path);
end;

procedure TfrmSetting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmSakuraPad.ini.SaveForm(Self);
end;

procedure TfrmSetting.btnTWDownloadClick(Sender: TObject);
begin
  if MsgYesNo('TW-Music2は、TAKE SOFTさん作のMIDIプレイヤーです。'#13#10+
              'TW-Music2のホームページからダウンロードしてください。') then
  begin
    OpenApp('http://koremaka.hp.infoseek.co.jp/twm2.html');
  end;
end;

procedure TfrmSetting.btnTWGetClick(Sender: TObject);
begin
  if not dlgExe.Execute then Exit;
  edtTWPath.Text := dlgExe.FileName;
end;

procedure MidiInProc(Handle: hMidiIn; wMsg: UINT; dwInstance: DWORD;
  p1, p2: DWORD); stdcall;
var
  m0,m1,m2: Byte;
  o, n: Integer;
  s: string;
const
  nn: array[0..11]of string = ('ド','ド#','レ','レ#','ミ','ファ','ファ#','ソ','ソ#','ラ','ラ#','シ');
begin
  case wMsg of
  MM_MIM_DATA:
    begin
      if MidiOutHandle > 0 then
      begin
        midiOutShortMsg(MidiOutHandle, p1);
      end;
      if MidiToEdit then
      begin
        m0 := (p1 and $FF);
        m1 := (p1 and $FF00) shr 8;
        m2 := (p1 and $FF0000) shr 16;
        if ((m0 and $F0) = $90)and(m2 > 0) then
        begin
          o := m1 div 12;
          n := m1 mod 12;
          s := '';
          if LastOctave <> o then
          begin
            LastOctave := o;
            s := s + 'o'+ IntToStr(o);
          end;
          frmSakuraPad.ActiveEditor.SelText := s+nn[n]+#13#10;
        end;
      end;
    end;
  end;
end;


procedure TfrmSetting.chkKansiMidiInClick(Sender: TObject);
begin

  // MIDI-INが開かれてれば閉じる
  if MidiInHandle <> 0 then
  begin
    midiInStop(MidiInHandle); 
    midiInClose(MidiInHandle);
  end;
  if MidiOutHandle <> 0 then
  begin
    midiOutClose(MidiOutHandle);
  end;

  if chkKansiMidiIn.Checked then
  begin
    if lstMidiIn.ItemIndex < 0 then
    begin
      ShowMessage('MIDI-INポートを選択してください。');
      chkKansiMidiIn.Checked := False;
      Exit;
    end;
    if (chkMidiInToOut.Checked = False)and(chkMidiInToEdit.Checked = False) then
    begin
      ShowMessage('監視する目的を選択してください。');
      chkKansiMidiIn.Checked := False;
      Exit;
    end;

    if midiInOpen(@MidiInHandle,
      lstMidiIn.ItemIndex,
      Integer(@MidiInProc),
      0,
      CALLBACK_FUNCTION) <> MMSYSERR_NOERROR then
    begin
      ShowMessage('MIDI-INポートが開けませんでした。設定を見直してください。');
      Exit;
    end;
    //設定
    if chkMidiInToOut.Checked then
    begin
      if cmbMidiOut.ItemIndex < 0 then
      begin
        ShowMessage('先にMIDI出力ポートを選択してください。');
        MidiInClose(MidiInHandle);
        Exit;
      end;
      if midiOutOpen(@MidiOutHandle,
        cmbMidiOut.ItemIndex,
        0,
        hInstance,
        CALLBACK_NULL) <> MMSYSERR_NOERROR then
      begin
        MidiInClose(MidiInHandle);
        ShowMessage('MIDI出力ポートが開けませんでした。');
        Exit;
      end;
    end;
    MidiToEdit := chkMidiInToEdit.Checked;
    midiInStart(MidiInHandle);
  end else
  begin
    //既に閉じているのでOK
    //procMidiInClose;
  end;
end;

procedure TfrmSetting.FormDestroy(Sender: TObject);
begin
  MidiToEdit := False;
end;

initialization
  MidiInHandle := 0;
  MidiOutHandle := 0;
  MidiToEdit := False;
  LastOctave := -1;

finalization
  //===============================
  // IN/OUTを閉じる
  if MidiInHandle <> 0 then
  begin
    midiInClose(MidiInHandle);
  end;
  if MidiOutHandle <> 0 then
  begin
    midiOutClose(MidiOutHandle);
  end;
  //===============================


end.
