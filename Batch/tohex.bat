@echo off
REM TheFreeman193
REM Updated January 2018
if "%~1" EQU "-?" goto help
if "%~1" EQU "/?" goto help
setlocal 
set tmp=%TEMP%\tohex_%random%%random%
set "inData=%~1"
set msg=Writing Hex...
set filemode=0
IF "%inData%" EQU "" goto use_stdin

if %inData:~0,1%==- goto checknext
if %inData:~0,1%==/ goto checknext
goto normal
:checknext
if /i %inData:~1,1%==f set filemode=1

:normal
if /i %filemode% EQU 1 (
	if "%~3" EQU "" (
		REM FILE IN / STDOUT
		call :makehex "%~2" "%tmp%1" >nul
		call :sorthex "%tmp%1" "%tmp%2"
		type "%tmp%2"
	) ELSE (
		REM FILE IN / FILE OUT
		if exist "%~f3" goto fileexists
		echo:%msg%
		call :makehex "%~2" "%tmp%1"
		call :sorthex "%tmp%1" "%~3"
		echo Done.
	)
) ELSE (
	echo:|set /P ="%inData%">"%tmp%1"
	if "%~2" EQU "" (
		REM ArgIn / STDOUT
		call :makehex "%tmp%1" "%tmp%2" >nul
		call :sorthex "%tmp%2" "%tmp%1"
		type "%tmp%1"
	) ELSE (
		REM ArgIn / FILEOUT 
		if exist "%~f2" goto fileexists
	    echo:%msg%
		call :makehex "%tmp%1" "%tmp%2"
		call :sorthex "%tmp%2" "%~2"
		echo Done.
	)
)
goto done

:use_stdin
REM STDIN / STDOUT
REM echo Ctrl+Z --^> Enter to terminate:
setlocal DisableDelayedExpansion
for /F "tokens=*" %%a in ('findstr /n $') do (
  set "line=%%a"
  setlocal EnableDelayedExpansion
  set "line=!line:*:=!"
  echo/!line!>>"%tmp%1"
  endlocal
)
call :makehex "%tmp%1" "%tmp%2" >nul
call :sorthex "%tmp%2" "%tmp%1"
type "%tmp%1"
goto done

:done
if EXIST "%tmp%1" del "%tmp%1"
if EXIST "%tmp%2" del "%tmp%2"
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
echo TOHEX [text_string] [output_file]
echo command-name ^| TOHEX
echo TOHEX /F input_file [output_file]
echo/
echo/
echo text_string   Text string to be converted to hex
echo input_file    File containing text string to be converted
echo output_file   File to write output hex to. If not included, output is written to STDOUT
echo/
echo Calling TOHEX without parameters will cause it to accept STDIN and write to STDOUT.
echo TOHEX will not write to files that already exist.
echo/
goto :eof

REM FUNCTIONS =====================================
:makehex
SETLOCAL
	certutil -encodehex "%1" "%2"
ENDLOCAL
goto :eof

:sorthex
SETLOCAL
	powershell -Command "(gc %1) -replace '\w+\t([\s\w]{23})\s\s([\s\w]{23})\s{3}.+','$1 $2' | Out-File -NoClobber -LiteralPath %2" >nul
	if ERRORLEVEL 1 goto fileexists
ENDLOCAL
goto :eof

