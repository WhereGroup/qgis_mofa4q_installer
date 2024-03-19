@ECHO ON
@GOTO :search

if _%1_==_payload_  goto :search

:getadmin
    echo %~nx0: elevating self
    set vbs=%temp%\getadmin.vbs
    echo Set UAC = CreateObject^("Shell.Application"^)                >> "%vbs%"
    echo UAC.ShellExecute "%~s0", "search %~sdp0 %*", "", "runas", 1 >> "%vbs%"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
goto :eof

:search
for /f %%a in ('dir /B /AD C:\Users') do (
    if exist "C:\Users\%%a\Desktop\MoFa4Q*.lnk" del /S /F /Q /A "C:\Users\%%a\Desktop\MoFa4Q*.lnk"
)
goto :finished

:finished
echo.
echo All Icons removed from users desktops!
echo.
goto :eof

