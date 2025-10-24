@echo off
echo ========================================
echo   Starting All Backend APIs
echo ========================================
echo.

echo [1/5] Starting Data Management API (Port 8005)...
start "DB Management API" cmd /k "uvicorn examples.db_management.app:app --host 127.0.0.1 --port 8005 --workers 2"
timeout /t 3 >nul

echo [2/5] Starting Notification Server API (Port 8003)...
start "Notification API" cmd /k "uvicorn examples.local_notification_server.app:app --host 127.0.0.1 --port 8003 --workers 2"
timeout /t 3 >nul

echo [3/5] Starting Streaming Web Backend API (Port 8800)...
start "Streaming API" cmd /k "uvicorn examples.streaming_web.backend.app:app --host 127.0.0.1 --port 8800 --workers 2"
timeout /t 3 >nul

echo [4/5] Starting Violation Records API (Port 8002)...
start "Violation API" cmd /k "uvicorn examples.violation_records.app:app --host 127.0.0.1 --port 8002 --workers 2"
timeout /t 3 >nul

echo [5/5] Starting YOLO Detection API (Port 8000)...
start "YOLO API" cmd /k "uvicorn examples.YOLO_server_api.backend.app:app --host 127.0.0.1 --port 8000 --workers 2"
timeout /t 3 >nul

echo.
echo ========================================
echo   Semua Backend APIs Sudah Dijalankan!
echo ========================================
echo.
echo API URLs:
echo   - DB Management:  http://127.0.0.1:8005
echo   - Notification:   http://127.0.0.1:8003
echo   - Streaming:      http://127.0.0.1:8800
echo   - Violation:      http://127.0.0.1:8002
echo   - YOLO Detection: http://127.0.0.1:8000
echo.
echo Tekan tombol apapun untuk menutup window ini...
pause >nul
