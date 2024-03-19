@REM Diese Datei startet mithilfe Mofa4Q variablen und startet das Mof4Q-Projekt
:::::::::::::: FIXED PARAMETERS ::::::::::::::
@echo off
set installFolder=c:\PROGRA~1\MoFa4Q
set qgisInstallPath=c:\PROGRA~1\QGIS
set FILE=%installFolder%\manifest.txt
for /f "delims=" %%a in (%FILE%) do set %%a
:::::::::::::: Progress ::::::::::::::

:::: Check MoFa4Q-Path exist?
IF exist "%FILE%" (
	for /f "delims=" %%a in (%FILE%) do set %%a
	goto qgis
) ELSE (
	echo "%FILE% nicht gefunden! || If Errorlevel 1 Goto exit
	goto exit
)

:qgis
::: call QGIS Programm with parameters
::: Check QGIS_DIRECTORY-Path exist?
IF exist "%qgisInstallPath%\bin\%qgisReleaseVersion%.bat" (
    "%qgisInstallPath%\bin\%qgisReleaseVersion%.bat" --skipbadlayers --noversioncheck --profiles-path "%profilePath%" --profile "%profileName%" || If Errorlevel 1 Goto exit
    goto mofa4start
) ELSE (
	echo "%qgisInstallPath%\bin\%qgisReleaseVersion%.bat" || If Errorlevel 1 Goto exit
	goto exit
)

:exit
ECHO [ENDE] Prozess beendet.
if %errorlevel%==1 (
  timeout 5 > NUL
  pause
  exit
)