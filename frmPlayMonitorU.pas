unit frmPlayMonitorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, smf_play, midi_out, ExtCtrls, StdCtrls, Spin;

type
  TDrawThread = class;

  TfrmPlayMonitor = class(TForm)
    panelCC: TPanel;
    panelNoteInfo: TPanel;
    boxNoteInfo: TPaintBox;
    boxCC: TPaintBox;
    splitC: TSplitter;
    panelBottom: TPanel;
    panelCH: TPanel;
    boxCH: TPaintBox;
    panelCol: TPanel;
    imgCol: TImage;
    panelSwitch: TPanel;
    spnPort: TSpinEdit;
    lblPort: TLabel;
    scrTempo: TScrollBar;
    chkParam: TCheckBox;
    chkVolume: TCheckBox;
    chkLog: TCheckBox;
    pntTop: TPaintBox;
    pnlBottom: TPanel;
    Label1: TLabel;
    chkSysEx: TCheckBox;
    chkCtrlChg: TCheckBox;
    chkBend: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure splitCMoved(Sender: TObject);
    procedure boxCHPaint(Sender: TObject);
    procedure boxCHMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spnPortChange(Sender: TObject);
    procedure imgColClick(Sender: TObject);
    procedure scrTempoChange(Sender: TObject);
    procedure boxCCClick(Sender: TObject);
    procedure chkVolumeClick(Sender: TObject);
    procedure boxNoteInfoClick(Sender: TObject);
    procedure chkLogClick(Sender: TObject);
    procedure chkBendClick(Sender: TObject);
  private
    { Private 宣言 }
    fdraw: TDrawThread;
    UseSolo: Boolean;
  public
    { Public 宣言 }
    Player: TSmfPlayer;
    midi: TMidiOut;
    bmpKeyboard: TBitmap;
    Port: Integer;
    DrawMode: Boolean;
    procedure ColorChange;
    procedure SetSetting;
  end;

  TDrawThread = class(TThread)
  private
    cNote,
    cCC: TCanvas;
    midi: TMidiOut;
    boxCC,
    boxNote: TPaintBox;
    bmpKeyboard: TBitmap;
    WaitTime: Integer;
    PlayMon: TfrmPlayMonitor;
    fvel: array [0..15] of Byte;
    procedure drawNote; //ノート情報を表示モニター
    procedure drawCC;   //コントロールチェンジモニター
    procedure drawOption;
    procedure drawParam; //パラメーター表示
  protected
    procedure Execute; override;
  public
    constructor Create(PlayMon: TfrmPlayMonitor); virtual;
  end;

const
  mon_text: array[0..14]of string = (
    'vel',
    'pan',
    'exp',
    'vol',
    'rev',
    'cho',
    'mod',
    'bend',
    '文字色',
    '鍵盤白',
    '鍵盤黒',
    '鍵盤演奏色１',
    '鍵盤演奏色２',
    'パネル背景',
    '鍵盤の区切り'
    );
  PC_VEL  = 0;
  PC_PAN  = 1;
  PC_EXP  = 2;
  PC_VOL  = 3;
  PC_REV  = 4;
  PC_CHO  = 5;
  PC_MOD  = 6;
  PC_BEND = 7;
  PC_CHAR = 8;
  PC_WHITE= 9;
  PC_BLACK= 10;
  PC_PLAY1= 11;
  PC_PLAY2= 12;
  PC_BACK = 13;
  PC_LINE = 14;

var
  frmPlayMonitor: TfrmPlayMonitor;

implementation

uses sakurapadU, smf_unit, frmSettingU, StrUnit;

var
  pc: array[0..14]of TColor;


{$R *.dfm}

procedure TfrmPlayMonitor.FormShow(Sender: TObject);
begin
  Player := frmSakuraPad.SmfPlayer ;
  midi := Player.MidiOut ;

  //配色の読み込み
  ColorChange ;

  UseSolo := False;
  DrawMode := True;

  //
  if fdraw<>nil then Exit;
  fdraw := TDrawThread.Create(Self);
  fdraw.Priority := tpLowest ;
