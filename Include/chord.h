/*
=title        "chord.h" ver.1.01
=description  文字列マクロで簡易コードを定義した (1999/12/17 | 2002/08/19 修正)
=keywords     SAKURA Function
*/

/** chord.h 概要

コードを文字列マクロにまとめたものです。

◇このファイルで定義されているコード
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

◇変換規則
	シャープ（＃）は p
	フラット（♭）は b

	文字列マクロとして実装されているので、コードネームの前に、
	#を加える必要があります。

	例）　実際の記述　コードネーム
		#CM7	//ＣＭ７
	  	#Dpaug  //Ｄ＃aug
		#Bbm7b5 //Ｂ♭m7(-5)

	定義ファイル"chord2.h"の方は、関数として実装されているので、
	そちらの方が扱いやすいと思います。
	しかし、コンパイル速度は、こちらの方が速いです。

* 使い方

Include(chord.h);

の一文を、曲頭に書き加えてください。
*/


// ------------ 
#C = {'c*e*g*'}
#Cp = {'c*+f*g*+'}
#Db = {'c*+f*g*+'}
#D = {'d*f*+a*'}
#Dp = {'d*+g*a*+'}
#Eb = {'d*+g*a*+'}
#E = {'e*g*+b*'}
#F = {'f*a*c*'}
#Fp = {'f*+a*+c*+'}
#Gb = {'f*+a*+c*+'}
#G = {'g*b*d*'}
#Gp = {'g*+c*d*+'}
#Ab = {'g*+c*d*+'}
#A = {'a*c*+e*'}
#Ap = {'a*+d*f*'}
#Bb = {'a*+d*f*'}
#B = {'b*d*+f*+'}
//m ------------ 
#Cm = {'c*d*+g*'}
#Cpm = {'c*+e*g*+'}
#Dbm = {'c*+e*g*+'}
#Dm = {'d*f*a*'}
#Dpm = {'d*+f*+a*+'}
#Ebm = {'d*+f*+a*+'}
#Em = {'e*g*b*'}
#Fm = {'f*g*+c*'}
#Fpm = {'f*+a*c*+'}
#Gbm = {'f*+a*c*+'}
#Gm = {'g*a*+d*'}
#Gpm = {'g*+b*d*+'}
#Abm = {'g*+b*d*+'}
#Am = {'a*c*e*'}
#Apm = {'a*+c*+f*'}
#Bbm = {'a*+c*+f*'}
#Bm = {'b*d*f*+'}
//7 ------------ 
#C7 = {'c*e*g*a*+'}
#Cp7 = {'c*+f*g*+b*'}
#Db7 = {'c*+f*g*+b*'}
#D7 = {'d*f*+a*c*'}
#Dp7 = {'d*+g*a*+c*+'}
#Eb7 = {'d*+g*a*+c*+'}
#E7 = {'e*g*+b*d*'}
#F7 = {'f*a*c*d*+'}
#Fp7 = {'f*+a*+c*+e*'}
#Gb7 = {'f*+a*+c*+e*'}
#G7 = {'g*b*d*f*'}
#Gp7 = {'g*+c*d*+f*+'}
#Ab7 = {'g*+c*d*+f*+'}
#A7 = {'a*c*+e*g*'}
#Ap7 = {'a*+d*f*g*+'}
#Bb7 = {'a*+d*f*g*+'}
#B7 = {'b*d*+f*+a*'}
//m7 ------------ 
#Cm7 = {'c*d*+g*a*+'}
#Cpm7 = {'c*+e*g*+b*'}
#Dbm7 = {'c*+e*g*+b*'}
#Dm7 = {'d*f*a*c*'}
#Dpm7 = {'d*+f*+a*+c*+'}
#Ebm7 = {'d*+f*+a*+c*+'}
#Em7 = {'e*g*b*d*'}
#Fm7 = {'f*g*+c*d*+'}
#Fpm7 = {'f*+a*c*+e*'}
#Gbm7 = {'f*+a*c*+e*'}
#Gm7 = {'g*a*+d*f*'}
#Gpm7 = {'g*+b*d*+f*+'}
#Abm7 = {'g*+b*d*+f*+'}
#Am7 = {'a*c*e*g*'}
#Apm7 = {'a*+c*+f*g*+'}
#Bbm7 = {'a*+c*+f*g*+'}
#Bm7 = {'b*d*f*+a*'}
//M7 ------------ 
#CM7 = {'c*e*g*b*'}
#CpM7 = {'c*+f*g*+c*'}
#DbM7 = {'c*+f*g*+c*'}
#DM7 = {'d*f*+a*c*+'}
#DpM7 = {'d*+g*a*+d*'}
#EbM7 = {'d*+g*a*+d*'}
#EM7 = {'e*g*+b*d*+'}
#FM7 = {'f*a*c*e*'}
#FpM7 = {'f*+a*+c*+f*'}
#GbM7 = {'f*+a*+c*+f*'}
#GM7 = {'g*b*d*f*+'}
#GpM7 = {'g*+c*d*+g*'}
#AbM7 = {'g*+c*d*+g*'}
#AM7 = {'a*c*+e*g*+'}
#ApM7 = {'a*+d*f*a*'}
#BbM7 = {'a*+d*f*a*'}
#BM7 = {'b*d*+f*+a*+'}
//mM7 ------------ 
#CmM7 = {'c*d*+g*b*'}
#CpmM7 = {'c*+e*g*+c*'}
#DbmM7 = {'c*+e*g*+c*'}
#DmM7 = {'d*f*a*c*+'}
#DpmM7 = {'d*+f*+a*+d*'}
#EbmM7 = {'d*+f*+a*+d*'}
#EmM7 = {'e*g*b*d*+'}
#FmM7 = {'f*g*+c*e*'}
#FpmM7 = {'f*+a*c*+f*'}
#GbmM7 = {'f*+a*c*+f*'}
#GmM7 = {'g*a*+d*f*+'}
#GpmM7 = {'g*+b*d*+g*'}
#AbmM7 = {'g*+b*d*+g*'}
#AmM7 = {'a*c*e*g*+'}
#ApmM7 = {'a*+c*+f*a*'}
#BbmM7 = {'a*+c*+f*a*'}
#BmM7 = {'b*d*f*+a*+'}
//dim ------------ 
#Cdim = {'c*d*+f*+a*'}
#Cpdim = {'c*+e*g*a*+'}
#Dbdim = {'c*+e*g*a*+'}
#Ddim = {'d*f*g*+b*'}
#Dpdim = {'d*+f*+a*c*'}
#Ebdim = {'d*+f*+a*c*'}
#Edim = {'e*g*a*+c*+'}
#Fdim = {'f*g*+b*d*'}
#Fpdim = {'f*+a*c*d*+'}
#Gbdim = {'f*+a*c*d*+'}
#Gdim = {'g*a*+c*+e*'}
#Gpdim = {'g*+b*d*f*'}
#Abdim = {'g*+b*d*f*'}
#Adim = {'a*c*d*+f*+'}
#Apdim = {'a*+c*+e*g*'}
#Bbdim = {'a*+c*+e*g*'}
#Bdim = {'b*d*f*g*+'}
//m7b5 ------------ 
#Cm7b5 = {'c*d*+f*+a*+'}
#Cpm7b5 = {'c*+e*g*b*'}
#Dbm7b5 = {'c*+e*g*b*'}
#Dm7b5 = {'d*f*g*+c*'}
#Dpm7b5 = {'d*+f*+a*c*+'}
#Ebm7b5 = {'d*+f*+a*c*+'}
#Em7b5 = {'e*g*a*+d*'}
#Fm7b5 = {'f*g*+b*d*+'}
#Fpm7b5 = {'f*+a*c*e*'}
#Gbm7b5 = {'f*+a*c*e*'}
#Gm7b5 = {'g*a*+c*+f*'}
#Gpm7b5 = {'g*+b*d*f*+'}
#Abm7b5 = {'g*+b*d*f*+'}
#Am7b5 = {'a*c*d*+g*'}
#Apm7b5 = {'a*+c*+e*g*+'}
#Bbm7b5 = {'a*+c*+e*g*+'}
#Bm7b5 = {'b*d*f*a*'}
//aug ------------ 
#Caug = {'c*e*g*+'}
#Cpaug = {'c*+f*a*'}
#Dbaug = {'c*+f*a*'}
#Daug = {'d*f*+a*+'}
#Dpaug = {'d*+g*b*'}
#Ebaug = {'d*+g*b*'}
#Eaug = {'e*g*+c*'}
#Faug = {'f*a*c*+'}
#Fpaug = {'f*+a*+d*'}
#Gbaug = {'f*+a*+d*'}
#Gaug = {'g*b*d*+'}
#Gpaug = {'g*+c*e*'}
#Abaug = {'g*+c*e*'}
#Aaug = {'a*c*+f*'}
#Apaug = {'a*+d*f*+'}
#Bbaug = {'a*+d*f*+'}
#Baug = {'b*d*+g*'}
//sus4 ------------ 
#Csus4 = {'c*f*g*'}
#Cpsus4 = {'c*+f*+g*+'}
#Dbsus4 = {'c*+f*+g*+'}
#Dsus4 = {'d*g*a*'}
#Dpsus4 = {'d*+g*+a*+'}
#Ebsus4 = {'d*+g*+a*+'}
#Esus4 = {'e*a*b*'}
#Fsus4 = {'f*a*+c*'}
#Fpsus4 = {'f*+b*c*+'}
#Gbsus4 = {'f*+b*c*+'}
#Gsus4 = {'g*c*d*'}
#Gpsus4 = {'g*+c*+d*+'}
#Absus4 = {'g*+c*+d*+'}
#Asus4 = {'a*d*e*'}
#Apsus4 = {'a*+d*+f*'}
#Bbsus4 = {'a*+d*+f*'}
#Bsus4 = {'b*e*f*+'}
//7sus4 ------------ 
#C7sus4 = {'c*f*g*a*+'}
#Cp7sus4 = {'c*+f*+g*+b*'}
#Db7sus4 = {'c*+f*+g*+b*'}
#D7sus4 = {'d*g*a*c*'}
#Dp7sus4 = {'d*+g*+a*+c*+'}
#Eb7sus4 = {'d*+g*+a*+c*+'}
#E7sus4 = {'e*a*b*d*'}
#F7sus4 = {'f*a*+c*d*+'}
#Fp7sus4 = {'f*+b*c*+e*'}
#Gb7sus4 = {'f*+b*c*+e*'}
#G7sus4 = {'g*c*d*f*'}
#Gp7sus4 = {'g*+c*+d*+f*+'}
#Ab7sus4 = {'g*+c*+d*+f*+'}
#A7sus4 = {'a*d*e*g*'}
#Ap7sus4 = {'a*+d*+f*g*+'}
#Bb7sus4 = {'a*+d*+f*g*+'}
#B7sus4 = {'b*e*f*+a*'}
//6 ------------ 
#C6 = {'c*e*g*a*'}
#Cp6 = {'c*+f*g*+a*+'}
#Db6 = {'c*+f*g*+a*+'}
#D6 = {'d*f*+a*b*'}
#Dp6 = {'d*+g*a*+c*'}
#Eb6 = {'d*+g*a*+c*'}
#E6 = {'e*g*+b*c*+'}
#F6 = {'f*a*c*d*'}
#Fp6 = {'f*+a*+c*+d*+'}
#Gb6 = {'f*+a*+c*+d*+'}
#G6 = {'g*b*d*e*'}
#Gp6 = {'g*+c*d*+f*'}
#Ab6 = {'g*+c*d*+f*'}
#A6 = {'a*c*+e*f*+'}
#Ap6 = {'a*+d*f*g*'}
#Bb6 = {'a*+d*f*g*'}
#B6 = {'b*d*+f*+g*+'}
//add9 ------------ 
#Cadd9 = {'c*d*e*g*'}
#Cpadd9 = {'c*+d*+f*g*+'}
#Dbadd9 = {'c*+d*+f*g*+'}
#Dadd9 = {'d*e*f*+a*'}
#Dpadd9 = {'d*+f*g*a*+'}
#Ebadd9 = {'d*+f*g*a*+'}
#Eadd9 = {'e*f*+g*+b*'}
#Fadd9 = {'f*g*a*c*'}
#Fpadd9 = {'f*+g*+a*+c*+'}
#Gbadd9 = {'f*+g*+a*+c*+'}
#Gadd9 = {'g*a*b*d*'}
#Gpadd9 = {'g*+a*+c*d*+'}
#Abadd9 = {'g*+a*+c*d*+'}
#Aadd9 = {'a*b*c*+e*'}
#Apadd9 = {'a*+c*d*f*'}
#Bbadd9 = {'a*+c*d*f*'}
#Badd9 = {'b*c*+d*+f*+'}
//m6 ------------ 
#Cm6 = {'c*d*+g*a*'}
#Cpm6 = {'c*+e*g*+a*+'}
#Dbm6 = {'c*+e*g*+a*+'}
#Dm6 = {'d*f*a*b*'}
#Dpm6 = {'d*+f*+a*+c*'}
#Ebm6 = {'d*+f*+a*+c*'}
#Em6 = {'e*g*b*c*+'}
#Fm6 = {'f*g*+c*d*'}
#Fpm6 = {'f*+a*c*+d*+'}
#Gbm6 = {'f*+a*c*+d*+'}
#Gm6 = {'g*a*+d*e*'}
#Gpm6 = {'g*+b*d*+f*'}
#Abm6 = {'g*+b*d*+f*'}
#Am6 = {'a*c*e*f*+'}
#Apm6 = {'a*+c*+f*g*'}
#Bbm6 = {'a*+c*+f*g*'}
#Bm6 = {'b*d*f*+g*+'}

