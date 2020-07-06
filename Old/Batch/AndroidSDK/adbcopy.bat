@echo off
REM adb shell cp -rL data/data/<DIR>/ external_sd/_dta
REM adb shell cp -rL data/data/com.google.android.gms/code_cache/secondary-dexes external_sd/_dta
REM com.google.android.gms-1.apk.classes2.dex

setlocal EnableDelayedExpansion
REM ====================== settings ================================
set _adbpath=D:\Program Files (x86)\Android\android-sdk\platform-tools
set _frompath=data/data
set _topath=external_sd/_dta2
set _stamp=%time:~0,2%_%time:~3,2%_%time:~6,2%
set _list=%~dp0adbcopy%_stamp%
set _tmp1=%_list%.tmp
set _log=%_list%.log
set _list=%_list%.txt
REM ================================================================

REM Check if dir list provided
IF [%1] NEQ [] (
IF EXIST "%1" (
	set _list=%~f1
	set _ext=1
)
)

REM Set location
%_adbpath:~0,2%
cd %_adbpath%

echo ===== ADBCopy v2 By TheFreeman193 ===== >%_log%
echo Date: %DATE% >>%_log%
echo Time: %TIME:~0,-3% >>%_log%
echo Settings: >>%_log%
echo/    Source: %_frompath% >>%_log%
echo/    Destination: %_topath% >>%_log%
echo/    Log File: %_log% >>%_log%
IF DEFINED _ext (
	echo/    List File ^(EXTERNAL^): %_list% >>%_log%
) ELSE (
	echo/    Temporary File^(s^): %_tmp1% >>%_log%
	echo/    List File: %_list% >>%_log%
)
echo/    ADB path: %_adbpath% >>%_log%
echo ======================================= >>%_log%

REM No need to generate dir list
IF DEFINED _ext (
echo %TIME%: External directory list provided, no need to ls. >>%_log%
goto docopy
)

REM ------- DIR LIST GENERATION -------

REM get raw dir list from adb
echo %TIME%: Retrieving dir list, writing to temp >>%_log%
adb shell ls -1 %_frompath%/ >%_tmp1%

REM empty output file
echo %TIME%: Emptying list file >>%_log%
echo. 1>NUL 2>%_list%

echo %TIME%: Cleaning dir list, writing to list file >>%_log%
REM clear trailing carriage returns
FOR /F "usebackq tokens=*" %%G IN ("%_tmp1%") DO (
	set _outp=%%G
	echo !_outp:~0,-1! >>%_list%
)

REM remove temp file
echo %TIME%: Cleanup temp file >>%_log%
del %_tmp1%
echo.

REM ------- FILE COPY -------

:docopy

REM prompt check and ask to continue
echo %TIME%: Waiting for user prompt to continue... >>%_log%
echo Check %_list% before continuing.
choice /C:YN /M "Continue"
IF ERRORLEVEL 2 goto cancel
echo %TIME%: User confirmed >>%_log%

REM make dest
echo %TIME%: Make dest dir >>%_log%
adb shell mkdir -p %_topath% 2>>%_log%

REM run copy
set _count=0
echo %TIME%: Starting copy... >>%_log%
FOR /F "usebackq tokens=1" %%G IN ("%_list%") DO (
	echo !TIME!: Copying %_frompath%/%%G/ --^> %_topath%/%%G >>%_log%
	echo Copying "%%G"...
	adb shell cp -rL %_frompath%/%%G/ %_topath% 1>&2 2>>%_log%
	set /A _count+=1
	echo !TIME!: Done %%G. >>%_log%
)
echo.
echo.
echo %TIME%: Finished copying %_count% dirs. >>%_log%
echo Copying complete. Copied %_count% directories.

goto end
:cancel
echo %TIME%: User cancelled. >>%_log%
goto final
:end
IF DEFINED _ext goto final
echo %TIME%: User prompt to delete list file. >>%_log%
choice /C:YN /M "Delete list file"
IF ERRORLEVEL 2 goto final
echo %TIME%: Cleanup files >>%_log%
del %_list%
:final
echo Log finish %DATE% %TIME%. >>%_log%
echo Done.
pause