end;


{ TDrawThread }

constructor TDrawThread.Create(PlayMon: TfrmPlayMonitor);
var
  i: Integer;
begin
  Self.PlayMon := PlayMon;
  boxNote      := PlayMon.boxNoteInfo ;
  boxCC        := PlayMon.boxCC ;
  Self.midi    := PlayMon.midi ;
  cNote        := boxNote.Canvas ;
  cCC          := boxCC.Canvas ;
  Self.bmpKeyboard := PlayMon.bmpKeyboard;
  WaitTime     := frmSakuraPad.ini.PlayerDrawWaitTime ;

  PlayMon.Caption := 'テキスト音楽「サクラ」 - 演奏モニター';
  // 配色の読み込み
  for i:=0 to High(frmSakuraPad.ini.MonColor) do
  begin
    pc[i] := frmSakuraPad.ini.MonColor[i];
  end;

  inherited Create(False);
  FreeOnTerminate := True;
end;


procedure TDrawThread.drawCC;
var
  bmp: TBitmap;
  c: TCanvas;
  pwidth, pheight: Integer;
  cheight,cwidth, cw: Extended;
  i: Integer;
  port:Integer;

  function Velocity(ch: Byte): Integer;
  var i: Integer;
  begin
    Result := 0;
    for i:=0 to 127 do
    begin
      if midi.NoteStatus[PlayMon.Port, ch, i] > 0 then
      begin
        Result := midi.NoteStatus[PlayMon.Port, ch, i];
        Break;
      end;
    end;
    fvel[ch] := Result;
  end;

  procedure drawC(xx,yy,val,col: Integer; IsBend: Boolean);
  var
    cz: Extended;
    x1,y1,y2: Integer;
  begin
    //キャンバスの初期化
    c.Pen.Style := psSolid ;
    c.Pen.Color := clGray;
    c.Brush.Color := pc[13];

    y1 := Trunc( yy*cheight );
    y2 := Trunc( (yy+1)*cheight );
    x1 := Trunc( xx*cwidth );
    c.Rectangle( x1, y1,
      Trunc((xx+1)*cwidth)+1, y2+1);

    //グラフ描画
    if IsBend then val := val div 128;
    cz := cw * val;
    c.Pen.Style := psClear ;
    c.Brush.Color := col;
    c.Rectangle( x1+1,y1+1, Trunc(x1+cz),y2+1);
  end;

  procedure drawC2(yy,val,col: Integer);
  var
    ww,cz: Extended;
    x1,y1,y2: Integer;
    i: Integer;
  begin
    //キャンバスの初期化
    c.Pen.Style := psSolid ;
    c.Pen.Color := clGray;
    c.Brush.Color := pc[13];

    y1 := Trunc( yy*cheight*2 );
    y2 := Trunc( (yy+1)*cheight*2 );
    c.Rectangle( 0, y1, Trunc(pwidth), y2+1);

    //グラフ描画
    cz := pwidth * (val/128) ;
    c.Pen.Style := psClear ;
    c.Brush.Color := col;
    c.Rectangle( 0,y1+1, Trunc(cz),y2+1);

    //罫線
    ww := pwidth / 8;
    c.Pen.Color := pc[PC_BACK];
    c.Pen.Style := psSolid;
    for i:=1 to 7 do
    begin
      x1 := Trunc(ww*i);
      c.MoveTo(x1,y1+1);
      c.LineTo(x1,y2);
    end;
  end;

