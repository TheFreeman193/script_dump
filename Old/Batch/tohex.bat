@echo off
REM TheFreeman193
REM Updated January 2018
if "%~1" EQU "-?" goto help
if "%~1" EQU "/?" goto help
setlocal 
set tempf=%TEMP%\tohex_%random%%random%
set inData=%~1
set msg=Writing Hex...
set msg2=Formatting Raw Hex. This may take a while...
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
		call :makehex "%~f2" "%tempf%1" >nul
		call :sorthex "%tempf%1" "%tempf%2" >nul
		if exist "%tempf%2" ( type "%tempf%2" ) else ( echo %err% 1>&2 )
	) else (
		REM FILE IN / FILE OUT
		if exist "%~f3" goto fileexists
		echo:%msg%
		call :makehex "%~f2" "%tempf%1"
		echo:%msg2%
		call :sorthex "%tempf%1" "%~f3"
		if exist "%~f3" ( echo Done. ) else ( echo %errf% 1>&2 )
	)
) else if %filemode% EQU 0 (
	echo:|set /p ="%inData%">"%tempf%1"
	if "%~2" EQU "" (
		REM ArgIn / STDOUT
		call :makehex "%tempf%1" "%tempf%2" >nul
		del "%tempf%1"
		call :sorthex "%tempf%2" "%tempf%1" >nul
		if exist "%tempf%1" ( type "%tempf%1" ) else ( echo %err% 1>&2 )
	) else (
		REM ArgIn / FILE OUT 
		if exist "%~f2" goto fileexists
	    echo:%msg%
		call :makehex "%tempf%1" "%tempf%2"
		echo:%msg2%
		call :sorthex "%tempf%2" "%~f2"
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
		call :makehex "%tempf%1" "%tempf%2" >nul
		del "%tempf%1"
		call :sorthex "%tempf%2" "%tempf%1"
		if exist "%tempf%1" ( type "%tempf%1" ) else ( echo %err% 1>&2 )
	) else (
		REM STDIN / FILE OUT
		if exist "%~f2" goto fileexists
	    echo:%msg%
		call :makehex "%tempf%1" "%tempf%2"
		echo:%msg2%
		call :sorthex "%tempf%2" "%~f2"
		if exist "%~f2" ( echo Done. ) else ( echo %errf% 1>&2 )
	)
) else echo %err%
goto done

:done
if exist "%tempf%1" del "%tempf%1"
if exist "%tempf%2" del "%tempf%2"
goto :eof

:fileexists
echo/Output file already exists^! Not continuing...
call :done
exit /b 183
goto :eof

:help
echo TOHEX: Converts text to a raw hexadecimal string.
echo/
echo/
echo TOHEX text_string [output_file]
echo TOHEX /F input_file [output_file]
echo command-name ^| TOHEX /I [output_file]
echo/
echo/
echo text_string   Text string to be converted to hex
echo input_file    File containing text string to be converted
echo output_file   File to write output hex to. If not included, output is written to STDOUT
echo/
echo TOHEX will not write to files that already exist.
echo Suitable for files of size 16MB or less.
echo/
goto :eof

REM FUNCTIONS =====================================
:makehex
setlocal
	certutil -encodehex "%~f1" "%~f2"
endlocal
goto :eof

:sorthex
setlocal
	powershell -Command "(gc %~f1) -replace '\w+\t([\s\w]{23})\s\s([\s\w]{23})\s{3}.+','$1 $2' | Out-File -NoClobber -Encoding ASCII -LiteralPath %~f2"
	if errorlevel 1 goto fileexists
endlocal
goto :eof
