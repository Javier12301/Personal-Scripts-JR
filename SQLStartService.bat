@echo off
cls && color 0

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a")

call :DisplayColoredText 0A "net "
call :DisplayColoredText 0C " start "
call :DisplayColoredText 0E " MSSQLLaunchpad"
echo. &
net start MSSQLLaunchpad

call :DisplayColoredText 0A "net "
call :DisplayColoredText 0C " start "
call :DisplayColoredText 0E " MsDtsServer150"
echo. &
net start MsDtsServer150

call :DisplayColoredText 0A "net "
call :DisplayColoredText 0C " start "
call :DisplayColoredText 0E " SQLBrowser"
echo. &
net start SQLBrowser

call :DisplayColoredText 0A "net "
call :DisplayColoredText 0C " start "
call :DisplayColoredText 0E " MSSQLSERVER"
echo. &
net start MSSQLSERVER

goto :end

:DisplayColoredText
<nul set /p "=%DEL%" > "%~2"
findstr /v /a:%1 /R "+" "%~2" nul
del "%~2" > nul
goto :eof

:end
echo.

pause