begin
  port := PlayMon.Port ;
  bmp := TBitmap.Create ;
  try
    c := bmp.Canvas ;
    pwidth  := boxCC.Width ;
    pheight := boxCC.Height ;
    bmp.Width  := pwidth;
    bmp.Height := pheight;
    cheight := pheight /  32; //1CH * 2
    cwidth  := pwidth  /   4;
    cw      := cwidth  / 128;

    for i:=0 to 15 do
    begin
      if PlayMon.DrawMode then
      begin
        drawC2(i,Trunc(128 * (Velocity(i)/128) * (midi.CCStatus[port,i,11]/128) * (midi.CCStatus[port,i,7]/128)),pc[PC_PLAY1 + (i mod 2)]);
      end else
      begin
        //velocity
        drawC(0,i*2,   Velocity(i),             pc[0], False);
        //pan
        drawC(0,i*2+1, midi.CCStatus[port,i,10],pc[1], False);
        //Exp
        drawC(1,i*2,   midi.CCStatus[port,i,11],pc[2], False);
        //Vol
        drawC(1,i*2+1, midi.CCStatus[port,i, 7],pc[3], False);
        //Rev
        drawC(2,i*2,   midi.CCStatus[port,i,91],pc[4], False);
        //Cho
        drawC(2,i*2+1, midi.CCStatus[port,i,93],pc[5], False);
        //Mod
        drawC(3,i*2,   midi.CCStatus[port,i, 1],pc[6], False);
        //PB
        drawC(3,i*2+1, (midi.PBStatus[port,i]) ,pc[7], True);
      end;
    end;

    //チャンネル区切り線
    c.Pen.Color := clBlack;
    c.Pen.Style := psSolid ;
    c.Pen.Width := 1;
    for i:=1 to 15 do
    begin
      c.MoveTo(0,Trunc(cheight*i*2));
      c.LineTo(pwidth, Trunc(i*2*cheight));
    end;

    cCC.Lock ;
    cCC.Draw(0,0,bmp);
    cCC.UnLock ;

  finally
    bmp.Free;
  end;
end;

procedure TDrawThread.drawNote;
const                         //c   d   e f   g   a   b
  keyb: array [0..11] of Byte = (0,1,0,1,0,0,1,0,1,0,1,0);
  keyw: array [0..11] of Byte = (0,0,1,1,2,3,3,4,4,5,5,6);

var
  c: TCanvas;
  pwidth, pheight: Integer;
  cheight: Extended;
  bmp: TBitmap;
  port: Integer;

  procedure drawWaku;
  var
    x, y: Integer;
    ww: Extended;
    ccol,col,o,k,xx: Integer;
  begin
    ww := pwidth / 66;

    for y := 0 to 15 do
    begin

      ccol := pc[11 + (y mod 2)];

      for x:=0 to 127 do
      begin
        col := midi.NoteStatus[port, y, x];
        if col=0 then continue;

        o := x div 12;
        k := x mod 12;
        xx := o*7+keyw[k];

        if keyb[k] = 0 then
        begin //白鍵盤
          if col = 0 then col := pc[9] else col := ccol;
          c.Pen.Color := col;
          c.Brush.Color := col;
          c.Rectangle(Trunc(xx*ww)+1, Trunc((y+0.5)*cheight+1),
            Trunc((xx+1)*ww), Trunc((y+1)*cheight));
        end;
      end;
      for x:=0 to 127 do
      begin
        col := midi.NoteStatus[port, y, x];
        if col=0 then continue;

        o := x div 12;
        k := x mod 12;
        xx := o*7+keyw[k];

        if keyb[k] = 0 then
        begin //白鍵盤
        end else
        begin //黒鍵盤
          if col = 0 then col := pc[10] else col := ccol;
          c.Pen.Color := pc[10];
          c.Brush.Color  := col;
          c.Rectangle(Trunc((xx+0.7)*ww), Trunc(y*cheight),
            Trunc((xx+1.3)*ww+1), Trunc((y+0.5)*cheight)+1);
        end;
      end;
    end;
  end;

