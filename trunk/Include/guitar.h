//------------------------------------------------------------------------------ Header.
/*
           		     ギターストローク用関数[guitar.h]
										製作者；ひまんちゅ
//------------------------------------------------------------------------------
								
◆使い方

Include(guitar.h)
の一文を文頭にお書き下さい。

◆書式

コード名(ST,LEN)

・コード名について
コード名を書き入れます。
使用しているコードは次のページをご覧下さい。

また、
＃はp、♭はbで表現します。
また、ハイコード、バレーコードで使う時はご連絡下さい。
フレット数を教えていただければ増築致します。

・STについて

音のばらし方を定義する数値です。
STを負の値にするとアップストローク、正の値にするとダウンストロークが表現できます。
STの絶対値を大きくすれば音のばらつきが大きくなります。
ちなみにSTを０にすると、同時発音となり、[Chord2.h]と同じ働きをします

・Lenについて
	LEN	コードの長さをn分音符形式で書きます。省略も出来ます。 

◆使い方の例
	ＣＭ７　 (ダウンストローク、８分音符)なら、		⇒ CM7(1,8)
	Ｄ＃ｍ　 (ゆっくりなアップストローク、16分音符)なら、	⇒ Dpm(-4,16)
	Ｂ♭add9 (アップストローク、全音符)なら、			⇒ Bbadd9(-2,1)
	Ｅ＃7-5  (ゆっくりダウンストローク、２分音符)なら、	⇒ Ep7b5(5,2)
	
と書きます。必ず、半角文字を使ってください。

コードフォーム参照URL
http://www.ishibashi.co.jp/academic/Chord_Guitar/Guitar_Chord.htm
http://www.ady.co.jp/song-chord/chorditiran.htm

//------------------------------------------------------------------------------
更新履歴
2004/6/28	Test公開
2004/8/21	Test公開ver2。dimの前まで。
2004/8/23	[guitar.h]始動。
*/
//major-------------------------------------------------------------------------
Function C(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*e*g*>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cp(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+>c*+f*g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Db(Int ST,Str LEN){Cp(ST,LEN)}
Function D(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>d*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dp(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>d*+g*a*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Eb(Int ST,Str LEN){Dp(ST,LEN)}
Function E(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>e*g*+b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function F(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*>c*f*a*>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fp(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+>c*+f*+a*+>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gb(Int ST,Str LEN){Fp(ST,LEN)};
Function G(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*b*>d*g*b*>g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gp(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*+g*+>c*d*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ab(Int ST,Str LEN){Gp(ST,LEN)};
Function A(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*a*>c*+e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ap(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*a*+>d*e*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bb(Int ST,Str LEN){Ap(ST,LEN)};
Function B(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+b*>d*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//minor-------------------------------------------------------------------------
Function Cm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*g*>c*e*-g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cpm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+>c*+e*g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dbm(Int ST,Str LEN){Cpm(ST,LEN)}
Function Dm(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>d*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dpm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>d*+f*+a*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ebm(Int ST,Str LEN){Dpm(ST,LEN)}
Function Em(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>e*g*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*>c*f*a*->c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fpm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+>c*+f*+a*>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gbm(Int ST,Str LEN){Fpm(ST,LEN)};
Function Gm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>d*g*b*>d*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gpm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*+g*+>c*d*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Abm(Int ST,Str LEN){Gpm(ST,LEN)};
Function Am(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*a*>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Apm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*a*+>c*+e*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bbm(Int ST,Str LEN){Apm(ST,LEN)};
Function Bm(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+b*>d*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//7th---------------------------------------------------------------------------
Function C7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*e*a*+>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cp7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+b*>e*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Db7(Int ST,Str LEN){Cp7(ST,LEN)}
Function D7(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>c*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dp7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>c*+g*a*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Eb7(Int ST,Str LEN){Dp7(ST,LEN)}
Function E7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>d*g*+b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function F7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*>c*d*+a*>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fp7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+>c*+e*a*+>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gb7(Int ST,Str LEN){Fp7(ST,LEN)};
Function G7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*b*>d*g*b*>f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gp7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*+f*+>c*d*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ab7(Int ST,Str LEN){Gp7(ST,LEN)};
Function A7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*g*>c*+e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ap7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*g*+>d*e*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bb7(Int ST,Str LEN){Ap7(ST,LEN)};
Function B7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+a*>d*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//minor-7th---------------------------------------------------------------------
Function Cm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*g*a*+>e*-g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cpm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+b*>e*g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dbm7(Int ST,Str LEN){Cpm7(ST,LEN)}
Function Dm7(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dpm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>c*+f*+a*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ebm7(Int ST,Str LEN){Dpm7(ST,LEN)}
Function Em7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>d*g*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*>c*d*+g*+>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fpm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+>c*+e*a*>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gbm7(Int ST,Str LEN){Fpm7(ST,LEN)};
Function Gm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>d*f*b*>d*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gpm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*+f*+>c*d*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Abm7(Int ST,Str LEN){Gpm7(ST,LEN)};
Function Am7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*g*>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Apm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*g*+>c*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bbm7(Int ST,Str LEN){Apm7(ST,LEN)};
Function Bm7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+a*>d*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function CM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*e*g*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function CpM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+>c*e*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function DbM7(Int ST,Str LEN){CpM7(ST,LEN)}
Function DM7(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>c*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function DpM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>d*g*a*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function EbM7(Int ST,Str LEN){DpM7(ST,LEN)}
Function EM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>d*+g*+b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function FM7(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4f*a*>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function FpM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+>c*+f*a*+>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function GbM7(Int ST,Str LEN){FpM7(ST,LEN)};
Function GM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*b*>d*g*b*>f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function GpM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*+g*>c*d*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function AbM7(Int ST,Str LEN){GpM7(ST,LEN)};
Function AM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*g*+>c*+e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function ApM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*a*>d*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function BbM7(Int ST,Str LEN){ApM7(ST,LEN)};
Function BM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+a*+>d*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function CmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*g*b*>e*-g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function CpmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+>c*e*g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function DbmM7(Int ST,Str LEN){CpmM7(ST,LEN)}
Function DmM7(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>c*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function DpmM7(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST,)'o4e*+>c*e*g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function EbmM7(Int ST,Str LEN){DpmM7(ST,LEN)}
Function EmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>d*+g*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function FmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o4f*>c*e*g*+>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function FpmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+>c*+f*a*>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function GbmM7(Int ST,Str LEN){FpmM7(ST,LEN)};
Function GmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>d*f*+a*+>d*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function GpmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*+g*b*>d*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function AbmM7(Int ST,Str LEN){GpmM7(ST,LEN)};
Function AmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*g*>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function ApmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*g*+>c*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function BbmM7(Int ST,Str LEN){ApmM7(ST,LEN)};
Function BmM7(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+a*>d*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function Csus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*e*g*>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cpsus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+>c*+f*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dbsus4(Int ST,Str LEN){Cpsus4(ST,LEN)}
Function Dsus4(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>d*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dpsus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>d*+g*+a*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ebsus4(Int ST,Str LEN){Dpsus4(ST,LEN)}
Function Esus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>e*a*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fsus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*>c*f*a*+>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fpsus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+>c*+f*+b*>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gbsus4(Int ST,Str LEN){Fpsus4(ST,LEN)};
Function Gsus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>d*g*>c*d*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gpsus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*+g*+>c*+d*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Absus4(Int ST,Str LEN){Gpsus4(ST,LEN)};
Function Asus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*a*>d*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Apsus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*a*+>d*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bbsus4(Int ST,Str LEN){Apsus4(ST,LEN)};
Function Bsus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+b*>e*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function C7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*g*a*+>f*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cp7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+b*>f*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Db7sus4(Int ST,Str LEN){Cp7sus4(ST,LEN)}
Function D7sus4(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>c*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dp7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>c*+g*+a*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Eb7sus4(Int ST,Str LEN){Dp7sus4(ST,LEN)}
Function E7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>d*a*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function F7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*>c*f*a*+>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fp7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+>c*+e*b*>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gb7sus4(Int ST,Str LEN){Fp7sus4(ST,LEN)};
Function G7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>c*d*g*>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gp7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*+f*+>c*+d*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ab7sus4(Int ST,Str LEN){Gp7sus4(ST,LEN)};
Function A7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*g*>d*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ap7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*g*+>d*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bb7sus4(Int ST,Str LEN){Ap7sus4(ST,LEN)};
Function B7sus4(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+a*>e*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function Cdim(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4c*f*+a*>d*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cpdim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>c*+g*+a*+>e*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dbdim(Int ST,Str LEN){Cpdim(ST,LEN)}
Function Ddim(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*-b*>f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dpdim(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*+a*>c*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ebdim(Int ST,Str LEN){Dpdim(ST,LEN)}
Function Edim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*a*+>e*g*>c*+e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fdim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3f*>d*g*+b*>f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fpdim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o4f*+>c*e*-a*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gbdim(Int ST,Str LEN){Fpdim(ST,LEN)};
Function Gdim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>e*a*+>c*+g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gpdim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>f*b*>d*g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Abdim(Int ST,Str LEN){Gpdim(ST,LEN)};
Function Adim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>d*+a*>c*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Apdim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>e*g*>c*+e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bbdim(Int ST,Str LEN){Apdim(ST,LEN)};
Function Bdim(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>e*+g*+>d*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function Cm7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*f*+a*+>d*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cpm7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+e*g*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dbm7b5(Int ST,Str LEN){Cpm7b5(ST,LEN)}
Function Dm7b5(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*g*+>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dpm7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ebm7b5(Int ST,Str LEN){Dpm7b5(ST,LEN)}
Function Em7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*a*+>e*g*>d*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fm7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*b*>f*g*+>d*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fpm7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3f*+a*>e*a*>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gbm7b5(Int ST,Str LEN){Fpm7b5(ST,LEN)};
Function Gm7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>c*+g*a*+>f*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gpm7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>d*g*+b*>f*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Abm7b5(Int ST,Str LEN){Gpm7b5(ST,LEN)};
Function Am7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>d*+a*>c*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Apm7b5(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>e*g*+>c*+e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bbm7b5(Int ST,Str LEN){Apm7b5(ST,LEN)};
Function Bm7b5(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o3b*>f*a*>d*'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function Caug(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*e*g*+>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cpaug(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST)'o4c*+e*+a*>c*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dbaug(Int ST,Str LEN){Cpaug(ST,LEN)}
Function Daug(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*+>d*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dpaug(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST,)'o4d*+g*b*>g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ebaug(Int ST,Str LEN){Dpaug(ST,LEN)}
Function Eaug(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3e*>c*e*g*+>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Faug(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4f*a*>c*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fpaug(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4f*+a*+>d*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gbaug(Int ST,Str LEN){Fpaug(ST,LEN)};
Function Gaug(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*b*>d*+g*b*>g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gpaug(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4g*+>c*e*g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Abaug(Int ST,Str LEN){Gpaug(ST,LEN)};
Function Aaug(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>f*a*>c*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Apaug(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*+a*+>d*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bbaug(Int ST,Str LEN){Apaug(ST,LEN)};
Function Baug(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>d*+g*b*>g*'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function Cadd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*e*g*>d*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cpadd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*+g*+>c*+d*g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dbadd9(Int ST,Str LEN){Cpadd9(ST,LEN)}
Function Dadd9(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*>d*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dpadd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>d*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ebadd9(Int ST,Str LEN){Dpadd9(ST,LEN)}
Function Eadd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>e*g*+b*>f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fadd9(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4f*a*>c*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fpadd9(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4f*+a*+>c*+g*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gbadd9(Int ST,Str LEN){Fpadd9(ST,LEN)};
Function Gadd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,0*ST,1*ST,2*ST,3*ST)'o3g*>d*a*>d*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gpadd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o4g*+>c*d*+a*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Abadd9(Int ST,Str LEN){Gpadd9(ST,LEN)};
Function Aadd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*a*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Apadd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*a*+>c*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bbadd9(Int ST,Str LEN){Apadd9(ST,LEN)};
Function Badd9(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3b*>f*+b*>c*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
Function C6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o4c*e*a*>c*e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Cp6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST)'o4c*+f*a*+>c*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Db6(Int ST,Str LEN){Cp6(ST,LEN)}
Function D6(Int ST,Str LEN){Str _CHORD={t.N(-1*ST,0*ST,1*ST,2*ST)'o4d*a*b*>f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Dp6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,)'o4d*+a*+>c*g*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Eb6(Int ST,Str LEN){Dp6(ST,LEN)}
Function E6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3e*b*>e*g*+>c*+e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function F6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>f*a*d*f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Fp6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o4f*+a*+>d*+f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gb6(Int ST,Str LEN){Fp6(ST,LEN)};
Function G6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*b*>d*g*b*>e*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Gp6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST,3*ST)'o3g*+>c*d*+g*+>c*e*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ab6(Int ST,Str LEN){Gp6(ST,LEN)};
Function A6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*>e*a*>c*+f*'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Ap6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*a*+>d*f*+'};_CHORD = _CHORD + LEN ; _CHORD;}
Function Bb6(Int ST,Str LEN){Ap6(ST,LEN)};
Function B6(Int ST,Str LEN){Str _CHORD={t.N(-2*ST,-1*ST,0*ST,1*ST,2*ST)'o3a*+>f*+b*>d*+g*'};_CHORD = _CHORD + LEN ; _CHORD;}
//------------------------------------------------------------------------------
