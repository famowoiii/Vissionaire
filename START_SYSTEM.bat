@echo off
title Construction Hazard Detection - System Startup
color 0A

echo ============================================================
echo    Construction Hazard Detection System
echo    Complete System Startup with Health Checks
echo ============================================================
echo.

REM Step 1: Check MySQL
echo [1/5] Checking MySQL Connection...
echo ============================================================
python -c "import pymysql; conn = pymysql.connect(host='127.0.0.1', user='root', password='', db='construction_hazard_detection'); conn.close(); print('MySQL OK')" 2>nul
if errorlevel 1 (
    echo [ERROR] Cannot connect to MySQL!
    echo.
    echo Possible solutions:
    echo   1. Make sure XAMPP MySQL is running
    echo   2. Start MySQL from XAMPP Control Panel
    echo   3. Check if database 'construction_hazard_detection' exists
    echo   4. Run scripts\init.sql if database is empty
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)
echo [OK] MySQL is ready!
echo.

REM Step 2: Check Redis
echo [2/5] Checking Redis Connection...
echo ============================================================
python -c "import redis; r = redis.Redis(host='127.0.0.1', port=6379); r.ping(); print('Redis OK')" 2>nul
if errorlevel 1 (
    echo [ERROR] Cannot connect to Redis!
    echo.
    echo Possible solutions:
    echo   1. Make sure Redis is installed
    echo   2. Start Redis server: redis-server
    echo   3. Check if port 6379 is available
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)
echo [OK] Redis is ready!
echo.

REM Step 3: Start All Backend APIs
echo [3/5] Starting Backend APIs...
echo ============================================================
echo Starting 5 backend services on ports: 8005, 8003, 8800, 8002, 8000
echo.

start "DB Management API" cmd /k "title DB Management API [Port 8005] && uvicorn examples.db_management.app:app --host 127.0.0.1 --port 8005 --workers 2"
echo   [OK] DB Management API starting on port 8005
timeout /t 2 >nul

start "Notification API" cmd /k "title Notification API [Port 8003] && uvicorn examples.local_notification_server.app:app --host 127.0.0.1 --port 8003 --workers 2"
echo   [OK] Notification API starting on port 8003
timeout /t 2 >nul

start "Streaming API" cmd /k "title Streaming Web API [Port 8800] && uvicorn examples.streaming_web.backend.app:app --host 127.0.0.1 --port 8800 --workers 2"
echo   [OK] Streaming Web API starting on port 8800
timeout /t 2 >nul

start "Violation API" cmd /k "title Violation Records API [Port 8002] && uvicorn examples.violation_records.app:app --host 127.0.0.1 --port 8002 --workers 2"
echo   [OK] Violation Records API starting on port 8002
timeout /t 2 >nul

start "YOLO API" cmd /k "title YOLO Detection API [Port 8000] && uvicorn examples.YOLO_server_api.backend.app:app --host 127.0.0.1 --port 8000 --workers 2"
echo   [OK] YOLO Detection API starting on port 8000
timeout /t 3 >nul

echo.
echo [OK] All APIs are starting up...
echo Waiting 10 seconds for APIs to initialize...
timeout /t 10 >nul

REM Step 4: Verify APIs are running
echo [4/5] Verifying API Health...
echo ============================================================
python -c "import requests; r = requests.get('http://127.0.0.1:8005/docs', timeout=5); print('DB Management API: OK' if r.status_code == 200 else 'FAILED')" 2>nul
python -c "import requests; r = requests.get('http://127.0.0.1:8800/docs', timeout=5); print('Streaming API: OK' if r.status_code == 200 else 'FAILED')" 2>nul
echo.

REM Step 5: Start Detection Service
echo [5/5] Starting Detection Service...
echo ============================================================
echo This will read stream configs from database and start detection.
echo.
start "Detection Service" cmd /k "title Main Detection Service && python main.py"
echo [OK] Detection service is starting!
echo.

echo ============================================================
echo    SYSTEM STARTUP COMPLETE!
echo ============================================================
echo.
echo All services are now running:
echo   - MySQL Database:     Ready
echo   - Redis Cache:        Ready
echo   - Backend APIs:       5 services running
echo   - Detection Service:  Processing streams
echo.
echo API Endpoints:
echo   http://127.0.0.1:8005  - DB Management
echo   http://127.0.0.1:8003  - Notifications
echo   http://127.0.0.1:8800  - Streaming Web
echo   http://127.0.0.1:8002  - Violation Records
echo   http://127.0.0.1:8000  - YOLO Detection
echo.
echo Web Interface:
echo   Open: visionnaire-cda17.web.app
echo   Configure: Use 127.0.0.1 URLs
echo.
echo To stop all services: Close all command windows or run STOP_SYSTEM.bat
echo.
pause
