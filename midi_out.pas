unit midi_out;

interface
uses Windows,  MMSystem, Classes, SysUtils, Forms;

const
  HEAP_ZERO_MEMORY  = $00000008;
  HEAP_NO_SERIALIZE = $00000001;
  MAX_PORT = 6;


type
  pDWORD = ^DWORD;
  pWORD  = ^WORD;

  (* SMF の為のレコード *)
  TSMF_MThd = record
    MThd    : Array[0..3]of Char;
    Count   : DWORD;
    Format  : WORD;
    TrkCount: WORD;
    TimeBase: WORD;
  end;

  TSMF_MTrk = record
    MTrk  :Array[0..3]of Char;
    Count :DWORD;
  end;

  (* ShortMsg出力用レコード *)
  TMidiShortMsg = record
    Status,
    Data1,
    Data2,
    NoData : Byte;
  end;

  (* 基本的なMIDI出力クラス *)
  EMidiOut = class(Exception);
  TMidiOut = class
  private
    procedure ResetNoteStatus;
  protected
    FIsOutDevOpen:Boolean;
    hMIDIOUT2:Array [0..MAX_PORT-1] of HMIDIOUT;
    LongMsgDone: Boolean;
  public
    CurPORT : Integer;
    LogStr, ErrMsg : string;
    UseLog : Boolean;
    CallBackWindowHandle: THandle; // SysEx 送信用
    ChannelMute: array [0..MAX_PORT-1,0..15] of Boolean;
    NoteStatus: array [0..MAX_PORT-1, 0..15, 0..127] of Byte;
    CCStatus: array[0..MAX_PORT-1,0..15,0..127] of Byte;
    PBStatus: array[0..MAX_PORT-1,0..15] of Integer;
    PCStatus: array[0..MAX_PORT-1,0..15] of Byte;
    constructor Create;
    destructor Destroy; override;
    function Open(DeviceID:Integer):Boolean; // SysEx を使う場合は、ポートを開く前に、CallBackWindowHandle をセットしておくこと
    function OpenPort(DeviceID, PortNo: Integer):Boolean;
    function Close:Boolean;
    function CloseAll: Boolean;
    function ClosePort(PortNo: Integer):Boolean;
    procedure MMDoneReceived; // SysExを使う場合でMM_MOM_DONEを受け取ったらこの関数を呼ぶこと
    function OutShortMsg(msg:TMidiShortMsg):Boolean;
    function OutShortMsgPORT(msg:TMidiShortMsg; portNo:Integer):Boolean;
    function OutShortMsgE(status, dat1, dat2:Byte):Boolean;
    function OutShortMsgEPORT(status, dat1, dat2:Byte; portNo:Integer):Boolean;
    function OutShortMsgAllPort(status, dat1, dat2:Byte):Boolean;
    procedure OutRPN(ch,msb,lsb,value:Integer);
    procedure OutNRPN(ch,msb,lsb,value:Integer);
    procedure OutBned(ch, value:Integer);
    procedure OutCtrlChg(ch, no, value:Integer);
    procedure OutProgramChange(ch, no:Integer);
    procedure OutNoteOn(ch, no, val:Integer);
    procedure OutNoteOff(ch, no, val:Integer);
    procedure OutAllNoteOff(ch:Integer);
    procedure OutAllNoteOffPort(ch:Integer; port: Integer);
    procedure OutResetCtrlPort(ch:Integer; port: Integer);
    function OutLongMsg(data: PBYTE; size: Integer): Boolean;
    function OutLongMsgPORT(data: PBYTE; size, portNo: Integer): Boolean;
    function OutSysEx(pSysex:Pointer; BufferSize: Integer):Boolean;
    function OutSysExPORT(pSysex:Pointer; BufferSize, portNo: Integer):Boolean;
    procedure OutXGReset(DevNo:Integer);
    procedure OutGSReset(DevNo:Integer);
    procedure OutGMReset;
    procedure Panic; //すべての音を消音する
    property IsOutDevOpen:Boolean read FIsOutDevOpen;
    function DeviceCount:Integer;
    function GetDeviceName(ID:Integer):String;
    function GetDviceList: string; //デバイスの一覧を取得する
    function GetMidiOutHandle: Integer;
    procedure SetMidiOutHandle(hdl: Integer);
  private
    function midioutErrorString( WError: Word ): String;
  end;

