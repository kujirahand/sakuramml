#!/bin/sh
fpc -Mdelphi -g -gv -vewh csakura.dpr && \
  # ./csakura test.mml | nkf -w
  ./csakura sample/sakura2.mml | nkf -w


