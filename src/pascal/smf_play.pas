unit smf_play;

interface
uses
  SysUtils, Classes, Windows, smf_unit, mmsystem, gui_benri;
{
  Clock の計算
    Timebase = 四分音符分解能
    Tempo    = 一分間の四分音符数
    1clock   = 60000msec/Tempo/Timebase
}

type
  // プレイヤー（演奏を司るクラス）
  TSmfPlayer = class;

  TMidiThread = class(TThread)
  private
    FEventIndex: Integer;
    FStepInterval: Extended;
    FBaseTime: DWORD;
    FBaseTimeRevision: Integer;
    FWaitTime: DWORD;
    FMidiClockNextStep: Integer;
    FMidiClockCount: Integer;
    procedure UseTimeGetTime;
    procedure MidiOutProcTimeGetTime;
    procedure TempoChange(vTempo: Integer);
    procedure SetTempoRate(const Value: Extended);
  protected
    FPlayer: TSmfPlayer;
    FTempo: Integer;
    FTempoRate: Extended;
    FSong: TSmfSong;
    FTrack: TSmfTrack;
    procedure Execute; override;
  public
    UseSysEx: Boolean;
    UseCtrlChg: Boolean;
    UseBend: Boolean;
    NowTime: Integer;
    NowStep: Integer;
    constructor Create(Player: TSmfPlayer); virtual;
    property TempoRate: Extended read FTempoRate write SetTempoRate;
  end;

  ESmfPlayer = class(Exception);
  TSmfPlayer = class(TSmfCustomPlayer)
  private
    FIsPlaying: Boolean;
    function GetLength: Integer;
  protected
    MidiThread: TMidiThread;
  public
    UseLog: Boolean;
    UseMidiClock: Boolean;
    UseRepeatPlay : Boolean;
    //
    UseSysEx, UseCtrlChg, UseBend: Boolean;
    //
    WaitTime: Byte;    //プレイヤーの負荷 [ 1(重) <---> x(軽) ] (ミリ秒単位で指定する)
    Position: Integer; //演奏開始位置
    Tempo: Integer;
    TempoRate: Extended;
    property IsPlaying: Boolean read FIsPlaying;
    property Length: Integer    read GetLength;
    procedure Open;    //標準のポートを開く / 細かく指定したい場合は、 MidiOut.OpenPort を使う
    procedure Close;   //標準のポートを閉じる
    procedure Play;
    procedure Stop;
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
    constructor Create; override;
  end;

var
  log: string;

implementation

{ TSmfPlayer }

procedure TSmfPlayer.Close;
begin
  MidiOut.Close ;
end;

constructor TSmfPlayer.Create;
begin
  inherited;
  WaitTime := 5{msec};
  UseLog := False;
  UseMidiClock := True;
  UseRepeatPlay := False;
  Position := 0;

  //
  UseSysEx := True;
  UseCtrlChg := True;
  UseBend := True;
  //
  TempoRate := 1;
end;

function TSmfPlayer.GetLength: Integer;
begin
  Result := 0;
  if Song.Count = 0 then Exit;
  if Song.Tracks[0].Count = 0 then Exit;
  Result := Song.Tracks[0].Events[Song.Tracks[0].Count -1].Time;
end;

procedure TSmfPlayer.LoadFromFile(FileName: string);
begin
  Song.LoadFromFile(FileName);
  Song.SetDelay(AppPath + 'sakura_player.ini');
  Song.TrackMix ;
end;

procedure TSmfPlayer.Open;
begin
  if False = MidiOut.Open(-1) then raise ESmfPlayer.Create('MIDIポートが開けません。');
end;

procedure TSmfPlayer.Play;
begin
  if FIsPlaying then Exit;

  //イベントが０なら演奏できない
  if Song.Count = 0 then Exit;
  if Song.Tracks[0].Count = 0 then Exit;

  MidiThread := TMidiThread.Create(Self);
  MidiThread.Priority   := tpTimeCritical;
  //
  MidiThread.UseSysEx   := UseSysEx;
  MidiThread.UseCtrlChg := UseCtrlChg;
  MidiThread.UseBend    := UseBend;
  MidiThread.TempoRate  := TempoRate;
  //
  FIsPlaying := True;
