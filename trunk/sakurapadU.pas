unit sakurapadU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, HEditor, heClasses, HEdtProp, HPropUtils, HViewEdt, heRaStrings, ToolWin, ComCtrls, ImgList, ExtCtrls, StdCtrls,
  DdeMan, csvDB, OleCtrls, SHDocVw, NewCtrls, MPlayer, smf_play, midi_out,
  Gauges, jpeg, Registry, shlobj, clipbrd, ActiveX, Buttons, Spin, tabCtrlMan,
  MenuBar, ActnMan, ActnCtrls, ActnList, ActnMenus, mmsystem, gMouseGesture, ini_util;

const
  TEMP_DIR        = 'temp\';
  BACKUP_FILENAME = 'backup.mml';
  MIDI_FILENAME   = 'sakura.mid';
  CMD_TXT         = 'doc\command.txt';
  CMD2_TXT        = 'Include\command2.txt';
  MLD_TXT         = 'doc\mld.txt';
  VOICE_TXT       = 'tools\voice.txt';
  HELP_TXT        = 'tools\help.txt';
  ARUKAS          = 'tools\arukas.exe';
  SHOW_LOGO_FILE  = 'tools\nologo';
  Kakikake        = '�T�N����������.txt';

  NOTE_NO_TABLE: array [0..6] of Integer = (9,11,0,2,4,5,7);

  WAV : array [0..5] of string = (
	'to.wav',
	'ki.wav',
	'n.wav',
	'pi.wav',
	'pu.wav',
	'b.wav'
  );
  WAV_TO = 0;
  WAV_KI = 1;
  WAV_N  = 2;
  WAV_PI = 3;
  WAV_PU = 4;
  WAV_B  = 5;


const
  mpMCI   = 0;
  mpTMidi = 1;
  mpSakura= 2;
  mpTW    = 3;

