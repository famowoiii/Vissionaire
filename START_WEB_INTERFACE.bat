@echo off
echo ========================================
echo   VISIONNAIRE WEB INTERFACE (LOCAL)
echo ========================================
echo.
echo Starting web server...
echo.
echo Web interface akan tersedia di:
echo   http://localhost:3000
echo.
echo Login dengan:
echo   Username: user
echo   Password: password
echo.
echo Tekan Ctrl+C untuk stop
echo ========================================
echo.

cd examples\streaming_web\frontend\dist
start http://localhost:3000
python -m http.server 3000