end;

procedure TSmfPlayer.SaveToFile(FileName: string);
begin
  Song.SaveToFile(FileName);
end;

procedure TSmfPlayer.Stop;
begin
  FIsPlaying := False;
  MidiOut.Panic;
  if UseMidiClock then
  begin
    MidiOut.OutShortMsgE($FC,0,0);
  end;
  MidiThread.Terminate ;
end;

{ TMidiThread }

constructor TMidiThread.Create(Player: TSmfPlayer);

  procedure SetPosition;
  var
    Event: TSmfEvent;

    procedure PreSendEvent;
    var m: TSmfMeta;
    begin
      if (Event.ClassType <> TSmfNoteOff)and(Event.ClassType <> TSmfNoteOn)and(Event.ClassType <> TSmfSysEx) then
      begin
        if (Event.ClassType = TSmfMeta) then
        begin
          m := TSmfMeta(Event);
          if m.MetaType = META_TEMPO then TempoChange(m.AsTempo);
        end else
          Event.Send ;
      end;
    end;

  begin
    FEventIndex := 0;
    Event := FTrack.Events[0];
    PreSendEvent;
    while Player.Position > Integer(Event.Time) do
    begin
      Inc(FEventIndex);
      if FTrack.Count <= FEventIndex then //インデックスが演奏より後ろの場合
      begin
        FEventIndex := FEventIndex -1; Exit;
      end;
      Event := FTrack.Events[FEventIndex];
      PreSendEvent;
    end;
    FBaseTime := DWORD( FBaseTime - Trunc( FStepInterval * FPlayer.Position ));

    // MIDI CLOCK
    FMidiClockCount := FSong.TimeBase div 24;
    FMidiClockNextStep := Trunc(Player.Position div FMidiClockCount) * FMidiClockCount + FMidiClockCount;
    if FPlayer.UseMidiClock then
    begin
      FPlayer.MidiOut.OutShortMsgE($FA, 0,0);
    end;
  end;

begin
  //変数設定
  UseSysEx := True;
  UseCtrlChg := True;
  UseBend := True;
  //
  FPlayer := Player;
  FSong   := FPlayer.Song ;
  FTrack  := FSong.Tracks[0];
  if Player.InitTempo < 30 then Player.InitTempo := 120;
  FTempo := FPlayer.InitTempo ;
  FTempoRate := 1;

  FPlayer.Tempo := Trunc(FTempo * FTempoRate);
  FStepInterval := 60000 / {tempo}Player.InitTempo / FSong.TimeBase;

  FBaseTime := timeGetTime;
  FBaseTimeRevision := 0;
  FWaitTime := FPlayer.WaitTime ;
  if FStepInterval = 0 then FStepInterval := 5.2;
  if FWaitTime = 0 then FWaitTime := 1;

  // 頭だし
  SetPosition;

  //ログ記録用
  if FPlayer.UseLog then
  begin
    Log := 'stime/etime(+delay) - event status'#13#10;
  end;

  inherited Create(False);
  FreeOnTerminate := True;
end;

procedure TMidiThread.Execute;
begin
  UseTimeGetTime;
end;