type

  TIniSakura = class(TIniList)
  public
    PlayerType: Integer;
    TMidiPath,
    TWPath,
    SkinPath: string;
    SynthType: Integer;
    UseSkin: Boolean;
    FontSize: Integer;
    OutMML: Integer; // 0:�X�g�g�� 1:MML 2:���ƂƂ�
    Recent: TStringList;
    PlayerWaitTime: Integer;
    PlayerDrawWaitTime: Integer;
    MidiPort: array[0..MAX_PORT-1]of Integer; //-2�����ݒ�
    MonColor: array[0..14]of Integer; //���j�^�[�̔z�F
  end;


  TfrmSakuraPad = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuNew: TMenuItem;
    mnuOpen: TMenuItem;
    mnuSave: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuExit: TMenuItem;
    N3: TMenuItem;
    Edit1: TMenuItem;
    mnuUndo: TMenuItem;
    mnuRedo: TMenuItem;
    mnuCut: TMenuItem;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    mnuFind: TMenuItem;
    mnuReplace: TMenuItem;
    mnuGoto: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Help1: TMenuItem;
    mnuHelpContents: TMenuItem;
    mnuAbout: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    mnuSaveAsMIDI: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    mnuRun: TMenuItem;
    mnuStop: TMenuItem;
    N10: TMenuItem;
    S1: TMenuItem;
    mnuSelDevice: TMenuItem;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    Find1: TMenuItem;
    mnuSelectAll: TMenuItem;
    Show1: TMenuItem;
    mnuShowBenriPanel: TMenuItem;
    mnuErrorTab: TMenuItem;
    mnuFindNext: TMenuItem;
    N11: TMenuItem;
    panelForm: TPanel;
    pageBottom: TPageControl;
    tabError: TTabSheet;
    splitBottom: TSplitter;
    dlgSaveMidi: TSaveDialog;
    PopupMenu1: TPopupMenu;
    popUndo: TMenuItem;
    popRedo: TMenuItem;
    N9: TMenuItem;
    popCut: TMenuItem;
    popCopy: TMenuItem;
    popPaste: TMenuItem;
    N12: TMenuItem;
    popSelectAll: TMenuItem;
    DdeClientConv1: TDdeClientConv;
    N14: TMenuItem;
    mnuPlayMidi: TMenuItem;
    N15: TMenuItem;
    mnuEditSetting: TMenuItem;
    EditorProp: TEditorProp;
    dlgExe: TOpenDialog;
    N16: TMenuItem;
    mnuCompilerLog: TMenuItem;
    mnuCompilerTime: TMenuItem;
    mnuHomePage: TMenuItem;
    tabHTML: TTabSheet;
    Panel2: TPanel;
    FileDrop1: TFileDrop;
    mnuResetGM: TMenuItem;
    mnuResetGS: TMenuItem;
    mnuResetXG: TMenuItem;
    N17: TMenuItem;
    popupMenuInclude: TPopupMenu;
    mnuOpenIncludeFile: TMenuItem;
    mnuArukas: TMenuItem;
    mnuShowKeyboard: TMenuItem;
    mnuShowGosenfu: TMenuItem;
    timerPlayer: TTimer;
    imgToolBar: TImageList;
    mnuAutoPlay: TMenuItem;
    timerAutoPlay: TTimer;
    N20: TMenuItem;
    N22: TMenuItem;
    mnuRegistMML: TMenuItem;
    mnuUninstall: TMenuItem;
    mnuSaveToMld: TMenuItem;
    dlgSaveMld: TSaveDialog;
    popupMenuSystemTab: TPopupMenu;
    popInsCmd: TMenuItem;
    popShowManual: TMenuItem;
    mnuInsSampleMML: TMenuItem;
    N23: TMenuItem;
    panelManual: TPanel;
    btnBack: TSpeedButton;
    mnuSelectKakou: TMenuItem;
    mnuSelectComment: TMenuItem;
    mnuSelectLoop: TMenuItem;
    mnuSelectStr: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    mnuTabToSpace: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    mnuShowBBS: TMenuItem;
    popJumpDefVar: TMenuItem;
    N36: TMenuItem;
    btnShowNewBrowser: TSpeedButton;
    mnuMidi2Mml: TMenuItem;
    N39: TMenuItem;
    mnuShowTrackInfo: TMenuItem;
    dlgOpenMidi: TOpenDialog;
    N40: TMenuItem;
    mnuPlayerRepeat: TMenuItem;
    cbarTop: TControlBar;
    ToolBar4: TToolBar;
    ToolButton3: TToolButton;
    ToolButton8: TToolButton;
    ToolBar5: TToolBar;
    toolPlay: TToolButton;
    toolStop: TToolButton;
    N47: TMenuItem;
    browser: TWebBrowser;
    btnErrTabClose: TSpeedButton;
    Panel5: TPanel;
    Panel8: TPanel;
    edtError: TEditor;
    tabErrTabClose2: TSpeedButton;
    cbarBottom: TControlBar;
    panelPlayer: TPanel;
    chkPlayFrom: TCheckBox;
    edtTime1: TSpinEdit;
    edtTime3: TSpinEdit;
    edtTime2: TSpinEdit;
    N37: TMenuItem;
    N42: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    ToolBar1: TToolBar;
    toolNew: TToolButton;
    toolOpen: TToolButton;
    toolSave: TToolButton;
    panelTrack: TPanel;
    lblInfo: TLabel;
    lblBar: TLabel;
    actList: TActionList;
    actNew: TAction;
    actOpen: TAction;
    actSaveAs: TAction;
    actZ: TAction;
    actX: TAction;
    actC: TAction;
    actV: TAction;
    actAll: TAction;
    actFind: TAction;
    actFindNext: TAction;
    actReplace: TAction;
    actGotoLine: TAction;
    actKeybd: TAction;
    actGosenfu: TAction;
    actRun: TAction;
    actStop: TAction;
    Label2: TLabel;
    Label3: TLabel;
    panelLeft: TPanel;
    panelLeftTop: TPanel;
    pageLeft: TPageControl;
    tabComment: TTabSheet;
    Panel4: TPanel;
    Label1: TLabel;
    cmbComment: TComboBox;
    btnEnumComment: TButton;
    lstComment: TListBox;
    tabCommand: TTabSheet;
    Splitter3: TSplitter;
    lstCmdGroup: TListBox;
    lstCommand: TListBox;
    tabInclude: TTabSheet;
    Splitter4: TSplitter;
    lstFiles: TListBox;
    tabList: TTabSheet;
    Splitter5: TSplitter;
    imgGakki: TImage;
    imgDown: TImage;
    lstVoice: TListBox;
    lstVoiceGroup: TListBox;
    tabHelp: TTabSheet;
    panelPicture: TPanel;
    lstHelp: TListBox;
    btnLeftPanelClose: TSpeedButton;
    imgLeftTop: TImage;
    dlgOpenSkin: TOpenDialog;
    ToolBar3: TToolBar;
    toolFontSmall: TToolButton;
    toolFontMiddle: TToolButton;
    toolFontBig: TToolButton;
    N49: TMenuItem;
    mnuLineBreak: TMenuItem;
    actLineBreak: TAction;
    N50: TMenuItem;
    mnuLineCentering: TMenuItem;
    mnuLineRighting: TMenuItem;
    actHelp: TAction;
    mnuHelpIndex: TMenuItem;
    Splitter1: TSplitter;
    mnuKeyMapping: TMenuItem;
    actY: TAction;
    mnuEffect: TMenuItem;
    mnuAutoHelp: TMenuItem;
    actInsLineTab: TAction;
    actDelLineTab: TAction;
    N32: TMenuItem;
    N33: TMenuItem;
    N52: TMenuItem;
    N26: TMenuItem;
    N53: TMenuItem;
    N54: TMenuItem;
    mnuRecBookmark: TMenuItem;
    mnuGotoBookmark: TMenuItem;
    N13: TMenuItem;
    popSetSiori: TMenuItem;
    splitLeft: TSplitter;
    mnuExternalBrowser: TMenuItem;
    N56: TMenuItem;
    tabTemplate: TTabSheet;
    lstTemplate: TListBox;
    actTemplateReg: TAction;
    N57: TMenuItem;
    N58: TMenuItem;
    N59: TMenuItem;
    Show2: TMenuItem;
    N19: TMenuItem;
    mnuSplitEdit: TMenuItem;
    panelEditor: TPanel;
    edtMain: TEditor;
    popupTemplate: TPopupMenu;
    N45: TMenuItem;
    N61: TMenuItem;
    N62: TMenuItem;
    mnuTemplateDelete: TMenuItem;
    N63: TMenuItem;
    mnuTemplateDir: TMenuItem;
    mnuShowTemplateTab: TMenuItem;
    mnuSplashWindow: TMenuItem;
    mnuInsInclude: TMenuItem;
    mnuRecent: TMenuItem;
    popRecent: TPopupMenu;
    mnuHokan: TMenuItem;
    N43: TMenuItem;
    actHokan: TAction;
    toolPlayReset: TToolButton;
    MPlay: TMediaPlayer;
    track: TTrackBar;
    actPlayPrev: TAction;
    N55: TMenuItem;
    mnuRythmBox: TMenuItem;
    mnuUseMouseGesture: TMenuItem;
    mnuHelpMouseGesture: TMenuItem;
    mnuShowBookmark: TMenuItem;
    Panel1: TPanel;
    lstUser: TListBox;
    chkSortUserFunc: TCheckBox;
    mnuShowIncludeManual: TMenuItem;
    mnuWriteMidiBBS: TMenuItem;
    N64: TMenuItem;
    mnuOnlyCompile: TMenuItem;
    mnuFindManual: TMenuItem;
    N66: TMenuItem;
    MIDI1: TMenuItem;
    mnuOpenMidiBBS: TMenuItem;
    mnuShowFAQ: TMenuItem;
    N65: TMenuItem;
    mnuPlugins: TMenuItem;
    mnuPluginEnum: TMenuItem;
    mnuInsDllVer: TMenuItem;
    command: TDdeServerConv;
    N68: TMenuItem;
    mnuShowPlayMonitor: TMenuItem;
    mnuShowMonitor: TMenuItem;
    N69: TMenuItem;
    N46: TMenuItem;
    mnuSetting: TMenuItem;
    N1: TMenuItem;
    N18: TMenuItem;
    N44: TMenuItem;
    mnuPlayMonitorTop: TMenuItem;
    toolMon: TToolButton;
    mnuEffectPlay: TMenuItem;
    N48: TMenuItem;
    mnuEffectClipboard: TMenuItem;
    popMessageBox: TPopupMenu;
    popMsgCopy: TMenuItem;
    popMsgClear: TMenuItem;
    SMFformat01: TMenuItem;
    mnuCloseEx: TMenuItem;
    N21: TMenuItem;
    mnuUseCloseEx: TMenuItem;
    img32file: TImageList;
    mnuMML2MIDIAll: TMenuItem;
    toolPlayFirst: TToolButton;
    mnuRunFirst: TMenuItem;
    actRunFirst: TAction;
    panelHelpTop: TPanel;
    imgMan: TImage;
    progBar: TProgressBar;
    lblMsg: TLabel;
    N38: TMenuItem;
    N41: TMenuItem;
    mnuSaveAsMidiEasy: TMenuItem;
    N51: TMenuItem;
    mnuAutoSaveMenu: TMenuItem;
    mnuAutoSave: TMenuItem;
    N60: TMenuItem;
    mnuOpenAutoSave: TMenuItem;
    mnuClearAutoSave: TMenuItem;
    timerAutoSave: TTimer;
    N67: TMenuItem;
    N70: TMenuItem;
    toolbarPlaySub: TToolBar;
    cmbPlaySpeed: TComboBox;
    N71: TMenuItem;
    mnuSpeedCompile: TMenuItem;
    S2: TMenuItem;
    mnuSpeedNormal: TMenuItem;
    mnuSpeedHigh: TMenuItem;
    mnuSpeedLow: TMenuItem;
    actSpeedLow: TAction;
    actSpeedNormal: TAction;
    actSpeedHigh: TAction;
    mnuTenkey: TMenuItem;
    N72: TMenuItem;
    N73: TMenuItem;
    mnuAddDecNum: TMenuItem;
    popupDefine: TPopupMenu;
    popDefPlay: TMenuItem;
    popInsEdit: TMenuItem;
    N74: TMenuItem;
    popDefCH1: TMenuItem;
    popDefCH2: TMenuItem;
    popDefCH3: TMenuItem;
    popDefCH4: TMenuItem;
    popDefCH5: TMenuItem;
    popDefCH6: TMenuItem;
    popDefCH7: TMenuItem;
    popDefCH8: TMenuItem;
    popDefCH9: TMenuItem;
    popDefCH10: TMenuItem;
    popDefCH11: TMenuItem;
    popDefCH12: TMenuItem;
    popDefCH13: TMenuItem;
    popDefCH14: TMenuItem;
    popDefCH15: TMenuItem;
    popDefCH16: TMenuItem;
    N77: TMenuItem;
    N75: TMenuItem;
    N76: TMenuItem;
    N78: TMenuItem;
    mnuOutMidClock: TMenuItem;
    N79: TMenuItem;
    popAddDecNum: TMenuItem;
    popupShowManWeb: TMenuItem;
    procedure WMMousewheel(var Msg: TMessage); message WM_MOUSEWHEEL;
    procedure MMDone(var Msg: TMessage); message MM_MOM_DONE; 
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuSelDeviceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuNewClick(Sender: TObject);
    procedure edtMainChange(Sender: TObject);
    procedure btnEnumCommentClick(Sender: TObject);
    procedure lstCommentClick(Sender: TObject);
    procedure mnuGotoClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
    procedure mnuRedoClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuSelectAllClick(Sender: TObject);
    procedure mnuRunClick(Sender: TObject);
    procedure mnuStopClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuShowBenriPanelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuFindClick(Sender: TObject);
    procedure mnuFindNextClick(Sender: TObject);
    procedure mnuErrorTabClick(Sender: TObject);
    procedure mnuSaveAsMIDIClick(Sender: TObject);
    procedure edtErrorClick(Sender: TObject);
    procedure edtErrorDblClick(Sender: TObject);
    procedure edtMainDblClick(Sender: TObject);
    procedure mnuPlayMidiClick(Sender: TObject);
    procedure mnuEditSettingClick(Sender: TObject);
    procedure mnuCompilerLogClick(Sender: TObject);
    procedure mnuCompilerTimeClick(Sender: TObject);
    procedure mnuHomePageClick(Sender: TObject);
    procedure lstCmdGroupClick(Sender: TObject);
    procedure lstCommandClick(Sender: TObject);
    procedure lstCommandDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstCmdGroupDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstCommandDblClick(Sender: TObject);
    procedure edtMainDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure edtMainDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lstFilesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FileDrop1FileDrop(Sender: TObject; Num: Integer;
      Files: TStrings; X, Y: Integer);
    procedure mnuOpenIncludeFileClick(Sender: TObject);
    procedure lstFilesClick(Sender: TObject);
    procedure mnuArukasClick(Sender: TObject);
    procedure lstUserDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuResetGMClick(Sender: TObject);
    procedure mnuResetGSClick(Sender: TObject);
    procedure mnuResetXGClick(Sender: TObject);
    procedure mnuReplaceClick(Sender: TObject);
    procedure lstVoiceDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstVoiceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lstVoiceDblClick(Sender: TObject);
    procedure lstUserDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure mnuShowKeyboardClick(Sender: TObject);
    procedure mnuShowGosenfuClick(Sender: TObject);
    procedure timerPlayerTimer(Sender: TObject);
    procedure toolSioriClick(Sender: TObject);
    procedure toolVoiceClick(Sender: TObject);
    procedure trackEnter(Sender: TObject);
    procedure lstVoiceGroupClick(Sender: TObject);
    procedure lstVoiceGroupDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstVoiceExit(Sender: TObject);
    procedure mnuAutoPlayClick(Sender: TObject);
    procedure timerAutoPlayTimer(Sender: TObject);
    procedure mnuRegistMMLClick(Sender: TObject);
    procedure mnuUninstallClick(Sender: TObject);
    procedure mnuSaveToMldClick(Sender: TObject);
    procedure pageLeftChange(Sender: TObject);
    procedure popShowManualClick(Sender: TObject);
    procedure barClick(Sender: TObject);
    procedure browserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure mnuInsSampleMMLClick(Sender: TObject);
    procedure btnInsertSampleClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuSelectCommentClick(Sender: TObject);
    procedure mnuSelectLoopClick(Sender: TObject);
    procedure mnuSelectStrClick(Sender: TObject);
    procedure mnuTabToSpaceClick(Sender: TObject);
    procedure cmbCommentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstHelpDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstHelpClick(Sender: TObject);
    procedure popJumpDefVarClick(Sender: TObject);
    procedure btnShowNewBrowserClick(Sender: TObject);
    procedure chkPlayFromClick(Sender: TObject);
    procedure trackExit(Sender: TObject);
    procedure mnuMidi2MmlClick(Sender: TObject);
    procedure mnuShowTrackInfoClick(Sender: TObject);
    procedure mnuPlayerRepeatClick(Sender: TObject);
    procedure btnErrTabCloseClick(Sender: TObject);
    procedure btnLeftPanelCloseClick(Sender: TObject);
    procedure panelLeftClick(Sender: TObject);
    procedure mnuChangeSkinClick(Sender: TObject);
    procedure mnuSkinMode0Click(Sender: TObject);
    procedure mnuSkinMode1Click(Sender: TObject);
    procedure toolFontSmallClick(Sender: TObject);
    procedure toolFontMiddleClick(Sender: TObject);
    procedure toolFontBigClick(Sender: TObject);
    procedure actLineBreakExecute(Sender: TObject);
    procedure mnuLineCenteringClick(Sender: TObject);
    procedure mnuLineRightingClick(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure mnuHelpIndexClick(Sender: TObject);
    procedure mnuSkinMod4Click(Sender: TObject);
    procedure mnuKeyMappingClick(Sender: TObject);
    procedure actYExecute(Sender: TObject);
    procedure edtMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuEffectClick(Sender: TObject);
    procedure mnuAutoHelpClick(Sender: TObject);
    procedure actInsLineTabExecute(Sender: TObject);
    procedure actDelLineTabExecute(Sender: TObject);
    procedure lstCommentDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure popSetSioriClick(Sender: TObject);
    procedure splitLeftMoved(Sender: TObject);
    procedure edtMainTopRowChange(Sender: TObject);
    procedure mnuExternalBrowserClick(Sender: TObject);
    procedure lstTemplateDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstTemplateDblClick(Sender: TObject);
    procedure lstTemplateClick(Sender: TObject);
    procedure actTemplateRegExecute(Sender: TObject);
    procedure lstVoiceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuSplitEditClick(Sender: TObject);
    procedure edtMainEnter(Sender: TObject);
    procedure mnuTemplateDeleteClick(Sender: TObject);
    procedure mnuTemplateDirClick(Sender: TObject);
    procedure mnuShowTemplateTabClick(Sender: TObject);
    procedure mnuSplashWindowClick(Sender: TObject);
    procedure mnuInsIncludeClick(Sender: TObject);
    procedure edtMainKeyPress(Sender: TObject; var Key: Char);
    procedure mnuHokanClick(Sender: TObject);
    procedure toolPlayResetClick(Sender: TObject);
    procedure trackScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure mnuRythmBoxClick(Sender: TObject);
    procedure edtTime1Change(Sender: TObject);
    procedure mnuUseMouseGestureClick(Sender: TObject);
    procedure mnuHelpMouseGestureClick(Sender: TObject);
    procedure MouseGesMouseGestureExecute(Sender: TObject;
      Gestures: TMouseGestureArray);
    procedure mnuShowBookmarkClick(Sender: TObject);
    procedure chkSortUserFuncClick(Sender: TObject);
    procedure lstUserClick(Sender: TObject);
    procedure mnuShowIncludeManualClick(Sender: TObject);
    procedure mnuWriteMidiBBSClick(Sender: TObject);
    procedure mnuOnlyCompileClick(Sender: TObject);
    procedure mnuFindManualClick(Sender: TObject);
    procedure mnuOpenMidiBBSClick(Sender: TObject);
    procedure mnuShowFAQClick(Sender: TObject);
    procedure mnuPluginEnumClick(Sender: TObject);
    procedure mnuInsDllVerClick(Sender: TObject);
    procedure commandExecuteMacro(Sender: TObject; Msg: TStrings);
    procedure mnuShowMonitorClick(Sender: TObject);
    procedure mnuMidiPortClick(Sender: TObject);
    procedure mnuShowPlayMonitorClick(Sender: TObject);
    procedure mnuSettingClick(Sender: TObject);
    procedure mnuPlayMonitorTopClick(Sender: TObject);
    procedure mnuEffectPlayClick(Sender: TObject);
    procedure mnuEffectClipboardClick(Sender: TObject);
    procedure popMsgCopyClick(Sender: TObject);
    procedure popMsgClearClick(Sender: TObject);
    procedure SMFformat01Click(Sender: TObject);
    procedure mnuCloseExClick(Sender: TObject);
    procedure mnuUseCloseExClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuShowBBSClick(Sender: TObject);
    procedure mnuMML2MIDIAllClick(Sender: TObject);
    procedure actRunFirstExecute(Sender: TObject);
    procedure panelHelpTopResize(Sender: TObject);
    procedure mnuAutoSaveClick(Sender: TObject);
    procedure timerAutoSaveTimer(Sender: TObject);
    procedure mnuOpenAutoSaveClick(Sender: TObject);
    procedure mnuClearAutoSaveClick(Sender: TObject);
    procedure cmbPlaySpeedChange(Sender: TObject);
    procedure cmbPlaySpeedClick(Sender: TObject);
    procedure mnuSpeedCompileClick(Sender: TObject);
    procedure actSpeedLowExecute(Sender: TObject);
    procedure actSpeedNormalExecute(Sender: TObject);
    procedure actSpeedHighExecute(Sender: TObject);
    procedure mnuTenkeyClick(Sender: TObject);
    procedure mnuAddDecNumClick(Sender: TObject);
    procedure popInsEditClick(Sender: TObject);
    procedure popDefPlayClick(Sender: TObject);
    procedure popDefCH16Click(Sender: TObject);
    procedure mnuOutMidClockClick(Sender: TObject);
    procedure popupShowManWebClick(Sender: TObject);
  private
    { Private �錾 }
    SaveFileName: string;
    FileModify: Boolean;
    MidiPlaying: Boolean;
    NoteOnNo: Integer;
    VoiceNo: Integer;
    Channel : Integer;
    MidiLen: Integer;
    FileHelp: string;
    MouseTrack: Boolean;
    IsStopCompile: Boolean;
    IsInit: Boolean;
    wav_interval: Integer;
    IsSplit: Boolean;
    SecondEditor: TEditor;
    ActiveSplitter: TSplitter;
    IsLeftClick: Boolean;
    IsKakikakeClose: Boolean;
    RejectKey: Boolean;
    FDefPlayChannel: Integer;
    procedure ChangeFileName(fname:string);
    procedure ChangeTitle(cap: string);
    function  Compile: Boolean;
    procedure ShowBar(text: string);
    procedure ShowInfo(text: string);
    procedure ReadIniFile;
    procedure SaveIniFile;
    procedure OnBookmarkClick(Sender: TObject);
    procedure OnRecBookmarkClick(Sender: TObject);
    procedure ExecuteDDE(cmd: string);
    procedure MakeCommandTree;
    procedure MakeTemplateList;
    procedure MakeIncludeFileTree;
    procedure MakeVoiceTree;
    function GetSampleCode: string;
    procedure InsSelectKakko(sFrom, sTo: string);
    procedure GetCaretWord;
    procedure ShowHtml(path: string);
    procedure AssignEvent(Editor: TEditor);
    procedure MakeRecentMenu;
    procedure mnuOpenRecent(Sender: TObject);
    procedure ShowVoiceDescript;
    procedure ReadBar(Bar: TControl);
    procedure WriteBar(Bar: TControl);
    procedure PluginClick(Sender: TObject);
    procedure makeKakikake;
    procedure AutoSaveExecute;
  public
    { Public �錾 }
    midiOut: TMidiOut;
    SmfPlayer: TSmfPlayer;
    voiceList: TStringList;
    ini: TIniSakura;
    ActiveEditor: TEditor;
    cmd: TCsvDb;
    IsShowHokan: Boolean;
    TempMidiFile: string;
    BackupFile: string;
    PlayModify: Boolean;
    DirPlugins: string;
    IniWindowMaxize: Boolean;
    ManualOnline: Boolean;
    procedure GotoLine(lineNo: Integer);
    procedure mciClose;
    procedure PlayWave(no: Integer);
    function  CheckModify(caption: string): Boolean; //False �Ȃ� Exit ����
    procedure LoadToEdit(fname: string);
    procedure ChangeSkin(fname: string);
    procedure SetPlayMonitorTop;
  end;

var
  frmSakuraPad: TfrmSakuraPad;

implementation

uses gui_benri, StrUnit, mci_cmd, use_sakura_dll, frmFindU,
  DirUtil, frmReplaceU, frmKeyboardU, frmOnpu, frmAboutU, jconvert,
  frmKeyMapU, IniFiles, TypInfo, frmInputNumU, HEditorMi,
  frmHokanU, frmRythmBoxU, frmFindHelp, frmWizHajimeteU,
  frmPlayMonitorU, frmMidiPortU, frmSettingU, smf_unit, frmMML2MidiU,
  frmTenkeyU;

{$R *.dfm}

procedure TfrmSakuraPad.mnuAboutClick(Sender: TObject);
begin
    PlayWave(WAV_PI);
    frmAbout.ShowModal ;
end;

procedure TfrmSakuraPad.mnuSelDeviceClick(Sender: TObject);
begin
  mciClose ;
	WinExec('control.exe Mmsys.cpl',SW_SHOW);
end;

procedure TfrmSakuraPad.FormCreate(Sender: TObject);

    procedure install;
    begin
        MessageBox(Handle,'�e�L�X�g���y�u�T�N���v'#13#10+
        ''#13#10+
        '������T�N�������K�Ɏg�����߂̐ݒ�����܂��B'#13#10+
        '�悭������Ȃ��l�́A�u�͂��v��I��ł��������B'#13#10+
        '�i�������ōs�����ݒ�́A���Ƃ���ł��ύX�ł��܂��B�j'
        ,'�e�L�X�g���y�u�T�N���v',MB_OK);
        if MsgYesNo('".mml"�t�@�C�����A�T�N���Ɋ֘A�t���Ă��ǂ��ł����H','�e�L�X�g���y�u�T�N���v') then
        begin
            mnuRegistMMLClick(nil) ;
        end;
    end;

    procedure InitializeVariable;
    begin
        //todo:�ϐ��̏�����
        FileModify := False;
        ManualOnline := True;
        //�e���|�����t�@�C����MIDI�t�@�C�����쐬
        {
        TempMidiFile := 'skr'+FormatDateTime('hh:nn:ss',Now);
        TempMidiFile := JReplace(TempMidiFile,'/','_',True);
        TempMidiFile := JReplace(TempMidiFile,':','_',True);
        TempMidiFile := JReplace(TempMidiFile,' ','_',True);
        //TempMidiFile := TempDir + TempMidiFile + '.mid';
        TempMidiFile := AppPath + TempMidiFile + '.mid';
        }
        ForceDirectories(AppPath + TEMP_DIR);
        TempMidiFile := AppPath + TEMP_DIR + MIDI_FILENAME;
        //
        MidiPlaying := False;
        BackupFile := AppPath + TEMP_DIR + BACKUP_FILENAME;
        if FileExists(AppPath+'sakura.ini')=False then
        begin
            install;
            if FileExists(AppPath + SHOW_LOGO_FILE) then DeleteFile(AppPath + SHOW_LOGO_FILE);
        end;
        ini := TIniSakura.Create(AppPath+'sakura.ini');
        cmd := TCsvDb.Create ;
        if FileExists(AppPath + CMD_TXT) then
        begin
            cmd.LoadFromFile(AppPath + CMD_TXT);
            {if FileExists(AppPath + CMD2_TXT) then
            begin
              cmd.LoadFromFileSub(AppPath + CMD2_TXT, False);
            end;}
            makeCommandTree;
        end;
        ChangeFileName('');
        makeIncludeFileTree;
        MakeTemplateList;
        mnuSplashWindow.Checked := not FileExists(AppPath + SHOW_LOGO_FILE);

        //for DEBUG
        if FileExists(AppPath+'tools\Arukas.exe')=False then
        begin
            mnuArukas.Enabled := False;
        end;
        //MIDI
        SmfPlayer := TSmfPlayer.Create ;
        midiOut := SmfPlayer.MidiOut ;
        midiOut.CallBackWindowHandle := Self.Handle;
        NoteOnNo := -1;
        VoiceNo := -1;
        voiceList := TStringList.Create ;
        if FileExists(AppPath + VOICE_TXT) then
        begin
            voiceList.LoadFromFile(AppPath + VOICE_TXT);
            makeVoiceTree;
        end;
        if FileExists(AppPath + HELP_TXT) then
        begin
            lstHelp.Items.LoadFromFile(AppPath + HELP_TXT); 
        end;
        FileHelp := '';
        dlgOpen.InitialDir := AppPath;
        MouseTrack := False;
        IsStopCompile := False;
        SecondEditor := nil;
        IsSplit := False;
        ActiveSplitter := nil;
        ActiveEditor := edtMain;
        IsShowHokan := False;
        PlayModify := True;
        IsLeftClick := False;
        DirPlugins := AppPath + 'plug-ins\';
        FDefPlayChannel := 1;
    end;

    procedure makeBookmarkMenu;
    var
        mi: TMenuItem;
        i: Integer;
        s: string;
    begin
        //menu add Bookmark

        for i:=0 to 9 do
        begin
            mi := TMenuItem.Create(mnuRecBookmark);
            mi.Caption := '&'+IntToStr(i);
            s := IntToStr(i);
            mi.ShortCut := ShortCut(Ord(s[1]),[ssCtrl,ssShift]);
            mi.Visible := True;
            mi.Tag := i;
            mi.OnClick := OnRecBookmarkClick;
            mnuRecBookmark.Add(mi);

            mi := TMenuItem.Create(mnuGotoBookmark);
            mi.Caption := '&'+IntToStr(i);
            s := IntToStr(i);
            mi.ShortCut := ShortCut(Ord(s[1]),[ssCtrl]);
            mi.Visible := True;
            mi.Tag := i;
            mi.OnClick := OnBookmarkClick;
            mnuGotoBookmark.Add(mi);
        end;
    end;

begin
    IsInit := True;
    //�ϐ��̏�����
    InitializeVariable;
    makeBookmarkMenu;
end;

procedure TfrmSakuraPad.mnuNewClick(Sender: TObject);
var s: string; i: Integer;
begin
    if FileModify then
    begin
        if SaveFileName = '' then s := '����' else s := ExtractFileName(SaveFileName);
        i := MsgYesNoCancel('"'+s+'"�͕ύX����Ă��܂��B'#13#10+
        '�ۑ����܂����H');
        case i of
        IDYES:mnuSaveClick(nil);
        IDNO:;
        IDCANCEL: Exit;
        end;
    end;
    edtMain.Clear;
    ChangeFileName('');
    frmWizHajimete.ShowModal ;
end;

procedure TfrmSakuraPad.ChangeFileName(fname: string);
var
    cap: string;
    i: Integer;
begin
    if fname='' then cap := '����' else cap := ExtractFileName(fname);

    SaveFileName := fname;

    ChangeTitle(cap);
    FileModify := False;
    PlayModify := True;

    if fname<>'' then
    begin
        i := ini.Recent.IndexOf(fname);
        if i>=0 then ini.Recent.Delete(i);
        if ini.Recent.Count>15 then ini.Recent.Delete(0);
        ini.Recent.Add(fname);
        MakeRecentMenu ;
    end;
end;

procedure TfrmSakuraPad.edtMainChange(Sender: TObject);
begin
    FileModify := True;
    PlayModify := True;
    ChangeTitle(SaveFileName);
end;

procedure TfrmSakuraPad.btnEnumCommentClick(Sender: TObject);
var
    i,cnt: Integer;
    key, s: string;
begin
    lstComment.Clear ;

    key := cmbComment.Text ;
    cnt := Length(key);
    for i:=0 to edtMain.Lines.Count -1 do
    begin
        s := edtMain.Lines.Strings[i];
        if Copy(s,1,cnt)=key then
        begin
            lstComment.Items.Add(s);
        end;
    end;
end;

procedure TfrmSakuraPad.lstCommentClick(Sender: TObject);
var
    i, cnt: Integer;
    key: string;
begin
    i := lstComment.ItemIndex ;
    if i < 0 then Exit;

    key := lstComment.Items[i];
    cnt := Length(key);
    for i:=0 to edtMain.Lines.Count -1 do
    begin
        if Copy(edtMain.Lines.Strings[i],1,cnt) = key then
        begin
            GotoLine(i);
            Break;
        end;
    end;
end;

procedure TfrmSakuraPad.GotoLine(lineNo: Integer);
begin
    ActiveEditor.SetFocus ;
    PlayWave(WAV_TO);
    if lineNo >= ActiveEditor.Lines.Count then Exit;
    with ActiveEditor do
    begin
        SelStart := Length(ActiveEditor.Lines.Text)-1;
        SelLength := 0;
        SetRowCol(LineNo, 0);
        SelLength := Length( ActiveEditor.Lines.Strings[lineNo] );
    end;
end;

procedure TfrmSakuraPad.mnuGotoClick(Sender: TObject);
var
    s: string;
begin
    s := InputBox('�w��s�ֈړ�','�ړ��������s�ԍ�����͂��Ă��������B','');
    if s='' then Exit;
    GotoLine( StrToIntDef(ConvToHalf(s),-1) ) ;
end;

procedure TfrmSakuraPad.mnuUndoClick(Sender: TObject);
begin
    ActiveEditor.Undo ;
    if mnuEffectClipboard.Checked then PlayWave(WAV_N);
end;

procedure TfrmSakuraPad.mnuRedoClick(Sender: TObject);
begin
    ActiveEditor.Redo ;
    if mnuEffectClipboard.Checked then PlayWave(WAV_N);
end;

procedure TfrmSakuraPad.mnuCutClick(Sender: TObject);
begin
    ActiveEditor.CutToClipboard ;
    if mnuEffectClipboard.Checked then PlayWave(WAV_N);
end;

procedure TfrmSakuraPad.mnuCopyClick(Sender: TObject);
begin
    ActiveEditor.CopyToClipboard ;
    if mnuEffectClipboard.Checked then PlayWave(WAV_N);
end;

procedure TfrmSakuraPad.mnuPasteClick(Sender: TObject);
begin
    ActiveEditor.PasteFromClipboard ;
    if mnuEffectClipboard.Checked then PlayWave(WAV_N);
end;

procedure TfrmSakuraPad.mnuSelectAllClick(Sender: TObject);
begin
    ActiveEditor.SetFocus ;
    ActiveEditor.SelectAll ;
    if mnuEffectClipboard.Checked then PlayWave(WAV_N);
end;

var
  timeCallback: DWORD;

procedure ProgFunc(NowLine, LineCount: Integer; msg: PChar; StopCompile: PBOOL); stdcall;
var
  per: Integer;
begin
  // ���܂�p�ɂ��ƃR���p�C�����x���Ȃ�
  if (timeCallBack + 300) < timeGetTime then
  begin
    Application.ProcessMessages ;
    timeCallBack := timeGetTime ;
  end else
  begin
    StopCompile^ := frmSakuraPad.IsStopCompile;
    Exit;
  end;

  with frmSakuraPad do
  begin
    if LineCount > 0 then
    begin
      per := Trunc(NowLine / LineCount * 100);
      //if (progBar.Position = per)and(Now) then Exit;
      progBar.Max := 100;
      progBar.Position := per;
    end;

    lblMsg.Caption := Format('[%03d/%03d]',[NowLine, LineCount])+' '+string(msg);
    StopCompile^ := IsStopCompile;
  end;
end;

function TfrmSakuraPad.Compile: Boolean;
var
    txt, path: string;
begin
    Result := True;

    //��ɃR���p�C��������?
    if PlayModify = False then Exit;

    //track.Position := 0;

    mnuRun.Enabled := False;
    toolPlay.Enabled := False;
    try
        begin //�S�Ẵ^�u
          txt := edtMain.Lines.Text ;
        end;
        if txt='' then Exit;
        txt := '//OriginalFile:' + SaveFileName + #13#10 +
               'SoundType='+IntToStr(ini.SynthType)+';'+txt;
        if chkPlayFrom.Checked then
        begin
          txt := txt + ' ;PlayFrom('+edtTime1.Text + ':' + edtTime2.Text + ':'+ edtTime3.Text+');';
        end;
        try
          WriteTextFile(BackupFile, txt);
        except
          ShowMessage('�o�b�N�A�b�v�t�@�C�����쐬�ł��܂���ł����B');
        end;
        try
          AutoSaveExecute; //�����ۑ�
        except
          ShowMessage('�����ۑ��Ɏ��s���܂����B');
        end;
        DeleteFile(TempMidiFile);
        progBar.Visible := True;
        lblMsg.Visible := True;
        sleep(100);
        path := ExtractFilePath(SaveFileName);
        if path='' then path := AppPath;
        SetCurrentDir(path);
        IsStopCompile := False;
        try
          timeCallback := timeGetTime ;
          if not mnuSpeedCompile.Checked then
          begin // �r���Œ�~�\
            Result := mmlCompile2(txt, TempMidiFile, @ProgFunc); //���������Ƃ�
          end else
          begin // �r���Œ�~�s�\
            Result := mmlCompile(txt, TempMidiFile); //���������Ƃ�
          end;
          Application.ProcessMessages ;
          if FileExists(TempMidiFile)=False then Result := False;
        except
          Result := False;
        end;
        //gauge.Visible := False;
        progBar.Position := 0;
        ShowInfo('ready');
        ShowBar(mmlErrorMessage);
        edtError.Lines.Text := mmlErrorMessage;
    finally
        mnuRun.Enabled := True;
        toolPlay.Enabled := True;
        midiLen := -1;
        PlayModify := False;
        progBar.Visible := False; lblMsg.Visible := False;
    end;
    if mnuCompilerLog.Checked then
    begin
        RunApp('notepad.exe "log_sakura.txt"');
    end;
end;

procedure TfrmSakuraPad.mnuRunClick(Sender: TObject);
begin
    if mnuEffectPlay.Checked then PlayWave(WAV_KI);
    Application.ProcessMessages ;
    mciClose ;
    if Compile then
    begin
        if Pos('�q���g',edtError.Lines.Text) > 0 then
          if pageBottom.Visible = False then mnuErrorTabClick(nil);
        mnuPlayMidiClick(nil);
    end else
    begin
        if pageBottom.Visible = False then
          mnuErrorTabClick(nil);
    end;
    if pageBottom.Visible then
    begin
        pageBottom.ActivePageIndex := 0;
        ActiveEditor.SetFocus ;
    end;
    Application.ProcessMessages ;
    ActiveEditor.SetFocus ;
end;

procedure TfrmSakuraPad.mnuStopClick(Sender: TObject);

    procedure subMCI;
    begin
      if MPlay.Mode = mpPlaying then MPlay.Stop ;
      if (MPlay.Mode = mpOpen)or(MPlay.Mode = mpStopped) then MPlay.Close ;
    end;

    procedure subTMidi;
    begin
        ExecuteDDE('stop');
    end;

    procedure subSakura;
    begin
        SmfPlayer.Stop ;
        SmfPlayer.MidiOut.CloseAll ;
    end;

begin
    IsStopCompile := True;
    //PlayWave(WAV_N);
    timerPlayer.Enabled := False;
    if MidiPlaying=False then
    begin
        mciClose;
        Exit;
    end;
    case ini.PlayerType of
      mpMCI        : subMCI;
      mpTMidi, mpTW: subTMidi;
      mpSakura     : subSakura;
    end;
    MidiPlaying := False;
    Application.ProcessMessages ;
    //timerPlayer.Enabled := True;
end;

procedure TfrmSakuraPad.mnuOpenClick(Sender: TObject);
begin
    if not CheckModify('�t�@�C�����J��') then Exit;
    if not dlgOpen.Execute then Exit;
    LoadToEdit(dlgOpen.FileName);
end;

procedure TfrmSakuraPad.mnuSaveClick(Sender: TObject);
begin
    if SaveFileName = '' then
    begin
        mnuSaveAsClick(nil);
        Exit;
    end;
    AutoSaveExecute;
    edtMain.Lines.SaveToFile(SaveFileName);
    FileModify := False;
    ChangeTitle(SaveFileName);
    PlayWave(0);
end;

procedure TfrmSakuraPad.ShowBar(text: string);
begin
    text := JReplace(text, #13#10, ' ', True);
    lblBar.Caption := text + '  ';
end;

procedure TfrmSakuraPad.mnuShowBenriPanelClick(Sender: TObject);
begin
    mnuShowBenriPanel.Checked := not mnuShowBenriPanel.Checked;
    if mnuShowBenriPanel.Checked then
    begin
        pageLeft.Visible := True;
        panelLeft.Width := 185;
        PlayWave(WAV_PI);
        splitLeftMoved(nil);
    end else
    begin
        pageLeft.Visible := False;
        panelLeft.Width := 10;
        PlayWave(WAV_B);
    end;
end;

procedure TfrmSakuraPad.ReadBar(Bar: TControl);
var
  B: Boolean;
  R: TRect;
  S: string;
begin
  with Ini do
  begin
    S := 'ToolBar\'+Bar.Name;
    B := ReadBool(S, 'Docking', True);
    R.Top := ReadInteger(S, 'Top', Bar.Top);
    R.Left := ReadInteger(S, 'Left', Bar.Left);
    if B then
    begin
      Bar.Top := R.Top;
      Bar.Left := R.Left;
    end
    else begin
      R.Bottom := R.Top + Bar.Height;
      R.Right := R.Left + Bar.Width;
      Bar.ManualFloat(R);
    end;
    Bar.Visible := True;//ReadBool(S, 'Visible', True)
  end;
end;

procedure TfrmSakuraPad.WriteBar(Bar: TControl);
var
  B: Boolean;
  S: string;
begin
  with Ini do
  begin
    B := cbarTop.ContainsControl(Bar);
    S := 'ToolBar\'+Bar.Name;
    WriteBool(S, 'Docking', B);
    WriteBool(S, 'Visible', Bar.Visible);
    if B then
    begin
      WriteInteger(S, 'Top', Bar.Top);
      WriteInteger(S, 'Left', Bar.Left);
    end
    else begin
      WriteInteger(S, 'Top', Bar.Parent.Top);
      WriteInteger(S, 'Left', Bar.Parent.Left);
    end;
  end;
end;

procedure TfrmSakuraPad.SaveIniFile;
var
    s: string;
    i: Integer;
begin
    //�����l

    //(�G�f�B�^�̐ݒ莞�_�ŏ�������ł��܂�)EditorProp.Ini(AppPath+'sakura.ini','main_edit','a');//�G�f�B�^�̐ݒ�
    //�֗��p�l��
    ini.WriteInteger('main','fontsize', edtMain.Font.Size);
    ini.WriteInteger('tools','OutMML', ini.OutMML);

    ini.WriteInteger('main','BenriPanelWidth', pageLeft.Width);
    ini.WriteInteger('main','PanelBottom', pageBottom.Height);


    //MIDI�|�[�g
    for i:=0 to MAX_PORT-1 do
    begin
      ini.WriteInteger('midi','port'+IntToStr(i),ini.MidiPort[i]);//���ݒ肪-2
    end;

    //�V���[�g�J�b�g
    ini.WriteString('shortcut','Undo', ShortCutToText(actZ.ShortCut) );
    ini.WriteString('shortcut','Cut', ShortCutToText(actX.ShortCut) );
    ini.WriteString('shortcut','Copy',ShortCutToText(actC.ShortCut) );
    ini.WriteString('shortcut','Paste',ShortCutToText(actV.ShortCut) );
    ini.WriteString('shortcut','Redo',ShortCutToText(actY.ShortCut) );
    ini.WriteString('shortcut','Run',ShortCutToText(actRun.ShortCut)) ;
    ini.WriteString('shortcut','Stop',ShortCutToText(actStop.ShortCut)) ;
    ini.WriteString('shortcut','Prev',ShortCutToText(actPlayPrev.ShortCut)) ;
    ini.WriteString('shortcut','Replace',ShortCutToText(actReplace.ShortCut)) ;
    ini.WriteString('shortcut','RunFirst',ShortCutToText(actRunFirst.ShortCut)) ;

    //�ŋߎg�����t�@�C��
    s := Trim(ini.Recent.Text);
    s := JReplace(s,#13#10,'|',True);
    ini.WriteString('main','recent_files',s);

    //�o�[
    WriteBar(ToolBar1);
    WriteBar(ToolBar2);
    WriteBar(ToolBar3);
    WriteBar(ToolBar4);
    WriteBar(ToolBar5);
    //WriteBar(MenuBar);
    WriteBar(panelTrack);
    WriteBar(panelPlayer);

    //���t���j�^�[
    for i:=0 to High(ini.MonColor) do
    begin
      ini.WriteInteger('play_mon','color'+IntToStr(i), ini.MonColor[i]);
    end;

    ini.Save('main');
    ini.Save('player');
    ini.SaveForm(Self); 
end;

procedure TfrmSakuraPad.ReadIniFile;
var
  i: Integer;
begin
  //todo: INI�t�@�C���ǂݍ���

//----------------------------------------------------------------------------
// �G�f�B�^

  if ini.SectionExists('main_edit') then
  begin
    try
    EditorProp.ReadIni(AppPath+'sakura.ini','main_edit','a');//�G�f�B�^�̐ݒ�
    EditorProp.AssignTo(edtMain);
    except
      //ShowMessage('�G�f�B�^�ݒ肪���Ă��邩�A�o�[�W�����A�b�v�̂���');
    end;
  end;

  ini.FontSize := ini.ReadInteger('main','fontsize', edtMain.Font.Size);
  edtmain.Font.Size := ini.FontSize ;
  ini.OutMML := ini.ReadInteger('tools','OutMML', 0);



//----------------------------------------------------------------------------
//INI �I�[�g���[�V����

  //�V�X�e��
  ini.AddMenu(mnuAutoPlay, 'main','autoplay', True);
  ini.AddInt(@ini.SynthType, 'main','synthtype', 0);
  ini.AddMenu(mnuUseCloseEx, 'main','close_kakikake', False);
  ini.AddMenu(mnuAutoSave, 'main', 'autosave', True); 

  //�X�L��
  ini.AddBool(@ini.UseSkin, 'main','skin_use', True);
  ini.AddStr(@ini.SkinPath, 'main', 'skin', AppPath+'skin\skin.jpg');
  //���ʉ�
  ini.AddMenu(mnuEffect, 'main', 'effect_edit', True);
  ini.AddMenu(mnuEffectPlay, 'main', 'effect_play', True);
  ini.AddMenu(mnuEffectClipboard, 'main', 'effect_clipboard', True);
  //�����w���v
  ini.AddMenu(mnuAutoHelp, 'main','auto_help', False);

  //�G���[�^�u
  ini.AddMenu(mnuExternalBrowser,'main','ExternalBrowser', True);
  ini.AddMenu(mnuUseMouseGesture,'main','MouseGesture', False);
  //�v���C���[�̐ݒ�
  ini.AddInt(@ini.PlayerType,'player','type', Ord(mpSakura));
  ini.AddStr(@ini.TMidiPath,'player','tmidi','');
  ini.AddStr(@ini.TWPath,'player','tw_music2','');
  ini.AddMenu(mnuShowPlayMonitor,'player','ShowPlayMonitor', True);
  ini.AddMenu(mnuPlayMonitorTop,'player','PlayMonitorTop', True);

  SetPlayMonitorTop;

  //���t���x�̐؂�ւ�
  ini.AddInt(@ini.PlayerWaitTime,'player','WaitTime', 5);
  ini.AddInt(@ini.PlayerDrawWaitTime,'player','DrawWaitTime', 100);
  //
  ini.AddMenu(mnuOutMidClock, 'player','mnuOutMidClock', False);

  ini.AddMenu(mnuSpeedCompile,  'main','mnuSpeedCompile', False);
  ini.AddMenu(mnuTenkey,        'main','mnuTenkey', False);

  //�^�u
  ini.AddMenu(mnuShowBenriPanel, 'main','ShowBenriPanel', True);
  ini.AddMenu(mnuErrorTab, 'main','ErrorTab', False);

  //�I�[�g���[�V�����̍Ō��
  ini.Load('main');
  //MouseGes.Enabled := mnuUseMouseGesture.Checked ;
  ChangeSkin(ini.SkinPath);
  ini.Load('player');
  IniWindowMaxize := ini.LoadForm(Self);

//----------------------------------------------------------------------------
//�֗��p�l��

  if mnuShowBenriPanel.Checked=False then
  begin
    mnuShowBenriPanel.Checked := True;
    mnuShowBenriPanelClick(nil);
  end;
  if mnuErrorTab.Checked=False then
  begin
    mnuErrorTab.Checked := True;
    mnuErrorTabClick(nil);
  end;

  pageLeft.Width := ini.ReadInteger('main','BenriPanelWidth', pageLeft.Width);
  if pageLeft.Width <= 0 then pageLeft.Width := 1;

  pageBottom.Height := ini.ReadInteger('main','PanelBottom', pageBottom.Height);
  if pageBottom.Height <= 0 then pageBottom.Height := 1;


//----------------------------------------------------------------------------
//MIDI�|�[�g

  for i:=0 to MAX_PORT-1 do
  begin
    ini.MidiPort[i] := ini.ReadInteger('midi','port'+IntToStr(i),-2);//���ݒ肪-2
  end;

//----------------------------------------------------------------------------
//�V���[�g�J�b�g

  actZ.ShortCut := TextToShortCut(ini.ReadString('shortcut','Undo','Ctrl+Z') );
  actX.ShortCut := TextToShortCut(ini.ReadString('shortcut','Cut','Ctrl+X') );
  actC.ShortCut := TextToShortCut(ini.ReadString('shortcut','Copy','Ctrl+C') );
  actV.ShortCut := TextToShortCut(ini.ReadString('shortcut','Paste','Ctrl+V') );
  actY.ShortCut := TextToShortCut(ini.ReadString('shortcut','Redo','Ctrl+Y') );
  actRun.ShortCut := TextToShortCut(ini.ReadString('shortcut','Run','F9') );
  actStop.ShortCut := TextToShortCut(ini.ReadString('shortcut','Stop','F10') );
  actPlayPrev.ShortCut := TextToShortCut(ini.ReadString('shortcut','Prev','F11')) ;
  actReplace.ShortCut := TextToShortCut(ini.ReadString('shortcut','Replace','Ctrl+R')) ;

  //�ŋߎg�����t�@�C��
  ini.Recent := TStringList.Create ;
  ini.Recent.Text := ini.ReadString('main','recent_files','');
  ini.Recent.Text := Trim(JReplace(ini.Recent.Text, '|', #13#10,True));
  MakeRecentMenu;

  //�o�[
  ReadBar(ToolBar1);
  ReadBar(ToolBar2);
  ReadBar(ToolBar3);
  ReadBar(ToolBar4);
  ReadBar(ToolBar5);
  //ReadBar(MenuBar);
  ReadBar(panelTrack);
  ReadBar(panelPlayer);

  //�v���O�C���̗�
  mnuPluginEnumClick(nil);

  // ���t���j�^�[�̔z�F�̓ǂݍ���
  // TODO:�F�̐ݒ�
  // (0)..(7) �p�����[�^�[ (8) �����F
  // (9)..(10)  ���Ղ̐F
  // (11)..(12) ���Չ��t�F
  ini.MonColor[0]  := RGB(245,91,110);
  ini.MonColor[1]  := RGB(255,180,184);
  ini.MonColor[2]  := RGB(140,180,255);
  ini.MonColor[3]  := RGB(179,230,217);
  ini.MonColor[4]  := RGB(240,120,  0);
  ini.MonColor[5]  := RGB(255,184,130);
  ini.MonColor[6]  := RGB(120,255,100);
  ini.MonColor[7]  := RGB(170,255,152);
  ini.MonColor[8]  := clWhite;
  ini.MonColor[9]  := clWhite;
  ini.MonColor[10] := RGB(80,80,80);
  ini.MonColor[11] := RGB(100,100,255);
  ini.MonColor[12] := RGB(255,100,100);
  ini.MonColor[13] := RGB(255,255,255);
  ini.MonColor[14] := clGray;

  for i:=0 to High(ini.MonColor) do
  begin
    ini.MonColor[i] := ini.ReadInteger('play_mon','color'+IntToStr(i), ini.MonColor[i]);
  end;
end;

procedure TfrmSakuraPad.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
    i: Integer;
begin
    if (ini.PlayerType = mpTMIDI) then
    begin
      midiOut.CloseAll ;
    end else
    begin
      Self.mciClose ;
    end;
    
    if FileModify then
    begin
        i := MsgYesNoCancel('"'+ExtractFileName(SaveFileName)+'"�́A�ύX����Ă��܂��B'#13#10+
        '�ۑ����܂����H','�e�L�X�g���y�u�T�N���v�I���m�F');
        case i of
        IDYES: mnuSaveClick(nil);
        IDNO: ;
        IDCANCEL:begin Action:=caNone; Exit; end;
        end;
    end;

    SaveIniFile ;
    if FileExists(TempMidiFile) then
    begin
        DeleteFile(TempMidiFile); 
    end;
end;

procedure TfrmSakuraPad.mnuSaveAsClick(Sender: TObject);
begin
    if not dlgSave.Execute then Exit;
    ChangeFileName(dlgSave.FileName);
    mnuSaveClick(nil);
end;

procedure TfrmSakuraPad.WMMousewheel(var Msg: TMessage);
begin
  if (Msg.WParam > 0) then
  begin
    { �z�C�[�������ɓ����������̏��� }
    Sendmessage(ActiveEditor.Handle, WM_VSCROLL, SB_LINEUP, 0);
    //�y�[�W�X�N���[���̏ꍇ�͉����g�p
    // Sendmessage(Editor1.Handle, WM_VSCROLL, SB_PAGEUP, 0);
  end
  else
  begin
    { �z�C�[������O�ɓ����������̏��� }
    Sendmessage(ActiveEditor.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
    //�y�[�W�X�N���[���̏ꍇ�͉����g�p
    // Sendmessage(Editor1.Handle, WM_VSCROLL, SB_PAGEDOWN, 0);
  end;
end;

procedure TfrmSakuraPad.mnuFindClick(Sender: TObject);
begin
    frmFind.Show ;
end;

procedure TfrmSakuraPad.mnuFindNextClick(Sender: TObject);
begin
    frmFind.btnFindClick(nil); 
end;

procedure TfrmSakuraPad.mnuErrorTabClick(Sender: TObject);
begin
    mnuErrorTab.Checked := not mnuErrorTab.Checked;

    pageBottom.Visible := mnuErrorTab.Checked ;
    splitBottom.Visible := mnuErrorTab.Checked ;
    splitBottom.Top := pageBottom.Top ;

    PlayWave(WAV_PI); 
end;

procedure TfrmSakuraPad.mnuSaveAsMIDIClick(Sender: TObject);
var
    fname: string;
begin
    if FileExists(TempMidiFile) = False then
    begin
        Compile ;
        if FileExists(TempMidiFile) = False then
        begin
          ShowMessage('�R���p�C���Ɏ��s���Ă��܂��B');
          Exit;
        end;
    end;

    fname := ChangeFileExt(ExtractFileName(SaveFileName), '.mid');
    if fname = '.mid' then fname := '����.mid';

    dlgSaveMidi.FileName := fname;
    if not dlgSaveMidi.Execute then Exit;

    SHFileCopy(TempMidiFile, dlgSaveMidi.FileName);
end;

procedure TfrmSakuraPad.edtErrorClick(Sender: TObject);
begin
    ShowBar('�_�u���N���b�N�Ŏw��s�Ɉړ����܂��B'); 
end;

procedure TfrmSakuraPad.edtErrorDblClick(Sender: TObject);
var
    row: Integer;
    s,ss: string;
begin
    row := edtError.Row ;
    if row<0 then Exit;
    s := edtError.Lines.Strings[row];
    if s='' then Exit;
    ss := GetToken('(',s);
    ss := GetToken(')',s);
    row := StrToIntDef(ss,-1);
    if row>=0 then GotoLine(row);
end;

procedure TfrmSakuraPad.edtMainDblClick;
var
    i, x,y: Integer;
    pp: TPoint;
begin
    GetCaretWord;

    //�������H
    i := StrToIntDef(ActiveEditor.SelText,MaxInt);
    if i>127 then //�Ⴄ,word
    begin
        popJumpDefVarClick(nil);
    end else
    begin
        ActiveEditor.Enabled := False;

        TEditorMi(ActiveEditor).GetCaretXY(x,y);
        with frmInputNum do
        begin
            pp.X := x; pp.Y := y;
            pp := ActiveEditor.ClientToScreen(pp);
            Left := pp.X - (frmInputNum.Width div 2);
            Top  := pp.Y;
            bar.Position := i;
            Show ;
        end;
        ActiveEditor.Enabled := True;
    end;

end;


procedure TfrmSakuraPad.OnBookmarkClick(Sender: TObject);
var
	tag: Integer;
begin
	tag := TMenuItem(Sender).Tag ;
    case tag of
    0: edtMain.GotoRowMark(rm0);
    1: edtMain.GotoRowMark(rm1);
    2: edtMain.GotoRowMark(rm2);
    3: edtMain.GotoRowMark(rm3);
    4: edtMain.GotoRowMark(rm4);
    5: edtMain.GotoRowMark(rm5);
    6: edtMain.GotoRowMark(rm6);
    7: edtMain.GotoRowMark(rm7);
    8: edtMain.GotoRowMark(rm8);
    9: edtMain.GotoRowMark(rm9);
    end;
end;

procedure TfrmSakuraPad.OnRecBookmarkClick(Sender: TObject);
var
	tag: Integer;
begin
	tag := TMenuItem(Sender).Tag ;
    case tag of
    0: edtMain.PutRowMark(edtMain.Row, rm0);
    1: edtMain.PutRowMark(edtMain.Row, rm1);
    2: edtMain.PutRowMark(edtMain.Row, rm2);
    3: edtMain.PutRowMark(edtMain.Row, rm3);
    4: edtMain.PutRowMark(edtMain.Row, rm4);
    5: edtMain.PutRowMark(edtMain.Row, rm5);
    6: edtMain.PutRowMark(edtMain.Row, rm6);
    7: edtMain.PutRowMark(edtMain.Row, rm7);
    8: edtMain.PutRowMark(edtMain.Row, rm8);
    9: edtMain.PutRowMark(edtMain.Row, rm9);
    end;
end;


procedure TfrmSakuraPad.ExecuteDDE(cmd: string);
begin

  case ini.PlayerType of
  mpTMidi:
    begin
      DdeClientConv1.ServiceApplication := ini.TMidiPath ;
      DdeClientConv1.SetLink('TMIDI', 'TMIDI');
      if not DdeClientConv1.OpenLink then
      begin
        ShowBar('TMIDI�ƘA���o���܂���(ToT)..��Ԃ��m�F���Ă��������B');
        Exit;
      end;
      DdeClientConv1.ExecuteMacro(PChar(Cmd), False);
      DdeClientConv1.CloseLink;
    end;
  mpTW:
    begin
      DdeClientConv1.ServiceApplication := ini.TWPath ;
      DdeClientConv1.SetLink('TWM2', 'TWM2');
      if not DdeClientConv1.OpenLink then
      begin
        ShowBar('TW-Music2�ƘA���o���܂���(ToT)..��Ԃ��m�F���Ă��������B');
        Exit;
      end;
      DdeClientConv1.ExecuteMacro(PChar(Cmd), False);
      DdeClientConv1.CloseLink;
    end;
  end;

end;

procedure TfrmSakuraPad.mnuPlayMidiClick(Sender: TObject);

    procedure subMCI;
    begin
      //MCI �ŉ��t
        if MPlay.Mode = mpOpen then MPlay.Close ;
        MPlay.FileName := TempMidiFile;
        MPlay.Open ;
        track.Max := MPlay.Length ;
        MidiLen := MPlay.Length ;
        MPlay.Position := track.Position ;
        MPlay.Play ;
        MidiPlaying := True;
        timerPlayer.Enabled := True;
    end;

    procedure subTMidi;
    begin
        //
        MidiPlaying := True;
        timerPlayer.Enabled := False;
        ExecuteDDE('playfile '+TempMidiFile+'');
    end;

    procedure subTW;
    begin
        MidiPlaying := True;
        timerPlayer.Enabled := False;
        ExecuteDDE('playfile '+TempMidiFile+'');
    end;

    procedure subSakura;
    var
      i,cnt: Integer;
    begin
        SmfPlayer.UseMidiClock := mnuOutMidClock.Checked;
        SmfPlayer.LoadFromFile(TempMidiFile);
        try
          cnt := 0;
          for i:=0 to MAX_PORT-1 do
          begin
            if ini.MidiPort[i] <> -2 then
            begin
              SmfPlayer.MidiOut.OpenPort(ini.MidiPort[i], i);
              Inc(cnt);
            end;
          end;
          if cnt=0 then SmfPlayer.Open;
        except
            on e:Exception do begin
              ShowWarn('MIDI�|�[�g���J���܂���ł����B'#13#10+midiOut.ErrMsg,'�T�N�������v���C���[');
              Exit;
            end;
        end;

        // ���t���j�^�[
        if mnuShowPlayMonitor.Checked then frmPlayMonitor.Show ;

        SmfPlayer.MidiOut.Panic ;
        SmfPlayer.WaitTime := ini.PlayerWaitTime ;

        SmfPlayer.UseRepeatPlay := mnuPlayerRepeat.Checked ;
        SmfPlayer.Position := track.Position;
        track.Max := SmfPlayer.Length ;
        //
        frmPlayMonitor.SetSetting;
        //
        SmfPlayer.Play ;
        timerPlayer.Enabled := True;
        MidiPlaying := True;
    end;
begin
    Application.ProcessMessages ;
    midiOut.CloseAll;

    if MidiPlaying = True then mciClose ;
    if FileExists(TempMidiFile) = False then
    begin
      Exit;
    end;

    case ini.PlayerType of
      mpMCI:    subMCI;
      mpTMidi:  subTMidi;
      mpSakura: subSakura;
      mpTW:     subTW;
    end;
end;

procedure TfrmSakuraPad.mnuEditSettingClick(Sender: TObject);
begin
	EditEditor(edtMain, nil);
    EditorProp.Assign(edtMain);
    EditorProp.WriteIni(AppPath+'sakura.ini','main_edit','a');
    ini.FontSize := edtMain.Font.Size ;
end;

procedure TfrmSakuraPad.mnuCompilerLogClick(Sender: TObject);
begin
    mnuCompilerLog.Checked := not mnuCompilerLog.Checked ;
    mnuCompilerTime.Checked := False;
    mmlOption(MML_OPTION_LOG);
end;

procedure TfrmSakuraPad.mnuCompilerTimeClick(Sender: TObject);
begin
    mnuCompilerTime.Checked := not mnuCompilerTime.Checked ;
    mnuCompilerLog.Checked := False;
    mmlOption(MML_OPTION_SHOW_TIME);
end;

procedure TfrmSakuraPad.mnuHomePageClick(Sender: TObject);
begin
    OpenApp('http://oto.chu.jp/');
end;

procedure TfrmSakuraPad.MakeCommandTree;
var
    i: Integer;
    s: string;
begin
    lstCmdGroup.Clear ;
    for i:=0 to cmd.Count -1 do
    begin
        s := cmd.Cells[0,i];
        if Copy(s,1,2)= '//' then
        begin
            Delete(s,1,2);
            lstCmdGroup.Items.Add(IntToStr(i)+','+s);
        end;
    end;
end;

procedure TfrmSakuraPad.lstCmdGroupClick(Sender: TObject);
var
    idx,i: Integer;
    s,key,path: string;
begin
    idx := lstCmdGroup.ItemIndex ;
    if idx<0 then Exit;
    s := lstCmdGroup.Items.Strings[idx];
    idx := StrToIntDef(GetToken(',', s),-1);
    if idx<0 then Exit;
    //
    PlayWave(WAV_PI);
    lstCommand.Clear ;
    for i:=idx+1 to cmd.Count -1 do
    begin
        s := cmd.Cells[0,i];
        if Copy(s,1,2)='//' then Break;
        key := GetToken(',',s); //�R�}���h����؂���
        lstCommand.Items.Add(key+','+IntToStr(i));
    end;
    lstCommand.Sorted := True;
    //
    path := '';
    s := lstCmdGroup.Items[lstCmdGroup.ItemIndex];
    GetToken(',',s);
    if s='�X�g�g���\�L' then
    begin
        path := AppPath + 'doc\reference\sutoton.htm';
    end else
    if s='��s�w��' then
    begin
        path := AppPath + 'doc\reference\cc-option.htm';
    end else
    if s='System�I�v�V����' then
    begin
        path := AppPath + 'doc\reference\system.htm';
    end;

    if FileExists(path) then
    begin
        if mnuAutoHelp.Checked then
        begin
            ShowHtml(path);
        end;
    end;
end;

procedure TfrmSakuraPad.lstCommandClick(Sender: TObject);
var
    i,no: Integer;
    key,s: string;
begin
    i := lstCommand.ItemIndex ;
    if i<0 then Exit;
    s := lstCommand.Items[i];
    key := GetToken(',', s);//key
    no := StrToIntDef(s,-1);
    if no<0 then Exit;
    s := Trim(cmd.Cells[3,no]);
    if s<>'' then
    begin
        fileHelp := AppPath + 'doc\command\'+s+'.htm';
        s := '(*doc:'+s+')['+ key + ']';
    end;
    ShowBar(s + '�y�����z'+cmd.Cells[1,no]+'�@�y�����z'+cmd.Cells[2,no]);
    //
    if mnuAutoHelp.Checked then
    begin
        barClick(nil);
    end else
    begin
        PlayWave(WAV_PI);
    end;
end;

procedure TfrmSakuraPad.lstCommandDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
    s: string;
    canvas: TCanvas;
begin
    s := lstCommand.Items[Index];
    s := GetToken(',',s); //KEY�����������
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
    end else
    begin
        //��I��
        if (Index mod 2)=0 then
        begin
            canvas.Brush.Color := clWhite;
        end else
        begin
            canvas.Brush.Color := RGB(230,230,255);
        end;
        canvas.Pen.Color := clBlack;
    end;
    canvas.FillRect(Rect);
    canvas.TextOut(Rect.Left +8, Rect.Top+2, s);
end;

procedure TfrmSakuraPad.lstCmdGroupDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
    s: string;
    canvas: TCanvas;
begin
    s := lstCmdGroup.Items[Index];
    GetToken(',',s); //KEY�����������
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
    end else
    begin
        //��I��
        if (Index mod 2)=0 then
        begin
            canvas.Brush.Color := clWhite;
        end else
        begin
            canvas.Brush.Color := RGB(255,230,230);
        end;
        canvas.Pen.Color := clBlack;
    end;
    canvas.FillRect(Rect);
    canvas.TextOut(Rect.Left +8, Rect.Top+2, s);
end;

procedure TfrmSakuraPad.lstCommandDblClick(Sender: TObject);
var
    i: Integer;
    s: string;
begin
    i := lstCommand.ItemIndex ;
    if i<0 then Exit;
    s := lstCommand.Items[i];
    s := GetToken(',', s);//key
    ActiveEditor.SelText := s;
    PlayWave(WAV_TO);
end;

procedure TfrmSakuraPad.edtMainDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
    row,col: Integer;
begin
    ActiveEditor.SetFocus ;
    ActiveEditor.PosToRowCol(X,Y,row,col, False);
    ActiveEditor.SetRowCol(row,col);

    if Source.ClassType = TListBox then
    begin
        Accept := True;
    end else
        Accept := False;
end;

procedure TfrmSakuraPad.edtMainDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    row,col: Integer;
begin
    ActiveEditor.SetFocus ;
    ActiveEditor.PosToRowCol(X,Y,row,col, False);
    ActiveEditor.SetRowCol(row,col);

    if Source.ClassType = TListBox then
    begin
        case TListBox(Source).Tag of
        0: lstCommandDblClick(nil);
        1: lstUserDblClick(nil);
        2: lstVoiceDblClick(nil);
        3: lstTemplateDblClick(nil);
        4: mnuInsIncludeClick(nil); 
        end;
    end;
end;

procedure TfrmSakuraPad.MakeIncludeFileTree;
var
    g: TGlob;
    fname: string;
    i: Integer;
begin
    lstFiles.Items.Clear ;
    g := TGlob.Create(AppPath+'Include\*.h');
    try
        for i:=0 to g.FileList.Count -1 do
        begin
            fname := g.FileList.Strings[i];
            {ReadTextFile(g.GetPath + fname, txt);
            GetToken('=description',txt);
            s := GetToken(#13#10, txt);}
            lstFiles.Items.Add(fname);
        end;
    finally
        g.Free ;
    end;
end;

procedure TfrmSakuraPad.lstFilesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
    s: string;
    canvas: TCanvas;
begin
    s := lstFiles.Items[Index];
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
    end else
    begin
        //��I��
        if (Index mod 2)=0 then
            canvas.Brush.Color := clWhite
        else
            canvas.Brush.Color := RGB(230,230,255);
        canvas.Pen.Color := clBlack;
    end;
    canvas.FillRect(Rect);
    canvas.TextOut(Rect.Left +8, Rect.Top+2, s);
end;

procedure TfrmSakuraPad.FileDrop1FileDrop(Sender: TObject; Num: Integer;
  Files: TStrings; X, Y: Integer);
var
    s: string;
    i: Integer;
begin
    mnuStopClick(nil); 
    if Num < 0 then Exit;
    Self.BringToFront ;
    Application.BringToFront ;
    s := Files.Strings[0];

    if Trim(ActiveEditor.Lines.Text) = '' then
    begin
      LoadToEdit(s); //�J��
      Exit;
    end;
    i := MsgYesNoCancel(s+#13#10'���A�ҏW���̃t�@�C���ɑ}�����܂����H'#13#10+
        '�V���ɊJ���ꍇ�́A�w�������x���N���b�N���Ă��������B');
    case i of
    IDYES:
        begin
            ReadTextFile(Files.Strings[0],s);
            edtMain.SelText := s;
        end;
    IDNO:
        begin
            RunApp(ParamStr(0)+' "'+Files.Strings[0]+'"') ;
        end;
    IDCANCEL:Exit;
    end;
end;

procedure TfrmSakuraPad.mnuOpenIncludeFileClick(Sender: TObject);
var
    i: Integer;
    s: string;
begin
    i := lstFiles.ItemIndex ;
    if i<0 then Exit;
    s := AppPath + 'Include\' + lstFiles.Items.Strings[i];
    RunApp(ParamStr(0)+' "'+s+'"');
end;

procedure TfrmSakuraPad.lstFilesClick(Sender: TObject);
var
    i: Integer;
    s, fname, su, doc: string;
    sl: TStringList;
begin
    i := lstFiles.ItemIndex ;
    if i<0 then Exit;
    //
    fname := AppPath + 'Include\' + lstFiles.Items.Strings[i];
    //
    doc   := AppPath + 'doc\include\' + lstFiles.Items.Strings[i];
    doc   := ChangeFileExt(doc, '.htm');
    lstUser.Items.Clear ;

    sl := TStringList.Create ;
    try
        sl.LoadFromFile(fname);
        for i:=0 to sl.Count -1 do
        begin
            s := sl.Strings[i];
            //s := Trim(sl.Strings[i]);//���[�J����񋓂��Ȃ�
            su := UpperCaseEx(s);
            if (Copy(s,1,2)='~{')or(Copy(s,1,1)='#')or(Copy(su,1,8)='FUNCTION')or(Copy(su,1,3)='INT')or(Copy(su,1,3)='STR')or(Copy(su,1,5)='ARRAY') then
            begin
                s := Trim(s);
                if Pos('//private',s)=0 then lstUser.Items.Add(s);
            end;
        end;
    finally
        sl.Free ;
    end;
    if FileExists(doc) then
    begin
        //ShowHtml(doc);
        ShowBar('(*html:'+doc+') �������N���b�N����ƃw���v��\���B');
    end;
end;

procedure TfrmSakuraPad.mnuArukasClick(Sender: TObject);
var
  temp: string;
begin
    mnuStopClick(nil);
    Compile ;
    temp := AppPath+ 'arukas.txt';
    RunAppAndWait(AppPath+ARUKAS+' "'+TempMidiFile+'" "'+temp+'"');
    RunApp('notepad.exe "'+temp+'"');
end;

procedure TfrmSakuraPad.lstUserDblClick(Sender: TObject);
var
    i: Integer;
    fp, key, s: string;
begin
    i := lstUser.ItemIndex ;
    if i<0 then Exit;
    s := Trim(lstUser.Items[i]);
    if Copy(s,1,1)='#' then
    begin
        key := Trim(GetToken('=',s));
        ActiveEditor.SelText := key;
    end else
    begin
        fp := Trim(UpperCase(GetToken(' ',s)));
        if fp='FUNCTION' then key := Trim(GetToken('(',s))+ '()'#13#10 else
        key := Trim(GetToken('=',s));
        ActiveEditor.SelText := key ;
    end;
end;

procedure TfrmSakuraPad.FormDestroy(Sender: TObject);
begin
    midiOut.Free ;
    voiceList.Free ;

    //======================
    // Backup File ���폜
    if FileExists(BackupFile) then
    begin
      DeleteFile(BackupFile); 
    end;
end;

procedure TfrmSakuraPad.mnuResetGMClick(Sender: TObject);
begin
    if mnuEffectPlay.Checked then PlayWave(WAV_N);
    midiOut.Open(-1);
    midiOut.OutGMReset ;
end;

procedure TfrmSakuraPad.mnuResetGSClick(Sender: TObject);
begin
    if mnuEffectPlay.Checked then PlayWave(WAV_N);
    midiOut.Open(-1);
    midiOut.OutGSReset(0) ;
end;

procedure TfrmSakuraPad.mnuResetXGClick(Sender: TObject);
begin
    if mnuEffectPlay.Checked then PlayWave(WAV_N);
    midiOut.Open(-1);
    midiOut.OutXGReset(0) ;
end;

procedure TfrmSakuraPad.mnuReplaceClick(Sender: TObject);
begin
    if edtMain.SelLength > 0 then
        frmReplace.chkSelectArea.Checked := True;
    frmReplace.Show ;
end;

procedure TfrmSakuraPad.MakeVoiceTree;
var
    i: Integer;
    s: string;
begin
    lstVoiceGroup.Clear ;
    for i:=0 to voiceList.Count -1 do
    begin
        s := voiceList.Strings[i];
        if Copy(s,1,1)='#' then
        begin
            Delete(s,1,1);
            s := IntToStr(i) + ':' + s;
            lstVoiceGroup.Items.Add(s);
        end;
    end;
    //lstVoiceGroup.Text := '�y��n����I��';
end;

procedure TfrmSakuraPad.lstVoiceDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
    s: string;
    canvas: TCanvas;
begin
    s := lstVoice.Items[Index];
    GetToken(',',s); //KEY�����������
    s := GetToken('�c',s); //KEY�����������
    if Copy(s,Length(s),1)='$' then
    begin
        Delete(s,Length(s),1);
    end;
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
    end else
    begin
        //��I��
        if (Index mod 2)=0 then
        begin
            canvas.Brush.Color := clWhite;
        end
        else begin
            canvas.Brush.Color := RGB(255,230,255);
        end;
        canvas.Pen.Color := clBlack;
    end;
    canvas.FillRect(Rect);
    canvas.TextOut(Rect.Left +20, Rect.Top+2, s);
    if s='' then
        Exit
    else if s[1] in ['0'..'9'] then
        canvas.Draw(Rect.Left+2, Rect.Top+1, imgGakki.Picture.Graphic);
end;

procedure TfrmSakuraPad.lstVoiceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    i, o:Integer;
begin
    Application.ProcessMessages ;
    ShowVoiceDescript;
    if VoiceNo < 0 then Exit;
    midiOut.Open(-1);
    midiOut.OutCtrlChg(0, 121, 0);
    if Button=mbRight then
    begin
        midiOut.OutProgramChange(0, VoiceNo-1);
        o := Random(5);
        for i:=0 to 3 do begin
            NoteOnNo := 36 + NOTE_NO_TABLE[ Random(7) ] + (12 * o);
            midiOut.OutNoteOn(Channel, NoteOnNo, 120);
            sleep(200);
            midiOut.OutNoteOff(Channel, NoteOnNo, 120);
        end;
        NoteOnNo := -1;
    end else
    begin
        if Channel = 9 then
        begin
            midiOut.OutProgramChange(0, 0);
            NoteOnNo := VoiceNo;
            //midiOut.OutNoteOn(Channel, NoteOnNo, 120);
        end else
        begin
            midiOut.OutProgramChange(0, VoiceNo-1);
            NoteOnNo := 64;
        end;
        midiOut.OutNoteOn(Channel, NoteOnNo, 120);
        sleep(200);
        {
        midiOut.OutNoteOff(Channel, NoteOnNo, 120);
        NoteOnNo := -1;}
    end;
end;

procedure TfrmSakuraPad.lstVoiceDblClick(Sender: TObject);
var
    i: Integer;
    key,s: string;
begin
    i := lstVoice.ItemIndex;
    if i<0 then Exit;
    s := lstVoice.Items.Strings[i];
    if s='' then Exit;
    key := GetToken(',', s);
    if Copy(s,Length(s),1)='$' then
    begin
        ActiveEditor.SelText := '$'+Copy(s,2,1)+'{n'+key+',}';
    end else
    begin
        ActiveEditor.SelText := key;
    end;
end;

procedure TfrmSakuraPad.lstUserDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
// tp name arg com
    tp, name, arg, com, s: string;
    p: PChar;
    canvas: TCanvas;
    w1,w2,w3: Integer;
    c: TColor;
begin
    s := lstUser.Items[Index];
    s := JReplace(s, #9, ' ', True);

    if (Copy(s,1,1)='#')or(Copy(s,1,1)='~') then
    begin
      tp   := Copy(s,1,1);
      s    := Copy(s,2, Length(s));
    end else
    begin
      tp   := UpperCase(GetToken(' ',s)); //�^�������������
    end;
    p := PChar(s);
    name := '';
    while p^ <>#0 do
    begin
      if not (p^ in ['(','{',' ','=']) then
      begin
        name := name + p^; Inc(p);
      end else break;
    end;
    name := Trim(name);
    com := string(p);
    if Pos('/*',com)>0 then
    begin
      arg := Trim(GetToken('/*',com));
      com := Trim(com);
      if com<>'' then com := '/*'+com;
    end else
    begin
      arg := Trim(GetToken('//',com));
      com := Trim(com);
      if com<>'' then com := '//'+com;
    end;
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
        canvas.FillRect(Rect);
        w1 := canvas.TextWidth('FUNCTION')+4;
        canvas.TextOut(Rect.Left +8, Rect.Top+2, tp);
        canvas.TextOut(Rect.Left +8+w1, Rect.Top+2, name+' '+arg+com);
        Exit;
    end else
    begin
        //��I��
        if tp='FUNCTION'   then c := RGB($CC,$CC,$FF) else
        if tp='STR'        then c := RGB($FF,$CC,$CC) else
        if Copy(tp,1,1)='#'then c := RGB($FF,$CC,$CC) else
        if tp='INT'        then c := RGB($FF,$FF,$99) else
        c := clWhite;
        canvas.Brush.Color := c;
      canvas.Font.Color := clBlack;
    end;
    //background
    canvas.FillRect(Rect);

    w1 := canvas.TextWidth('FUNCTION')+4;
    w2 := w1 + canvas.TextWidth(name)+4;
    w3 := w2 + canvas.TextWidth(arg)+4;

    //type
    canvas.Font.Color := clBlue;
    canvas.TextOut(Rect.Left +8, Rect.Top+2, tp);

    //name
    canvas.Font.Color := clBlack;
    canvas.TextOut(Rect.Left +8+w1, Rect.Top+2, name);

    //arg
    canvas.Font.Color := clGray;
    canvas.TextOut(Rect.Left +8+w2, Rect.Top+2, arg);

    //comment s
    canvas.Font.Color := clGreen;
    canvas.TextOut(Rect.Left +8+w3, Rect.Top+2, com);
end;

procedure TfrmSakuraPad.mnuShowKeyboardClick(Sender: TObject);
begin
    frmKeyboard.Show;
    PlayWave(WAV_PI);
end;

procedure TfrmSakuraPad.mnuShowGosenfuClick(Sender: TObject);
begin
    frmOnpu1.Show;
    PlayWave(WAV_PI);
end;

procedure TfrmSakuraPad.timerPlayerTimer(Sender: TObject);
var
  m: string;
  
  procedure showBottom;
  begin
    if pageBottom.Visible then
    begin
        if pageBottom.ActivePageIndex = 0 then
        begin
            edtError.SetFocus ;
            edtError.Row := edtError.Lines.Count-1;
        end;
        edtMain.SetFocus ;
    end else
    begin
      ShowBar(m);
    end;
  end;

begin
    if MidiPlaying = False then
    begin
        timerPlayer.Enabled := False;
        mnuStopClick(nil);
        Exit;
    end;

    if ini.PlayerType = mpMCI then
    begin
        if MPlay.Mode <> mpPlaying then
        begin
            if mnuPlayerRepeat.Checked then
            begin
                if (MPlay.Mode = mpStopped)or(MPlay.Mode = mpStopped) then
                begin//REPLAY
                    MPlay.Play ;
                end;
            end else begin
                timerPlayer.Enabled := False;
                mnuStopClick(nil);
                //track.Position := 0;
                Exit;
            end;
        end;
        try
            track.Position := MPlay.Position;
        except
            timerPlayer.Enabled := False;
            mnuStopClick(nil);
        end;
        ShowInfo (IntToStr(track.Position)+'/'+IntToStr(MidiLen));
    end else

    if ini.PlayerType = mpSakura then
    begin
        if SmfPlayer.IsPlaying = False then
        begin
            timerPlayer.Enabled := False;
            mnuStopClick(nil);
            track.Position := 0;
            Exit;
        end;

        track.Position := SmfPlayer.Position ;
        ShowInfo(Format('%6d/%6d',[track.Position, Track.Max]));

        //���^�C�x���g�̕\��
        if SmfPlayer.MetaText <> '' then
        begin
            m := SmfPlayer.MetaText ;
            SmfPlayer.MetaText := '';
            edtError.Lines.Text := edtError.Lines.Text + Trim(m) + #13#10;
            showBottom;
        end;
        //���O�̕\��
        if SmfPlayer.UseLog and (Log<>'')then
        begin
          edtError.Lines.Add(Log);
          Log := '';
          showBottom;
        end;
    end;
end;

procedure TfrmSakuraPad.toolSioriClick(Sender: TObject);
begin
    pageLeft.ActivePageIndex := 0;
end;

procedure TfrmSakuraPad.toolVoiceClick(Sender: TObject);
begin
    pageLeft.ActivePageIndex := 3;
end;

procedure TfrmSakuraPad.trackEnter(Sender: TObject);
begin
    mnuStopClick(nil);
    MouseTrack := True;
end;

procedure TfrmSakuraPad.lstVoiceGroupClick(Sender: TObject);
var
    idx,i: Integer;
    s: string;
begin
    i := lstVoiceGroup.ItemIndex ;
    if i<0 then Exit;
    s := lstVoiceGroup.Items.Strings[i];
    s := GetToken(':', s);
    idx := StrToIntDef(s, -1);
    if idx<0 then Exit;
    lstVoice.Clear ;
    i:=idx+1;
    while  i < voiceList.Count do
    begin
        s := voiceList.Strings[i];
        if Copy(s,1,1)='#' then Break;
        s := s + ',' + voiceList.Strings[i+1];
        lstVoice.Items.Add(s);
        Inc(i,2);
    end;
    PlayWave(WAV_N); 
end;

procedure TfrmSakuraPad.lstVoiceGroupDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
    s: string;
    canvas: TCanvas;
begin
    s := lstVoiceGroup.Items[Index];
    GetToken(':',s); //KEY�����������
    s := GetToken('�c',s); //KEY�����������
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
    end else
    begin
        //��I��
        if (Index mod 2)=0 then
        begin
            canvas.Brush.Color := clWhite;
        end
        else begin
            canvas.Brush.Color := RGB(255,230,255);
        end;
        canvas.Pen.Color := clBlack;
    end;
    canvas.FillRect(Rect);
    canvas.TextOut(Rect.Left +20, Rect.Top+2, s);
    canvas.CopyMode := cmMergeCopy		 ;
    canvas.Draw(Rect.Left+2, Rect.Top+1, imgDown.Picture.Graphic);
end;

procedure TfrmSakuraPad.lstVoiceExit(Sender: TObject);
begin
    if NoteOnNo>0 then
    begin
        midiOut.OutNoteOff(Channel, NoteOnNo,100);
        NoteOnNo := -1;
    end;
end;

procedure TfrmSakuraPad.mciClose;

    procedure subMCI;
    begin
      if MPlay.Mode = mpPlaying then MPlay.Stop ;
      if (MPlay.Mode = mpOpen)or(MPlay.Mode = mpStopped) then MPlay.Close ;
    end;

    procedure subTMidi;
    begin
      ExecuteDDE('stop');
    end;

    procedure subSakura;
    begin
      SmfPlayer.Stop ;
      midiOut.Panic ;
      midiOut.CloseAll ;
    end;

    procedure subTW;
    begin
      ExecuteDDE('stop');
    end;

begin
    try
        if MidiPlaying then
        begin
            case ini.PlayerType of
              mpMCI:    subMCI;
              mpTMidi:  subTMidi;
              mpSakura: subSakura;
              mpTW:     subTW;
            end;
        end;
        MidiPlaying := False;
    except
    end;
end;

procedure TfrmSakuraPad.mnuAutoPlayClick(Sender: TObject);
begin
    mnuAutoPlay.Checked := not mnuAutoPlay.Checked ;
end;

procedure TfrmSakuraPad.timerAutoPlayTimer(Sender: TObject);
begin
    IsInit := True;
    timerAutoPlay.Enabled := False;
    if mnuAutoPlay.Checked then
    begin
        if edtMain.Lines.Text <> '' then
        begin
            mnuRunClick(nil);
        end;
    end;
    IsInit := False;
end;

procedure TfrmSakuraPad.mnuRegistMMLClick(Sender: TObject);
begin
  //MML�̊֘A�t��
  with TRegistry.Create do
  begin
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if KeyExists('\.mml') then
      begin
        if MsgYesNo('���ɑ��̃\�t�g�Ɋ֘A�t��������Ă��܂����A'#13#10+
            '�֘A�t������蒼���܂����H','�g���q".mml"�̊֘A�t��') then
        begin
            mnuUninstallClick(nil);
        end else
        begin
            Exit;
        end;
      end;
      OpenKey('\.mml',True);                        // �g���q.xxx ��o�^
      WriteString('','mmlFile');                    // �g���q.xxx �� xxxFile ���Q��
      OpenKey('\.mml\ShellNew',True);               // �g���q.xxx ��o�^
      WriteString('NullFile','');                   // �V�K�쐬�ɂЂ܂��v���O������ǉ�
      OpenKey('\mmlFile',True);                     // xxxFile ��o�^
      WriteString('','�u�T�N���v�p���y�e�L�X�g');         // Explorer �̐����p
      OpenKey('\mmlFile\DefaultIcon',True);         // Icon �Q�ƃL�[
      WriteString('','"'+AppPath+'tools\mml.ico"'); // Icon �̎w��
      OpenKey('\mmlFile\shell\open\command',True);  // Application �Q�ƃL�[
      WriteString('',                               // Application �̎w��
            '"'+AppPath+'sakura.exe'+'" "%1" %*');
      {�����A�T�u�R�}���h������΁E�E�E
      OpenKey('\hmwFile\shell\�ҏW\command',True);  // Application �Q�ƃL�[
      WriteString('',                               // Application �̎w��
            '"'+AppPath+'himapad.exe'+'" "%1"');
      }
      SHChangeNotify(SHCNE_ASSOCCHANGED,            //�V�X�e���ɕύX��ʒm
                     SHCNF_FLUSH,nil,nil);
      ShowMessage('".mml"�t�@�C���ɁA�T�N�����֘A�t���܂����B'#13#10+
          '���ꂩ��A".mml"�t�@�C�����_�u���N���b�N���������ŁA���t����܂��B');
    finally
      Free;
    end;
  end;
end;

procedure TfrmSakuraPad.mnuUninstallClick(Sender: TObject);
var
    cnt: Integer;
begin
  cnt := 0;
  with TRegistry.Create do
  begin
    try
      RootKey:=HKEY_CLASSES_ROOT;
      if KeyExists('\.mml') then
      begin
          Inc(cnt);
          DeleteKey('\.mml');                        // �g���q.xxx ��o�^
      end;
      if KeyExists('\mmlFile') then
      begin
          Inc(cnt);
          DeleteKey('\mmlFile');                     // xxxFile ��o�^
      end;
      if cnt>0 then
      begin
        SHChangeNotify(SHCNE_ASSOCCHANGED,            //�V�X�e���ɕύX��ʒm
                     SHCNF_FLUSH,nil,nil);
        ShowMessage('".mml" �t�@�C���̊֘A�t�����������܂����B');
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmSakuraPad.mnuSaveToMldClick(Sender: TObject);
var
    s: string;
    txt: string;
begin
    if not dlgSaveMld.Execute then Exit;

    mmlOption(MML_OPTION_MLD_FILE);
    txt := 'SoundType=3;';
    txt := txt + edtMain.Lines.Text ;
    mmlCompile(txt, dlgSaveMld.FileName);
    mmlOption(0);
    ReadTextFile(dlgSaveMld.FileName, s);

    s := jconvert.EncodeBase64(s);
    Clipboard.AsText := '--B:M'#13#10+s;
    ShowMessage('i���[�h�������`��(MFi2)�ŕۑ����܂����B'#13#10+
    '�N���b�v�{�[�h�ɂ́ABASE64�`�����R�s�[���܂����B');
end;

procedure TfrmSakuraPad.pageLeftChange(Sender: TObject);
begin
    if pageLeft.ActivePageIndex = 0 then
    begin
        btnEnumCommentClick(nil); 
    end;
    PlayWave(WAV_PU);
end;

procedure TfrmSakuraPad.popShowManualClick(Sender: TObject);
begin
  ManualOnline := False;
  barClick(nil);
end;

procedure TfrmSakuraPad.barClick(Sender: TObject);
var
    s: string;
    key: string;

    procedure showtab;
    begin
        if pageBottom.Visible = False then
        begin
            mnuErrorTabClick(nil);
        end;
    end;

    procedure show_doc(path: string);
    begin
        if Copy(path, 1, 4) = 'http' then
        begin
            ShowHtml(path);
        end else
        if FileExists(path) then
        begin
            ShowHtml(path);
        end;
    end;

    procedure command(str: string);
    var
      cmd: string;
      f, s: string;
      wkey: WideString;
      ukey: UTF8String;
      i: Integer;
    begin
        cmd := GetToken(':', str);

        if cmd='doc' then
        begin
            //mnuStopClick(nil);
            showtab;
            if ManualOnline then
            begin
              wkey := key;
              ukey := UTF8Encode(wkey);
              s    := ukey;
              key := '';
              for i := 1 to Length(s) do
              begin
                key := key + '%' + IntToHex(Ord(s[i]),2);
              end;
              show_doc('http://aoi-project.com/sakura/cmd/wiki.aoi?' + Key);
            end else
            begin
              show_doc(AppPath + 'doc\command\'+str+'.htm');
            end;
        end else
        if cmd='line' then
        begin
            GotoLine(Trunc(StrToValue(str)));
        end else
        if cmd='file' then
        begin
          f := AppPath + 'Include\' + str;
          if FileExists(f) then RunApp('notepad "'+f+'"');
        end else
        if cmd='html' then
        begin
          if FileExists(str) then OpenApp(str);
        end;
    end;


begin

    s := lblBar.Caption ;
    if Copy(s,1,2)='(*' then
    begin
        key := s;
        s := GetToken(')',key);
        Delete(s,1,2);
        if s='' then Exit;
        GetToken('[', Key);
        Key := GetToken(']', Key);
        command(s);
    end else
    begin
        //���������ꍇ
        showtab;
        ShowBar('');
    end;
end;

function TfrmSakuraPad.GetSampleCode: string;
var
    s: TStringList;
    i: Integer;
begin
    //
    s := TStringList.Create;
    try
        if FileExists(FileHelp) then
        begin
            s.LoadFromFile(FileHelp);
            s.Text := GetTags(s.Text, 'CODE');
            for i:=0 to s.Count-1 do
            begin
                s.Strings[i] := Trim(s.Strings[i]);
            end;
            Result := s.Text ;
            Result := JReplace(Result,#13#10,'',True);
            Result := JReplace(Result,'<BR>',#13#10,True);
            Result := DeleteTag(Result); 
            //
            Result := JReplace(Result,'&gt;','>',True);
            Result := JReplace(Result,'&lt;','<',True);
            Result := JReplace(Result,'&amp;','&',True);
            Result := JReplace(Result,'&quot;','"',True);
        end;
    finally
        s.Free ;
    end;
end;

procedure TfrmSakuraPad.browserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
    FileHelp := URL;
    //ShowMessage(FileHelp);
end;

procedure TfrmSakuraPad.mnuInsSampleMMLClick(Sender: TObject);
begin
    edtMain.SelText := GetSampleCode ;
end;

procedure TfrmSakuraPad.btnInsertSampleClick(Sender: TObject);
begin
    edtMain.SelText := GetSampleCode ;
end;

procedure TfrmSakuraPad.btnBackClick(Sender: TObject);
begin
    try
    if browser.LocationName = '' then
    begin
        browser.Navigate(AppPath+'doc\index.htm'); 
    end else
        browser.GoBack ;
    except
    end;
end;

procedure TfrmSakuraPad.mnuExitClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmSakuraPad.FormShow(Sender: TObject);
var
  fname: string;

    procedure Readparam;
    var
        idx: Integer;
        s, fname, c: string;
    begin
        idx := 1;
        while idx <= ParamCount do
        begin
            s := ParamStr( idx );
            c := Copy(s,1,1);
            if (c='/')or(c='-') then // �R�}���h
            begin
                Delete(s,1,1);
                if(s='')then
                begin
                    //----------------
                end;
            end else
            begin
                if fname='' then fname := s;
            end;
            Inc(idx);
        end;
        if fname <> '' then
        begin
            ChangeFileName(fname);
            LoadToEdit(SaveFileName);
        end else
        begin
          ChangeFileName(''); 
        end;
    end;

    procedure ReadKakikake;
    var s: string;
    begin
      if FileExists(AppPath + Kakikake) then
      begin
        ActiveEditor.Lines.LoadFromFile(AppPath + Kakikake);
        s := ActiveEditor.Lines.Strings[0];
        ActiveEditor.Lines.Delete(0);
        FileModify := False;
        ChangeFileName(Copy(s,3,512));// �R�����g���͂���
        ActiveEditor.Invalidate ;
      end;
    end;

begin
    IsInit := True;

    //�ݒ�t�@�C�� "sakura.ini"��ǂ�
    ReadIniFile;

    //�t�@�C��������Έ��������ċN��
    if ParamCount = 0 then ReadKakikake
                      else ReadParam;

    //�O���肩���̃t�@�C�������݂��邩�H
    //BackupFile := AppPath + TEMP_DIR + BACKUP_FILENAME;
    if FileExists(BackupFile) then
    begin
      if MsgYesNo('�O���肩���̃t�@�C��������܂����������܂����H') then
      begin
        LoadToEdit(BackupFile);
        if ActiveEditor.Lines.Count > 0 then
        begin
          fname := Trim(ActiveEditor.Lines.Strings[0]);
          ActiveEditor.Lines.Delete(0);
          if Copy(fname,1,15) = '//OriginalFile:' then
          begin
            Delete(fname, 1,15);
            ChangeFileName(fname);
          end;
        end;
      end;
    end;

    //�w���v�^�u���A�N�e�B�u��
    edtMain.SetFocus ;
    pageLeft.ActivePageIndex := 4;

    IsInit := False;
    timerAutoPlay.Enabled := True;
end;

procedure TfrmSakuraPad.mnuSelectCommentClick(Sender: TObject);
var
    s: string;
begin
    s := Trim(edtMain.SelText);
    if (Copy(s,1,2)='/*')and(Copy(s,Length(s)-1,2)='*/') then
    begin
        Delete(s,1,2);
        Delete(s,Length(s)-1,2);
        s := Trim(s);
    end else
    begin
        s := '/* ' + s + ' */'#13#10;
    end;
    edtMain.SelText := s;
end;

procedure TfrmSakuraPad.mnuSelectLoopClick(Sender: TObject);
begin
    InsSelectKakko('[',']');
end;

procedure TfrmSakuraPad.InsSelectKakko(sFrom, sTo: string);
var
    s: string;
begin
    s := Trim(edtMain.SelText);
    if (Copy(s,1,1)=sFrom)and(Copy(s,Length(s),1)=sTo) then
    begin
        Delete(s,1,1);
        Delete(s,Length(s),1);
        s := Trim(s);
    end else
    begin
        s := sFrom + ' ' + s + ' ' + sTo;
    end;
    edtMain.SelText := s;
end;

procedure TfrmSakuraPad.mnuSelectStrClick(Sender: TObject);
begin
    InsSelectKakko('{','}');
end;

procedure TfrmSakuraPad.mnuTabToSpaceClick(Sender: TObject);
begin
    edtMain.SelText := JReplace(edtMain.SelText, #9, '�@', True);
end;

procedure TfrmSakuraPad.cmbCommentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key=13 then
    begin
        btnEnumCommentClick(nil); 
    end;
end;

procedure TfrmSakuraPad.lstHelpDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
    s: string;
    canvas: TCanvas;
begin
    s := lstHelp.Items[Index];
    s := GetToken(',',s);
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
    end else
    begin
        //��I��
        if (Index mod 2)=0 then
        begin
            canvas.Brush.Color := clWhite;
        end else
        begin
            canvas.Brush.Color := RGB(230,230,255);
        end;
        canvas.Pen.Color := clBlack;
    end;
    canvas.FillRect(Rect);
    canvas.TextOut(Rect.Left +20, Rect.Top+2, s);
    canvas.CopyMode := cmMergeCopy		 ;
    canvas.Draw(Rect.Left+2, Rect.Top+1, imgDown.Picture.Graphic);
end;

procedure TfrmSakuraPad.lstHelpClick(Sender: TObject);
var
    s: string;
    Index: Integer;
begin
    Index := lstHelp.ItemIndex ;
    if Index<0 then Exit;

    s := lstHelp.Items[Index];
    GetToken(',',s); //KEY���̂Ă�
    s := Trim(s);

    if mnuExternalBrowser.Checked = False then
    begin
        if not pageBottom.Visible then
        begin
            mnuErrorTabClick(nil);
        end;
        pageBottom.ActivePageIndex := 1;
    end;
    ShowHtml(AppPath + s); 
end;

procedure TfrmSakuraPad.popJumpDefVarClick(Sender: TObject);
var
    key, txt, s, ss,skey: string;
    i: Integer;

    function chkIncludeFile(fname: string): Boolean; //����������TRUE
    var
        sl: TStringList;
        f: string;
        i: Integer;

        procedure GetInfo;
        begin
            ss := '(*file:'+f+')�y�s�z'+IntToStr(i+1)+'�y���e�z'+s;
            ShowBar(ss);
        end;

    begin
        Result := True;
        f := fname;
        sl := TStringList.Create ;
        try
            fname := AppPath + 'Include\'+fname;
            if FileExists(fname) then
            begin
                sl.LoadFromFile(fname);
                for i:=0 to sl.Count -1 do
                begin
                    s := sl.Strings[i];
                    skey := '#'+key;
                    if (Copy(s,1,Length(skey))=skey) then
                    begin
                        GetInfo; Exit;
                    end;
                    ss := UpperCase(s);
                    skey := UpperCase('Str '+ key);
                    if Copy(ss,1,Length(skey)) = skey then
                    begin
                        GetInfo; Exit;
                    end;
                    skey := UpperCase('Int '+ key);
                    if Copy(ss,1,Length(skey)) = skey then
                    begin
                        GetInfo; Exit;
                    end;
                    skey := UpperCase('Function '+ key);
                    if Copy(ss,1,Length(skey)) = skey then
                    begin
                        GetInfo; Exit;
                    end;
                    skey := '~{'+ key+'}';
                    if Copy(ss,1,Length(skey)) = skey then
                    begin
                        GetInfo; Exit;
                    end;
                end;
            end;
            Result := False;
        finally
            sl.Free ;
        end;
    end;

    procedure EditLine(i: Integer);
    begin
        if i>=0 then
        begin
            ShowBar('(*line:'+IntToStr(i)+') '+ActiveEditor.ListString[i]);
        end;
    end;

begin
    if ActiveEditor.SelLength = 0 then
    begin
        GetCaretWord;
    end;
    //�G�f�B�^�̓����𒲂ׂ�----------------------------------------------------
    key := Trim(ActiveEditor.SelText) ;
    if key='' then Exit;
    for i:=0 to ActiveEditor.Lines.Count -1 do
    begin
        s := Trim(ActiveEditor.Lines.Strings[i]);

        if key[1] <> '#' then skey := '#'+key;
        if (Copy(s,1,Length(skey))=skey) then
        begin
            EditLine(i); Exit;
        end;
        ss := UpperCase(s);
        skey := UpperCase('Str '+ key);
        if Copy(ss,1,Length(skey)) = skey then
        begin
            Editline(i);
            Exit;
        end;
        skey := UpperCase('Int '+ key);
        if Copy(ss,1,Length(skey)) = skey then
        begin
            EditLine(i); Exit;
        end;
        skey := UpperCase('Function '+ key);
        if Copy(ss,1,Length(skey)) = skey then
        begin
            EditLine(i); Exit;
        end;
        skey := '~{'+ key+'}';
        if Copy(ss,1,Length(skey)) = skey then
        begin
            EditLine(i); Exit;
        end;
    end;
    //�G�f�B�^���ɂȂ��Ƃ�
    //Help������----------------------------------------------------------------
    i := cmd.Find(key,0,0);
    if i<0 then
    begin
    end else
    begin
        s := '';
        if cmd.Cells[3,i] <> '' then
        begin
            s := s + '(*doc:'+cmd.Cells[3,i]+')';
        end;
        s := s + '�y�����z'+cmd.Cells[1,i] + '�@�y�����z'+cmd.Cells[2,i];
        ShowBar(s);
        //barClick(nil);
        Exit;
    end;
    //�w���v�ɂȂ��Ƃ��AInclude�t�@�C�����݂�
    //stdmsg.h------------------------------------------------------------------
    if chkIncludeFile('stdmsg.h') then Exit;
    //���̑�
    txt := ActiveEditor.Lines.Text ;
    while txt<>'' do
    begin
        if Pos('Include(',txt)=0 then Break;
        GetToken('Include(', txt);
        ss := GetToken(')',txt);
        if chkIncludeFile(ss) then Exit;
        txt := Trim(txt);
    end;
    ShowBar('('+key+')');
end;

procedure TfrmSakuraPad.btnShowNewBrowserClick(Sender: TObject);
begin
    OpenApp(FileHelp);
end;

procedure TfrmSakuraPad.chkPlayFromClick(Sender: TObject);
begin
    if chkPlayFrom.Checked then
    begin
        edtTime1.Enabled := True;
        edtTime2.Enabled := True;
        edtTime3.Enabled := True;
    end else
    begin
        edtTime1.Enabled := False;
        edtTime2.Enabled := False;
        edtTime3.Enabled := False;
    end;
    PlayModify := True;
end;

procedure TfrmSakuraPad.trackExit(Sender: TObject);
begin
    MouseTrack := False;
end;

procedure TfrmSakuraPad.mnuMidi2MmlClick(Sender: TObject);
begin
    if not dlgOpenMidi.Execute then Exit;
    RunAppAndWait(AppPath+ARUKAS+' -m2 "'+dlgOpenMidi.FileName+'" "'+AppPath+'temp.txt"');
    RunApp(ParamStr(0)+' "'+AppPath+'temp.txt"');
end;

procedure TfrmSakuraPad.mnuShowTrackInfoClick(Sender: TObject);
var
    temp, s: string;
    i: Integer;
begin
    i := edtMain.SelStart ;
    s := Copy(edtMain.Lines.Text, 1, i)+';PrintTrack;End;';
    temp := edtMain.Lines.Text ;
    edtMain.Lines.Text := s;
    mciClose ;
    PlayModify := True;
    Compile ;
    edtMain.Lines.Text := temp;
    edtMain.SelStart := i;
    if pageBottom.Visible then
    begin
        pageBottom.ActivePageIndex := 0;
        edtMain.SetFocus ;
    end;
end;


procedure TfrmSakuraPad.mnuPlayerRepeatClick(Sender: TObject);
begin
    mnuPlayerRepeat.Checked := not mnuPlayerRepeat.Checked;
end;

procedure TfrmSakuraPad.btnErrTabCloseClick(Sender: TObject);
begin
    ShowBar('�������N���b�N����ƁA���b�Z�[�W�^�u���\������܂��B���߂��\������Ă���Ƃ��́A�}�j���A����\�����܂��B');
    mnuErrorTabClick(nil);
end;

procedure TfrmSakuraPad.GetCaretWord;
var
    i,l,ll,r: Integer;
    str,ch: string;

const
    break1 = '�@�f�I�h���������f�i�j���|�`�O�b���u�v���F�G�Q�E�����A�B�{�����w�x�H'#0;
    break2 = ' !"#$%&''()=-~^|\[]@{}*+;:<>,./\?'#9#0;

    function lchk(wch: string; p: Integer): Boolean;
    begin
        Result := False;
        if p<2 then Exit;
        if Length(str) < p then Exit;
        if wch[2] <> str[p] then Exit;
        if wch[1] <> str[p-1] then Exit;
        Result := True;
    end;

begin
    // �P��̑I��
    l := ActiveEditor.SelStart +1;
    str := ActiveEditor.Lines.Text + ';';
    ll := 0;
    if str='' then Exit;
    while l > 1 do // �s���܂Ŗ߂�
    begin
        // ���s�̎�
        if lchk(#13#10, l) then begin
            Inc(l);
            Break;
        end;
        Dec(l);
    end;
    i := l;
    while i < ActiveEditor.SelStart do
    begin
        if str[i] in LeadBytes then
        begin
            ch := str[i] + str[i+1];
            Inc(i,2);
            if Pos(ch,break1)>0 then
            begin
                ll := i;
            end;
        end else
        begin
            ch := str[i];
            Inc(i);
            if Pos(ch,break2)>0 then
            begin
                ll := i;
            end;
        end;
    end;

    if ll<>0 then l := ll
    else
    begin
        if i >= Length(str) then l := i;
    end;

    ActiveEditor.SelStart := l-1;
    i := l; ll := 0; r := l;
    while True do
    begin
        if str[i] in LeadBytes then
        begin
            ch := str[i] + str[i+1];
            if Pos(ch,break1)>0 then
            begin
                ll := i; Break;
            end;
            Inc(i,2);
        end else
        begin
            ch := str[i];
            if Pos(ch,break2+#13#10)>0 then
            begin
                ll := i; Break;
            end;
            Inc(i);
        end;
        if i > Length(str) then
        begin
            ll := i; Break;
        end;
    end;
    if ll<>0 then r := ll;
    ActiveEditor.SelLength := r-l;
end;

procedure TfrmSakuraPad.LoadToEdit(fname: string);
begin
    edtMain.Lines.LoadFromFile(fname);
    FileModify := False;
    PlayModify := False;
    ChangeFileName(fname);
end;

function TfrmSakuraPad.CheckModify(caption: string): Boolean;
var
    i: Integer;
    s: string;
begin
    Result := True;
    if FileModify then
    begin
        if SaveFileName = '' then s := '����' else s := ExtractFileName(SaveFileName);
        i := MsgYesNoCancel('"'+s+'"�͕ύX����Ă��܂��B'#13#10+
        '�ۑ����܂����H',caption);
        case i of
        IDYES:mnuSaveClick(nil);
        IDNO:;
        IDCANCEL: Result := False;
        end;
    end;
end;

procedure TfrmSakuraPad.ShowInfo(text: string);
begin
    text := JReplace(text, #13#10, ' ', True);
    lblInfo.Caption := text + ' ';
end;

procedure TfrmSakuraPad.btnLeftPanelCloseClick(Sender: TObject);
begin
    mnuShowBenriPanelClick(nil);
    ShowBar('���[�ׂ̍��p�l�����N���b�N����ƕ֗��p�l��������܂��B');
end;

procedure TfrmSakuraPad.panelLeftClick(Sender: TObject);
begin
    if mnuShowBenriPanel.Checked = False then
        mnuShowBenriPanelClick(nil);
end;

procedure TfrmSakuraPad.mnuChangeSkinClick(Sender: TObject);
begin
    if not dlgOpenSkin.Execute then Exit;
    ini.SkinPath := dlgOpenSkin.FileName ;
    ChangeSkin(dlgOpenSkin.FileName);
end;

procedure TfrmSakuraPad.ChangeSkin(fname: string);
var
    bmp: TBitmap;
    i: Integer;
    w: TWindowState;
begin
    //�X�L���̐ݒ�
    try

    if FileExists(fname)=False then
    begin
        ini.UseSkin := False;
    end;
    if ini.UseSkin = False then
    begin
        cbarTop.Picture := nil;
        cbarBottom.Picture := nil;
        imgLeftTop.Picture := nil;
        imgMan.Picture := nil;
        ini.SkinPath := '';
        Exit;
    end;

    cbarTop.Picture.LoadFromFile(fname);

    bmp := TBitmap.Create ;
    try
        bmp.width := cbarTop.Picture.Width ;
        bmp.Height := cbarTop.Picture.Height ;
        bmp.Assign(cbarTop.Picture.Graphic);
        bmp.PixelFormat := pf24bit ;
        i := bmp.Canvas.Pixels[0,0];
        if i=0 then begin end else begin
            panelPlayer.Color := i;
            panelTrack.Color := i;
            panelLeftTop.Color := i;
            panelManual.Color := i;
            panelPicture.Color := i;
        end;
        cbarBottom.Picture.Assign(bmp);
        //imgLeftTop.Picture.Assign(bmp);
        //imgMan.Picture.Assign(bmp);
        panelHelpTopResize(nil); // �r�b�g�}�b�v�̍X�V
    finally
        bmp.Free;
    end;
    ini.SkinPath := fname;
    finally
        //menuBar.Invalidate ;
    end;

    w := frmSakuraPad.WindowState;
    frmSakuraPad.WindowState := wsMinimized ;
    sleep(100);
    Application.ProcessMessages ;

    if IniWindowMaxize = True then
    begin
      frmSakuraPad.WindowState := w ;
    end else
    begin
      frmSakuraPad.WindowState := wsMaximized ;
    end;
end;

procedure TfrmSakuraPad.mnuSkinMode0Click(Sender: TObject);
begin
    ini.UseSkin := False;
    ChangeSkin('');
end;

procedure TfrmSakuraPad.mnuSkinMode1Click(Sender: TObject);
var
    tag: Integer;
const
    path:array[0..6]of string = (
    'skin.jpg',
    'hana.jpg',
    'hana2.jpg',
    'usagi.jpg',
    'sima2.jpg',
    'yasi.jpg',
    'gara.jpg'
    );
begin
    ini.UseSkin := True;
    tag := TMenuItem(Sender).Tag ;
    ChangeSkin(AppPath+'skin\'+path[tag]);
end;


procedure TfrmSakuraPad.toolFontSmallClick(Sender: TObject);
begin
    ActiveEditor.Font.Size := ActiveEditor.Font.Size - 2;
    if ActiveEditor.Font.Size < 4 then ActiveEditor.Font.Size := 4;
    PlayWave(WAV_B);
end;

procedure TfrmSakuraPad.toolFontMiddleClick(Sender: TObject);
begin
    ActiveEditor.Font.Size := ini.FontSize ;
    PlayWave(WAV_PI);
end;

procedure TfrmSakuraPad.toolFontBigClick(Sender: TObject);
begin
    ActiveEditor.Font.Size := ActiveEditor.Font.Size + 2;
    PlayWave(WAV_B);
end;

procedure TfrmSakuraPad.actLineBreakExecute(Sender: TObject);
var
    s: string;
    i: Integer;
begin
    s := '//';
    for i:=1 to 78 do s := s + '-';
    edtMain.Lines.Insert(edtMain.Row, s);
    PlayWave(WAV_TO); 
end;

procedure TfrmSakuraPad.mnuLineCenteringClick(Sender: TObject);
var
    ss,s: string;
    len: Integer;
    i: Integer;
begin
    s := Trim(edtMain.Lines.Strings[ edtMain.Row ]);
    len := Length(s);
    len := (80 - len) div 2;
    ss := '';
    for i:=1 to len do ss := ss + ' ';
    edtMain.Lines.Strings[ edtMain.Row ] := ss + s;
end;

procedure TfrmSakuraPad.mnuLineRightingClick(Sender: TObject);
var
    ss,s: string;
    len: Integer;
    i: Integer;
begin
    s := Trim(edtMain.Lines.Strings[ edtMain.Row ]);
    len := Length(s);
    len := (80 - len);
    ss := '';
    for i:=1 to len do ss := ss + ' ';
    edtMain.Lines.Strings[ edtMain.Row ] := ss + s;
end;

procedure TfrmSakuraPad.actHelpExecute(Sender: TObject);
var
    s: string;
begin
    mnuStopClick(nil);
    GetCaretWord ;
    s := Trim(edtMain.SelText) ;
    if s<>'' then
    begin
        popJumpDefVarClick(nil);
    end else begin
        OpenApp(AppPath+'doc\index.htm');
    end;
end;

procedure TfrmSakuraPad.mnuHelpIndexClick(Sender: TObject);
begin
    OpenApp(AppPath+'doc\index.htm');
end;

procedure TfrmSakuraPad.mnuSkinMod4Click(Sender: TObject);
begin
    ini.UseSkin := True;
    ChangeSkin(AppPath + 'skin\skin4.jpg');
end;

procedure TfrmSakuraPad.mnuKeyMappingClick(Sender: TObject);
begin
    frmKeyMap.ShowModal ;
end;

procedure TfrmSakuraPad.actYExecute(Sender: TObject);
begin
    edtMain.Redo ;
    PlayWave(WAV_N);
end;

procedure TfrmSakuraPad.PlayWave(no: Integer);
var
    f: string;
    i: Integer;
begin
    if mnuEffect.Checked = False then Exit;
    if IsInit then Exit; //�����ݒ�̓r���Ȃ特��炳�Ȃ�
    i := Integer(timeGetTime) - wav_interval;
    if i<500 then Exit;

    f := AppPath + 'tools\wav\' + WAV[no];
    if FileExists(f) then
    begin
        sndPlaySound(PChar(f), SND_SYNC);
    end;
    wav_interval := timeGetTime;
end;

procedure TfrmSakuraPad.edtMainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

const
  //............................0    1    2    3    4      5    6    7    8    9    10  11   12 13
  n0: array [0..15] of string = ('�b','�h','��','�~','�t�@','�\','��','�V','�[','`','*','��','','��','','�f');
  n1: array [0..15] of string = ('r', 'c', 'd', 'e', 'f',   'g', 'a', 'b', '^','`', '*','+', '','-', '','�f');
  n2: array [0..15] of string = ('��','��','��','��','�ӂ�','��','��','��','�[','`','*','��','','��','','�f');

begin
    RejectKey := False;
    if Key = VK_RETURN then
    begin
        PlayWave(WAV_PI);
    end else
    if (Key=VK_SPACE) and (ssCtrl in Shift) then
    begin
        Key := 0;
        mnuHokanClick(nil);
    end else
    if (mnuTenkey.Checked)and([ssCtrl] = Shift) then
    begin
    {
106:*
107:+
108:
109:-
110:
111:/
    }
      case Key of
      96..110:
        begin
          case ini.OutMML of
          0: ActiveEditor.SelText := n0[Key-96];
          1: ActiveEditor.SelText := n1[Key-96];
          2: ActiveEditor.SelText := n2[Key-96];
          end;
          Key := 0;
          RejectKey := True;
        end;
      111:
        begin
          case ini.OutMML of
          0,2: ActiveEditor.SelText := '����';
          1  : ActiveEditor.SelText := 'l';
          end;
          Key := 0;
          RejectKey := True;
        end;
      end;
    end;
    lblInfo.Caption := IntToStr(Key);
end;

procedure TfrmSakuraPad.mnuEffectClick(Sender: TObject);
begin
    mnuEffect.Checked := not mnuEffect.Checked ;
end;

procedure TfrmSakuraPad.mnuAutoHelpClick(Sender: TObject);
begin
    mnuAutoHelp.Checked := not mnuAutoHelp.Checked ;
end;

procedure TfrmSakuraPad.actInsLineTabExecute(Sender: TObject);
var
    s: TStringList;
    i,idx,len: Integer;
begin
    s := TStringList.Create ;
    try
        idx := edtMain.SelStart ;
        len := edtMain.SelLength ;
        s.Text := edtMain.SelText ;
        for i:=0 to s.Count-1 do
        begin
            s.Strings[i] := #9 + s.Strings[i];
            Inc(len);
        end;
        edtMain.SelText := s.Text ;
        edtMain.SelStart := idx;
        edtMain.SelLength := len;
    finally
        s.Free;
    end;
end;

procedure TfrmSakuraPad.actDelLineTabExecute(Sender: TObject);
var
    s: TStringList;
    i,idx,len: Integer;
    t: string;
begin
    s := TStringList.Create ;
    try
        idx := edtMain.SelStart ;
        len := edtMain.SelLength ;
        s.Text := edtMain.SelText ;
        for i:=0 to s.Count-1 do
        begin
            t := s.Strings[i];
            if Copy(t,1,1) = #9 then
            begin
                s.Strings[i] := Copy(t,2,Length(t)-1);
                Dec(len);
            end;
        end;
        edtMain.SelText := s.Text ;
        edtMain.SelStart := idx;
        edtMain.SelLength := len;
    finally
        s.Free;
    end;
end;

procedure TfrmSakuraPad.lstCommentDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
    s: string;
    canvas: TCanvas;
begin
    s := lstComment.Items[Index];
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
    end else
    begin
        //��I��
        if (Index mod 2)=0 then
        begin
            canvas.Brush.Color := clWhite;
        end
        else begin
            canvas.Brush.Color := RGB(230,230,255);
        end;
        canvas.Pen.Color := clBlack;
    end;
    canvas.FillRect(Rect);
    canvas.TextOut(Rect.Left +2, Rect.Top+2, s);
end;

procedure TfrmSakuraPad.popSetSioriClick(Sender: TObject);
var
    s: string;
begin
    s := InputBox('������̐ݒ�','������̖��O����͂��Ă�������','');
    if s='' then Exit;
    edtMain.Lines.Insert(edtMain.Row, '//_'+s); 
end;

procedure TfrmSakuraPad.splitLeftMoved(Sender: TObject);
begin
    btnLeftPanelClose.Left := imgLeftTop.Width - btnLeftPanelClose.Width - 1;
end;

procedure TfrmSakuraPad.edtMainTopRowChange(Sender: TObject);
begin
    Application.ProcessMessages ;
    //�Ȃ����A�X�N���[���o�[���㉺���Ă���ƁA��O����������̂ŁB
end;

procedure TfrmSakuraPad.mnuExternalBrowserClick(Sender: TObject);
begin
    mnuExternalBrowser.Checked := not mnuExternalBrowser.Checked;
end;

procedure TfrmSakuraPad.ShowHtml(path: string);
begin
    if mnuExternalBrowser.Checked then
    begin
        OpenApp(path);
    end else
    begin
        browser.Navigate(path);
        if pageBottom.Visible then
        begin
            pageBottom.ActivePageIndex := 1;
        end;
    end;
end;

procedure TfrmSakuraPad.MakeTemplateList;
var
    dir: string;
    g: TGlob;
begin
    dir := AppPath + 'tools\template\*';
    g := TGlob.Create(dir);
    try
        lstTemplate.Sorted := True;
        lstTemplate.Items.Text := g.FileList.Text ;
    finally
        g.Free;
    end;
end;

procedure TfrmSakuraPad.lstTemplateDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
    s: string;
    canvas: TCanvas;
begin
    s := lstTemplate.Items[Index];
    s := GetToken('.',s); 
    //
    canvas := TListBox(Control).Canvas ;
    if odSelected in State then
    begin
        //�I��
        canvas.Brush.Color := clBlue;
        canvas.Pen.Color := clWhite;
    end else
    begin
        //��I��
        if (Index mod 2)=0 then
            canvas.Brush.Color := clWhite
        else
            canvas.Brush.Color := RGB(230,230,255);
        canvas.Pen.Color := clBlack;
    end;
    canvas.FillRect(Rect);
    canvas.TextOut(Rect.Left +20, Rect.Top+2, s);
    canvas.CopyMode := cmMergeCopy		 ;
    canvas.Draw(Rect.Left+2, Rect.Top+1, imgDown.Picture.Graphic);
end;

procedure TfrmSakuraPad.lstTemplateDblClick(Sender: TObject);
var
    path, s: string;
    i: Integer;
begin
    i := lstTemplate.ItemIndex ;
    if i<0 then Exit;

    path := AppPath + 'tools\template\'+lstTemplate.Items[i];
    ReadTextFile(path, s);

    ActiveEditor.SelText := s;
    PlayWave(WAV_TO);
end;

procedure TfrmSakuraPad.lstTemplateClick(Sender: TObject);
var
    path, s: string;
    i: Integer;
begin
    i := lstTemplate.ItemIndex ;
    if i<0 then Exit;

    path := AppPath + 'tools\template\'+lstTemplate.Items[i];
    ReadTextFile(path, s);
    lblBar.Caption := Copy(JReplace(s,#13#10,'...',True),1,100);

    PlayWave(WAV_N);
end;

procedure TfrmSakuraPad.actTemplateRegExecute(Sender: TObject);
var
    txt,s: string;
begin
    txt := edtMain.SelText ;
    s := InputBox('�e���v���[�g�֓o�^','�t�@�C��������͂��Ă�������','');
    if s='' then Exit;
    if WriteTextFile(AppPath+'tools\template\'+s+'.txt', txt) = False then
    begin
        ShowWarn('�e���v���[�g�̓o�^�Ɏ��s���܂����B'#13#10+
        '�t�@�C�������m�F���Ă��������B','�e���v���[�g�o�^');
    end;
    MakeTemplateList;
end;

procedure TfrmSakuraPad.lstVoiceMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    midiOut.OutAllNoteOff(Channel);
end;

procedure TfrmSakuraPad.mnuSplitEditClick(Sender: TObject);

    procedure BeginSplit;
    var
      Editor: TEditor;
      Splitter: TSplitter;
    begin
      if not IsSplit then
      begin
        Editor := TEditor.Create(Self);
        // TEditorProp �ɂ��v���p�e�B�ݒ�
        EditorProp.Assign(edtMain);
        EditorProp.AssignTo(Editor);
        // �C�x���g�n���h�����󂯌p��
        AssignProperties(edtMain, Editor, tkMethods);
        AssignEvent(Editor);
        Editor.PopupMenu := PopupMenu1;
        // Parent ��
        Editor.Parent := panelEditor;
        Editor.Align := alTop;
        Editor.Top := 0;
        Editor.Height := panelEditor.Height div 2;
        // ������I�u�W�F�N�g�̋��L
        Editor.ExchangeList(edtMain);
        Editor.TopRow := edtMain.TopRow;
        edtMain.TopRow := Editor.TopRow + Editor.RowCount;
        Splitter := TSplitter.Create(Self);
        Splitter.Parent := panelEditor;
        Splitter.Align := alTop;
        Splitter.Top := Editor.Top + Editor.Height;
        Splitter.Cursor := crVSplit;
        //Splitter.OnMoved := SplitterMoved;
        ActiveSplitter := Splitter;
        SecondEditor := Editor;//�j����p
        IsSplit := True;
      end;
    end;

    procedure EndSplit;
    begin
      if IsSplit then
      begin
        ActiveSplitter.Free;
        SecondEditor.Free;
      end;
      IsSplit := False;
    end;

begin
    if IsSplit then
        EndSplit
    else
        BeginSplit;
    mnuSplitEdit.Checked := IsSplit;
    PlayWave(WAV_PI); 
end;

procedure TfrmSakuraPad.AssignEvent(Editor: TEditor);
begin
    with Editor do
    begin
        OnChange   := edtMainChange;
        OnDblClick := edtMainDblClick;
        OnDragOver := edtMainDragOver;
        OnKeyDown  := edtMainKeyDown;
        OnTopRowChange := edtMainTopRowChange;
        OnEnter    := edtMainEnter;
    end;
end;

procedure TfrmSakuraPad.edtMainEnter(Sender: TObject);
begin
    ActiveEditor := Sender as TEditor;
end;

procedure TfrmSakuraPad.mnuTemplateDeleteClick(Sender: TObject);
var
    path: string;
    i: Integer;
begin
    i := lstTemplate.ItemIndex ;
    if i<0 then Exit;
    if False = MsgYesNo(lstTemplate.Items[i]+'���폜���܂��B��낵���ł����H') then
    begin
        Exit;
    end;

    path := AppPath + 'tools\template\'+lstTemplate.Items[i];
    DeleteFile(path);
    PlayWave(WAV_B);
    sleep(100);
    MakeTemplateList ;
end;

procedure TfrmSakuraPad.mnuTemplateDirClick(Sender: TObject);
begin
    OpenApp(AppPath + 'tools\template\'); 
end;

procedure TfrmSakuraPad.mnuShowTemplateTabClick(Sender: TObject);
begin
    if pageLeft.Visible = False then mnuShowBenriPanelClick(nil);

    pageLeft.ActivePage := tabTemplate ;
    ShowMessage('��ʍ����A���^�^�u���A���^���G�f�B�^�Ƀh���b�O���h���b�v�ł��܂��B');
end;

procedure TfrmSakuraPad.mnuSplashWindowClick(Sender: TObject);
begin
    mnuSplashWindow.Checked := not mnuSplashWindow.Checked;

    if mnuSplashWindow.Checked=False then
    begin
        WriteTextFile(AppPath+SHOW_LOGO_FILE,'���̃t�@�C��������ƃ��S��\�����܂���B');
    end else
    begin
        if FileExists(AppPath + SHOW_LOGO_FILE) then
        begin
            DeleteFile(AppPath + SHOW_LOGO_FILE);
        end;
    end;
end;

procedure TfrmSakuraPad.mnuInsIncludeClick(Sender: TObject);
var
    i: Integer;
    s,fn: string;
begin
    i := lstFiles.ItemIndex ;
    if i<0 then Exit;
    fn := lstFiles.Items.Strings[i];
    if LowerCase(Copy(fn, Length(fn)-3+1,3))='j.h' then
    begin
      s := 'Sutoton('+ fn + ');';
    end else
      s := 'Include(' + fn + ');';
    ActiveEditor.SelText := s;
end;

procedure TfrmSakuraPad.MakeRecentMenu;
var
    m,mm: TMenuItem;
    i: Integer;
begin
    mnuRecent.Clear ;
    popRecent.Items.Clear ;
    if ini.Recent.Count = 0 then
    begin
        mnuRecent.Enabled := False;
    end else
    begin
        mnuRecent.Enabled := True;
    end;

    for i:=0 to ini.Recent.Count -1 do
    begin
        m := TMenuItem.Create( mnuRecent );
        m.Caption := ini.Recent.Strings[ini.Recent.Count - i - 1];
        m.OnClick := mnuOpenRecent;
        m.Tag := ini.Recent.Count - i - 1;
        mnuRecent.Add(m);

        mm := TMenuItem.Create( popRecent );
        mm.Caption := ini.Recent.Strings[ini.Recent.Count - i - 1];
        mm.OnClick := mnuOpenRecent;
        mm.Tag := ini.Recent.Count - i - 1;
        popRecent.Items.Add(mm);
    end;

end;

procedure TfrmSakuraPad.mnuOpenRecent(Sender: TObject);
var
    m: TMenuItem;
begin
    m := Sender as TMenuItem;
    if not CheckModify('�ŋߎg�����t�@�C�����J��') then Exit;
    LoadToEdit( ini.Recent.Strings[ m.tag ] );
end;


procedure TfrmSakuraPad.edtMainKeyPress(Sender: TObject; var Key: Char);
begin
    if IsShowHokan then
    begin
        Key := #0;
        Exit;
    end;
    if RejectKey then
    begin
        Key := #0;
        Exit;
    end;
end;

procedure TfrmSakuraPad.mnuHokanClick(Sender: TObject);
var
    pp: TPoint;
    x,y,len: Integer;
begin
    GetCaretWord ;
    len := ActiveEditor.SelLength ;
    ActiveEditor.SelLength := 0;
    TEditorMi(ActiveEditor).GetCaretXY(x,y);
    with frmHokan do
    begin
        pp.X := x;
        pp.Y := y;
        pp := ActiveEditor.ClientToScreen(pp);
        Left := pp.X;
        Top  := pp.Y + ActiveEditor.FontHeight ;
        Show ;
        ActiveEditor.SelLength := len;
        IsShowHokan := True;
        Filter(ActiveEditor.SelText);
    end;
end;

procedure TfrmSakuraPad.toolPlayResetClick(Sender: TObject);
begin
    mnuStopClick(nil);
    track.Position := 0;
end;

procedure TfrmSakuraPad.trackScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
    mnuStopClick(nil);
end;

procedure TfrmSakuraPad.mnuRythmBoxClick(Sender: TObject);
begin
    frmRythmBox.Show ;    
end;

procedure TfrmSakuraPad.edtTime1Change(Sender: TObject);
begin
    PlayModify := True;
end;

procedure TfrmSakuraPad.ShowVoiceDescript;
var
    i: Integer;
    key, s: string;
begin
    i := lstVoice.ItemIndex;
    if i<0 then Exit;
    s := lstVoice.Items.Strings[i];
    if s='' then Exit;
    key := GetToken(',', s);
    GetToken('(',key);
    key := GetToken(')',key);
    ShowBar(Format('(*doc:0)[%s]:%s',[key, s]));
    VoiceNo := StrToIntDef(GetToken(':',s),-1);
    if Copy(s,Length(s),1)='$' then
    begin
        Channel := 9;
    end else
    begin
        Channel := 0;
    end;
end;

procedure TfrmSakuraPad.mnuUseMouseGestureClick(Sender: TObject);
begin
  mnuUseMouseGesture.Checked := not mnuUseMouseGesture.Checked ;
  //MouseGes.Enabled := mnuUseMouseGesture.Checked ;
end;

procedure TfrmSakuraPad.mnuHelpMouseGestureClick(Sender: TObject);
begin
  ShowMessage('[�}�E�X�W�F�X�`���[�̐���]'#13#10+
  ''#13#10+
  '�}�E�X�W�F�X�`���[�Ƃ́A�G�f�B�^�����ȂǂŁA�}�E�X�̉E�N���b�N�������Ȃ���'#13#10+
  '�w��̓�����s�����Ƃɂ��A�C�ӂ̃R�}���h�����s�����邱�Ƃ��ł���Ƃ������̂ł��B'#13#10+
  ''#13#10+
  '[�E�N���b�N]��[�������ړ�]�F���t�J�n'#13#10+
  '[�E�N���b�N]��[�������ړ�]�F���t�����߂�'#13#10+
  '[�E�N���b�N]��[�������ړ�]�F������̕\��'#13#10+
  '');
end;

procedure TfrmSakuraPad.MouseGesMouseGestureExecute(Sender: TObject;
  Gestures: TMouseGestureArray);
var
  s: string;
begin
  //TODO:�}�E�X�W�F�X�`��
  s := MouseGestureArrayToString(Gestures);
  //ShowBar(s);
  if s='��' then toolPlayResetClick(nil) else
  if s='��' then mnuRunClick(nil) else;
  if s='��' then mnuShowBookmarkClick(nil) else;
end;

procedure TfrmSakuraPad.mnuShowBookmarkClick(Sender: TObject);
begin
  if not mnuShowBenriPanel.Checked then mnuShowBenriPanelClick(nil);
  pageLeft.ActivePage := tabComment ;
  btnEnumCommentClick(nil); 
end;

procedure TfrmSakuraPad.chkSortUserFuncClick(Sender: TObject);
begin
  lstUser.Sorted := chkSortUserFunc.Checked;
  if lstUser.Sorted = False then
  begin //�ė�
    lstFilesClick(nil); 
  end;
end;

procedure TfrmSakuraPad.lstUserClick(Sender: TObject);
var
    i: Integer;
    s: string;
begin
    i := lstUser.ItemIndex ;
    if i<0 then Exit;
    s := lstUser.Items[i];
    ShowBar(s); 
end;

procedure TfrmSakuraPad.mnuShowIncludeManualClick(Sender: TObject);
var
    i: Integer;
    s,f: string;
begin
    i := lstFiles.ItemIndex ;
    if i<0 then Exit;
    f := lstFiles.Items.Strings[i];
    s := AppPath + 'doc\include\' + f;
    s := ChangeFileExt(s, '.htm');
    if FileExists(s) then
      OpenApp(s)
    else
      ShowMessage('"'+f+'"�̃}�j���A���͂���܂���B');
end;

procedure TfrmSakuraPad.ChangeTitle(cap: string);
var cap2: string;
begin
    if Trim(cap) = '' then cap := '����';
    cap := cap + ' - �e�L�X�g���y�u�T�N���v';
    if FileModify then cap2 := '*' + cap else cap2 := cap;
    Self.Caption := cap2;
    Application.Title := cap;
end;

procedure TfrmSakuraPad.mnuWriteMidiBBSClick(Sender: TObject);
var
  i: Integer;
begin
  DeleteFile(TempMidiFile);
  mnuOnlyCompileClick(nil);
  if FileExists(TempMidiFile) then
  begin
    i := GetFileSizeEasy(TempMidiFile);
    edtMain.Lines.SaveToFile(BackupFile);
    //ShowMessage(IntToStr(i));
    if i>3000 then
    begin
      ShowMessage('�t�@�C���T�C�Y='+IntToStr(i)+#13#10+
      'MIDI�t�@�C�����傫������̂�WEB�֓]���ł��܂���B'#13#10+
      '�]���Ȍ��Ȃǂ����炵�Ă݂Ă��������B');
      Exit;
    end;
    if MsgYesNo('���ݕҏW���̋Ȃ��������݂܂��B��낵���ł����H')=False then Exit;
    //frmToukou.ShowModal ;
  end else
  begin
    ShowMessage('���ݕҏW���̋Ȃ͏������߂܂���B');
  end;
end;

procedure TfrmSakuraPad.mnuOnlyCompileClick(Sender: TObject);
begin
    Application.ProcessMessages ;
    mciClose ;
    PlayModify := True;
    if Compile then
    begin
      //ok;
    end else
    begin
        if pageBottom.Visible = False then
            mnuErrorTabClick(nil);
    end;
    if pageBottom.Visible then
    begin
        pageBottom.ActivePageIndex := 0;
        ActiveEditor.SetFocus ;
    end;
end;

procedure TfrmSakuraPad.mnuFindManualClick(Sender: TObject);
begin
  frmFindHelpF.Show ;  
end;

procedure TfrmSakuraPad.mnuOpenMidiBBSClick(Sender: TObject);
begin
  OpenApp('http://www.text2music.com/midi/midi.cgi');
end;

procedure TfrmSakuraPad.mnuShowFAQClick(Sender: TObject);
begin
  OpenApp(AppPath+'doc\faq\index.htm');
end;

procedure TfrmSakuraPad.mnuPluginEnumClick(Sender: TObject);
var
  m: TMenuItem;
  g: TStringList;
  i,cnt: Integer;
  s,ext: string;
begin
  //�v���O�C���̗�
  //mnuPlugins.Clear ;

  (*
  m := TMenuItem.Create(mnuPlugins);
  m.Caption := '�v���O�C���̍ė�';
  m.OnClick := mnuPluginEnumClick;
  mnuPlugins.Add(m);

  m := TMenuItem.Create(mnuPlugins);
  m.Caption := '-';
  mnuPlugins.Add(m);

  *)

  //�v���O�C���t�H���_������
  cnt := 0;
  g := getAllFiles(DirPlugins + '*');
  try
    for i:=0 to g.Count -1 do
    begin
      s := ExtractFilename(g.Strings[i]);
      ext := LowerCase(ExtractFileExt(s));
      //'.EXE;.HMW;.BAT;.VBS;.JS'
      if (ext='.exe')or(ext='.hmw')or(ext='.bat')or(ext='.vbs')or(ext='.js') then
      begin //
      end else Continue;
      m := TMenuItem.Create(mnuPlugins);
      m.Caption := s + ' :(&' + IntToStr(cnt+1) + ')';
      m.OnClick := PluginClick;
      mnuPlugins.Add(m);
      Inc(cnt);
    end;
  finally
    g.Free ;
  end;

end;

procedure TfrmSakuraPad.PluginClick(Sender: TObject);
var
  c, ext: string;

  procedure CheckHimawari;
  begin
    //MML�̊֘A�t��
    with TRegistry.Create do
    begin
      try
        RootKey:=HKEY_CLASSES_ROOT;
        if not KeyExists('.hmw') then
        begin
          if MsgYesNo('�v���O�C�������s����ɂ́A'#13#10+
          '���{��v���O��������u�Ђ܂��v���K�v�ł�'#13#10+
          '�Ђ܂��̃_�E�����[�h�y�[�W��\�����܂����H') then
          begin
            OpenApp('http://www.text2music.com/hima/download.htm');
          end;
        end else
          OpenApp(c);
      finally
        Free;
      end;
    end;
  end;

begin
  c := TMenuItem(Sender).Caption ;
  c := DirPlugins + GetToken(':', c);
  c := Trim(c);
  ext := LowerCase(ExtractFileExt(c));
  if ext='.hmw' then
  begin
    //Check ".hmw"
    CheckHimawari;
  end else
    OpenApp(c);
end;

procedure TfrmSakuraPad.mnuInsDllVerClick(Sender: TObject);
begin
  ActiveEditor.SelText := '// dSakura.dll Version.' + mmlVersionInfo;
end;

procedure TfrmSakuraPad.commandExecuteMacro(Sender: TObject;
  Msg: TStrings);
var
	token: string;
  cmd, value: string;

    procedure sub_saveas;
    begin
    	{if FileExists(value) then begin
        	if MsgYesNo('"'+value+'"�֏㏑�����Ă��ǂ��ł����H')=False then Exit;
            ChangeCurFile(value);
        end;
        mnuSaveClick(nil);}
        ActiveEditor.Lines.SaveToFile( value );
    end;
    procedure sub_open;
    begin
    	ActiveEditor.Lines.LoadFromFile(value);
      ChangeFileName(value);
    end;
    procedure sub_insert;
    begin
    	ActiveEditor.SelLength := 0;
      ActiveEditor.SelText := value;
    end;
    procedure sub_col;
    var i: Integer;
    begin
        Self.Activate;
        i := StrToIntDef(value, -1);
        if i<0 then Exit;
        ActiveEditor.SetFocus ;
        ActiveEditor.Col := i-1;
    end;
    procedure sub_row;
    var i: Integer;
    begin
        i := StrToIntDef(value, -1);
        if i<0 then Exit;
        ActiveEditor.SetFocus ;
        GotoLine(i);
    end;
    procedure sub_seltext_save;
    var s: TStringList;
    begin
        s := TStringList.Create;
        try
            s.Text := edtMain.SelText ;
            s.SaveToFile(value);
        finally
            s.Free;
        end;
    end;
    procedure sub_seltext_load;
    var s: TStringList;
    begin
        s := TStringList.Create;
        try
            s.LoadFromFile(value);
            ActiveEditor.SelText := s.Text;
        finally
            s.Free;
        end;
    end;
begin
	  token := Msg.Text ;
    ShowBar(token); 
	  cmd := Trim(lowercase(convToHalf(GetToken(' ', token))));
    value := Trim(token);

    if cmd='new'		  then mnuNewClick(nil) else
    if cmd='save'		  then mnuSaveClick(nil) else
    if cmd='saveas'	  then sub_saveas else
    if cmd='open'		  then sub_open else
    if cmd='insert'	  then sub_insert else
    if cmd='row'      then sub_row else
    if cmd='col'      then sub_col else
    if cmd='seltext_save' then sub_seltext_save else
    if cmd='seltext_open' then sub_seltext_load else
    if cmd='copy'     then Clipboard.AsText := edtMain.SelText else
    if cmd='paste'    then begin ActiveEditor.SelText := Clipboard.AsText; end else
    if cmd='play'      then mnuRunClick(nil) else
    if cmd='stop'      then mnuStopClick(nil) else
    ;
end;

procedure TfrmSakuraPad.mnuShowMonitorClick(Sender: TObject);
begin
  frmPlayMonitor.Show ;
end;

procedure TfrmSakuraPad.mnuMidiPortClick(Sender: TObject);
begin
  frmMidiPort.ShowModal ;
end;

procedure TfrmSakuraPad.mnuShowPlayMonitorClick(Sender: TObject);
begin
  mnuShowPlayMonitor.Checked := not mnuShowPlayMonitor.Checked ;
end;

procedure TfrmSakuraPad.mnuSettingClick(Sender: TObject);
begin
  frmSetting.ShowModal ;  
end;

procedure TfrmSakuraPad.mnuPlayMonitorTopClick(Sender: TObject);
begin
  mnuPlayMonitorTop.Checked := not mnuPlayMonitorTop.Checked ;
  SetPlayMonitorTop;
end;

procedure TfrmSakuraPad.SetPlayMonitorTop;
begin
  if frmPlayMonitor = nil then Exit;

  if mnuPlayMonitorTop.Checked then
    frmPlayMonitor.FormStyle := fsStayOnTop
  else
    frmPlayMonitor.FormStyle := fsNormal ;
end;

procedure TfrmSakuraPad.mnuEffectPlayClick(Sender: TObject);
begin
    mnuEffectPlay.Checked := not mnuEffectPlay.Checked ;
end;

procedure TfrmSakuraPad.mnuEffectClipboardClick(Sender: TObject);
begin
    mnuEffectClipboard.Checked := not mnuEffectClipboard.Checked ;
end;

procedure TfrmSakuraPad.popMsgCopyClick(Sender: TObject);
begin
  edtError.CopyToClipboard ;
  if mnuEffectClipboard.Checked then PlayWave(WAV_PI);
end;

procedure TfrmSakuraPad.popMsgClearClick(Sender: TObject);
begin
  edtError.Clear ;
  if mnuEffect.Checked then PlayWave(WAV_PI);
end;


procedure TfrmSakuraPad.MMDone(var Msg: TMessage);
begin
  midiOut.MMDoneReceived ;
  if frmPlayMonitor.chkLog.Checked then
  begin
    log := log + 'SysEx ���M����'#13#10;
  end;
end;

procedure TfrmSakuraPad.SMFformat01Click(Sender: TObject);
var
    fname: string;
    smf: TSmfSong;
    player: TSmfCustomPlayer ;
begin
    if FileExists(TempMidiFile) = False then
    begin
        Compile ;
        if FileExists(TempMidiFile) = False then
        begin
          ShowMessage('�R���p�C���Ɏ��s���Ă��܂��B');
          Exit;
        end;
    end;

    fname := ChangeFileExt(ExtractFileName(SaveFileName), '.mid');
    if fname = '.mid' then fname := '����.mid';

    dlgSaveMidi.FileName := fname;
    if not dlgSaveMidi.Execute then Exit;

    player := TSmfCustomPlayer.Create ;
    smf := TSmfSong.Create(player);
    try
      smf.LoadFromFile(TempMidiFile);
      smf.TrackMix ;
      smf.Format := 0;
      smf.SaveToFile(dlgSaveMidi.FileName);
    finally
      smf.Free ;
      player.Free ;
    end;

end;

procedure TfrmSakuraPad.mnuCloseExClick(Sender: TObject);
begin
  //---���������I��
  makeKakikake;
  Close;
end;

procedure TfrmSakuraPad.mnuUseCloseExClick(Sender: TObject);
begin
  mnuUseCloseEx.Checked := not mnuUseCloseEx.Checked ;
end;

procedure TfrmSakuraPad.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if mnuUseCloseEx.Checked then // ���������I��
  begin
    makeKakikake;
  end else
  begin
    if IsKakikakeClose = False then // ���݂����ď��������I�����H
    begin
      if FileExists(AppPath + Kakikake) then DeleteFile(AppPath + Kakikake);
    end;
  end;
end;

procedure TfrmSakuraPad.makeKakikake;
begin
  ActiveEditor.Lines.Insert(0, '//'+SaveFileName);
  ActiveEditor.Lines.SaveToFile(AppPath + Kakikake);
  FileModify := False;
  IsKakikakeClose := True;
end;

procedure TfrmSakuraPad.mnuShowBBSClick(Sender: TObject);
begin
  OpenApp('http://oto.chu.jp/');
end;

procedure TfrmSakuraPad.mnuMML2MIDIAllClick(Sender: TObject);
begin
  frmMML2Midi.ShowModal ;
end;

procedure TfrmSakuraPad.actRunFirstExecute(Sender: TObject);
begin
  track.Position := 0;
  PlayModify := True;
  mnuRunClick(nil);
end;

procedure TfrmSakuraPad.panelHelpTopResize(Sender: TObject);
var
  x, y, w, h, cw, ch: Integer;
begin
  ProgBar.Width := panelHelpTop.Width - ProgBar.Left * 2;

  // PICTURE
  if cbarTop.Picture.Graphic <> nil then
  begin
    imgMan.Picture := nil;
    w := cbarTop.Picture.Width;
    h := cbarTop.Picture.Height ;
    cw := imgMan.Width div w + 1;
    ch := imgMan.Height div h + 1;
    for y := 0 to ch-1 do
    begin
      for x := 0 to cw-1 do
      begin
        imgMan.Canvas.Draw(w * x, h * y, cbarTop.Picture.Graphic); 
      end;
    end;
    //
    imgLeftTop.Picture := nil;
    cw := imgLeftTop.Width div w + 1;
    ch := imgLeftTop.Height div h + 1;
    for y := 0 to ch-1 do
    begin
      for x := 0 to cw-1 do
      begin
        imgLeftTop.Canvas.Draw(w * x, h * y, cbarTop.Picture.Graphic);
      end;
    end;
  end;
end;

procedure TfrmSakuraPad.mnuAutoSaveClick(Sender: TObject);
begin
  mnuAutoSave.Checked := not mnuAutoSave.Checked;
end;

procedure TfrmSakuraPad.timerAutoSaveTimer(Sender: TObject);
begin
  AutoSaveExecute;  
end;

procedure TfrmSakuraPad.AutoSaveExecute;
var
  f, s, dir: string;
begin
  //---------------------------------------
  // Auto Save Execute
  if mnuAutoSave.Checked = False then Exit;

  //---------------------------------------
  // Save
  f := ChangeFileExt(ExtractFileName(SaveFileName), '');

  s := FormatDateTime('yyyymmdd_hh', Now);
  dir := AppPath + 'temp\autosave\' + f + '~' + s + '.mml';

  ForceDirectories(ExtractFilePath(dir)); 
  ActiveEditor.Lines.SaveToFile(dir);
end;

procedure TfrmSakuraPad.mnuOpenAutoSaveClick(Sender: TObject);
begin
  OpenApp(AppPath + 'temp\autosave');
end;

procedure TfrmSakuraPad.mnuClearAutoSaveClick(Sender: TObject);
begin
  if MsgYesNo('�����ۑ������t�@�C�����폜���Ă���낵���ł����H') then
  begin
    if MsgYesNo('�폜����ƕ����ł��Ȃ��Ȃ�܂����ǂ��ł����H') then
    begin
      gui_benri.SHFileDelete(AppPath+'temp\autosave\*.mml'); 
    end;
  end;
end;

procedure TfrmSakuraPad.cmbPlaySpeedChange(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  s := cmbPlaySpeed.Text;
  i := StrToIntDef( Copy(s,1,Length(s)-1), 100 );
  SmfPlayer.TempoRate := i / 100;
  if SmfPlayer.IsPlaying then
  begin
    SmfPlayer.Stop ;
    SmfPlayer.Play ;
  end;
end;

procedure TfrmSakuraPad.cmbPlaySpeedClick(Sender: TObject);
begin
  lblBar.Caption := ('���t���x��I���ł��܂��B���݂́A' + cmbPlaySpeed.Text + '�̑����ŉ��t���܂��B'); 
end;

procedure TfrmSakuraPad.mnuSpeedCompileClick(Sender: TObject);
begin
  mnuSpeedCompile.Checked := not mnuSpeedCompile.Checked;
end;

procedure TfrmSakuraPad.actSpeedLowExecute(Sender: TObject);
begin
  cmbPlaySpeed.ItemIndex := 1;
  cmbPlaySpeedChange(nil);
end;

procedure TfrmSakuraPad.actSpeedNormalExecute(Sender: TObject);
begin
  cmbPlaySpeed.ItemIndex := 3;
  cmbPlaySpeedChange(nil);
end;

procedure TfrmSakuraPad.actSpeedHighExecute(Sender: TObject);
begin
  cmbPlaySpeed.ItemIndex := 6;
  cmbPlaySpeedChange(nil);
end;

procedure TfrmSakuraPad.mnuTenkeyClick(Sender: TObject);
begin
  mnuTenkey.Checked := not mnuTenkey.Checked;
  if mnuTenkey.Checked then frmTenkey.Show;
end;

procedure TfrmSakuraPad.mnuAddDecNumClick(Sender: TObject);
var
  s, res, sno: string;
  IncNo, no: Integer;
  p: PChar;
begin
  s := InputBox('�����l�����','�I�����ꂽ�͈͂̐��l�𑝌������܂��B', '0');
  if s = '' then Exit;
  IncNo := StrToIntDef(s, 0);
  //
  s := ActiveEditor.SelText; s := convToHalfAnk(s);
  res := '';
  p := PChar(s);
  while p^ <> #0 do
  begin
    if p^ in LeadBytes then
    begin
      res := res + p^ + (p+1)^; Inc(p, 2); Continue;
    end;
    if p^ in ['0'..'9','$'] then
    begin
      sno := p^; Inc(p);
      while p^ in ['0'..'9'] do
      begin
        sno := sno + p^; Inc(p);
      end;
      no := StrToIntDef(sno, 0);
      no := no + IncNo;
      res := res + IntToStr(no);
    end else
    begin
      res := res + p^; Inc(p);
    end;
  end;
  ActiveEditor.SelText := res;
end;

procedure TfrmSakuraPad.popInsEditClick(Sender: TObject);
begin
  lstUserDblClick(nil);
end;

procedure TfrmSakuraPad.popDefPlayClick(Sender: TObject);
var
  sInc, s, head, body: string;

  procedure play(mml: string);
  begin
    mnuStopClick(nil);

    track.Position := 0;
    mmlCompile(sInc + 'CH(' + IntToStr(FDefPlayChannel) + ');' + mml, TempMidiFile);

    mnuPlayMidiClick(nil);
  end;

begin
  // ���t
  if lstUser.ItemIndex  < 0 then Exit;
  if lstFiles.ItemIndex < 0 then Exit;

  sInc := 'Include('+lstFiles.Items[lstFiles.ItemIndex]+')'#13#10;
  s := Trim(lstUser.Items[ lstUser.ItemIndex ]);
  if s = '' then Exit;

  // ��`�t�@�C��
  if s[1] = '#' then
  begin
    s := GetToken('=', s);
    play('l1^1' + s);
    Exit;
  end;

  // ���F��`
  head := UpperCase(GetToken(' ', s));
  if head = 'ARRAY' then
  begin
    body := GetToken('=', s);
    play('Voice(' + body + '); q100 o5 l4 cdefgab>c<');
  end else
  ;
end;

procedure TfrmSakuraPad.popDefCH16Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 16 do
  begin
    TMenuItem( FindComponent('popDefCH'+ IntToStr(i)) ).Checked := False;
  end;
  FDefPlayChannel := TMenuItem(Sender).Tag;
  TMenuItem(Sender).Checked := True;
end;

procedure TfrmSakuraPad.mnuOutMidClockClick(Sender: TObject);
begin
  mnuOutMidClock.Checked := not mnuOutMidClock.Checked;
end;

procedure TfrmSakuraPad.popupShowManWebClick(Sender: TObject);
begin
    ManualOnline := True;
    barClick(nil);
end;

initialization
OleInitialize(nil);

finalization
OleUninitialize;



end.
