/**
KORG ELECTRIBE ER-1
*/

// Part äyäÌî‘çÜ
Int BD = 0; //Bass Drum
Int SD = $A; //Snare Drum
Int TAM = $14
Int SEQ = $1E
Int AudioIn1 = $50
Int AudioIn2 = $5A
Int HH_C = $28; // Hi-hat close
Int HH_O = $7F;
Int CRASH = $3C;
Int HAND = $46;

//
Function ER1(LSB, PART, VALUE){
	NRPN(2,LSB+PART, VALUE);
}

Function ER1LowBoost(PART,VALUE){ ER1(0, PART, VALUE); }
Function ER1Pan(PART,VALUE)     { ER1(1, PART, VALUE); }
Function ER1Pitch(PART,VALUE)   { ER1(2, PART, VALUE); }
Function ER1Wave(PART,VALUE)    { ER1(3, PART, VALUE); }//off=0/on=127
Function ER1ModType(PART,VALUE) { ER1(4, PART, VALUE); }//0~5
Function ER1ModSpeed(PART,VALUE){ ER1(5, PART, VALUE); }
Function ER1ModDepth(PART,VALUE){ ER1(6, PART, VALUE); }
Function ER1Level(PART,VALUE)   { ER1(7, PART, VALUE); }
Function ER1Decay(PART,VALUE)   { ER1(8, PART, VALUE); }
Function ER1RingMod(PART,VALUE) { ER1($66, PART, VALUE); }//on/off
Function ER1DelayDepth(VALUE)   { NRPN(2,$64, VALUE); }
Function ER1DelayTime(VALUE)    { NRPN(2,$65, VALUE); }
Function ER1DelayType(VALUE)    { NRPN(2,$6B, VALUE); }//0=note 1=motion 2=Tempo

/* sample 
TR(1) CH(10) r4 @1 r4
//EFFECT
ER1DelayTime(10);
ER1DelayDepth(40);

ER1LowBoost(BD, 127);
ER1LowBoost(SD, 90);
ER1Decay(SD,40);
ER1Pitch(SD,30);
ER1Level(SD,127);
ER1ModType(SD,4);
ER1ModSpeed(SD,40);
ER1ModDepth(SD,12);

//ïWèÄÇÃéû
$b{o3c} //BD
$s{o3d} //Snare
$m{o3e} //Tam
$u{o3f} //Seq
$h{o3f+}//Hi-Hat Close
$o{o3a+}//Hi-Hat Open
$c{o4c+}//Crash
$d{o3d+}//Hand Clap

Rythm{
	l16
	[8
		brrb srrb bbrr srrr        r-1
		hhoh hhoh hhoh hhoh32h32   r-1
		crur rrur rrur drrr
	] 
}
*/