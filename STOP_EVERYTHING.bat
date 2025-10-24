@echo off
echo ================================================
echo   Stopping All Services
echo ================================================
echo.

echo Stopping Python processes...
taskkill /F /IM python.exe /T >nul 2>&1

echo Stopping Uvicorn processes...
taskkill /F /IM uvicorn.exe /T >nul 2>&1

echo Stopping Redis...
redis-cli.exe shutdown >nul 2>&1

echo.
echo ================================================
echo   All Services Stopped
echo ================================================
echo.
echo You can now close all terminal windows.
echo.
pause