implementation


{ TMidiOut }

function TMidiOut.Close: Boolean;
begin
  Result := ClosePORT(CurPORT);
end;

constructor TMidiOut.Create;
var
  i,j:Integer;
begin
  for i:=0 to MAX_PORT-1 do
  begin
    hMIDIOUT2[i] := 0;
    for j:=0 to 15 do
    begin
      ChannelMute[i,j] := False;
    end;
  end;
  CurPORT := 0;
  UseLog := False;
  LongMsgDone := False;
  CallBackWindowHandle := 0;
end;

destructor TMidiOut.Destroy;
var
  i:Integer;
begin
  for i:=0 to MAX_PORT-1 do
    ClosePort(i);
end;

function TMidiOut.DeviceCount: Integer;
begin
  Result := midiOutGetNumDevs;
end;

function TMidiOut.GetDeviceName(ID: Integer): String;
var
  p:MIDIOUTCAPS;
begin
  if ID < 0 then begin Result := 'MIDI Default'; Exit; end;
  midiOutGetDevCaps(ID,@p,SizeOf(p));
  Result := string(p.szPname) ;
end;

function TMidiOut.Open(DeviceID:Integer): Boolean;
begin
  Result := OpenPORT(DeviceID, CurPORT);
end;

procedure TMidiOut.OutAllNoteOff(ch: Integer);
var b:TMidiShortMsg;
begin
  b.Status := $B0 + ch;
  b.Data1  := $7b;
  b.Data2  :=  00;
  OutShortMsg(b);
end;

procedure TMidiOut.OutBned(ch, value:Integer);
var
  b:TMidiShortMsg;
  i:Integer;
begin
  Inc(value,8192);
  b.Status := $E0 + ch;
  i := (value shr 7) and $7F;
  b.Data2 := i;
  i := value and $7F;
  b.Data1 := i;
  OutShortMsg(b);
end;

function TMidiOut.midioutErrorString( WError: Word ): String;
var
  errorDesc: PChar;
begin
  errorDesc := Nil;
  try
    errorDesc := StrAlloc(MAXERRORLENGTH);
    if midioutGetErrorText(WError, errorDesc, MAXERRORLENGTH) = 0 then
      result := StrPas(errorDesc)
    else
      result := 'Specified error number is out of range';
  finally
    if errorDesc <> Nil Then StrDispose(errorDesc);
  end;
end;

function TMidiOut.OutLongMsg(data: PBYTE; size: Integer): Boolean;
begin
  Result := OutLongMsgPORT(data,size,0);
end;

procedure TMidiOut.OutNoteOff(ch, no, val: Integer);
var b:TMidiShortMsg;
begin
  b.Status := $80 + ch;
  b.Data1 := no;
  b.Data2 := val;
  OutShortMsg (b);
end;

procedure TMidiOut.OutNoteOn(ch, no, val: Integer);
var b:TMidiShortMsg;
begin
  b.Status := $90 + ch;
  b.Data1 := no;
  b.Data2 := val;
  OutShortMsg (b);
end;

procedure TMidiOut.OutNRPN(ch, msb, lsb, value: Integer);
var b:TMidiShortMsg;
begin
  b.Status := $B0 + ch;
  b.Data1 := 99;
  b.Data2 := msb;
  OutShortMsg (b);
  b.Data1 := 98;
  b.Data2 := lsb;
  OutShortMsg (b);
  b.Data1 := 6;
  b.Data2 := value;
  //sleep(50);
  OutShortMsg(b);
end;

