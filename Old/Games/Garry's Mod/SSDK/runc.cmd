@echo off
tasklist /fi "IMAGENAME eq hl2.exe" >nul | find /I /N "hl2.exe" >nul
if "%ERRORLEVEL%"=="0" do (
	"%SteamDir%\common\GarrysMod\hl2.exe" -hijack +quit
	ping localhost >nul
)
start /b mdlcompile %%1
ping localhost >nul
echo Running GMod.
start /D "%SteamDir%\common\GarrysMod" hl2.exe -condebug +map gm_construct
echo Done.