unit smf_const;

interface
uses
  {$ifdef Win32}Windows,{$endif}
  SysUtils,
  Classes;

const
  //ＭＩＤＩイベントのステータス
  EVENT_NOTE_OFF               = $80;
  EVENT_NOTE_ON                = $90;
  EVENT_KEY_PRESSURE           = $A0; //アフタータッチ
  EVENT_CONTROL_CHANGE         = $B0; //コントロールチェンジ
  EVENT_PROGRAM_CHANGE         = $C0;
  EVENT_CHANNEL_PRESSURE       = $D0;
  EVENT_PITCH_BEND             = $E0;

  EVENT_SYS_EX                 = $F0;
  EVENT_META                   = $F7;

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


  //MIDI送信時のイベント
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


implementation

end.
