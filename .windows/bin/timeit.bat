@setlocal enableextensions enabledelayedexpansion
@echo off
set start=%time%

call %*
echo Start: %start% 1>&2
echo End:   %time% 1>&2
endlocal
