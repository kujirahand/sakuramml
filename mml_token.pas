unit mml_token;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 https://sakuramml.com
説　明：トークンの切り出し、ストトンへの変換を行う下請けユニット
履　歴：

2002/06/03 15:13 雛型作成
2002/11/22 12:22 ストトンのアルゴリズム変更
-------------------------------------------------------------------------------}

interface

uses
  {$ifdef Win32}
  Windows,
  {$endif}
  SysUtils,
  Classes,
  hashUnit,
  mml_variable;

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
    //文字列中から、一致する部分があるか検索する
    function Find(src: PChar): Integer; //見つからない場合は、-1
  end;

{'　'や'＃'などの記号のみ半角にする。ただし、".."の間だけは、無視する}
function ConvToHalfSign(src: string; lineNo: Integer): string;
{ドレミを、cde のMMLへ変換する}
function SutotonToMml(src: string; lineNo: Integer): string;


{文字列の中から、数字部分のみを取り出す}
function GetNumber(var pp: PChar): string;


{MMLのソースから、単語を１つ切り出す}
function getTokenMML(var ptr: PChar): string;
{スクリプトから、単語１つを切り出す}
function getTokenWord(var ptr: PChar): string;

{MMLの文字列分を、抜き出す}
function getString(var ptr: PChar; var lineNo: Integer): string;

{MMLのネストする()を、抜き出す}
function GetMaruKakko(var ptr: PChar; var lineNo: Integer): string;
function GetNakaKakko(var ptr: PChar; var lineNo: Integer): string;
function GetKakkoNest(var ptr: PChar; var lineNo: Integer; const kakkoFrom, kakkoTo: Char): string;


{ネストする cFrom .. cTo までを調べ、ポインタを cToまで進める}
procedure skipKakko(var ptr: PChar; var lineNo: Integer; const cFrom, cTo:Char);

procedure skipSpace(var p: PChar);
procedure skipSpaceReturn(var p: PChar; var lineNo: Integer);
procedure skipSpaceCalc(var p: PChar);

implementation                  

uses StrUnit, mml_base;

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
                    if nest<0 then raise EParserError.Create('"'+kakkoFrom+'"が足りません。');
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
    if ptr^<>'{' then raise Exception.Create('文字列が "{"から始まっていません。');
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
    //{"str"}対策
    if (Copy(Result,1,1)='"')and(Copy(Result,Length(Result),1)='"') then
    begin
        Result := Copy(Result,2,Length(Result)-2);
    end;
    if nest>0 then raise Exception.Create('文字列が "}"で終わっていません。');
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
        '$':// 16 進数
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
        '0'..'9'{,'.'}: //10 進数
        begin
        	tmp := pp;
            while pp^ in ['0'..'9'] do Inc(pp);

            //浮動小数点は扱わない
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

