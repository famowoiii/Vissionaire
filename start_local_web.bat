@echo off
REM Simple HTTP server untuk serve streaming web frontend

echo ======================================
echo Starting Local Web Interface
echo ======================================
echo.
echo Web interface akan tersedia di:
echo   http://localhost:3000
echo.
echo Untuk login, gunakan credentials:
echo   Username: user
echo   Password: password
echo.
echo Press Ctrl+C to stop
echo ======================================
echo.

cd examples\streaming_web\frontend\dist
python -m http.server 3000
