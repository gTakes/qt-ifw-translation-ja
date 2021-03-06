# Qt Installer Framework's Unoffical Japanese Translation File
Language:&emsp;*English*&ensp;|&ensp;[日本語](README_JA.md) 
## Background
I created one installer using Qt Installer Framework 3.0.1 in Japanese environment, and I noticed that translation was not applied to some strings.  
Even if I get the source file and build it, I decided to translate the untranslated phrase and apply it. I will describe the procedure here.  
*Here is the steps for Windows only.*

## Structure of this repository
+ translations
    + qt5 &emsp; ... Directory of translated files for Qt5
        + ....ts &emsp; ... Translated file
        + version.txt &ensp; ... Corresponding version of the translated file
    + qtifw &emsp; ... Directory of a translated file for Qt Installer Framework
        + ja.ts &emsp; ... Translated file
        + version.txt &ensp; ... Corresponding version of the translated file
+ LICENCE &emsp; ... License (GPL3-EXCEPT)
+ qtvars.bat &emsp; ... Building environment setting batch file
+ qtvars.lnk &emsp; ... Launch qtvars.bat with cmd.exe Winodws shortcut file
+ README.md &emsp; ... 
English version of this file
+ README_JA.md &emsp; ... This file

## Build "Qt" for Qt Installer Framework
The Qt installer framework is usually built using Qt's static  library. If you already have a Qt static library you can skip this step. You can also refer to the Qt manual.
> [Qt Installer Framework's Manual - http://doc.qt.io/qtinstallerframework/](http://doc.qt.io/qtinstallerframework/)

### Get the Qt source code and build it
The explanation is as if the work is done in the directory "`C:\Develop\Qt`".
1. Use Git to get the Qt source code (latest version: 5.10.0 at the time of this writing).  
**"`--recursive`" option is required** since the Qt consists submodule. 

    ``` bat
    > cd C:\Develop\Qt
    > git clone --recursive https://github.com/qt/qt5.git
    ```

2. The directory "`qt5`" is created in the working directory "`C:\Develop\Qt`", and the source file is expanded in it.

3. Set the build environment. 
It is set to build with `MSVC 2015 32 bit (x86)`. Building with 64-bit is not recommended as the installer will be dedicated to 64 bits.  
Choose `VS2015 x86 Native Tools Command Prompt` from the Windows start menu.   
If you start the command prompt first, start the next batch file. (When using `VS2015 x86 Native Tools Command Prompt`, it is not necessary to start batch file.)
    ``` sh
    > "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86 
    ```
    Then go to the directory "`C:\Develop\Qt\qt5`" and set the search path and others for building.
    ``` bat
    > set PATH=%CD%\qtbase\bin;%PATH%
    > set CL=/MP
    ```
    The reason to pass the search path to `qtbase\bin` is to use `qmake.exe` inside it while building Qt. 
    `qmake.exe` is generated by `configure.bat` which is executed next.  
    
    `set CL=/MP` is to enable the compiler (cl.exe) started by nmake to use multiprocessor. If you use `jom` it is not necessary.

4. Run the `configure` script (batch file). 
In this case, options are specified to make them a minimal build and static libraries.
    ``` bat
    > configure -prefix %CD%\qtbase -release -static -static-runtime -accessibility -opensource -confirm-license -no-opengl -no-icu -no-sql-sqlite -no-qml-debug -nomake examples -nomake tests -skip qtactiveqt -skip qtenginio -skip qtlocation -skip qtmultimedia -skip qtserialport -skip qtquick1 -skip qtquickcontrols -skip qtscript -skip qtsensors -skip qtwebengine -skip qtwebsockets -skip qtxmlpatterns -skip qt3d 
    ```
    *The Qt Installer Framework manual includes "`-skip qtwebkit`", but "`qkwebkit`" is not included in the latest Qt, so if it is specified in an error will occur.*

5. Run "`nmake`" and build. (It will take a lot of time, it will be over 30 minutes, depending on the specs of the PC.)

    ``` bat
    > nmake
    ```
    
    When the build succeeds, libraries and executable files are created in the directory "`qtbase`" in the source tree.  
    Now that ready to build Qt Installer Framework.


## Build "Qt Installer Framework"

The explanation assumes that work is done in the directory "`C:\Develop\QtIFW`".

1. Use Git to get the source code (latest version) of Qt Installer Framework. (You may also use GUI tools like TortoiseGit.)
    ``` sh
    > cd C:\Develop\QtIFW
    > git clone https://github.com/qtproject/installer-framework.git
    ```

2. The diretory "`installer-framework`" is created in the working directory "`C:\Develop\QtIFW`", and the source files is expanded into it.

3. Go to directory "`installer-framework`" and build it as follows.
    ``` sh
    > cd installer-framework
    > qmake && nmake
    ```

## Update Qt Install Framework Translation File
If you do not build it once, you can not update the translation file normally, so please build first if you have not built it.

### Update translation file
First, update "`.ts`" file. In this case, since it handles Japanese translation files, it becomes "`ja.ts`" file. This will be executed by the command prompt of the build environment.

1. Go to the path "`C:\Develop\QtIFW\installer-framework\src\sdk`".
    ``` bat
    > cd C:\Develop\QtIFW\installer-framework\src\sdk
    ```
2. If you already have a translation file for this version, copy that file into the "`sdk\translations`" directory . (In this case, the "`ja.ts`" file)  
If you do not have it, leave the existing one.

2. Type the following command. (Please run in "`sdk`" directory **not in "sdk\translations" directory**.)
    ``` bat
    > nmake ts-ja
    ```
    The argument "`ts-ja`" updates only the Japanese translation file. To update all the translation files, use "`ts-all`".

The Japanese translation file has been updated.The updated file is located in "`installer-framework\src\sdk\translations`". 
Translation will be written to that file. Normally it will be done with GUI using Linguist.

When you open the file with Linguist, find "?" At the beginning of each item in the "Context" list on the left, translate the necessary items or all. You can jump to untranslated with "Ctrl + J".

After translation is completed, select "File" - "Release" from the menu and generate (or update) the "`ja.qm`" file. (It will be created in "`sdk\translations`".)

### Apply translation
Apply the translated file.  

Start "`nmake`" with no arguments using the command prompt (in "`src\sdk`").
``` bat
> nmake
```

Then, rcc.exe embeds the translation file as a resource into "installerbass.exe".

Next, if you create an installer with "binarycreator.exe", the translation will be reflected.

### Confirm whether translation has been applied
We will generate a sample installer to see if translation has been applied. The sample is in "`installer-framework\examples`". This time we will use "`tutorial`".
``` bat
> cd installer-framework\examples\tutorial
```

Create an installer with the following command.
``` bat
> ..\..\bin\binarycreator.exe -c config\config.xml -p packages testinstaller.exe
```

Run the created "testinstaller.exe" and check whether translation is applied.


## There are un-translated buttons
The reason why buttons such as "next" is not translated is probably on the Qt side.  
The Qt Installer Framework is created using QWizard widgets. Therefore, buttons such as "Next" and "Cancel" need to update Qt side translation and rebuild Qt Installer Framework. (However, the "Quit" button on the first showing of the installer is the translation of Qt Installer Framework.)

Work is done within the Qt source used to build the Qt Installer Framework. It will be explained on the condition that the source of Qt is expanded to "`qt5`" directory in "`C:\Develop\Qt`" and it is built statically.

1. Move to the directory for translation and update the translation file to match the current source.（In this case, updating    only Japnanese translation file.）
    ``` bat
    > cd qt5\qttranslation\translations
    > nmake ts-ja
    ```

2. Qt Installer Framework displays mainly in "qtbase_en.ts". Translate this file using Linguist for the shortfall. (Items on which "?" are displayed)

3. After the translation is over, up to the directory "`qttranslations`" and run "nmake" it so that the "`.qm`" file is placed in an appropriate directory.
    ``` bat
    > cd ..
    > nmake
    ```
    The updated translations will be placed  within "`qt5\qtbase\translations`". It is not necessary to rebuild Qt itself.

4. Next, rebuild Qt Installer Framework.  
    Change to the directory "C:\Develop\QtIFW\installer-framework".
    ``` bat
    > cd C:\Develop\QtIFW\installer-framework
    ```

5. After execute "nameke clean" once, rebuild it. In order to shorten the build time, it is recommended to set the environment variable to use "/MP" option for "cl.exe".
    ``` bat
    > set CL=/MP
    > nmake clean && nmake
    ```

When the build is finished, confirm that the executable files in "`installer-framework\bin`" are updated. (it is a failure If they are not updated.)

Generate a sample installer to see if translation has been applied. The sample is in "`installer-framework\examples`". This time we use "`tutorial`".
``` bat
> cd installer-framework\examples\tutorial
```
Type the following command so that create an installer.
``` bat
> ..\..\bin\binarycreator.exe -c config\config.xml -p packages testinstaller.exe
```

Execute "`testinstaller.exe`" to see if translation is applied.
