unit StrUnit;
(*------------------------------------------------------------------------------
汎用文字列処理を定義したユニット

全ての関数は、マルチバイト文字(S-JIS)に対応している

作成者：クジラ飛行机( web@kujirahand.com ) https://sakuramml.com
作成日：2001/11/24

履歴：
2002/04/09 途中に#0を含む文字列でも検索置換できるように修正

------------------------------------------------------------------------------*)
interface
uses
  {$ifdef Win32}
  Windows, 
  {$endif}
  SysUtils, Classes, EasyMasks,
  Variants;

type
  TCharSet = set of Char;

(******************************************************************************)
// multibyte function

{文字列検索 // ｎバイト目の文字の位置を返す}
function JPosEx(const sub, str:string; idx:Integer): Integer;
{文字列置換}
function JReplace(const Str, oldStr, newStr:string; repAll:Boolean): string;
{文字列置換拡張版}
function JReplaceEx(const Str, oldStr, newStr:string; repAll:Boolean; useCase:Boolean): string;
{デリミタ文字列までの単語を切り出す。（切り出した単語にデリミタは含まない。）
切り出し後は、元の文字列strから、切り出した文字列＋デリミタ分を削除する。}
function GetToken(const delimiter: String; var str: string): String;
{Multibyte文字数を得る}
function JLength(const str: string): Integer;
{Multibyte文字列を切り出す}
function JCopy(const str: string; Index, Count: Integer): string;
{Mutibyte文字列を検索する}
function JPosM(const sub, str: string): Integer;

{------------------------------------------------------------------------------}
{文字種類の変換}

{全角変換}
function convToFull(const str: string): string;
{半角変換}
function convToHalf(const str: string): string;
{数字とアルファベットと記号のみ半角に変換する/但し遅い}
function convToHalfAnk(const str: string): string;

{------------------------------------------------------------------------------}
{文字種類の判別}
function IsHiragana(const str: string): Boolean;
function IsKatakana(const str: string): Boolean;
function Asc(const str: string): Integer; //文字コードを得る
function IsNumStr(const str: string): Boolean; //文字列が全て数値かどうか判断

{------------------------------------------------------------------------------}
{HTML処理}

{HTML から タグを取り除く}
function DeleteTag(const html: string): String;
{HTMLの指定タグで囲われた部分を抜き出す}
function GetTag(var html:string; tag: string): string;
function GetTags(html:string; tag: string): string;

{------------------------------------------------------------------------------}
{トークン処理}

{トークン切り出し／区切り文字分を進める}
function GetTokenChars(delimiter: TCharSet; var ptr:PChar): string;
{ネストする（）の内容を抜き出す}
function GetKakko(var pp: PChar): string;

{------------------------------------------------------------------------------}
{日時処理}

{日付の加算 ex)３ヵ月後 IncDate('2001/10/30','0/3/0') 三日前 IncDate('2001/1/1','-0/0/3')}
function IncDate(BaseDate: TDateTime; AddDate: string): TDateTime;
{時間の加算 ex)３時間後 IncTime('15:0:0','3:0:0') 三秒前 IncTime('12:45:0','-0:0:3')}
function IncTime(BaseTime: TDateTime; AddTime: string): TDateTime;
{西暦、和暦に対応した日付変換用関数}
function StrToDateStr(str: string): string;
{西暦、和暦に対応した日付変換用関数}
function StrToDateEx(str: string): TDateTime;
{TDateTimeを、和暦に変換する}
function DateToWareki(d: TDateTime): string;

{------------------------------------------------------------------------------}
{その他}

{Insert Comma 3keta}
function InsertYenComma(const yen: string): string;
{文字を出来る限り数値に変換する}
function StrToValue(const str: string): Extended;
function WildMatch(Filename,Mask:string):Boolean;
{gyousoroe}
function CutLine(line: string; cnt,tabCnt: Integer; kinsoku: string): string;


{------------------------------------------------------------------------------}
implementation


{行揃えする}
function CutLine(line: string; cnt,tabCnt: Integer; kinsoku: string): string;
(*
const
  GYOUTOU_KINSI = '、。，．・？！゛゜ヽヾゝゞ々ー）］｝」』!),.:;?]}｡｣､･ｰﾞﾟ';
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
        //禁則処理(行頭禁則文字)
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

{TDateTimeを、和暦に変換する}
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
        if y=1 then sy := '元年' else sy := IntToStr(y)+'年';
        Result := Format('明治'+sy+'%d月%d日',[mm,dd]);
    end else
    if (TAISYO<=yy)and(yy<SYOWA) then
    begin
        y := yy-TAISYO+1;
        if y=1 then sy := '元年' else sy := IntToStr(y)+'年';
        Result := Format('大正'+sy+'%d月%d日',[mm,dd]);
    end else
    if (SYOWA<=yy)and(yy<HEISEI) then
    begin
        y := yy-SYOWA+1;
        if y=1 then sy := '元年' else sy := IntToStr(y)+'年';
        Result := Format('昭和'+sy+'%d月%d日',[mm,dd]);
    end else
    if (HEISEI<=yy) then
    begin
        y := yy-HEISEI+1;
        if y=1 then sy := '元年' else sy := IntToStr(y)+'年';
        Result := Format('平成'+sy+'%d月%d日',[mm,dd]);
    end;
end;

{MutiByte文字数を得る}
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

{MutiByte文字列を切り出す}
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

{MutiByte文字列を検索する}
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

function Asc(const str: string): Integer; //文字コードを得る
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

{西暦、和暦に対応した日付変換用関数}
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

{時間の加算 ex)３時間後 IncTime('15:0:0','3:0:0') 三秒前 IncTime('12:45:0','-0:0:3')}
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

