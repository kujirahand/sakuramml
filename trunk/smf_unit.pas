unit smf_unit;
// �p�r�FMIDI�t�@�C�����t�̂��߂̊e��C�x���g�̃N���X���`��������
// �쐬�F�N�W����s�� (http://www.text2music.com)
// ���t�F2002/11/25

interface

uses
  Windows, SysUtils, Classes, midi_out, inifiles;

const
  //�l�h�c�h�C�x���g�̃X�e�[�^�X
  EVENT_NOTE_OFF               = $80;
  EVENT_NOTE_ON                = $90;
  EVENT_KEY_PRESSURE           = $A0; //�A�t�^�[�^�b�`
  EVENT_CONTROL_CHANGE         = $B0; //�R���g���[���`�F���W
  EVENT_PROGRAM_CHANGE         = $C0;
  EVENT_CHANNEL_PRESSURE       = $D0;
  EVENT_PITCH_BEND             = $E0;

  EVENT_SYS_EX                 = $F0;
  EVENT_META                   = $FF;

  //ControlChange
  CC_BANK_MSB = $00;
  CC_BANK_LSB = $20;
  //
  CC_RPN_MSB = 101;
  CC_RPN_LSB = 100;
  CC_NRPN_MSB = 99;
  CC_NRPN_LSB = 98;
  CC_DATA_ENTRY = 6;

  //META Event
  META_END_OF_TRACK = #$FF#$2F#00;
  META_TYPE_END_OF_TRACK = $2F;
  //
  META_TEMPO        = $51;//3BYTE
  META_SEQ_NO       = $00;//2BYTE
  META_TEXT         = $01;
  META_COPYRIGHT    = $02;
  META_TRACK_NAME   = $03;
  META_INST_NAME    = $04;
  META_LYRIC        = $05;
  META_MARKER       = $06;
  META_CUE_POINT    = $07;
  META_CH_PREFIX    = $20;//1BYTE
  META_SMPTE        = $54;//5BYTE
  META_TIME_SIG     = $58;//4BYTE
  META_KEY_SIG      = $59;//2BYTE
  META_SEQ_SPRC     = $7F;
  META_PORT         = $21;//1BYTE


  //MIDI���M���̃C�x���g
  EVENT_SYSTE_EXCLUSIVE        = $F0;
  EVENT_MIDI_TIMECODE          = $F1;
  EVENT_SONG_POSITION          = $F2;
  EVENT_SONG_SELECT            = $F3;
  EVENT_TUNE_REQUEST           = $F4;
  EVENT_START                  = $FA;
  EVENT_CONTINUE               = $FB;
  EVENT_STOP                   = $FC;
  EVENT_ACTIVE_SENSING         = $FE;
  EVENT_SYSTEM_RESET           = $FF;

