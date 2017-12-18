unit mml_const;
{-------------------------------------------------------------------------------
ソフト：テキスト音楽「サクラ」
作　者：クジラ飛行机 https://sakuramml.com
説　明：サクラで用いる定数を定義したユニット
s
履　歴：

2002/06/03 15:13 雛型作成
-------------------------------------------------------------------------------}

interface

uses
  Windows,
  SysUtils,
  Classes;

const
    ENZANSI_CHAR     = ['+','-','*','/','%','<','>','=','|','&','^','!'];      //※ '^' は、タイ記号なので注意
    ENZANSI_NEXT_CHAR = ['<','>','=','|','&','!'];
    ARG_CHAR         = ['=','(','$','0'..'9','!','{'];
    USER_DEFINE_CHAR = ['!','%','(',')','\','/','=','*','?'];  //ユーザーが定義できる記号

    BOOL_TRUE = 1; // 基本的に、0 以外は、TRUEと見なす
    BOOL_FALSE = 0;

    VAR_TYPE_INT = 'i';
    VAR_TYPE_STR = 's';
    VAR_TYPE_ARRAY= 'a';

    //特定音源の番号
    SOUND_TYPE_GM = 0;
    SOUND_TYPE_GS = 1;
    SOUND_TYPE_XG = 2;

    //WAVE_TYPE 先行指定で
    WAVE_TYPE_LINE = 0;
    WAVE_TYPE_SINE = 1;

    // Note No TABLE
    //  9 11  0  2  4  5  7
    //  a  b  c  d  e  f  g
    NOTE_NO_TABLE: array [0..6] of Integer = (9,11,0,2,4,5,7);

    //先行指定のコマンド名
    {先行指定}
    OPTION_ON_NOTE   = 'onNote'; //(命令).onNote(v1,v2,v3...)//ノートオン毎の値の先行指定
    OPTION_ON_NOTE2  = 'N';//(命令).N(v1,v2,v3...)//ノートオン毎の値の先行指定
    OPTION_ON_TIME   = 'onTime';//(命令).onTime(low,high,len...)//指定時間毎の値の推移的先行指定。
    OPTION_ON_TIME2  = 'T';//(命令).T(low,high,len, low,high,len...)//指定時間毎の値の推移的先行指定
    OPTION_CC_SINE   = 'Sine';//(命令).Sine(type,low,high,len,times)//コントロールチェンジの連続値書き込み命令type=0:sine/1:up sine/2:down sine
    OPTION_ON_SINE   = 'onNoteSine';//(命令).onNoteSine(type,low,high,len,times)//ノートオン毎にコントロールチェンジの連続値書き込み命令 type=0:sine/1:up sine/2:down sine
    OPTION_ON_CYCLE  = 'onCycle';//(命令).onCycle(len,v1,v2,v3...)//指定時間毎の値の先行指定
    OPTION_ON_CYCLE2 = 'C';//(命令).C(len,v1,v2,v3...)//指定時間毎の値の先行指定
    OPTION_ON_WAVE   = 'onNoteWave';//(命令).onNoteWave(low,high,len...)//ノートオン毎に直線的な値の推移を書き込む(コントロールチェンジ,ベンド)
    OPTION_ON_WAVE2  = 'W';//(命令).W(low,high,len...)//ノートオン毎に直線的な値の推移を書き込む(コントロールチェンジ,ベンド)
    OPTION_ON_WAVE_EX= 'onNoteWaveEx';//(命令).W(low,high,len...)//ノートオン毎に、ノートの長さに応じた波形を書き込む(コントロールチェンジ,ベンド)
    OPTION_ON_WAVE_EX2= 'WE';//(命令).W(low,high,len...)//ノートオン毎に、ノートの長さに応じた波形を書き込む(コントロールチェンジ,ベンド)
    OPTION_ON_WAVE_R =  'onNoteWaveR';//(命令).onNoteWaveR(low,high,len...)//ノートオンしている間、low,higi,len...を繰り返す
    OPTION_ON_WAVE_R2=  'WR';//(命令).WR(low,high,len...)//ノートオンしている間、low,higi,len...を繰り返す
    OPTION_DELAY     = 'Delay';//(命令).Delay=v//先行指定の効果の遅延時間
    OPTION_REPEAT    = 'Repeat';//(命令).Repeat(on/off)//予約指定で.onNoteなどで繰り返すかどうか
    OPTION_RANDOM    = 'Random';//(命令).Random=v//書き込まれる値に、vのランダムな値を足す
    OPTION_RANGE     = 'Range';//(命令).Range(low,high)//書き込まれる値に、上限と下限を設定する
    OPTION_FREQUENCY = 'Frequency';//(命令).WR(low,high,len...)//コントロールチェンジの書き込み頻度を指定する
    OPTION_MAX       = 'Max';//q.Max|v.Max//qやvの最大値を変更する
    {/先行指定}

    //タイモード
    TIE_PORT         = 0;//ノートオンを、ポルタメントでつなぐ
    TIE_BEND         = 1;//ノートオンを、ベンドでつなぐ
    TIE_GATE         = 2;//ノートオンのゲートを100%にする
    TIE_ALP          = 3;//どんどん重なる

    BEND_RANGE_MAX = 12;//ベンドレンジの最大値は、１２とする(GMレベル)

    //特殊コントロールチェンジ
    CC_NO_BEND      = 257;
    CC_NO_BEND_FULL = 256;

    //CC
    CC_NO_VOLUME     = 7;
    CC_NO_EXPRESSION = 11;
    CC_NO_PANPOT     = 10;
    CC_NO_REVERB     = 91;

implementation

end.
