/**
KORG ELECTRIBE EA-1
音源パラメータ操作関数群
*/

Int EA1CH = 0; // 0 or 1 書き込み先チャンネル

//EA1のポルタメント
Function EA1Portament(Val){
  NRPN(3,(EA1CH*$20),Val);
}
//OSC-Balance:OSC1とOSC2のバランス
Function EA1OSC_Balace(Val){//OSC1 <- 0 ~ 64 ~ 127 -> OSC2
  NRPN(3,(EA1CH*$20)+1, Val);
}
Function EA1OSC_Pitch(Val){
  NRPN(3,(EA1CH*$20)+2, Val);
}
Function EA1OSC1_Wave(Val){//0:ノコギリ波 / 1:矩形波 / 2:三角波 / 3:Audio in
  NRPN(3,(EA1CH*$20)+3, Val);
}
Function EA1OSC2_Wave(Val){
  NRPN(3,(EA1CH*$20)+4, Val);
}
Function EA1Distortion(Val){//0:off / 127:on
  NRPN(3,(EA1CH*$20)+6, Val);//表間違い
}
Function EA1AMP(Val){
  NRPN(3,(EA1CH*$20)+7, Val);
}
Function EA1Cutoff(Val){
  NRPN(3,(EA1CH*$20)+8, Val);
}
Function EA1Resonance(Val){
  NRPN(3,(EA1CH*$20)+9, Val);
}
Function EA1EG_Int(Val){
  NRPN(3,(EA1CH*$20)+10, Val);
}
Function EA1Decay(Val){
  NRPN(3,(EA1CH*$20)+11, Val);
}
Function EA1DelayDepth(Val){
  NRPN(3,(EA1CH*$20)+12, Val);
}
Function EA1DelayTime(Val){
  NRPN(3,(EA1CH*$20)+13, Val);
}

/* 以下、サンプル
Str Wait = {r%3}
TR(1)CH(1)
@4
r4
EA1Portament(60)
EA1AMP(127) Wait
EA1OSC1_Wave(1) Wait
EA1OSC2_Wave(2) Wait
EA1OSC_Balace(80) Wait
EA1Distortion(0) Wait
EA1Cutoff(80) Wait
EA1Resonance(90) Wait
EA1EG_Int(20) Wait
EA1Decay(10) Wait
EA1DelayDepth(50) Wait
EA1DelayTime(60) Wait

KeyFlag=(1,0,0,0,1,0,0)//sharp
[8
	EA1Cutoff(30) DataMSB.onTime(30,127,!1)
	o4l16 cdeg32g+32 a>cde | `ga>cd e`ga>e<
	DataMSB.onTime(127,30,!1)
	b-age d<bag | >e32d32g<<ba g-ed"b
]
*/

