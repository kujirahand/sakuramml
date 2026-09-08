program c_smf;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  smf_types in 'smf_types.pas',
  smf_const in 'smf_const.pas';

var
    song: TSmfSong ;
    track: TSmfTrack ;
begin
    song := TSmfSong.Create ;
    try
        song.TimeBase := 96; //四分音符分解能
        track := song.GetTrack(0); //トラック０を作成

        //                time, ch, no, vel, len
        track.WriteNoteOn(   0,  0, 60, 127,  96);//o5c
        track.WriteNoteOn(  96,  0, 62, 127,  96);//o5d
        track.WriteNoteOn( 192,  0, 64, 127,  96);//o5e

        song.SaveToFile('test_c.mid'); //ファイルへ保存
    finally
        song.Free ;
    end;
end.
