# Qt Installer Framework の非公式日本語翻訳ファイル
言語:&emsp;[English](README.md)&ensp;|&ensp;**日本語** 
## 背景
日本語環境においてQt Installer Framework 3.0.1 を使用してインストーラを作成したところ、一部の文字列に翻訳が適用されていないことに気付きました。ソースファイルを取得してビルドしても同様のため、未対応の翻訳をして適用させることにしました。ここではその手順を記載します。  
**※Windows用の手順のみ記載しています。**

## このリポジトリの構成
+ translations
    + qt5 &emsp; ... Qt5用翻訳済ファイルのディレクトリ
        + ....ts &emsp; ... 翻訳済ファイル
        + version.txt &ensp; ... 翻訳ファイルの対応バージョン
    + qtifw &emsp; ... Qt Installer Framework用翻訳済ファイルのディレクトリ
        + ja.ts &emsp; ... 翻訳済ファイル
        + version.txt &ensp; ... 翻訳ファイルの対応バージョン
+ LICENCE &emsp; ... License (GPL3-例外規定)
+ qtvars.bat &emsp; ... ビルド用環境設定バッチファイル
+ qtvars.lnk &emsp; ... cmd.exe で qtvars.batを起動する Winodws ショートカットファイル
+ README.md &emsp; ... このファイルの英語版
+ README_JA.md &emsp; ... このファイル

