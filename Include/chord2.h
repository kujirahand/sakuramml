/*
=title        "chord2.h" ver.1.02
=description  簡易コードを定義した関数 (2000/06/06 | 2002/08/19修正)
=keywords     SAKURA Function
*/

/** 概要
◇コードを簡単に使うための関数です。

このファイルで定義されているコードです。
	メジャー			""
	マイナー			m
	セブンス			7
	メジャーセブン			M7
	マイナーセブン			m7
	マイナーメジャーセブン		mM7
	ディミニッシュ			dim
	マイナーセブンフラットファイブ	m7b5
	オーギュメント			aug
	サスフォー			sus4
	セブンサスフォー		7sus4
	シックス			6	
	アドナインス			add9

◇　変換規則
	シャープ（＃）は p
	フラット（♭）は b
　　例）
	ＣＭ７　 なら、CM7
	Ｄ＃ｍ　 なら、Dpm
	Ｂ♭add9 なら、Bbadd9
	と書きます。必ず、半角文字を使ってください。

*書式

コード名(Str LEN)

	LEN	コードの長さn分音符形式で書きます。省略も出来ます。 

* 使い方

Include(chord2.h);

の一文を、曲頭に書き加えてください。

*/

// ------------ 
Function C(Str LEN){ Str _CHORD = {'c*e*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cp(Str LEN){ Str _CHORD = {'c*+f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Db(Str LEN){ Str _CHORD = {'c*+f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function D(Str LEN){ Str _CHORD = {'d*f*+a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dp(Str LEN){ Str _CHORD = {'d*+g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Eb(Str LEN){ Str _CHORD = {'d*+g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function E(Str LEN){ Str _CHORD = {'e*g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function F(Str LEN){ Str _CHORD = {'f*a*c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fp(Str LEN){ Str _CHORD = {'f*+a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gb(Str LEN){ Str _CHORD = {'f*+a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function G(Str LEN){ Str _CHORD = {'g*b*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gp(Str LEN){ Str _CHORD = {'g*+c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ab(Str LEN){ Str _CHORD = {'g*+c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function A(Str LEN){ Str _CHORD = {'a*c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ap(Str LEN){ Str _CHORD = {'a*+d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bb(Str LEN){ Str _CHORD = {'a*+d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function B(Str LEN){ Str _CHORD = {'b*d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
//m ------------ 
Function Cm(Str LEN){ Str _CHORD = {'c*d*+g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cpm(Str LEN){ Str _CHORD = {'c*+e*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dbm(Str LEN){ Str _CHORD = {'c*+e*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dm(Str LEN){ Str _CHORD = {'d*f*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dpm(Str LEN){ Str _CHORD = {'d*+f*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ebm(Str LEN){ Str _CHORD = {'d*+f*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Em(Str LEN){ Str _CHORD = {'e*g*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fm(Str LEN){ Str _CHORD = {'f*g*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fpm(Str LEN){ Str _CHORD = {'f*+a*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gbm(Str LEN){ Str _CHORD = {'f*+a*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gm(Str LEN){ Str _CHORD = {'g*a*+d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gpm(Str LEN){ Str _CHORD = {'g*+b*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Abm(Str LEN){ Str _CHORD = {'g*+b*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Am(Str LEN){ Str _CHORD = {'a*c*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Apm(Str LEN){ Str _CHORD = {'a*+c*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bbm(Str LEN){ Str _CHORD = {'a*+c*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bm(Str LEN){ Str _CHORD = {'b*d*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
//7 ------------ 
Function C7(Str LEN){ Str _CHORD = {'c*e*g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cp7(Str LEN){ Str _CHORD = {'c*+f*g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Db7(Str LEN){ Str _CHORD = {'c*+f*g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function D7(Str LEN){ Str _CHORD = {'d*f*+a*c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dp7(Str LEN){ Str _CHORD = {'d*+g*a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Eb7(Str LEN){ Str _CHORD = {'d*+g*a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function E7(Str LEN){ Str _CHORD = {'e*g*+b*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function F7(Str LEN){ Str _CHORD = {'f*a*c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fp7(Str LEN){ Str _CHORD = {'f*+a*+c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gb7(Str LEN){ Str _CHORD = {'f*+a*+c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function G7(Str LEN){ Str _CHORD = {'g*b*d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gp7(Str LEN){ Str _CHORD = {'g*+c*d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ab7(Str LEN){ Str _CHORD = {'g*+c*d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function A7(Str LEN){ Str _CHORD = {'a*c*+e*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ap7(Str LEN){ Str _CHORD = {'a*+d*f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bb7(Str LEN){ Str _CHORD = {'a*+d*f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function B7(Str LEN){ Str _CHORD = {'b*d*+f*+a*'}; _CHORD = _CHORD + LEN; _CHORD;}
//m7 ------------ 
Function Cm7(Str LEN){ Str _CHORD = {'c*d*+g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cpm7(Str LEN){ Str _CHORD = {'c*+e*g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dbm7(Str LEN){ Str _CHORD = {'c*+e*g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dm7(Str LEN){ Str _CHORD = {'d*f*a*c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dpm7(Str LEN){ Str _CHORD = {'d*+f*+a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ebm7(Str LEN){ Str _CHORD = {'d*+f*+a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Em7(Str LEN){ Str _CHORD = {'e*g*b*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fm7(Str LEN){ Str _CHORD = {'f*g*+c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fpm7(Str LEN){ Str _CHORD = {'f*+a*c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gbm7(Str LEN){ Str _CHORD = {'f*+a*c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gm7(Str LEN){ Str _CHORD = {'g*a*+d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gpm7(Str LEN){ Str _CHORD = {'g*+b*d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Abm7(Str LEN){ Str _CHORD = {'g*+b*d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Am7(Str LEN){ Str _CHORD = {'a*c*e*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Apm7(Str LEN){ Str _CHORD = {'a*+c*+f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bbm7(Str LEN){ Str _CHORD = {'a*+c*+f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bm7(Str LEN){ Str _CHORD = {'b*d*f*+a*'}; _CHORD = _CHORD + LEN; _CHORD;}
//M7 ------------ 
Function CM7(Str LEN){ Str _CHORD = {'c*e*g*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function CpM7(Str LEN){ Str _CHORD = {'c*+f*g*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function DbM7(Str LEN){ Str _CHORD = {'c*+f*g*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function DM7(Str LEN){ Str _CHORD = {'d*f*+a*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function DpM7(Str LEN){ Str _CHORD = {'d*+g*a*+d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function EbM7(Str LEN){ Str _CHORD = {'d*+g*a*+d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function EM7(Str LEN){ Str _CHORD = {'e*g*+b*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function FM7(Str LEN){ Str _CHORD = {'f*a*c*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function FpM7(Str LEN){ Str _CHORD = {'f*+a*+c*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function GbM7(Str LEN){ Str _CHORD = {'f*+a*+c*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function GM7(Str LEN){ Str _CHORD = {'g*b*d*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function GpM7(Str LEN){ Str _CHORD = {'g*+c*d*+g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function AbM7(Str LEN){ Str _CHORD = {'g*+c*d*+g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function AM7(Str LEN){ Str _CHORD = {'a*c*+e*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function ApM7(Str LEN){ Str _CHORD = {'a*+d*f*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function BbM7(Str LEN){ Str _CHORD = {'a*+d*f*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function BM7(Str LEN){ Str _CHORD = {'b*d*+f*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
//mM7 ------------ 
Function CmM7(Str LEN){ Str _CHORD = {'c*d*+g*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function CpmM7(Str LEN){ Str _CHORD = {'c*+e*g*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function DbmM7(Str LEN){ Str _CHORD = {'c*+e*g*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function DmM7(Str LEN){ Str _CHORD = {'d*f*a*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function DpmM7(Str LEN){ Str _CHORD = {'d*+f*+a*+d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function EbmM7(Str LEN){ Str _CHORD = {'d*+f*+a*+d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function EmM7(Str LEN){ Str _CHORD = {'e*g*b*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function FmM7(Str LEN){ Str _CHORD = {'f*g*+c*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function FpmM7(Str LEN){ Str _CHORD = {'f*+a*c*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function GbmM7(Str LEN){ Str _CHORD = {'f*+a*c*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function GmM7(Str LEN){ Str _CHORD = {'g*a*+d*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function GpmM7(Str LEN){ Str _CHORD = {'g*+b*d*+g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function AbmM7(Str LEN){ Str _CHORD = {'g*+b*d*+g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function AmM7(Str LEN){ Str _CHORD = {'a*c*e*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function ApmM7(Str LEN){ Str _CHORD = {'a*+c*+f*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function BbmM7(Str LEN){ Str _CHORD = {'a*+c*+f*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function BmM7(Str LEN){ Str _CHORD = {'b*d*f*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
//dim ------------ 
Function Cdim(Str LEN){ Str _CHORD = {'c*d*+f*+a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cpdim(Str LEN){ Str _CHORD = {'c*+e*g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dbdim(Str LEN){ Str _CHORD = {'c*+e*g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ddim(Str LEN){ Str _CHORD = {'d*f*g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dpdim(Str LEN){ Str _CHORD = {'d*+f*+a*c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ebdim(Str LEN){ Str _CHORD = {'d*+f*+a*c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Edim(Str LEN){ Str _CHORD = {'e*g*a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fdim(Str LEN){ Str _CHORD = {'f*g*+b*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fpdim(Str LEN){ Str _CHORD = {'f*+a*c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gbdim(Str LEN){ Str _CHORD = {'f*+a*c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gdim(Str LEN){ Str _CHORD = {'g*a*+c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gpdim(Str LEN){ Str _CHORD = {'g*+b*d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Abdim(Str LEN){ Str _CHORD = {'g*+b*d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Adim(Str LEN){ Str _CHORD = {'a*c*d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Apdim(Str LEN){ Str _CHORD = {'a*+c*+e*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bbdim(Str LEN){ Str _CHORD = {'a*+c*+e*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bdim(Str LEN){ Str _CHORD = {'b*d*f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
//m7b5 ------------ 
Function Cm7b5(Str LEN){ Str _CHORD = {'c*d*+f*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cpm7b5(Str LEN){ Str _CHORD = {'c*+e*g*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dbm7b5(Str LEN){ Str _CHORD = {'c*+e*g*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dm7b5(Str LEN){ Str _CHORD = {'d*f*g*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dpm7b5(Str LEN){ Str _CHORD = {'d*+f*+a*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ebm7b5(Str LEN){ Str _CHORD = {'d*+f*+a*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Em7b5(Str LEN){ Str _CHORD = {'e*g*a*+d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fm7b5(Str LEN){ Str _CHORD = {'f*g*+b*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fpm7b5(Str LEN){ Str _CHORD = {'f*+a*c*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gbm7b5(Str LEN){ Str _CHORD = {'f*+a*c*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gm7b5(Str LEN){ Str _CHORD = {'g*a*+c*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gpm7b5(Str LEN){ Str _CHORD = {'g*+b*d*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Abm7b5(Str LEN){ Str _CHORD = {'g*+b*d*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Am7b5(Str LEN){ Str _CHORD = {'a*c*d*+g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Apm7b5(Str LEN){ Str _CHORD = {'a*+c*+e*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bbm7b5(Str LEN){ Str _CHORD = {'a*+c*+e*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bm7b5(Str LEN){ Str _CHORD = {'b*d*f*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
//aug ------------ 
Function Caug(Str LEN){ Str _CHORD = {'c*e*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cpaug(Str LEN){ Str _CHORD = {'c*+f*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dbaug(Str LEN){ Str _CHORD = {'c*+f*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Daug(Str LEN){ Str _CHORD = {'d*f*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dpaug(Str LEN){ Str _CHORD = {'d*+g*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ebaug(Str LEN){ Str _CHORD = {'d*+g*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Eaug(Str LEN){ Str _CHORD = {'e*g*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Faug(Str LEN){ Str _CHORD = {'f*a*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fpaug(Str LEN){ Str _CHORD = {'f*+a*+d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gbaug(Str LEN){ Str _CHORD = {'f*+a*+d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gaug(Str LEN){ Str _CHORD = {'g*b*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gpaug(Str LEN){ Str _CHORD = {'g*+c*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Abaug(Str LEN){ Str _CHORD = {'g*+c*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Aaug(Str LEN){ Str _CHORD = {'a*c*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Apaug(Str LEN){ Str _CHORD = {'a*+d*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bbaug(Str LEN){ Str _CHORD = {'a*+d*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Baug(Str LEN){ Str _CHORD = {'b*d*+g*'}; _CHORD = _CHORD + LEN; _CHORD;}
//sus4 ------------ 
Function Csus4(Str LEN){ Str _CHORD = {'c*f*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cpsus4(Str LEN){ Str _CHORD = {'c*+f*+g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dbsus4(Str LEN){ Str _CHORD = {'c*+f*+g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dsus4(Str LEN){ Str _CHORD = {'d*g*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dpsus4(Str LEN){ Str _CHORD = {'d*+g*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ebsus4(Str LEN){ Str _CHORD = {'d*+g*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Esus4(Str LEN){ Str _CHORD = {'e*a*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fsus4(Str LEN){ Str _CHORD = {'f*a*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fpsus4(Str LEN){ Str _CHORD = {'f*+b*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gbsus4(Str LEN){ Str _CHORD = {'f*+b*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gsus4(Str LEN){ Str _CHORD = {'g*c*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gpsus4(Str LEN){ Str _CHORD = {'g*+c*+d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Absus4(Str LEN){ Str _CHORD = {'g*+c*+d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Asus4(Str LEN){ Str _CHORD = {'a*d*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Apsus4(Str LEN){ Str _CHORD = {'a*+d*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bbsus4(Str LEN){ Str _CHORD = {'a*+d*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bsus4(Str LEN){ Str _CHORD = {'b*e*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
//7sus4 ------------ 
Function C7sus4(Str LEN){ Str _CHORD = {'c*f*g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cp7sus4(Str LEN){ Str _CHORD = {'c*+f*+g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Db7sus4(Str LEN){ Str _CHORD = {'c*+f*+g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function D7sus4(Str LEN){ Str _CHORD = {'d*g*a*c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dp7sus4(Str LEN){ Str _CHORD = {'d*+g*+a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Eb7sus4(Str LEN){ Str _CHORD = {'d*+g*+a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function E7sus4(Str LEN){ Str _CHORD = {'e*a*b*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function F7sus4(Str LEN){ Str _CHORD = {'f*a*+c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fp7sus4(Str LEN){ Str _CHORD = {'f*+b*c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gb7sus4(Str LEN){ Str _CHORD = {'f*+b*c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function G7sus4(Str LEN){ Str _CHORD = {'g*c*d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gp7sus4(Str LEN){ Str _CHORD = {'g*+c*+d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ab7sus4(Str LEN){ Str _CHORD = {'g*+c*+d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function A7sus4(Str LEN){ Str _CHORD = {'a*d*e*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ap7sus4(Str LEN){ Str _CHORD = {'a*+d*+f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bb7sus4(Str LEN){ Str _CHORD = {'a*+d*+f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function B7sus4(Str LEN){ Str _CHORD = {'b*e*f*+a*'}; _CHORD = _CHORD + LEN; _CHORD;}
//6 ------------ 
Function C6(Str LEN){ Str _CHORD = {'c*e*g*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cp6(Str LEN){ Str _CHORD = {'c*+f*g*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Db6(Str LEN){ Str _CHORD = {'c*+f*g*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function D6(Str LEN){ Str _CHORD = {'d*f*+a*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dp6(Str LEN){ Str _CHORD = {'d*+g*a*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Eb6(Str LEN){ Str _CHORD = {'d*+g*a*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function E6(Str LEN){ Str _CHORD = {'e*g*+b*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function F6(Str LEN){ Str _CHORD = {'f*a*c*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fp6(Str LEN){ Str _CHORD = {'f*+a*+c*+d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gb6(Str LEN){ Str _CHORD = {'f*+a*+c*+d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function G6(Str LEN){ Str _CHORD = {'g*b*d*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gp6(Str LEN){ Str _CHORD = {'g*+c*d*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ab6(Str LEN){ Str _CHORD = {'g*+c*d*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function A6(Str LEN){ Str _CHORD = {'a*c*+e*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ap6(Str LEN){ Str _CHORD = {'a*+d*f*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bb6(Str LEN){ Str _CHORD = {'a*+d*f*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function B6(Str LEN){ Str _CHORD = {'b*d*+f*+g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
//add9 ------------ 
Function Cadd9(Str LEN){ Str _CHORD = {'c*d*e*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cpadd9(Str LEN){ Str _CHORD = {'c*+d*+f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dbadd9(Str LEN){ Str _CHORD = {'c*+d*+f*g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dadd9(Str LEN){ Str _CHORD = {'d*e*f*+a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dpadd9(Str LEN){ Str _CHORD = {'d*+f*g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ebadd9(Str LEN){ Str _CHORD = {'d*+f*g*a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Eadd9(Str LEN){ Str _CHORD = {'e*f*+g*+b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fadd9(Str LEN){ Str _CHORD = {'f*g*a*c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fpadd9(Str LEN){ Str _CHORD = {'f*+g*+a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gbadd9(Str LEN){ Str _CHORD = {'f*+g*+a*+c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gadd9(Str LEN){ Str _CHORD = {'g*a*b*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gpadd9(Str LEN){ Str _CHORD = {'g*+a*+c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Abadd9(Str LEN){ Str _CHORD = {'g*+a*+c*d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Aadd9(Str LEN){ Str _CHORD = {'a*b*c*+e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Apadd9(Str LEN){ Str _CHORD = {'a*+c*d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bbadd9(Str LEN){ Str _CHORD = {'a*+c*d*f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Badd9(Str LEN){ Str _CHORD = {'b*c*+d*+f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
//m6 ------------ 
Function Cm6(Str LEN){ Str _CHORD = {'c*d*+g*a*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Cpm6(Str LEN){ Str _CHORD = {'c*+e*g*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dbm6(Str LEN){ Str _CHORD = {'c*+e*g*+a*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dm6(Str LEN){ Str _CHORD = {'d*f*a*b*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Dpm6(Str LEN){ Str _CHORD = {'d*+f*+a*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Ebm6(Str LEN){ Str _CHORD = {'d*+f*+a*+c*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Em6(Str LEN){ Str _CHORD = {'e*g*b*c*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fm6(Str LEN){ Str _CHORD = {'f*g*+c*d*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Fpm6(Str LEN){ Str _CHORD = {'f*+a*c*+d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gbm6(Str LEN){ Str _CHORD = {'f*+a*c*+d*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gm6(Str LEN){ Str _CHORD = {'g*a*+d*e*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Gpm6(Str LEN){ Str _CHORD = {'g*+b*d*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Abm6(Str LEN){ Str _CHORD = {'g*+b*d*+f*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Am6(Str LEN){ Str _CHORD = {'a*c*e*f*+'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Apm6(Str LEN){ Str _CHORD = {'a*+c*+f*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bbm6(Str LEN){ Str _CHORD = {'a*+c*+f*g*'}; _CHORD = _CHORD + LEN; _CHORD;}
Function Bm6(Str LEN){ Str _CHORD = {'b*d*f*+g*+'}; _CHORD = _CHORD + LEN; _CHORD;}
