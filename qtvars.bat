@echo off
rem chcp 65001
rem setlocal enabledelayedexpansion
set BAT_DIR=%~dp0

set VC_DIR="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC"
set QT_BIN_DIR=C:\Develop\Qt\qt5\qtbase\bin

set IS_NMAKE_ENABLED=0
call %VC_DIR%\vcvarsall.bat x86
where nmake.exe
if %ERRORLEVEL% == 0 (
	set IS_NMAKE_ENABLED=1
	echo "nmake.exe" is found.
)

set IS_QMAKE_ENABLED=0
set PATH=%QT_BIN_DIR%;%BAT_DIR%qt-creator;%PATH%
where qmake.exe
if %ERRORLEVEL% == 0 (
	set IS_QMAKE_ENABLED=1
	echo "qmake.exe" is found.
)


if %IS_NMAKE_ENABLED% == 0 (	
	echo;
	echo Could not find "nmake.exe".
	if defined VC_DIR (
		echo The directory specification of VC might be incorrect as follows:
		echo %VC_DIR%
	) else (
		echo VC_DIR is empty. Set the path of the directory where "nmake.exe" exists to VC_DIR.
	)
)
if %IS_QMAKE_ENABLED% == 0 (
	echo;
	echo Could not find "qmake.exe".
	if defined QT_BIN_DIR (
		echo The directory specification of Qt might be incorrect as follows:
		echo %QT_BIN_DIR%
	) else (
		echo QT_BIN_DIR is empty. Set the path of the directory where "qmake.exe" exists to QT_BIN_DIR.
	)
)

if %IS_NMAKE_ENABLED% == 1 (
	set RESULT_MESSAGE=MSVC
	if %IS_QMAKE_ENABLED% == 1 (
		set RESULT_MESSAGE=!RESULT_MESSAGE! and Qt
		
	) 
	set RESULT_MESSAGE=!RESULT_MESSAGE! tools are now available.
	
) else (
	if %IS_QMAKE_ENABLED% == 1 (
		set RESULT_MESSAGE=Qt tools are now available.
	)
)

if defined RESULT_MESSAGE (
	echo;
	echo %RESULT_MESSAGE%
)
