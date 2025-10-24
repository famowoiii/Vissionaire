@echo off
echo ================================================
echo   Construction Hazard Detection System
echo   AUTOMATIC STARTUP
echo ================================================
echo.

REM Check MySQL
echo [1/6] Checking MySQL...
netstat -an | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [ERROR] MySQL not running!
    echo Please start XAMPP MySQL first, then run this script again.
    pause
    exit /b 1
)
echo [OK] MySQL is running on port 3306

REM Start Redis
echo.
echo [2/6] Starting Redis...
redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    start "Redis Server" cmd /k "redis-server.exe redis.windows.conf"
    timeout /t 3 /nobreak >nul
    redis-cli.exe ping >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to start Redis!
        pause
        exit /b 1
    )
)
echo [OK] Redis is running on port 6379

REM Start DB Management API
echo.
echo [3/6] Starting DB Management API (Port 8005)...
start "DB Management API - Port 8005" cmd /k "cd /d D:\Construction-Hazard-Detection && uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005"
timeout /t 5 /nobreak >nul

REM Start Streaming API
echo.
echo [4/6] Starting Streaming API (Port 8800)...
start "Streaming API - Port 8800" cmd /k "cd /d D:\Construction-Hazard-Detection && uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800"
timeout /t 5 /nobreak >nul

REM Wait for services to fully start
echo.
echo [5/6] Waiting for services to initialize...
timeout /t 10 /nobreak >nul

REM Verify services
echo.
echo [6/6] Verifying services...
echo.

netstat -an | findstr ":8005" | findstr "LISTENING" >nul && echo [OK] DB Management API (8005) || echo [FAIL] DB Management API (8005)
netstat -an | findstr ":8800" | findstr "LISTENING" >nul && echo [OK] Streaming API (8800) || echo [FAIL] Streaming API (8800)
netstat -an | findstr ":3306" | findstr "LISTENING" >nul && echo [OK] MySQL (3306) || echo [FAIL] MySQL (3306)
redis-cli.exe ping >nul 2>&1 && echo [OK] Redis (6379) || echo [FAIL] Redis (6379)

echo.
echo ================================================
echo   ALL SERVICES STARTED!
echo ================================================
echo.
echo Service URLs:
echo   - DB Management:  http://127.0.0.1:8005/docs
echo   - Streaming API:  http://127.0.0.1:8800/docs
echo   - Visionnaire:    https://visionnaire-cda17.web.app/login
echo.
echo ================================================
echo   NEXT STEPS:
echo ================================================
echo.
echo 1. Configure Visionnaire (FIRST TIME ONLY):
echo    - Open: https://visionnaire-cda17.web.app/login
echo    - Press F12, paste in Console:
echo.
echo    localStorage.clear();
echo    localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
echo    localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
echo    location.reload();
echo.
echo 2. Login to Visionnaire:
echo    Username: user
echo    Password: password
echo.
echo 3. Start Detection (in NEW terminal):
echo    cd D:\Construction-Hazard-Detection
echo    python main.py --config config\test_stream.json
echo.
echo 4. View Live Stream in Visionnaire:
echo    Live Stream -^> Test Site -^> Local Video Demo
echo.
echo ================================================
echo.
echo Press any key to open Visionnaire in browser...
pause >nul

REM Open Visionnaire in browser
start https://visionnaire-cda17.web.app/login

echo.
echo Visionnaire opened in browser!
echo.
echo Remember to start detection:
echo   python main.py --config config\test_stream.json
echo.
pause