{ドレミを、cde のMMLへ変換する}
function SutotonToMml(src: string; lineNo: Integer): string;
var
    p: PChar;
    list: TSutotonList;

    procedure ah(key, val: string; tag: Integer);
    begin
      //tag は プログラム中では、使わない
      list.AddSutoton(key, val);
    end;

    procedure sortSutotonList;
    begin
      list.SortName ;
    end;

    procedure addSutotonList;//todo:ストトン
    begin
      {ストトン登録}
      ah('調','System.KeyFlag',500);//調#(音符)//臨時記号を設定する。（例）調＃（ドファ）
      ah('音階','o',501);//音階(数値)//音階を数値で指定する。初期値は５。範囲は、0～10（例）音階５
      ah('時間','Time',502);//時間(小節数:拍数:ステップ数)//指定時間にポインタを移動する。範囲は、小節数・拍数が、１～。ステップ数は、０～。（例）時間（４：１：０）
      ah('読む','Include',503);//読む(ファイル名)//外部定義ファイルを読み込む。（例）読む(chord2.h)
      ah('予約','.onNote=',504);//(コマンド)予約(v1,v2,v3...)//コマンドの値を予約しておく（例）音量予約120,50【ドレミファ】
      ah('拍子','System.TimeSignature=',505);//拍子 分子,分母//拍子を設定する。（例）拍子4,4
      ah('音色','@',506);//音色（番号）//音色を設定する。
      ah('音符','l',507);//音符（ｎ分音符指定）//基本となる音符の長さをｎ分音符で指定する。（例）音符16//１６分音符の意味
      ah('音量','v',508);//音量（数値）//音量(実際は音の強さ)を設定する。初期値は、100。範囲は、0~127。（例）音量127
      ah('連符','Div',509);//連符{音名}[音長]//３連符や５連符などを表現する。（例）連符{ドレミ}4
      ah('ゲート','q',510);//ゲート（割合）//音符の長さに対する実際の発音時間を割合（100分率）で指定する。範囲は、1～100～。（例）ゲート80
      ah('テンポ','Tempo=',511);//テンポ（数値）//テンポを設定する。初期値は、120。範囲は、20～240を推奨。（例）テンポ120
      ah('曖昧さ','.Random=',512);//(コマンド)曖昧さ（数値）//各属性の曖昧さを設定する。範囲は、0～。初期値は、0。（例）音量曖昧さ80 【ドレミソ】
      ah('トラック','Track=',513);//トラック（番号）//トラック番号を指定する。初期値は、０。範囲は、0～。（例）トラック３
      ah('チャンネル','Channel=',514);//チャンネル（番号）//現在のトラックにチャンネルを設定する。初期値は、トラック番号と同じ。範囲は、１～１６（例）トラック３チャンネル１０
      ah('曲名','TrackName=',515);//曲名{"文字列"}//生成するMIDIファイルに曲名を埋め込む。（例）曲名{"テスト"}
      ah('作者','Copyright=',516);//作者{"文字列"}//生成するMIDIファイルに著作権情報を埋め込む。（例）作者{"クジラ飛行机"}
      ah('コメント','MetaText=',517);//コメント{"文字列"}//生成するMIDIファイルにコメントを埋め込む。（例）コメント{"テスト"}
      ah('音源初期化','System.MeasureShift(1);ResetGM;Time(1:1:0);TrackSync;',518);//音源初期化//音源の初期化(GMリセット)を実行する。（例）音源初期化
      ah('演奏位置','PlayFrom',519);//演奏位置(小節数:拍数:ステップ数))//長い曲の途中から演奏したい時、曲の演奏位置を指定する。（例）演奏位置（32:1:0）
      ah('ー','^',520);//ー//タイ。音を伸ばす。（例）ドードレミミソーーー
      ah('上','>',521);////音階を相対的に１つ上げる
      ah('下','<',522);////音階を相対的に１つ下げる
      ah('ド','c',523);////音名
      ah('レ','d',523);////音名
      ah('ミ','e',523);////音名
      ah('フ','f',523);////音名
      ah('ァ','',523);////音名
      ah('ソ','g',523);////音名
      ah('ラ','a',523);////音名
      ah('シ','b',523);////音名
      ah('ン','r',524);////休符。（例）ドーーン　レンレー
      ah('ッ','r',524);////休符。（例）ドーーッ　レッレー
      ah('ど','c',523);////音名
      ah('れ','d',523);////音名
      ah('み','e',523);////音名
      ah('ふ','f',523);////音名
      ah('ぁ','',523);////音名
      ah('そ','g',523);////音名
      ah('ら','a',523);////音名
      ah('し','b',523);////音名
      ah('ん','r',524);////休符
      ah('っ','r',524);////休符
      ah('イ','a',523);////音名
      ah('ロ','b',523);////音名
      ah('ハ','c',523);////音名
      ah('ニ','d',523);////音名
      ah('ホ','e',523);////音名
      ah('ヘ','f',523);////音名
      ah('ト','g',523);////音名
      ah('変','-',524);////フラット（例）イ変
      ah('嬰','+',525);////シャープ
      ah('リズム','Rythm',526);////リズムモード
      ah('ず','n36,',527);////バスドラム
      ah('た','n38,',529);////スネアドラム
      ah('つ','n42,',528);////ハイハット（クローズ）
      ah('ち','n46,',529);////ハイハット（オープン）
      ah('ぱ','n49,',530);////シンバル
      ah('と','n50,',531);////Lowタム
      ah('む','n47,',532);////Midタム
      ah('ろ','n43,',533);////Highタム
      ah('大きく','Cresc=',534);//大きく(音長),(最終値)//音量(EP)をだんだん大きくする
      ah('小さく','Decresc=',535);//小さく(音長),(最終値)//音量(EP)をだんだん小さくする
      ah('クレッシェンド','Cresc=',534);//大きく(音長),(最終値)//音量(EP)をだんだん大きくする
      ah('デクレッシェンド','Cresc=',535);//小さく(音長),(最終値)//音量(EP)をだんだん小さくする
      ah('音量戻す','EP(127)',536);////音量(EP)を最大値に戻す
      ah('方向左','P(0)',537);////ステレオの左から音が出るようにする
      ah('方向左前','P(32)',538);////ステレオの左前から音が出るようにする
      ah('方向前','P(64)',539);////ステレオの前から音が出るようにする
      ah('方向右前','P(96)',541);////ステレオの右前から音が出るようにする
      ah('方向右','P(127)',540);////ステレオの右から音が出るようにする
      ah('方向回す','P.onNoteWaveEx(0,127,!1,127,0,!1);',542);////ステレオの左右を回す
      ah('ビブラートオフ','M(0)',543);////ビブラートをやめる
      ah('ペダル','y64,127;',544);////ペダルを踏む
      ah('放す','y64,0;',545);////ペダルを放す
      ah('テンポ改','TempoChange=',546);//テンポ改([[[t1],t2],len])//テンポを推移的に変更する。lenを省略すると、全音符の間に推移し、t1を省略すると、以前の値からt2へ推移する。
      ah('ビブラート','M.onNoteWaveEx(0,0,!4,0,96,!8);',547);////推移的なビブラートをかける
      ah('ここから演奏','PlayFrom(Time);',548);////途中から演奏したいときに書く

      {/ストトン登録}

      sortSutotonList;
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
                s := ExtractFilePath(ParamStr(0)) + 'Include' + PATH_FLAG + fname;
                if FileExists(s) = False then
                begin
                    raise EFOpenError.CreateFmt('ファイル"%d"が見つかりません。',[fname]);
                end;
            end;
            sl := TStringList.Create ;
            try
                {$IFDEF UNIX}
                sl.LineBreak := #13#10;
                {$ENDIF}
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

            ah(w, txt,999); //ストトンユーザー命令を追加
            SortSutotonList;
        end;

        //互換性のため、{" ... "} と、閉じた形ではなく、 {" ... } で範囲を認識
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
                        raise EParserError.CreateFmt('(%d) : {" ... "}が対応していません。',[tempNo]);
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
            if p^ = '~' then //ストトンのユーザー追加
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

