<<<<<<< HEAD
# sakuramml - テキスト音楽「サクラ」第三版

MML Compiler (MML to MIDI File Converter)

## for Windows

- Binary download --> https://sakuramml.com/

## Compiler

- Full (Windows only) : Delphi7
- Commnad line version : Delphi7 / FPC (Free Pascal Compiler)

## Charset 

- Shift_JIS (not UTF-8)

### Compile for FPC (Free Pascal compiler)

1. Install FPC
2. Compile

    ```sh
    fpc -Mdelphi -g -gv -vewh csakura.dpr
        OR
    ./make.sh
    ```

### Compile (Debian, Ubuntu)

1. Install dependencies

    ```sh
    sudo apt install libc-dev fp-compiler
    ```

2. Compile

    ```sh
    git clone https://github.com/kujirahand/sakuramml.git
    cd sakuramml
    ./make.sh
    ```

### Compile (macOS)

 1. Install FPC

  ```sh
  brew install fpc
  ```

 2. Compile

  ```sh
    git clone https://github.com/kujirahand/sakuramml.git
    cd sakuramml
    ./make.sh
  ```


### Compile (other Linux)

1. Check CPU

    ```sh
    uname -a
    ```

2. Install FPC

    - https://sourceforge.net/projects/freepascal/files/Linux/3.0.4/

    ```sh
    # example
    wget https://sourceforge.net/projects/freepascal/files/Linux/3.0.4/fpc-3.0.4.x86_64-linux.tar/download
    tar xvf download
    cd fpc-3.0.4.x86_64-linux/
    ./install.sh
    ```

3. Pull sourcecode

    ```
    git clone https://github.com/kujirahand/sakuramml.git
    cd sakuramml
    ./make.sh
    ```

    ここまで来れば、警告がいくつか表示される物の、./csakuraという実行ファイルができているはず

### Compile (Raspberry pi)

```sh
sudo apt-get update
sudo apt-get install fpc
git clone https://github.com/kujirahand/sakuramml.git
cd sakuramml
./make.sh
```




=======
# sakuramml - テキスト音楽「サクラ」第三版

MML Compiler (MML to MIDI File Converter)

## for Windows

- Binary download --> https://sakuramml.com/

## Compiler

- Full (Windows only) : Delphi7
- Commnad line version : Delphi7 / FPC (Free Pascal Compiler)

## Charset 

- Shift_JIS (not UTF-8)

### Compile for FPC (Free Pascal compiler)

1. Install FPC
2. Compile

    ```sh
    fpc -Mdelphi -g -gv -vewh csakura.dpr
        OR
    ./make.sh
    ```

### Compile (Debian, Ubuntu)

1. Install dependencies

    ```sh
    sudo apt install libc-dev fp-compiler
    ```

2. Compile

    ```sh
    git clone https://github.com/kujirahand/sakuramml.git
    cd sakuramml
    ./make.sh
    ```

### Compile (macOS)

 1. Install FPC

  ```sh
  brew install fpc
  ```

 2. Compile

  ```sh
    git clone https://github.com/kujirahand/sakuramml.git
    cd sakuramml
    ./make.sh
  ```

### (memo) macOSでエラーが出たとき

Apple SilliconのmacOSで、うまくエラーが出ないエラーを観測しました。
以下の勧めに応じてコンパイラオプションを修正すると良いです。

https://wiki.freepascal.org/Mac_Installation_FAQ#ld:_library_not_found_for_-lc

具体的には以下の手順でSDKのパスを指定しました。

- `/opt/homebrew/etc/fpc.cfg` をテキストエディタで開く
- 適当な場所に `-XR/Library/Developer/CommandLineTools/SDKs/MacOSX12.1.sdk/` を追加。
- なお、上記パスはSDKのバージョンに応じて変わると思うのでパスが存在するか確認してください。



### Compile (other Linux)

1. Check CPU

    ```sh
    uname -a
    ```

2. Install FPC

    - https://sourceforge.net/projects/freepascal/files/Linux/3.0.4/

    ```sh
    # example
    wget https://sourceforge.net/projects/freepascal/files/Linux/3.0.4/fpc-3.0.4.x86_64-linux.tar/download
    tar xvf download
    cd fpc-3.0.4.x86_64-linux/
    ./install.sh
    ```

3. Pull sourcecode

    ```
    git clone https://github.com/kujirahand/sakuramml.git
    cd sakuramml
    ./make.sh
    ```

    ここまで来れば、警告がいくつか表示される物の、./csakuraという実行ファイルができているはず

### Compile (Raspberry pi)

```sh
sudo apt-get update
sudo apt-get install fpc
git clone https://github.com/kujirahand/sakuramml.git
cd sakuramml
./make.sh
```




>>>>>>> 82dc252f7b5f089a0e92096834bc56b8f2558607
