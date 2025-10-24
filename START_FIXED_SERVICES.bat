@echo off
echo ================================================
echo   Construction Hazard Detection System
echo   Starting All Services (FIXED VERSION)
echo ================================================
echo.

REM Start Redis Server
echo [1/6] Starting Redis Server...
redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    start "Redis Server" cmd /k "redis-server.exe redis.windows.conf"
    timeout /t 3 /nobreak >nul
) else (
    echo Redis already running!
)

REM Start YOLO Detection API (Port 8000)
echo [2/6] Starting YOLO Detection API (Port 8000)...
start "YOLO Detection API" cmd /k "cd examples\YOLO_server_api && python main.py"
timeout /t 5 /nobreak >nul

REM Start Violation Record API (Port 8002)
echo [3/6] Starting Violation Record API (Port 8002)...
start "Violation Record API" cmd /k "uvicorn examples.violation_records.app:app --host 0.0.0.0 --port 8002"
timeout /t 3 /nobreak >nul

REM Start FCM API (Port 8003)
echo [4/6] Starting FCM API (Port 8003)...
start "FCM API" cmd /k "uvicorn examples.local_notification_server.app:app --host 0.0.0.0 --port 8003"
timeout /t 3 /nobreak >nul

REM Start DB Management API (Port 8005)
echo [5/6] Starting DB Management API (Port 8005)...
start "DB Management API" cmd /k "uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005"
timeout /t 3 /nobreak >nul

REM Start Streaming API (Port 8800)
echo [6/6] Starting Streaming API (Port 8800)...
start "Streaming Web API" cmd /k "uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800"
timeout /t 5 /nobreak >nul

echo.
echo ================================================
echo   Waiting for services to initialize...
echo ================================================
timeout /t 15 /nobreak >nul

echo.
echo Checking service status...
echo.

REM Check each port
netstat -an | findstr ":8000" | findstr "LISTENING" >nul && echo [OK] YOLO API (8000) || echo [FAIL] YOLO API (8000)
netstat -an | findstr ":8002" | findstr "LISTENING" >nul && echo [OK] Violation API (8002) || echo [FAIL] Violation API (8002)
netstat -an | findstr ":8003" | findstr "LISTENING" >nul && echo [OK] FCM API (8003) || echo [FAIL] FCM API (8003)
netstat -an | findstr ":8005" | findstr "LISTENING" >nul && echo [OK] DB Management API (8005) || echo [FAIL] DB Management API (8005)
netstat -an | findstr ":8800" | findstr "LISTENING" >nul && echo [OK] Streaming API (8800) || echo [FAIL] Streaming API (8800)
redis-cli.exe ping >nul 2>&1 && echo [OK] Redis (6379) || echo [FAIL] Redis (6379)

echo.
echo ================================================
echo   Service URLs:
echo ================================================
echo   - YOLO Detection API:    http://127.0.0.1:8000/docs
echo   - Violation Record API:  http://127.0.0.1:8002/docs
echo   - FCM API:               http://127.0.0.1:8003/docs
echo   - DB Management API:     http://127.0.0.1:8005/docs
echo   - Streaming Web API:     http://127.0.0.1:8800/docs
echo   - Redis:                 127.0.0.1:6379
echo.
echo ================================================
echo   Next: Configure Visionnaire
echo ================================================
echo.
echo 1. Open: https://visionnaire-cda17.web.app/login
echo 2. Press F12 and paste in console:
echo.
echo localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
echo localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
echo localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
echo localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
echo localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
echo location.reload();
echo.
echo 3. Login: user / password
echo.
pause
