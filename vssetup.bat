@echo off
REM
REM  Copyright (C) 2020 CA. All rights reserved.           
REM
REM ##------------------------------------------------------------------
REM ##  NAME:      vssetup.bat
REM ##
REM ##  PARMS:     [vsver] - Default is 2017.
REM ##
REM ##  PURPOSE:   Assist with setting environment variables for
REM ##             VS 2017 and beyond
REM ##             This script detemines the location of Visual Studio, 
REM ##             which includes Version and Offering.
REM ##                             
REM ##  MODIFICATIONS:
REM ##     RAL  07/11/2018  Initial creation
REM ##     RAL  08/13/2018  Add check for VS 2017 on 32bit systems
REM ##     RAL  05/28/2020  Add support for VS 2019
REM ##------------------------------------------------------------------

SETLOCAL

if not "%1" == "" set vsver=%1
if "%1" == "" set vsver=2017

REM ##
REM ## first, attempt to find vswhere on 32bit systems
REM ##
set vswhere="C:\Program Files\Microsoft Visual Studio\Installer\vswhere.exe"
dir %vswhere% > NUL 2>&1
if %ERRORLEVEL% == 0 goto vswhere_found

REM ##
REM ## second, attempt to find vswhere on 64bit systems
REM ##
set vswhere="C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
dir %vswhere% > NUL 2>&1
if not %ERRORLEVEL% == 0 goto vswhere_not_found

REM ##
REM ## locate any Visual Studio 2017 and newer installations
REM ##
:vswhere_found
%vswhere% -products * -property installationPath > %TEMP%\vswhere.tmp

REM ##
REM ## collect Visual Studio location based on supplied Visual Studio version
REM ##
set vslocation="location not found"
for /f "tokens=*" %%i in (%TEMP%\vswhere.tmp) do call :process_location "%%i"

del %TEMP%\vswhere.tmp > NUL

if %vslocation% == "location not found%" goto vsver_not_found

REM ##
REM ## Set Visual Studio version based on Visual Studio Product
REM ##
if "%vsver%" == "2017" set ver=VS150
if "%vsver%" == "2019" set ver=VS160

ENDLOCAL & set cagen_vs_ver=%ver%& set VSINSTALLDIR=%vslocation:"=%\& set VCINSTALLDIR=%vslocation:"=%\VC\

REM ##
REM ## set VS***COMNTOOL prefix based on VS version
REM ##
set %cagen_vs_ver%COMNTOOLS=%VSINSTALLDIR%Common7\Tools\
echo VCINSTALLDIR is %VCINSTALLDIR%
echo VSINSTALLDIR is %VSINSTALLDIR%
call echo %cagen_vs_ver%COMNTOOLS is %%%cagen_vs_ver%COMNTOOLS%%
set cagen_vs_ver=

REM ##
REM ## VS no longer adds HTML Help Workshop to PATH.  
REM ## CA Gen's generated GUI clients still use CHM files,
REM ## so we need to add this to the PATH.
REM ##

if exist "C:\Program Files\HTML Help Workshop" set PATH=C:\Program Files\HTML Help Workshop;%PATH%
if exist "C:\Program Files (x86)\HTML Help Workshop" set PATH=C:\Program Files (x86)\HTML Help Workshop;%PATH%
goto end

:process_location
for /f "tokens=4 delims=\" %%j in (%1) do (
    if %%j == %vsver% set vslocation=%1
    )
goto :eof

goto end

:vsver_not_found
@echo.
@echo *
@echo * Visual Studio version passed to vssetup.bat (%vsver%) was not found.
@echo * Verify that version of Visual Studio passed in is installed.
@echo *
goto end

:usage
@echo.
@echo *
@echo * VSSETUP.BAT is used to assist with setting environment variables for VS 2017 and beyond
@echo *
@echo * Usage:
@echo *     vssetup.bat [vsver]
@echo *
@echo * Where [vsver] is Visual Studio version.  Default is 2017.
@echo *
goto end

:vswhere_not_found
@echo.
@echo *
@echo * The Visual Studio Locator  vswhere  was not found.
@echo * Please ensure that you have properly installed Visual Studio 2017 or newer.
@echo *
goto end

:end
@echo off
ENDLOCAL
