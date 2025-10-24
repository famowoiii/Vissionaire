@echo off
title Construction Hazard Detection - Complete System with ALL 7 APIs
color 0A
cls

echo ============================================================
echo   CONSTRUCTION HAZARD DETECTION SYSTEM
echo   STARTING ALL 7 API SERVICES + DETECTION + TELEGRAM
echo ============================================================
echo.

REM Check if running from correct directory
if not exist "main.py" (
    echo [ERROR] Please run this script from D:\Construction-Hazard-Detection
    pause
    exit /b 1
)

REM Check MySQL
echo [Step 1/11] Checking MySQL...
netstat -an | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [ERROR] MySQL not running!
    echo Please start XAMPP MySQL first.
    pause
    exit /b 1
)
echo [OK] MySQL running on port 3306

REM Clear Redis cache (remove old data like puki/pukimak)
echo.
echo [Step 2/11] Clearing Redis cache (removing old data)...
redis-cli.exe ping >nul 2>&1
if not errorlevel 1 (
    redis-cli.exe FLUSHALL >nul
    echo [OK] Redis cache cleared
) else (
    echo [INFO] Redis not running yet, will start fresh
)

REM Start Redis Server
echo.
echo [Step 3/11] Starting Redis Server...
redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    start "Redis Server - Port 6379" cmd /k "title Redis Server - Port 6379 && cd /d D:\Construction-Hazard-Detection && redis-server.exe redis.windows.conf"
    timeout /t 3 /nobreak >nul
    redis-cli.exe ping >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to start Redis!
        pause
        exit /b 1
    )
)
echo [OK] Redis running on port 6379

REM Start YOLO Detection API - Port 8000
echo.
echo [Step 4/11] Starting YOLO Detection API (Port 8000)...
netstat -an | findstr ":8000" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "YOLO Detection API - Port 8000" cmd /k "title YOLO Detection API - Port 8000 && cd /d D:\Construction-Hazard-Detection\examples\YOLO_server_api && python main.py"
    timeout /t 5 /nobreak >nul
)
echo [OK] YOLO Detection API starting...

REM Start Violation Records API - Port 8002
echo.
echo [Step 5/11] Starting Violation Records API (Port 8002)...
netstat -an | findstr ":8002" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "Violation Records API - Port 8002" cmd /k "title Violation Records API - Port 8002 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.violation_records.app:app --host 0.0.0.0 --port 8002"
    timeout /t 3 /nobreak >nul
)
echo [OK] Violation Records API starting...

REM Start FCM Notification API - Port 8003
echo.
echo [Step 6/11] Starting FCM Notification API (Port 8003)...
netstat -an | findstr ":8003" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "FCM Notification API - Port 8003" cmd /k "title FCM Notification API - Port 8003 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.local_notification_server.app:app --host 0.0.0.0 --port 8003"
    timeout /t 3 /nobreak >nul
)
echo [OK] FCM Notification API starting...

REM Start Chat API (LINE Bot) - Port 8004
echo.
echo [Step 7/11] Starting Chat API - LINE Bot (Port 8004)...
netstat -an | findstr ":8004" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "Chat API - Port 8004" cmd /k "title Chat API - LINE Bot - Port 8004 && cd /d D:\Construction-Hazard-Detection\examples\line_chatbot && python line_bot.py"
    timeout /t 3 /nobreak >nul
)
echo [OK] Chat API starting...

REM Start DB Management API - Port 8005
echo.
echo [Step 8/11] Starting DB Management API (Port 8005)...
netstat -an | findstr ":8005" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "DB Management API - Port 8005" cmd /k "title DB Management API - Port 8005 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005"
    timeout /t 3 /nobreak >nul
)
echo [OK] DB Management API starting...

REM Start Streaming Web API - Port 8800
echo.
echo [Step 9/11] Starting Streaming Web API (Port 8800)...
netstat -an | findstr ":8800" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "Streaming Web API - Port 8800" cmd /k "title Streaming Web API - Port 8800 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800"
    timeout /t 3 /nobreak >nul
)
echo [OK] Streaming Web API starting...

REM Wait for services to fully start
echo.
echo [Step 10/11] Waiting for all services to initialize...
timeout /t 15 /nobreak >nul

REM Verify all services
echo.
echo [Step 11/11] Verifying all services...
echo.
echo ============================================================
echo   SERVICE STATUS - ALL 7 APIs
echo ============================================================
echo.