procedure TMidiThread.MidiOutProcTimeGetTime;
var
  Event: TSmfEvent;

  procedure SendEvent;
  var motari: Integer;
  begin
      //todo: イベント送出
      motari := Trunc(Nowtime - Int64(Event.Time)* FStepInterval) ; //もたり具合を計算
      if motari >= 300{msec} then Exit;

      //LOG
      if FPlayer.UseLog then
      begin
        NowStep := Trunc(NowTime / FStepInterval);
        log := log + Format('%5d(+%4dm) - 0x%2x'#13#10,[NowStep, motari, Event.Event]);
        if Length(log) > 4096 then
        begin
          log := Copy(log, Length(log)-4096+1, 4096);
        end;
      end;

      if (Event.ClassType = TSmfSysEx)and(UseSysEx = False) then Exit;
      if (Event.ClassType = TSmfControlChange)and(UseCtrlChg = False) then Exit;
      if (Event.ClassType = TSmfPitchBend)and(UseBend = False) then Exit;

      if Event.ClassType = TSmfMeta then
      begin
        if TSmfMeta(Event).MetaType = META_TEMPO then
        begin
          TempoChange(TSmfMeta(Event).AsTempo);
        end else
          Event.Send ;
      end else
      begin
        if FPlayer.Tempo <> FTempo then TempoChange(FPlayer.Tempo);
        Event.Send ;
      end;
  end;

  procedure EndOfTrack;
  begin
    if FPlayer.UseRepeatPlay = False then
    begin
      FPlayer.FIsPlaying := False;
      Terminate;
      Exit;
    end else
    begin
      FBaseTime := timeGetTime;
      FBaseTimeRevision := 0;
      FEventIndex := 0;
    end;
  end;

begin
  NowTime := timeGetTime - FBaseTime; // 実時間
  Inc(NowTime, FBaseTimeRevision);
  NowStep := Trunc(NowTime / FStepInterval);
  FPlayer.Position := NowStep;

  Event := FTrack.Events[FEventIndex];

  // MIDI Clock
  if (FPlayer.UseMidiClock)and(NowStep >= FMidiClockNextStep) then
  begin
    Inc(FMidiClockNextStep, FMidiClockCount);
    FPlayer.MidiOut.OutShortMsgE($F8, 0, 0);
  end;

  while Integer(Event.Time) <= NowStep do
  begin
    SendEvent;
    Inc(FEventIndex);
    if FEventIndex >= FTrack.Count then
    begin
      //最後まで演奏した
      EndOfTrack; Exit;
    end;
    // 次のイベントをチェック
    Event := FTrack.Events[FEventIndex]; //次回送信するイベント
    if Integer(Event.Time) <= NowStep then
    begin
      NowTime := timeGetTime - FBaseTime; // 実時間を計測し直す（もたり対策）
      Inc(NowTime, FBaseTimeRevision);
    end;
  end;
end;

procedure TMidiThread.SetTempoRate(const Value: Extended);
begin
  FTempoRate := Value;
  TempoChange(FTempo);
end;

procedure TMidiThread.TempoChange(vTempo: Integer);
begin
  // テンポチェンジによる実時間との差を計測し、FBaseTimeRevision に記録
  vTempo := Trunc(vTempo * TempoRate);

  FStepInterval := 60000 / vTempo / Integer(FSong.TimeBase);
  if FStepInterval <= 0 then FStepInterval := 5.2;

  NowTime := timeGetTime - FBaseTime; // 実時間
  FBaseTimeRevision := Trunc(NowStep * FStepInterval) - NowTime;
  Inc(NowTime, FBaseTimeRevision);

  // 現在イベントの再計算
  NowStep := Trunc(NowTime / FStepInterval);

  // MidiClock(24/４分音符) || 1step = TimeBase / 24
  FMidiClockCount := FSong.TimeBase div 24;
  FMidiClockNextStep := Trunc(NowStep div FMidiClockCount) * FMidiClockCount + FMidiClockCount;

  // テンポを外部に知らせる場合
  FPlayer.Tempo := vTempo ;
  FTempo := vTempo;
end;

procedure TMidiThread.UseTimeGetTime;
begin
  timeBeginPeriod(FWaitTime); //タイマーの精度を設定

  try
  try
    //演奏終了まで繰り返し
    while not Terminated do
    begin
      MidiOutProcTimeGetTime; //MIDIイベントの送出
      Sleep(FWaitTime); //OSの負荷を減らすため
    end;
  except
    raise;
  end;

  finally
    timeEndPeriod(FWaitTime); //タイマーの精度を元に戻す
  end;
end;

end.
