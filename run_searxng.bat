@echo off
NET SESSION >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Requesting Administrator privileges to run containers...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

:: Switch to specific script directory to find local files
cd /d "%~dp0"

set IMAGE_NAME=searxng/searxng
set CONTAINER_NAME=searxng_debug
set SEARXNG_PORT=%1
if "%SEARXNG_PORT%"=="" set SEARXNG_PORT=8080

:: Ensure lite-dock.exe exists (reusing build logic)
if not exist "lite-dock.exe" (
    echo [Build] Lite-Dock binary missing. Building...
    set GOOS=windows
    set GOARCH=amd64
    go build -o lite-dock.exe main.go
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Build failed.
        pause
        exit /b
    )
)

echo ==============================================
echo Pulling and Running SearXNG via Lite-Dock...
echo Access it at http://localhost:8080 after start.
echo ==============================================

:: 1. Pull Image Natively
lite-dock.exe pull %IMAGE_NAME%
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to pull image.
    pause
    exit /b
)

:: 2. Configure SearXNG
echo Configuring SearXNG settings...
if exist "patch_entrypoint.py" (
    python patch_entrypoint.py
)

:: 3. Handover to Auto-Rotation Supervisor
echo [AutoMode] Starting Supervisor (Handles Proxy Rotation & Container Lifecycle)...
echo Press Ctrl+C to stop everything.
python auto_runner.py

pause