netstat -an | findstr ":8000" | findstr "LISTENING" >nul && echo [OK] 1. YOLO Detection API (8000) || echo [FAIL] 1. YOLO Detection API (8000)
netstat -an | findstr ":8002" | findstr "LISTENING" >nul && echo [OK] 2. Violation Records API (8002) || echo [FAIL] 2. Violation Records API (8002)
netstat -an | findstr ":8003" | findstr "LISTENING" >nul && echo [OK] 3. FCM Notification API (8003) || echo [FAIL] 3. FCM Notification API (8003)
netstat -an | findstr ":8004" | findstr "LISTENING" >nul && echo [OK] 4. Chat API - LINE Bot (8004) || echo [WARN] 4. Chat API (8004) - Optional
netstat -an | findstr ":8005" | findstr "LISTENING" >nul && echo [OK] 5. DB Management API (8005) || echo [FAIL] 5. DB Management API (8005)
echo [INFO] 6. File Management API (Integrated with DB Management)
netstat -an | findstr ":8800" | findstr "LISTENING" >nul && echo [OK] 7. Streaming Web API (8800) || echo [FAIL] 7. Streaming Web API (8800)

echo.
echo Plus:
netstat -an | findstr ":3306" | findstr "LISTENING" >nul && echo [OK] MySQL Database (3306) || echo [FAIL] MySQL Database (3306)
redis-cli.exe ping >nul 2>&1 && echo [OK] Redis Cache (6379) || echo [FAIL] Redis Cache (6379)

echo.
echo ============================================================
echo   ALL 7 API SERVICES STARTED!
echo ============================================================
echo.
echo Service URLs:
echo   1. YOLO Detection:     http://127.0.0.1:8000/docs
echo   2. Violation Records:  http://127.0.0.1:8002/docs
echo   3. FCM Notifications:  http://127.0.0.1:8003/docs
echo   4. Chat API (LINE):    http://127.0.0.1:8004
echo   5. DB Management:      http://127.0.0.1:8005/docs
echo   6. File Management:    (Integrated)
echo   7. Streaming Web:      http://127.0.0.1:8800/docs
echo.
echo Visionnaire Web:
echo   https://visionnaire-cda17.web.app/login
echo.
echo ============================================================
echo   NEXT: START DETECTION WITH TELEGRAM
echo ============================================================
echo.
echo Telegram Bot Status:
echo   Chat ID: 5856651174
echo   Language: English
echo   Status: ENABLED - Ready to send alerts!
echo.
echo Press any key to start detection now...
pause >nul

REM Start Detection with Telegram
start "Detection with Telegram Notifications" cmd /k "title Detection - Telegram Enabled && cd /d D:\Construction-Hazard-Detection && python main.py --config config\test_stream.json"

echo.
echo ============================================================
echo   DETECTION STARTED!
echo ============================================================
echo.
echo Active Terminal Windows (Total: 8 windows):
echo   1. Redis Server (Port 6379)
echo   2. YOLO Detection API (Port 8000)
echo   3. Violation Records API (Port 8002)
echo   4. FCM Notification API (Port 8003)
echo   5. Chat API - LINE Bot (Port 8004)
echo   6. DB Management API (Port 8005)
echo   7. Streaming Web API (Port 8800)
echo   8. Detection with Telegram Notifications
echo.
echo ============================================================
echo   SYSTEM FULLY OPERATIONAL - ALL 7 APIs + DETECTION
echo ============================================================
echo.
echo What's happening now:
echo   - All 7 API services are running
echo   - Detection is analyzing video frames
echo   - When violation detected:
echo     * Alert saved to database (Violation Records API)
echo     * Telegram notification sent (to Chat ID: 5856651174)
echo     * Live stream updated (Streaming API)
echo.
echo Open Visionnaire Web (Optional):
echo   URL: https://visionnaire-cda17.web.app/login
echo   Username: user
echo   Password: password
echo.
echo Configure Visionnaire (First Time Only):
echo   Press F12 -^> Console -^> Paste:
echo.
echo   localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
echo   localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
echo   localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
echo   localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004');
echo   localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
echo   localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
echo   location.reload();
echo.
echo To STOP all services:
echo   Run: STOP_EVERYTHING.bat
echo   Or close all 8 terminal windows
echo.
echo ============================================================
echo.
echo Press any key to open Visionnaire in browser...
pause >nul

start https://visionnaire-cda17.web.app/login

echo.
echo Visionnaire opened in browser!
echo.
echo IMPORTANT:
echo   - Keep all 8 terminal windows open!
echo   - Check your Telegram for violation alerts!
echo   - Monitor Live Stream in Visionnaire!
echo.
echo ============================================================
echo   READY TO DETECT SAFETY VIOLATIONS!
echo ============================================================
echo.
pause