## Qt Installer Framework向け Qt のビルド
Qt installer Framework は通常 Qt のスタティック（静的）ライブラリを使用してビルドします。すでに Qt のスタティックライブラリを持っている場合はこの手順を飛ばすことができます。Qt のマニュアルを参考に行っても構いません。
> [Qt Installer Framework のマニュアル - http://doc.qt.io/qtinstallerframework/](http://doc.qt.io/qtinstallerframework/)

### Qt のソースコード取得とビルド
ここでは、ディレクトリ "`C:\Develop\Qt`" で作業を行うことを前提に説明します。
1. Git を使用して Qt のソースコード（最新版: この記述時点では 5.10.0 ）を取得します。Git を使用して次のようにします。  
※Qt サブモジュールで構成されているので `--recursive` オプションが必要です。

    ``` bat
    > cd C:\Develop\Qt
    > git clone --recursive https://github.com/qt/qt5.git
    ```

2. 作業ディレクトリ "`C:\Develop\Qt`" 内に、"`qt5`" というディレクトリが作成され、その中にソースファイルが展開されます。

3. ビルド環境を設定します。ここでは `MSVC2015 32ビット(x86)` でビルドすることにします。※64ビットでビルドすると、インストーラが64ビット専用になるのでお勧めしません。  
Windows のスタートメニューから `VS2015 x86 Native Tools Command Prompt`を選びます。先にコマンドプロンプトを起動した場合は、次のバッチファイルを起動します。(VS2015 x86 Native Tools Command Promptを使用する場合、バッチファイルの起動は不要です。)
    ``` sh
    > "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86 
    ```
    そして ディレクトリ "`C:\Develop\Qt\qt5`" へ移り、ビルド用のパスなどを設定します。
    ``` bat
    > set PATH=%CD%\qtbase\bin;%PATH%
    > set CL=/MP
    ```
    `qtbase\bin` へ検索パスを通すのは、Qtのビルド中にその中の `qmake.exe` などが使用されるからです。`qmake.exe` は、次で実行する `configure.bat` で生成されます。  
    `set CL=/MP` は nmakeで起動されるコンパイラ（cl.exe）がマルチプロセッサを使用できるようにするためです。もし、`jom` を使用するのであれば必要ありません。

4. `configure` スクリプト（バッチファイル）を実行します。ここでは最小限のビルドにし、スタティックライブラリにするためにオプションを指定します。
    ``` bat
    > configure -prefix %CD%\qtbase -release -static -static-runtime -accessibility -opensource -confirm-license -no-opengl -no-icu -no-sql-sqlite -no-qml-debug -nomake examples -nomake tests -skip qtactiveqt -skip qtenginio -skip qtlocation -skip qtmultimedia -skip qtserialport -skip qtquick1 -skip qtquickcontrols -skip qtscript -skip qtsensors -skip qtwebengine -skip qtwebsockets -skip qtxmlpatterns -skip qt3d 
    ```
    ※ Qt Installer Framework のマニュアルでは、`-skip qtwebkit` が含まれていますが、最新のQtでは `webkit` が同梱されなくなったので、指定するとエラーが生じます。

5. `nmake` を実行してビルドします。（多くの時間がかかります。PCのスペックにもよりますが、30分以上になります。）
    ``` bat
    > nmake
    ```
    ビルドが成功すると、ソースツリーの中の `qtbase` 内にライブラリや実行ファイルが作成されます。  
    これで Qt Installer Framework をビルドする準備ができました。


## Qt Installer Framework のビルド
。
ここでは、ディレクトリ "`C:\Develop\QtIFW`" で作業を行うことを前提に説明します。

1. Git を使用して Qt Installer Framework のソースコード（最新版）を取得します。Git を使用して次のようにします。（TortoiseGitのようなGUIツールを使用しても良いでしょう。）
    ``` sh
    > cd C:\Develop\QtIFW
    > git clone https://github.com/qtproject/installer-framework.git
    ```

2. 作業ディレクトリ "`C:\Develop\QtIFW`" 内に、"`installer-framework`" というディレクトリが作成され、その中にソースファイルが展開されます。

3. "`installer-framework`" へ移動し、次のようにビルドします。
    ``` sh
    > cd installer-framework
    > qmake && nmake
    ```

## Qt Install Framework の翻訳の更新
一度ビルドしておかないと、翻訳ファイルの更新を正常にうことができないので、ビルドしていない場合はまずビルドしてください。

### 翻訳ファイルの更新
まず、`.ts` ファイルを更新します。ここでは、日本語翻訳ファイルなので、`ja.ts` ファイルになります。ここはビルド環境のコマンドプロンプトで実行することになります。

1. "`C:\Develop\QtIFW\installer-framework\src\sdk`" へ移動します。
    ``` bat
    > cd C:\Develop\QtIFW\installer-framework\src\sdk
    ```
2. すでにこのバージョン用の翻訳ファイルを持っている場合は、`sdk\translations` ディレクトリ内へそのファイルをコピーします。（ここでは、`ja.ts` ファイル）  
持っていない場合は既存のものをそのままにしておきます。

2. 次のコマンドを入力します。（`sdk` ディレクトリで実行してください。`sdk\translations` ディレクトリでは**ありません**。）
    ``` bat
    > nmake ts-ja
    ```
    `ts-ja` という引数は日本語翻訳ファイルのみを更新します。すべての翻訳ファイルを更新するときは、`ts-all` を使用します。

これで日本語の翻訳ファイルが更新されました。更新されたファイルは、`installer-framework\src\sdk\translations`内にあります。
このファイルに翻訳を書き込んでいきます。通常は Linguist を使用して GUI で行います。

Linguistで開くと、左側の「コンテキスト」一覧の先頭に「？」が表示されているものがあるので、それをすべて翻訳します。「Ctrl + J」で未翻訳へジャンプできます。

翻訳が完了したら、「ファイル」－「リリース」で ja.qm ファイルを生成（更新）します。（`sdk\translations`内に作成されます。）

### 翻訳の適用
翻訳ファイルを更新したら、それを適用します。  

コマンドプロンプトで、（`src\sdk` 内で） 引数なしで nmake を起動します。
``` bat
> nmake
```

そうすると、rcc.exe により翻訳ファイルがリソースとして installerbase.exe に埋め込まれます。

これで次に binarycreator.exe でインストーラを作成すると、翻訳が反映されます。

### 翻訳が適用されたかどうかの確認
翻訳が適用されたかどうかを確認するため、サンプルのインストーラを生成します。サンプルは `installer-framework\examples` 内にあります。今回は tutorial を使用します。
``` bat
> cd installer-framework\examples\tutorial
```

次のコマンドでインストーラを作成できます。
``` bat
> ..\..\bin\binarycreator.exe -c config\config.xml -p packages testinstaller.exe
```

作成されたtestinstaller.exe を起動して翻訳が適用されているかどうかを確認してください。


## ボタンが翻訳されていない場合
"Next" などのボタンが翻訳されていない場合は、Qt 側の翻訳の問題です。
Qt Installer Framework は QWizard のウィジェットを使用して作成されています。そのため、"Next" や "Cancel" などのボタンは Qt 側の翻訳を更新し、Qt Installer Framework を再ビルドする必要があります。（インストーラの最初の画面の "Quit" ボタンは Qt Installer Framework の方の翻訳になります。

まず、Qt Installer Framework のビルドに使用した Qt ソース内で作業を行います。ここでは、"`C:\Develop\Qt`" の "`qt5`" というディレクトリに Qt のソースが展開され、スタティックにビルドされていると想定します。

1. まず、翻訳用のディレクトリに移り、翻訳ファイルを現在のソースに合わせるように更新します。（ここでは日本語の翻訳ファイルのみを更新しています。）
    ``` bat
    > cd qt5\qttranslation\translations
    > nmake ts-ja
    ```

2. Qt Installer Frameworkで表示されるのは、主に qtbase_ja.ts 内のものです。このファイルを Linguist を使用して不足分を翻訳します。（「？」が表示されている項目）

3. 翻訳終了後、一つ上のディレクトリ qttranslations へ移り、`.qm` ファイルの作成と適切に配置されるように、nmake します。
    ``` bat
    > cd ..
    > nmake
    ```
    これで、更新された翻訳が、`qt5\qtbase\translations` 内に配置されます。 Qt そのもののリビルドは必要ありません。

4. 次に Qt Installer Framework をリビルドします。  
    ディレクトリ "C:\Develop\QtIFW\installer-framework" へ移ります。
    ``` bat
    > cd C:\Develop\QtIFW\installer-framework
    ```

5. 再ビルドのために、一度クリーンを行い、ビルドします。ビルド時間を短縮するため、cl に対し /MP オプションを使用するように環境変数へセットすることをお勧めします。
    ``` bat
    > set CL=/MP
    > nmake clean && nmake
    ```

ビルドが終了したら、 `installer-framework\bin` 内の実行ファイルが更新されていることを確認してください。（更新されていないときは失敗しています。）

翻訳が適用されたかどうかを確認するため、サンプルのインストーラを生成します。サンプルは `installer-framework\examples` 内にあります。今回は `tutorial` を使用します。
``` bat
> cd installer-framework\examples\tutorial
```
次のコマンドでインストーラを作成できます。
``` bat
> ..\..\bin\binarycreator.exe -c config\config.xml -p packages testinstaller.exe
```

`testinstaller.exe` を起動して翻訳が適用されているかどうかを確認してください。
