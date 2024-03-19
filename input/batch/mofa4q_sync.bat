@REM This file starts using Mofa4Q variables and starts the Mof4Q project
:::::::::::::: FIXED PARAMETERS ::::::::::::::
@echo off
setlocal
set installFolder=c:\PROGRA~1\MoFa4Q
set FILE=%installFolder%\manifest.txt
set VAR_COMPANY=wheregroup

:::::::::::::: Progress ::::::::::::::

:::: Check MoFa4Q-Path exist?
IF exist "%FILE%" (
	for /f "delims=" %%a in (%FILE%) do set %%a
	:::: start cmd min
	if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
	goto qgis
) ELSE (
	echo "%FILE% not found! || If Errorlevel 1 Goto exit
	goto exit
)

:qgis
::: set QGIS program path and call o4w_env env
::: check QGIS_DIRECTORY-Path exist?
set QGIS_DIRECTORY="%qgisInstallPath%\bin"
IF exist "%QGIS_DIRECTORY%" (
    call %QGIS_DIRECTORY%\o4w_env.bat
    goto mofa4start
) ELSE (
	echo "%FILE% not found! || If Errorlevel 1 Goto exit
	goto exit
)


:mofa4start
::: set QGIS program path and call o4w_env env
IF DEFINED qgisSyncDev (
    set VAR_COMPANY=%qgisSyncDev%
)
IF NOT DEFINED qgisSyncDevServer (
    set qgisSyncDevServer=%qgisSyncDevServer%
)
IF NOT DEFINED profilePath (
	echo "%profilePath% not found! || If Errorlevel 1 Goto exit
	goto exit
)
IF NOT DEFINED installFolder (
	echo "%installFolder% not found! || If Errorlevel 1 Goto exit
	goto exit
)

python "%installFolder%\batch\mofa4q_sync.py" %installFolder% %profilePath%\profiles\%profileName% %VAR_COMPANY% %qgisSyncDevServer% || If Errorlevel 1 Goto exit

:exit
endlocal
if %errorlevel%==1 (
  ECHO "[ENDE] process finish."
  timeout 5 > NUL
  pause
  exit
)
ELSE (
    exit
)