procedure TMidiOut.OutRPN(ch, msb, lsb, value: Integer);
var b:TMidiShortMsg;
begin
  b.Status := $B0 + ch;
  b.Data1 := 101;
  b.Data2 := msb;
  OutShortMsg (b);
  b.Data1 := 100;
  b.Data2 := lsb;
  OutShortMsg (b);
  b.Data1 := 6;
  b.Data2 := value;
  //sleep(50);
  OutShortMsg(b);
end;

function TMidiOut.OutShortMsg(msg: TMidiShortMsg): Boolean;
begin
  Result := OutShortMsgPORT(msg, CurPORT);
end;

function TMidiOut.OutShortMsgE(status, dat1, dat2:Byte): Boolean;
var
  msg:TMidiShortMsg;
begin
  msg.Status := status;
  msg.Data1 := dat1;
  msg.Data2 := dat2;
  msg.NoData := 0;
  Result := OutShortMsgPORT(msg, CurPORT);
end;

procedure TMidiOut.OutXGReset(DevNo: Integer);
var
  buf:Array [0..8]of BYTE;
begin
  // XG system On Msg
  buf[0]:=$F0;
  buf[1]:=$43;
  buf[2]:=$10 + DevNo;
  buf[3]:=$4c;
  buf[4]:=0;
  buf[5]:=0;
  buf[6]:=$7e;
  buf[7]:=0;
  buf[8]:=$f7;
  OutSysEx(@buf,9);
end;

function TMidiOut.OutSysEx(pSysex: Pointer; BufferSize: Integer): Boolean;
begin
  Result := OutLongMsg(pSysex, BufferSize);
end;

procedure TMidiOut.OutGMReset();
var
  buf:Array [0..5]of BYTE;
begin
  //F0 7E 7F 09 01 F7
  buf[0]:=$F0;
  buf[1]:=$7E;
  buf[2]:=$7F;
  buf[3]:=9;
  buf[4]:=1;
  buf[5]:=$F7;
  OutSysEx(@buf,6);
end;

procedure TMidiOut.OutGSReset(DevNo: Integer);
var
  buf:Array [0..10]of BYTE;
begin
  //SysEx$=F0,41,Dev,42,12,40,00,7F,00,41,F7;
  buf[0]:=$F0;
  buf[1]:=$41;
  buf[2]:=$10 + DevNo;
  buf[3]:=$42;
  buf[4]:=$12;
  buf[5]:=$40;
  buf[6]:=0;
  buf[7]:=$7f;
  buf[8]:=0;
  buf[9]:=$41;
  buf[10]:=$f7;
  OutSysEx(@buf,11);
end;

procedure TMidiOut.OutCtrlChg(ch, no, value: Integer);
var b:TMidiShortMsg;
begin
  b.Status := $B0 + ch;
  b.Data1 := no;
  b.Data2 := value;
  OutShortMsg (b);
end;

procedure TMidiOut.OutProgramChange(ch, no: Integer);
var b:TMidiShortMsg;
begin
  b.Status := $C0 + ch;
  b.Data1 := no;
  b.Data2 := 0;
  OutShortMsg (b);
end;

function TMidiOut.GetMidiOutHandle: Integer;
begin
  Result := hMIDIOUT2[CurPORT];
end;

procedure TMidiOut.SetMidiOutHandle(hdl: Integer);
begin
  hMIDIOUT2[CurPORT] := hdl;
end;

function TMidiOut.ClosePort(PortNo: Integer): Boolean;
begin
  if hMIDIOUT2[PortNo] = 0 then
  begin
    Result := True; Exit;
  end;
  midiOutReset(hMIDIOUT2[PortNo]);
  if hMIDIOUT2[PortNo] <> 0 then midiOutClose(hMIDIOUT2[PortNo]);
  hMIDIOUT2[PortNo] := 0;
  FIsOutDevOpen := False;
  Result := True;
end;

