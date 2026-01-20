@echo off
:: Ensure script runs from its own directory even if "Run as Administrator"
cd /d "%~dp0"

NET SESSION >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

echo Building Lite-Dock natively for Windows...

:: Check if Go is installed
go version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Go is not installed or not in PATH.
    echo Please install Go from https://golang.org/dl/
    pause
    exit /b 1
)

:: Build the executable
go build -o lite-dock.exe .

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Build failed. Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo Installation Success!
echo You can now use lite-dock.exe natively.
echo Run: lite-dock.exe
echo ==========================================
pause
