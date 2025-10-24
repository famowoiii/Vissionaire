@echo off
title Reset Cache and Restart Streaming
color 0E
echo ========================================================
echo   FIX STREAM ISSUE - Reset Cache and Restart
echo ========================================================
echo.

echo [Step 1/4] Clearing Redis cache...
redis-cli.exe FLUSHALL
if errorlevel 1 (
    echo [ERROR] Failed to clear Redis cache!
    echo Make sure Redis is running.
    pause
    exit /b 1
)
echo [OK] Redis cache cleared!

echo.
echo [Step 2/4] Verifying Redis is empty...
redis-cli.exe KEYS "*"
echo [OK] Redis verification complete.

echo.
echo [Step 3/4] Checking database configuration...
python check_database.py
if errorlevel 1 (
    echo [WARNING] Database check had issues, but continuing...
)

echo.
echo ========================================================
echo   CACHE CLEARED SUCCESSFULLY!
echo ========================================================
echo.
echo NEXT STEPS:
echo.
echo 1. Restart Streaming API (Port 8800)
echo    - Close the existing Streaming API terminal window
echo    - Run: uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
echo.
echo 2. Start Detection (if not running)
echo    - Run: python main.py --config config\test_stream.json
echo.
echo 3. Refresh Visionnaire Browser
echo    - Press Ctrl + Shift + R (hard refresh)
echo    - Or clear browser cache
echo.
echo 4. Your streams should now show:
echo    - Test Site / Stream "1"
echo    - Coba_Guys / Stream "Proyek"
echo.
echo ========================================================
echo.
echo Press any key to open guide...
pause >nul

start FIX_STREAM_ISSUE.md

echo.
echo Guide opened!
echo.
pause
