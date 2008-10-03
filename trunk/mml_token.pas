unit mml_token;
{-------------------------------------------------------------------------------
�\�t�g�F�e�L�X�g���y�u�T�N���v
��@�ҁF�N�W����s�� http://www.text2music.com
���@���F�g�[�N���̐؂�o���A�X�g�g���ւ̕ϊ����s�����������j�b�g
���@���F

2002/06/03 15:13 ���^�쐬
2002/11/22 12:22 �X�g�g���̃A���S���Y���ύX
-------------------------------------------------------------------------------}

interface

uses
  SysUtils,
  Classes,
  hashUnit,
  mml_variable,
  Windows;

type
  TStrHashNode = class(THashNode)
    value: string;
    tag: Integer;
  end;

  PSutotonNode = ^TSutotonNode;
  TSutotonNode = record
    name: string;
    value: string;
    len: Integer;
  end;

  TSutotonList = class(TList)
  public
    function AddSutoton(name, value: string): Integer;
    procedure SortName;
    procedure Clear; override;
    //�����񒆂���A��v���镔�������邩��������
    function Find(src: PChar): Integer; //������Ȃ��ꍇ�́A-1
  end;

{'�@'��'��'�Ȃǂ̋L���̂ݔ��p�ɂ���B�������A".."�̊Ԃ����́A��������}
function ConvToHalfSign(src: string; lineNo: Integer): string;
{�h���~���Acde ��MML�֕ϊ�����}
function SutotonToMml(src: string; lineNo: Integer): string;


{������̒�����A���������݂̂����o��}
function GetNumber(var pp: PChar): string;


{MML�̃\�[�X����A�P����P�؂�o��}
function getTokenMML(var ptr: PChar): string;
{�X�N���v�g����A�P��P��؂�o��}
function getTokenWord(var ptr: PChar): string;

{MML�̕����񕪂��A�����o��}
function getString(var ptr: PChar; var lineNo: Integer): string;

{MML�̃l�X�g����()���A�����o��}
function GetMaruKakko(var ptr: PChar; var lineNo: Integer): string;
function GetNakaKakko(var ptr: PChar; var lineNo: Integer): string;
function GetKakkoNest(var ptr: PChar; var lineNo: Integer; const kakkoFrom, kakkoTo: Char): string;


{�l�X�g���� cFrom .. cTo �܂ł𒲂ׁA�|�C���^�� cTo�܂Ői�߂�}
procedure skipKakko(var ptr: PChar; var lineNo: Integer; const cFrom, cTo:Char);

procedure skipSpace(var p: PChar);
procedure skipSpaceReturn(var p: PChar; var lineNo: Integer);
procedure skipSpaceCalc(var p: PChar);

implementation

uses StrUnit;

function GetMaruKakko(var ptr: PChar; var lineNo: Integer): string;
begin
    Result := GetKakkoNest(ptr, lineNo, '(',')');
end;

function GetNakaKakko(var ptr: PChar; var lineNo: Integer): string;
begin
    Result := GetKakkoNest(ptr, lineNo, '{','}');
end;

function GetKakkoNest(var ptr: PChar; var lineNo: Integer; const kakkoFrom, kakkoTo: Char): string;
var
    nest: Integer;
begin
    Result := '';
    nest := 0;
    while ptr^<>#0 do
    begin
        if ptr^ in LeadBytes then
        begin
            Result := Result + (ptr)^ + (ptr+1)^;
            Inc(ptr,2);
        end else
        begin
            if ptr^ = kakkoFrom then
                begin
                    if nest<>0 then Result := Result + kakkoFrom;
                    Inc(nest);
                    Inc(ptr);
                    Continue;
                end
            else if ptr^ = kakkoTo then
                begin
                    Dec(nest);
                    if nest<>0 then Result := Result + kakkoTo;
                    Inc(ptr);
                    if nest=0 then Break;
                    if nest<0 then raise EParserError.Create('"'+kakkoFrom+'"������܂���B');
                    Continue;
                end
            else if ptr^ = #13 then
                begin
                    Inc(lineNo);
                    Inc(ptr);
                    Result := Result + #13#10;
                    if ptr^ = #10 then Inc(ptr); Continue;
                end
            else
                begin
                    Result := Result + ptr^;
                    Inc(ptr);
                end;
        end;
    end;
end;


function getString(var ptr: PChar; var lineNo: Integer): string;
var
    nest: Integer;
begin
    Result := '';

    skipSpace(ptr);
    if ptr^<>'{' then raise Exception.Create('������ "{"����n�܂��Ă��܂���B');
    Inc(ptr);
    nest := 1;

    while ptr^ <> #0 do
    begin
        if ptr^ in LeadBytes then
        begin
            Result := Result + ptr^ + (ptr+1)^;
            Inc(ptr,2);
        end else
        begin
            if ptr^ = #13 then Inc(lineNo);
            case ptr^ of
            '{':
                begin
                    Result := Result + '{';
                    Inc(nest);
                    Inc(ptr); Continue;
                end;
            '}':
                begin
                    Inc(ptr);
                    Dec(nest);
                    if nest<=0 then Break;
                    Result := Result + '}';
                end;
            else
                begin
                    Result := Result + ptr^;
                    Inc(ptr);
                end;
            end;
        end;
    end;
    //{"str"}�΍�
    if (Copy(Result,1,1)='"')and(Copy(Result,Length(Result),1)='"') then
    begin
        Result := Copy(Result,2,Length(Result)-2);
    end;
    if nest>0 then raise Exception.Create('������ "}"�ŏI����Ă��܂���B');
end;

procedure skipSpace(var p: PChar);
begin
    while p^ in [' ',#9,'|'] do Inc(p);
end;

procedure skipSpaceCalc(var p: PChar);
begin
    while p^ in [' ',#9] do Inc(p);
end;

procedure skipSpaceReturn(var p: PChar; var lineNo: Integer);
begin
    while True do
    begin
        skipSpace(p);
        if p^ = #13 then
        begin
          Inc(p);
          Inc(lineNo);
          skipSpace(p);
        end else
        if p^ = #10 then
        begin
          Inc(p);
        end else
          Break;
    end;
end;

function GetNumber(var pp: PChar): string;
var
	buf, tmp: PChar;
  len: Integer;
  flg: string;
begin
  Result := '';
  while pp^ in [' ',#9] do Inc(pp);
  if pp^ in ['+','-'] then
  begin
    flg := pp^; Inc(pp);
  end else
    flg := '';
	case pp^ of
        '$':// 16 �i��
        begin
            Inc(pp); tmp := pp;
            while pp^ in ['0'..'9','A'..'F','a'..'f'] do Inc(pp);
            len := pp - tmp;
            GetMem(buf, len+1);
            try
            	StrLCopy(buf, tmp, len);
                (buf+len)^ := #0;
                Result := string( PChar(buf) );
            finally
            	FreeMem(buf);
            end;
			Result := IntToStr( StrToIntDef('$'+Result, 0) );
        end;
        '0'..'9'{,'.'}: //10 �i��
        begin
        	tmp := pp;
            while pp^ in ['0'..'9'] do Inc(pp);

            //���������_�͈���Ȃ�
            {if (pp^ = '.')and((pp+1)^ in ['0'..'9']) then
            begin
            	Inc(pp);
            	while pp^ in ['0'..'9'] do Inc(pp);
            end;}

            len := pp - tmp;
            GetMem(buf, len+1);
            try
            	StrLCopy(buf, tmp, len);
                (buf+len)^ := #0;
                Result := string( PChar(buf) );
            finally
            	FreeMem(buf);
            end;
        end;
	end;
  Result := flg + Result;
end;

{�h���~���Acde ��MML�֕ϊ�����}
function SutotonToMml(src: string; lineNo: Integer): string;
var
    p: PChar;
    list: TSutotonList;

    procedure ah(key, val: string; tag: Integer);
    begin
      //tag �� �v���O�������ł́A�g��Ȃ�
      list.AddSutoton(key, val);
    end;

    procedure sortSutotonList;
    begin
      list.SortName ;
    end;

    procedure addSutotonList;//todo:�X�g�g��
    begin
      {�X�g�g���o�^}
      ah('��','System.KeyFlag',500);//��#(����)//�Վ��L����ݒ肷��B�i��j�����i�h�t�@�j
      ah('���K','o',501);//���K(���l)//���K�𐔒l�Ŏw�肷��B�����l�͂T�B�͈͂́A0�`10�i��j���K�T
      ah('����','Time',502);//����(���ߐ�:����:�X�e�b�v��)//�w�莞�ԂɃ|�C���^���ړ�����B�͈͂́A���ߐ��E�������A�P�`�B�X�e�b�v���́A�O�`�B�i��j���ԁi�S�F�P�F�O�j
      ah('�ǂ�','Include',503);//�ǂ�(�t�@�C����)//�O����`�t�@�C����ǂݍ��ށB�i��j�ǂ�(chord2.h)
      ah('�\��','.onNote=',504);//(�R�}���h)�\��(v1,v2,v3...)//�R�}���h�̒l��\�񂵂Ă����i��j���ʗ\��120,50�y�h���~�t�@�z
      ah('���q','System.TimeSignature=',505);//���q ���q,����//���q��ݒ肷��B�i��j���q4,4
      ah('���F','@',506);//���F�i�ԍ��j//���F��ݒ肷��B
      ah('����','l',507);//�����i���������w��j//��{�ƂȂ鉹���̒��������������Ŏw�肷��B�i��j����16//�P�U�������̈Ӗ�
      ah('����','v',508);//���ʁi���l�j//����(���ۂ͉��̋���)��ݒ肷��B�����l�́A100�B�͈͂́A0~127�B�i��j����127
      ah('�A��','Div',509);//�A��{����}[����]//�R�A����T�A���Ȃǂ�\������B�i��j�A��{�h���~}4
      ah('�Q�[�g','q',510);//�Q�[�g�i�����j//�����̒����ɑ΂�����ۂ̔������Ԃ������i100�����j�Ŏw�肷��B�͈͂́A1�`100�`�B�i��j�Q�[�g80
      ah('�e���|','Tempo=',511);//�e���|�i���l�j//�e���|��ݒ肷��B�����l�́A120�B�͈͂́A20�`240�𐄏��B�i��j�e���|120
      ah('�B����','.Random=',512);//(�R�}���h)�B�����i���l�j//�e�����̞B������ݒ肷��B�͈͂́A0�`�B�����l�́A0�B�i��j���ʞB����80 �y�h���~�\�z
      ah('�g���b�N','Track=',513);//�g���b�N�i�ԍ��j//�g���b�N�ԍ����w�肷��B�����l�́A�O�B�͈͂́A0�`�B�i��j�g���b�N�R
      ah('�`�����l��','Channel=',514);//�`�����l���i�ԍ��j//���݂̃g���b�N�Ƀ`�����l����ݒ肷��B�����l�́A�g���b�N�ԍ��Ɠ����B�͈͂́A�P�`�P�U�i��j�g���b�N�R�`�����l���P�O
      ah('�Ȗ�','TrackName=',515);//�Ȗ�{"������"}//��������MIDI�t�@�C���ɋȖ��𖄂ߍ��ށB�i��j�Ȗ�{"�e�X�g"}
      ah('���','Copyright=',516);//���{"������"}//��������MIDI�t�@�C���ɒ��쌠���𖄂ߍ��ށB�i��j���{"�N�W����s��"}
      ah('�R�����g','MetaText=',517);//�R�����g{"������"}//��������MIDI�t�@�C���ɃR�����g�𖄂ߍ��ށB�i��j�R�����g{"�e�X�g"}
      ah('����������','System.MeasureShift(1);ResetGM;Time(1:1:0);TrackSync;',518);//����������//�����̏�����(GM���Z�b�g)�����s����B�i��j����������
      ah('���t�ʒu','PlayFrom',519);//���t�ʒu(���ߐ�:����:�X�e�b�v��))//�����Ȃ̓r�����牉�t���������A�Ȃ̉��t�ʒu���w�肷��B�i��j���t�ʒu�i32:1:0�j
      ah('�[','^',520);//�[//�^�C�B����L�΂��B�i��j�h�[�h���~�~�\�[�[�[
      ah('��','>',521);////���K�𑊑ΓI�ɂP�グ��
      ah('��','<',522);////���K�𑊑ΓI�ɂP������
      ah('�h','c',523);////����
      ah('��','d',523);////����
      ah('�~','e',523);////����
      ah('�t','f',523);////����
      ah('�@','',523);////����
      ah('�\','g',523);////����
      ah('��','a',523);////����
      ah('�V','b',523);////����
      ah('��','r',524);////�x���B�i��j�h�[�[���@�������[
      ah('�b','r',524);////�x���B�i��j�h�[�[�b�@���b���[
      ah('��','c',523);////����
      ah('��','d',523);////����
      ah('��','e',523);////����
      ah('��','f',523);////����
      ah('��','',523);////����
      ah('��','g',523);////����
      ah('��','a',523);////����
      ah('��','b',523);////����
      ah('��','r',524);////�x��
      ah('��','r',524);////�x��
      ah('�C','a',523);////����
      ah('��','b',523);////����
      ah('�n','c',523);////����
      ah('�j','d',523);////����
      ah('�z','e',523);////����
      ah('�w','f',523);////����
      ah('�g','g',523);////����
      ah('��','-',524);////�t���b�g�i��j�C��
      ah('�d','+',525);////�V���[�v
      ah('���Y��','Rythm',526);////���Y�����[�h
      ah('��','n36,',527);////�o�X�h����
      ah('��','n38,',529);////�X�l�A�h����
      ah('��','n42,',528);////�n�C�n�b�g�i�N���[�Y�j
      ah('��','n46,',529);////�n�C�n�b�g�i�I�[�v���j
      ah('��','n49,',530);////�V���o��
      ah('��','n50,',531);////Low�^��
      ah('��','n47,',532);////Mid�^��
      ah('��','n43,',533);////High�^��
      ah('�傫��','Cresc=',534);//�傫��(����),(�ŏI�l)//����(EP)�����񂾂�傫������
      ah('������','Decresc=',535);//������(����),(�ŏI�l)//����(EP)�����񂾂񏬂�������
      ah('�N���b�V�F���h','Cresc=',534);//�傫��(����),(�ŏI�l)//����(EP)�����񂾂�傫������
      ah('�f�N���b�V�F���h','Cresc=',535);//������(����),(�ŏI�l)//����(EP)�����񂾂񏬂�������
      ah('���ʖ߂�','EP(127)',536);////����(EP)���ő�l�ɖ߂�
      ah('������','P(0)',537);////�X�e���I�̍����特���o��悤�ɂ���
      ah('�������O','P(32)',538);////�X�e���I�̍��O���特���o��悤�ɂ���
      ah('�����O','P(64)',539);////�X�e���I�̑O���特���o��悤�ɂ���
      ah('�����E�O','P(96)',541);////�X�e���I�̉E�O���特���o��悤�ɂ���
      ah('�����E','P(127)',540);////�X�e���I�̉E���特���o��悤�ɂ���
      ah('������','P.onNoteWaveEx(0,127,!1,127,0,!1);',542);////�X�e���I�̍��E����
      ah('�r�u���[�g�I�t','M(0)',543);////�r�u���[�g����߂�
      ah('�y�_��','y64,127;',544);////�y�_���𓥂�
      ah('����','y64,0;',545);////�y�_�������
      ah('�e���|��','TempoChange=',546);//�e���|��([[[t1],t2],len])//�e���|�𐄈ړI�ɕύX����Blen���ȗ�����ƁA�S�����̊Ԃɐ��ڂ��At1���ȗ�����ƁA�ȑO�̒l����t2�֐��ڂ���B
      ah('�r�u���[�g','M.onNoteWaveEx(0,0,!4,0,96,!8);',547);////���ړI�ȃr�u���[�g��������
      ah('�������牉�t','PlayFrom(Time);',548);////�r�����牉�t�������Ƃ��ɏ���

      {/�X�g�g���o�^}

      sortSutotonList;
    end;

    function get2Byte(var p: PChar): string;
    begin
        Result := '';
        while p^ <> #0 do
        begin
            if p^ in LeadBytes then
            begin
                Result := Result + p^ + (p+1)^;
                Inc(p,2);
            end else
                Exit;
        end;
    end;


    function ConvToMml(var p: PChar; var lineNo: Integer):string;
    var
        i: Integer;
        ps: PSutotonNode;

        procedure includeSutoton;
        var
            s,fname: string;
            sl: TStringList;
            p2: PChar;
            l: Integer;
        begin
            skipSpace(p);
            fname := GetMaruKakko(p, lineNo);
            s := ExtractFilePath(ParamStr(0)) + fname;
            if FileExists(s) = False then
            begin
                s := ExtractFilePath(ParamStr(0)) + 'Include\' + fname;
                if FileExists(s) = False then
                begin
                    raise EFOpenError.CreateFmt('�t�@�C��"%d"��������܂���B',[fname]);
                end;
            end;
            sl := TStringList.Create ;
            try
                sl.LoadFromFile(s);
                s := sl.Text ;
            finally
                sl.Free ;
            end;
            s := ConvToHalfSign(s, 0);
            p2 := PChar(s);
            l := lineNo;
            ConvToMml(p2, l);
        end;

        procedure subUserAddSutotonHash;
        var w, txt: string;
        begin
            Inc(p); // skip ~

            // ~{ w } = { txt }
            w := GetNakaKakko(p, lineNo);
            skipSpace(p);
            if p^ = '=' then Inc(p);
            txt := GetNakaKakko(p, lineNo);

            ah(w, txt,999); //�X�g�g�����[�U�[���߂�ǉ�
            SortSutotonList;
        end;

        //�݊����̂��߁A{" ... "} �ƁA�����`�ł͂Ȃ��A {" ... } �Ŕ͈͂�F��
        procedure CopyToKakkoEnd;
        var
            temp: PChar;
            tempNo: Integer;
            s: string;
        begin
            tempNo := lineNo;
            s := p^ + (p+1)^; Inc(p,2); // copy {"
            temp := p;
            while True do
            begin
                if p^ in LeadBytes then
                begin
                    s := s + p^ + (p+1)^;
                    Inc(p,2);
                end else
                begin
                    if (p^='}') then
                    begin
                        s := s + p^;
                        Inc(p);
                        Break;
                    end else
                    if p^=#0 then
                    begin
                        raise EParserError.CreateFmt('(%d) : {" ... "}���Ή����Ă��܂���B',[tempNo]);
                    end;
                    if p^=#13 then Inc(LineNo);
                    s := s + p^;
                    Inc(p);
                end;
            end;
            if Copy(s, Length(s)-1,2)='"}' then
            begin
                Result := Result + s;
            end else
            begin
                Result := Result + '{"';
                p := temp;
            end;
        end;

    begin
        while p^ <> #0 do
        begin
            if p^ in LeadBytes then
            begin
              i := list.Find(p);
              if i>=0 then
              begin
                ps := PSutotonNode(list.Items[i]);
                Result := Result + ps^.value ;
                Inc(p, ps^.len);
              end else
              begin
                Result := Result + p^ + (p+1)^;
                Inc(p,2);
              end;
              Continue;
            end else
            if p^ = #13 then
            begin
                Inc(p);
                Inc(lineNo);
                if p^=#10 then Inc(p);
                Result := Result + #13#10;
                Continue;
            end else
            if p^ = '~' then //�X�g�g���̃��[�U�[�ǉ�
            begin
                subUserAddSutotonHash;
            end else
            if (p^ = '{')and((p+1)^='"') then
            begin
                CopyToKakkoEnd;
                Continue;
            end else
            if p^ = 'S' then
            begin
                if StrLComp(p, 'Sutoton', 7) = 0 then
                begin
                    Inc(p,7);
                    includeSutoton;
                end else
                begin
                    Result := Result + p^;
                    Inc(p);
                end;
            end else
            begin
                Result := Result + p^;
                Inc(p);
            end;
        end;
    end;

begin
    Result := '';
    list := TSutotonList.Create ;
    try
    try
        addSutotonList;
        p := PChar(src);
        Result := ConvToMml(p, lineNo);
    except
        on e: Exception do
        raise EParserError.Create(e.Message);
    end;
    finally
        list.Free ;
    end;
end;

{'�@'��'��'�Ȃǂ̋L���̂ݔ��p�ɂ���B�������A".."�̊Ԃ����́A��������}
function ConvToHalfSign(src: string; lineNo: Integer): string;
const
  conv = '�@ �D.�I!�h"��#��$��%��&�f'#39'�i(�j)��=�`~�b|�|-�O^��\��@�u''�G;�F:�v''�A,�C,'+
  '�B.�e`�o{�{+��*�p}��<��>�H?�Q_��#��-�w{�x}�y[�z]�^/'+
  '�P1�Q2�R3�S4�T5�U6�V7�W8�X9�O0��1��2�O3�l4��5�Z6��7��8��9��0��1��2�Q3�Z0'+
  '��#�{+��-��>��>��<��<';

var
    hash: THash ;
    n: TStrHashNode;
    len, i:Integer;
    s: string;
    p: PChar;

    procedure AddHashList(key, val: string);
    var node: TStrHashNode;
    begin
        node := TStrHashNode.Create(key) ;
        node.value := val;
        hash.Add(node);
    end;

    procedure CopyToKakkoEnd;
    var
        tempNo: Integer;
    begin
        tempNo := lineNo;
        Result := Result + p^ + (p+1)^; Inc(p,2); // copy {"
        while True do
        begin
            if p^ in LeadBytes then
            begin
                Result := Result + p^ + (p+1)^;
                Inc(p,2);
            end else
            begin
                //if (p^='"')and((p+1)^='}') then // {"ceg}�̂悤�ȏ��������o���Ȃ��Ȃ邩��
                if (p^='}') then //{"�œ��ꂾ���A���J�b�R�́��̗��R�ŁA} �݂̂ł悢
                begin
                    Break;
                end else
                if p^=#0 then
                begin
                    raise EParserError.CreateFmt('(%d) : {" ... "}���Ή����Ă��܂���B',[tempNo]);
                end;
                if p^=#13 then Inc(LineNo);
                Result := Result + p^;
                Inc(p);
            end;
        end;
    end;

    procedure skipComment2(var p: PChar);
    begin
        while True do
        begin
            if p^ in LeadBytes then
            begin
                Inc(p, 2);
            end else
            begin
                if p^ in [ #13, #0] then Break;
                Inc(p);
            end;
        end;
    end;

    procedure skipComment(var ptr: PChar);
    var
        nest: Integer;
    begin
        //������ł́A�R�����g�̃l�X�g�������Ă���
        nest := 0;
        while ptr^ <> #0 do
        begin
            if ptr^ in LeadBytes then
            begin
                Inc(ptr,2); Continue;
            end;
            if ptr^ = #13 then
            begin
                Inc(lineNo);
                Result := Result + #13#10;
                Inc(ptr);
            end
            else if (ptr^='*')and((ptr+1)^='/') then
            begin
                Inc(ptr,2);
                Dec(nest);
                if nest<=0 then Break;
            end else if (ptr^='/')and((ptr+1)^='*') then
            begin
                Inc(ptr,2);
                Inc(nest);
            end else
                Inc(ptr);
        end;
    end;


begin
    hash := TPtrHash.Create ;
    try
        //�n�b�V���ɕϊ��Ώە�����y�A��������
        i := 1;
        len := Length(conv);
        while i<len do
        begin
            //debug--
            if not(conv[i] in LeadBytes) then raise Exception.Create('ConvToHalfSign'+IntToStr(i)+'�ŁA�S�p���p���Ή����Ă��܂���B');
            AddHashList(Copy(conv,i,2), Copy(conv,i+2,1));
            Inc(i,3);
        end;

        //�n�b�V�����Q�Ƃ��Ȃ���A�������u������
        Result := '';
        p := PChar( src );
        while p^ <> #0 do
        begin
            if p^ in LeadBytes then
            begin
                s := p^ + (p+1)^;
                n := TStrHashNode( hash.Find(s) );
                if n=nil then
                begin
                    Result := Result + s;
                end else
                begin
                    Result := Result + n.value ;
                end;
                Inc(p,2);
            end else
            begin
                if (p^ = '{')and((p+1)^='"') then //���ꕶ���񂪂���΃X�L�b�v�I�I�I
                begin
                    CopyToKakkoEnd;
                end else
                if (p^ = '/')and((p+1)^='/') then
                begin//�s���܂ŃR�����g
                    skipComment2(p);
                end else
                if (p^ = '/')and((p+1)^='*') then
                begin//{*/}�܂ŃR�����g
                    skipComment(p);
                end else
                begin
                    if p^=#13 then Inc(lineNo);
                    Result := Result + p^;
                    Inc(p);
                end;
            end;
        end;

    finally
        hash.Free ;
    end;
end;


{MML�̃\�[�X����A�P����P���o��}
function getTokenMML(var ptr: PChar): string;

    procedure GetMultiByteWord;
    begin
        //�h���~�t�@�\���V�ǂ�݂ӂ����炵�̏ꍇ�����́A�P���������Ԃ�
        Result := (ptr)^ + (ptr+1)^;
        Inc(ptr,2);
        {
        if JPosEx(Result, '�ǂ�݂ӂ��炵�h���~�t�\���V',1) > 0 then
        begin
            if (Result='��')or(Result='�t') then //�t�@�̏���
            begin
                s := (ptr) + (ptr+1)^;
                if (s='��')or(s='�@') then Inc(ptr,2);
            end;
            Exit;
        end;
        //����ȊO�̎�: �������󔒂܂ŒP��ƌ��Ȃ�
        }
        while ptr^ <> #0 do
        begin
            if ptr^ in LeadBytes then
            begin
                Result := Result + (ptr)^ + (ptr+1)^;
                Inc(ptr,2);
            end else
            begin
                if ptr^ in ['A'..'Z','a'..'z','_','0'..'9'] then
                begin
                    Result := Result + ptr^;
                    Inc(ptr);
                end else
                    Break;//
            end;
        end;
    end;

    procedure GetUpperWord;
    begin
        Result := ptr^;
        Inc(ptr);
        while ptr^ <> #0 do
        begin
            if ptr^ in ['A'..'Z','a'..'z','_','0'..'9'] then
            begin
                Result := Result + ptr^ ;
                Inc(ptr);
            end else
                Break;
        end;
    end;

begin
    {--------------------
    �P����o���̋K���F
        �T�N���ł́A�啶���E�������EMutiByte�ŁA���o���P�ꂪ�Ⴄ
        [A-Z_0-9]+
        [a-z]
        [�h���~�t�@�\���V]
        MutiByte+
    ----------------------}
    if ptr=nil then Exit;
    if ptr^=#0 then Exit;
    Result := '';
    while ptr^ in [' ',#9] do Inc(ptr);
    if ptr^ in [#0, ';', #13, #10] then Exit;

    if ptr^ in LeadBytes then
        GetMultiByteWord
    else if ptr^ in ['A'..'Z','_','#'] then
        GetUpperWord
    else begin
        //�������i���A�L���j1���������؂���
        Result := ptr^; Inc(ptr);
    end;
end;

{�X�N���v�g����A�P��P��؂�o��}
function getTokenWord(var ptr: PChar): string;
begin
    // [A..Z,a-z,_,#][A..Z,a-z,_0-9]+
    skipSpace(ptr);
    Result := '';
    if ptr^ in ['A'..'Z','a'..'z','_','#'] then
    begin
        Result := ptr^;
        Inc(ptr);
        while ptr^ in ['A'..'Z','a'..'z','_','0'..'9'] do
        begin
            Result := Result + ptr^;
            Inc(ptr);
        end;
    end;
end;


procedure skipKakko(var ptr: PChar; var lineNo: Integer; const cFrom, cTo:Char);
var
    nest: Integer;
begin
    skipSpace(ptr);
    if ptr^<>cFrom then raise Exception.Create('�͈͎w��G���[�B"'+cFrom+'"����n�܂��Ă��܂���B');
    Inc(ptr);
    nest := 1;

    while ptr^ <> #0 do
    begin
        if ptr^ in LeadBytes then
        begin
            Inc(ptr,2);
        end else
        begin
            if ptr^ = #13 then Inc(lineNo);

            if ptr^ = cFrom then
            begin
                Inc(nest);
                Inc(ptr); Continue;
            end else
            if ptr^ = cTo then
            begin
                Inc(ptr);
                Dec(nest);
                if nest<=0 then Break;
            end else
            begin
                Inc(ptr);
            end;
        end;
    end;

    if nest>0 then raise Exception.Create('�͈͎w��G���[�B"'+cTo+'"�ŏI����Ă��܂���B');
end;


{ TSutotonList }

function TSutotonList.AddSutoton(name, value: string): Integer;
var
  p: PSutotonNode;
  i: Integer;
begin
  //�����L�[����������㏑��
  for i:=0 to Count-1 do
  begin
    p := Items[i];
    if p^.name = name then
    begin
      p^.value := value;
      Result := i;
      Exit;
    end;
  end;
  //�V�K
  New(p);
  p^.name := name;
  p^.value := value;
  p^.len := Length(name);
  Result := Add(p);
end;

procedure TSutotonList.Clear;
var
  i: Integer;
  p: PSutotonNode;
begin
  for i:=0 to Count -1 do
  begin
    p := Items[i];
    if p <> nil then begin
      Dispose(p);
    end;
  end;
  inherited;

end;


function TSutotonList.Find(src: PChar): Integer;
var
  i:Integer;
  p: PSutotonNode ;
begin
  Result := -1;
  if(src=nil) then Exit;
  for i:=0 to Count-1 do
  begin
    p := Items[i];
    if( StrLComp(src, PChar(p^.name), p^.len) = 0 )then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function funcSortName(Item1, Item2: Pointer): Integer;
var
  p1,p2: PSutotonNode;
begin
  p1 := Item1;
  p2 := Item2;
  Result := p2.len - p1.len ;
end;

procedure TSutotonList.SortName;
begin
  Sort(funcSortName);
end;

end.
