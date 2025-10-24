@echo off
title Starting All 7 API Services
color 0A
echo ========================================================
echo   Construction Hazard Detection System
echo   STARTING ALL 7 API SERVICES
echo ========================================================
echo.

REM Check MySQL
echo [Step 1/9] Checking MySQL...
netstat -an | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [ERROR] MySQL not running!
    echo Please start XAMPP MySQL first.
    pause
    exit /b 1
)
echo [OK] MySQL running on port 3306

REM Start Redis
echo.
echo [Step 2/9] Starting Redis...
redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    start "Redis Server - Port 6379" cmd /k "title Redis Server && redis-server.exe redis.windows.conf"
    timeout /t 3 /nobreak >nul
)
echo [OK] Redis running on port 6379

REM Start YOLO Detection API - Port 8000
echo.
echo [Step 3/9] Starting YOLO Detection API (Port 8000)...
start "YOLO Detection API - Port 8000" cmd /k "title YOLO Detection API - Port 8000 && cd /d D:\Construction-Hazard-Detection\examples\YOLO_server_api && python main.py"
timeout /t 3 /nobreak >nul

REM Start Violation Records API - Port 8002
echo.
echo [Step 4/9] Starting Violation Records API (Port 8002)...
start "Violation Records API - Port 8002" cmd /k "title Violation Records API - Port 8002 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.violation_records.app:app --host 0.0.0.0 --port 8002"
timeout /t 3 /nobreak >nul

REM Start FCM/Notification API - Port 8003
echo.
echo [Step 5/9] Starting FCM Notification API (Port 8003)...
start "FCM Notification API - Port 8003" cmd /k "title FCM Notification API - Port 8003 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.local_notification_server.app:app --host 0.0.0.0 --port 8003"
timeout /t 3 /nobreak >nul

REM Start Chat API (Line Bot) - Port 8004
echo.
echo [Step 6/9] Starting Chat API (Port 8004)...
start "Chat API - Port 8004" cmd /k "title Chat API - Port 8004 && cd /d D:\Construction-Hazard-Detection\examples\line_chatbot && python line_bot.py"
timeout /t 3 /nobreak >nul

REM Start DB Management API - Port 8005
echo.
echo [Step 7/9] Starting DB Management API (Port 8005)...
start "DB Management API - Port 8005" cmd /k "title DB Management API - Port 8005 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005"
timeout /t 3 /nobreak >nul

REM Start Streaming Web API - Port 8800
echo.
echo [Step 8/9] Starting Streaming Web API (Port 8800)...
start "Streaming Web API - Port 8800" cmd /k "title Streaming Web API - Port 8800 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800"
timeout /t 5 /nobreak >nul

REM Wait for all services to start
echo.
echo [Step 9/9] Waiting for services to initialize...
timeout /t 15 /nobreak >nul

REM Verify all services
echo.
echo ========================================================
echo   VERIFYING ALL SERVICES
echo ========================================================
echo.

netstat -an | findstr ":8000" | findstr "LISTENING" >nul && echo [OK] YOLO Detection API (8000) || echo [FAIL] YOLO Detection API (8000)
netstat -an | findstr ":8002" | findstr "LISTENING" >nul && echo [OK] Violation Records API (8002) || echo [FAIL] Violation Records API (8002)
netstat -an | findstr ":8003" | findstr "LISTENING" >nul && echo [OK] FCM Notification API (8003) || echo [FAIL] FCM Notification API (8003)
netstat -an | findstr ":8004" | findstr "LISTENING" >nul && echo [OK] Chat API (8004) || echo [FAIL] Chat API (8004) - Optional
netstat -an | findstr ":8005" | findstr "LISTENING" >nul && echo [OK] DB Management API (8005) || echo [FAIL] DB Management API (8005)
netstat -an | findstr ":8800" | findstr "LISTENING" >nul && echo [OK] Streaming Web API (8800) || echo [FAIL] Streaming Web API (8800)
netstat -an | findstr ":3306" | findstr "LISTENING" >nul && echo [OK] MySQL Database (3306) || echo [FAIL] MySQL Database (3306)
redis-cli.exe ping >nul 2>&1 && echo [OK] Redis Cache (6379) || echo [FAIL] Redis Cache (6379)

echo.
echo ========================================================
echo   ALL SERVICES STARTED!
echo ========================================================
echo.
echo API Service URLs:
echo   1. YOLO Detection:     http://127.0.0.1:8000/docs
echo   2. Violation Records:  http://127.0.0.1:8002/docs
echo   3. FCM Notifications:  http://127.0.0.1:8003/docs
echo   4. Chat API:           http://127.0.0.1:8004 (Line Bot)
echo   5. DB Management:      http://127.0.0.1:8005/docs
echo   6. Streaming Web:      http://127.0.0.1:8800/docs
echo.
echo Visionnaire Web Interface:
echo   https://visionnaire-cda17.web.app/login
echo.
echo ========================================================
echo   CONFIGURE VISIONNAIRE (FIRST TIME ONLY)
echo ========================================================
echo.
echo Open browser console (F12) and paste:
echo.
echo localStorage.clear();
echo localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
echo localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
echo localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
echo localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004');
echo localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
echo localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
echo location.reload();
echo.
echo ========================================================
echo   LOGIN CREDENTIALS
echo ========================================================
echo.
echo Username: user
echo Password: password
echo.
echo ========================================================
echo   NEXT STEP: START DETECTION
echo ========================================================
echo.
echo In a NEW terminal window, run:
echo   cd D:\Construction-Hazard-Detection
echo   python main.py --config config\test_stream.json
echo.
echo Then view Live Stream in Visionnaire!
echo.
echo ========================================================
echo.
echo Press any key to open Visionnaire in browser...
pause >nul

start https://visionnaire-cda17.web.app/login

echo.
echo Visionnaire opened!
echo.
echo IMPORTANT: Keep all terminal windows open!
echo To stop all services, run: STOP_EVERYTHING.bat
echo.
pause
