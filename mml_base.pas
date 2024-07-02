unit mml_base;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 https://sakuramml.com
説　明：サクラのＭＭＬをＳＭＦに変換するメインユニット

履　歴：

2002/06/03 15:13 雛型作成
2002/06/16 11:03 ほぼ完成
-------------------------------------------------------------------------------}

interface
uses
  {$ifdef Win32}
  Windows,
  {$endif}
  Classes,           
  SysUtils,
  mml_const,
  mml_error,
  mml_var,
  mml_calc,
  mml_system,
  smf_types,
  smf_const,
  mml_types,
  mml_token2,
  Math;

//------------------------------------------------------------------------------
const
  //TODO: バージョン情報
  VER_INFO   = '2.384';
  DATE_INFO  = '2024/07/02';
  VER_NUMBER = 2384;
//------------------------------------------------------------------------------
const
  PATH_FLAG = {$IFDEF Win32}'\'{$ELSE}'/'{$ENDIF};

type
  TMmlBase = class(TMmlSystem)
  private
    //システム命令
    function scriptInt(var sp: TSrcPos): TMVarCustom;
    function scriptStr(var sp: TSrcPos): TMVarCustom;
    function scriptArray(var sp: TSrcPos): TMVarCustom;
    function scriptPrint(var sp: TSrcPos): TMVarCustom;
    function scriptPrintTime(var sp: TSrcPos): TMVarCustom;
    function scriptPrintTrackStatus(var sp: TSrcPos): TMVarCustom;
    //
    function scriptArraySortStr(var sp: TSrcPos): TMVarCustom;
    function scriptArraySortNum(var sp: TSrcPos): TMVarCustom;
    //
    function scriptLoopFrom(var sp: TSrcPos): TMVarCustom;
    function scriptLoopTo(var sp: TSrcPos): TMVarCustom;
    function scriptLoopBreak(var sp: TSrcPos): TMVarCustom;
    //
    function scriptFor(var sp: TSrcPos): TMVarCustom;
    function scriptWhile(var sp: TSrcPos): TMVarCustom;
    function scriptIf(var sp: TSrcPos): TMVarCustom;
    function scriptNext(var sp: TSrcPos): TMVarCustom; //'}'のこと
    function scriptExit(var sp: TSrcPos): TMVarCustom;
    function scriptSwitch(var sp: TSrcPos): TMVarCustom;
    //
    function scriptRandom (var sp: TSrcPos): TMVarCustom;
    function scriptRandomSelect (var sp: TSrcPos): TMVarCustom;
    function scriptStep (var sp: TSrcPos): TMVarCustom;
    function scriptNoteNo (var sp: TSrcPos): TMVarCustom;
    function scriptIntToStr (var sp: TSrcPos): TMVarCustom;
    function scriptMML (var sp: TSrcPos): TMVarCustom;
    function scriptStrToLen (var sp: TSrcPos): TMVarCustom;
    function scriptStrToNum (var sp: TSrcPos): TMVarCustom;
    function scriptSizeOf (var sp: TSrcPos): TMVarCustom;
    function scriptHEX (var sp: TSrcPos): TMVarCustom;
    function scriptVarType (var sp: TSrcPos): TMVarCustom;
    //
    function scriptFunction(var sp: TSrcPos): TMVarCustom;
    function scriptResult(var sp: TSrcPos): TMVarCustom;
    function scriptArgOrder(var sp: TSrcPos): TMVarCustom;
    function scriptAllowMultiLine(var sp: TSrcPos): TMVarCustom;
    function scriptMetaTextEOL(var sp: TSrcPos): TMVarCustom;
    //MML命令
    function funcLength(var sp: TSrcPos): TMVarCustom;
    function funcOctave(var sp: TSrcPos): TMVarCustom;
    function funcQgate(var sp: TSrcPos): TMVarCustom;
    function funcQgate2(var sp: TSrcPos): TMVarCustom;
    function funcTiming(var sp: TSrcPos): TMVarCustom;
    function funcVelocity(var sp: TSrcPos): TMVarCustom;
    function funcNoteA(var sp: TSrcPos): TMVarCustom;
    function funcNoteB(var sp: TSrcPos): TMVarCustom;
    function funcNoteC(var sp: TSrcPos): TMVarCustom;
    function funcNoteD(var sp: TSrcPos): TMVarCustom;
    function funcNoteE(var sp: TSrcPos): TMVarCustom;
    function funcNoteF(var sp: TSrcPos): TMVarCustom;
    function funcNoteG(var sp: TSrcPos): TMVarCustom;
    function funcNoteR(var sp: TSrcPos): TMVarCustom;
    function funcNoteN(var sp: TSrcPos): TMVarCustom;
    function funcDirectSmf(var sp: TSrcPos): TMVarCustom;
    function funcNoteOn(var sp: TSrcPos): TMVarCustom;
    function funcNoteOff(var sp: TSrcPos): TMVarCustom;
    function funcOctaveUp(var sp: TSrcPos): TMVarCustom;
    function funcOctaveDown(var sp: TSrcPos): TMVarCustom;
    function funcOctaveUpOnece(var sp: TSrcPos): TMVarCustom;
    function funcOctaveDownOnece(var sp: TSrcPos): TMVarCustom;
    function funcWaon(var sp: TSrcPos): TMVarCustom;
    function funcDiv(var sp: TSrcPos): TMVarCustom;
    function scriptTieMode(var sp: TSrcPos): TMVarCustom;
    //
    function scriptTrack(var sp: TSrcPos): TMVarCustom;
    function scriptTrackKey(var sp: TSrcPos): TMVarCustom;
    function scriptChannel(var sp: TSrcPos): TMVarCustom;
    function scriptTime(var sp: TSrcPos): TMVarCustom;
    function scriptSub(var sp: TSrcPos): TMVarCustom;
    function scriptPlay(var sp: TSrcPos): TMVarCustom;
    function scriptSystem(var sp: TSrcPos): TMVarCustom;
    function scriptTimeBase(var sp: TSrcPos): TMVarCustom;
    function scriptInclude(var sp: TSrcPos): TMVarCustom;
    function scriptKeyShift(var sp: TSrcPos): TMVarCustom;
    function scriptKeyFlag(var sp: TSrcPos): TMVarCustom;
    function scriptTimeKeyFlag(var sp: TSrcPos): TMVarCustom;
    function scriptTimeKey(var sp: TSrcPos): TMVarCustom;
    function scriptTimeKey2(var sp: TSrcPos): TMVarCustom;
    function scriptRythm(var sp: TSrcPos): TMVarCustom;
    function scriptRythmChar(var sp: TSrcPos): TMVarCustom;
    function scriptTrackSync(var sp: TSrcPos): TMVarCustom;
    function scriptTrackMute(var sp: TSrcPos): TMVarCustom;
    function scriptTrackMute2(var sp: TSrcPos): TMVarCustom;
    function scriptTrackSolo(var sp: TSrcPos): TMVarCustom;
    function scriptStretch(var sp: TSrcPos): TMVarCustom;
    function scriptPlayFrom(var sp: TSrcPos): TMVarCustom;
    function scriptPlayTo(var sp: TSrcPos): TMVarCustom;
    function scriptEnd (var sp: TSrcPos): TMVarCustom;
    function scriptMsgBox (var sp: TSrcPos): TMVarCustom;
    function scriptASC(var sp: TSrcPos): TMVarCustom;
    function scriptCHR(var sp: TSrcPos): TMVarCustom;
    function scriptMID(var sp: TSrcPos): TMVarCustom;
    function scriptPos (var sp: TSrcPos): TMVarCustom;
    function scriptPosEx(var sp: TSrcPos): TMVarCustom;
    function scriptReplace(var sp: TSrcPos): TMVarCustom;
    function scriptUseKeyShift(var sp: TSrcPos): TMVarCustom;
    function scriptCCMute(var sp: TSrcPos): TMVarCustom;
    function scriptCCNoMute(var sp: TSrcPos): TMVarCustom;
    function scriptKeyPress(var sp:TSrcPos): TMVarCustom;


    //
    function scriptVoice(var sp: TSrcPos): TMVarCustom;
    function scriptCC(var sp: TSrcPos): TMVarCustom;
    function scriptBend(var sp: TSrcPos): TMVarCustom;
    function scriptBendFull(var sp: TSrcPos): TMVarCustom;
    function scriptRPN(var sp: TSrcPos): TMVarCustom;
    function scriptNRPN(var sp: TSrcPos): TMVarCustom;
    function scriptSysEx(var sp: TSrcPos): TMVarCustom;

    function scriptCC_M(var sp: TSrcPos): TMVarCustom;
    function scriptCC_PT(var sp: TSrcPos): TMVarCustom;
    function scriptCC_DataMSB(var sp: TSrcPos): TMVarCustom;
    function scriptCC_DataLSB(var sp: TSrcPos): TMVarCustom;
    function scriptCC_MainVolume(var sp: TSrcPos): TMVarCustom;
    function scriptCC_Panpot(var sp: TSrcPos): TMVarCustom;
    function scriptCC_Expression(var sp: TSrcPos): TMVarCustom;
    function scriptCC_PortamentoSwitch(var sp: TSrcPos): TMVarCustom;
    function scriptCC_Reverb(var sp: TSrcPos): TMVarCustom;
    function scriptCC_Chorus(var sp: TSrcPos): TMVarCustom;
    function scriptCC_VAR(var sp: TSrcPos): TMVarCustom;
    //メタイベント
    function scriptTempo(var sp: TSrcPos): TMVarCustom;
    function scriptTempoChange(var sp: TSrcPos): TMVarCustom;
    function scriptTimeSig(var sp: TSrcPos): TMVarCustom;
    function scriptChPrefix(var sp: TSrcPos): TMVarCustom;
    function scriptMetaText (var sp: TSrcPos): TMVarCustom;
    function scriptCopyright (var sp: TSrcPos): TMVarCustom;
    function scriptTrackName (var sp: TSrcPos): TMVarCustom;
    function scriptInstrumentName (var sp: TSrcPos): TMVarCustom;
    function scriptLyric (var sp: TSrcPos): TMVarCustom;
    function scriptMarker  (var sp: TSrcPos): TMVarCustom;
    function scriptCuePoint (var sp: TSrcPos): TMVarCustom;
    function scriptPort (var sp: TSrcPos): TMVarCustom;
    function scriptExpressionChange(var sp: TSrcPos): TMVarCustom;
    function scriptExpressionChangeDecresc(var sp: TSrcPos): TMVarCustom;
    function scriptDeleteCC(var sp: TSrcPos): TMVarCustom;
    function scriptVersion(var sp: TSrcPos): TMVarCustom;
  private
    //主な構文解析に必要な下請け(クラス)
    TokenBase: TMmlTokenBase ;
    function  getArgs(var sp: TSrcPos): TMArray;   // 引数配列を得る
    function  getArgsHex(var sp: TSrcPos): TMArray;// SysEx$ 対策
    function  getArg(var sp: TSrcPos): TMVarCustom;// 引数を得る
    function  getArgAndCalc(var sp: TSrcPos): TMVarCustom; // 計算可能なパラメーターを持つ引数を得る
    function  getArgsWithType(var sp: TSrcPos; varType: string): TMArray; //変数の型を指定して値を得る
    function  GetNoteLength(var sp: TSrcPos; stepmode: Boolean; def: Integer): Integer; //ステップ値で引数を得る
    //構文解析の下請け的な関数
    function  GetIntValue(var sp: TSrcPos): Integer;
    function  GetIntValueAndCalc(var sp: TSrcPos): Integer;
    //function  getNumberM(var sp: TSrcPos): TMInt;
    //function  getArg_sub(var sp: TSrcPos): TMVarCustom;
    //function  GetTokenComma(var sp: TSrcPos): string; //カンマがあるところまでのトークンを得る
    function  GetTimeValue(var sp: TSrcPos): Integer; // Time(mes:beat:tick);の引数部分を得る
    //システム/MML
    procedure AddSystemCommand;//システム命令をひたすら追加する
    procedure makeVariable(var sp: TSrcPos; c:Char);
    procedure GetTrackDefaultValue(var len, gate, vel, tim, oct: Integer; var stepm: Boolean);
    //MML
    function  NoteOn(var sp: TSrcPos; NoteName: Char): TMInt; //NoteNoを返す
    function  SetNoteInfo(var sp: TSrcPos; var ni: TNoteInfos; pname:Char; IncValue: Integer): TMInt;//lqoなどのパラメをセット
    function  GetNowTimeKey(no: Integer): Integer; //MaxIntなら非適用
    function  GetNoteNo(var sp: TSrcPos; NoteName: Char; UseKeyShift: Boolean): Integer;
    //コントロールチェンジの書き込みなど
    procedure WriteCCWave(var ncc: TNoteCC; var track: TSmfTrack; noteLen, ch: Integer);
    procedure WriteCCOption(var sp: TSrcPos; cc: Integer);
    procedure WriteCCComand(var sp: TSrcPos; cc: Integer);
    procedure WritePicthBend(time,value: Integer);
    procedure WriteCCNoteOnTimeDirect(ccNo,time,fromValue,toValue,Len: Integer);
    procedure checkNoteOnCC(noteLen, ch: Integer);//ノートオン毎のイベントチェック
    procedure WriteDirectSmf(byteArray: TArrayOfByte);
    procedure setRpnNrpn(var sp:TSrcPos; rpnType:TRpnType);
    procedure WriteMetaText(var sp: TSrcPos; mType: Byte);
    procedure WriteTempo(time, value: Integer);
    procedure cresc_sub(def1,def2: Integer; var sp: TSrcPos);//クレッシェンド、デクレッシェンドの処理
    procedure DeleteCCAfterTime(track: TSmfTrack; ch, ccNo: Integer; time: Integer; CompleteDelete: Boolean); // 指定トラックのタイム以降に書き込まれたコントロールチェンジを削除する
  protected
    function  ExecuteCommand(node: TMHashNode; var sp: TSrcPos): TMVarCustom; override;// node を渡して値を得る
    procedure DebugMeta(text:string); //デバッグ用のメタテキスト
    function  PreCompile(src: string; lineNo: Integer): string;
    procedure Compile(var sp: TSrcPos);
    procedure Analize(var sp: TSrcPos);
    procedure Eval(src: string); //文字列を評価・実行する
  public
    constructor Create;
    destructor Destroy; override;
  private
    NestCountCompile: Integer; //Compile関数を再帰的にコールした回数
  end;

implementation

uses StrUnit, mml_token;

{$ifdef Win32}
{$else}
const MB_OK = 1;
procedure MessageBox(windowid: Integer; msg: PChar; title: PChar; id: Integer);
begin
  Writeln('[' + title + ']');
  Writeln(msg);
end;
{$endif}


{ TMmlBase }

constructor TMmlBase.Create;
begin
    inherited Create;
    AddSystemCommand;
    NestCountCompile := 0;
    TokenBase := TMmlTokenBase.Create(Self);
end;

destructor TMmlBase.Destroy;
begin
    TokenBase.Free ;
    inherited;
end;

procedure TMmlBase.AddSystemCommand;
var
  //ラストの数値
  cmds: array [0..132] of Pointer;
  i: Integer;

    procedure tag_check(tag: Integer; p:Pointer; key:string);
    begin
      if (cmds[tag] <> nil)and(cmds[tag] <> p) then
      begin
        raise Exception.Create('多重定義"'+key+'"：AddSystemCommand');
      end else
      begin
        cmds[tag] := p;
      end;
    end;

    function cmd( key: string; proc: TMFuncObj; tag: Integer ): TMHashNode;
    begin
      tag_check(tag, @proc, key);
      Result := TMHashNode.Create(key);
      Result.nodeType := ntSysFunc;
      Result.value := TMFunc.Create;
      Result.tag := tag;
      TMFunc(Result.value).funcPtr := proc;
      Commands.Add(Result);
    end;

    function v( key: string; val: Integer; tag: Integer ): TMHashNode;
    begin
      Result := TMHashNode.Create(key);
      Result.nodeType := ntInt;
      Result.value := TMInt.Create;
      Result.tag := tag;
      TMInt(Result.value).value := val;
      Commands.Add(Result);
    end;

    function vs( key: string; val: string; tag: Integer ): TMHashNode;
    begin
      Result := TMHashNode.Create(key);
      Result.nodeType := ntStr;
      Result.value := TMStr.Create;
      Result.tag := tag;
      TMStr(Result.value).value := val;
      Commands.Add(Result);
    end;