type
  // Midi File Header
  TSmfFileHeader = packed record
    ID:         array [0..3] of Char;
    Len:        DWORD;
    Format:     WORD;
    TrackCount: WORD;
    Timebase:   WORD;
  end;
  // Midi File Track Header
  TSmfTrackHeader = packed record
    ID:       array [0..3] of Char;
    Len:      DWORD;
  end;

  TSmfSong = class; //�O���錾

  TMergeList = class(TList)
  public
    procedure Sort(Compare: TListSortCompare);
  end;
  
  TSmfCustomPlayer = class
  public
    Song: TSmfSong; // �ȃf�[�^
    MidiOut: TMidiOut;
    InitTempo: Integer;
    MetaText: string;
    TimeSigKo,
    TimeSigOya: Integer; //���q�L��
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  // �C�x���g�N���X�̐��^
  TSmfEvent = class
  private
    function GetChannel: Byte;
  public
    Event:    Byte;  // �C�x���g��� (���ۂ̃`�����l���́A���ʂW�o�C�g�j
    Port:     Byte;  // �|�[�g�ԍ�
    Time:     Integer; // �C�x���g���ԁi�X�e�b�v�l�j
    Parent:   TSmfCustomPlayer;
    property  Channel: Byte read GetChannel;
    procedure Send; virtual; abstract; // �C�x���g�𑗐M����
    procedure LoadFromStream(Stream: TStream); virtual; abstract;
    function  SaveToStream(Stream: TStream): Integer; virtual; abstract; // ���o�C�g�������񂾂��Ԃ�
  end;

  // �g���b�N (�C�x���g�̏W�܂�)
  TSmfTrack = class(TList)
  private
    function GetEvent(Index: Integer): TSmfEvent;
    procedure SetEvent(Index: Integer; Event: TSmfEvent);
  protected
    Port: Integer;
  public
    property Events[Index: Integer]: TSmfEvent read GetEvent write SetEvent;
    procedure Clear; override;
    procedure SortEvent;
  end;

  // �\���O (�g���b�N�̏W�܂�)
  TSmfSong = class(TList)
  private
    function GetTrack(Index: Integer): TSmfTrack;
    procedure SetTrack(Index: Integer; Track: TSmfTrack);
  protected
    procedure SortAllTrack;
  public
    TimeBase : DWORD;
    Format   : DWORD;
    Parent   : TSmfCustomPlayer ; 
    property Tracks[Index: Integer]: TSmfTrack read GetTrack write SetTrack;
    procedure Clear; override;
    procedure TrackMix; //�����g���b�N���P�Ƀ~�b�N�X����
    procedure LoadFromStream(stream: TStream);
    procedure SaveToStream(stream: TStream);
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
    constructor Create(Parent: TSmfCustomPlayer);
    procedure SetDelay(ininame: string);
  end;

  // MIDI�t�@�C�������ۂɓǍ���ł���N���X
  ESmfReadSMF = class(Exception);
  TSmfReadSMF = class
  private
    FSong: TSmfSong;
    FTrackCount: Integer;
    procedure ReadHeader(Stream: TStream);
    procedure ReadTrack(Stream: TStream);
    procedure WriteHeader(Stream: TStream);
  public
    constructor Create(Song: TSmfSong);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  end;

  // �eMIDI�C�x���g
  TSmfNoteOff = class(TSmfEvent)
  public
    NoteNo,
    Velocity: Byte;
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
  end;
  TSmfNoteOn = class(TSmfEvent)
  public
    NoteNo,
    Velocity: Byte;
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
  end;
  TSmfKeyPressure = class(TSmfEvent)
  public
    NoteNo,
    Value: Byte;
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
  end;
  TSmfControlChange = class(TSmfEvent)
  public
    No,
    Value: Byte;
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
  end;
  TSmfProgramChange = class(TSmfEvent)
  public
    Value: Byte;
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
  end;
  TSmfChannelPressure = class(TSmfEvent)
  public
    Value: Byte;
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
  end;
  TSmfPitchBend = class(TSmfEvent)
  public
    Value: Integer;
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
  end;
  TSmfSysEx = class(TSmfEvent)
  public
    Data: array of Char; // Data ���ێ�����̂́A "$F0 (VarLen) (Data ... $F7)" �́A$F7 ���܂� Data �ȉ��ł���
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
  end;
  TSmfMeta = class(TSmfEvent)
  private
    function  GetAsTempo: Integer;        // Tempo �C�x���g�Ƃ��Ēl�𓾂�
    procedure SetAsTempo(Value: Integer); //
  public
    MetaType: Byte;
    Data: array of Char;
    procedure Send;                            override;
    procedure LoadFromStream(Stream: TStream); override;
    function  SaveToStream  (Stream: TStream): Integer; override;
    property AsTempo: Integer read GetAsTempo write SetAsTempo;
  end;

//�r�b�O�G���f�B�A���ƁA���g���G���f�B�A�������ւ���
function SwapEndian4(x: DWORD): DWORD; overload;
function SwapEndian2(x: WORD): WORD; overload;

