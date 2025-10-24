@echo off
title Telegram Violation Monitor
color 0B
cls

echo ============================================================
echo   TELEGRAM VIOLATION MONITOR
echo   Real-time notifications for safety violations
echo ============================================================
echo.
echo This script will:
echo   1. Monitor violation_records table in MySQL
echo   2. Send Telegram notification for every new violation
echo   3. Include violation details and image
echo ============================================================
echo.

cd /d D:\Construction-Hazard-Detection

echo Starting Telegram monitor...
echo.

python telegram_violation_monitor.py

pause