begin
    //todo: AddSystemCommand
    for i:=0 to High(cmds) do cmds[i] := nil;

    {システム命令ここから}
    //音符属性
    cmd('l', funcLength,0);//l(n)//音の長さをn分音符で指定(初期値4)
    cmd('o', funcOctave,1);//o(n)//オクターブ(音階)を指定(0~10の範囲)(初期値5)
    cmd('q', funcQgate,2);//q(n)//音の長さに対するゲートタイム（発音時間）の割合をパーセントで指定(0~100~∞の範囲)(初期値80)
    cmd('h', funcQgate2,113);//h(n)//ゲート値をステップ値で減算補正する(初期値0)
    cmd('v', funcVelocity,3);//v(n)//ベロシティ(音の強さ)を指定(0~127の範囲)(初期値100)
    cmd('t', funcTiming,4); //t(n)//発音のタイミングをステップ単位で指定(初期値0)
    cmd('<', funcOctaveDown,5); //<//オクターブを１つ下げる
    cmd('>', funcOctaveUp,6); //>//オクターブを１つ上げる
    cmd('`', funcOctaveUpOnece,7); //`//一時的にオクターブを１つ上げる
    cmd('"', funcOctaveDownOnece,8); //"//一時的にオクターブを１つ下げる
    cmd('''', funcWaon,9); //'mml'//'...'の間を和音として発音する
    cmd('Div', funcDiv,10); //Div{mml}(n)//{...}の間をn分音符の連符として発音する
    cmd('DIV', funcDiv,10); ////Div{mml}(n)//{...}の間をn分音符の連符として発音する
    cmd( 'Slur', scriptTieMode,11 );//Slur(type[,value,range])//タイ記号"&"の異音程(スラー)の動作を変更する。type=0:グリッサンド/1:ベンド/2:ゲート/3:アルペジオ
    //音名
    cmd('c', funcNoteC,12); //c[(l),(q),(v),(t),(o)]//ドを発音する
    cmd('d', funcNoteD,13); //d[(l),(q),(v),(t),(o)]//レを発音する
    cmd('e', funcNoteE,14); //e[(l),(q),(v),(t),(o)]//ミを発音する
    cmd('f', funcNoteF,15); //f[(l),(q),(v),(t),(o)]//ファを発音する
    cmd('g', funcNoteG,16); //g[(l),(q),(v),(t),(o)]//ソを発音する
    cmd('a', funcNoteA,17); //a[(l),(q),(v),(t),(o)]//ラを発音する
    cmd('b', funcNoteB,18); //b[(l),(q),(v),(t),(o)]//シを発音する
    cmd('r', funcNoteR,19); //r//休符を表す
    cmd('^', funcNoteR,20); //^//音符と音符の加算記号。もし、突然これが現れたときは、休符として扱う//
    cmd('n', funcNoteN,21); //n(NoteNo)[,(l),(q),(v),(t),(o)]//ノート番号を指定して発音する//
    //トラック・チャンネル
    cmd( 'Track', scriptTrack,23 );//Track(n)//トラック番号を指定する(0~∞の範囲)。読取り可。
    cmd( 'NowTrack', scriptTrack,23 );//Track(n)//トラック番号を指定する(0~∞の範囲)。読取り可。
    cmd( 'TR', scriptTrack,23 );//Track(n)//トラック番号を指定する(0~∞の範囲)読取り可。
    cmd( 'Channel', scriptChannel,24 );//Channel(n)//トラックにチャンネルを設定する(1~16の範囲)。読取り可。
    cmd( 'CH', scriptChannel,24 );//Channel(n)//トラックにチャンネルを設定する(1~16の範囲)読取り可。
    cmd( 'TrackSync', scriptTrackSync,25 );//TrackSync//全てのトラックを同タイムに合わせる
    cmd( 'Time', scriptTime,26 );//Time((小節:拍:ステップ数)|(総ステップ数))//トラックのタイムポインタを指定する。読取りは、総ステップ数。
    cmd( 'TIME', scriptTime,26 );//Time((小節:拍:ステップ数)|(総ステップ数))//トラックのタイムポインタを指定する。読取りは、総ステップ数。
    cmd( 'Sub', scriptSub,27 );//Sub{(mml)}//mml書き込み後、タイムポインタをSubの前に戻す。
    cmd( 'SUB', scriptSub,27 );//Sub{(mml)}//mml書き込み後、タイムポインタをSubの前に戻す。
    cmd( 'S',   scriptSub,27 );//S{(mml)}//mml書き込み後、タイムポインタをSubの前に戻す。
    cmd( 'Play', scriptPlay,28 );//Play({a},{b},{c}...)//複数トラックを１度に書き込む
    cmd( 'PLAY', scriptPlay,28 );//Play({a},{b},{c}...)//複数トラックを１度に書き込む
    cmd( 'Rythm', scriptRythm,29 );//Rhythm{...}//{...}の中を、リズムモードにする
    cmd( 'RYTHM', scriptRythm,29 );//Rhythm{...}//{...}の中を、リズムモードにする
    cmd( 'Rhythm', scriptRythm,29 );//Rhythm{...}//{...}の中を、リズムモードにする
    cmd( 'RHYTHM', scriptRythm,29 );//Rhythm{...}//{...}の中を、リズムモードにする
    cmd( '$', scriptRythmChar,30 );// $(char){...}//リズムモードで利用するマクロを設定する
    cmd( 'Stretch', scriptStretch,31 );//Stretch{ mml }(len)//フレーズmmlを、lenの長さにストレッチして書き込む
    cmd( 'PlayFrom', scriptPlayFrom,32 );//PlayFrom(time|[.option])//途中から演奏する場合の設定を行う
    cmd( 'PlayTo', scriptPlayTo,108 );//PlayTo(time)//演奏を途中で終わらせる設定を行う
    cmd( 'PrintTime', scriptPrintTime,33 );//PrintTime([n])//指定トラック(省略時はカレントトラック)の、トラック番号及びタイムポインタの情報を表示する
    cmd( 'PrintTrack', scriptPrintTrackStatus,34 );//PrintTrack([n])//指定トラック(省略時はカレントトラック)の、トラック情報を詳細に表示する
    cmd( 'TrackMute', scriptTrackMute,35 );//TrackMute(on/off)//(on)でこのコマンド以降のトラックの発音をミュート(消音)し、タイムポインタのみ進める
    cmd( 'Solo', scriptTrackSolo,36 );//Solo(n[,n,n...])//指定トラックのみをMIDIファイルに書き出す
    cmd( 'Mute', scriptTrackMute2,37 );//Mute(n[,n,n...])//指定トラックのMIDIファイル書き出しをミュートする
    cmd( 'TrackKey', scriptTrackKey,109 );//TrackKey(v)//カレントトラックのキーを、vだけ上げる
    //音色・コントロールチェンジ
    cmd( 'Voice', scriptVoice,38 );//Voice(n[,msb,lsb])//音色を指定する(1~128の範囲)読取り可。
    cmd( '@', scriptVoice,38 );//@n[,msb,lsb]//音色を指定する(1~128の範囲)
    cmd( 'y', scriptCC,39 );//y(n),[(value)|.(option)]//コントロールチェンジを書き込む(全て0~127の範囲)
    cmd( 'p', scriptBend,40 );//p[%][(value)|.(option)]//簡易ピッチベンドを書き込む(0~63~127の範囲)(%をつけると-8192~0~8191)
    cmd( 'PitchBend', scriptBendFull,41 );//PitchBend[%][(value)|.(option)]//ピッチベンドを書き込む(-8192~0~8191の範囲)
    cmd( 'RPN', scriptRPN,42 );//RPN(msb,lsb,data)//RPNを書き込む
    cmd( 'NRPN', scriptNRPN,43 );//NRPN(msb,lsb,data)//NRPNを書き込む
    cmd( 'SysEx', scriptSysEx,44 );//SysEx[$]($F0,v1,v2,v3...,$F7)//SysExを書き込む。$をつけた時は全ての数値を16進数として扱う
    cmd( 'Modulation', scriptCC_M,45 );//M(n)//モジュレーションを書き込む
    cmd( 'M', scriptCC_M,45 );//M(n)//モジュレーションを書き込む
    cmd( 'PortamentoTime', scriptCC_PT,46 );//PT(n)//ポルタメントタイムを書き込む
    cmd( 'PT', scriptCC_PT,46 );//PT(n)//ポルタメントタイムを書き込む
    cmd( 'DataMSB', scriptCC_DataMSB,47 );//DataMSB(n)//RPN/NRPNのデータMSBを書き込む
    cmd( 'Y', scriptCC_DataMSB,47 );//DataMSB(n)//RPN/NRPNのデータMSBを書き込む
    cmd( 'DataLSB', scriptCC_DataLSB,48 );//DataLSB(n)//RPN/NRPNのデータLSBを書き込む
    cmd( 'MainVolume', scriptCC_MainVolume,49 );//MainVolume(n)//メインボリュームを書き込む
    cmd( 'V', scriptCC_MainVolume,49 );//V(n)//メインボリュームを書き込む
    cmd( 'Panpot', scriptCC_Panpot,50 );//Panpot(n)//パンポットを書き込む
    cmd( 'P', scriptCC_Panpot,50 );//P(n)//パンポットを書き込む
    cmd( 'Expression', scriptCC_Expression,51 );//Expression(n)//エクスプレッションを書き込む
    cmd( 'EP', scriptCC_Expression,51 );//EP(n)//エクスプレッションを書き込む
    cmd( 'Cresc', scriptExpressionChange,118 );//Cresc([[[len],v1],v2])//だんだん大きく。エクスプレッションをlen(ｎ分音符指定で)の間に、t1からt2へ変更する。lenを省略すると全音符の長さになる。
    cmd( 'Decresc', scriptExpressionChangeDecresc,119 );//Decresc([[[len],v1],v2])//だんだん小さく。エクスプレッションをlen(ｎ分音符指定で)の間に、t1からt2へ変更する。lenを省略すると全音符の長さになる。
    cmd( 'PortamentoSwitch', scriptCC_PortamentoSwitch,52 );//PortamentSwitch(n)//ポルタメントスイッチを書き込む
    cmd( 'PS', scriptCC_PortamentoSwitch,52 );//PS(n)//ポルタメントスイッチを書き込む
    cmd( 'Reverb', scriptCC_Reverb,53 );//Reverb(n)//リバーブを書き込む
    cmd( 'REV', scriptCC_Reverb,53 );//REV(n)//リバーブを書き込む
    cmd( 'Chorus', scriptCC_Chorus,54 );//Chorus(n)//コーラスを書き込む
    cmd( 'CHO', scriptCC_Chorus,54 );//CHO(n)//コーラスを書き込む
    cmd( 'VAR', scriptCC_VAR,55 );//VAR(n)//バリエーションを書き込む
    cmd( 'DeleteCC', scriptDeleteCC,121 );//DeleteCC(n)//この命令以降のタイムに書かれたコントロールチェンジ・ピッチベンドを完全に削除する。
    cmd( 'CCMute', scriptCCMute,123 );//CCMute(on/off)//コントロールチェンジの書き込みをミュートする。トラックごとに指定できる。
    cmd( 'CCNoMute', scriptCCNoMute,126 );//CCNoMute(no,on/off)//特定のコントロールチェンジナンバーの書き込みをミュートする。トラックごとに指定できる。
    cmd( 'KeyPressure', scriptKeyPress,130 );//KeyPressure(n)//最後に発音したノートに対してキープレッシャー(アフタータッチ)を書き込む
    cmd( 'KP',       scriptKeyPress,130 );//KP(n)//最後に発音したノートに対してキープレッシャー(アフタータッチ)を書き込む

    //メタイベント
    cmd( 'Tempo', scriptTempo,56 );//Tempo(n)//テンポを設定する(1~500の範囲)。読取り可。
    cmd( 'TempoChange', scriptTempoChange,117 );//TempoChange(t1[[,t2],len])//テンポをt1からt2へlen(ステップ数)の長さで変更する。t2を省略すると、現在のテンポからt1までの推移。lenを省略すると全音符の長さになる。
    cmd( 'TimeSignature', scriptTimeSig,57 );//TimeSignature(分子,分母)//拍子記号を設定する
    cmd( 'ChannelPrefix', scriptChPrefix,58 );//ChannelPrefix(n)//チャンネルプリフィックスを設定する(0~127の範囲)。
    cmd( 'MetaText', scriptMetaText,59 );//MetaText={"text"}//メタテキストを書き込む。
    cmd( 'Copyright', scriptCopyright,60 );//Copyright={"text"}//著作権情報を書き込む。
    cmd( 'TrackName', scriptTrackName,61 );//TrackName={"text"}//トラック名/曲名を書き込む。
    cmd( 'InstrumentName', scriptInstrumentName,62 );//InstrumentName={"text"}//楽器名を書き込む。
    cmd( 'Lyric', scriptLyric,63 );//Lyric={"text"}//歌詞を書き込む。
    cmd( 'Marker', scriptMarker,64  );//Marker ={"text"}//マーカーを書き込む。
    cmd( 'CuePoint', scriptCuePoint,65 );//CuePoint={"text"}//キューポイントを書き込む。
    cmd( 'Port', scriptPort,66 );//Port(n)//ポート番号を指定する（但しポートに対応したプレイヤーが必要）
    cmd( 'PORT', scriptPort,66 );//PORT(n)//ポート番号を指定する（但しポートに対応したプレイヤーが必要）

    //システム
    cmd( 'System', scriptSystem,67 );//System.(オプション)//MMLシステムのカスタマイズなど
    cmd( 'TimeBase', scriptTimeBase,68 );//TimeBase(n)//タイムベース（四分音符分解能）を設定する
    cmd( 'Include', scriptInclude,69 );//Include(ファイル名)//ファイルを取り込んで実行する
    cmd( 'Key', scriptKeyShift,70 );//Key(n)//キーをn半音上げる
    cmd( 'KeyFlag', scriptKeyFlag,72 );//KeyFlag[+|-](note)|KeyFlag=(a,b,c,d,e,f,g)//臨時記号を設定する
    cmd( 'TimeKeyFlag', scriptTimeKeyFlag,73 );//TimeKeyFlag((fromTime),(toTime),(a,b,c,d,e,f,g))//時間を指定して臨時記号を設定する。(fromTime)を省略すると現在のタイム、(toTime)を省略すると次に指定があるまでが補完される
    cmd( 'TimeKey', scriptTimeKey,74 );//TimeKey((fromTime),(toTime),value)//時間を指定してキーをvalur半音上げる。(fromTime)を省略すると現在のタイム、(toTime)を省略すると次に指定があるまでが補完される
    cmd( 'TimeKey2', scriptTimeKey2,116 );//TimeKey2((fromTime),(toTime),value)//時間を指定してキーをvalur半音上げる(その2)。(fromTime)を省略すると現在のタイム、(toTime)を省略すると次に指定があるまでが補完される
    v( 'SoundType',0, 75 );//SoundType=v//ユーザーが使用している音源のタイプを得る。v=0:GM/1:GS/2:XG
    cmd('DirectSMF', funcDirectSmf,76); //DirectSMF(b1,b2,b3...)//直接SMFにイベントを埋め込む//
    cmd('NoteOn', funcNoteOn,77);  //NoteOn(noteno,velocity)//ノートオンだけをSMFに埋め込む//
    cmd('NoteOff', funcNoteOff,78); //NoteOff(noteno,velocity)//ノートオフだけをSMFに埋め込む//
    cmd('UseKeyShift', scriptUseKeyShift,110); //UseKeyShift(on|off)//KeyやTimeKeyやTrackKeyの適用をオンオフする
    cmd('ArgOrder', scriptArgOrder,114); //ArgOrder(lqvto)//ノート(abcdefgn)引数の並び順をカスタマイズする
    cmd('AllowMultiLine', scriptAllowMultiLine,131); //AllowMultiLine(0|1)//複数行にわたる和音をエラーにする(0でオフにする)
    cmd('MetaTextEOL', scriptMetaTextEOL,132); //MetaTextEOL(0|1|2)//メタテキストの改行コードをLFに変える「MetaTextEOL(1)」でLF、2でCRに、0でCRLFする

    //スクリプト
    cmd( 'Int', scriptInt,79 );//Int name[=value];//整数型(32bit)の変数(name)を作成し、(value)で初期化する
    cmd( 'INT', scriptInt,79 );//Int name[=value];//整数型(32bit)の変数(name)を作成し、(value)で初期化する
    cmd( 'Integer', scriptInt,79 );//Integer name[=value];//整数型(32bit)の変数(name)を作成し、(value)で初期化する
    cmd( 'INTEGER', scriptInt,79 );//Integer name[=value];//整数型(32bit)の変数(name)を作成し、(value)で初期化する
    cmd( 'Str', scriptStr,80 );//Str name[=value];//文字列型の変数(name)を作成し、(value)で初期化する
    cmd( 'STR', scriptStr,80 );//Str name[=value];//文字列型の変数(name)を作成し、(value)で初期化する
    cmd( 'Array', scriptArray,81 );//Array name[=(value,value,value...)];//配列変数(name)を作成し、(value,value,value...)で初期化する
    cmd( 'ARRAY', scriptArray,81 );//Array name[=(value,value,value...)];//配列変数(name)を作成し、(value,value,value...)で初期化する
    cmd( 'Print', scriptPrint,82 );//Print(value);//valueを、コンソールに表示する
    cmd( 'PRINT', scriptPrint,82 );//Print(value);//valueを、コンソールに表示する
    //制御構造
    cmd( '[', scriptLoopFrom,83 );//[n mml]//mml を n回実行する。もし最後の１回の時":"があれば、ループの外へ抜ける
    cmd( ']', scriptLoopTo,84 );//[n mml]//mml を n回実行する。もし最後の１回の時":"があれば、ループの外へ抜ける
    cmd( ':', scriptLoopBreak,85 );//[n mml]//mml を n回実行する。もし最後の１回の時":"があれば、ループの外へ抜ける
    cmd( 'For', scriptFor,86 );//For(初期処理;条件式;再初期化){ .. }//{ .. } の範囲を終了判定が真になるまで繰り返す
    cmd( 'FOR', scriptFor,86 );//For(初期処理;条件式;再初期化){ .. }//{ .. } の範囲を終了判定が真になるまで繰り返す
    cmd( 'While', scriptWhile,87 );//For(初期処理;条件式;再初期化){ .. }//{ .. } の範囲を終了判定が真になるまで繰り返す
    cmd( 'WHILE', scriptWhile,87 );//For(初期処理;条件式;再初期化){ .. }//{ .. } の範囲を終了判定が真になるまで繰り返す
    cmd( 'If', scriptIf,88 );//If(条件式){ 真 }Else{ 偽 }//条件式により処理を分ける
    cmd( 'IF', scriptIf,88 );//If(条件式){ 真 }Else{ 偽 }//条件式により処理を分ける
    cmd( 'SWITCH', scriptSwitch,127 );//Switch(条件式){ Case (条件){...} Default{...} }//条件式により処理を分ける
    cmd( 'Switch', scriptSwitch,127 );//Switch(条件式){ Case (条件){...} Default{...} }//条件式により処理を分ける
    cmd( '}', scriptNext,89 );//{ .. }//{ .. }を対にして使い、範囲を表す
    cmd( 'Exit', scriptExit,90 );//{ .. EXIT; }//ForやWhileの途中で、繰り返し部分から抜けるのに使う
    cmd( 'EXIT', scriptExit, 90);//{ .. EXIT; }//ForやWhileの途中で、繰り返し部分から抜けるのに使う
    cmd( 'Function', scriptFunction,91 );//Function 名前(引数宣言){ 内容 }//関数を定義する。引数宣言は、『型名 名前[=初期値]』のように書く
    cmd( 'FUNCTION', scriptFunction,91 );//Function 名前(引数宣言){ 内容 }//関数を定義する。引数宣言は、『型名 名前[=初期値]』のように書く
    cmd( 'Result', scriptResult,92 );//Result[=返却値]//関数の値を設定する
    cmd( 'RESULT', scriptResult,92 );//Result[=返却値]//関数の値を設定する
    //変数
    v('on', 1, 93); ////=1
    v('off', 0, 93); ////=0
    vs('?', ';PlayFrom(Time);', 120); //=PlayFrom(Time);//ここから演奏を開始する
    
    //組み込み関数
    cmd('Random', scriptRandom,94); //Random(num1[,num2])//num1~num2の乱数を返す。
    cmd('RandomSelect', scriptRandomSelect,95); //RandomSelect(n1,n2,n3...)//引数の中からランダムに選んだ値を返す
    cmd('Step', scriptStep,96); //Step(n)//"!数値"と同じ。前バージョンとの互換性のため
    cmd('STEP', scriptStep,96); //Step(n)//"!数値"と同じ。前バージョンとの互換性のため
    cmd('NoteNo', scriptNoteNo,97); //NoteNo(mml)//mmlに書かれたノートのノート番号を返す
    cmd('#STR', scriptIntToStr,98); //#STR(num)//numを文字列に変換して返す
    cmd('MML', scriptMML,99); //MML(コマンド)//コマンドに指定した値を得る。利用できるコマンド(l|v|o|q|t|@|BR|p%|Key|TimeKey)
    cmd('StrToLen', scriptStrToLen,100); //StrToLen(n)//ｎに書いた、ｎ分音符指定の長さを、ステップ値に変換して返す
    cmd('StrToNum', scriptStrToNum,101); //StrToNum(s)//sに書いた文字列を、数値に変換する
    cmd('SizeOf', scriptSizeOf,102); //SizeOf(var)//varに書いた配列のサイズを得る
    cmd('ASC', scriptASC,105); //ASC({str})//strの文字コードを得る
    cmd('CHR', scriptCHR,129); //CHR(no)//文字コードnoの文字を得る
    cmd('MID', scriptMID,106); //MID({str},Index,Len)//strのIndex番目から、Len文字切り出す
    cmd('POS', scriptPOS,115); //POS({sub},{str})//sub が strの何文字目にあるか検索する。見つからないときは、0を返す。
    cmd('POSX', scriptPOSEX,122); //POS({sub},{str})//sub が strの何文字目にあるか検索する。見つからないときは、0を返す。
    cmd('Replace', scriptReplace,107); //Replace({str},{A},{B},onoff)//strのAをBに置換する。onoffは、初めの１つだけを置換する場合は、off を、すべて置換する場合は on をセットする。
    cmd('HEX', scriptHEX,111); //HEX(n)//n を16進数に変換する
    cmd('VarType', scriptVarType,112); //VarType(var)//var の型を判別する

    cmd('ArraySortStr', scriptArraySortStr,124); //ArraySortStr(ary)//aryを文字列ソートする
    cmd('ArraySortNum', scriptArraySortNum,125); //ArraySortNum(ary)//aryを数値ソートする

    cmd('VERSION', scriptVersion,128); //VERSION//バージョン情報を整数で返す

    //その他
    cmd('End', scriptEnd,103); //End//コンパイルを中止する
    cmd('MsgBox', scriptMsgBox,104); //MsgBox({"str"})//ダイアログにメッセージを表示する

    {システム命令ここまで}
end;


function TMmlBase.getArgs(var sp: TSrcPos): TMArray;
begin
  Result := TokenBase.GetArgs(sp,'');
end;
//old ... 2002/10/31
(*
function TMmlBase.getArgs(var sp: TSrcPos): TMArray;
var
    sp2: TSrcPos;

    procedure getArray(var pp: TSrcPos);
    var
        mv: TMVarCustom;
        //sp3: TSrcPos;
    begin
        while True do
        begin
            skipSpace(pp.ptr);
            {if pp.ptr^ = '(' then      //todo: (a+b)-cのようなとき
            begin
                sp3 := TSrcPos.Create ;
                try
                    sp3.Assign(pp);
                    sp3.SetTempSource(GetMaruKakko(pp) );
                    getArray(sp3);
                finally
                    sp3.Free ;
                end;
            end else}
            begin
                mv := getArgAndCalc(pp) ;//引数を１つ取得
                if (mv<>nil)and(mv.ClassType = TMArray) then
                begin
                    Result.AddArray(mv as TMArray);
                end else
                begin
                    if mv=nil then
                    begin
                        //nil なら、ダミーの文字列を返す
                        Result.Add(TMStr.Create);
                    end else begin
                        Result.Add(mv) ;
                    end;
                end;
            end;
            skipSpace(pp.ptr);
            if pp.ptr^ in ValueSplitChar then //続きがあるか判別
            begin
                Inc(pp.ptr);
            end else
                Break;//終わり
        end;
    end;

begin
    {以下は、命令の引数と見なす
        command num,arg,arg...
        command=arg,arg,arg...
        command(arg,arg,arg...) }

    // 引数があるか判別。なければ、ＮＩＬを返す
    skipSpace(sp.ptr);
    case sp.ptr^ of
    //引数あり
    '=':
        begin
            Inc(sp.ptr);
            Result := TMArray.Create ;
            getArray( sp );
        end;
    '(':
        begin //カッコを展開して、変数をセットする
            Result := TMArray.Create ;
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp);
                sp2.SetTempSource( getMaruKakko(sp) );
                try
                    getArray( sp2 );
                except
                    on e: Exception do raise EParserError.Create(e.Message);
                end;
            finally
                sp2.Free;
            end;
        end;
    '%','!','$','0'..'9','{','-':
        begin
            Result := TMArray.Create ;
            getArray(sp);
        end;
    //引数なし
    else
        begin
            Result := nil;
        end;
    end;
end;
*)

//コメントのトリムなど一通り終わっているソースに対して解析を繰り返し行う
procedure TMmlBase.Compile(var sp: TSrcPos);
var
  s: string;
  IsStopCompile: Boolean;
begin
  if FlagStopCompile then Exit;

  // 無限再帰呼び出しのチェック
  Inc(NestCountCompile);
  if NestCountCompile > 128 then
  begin
    FlagStopCompile := True;
    raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'再帰呼び出し回数が128回を超えました。。',sp));
  end;
  try
    if sp=nil then Exit;

    while sp.ptr^ <> #0 do
    begin
      if FlagStopCompile then Exit;

      skipSpace(sp.ptr);
      if sp.ptr^ = #13 then
      begin
        skipSpaceReturn(sp.ptr, sp.lineNo);
        // 途中経過のレポート
        if Assigned(OnProgress) then
        begin
          if nowpos <> nil then
          begin
            s := 'MML解析中 "' + nowpos.cmd + '"';
            if LastLine < nowpos.lineNo then LastLine := nowpos.lineNo;
            OnProgress(LastLine, LineCount, PChar(s), @IsStopCompile);
          end else
          begin
            OnProgress(-1, -1, nil, @IsStopCompile);
          end;
          // コンパイルの中止
          if IsStopCompile then
          begin
            FlagStopCompile := True;
            sp := nil;
            raise EMml.Create(ErrMsg('ユーザーによりコンパイルが中止されました。',sp));
          end;
        end;
      end;
      try
        // 実際の実行
        Analize(sp);
        if FuncBreak > 0 then
        begin
            Dec(FuncBreak);
            Exit;
        end;
      except
        //コンパイルの中止を支持し、エラーを再送出
        FlagStopCompile := True;
        raise;
      end;
    end;
  finally
    if not FlagStopCompile then Dec(NestCountCompile);
  end;
end;

function TMmlBase.PreCompile(src: string; lineNo: Integer): string;
begin
    //前置処理
    try
    //WriteComTime('半角化');
    Result := convToHalfSign(src, lineNo);//全角半角処理
    //WriteLog(Result);
    //WriteComTime('ストトン化');
    Result := SutotonToMml(Result, lineNo);
    //WriteComTime('プロプロ終了');
    //WriteLog(Result);
    except
        on e: Exception do
            raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'ストトンの記述ミス。'+e.Message,nil));
    end;
end;

procedure TMmlBase.Analize(var sp: TSrcPos);
var
    token: string;
    node: TMHashNode;
    ret: TMVarCustom;
    ArrayIndex: Integer;

    procedure LetVar; //変数へ値を代入する
    var
        v: TMVarCustom;
    begin
        node.DefinePos.Assign(sp);//値を代入した場所を取得

        //---代入すべき値を取得する------------------------------------------
        //配列への代入か判別
        if node.nodeType <> ntArray then
        begin
            //整数、文字列への取得
            Inc(sp.ptr); // skip '='
            v := getArgAndCalc(sp);
        end else
        begin
            //配列の取得
            if ArrayIndex < 0 then
            begin //配列の取得
                v := getArgsWithType(sp,'a');
                //PrintCon(v.StrValue,sp);
            end else
            begin //要素の取得
                Inc(sp.ptr); // skip '='
                v := getArgAndCalc(sp);
                try try
                    if ArrayIndex >= TMArray(node.value).Count then
                    begin //Grow
                        TMArray(node.value).Items[ArrayIndex] := v.clone;
                    end else
                    begin
                        if TMArray(node.value).Items[ArrayIndex] <> nil then
                        begin
                          TMArray(node.value).Items[ArrayIndex].Assign(v);
                        end else
                        begin
                          TMArray(node.value).Items[ArrayIndex] := v.clone ;
                        end;
                    end;
                except //型が合わなければエラー
                    on e: Exception do raise EMml.CreateFmt( ErrMsg(MML_ERR_VAR_ILLIGAL_TYPE+e.Message,sp),[node.key] );
                end;
                finally
                    v.Free ;
                end;
                Exit;
            end;
        end;

        //---実際に値の代入を行う-----------------------------------------
        try
            try
                //型に併せて自動変換
                if  v=nil then Exit;
                if node.value.ClassType = TMInt then
                begin
                    TMInt(node.value).value := v.IntValue ;
                    //_debug(IntToStr(TMInt(node.value).value));
                end else
                if node.value.ClassType = TMStr then
                begin
                    TMStr(node.value).value := v.StrValue ;
                end else
                if node.value.ClassType = TMArray then
                begin
                    if v.ClassType = TMArray then
                    begin //配列から、配列への代入
                        TMArray(node.value).Assign(v) ;
                        //PrintCon(node.value.StrValue,sp);
                    end else
                    begin //文字列、数値を、配列へ代入
                        TMArray(node.value).Clear ;
                        TMArray(node.value).Add(v);
                    end;
                end else;
            except
                //型が合わなければエラー
                on e: Exception do
                    raise EMml.CreateFmt( ErrMsg(MML_ERR_VAR_ILLIGAL_TYPE+e.Message,sp),[node.key] );
            end;
        finally
            v.Free ;
        end;

    end;

    procedure ExecuteStr;
    var
        sp2: TSrcPos;
        s: string;
        mv: TMArray;

        procedure extract_sharp_macro;
        var
            arg: TMArray; i: Integer; skey,ss,t: string;
            pp: PChar;
            v: TMStr;
        begin
            //引数を得る
            if sp.ptr^ = '(' then
            begin
                pp := sp.ptr;
                t := Trim(GetMaruKakko(sp));
                if Pos(',',t)=0 then
                begin
                    t := Trim(t);
                    if (Copy(t,1,1)='{')and(Copy(t,Length(t),1)='}') then
                    begin
                        t := Copy(t,2,Length(t)-2);
                    end;
                    v := TMStr.Create ;
                    v.value := t;
                    arg := TMArray.Create;
                    arg.Add(v);
                end else
                begin
                    sp.ptr := pp;
                    arg := getArgs(sp);
                    t := '';
                end;
            end else
                arg := nil;

            ss := node.value.StrValue ;
            if arg<>nil then
            begin
                if Pos('#?',ss)=0 then
                begin
                    ss := ss + arg.StrValue ;
                end else
                for i:=0 to arg.Count -1 do
                begin
                    skey := '#?' + IntToStr(i+1);
                    ss := JReplace(ss, skey, arg.Items[i].StrValue, True);
                end;
            end else
            begin
                ss := ss + t;
            end;
            //str型ならば、値を展開する
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp);
                sp2.cmd := node.Key;
                node.DefinePos.cmd := node.Key ;
                sp2.SetTempSource( ss );
                try
                    Compile(sp2);
                except
                    raise EMml.CreateFmt( ErrMsg(MML_ERR_STR_EXPAND,node.DefinePos),[node.key] );
                end;
                sp2.cmd := '';
            finally
                sp2.Free ;
            end;
        
        end;

    begin
        //オプションか？
        if sp.ptr^ = '.' then
        begin
            Inc(sp.ptr);
            s := GetTokenChars(['(','=',' '],sp.ptr);
            Dec(sp.ptr); //'('など、進めすぎだから、１つ戻す
            if s='s' then
            begin
                mv := getArgs(sp);
                if mv = nil     then raise EMml.CreateFmt( ErrMsg(MML_ERR_ARG,sp),[s] );
                if mv.Count < 2 then raise EMml.CreateFmt( ErrMsg(MML_ERR_ARG,sp),[s] );
                (node.value as TMStr).value := JReplace(
                    node.value.StrValue, mv.Items[0].StrValue,
                    mv.Items[1].StrValue, True);
                Exit;
            end else
                raise EMml.CreateFmt( ErrMsg(MML_ERR_UNKNOWN,sp),[s] );
        end;
        //#str(引数)で、マクロの展開ができる
        if (Copy(node.Key,1,1)='#')and(sp.ptr^ = '(') then
        begin
            extract_sharp_macro;
            Exit;
        end;

        //str型ならば、値を展開する
        sp2 := TSrcPos.Create ;
        try
            sp2.Assign(sp);
            sp2.cmd := node.Key;
            node.DefinePos.cmd := node.Key ;
            sp2.SetTempSource( (node.value as TMStr).value );
            try
                Compile(sp2);
            except
                raise EMml.CreateFmt( ErrMsg(MML_ERR_STR_EXPAND,node.DefinePos),[node.key] );
            end;
            sp2.cmd := '';
        finally
            sp2.Free ;
        end;
    end;

    procedure subIncDec; //なんちゃってＣ言語風の、加算減算
    var
        v,v2:TMVarCustom;
    begin
        v := node.value ;
        if v.ClassType <> TMInt then raise EMml.CreateFmt(ErrMsg(MML_ERR_NOT_INT,sp),[node.key]);
        if (sp.ptr^='+')and((sp.ptr+1)^='+') then //Inc処理
        begin
            Inc(sp.ptr,2);
            Inc(TMInt(v).value);
        end else
        if (sp.ptr^='-')and((sp.ptr+1)^='-') then //Dec処理
        begin
            Inc(sp.ptr,2);
            Dec(TMInt(v).value);
        end else
        if (sp.ptr^='+')and((sp.ptr+1)^='=') then //Var+=n
        begin
            Inc(sp.ptr,2);
            v2 := getArgAndCalc(sp); //もう１つの値を得る
            if v2 <> nil then
            begin
                Inc(TMInt(v).value, v2.IntValue);
                v2.Free ;
            end;
        end else
        if (sp.ptr^='-')and((sp.ptr+1)^='=') then //Var-=n
        begin
            Inc(sp.ptr,2);
            v2 := getArgAndCalc(sp); //もう１つの値を得る
            if v2 <> nil then
            begin
                Dec(TMInt(v).value, v2.IntValue);
                v2.Free ;
            end;
        end else
        if (sp.ptr^='*')and((sp.ptr+1)^='=') then //Var*=n
        begin
            Inc(sp.ptr,2);
            v2 := getArgAndCalc(sp); //もう１つの値を得る
            if v2 <> nil then
            begin
                TMInt(v).value := TMInt(v).value * v2.IntValue;
                v2.Free ;
            end;
        end else
        if (sp.ptr^='/')and((sp.ptr+1)^='=') then //Var/=n
        begin
            Inc(sp.ptr,2);
            v2 := getArgAndCalc(sp); //もう１つの値を得る
            if v2 <> nil then
            begin
                TMInt(v).value := TMInt(v).value div v2.IntValue;
                v2.Free ;
            end;
        end else
            raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[sp.ptr^+(sp.ptr+1)^])
    end;

    function getArrayIndex: Integer;
    var
        s: string; sp2: TSrcPos ;
    begin
        s := GetKakko(sp.ptr);
        sp2 := TSrcPos.Create ;
        try
            sp2.Assign(sp); 
            sp2.SetTempSource(s);
            try
            try
                ret := getArgAndCalc(sp2);
                Result := ret.IntValue;
            except
                Result := -1;
                raise EMml.CreateFmt(ErrMsg(MML_ERR_SYNTAX+'%s',sp),['配列の要素番号の取得に失敗']);
            end;
            finally
                ret.Free ;
            end;
        finally
            sp2.Free ;
        end;
    end;

    procedure makeStr2; // 文字列変数を生成
    begin
        //'#'を
        node := TMHashNode.Create(token);
        node.DefinePos.Assign(sp);
        node.nodeType := ntStr ;
        node.value := TMStr.Create ;
        ParentCommands.Add(node);
    end;

begin
    //todo: analize
    //空白、改行処理
    skipSpaceReturn(sp.ptr, sp.lineNo);
    while sp.ptr^ in [' ',#9,';','|'] do Inc(sp.ptr);

    //1語読み出す
    token := getTokenMML(sp.ptr);
    if token='' then Exit;
    //ログを残す
    if MmlOption.EventLog then WriteLog(SourceFileName(sp.fileNo)+'('+IntToStr(sp.lineNo)+'):'+token);

    //命令か？
    node := Commands.Items[token];
    if node=nil then
    begin//"#変数"の 動的生成処理
        //sp.cmd := '';
        if Copy(token,1,1)='#' then
        begin
            makeStr2;
        end;
    end;
    if node<>nil then
    begin
        case node.nodeType of
        ntSysFunc, ntUserFunc:
            begin
                //関数を実行する
                ret := ExecuteCommand(node, sp);
                if ret<>nil then
                begin
                    ret.Free ;
                    ret := nil;
                end;
            end;
        ntStr, ntInt, ntArray:
            begin
                skipSpace(sp.ptr);
                //配列要素への代入か？
                if (sp.ptr^ = '(')and(node.nodeType = ntArray) then
                begin
                    ArrayIndex := getArrayIndex;
                    skipSpace(sp.ptr);
                end else
                    ArrayIndex := -1;
                //代入か？
                if sp.ptr^ = '=' then
                begin
                    LetVar; Exit;
                end else
                //変数の Inc 処理か
                if (sp.ptr^='+')or(sp.ptr^='-') then
                begin
                    subIncDec; Exit;
                end else
                begin
                    //文字列の展開か？
                    if node.nodeType = ntStr then
                    begin
                        ExecuteStr;
                        Exit;
                    end;
                end;
                //代入でも、文字列の展開でもなく、突然、変数が現れたら、エラーにする
                raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_CANT_EXECUTE,sp),[token]);
            end;
        else
            begin//未定義
            end;
        end;
    end else
    begin
        //命令が見つからない
        if token[1] in LeadBytes then
        begin
            ShowHint(Format(MML_ERR_UNKNOWN,[token]),sp);//ストトンの場合は、"Sakura v1"でエラーにならない。
        end else
        begin
            if token[1] in ['0'..'9'] then
            begin
                raise EMml.Create(ErrMsg('突然の"'+token+'"です。命令が必要です。', sp));
            end else
            begin
                ShowHint('"'+token+'"は未定義です。つづりを確かめてください。', sp);
            end;
            //raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN, sp),[token]);
        end;
    end;
end;


function TMmlBase.scriptInt(var sp: TSrcPos): TMVarCustom;
begin
    makeVariable(sp, VAR_TYPE_INT);
    Result := nil;
end;

function TMmlBase.scriptStr(var sp: TSrcPos): TMVarCustom;
begin
    makeVariable(sp, VAR_TYPE_STR);
    Result := nil;
end;

function TMmlBase.scriptArray(var sp: TSrcPos): TMVarCustom;
begin
    makeVariable(sp, VAR_TYPE_ARRAY);
    Result := nil;
end;

function TMmlBase.scriptPrint(var sp: TSrcPos): TMVarCustom;
var
    v: TMArray;
begin
    v := getArgs(sp) ;
    try
        //_debug(v.StrValue);
        if v=nil then
        begin
            PrintCon('nil', sp);
        end else
        begin
            PrintCon(v.StrValue, sp);
        end;
    finally
        v.Free ;
    end;
    Result := nil;
end;

function TMmlBase.getArg(var sp: TSrcPos): TMVarCustom;
begin
  Result := TokenBase.GetArg(sp, False);
end;

(*
function TMmlBase.getNumberM(var sp: TSrcPos): TMInt;
var
    s: string;
    n: Integer;
    sign: Integer;
begin
    //前置記号 ('-','+')
    sign := 1;
    if sp.ptr^ ='-' then
    begin
        Inc(sp.ptr); sign := -1;
    end else
    if sp.ptr^ = '+' then
    begin
        Inc(sp.ptr);
    end;

    if not(sp.ptr^ in ['$','0'..'9','!','%']) then
    begin
        Result := nil; Exit;
    end;
    Result := TMInt.Create;
    if sp.ptr^ = '%' then //フラグセット
    begin
        Result.Flag := '%'; Inc(sp.ptr);
    end;
    if sp.ptr^ = '!' then //(n)分音符指定
    begin
        Inc(sp.ptr);
        s := GetNumber( sp.ptr );
        n := StrToInt( s );
        //全音符のタイムベースを得て、ｎ分音符で割る
        Result.value := NtoStep(n);
    end else
    begin
        s := GetNumber( sp.ptr );
        Result.value := StrToIntDef( s, 0 ) * sign;
    end;
end;
*)

function TMmlBase.ExecuteCommand(node: TMHashNode; var sp: TSrcPos): TMVarCustom;
var
    nodeVar: TMVarCustom;
    n: TMVarCustom;
    i: Integer;
    tmp: TSrcPos;
    tmpS: string;

    procedure subUserFunc;
    var
        arg: TMArray;
        i,j: Integer;
        func: TMUserFunc;
        st: TMStruct;
        mv, temp: TMVarCustom;
        mv_node: TMHashNode;
    begin
        //todo: call UserFunc
        func := nodeVar as TMUserFunc;
        //引数の取得
        skipSpace(sp.ptr);
        //引数があるか？
        if sp.ptr^ in ARG_CHAR then
        begin//引数を取得
            try
                arg := getArgsWithType(sp, func.ArgType);
            except
                raise EMml.CreateFmt(ErrMsg(MML_ERR_CALL_FUNC+'引数の取得に失敗しました。',sp),[node.key]);
            end;
        end else
        begin //引数がない場合
            arg := TMArray.Create ; //ダミーを作成
        end;
        //arg に省略があれば、初期値をセット
        for i:=0 to Length(func.ArgType)-1 do
        begin
            if arg.Items[i] = nil then
            begin
                if func.ArgInit.Items[i]<>nil then
                    arg.Items[i] := func.ArgInit.Items[i].clone;
            end;
        end;
        //関数用の構造フレームを作成
        st := TMStruct.Create(Structs, stFunction);
        st.PosFrom.Assign(func.Src);
        st.PosTo.Assign(sp);
        //付け替え
        Structs := st;
        Commands := st.varHash ;
        //引数を、ローカル変数ハッシュへ登録
        for  i:= 0 to Length(func.ArgType)-1 do
        begin
            //変数ハッシュノードを作成
            mv_node := TMHashNode.Create(func.ArgName[i]);

            //型ごとに値を生成
            case func.ArgType[i+1] of//ArgType は、文字列だから +1 する。（Pascalの文字列は、１から）
            'i':begin
                    mv := TMInt.Create ;
                    mv_node.nodeType := ntInt;
                    if arg.Items[i] <> nil then
                    begin
                        TMInt(mv).value := arg.Items[i].IntValue ;
                        //_debug(IntToStr(TMInt(mv).value));
                    end;
                end;
            's':begin
                    mv := TMStr.Create ;
                    mv_node.nodeType := ntStr;
                    if arg.Items[i] <> nil then
                        TMStr(mv).value := arg.Items[i].StrValue
                    else
                        TMStr(mv).value := '';
                end;
            'a':begin
                    mv := TMArray.Create ;
                    mv_node.nodeType := ntArray;
                    try
                        for j:=i to arg.Count -1 do
                        begin
                            TMArray(mv).Add(arg.Items[j]);
                        end;
                        mv_node.value := mv;
                        //ハッシュへ登録
                        Commands.Add(mv_node);
                        Break;
                    except
                        raise EMml.CreateFmt(ErrMsg(MML_ERR_CALL_FUNC+' %d番目の引数の型が違います。',sp),[node.key, i+1]);
                    end;
                end;
            else
                mv := TMInt.Create;
            end;
            mv_node.value := mv;
            //ハッシュへ登録
            Commands.Add(mv_node);
        end;
        //ポインタを関数の中へ
        sp.Assign(func.Src);
        temp := FuncResult;
        FuncResult := nil;
        try
          Compile(sp);//実行
        finally
          //返り値をセットしてユーザー関数呼び出し完了
          Result := FuncResult ;
          //_debug(Result.StrValue);
          FuncResult := temp;
        end;
    end;

    procedure getArrayValue;
    begin
        if sp.ptr^ = '(' then
        begin //配列要素へのアクセス
            n := getArg(sp) ;
            if n<>nil then
            begin
                i := n.IntValue ;
                n.Free;
                //n := nil;
                n := TMArray(nodeVar).Items[i];
                if n <> nil then Result := n.clone else Result := nil;
            end;
        end else
        begin
            Result := TMArray(nodeVar).clone ;
        end;
    end;

begin
    Result := nil;

    //ノードにぶら下がっている変数を得る
    nodeVar := node.value ;
    if nodeVar = nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_SYSTEM+'変数"%s"の値が設定されていません。',sp),[node.key]);

    //変数のタイプ別に値を得る
    case node.nodeType of
        ntInt, ntStr:
        begin
            Result := nodeVar.clone ;
        end;
        ntArray:
        begin
            getArrayValue;
        end;
        ntSysFunc:
        begin
            try
                sp.cmd := node.Key ;
                Result := TMFunc(nodeVar).Execute(sp);
            except
              on e: Exception do
              begin
                raise EMml.CreateFmt(ErrMsg(MML_ERR_CALL_FUNC + e.Message,sp),[node.key]);
                Exit;
              end;
            end;
        end;
        ntUserFunc:
        begin
            tmp := TSrcPos.Create ;
            try
                try
                    sp.cmd := node.Key ;
                    tmpS := NowFunc;
                    NowFunc := node.Key ; //現在のユーザー関数
                    tmp.Assign(sp);
                    subUserFunc;
                    NowFunc := tmpS; //現在のユーザー関数を戻す
                except
                    raise EMml.CreateFmt(ErrMsg(MML_ERR_CALL_USER_FUNC,tmp{呼び出し元を特定}),[node.key]);
                end;
            finally
                tmp.Free ;
            end;
        end;
    end;

end;


procedure TMmlBase.makeVariable(var sp: TSrcPos; c:Char);
var
    node: TMHashNode;
    name: string;
    v: TMVarCustom;

    procedure CreateNodeValue;
    begin
        case c of
        VAR_TYPE_INT:
            begin
                node.value := TMInt.Create ;
                node.nodeType := ntInt;
            end;
        VAR_TYPE_STR:
            begin
                node.value := TMStr.Create ;
                node.nodeType := ntStr;
            end;
        VAR_TYPE_ARRAY:
            begin
                node.value := TMArray.Create ;
                node.nodeType := ntArray;
            end;
        end;
    end;

    procedure LetInitValue;
    begin
        // 初期値を取得
        if sp.ptr^ = '(' then
        begin
            ShowHint('代入には、"="を使ってください。',sp); //以前のバージョン
        end else
        if sp.ptr^ = '=' then
        begin
            Inc(sp.ptr); // skip '='
            skipSpaceReturn(sp.ptr, sp.lineNo);
            skipSpace(sp.ptr); 
        end;
        try
            case c of
            VAR_TYPE_INT:
                begin
                    v := getArgAndCalc(sp);
                    if v <> nil then
                    begin
                        TMInt(node.value).value := v.IntValue;
                        v.Free ;
                    end;
                end;
            VAR_TYPE_STR:
                begin
                    v := getArgAndCalc(sp);
                    if v<>nil then begin
                        TMStr(node.value).value := v.StrValue;
                        v.Free ;
                    end;
                end;
            VAR_TYPE_ARRAY:
                begin
                    skipSpace(sp.ptr);
                    if sp.ptr^ = '(' then
                    begin
                        v := getArgs(sp);
                        if v<>nil then
                        begin
                            TMArray(node.value).Assign(v);
                            v.Free ;
                        end;
                    end else begin //配列を丸投げ
                        //'='まで戻す
                        while sp.ptr^ <> '=' do Dec(sp.ptr);
                        v := getArgs(sp);
                        if v<>nil then
                        begin
                            if v.ClassType = TMArray then
                                TMArray(node.value).Assign(v)
                            else
                                TMArray(node.value).Add(v);
                            v.Free ;
                        end;
                    end;
                end;
            end;
        except
            //取得した値が生成した型と違えばエラー
            raise EMml.CreateFmt(ErrMsg(MML_ERR_SYNTAX+'変数"%s"の値の初期化値の取得に失敗。',sp),[name]);
        end;
    end;

begin
    skipSpace(sp.ptr);

    // 変数名を取得
    name := getTokenWord(sp.ptr);
    if name='' then
    begin
        if sp.ptr^ in USER_DEFINE_CHAR then
        begin
            name := sp.ptr^;
            Inc(sp.ptr);
        end;
    end;
    if name='' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'名前がありません。',sp),[sp.cmd]);

    //ローカルに同じ名前がないか確認
    if Commands.ExistsLocalKey(name) then
    begin
        ShowHint(Format(MML_ERR_VAR_ALREADY_EXISTS,[ name ]),sp);
        Commands.Delete(name);
        //raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_ALREADY_EXISTS,sp),[name]);
    end;

    // 変数を生成し、ハッシュに追加
    node := TMHashNode.Create(name);
    node.DefinePos.Assign(sp); //定義場所を記憶

    //実際の値を生成
    CreateNodeValue;
    Commands.Let( node ); // 現在の変数管理用のハッシュに登録

    // 初期値があるか
    skipSpace(sp.ptr);
    if sp.ptr^ in [ '=','(' ] then
    begin
        LetInitValue;
    end;
    //_debug(node.value.StrValue);
end;


function TMmlBase.scriptLoopFrom(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct;
    n : TMVarCustom ;
begin
    Result := nil;
    
    //スクリプトの下層構造を生成
    st := TMStruct.Create(Structs, stLoop);

    //実行範囲を得る  [n ... ] ネスとされたカッコ
    //範囲先頭
    st.PosFrom.Assign(sp); // '['の後 、後で、[(n)... の n を得る

    //範囲最後
    Dec(sp.ptr);// back '['
    try
        skipKakko(sp.ptr, sp.lineNo, '[',']');
    except
        raise EMml.CreateFmt(ErrMsg(MML_ERR_KAKKO_NOT_PAIR,st.PosFrom),['[..]']);
    end;
    st.PosTo.Assign(sp);

    //リピート回数を得る
    try
        while st.PosFrom.ptr^ in [#9,' '] do Inc(st.PosFrom.ptr);
        if st.PosFrom.ptr^ in ARG_CHAR then
        begin
            n := getArg(st.PosFrom);
            if n=nil then st.LoopCount := 2 else
            begin
                st.LoopCount := n.IntValue ;
                n.Free ;
            end;
        end else
        begin
            st.LoopCount := 2;
        end;
    except
        raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE, sp),['[']);
    end;
    st.LoopIndex := 0;

    if st.LoopCount <= 0 then
    begin//ループしない
        st.Free ;
        //spは、リピートの最後を指しているので、このまま抜ける
        Exit;
    end;

    //カレント構造を、付け替える
    Commands := st.varHash ;
    Structs := st;
    sp.Assign(Structs.PosFrom);
end;

function TMmlBase.scriptLoopTo(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct;
begin
    Result := nil;

    //整合性のチェック
    if Structs.StructType <> stLoop then raise EMml.CreateFmt(ErrMsg(MML_ERR_KAKKO_NOT_PAIR,sp),['[..]']);

    //リピート回数をチェック
    Inc(Structs.LoopIndex);
    if Structs.LoopIndex >= Structs.LoopCount then
    begin
        //ループ終了
        st := Structs.Parent ;
        Structs.Free ;//カレント構造を、破棄
        Structs := st;//親に付け替え
        Commands := Structs.varHash ;
        Exit;
    end;

    //ループ先頭へ戻る
    sp.Assign(Structs.PosFrom);
end;

function TMmlBase.scriptLoopBreak(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct;
begin
    Result := nil;

    //整合性のチェック
    if Structs.StructType <> stLoop then raise EMml.CreateFmt(ErrMsg(MML_ERR_KAKKO_NOT_PAIR,sp),['[ : ]']);

    //リピート回数をチェック
    if (Structs.LoopIndex+1) = Structs.LoopCount then //最後の一回か？
    begin
        //ループ終了
        sp.Assign(Structs.PosTo); // ] 後ろにポインタを付け替え

        st := Structs.Parent ;
        Structs.Free ;//カレント構造を、破棄
        Structs := st;//親に付け替え
        Commands := Structs.varHash ;

        Exit;
    end;
end;

function TMmlBase.scriptFor(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    st: TMStruct;
    v: TMVarCustom;
begin
    //todo: FOR
    Result := nil;
    st := TMStruct.Create(Structs, stFor);

    //初期化式、条件式、再初期化式を得る
    s := getMaruKakko(sp); //For の後の、(..) を得た
    st.siki1 := GetToken(';', s);
    st.Jouken := GetToken(';', s);
    st.siki2 := s;

    //繰り返し範囲開始を得る
    skipSpaceReturn(sp.ptr, sp.lineNo);
    if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('Forの後に "{" がありません。',sp));
    st.PosFrom.Assign(sp);
    Inc(st.PosFrom.ptr); //skip '{'

    //範囲終わりを得る
    skipKakko(sp.ptr, sp.lineNo, '{','}');
    st.PosTo.Assign(sp);

    //スクリプト構造のスコープをForに付け替え
    Structs := st;
    Commands := Structs.varHash ;

    //初期化式を実行
    sp.ptr := PChar(Structs.siki1);
    try
        Compile(sp);
    except
        raise EMml.Create(ErrMsg('Forの初期化に失敗。',sp));
    end;

    //条件式を評価
    sp.ptr := PChar(Structs.Jouken);
    v := getArgAndCalc(sp);
    try
        if v.IntValue = BOOL_FALSE then
        begin //For いきなり実行しないとき
            sp.Assign(Structs.PosTo);
            st := Structs.Parent ; // Structs を、親に付け替える
            Structs.Free ;
            Structs := st;
            Commands := Structs.varHash ;
            Exit;
        end;
        sp.Assign(Structs.PosFrom); //Ｆｏｒ先頭に飛ぶ 
    finally
        v.Free ;
    end;
end;

function TMmlBase.scriptNext(var sp: TSrcPos): TMVarCustom;
const
  CHECK_MUGEN = 4096;

    procedure LoopLast;
    var
        st: TMStruct ;
    begin
        st := Structs.Parent ;
        Structs.Free ;
        Structs := st;
        Commands := Structs.varHash ;
    end;

    procedure subFor;
    var
        v: TMVarCustom;
    begin
        //再初期化式を実行
        sp.lineNo := Structs.PosFrom.lineNo ;
        sp.ptr := PChar( Structs.siki2 );
        Compile(sp);
        //条件式を評価
        sp.ptr := PChar( Structs.Jouken );
        v := getArgAndCalc(sp);
        if (v=nil) or (v.IntValue = BOOL_FALSE) then
        begin //For から抜ける
            sp.Assign(Structs.PosTo); //For 後ろにポインタを付け替え
            LoopLast;
            Exit;
        end else
        begin
            Inc(Structs.LoopCount);
            if Structs.LoopCount > CHECK_MUGEN then
            begin
                raise EMml.Create(ErrMsg(MML_ERR_SYSTEM+'FORで無限ループの可能性があります。',sp));
            end;
        end;
        sp.Assign(Structs.PosFrom); //繰り返し先頭に戻る
    end;

    procedure subWhile;
    var
        v: TMVarCustom;
    begin
        //条件式を評価
        sp.lineNo := Structs.PosFrom.lineNo ;
        sp.ptr := PChar( Structs.Jouken );
        v := getArgAndCalc(sp);
        if (v=nil) or (v.IntValue = BOOL_FALSE) then
        begin //While から抜ける
            sp.Assign(Structs.PosTo); //While 後ろにポインタを付け替え
            LoopLast;
            Exit;
        end else
        begin
            Inc(Structs.LoopCount);
            if Structs.LoopCount > CHECK_MUGEN then
            begin
                raise EMml.Create(ErrMsg(MML_ERR_SYSTEM+'WHILEで無限ループの可能性があります。',sp));
            end;
        end;
        sp.Assign(Structs.PosFrom); //繰り返し先頭に戻る
    end;

    procedure subIF;
    begin
        sp.Assign(Structs.PosTo); //If 後ろにポインタを付け替え
        LoopLast;
        Exit;
    end;

    procedure subFunc;
    begin
        sp.Assign(Structs.PosTo); //元の位置に戻る
        LoopLast;
        Inc(FuncBreak);
        Exit;
    end;

    procedure subSwitch;
    begin
        sp.Assign(Structs.PosTo); //If 後ろにポインタを付け替え
        LoopLast;
        Exit;
    end;

begin
    Result := nil;
    //構造式が正しいか判断
    if Structs.StructType = stNormal then
    begin
        //raise EMml.CreateFmt(ErrMsg('突然の"}"。'+MML_ERR_KAKKO_NOT_PAIR,sp),['{ .. }']);
        ShowHint('突然の"}"。',sp);
        Exit;
    end;
    //構造式によって、処理を分岐
    case Structs.StructType of
        stFor: subFor;
        stWhile: subWhile;
        stIf: subIf;
        stSwitch: subSwitch;
        stFunction: subFunc;
    end;
end;

function TMmlBase.scriptWhile(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct ;
    v: TMVarCustom;
begin
    Result := nil;
    st := TMStruct.Create(Structs, stWhile);

    //条件式を得る
    st.Jouken := getMaruKakko(sp);
    skipSpaceReturn(sp.ptr, sp.lineNo);

    //Whileの範囲開始位置を得る
    if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('While の後に "{" がありません。',sp));
    st.PosFrom.Assign(sp);
    Inc(st.PosFrom.ptr); // skip '{'

    //範囲終了位置を得る
    skipKakko(sp.ptr, sp.lineNo, '{','}');
    st.PosTo.Assign(sp);

    //条件式を評価
    sp.lineNo := st.PosFrom.lineNo ;
    sp.ptr := PChar( st.Jouken );
    v := getArgAndCalc(sp);
    try
    if (v=nil)or(v.IntValue = BOOL_FALSE) then
    begin//実行しない
        sp.Assign(st.PosTo);
        st.Free ;
        Exit;
    end;
    finally
        v.Free ;
    end;
    //付け替え
    Structs := st;
    Commands := Structs.varHash ;
    sp.Assign(Structs.PosFrom);
end;

function TMmlBase.scriptIf(var sp: TSrcPos): TMVarCustom;
var
    st: TMStruct ;
    v: TMVarCustom;
begin
    Result := nil;
    st := TMStruct.Create(Structs, stIf);

    //条件式を得る
    st.Jouken := getMaruKakko(sp);
    skipSpaceReturn(sp.ptr, sp.lineNo);

    //Ifの範囲開始位置を得る
    if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('If の後に "{" がありません。',sp));
    st.PosFrom.Assign(sp);
    Inc(st.PosFrom.ptr); // skip '{'

    //範囲終了位置を得る
    skipKakko(sp.ptr, sp.lineNo, '{','}');
    st.PosTo.Assign(sp);

    //Elseがあるか？？
    skipSpaceReturn(sp.ptr, sp.lineNo);
    skipSpace(sp.ptr);
    if (StrLcomp(sp.ptr, 'ELSE', 4) = 0)or(StrLcomp(sp.ptr, 'Else', 4) = 0) then
    begin //Elseがある
        Inc(sp.ptr,4); //skip "Else"

        //Else開始位置を得る
        skipSpaceReturn(sp.ptr, sp.lineNo);
        if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('If..Else の後に "{" がありません。',sp));
        st.PosElse.Assign(sp);
        Inc(st.PosElse.ptr); // skip '{'
        //Else終了位置
        skipKakko(sp.ptr, sp.lineNo, '{','}');
        st.PosTo.Assign(sp);
    end else
    begin //Elseがない
        st.PosElse.ptr := nil; //判別できるように、nilを
    end;

    //条件式を評価
    sp.lineNo := st.PosFrom.lineNo ;
    sp.ptr := PChar( st.Jouken );
    v := getArgAndCalc(sp);
    try
    if (v=nil)or(v.IntValue = BOOL_FALSE) then
    begin// Elseを実行
        if st.PosElse.ptr = nil then
        begin//Elseがない = 抜ける
            sp.Assign(st.PosTo) ;
            st.Free ;
            Exit;
        end;
        //set
        sp.Assign(st.PosElse);
    end else
        sp.Assign(st.PosFrom);
    finally
        v.Free ;
    end;
    //付け替え
    Structs := st;
    Commands := Structs.varHash ;
end;

function TMmlBase.scriptExit(var sp: TSrcPos): TMVarCustom;

    procedure ExitCurStruct;
    var s: TMStruct;
    begin
        sp.Assign(Structs.PosTo);
        s := Structs.Parent ;
        Structs.Free ;
        Structs := s;
        Commands := Structs.varHash ;
    end;

begin
    Result := nil;
    //とりあえず、IF は、無条件に抜ける
    while True do
    begin
        if Structs.StructType <> stIf then Break;
        ExitCurStruct;
    end;
    //問題なければ１つだけ抜ける
    if Structs.StructType = stNormal then
    begin
        raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'Exitがループ外にあります。',sp));
    end;
    ExitCurStruct;
end;

function TMmlBase.scriptFunction(var sp: TSrcPos): TMVarCustom;
var
    name, arg_s, s: string;
    func: TMUserFunc;
    p: PChar;
    idx: Integer;
    iv: TMVarCustom;
    node: TMHashNode;

    procedure getInitValue;
    var
        sp2: TSrcPos;
    begin
        sp2 := TSrcPos.Create ;
        try
            Inc(p);// skip '='
            sp2.Assign(sp);
            sp2.ptr := p;
            iv := getArg(sp2);
            func.ArgInit.Add(iv);
            p := sp2.ptr ;
        finally
            sp2.Free ;
        end;
    end;

const
    MAX_ARG = 64;
begin
    Result := nil;

    //関数名の取得
    name := getTokenWord(sp.ptr);
    if name='' then
    begin
        if sp.ptr^ in USER_DEFINE_CHAR then
        begin
            name := sp.ptr^;
            Inc(sp.ptr);
        end;
    end;

    if name='' then raise EMml.Create(ErrMsg(MML_ERR_DEF_FUNC+'関数名がありません。',sp));

    //ローカルに同じ名前がないか確認
    if Commands.ExistsLocalKey(name) then
    begin
        ShowHint(Format(MML_ERR_FUNCTION_ALREADY_EXISTS,[ name ]),sp);
        Commands.Delete(name);
        //raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_ALREADY_EXISTS,sp),[name]);
    end;

    func := TMUserFunc.Create ;
    func.ArgType := '';

    //引数の取得
    skipSpace(sp.ptr);
    if sp.ptr^ = '(' then
    begin
        arg_s := getMaruKakko(sp);
        p := PChar(arg_s);
        idx := 0;
        SetLength(func.ArgName, MAX_ARG);//適当に64個を予定
        func.ArgType := '';
        while p^ <> #0 do
        begin
            //引数の型を得る .. 型名の場合は、名前を得る
            skipSpace(p);
            s := GetTokenChars([' ',',','=','(',')',#9],p);
            Dec(p);//区切り文字を戻す
            if s='' then Break;
            if (s='Int')or(s='INT') then
            begin
                func.ArgType := func.ArgType + 'i';
                s := getTokenWord(p);
            end else
            if (s='Str')or(s='STR') then
            begin
                func.ArgType := func.ArgType + 's';
                s := getTokenWord(p);
            end else
            if (s='Array')or(s='ARRAY') then
            begin
                func.ArgType := func.ArgType + 'a';
                s := getTokenWord(p);
            end else
            begin//省略は、INT型
                func.ArgType := func.ArgType + 'i';
            end;
            //引数名をセット
            func.ArgName[idx] := s;
            Inc(idx);
            if MAX_ARG <= idx then raise EMml.CreateFmt(ErrMsg(MML_ERR_DEF_FUNC+'引数の数が %i 個を超えました。',sp),[MAX_ARG]);
            //初期値があるか？
            skipSpace(p);//
            if p^ = '=' then
                getInitValue
            else
                func.ArgInit.Add(nil);

            while p^ in [#9,#13,#10,' '] do Inc(p);
            if p^ = ',' then Inc(p) else Break;
            while p^ in [#9,#13,#10,' '] do Inc(p);

        end;
        if idx<>0 then //ArgNameの帳尻合わせ
        begin
            SetLength(func.ArgName, idx);
        end else
            func.ArgName := nil;
    end;
    //関数内容の取得
    skipSpaceReturn(sp.ptr, sp.lineNo); 
    if sp.ptr^<>'{' then  raise EMml.CreateFmt(ErrMsg(MML_ERR_DEF_FUNC+'関数宣言で "{" がありません。',sp),[MAX_ARG]);

    //ソース取得
    func.Src.Assign(sp);
    func.Src.cmd := name;
    Inc(func.Src.ptr); // skip '{'
    skipKakko(sp.ptr, sp.lineNo, '{', '}');//ポインタは、関数の最後まで持っていく

    //ハッシュへ登録
    node := TMHashNode.Create(name);
    node.DefinePos.Assign(func.Src);
    node.nodeType := ntUserFunc;
    node.value := func;
    Commands.Add(node);
end;


function TMmlBase.scriptResult(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
begin
    //代入があるか確認
    skipSpace(sp.ptr);

    if sp.ptr^ = '=' then
    begin
        Inc(sp.ptr); // skip '='
        v := getArgAndCalc(sp);

        {
        if Structs.Parent <> nil then
            Structs.Parent.Result := v
        else
            if v<>nil then v.Free;
        }
        if FuncResult <> nil then FuncResult.Free ;
        FuncResult := v;
    end;
    //返却値をセット
    {
    if Structs.Parent <> nil then
        Result := Structs.Parent.Result.clone
    else
        Result := nil;
    }
    if FuncResult=nil then
    begin
        Result := nil;
    end else
    begin
        Result := FuncResult.clone ;
    end;
end;

function TMmlBase.funcLength(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Length, 'l', SongInfo.TimeBase);
end;

function TMmlBase.funcNoteA(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'a');
end;

function TMmlBase.funcNoteB(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'b');
end;

function TMmlBase.funcNoteC(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'c');
end;

function TMmlBase.funcNoteD(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'd');
end;

function TMmlBase.funcNoteE(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'e');
end;

function TMmlBase.funcNoteF(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'f');
end;

function TMmlBase.funcNoteG(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'g');
end;

function TMmlBase.funcOctave(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Octave, 'o', 1);
end;

function TMmlBase.funcQgate(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Qgate, 'q', SongInfo.qAdd);
end;

function TMmlBase.funcTiming(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Timing, 't', 1);
end;

function TMmlBase.funcVelocity(var sp: TSrcPos): TMVarCustom;
begin
    Result := SetNoteInfo(sp, CurTrack.Velocity, 'v', SongInfo.vAdd);
end;

function Div2(a,b: Integer): Integer;
begin
    if b=0 then begin Result := 0; Exit; end;
    Result := a div b;
end;

//NoteOn  Option [(l),(q),(v),(t),(o)]
function TMmlBase.NoteOn(var sp: TSrcPos; NoteName: Char): TMInt;
var
    l,q,v,t,o,nn: Integer; stepm,qstep: Boolean;

    procedure getNoteArg;
    var
        flag: Char;
        qq, qMax: Integer;
        r: Extended;
        mv: TMVarCustom ;
        order: string;
        i: Integer;

        procedure subL;
        begin
          l := GetNoteLength(sp, stepm, l);
        end;
        procedure subQ;
        begin
          //Gate
          if sp.ptr^ in ['+','-','*','/'] then begin flag := sp.ptr^; Inc(sp.ptr); end else flag := #0;
          if sp.ptr^ in ['%','!','$','(','0'..'9'] then
          begin
              mv := getArg(sp);
              if mv<>nil then
              begin
                  if mv.ClassType <> TMInt then
                      raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);

                  case flag of
                      '+': q := q + mv.IntValue ;
                      '-': q := q - mv.IntValue ;
                      '*': q := q * mv.IntValue ;
                      '/': q := Div2(q , mv.IntValue) ;
                      else q := mv.IntValue ;
                  end;
                  if TMInt(mv).Flag = '%' then qstep := True else qstep := False;
                  mv.Free ;
              end;
          end else qstep := False;
        end;
        procedure subV;
        begin
          if sp.ptr^ in ['+','-','*','/'] then begin flag := sp.ptr^; Inc(sp.ptr); end else flag := #0;
          if sp.ptr^ in ['!','$','(','0'..'9'] then
          begin
              mv := getArg(sp);
              if mv<>nil then begin
                  if mv.ClassType <> TMInt then
                      raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
                  case flag of
                      '+': v := v + mv.IntValue ;
                      '-': v := v - mv.IntValue ;
                      '*': v := v * mv.IntValue ;
                      '/': v := Div2(v , mv.IntValue) ;
                      else v := mv.IntValue ;
                  end;
                  mv.Free ;
              end;
          end;
        end;
        procedure subT;
        begin
          skipSpace(sp.ptr);
          if sp.ptr^ in ['+','-','*','/'] then begin flag := sp.ptr^; Inc(sp.ptr); end else flag := #0;
          if sp.ptr^ in ['!','$','(','0'..'9'] then
          begin
              mv := getArg(sp);
              if mv<>nil then begin
                  if mv.ClassType <> TMInt then
                      raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
                  case flag of
                      '+': t := t + mv.IntValue ;
                      '-': t := t - mv.IntValue ;
                      '*': t := t * mv.IntValue ;
                      '/': t := Div2(t , mv.IntValue) ;
                      else t := mv.IntValue ;
                  end;
                  mv.Free ;
              end;
          end;
        end;
        procedure subO;
        begin
          //Octave
          if sp.ptr^ in ['+','-','*','/'] then begin flag := sp.ptr^; Inc(sp.ptr); end else flag := #0;
          if sp.ptr^ in ['!','$','(','0'..'9'] then
          begin
              mv := getArg(sp);
              if mv<>nil then begin
                  if mv.ClassType <> TMInt then
                      raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
                  case flag of
                      '+': o := o + mv.IntValue ;
                      '-': o := o - mv.IntValue ;
                      '*': o := o * mv.IntValue ;
                      '/': o := Div2(o , mv.IntValue) ;
                      else o := mv.IntValue ;
                  end;
                  mv.Free ;
              end;
          end;
        end;

    begin
        // ArgOrder に沿って引数を取得
        order := CurTrack.ArgOrder;

        // 引数を得る
        for i:=1 to Length(order) do
        begin
          case order[i] of
            'l': subL;
            'q': subQ;
            'v': subV;
            't': subT;
            'o': subO;
            else
              raise EMml.CreateFmt(ErrMsg(MML_ERR_WRONG_ARG_ORDER,sp),[order[i]]);
          end;
          if sp.ptr^ <> ',' then Break;
          Inc(sp.ptr);
          skipSpace(sp.ptr);
        end;

        //ゲートの計算
        qmax := SongInfo.qMax ;
        qq := CurTrack.Qgate.GetQGateValue(l, qmax);//__0~9までの値加算すればよい
        if qstep then
        begin
            q := q+qq;
        end else
        begin
            // ゲートレートを、ステップに変換
            r := q / qmax;
            q := Trunc(l * r) + qq;
            if (q=0)and(qmax>0)and(l>0) then q := 1;
        end;
        if l>0 then q := q - CurTrack.Q2; //ゲートの補正
        //if q<=0 then q := 1;

        //ベロシティの計算
        if SongInfo.vMax <> 127 then
        begin
            v := Trunc(v * (128 / (SongInfo.vMax+1)));
        end;

        //オクターブの計算
        if FlagOctaveUpOnce <> 0 then
        begin
            Inc(o,FlagOctaveUpOnce);
            FlagOctaveUpOnce := 0;
        end;

    end;


    procedure WriteTrack;
    var
        c, wc: TSmfNoteOn;
        i,sa: Integer;

        procedure subTie; //タイの処理
        var i,len: Integer;

            procedure subGate;
            var blen: Integer;
            begin
                i := 1;
                while i < TieStack.Count do
                begin
                    c := TieStack.Items[i]; Inc(i);
                    //単純に音の長さを加算して書き込む（タイ＆スラー共通）
                    sa := c.NoteNo - wc.NoteNo ; //差を算出
                    if sa=0 then
                    begin
                        wc.Len := Max((wc.Len + c.Len -1),1);
                        c.Free ;//スタックに積まないから、解放してしまう
                    end else
                    begin
                        len := c.Time - Trunc(wc.Time);
                        if wc.OptionValue = MaxInt then blen := CurTrack.TieValue else blen := wc.OptionValue;
                        if blen<0 then
                        begin
                            len := len + Trunc(len * (blen/100));
                        end else
                        begin
                            len := Trunc(len * (blen/100));
                        end;
                        wc.Len := len-1;
                        CurSmfTrack.Add(wc);
                        wc := c;
                    end;
                end;
                CurSmfTrack.Add(wc);//元となる音を書き込む
            end;
            procedure subAlp;
            var i, maxN, j: Integer; wwc: TSmfNoteOn;
            begin
                maxN := CurTrack.TieValue -1;//最大和音数
                if maxN<=0 then Exit;
                for i:=0 to TieStack.Count-1 do
                begin
                    c := TieStack.Items[i];
                    j := Min(i + maxN, TieStack.Count -1);
                    wwc := TieStack.Items[j];
                    c.len := (wwc.Time - c.Time) + wwc.Len ;
                    CurSmfTrack.Add(c);
                end;
            end;
            procedure subBend(griss: Boolean);
            var
                len,fromTime,i,saMax, oldP, blen: Integer;
                br: Integer; rpn: TSmfRpn; p: Integer; wwc: TSmfNoteOn;
            begin
                //差の最大値を得る
                wwc := TieStack.Items[TieStack.Count-1];//最後のノートを基準にする
                saMax := 0;
                for i:=0 to TieStack.Count -2 do
                begin
                    c := TieStack.Items[i];
                    sa := abs(wwc.NoteNo - c.NoteNo);
                    if sa > saMax then saMax := sa;
                end;
                br := SongInfo.BendRange[CurTrack.Channel];
                if br < saMax then //ベンド幅より差が大きい
                begin
                    if saMax > BEND_RANGE_MAX then //GMレベルでは、ベンド出来ない
                    begin
                        with CurTrack do begin
                            i := TieValue ; TieValue := 100;
                            subGate; TieValue := i; Exit;
                        end;
                    end;
                    //ベンド幅を勝手に変更してしまう
                    rpn := TSmfRpn.Create ;
                    rpn.rpnType := typeRpn;
                    rpn.msb := 0; rpn.lsb := 0; rpn.data := BEND_RANGE_MAX;
                    rpn.byteCount := 3;
                    rpn.Event := EVENT_CONTROL_CHANGE or CurTrack.Channel ;
                    rpn.Time := wc.Time - 2;
                    CurSmfTrack.Add(rpn);
                    br := BEND_RANGE_MAX ;
                    SongInfo.BendRange[CurTrack.Channel] := br;
                end;
                fromTime := wc.Time ;
                wc := TieStack.Items[TieStack.Count-1];//最後のノートを基準にする

                //top note
                c := TieStack.Items[0];
                sa := c.NoteNo - wc.NoteNo;
                p := Trunc(sa * (8192/br));
                WritePicthBend(c.Time-1, p);
                oldP := p;
                blen := c.OptionValue ;
                c.Free;

                for i:=1 to TieStack.Count -2 do
                begin
                    c := TieStack.Items[i];
                    sa := c.NoteNo - wc.NoteNo;
                    p := Trunc(sa * (8192/br));
                    if (oldP = p) then Continue;
                    if griss then
                    begin
                        //Wave書き込み準備
                        if blen = MaxInt then blen := CurTrack.TieValue;
                        //
                        if blen<0 then
                        begin
                            blen := blen*-1;
                            WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,c.Time, oldP, p, blen);
                        end else
                        begin
                            WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,(c.Time - blen), oldP, p, blen);
                        end;
                    end else begin
                        WritePicthBend(c.Time, p);
                    end;
                    oldP := p;
                    blen := c.OptionValue ;
                    c.Free ; //ノート情報をベンドに変えたので、削除
                end;
                //last Note
                if griss then
                begin
                    c := TieStack.Items[TieStack.Count-2];
                    sa := c.NoteNo - wc.NoteNo ;
                    p := Trunc(sa * (8192/br));
                    if p<>0 then
                    begin
                        //Wave書き込み準備
                        if blen = MaxInt then blen := CurTrack.TieValue;
                        //
                        //WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,(wc.Time - len), p, 0, len);
                        if blen<0 then
                        begin
                            blen := blen*-1;
                            WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,wc.Time, p, 0, blen);
                        end else
                        begin
                            WriteCCNoteOnTimeDirect(CC_NO_BEND_FULL,(wc.Time - blen), p, 0, blen);
                        end;
                    end;
                end else
                begin
                    WritePicthBend(wc.Time, 0); //最後ベンドを0に戻す
                end;
                len := wc.Time - fromTime + wc.Len ;
                wc.Time := fromTime;
                wc.Len := len;
                CurSmfTrack.Add(wc);
            end;

        begin
            TieStack.Add(c); //今回の音もスタックに積んでしまう。
            wc := TieStack.Items[0]; //基本となるノート
            //todo: スラーの処理
            case CurTrack.TieMode of
            TIE_GATE: subGate;
            TIE_BEND: subBend(False);
            TIE_PORT: subBend(True);
            TIE_ALP:  subAlp;
            end;
            TieStack.Clear ;
        end;

        procedure checkTieOrNot;
        begin
            //タイかどうか確認する
            skipSpace(sp.ptr);
            if sp.ptr^ = '&' then
            begin
                Inc(sp.ptr);
                if sp.ptr^ = '&' then begin
                    {c.OptionValue := CurTrack.TieValue;
                    while sp.ptr^ = '&' do
                    begin
                        Inc(sp.ptr);
                        Inc(c.OptionValue,CurTrack.TieValue);
                    end;}//&&で、値を２倍の処理
                    //&&で、lの値を採用する
                    Inc(sp.ptr);
                    case CurTrack.TieMode of
                    TIE_BEND,TIE_PORT: c.OptionValue := c.Len;
                    TIE_GATE: c.OptionValue := 200;
                    else
                        c.OptionValue := CurTrack.TieValue * 2;
                    end;
                    if CurTrack.TieValue < 0 then c.OptionValue := -1 * c.OptionValue;
                end else
                if sp.ptr^ in ARG_CHAR then
                begin
                    c.OptionValue := GetIntValue(sp)
                end else
                    c.OptionValue := MaxInt;
                //タイである
                TieStack.Add(c);
            end else
            begin
                //タイではない。普通の書き込み
                if TieStack.Count > 0 then
                begin//前の音がタイのとき
                    subTie;
                end else
                begin//前の音はタイではないとき
                    if c.Len > 1 then Dec(c.Len);
                    CurSmfTrack.Add(c);
                end;
            end;
        end;

    begin
        c := TSmfNoteOn.Create ;
        c.Time := CurTrack.TimePtr + t;//タイミングを忘れずに
        c.Event := EVENT_NOTE_ON or CurTrack.Channel ;
        c.NoteNo := Max(0, Min(nn,127));
        c.Velocity := Max(0, Min(v,127));
        c.Len := q;
        c.PackedNoteOff := True;
        CurSmfTrack.LastNodeNo := c.NoteNo;

        //---実際の書き込み処理。和音orタイならスタックへ書き込み

        //音長０の和音か？
        if l=0 then
        begin
            WaonStack.Add(c);//スタックへ
        end else
        begin
            //和音最後の音符なら、スタックから和音を下ろす
            if WaonStack.Count = 0 then
            begin
                if c.Len <= 0 then
                begin
                    c.Free;
                    Exit; //音長が０以下なら、書き込まない
                end else
                    checkTieOrNot;
            end else
            begin
                // 和音スタックに音符が置かれている場合
                for i:=0 to WaonStack.Count -1 do
                begin
                    wc := WaonStack.Items[i];
                    if wc.Len = 0 then wc.Len := c.Len ;
                    CurSmfTrack.Add(wc); //音の長さが分かったので、それをセットして、ＳＭＦに書き込み
                end;
                //和音スタックを書き込んだので、次は、自身を書き込む
                CurSmfTrack.Add(c);// 
                WaonStack.Clear ;
            end;
        end;
    end;

    procedure SetWaonIniValue;
    var i: Integer;
    begin
        if RecWaon.Option <> nil then
        begin
            for i:=0 to RecWaon.Option.Count -1 do //和音時の初期値をセット
            begin
                case i of
                    0: if RecWaon.Option.Items[0]<>nil then l := RecWaon.Option.IntItems[0];
                    1: if RecWaon.Option.Items[1]<>nil then q := RecWaon.Option.IntItems[1];
                    2: if RecWaon.Option.Items[2]<>nil then v := RecWaon.Option.IntItems[2];
                    3: if RecWaon.Option.Items[3]<>nil then t := RecWaon.Option.IntItems[3];
                    4: if RecWaon.Option.Items[4]<>nil then o := RecWaon.Option.IntItems[4];
                end;
            end;
        end;
    end;

begin
    //todo: NoteOn
    Result := nil;
    sp.cmd := NoteName; //コマンド名をアサイン//エラー表示用

    //デバッグ用。MetaTextへ、現在の実行行を埋め込む
    if MmlOption.MetaLog then
    begin
        DebugMeta(SourceFileName(sp.fileNo)+'('+IntToStr(sp.lineNo)+')');
    end;


    //和音コマンド('...')中かどうかチェック... (.onCycle系で誤差が出るのでこの位置でポインタを変更)
    if RecWaon.Enable then
    begin
        CurTrack.TimePtr := RecWaon.Time ; //タイムポインタを戻す
    end;

    //GetTrackDefaultValue(l,q,v,t,o,stepm);
    with CurTrack do //カレントトラックのデフォルト値を得る
    begin
        l := Length.GetValue ;
        q := Qgate.ArrayNote[0].Value ;
        v := Velocity.GetValue ;
        t := Timing.GetValue ;
        o := Octave.GetValue ;
        stepm := Stepmode;
        qstep := QGate.ArrayNote[0].StepMode ;
    end;

    //和音コマンド('...')ならば、和音の初期値を得る
    if RecWaon.Enable then
    begin
        SetWaonIniValue;
    end;

    // ノートナンバーの計算
    nn := getNoteNo(sp, NoteName, True);

    // ノートの引数を得る
    getNoteArg;

    //Stretchコマンドで利用する
    if StretchRate <> 1 then
    begin
        l := Trunc(l * StretchRate);
        q := Trunc(q * StretchRate);
    end;

    //最終的なノートナンバーを算出
    if NoteName <> 'n' then
    begin
        nn := (o + SongInfo.OctaveRangeShift)* 12 + nn;
    end;
    nn := Max(0,min(127, nn));//最大値と最小値にあわせる
    {if CurTrack.Mute then
    begin
        Result := TMInt.Create; TMInt(Result).value := nn; //発音したノートナンバーを返却値とする場合
    end;}

    //トラックにデータを書き込む
    if CurTrack.Mute = False then WriteTrack;

    //ノート毎の、コントロールチェンジのチェックをする
    checkNoteOnCC(l, CurTrack.Channel); //実際の音符の長さが分からないと、.onNoteWaveExが駆動できないから、この位置に置く

    //タイムポインタを進める
    Inc(CurTrack.TimePtr, l);
end;


function TMmlBase.GetNoteLength(var sp: TSrcPos;
  stepmode: Boolean; def: Integer): Integer;
begin
  Result := TokenBase.GetNoteLength(sp, stepmode, def); 
end;
(*
function TMmlBase.GetNoteLength(var sp: TSrcPos;
  stepmode: Boolean; def: Integer): Integer;
var
    vi: Integer;

    function getOne: Integer;
    var
        mv: TMVarCustom;
        v: Extended;
        stepm: Boolean;

        procedure huten;
        var el,divLen:Extended ;
        begin
            //付点の処理
            el := 1;
            divLen := 0.5;
            while sp.ptr^ = '.' do
            begin
                Inc(sp.ptr);
                el := el + divLen;
                divLen := divLen / 2;
            end;
            v := v*el;
        end;

    begin
        //値の取得
        skipSpace(sp.ptr);
        if not (sp.ptr^ in ['$','%','0'..'9','(']) then //省略されたときは、デフォルトを返す
        begin
            v := def; huten; Result := Trunc(v);
            Exit;
        end;

        v := 0;
        try
            mv := getArg(sp);
        except
            raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'音長の指定。',sp));
        end;
        try
            if mv = nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
            if mv.ClassType = TMInt then
            begin
                //StepModeの判別
                if TMInt(mv).Flag = '%' then stepm := not stepmode else stepm := stepmode;
                if stepm then
                begin
                    v := TMInt(mv).value
                end else begin
                    v := TMInt(mv).value ;
                    v := NtoStep(Trunc(v));
                end;
            end else
            begin
                //
                if stepmode then
                    v := mv.IntValue
                else
                    v := NtoStep(mv.IntValue);
            end;
        finally
            mv.Free ;
        end;
        huten;
        Result := Trunc(v);
    end;

begin
    vi := getOne;
    //タイの処理・・・
    while True do
    begin
        //タイがあるか？
        skipSpaceReturn(sp.ptr, sp.lineNo);
        //skipSpace(sp.ptr);
        if sp.ptr^ in ['^','+'] then
        begin
            Inc(sp.ptr);
            vi := vi + getOne;
        end else
        if sp.ptr^ = '-' then
        begin
            Inc(sp.ptr);
            vi := vi - getOne;
        end else
            Break;
    end;

    Result := vi;
end;
*)

function TMmlBase.SetNoteInfo(var sp: TSrcPos; var ni: TNoteInfos;
  pname: Char; IncValue: Integer): TMInt;
var
    v: TMVarCustom;
    idx,vi: Integer;
    Flag: Char;

    procedure setOption;
    var
        token: string;
        mv: TMVarCustom;
    begin
        Inc(sp.ptr);// skip '.'
        token := GetTokenChars([' ','=','('], sp.ptr); // .onNote のようなトークンを得る
        if token='' then raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'"."の後ろにはオプション名が必要です。',sp));
        Dec(sp.ptr); //読みすぎなので、１文字戻す
        //ノート情報オプションにより処理を分ける
        if (token=OPTION_ON_NOTE)or(token=OPTION_ON_NOTE2) then
        begin
            mv := getArgs(sp);
            if (mv=nil)or(mv.ClassType <> TMArray) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[token]);
            ni.SetReserveValue(idx, noteOnNote, mv as TMArray, CurTrack.TimePtr);
        end else
        if (token=OPTION_ON_TIME)or(token=OPTION_ON_TIME2) then
        begin
            mv := getArgs(sp);
            if (mv=nil)or(mv.ClassType <> TMArray) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[token]);
            ni.SetReserveValue(idx, noteOnTime, mv as TMArray, CurTrack.TimePtr);
        end else
        if (token=OPTION_ON_CYCLE)or(token=OPTION_ON_CYCLE2) then
        begin
            mv := getArgs(sp);
            if (mv=nil)or(mv.ClassType <> TMArray) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[token]);
            ni.SetReserveValue(idx, noteOnCycle, mv as TMArray, CurTrack.TimePtr);
        end else
        if (token=OPTION_DELAY) then
        begin
            sp.cmd := OPTION_DELAY;
            ni.CreateArrayNote(idx);
            ni.ArrayNote[idx].DelayTime := GetIntValueAndCalc(sp);
        end else
        if (token=OPTION_REPEAT) then
        begin
            sp.cmd := OPTION_REPEAT;
            ni.CreateArrayNote(idx);
            ni.ArrayNote[idx].RepeatMode := GetIntValueAndCalc(sp);
        end else
        if (token=OPTION_RANDOM) then
        begin
            sp.cmd := OPTION_RANDOM;
            ni.CreateArrayNote(idx);
            ni.ArrayNote[idx].RandomValue := GetIntValueAndCalc(sp);
        end else
        if (token=OPTION_MAX) then
        begin
            sp.cmd := OPTION_MAX;
            case pname of
            'q':
            begin
                SongInfo.qMax := GetIntValueAndCalc(sp);
                CurTrack.Qgate.SetValue(0,SongInfo.qMax);
            end;
            'v':
            begin
                SongInfo.vMax := GetIntValueAndCalc(sp);
                CurTrack.Velocity.SetValue(0,SongInfo.vMax);
            end;
            end;
        end else
        if (token=OPTION_RANGE) then
        begin
            mv := getArgs(sp);
            if (mv=nil)or(mv.ClassType <> TMArray) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[token]);
            if TMArray(mv).Count <> 2 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"(low,high)"形式で指定してください。',sp),[token]);
            if ni.Range <> nil then ni.Range.Free ;
            ni.Range := TMRange.Create(TMArray(mv).IntItems[0],TMArray(mv).IntItems[1]);
        end else
            raise  EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[token]);

        if Flag='%' then
            ni.ArrayNote[idx].StepMode := True  //step指定
        else
            ni.ArrayNote[idx].StepMode := False;
    end;

    function subSoutai: Boolean;
    var
        p,v: Integer;
    begin
        Result := False;
        //相対指定かどうかチェック
        if not(sp.ptr^ in ['+','-']) then Exit;

        p := 0;
        while True do
        begin
            if sp.ptr^ = '+' then Inc(p) else
            if sp.ptr^ = '-' then Dec(p) else Break;
            Inc(sp.ptr);
        end;

        if not(sp.ptr^ in ['$','(','!','0'..'9']) then
        begin
            ni.IncValue(idx, p * IncValue); //相対的に増やす
        end else
        begin //数値指定がある
            v := GetIntValue(sp);
            ni.IncValue(idx, p * v);
        end;
        if Flag='%' then ni.ArrayNote[idx].StepMode := True;

        Result := True;
        Exit;
    end;

begin
    Result := nil ;

    sp.cmd := pname;
    idx := -1;
    if sp.ptr^ = '_' then //独立した v__3=40 のような多重階層パラメーター
    begin
        Inc(sp.ptr);
        idx := 0;
        if sp.ptr^ = '_' then
        begin
            Inc(sp.ptr);
            v := getArg(sp); if (v=nil)or(v.ClassType <> TMInt) then raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
            idx := v.IntValue ;
            if (idx>=MAX_NOTE_INFO-1) then raise EMml.CreateFmt(ErrMsg(MML_ERR_RANGE_OVER+'(0~%d)',sp),[sp.cmd,MAX_NOTE_INFO-2{arrayNoteInfo の 0 が指定なしを表すので}]);
        end;
    end;
    Inc(idx);// ノーマルが、idx=0 なので、1 足す

    //ステップ指定か確認
    if sp.ptr^ = '%' then //ステップ指定である
    begin
        Flag := sp.ptr^;
        Inc(sp.ptr);
    end else begin
        Flag := #0;
    end;

    if sp.ptr^ = '.' then
    begin
        setOption;
        Result := nil; //option指定時は現在の値が不定だから
        Exit;
    end;

    //---値を設定-----------------------------------------------------------

    if pname = 'l' then //"l"のとき。
    begin
        if Flag = '%' then //ステップ指定である
        begin
            CurTrack.Stepmode := not SongInfo.Stepmode;
        end else
        begin
            CurTrack.Stepmode := SongInfo.Stepmode;
        end;
        vi := GetNoteLength(sp, CurTrack.Stepmode, -1);
        ni.SetValue(idx, vi) ;
        v := TMInt.Create ;
        TMInt(v).value := vi;
    end else
    begin //'l"以外のとき。

        if sp.ptr^='=' then begin
            Inc(sp.ptr);
        end else
        if subSoutai then
        begin
            Exit;
        end;
        v := getArg(sp);
        if (v=nil)or(v.ClassType <> TMInt) then raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
        ni.SetValue(idx, v.IntValue) ;
        Result := v as TMInt;
    end;
    if Flag='%' then
        ni.ArrayNote[idx].StepMode := True  //step指定
    else
        ni.ArrayNote[idx].StepMode := False;
end;

function TMmlBase.GetIntValue(var sp: TSrcPos): Integer;
var
    mv: TMVarCustom;
begin
    //if sp.ptr^ = '=' then Inc(sp.ptr);
    mv := getArg(sp);
    if (mv=nil)or(mv.ClassType <> TMInt) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    Result := mv.IntValue ;
    mv.Free ;
end;

function TMmlBase.scriptChannel(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    p: PChar;
begin
    skipSpace(sp.ptr);
    p := sp.ptr ;
    if (p^='(')or((p^='=')and(not((p+1)^in['!','='])))or(p^ in ['0'..'9']) then
    begin //代入
        v :=GetIntValue(sp);
        if (v<=0)or(v>16) then raise EMml.CreateFmt(ErrMsg(MML_ERR_RANGE_OVER+'(1~16が範囲)',sp),['Channel']);
        CurTrack.Channel := v - 1;
    end;
    //カレントトラックのチャンネル番号を返す
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.Channel + 1;
end;

function TMmlBase.scriptTrack(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    p: PChar;
begin
    skipSpace(sp.ptr);
    p := sp.ptr ;
    if (p^='(')or((p^='=')and(not((p+1)^in['!','='])))or(p^ in ['0'..'9']) then
    begin //代入
        v :=GetIntValue(sp);
        SetCurTrack(v);
    end;
    //カレントトラックの番号を返す
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.TrackNo ;
end;

function TMmlBase.scriptVoice(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    c: TSmfProgramChange;
    ary: TMArray;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ARG_CHAR then
        ary := getArgs(sp)
    else begin
        //@a,b,c のようなとき。小文字コマンドのように取得
        ary := TMArray.Create ;
        ary.Add( getArgAndCalc(sp) ); skipSpace(sp.ptr);
        if sp.ptr^ = ',' then
        begin
            Inc(sp.ptr);
            ary.Add( getArgAndCalc(sp) ); skipSpace(sp.ptr);
            if sp.ptr^ = ',' then
            begin
                Inc(sp.ptr);
                ary.Add( getArgAndCalc(sp) );
            end;
        end;
    end;

    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Voice']);
    if ary.Count = 0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Voice']);

    v := ary.IntItems[0] - 1 + SongInfo.VoiceNoShift;
    if (v<0)or(v>127) then raise EMml.CreateFmt(ErrMsg(MML_ERR_RANGE_OVER+'(%d~%d)',sp),['Voice', (1+SongInfo.VoiceNoShift),(128+SongInfo.VoiceNoShift)]);

    CurTrack.Voice := ary.IntItems[0];//記憶用

    // SMFにイベント書き込み
    c := TSmfProgramChange.Create ;
    c.Event := EVENT_PROGRAM_CHANGE or CurTrack.Channel ;
    c.Time := CurTrack.TimePtr - 1;//1step前
    c.value := v ;

    //msb, lsb の取得
    c.msb := -1;
    c.lsb := -1;

    if ary.Items[1]<>nil then
    begin
        c.msb := ary.IntItems[1];
    end;
    if ary.Items[2]<> nil then
    begin
        c.lsb := ary.IntItems[2];
    end;

    CurSmfTrack.Add(c); //SMF 書き込み

    //カレントトラックの音色番号を返す
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.Voice ;
end;

function TMmlBase.funcNoteN(var sp: TSrcPos): TMVarCustom;
begin
    Result := NoteOn(sp, 'n');
end;

function TMmlBase.funcNoteR(var sp: TSrcPos): TMVarCustom;
var
    len, d: Integer;
    stepm: Boolean;
    flag,sign: Char;

    procedure chkWaon;
    begin
        if RecWaon.Enable then
        begin
            CurTrack.TimePtr := RecWaon.Time ; //タイムポインタを戻す
            if RecWaon.Option <> nil then
            begin
                if RecWaon.Option.Count >= 1 then
                    len := RecWaon.Option.Items[0].IntValue ;
            end;
        end;
    end;

begin
    Result := nil;

    if sp.ptr^ = '*' then
    begin
        flag := sp.ptr^;
        Inc(sp.ptr);
    end else begin
        flag := #0;
    end;
    if sp.ptr^ in ['-','+'] then
    begin
        sign := sp.ptr^;
        Inc(sp.ptr); // 逆方向または、加算。
    end else
        sign := #0;

    if flag<>'*' then
    begin // イベントを起こす
        GetTrackDefaultValue(len,d,d,d,d,stepm);
        //和音コマンド('...')中かどうかチェック
        chkWaon;
        len := GetNoteLength(sp, stepm, len);
        checkNoteOnCC(len, CurTrack.Channel);
    end else
    begin
        len := CurTrack.Length.GetValue ;
        chkWaon;
        len := GetNoteLength(sp, CurTrack.Stepmode, len);
    end;
    if sign='-' then
    begin
        Dec( CurTrack.TimePtr, len );
    end else
    begin
        Inc( CurTrack.TimePtr, len );
    end;
end;

function TMmlBase.scriptCC(var sp: TSrcPos): TMVarCustom;
var
    cc: Integer; //CC番号
{    v: Integer;
    ccc: TSmfControlChange ;}
begin
    Result := nil;

    cc := GetIntValue(sp); //CC番号を得る
    skipSpace(sp.ptr);

    if sp.ptr^ = '.' then
    begin
        WriteCCOption(sp, cc); Exit;
    end;

    if (sp.ptr^ = ',') then Inc(sp.ptr);

    //ピッチベンド等の指定があれば、その番号を実行
    if cc=256 then
        scriptBendFull(sp)
    else if cc=257 then
        scriptBend(sp)
    else
        WriteCCComand(sp, cc);
    {
    if not(sp.ptr^ in [',','(','=','0'..'9','$']) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"y(no),(value)"の書式で指定してください。',sp),['y']);
    if (sp.ptr^ = ',') then Inc(sp.ptr);
    v := GetIntValue(sp); //値を得る

    //smfに書き込む
    ccc := TSmfControlChange.Create ;
    ccc.Time := CurTrack.TimePtr ;
    ccc.Event := EVENT_CONTROL_CHANGE or CurTrack.Channel ;
    ccc.No := cc;
    ccc.Value := v;
    CurSmfTrack.Add(ccc);
    }
end;

procedure TMmlBase.WriteCCWave(var ncc: TNoteCC; var track: TSmfTrack; noteLen, ch: Integer);
var
    Freq: Integer;
    TimePtr: Integer; //カレントトラックのタイムポインタ
    oldV: Integer;

    procedure writeTrack(time, v: Integer);
    var
        c: TSmfCustomNode ;
    begin
        //Random
        if ncc.RandomValue <> 0 then
        begin
            v := v + Random(ncc.RandomValue*2) - ncc.RandomValue; 
        end;
        
        if ncc.Range <> nil then //Rangeによる値補正
        begin
            v := Max(ncc.Range.low, Min(ncc.Range.high, v));
        end;
        if oldV = v then Exit;
        oldV := v;

        if ncc.No <= 127 then // CC (0~127)
        begin
            c := TSmfControlChange.Create ;
            c.Event := EVENT_CONTROL_CHANGE or ch ;
            TSmfControlChange(c).No := Byte(ncc.No) ;
            TSmfControlChange(c).Value := Min(127, Max(0,v));
        end else
        if ncc.No = 256 then // Bend FullRange(-8192~0~8191)
        begin
            c := TSmfPitchBend.Create ;
            c.Event := EVENT_PITCH_BEND or ch ;
            TSmfPitchBend(c).value := Min(8191, Max(-8192, v));
        end else
        if ncc.No = 257 then //easy Range BEND(0~63~127)
        begin
            c := TSmfPitchBend.Create ;
            c.Event := EVENT_PITCH_BEND or ch ;
            v := v * 128 - 8192;
            TSmfPitchBend(c).value := Min(8191, Max(-8192, v));
        end else
        begin
            Exit;
        end;
        c.Time := time;
        track.Add(c);
    end;

    procedure subTime;
    var
        len_add, total, cnt, i, j, low, high, len, takasa,v, n: Integer;
        a: Extended;
    begin
        i := 0;
        n := TimePtr;
        total := 0;
        while i < ncc.reserve.Count do
        begin
            low  := ncc.reserve.IntItems[i];
            high := ncc.reserve.IntItems[i+1];
            len  := ncc.reserve.IntItems[i+2];
            //
            takasa := high - low;
            if len<>0 then a := takasa / len else a := 0;
            //
            cnt := (len div Freq)-1;//1回分ゆとりをもたせる
            for j:=0 to cnt-2 do
            begin
                v := Trunc(a * j * Freq)+low;
                len_add := Freq * j;
                writeTrack(n + len_add-1, v);

                //Break判定
                Inc(total,Freq);
                if noteOnWave = ncc.noteOnType then begin
                    if total > noteLen then // noteLen を超えたとき、Break
                        Break;
                end;
            end;
            if noteOnWave = ncc.noteOnType then begin
                if total > noteLen then // noteLen を超えたとき、Break
                    Break;
            end;

            if cnt>0 then
            begin
                writeTrack(n + Freq*(cnt-1), high); //最後に帳尻合わせ
            end;
            Inc(i, 3);
            Inc(n, len);
        end;
        //最後の値を記憶しておく
        ncc.LastValue := oldV;
    end;

    procedure subCCWave;
    var
        cnt, waveType, low, high, len, times, takasa,v, n, break_cnt: Integer;

        procedure Sine;
        var i,flen: Integer;
        begin
            flen := (cnt div times)-1;

            for i:=0 to cnt-1 do
            begin
                if i > break_cnt then break;
                n := Trunc((len / cnt) * i);
                v := Trunc( takasa * sin( 3.14 * ((i mod flen)/flen)) ) + low;
                writeTrack(TimePtr+n, v);
            end;
        end;

        procedure SineUp;
        var i,flen: Integer;
        begin
            flen := (cnt div times)-1;

            for i:=0 to cnt-1 do
            begin
                if i > break_cnt then break;
                n := Trunc((len / cnt) * i);
                v := Trunc( takasa * sin( 3.14 * ((i mod flen)/flen)) );
                v := Trunc(v * (i/cnt));
                v := v + low;
                writeTrack(TimePtr+n, v);
            end;
        end;

        procedure SineDown;
        var i,flen: Integer;
        begin
            flen := (cnt div times)-1;

            for i:=0 to cnt-1 do
            begin
                if i > break_cnt then break;
                n := Trunc((len / cnt) * i);
                v := Trunc( takasa * sin( 3.14 * ((i mod flen)/flen)) );
                v := v - Trunc(v * (i/cnt));
                v := v + low;
                writeTrack(TimePtr+n, v);
            end;
        end;

    begin
        //(命令).Wave(type,low,high,len,times)//コントロールチェンジの連続値書き込み命令
        waveType := ncc.reserve.IntItems[0];
        low      := ncc.reserve.IntItems[1];
        high     := ncc.reserve.IntItems[2];
        len      := ncc.reserve.IntItems[3];
        times    := ncc.reserve.IntItems[4];


        cnt := len div Freq; //書き込み回数
        if cnt<=0 then Exit;

        takasa := high - low;

        break_cnt := cnt;
        if noteOnSine = ncc.noteOnType then
        begin
            if noteLen < len then
            begin
                break_cnt := noteLen div Freq;
                if break_cnt <=0 then Exit;
            end;
        end;

        case waveType of
        0:Sine;
        1:SineUp;
        2:SineDown;
        end;

        //最後の値を記憶しておく
        ncc.LastValue := oldV;
    end;

    procedure subNote;
    var v: Integer;
    begin
        if ncc.FIndex >= ncc.reserve.Count then
        begin //範囲超過
            if ncc.RepeatMode = BOOL_FALSE then
            begin
                ncc.noteOnType := noteNormal; Exit;
            end else begin
                ncc.FIndex := 0;
            end;
        end;
        v := ncc.reserve.IntItems[ncc.FIndex];
        if ncc.LastValue <> v then writeTrack(TimePtr-1, v);
        //最後の値を記憶しておく
        ncc.LastValue := v;
        Inc(ncc.FIndex);
    end;

    procedure subCycle;
    var v, len, idx: Integer;
    begin
        if ncc.reserve.Count = 0 then Exit;
        len := ncc.reserve.IntItems[0];
        if len=0 then Exit;
        idx := (TimePtr - ncc.Time) div len;
        v := ncc.reserve.IntItems[1 + (idx mod (ncc.reserve.Count-1))];
        writeTrack(timePtr-1, v);
        //最後の値を記憶しておく
        ncc.LastValue := oldV;
    end;

    procedure subWaveEx;
    var
        n, v, len, alen, i, j, cnt, low, high, takasa, realLen: Integer;
        wlen,a: Extended;
    begin
        //まず、WaveTableに書き込まれた長さを合計し、長さを計算する
        alen := 0;
        for i:=0 to (ncc.reserve.Count div 3)-1 do
        begin
            if (i*3+2) >= ncc.reserve.Count then Break;
            alen := alen + ncc.reserve.IntItems[i*3+2];
        end;
        if alen<=0 then alen := 1;

        //割合を得て書き込み
        n := TimePtr;
        for i:=0 to (ncc.reserve.Count div 3)-1 do
        begin
            if (i*3+2) >= ncc.reserve.Count then Break;
            low  := ncc.reserve.IntItems[i*3+0];
            high := ncc.reserve.IntItems[i*3+1];
            len  := ncc.reserve.IntItems[i*3+2];
            wlen := len / alen; //長さの割合
            realLen := Trunc(wlen * noteLen);
            takasa := high -low;
            if realLen<>0 then
                a    := takasa / realLen
            else
                a    := 0;
            cnt  := (realLen div Freq)-1;//1回分のゆとり
            for j:=0 to cnt-2 do
            begin
                v := Trunc((j*Freq) * a)+low; //実際の値
                writeTrack((n + j*Freq),v);
            end;
            if cnt>0 then
            begin
                writeTrack(n + Freq*(cnt-1), high); //最後に帳尻合わせ
            end;
            Inc(n, realLen);
        end;
        //最後の値を記憶しておく
        ncc.LastValue := oldV;
    end;

    procedure subWaveR;
    var
        lastPtr, v, len, i, j, cnt, low, high, takasa, total: Integer;
        a: Extended;
    begin
        if ncc.reserve.Count <= 0 then Exit;
        lastPtr := CurTrack.TimePtr + noteLen; //書き込みタイム最終値

        total := 0;
        i := 0;
        while timePtr < lastPtr do
        begin
            if (i+3) > ncc.reserve.Count then i := 0;
            //値の取得
            low  := ncc.reserve.IntItems[i+0];
            high := ncc.reserve.IntItems[i+1];
            len  := ncc.reserve.IntItems[i+2];
            if len <= 0 then Break;
            Inc(i,3);

            if Freq >= len then begin //もし、len が 短いときは、highを書いてループを続ける
                writeTrack(timePtr, high);
                Inc(timePtr, Freq);
                Continue;
            end;

            //傾きを得る
            takasa := high - low;
            a := takasa / (len-1); //※ by 4neria (2002/10/22)

            //書き込み回数を得る
            cnt := (len div Freq);//-1; //※ by 4neria (2002/10/22)
            for j := 0 to cnt-1 do
            begin
                if timePtr >= lastPtr then Exit; //最後を越えたら抜ける
                v := Trunc((j*Freq)*a)+low;
                writeTrack(timePtr, v);
                Inc(timePtr, Freq);
                Inc(total, Freq);
                if total > noteLen then Break;
            end;
        end;
        //最後の値を記憶しておく
        ncc.LastValue := oldV;
    end;


begin
    Freq := SongInfo.CCFreq ;
    TimePtr := CurTrack.TimePtr + ncc.DelayTime;
    oldV := MaxInt;

    if CurTrack.CCNoMute[ncc.No] then Exit;

    if (ncc.DelayTime > 0) then
    begin
        if (ncc.No = CC_NO_BEND) then
        begin
            writeTrack(CurTrack.TimePtr, 64);
        end;
        if (ncc.No = CC_NO_BEND_FULL) then
        begin
            writeTrack(CurTrack.TimePtr, 0);
        end;
    end;
    if CurTrack.CCMute then Exit;

    case ncc.noteOnType of
    noteOnTime:   subTime;
    noteCCSine:   subCCWave;
    noteOnSine:   subCCWave;
    noteOnNote:   subNote;
    noteOnCycle:  subCycle;
    noteOnWave:   subTime;
    noteOnWaveEx: subWaveEx;
    noteOnWaveR:  subWaveR;
    noteOff:;//何もしない
    end;

end;

function TMmlBase.scriptBend(var sp: TSrcPos): TMVarCustom;
var
    v,vv: Integer;
    flg: Char;
begin
    Result := nil;

    if sp.ptr^='%' then //Full Range Bend
    begin
        Inc(sp.ptr);
        ScriptBendFull(sp); Exit;
    end;

    skipSpace(sp.ptr);

    if sp.ptr^ = '.' then
    begin
        WriteCCOption(sp, CC_NO_BEND); Exit;
    end;

    if sp.ptr^ in ['+','-'] then
    begin
        flg := sp.ptr^;
        Inc(sp.ptr);
    end else
        flg := #0;

    vv := GetIntValueAndCalc(sp); //値を得る
    case flg of
    '+':
        begin
            vv := vv + SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND).LastValue ;
        end;
    '-':
        begin
            vv := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND).LastValue - vv;
        end;
    end;

    vv := Max(0, Min(128, vv));
    v := vv * 128 - 8192;

    WritePicthBend(CurTrack.TimePtr - SongInfo.ControllerShift, v);
end;

procedure TMmlBase.WriteCCOption(var sp: TSrcPos; cc: Integer);
var
  nc: TNoteCC;
  v: Integer;

    procedure subOnNote;
    var mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnNote ;
        nc.reserve.Assign(mv);
        nc.FIndex := 0;
        mv.Free ;
    end;

    procedure subOnTime;
    var
        mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnTime ;
        //今すぐ書き込み
        nc.Time := CurTrack.TimePtr ;
        nc.reserve.Assign(mv);
        mv.Free ;

        if (CurTrack.CCMute = False)and(CurTrack.CCNoMute[nc.No] = False) then
        begin
          //トラックの無駄に書き込まれるコントロールチェンジをトリムする(ver.2.32以降)
          DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, nc.No, CurTrack.TimePtr, False);
          WriteCCWave(nc, CurSmfTrack, 0, CurTrack.Channel);
        end;
        nc.noteOnType := noteOff;
    end;

    procedure subCCSine;
    var
        mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteCCSine ;
        //今すぐ書き込み
        nc.Time := CurTrack.TimePtr ;
        nc.reserve.Assign(mv);
        mv.Free ;

        if (CurTrack.CCMute = False)and(CurTrack.CCNoMute[nc.No] = False) then
        begin
          //トラックの無駄に書き込まれるコントロールチェンジをトリムする(ver.2.32以降)
          DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, nc.No, CurTrack.TimePtr, False);

          WriteCCWave(nc, CurSmfTrack, 0, CurTrack.Channel);
        end;
        nc.noteOnType := noteOff;
    end;

    procedure subOnSine;
    var
        mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnSine ;
        nc.Time := CurTrack.TimePtr ;
        nc.reserve.Assign(mv);
        mv.Free ;
    end;

	procedure subOnCycle;
  var mv: TMArray;
  begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnCycle ;
        nc.reserve.Assign(mv);
        nc.Time := CurTrack.TimePtr ;
        nc.FIndex := 0;
        mv.Free ;
	end;

	  procedure subOnWave;
    var mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnWave ;
        nc.reserve.Assign(mv);
        nc.Time := CurTrack.TimePtr ;
        nc.FIndex := 0;
        mv.Free ;
	  end;

	  procedure subOnWaveEx;
    var mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnWaveEx ;
        nc.reserve.Assign(mv);
        nc.Time := CurTrack.TimePtr ;
        nc.FIndex := 0;
        mv.Free ;
	  end;

	  procedure subOnWaveR;
    var mv: TMArray;
    begin
        mv := getArgsWithType(sp,'a');
        if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
        nc.noteOnType := noteOnWaveR ;
        nc.reserve.Assign(mv);
        nc.Time := CurTrack.TimePtr ;
        nc.FIndex := 0;
        mv.Free ;
	end;

	procedure subDelay;
	begin
        v := GetIntValue(sp);
        nc.DelayTime := v;
	end;

	procedure subRepeat;
	begin
        v := GetIntValue(sp);
        nc.RepeatMode := v;
        nc.FIndex := 0;
	end;

	procedure subRandom;
	begin
        v := GetIntValue(sp);
        nc.RandomValue := v;
	end;

	procedure subRange;
    var mv: TMArray;
	begin
        mv := getArgs(sp);
        if (mv=nil)or(mv.ClassType <> TMArray)or(TMArray(mv).Count <> 2) then EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"(low,high)"で指定してください。',sp),[sp.cmd]);
        nc.Range := TMRange.Create(TMArray(mv).IntItems[0],TMArray(mv).IntItems[1]);
	end;

	procedure subFreq;
	begin//CC書き込み頻度の設定
        v := GetIntValueAndCalc(sp);
        SongInfo.CCFreq := v;
	end;

var
    s: string;
begin
    nc := GetCurCCNote(cc); // 現在のトラックのチャンネルよりコントロールチェンジを得る
    nc.No := cc;
    Inc(sp.ptr);// skip "."
    //オプション名を得る
    s := GetTokenChars(['=','(',' '], sp.ptr);
    if s='' then raise EMml.Create(ErrMsg(MML_ERR_SYNTAX+'"."の後ろにはオプション名が必要です。',sp));
    sp.cmd := s;
    Dec(sp.ptr); //読みすぎなので、１文字戻す
    //ノート情報オプションにより処理を分ける
    if (s=OPTION_ON_NOTE)or(s=OPTION_ON_NOTE2)      then subOnNote   else
    if (s=OPTION_ON_TIME)or(s=OPTION_ON_TIME2)      then subOnTime   else
    if (s=OPTION_CC_SINE)                           then subCCSine   else
    if (s=OPTION_ON_SINE)                           then subOnSine   else
    if (s=OPTION_ON_CYCLE)or(s=OPTION_ON_CYCLE)     then subOnCycle  else
    if (s=OPTION_ON_WAVE)or(s=OPTION_ON_WAVE2)      then subOnWave   else
    if (s=OPTION_ON_WAVE_EX)or(s=OPTION_ON_WAVE_EX2)then subOnWaveEx else
    if (s=OPTION_ON_WAVE_R)or(s=OPTION_ON_WAVE_R2)  then subOnWaveR  else
    if (s=OPTION_DELAY)                             then subDelay    else
    if (s=OPTION_REPEAT)                            then subRepeat   else
    if (s=OPTION_RANDOM)                            then subRandom   else
    if (s=OPTION_RANGE)                             then subRange    else
    if (s=OPTION_FREQUENCY)                         then subFreq     else
    raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[s]);
end;


function TMmlBase.scriptBendFull(var sp: TSrcPos): TMVarCustom;
var
    vv: Integer;
    flg:Char;
begin
    Result := nil;
{逆は使われないだろうから、この処理は、スキップ
    if sp.ptr^='%' then //Full Range Bend
    begin
        Inc(sp.ptr);
        ScriptBend(sp); Exit;
    end;
}
    skipSpace(sp.ptr);

    if sp.ptr^ = '.' then
    begin
        WriteCCOption(sp, CC_NO_BEND_FULL); Exit;
    end;
    if sp.ptr^ = ',' then
    begin
        ShowHint(MML_WARN_VAR_SYNTAX+'値指定で","は使えません。',sp);
        Inc(sp.ptr);
    end;

    if sp.ptr^ in ['+','-'] then
    begin
        flg := sp.ptr^;
        Inc(sp.ptr);
    end else
        flg := #0;

    vv := GetIntValueAndCalc(sp); //値を得る
    case flg of
    '+':
        begin
            vv := vv + SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND_FULL).LastValue ;
        end;
    '-':
        begin
            vv := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND_FULL).LastValue - vv;
        end;
    end;

    WritePicthBend(CurTrack.TimePtr - SongInfo.ControllerShift, vv);
end;

procedure TMmlBase.checkNoteOnCC(noteLen, ch: Integer);
var
    cc: TCCList;
    nc: TNoteCC;
    i: Integer;

begin
    cc := GetCurCCList;
    for i:=0 to cc.Count -1 do
    begin
        nc := cc.Items[i];
        if nc=nil then Continue;
        WriteCCWave(nc, CurSmfTrack, noteLen, ch);
    end;
end;

function TMmlBase.funcDirectSmf(var sp: TSrcPos): TMVarCustom;
var
    v: TMArray;
    i: Integer;
    b: TArrayOfByte;
begin
    //直接、SMFイベントを書き込む
    Result := nil;
    v := getArgs(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['DirectSMF']);
    if v.Count = 0 then Exit;

    SetLength(b, v.Count);
    for i:=0 to v.Count -1 do
    begin
        b[i] := Byte(v.IntItems[i]);
    end;

    WriteDirectSmf(b);
end;

procedure TMmlBase.WriteDirectSmf(byteArray: TArrayOfByte);
var
    c: TSmfDirect ;
begin
    c := TSmfDirect.Create ;
    c.Time := CurTrack.TimePtr ;
    c.Event := byteArray[0];
    c.byteArray := byteArray;
    CurSmfTrack.Add(c); 
end;

function TMmlBase.funcNoteOff(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    b: TArrayOfByte ;
begin
    Result := nil;
    ary := getArgs(sp);
    if (ary=nil)or(ary.Count <> 2) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['NoteOff']);
    SetLength(b, 3);
    b[0] := EVENT_NOTE_OFF or CurTrack.Channel ;
    b[1] := Byte(ary.IntItems[0]);
    b[2] := Byte(ary.IntItems[1]);
    WriteDirectSmf(b);
end;

function TMmlBase.funcNoteOn(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    b: TArrayOfByte ;
begin
    Result := nil;
    ary := getArgs(sp);
    if (ary=nil)or(ary.Count <> 2) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['NoteOff']);
    SetLength(b, 3);
    b[0] := EVENT_NOTE_ON or CurTrack.Channel ;
    b[1] := Byte(ary.IntItems[0]);
    b[2] := Byte(ary.IntItems[1]);
    WriteDirectSmf(b);
end;

function TMmlBase.funcOctaveDown(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    if SongInfo.X68Mode then
    begin
        CurTrack.Octave.SetValue(0, CurTrack.Octave.ArrayNote[0].ROValue+1);
    end else begin
        CurTrack.Octave.SetValue(0, CurTrack.Octave.ArrayNote[0].ROValue-1);
    end;
end;

function TMmlBase.funcOctaveUp(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    if SongInfo.X68Mode then
    begin
        CurTrack.Octave.SetValue(0, CurTrack.Octave.ArrayNote[0].ROValue-1);
    end else begin
        CurTrack.Octave.SetValue(0, CurTrack.Octave.ArrayNote[0].ROValue+1);
    end;
end;

function TMmlBase.funcOctaveUpOnece(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    Inc(FlagOctaveUpOnce);
end;

function TMmlBase.funcWaon(var sp: TSrcPos): TMVarCustom;
var
    s:string;
    sp2: TSrcPos;
    len: Integer;
    m,v: TMInt;
begin
    Result := nil;
    RecWaon.Enable := True;

    //和音の範囲を得る
    s := GetTokenChars([''''], sp.ptr);
    //和音の範囲に改行があればエラー
    if SongInfo.AllowMuliLine = False then
    begin
      if Pos(#13#10, s) > 0 then
      begin
        raise Exception.Create('和音内に改行があります。');
      end;
    end;
    //オプションがあれば、オプションを得る
    len := GetNoteLength(sp, CurTrack.Stepmode, CurTrack.Length.GetValue);

    m := TMInt.Create ;
    m.value := len;
    if RecWaon.Option = nil then RecWaon.Option := TMArray.Create else RecWaon.Option.Clear ;
    RecWaon.Option.Add(m); //オプションに Length をセット

    skipSpace(sp.ptr);
    if sp.ptr^ = ',' then //","がある＝ゲートの指定がある
    begin
        Inc(sp.ptr); skipSpace(sp.ptr);
        if sp.ptr^ in ['+','-'] then
        begin
            v := getArg(sp) as TMInt;
            v.value := v.value + CurTrack.Qgate.GetValue ;
        end else
        begin
            v := getArg(sp) as TMInt;
        end;
        RecWaon.Option.Add( v ); //ゲートをセット
        skipSpace(sp.ptr);
        if sp.ptr^ = ',' then
        begin
            Inc(sp.ptr); skipSpace(sp.ptr);
            if sp.ptr^ in ['+','-'] then
            begin
                v := getArg(sp) as TMInt;
                v.value := v.value + CurTrack.Velocity.GetValue ;
            end else
            begin
                v := getArg(sp) as TMInt;
            end;
            RecWaon.Option.Add( v ); //ベロシティをセット
            skipSpace(sp.ptr);
            if sp.ptr^ = ',' then
            begin
                Inc(sp.ptr);
                RecWaon.Option.Add( getArg(sp) ); //タイミングをセット
                skipSpace(sp.ptr);
                if sp.ptr^ = ',' then
                begin
                    Inc(sp.ptr); skipSpace(sp.ptr);
                    if sp.ptr^ in ['+','-'] then
                    begin
                        v := getArg(sp) as TMInt;
                        v.value := v.value + CurTrack.Octave.GetValue ;
                    end else
                    begin
                        v := getArg(sp) as TMInt;
                    end;
                    RecWaon.Option.Add( v ); //オクターブをセット
                end;
            end;
        end;
    end;

    //和音開始時間をセット
    RecWaon.Time := CurTrack.TimePtr ;

    //変数内コンパイル準備
    sp2 := TSrcPos.Create ;
    try
        sp2.Assign(sp);
        sp2.SetTempSource(s); //和音の範囲をセット
        Compile(sp2); // 和音の範囲をコンパイル
    finally
        sp2.Free;
    end;
    RecWaon.Enable := False;
    if RecWaon.Option <> nil then RecWaon.Option.Free ;
    RecWaon.Option := nil;
end;

function TMmlBase.funcDiv(var sp: TSrcPos): TMVarCustom;
var
    temp,cnt,len, rLen, last: Integer;
    s: string;
    m: TMVarCustom;
    sp2: TSrcPos;
    p: PChar;
begin
    Result := nil;
    // Div{ (mml) }(n) の、mml 部分を得る
    skipSpace(sp.ptr);
    if sp.ptr^ <> '{' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"Div{ .. }(len)"で指定してください。',sp),['Div']);
    m := getArg(sp);
    if m.ClassType <> TMStr then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"Div{ .. }(len)"で指定してください。',sp),['Div']);
    s := m.StrValue ;
    m.Free ;
    // 音長を得る
    len := GetNoteLength(sp, CurTrack.Stepmode, CurTrack.Length.GetValue);
    if s='' then Exit;

    //sの中に音符がいくつあるのか数える
    cnt := 0;
    p := PChar(s);
    while p^ <> #0 do
    begin
        if p^ in ['c','d','e','f','g','a','b','n','r'] then
        begin
            Inc(cnt);
            Inc(p);
        end else
        if p^ ='''' then begin
            Inc(cnt);
            Inc(p);
            while p^ <> '''' do Inc(p); Inc(p);
        end else
            Inc(p);
    end;
    //音符１つのステップ数を得る
    if cnt=0 then rLen := len else rLen := len div cnt;
    last := CurTrack.TimePtr + len;
    temp := CurTrack.Length.GetValue ;

    //DivのMML部分をコンパイル
    CurTrack.Length.SetValue(0, rLen); //音長を Div 分にセット
    sp2 := TSrcPos.Create;
    try
        sp2.Assign(sp);
        sp2.SetTempSource(s);
        Compile(sp2);
    finally
        sp2.Free ;
    end;
    CurTrack.Length.SetValue(0, temp); //音長を 元に戻す
    CurTrack.TimePtr := last; //本来 Div の後のタイムポインタに戻す 
end;

function TMmlBase.scriptRPN(var sp: TSrcPos): TMVarCustom;
begin
    sp.cmd := 'RPN';
    setRpnNrpn(sp, typeRpn);
    Result := nil;
end;

function TMmlBase.scriptNRPN(var sp: TSrcPos): TMVarCustom;
begin
    sp.cmd := 'NRPN';
    setRpnNrpn(sp, typeNrpn);
    Result := nil;
end;

procedure TMmlBase.setRpnNrpn(var sp: TSrcPos; rpnType: TRpnType);
var
    ary: TMArray;
    rpn:TSmfRPN ;

    procedure chkBendRange;
    begin
        //ベンドレンジは、記憶しておく
        if rpn.rpnType = typeRPN then
        begin
            if (rpn.msb=0)and(rpn.lsb=0) then
            begin
                SongInfo.BendRange[ CurTrack.Channel ] := rpn.data ;
            end;
        end;
    end;

begin
    //rpn(msb,lsb,data)
    ary := getArgs(sp);
    if (ary=nil)or(ary.Count<2) then begin
        raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"%s(msb,lsb[,data])"で指定してください。',sp),[sp.cmd,sp.cmd]);
    end;
    //
    //同タイムにRPN/NRPNを書き込まないためのSHIFT
    if (RpnShift.ch = CurTrack.Channel)and(RpnShift.time = CurTrack.TimePtr) then
    begin
        Inc(RpnShift.shift,(ary.Count)*SongInfo.ControllerShift) ;
    end else
    begin
        RpnShift.shift := 0;
    end;

    rpn := TSmfRPN.Create ;
    rpn.Time := CurTrack.TimePtr - RpnShift.shift -1;//1step前に書き込む
    rpn.rpnType := rpnType;
    rpn.Event := EVENT_CONTROL_CHANGE or CurTrack.Channel ;
    rpn.msb := Byte(ary.IntItems[0]);
    rpn.lsb := Byte(ary.IntItems[1]);
    if ary.Count >= 3 then
    begin
        rpn.data := Byte(ary.IntItems[2]);
        rpn.byteCount := 3;
        chkBendRange;
    end else
    begin
        rpn.byteCount := 2;
    end;
    CurSmfTrack.Add(rpn);

    RpnShift.ch    := CurTrack.Channel ;
    RpnShift.time  := CurTrack.TimePtr ;
end;

function TMmlBase.scriptSysEx(var sp: TSrcPos): TMVarCustom;
var
    mv, chk: TMArray;
    i,j,idx,sum,r: Integer;
    Flag: Char;
    ary: TArrayOfByte ;
    v: TMVarCustom;
    sp2: TSrcPos;
    sysex: TSmfSysEx ;
begin
    Result := nil;
    Flag := sp.ptr^;
    if Flag = '$' then //以後全部16進数モード
    begin
        inc(sp.ptr);
        mv := getArgsHex(sp);
    end else
    begin
        mv := getArgs(sp);
    end;
    if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);

    SetLength(ary, 1024); //適当にバイトを確保
    idx := 0;

    //チェックサムの処理
    for i:=0 to mv.Count -1 do
    begin
        v := mv.Items[i];
        if v.ClassType = TMInt then
        begin
            ary[idx] := Byte(v.IntValue);
            Inc(idx);
        end else
        if v.ClassType = TMStr then
        begin
            //チェックサムの計算
            sp2 := TSrcPos.Create ;
            sp2.Assign(sp); 
            sp2.SetTempSource(v.StrValue);
            if Flag='$' then
                chk := getArgsHex(sp2)
            else begin
                sp2.src := '=' + sp2.src ;
                sp2.ptr := PChar(sp2.src);
                chk := getArgs(sp2);
            end;
            sp2.Free ;
            if chk<>nil then begin
                //_debug(chk.StrValue);
                sum := 0;
                for j:=0 to chk.Count -1 do
                begin
                    r := chk.IntItems[j];
                    sum := sum + r;
                    ary[idx] := r;
                    Inc(idx);
                end;
                r := 128 - (sum mod 128);
                ary[idx] := r; //チェックサム付加
                Inc(idx);
            end;
        end;
    end;
    //
    sysex := TSmfSysEx.Create ;
    sysex.Time := CurTrack.TimePtr ;
    sysex.Event := EVENT_SYS_EX ;
    if ary[0] = EVENT_SYS_EX then
        sysex.byteArray := Copy(ary, 1, idx-1)
    else
        sysex.byteArray := Copy(ary, 0, idx);
    ary := nil;
    CurSmfTrack.Add(sysex); 
end;

function TMmlBase.getArgsHex(var sp: TSrcPos): TMArray;
var
    sp2: TSrcPos;

    procedure getArray(pp: TSrcPos);

        procedure getNum;
        var s: string; m: TMInt;
        begin
            s := '';
            while pp.ptr^ in ['0'..'9','A'..'F','a'..'f'] do begin s := s + pp.ptr^; Inc(pp.ptr); end;
            s := '$' + s; //
            m := TMInt.Create ;
            m.value := StrToIntDef(s, 0);
            Result.Add(m);
        end;

    begin
        Result := TMArray.Create ;
        while True do
        begin
            skipSpace(pp.ptr); 
            case pp.ptr^ of
                '(': Result.Add( getArg(pp) ) ; //変数or計算式を１つ取得
                '{': Result.Add( getArg(pp)) ; //文字列を１つ取得
                '0'..'9','A'..'F','a'..'f':
                begin
                    getNum;
                end;
            end;

            skipSpace(pp.ptr);
            if pp.ptr^ = ',' then //続きがあるか判別
            begin
                Inc(pp.ptr);
            end else
                Break;//終わり
        end;
    end;

begin
    // 引数があるか判別。なければ、ＮＩＬを返す
    skipSpace(sp.ptr);
    case sp.ptr^ of
    //引数あり
    '=':
        begin
            Inc(sp.ptr);
            getArray( sp );
        end;
    '(':
        begin //カッコを展開して、変数をセットする
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp);
                sp2.SetTempSource( getMaruKakko(sp) );
                getArray( sp2 );
            finally
                sp2.Free;
            end;
        end;
    '0'..'9','A'..'F','a'..'f':
        begin
            getArray(sp);
        end;
    //引数なし
    else
        begin
            Result := nil;
        end;
    end;
