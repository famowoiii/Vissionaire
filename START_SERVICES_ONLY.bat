@echo off
title Start Services Only (No Detection)
color 0B
cls

echo ============================================================
echo   START SERVICES ONLY
echo   (Redis + DB API + Streaming API)
echo ============================================================
echo.

REM Check MySQL
echo [1/5] Checking MySQL...
netstat -an | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [ERROR] MySQL not running!
    echo Please start XAMPP MySQL first.
    pause
    exit /b 1
)
echo [OK] MySQL running

REM Clear Redis cache
echo.
echo [2/5] Clearing Redis cache...
redis-cli.exe FLUSHALL >nul 2>&1
echo [OK] Cache cleared

REM Start Redis
echo.
echo [3/5] Starting Redis Server...
redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    start "Redis Server - Port 6379" cmd /k "title Redis Server && cd /d D:\Construction-Hazard-Detection && redis-server.exe redis.windows.conf"
    timeout /t 3 /nobreak >nul
)
echo [OK] Redis started

REM Start DB API
echo.
echo [4/5] Starting DB Management API...
start "DB Management API - Port 8005" cmd /k "title DB Management API && cd /d D:\Construction-Hazard-Detection && uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005"
timeout /t 5 /nobreak >nul
echo [OK] DB API started

REM Start Streaming API
echo.
echo [5/5] Starting Streaming API...
start "Streaming Web API - Port 8800" cmd /k "title Streaming Web API && cd /d D:\Construction-Hazard-Detection && uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800"
timeout /t 5 /nobreak >nul
echo [OK] Streaming API started

echo.
echo ============================================================
echo   SERVICES READY!
echo ============================================================
echo.
echo Next: Run detection manually
echo   python main.py --config config\test_stream.json
echo.
pause
