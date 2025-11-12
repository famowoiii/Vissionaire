@echo off
title Stop All Services
color 0C

echo ============================================================
echo    Stopping Construction Hazard Detection System
echo ============================================================
echo.

echo Stopping all Python processes (Detection Service + APIs)...
taskkill /F /IM python.exe 2>nul
if errorlevel 1 (
    echo [INFO] No Python processes found running
) else (
    echo [OK] Python processes stopped
)
echo.

echo ============================================================
echo    All services have been stopped!
echo ============================================================
echo.
echo To start the system again, run: START_SYSTEM.bat
echo.
pause
