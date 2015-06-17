@echo off
setlocal EnableDelayedExpansion

set repo=lemons

set tgt=TEMP_CHANGELOG
set filter="~log"

set fmt="## Revision [%%h](http://github.com/TheFreeman193/%repo%/commit/%%H)%%n```%%n%%B```%%n"
set fmt2="- [%%H](http://github.com/TheFreeman193/%repo%/commit/%%H) - %%f"

"%git_install_root%\cmd\git.exe" log --pretty=format:%fmt% --reverse --grep=%filter%>>%tgt%
echo. >>%tgt%
echo. >>%tgt%
echo # Commit list>>%tgt%
echo. >>%tgt%

"%git_install_root%\cmd\git.exe" log --pretty=format:%fmt2% --reverse --grep=%filter%>>%tgt%

set outp=CHANGELOG.md
echo # Changelog (Generated, Compound)>%outp%
echo.>>%outp%

for /f "eol=~ tokens=*" %%G in (%tgt%) do @echo.%%G>>%outp%

del TEMP_CHANGELOG

echo.Done.
pause