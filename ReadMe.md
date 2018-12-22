# sakuramml - テキスト音楽「サクラ」第三版

MML Compiler (MML to MIDI File Converter)

## for Windows

- Binary download --> https://sakuramml.com/

## Compiler

- Full (Default) : Delphi7 (Win)
- Commnad line version : Delphi7 / FPC (Free Pascal Compiler)

## Charset 

- Shift_JIS

### Compile for FPC (Free Pascal compiler)

- 1. Install FPC
- 2. Compile

```
fpc -Mdelphi -g -gv -vewh csakura.dpr
    OR
./make.sh
```

### Compile (Debian, Ubuntu)

1. Install dependencies

```
sudo apt install libc-dev fp-compiler nkf
```

2. Compile

```
git clone https://github.com/kujirahand/sakuramml.git
cd sakuramml
./make.sh
```


### Compile (Linux)

- 1. check CPU
 - 1.1 ``uname -a``
 - 2. Install FPC
  - 2.1 https://sourceforge.net/projects/freepascal/files/Linux/3.0.4/
  - 2.2 (ex) wget wget https://sourceforge.net/projects/freepascal/files/Linux/3.0.4/fpc-3.0.4.x86_64-linux.tar/download
  - 2.3 ``tar xvf download``
  - 2.4 ``cd fpc-3.0.4.x86_64-linux/``
  - 2.5 ``./install.sh``
- 3. pull sourcecode
 - 3.1 ``git clone https://github.com/kujirahand/sakuramml.git``
 - 3,2 ``cd sakuramml``
 - 3.3 ``./make.sh``
 - ここまで来れば、警告がいくつか表示される物の、./csakuraという実行ファイルができているはず

### Compile (Raspberry pi)

```
sudo apt-get update
sudo apt-get install fpc
sudo apt-get install nkf
git clone https://github.com/kujirahand/sakuramml.git
cd sakuramml
./make.sh
```