{�ϒ����l�\�����A�X�g���[���֓ǂݏ�������}
function WriteVarLen(stream: TStream; v: DWORD): Integer;
function ReadVarLen(stream: TStream; var v: DWORD): Integer;

// �X�g���[�����P�o�C�g�ǂ݁A�eMIDI�C�x���g�𐶐�����
function CreateMidiEvent(Event: Byte): TSmfEvent;

implementation

// FDelphi �T���v�����A�ׂ�����́A�}�[�W�\�[�g�N���X
procedure TMergeList.Sort(Compare: TListSortCompare);
var Tmp:PPointerList;
  procedure MergeSort(First,Last: Integer);
  var
    I,J,K,P,Mid:Integer;
  begin
    if First < Last then begin
      Mid :=(First + Last) div 2;
      MergeSort(First,Mid);
      MergeSort(Mid+1,Last);
      P := Mid - First + 1;
      System.Move(List^[First],Tmp^[0], P * SizeOf(Pointer) );
      i := Mid + 1; J := 0 ; k := first;
      while (i <= Last) and (J < P) do
        if Compare(Tmp^[J],List^[I]) > 0
          then begin
            List^[k] := List^[i];
            //�㔼���珑���߂��B
            Inc(k);Inc(i);
          end else begin
            List^[k] := Tmp^[j];
            //��Ɨ̈悩�珑���߂��B�����A�Ԉ���Ă܂����Bm(__)m
            Inc(k);Inc(J);
          end;
      while j < P do begin
        List^[K] := Tmp^[j];
        inc(k);inc(j);
      end;
    end;
  end;
begin
  GetMem(Tmp,(count div 2 + 1) * SizeOf(Pointer));
  try
    MergeSort(0,Count-1);
  finally
    FreeMem(Tmp);
  end;
end;


function SwapEndian4(x: DWORD): DWORD;
begin
    Result := ( x shl 24 ) or ( ( x and $ff00 ) shl 8 ) or
            ( ( x shr 8 ) and $ff00 ) or ( x shr 24 );
end;

function SwapEndian2(x: WORD): WORD;
begin
    Result := ( (x and $FF) shl 8) or (x shr 8);
end;

(** WriteVarLen
�@�\�F
�@�ϒ����l�\�����A�X�g���[���ɏ�������
�����F
  stream  �������ݐ�X�g���[��
  v       �������ޒl
�߂�l�F
�@�������񂾃o�C�g��
*)
function WriteVarLen(stream: TStream; v: DWORD): Integer;
var
    b: DWORD;
    cnt: Integer;
begin
    b := v and $7f;
    cnt := 1;
    v := v shr 7;
    while v > 0 do
    begin
        b := b shl 8;
        b := b or ( v and $7f) or $80;
        v := v shr 7;
        Inc(cnt);
    end;
    Result := stream.Write(b, cnt);
end;

(** ReadVarLen
�@�\�F
�@�ϒ����l�\�����A�X�g���[������ǂݏo��
�����F
  stream  �ǂݏo�����X�g���[��
  v       �ǂݏo�����l
�߂�l�F
�@�ǂݍ��񂾃o�C�g��
*)
function ReadVarLen(stream: TStream; var v: DWORD): Integer;
var b: Byte;
begin
  Result := 0; // �ǂݍ��݃o�C�g����Ԃ��̂ŁA���Z�b�g
  Result := Result + stream.Read(b,1);
  v := b;
  if (b and $80)=0 then Exit;
  v := v and $7f;
  repeat
    Result := Result + stream.Read(b, 1);
    v := (v shl 7) + (b and $7f);
  until ((b and $80)=0);
end;


// �X�g���[�����P�o�C�g�ǂ݁A�eMIDI�C�x���g�𐶐�����
//TODO: CreateMidiEvent
function CreateMidiEvent(Event: Byte): TSmfEvent;

  procedure procSysExMeta; //���^�C�x���g�̐���
  begin
    if Event = EVENT_SYS_EX then
    begin
      Result := TSmfSysEx.Create ;
    end else
    begin
      Result := TSmfMeta.Create ;
    end;
  end;

begin
  Result := nil;

  case (Event and $F0) of
  EVENT_NOTE_OFF:         Result := TSmfNoteOff.Create;
  EVENT_NOTE_ON:          Result := TSmfNoteOn.Create;
  EVENT_KEY_PRESSURE:     Result := TSmfKeyPressure.Create;
  EVENT_CONTROL_CHANGE:   Result := TSmfControlChange.Create;
  EVENT_PROGRAM_CHANGE:   Result := TSmfProgramChange.Create;
  EVENT_CHANNEL_PRESSURE: Result := TSmfChannelPressure.Create;
  EVENT_PITCH_BEND:       Result := TSmfPitchBend.Create;
  EVENT_SYS_EX:           procSysExMeta;
  end;

end;

{ TSmfTrack }

procedure TSmfTrack.Clear;
var
  i: Integer;
  p: TSmfEvent;
begin
  for i:=0 to Count -1 do
  begin
    p := Items[i];
    if p<>nil then p.Free ;
  end;
  inherited;
end;

function TSmfTrack.GetEvent(Index: Integer): TSmfEvent;
begin
  Result := Items[Index];
end;

procedure TSmfTrack.SetEvent(Index: Integer; Event: TSmfEvent);
begin
  Items[Index] := Event;
end;

function func_sort(Item1, Item2: Pointer): Integer;
var i1, i2: TSmfEvent;
begin
  i1 := Item1;
  i2 := Item2;
  Result := i1.Time - i2.Time;
end;

procedure TSmfTrack.SortEvent;
begin
  TMergeList(Self).Sort(func_sort);
end;

{ TSmfSong }

procedure TSmfSong.Clear;
var
  i: Integer;
  p: TSmfTrack;
begin
  for i:=0 to Count-1 do
  begin
    p := Items[i];
    if p<>nil then p.Free ;
  end;
  inherited;
end;

constructor TSmfSong.Create(Parent: TSmfCustomPlayer);
begin
  Self.Parent := Parent;
end;

function TSmfSong.GetTrack(Index: Integer): TSmfTrack;
begin
  Result := Items[Index];
end;

procedure TSmfSong.LoadFromFile(FileName: string);
var
  stream: TMemoryStream;
begin
  stream := TMemoryStream.Create ;
  try
  try
    stream.LoadFromFile(FileName);
    LoadFromStream(stream);
  except
    raise;
  end;
  finally
    stream.Free ;
  end;
end;

procedure TSmfSong.LoadFromStream(stream: TStream);
var
  smf: TSmfReadSmf;
begin
  //�w�b�_�̓ǂݍ���
  Clear;
  smf := TSmfReadSmf.Create(Self);
  try try
    smf.LoadFromStream(stream);
  except raise; end;
  finally
    smf.Free ;
  end;
end;

procedure TSmfSong.SaveToFile(FileName: string);
var
  stream: TMemoryStream;
begin
  stream := TMemoryStream.Create ;
  try
  try
    SaveToStream(stream);
    stream.SaveToFile(FileName);
  except
    raise;
  end;
  finally
    stream.Free ;
  end;
end;

procedure TSmfSong.SaveToStream(stream: TStream);
var
  smf: TSmfReadSmf;
begin
  //�w�b�_�̓ǂݍ���
  smf := TSmfReadSmf.Create(Self);
  try try
    smf.SaveToStream(stream);
  except raise; end;
  finally
    smf.Free ;
  end;
end;

procedure TSmfSong.SetDelay(ininame: string);
var
  j, i, delay: Integer;
  ini: TIniFile;
  trk: TSmfTrack;
  eve: TSmfEvent;
begin
  ini := TIniFile.Create(ininame);
  try
    // �g���b�N�̃f�B���C��ݒ�
    for i := 0 to Count - 1 do
    begin
      delay := ini.ReadInteger('track.delay', IntToStr(i + 1), 0);
      if delay <> 0 then
      begin
        trk := Self.Tracks[i];
        for j := 0 to trk.Count - 1 do
        begin
          eve       := trk.Events[j];
          eve.Time  := eve.Time + delay;
          if eve.Time < 0 then eve.Time := 0;
        end;
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TSmfSong.SetTrack(Index: Integer; Track: TSmfTrack);
begin
  Items[Index] := Track;
end;

procedure TSmfSong.SortAllTrack;
var i: Integer;
begin
  for i:=0 to Count-1 do
  begin
    Tracks[i].SortEvent ;
  end;
end;

procedure TSmfSong.TrackMix;
var
  i, j: Integer;
  track, dTrack: TSmfTrack;
  event: TSmfEvent;
begin
  dTrack := Tracks[0];

  // �g���b�N�̃C�x���g���������B
  for i:=1 to Count -1 do
  begin
    track := Tracks[1];
    for j:=0 to track.Count -1 do
    begin
      event := track.Events[j];
      dTrack.Add(event);
      track.Events[j] := nil;
    end;
    track.Free ;
    Self.Delete(1);
  end;

  Format := 0; //�܂Ƃ߂���A�t�H�[�}�b�g�́A�O
  SortAllTrack;
end;

{ TSmfEvent }

function TSmfEvent.GetChannel: Byte;
begin
  Result := Event and $F;
end;

{ TSmfReadSMF }

constructor TSmfReadSMF.Create(Song: TSmfSong);
begin
  FSong := Song;
end;

procedure TSmfReadSMF.LoadFromStream(Stream: TStream);
var
  i: Integer;
begin
  //�w�b�_�[�̓ǂݏo��
  ReadHeader(Stream);
  FSong.Parent.InitTempo := -1;
  
  //�g���b�N���Ƃɓǂݏo��
  for i:=0 to FTrackCount-1 do
  begin
    ReadTrack(Stream);
  end;
end;

procedure TSmfReadSMF.ReadHeader(Stream: TStream);
var
  FileHeader: TSmfFileHeader;
begin
  try
    Stream.Read(FileHeader, SizeOf(FileHeader));
  except
    raise ESmfReadSMF.Create('SMF�w�b�_�̓ǂݏo���Ɏ��s���܂����B');
  end;

  //�w�b�_�̉��
  if StrLComp(@FileHeader.ID[0], 'MThd', 4) <> 0 then
    raise ESmfReadSMF.Create('MIDI�t�@�C���ł͂���܂���B');
  FSong.TimeBase := SwapEndian2( FileHeader.Timebase   );
  FSong.Format   := SwapEndian2( FileHeader.Format     );
  FTrackCount    := SwapEndian2( FileHeader.TrackCount );
end;

procedure TSmfReadSMF.ReadTrack(Stream: TStream);
var
  track: TSmfTrack;
  event, event2: TSmfEvent;
  c, TrackLen, TrackLast, i: Integer;
  filePos, ttime: Integer;
  dtime: DWORD;
  status, rstatus, defaultPort: Byte;

  procedure ReadTrackHeader;
  var
    header: TSmfTrackHeader ;
  begin
    // �w�b�_�̃`�F�b�N
    try
      Stream.Read(header, SizeOf(header));
    except raise; end;
    if StrLComp(@header.ID[0], 'MTrk', 4) <> 0 then
      raise ESmfReadSMF.CreateFmt('MIDI�t�@�C���̃g���b�N%d�w�b�_�����Ă��܂�',[c]);
    TrackLen := SwapEndian4(header.Len);
  end;

begin
  //TODO: Track�ǂݍ���
  // �g���b�N�̐���
  track := TSmfTrack.Create ;
  c := FSong.Add(track);

  ReadTrackHeader;
  filePos  := Stream.Position;
  TrackLast := filePos + TrackLen;

  // �C�x���g�̓ǂݏo��
  ttime := 0;
  defaultPort := 0;
  rstatus := 0; // �����j���O�X�e�[�^�X������
  while Stream.Position < TrackLast do // END_OF_TRACK �܂œǂ�
  begin
    // �f���^�^�C����ǂ�
    ReadVarLen(Stream, dtime);
    Inc(ttime, dtime); // ������

    // �C�x���g�𓾂�
    Stream.Read(status, 1);

    //�����j���O�X�e�[�^�X���H
    if status < $80 then
    begin // �����j���O�X�e�[�^�X���g�����f�[�^
      Stream.Seek(-1, soCurrent); // 1�O�ɖ߂�
      status := rstatus;
    end else
    begin
      rstatus := status;
    end;

    //MIDI�C�x���g����
    event := CreateMidiEvent(Status);
    event.Parent := FSong.Parent;
    event.Event := Status;
    event.Time := ttime;
    track.Add(event);
    event.LoadFromStream(Stream);


    //�C�x���g���e�̃`�F�b�N
    if (Status = EVENT_META) then
    begin
      case TSmfMeta(Event).MetaType of
      META_TYPE_END_OF_TRACK: Break; // �g���b�N�̓ǂݎ��I��
      META_PORT:
        begin
          defaultPort := Ord( TSmfMeta(Event).Data[0] );
          // ���^�C���ɏ������܂ꂽ�C�x���g�̃|�[�g��␳����K�v������
          i := track.Count - 2;
          while i >= 0 do
          begin
            event2 := track.Events[i];
            if event2.Time <> event.Time then Break;
            event2.Port := defaultPort;
            Dec(i);
          end;
        end;
      META_TEMPO:
        begin
          if FSong.Parent.InitTempo = -1 then
          begin //�����e���|���擾
            FSong.Parent.InitTempo := TSmfMeta(Event).AsTempo ;
          end;
        end;
      end;
    end;
    //�C�x���g�Ɋ�{�l���Z�b�g
    event.Port := defaultPort;
    //Writeln('read:',ttime,'-',Status);
  end;

  //���̃w�b�_�̐擪�ɓ�����
  Stream.Seek((filePos + TrackLen), soFromBeginning);
end;


procedure TSmfReadSMF.SaveToStream(Stream: TStream);


  procedure WriteTrack(trackNo: Integer);
  var
    header: TSmfTrackHeader;
    pos_header, i: Integer;
    track: TSmfTrack;
    event: TSmfEvent;
    ttime, dtime: Integer;
    total: Integer;
    b: Byte;
  begin
    track := FSong.Tracks[trackNo];

    // �g���b�N�`�����N�������݁i�Ƃ肠�����j
    pos_header := Stream.Position ;
    Move('MTrk', header.ID[0], 4);
    Stream.Write(header, SizeOf(header));

    // �g���b�N�̃C�x���g����������
    total := 0;
    ttime := 0;
    for i:=0 to track.Count -1 do
    begin
      event := track.Events[i];
      if event.ClassType = TSmfMeta then
      if TSmfMeta(event).MetaType = META_TYPE_END_OF_TRACK then Continue;

      // �f���^�^�C����������
      dtime := event.Time - ttime;
      ttime := event.Time ;
      total := total + WriteVarLen(Stream, dtime);
      // �C�x���g��������
      total := total + event.SaveToStream(Stream);
      //writeln('read ',dtime, '-', event.event);
    end;
    b := 0; total := total + Stream.Write(b, 1);
    total := total + Stream.Write(META_END_OF_TRACK, 3);

    // �g���b�N�`�����N���ď�������
    Stream.Position := pos_header;
    header.Len := SwapEndian4(total); 
    Stream.Write(header, SizeOf(header));
    Stream.Seek(0, soFromEnd);
  end;

var
  i: Integer;
begin
  //TODO: Track��������
  // �C�x���g���^�C�����Ƀ\�[�g
  FSong.SortAllTrack;

  // MIDI�t�@�C���w�b�_�`�����N��������
  WriteHeader(Stream);

  // �e�g���b�N����������
  for i:=0 to FSong.Count -1 do
  begin
    WriteTrack(i);
  end;
end;

procedure TSmfReadSMF.WriteHeader(Stream: TStream);
var
  header: TSmfFileHeader;
begin
  with header do begin
    Move('MThd',ID, 4);
    Len := SwapEndian4(6);
    TrackCount := SwapEndian2(FSong.Count);
    Format := SwapEndian2(FSong.Format);
    Timebase := SwapEndian2(FSong.TimeBase) ;
  end;
  Stream.Position := 0;
  Stream.Write(header, SizeOf(header));
end;

{ TSmfNoteOff }

procedure TSmfNoteOff.LoadFromStream(Stream: TStream);
begin
  Stream.Read(NoteNo, 1);
  Stream.Read(Velocity, 1);
end;

function TSmfNoteOff.SaveToStream(Stream: TStream): Integer;
begin
  Stream.Write(Event, 1);
  Stream.Write(NoteNo, 1);
  Stream.Write(Velocity, 1);
  Result := 3;
end;

procedure TSmfNoteOff.Send;
begin
  Parent.MidiOut.OutShortMsgEPORT(Event, NoteNo, Velocity, Port);
end;

{ TSmfNoteOn }

procedure TSmfNoteOn.LoadFromStream(Stream: TStream);
begin
  Stream.Read(NoteNo, 1);
  Stream.Read(Velocity, 1);
end;

function TSmfNoteOn.SaveToStream(Stream: TStream): Integer;
begin
  Stream.Write(Event, 1);
  Stream.Write(NoteNo, 1);
  Stream.Write(Velocity, 1);
  Result := 3;
end;

procedure TSmfNoteOn.Send;
begin
  Parent.MidiOut.OutShortMsgEPORT(Event, NoteNo, Velocity, Port);
end;

{ TSmfKeyPressure }

procedure TSmfKeyPressure.LoadFromStream(Stream: TStream);
begin
  Stream.Read(NoteNo, 1);
  Stream.Read(Value, 1);
end;

function TSmfKeyPressure.SaveToStream(Stream: TStream): Integer;
begin
  Stream.Write(Event, 1);
  Stream.Write(NoteNo, 1);
  Stream.Write(Value, 1);
  Result := 3;
end;

procedure TSmfKeyPressure.Send;
begin
  Parent.MidiOut.OutShortMsgEPORT(Event, NoteNo, Value, Port);
end;

{ TSmfControlChange }

procedure TSmfControlChange.LoadFromStream(Stream: TStream);
begin
  Stream.Read(No, 1);
  Stream.Read(Value, 1);
end;

function TSmfControlChange.SaveToStream(Stream: TStream): Integer;
begin
  Stream.Write(Event, 1);
  Stream.Write(No, 1);
  Stream.Write(Value, 1);
  Result := 3;
end;

procedure TSmfControlChange.Send;
begin
  Parent.MidiOut.OutShortMsgEPORT(Event, No, Value, Port);
end;

{ TSmfProgramChange }

procedure TSmfProgramChange.LoadFromStream(Stream: TStream);
begin
  Stream.Read(Value, 1);
end;

function TSmfProgramChange.SaveToStream(Stream: TStream): Integer;
begin
  Stream.Write(Event, 1);
  Stream.Write(Value, 1);
  Result := 2;
end;

procedure TSmfProgramChange.Send;
begin
  Parent.MidiOut.OutShortMsgEPORT(Event, Value, 0{dummy}, Port);
end;

{ TSmfChannelPressure }

procedure TSmfChannelPressure.LoadFromStream(Stream: TStream);
begin
  Stream.Read(Value, 1);
end;

function TSmfChannelPressure.SaveToStream(Stream: TStream): Integer;
begin
  Stream.Write(Event, 1);
  Stream.Write(Value, 1);
  Result := 2;
end;

procedure TSmfChannelPressure.Send;
begin
  Parent.MidiOut.OutShortMsgEPORT(Event, Value, 0{dummy}, Port);
end;

{ TSmfPitchBend }

procedure TSmfPitchBend.LoadFromStream(Stream: TStream);
var
  msb, lsb: Byte;
begin
  with Stream do begin
    Read(lsb,1);
    Read(msb,1);
  end;
  value := (msb shl 7) or lsb;
end;

function TSmfPitchBend.SaveToStream(Stream: TStream): Integer;
var
  msb, lsb: Byte; //
begin
  msb := (value shr 7) and $7F; //��ʂV�r�b�g
  lsb := value and $7F;         //���ʂV�r�b�g

  //�������ޏ��Ԃ́A���(msb)�Ɖ���(lsb)���t�Ȃ̂Œ���
  with Stream do begin
    Write(Event, 1);
    Write(lsb, 1);
    Write(msb, 1);
  end;
  Result := 3;
end;

procedure TSmfPitchBend.Send;
var
  b:TMidiShortMsg;
begin
  b.Status := Event;
  b.Data1  := value and $7F;
  b.Data2  := (value shr 7) and $7F;
  Parent.MidiOut.OutShortMsgPORT(b, Port);
end;

{ TSmfSysEx }

procedure TSmfSysEx.LoadFromStream(Stream: TStream);
var
  len: DWORD;
begin
  ReadVarLen(Stream, len);
  SetLength(Data, len); // $FF (VarLen)|(Data)
  Stream.Read(Data[0], len);
end;

function TSmfSysEx.SaveToStream(Stream: TStream): Integer;
var
  len: DWORD;
begin
  Result := Stream.Write(Event, 1);
  len := Length(Data);
  Result := Result + WriteVarLen(Stream, len);
  Result := Result + Stream.Write(Data[0], len);
end;

procedure TSmfSysEx.Send;
var
  p: PChar;
  len: Integer;
begin
  len := Length(Data);
  GetMem(p, len + 1);
  p^ := #$F0;
  Move(Data[0], (p+1)^, len);
  //Parent.MidiOut.OutLongMsg(PByte(p), len+1);
  Parent.MidiOut.OutLongMsgPORT(PByte(p), len+1, Port);
end;

{ TSmfMeta }

procedure TSmfMeta.LoadFromStream(Stream: TStream);
var
  len: DWORD;
begin
  Stream.Read(MetaType, 1); // Meta Status
  ReadVarLen(Stream, len);  // Read Text Length

  if len<> 0 then
  begin
    SetLength(Data, len);     // Read
    Stream.Read(Data[0], len);
  end else
  begin
    Data := nil;
  end;
end;

function TSmfMeta.SaveToStream(Stream: TStream): Integer;
var
  len: DWORD;
  b: Byte;
begin
  Result := 0;
  if MetaType = META_TYPE_END_OF_TRACK then Exit; //END_OF_TRACK �͏������܂Ȃ�

  b := $FF;
  Result := Stream.Write(b, 1);
  Result := Result + Stream.Write(MetaType, 1);
  len := Length(Data);
  Result := Result + WriteVarLen(Stream, len);
  Result := Result + Stream.Write(Data[0], len);
end;

procedure TSmfMeta.Send;
var
  s: string;
  len, i, b, bb: Integer;
begin
  // Meta�C�x���g�́A�����o�͂��Ȃ�
  if (MetaType = META_TRACK_NAME)or(MetaType = META_TEXT)or(MetaType = META_LYRIC) then
  begin
    len := Length(Data);
    SetLength(s, len+1);
    Move(Data[0], s[1], len);
    s[len+1] := #0;
    Parent.MetaText := Parent.MetaText + string(PChar(s)) + #13#10;
  end else
  if MetaType = META_TIME_SIG then
  begin
    Parent.TimeSigKo := Ord(Data[0]);
    // ����́A�Q�̕��ׂ̂���ƂȂ�
    b := Ord(Data[1]);
    bb := 2;
    for i:=1 to b-1 do bb := bb * 2;
    Parent.TimeSigOya := bb;
  end;
end;

function TSmfMeta.GetAsTempo: Integer;
begin
  Result := Ord(Data[2]) or (Ord(Data[1]) shl 8) or (Ord(Data[0]) shl 16);
  Result := 60000000 div Result;
end;

procedure TSmfMeta.SetAsTempo(Value: Integer);
begin
  SetLength(Data, 3);
  Data[0] := Char((Value shr 16) and $FF);
  Data[1] := Char((Value shr  8) and $FF);
  Data[2] := Char((Value       ) and $FF);
end;

{ TSmfCustomPlayer }

constructor TSmfCustomPlayer.Create;
begin
  MidiOut := TMidiOut.Create ;
  Song := TSmfSong.Create(Self) ;
  InitTempo := -1; // ����`
  TimeSigKo  := 4; // 4/4���q
  TImeSigOya := 4;
end;

destructor TSmfCustomPlayer.Destroy;
begin
  Song.Free ;
  MidiOut.Free ;
  inherited;
end;

end.
