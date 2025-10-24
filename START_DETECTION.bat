@echo off
echo ================================================
echo   Starting Detection System
echo ================================================
echo.

REM Check if services are running
echo Checking services...
echo.

netstat -an | findstr ":8005" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [ERROR] DB Management API not running!
    echo Please run START_EVERYTHING.bat first.
    pause
    exit /b 1
)
echo [OK] DB Management API running

netstat -an | findstr ":8800" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [ERROR] Streaming API not running!
    echo Please run START_EVERYTHING.bat first.
    pause
    exit /b 1
)
echo [OK] Streaming API running

redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Redis not running!
    echo Please run START_EVERYTHING.bat first.
    pause
    exit /b 1
)
echo [OK] Redis running

echo.
echo ================================================
echo   All services ready!
echo ================================================
echo.
echo Starting detection with test video...
echo.
echo Press Ctrl+C to stop detection
echo.

REM Start detection
cd /d D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json

pause
