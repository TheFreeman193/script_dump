@echo off
setlocal DisableDelayedExpansion

for /f "delims=" %%G in ('git config --get remote.origin.url') do set _repo=%%G

set _tgt=CHANGELOG.tmp
set _filter="~log"

set _fmt="### Revision [%%h](%_repo%/commit/%%H)%%n%%ci By [%%an](%%ae) (%%cr)%%n```%%n%%B%%n```%%n"
set _fmt2="- %%cI [%%h](%_repo%/commit/%%H) - %%f"

git log --pretty=format:%_fmt% --reverse --until=%DATE% >>%_tgt%
REM git log --pretty=format:%_fmt% --reverse --grep=%_filter% --until=%DATE% >>%_tgt%

echo/>>%_tgt%
echo/>>%_tgt%
echo # Commit list>>%_tgt%
echo/>>%_tgt%

git log --pretty=format:%_fmt2% --reverse --until=%DATE% >>%_tgt%

set _outp=CHANGELOG.md
echo # Changelog (Compound)>%_outp%
echo #### Last Updated %DATE:~-4,4%/%DATE:~-7,2%/%DATE:~-10,2% %TIME:~0,-3% >>%_outp%
echo/>>%_outp%

for /f "eol=~ tokens=*" %%G in (%_tgt%) do @echo/%%G>>%_outp%

del %_tgt%

echo Done.
