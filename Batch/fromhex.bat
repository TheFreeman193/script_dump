@echo off
REM TheFreeman193
REM Updated January 2018
if "%~1" EQU "-?" goto help
if "%~1" EQU "/?" goto help
setlocal
set tempf=%TEMP%\fromhex_%random%%random%
set inData=%~1
set msg=Decoding Hex...
set err=Something went wrong.
set errf=%err% File not written.
set filemode=0
if "%inData%" EQU "" goto help

if %inData:~0,1%==- goto checknext
if %inData:~0,1%==/ goto checknext
goto normal
:checknext
if /i %inData:~1,1%==f set filemode=1
if /i %inData:~1,1%==i set filemode=2

:normal
if %filemode% EQU 1 (
	if "%~3" EQU "" (
		REM FILE IN / STDOUT
		call :decode "%~2" "%tempf%1" >nul
		if exist "%tempf%1" ( type "%tempf%1" ) else ( echo %err% 1>&2 )
	) else (
		REM FILE IN / FILE OUT
		if exist "%~f3" goto fileexists
		echo:%msg%
		call :decode "%~2" "%~3"
		if exist "%~f3" ( echo Done. ) else ( echo %errf% 1>&2 )
	)
) else if %filemode% EQU 0 (
	echo:%inData%>"%tempf%1"
	if "%~2" EQU "" (
		REM ArgIn / STDOUT
		call :decode "%tempf%1" "%tempf%2" >nul
		if exist "%tempf%2" ( type "%tempf%2" ) else ( echo %err% 1>&2 )
	) else (
		REM ArgIn / FILE OUT
		if exist "%~f2" goto fileexists
		echo:%msg%
		call :decode "%tempf%1" "%~2"
		if exist "%~f2" ( echo Done. ) else ( echo %errf% 1>&2 )
	)
) else if %filemode% EQU 2 (
	REM echo Ctrl+Z --^> Enter to terminate:
	setlocal DisableDelayedExpansion
	for /F "tokens=*" %%j in ('findstr /n $') do (
	  set line=%%j
	  setlocal EnableDelayedExpansion
	  set line=!line:*:=!
	  echo/!line!>>"%tempf%1"
	  endlocal
	)
	if "%~2" EQU "" (
		REM STDIN / STDOUT
		call :decode "%tempf%1" "%tempf%2" >nul
		if exist "%tempf%2" ( type "%tempf%2" ) else ( echo %err% 1>&2 )
	) else (
		REM STDIN / FILE OUT
		if exist "%~f2" goto fileexists
	    echo:%msg%
		call :decode "%tempf%1" "%~2"
		if exist "%~f2" ( echo Done. ) else ( echo %errf% 1>&2 )
	)
) else echo %err%
goto done

:done
if EXIST "%tempf%1" del "%tempf%1"
if EXIST "%tempf%2" del "%tempf%2"
goto :eof

:fileexists
echo/Output file already exists^! Not continuing...
call :done
exit /b 183
goto :eof

:help
echo FROMHEX: Converts a raw hexadecimal string to text.
echo/
echo/
echo FROMHEX hex_string [output_file]
echo FROMHEX /F input_file [output_file]
echo command-name ^| FROMHEX /I  [output_file]
echo/
echo/
echo hex_string    Raw hex string to be converted
echo input_file    File containing raw hex string to be converted
echo output_file   File to write output text to. If not included, output is written to STDOUT
echo/
echo FROMHEX will not write to files that already exist.
echo Suitable for files of size 16MB or less.
echo/
goto :eof

REM FUNCTIONS =====================================
:decode
SETLOCAL
	certutil -decodehex "%~f1" "%~f2"
ENDLOCAL
goto :eof