end;

function TMmlBase.scriptTempo(var sp: TSrcPos): TMVarCustom;  //20~240の範囲にすべし
var
    meta: TSmfTempo ;
    v: DWORD;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ARG_CHAR then
    begin
        //書き込み
        while True do
        begin
          skipSpace(sp.ptr);
          if sp.ptr^ = '=' then
            Inc(sp.ptr) // Tempo= = 50 のような ver.1 互換性のため
          else
            Break;
        end;

        if sp.ptr^ in ['0'..'9'] then
          v := GetIntValue(sp)
        else
          v := GetIntValueAndCalc(sp);

        if v<=0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"Tempo(n)"で指定してください。(20~240の範囲が望ましい)',sp),['Tempo']);
        SongInfo.Tempo := v;
        meta := TSmfTempo.Create ;
        with meta do
        begin
            Time := CurTrack.TimePtr ;
            SetTempo(SongInfo.Tempo);
        end;
        //CurSmfTrack.Add(meta); //テンポトラックは、０に持ってくるべし
        SmfSong.GetTrack(0).Add(meta);
    end;

    Result := TMInt.Create;
    TMInt(Result).value := SongInfo.Tempo ;
end;

function TMmlBase.scriptTimeSig(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    ha,haha,ko: Integer;
    meta: TSmfMeta ;

    function pow(v, cnt: Integer): Integer;
    var i: Integer;
    begin
        Result := 1;
        for i:=1 to cnt do
            Result := Result * v;
    end;
    procedure subHaha;
    var i,n: Integer;
    begin
        i := 1;
        while True do begin
            n := pow(2,i);
            if n>=haha then Break;
            Inc(i);
        end;
        ha := i;
    end;

begin
    Result := nil;
    ary := getArgs(sp);
    ko   := ary.IntItems[0];
    haha := ary.IntItems[1];
    if (ko=0)or(haha=0) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'"TimeSignature(分子,分母)"で指定してください。',sp),['TimeSignature']);
    //
    subHaha;
    SongInfo.TimeSigKo := ko;
    SongInfo.TimeSigHa := haha;
    meta := TSmfMeta.Create ;
    with meta do
    begin
        Time := CurTrack.TimePtr ;
        Event := EVENT_META ;
        MetaType := META_TIME_SIG;
        SetLength(byteArray,4);
        byteArray[0] := Byte(ko);
        byteArray[1] := Byte(ha);
        byteArray[2] := Byte(SongInfo.TimeBase);        // メトロノームStep
        byteArray[3] := (SongInfo.TimeBase div 8);// 32分音符Step
    end;
    CurSmfTrack.Add(meta);