{日付の加算 ex)３ヵ月後 IncDate('2001/10/30','0/3/0') 三日前 IncDate('2001/1/1','-0/0/3')}
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

        Inc(m,mm); // 月の足し算
        if m > 12 then begin
            Inc(y, (m div 12));
            m := m mod 12;
        end;
        maxD := (SysUtils.MonthDays[IsLeapYear(y)])[m];
        if d > maxD then d := maxD;

        Inc(d,dd); // 日の足し算
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
        tm := m-mm; //月の引き算
        while tm < 1 do
        begin
            Inc(tm,12);
            Dec(ty,1);
        end;
        td := d;

        if ty<1900 then begin raise ERangeError.Create('1900年以下は計算できません。');  end;
        maxD := (SysUtils.MonthDays[IsLeapYear(ty)])[tm];
        if td > maxD then td := maxD;

        td := td-dd; //日の引き算
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

{ネストする（）の内容を抜き出す}
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
            raise Exception.Create('")"が対応していません。');
        end;
        Exit;
    end;
    if nest > 0 then raise Exception.Create('")"が対応していません。');
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


{文字列を数値に変換する}
function StrToValue(const str: string): Extended;
var
    st,p,mem,pt: PChar;
    len, sig: Integer;
    buf: string;
begin

    // はじめに、数字を半角にする
    if str='' then begin Result := 0; Exit; end;

    buf := Trim(JReplace(convToHalf(str),',','',True));//カンマを削除

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

{HTML から タグを取り除く}
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

{HTMLの指定タグで囲われた部分を抜き出す}
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
    ltag := LowerCase(tag);
    utag := UpperCase(tag);

    res_in := nil;
    //res_out := nil;
    // 頭出し
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
    // 最後出し
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

function JPosEx(const sub, str:string; idx:Integer): Integer;
var
	p, sub_p, temp: PChar; len, str_len: Integer;
begin
    Result := 0;
    // 関数の引数エラーチェック
    str_len := Length(str);
    if str_len < idx then Exit;
    if idx < 1 then idx := 1;
    if (sub='')or(str='') then Exit;
    // 検索準備
	temp := PChar(str); p:= temp;
    Inc(p, idx-1);
    sub_p := PChar(sub);
	len := Length(sub);
    // 文字列中をループしながら検索(リニアサーチ)
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
    oldStrFind := UpperCase(oldStr);
    strFind := UpperCase(Result);
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
        oldStrFind := UpperCase(oldStr);
        strFind := UpperCase(Result);
    	i := JPosEx(oldStrFind, strFind, idx);
        if i=0 then Exit;
        Delete(result, i, Length(oldStr));
        Insert(newStr, result, i);
        idx := i + Length(newStr);
    end;
end;

function convToFull(const str: string): string;
begin
  Result := str;
  raise Exception.Create('not implements');
end;

function convToHalf(const str: string): string;
begin
    Result := convToHalfAnk(str);
end;

function convToHalfAnk(const str: string): string;
var
    p,pr: PChar;
    s: string;
    i: Integer;
const
    HALF_JOUKEN = '０１２３４５６７８９'+
        'ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ'+
        'ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ'+
        '！”＃＄％＆’（）＝－￥［］｛｝＿／＞＜，．＠‘　';

begin
    SetLength(Result, Length(str)+1);//とりあえず適当な大きさを確保
    p  := PChar(str);
    pr := PChar(Result);

    while p^ <> #0 do
    begin
        if p^ in LeadBytes then
        begin
            s := p^ + (p+1)^;
            i := Pos(s, HALF_JOUKEN);
            if (i>0)and(((i-1)mod 2)=0) then //文字が途中で分断されているのを防ぐため、mod 2=0 でチェック
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
        begin // 既に ank
            pr^ := p^ ; Inc(pr); Inc(p);
        end;
    end;
    pr^ := #0;
    Result := string(PChar(Result));
end;

function convToFullAnk(const str: string): string;
begin
  Result := str;
end;


{トークン処理}
{トークン切り出し／区切り文字分を進める}
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

function IsNumStr(const str: string): Boolean; //文字列が全て数値かどうか判断
var
    p: PChar;
begin
    Result := False;
    p := PChar(str);

    if not (p^ in ['0'..'9']) then Exit;
    Inc(p);

    while p^ <> #0 do
    begin
        if p^ in ['0'..'9','e','E','+','-','.'] then //浮動小数点に対応
            Inc(p)
        else
            Exit;
    end;
    Result := True;
end;

end.
