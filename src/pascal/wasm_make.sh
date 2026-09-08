#!/bin/sh
fpc -Twasi -Pwasm32 -FE -Mdelphi -g -gv -vewh csakura.dpr 

# ./csakura test.mml | iconv -f cp932
#./csakura ../../sample/sakura2.mml | iconv -f cp932