end;

function TMmlBase.scriptTime(var sp: TSrcPos): TMVarCustom;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ = '=' then
    begin // 総ステップ数の代入
        CurTrack.TimePtr := GetIntValueAndCalc(sp) ;
    end else
    if sp.ptr^ = '(' then
    begin //セット
        CurTrack.TimePtr := GetTimeValue(sp);
    end;

    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.TimePtr ;
end;

function TMmlBase.scriptChPrefix(var sp: TSrcPos): TMVarCustom;
var
    meta: TSmfMeta ;
    v: Integer;
begin
    skipSpace(sp.ptr);
    //書き込み
    v := GetIntValue(sp);
    if v<=0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['ChannelPrefix']);
    meta := TSmfMeta.Create ;
    with meta do
    begin
        Time := CurTrack.TimePtr ;
        Event := EVENT_META ;
        MetaType := META_CH_PREFIX;
        SetLength(byteArray,1);
        byteArray[0] := Byte(v-1);
    end;
    CurSmfTrack.Add(meta);
    Result := nil;
end;

function TMmlBase.scriptCopyright(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_COPYRIGHT);
    Result := nil;
end;

function TMmlBase.scriptCuePoint(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_CUE_POINT);
    Result := nil;
end;

function TMmlBase.scriptInstrumentName(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_INST_NAME);
    Result := nil;
