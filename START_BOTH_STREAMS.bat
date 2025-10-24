@echo off
title Start Detection - Both Streams (Test Site + Coba_Guys)
color 0E
cls

echo ============================================================
echo   START DETECTION - BOTH STREAMS
echo ============================================================
echo.
echo This will start detection for:
echo   1. Test Site / Stream "1"
echo   2. Coba_Guys / Stream "Proyek"
echo.
echo Both streams will appear in Visionnaire Live Stream!
echo.
echo ============================================================
echo.

cd /d D:\Construction-Hazard-Detection

echo Starting detection for both streams...
echo.

python main.py --config config\both_streams.json

pause
