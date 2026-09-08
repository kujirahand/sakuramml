program sakura;

uses
  Windows,
  Forms,
  SysUtils,
  sakurapadU in 'sakurapadU.pas' {frmSakuraPad},
  gui_benri in 'gui_benri.pas',
  StrUnit in 'strunit.pas',
  mci_cmd in 'mci_cmd.pas',
  use_sakura_dll in 'use_sakura_dll.pas',
  frmFindU in 'frmFindU.pas' {frmFind},
  csvDB in 'csvDB.pas',
  DirUtil in 'DirUtil.pas',
  frmReplaceU in 'frmReplaceU.pas' {frmReplace},
  frmKeyboardU in 'frmKeyboardU.pas' {frmKeyboard},
  frmOnpu in 'frmOnpu.pas' {frmOnpu1},
  frmAboutU in 'frmAboutU.pas' {frmAbout},
  jconvert in 'jconvert.pas',
  frmSelListU in 'frmSelListU.pas' {frmSelList},
  tabCtrlMan in 'tabCtrlMan.pas',
  frmSplash in 'frmSplash.pas' {frmSplashWindow},
  frmKeyMapU in 'frmKeyMapU.pas' {frmKeyMap},
  frmInputNumU in 'frmInputNumU.pas' {frmInputNum},
  HEditorMi in 'HEditorMi.pas',
  frmHokanU in 'frmHokanU.pas' {frmHokan},
  frmRythmBoxU in 'frmRythmBoxU.pas' {frmRythmBox},
  frmFindHelp in 'frmFindHelp.pas' {frmFindHelpF},
  frmWizHajimeteU in 'frmWizHajimeteU.pas' {frmWizHajimete},
  smf_unit in 'smf_unit.pas',
  smf_play in 'smf_play.pas',
  midi_out in 'midi_out.pas',
  frmPlayMonitorU in 'frmPlayMonitorU.pas' {frmPlayMonitor},
  frmMidiPortU in 'frmMidiPortU.pas' {frmMidiPort},
  frmSettingU in 'frmSettingU.pas' {frmSetting},
  ini_util in 'ini_util.pas',
  frmMML2MidiU in 'frmMML2MidiU.pas' {frmMML2Midi},
  frmTenkeyU in 'frmTenkeyU.pas' {frmTenkey};

{$R *.res}
{$R pad_manifest.res}


var
  frm1: TfrmSplashWindow;
begin
  Application.Initialize;
  if not FileExists(ExtractFilePath(ParamStr(0))+SHOW_LOGO_FILE) then
  begin
    frm1 := TfrmSplashWindow.Create(Application.MainForm);
    frm1.Show ;
  end;
  Application.CreateForm(TfrmSakuraPad, frmSakuraPad);
  Application.CreateForm(TfrmFind, frmFind);
  Application.CreateForm(TfrmReplace, frmReplace);
  Application.CreateForm(TfrmKeyboard, frmKeyboard);
  Application.CreateForm(TfrmOnpu1, frmOnpu1);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmSelList, frmSelList);
  Application.CreateForm(TfrmKeyMap, frmKeyMap);
  Application.CreateForm(TfrmInputNum, frmInputNum);
  Application.CreateForm(TfrmHokan, frmHokan);
  Application.CreateForm(TfrmRythmBox, frmRythmBox);
  Application.CreateForm(TfrmFindHelpF, frmFindHelpF);
  Application.CreateForm(TfrmWizHajimete, frmWizHajimete);
  Application.CreateForm(TfrmPlayMonitor, frmPlayMonitor);
  Application.CreateForm(TfrmMidiPort, frmMidiPort);
  Application.CreateForm(TfrmSetting, frmSetting);
  Application.CreateForm(TfrmMML2Midi, frmMML2Midi);
  Application.CreateForm(TfrmTenkey, frmTenkey);
  Application.Run;
end.
