unit StrUnit;
(*------------------------------------------------------------------------------
�ėp�����񏈗����`�������j�b�g

�S�Ă̊֐��́A�}���`�o�C�g����(S-JIS)�ɑΉ����Ă���

�쐬�ҁF�R�{���( mine@text2music.com ) http://www.text2music.com
�쐬���F2001/11/24

�����F
2002/04/09 �r����#0���܂ޕ�����ł������u���ł���悤�ɏC��

------------------------------------------------------------------------------*)
interface
uses
  Windows, SysUtils, Classes, EasyMasks,
  Variants;

type
  TCharSet = set of Char;

(******************************************************************************)
// multibyte function

{�����񌟍� // ���o�C�g�ڂ̕����̈ʒu��Ԃ�}
function JPosEx(const sub, str:string; idx:Integer): Integer;
{������u��}
function JReplace(const Str, oldStr, newStr:string; repAll:Boolean): string;
{������u���g����}
function JReplaceEx(const Str, oldStr, newStr:string; repAll:Boolean; useCase:Boolean): string;
{�f���~�^������܂ł̒P���؂�o���B�i�؂�o�����P��Ƀf���~�^�͊܂܂Ȃ��B�j
�؂�o����́A���̕�����str����A�؂�o����������{�f���~�^�����폜����B}
function GetToken(const delimiter: String; var str: string): String;
{Multibyte�������𓾂�}
function JLength(const str: string): Integer;
{Multibyte�������؂�o��}
function JCopy(const str: string; Index, Count: Integer): string;
{Mutibyte���������������}
function JPosM(const sub, str: string): Integer;

{------------------------------------------------------------------------------}
{������ނ̕ϊ�}

{ LCMapString ���ȒP�Ɏg�����߂̊֐� �ϊ���̕�����́Astr * 2 �ȓ�}
function LCMapStringEx(const str: string; MapFlag: DWORD): string;
{ LCMapString ���ȒP�Ɏg�����߂̊֐� �ϊ���̕�����́Astr �ȓ�}
function LCMapStringExHalf(const str: string; MapFlag: DWORD): string;
{�S�p�ϊ�}
function convToFull(const str: string): string;
{���p�ϊ�}
function convToHalf(const str: string): string;
{�����ƃA���t�@�x�b�g�ƋL���̂ݔ��p�ɕϊ�����/�A���x��}
function convToHalfAnk(const str: string): string;
{�Ђ炪�ȁE�J�^�J�i�̕ϊ�}
function convToHiragana(const str: string): string;
function convToKatakana(const str: string): string;
{MutiByte���l�������啶���A��������}
function LowerCaseEx(const str: string): string;
function UpperCaseEx(const str: string): string;
function RomajiToKana(romaji: String): String;
{� ���m�� �̂悤�ȍs���̔��p�J�i���폜���ĕԂ�}
function TrimLeftKana(str: string): string;

{------------------------------------------------------------------------------}
{������ނ̔���}
function IsHiragana(const str: string): Boolean;
function IsKatakana(const str: string): Boolean;
function Asc(const str: string): Integer; //�����R�[�h�𓾂�
function IsNumStr(const str: string): Boolean; //�����񂪑S�Đ��l���ǂ������f

{------------------------------------------------------------------------------}
{HTML����}

{HTML ���� �^�O����菜��}
function DeleteTag(const html: string): String;
{HTML�̎w��^�O�ň͂�ꂽ�����𔲂��o��}
function GetTag(var html:string; tag: string): string;
function GetTags(html:string; tag: string): string;

{------------------------------------------------------------------------------}
{�g�[�N������}

{�g�[�N���؂�o���^��؂蕶������i�߂�}
function GetTokenChars(delimiter: TCharSet; var ptr:PChar): string;
{�l�X�g����i�j�̓��e�𔲂��o��}
function GetKakko(var pp: PChar): string;

{------------------------------------------------------------------------------}
{��������}

{���t�̉��Z ex)�R������ IncDate('2001/10/30','0/3/0') �O���O IncDate('2001/1/1','-0/0/3')}
function IncDate(BaseDate: TDateTime; AddDate: string): TDateTime;
{���Ԃ̉��Z ex)�R���Ԍ� IncTime('15:0:0','3:0:0') �O�b�O IncTime('12:45:0','-0:0:3')}
function IncTime(BaseTime: TDateTime; AddTime: string): TDateTime;
{����A�a��ɑΉ��������t�ϊ��p�֐�}
function StrToDateStr(str: string): string;
{����A�a��ɑΉ��������t�ϊ��p�֐�}
function StrToDateEx(str: string): TDateTime;
{TDateTime���A�a��ɕϊ�����}
function DateToWareki(d: TDateTime): string;

{------------------------------------------------------------------------------}
{���̑�}

{Insert Comma 3keta}
function InsertYenComma(const yen: string): string;
{�������o������萔�l�ɕϊ�����}
function StrToValue(const str: string): Extended;
function WildMatch(Filename,Mask:string):Boolean;
{gyousoroe}
function CutLine(line: string; cnt,tabCnt: Integer; kinsoku: string): string;


{------------------------------------------------------------------------------}
implementation


{�s��������}
function CutLine(line: string; cnt,tabCnt: Integer; kinsoku: string): string;
(*
const
  GYOUTOU_KINSI = '�A�B�C�D�E�H�I�J�K�R�S�T�U�X�[�j�n�p�v�x!),.:;?]}�������';
*)
var
    p, pr,pr_s: PChar;
    i,len: Integer;

    procedure CopyOne;
    begin
        pr^ := p^; Inc(pr); Inc(p);
    end;

    procedure InsCrLf;
    var next_c: string;
    begin
        //�֑�����(�s���֑�����)
        if kinsoku<>'' then
        begin
            if p^ in LeadBytes then
            begin
                next_c := p^ + (p+1)^;
            end else
            begin
                next_c := p^;
            end;

            if JPosEx(next_c, kinsoku, 1)>0 then
            begin
                if p^ in LeadBytes then
                begin
                    CopyOne; CopyOne;
                end else
                begin
                    CopyOne;
                end;
            end;
        end;

        pr^ := #13; Inc(pr);
        pr^ := #10; Inc(pr);
        i := 0;
    end;

begin
    if cnt<=0 then
    begin
        Result := line;
        Exit;
    end;

    len := Length(line);
    SetLength(Result, len + (len div cnt)*2 + 1);

    pr := PChar(Result); pr_s := pr;
    p  := PChar(line);
    i := 0;
    while p^ <> #0 do
    begin
        if p^ in LeadBytes then
        begin
            if (i+2) > cnt then InsCrLf;
            CopyOne;
            CopyOne;
            Inc(i,2);
        end else
        begin
            if i >= cnt then InsCrLf;
            if p^ in [#13,#10] then
            begin
                Inc(p);
                if p^ in[#13,#10] then Inc(p);
                InsCrLf;
            end else
            if p^ = #9 then
            begin
                CopyOne;
                Inc(i, tabCnt);
            end else
            begin
                CopyOne;
                Inc(i);
            end;
        end;
    end;

    pr^ := #0;
    Result := string( pr_s );
end;

{TDateTime���A�a��ɕϊ�����}
function DateToWareki(d: TDateTime): string;
var y, yy, mm, dd: Word; sy: string;

const
  MEIJI  = 1869;
  TAISYO = 1912;
  SYOWA  = 1926;
  HEISEI = 1989;
begin
    DecodeDate(d, yy, mm, dd);
    if (MEIJI<=yy)and(yy<TAISYO) then
    begin
        y := yy-MEIJI+1;
        if y=1 then sy := '���N' else sy := IntToStr(y)+'�N';
        Result := Format('����'+sy+'%d��%d��',[mm,dd]);
    end else
    if (TAISYO<=yy)and(yy<SYOWA) then
    begin
        y := yy-TAISYO+1;
        if y=1 then sy := '���N' else sy := IntToStr(y)+'�N';
        Result := Format('�吳'+sy+'%d��%d��',[mm,dd]);
    end else
    if (SYOWA<=yy)and(yy<HEISEI) then
    begin
        y := yy-SYOWA+1;
        if y=1 then sy := '���N' else sy := IntToStr(y)+'�N';
        Result := Format('���a'+sy+'%d��%d��',[mm,dd]);
    end else
    if (HEISEI<=yy) then
    begin
        y := yy-HEISEI+1;
        if y=1 then sy := '���N' else sy := IntToStr(y)+'�N';
        Result := Format('����'+sy+'%d��%d��',[mm,dd]);
    end;
end;

{MutiByte�������𓾂�}
function JLength(const str: string): Integer;
var
	p: PChar;
begin
	p := PChar(str);
    Result := 0;
    while p^ <> #0 do
    begin
    	if p^ in LeadBytes then
        	Inc(p,2)
        else
        	Inc(p);
        Inc(Result);
    end;
end;

{MutiByte�������؂�o��}
function JCopy(const str: string; Index, Count: Integer): string;
var
    i, iTo: Integer;
    p: PChar;
    ch: string;
begin
    i   := 1;
    iTo := Index + Count -1;
    p := PChar(str);
    Result := '';
    while (p^ <> #0) do
    begin
        if p^ in LeadBytes then
        begin
            ch := p^ + (p+1)^;
            Inc(p,2);
        end else
        begin
            ch :=p^;
            Inc(p);
        end;
        if (Index <= i) and (i <= iTo) then
        begin
            Result := Result + ch;
        end;
        Inc(i);
        if iTo < i then Break;
    end;
end;

{MutiByte���������������}
function JPosM(const sub, str: string): Integer;
var
    i, len: Integer;
    p, ps: PChar;
begin
    i := 1;
    Result := 0;
    p := PChar(str);
    ps := PChar(sub);
    len := Length(sub);
    while p^ <> #0 do
    begin
        if StrLComp(p, ps, len) = 0 then
        begin
            Result := i; Break;
        end;
        if p^ in LeadBytes then
        begin
            Inc(p,2);
        end else
        begin
            Inc(p);
        end;
        Inc(i);
    end;
end;

function Asc(const str: string): Integer; //�����R�[�h�𓾂�
begin
    if str='' then begin
		Result := 0;
    	Exit;
    end;

    if str[1] in LeadBytes then
    begin
    	Result := (Ord(str[1]) shl 8) + Ord(str[2]);
    end else
    	Result := Ord(str[1]);
end;

{����A�a��ɑΉ��������t�ϊ��p�֐�}
function StrToDateStr(str: string): string;
begin
    Result:='';
    if str='' then Exit;
    Result := FormatDateTime(
        'yyyy/mm/dd',
        StrToDateEx(str)
    );
end;

function StrToDateEx(str: string): TDateTime;
begin
    Result := Now;
    if str='' then Exit;
    if Pos('.',str)>0 then str := JReplace(str,'.','/',True);
    Result := VarToDateTime(str); 
end;

{���Ԃ̉��Z ex)�R���Ԍ� IncTime('15:0:0','3:0:0') �O�b�O IncTime('12:45:0','-0:0:3')}
function IncTime(BaseTime: TDateTime; AddTime: string): TDateTime;
var
    flg: string;
    h,n,s, hh,nn,ss,dummy: Word;
    th,tn,ts: Integer;
begin
    flg := Copy(AddTime,1,1);
    if (flg='-')or(flg='+') then Delete(AddTime, 1,1);

    DecodeTime(BaseTime, h, n, s, dummy);
    hh := StrToIntDef(getToken(':', AddTime),0);
    nn := StrToIntDef(getToken(':', AddTime),0);
    ss := StrToIntDef(AddTime, 0);
    if flg <> '-' then
    begin
        Inc(h,hh); Inc(n,nn); Inc(s,ss);
        while True do
        begin
            while s >= 60 do begin
                Dec(s,60);
                Inc(n);
            end;
            while n >= 60 do begin
                Dec(n,60);
                Inc(h);
            end;
            h := h mod 24;
            if(s<60)and(n<60)then Break;
        end;
    end else
    begin
        //Dec(h,hh); Dec(n,nn); Dec(s,ss);
        th := h - hh;
        tn := n - nn;
        ts := s - ss;
        while True do
        begin
            while ts < 0 do
            begin
                Inc(ts,60);
                Dec(tn);
            end;
            if tn < 1 then
            begin
                tn := 59;
                Dec(th);
                if th < 1 then begin
                    th := 23;
                end;
            end;
            while th < 0 do
            begin
                Inc(th,24);
            end;
            if(ts>=0)and(tn>=1)then
            begin
                h := Word(th);
                n := Word(tn);
                s := Word(ts);
                Break;
            end;
        end;
    end;
    Result := EncodeTime(h,n,s,0);
end;

{���t�̉��Z ex)�R������ IncDate('2001/10/30','0/3/0') �O���O IncDate('2001/1/1','-0/0/3')}
function IncDate(BaseDate: TDateTime; AddDate: string): TDateTime;
var
    flg: string;
    y,m,d, yy,mm,dd: Word;
    maxD: Word;
    ty,tm,td: Integer;
begin
    flg := Copy(AddDate,1,1);
    if (flg='-')or(flg='+') then Delete(AddDate, 1,1);

    DecodeDate(BaseDate, y, m, d);
    yy := StrToIntDef(getToken('/', AddDate),0);
    mm := StrToIntDef(getToken('/', AddDate),0);
    dd := StrToIntDef(AddDate, 0);
    if flg <> '-' then
    begin
        Inc(y,yy);

        Inc(m,mm); // ���̑����Z
        if m > 12 then begin
            Inc(y, (m div 12));
            m := m mod 12;
        end;
        maxD := (SysUtils.MonthDays[IsLeapYear(y)])[m];
        if d > maxD then d := maxD;

        Inc(d,dd); // ���̑����Z
        while True do
        begin
            maxD := (SysUtils.MonthDays[IsLeapYear(y)])[m];
            if d > maxD then
            begin
                Inc(m); if m > 12 then begin Inc(y); Dec(m,12); end;
                Dec(d, maxD);
            end else Break;
        end;
    end else
    begin
        //Dec(y,yy); Dec(m,mm); Dec(d,dd);
        ty := y-yy;
        tm := m-mm; //���̈����Z
        while tm < 1 do
        begin
            Inc(tm,12);
            Dec(ty,1);
        end;
        td := d;

        if ty<1900 then begin raise ERangeError.Create('1900�N�ȉ��͌v�Z�ł��܂���B');  end;
        maxD := (SysUtils.MonthDays[IsLeapYear(ty)])[tm];
        if td > maxD then td := maxD;

        td := td-dd; //���̈����Z
        while True do
        begin
            if td < 1 then
            begin
                Dec(tm);
                if tm < 1 then begin
                    Dec(ty);
                    tm := 12;
                end;
                maxD := (SysUtils.MonthDays[IsLeapYear(ty)])[tm];
                Inc(td, maxD);
            end else
            if (ty>=1)and(tm>=1)and(td>=1) then
            begin
                y := ty; m := tm; d := td;
                Break;
            end else Break;
        end;
    end;
    Result := EncodeDate(y,m,d);
end;

procedure skipSpace(var p: PChar);
begin
    while p^ in [' ',#9] do Inc(p);
end;

{�l�X�g����i�j�̓��e�𔲂��o��}
function GetKakko(var pp: PChar): string;
const
    CH_STR1 = '"';
    CH_STR2 = '''';
var
	nest, len: Integer;
    tmp, buf: PChar;
    IsStr, IsStr2: Boolean;
begin
    Result := '';
	skipSpace(pp);
    nest := 0;
    IsStr := False;
    IsStr2 := False;
    if pp^ = '(' then
    begin
    	Inc(nest);
        Inc(pp);
    end;
	tmp := pp;
    while pp^ <> #0 do
    begin
        if pp^ in LeadBytes then
        begin
        	Inc(pp,2); continue;
        end else
    	case pp^ of
            CH_STR1:
            begin
                if IsStr2 = False then
            	    IsStr := not IsStr;
                Inc(pp);
            end;
            CH_STR2:
            begin
                if IsStr = False then
            	    IsStr2 := not IsStr2;
                Inc(pp);
            end;
            '\':
            begin
            	Inc(pp);
                if IsStr then if pp^ in LeadBytes then Inc(pp,2) else Inc(pp);
            end;
        	'(':
            begin
            	Inc(pp);
                if (IsStr=False)and(IsStr2=False) then
                begin
                	Inc(nest); continue;
                end;
            end;
            ')':
            begin
            	Inc(pp);
                if (IsStr=False)and(IsStr2=False) then
                begin
                	Dec(nest);
                	if nest = 0 then Break;
                	continue;
                end;
            end;
            else
            	Inc(pp);
        end;
    end;
    len := pp - tmp -1;
    if len<=0 then
    begin
        if nest <> 0 then
        begin
            pp := tmp;
            raise Exception.Create('")"���Ή����Ă��܂���B');
        end;
        Exit;
    end;
    if nest > 0 then raise Exception.Create('")"���Ή����Ă��܂���B');
    GetMem(buf, len + 1);
    try
    	StrLCopy(buf, tmp, len);
        (buf+len)^ := #0;
        Result := string( PChar(buf) );
    finally
    	FreeMem(buf);
    end;
end;


function WildMatch(Filename,Mask:string):Boolean;
begin
    Result := MatchesMask(Filename, Mask);
end;


{������𐔒l�ɕϊ�����}
function StrToValue(const str: string): Extended;
var
    st,p,mem,pt: PChar;
    len, sig: Integer;
    buf: string;

    function convToHalfMini(sSrc: string): string;
    var
      cSrc : array [0..255] of char;
      cDst : array [0..255] of char;
    begin
      StrLCopy( cSrc, PChar(sSrc), 254  );
      FillChar( cDst, sizeof(cDst), 0);
      LCMapString( LOCALE_SYSTEM_DEFAULT, LCMAP_HALFWIDTH, cSrc, strlen(cSrc),cDst, sizeof(cDst) );
      Result := cDst;
    end;

begin

    // �͂��߂ɁA�����𔼊p�ɂ���
    if str='' then begin Result := 0; Exit; end;

    buf := Trim(JReplace(ConvToHalfMini(str),',','',True));//�J���}���폜

    p := PChar(buf);
    while p^ in [' ',#9] do Inc(p);
    if p^='$' then
    begin
        Result := StrToIntDef(buf,0);
        Exit;
    end;

    sig := 1;

    if p^ = '+' then Inc(p) else
    if p^ ='-' then
    begin
        Inc(p);
        sig := -1;
    end;

    st := p;
    while p^ in ['0'..'9'] do Inc(p);
    if p^ = '.' then
    begin
        Inc(p); // skip .
        while True do
        begin
            if p^ in ['0'..'9'] then Inc(p)
            else if p^ in ['e','E'] then begin
                pt := p;
                Inc(p);
                if p^ in ['+','-'] then Inc(p);
                if p^ in ['0'..'9'] then
                begin
                    while p^ in ['0'..'9'] do Inc(p);
                    Break;
                end else
                begin
                    p := pt; Break;
                end;
            end else Break;
        end;
    end;

    len := p - st;
    if len=0 then begin Result:=0; Exit; end;

    GetMem(mem, len+1);
    try
        StrLCopy(mem, st, len);
        (mem+len)^ := #0;
        Result := sig * StrToFloat(string(mem));
    finally
        FreeMem(mem);
    end;
end;


function GetToken(const delimiter: String; var str: string): String;
var
    i: Integer;
begin
    i := JPosEx(delimiter, str,1);
    if i=0 then
    begin
        Result := str;
        str := '';
        Exit;
    end;
    Result := Copy(str, 1, i-1);
    Delete(str,1,i + Length(delimiter) -1);
end;

{HTML ���� �^�O����菜��}
function DeleteTag(const html: string): String;
var
  i: Integer;
  txt: String;
  TagIn: Boolean;
begin
    txt := Trim(html);
    if txt = '' then Exit;

    i := 1;
    Result := '';

    TagIn := False;
    while i <= Length(txt) do
    begin

        if txt[i] in SysUtils.LeadBytes then
        begin
            if TagIn=False then
                Result := Result + txt[i] + txt[i+1];

            Inc(i,2);
            Continue;
        end;
        case txt[i] of
            '<': //TAG in
            begin
                TagIn := True;
                Inc(i);
            end;
            '>': //TAG out
            begin
                TagIn := False;
                Inc(i);
            end;
            else
            begin
                if TagIn then
                begin // to skip
                    Inc(i);
                end else
                begin
                    Result := Result + txt[i];
                    Inc(i);
                end;
            end;
        end;

    end;
end;

{HTML�̎w��^�O�ň͂�ꂽ�����𔲂��o��}
function GetTag(var html:string; tag: string): string;
var
	top, p,pp, res_in, res_out: PChar;
    ltag,utag: string;
    len: Integer;
begin
    if (Copy(tag,1,1)='<')and(Copy(tag,Length(tag),1)='>') then
    begin
        Delete(tag,1,1);
        Delete(tag,Length(tag),1);
    end;

	Result := '';
	if html='' then Exit;
	p := PChar(html);
    top := p;
    ltag := LowerCaseEx(tag);
    utag := UpperCaseEx(tag);

    res_in := nil;
    //res_out := nil;
    // ���o��
    while p^ <> #0 do
    begin
    	if p^ = '<' then
        begin
        	pp := p;
            Inc(pp);
            if (StrLComp(pp, PChar(ltag), Length(ltag))=0)or
            	(StrLComp(pp, PChar(utag), Length(utag))=0) then
            begin
            	res_in := p;
                while not(p^ in ['>',#0]) do Inc(p); if p^='>' then Inc(p);
            	Break;
            end;
        end;
        Inc(p);
    end;
    if (res_in = nil)or(p^=#0) then
    begin
    	html := '';
        Exit;
    end;
    res_out := (p-1);
    // �Ō�o��
    while p^ <> #0 do
    begin
    	if (p^ = '<')and((p+1)^='/') then
        begin
            Inc(p,2);
            if (StrLComp(p, PChar(ltag), Length(ltag))=0)or
            	(StrLComp(p, PChar(utag), Length(utag))=0) then
            begin
            	while not(p^ in ['>',#0]) do Inc(p);
            	res_out := p;
                Break;
            end;
        end;
        Inc(p);
    end;
    if (res_out=nil) then
    begin
    	html := '';
        Exit;
    end;
    len := res_out - res_in + 1;
    SetLength(Result, len+1);
    StrLCopy(PChar(result),res_in, len);
    Result[len+1] := #0;
    Result := string( PChar(Result) );
    //
    len := res_out - top;
    Delete(html,1, len);
end;
function GetTags(html:string; tag: string): string;
var
	s: string;
begin
	Result := '';
    while html <> '' do
    begin
    	s := GetTag(html, tag);
        if s<>'' then
        	Result := Result + s + #13#10;
    end;
end;

function InsertYenComma(const yen: string): string;
begin
    if Pos('.',yen)=0 then
    begin
        Result := FormatCurr('#,##0', StrToValue(yen));
    end else
    begin
        Result := FormatCurr('#,##0.00', StrToValue(yen));
    end;
end;

function RomajiToKana(romaji: String): String;
const
    kana_list = 'k,�����,s,�����,t,�����,n,�����,h,�����,m,�����,y,2� � � ��� ,r,�����,w,2� ��� ��� ,'+
    'g,2�޷޸޹޺�,z,2�޼޽޾޿�,d,2����������,b,2����������,p,2����������,'+
    'q,2����� ����,f,2̧̨� ̪̫,j,3�ެ�� �ޭ�ު�ޮ,l,�����,x,�����,c,�����,'+
    'v,3�ާ�ި�� �ު�ޫ,f,�����'+
    'ky,2����������,sy,2����������,ty,2����������,ny,2ƬƨƭƪƮ,hy,2ˬ˨˭˪ˮ,'+
    'my,2ЬШЭЪЮ,by,3�ެ�ި�ޭ�ު�ޮ,cy,2����������,ch,2��� ������,sh,2��� ������';
var
    p: PChar;
    siin: string;
    siin_s, siin_k: array [0..50] of string;

    function GetBoinNo(c: Char): Integer;
    begin
        case c of
        'a': Result := 0;
        'i': Result := 1;
        'u': Result := 2;
        'e': Result := 3;
        'o': Result := 4;
        else Result := 0;
        end;
    end;

    function GetSiinCh(s: string; c: Char): string;
    var i,len: Integer;
    begin
        Result := '';
        if s='' then Exit;
        i := GetBoinNo(c);
        if s[1] in ['1'..'9'] then
        begin
            len := StrToIntDef(s[1],1);
            Delete(s,1,1);
            Result := Trim(Copy(s, i*2+1, len));
        end else
        begin
            Result := s[i+1];
        end;
    end;

    procedure DecideChar(c: Char);
    var i:Integer;
    begin
        if siin = '' then begin
            Result := Result + Copy('�����',GetBoinNo(c)+1,1);
        end else
        begin
            for i:=0 to High(siin_k) do
            begin
                if siin = siin_s[i] then
                begin
                    Result := Result + GetSiinCh( siin_k[i], c);
                    Break;
                end;
            end;
        end;

    end;

    procedure getKanaList;
    var i: Integer; s,ss: string;
    begin
        ss := kana_list; i:=0;
        while ss<>'' do
        begin
            s := GetToken(',', ss);
            siin_s[i] := s;
            s := GetToken(',', ss);
            siin_k[i] := s;
            Inc(i);
        end;
    end;

begin
    Result := '';
    romaji := LowerCase(convToHalf(romaji));
    if romaji='' then Exit;

    getKanaList;

    siin := '';
    p := PChar(romaji);
    while p^ <> #0 do
    begin
        if p^='-' then
        begin
            Result := Result + '�';
            Inc(p); siin := '';
            Continue;
        end else
        if p^ in ['a','i','u','e','o'] then
        begin //�ꉹ�Ȃ̂Ō���
            DecideChar(p^);
            Inc(p);
            siin := '';
            Continue;
        end else
        if p^ in ['a'..'z'] then
        begin
            if (siin='n')and(p^<>'y') then
            begin
                Result := Result + '�';
                siin := p^;
                Inc(p);
                Continue;
            end;
            if Copy(siin,Length(siin),1)=p^ then
            begin
                Inc(p);
                Result := Result + '�';
                Continue;
            end;
            siin := siin + p^;
            Inc(p);
        end else
        begin //�L�������Ȃ�
            Result := Result + p^;
            Inc(p);
        end;
    end;

end;

{� ���m�� �̂悤�ȍs���̔��p�J�i���폜���ĕԂ�}
function TrimLeftKana(str: string): string;
begin
    Result := '';
    if str='' then Exit;

    if (str[1] in ['�'..'�'])and(Copy(str,2,1)=' ') then
    begin
        Delete(str,1,1);
    end;
    Result := Trim(str);
end;

function JPosEx(const sub, str:string; idx:Integer): Integer;
var
	p, sub_p, temp: PChar; len, str_len: Integer;
begin
    Result := 0;
    // �֐��̈����G���[�`�F�b�N
    str_len := Length(str);
    if str_len < idx then Exit;
    if idx < 1 then idx := 1;
    if (sub='')or(str='') then Exit;
    // ��������
	temp := PChar(str); p:= temp;
    Inc(p, idx-1);
    sub_p := PChar(sub);
	len := Length(sub);
    // �����񒆂����[�v���Ȃ��猟��(���j�A�T�[�`)
    while ((p-temp+1) <= str_len) do
    begin
    	if AnsiStrLComp(sub_p, p, len)=0 then
        begin
    		Result := (p - temp) + 1;
        	Exit;
        end;
    	if p^ in SysUtils.LeadBytes then Inc(p,2) else Inc(p);
    end;
end;

function JReplace(const Str, oldStr, newStr:string; repAll:Boolean): string;
var
	i, idx:Integer;
begin
	Result := Str;
    // ****
	i := JPosEx(oldStr, Str, 1);
    if i=0 then Exit;
    Delete(result, i, Length(oldStr));
    Insert(newStr, result, i);
    idx := i + Length(newStr);
    if repAll = False then Exit;
    // *** Loop
    while True do
    begin
    	i := JPosEx(oldStr, result, idx);
        if i=0 then Exit;
        Delete(result, i, Length(oldStr));
        Insert(newStr, result, i);
        idx := i + Length(newStr);
    end;
end;

function JReplaceEx(const Str, oldStr, newStr:string; repAll:Boolean; useCase:Boolean): string;
var
	i, idx:Integer;
    oldStrFind: string;
    strFind: string;
begin
	Result := Str;
    oldStrFind := UpperCaseEx(oldStr);
    strFind := UpperCaseEx(Result);
    // ****
	i := JPosEx(oldStrFind, strFind, 1);
    if i=0 then Exit;
    Delete(result, i, Length(oldStr));
    Insert(newStr, result, i);
    idx := i + Length(newStr);
    if repAll = False then Exit;
    // *** Loop
    while True do
    begin
        oldStrFind := UpperCaseEx(oldStr);
        strFind := UpperCaseEx(Result);
    	i := JPosEx(oldStrFind, strFind, idx);
        if i=0 then Exit;
        Delete(result, i, Length(oldStr));
        Insert(newStr, result, i);
        idx := i + Length(newStr);
    end;
end;


{LCMapString-------------------------------------------------------------------}
function LCMapStringEx(const str: string; MapFlag: DWORD): string;
var
    pDes: PChar;
    len,len2: Integer;
begin
    if str='' then begin Result := ''; Exit; end;
    len  := Length(str);
    len2 := len*2+2;
    GetMem(pDes, len2);//half -> full
    FillChar( pDes^, len2, 0 );
    LCMapString( LOCALE_SYSTEM_DEFAULT, MapFlag, PChar(str), len, pDes, len2-1);
    Result := string( pDes );
end;
function LCMapStringExHalf(const str: string; MapFlag: DWORD): string;
var
    pDes: PChar;
    len,len2: Integer;
begin
    if str='' then begin Result := ''; Exit; end;
    len  := Length(str);
    len2 := len+2;
    GetMem(pDes, len2);
    FillChar( pDes^, len2, 0 );
    LCMapString( LOCALE_SYSTEM_DEFAULT, MapFlag, PChar(str), len, pDes, len2-1);
    Result := string( pDes );
end;
function convToFull(const str: string): string;
begin
    Result := LCMapStringEx( str, LCMAP_FULLWIDTH );
end;

function convToHalf(const str: string): string;
begin
    Result := LCMapStringEx( str, LCMAP_HALFWIDTH );
end;
{�Ђ炪�ȁE�J�^�J�i�̕ϊ�}
function convToHiragana(const str: string): string;
begin
    Result := LCMapStringEx( str, LCMAP_HIRAGANA );
end;
function convToKatakana(const str: string): string;
begin
    Result := LCMapStringEx( str, LCMAP_KATAKANA );
end;
{MutiByte���l�������啶���A��������}
function LowerCaseEx(const str: string): string;
begin
    Result := LCMapStringExHalf( str, LCMAP_LOWERCASE );
end;
function UpperCaseEx(const str: string): string;
begin
    Result := LCMapStringExHalf( str, LCMAP_UPPERCASE );
end;

function convToHalfAnk(const str: string): string;
var
    p,pr: PChar;
    s: string;
    i: Integer;
const
    HALF_JOUKEN = '�O�P�Q�R�S�T�U�V�W�X'+
        '����������������������������������������������������'+
        '�`�a�b�c�d�e�f�g�h�i�j�k�l�m�n�o�p�q�r�s�t�u�v�w�x�y'+
        '�I�h���������f�i�j���|���m�n�o�p�Q�^�����C�D���e�@';

begin
    SetLength(Result, Length(str)+1);//�Ƃ肠�����K���ȑ傫�����m��
    p  := PChar(str);
    pr := PChar(Result);

    while p^ <> #0 do
    begin
        if p^ in LeadBytes then
        begin
            s := p^ + (p+1)^;
            i := Pos(s, HALF_JOUKEN);
            if (i>0)and(((i-1)mod 2)=0) then //�������r���ŕ��f����Ă���̂�h�����߁Amod 2=0 �Ń`�F�b�N
            begin
                s := convToHalf(s);
                pr^ := s[1]; Inc(pr);
                Inc(p,2);
            end else
            begin
                pr^ := p^; Inc(pr); Inc(p);
                pr^ := p^; Inc(pr); Inc(p);
            end;
        end else
        begin // ���� ank
            pr^ := p^ ; Inc(pr); Inc(p);
        end;
    end;
    pr^ := #0;
    Result := string(PChar(Result));
end;

{�g�[�N������}
{�g�[�N���؂�o���^��؂蕶������i�߂�}
function GetTokenChars(delimiter: TCharSet; var ptr:PChar): string;
begin
	Result := '';
	while ptr^ <> #0 do
    begin
    	if ptr^ in LeadBytes then
        begin
        	Result := Result + ptr^ + (ptr+1)^;
            Inc(ptr,2);
        end else
        begin
        	if ptr^ in delimiter then
            begin
            	Inc(ptr);
                Break;
            end;
            Result := Result + ptr^;
            Inc(ptr);
        end;
    end;
end;


function IsHiragana(const str: string): Boolean;
var code: Integer;
begin
    Result := False;
    if Length(str)<2 then Exit;
    code := (Ord(str[1])shl 8) + Ord(str[2]);
    if ($82A0 <= code)and(code <= $833E) then Result := True;
end;

function IsKatakana(const str: string): Boolean;
var code: Integer;
begin
    Result := False;
    if Length(str)<2 then Exit;
    code := (Ord(str[1])shl 8) + Ord(str[2]);
    if ($8340 <= code)and(code <= $839D) then Result := True;
end;

function IsNumStr(const str: string): Boolean; //�����񂪑S�Đ��l���ǂ������f
var
    p: PChar;
begin
    Result := False;
    p := PChar(str);

    if not (p^ in ['0'..'9']) then Exit;
    Inc(p);

    while p^ <> #0 do
    begin
        if p^ in ['0'..'9','e','E','+','-','.'] then //���������_�ɑΉ�
            Inc(p)
        else
            Exit;
    end;
    Result := True;
end;

end.