{'　'や'＃'などの記号のみ半角にする。ただし、".."の間だけは、無視する}
function ConvToHalfSign(src: string; lineNo: Integer): string;
const
  conv = '　 ．.！!”"＃#＄$％%＆&’'#39'（(）)＝=～~｜|－-＾^￥\＠@「''；;：:」''、,，,'+
  '。.‘`｛{＋+＊*｝}＜<＞>？?＿_♯#♭-『{』}【[】]／/'+
  '１1２2３3４4５5６6７7８8９9０0一1二2三3四4五5六6七7八8九9零0壱1弐2参3〇0'+
  '＃#＋+♭-↑>＞>↓<＜<';

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
                //if (p^='"')and((p+1)^='}') then // {"ceg}のような書き方が出来なくなるから
                if (p^='}') then //{"で特殊だが、閉じカッコは↑の理由で、} のみでよい
                begin
                    Break;
                end else
                if p^=#0 then
                begin
                    raise EParserError.CreateFmt('(%d) : {" ... "}が対応していません。',[tempNo]);
                end;
                if p^ = #13 then Inc(LineNo);
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
                if p^ in [ #13, #10, #0] then Break;
                Inc(p);
            end;
        end;
    end;

    procedure skipComment(var ptr: PChar);
    var
        nest: Integer;
    begin
        //さくらでは、コメントのネストを許している
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
        //ハッシュに変換対象文字列ペアを加える
        i := 1;
        len := Length(conv);
        while i < len do
        begin
          if not(conv[i] in LeadBytes) then raise Exception.Create('[SystemError] ConvToHalfSign'+IntToStr(i)+'で、全角半角が対応していません。');
              AddHashList(Copy(conv,i,2), Copy(conv,i+2,1));
              Inc(i,3);
        end;

        //ハッシュを参照しながら、文字列を置換する
        Result := '';
        p := PChar( src );
        while p^ <> #0 do
        begin
            if p^ in LeadBytes then
            begin
                s := p^ + (p+1)^;
                n := TStrHashNode( hash.Find(s) );
                if n = nil then
                begin
                    Result := Result + s;
                end else
                begin
                    Result := Result + n.value ;
                end;
                Inc(p,2);
            end else
            begin
                if (p^ = '{')and((p+1)^='"') then //特殊文字列があればスキップ！！！
                begin
                    CopyToKakkoEnd;
                end else
                if (p^ = '/')and((p+1)^='/') then
                begin//行末までコメント
                    skipComment2(p);
                end else
                if (p^ = '/')and((p+1)^='*') then
                begin//{*/}までコメント
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


{MMLのソースから、単語を１つ取り出す}
function getTokenMML(var ptr: PChar): string;

    procedure GetMultiByteWord;
    begin
        //ドレミファソラシどれみふぁそらしの場合だけは、１文字だけ返す
        Result := (ptr)^ + (ptr+1)^;
        Inc(ptr,2);
        {
        if JPosEx(Result, 'どれみふそらしドレミフソラシ',1) > 0 then
        begin
            if (Result='ふ')or(Result='フ') then //ファの処理
            begin
                s := (ptr) + (ptr+1)^;
                if (s='ぁ')or(s='ァ') then Inc(ptr,2);
            end;
            Exit;
        end;
        //それ以外の時: 数字か空白まで単語と見なす
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
    単語取り出しの規則：
        サクラでは、大文字・小文字・MutiByteで、取り出す単語が違う
        [A-Z_0-9]+
        [a-z]
        [ドレミファソラシ]
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
        //小文字（か、記号）1文字だけ切り取り
        Result := ptr^; Inc(ptr);
    end;
end;

{スクリプトから、単語１つを切り出す}
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
    if ptr^<>cFrom then raise Exception.Create('範囲指定エラー。"'+cFrom+'"から始まっていません。');
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

    if nest>0 then raise Exception.Create('範囲指定エラー。"'+cTo+'"で終わっていません。');
end;


{ TSutotonList }

function TSutotonList.AddSutoton(name, value: string): Integer;
var
  p: PSutotonNode;
  i: Integer;
begin
  //同じキーがあったら上書き
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
  //新規
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