end;

function TMmlBase.scriptLyric(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_LYRIC);
    Result := nil;
end;

function TMmlBase.scriptMarker(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_MARKER);
    Result := nil;
end;

function TMmlBase.scriptMetaText(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_TEXT);
    Result := nil;
end;

function TMmlBase.scriptTrackName(var sp: TSrcPos): TMVarCustom;
begin
    WriteMetaText(sp, META_TRACK_NAME);
    Result := nil;
end;

procedure TMmlBase.WriteMetaText(var sp: TSrcPos; mType: Byte);
var
    mv: TMVarCustom ;
    txt: string;
    meta: TSmfMeta ;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ = '=' then Inc(sp.ptr);
    skipSpace(sp.ptr);
    if sp.ptr^ = '=' then Inc(sp.ptr);
    
    if sp.ptr^ = '"' then
    begin //ver.xx互換のため
      Inc(sp.ptr);
      mv := TMStr.Create ;
      TMStr(mv).value := GetTokenChars(['"'], sp.ptr);  
    end else begin
      mv := getArgAndCalc(sp);
    end;
    if mv=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'`MetaText={"text"}`の形式で指定してください。',sp),['メタイベント']);
    txt := mv.StrValue ;
    case SongInfo.MetaTextEOL of
      1:
        begin
          // LF
          txt := JReplace(txt, #13#10, #10, True);
        end;
      2:
        begin
          // CR
          txt := JReplace(txt, #13#10, #13, True);
        end;
    end;

    if mType=META_TRACK_NAME then // MLDのタイトル書き出しように覚えておく
    begin
        SmfSong.TrackName := txt;
    end;

    if (Copy(txt,1,1)='"')and(Copy(txt,Length(txt),1)='"') then
    begin
        txt := Copy(txt,2, Length(txt)-2);
    end;

    meta := TSmfMeta.Create ;
    with meta do
    begin
        Event := EVENT_META ;
        Time := CurTrack.TimePtr ;
        MetaType := mType;
        if txt='' then txt := ' ';
        SetLength(byteArray, Length(txt));
        Move(txt[1], byteArray[0], Length(txt));
    end;
    CurSmfTrack.Add(meta);
end;

function TMmlBase.scriptSub(var sp: TSrcPos): TMVarCustom;
var
    sp2: TSrcPos;
    t: Integer;
begin
    skipSpace(sp.ptr);//
    sp2 := TSrcPos.Create ;
    try
        sp2.Assign(sp);
        sp2.SetTempSource(GetNakaKakko(sp));

        //タイムポインタを記憶
        t := CurTrack.TimePtr ;
        //{ } の中を実行
        Compile(sp2);
        //タイムポインタを戻す
        CurTrack.TimePtr := t;

    finally
        sp2.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptPlay(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    i, nowTr, nowPtr: Integer;
    sp2: TSrcPos;
    mv: TMVarCustom ;
    sc: set of Char;
begin
    Result := nil;
    sp2 := TSrcPos.Create ;
    try

    sp2.Assign(sp);//

    // Play( A; B; C; D... ) を得る
    sc := ValueSplitChar ;
    ValueSplitChar := [',',';'];
    ary := getArgs(sp);
    ValueSplitChar := sc;

    if ary=nil then Exit;

    //トラック毎に書き込み
    nowTr  := CurTrack.TrackNo ;
    nowPtr := CurTrack.TimePtr ;
    //_debug(ary.count);
    for i := 0 to ary.Count -1 do
    begin
        mv := ary.Items[i];
        if mv=nil then Continue;
        if mv.ClassType <> TMStr then Continue;

        SetCurTrack(i); //トラックを変更
        CurTrack.TimePtr := nowPtr; //ポインタを合わせる
        sp2.Assign(sp); 
        sp2.SetTempSource(mv.StrValue);
        try
            Compile(sp2);
        except
            raise EMml.CreateFmt(ErrMsg(MML_ERR_PLAY,sp),[i, sp2.src]);
        end;
    end;
    //トラックを元に戻す
    SetCurTrack(nowTr);

    finally
        sp2.Free;
    end;

end;

function TMmlBase.scriptSystem(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;

    procedure subInclude;
    begin
        Result := scriptInclude(sp);
    end;

    procedure subX68mode;
    begin
        SongInfo.X68Mode := (BOOL_FALSE <> GetIntValue(sp));
    end;

    procedure subStepmode;
    begin
        SongInfo.Stepmode := (BOOL_FALSE <> GetIntValue(sp));
    end;

    procedure subqMax;
    begin
        SongInfo.qMax := GetIntValue(sp);
    end;

    procedure subvMax;
    begin
        SongInfo.vMax := GetIntValue(sp);
    end;

    procedure subvAdd;
    begin
        SongInfo.vAdd := GetIntValue(sp);
    end;

    procedure subqAdd;
    begin
        SongInfo.qAdd := GetIntValue(sp);
    end;

    procedure subq2Add;
    begin
        SongInfo.q2Add := GetIntValue(sp);
    end;

    procedure subTimeBase;
    begin
        Result := scriptTimeBase(sp);
    end;

    procedure subRandomSeed;
    begin
        v := GetIntValue(sp);
        RandSeed := v;
    end;

    procedure subKeyshift;
    begin
        SongInfo.Keyshift := GetIntValue(sp); 
    end;

    procedure subMeasureShift;
    begin
        SongInfo.MeasureShift := GetIntValue(sp);
    end;

    procedure subVoiceNoShift;
    begin
        SongInfo.VoiceNoShift := GetIntValue(sp);
    end;

    procedure subOctaveRangeShift;
    begin
        SongInfo.OctaveRangeShift := GetIntValue(sp); 
    end;

    procedure subKeyFlag;
    begin
        Result := scriptKeyFlag(sp);
    end;

    procedure subControllerShift;
    begin
        SongInfo.ControllerShift := GetIntValue(sp); //コントロールの書き込みタイミング
        SmfSong.CCShift := SongInfo.ControllerShift;
    end;

    procedure subTimeSignature;
    begin
        scriptTimeSig(sp); 
    end;

{System オプション
Include
LoadSMF
X68mode
Stepmode
qMax
vMax
vAdd
qAdd
q2Add
TimeBase
TimeSignature
RandomSeed
Keyshift
MeasureShift
VoiceNoShift
OctaveRangeShift
KeyFlag
GetKeyFlag
ControllerShift
}

var
    s: string;
begin
    Result := nil;
    if sp.ptr^<>'.' then Exit;
    Inc(sp.ptr);
    //s := Trim(GetTokenChars(['+','-','=','(','#'], sp.ptr));
    //Dec(sp.ptr); //back +-=(
    s := Trim(getTokenWord(sp.ptr)); 
    {Systemオプション}
    if s='Include' then subInclude else //Include(fname)//定義ファイルを取り込んで実行する
    if s='LoadSMF' then {未定義} else //System.LoadSMF(fname)//未定義
    if s='X68mode' then subX68mode else //System.X68mode(on/off)//オクターブの上下記号<>を入れ替える。初期値は、off
    if s='Stepmode' then subStepmode else //System.Stepmode(on/off)//ステップ指定を基本とする。初期値は、off
    if s='qMax' then subqMax else //System.qMax=value//qの100%時の値を指定する。初期値は、100。旧いMMLなどの再現用。（例）System.qMax=8
    if s='vMax' then subvMax else //Sysytem.vMax=value//vの最大値を指定する。初期値は、127。旧いMMLなどの再現用。（例）System.vMax=15
    if s='vAdd' then subvAdd else ////v++で加算する値を指定する
    if s='qAdd' then subqAdd else ////q++で加算する値を指定する
    if s='q2Add' then subq2Add else ////q%++で、加算する値を指定する
    if s='TimeBase' then subTimeBase else //TimeBase=value//四分音符分解能。タイムベースを指定する。初期値は、96。48,96,120,196,240,480などが一般的。
    if s='TimeSignature' then subTimeSignature else //TimeSignature=分子,分母//拍子記号の設定を行う
    if s='RandomSeed' then subRandomSeed else //RandomSeed=v//乱数の種を指定して、毎回同じ乱数が得られるようにする。
    if s='Keyshift' then subKeyshift else //System.Keyshift=v//キーをv半音上げる
    if s='MeasureShift' then subMeasureShift else //System.MeasureShift=v//小節数をずらしてTime(1:1:0)以前に初期設定が出来るようにする。
    if s='VoiceNoShift' then subVoiceNoShift else //System.VoiceNoShift=v//音色番号が、0から始まる音源の場合に、-1を指定する、初期値は、0
    if s='OctaveRangeShift' then subOctaveRangeShift else //System.OctaveRangeShift=v//オクターブレンジのシフト値。初期値は、0。
    if s='KeyFlag' then subKeyFlag else //KeyFlag[+|-](mml)|KeyFlag=(a,b,c,d,e,f,g)//臨時記号を適用する。配列に代入すると、キーフラグの値を得られる。
    if s='GetKeyFlag' then subKeyFlag else//Array (name) = System.GetKeyFlag//キーフラグの値を配列に読み込む
    if s='ControllerShift' then subControllerShift else//System.ControllerShift=v//各種エフェクトの書き込みタイミングの制御。初期値は、3。
    {/Systemオプション}
    raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[s]) ;

end;

function TMmlBase.scriptInclude(var sp: TSrcPos): TMVarCustom;
var
    sp2: TSrcPos;
    fname, s: string;
    fno: Integer;
    ms: TMStr;

    function FindPath(fname: string; var s: string): Boolean;
    var
      AppPath, CurDir, Up, ss, p: string;
    begin
      Result := False;

      // AppPath を検索
      AppPath := ExtractFilePath( ParamStr(0) );
      s := AppPath + fname;
      if FileExists(s) then begin Result := True; Exit; end;
      s := AppPath + 'Include' + PATH_FLAG + fname;
      if FileExists(s) then begin Result := True; Exit; end;

      // CurDir を検索
      CurDir := GetCurrentDir + PATH_FLAG;
      s := CurDir + fname;
      if FileExists(s) then begin Result := True; Exit; end;
      s := CurDir + 'Include' + PATH_FLAG + fname;
      if FileExists(s) then begin Result := True; Exit; end;

      // ../Include を検索
      Up := ExtractFilePath(Copy(AppPath, 1, Length(AppPath) -1));
      s := Up + fname;
      if FileExists(s) then begin Result := True; Exit; end;
      s := Up + 'Include' + PATH_FLAG + fname;
      if FileExists(s) then begin Result := True; Exit; end;

      // ../Include を検索 (2)
      Up := ExtractFilePath(Copy(CurDir, 1, Length(CurDir) -1));
      s := Up + fname;
      if FileExists(s) then begin Result := True; Exit; end;
      s := Up + 'Include' + PATH_FLAG + fname;
      if FileExists(s) then begin Result := True; Exit; end;

      // 環境変数内をチェック
      ss := GetEnvironmentVariable('Path');
      while ss<> '' do
      begin
        p := GetToken(';', ss);
        s := p + fname;
        if FileExists(s) then begin Result := True; Exit; end;
        s := p + 'Include' + PATH_FLAG + fname;
        if FileExists(s) then begin Result := True; Exit; end;
      end;
    end;


begin
    Result := nil;

    //ファイル名を得る
    skipSpace(sp.ptr);
    if sp.ptr^ = '(' then
    begin
        fname := GetMaruKakko(sp);
    end else raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Include']);

    //fname : 識別用の名前
    //s     : フルパスのファイル名
    if FindPath(fname, s)=False then
    begin
      raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'ファイル"%s"が見つかりません。',sp),['Include',fname]);
    end;

    //ソースの二重取り込みチェック
    if IncludedFiles.IndexOf(fname)>=0 then
    begin
        //取り込んでいるから抜ける
        Exit;
    end;

    //ファイル番号に追加
    fno := IncludedFiles.Add(fname);

    ms := TMStr.Create ;
    ms.LoadFromFile(s);
    ms.value := PreCompile(ms.value, 0);
    IncludedSource.Add(ms);

    //
    sp2 := TSrcPos.Create ;
    try
        sp2.ptr := PChar(ms.value);
        sp2.lineNo := 0;
        sp2.fileNo := fno;
        sp2.cmd := 'Include';
        Compile(sp2);
    finally
        sp2.Free ;
    end;

end;


function TMmlBase.scriptKeyShift(var sp: TSrcPos): TMVarCustom;
begin
    skipSpace(sp.ptr);

    if sp.ptr^ in ARG_CHAR then
        SongInfo.Keyshift := GetIntValue(sp);

    Result := TMInt.Create ;
    TMInt(Result).value := SongInfo.Keyshift;
end;

function TMmlBase.scriptPort(var sp: TSrcPos): TMVarCustom;
var
    meta: TSmfMeta ;
    v: Integer;
begin
    skipSpace(sp.ptr);
    //書き込み
    v := GetIntValue(sp);
    if v<0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Port']);
    meta := TSmfMeta.Create ;
    with meta do
    begin
        Event := EVENT_META;
        Time := CurTrack.TimePtr ;
        MetaType := META_PORT;
        SetLength(byteArray,1);
        byteArray[0] := Byte(v);
    end;
    CurTrack.Port := v; // set port
    CurSmfTrack.Add(meta);
    Result := nil;
end;

function TMmlBase.funcOctaveDownOnece(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    Dec(FlagOctaveUpOnce);
end;

function TMmlBase.scriptCC_M(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,1);
    Result := nil;
end;

procedure TMmlBase.WriteCCComand(var sp: TSrcPos; cc: Integer);
var
    ccc: TSmfControlChange;
    v: Integer;
    n: TNoteCC;
    s: string;
    sp2: TSrcPos;
begin
    if sp.ptr^ = '.' then
    begin
        WriteCCOption(sp, cc); Exit;
    end else
    if sp.ptr^ = ',' then
    begin
        ShowHint(MML_WARN_VAR_SYNTAX+'値指定で無意味な","は使えません。',sp);
        Inc(sp.ptr);
    end;
    v := 0;
    if sp.ptr^ = '(' then
    begin
        s := GetMaruKakko(sp);
        sp2 := TSrcPos.Create ;
        try
            sp2.SetTempSource(s);
            v := GetIntValueAndCalc(sp2);
        except
            sp2.Free ;
        end;
    end else
    begin
        v := GetIntValueAndCalc(sp); //値を得る
    end;

    //
    v := Min(v,127); //最大値を、127に収める
    n := SongInfo.CC[CurTrack.Channel].GetCC(cc);
    n.No := cc;
    n.noteOnType := noteNormal ;
    n.Time := CurTrack.TimePtr ;
    n.LastValue := v; //値を記憶する

    //
    if CurTrack.CCMute then Exit;
    if CurTrack.CCNoMute[cc] then Exit;

    //トラックへ無駄に書き込まれるコントロールチェンジをトリムする(ver.2.32以降)
    DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, cc, CurTrack.TimePtr, False);

    //smfに書き込む
    ccc := TSmfControlChange.Create ;
    ccc.Time := CurTrack.TimePtr - SongInfo.ControllerShift;//1step前に書き込む
    ccc.Event := EVENT_CONTROL_CHANGE or CurTrack.Channel ;
    ccc.No := cc;
    ccc.Value := Byte(v);
    CurSmfTrack.Add(ccc);
end;

function TMmlBase.scriptCC_PT(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,5);
    Result := nil;
end;

function TMmlBase.scriptCC_Chorus(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,93);
    Result := nil;
end;

function TMmlBase.scriptCC_DataLSB(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,38);
    Result := nil;

end;

function TMmlBase.scriptCC_DataMSB(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,6);
    Result := nil;

end;

function TMmlBase.scriptCC_Expression(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,11);
    Result := nil;
end;

function TMmlBase.scriptCC_MainVolume(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,7);
    Result := nil;

end;

function TMmlBase.scriptCC_Panpot(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,10);
    Result := nil;

end;

function TMmlBase.scriptCC_PortamentoSwitch(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,65);
    Result := nil;

end;

function TMmlBase.scriptCC_Reverb(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,91);
    Result := nil;

end;

function TMmlBase.scriptCC_VAR(var sp: TSrcPos): TMVarCustom;
begin
    WriteCCComand(sp,94);
    Result := nil;

end;

function TMmlBase.scriptRythm(var sp: TSrcPos): TMVarCustom;

    function ReplaceRythm(src: string): string;
    var
      sp3: TSrcPos;
      s, ss: string;
      node: TMHashNode;
      IsDiv: Boolean;

        procedure get_arg_num; // ss の ? を, 続く引数に置換する
        var a: string;
        begin
          //引数を得る
          a := '';
          if sp3.ptr^ in ['0'..'9','$','^'] then
          begin
            while sp3.ptr^ in ['0'..'9','$','.','^'] do begin
              a := a + sp3.ptr^; Inc(sp3.ptr);
            end;
          end;
          //マクロを置換
          ss := JReplace(ss, '?', a, True);
        end;

    begin
        Result := '';
        IsDiv := False;
        sp3 := TSrcPos.Create ;
        try
            sp3.Assign(sp);
            sp3.SetTempSource(src);
            while sp3.ptr^<>#0 do
            begin
                if sp3.ptr^ in LeadBytes then
                begin
                    Result := Result + sp3.ptr^ + (sp3.ptr+1)^;
                    Inc(sp3.ptr,2);
                end else
                begin //Rythmモードでは、1文字、1命令になる
                    if sp3.ptr^ = '$' then
                    begin //リズムmacro定義
                        Inc(sp3.ptr);
                        scriptRythmChar(sp3); Continue;
                    end else
                    if sp3.ptr^ = '(' then
                    begin //カッコの中だけは、非リズムモード
                        s := GetMaruKakko(sp3);
                        s := JReplace(s,'Sub','',True);
                        Result := Result + s + ' ';//(v1)との互換性のため最後にスペースが必要
                        if Pos('Div',s)>0 then IsDiv := True;
                        Continue;
                    end else
                    if sp3.ptr^ = '#' then
                    begin
                        s := getTokenWord(sp3.ptr);
                        node := Commands.Items[s];
                        if node<>nil then
                        begin
                            s := ReplaceRythm(node.value.StrValue);
                            Result := Result + s ;
                        end else
                        begin
                            Result := Result + s;
                        end;
                        Continue;
                    end else
                    if sp3.ptr^ = '{' then //擬似Sub命令
                    begin
                        s := GetNakaKakko(sp3);
                        if IsDiv then
                        begin
                          Result := Result + '{'+ ReplaceRythm(s) + '}'; IsDiv := False;
                        end else
                        begin
                          Result := Result + 'Sub{'+ ReplaceRythm(s) + '}';
                        end;
                        Continue;
                    end else
                    if (strLComp(sp3.ptr, 'Div', 3) = 0)or(strLComp(sp3.ptr, 'DIV', 3) = 0) then
                    begin
                        IsDiv := True;
                        Inc(sp3.ptr, 3);
                        Result := Result + 'Div';
                        Continue;
                    end else
                    if RythmChar[Ord(sp3.ptr^)] <> '' then
                    begin
                        //マクロを展開する
                        ss := RythmChar[Ord(sp3.ptr^)]; Inc(sp3.ptr);
                        if Pos('?', ss)>0 then get_arg_num;
                        Result := Result + ss;
                    end else begin
                        Result := Result + sp3.ptr^;
                        Inc(sp3.ptr);
                    end;
                end;
            end;
        finally
            sp3.Free ;
        end;
    end;

var
    sp2: TSrcPos;
    s: string;
begin
    //リズムモード
    sp2 := TSrcPos.Create ;
    try
        sp2.Assign(sp);
        s := GetNakaKakko(sp);
        s := ReplaceRythm(s);
        //_debug(s);
        if MmlOption.RythmLog then
        begin
            WriteLog('// ---[Rythmモード置換]--->');
            WriteLog(s);
            WriteLog('//<---[Rythmモード置換]');
        end;
        sp2.SetTempSource(s);//{..}を取得
        try
            Compile(sp2);
        except
            raise;//エラーを再送出
        end;
    finally
        sp2.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptRythmChar(var sp: TSrcPos): TMVarCustom;
var
    c: Char;
    s: string;
begin
    //マクロ文字を得る
    if sp.ptr^ in LeadBytes then
    begin//全角だったら、エラー
        raise EMml.Create(ErrMsg(MML_ERR_DEF_MACRO+'リズムマクロは半角で指定してください。',sp));
    end;
    c := sp.ptr^; Inc(sp.ptr);
    if(sp.ptr^='=')then Inc(sp.ptr);
    s := GetNakaKakko(sp);
    //マクロに内容をセット
    RythmChar[Ord(c)] := s;
    Result := nil;
end;

procedure TMmlBase.DebugMeta(text: string);
var
    meta: TSmfMeta ;
begin
    text := Trim(text);
    meta := TSmfMeta.Create ;
    with meta do
    begin
        Time := CurTrack.TimePtr ;
        Event := EVENT_META ;
        MetaType := META_TEXT;
        if text='' then text := ' ';
        SetLength(byteArray, Length(text));
        Move(text[1], byteArray[0], Length(text));
    end;
    CurSmfTrack.Add(meta);
end;

function TMmlBase.scriptRandom(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
    v1,v2: Integer;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Random']);
    if ary.Count = 0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Random']);


    Result := TMInt.Create ;
    if ary.Count = 1 then
    begin
        v1 := ary.IntItems[0];
        TMInt(Result).value := Random( v1 );
    end else
    begin
        v1 := ary.IntItems[0];
        v2 := ary.IntItems[1];
        if v1>v2 then
            TMInt(Result).value := Random( v1-v2 ) + v2
        else
            TMInt(Result).value := Random( v2-v1 ) + v1;
    end;
end;

function TMmlBase.scriptRandomSelect(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['RandomSelect']);

    Result := TMInt.Create ;
    TMInt(Result).value := ary.IntItems[Random(ary.Count)];
end;

function TMmlBase.scriptIntToStr(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom ;
begin
    v := getArg(sp);
    Result := TMStr.Create ;
    if v<>nil then
        TMStr(Result).value := v.StrValue ;
end;

function TMmlBase.scriptMML(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    p: PChar;
    v,i: Integer;
    n: TNoteCC;
    hn: TMHashNode ;

    procedure getWordsValue;
    var w: string;
    begin
        w := UpperCase(getTokenWord(p));
        if (w='BR') then
        begin
            v := SongInfo.BendRange[CurTrack.Channel];
        end else
        if (w='KEY') then
        begin
            v := SongInfo.Keyshift ;
        end else
        if (w='TIMEKEY') then
        begin
            v := GetNowTimeKey(0) ;
            if v=MaxInt then v := 0; //非適用のとき
        end else
        if (w='TIMEKEY2') then
        begin
            v := GetNowTimeKey(1) ;
            if v=MaxInt then v := 0; //非適用のとき
        end else
        if (w='PORT') then
        begin
            v := CurTrack.Port ;
        end else
        raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp),[w]);
    end;

    function NoteInfo(ni: TNoteInfos): Integer;
    var idx, no: Integer;
    begin
        idx := 0; Inc(p);
        if p^ = '_' then
        begin
            Inc(p);
            if p^ = '_' then
            begin
                Inc(p);
                no := StrToIntDef(GetNumber(p),-1);
                if no<0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['MML(コマンド__)のあとに数値がありません。']);
                idx := no + 1;
            end else
            begin
                idx := 1;
            end;
        end;
        try
            Result := ni.ArrayNote[idx].Value;
        except
            Result := 0;
        end;
    end;

begin
    s := GetMaruKakko(sp);
    hn := Commands.Items[s];
    if (hn<>nil)and(hn.nodeType = ntStr) then s := hn.value.StrValue;

    p := PChar(s);
    v := 0;
    skipSpace(p);//MML値得る
    case p^ of
    '@': v := CurTrack.Voice ;
    'v': v := NoteInfo(CurTrack.Velocity) ;
    'o': v := NoteInfo(CurTrack.Octave);
    'l': v := NoteInfo(CurTrack.Length);
    'q': v := NoteInfo(CurTrack.Qgate) ;
    't': v := NoteInfo(CurTrack.Timing) ;
    'h': v := CurTrack.Q2 ;
    'y':
        begin
            Inc(p);//skip 'y'
            i := StrToIntDef(GetNumber(p),-1);
            if i<0 then raise Emml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['MML']);
            n := SongInfo.CC[CurTrack.Channel].FindCC(i);
            if n=nil then
                v := 0
            else begin
                v := n.LastValue ;
                if v<0 then //値が未設定のとき、リセット時の初期値を入れる。
                begin
                    case n.No of
                    CC_NO_VOLUME:     v := 100;
                    CC_NO_EXPRESSION: v := 127;
                    CC_NO_PANPOT:     v :=  64;
                    end;
                end;
            end;
        end;
    'p':
        begin
            Inc(p);//skip 'p'
            if p^='%' then
                n := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND_FULL)
            else
                n := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND);
            v := n.LastValue ;
        end;
    'A'..'Z','_':
        begin
            getWordsValue;
        end;
    end;
    Result := TMInt.Create;
    TMInt(Result).value := v;
