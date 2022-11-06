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




