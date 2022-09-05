@echo off
@echo.
@echo GENENV: CA Gen Visual Studio Runtime Environment Setup Procedure
@echo.
REM
REM  Copyright (C) 2020 CA. All rights reserved.           
REM
REM ##------------------------------------------------------------------
REM ##  NAME:      genenv [bits] [vsver]
REM ##
REM ##  PARMS:     [bits]  - either 32 or 64.  Default is 32.
REM ##  PARMS:     [vsver] - either 2010, 2012, 2015, 2017 or 2019.  Default is 2015.
REM ##
REM ##  NOTES:     This procedure will set the appropriate Visual Studio
REM ##             compiler environment variables based on bits and version.
REM ##             Also, the appropriate GEN runtime path will be added to
REM ##             the PATH environment variable for application execution.
REM ##
REM ##  MODIFICATIONS:
REM ##     RAL  12/01/11  Initial Release
REM ##     RAL  02/04/12  Support both VS2010 and VS2012
REM ##     RAL  07/12/18  Add Support for VS2017
REM ##     RAL  05/28/20  Add Support for VS2019
REM ##------------------------------------------------------------------

SETLOCAL

set bits=0
if "%1" == "32" set bits=32
if "%1" == "64" set bits=64
if "%1" == ""   set bits=32
if "%bits%" == "0" goto usage

set ver=0
if "%2" == "2010" set ver=VS100
if "%2" == "2012" set ver=VS110
if "%2" == "2015" set ver=VS140
if "%2" == "2017" set ver=VS150
if "%2" == "2019" set ver=VS160
if "%2" == ""     set ver=VS140
if "%ver%" == "0" goto usage

ENDLOCAL & set compiler_ver=%ver%& set vsbits=%bits%
set compiler_num=%compiler_ver:~2,3%

REM *******************************************************
REM
REM Setup Visual Studio 32 or 64 bit runtime environment
REM
REM *******************************************************

if "%compiler_num%" GEQ "150" call "%GEN86%Gen\vssetup.bat" %2

set batchFile=vsvars32.bat
if "%compiler_num%" GEQ "150" set batchFile=VsDevCmd.bat

REM
REM Determine if selected VS version is installed.
REM

if not defined %compiler_ver%COMNTOOLS (
  goto error_no_vscomntools	
) else (
  call "%%%compiler_ver%COMNTOOLS%%%batchFile%"
)

set PATH=%GEN86%Gen;%PATH%
@echo.
@echo %GEN86%Gen added to front of PATH

if %vsbits% == 32 goto end

if "%VCINSTALLDIR%" == "" goto error_no_vcinstalldir
if "%compiler_num%" GEQ "150" (
  call "%VCINSTALLDIR%Auxiliary\Build\vcvarsall.bat" x64
) else (
  call "%VCINSTALLDIR%vcvarsall.bat" x64
)

set PATH=%GEN86%Gen\amd64;%PATH%
@echo.
@echo %GEN86%Gen\amd64 added to front of PATH
goto end

:error_no_vscomntools
@echo ERROR: Cannot determine the location of Visual Studio %2.
@echo        The specified version of Visual Studio may not be installed.
goto end

:error_no_vcinstalldir
@echo ERROR: Cannot determine the location of Visual Studio %2.
@echo        Environment variable %VCINSTALLDIR% is not currently set.
goto end

:usage
@echo.
@echo * GENENV.BAT is used to setup your Visual Studio command line execution environment.
@echo *
@echo * Usage:
@echo *     genenv.bat [bits] [vsver]
@echo *
@echo * Where [bits] is either 32 or 64. The default is 32.
@echo *       [vsver] is either 2010, 2012, 2015, 2017 or 2019.  Default is 2015.
@echo *
ENDLOCAL

:end
@echo OFF