function TMidiOut.OpenPort(DeviceID, PortNo: Integer): Boolean;
var c,res:UINT;
begin
  //if hMIDIOUT <> 0 then Close;
  c := UINT(DeviceID);
  if DeviceID < 0 then c := MIDI_MAPPER;
  if hMIDIOUT2[PortNo] <> 0 then
  begin
    Result := True;
    Exit; //既に開いている
  end;
  if CallBackWindowHandle = 0 then
  begin
    res := midiOutOpen(@hMIDIOUT2[PortNo], c, 0,
      0, CALLBACK_NULL);
  end else
  begin
    res := midiOutOpen(@hMIDIOUT2[PortNo], c,
      DWORD(CallBackWindowHandle), 0, CALLBACK_WINDOW);
  end;
  Result := (res = MMSYSERR_NOERROR);
  if Result = False then
  begin
    ErrMsg := midioutErrorString(res);
  end;
  FIsOutDevOpen := Result;
end;

function TMidiOut.OutShortMsgPORT(msg: TMidiShortMsg;
  portNo: Integer): Boolean;
begin
  if hMIDIOUT2[portNo] = 0 then begin Result := False; Exit; end;
  //---NoteStatus
       if (msg.Status and $F0)=$90 then NoteStatus[portNo, (msg.Status and $F), msg.Data1] := msg.Data2
  else if (msg.Status and $F0)=$80 then NoteStatus[portNo, (msg.Status and $F), msg.Data1] := 0
  else if (msg.Status and $F0)=$B0 then CCStatus  [portNo, (msg.Status and $F), msg.Data1] := msg.Data2
  else if (msg.Status and $F0)=$E0 then PBStatus  [portNo, (msg.Status and $F)] := (msg.Data2 shl 7)or(msg.Data1)
  else if (msg.Status and $F0)=$C0 then PCStatus  [portNo, (msg.Status and $F)] := msg.Data1
  ;

  //ミュートしたチャンネルは演奏しない
  if ChannelMute[ portNo, msg.status and $F ] then begin Result:=True; Exit; end;

  if UseLog then begin
    logstr := Format('(Port%d)$%2X,%3d,%3d'#13#10,[portNo, msg.Status, msg.Data1, msg.Data2])+logstr;//送信ログ
  end;

  msg.NoData := 0;
  Result := (midiOutShortMsg(hMIDIOUT2[portNo],DWORD(msg)) = MMSYSERR_NOERROR);
end;


function TMidiOut.OutLongMsgPORT(data: PBYTE; size,
  portNo: Integer): Boolean;
var
  FErr:WORD;
  hdr:PMidiHdr;
begin
  if hMIDIOUT2[portNo] = 0 then begin Result := False; Exit; end;

  // コールバック関数設定の確認
  if CallBackWindowHandle = 0 then
    raise EMidiOut.Create('エクスクルーシブを送信するときは、'#13#10+
    'CallBackWindowHandleを設定してコールバック関数を定義する必要があります。');


  // 送信準備
  hdr := PMidiHdr( HeapAlloc (GetProcessHeap , HEAP_ZERO_MEMORY, sizeof(TMIDIHDR)));
  hdr^.lpData := PChar( HeapAlloc(GetProcessHeap , HEAP_NO_SERIALIZE, size));
  CopyMemory(hdr^.lpData, data, size);
  hdr^.dwBufferLength := size;
  hdr^.dwFlags := 0;

  LongMsgDone := False;

  FErr := midiOutPrepareHeader(hMIDIOUT2[portNo], hdr, sizeof(TMidiHdr));
  if(FErr<>MMSYSERR_NOERROR)then raise Exception.Create(midioutErrorString(FErr));

  FErr:=midiOutLongMsg(hMIDIOUT2[portNo], hdr, SizeOf(TMidiHdr));
  if(FErr<>MMSYSERR_NOERROR)then raise Exception.Create(midioutErrorString(FErr));


  // 送信完了まで待機
  while LongMsgDone = False do
  begin
    Application.ProcessMessages ;
    sleep(1);
  end;

  // 開放
  midiOutUnPrepareHeader(hMIDIOUT2[portNo], hdr, sizeof(TMidiHdr));
  HeapFree(GetProcessHeap,0,hdr^.lpData);
  HeapFree(GetProcessHeap,0,hdr);

  Result := (FErr=MMSYSERR_NOERROR);
end;

function TMidiOut.OutSysExPORT(pSysex: Pointer; BufferSize,
  portNo: Integer): Boolean;
begin
  Result := OutLongMsgPORT(pSysex, BufferSize, portNo);
end;

function TMidiOut.OutShortMsgEPORT(status, dat1, dat2: Byte;
  portNo: Integer): Boolean;
var msg:TMidiShortMsg;
begin
  msg.Status := status;
  msg.Data1 := dat1;
  msg.Data2 := dat2;
  msg.NoData := 0;
  Result := OutShortMsgPORT(msg, portNo);
end;

function TMidiOut.CloseAll: Boolean;
var
  i:Integer;
  b:Boolean;
begin
  Result := True;
  for i:=0 to MAX_PORT-1 do
  begin
    if hMIDIOUT2[i] <> 0 then
    begin
      b := ClosePort(i);
      if not b then Result := False;
    end;
  end;
end;

function TMidiOut.OutShortMsgAllPort(status, dat1, dat2: Byte): Boolean;
var
  i:Integer;
  msg: TMidiShortMsg;
begin
  //出力可能なポート全てに同じ内容のメッセージを出力する
  msg.Status := status;
  msg.Data1 := dat1;
  msg.Data2 := dat2;
  Result := true;
  try
    for i:=0 to MAX_PORT-1 do
    begin
      if hMIDIOUT2[i] <> 0 then
      begin
          OutShortMsgPORT(msg, i);
      end;
    end;
  except
    Result := False;
  end;
end;


//すべての音を消音する
procedure TMidiOut.Panic;
var
  i,j: Integer;
begin
  for j := 0 to MAX_PORT-1 do
  begin
    if hMIDIOUT2[j] = 0 then Continue;
    for i:=0 to 15 do
    begin
      OutAllNoteOffPort(i,j);
    end;
  end;
  ResetNoteStatus;
end;

procedure TMidiOut.ResetNoteStatus;
var
  p, c, n: Integer;
begin
  for p := 0 to MAX_PORT -1 do
    for c := 0 to 15 do
    begin
      for n := 0 to 127 do
      begin
        NoteStatus[p,c,n] := 0;
        CCStatus[p,c,n] := 0;
      end;
      PBStatus[p,c] := 8192;
      PCStatus[p,c] := 0;
      CCStatus[p,c,10] := 64;
      CCStatus[p,c,11] := 127;
      CCStatus[p,c, 7] := 100;
    end;
end;


function TMidiOut.GetDviceList: string;
var
  i: Integer;
begin
  Result := '';
  for i:=-1 to DeviceCount -1 do
  begin
    Result := Result + GetDeviceName(i) + #13#10;
  end;
end;

procedure TMidiOut.OutAllNoteOffPort(ch, port: Integer);
var
  b:TMidiShortMsg;
begin
  b.Status := $B0 + ch;
  b.Data1 := 123;
  b.Data2 := 0;
  OutShortMsgPORT(b, port);
end;

procedure TMidiOut.OutResetCtrlPort(ch, port: Integer);
var
  b:TMidiShortMsg;
begin
  b.Status := $B0 + ch;
  b.Data1 := 120;
  b.Data2 := 0;
  OutShortMsgPORT(b, port);
  b.Data1 := 121;
  b.Data2 := 0;
  OutShortMsgPORT(b, port);
  b.Data1 := 123;
  b.Data2 := 0;
  OutShortMsgPORT(b, port);
end;

procedure TMidiOut.MMDoneReceived;
begin
  // エクスクルーシブ送信完了を設定
  LongMsgDone := True;
end;


end.
