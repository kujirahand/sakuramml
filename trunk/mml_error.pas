unit mml_error;
{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���FMML�\���G���[���Ǘ�����


���@���F

2002/06/03 15:13 ���^�쐬
-------------------------------------------------------------------------------}

interface

uses
  Windows,
  SysUtils,
  Classes,
  mmsystem;

type
  EMml = class(Exception)
    constructor Create(const Msg: string);
    constructor CreateFmt(const Msg: string; const Args: array of const);
  end;

  procedure _debug(s: string); overload;
  procedure _debug(i: Integer); overload;
  procedure WriteLog(s: string);
  procedure WriteComTime(mes: string); //�R�����g����Ō��݂܂ł̎��s���Ԃ��L�^����

var
  CompilerMessage: string;
  TimeCheck: DWORD;

const
    MML_LOG = 'log_sakura.txt';//���O�t�@�C���̖��O

//�G���[���b�Z�[�W���X�g
const
  //�����Ȃ����b�Z�[�W�݂̂̃G���[
  MML_ERR_SYSTEM = '�T�N���̃V�X�e���G���[�B';
  MML_ERR_GET_STRING = '������̎擾�Ɏ��s';
  MML_ERR_SYNTAX = '���@�G���[�B';
  MML_ERR_DEF_FUNC = '�֐��̒�`�Ɏ��s���܂����B';
  MML_ERR_DEF_MACRO = '�}�N���̒�`�Ɏ��s���܂����B';

  //"%s"�̈������G���[
  MML_ERR_UNKNOWN = '"%s"�͖���`�ł��B�Â���m���߂Ă��������B';
  MML_ERR_VAR_NOT_FOUND = '�ϐ�"%s"�͖���`�ł��B�Â���m���߂Ă��������B';
  MML_ERR_RANGE_OVER = '����"%s"�ŁA�l���͈͂𒴂��Ďw�肳��܂����B';
  MML_ERR_ARG = '����"%s"�̈����̎w�肪�s���ł��B';
  MML_ERR_CALC = '�v�Z���Ɍ�肪����܂��B';
  MML_ERR_VAR_ILLIGAL_TYPE = '�ϐ�"%s"�ɕs���Ȍ^�������悤�Ƃ��܂����B';
  MML_ERR_VAR_CANT_EXECUTE = '�ϐ�"%s"�́A���s�ł��܂���B';
  MML_ERR_KAKKO_NOT_PAIR = '�J�b�R"%s"���A�Ή����Ă��܂���B';
  MML_ERR_CANT_READ_INT_VALUE = '����"%s"�ŁA�������ǂ߂܂���B�������w�肵�Ă��������B';
  MML_ERR_NOT_INT = '�ϐ�"%s"�́A�����ł͂���܂���B';
  MML_ERR_CALL_FUNC = '�֐�"%s"�̌Ăяo���Ɏ��s���܂����B';
  MML_ERR_CALL_USER_FUNC = '���[�U�[�֐�"%s"�̌Ăяo���Ɏ��s���܂����B';
  MML_ERR_STR_EXPAND = '"������"%s"�ɋL�q�~�X������܂��B';
  MML_ERR_WRONG_ARG_ORDER = '�m�[�g��`����"%s"�́A����`�̈����w��q�ł��B';
  //"%d"���G���[
  MML_ERR_PLAY = '"PLAY"���̃g���b�N(%d)"%s"���ɋL�q�~�X������܂��B';
  //WARNING
  MML_ERR_VAR_ALREADY_EXISTS = '�ϐ�"%s"���A�Ē�`���Ă��܂��B';
  MML_ERR_FUNCTION_ALREADY_EXISTS = '�֐�"%s"���A�Ē�`���Ă��܂��B';
  MML_WARN_VAR_SYNTAX = '�񐄏��ȕ��@�̌x���B';

implementation

procedure _debug(s: string); 
begin
    MessageBox(0, PChar(s), 'debug', MB_OK);
end;
procedure _debug(i: Integer);
var
    s: string;
begin
    s := IntToStr(i);
    MessageBox(0, PChar(s), 'debug', MB_OK);
end;

procedure WriteLog(s: string);
var
    f: TextFile;
begin
    AssignFile(f, MML_LOG);

    if FileExists(MML_LOG) then
    begin
        Append(f);
        writeln(f,s);
    end else
    begin
        Rewrite(f);
        writeln(f,s);
    end;
    CloseFile(f);
end;

procedure WriteComTime(mes: string); //�R�����g����Ō��݂܂ł̎��s���Ԃ��L�^����
begin
    CompilerMessage := CompilerMessage +
        Format('[%s] %.2f �b',[mes,((timeGetTime-TimeCheck)/1000)])+#13#10;
end;

{ EMml }

//���������ACompilierMessage�ɃG���[�������������ׂ̌p��
constructor EMml.Create(const Msg: string);
begin
    if Pos(Msg, CompilerMessage) > 0 then
    begin
        inherited Create(Msg);
        Exit;
    end;

    CompilerMessage := CompilerMessage + Msg;
    inherited Create(Msg);
end;

constructor EMml.CreateFmt(const Msg: string; const Args: array of const);
var
    s: string;
begin
    s := Format(Msg,Args);
    
    if Pos(s, CompilerMessage) > 0 then
    begin
        inherited CreateFmt(Msg, Args);
        Exit;
    end;

    CompilerMessage := CompilerMessage + s;
    inherited CreateFmt(Msg, Args);
end;

initialization
  CompilerMessage := '';
  TimeCheck := timeGetTime;

end.