begin
  if PlayMon.chkParam.Checked then
  begin
    drawParam; Exit;
  end;

  port := PlayMon.Port ;
  bmp := TBitmap.Create ;
  try
    pwidth  := boxNote.Width  ;
    pheight := boxNote.Height ;
    cheight := pheight / 16;

    bmp.Width := pwidth;
    bmp.Height := pheight;

    c := bmp.Canvas ;
    c.Pen.Style := psSolid ;

    c.Draw(0,0,bmpKeyboard);
    drawWaku;

    cNote.Lock ;
    cNote.Draw(0,0,bmp);
    cNote.UnLock ;

  finally
    bmp.Free;
  end;
end;

procedure TDrawThread.drawOption;
var
  s, u: string;
  b, timebase, oya, ko, h: Integer;
  mes, beat, sbeat, step, pos: Integer;
begin
  //
  if PlayMon.scrTempo.Position <> PlayMon.Player.Tempo then
  begin
    if PlayMon.scrTempo.Max <= PlayMon.Player.Tempo - 10 then PlayMon.scrTempo.Max := Trunc( PlayMon.Player.Tempo * 1.3 );
    PlayMon.scrTempo.Position := PlayMon.Player.Tempo ;
  end;

  //
  if PlayMon.Player.MetaText <> '' then
  begin
    s := PlayMon.Player.MetaText;
    s := GetToken(#13#10, s);
    u := PlayMon.Caption ;
    if  u <> s then
    begin
      PlayMon.Caption := s;
    end;
  end;

  // 演奏タイムの計算
  oya      := PlayMon.Player.TimeSigOya ;
  ko       := PlayMon.Player.TimeSigKo  ;
  timebase := PlayMon.Player.Song.TimeBase ;
  pos      := PlayMon.Player.Position ;

  try
    b := Trunc( timebase * (4 / oya) );
    if b <> 0 then
    begin
      step  :=  pos mod b;
      sbeat :=  pos div b;
    end else
    begin
      step := 0;
      sbeat := 0;
    end;
    beat  :=  sbeat mod ko;
    mes   :=  sbeat div ko;
    // タイムの表示
    s     := Format('%.03d:%.03d:%.03d',[mes+1,beat+1,step]);
  except
    s := '---:---:---';
  end;
  // テンポの表示
  s     := s + Format('   Tempo%.03d',[PlayMon.Player.Tempo]);

  with PlayMon.pntTop do
  begin
    Canvas.Font.Color := clBlack;
    Canvas.Font.Size := 8;
    h := Canvas.TextHeight('Z');
    Canvas.Font.Name   := 'ＭＳ　ゴシック';
    Canvas.Pen.Color   := clWhite;
    Canvas.Brush.Color := clWhite;
    Canvas.Rectangle(0,0,Width,height);
    Canvas.TextOut(4,((height-h)div 2),s);
  end;
end;

procedure TDrawThread.drawParam;
var
  h_ch: Extended;
  w: Extended;
  i,port: Integer;
  bmp: TBitmap;

  procedure drawHeader;
  var
    i,x,y,cw: Integer;
  const
    s: array[0..10]of string = (
    'CH',
    '@',
    'VOL',
    'EXP',
    'PAN',
    'MOD',
    'REV',
    'CHO',
    'P.B',
    'VEL',
    '---'
    );
  begin
    y := 0;
    for i:=0 to high(s) do
    begin
      x := Trunc(i * w);
      with bmp.Canvas do
      begin
        cw := TextWidth(s[i]);
        TextOut(x+Trunc((w-cw)-2), y+1, s[i]);
      end;
    end;

  end;

  procedure drawc(col,row:Integer; msg: string; val: Integer=MaxInt);
  var
    x,y,cw: Integer;
    s: string;
  begin
    x := Trunc(col * w)+2;
    y := Trunc((row+1) * h_ch)+1;

    with bmp.Canvas do
    begin
      if val<>MaxInt then
      begin
        s := IntToStr(val);
        cw := TextWidth(s);
        TextOut(x+Trunc(w-cw)-2,y, s);
      end else begin
        TextOut(x,y, msg);
      end;
    end;
  end;

  function NoteName(ch: Integer):string;
  var
    i: Integer;
  const
    nn: array [0..11] of string = (
    'c','c#','d','d#','e','f','f#','g','g#','a','a#','b'
    );
  begin
    Result := '';
    for i:=0 to 127 do
    begin
      if midi.NoteStatus[Port, ch, i] > 0 then
      begin
        Result := Result + nn[i mod 12] + IntToStr(i div 12);
      end;
    end;
  end;

begin
  // データの詳細表示
  h_ch := boxNote.Height / 17;
  w    := boxNote.Width / 12;
  port := PlayMon.Port ;

  //ちらつき防止のため、あらかじめＢＭＰに描きキャンパスに転送する
  bmp := TBitmap.Create ;
  try

    bmp.Width := boxNote.Width ;
    bmp.Height := boxNote.Height ;

    // Clear
    with bmp.Canvas do
    begin
      Brush.Color := pc[PC_BACK];
      Pen.Color   := pc[PC_BACK];
      Rectangle(0,0, boxNote.Width, boxNote.Height);
      Font.Color :=  pc[PC_CHAR];
      Font.Size := 8;
      Font.Name := 'ＭＳ　ゴシック';
    end;
    //罫線
    with bmp.Canvas do
    begin
      for i:=0 to 16 do //横線
      begin
        Brush.Color := pc[PC_PLAY2 - (i mod 2)];
        Pen.Color   := Brush.Color;
        Rectangle(0, Trunc(h_ch*i),
          bmp.Width, Trunc(h_ch*(i+1)));
      end;

      Pen.Color   := pc[PC_CHAR];
      for i:=1 to 1 do //縦線
      begin
        MoveTo(Trunc(w*i)+2,0);
        LineTo(Trunc(w*i)+2, bmp.Height);
      end;
      Brush.Style := bsClear;
    end;

    drawHeader;

    for i:=0 to 15 do
    begin
      drawc( 0, i, 'CH', i+1);
      drawc( 1, i, '@',  midi.PCStatus[Port, i]+1);
      drawc( 2, i, 'V',  midi.CCStatus[Port, i,  7]);
      drawc( 3, i, 'EP', midi.CCStatus[Port, i, 11]);
      drawc( 4, i, 'PAN',midi.CCStatus[Port, i, 10]);
      drawc( 5, i, 'MOD',midi.CCStatus[Port, i,  1]);
      drawc( 6, i, 'REV',midi.CCStatus[Port, i, 91]);
      drawc( 7, i, 'CHO',midi.CCStatus[Port, i, 93]);
      drawc( 8, i, 'PB' ,midi.PBStatus[Port, i]-8192);
      drawc( 9, i, 'v'  ,fvel[i]);
      drawc(10, i, NoteName(i));
    end;
    boxNote.Canvas.Draw(0,0,bmp);
  finally
    bmp.Free;
  end;
end;

procedure TDrawThread.Execute;
begin
  while not Terminated do
  begin
    Synchronize(DrawNote);
    Synchronize(DrawCC);
    Synchronize(DrawOption);
    sleep(WaitTime);
  end;
end;

procedure TfrmPlayMonitor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  fdraw.Terminate ;
  fdraw := nil;
  //while not fdraw.Terminated do sleep(1);
end;

procedure TfrmPlayMonitor.FormCreate(Sender: TObject);
begin
  bmpKeyboard := TBitmap.Create ;
  frmSakuraPad.ini.LoadForm(Self);
  Port := 0;
  fdraw := nil;
  DrawMode := False;
  frmSakuraPad.SetPlayMonitorTop;
end;

procedure TfrmPlayMonitor.FormDestroy(Sender: TObject);
begin
  bmpKeyboard.Free ;
  frmSakuraPad.ini.SaveForm(Self); 
end;

procedure TfrmPlayMonitor.FormResize(Sender: TObject);

  //キーボードの雛型を描画して、bmpKeyboard に記録
  procedure drawKeyboard;
  const                         //c   d   e f   g   a   b
    keyb: array [0..11] of Byte = (0,1,0,1,0,0,1,0,1,0,1,0);
    keyw: array [0..11] of Byte = (0,0,1,1,2,3,3,4,4,5,5,6);

  var
    c: TCanvas;
    pwidth, pheight: Integer;
    cheight: Extended;

    procedure drawWaku;
    var
      x, y: Integer;
      ww: Extended;
      o,k,xx: Integer;
    begin
      ww := pwidth / 66;

      for y := 0 to 15 do
      begin

        for x:=0 to 127 do
        begin
          o := x div 12;
          k := x mod 12;
          xx := o*7+keyw[k];

          if keyb[k] = 0 then
          begin //白鍵盤
            c.Pen.Color := pc[14];
            c.Brush.Color := pc[9];
            c.Rectangle(Trunc(xx*ww), Trunc(y*cheight),
              Trunc((xx+1)*ww)+1, Trunc((y+1)*cheight)+1);
          end;
        end;

        for x:=0 to 127 do
        begin
          o := x div 12;
          k := x mod 12;
          xx := o*7+keyw[k];

          if keyb[k] = 0 then
          begin //白鍵盤
          end else
          begin //黒鍵盤
            c.Pen.Color    := pc[10];
            c.Brush.Color  := pc[10];
            c.Rectangle(Trunc((xx+0.7)*ww), Trunc(y*cheight),
              Trunc((xx+1.3)*ww+1), Trunc((y+0.5)*cheight)+1);
          end;
        end;
      end;
    end;
  begin
    bmpKeyboard.Width := boxNoteInfo.Width ;
    bmpKeyboard.Height := boxNoteInfo.Height ;
    pwidth := bmpKeyboard.Width ;
    pheight:= bmpKeyboard.Height ;
    cheight := pheight / 16;

    c := bmpKeyboard.Canvas ;
    c.Pen.Style := psSolid ;

    drawWaku;
  end;

  procedure drawColorDescript;
  var i:Integer; w,h: Extended;
  begin
    imgCol.Picture := nil;
    w := imgCol.Width / 4;
    h := imgCol.Height / 2;
    with imgCol.Canvas do begin
      Pen.Color   := clWhite;
      Brush.Color := clWhite;
      Rectangle(0,0,imgCol.Width,imgCol.Height);
      Font.Name := 'ＭＳ　Ｐゴシック';
      Font.Size := 7;
      Font.Color := pc[8];
      for i:=0 to 7 do
      begin
        Pen.Color := pc[i];
        Brush.Color := pc[i];
        Rectangle(Trunc((i div 2)*w),Trunc((i mod 2)*h),
          Trunc(((i div 2)+1)*w), Trunc(((i mod 2)+1)*h));
        TextOut(Trunc(w*(i div 2))+2, Trunc((i mod 2)*h), mon_text[i]);
      end;
    end;
  end;

begin
  drawKeyboard;
  drawColorDescript;
  //コントロールの配色
  pntTop.Canvas.Pen.Color   := clWhite;
  pntTop.Canvas.Brush.Color := clWhite;
  pntTop.Canvas.Rectangle(RECT(0,0,pntTop.Width,pntTop.Height));
end;

procedure TfrmPlayMonitor.splitCMoved(Sender: TObject);
begin
  //panelCol.Width := SplitC.Left ;
  frmPlayMonitor.Resize ;
end;

procedure TfrmPlayMonitor.boxCHPaint(Sender: TObject);
var
  h: Extended;
  i,cw,ch,w: Integer;
  s: string;
begin
  h := boxCH.Height / 16;
  w := boxCH.Width ;
  with boxCH.Canvas do
  begin
    Font.Color := pc[PC_CHAR];
    Font.Size := 8;
    Pen.Color := clWhite;
    Pen.Width := 2;

    cw := TextWidth('Z');
    ch := TextHeight('Z');

    for i:=0 to 15 do
    begin
      s := IntToStr(i+1);
      if midi.ChannelMute[Port,i] then
      begin
        Brush.Color := pc[9];
        Rectangle(0, Trunc(i*h),
          boxCH.Width, Trunc((i+1)*h)+1);
      end else
      begin
        Brush.Color := pc[11 + (i mod 2)];
        Rectangle(0, Trunc(i*h),
          boxCH.Width, Trunc((i+1)*h)+1);
        TextOut(Trunc((w-cw*Length(s))/2),(Trunc(i*h)+Trunc((h-ch)/2)), IntToStr(i+1));
      end;
    end;
    Pen.Width := 1;
  end;
end;

procedure TfrmPlayMonitor.boxCHMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  h: Extended;
  i,j: Integer;
begin
  h := boxCH.Height / 16;
  i := Trunc( Y / h );

  if Button = mbLeft then
  begin
    //ミュート
    midi.OutAllNoteOffPort(i, port);
    midi.ChannelMute[ Port, i ] := not midi.ChannelMute[ Port, i ];
  end else
  begin
    //ソロ
    if UseSolo then
    begin
      // ソロ = off
      for j:=0 to 15 do
      begin
          midi.ChannelMute[ Port, j ] := False;
      end;
    end else
    begin
      // ソロ = on
      for j:=0 to 15 do
      begin
        if j<>i then
        begin
          midi.OutAllNoteOffPort(j, port);
          midi.ChannelMute[ Port, j ] := True;
        end else
        begin
          midi.ChannelMute[ Port, j ] := False;
        end;
      end;
    end;
    UseSolo := not UseSolo;
  end;
  boxCHPaint(nil);
end;

procedure TfrmPlayMonitor.spnPortChange(Sender: TObject);
begin
  Port := spnPort.Value ;
end;

procedure TfrmPlayMonitor.imgColClick(Sender: TObject);
begin
  frmSetting.page.ActivePageIndex := 2;{配色}
  frmSetting.ShowModal ;
end;

procedure TfrmPlayMonitor.scrTempoChange(Sender: TObject);
begin
  Player.Tempo := scrTempo.Position ;
end;

procedure TfrmPlayMonitor.ColorChange;
var i: Integer;
begin
  // 配色の読み込み
  for i:=0 to High(frmSakuraPad.ini.MonColor) do
  begin
    pc[i] := frmSakuraPad.ini.MonColor[i];
  end;
end;

procedure TfrmPlayMonitor.boxCCClick(Sender: TObject);
begin
  DrawMode := not DrawMode;
  chkVolume.Checked := DrawMode;
end;

procedure TfrmPlayMonitor.chkVolumeClick(Sender: TObject);
begin
  DrawMode := chkVolume.Checked ;
end;

procedure TfrmPlayMonitor.boxNoteInfoClick(Sender: TObject);
begin
  chkParam.Checked := not chkParam.Checked ;
end;

procedure TfrmPlayMonitor.chkLogClick(Sender: TObject);
begin
  Player.UseLog := chkLog.Checked ;
end;

procedure TfrmPlayMonitor.chkBendClick(Sender: TObject);
begin
  Player.Stop ;
  SetSetting;
  Player.Play ;
end;

procedure TfrmPlayMonitor.SetSetting;
begin
  with frmSakuraPad do
  begin
    SmfPlayer.UseSysEx    := frmPlayMonitor.chkSysEx.Checked ;
    SmfPlayer.UseCtrlChg  := frmPlayMonitor.chkCtrlChg.Checked ;
    SmfPlayer.UseBend     := frmPlayMonitor.chkBend.Checked ;
  end;
end;

end.