end;

function TMmlBase.scriptNoteNo(var sp: TSrcPos): TMVarCustom;
var
    o,v: Integer;
    s: string;
    hn: TMHashNode;
    nsp: TSrcPos;
    nn: Char;
begin
    //ノートナンバーを得る部分
    skipSpace(sp.ptr);
    s := GetMaruKakko(sp);
    hn := Commands.Items[s];
    if (hn<>nil)and(hn.nodeType = ntStr) then s := hn.value.StrValue;

    nsp := TSrcPos.Create ;
    nsp.Assign(sp);
    nsp.SetTempSource(s);
    o := CurTrack.Octave.GetValue ;
    v := 0;
    while nsp.ptr^ <> #0 do
    begin
        if nsp.ptr^='o' then
        begin
            Inc(nsp.ptr);
            o := GetIntValue(nsp);
        end else
        if nsp.ptr^ in ['a'..'g','n'] then
        begin
            nn := nsp.ptr^; Inc(nsp.ptr);
            v := GetNoteNo(nsp, nn, False);
        end else
            Inc(nsp.ptr);
    end;
    Result := TMInt.Create ;
    TMInt(Result).value := o*12 + v;
end;

function TMmlBase.scriptStep(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    sp2: TSrcPos;
begin
    s := '!'+GetMaruKakko(sp);
    sp2 := TSrcPos.Create;
    try
        sp2.Assign(sp);
        sp2.SetTempSource(s);
        Result := getArg(sp2);
    finally
        sp2.Free ;
    end;
end;

function TMmlBase.scriptStrToLen(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    sp2: TSrcPos;
begin
    s := GetMaruKakko(sp);

    sp2 := TSrcPos.Create;
    try
        sp2.Assign(sp);
        sp2.SetTempSource('!('+s+')');
        Result := TMInt.Create ;
        TMInt(Result).value := GetIntValueAndCalc(sp2);
    finally
        sp2.Free ;
    end;
end;

function TMmlBase.scriptStrToNum(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    sp2: TSrcPos;
begin
    s := GetMaruKakko(sp);
    sp2 := TSrcPos.Create;
    try
        sp2.Assign(sp);
        sp2.SetTempSource('('+s+')');
        Result := TMInt.Create ;
        TMInt(Result).value := GetIntValueAndCalc(sp2);
    finally
        sp2.Free ;
    end;
end;

function TMmlBase.scriptTrackSync(var sp: TSrcPos): TMVarCustom;
var
    i,tm: Integer;
begin
    tm := CurTrack.TimePtr ;
    for i:=0 to SongInfo.Count -1 do
    begin
        if SongInfo.Items[i] <> nil then
        begin
            TTrackInfo(SongInfo.Items[i]).TimePtr := tm;
        end;
    end;
    SongInfo.TrackSyncTime := tm; //今後生成されるトラックに備える
    Result:= nil;
end;

{function TMmlBase.GetTokenComma(var sp: TSrcPos): string;
begin
    Result := '';
    if sp.ptr^ = '{' then
    begin
        Result := getString(sp.ptr, sp.lineNo);
        Exit;
    end;
    while sp.ptr^ <> #0 do
    begin
        if sp.ptr^ in LeadBytes then
        begin
            Result := Result + sp.ptr^ + (sp.ptr+1)^;
            Inc(sp.ptr,2); Continue;
        end;
        if sp.ptr^ in [#13,#10] then Break;
        if sp.ptr^ in ValueSplitChar then Break;
        Result := Result + sp.ptr^;
        Inc(sp.ptr);
    end;
end;}


function TMmlBase.getArgsWithType(var sp: TSrcPos;
  varType: string): TMArray;
begin
  Result := TokenBase.GetArgs(sp, varType); 
end;

(*
function TMmlBase.getArgsWithType(var sp: TSrcPos;
  varType: string): TMArray;
var
    sp2: TSrcPos;
    s: string;
    node: TMHashNode;

    procedure getArray(var pp: TSrcPos);
    var
        i: Integer;
        v: TMVarCustom ;
        s: string;
        n: TMHashNode ;
        temp,p: PChar;
        sp3: TSrcPos;

        procedure getArrayType(var pp: TSrcPos);
        var spa: TSrcPos;
        begin
            begin
                while True do
                begin
                    if (pp.ptr^ = '(') then
                    begin
                        spa := TSrcPos.Create ;
                        try
                            spa.Assign(pp);
                            s := GetMaruKakko(pp);
                            spa.SetTempSource(s);
                            getArrayType(spa);
                        finally
                            spa.Free ;
                        end;
                    end else
                    begin
                        v := getArgAndCalc(pp);
                        if v=nil then
                        begin
                            if pp.ptr^ in ValueSplitChar then //すぐ後ろにカンマ
                            begin
                                Result.AddInt(0);
                                Inc(pp.ptr);
                                Continue;
                            end else
                            begin
                                Result.AddInt(0);
                                Break;
                            end;
                        end;
                        if v.ClassType = TMArray then
                        begin
                            Result.AddArray(v as TMArray);
                        end else
                            Result.Add(v);
                    end;
                    skipSpace(pp.ptr);
                    if pp.ptr^ in ValueSplitChar then Inc(pp.ptr) else Break;
                end;
            end;
        end;

    begin
        //型に併せて引数を得る
        Result := TMArray.Create ;
        for i:=1 to Length(varType) do
        begin
            skipSpace(pp.ptr);
            if pp.ptr^ = #0 then Break;
            case varType[i] of
            'i':
                begin
                    v := getArgAndCalc(pp);
                    if v<>nil then begin
                        if v.ClassType = TMArray then Result.AddArray(v as TMArray);
                    end;
                    Result.Add( v ) ; //引数を１つ取得
                end;
            'a':
                begin
                    if pp.ptr^ in ['A'..'Z','a'..'z','_','#'] then
                    begin
                        temp := pp.ptr;
                        s := getTokenWord(pp.ptr);
                        n := Commands.Items[s];
                        if n.nodeType = ntArray then
                        begin
                            Result.AddArray(n.value as TMArray);
                        end else
                        begin
                            pp.ptr := temp;
                            getArrayType(pp);
                        end;
                    end else
                        getArrayType(pp);
                end;
            's':
                begin
                    if pp.ptr^ = '{' then
                    begin
                        v := getArg(pp);
                    end else
                    begin
                        s := GetTokenComma(pp);
                        n := Commands.Items[s];
                        if (n=nil)or(n.nodeType <> ntStr) then
                        begin
                            sp3 := TSrcPos.Create ;
                            try
                                sp3.Assign(pp);
                                sp3.SetTempSource(s);
                                p := sp3.ptr;
                                {
                                if p^ in ['A'..'Z','a'..'z','_','#'] then
                                begin
                                    v := TMStr.Create ;
                                    TMStr(v).value := s;
                                end else
                                begin
                                    v := getArgAndCalc(sp3);
                                end;}
                                if p^ in ARG_CHAR then
                                begin
                                    v := getArgAndCalc(sp3);
                                end else
                                begin
                                    v := TMStr.Create ;
                                    TMStr(v).value := s;
                                end;
                                //raise Exception.CreateFmt(ErrMsg(MML_ERR_SYSTEM+'"%s"',pp),[p^]);
                            finally
                                sp3.Free ;
                            end;
                        end
                        else
                            v := n.value ;
                    end;
                    Result.Add(v);
                end;
            end;
            skipSpace(pp.ptr);
            if pp.ptr^ in ValueSplitChar then Inc(pp.ptr) else Break;
        end;
    end;

begin
    // 引数があるか判別。なければ、NIL を返す
    skipSpace(sp.ptr);
    case sp.ptr^ of
    //引数あり
    '=':
        begin
            Inc(sp.ptr);
            getArray( sp );
        end;
    '(':
        begin //カッコを展開して、変数をセットする
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp); 
                s := getMaruKakko(sp);
                if Pos(',',s) = 0 then
                begin
                    node := Commands.Items[s];
                    if node=nil then
                    begin
                        if not((Copy(s,1,1)='{')and(Copy(s,Length(s),1)='}')) then
                        begin
                            if Copy(varType,1,1)='s' then s := '{'+s+'}';
                        end;
                    end else
                    begin
                        Result := TMArray.Create ;
                        Result.Add(node.value.clone);
                    end;
                end;
                sp2.SetTempSource( s );
                try
                    getArray( sp2 );
                except
                    on e: Exception do raise EParserError.Create(e.Message); 
                end;
            finally
                sp2.Free;
            end;
        end;
    '%','!','$','0'..'9','{':
        begin
            getArray(sp);
        end;
    //引数なし
    else
        begin
            Result := nil;
        end;
    end;
end;
*)

procedure TMmlBase.GetTrackDefaultValue(var len, gate, vel, tim,
  oct: Integer; var stepm: Boolean);
begin
    with CurTrack do //カレントトラックのデフォルト値を得る
    begin
        len    := Length.GetValue ;
        gate   := Qgate.GetValue ;
        vel    := Velocity.GetValue ;
        tim    := Timing.GetValue ;
        oct    := Octave.GetValue ;
        stepm  := Stepmode;
    end;
    if StretchRate <> 1 then
    begin
        len := Trunc(len * StretchRate );
    end;
end;

function TMmlBase.getArgAndCalc(var sp: TSrcPos): TMVarCustom;
begin
  Result := TokenBase.GetArgCalc(sp); 
end;

(*
function TMmlBase.getArg_sub(var sp: TSrcPos): TMVarCustom;
var
    debugPos: TSrcPos;

    //変数・関数を得る
    procedure VarOrCommand;
    var
        key: string;
        node: TMHashNode;

    begin
        //カンマまでを得る
        //key := getTokenMML(sp.ptr);
        key := getTokenWord(sp.ptr); 

        if Copy(key,1,1)='#' then //例外的な文字列、"#変数"の処理
        begin
            node := Commands.Items[ key ];
            if node=nil then begin //なければ作る
                node := TMhashNode.Create(key) ;
                node.value := TMStr.Create ;
                ParentCommands.Add(node);
            end;
        end else begin
            node := Commands.Items[ key ];
        end;
        if node=nil then
        begin
            //keyをそのまま返す
            Result := TMStr.Create ;
            TMStr(Result).value := key;
            Exit;
            //raise EMml.CreateFmt(ErrMsg(MML_ERR_VAR_NOT_FOUND,sp),[ key ]);
        end;
        //node を渡して、値を得る
        Result := ExecuteCommand(node, sp);
    end;

    //値を１つ得る
    procedure getOne;
    var
        temp: Boolean;

        //カッコのある場合：カッコの中身を得る
        procedure subKakko;
        var
            sp2: TSrcPos;
            s: string;
            n: TMHashNode;
            mv: TMVarCustom;
        begin
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp);
                s := GetMaruKakko(sp);
                if (Copy(s,1,1)='(')and(Copy(s,Length(s),1)=')') then //無意味な、((A))のようなカッコの負担を減らす
                begin
                    s := Copy(s,2,Length(s)-2);
                end;
                n := Commands.Items[s];
                if (n=nil)or(n.nodeType=ntSysFunc)or(n.nodeType=ntUserFunc) then
                begin
                    sp2.SetTempSource(s);
                    Result := getArgAndCalc(sp2);
                end else
                begin
                    mv := n.value ;
                    Result := mv.clone ;
                end;
            finally
                sp2.Free ;
            end;
        end;

        //文字列の取得
        procedure subString;
        var
            sp2: TSrcPos; //文字列の取得開始位置を覚えておく
        begin
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp); //文字列の取得開始位置をコピー
                Result := TMStr.Create ;
                try
                    //文字列を取得
                    TMStr(Result).value := getString(sp.ptr, sp.lineNo);
                    //_debug(TMStr(Result).value);
                except
                    //取得に失敗したらエラー
                    raise;// EMml.Create(ErrMsg(MML_ERR_GET_STRING,sp2));
                end;
            finally
                sp2.Free ;
            end;
        end;
        //文字列の取得
        procedure subString2;
        var
            sp2: TSrcPos; //文字列の取得開始位置を覚えておく
        begin
            sp2 := TSrcPos.Create ;
            try
                sp2.Assign(sp); //文字列の取得開始位置をコピー
                Result := TMStr.Create ;
                try
                    //文字列を取得
                    if sp.ptr^ = '"' then Inc(sp.ptr);
                    TMStr(Result).value := GetTokenChars(['"'],sp.ptr);
                    //_debug(TMStr(Result).value);
                except
                    //取得に失敗したらエラー
                    raise;
                end;
            finally
                sp2.Free ;
            end;
        end;

    begin
        skipSpace(sp.ptr);//
        case sp.ptr^ of
        '$','0'..'9':
            begin
                Result := getNumberM(sp) ;
            end;
        '+','=':
            begin
                Inc(sp.ptr);
                //Result := getNumberM(sp) ;//=のあとが数字とは限らない
                temp := CalcMode ;
                CalcMode := True;
                getOne;
                CalcMode := temp;
                Exit;
            end;
        '-':
            begin
                Inc(sp.ptr);
                Result := getArgAndCalc(sp);
                if Result.ClassType = TMInt then
                    TMInt(Result).value := -1 * Result.IntValue ;
            end;
        '!':
            begin
                Inc(sp.ptr);
                Result := TMInt.Create ;
                TMInt(Result).value := GetNoteLength(sp, False, CurTrack.Length.GetValue);
            end;
        '%':
            begin
                Inc(sp.ptr); // skip '%'
                Result := getArg(sp);
                if Result=nil then
                begin
                    raise Exception.Create('[%]の値がありません。'); 
                end else
                if Result.ClassType = TMInt then
                    TMInt(Result).Flag := '%' ;
            end;
        'A'..'Z','a'..'z','_','#':
            begin
                if CalcMode=False then
                begin
                    Result := nil; Exit;
                end;
                VarOrCommand;
            end;
        '(':
            begin //計算式
                subKakko;
            end;
        '{':
            begin //文字列
                subString;
            end;
        '"':
            begin //文字列２
                subString2;
            end;
        else
            begin
                Result := nil;
            end;
        end;
    end;

    procedure CalcVar;
    var
        stack: TMStack;
        enzansi: string;
        ppp: PChar;
    begin
        stack := TMStack.Create ;
        try
        try
            //初めに取得した値を加える
            stack.Add(Result);
            while sp.ptr^ in ENZANSI_CHAR do
            begin
                //演算子を取得
                ppp := sp.ptr;
                enzansi := sp.ptr^;
                if (sp.ptr^ in ENZANSI_NEXT_CHAR)and((sp.ptr+1)^ in ENZANSI_NEXT_CHAR) then
                begin
                    enzansi := enzansi + (sp.ptr+1)^;
                    Inc(sp.ptr);
                end;
                stack.Add( CreateEnzansi(enzansi) );
                Inc(sp.ptr);//inc enzansi
                //項を取得
                getOne;
                if Result = nil then
                begin
                    //後ろが計算式だと思ったけど、違ったようなので、
                    //ポインタを元に戻す
                    sp.ptr := ppp;
                    stack.Delete(stack.Count -1);
                    ShowHint(Format('式の直後に演算子`%s`があったので、誤動作を起こす恐れがあります。',[enzansi]),sp);
                    Break;
                end else begin
                    stack.Add(Result);
                end;
                skipSpaceCalc(sp.ptr);
            end;
            //スタックに得た計算式を計算する
            Result := CalcTMStack( stack );
        except
            on e: Exception do
                raise EParserError.Create(e.Message);
        end;
        finally
            stack.Free ;
        end;
    end;

begin
    debugPos := TSrcPos.Create ;
    try
    debugPos.Assign(sp);

    //値を得る
    try
        getOne;
    except
        on e: Exception do raise EMml.Create(ErrMsg(e.Message, sp));
    end;
    if CalcMode = False then Exit;
    if Result = nil then Exit;

    //値の後ろに計算式があれば計算する
    skipSpaceCalc(sp.ptr);
    if Result.ClassType = TMStr then //文字列で計算できるのは、＋ = ! だけ
    begin
        if not (sp.ptr^ in ['+','=','!']) then Exit;
    end else
    if not(sp.ptr^ in ENZANSI_CHAR) then Exit;//演算子がないから、抜ける

    //実際に計算
    try
        CalcVar;
    except
        on e: Exception do
        begin
            raise EMml.Create(ErrMsg(MML_ERR_SYSTEM+e.Message, debugPos));
        end;
    end;

    finally
        debugpos.Free ;
    end;
end;
*)

function TMmlBase.scriptSizeOf(var sp: TSrcPos): TMVarCustom;
var
    s: string;
    //sp2: TSrcPos;
    v: TMHashNode ;
begin
    Result := TMInt.Create ;

    s := Trim(GetMaruKakko(sp));

    v := Commands.Items[s];
    if (v=nil)or(v.value=nil) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG, sp),['SizeOf']);

    TMInt(Result).value := TMHashNode(v).Count;

    if v.value.ClassType = TMInt then
    begin
        TMInt(Result).value := SizeOf(Integer);
    end else if v.value.ClassType = TMStr then
    begin
        TMInt(Result).value := Length(v.value.StrValue);
    end else if v.value.ClassType = TMArray then
    begin
        TMInt(Result).value := TMArray(v.value).Count ;
    end;
