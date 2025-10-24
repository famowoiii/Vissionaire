@echo off
echo ================================================
echo   Construction Hazard Detection System
echo   Starting All Services...
echo ================================================
echo.

REM Start Redis Server
echo [1/6] Starting Redis Server...
start "Redis Server" cmd /k "redis-server.exe redis.windows.conf"
timeout /t 3 /nobreak >nul

REM Start YOLO Detection API (Port 8000)
echo [2/6] Starting YOLO Detection API (Port 8000)...
start "YOLO Detection API" cmd /k "cd examples\YOLO_server_api && python main.py"
timeout /t 5 /nobreak >nul

REM Start Violation Record API (Port 8002)
echo [3/6] Starting Violation Record API (Port 8002)...
start "Violation Record API" cmd /k "cd examples\violation_records && uvicorn main:app --host 0.0.0.0 --port 8002"
timeout /t 3 /nobreak >nul

REM Start FCM API (Port 8003)
echo [4/6] Starting FCM API (Port 8003)...
start "FCM API" cmd /k "cd examples\local_notification_server && uvicorn main:app --host 0.0.0.0 --port 8003"
timeout /t 3 /nobreak >nul

REM Start DB Management API (Port 8005)
echo [5/6] Starting DB Management API (Port 8005)...
start "DB Management API" cmd /k "cd examples\db_management && uvicorn main:app --host 0.0.0.0 --port 8005"
timeout /t 3 /nobreak >nul

REM Start Streaming API (Port 8800)
echo [6/6] Starting Streaming API (Port 8800)...
start "Streaming Web API" cmd /k "cd examples\streaming_web && uvicorn main:app --host 0.0.0.0 --port 8800"
timeout /t 3 /nobreak >nul

echo.
echo ================================================
echo   All Services Started Successfully!
echo ================================================
echo.
echo Service URLs:
echo   - YOLO Detection API:    http://127.0.0.1:8000
echo   - Violation Record API:  http://127.0.0.1:8002
echo   - FCM API:               http://127.0.0.1:8003
echo   - DB Management API:     http://127.0.0.1:8005
echo   - Streaming Web API:     http://127.0.0.1:8800
echo   - Redis:                 127.0.0.1:6379
echo.
echo ================================================
echo   Next Steps:
echo ================================================
echo.
echo 1. Access Visionnaire Web Interface:
echo    https://visionnaire-cda17.web.app/login
echo.
echo 2. Configure API URLs in browser console (F12):
echo    See VISIONNAIRE_SETUP.md for instructions
echo.
echo 3. Login credentials:
echo    Username: user
echo    Password: password
echo.
echo Press any key to start main detection...
pause >nul

REM Start Main Detection
echo.
echo Starting Main Detection System...
start "Main Detection" cmd /k "python main.py"

echo.
echo ================================================
echo   System is now fully operational!
echo ================================================
echo.
echo Keep all windows open for the system to work properly.
echo Close this window will NOT stop the services.
echo To stop services, close individual command windows.
echo.
pause
