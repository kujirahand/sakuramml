unit mml_unit;

{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���F�T�N���̂l�l�k���r�l�e�ɕϊ����郁�C�����j�b�g


���@���F

2002/06/03 15:13 ���^�쐬
-------------------------------------------------------------------------------}


interface

uses
  Windows,
  Classes,
  SysUtils,
  mml_error,
  mml_base;

type
  TMml2Smf=class(TMmlBase)
  public
    function Execute(str: string; out_file: string): Boolean;
    function GetMessage: string;
  end;

implementation

uses mml_variable, mml_system, mml_var, mml_types, smf_types;

{ TMml2Smf }


function TMml2Smf.Execute(str, out_file: string): Boolean;
var
    ms: TMStr;
    flg: Boolean;

    function chkf(f: string): Boolean;
    begin
      Result := FileExists( f + 'stdmsg.h' );
    end;

    procedure IncludeStdMsg; //�W���t�@�C���� Include ���鏈��
    begin

        if chkf('Include\')or chkf('')or chkf(ExtractFilePath(ParamStr(0)))or
          chkf(ExtractFilePath(ParamStr(0))+'Include\') then
        begin

          try
              Eval('Include(stdmsg.h)');
          except
              CompilerMessage := CompilerMessage + ('[�q���g](-1): �W���t�@�C��"stdmsg.h"�̃R���p�C���Ɏ��s'#13#10);
          end;

        end else
        begin
          CompilerMessage := CompilerMessage + '[�q���g](-1): stdmsg.h ��ǂݔ�΂��܂����B'#13#10;
        end;
    end;

    procedure CountLineNo;
    var p: PChar;
    begin
        LineCount := 0;
        LastLine := 0;
        p := PChar(str);
        while p^ <> #0 do
        begin
            if p^ in LeadBytes then
                Inc(p,2)
            else
            begin
                if p^ = #13 then Inc(LineCount);
                Inc(p);
            end;
        end;
    end;

begin
    Result := True;
    try
        //---- TMml2Smf�̃R���p�C�����C���֐� ----------------------------------

        //�R���p�C���J�n���Ԃ��L�^
        if MmlOption.EventLog then
        begin
            if FileExists(MML_LOG) then DeleteFile(MML_LOG); //�����̃��O�t�@�C��������΍폜
            WriteLog('�C�x���g���O');
            WriteLog(DateTimeToStr(Now));
        end;
        if MmlOption.TimeLog then WriteComTime('�����ݒ芮��');

        //"stdmsg.h"���C���N���[�h���邩�H
        if MmlOption.IncludeStdMsg then IncludeStdMsg ;
        if MmlOption.TimeLog then WriteComTime('"stdmsg.h"�̎捞�݊���');

        CountLineNo;
        ms := TMStr.Create ;
        ms.value := PreCompile(str, 0);//�v���R���p�C��

        //�X�g�g���̕ϊ����ʂ����O�Ɏc����?
        if MmlOption.SutotonLog then WriteLog(ms.value);//�ϊ��������ʂ�LOG�ɕۑ�
        if MmlOption.TimeLog then WriteComTime('�X�g�g������MML�֕ϊ�����');

        //�W���t�@�C���ɓ��e���Z�b�g
        with nowpos do //���݈ʒu���Z�b�g
        begin
            SetTempSource(ms.value) ;
            IncludedSource.Add(ms);
            fileNo := IncludedFiles.Add('');
            lineNo := 0;
        end;

        //�R���p�C��
        try
            Compile(nowpos);//�R���p�C���J�n
            if FlagStopCompile then
            begin
                Result := False;
                Exit;
            end;
        except
            Result := False;
            Exit;
        end;

        WriteEndOfTrack;
        if MmlOption.TimeLog then WriteComTime('�R���p�C������');

        if Assigned(OnProgress) then
        begin
          flg := False;
          OnProgress(8,10,'�R���p�C��������MIDI�f�[�^������',@flg);
          if flg then Exit;
        end;

        //---MIDI�t�@�C���֏����o��
        SmfSong.DebugTime := MmlOption.TimeLog;
        if MmlOption.MldFormat then
        begin
            //SmfSong.SaveToMld(out_file); //Docomo MLD�����ŏ����o��
        end else
        begin
            SmfSong.SaveToFile(out_file);
        end;
        if MmlOption.TimeLog then WriteComTime('MIDI�t�@�C�������o������');
    except
        Result := False;
    end;
end;

function TMml2Smf.GetMessage: string;
begin
    Result := CompilerMessage ;
end;



end.