end;

function TMmlBase.scriptStretch(var sp: TSrcPos): TMVarCustom;
var
    sp2, spt: TSrcPos;
    len, tempPtr, timeCount: Integer;
    src: string;
    tempRate: Extended; tempMute: Boolean;
begin
    //Stretchコマンド　：　フレーズの長さをストレッチさせる。
    Result := nil;
    skipSpace(sp.ptr);
    sp2 := TSrcPos.Create ;
    spt := TSrcPos.Create ;
    try
        sp2.Assign(sp); spt.Assign(sp); // 現在のタイムポインタを保存
        src := GetNakaKakko(sp);        // ストレッチ範囲の取得
        sp2.SetTempSource( src );
        len := GetNoteLength(sp, CurTrack.Stepmode, CurTrack.Length.GetValue); // デフォルト音長を得る
        //トラックをミュートにする
        tempPtr := CurTrack.TimePtr ;
        tempMute := CurTrack.Mute ;
        CurTrack.Mute := True;
        //トラックの長さを得るために実行
        try
            Compile(sp2);
        except
            raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,spt),['Stretch']);
        end;
        timeCount := CurTrack.TimePtr - tempPtr;
        tempRate := StretchRate ;
        StretchRate := len / timeCount;
        CurTrack.Mute := tempMute;
        //実際に実行
        sp2.SetTempSource( src );
        CurTrack.TimePtr := tempPtr;
        try
            Compile(sp2);
        except
            raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,spt),['Stretch']);
        end;
        CurTrack.TimePtr := tempPtr + len;
        StretchRate := tempRate;
    finally
        sp2.Free ;
        spt.Free ;
    end;
end;

procedure TMmlBase.Eval(src: string);
var
    sp: TSrcPos;
begin
    sp := TSrcPos.Create ;
    try
    try
        sp.fileNo := -1;
        sp.lineNo := 0;
        sp.SetTempSource(src);
        Compile(sp);
    except
      raise; //エラー
    end;
    finally
        sp.Free ;
    end;
end;

function TMmlBase.scriptPlayFrom(var sp: TSrcPos): TMVarCustom;
var
    i: Integer;

    procedure subSysEx;
    begin
        i := GetIntValue(sp);
        SmfSong.PlayFrom.SysEx := (BOOL_TRUE = i);
    end;

    procedure subCC;
    begin
        i := GetIntValue(sp);
        SmfSong.PlayFrom.CC := (BOOL_TRUE = i);
    end;

    procedure subRPN;
    begin
        i := GetIntValue(sp);
        SmfSong.PlayFrom.RPN_NRPN := (BOOL_TRUE = i);
    end;

    procedure subWait;
    begin
        i := GetIntValue(sp);
        SmfSong.PlayFrom.WaitTime := i;
    end;

    //オプション取得
    procedure subOption;
    var s: string;
    begin
        Inc(sp.ptr); // skip '.'
        s := getTokenWord(sp.ptr);
        if s='SysEx'    then subSysEx else
        if s='CtrlChg'  then subCC    else
        if s='RPN_NRPN' then subRPN   else
        if s='Wait'     then subWait  else
        raise EMml.CreateFmt(ErrMsg(MML_ERR_UNKNOWN,sp), [s]);
    end;

begin
    Result := nil;

    //時間指定か？オプションがあるか？
    skipSpace(sp.ptr);
    if sp.ptr^ = '.' then begin subOption; Exit; end;

    //時間指定
    SmfSong.PlayFrom.FromPos := GetTimeValue(sp);
end;

function TMmlBase.GetTimeValue(var sp: TSrcPos): Integer;
var
    s: string;
    sp2: TSrcPos;
    mes,beat,tick: Integer;
begin
    if sp.ptr^ = '(' then //カッコを展開
    begin // 総ステップ or 小節数
        s := GetMaruKakko(sp);

        sp2 := TSrcPos.Create ;
        try
            sp2.Assign(sp);
            sp2.SetTempSource(s);
            if Pos(':',s)>0 then
            begin //小節：拍：ステップ　指定
                mes := GetIntValueAndCalc(sp2);
                skipSpace(sp2.ptr);
                if sp2.ptr^ = ':' then Inc(sp2.ptr);
                beat := GetIntValueAndCalc(sp2);
                skipSpace(sp2.ptr);
                if sp2.ptr^ = ':' then Inc(sp2.ptr);
                tick := GetIntValueAndCalc(sp2);
                Result := TimeToStep(mes,beat,tick);
            end else
            begin//総ステップ指定
                Result := GetIntValueAndCalc(sp2);
            end;
        finally
            sp2.Free ;
        end;
    end else
    begin
        raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    end;
end;

function TMmlBase.GetIntValueAndCalc(var sp: TSrcPos): Integer;
var
    mv: TMVarCustom;
begin
    //if sp.ptr^ = '=' then Inc(sp.ptr);
    mv := getArgAndCalc(sp);
    if (mv=nil){or(mv.ClassType <> TMInt)} then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    Result := mv.IntValue ;
    mv.Free ;
end;

function TMmlBase.scriptPrintTime(var sp: TSrcPos): TMVarCustom;
var
    m: TMTime;
    i: TMVarCustom;
    trk: TTrackInfo ;
begin
    i := nil;
    if sp.ptr^ in ARG_CHAR then
    begin
        i := getArg(sp);
    end;
    if i=nil then trk := CurTrack else trk := SongInfo.GetTrack(i.IntValue);

    m := StepToTime(trk.TimePtr);
    PrintCon(Format('Track(%d);Time(%d:%d:%d);//=%d(PrintTime)',
    [trk.TrackNo,
    m.mes, m.beat, m.tick,
    trk.TimePtr]),sp);
    Result := nil;
end;

function TMmlBase.scriptPrintTrackStatus(var sp: TSrcPos): TMVarCustom;
var
    m: TMTime;
    i: TMVarCustom;
    trk: TTrackInfo ;
    sk: TSmfTrack;
    s: string;
    n: TNoteCC;
begin
    //ほとんど、デバッグ用の命令っすねぇ～～～
    i := nil;
    if sp.ptr^ in ['=','('] then
    begin
        i := getArg(sp);
    end;
    if i=nil then
    begin
        trk := CurTrack;
        sk  := CurSmfTrack ;
    end else begin
        trk := SongInfo.GetTrack(i.IntValue);
        sk  := SmfSong.GetTrack(i.IntValue);
    end;
    m := StepToTime(trk.TimePtr);
    PrintCon(
        Format('Track(%d) Channel(%d) Voice(%d) Time(%d:%d:%d) Time=%d',
        [trk.TrackNo,
        trk.Channel+1,
        trk.Voice,
        m.mes, m.beat, m.tick,
        trk.TimePtr]),sp);
    s := '';
    s := s + 'l%' + IntToStr(trk.Length.GetValue);
    if trk.Stepmode then s := s + '(ステップモード) ' else s := s + '(n分音符モード) ';
    if trk.Qgate.ArrayNote[0].StepMode then
    begin
        s := s + 'q%' + IntToStr(trk.Qgate.GetValue)+ '(ステップモード) '
    end else
    begin
        s := s + 'q' + IntToStr(trk.Qgate.GetValue)+ '(％指定モード) ';
    end;

    s := s + 'v' + IntToStr(trk.Velocity.GetValue)+' ';
    s := s + 't' + IntToStr(trk.Timing.GetValue)+ ' ';
    s := s + 'o' + IntToStr(trk.Octave.GetValue)+ ' ';

    PrintCon(s, sp);

    s := '';
    n := SongInfo.CC[trk.Channel].GetCC(CC_NO_BEND_FULL);
    s := s + Format('Slur(%d,%d) ',[trk.TieMode, trk.TieValue]);
    s := s + Format('BR(%d) PitchBend(%d)',[SongInfo.BendRange[trk.Channel], n.LastValue]);

    PrintCon(s, sp);

    s := '';
    s := s + 'イベント数=' + IntToStr(sk.Count)+' ';
    if trk.Mute then s := s + 'TrackMute(on) ' else s := s + 'TrackMute(off) ';

    PrintCon(s, sp);

    Result := nil;
end;

function TMmlBase.scriptTrackMute(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
begin
    v := getArg(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'(on)か(off)を指定',sp),[sp.cmd]);
    if v.IntValue <> BOOL_FALSE then
    begin // true
        CurTrack.Mute := True;
    end else
    begin
        CurTrack.Mute := False;
    end;
    v.Free;
    Result := nil;
end;

function TMmlBase.scriptTrackSolo(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
    i,no: Integer;
begin
    v := getArgs(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'トラック番号を指定してください。',sp),[sp.cmd]);
    SmfSong.SoloOrMute := 1;
    for i:=0 to TMArray(v).Count -1 do
    begin
        no := TMArray(v).IntItems[i];
        SmfSong.GetTrack(no).MuteTrack := True;
    end;
    v.Free;
    Result := nil;
end;

function TMmlBase.scriptTrackMute2(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
    i,no: Integer;
begin
    v := getArgs(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'トラック番号を指定してください。',sp),[sp.cmd]);
    SmfSong.SoloOrMute := -1;
    for i:=0 to TMArray(v).Count -1 do
    begin
        no := TMArray(v).IntItems[i];
        SmfSong.GetTrack(no).MuteTrack := True;
    end;
    v.Free;
    Result := nil;
end;

function TMmlBase.scriptKeyFlag(var sp: TSrcPos): TMVarCustom;
var
    flag, c: Char;
    src: string;
    m: TMArray;
    i: Integer;

    procedure getFlag;
    var i: Integer;
    begin
        for i:=0 to 6 do SongInfo.KeyFlag[i] := 0; //０で初期化
        for i:=1 to Length(src) do
        begin
            c := src[i];
            if c in ['a'..'g'] then
                case flag of
                '+','#': SongInfo.KeyFlag[Ord(c) - Ord('a')] := 1;
                '-': SongInfo.KeyFlag[Ord(c) - Ord('a')] := -1;
                end;
        end;
    end;

    //メタ情報として、タグを埋め込む
    procedure MetaTag;
    var
        i,cnt: Integer;
        c: TSmfMeta;
    begin
        cnt := 0;
        for i:=0 to 6 do
        begin
            if SongInfo.KeyFlag[i] > 0 then Inc(cnt) else
            if SongInfo.KeyFlag[i] < 0 then Dec(cnt);
        end;

        c := TSmfMeta.Create ;
        c.Event := EVENT_META ;
        c.Time := CurTrack.TimePtr;
        c.MetaType := META_KEY_SIG ;
        SetLength(c.ByteArray, 2);
        if cnt < 0 then
        begin
            c.byteArray[0] := Byte(cnt); //bit7に、1をセット
        end else
        begin
            c.byteArray[0] := Byte(cnt);
        end;
        c.byteArray[1] := 0;
        CurSmfTrack.Add(c); 
    end;

begin
    if sp.ptr^ in ['+','-','#'] then
    begin
        flag := sp.ptr^;
        Inc(sp.ptr);
        src := GetMaruKakko(sp);
        getFlag;
        MetaTag;
    end else
    if sp.ptr^ = '=' then
    begin
        Inc(sp.ptr);
        for i:=0 to 6 do SongInfo.KeyFlag[i] := 0; //０で初期化
        m := getArgs(sp);
        if m<>nil then
        begin
            for i:=0 to 6 do
                SongInfo.KeyFlag[i] := m.IntItems[i];
        end;
        MetaTag;
    end;

    Result := TMArray.Create ;
    for i:=0 to 6 do
        TMArray(Result).IntItems[i] := SongInfo.KeyFlag[i];
end;

function TMmlBase.scriptTimeKeyFlag(var sp: TSrcPos): TMVarCustom;
var
    kf: TTimeKeyFlag;
    sp2: TSrcPos;

    procedure getFromTime;
    begin
        skipSpace(sp2.ptr);
        if sp2.ptr^ = '(' then
        begin
            kf.timeFrom := GetTimeValue(sp2);
        end else
        begin
            kf.timeFrom := CurTrack.TimePtr ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;
    procedure getToTime;
    begin
        if sp2.ptr^ = '(' then
        begin
            kf.timeTo := GetTimeValue(sp2);
        end else
        begin
            kf.timeTo := -1 ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;
    procedure getKeyFlag;
    var m: TMArray; i:Integer;
    begin
        m := getArgs(sp2);
        if m<>nil then
        begin
            for i:=0 to 6 do
                kf.KeyFlag[i] := m.IntItems[i];
        end;
    end;

