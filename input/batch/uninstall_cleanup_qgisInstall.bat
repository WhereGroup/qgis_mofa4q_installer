@echo OFF
if "%1"=="runas" (
  cd %~dp0
) else (
  powershell Start -File "cmd '/C %~f0 runas'" -Verb RunAs
)

set installFolder=c:\PROGRA~1\MoFa4Q
set FILE=%installFolder%\manifest.txt

for /f "delims=" %%a in (%FILE%) do set %%a

@GOTO :search

if _%1_==_payload_  goto :search

:search
    if exist "%qgisInstallPath%" rd /q /s "%qgisInstallPath%"

goto :finished

:finished
echo.
echo All Files removed from "%qgisInstallPath%"!
echo.
goto :eof

