@echo off
title Start Detection with Telegram
color 0E
cls

echo ============================================================
echo   START DETECTION WITH TELEGRAM NOTIFICATIONS
echo ============================================================
echo.

REM Check if services are running
echo Checking required services...
echo.

netstat -an | findstr ":8005" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [WARNING] DB Management API (8005) not running!
    echo Please run START_SERVICES_ONLY.bat first.
    echo.
)

netstat -an | findstr ":8800" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [WARNING] Streaming API (8800) not running!
    echo Please run START_SERVICES_ONLY.bat first.
    echo.
)

redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Redis not running!
    echo Please run START_SERVICES_ONLY.bat first.
    echo.
)

echo ============================================================
echo   TELEGRAM BOT STATUS
echo ============================================================
echo.
echo Chat ID: 5856651174
echo Language: English
echo Status: ENABLED
echo.
echo You will receive notifications when violations detected!
echo.
echo ============================================================
echo   STARTING DETECTION...
echo ============================================================
echo.

cd /d D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json

pause