begin
    skipSpace(sp.ptr);
    if sp.ptr^ <> '(' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    sp2 := TSrcPos.Create ;
    try
        kf := TTimeKeyFlag.Create ;
        sp2.Assign(sp);
        sp2.SetTempSource(GetMaruKakko(sp) );
        //値の読み取り
        getFromTime;
        getToTime;
        getKeyFlag;
        SongInfo.TimeKeyFlag.Add(kf);
    finally
        sp2.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptTimeBase(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    i: Integer;
    t: TTrackInfo;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ['=','('] then
    begin
        v := GetIntValue(sp);
        SmfSong.TimeBase := v ;
        SongInfo.TimeBase := v;
        //(v = 48)or(v=96)or(v=192)or(v=384)or(v=480)or(v=960)then
        if (v<12)or(v>65535) then
        begin
            raise Emml.CreateFmt(ErrMsg(MML_ERR_RANGE_OVER+'48,96,192,480,960などがよく使われます。',sp),['TimeBase']);
        end;
        //SongInfo.ControllerShift := SongInfo.TimeBase div 24; // ver.1.xxのため
        //--------------
        // トラックのlの初期値を書き換える
        for i := 0 to SongInfo.GetTrackCount - 1 do
        begin
          t := SongInfo.GetTrack(i);
          t.Length.ArrayNote[0].Value := SongInfo.TimeBase;
        end;
    end;
    Result := TMInt.Create ;
    TMInt(Result).value := SongInfo.TimeBase ;
end;

function TMmlBase.scriptTimeKey(var sp: TSrcPos): TMVarCustom;
var
    kf: TTimeKey;
    sp2: TSrcPos;

    procedure getFromTime;
    begin
        skipSpace(sp2.ptr);
        if sp2.ptr^ = '(' then
        begin
            kf.timeFrom := GetTimeValue(sp2);
        end else
        begin
            kf.timeFrom := CurTrack.TimePtr ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;
    procedure getToTime;
    begin
        if sp2.ptr^ = '(' then
        begin
            kf.timeTo := GetTimeValue(sp2);
        end else
        begin
            kf.timeTo := -1 ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;

    procedure getKey;
    begin
        kf.key := GetIntValueAndCalc(sp2);
    end;

begin
    skipSpace(sp.ptr);
    if sp.ptr^ <> '(' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    sp2 := TSrcPos.Create ;
    try
        kf := TTimeKey.Create ;
        sp2.Assign(sp);
        sp2.SetTempSource(GetMaruKakko(sp) );
        //値の読み取り
        getFromTime;
        getToTime;
        getKey;
        SongInfo.TimeKey.Add(kf);
    finally
        sp2.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptTieMode(var sp: TSrcPos): TMVarCustom;
var
    v: TMArray ;
begin
    v := getArgs(sp);
    if (v=nil)or(v.Count < 1) then raise EMml.CreateFmt( ErrMsg(MML_ERR_ARG,sp),['TieMode'] );
    CurTrack.TieMode := v.IntItems[0];
    if v.Count >= 2 then
    begin
        CurTrack.TieValue := v.IntItems[1];
    end;
    if v.Count >= 3 then //ベンドレンジ強制指定
    begin
        SongInfo.BendRange[CurTrack.Channel] := v.IntItems[2];
    end;
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.TieMode ;
end;

procedure TMmlBase.WritePicthBend(time,value: Integer);
var
    v: Integer;
    ccc: TSmfPitchBend ;
    n: TNoteCC;
begin
    v := Max(-8192, Min(8191, value));

    //-------------------------------------------------------
    //BENDの指定種類に関係なく、オプションをオフにセット
    //-------------------------------------------------------
    //BEND-MIN
    n := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND);
    n.noteOnType := noteNormal ;
    n.Time := time ;
    n.No := CC_NO_BEND;
    n.LastValue := (v+8192) div 128;
    n.FIndex := 0;

    //BEND-FULL
    n := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_BEND_FULL);
    n.noteOnType := noteNormal ;
    n.Time := time ;
    n.No := CC_NO_BEND_FULL;
    n.LastValue := v;
    n.FIndex := 0;
    //-------------------------------------------------------

    if (CurTrack.CCMute = False)and(CurTrack.CCNoMute[n.No] = False) then
    begin
      //トラックへ無駄に書き込まれるコントロールチェンジをトリムする(ver.2.32以降)
      DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, CC_NO_BEND, time, False);

      //SMFに書き込む
      ccc := TSmfPitchBend.Create ;
      ccc.Time := time ;
      ccc.Event := EVENT_PITCH_BEND or CurTrack.Channel ;
      ccc.Value := v;
      CurSmfTrack.Add(ccc);
    end;
end;

procedure TMmlBase.WriteCCNoteOnTimeDirect(ccNo, time, fromValue, toValue,
  Len: Integer);
var
    ncc: TNoteCC;
    temp: Integer;
begin
    ncc := SongInfo.CC[CurTrack.Channel].GetCC(ccNo);
    ncc.Time := time ;
    ncc.noteOnType := noteOnTime ;
    ncc.No := ccNo ;
    ncc.reserve := TMArray.Create ;
    ncc.reserve.AddInt(fromValue);
    ncc.reserve.AddInt(toValue);
    ncc.reserve.AddInt(Len);
    temp := CurTrack.TimePtr ;
    CurTrack.TimePtr := time;

    WriteCCWave(ncc, CurSmfTrack, len, CurTrack.Channel);
    CurTrack.TimePtr := temp;
    ncc.noteOnType := noteNormal ;
end;

function TMmlBase.GetNowTimeKey(no: Integer): Integer;
var
  i: Integer; kf: TTimeKey; tp: Integer;
  lst: TList;
begin
    Result := MaxInt;
    tp := CurTrack.TimePtr ;

    if (no=0) then
    begin
      lst := SongInfo.TimeKey;
    end else
    if (no=1) then
    begin
      lst := SongInfo.TimeKey2;
    end else
      raise Exception.Create('GetNowTimeKey で 未定義の TimeKey 番号');

    for i := (lst.Count -1) downto 0 do
    begin
        kf := lst.Items[i];
        if kf.timeTo > 0 then
        begin
            if (kf.timeFrom <= tp)and(tp < kf.timeTo) then
            begin
                Result := kf.key ;
                Break;
            end;
        end else
        begin
            if (kf.timeFrom <= tp) then
            begin
                Result := kf.key;
                Break;
            end;
        end;
    end;
end;

function TMmlBase.scriptEnd(var sp: TSrcPos): TMVarCustom;
begin
    //FlagStopCompile := True;
    Inc(FuncBreak,1);
    sp.ptr^ := #0;
    sp.ptr^ := #0;
    Result := nil;
end;

function TMmlBase.scriptMsgBox(var sp: TSrcPos): TMVarCustom;
var
    v: TMArray;
    s: string;
begin
    v := getArgs(sp) ;
    try
        if v=nil then
        begin
            s := 'nil';
            MessageBox(0, PChar(s),'メッセージ',MB_OK);
        end else
        begin
            s := v.StrValue;
            MessageBox(0, PChar(s),'メッセージ',MB_OK);
        end;
    finally
        v.Free ;
    end;
    Result := nil;
end;

function TMmlBase.scriptASC(var sp: TSrcPos): TMVarCustom;
var
    mv: TMVarCustom ;
    s: string;
    sp2: TSrcPos;
begin
    Result := TMInt.Create ;

    sp2 := TSrcPos.Create ;
    try
      sp2.SetTempSource(GetKakko(sp.ptr));
      mv := getArgAndCalc(sp2);
    finally
      sp2.Free ;
    end;

    if mv<>nil then
    begin
      s := mv.StrValue ;
    end;
    if s='' then
    begin
        TMInt(Result).value := 0; Exit;
    end;
    if s[1] in LeadBytes then
    begin
        TMInt(Result).value := (Ord(s[1]) shl 8)or Ord(s[2]);
    end else
    begin
        TMInt(Result).value := Ord(s[1]);
    end;
end;

function TMmlBase.scriptMID(var sp: TSrcPos): TMVarCustom;
var
    mv: TMArray ;
    s: string;
begin
    Result := TMStr.Create ;;
    mv := getArgsWithType(sp,'sii');
    if mv<>nil then s := mv.StrValue ;
    if s='' then
    begin
        TMStr(Result).value := ''; Exit;
    end;
    TMStr(Result).value := JCopy(
        mv.Items[0].StrValue,
        mv.Items[1].IntValue,
        mv.Items[2].IntValue);
end;

function TMmlBase.scriptReplace(var sp: TSrcPos): TMVarCustom;
var
    mv: TMArray ;
    s: string;
begin
    Result := TMStr.Create ;;
    mv := getArgsWithType(sp,'sssi');
    if mv<>nil then s := mv.StrValue ;
    if s='' then
    begin
        TMStr(Result).value := ''; Exit;
    end;
    TMStr(Result).value := JReplace(
        mv.Items[0].StrValue,
        mv.Items[1].StrValue,
        mv.Items[2].StrValue,
        (1=mv.Items[3].IntValue));
end;

function TMmlBase.scriptPlayTo(var sp: TSrcPos): TMVarCustom;
begin
    Result := nil;
    //時間指定
    SmfSong.PlayFrom.ToPos := GetTimeValue(sp);
end;

function TMmlBase.GetNoteNo(var sp: TSrcPos; NoteName: Char; UseKeyShift: Boolean): Integer;
var
    nn: Integer;
    mv: TMVarCustom;
    f: Char;

    function UseTimeKeyFlag : Boolean;
    var i: Integer; kf: TTimeKeyFlag; tp: Integer;
    begin
        Result := False;
        tp := CurTrack.TimePtr ;
        for i := (SongInfo.TimeKeyFlag.Count -1) downto 0 do
        begin
            kf := SongInfo.TimeKeyFlag.Items[i];
            if kf.timeTo > 0 then
            begin
                if (kf.timeFrom <= tp)and(tp < kf.timeTo) then
                begin
                    Result := True;
                    Inc(nn, kf.KeyFlag[Ord(NoteName) - Ord('a')]);
                    Break;
                end;
            end else
            begin
                if (kf.timeFrom <= tp) then
                begin
                    Result := True;
                    Inc(nn, kf.KeyFlag[Ord(NoteName) - Ord('a')]);
                    Break;
                end;
            end;
        end;
    end;

    function UseTimeKey: Boolean;
    var i1,i2: Integer;
    begin
        i1 := GetNowTimeKey(0) ;
        i2 := GetNowTimeKey(1) ;
        if (i1=MaxInt)and(i2=MaxInt) then begin
            Result := False;
            Exit;
        end;
        Result := True;
        if(i1 <> MaxInt)then Inc(nn, i1);
        if(i2 <> MaxInt)then Inc(nn, i2);
    end;

begin
    if NoteName='n' then
    begin
        mv := getArg(sp);
        if (mv=nil)or(mv.ClassType <> TMInt) then
                raise EMml.CreateFmt(ErrMsg(MML_ERR_CANT_READ_INT_VALUE,sp),[sp.cmd]);
        nn := mv.IntValue ;
        if sp.ptr^=',' then Inc(sp.ptr);
    end else
    begin
        //NoteNo のテーブルよりフラットな値を得る
        nn := NOTE_NO_TABLE[ Ord(NoteName) - Ord('a') ];

        //さらに臨時記号を適用するか？
        if sp.ptr^ = '*' then
        begin
            f := '*';
            Inc(sp.ptr);
        end else begin
            f := #0;
        end;

        while True do
        begin
            if sp.ptr^ in ['#','+'] then
                Inc(nn)
            else if sp.ptr^ = '-' then
                Dec(nn)
            else
                Break;
            Inc(sp.ptr);
        end;

        //キーフラグを適用するか？
        if sp.ptr^ = '*' then//フラット
        begin
            Inc(sp.ptr);
        end else
        begin //キーフラグの適用
            if f<>'*' then
            begin
                if UseTimeKeyFlag=False then//タイム強制のキーフラグ(TimeKeyFlag)を使うか？
                begin//使わないときは、KeyFlagの値を適用する
                    Inc(nn, SongInfo.KeyFlag[Ord(NoteName)-Ord('a')]);
                end;
            end;
        end;

    end;

    if UseKeyShift and SongInfo.UseKeyShift then
    begin
        //システム全体の Key
        UseTimeKey; //if UseTimeKey=False then // ... ver2.35 で修正 ... 要望により TimeKey と Key 両方を有効にする
        begin //通常のKeyshift
            Inc(nn, SongInfo.Keyshift);
            //トラックごとの Key
            Inc(nn, CurTrack.Key);
        end;
    end;

    Result := nn;
end;

function TMmlBase.scriptTrackKey(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ARG_CHAR then
    begin //代入
        v :=GetIntValue(sp);
        CurTrack.Key := v;
    end;
    //カレントトラックの番号を返す
    Result := TMInt.Create ;
    TMInt(Result).value := CurTrack.Key ;
end;

function TMmlBase.scriptUseKeyShift(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
begin
    skipSpace(sp.ptr);
    if sp.ptr^ in ARG_CHAR then
    begin //代入
        v :=GetIntValue(sp);
        SongInfo.UseKeyShift := (v<>0);
    end;
    //カレントトラックの番号を返す
    Result := TMInt.Create ;
    TMInt(Result).value := Ord(SongInfo.UseKeyShift) ;
end;

function TMmlBase.scriptHEX(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom ;
    i: Integer;
    s: string;
begin
    v := getArg(sp);
    Result := TMStr.Create ;
    if v<>nil then
    begin
      if v.ClassType = TMArray then
      begin
        s := '';
        for i:=0 to TMArray(v).Count -1 do
        begin
          s := s + '$' + IntToHex( TMArray(v).IntItems[ i ], 2 ) + ', ';
        end;
        if s<>'' then s := Copy(s,1,Length(s)-2); //後ろの', ' を削除
        TMStr(Result).value := s;
      end else
      begin
        TMStr(Result).value := '$'+IntToHex(v.IntValue,2) ;
      end;
    end;
end;

function TMmlBase.scriptVarType(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom ;
begin
    v := getArg(sp);
    Result := TMStr.Create ;
    if v<>nil then
    begin
      if v.ClassType = TMArray then TMStr(Result).value := 'Array' else
      if v.ClassType = TMStr   then TMStr(Result).value := 'Str' else
      if v.ClassType = TMInt   then TMStr(Result).value := 'Int' else;
    end else
    begin
      TMStr(Result).value := '';
    end;
end;

function TMmlBase.funcQgate2(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
begin
    Result := nil;
    skipSpace(sp.ptr);
    v :=GetIntValue(sp);
    CurTrack.Q2 := v;
end;


function TMmlBase.scriptArgOrder(var sp: TSrcPos): TMVarCustom;
var
  s: string;
begin
  Result := nil;
  s := GetMaruKakko(sp);
  CurTrack.ArgOrder := s;
end;

function TMmlBase.scriptAllowMultiLine(var sp: TSrcPos): TMVarCustom;
var
  s: string;
begin
  Result := nil;
  s := GetMaruKakko(sp);
  SongInfo.AllowMuliLine := (s <> '0');
end;


function TMmlBase.scriptPos(var sp: TSrcPos): TMVarCustom;
var
    mv: TMArray ;
    s: string;
begin
    Result := TMInt.Create ;;
    mv := getArgsWithType(sp,'ss');
    if mv<>nil then s := mv.StrValue ;
    if s='' then
    begin
        TMInt(Result).value := 0; Exit;
    end;
    TMInt(Result).value := JPosEx(
        mv.Items[0].StrValue,
        mv.Items[1].StrValue,0);
end;

function TMmlBase.scriptTimeKey2(var sp: TSrcPos): TMVarCustom;
var
    kf: TTimeKey;
    sp2: TSrcPos;

    procedure getFromTime;
    begin
        skipSpace(sp2.ptr);
        if sp2.ptr^ = '(' then
        begin
            kf.timeFrom := GetTimeValue(sp2);
        end else
        begin
            kf.timeFrom := CurTrack.TimePtr ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;
    procedure getToTime;
    begin
        if sp2.ptr^ = '(' then
        begin
            kf.timeTo := GetTimeValue(sp2);
        end else
        begin
            kf.timeTo := -1 ;
        end;
        skipSpace(sp2.ptr);
        if sp2.ptr^ = ',' then Inc(sp2.ptr);
    end;

    procedure getKey;
    begin
        kf.key := GetIntValueAndCalc(sp2);
    end;

begin
    skipSpace(sp.ptr);
    if sp.ptr^ <> '(' then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
    sp2 := TSrcPos.Create ;
    try
        kf := TTimeKey.Create ;
        sp2.Assign(sp);
        sp2.SetTempSource(GetMaruKakko(sp) );
        //値の読み取り
        getFromTime;
        getToTime;
        getKey;
        SongInfo.TimeKey2.Add(kf);
    finally
        sp2.Free ;
    end;
    Result := nil;
end;


function TMmlBase.scriptTempoChange(var sp: TSrcPos): TMVarCustom;
//テンポを推移的に変更する
var
  ary: TMArray;
  i, cnt, t1, t2, len, tm, tstep,v: Integer;
  a: Extended;
begin
  Result := nil;

  ary := getArgs(sp);
  case ary.Count of
    1:
      begin
        t1  := SongInfo.Tempo ;
        t2  := ary.IntItems[0];
        len := SongInfo.TimeBase * 4;
      end;
    2:
      begin
        t1  := SongInfo.Tempo ;
        t2  := ary.IntItems[0];
        len := ary.IntItems[1];
      end;
    3:
      begin
        t1  := ary.IntItems[0];
        t2  := ary.IntItems[1];
        len := ary.IntItems[2];
      end;
    else
      raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),[sp.cmd]);
  end;

  tstep := Trunc(SongInfo.TimeBase / 4); // 16分音符単位で書き込み
  cnt := Trunc(len / tstep);
  a   := (t2 - t1) / cnt;

  tm := CurTrack.TimePtr ;
  for i := 0 to cnt - 2 do
  begin
    v := Trunc(i * a + t1);
    WriteTempo(i * tstep + tm, v);
  end;
  WriteTempo(tm + len, t2);
end;

procedure TMmlBase.WriteTempo(time, value: Integer);
var
  meta: TSmfTempo ;
begin
  SongInfo.Tempo := value;

  meta := TSmfTempo.Create ;
  meta.Time := time ;
  meta.SetTempo(SongInfo.Tempo);

  //テンポトラックは、0 に持ってくるべし
  SmfSong.GetTrack(0).Add(meta);
end;

function TMmlBase.scriptExpressionChange(var sp: TSrcPos): TMVarCustom;
//EPを推移的に変更する
begin
  Result := nil;
  cresc_sub(40,127, sp);
end;

function TMmlBase.scriptExpressionChangeDecresc(var sp: TSrcPos): TMVarCustom;
begin
  Result := nil;
  cresc_sub(127,40, sp);
end;

procedure TMmlBase.cresc_sub(def1,def2: Integer; var sp: TSrcPos);
//(len),(v1),(v2)
var
  ary: TMArray;
  i, cnt, t1, t2, len, tm, tstep,v,ov: Integer;
  a: Extended;
  cc: TNoteCC;
begin
  // EPを取得
  cc := SongInfo.CC[CurTrack.Channel].GetCC(CC_NO_EXPRESSION);
  if cc.LastValue < -1 then cc.LastValue := 127;

  // 音の長さを取得
  if sp.ptr^ = '=' then Inc(sp.ptr);
  len := GetNoteLength(sp,CurTrack.Stepmode, -1);
  if len<=0 then len := SongInfo.TimeBase * 4; // 諸略されたら、全音符で指定。

  // 引数を取得
  skipSpace(sp.ptr);
  if sp.ptr^ = ',' then
  begin
    Inc(sp.ptr);
    ary := getArgs(sp);
    try
      case ary.Count of
        0:
          begin
            t1 := def1 ;
            t2 := def2; //Cresc
          end;
        1:
          begin
            t1 := cc.LastValue ;
            t2 := ary.IntItems[0];
          end;
        else // cnt >= 2
          begin
            t1 := ary.IntItems[0];
            t2 := ary.IntItems[1];
          end;
      end;
    finally
      ary.Free ;
    end;
  end else
  begin
    t1 := def1 ;
    t2 := def2; //Cresc
  end;


  // 推移値を計算
  tstep := SongInfo.CCFreq; // 書き込み頻度をチェック
  cnt := Trunc(len / tstep);
  a   := (t2 - t1) / cnt;

  tm := CurTrack.TimePtr ;
  ov := -1;
  for i := 0 to cnt - 2 do
  begin
    v := Trunc(i * a + t1);
    v := Max(0, Min(127, v));
    if ov<> v then
      CurSmfTrack.WriteControlChange((i * tstep + tm), CurTrack.Channel, CC_NO_EXPRESSION, v);
    ov := v;
  end;
  // 最後に帳尻合わせをする
  CurSmfTrack.WriteControlChange((tm+len), CurTrack.Channel, CC_NO_EXPRESSION, t2);
  cc.LastValue := t2;
end;

procedure TMmlBase.DeleteCCAfterTime(track: TSmfTrack; ch, ccNo, time: Integer; CompleteDelete: Boolean);
var
  i: Integer;
  n: TSmfCustomNode; cc: TSmfControlChange;
  des_event: Byte;
begin
  // 完全に削除するわけではなく、直前のCCに対してこの機能を有効にするかどうか
  if CompleteDelete then
  begin
    track.Sort ;
  end;

  // 削除するイベントタイプを調べる
  if (ccNo = CC_NO_BEND)or(ccNo = CC_NO_BEND_FULL) then
  begin
    des_event := ch or EVENT_PITCH_BEND ;
  end else
  begin
    des_event := ch or EVENT_CONTROL_CHANGE ;
  end;

  // 削除対象イベントを、トラックの後ろ側から検査し、削除していく
  i := track.Count - 1;
  while i >= 0 do
  begin
    // 指定タイム以前なら抜ける
    n := track.Items[i];

    if n.Event = des_event then // CCか？
    begin
      if ccNo < 128 then
      begin
        cc := TSmfControlChange(n);
        if cc.No = ccNo then // 指定の CC No か ?
        begin
          if n.Time < time then Break;
          track.Delete(i); // 削除
        end;
      end else
      begin // ベンド
        if n.Time < time then Break;
        track.Delete(i); // 削除
      end;
    end;
    Dec(i);
  end;

end;

function TMmlBase.scriptDeleteCC(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
begin
    v := GetIntValue(sp);
    if v<0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['DeleteCC']);
    DeleteCCAfterTime(CurSmfTrack, CurTrack.Channel, v, CurTrack.TimePtr, True); 
    Result := nil;
end;

function TMmlBase.scriptPosEx(var sp: TSrcPos): TMVarCustom;
var
    mv: TMArray ;
    s: string;
begin
    Result := TMInt.Create ;;
    mv := getArgsWithType(sp,'ssi');
    if mv<>nil then s := mv.StrValue ;
    if s='' then
    begin
        TMInt(Result).value := 0; Exit;
    end;
    TMInt(Result).value := JPosEx(
        mv.Items[0].StrValue,
        mv.Items[1].StrValue,
        mv.Items[2].IntValue);
end;

function TMmlBase.scriptCCMute(var sp: TSrcPos): TMVarCustom;
var
    v: TMVarCustom;
begin
    v := getArg(sp);
    if v=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG+'(on)か(off)を指定',sp),[sp.cmd]);
    if v.IntValue <> BOOL_FALSE then
    begin // true
        CurTrack.CCMute := True;
    end else
    begin
        CurTrack.CCMute := False;
    end;
    v.Free;
    Result := nil;
end;

function TMmlBase.scriptArraySortNum(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['SortNum']);
    if ary.Count = 0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Random']);

    ary.SortNum ;
    Result := ary.clone ;
end;

function TMmlBase.scriptArraySortStr(var sp: TSrcPos): TMVarCustom;
var
    ary: TMArray;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['SortStr']);
    if ary.Count = 0 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['Random']);

    ary.SortStr ;
    Result := ary.clone ;
end;

function TMmlBase.scriptCCNoMute(var sp: TSrcPos): TMVarCustom;
var
    ary  : TMArray;
    v1,v2: TMVarCustom;
begin
    ary := getArgs(sp);
    if ary=nil then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['CCNoMute']);
    if ary.Count < 2 then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['CCNoMute']);

    v1 := ary.Items[0];
    v2 := ary.Items[1];

    if (v1.IntValue < 0)or(v1.IntValue > 127) then raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['CCNoMute']);

    CurTrack.CCNoMute[v1.IntValue] := (v2.IntValue <> 0);

    { debug:::
    if CurTrack.CCNoMute[v1.IntValue] <> (v2.IntValue <> 0) then
    begin
      MessageBox(0, 'err','err',MB_OK);
    end;
    }

    Result := nil;
end;

function TMmlBase.scriptSwitch(var sp: TSrcPos): TMVarCustom;
var
    SwitchStruct: TMStruct ;
    JoukenValue, CaseValue: TMVarCustom;
    token, caseJouken: string;
    casePos : TSrcPos;
begin
    //todo: switch
    Result := nil;
    SwitchStruct := TMStruct.Create(Structs, stSwitch);

    //条件式を得る
    SwitchStruct.Jouken := getMaruKakko(sp);
    skipSpaceReturn(sp.ptr, sp.lineNo);

    //Switchの範囲開始位置を得る
    if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('Switch の後に "{" がありません。',sp));
    SwitchStruct.PosFrom.Assign(sp);
    Inc(SwitchStruct.PosFrom.ptr); // skip '{'

    //範囲終了位置を得る
    skipKakko(sp.ptr, sp.lineNo, '{','}');
    SwitchStruct.PosTo.Assign(sp);

    //条件式を評価
    sp.lineNo := SwitchStruct.PosFrom.lineNo ;
    sp.ptr := PChar( SwitchStruct.Jouken );
    JoukenValue := getArgAndCalc(sp);

    //CASE を拾って条件にあう文を選ぶ
    sp.Assign( SwitchStruct.PosFrom );
    while sp.ptr^ <> #0 do
    begin
      skipSpaceReturn(sp.ptr, sp.lineNo);

      // 条件を得る
      token := UpperCase( getTokenMML(sp.ptr) );
      if token = 'DEFAULT' then
      begin
        // 無条件にこの後の文を実行する
        if sp.ptr^ = '{' then Inc(sp.ptr);
        Break;
      end else
      if token = '}' then
      begin
        // 結局何も実行しなかったとき
        Inc(sp.ptr); // skip '}'
        SwitchStruct.Free;
        Exit; // *** 
      end else
      if token <> 'CASE' then raise EMml.Create(ErrMsg('SWITCHの中ではCASEかDEFAULTを記述してください。',sp));
      caseJouken := GetMaruKakko(sp);
      if sp.ptr^ <> '{' then raise EMml.Create(ErrMsg('CASE(条件) の後に "{" がありません。',sp));

      casePos := TSrcPos.Create;
      try
        casePos.Assign(sp);
        casePos.ptr := sp.ptr;
        // CASE を評価
        sp.lineNo := casePos.lineNo; sp.ptr := PChar( caseJouken );
        CaseValue := getArgAndCalc(sp);

        if CaseValue.StrValue = JoukenValue.StrValue then
        begin
          // CASE の中を実行
          sp.Assign(casePos);
          Inc(sp.ptr); // skip '{'
          Break;
        end else
        begin
          // 次のCASEへ進める
          sp.Assign(casePos);
          skipKakko(sp.ptr, sp.lineNo, '{','}');
        end;

      finally
        casePos.Free;
      end;
    end;

    //付け替え
    Structs := SwitchStruct;
    Commands := Structs.varHash ;
end;

function TMmlBase.scriptVersion(var sp: TSrcPos): TMVarCustom;
begin
  // バージョン情報の表示
  Result := TMInt.Create;
  TMInt(Result).value := VER_NUMBER;
end;

function TMmlBase.scriptCHR(var sp: TSrcPos): TMVarCustom;
var
    mv: TMVarCustom ;
    i: Integer;
    sp2: TSrcPos;
begin
    Result := TMStr.Create ;

    sp2 := TSrcPos.Create ;
    try
      sp2.SetTempSource(GetKakko(sp.ptr));
      mv := getArgAndCalc(sp2);
    finally
      sp2.Free ;
    end;

    if mv<>nil then
    begin
      i := mv.IntValue ;
    end else
    begin
      raise EMml.CreateFmt(ErrMsg(MML_ERR_ARG,sp),['CHR']);
    end;

    if (i >= 0)and(i <= $7F) then
    begin
        TMStr(Result).value := CHR(i);
    end else
    begin
      // 漢字コードあり
      TMStr(Result).value := CHR((i shr 8)and $FF) + CHR(i and $FF);
    end;
end;

function TMmlBase.scriptKeyPress(var sp: TSrcPos): TMVarCustom;
var
    v: Integer;
    kp: TSmfKeyPressure;
begin
    Result := nil;

    v := GetIntValue(sp); //値を得る
    skipSpace(sp.ptr);

    //smfに書き込む
    kp := TSmfKeyPressure.Create;
    kp.Time := CurTrack.TimePtr;
    kp.Event := EVENT_KEY_PRESSURE or CurTrack.Channel;
    kp.NoteNo := CurSmfTrack.LastNodeNo;
    kp.velocity := v;
    CurSmfTrack.Add(kp);
end;

function TMmlBase.scriptMetaTextEOL(var sp: TSrcPos): TMVarCustom;
var
  s: string;
begin
  Result := nil;
  s := GetMaruKakko(sp);
  SongInfo.MetaTextEOL := StrToIntDef(s, 0);
end;

end.
