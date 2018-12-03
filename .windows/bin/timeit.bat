@setlocal enableextensions enabledelayedexpansion
@echo off
set start=%time%

call %*
echo Start: %start%
echo End:   %time%
endlocal
