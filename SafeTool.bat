@echo off
chcp 437 >nul
title SafeTool Pro Max
mode con cols=80 lines=35
color 0A
cls

:: Auto Admin
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~f0""' -Verb RunAs" >nul 2>&1
    exit
)

:MENU
cls
echo.
echo        = SafeTool Pro Max =
echo.
echo 1. Full System Clean
echo 2. Desktop Dangerous File Scan
echo 3. Startup Item Manager
echo 4. Browser Cache Clean
echo 5. Log & Prefetch Clean
echo 6. Deep Temp Clean
echo 7. Exit
echo.
set /p "choice=Select an option: "

if "%choice%"=="1" goto FULLCLEAN
if "%choice%"=="2" goto SCAN
if "%choice%"=="3" goto STARTUP
if "%choice%"=="4" goto BROWSER
if "%choice%"=="5" goto LOGPREFETCH
if "%choice%"=="6" goto DEEPTEMP
if "%choice%"=="7" goto EXIT
goto MENU

:FULLCLEAN
cls
echo [1/8] Cleaning user temp files...
del /f /s /q "%temp%\*" >nul 2>&1
del /f /s /q "%localappdata%\Temp\*" >nul 2>&1

echo [2/8] Cleaning system temp files...
del /f /s /q "%windir%\Temp\*" >nul 2>&1

echo [3/8] Cleaning Windows Update cache...
del /f /s /q "%windir%\SoftwareDistribution\Download\*" >nul 2>&1

echo [4/8] Cleaning Edge cache...
del /f /s /q "%localappdata%\Microsoft\Windows\INetCache\*" >nul 2>&1
del /f /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1

echo [5/8] Cleaning Chrome cache...
del /f /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1

echo [6/8] Cleaning recent files...
del /f /s /q "%userprofile%\Recent\*" >nul 2>&1

echo [7/8] Cleaning prefetch...
del /f /s /q "%windir%\Prefetch\*" >nul 2>&1

echo [8/8] Cleaning system logs...
del /f /s /q "%windir%\Logs\*" >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Application >nul 2>&1

echo.
echo Clean completed successfully.
echo.
pause
goto MENU

:SCAN
cls
echo Scanning dangerous files on Desktop...
echo.
set count=0
for /r "%userprofile%\Desktop" %%i in (*.bat *.cmd *.vbs *.ps1 *.exe) do (
    echo Found: %%~nxi
    set /a count+=1
)
echo.
echo Scan finished. Total risky files: %count%
echo.
pause
goto MENU

:STARTUP
cls
echo Current Startup Items:
echo.
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run"
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
echo.
set /p "delstart=Enter startup name to delete: "
if not defined delstart goto MENU
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "%delstart%" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%delstart%" /f >nul 2>&1
echo Startup item disabled.
echo.
pause
goto MENU

:BROWSER
cls
echo Cleaning all browser caches...
del /f /s /q "%localappdata%\Microsoft\Windows\INetCache\*" >nul 2>&1
del /f /s /q "%localappdata%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /f /s /q "%localappdata%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /f /s /q "%appdata%\Mozilla\Firefox\Profiles\*\cache2\*" >nul 2>&1
echo.
echo Browser cache cleaned.
echo.
pause
goto MENU

:LOGPREFETCH
cls
echo Cleaning logs & prefetch...
del /f /s /q "%windir%\Prefetch\*" >nul 2>&1
del /f /s /q "%windir%\Logs\*" >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Application >nul 2>&1
echo.
echo Done.
echo.
pause
goto MENU

:DEEPTEMP
cls
echo Deep temporary file clean...
del /f /s /q "%temp%\*" >nul 2>&1
del /f /s /q "%localappdata%\Temp\*" >nul 2>&1
del /f /s /q "%windir%\Temp\*" >nul 2>&1
del /f /s /q "%windir%\SoftwareDistribution\Download\*" >nul 2>&1
echo.
echo Deep clean completed.
echo.
pause
goto MENU

:EXIT
cls
echo Thank you for using SafeTool Pro Max
timeout /t 2 >nul
exit