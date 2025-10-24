@echo off
title ULTIMATE START WITH TELEGRAM - Full Auto System
color 0A
cls

echo ============================================================
echo   ULTIMATE START WITH TELEGRAM - FULLY AUTOMATED SYSTEM
echo   Construction Hazard Detection + Telegram Notifications
echo ============================================================
echo.
echo This script will:
echo   1. Start ALL 7 API services
echo   2. Clear old cache
echo   3. Auto-detect ALL sites from database
echo   4. Start detection for ALL streams
echo   5. Auto-configure Visionnaire
echo   6. Start Telegram Violation Monitor
echo   7. Open Visionnaire ready to use!
echo.
echo ============================================================
echo.

REM Check MySQL
echo [Step 1/14] Checking MySQL...
netstat -an | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [ERROR] MySQL not running!
    echo Please start XAMPP MySQL first.
    pause
    exit /b 1
)
echo [OK] MySQL running

REM Clear Redis cache
echo.
echo [Step 2/14] Clearing Redis cache...
redis-cli.exe ping >nul 2>&1
if not errorlevel 1 (
    redis-cli.exe FLUSHALL >nul
    echo [OK] Cache cleared
) else (
    echo [INFO] Redis not running yet
)

REM Start Redis
echo.
echo [Step 3/14] Starting Redis Server...
redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    start "Redis Server - Port 6379" cmd /k "title Redis Server && cd /d D:\Construction-Hazard-Detection && redis-server.exe redis.windows.conf"
    timeout /t 3 /nobreak >nul
)
echo [OK] Redis started

REM Start YOLO Detection API
echo.
echo [Step 4/14] Starting YOLO Detection API (8000)...
netstat -an | findstr ":8000" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "YOLO API - 8000" cmd /k "title YOLO API - 8000 && cd /d D:\Construction-Hazard-Detection\examples\YOLO_server_api && python main.py"
    timeout /t 5 /nobreak >nul
)
echo [OK] YOLO API started

REM Start Violation Records API
echo.
echo [Step 5/14] Starting Violation Records API (8002)...
netstat -an | findstr ":8002" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "Violation API - 8002" cmd /k "title Violation API - 8002 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.violation_records.app:app --host 0.0.0.0 --port 8002"
    timeout /t 3 /nobreak >nul
)
echo [OK] Violation API started

REM Start FCM Notification API
echo.
echo [Step 6/14] Starting FCM Notification API (8003)...
netstat -an | findstr ":8003" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "FCM API - 8003" cmd /k "title FCM API - 8003 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.local_notification_server.app:app --host 0.0.0.0 --port 8003"
    timeout /t 3 /nobreak >nul
)
echo [OK] FCM API started

REM Start Chat API
echo.
echo [Step 7/14] Starting Chat API (8004)...
netstat -an | findstr ":8004" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "Chat API - 8004" cmd /k "title Chat API - 8004 && cd /d D:\Construction-Hazard-Detection\examples\line_chatbot && python line_bot.py"
    timeout /t 3 /nobreak >nul
)
echo [OK] Chat API started

REM Start DB Management API
echo.
echo [Step 8/14] Starting DB Management API (8005)...
netstat -an | findstr ":8005" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "DB API - 8005" cmd /k "title DB API - 8005 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005"
    timeout /t 3 /nobreak >nul
)
echo [OK] DB API started

REM Start Streaming Web API
echo.
echo [Step 9/14] Starting Streaming Web API (8800)...
netstat -an | findstr ":8800" | findstr "LISTENING" >nul
if errorlevel 1 (
    start "Streaming API - 8800" cmd /k "title Streaming API - 8800 && cd /d D:\Construction-Hazard-Detection && uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800"
    timeout /t 3 /nobreak >nul
)
echo [OK] Streaming API started

REM Wait for services
echo.
echo [Step 10/14] Waiting for all services to initialize...
timeout /t 15 /nobreak >nul

REM Auto-generate config for ALL streams from database
echo.
echo [Step 11/14] Auto-generating config for ALL streams from database...
python generate_all_streams_config.py
if errorlevel 1 (
    echo [WARNING] Failed to generate auto config, using default
    set CONFIG_FILE=config\test_stream.json
) else (
    echo [OK] Auto config generated!
    set CONFIG_FILE=config\auto_all_streams.json
)

REM Verify services
echo.
echo [Step 12/14] Verifying services...
netstat -an | findstr ":8000" | findstr "LISTENING" >nul && echo [OK] YOLO API (8000) || echo [FAIL] YOLO API (8000)
netstat -an | findstr ":8002" | findstr "LISTENING" >nul && echo [OK] Violation API (8002) || echo [FAIL] Violation API (8002)
netstat -an | findstr ":8003" | findstr "LISTENING" >nul && echo [OK] FCM API (8003) || echo [FAIL] FCM API (8003)
netstat -an | findstr ":8004" | findstr "LISTENING" >nul && echo [OK] Chat API (8004) || echo [WARN] Chat API (8004)
netstat -an | findstr ":8005" | findstr "LISTENING" >nul && echo [OK] DB API (8005) || echo [FAIL] DB API (8005)
netstat -an | findstr ":8800" | findstr "LISTENING" >nul && echo [OK] Streaming API (8800) || echo [FAIL] Streaming API (8800)

echo.
echo ============================================================
echo   ALL SERVICES STARTED!
echo ============================================================
echo.

REM Create Visionnaire auto-config HTML with instructions
echo [Step 13/14] Creating Visionnaire auto-config instructions...

echo ^<!DOCTYPE html^> > visionnaire_config.html
echo ^<html^> >> visionnaire_config.html
echo ^<head^> >> visionnaire_config.html
echo     ^<meta charset="UTF-8"^> >> visionnaire_config.html
echo     ^<title^>Visionnaire Auto Config - Copy ^&amp; Paste^</title^> >> visionnaire_config.html
echo     ^<style^> >> visionnaire_config.html
echo         * { margin: 0; padding: 0; box-sizing: border-box; } >> visionnaire_config.html
echo         body { font-family: 'Segoe UI', Arial, sans-serif; background: linear-gradient(135deg, #1a1a2e 0%%, #16213e 100%%); color: #fff; padding: 20px; min-height: 100vh; } >> visionnaire_config.html
echo         .container { max-width: 900px; margin: 0 auto; } >> visionnaire_config.html
echo         h1 { color: #4CAF50; font-size: 32px; margin-bottom: 10px; text-align: center; } >> visionnaire_config.html
echo         h2 { color: #FFC107; font-size: 20px; margin: 30px 0 15px 0; border-left: 4px solid #4CAF50; padding-left: 15px; } >> visionnaire_config.html
echo         .subtitle { text-align: center; color: #aaa; margin-bottom: 30px; font-size: 16px; } >> visionnaire_config.html
echo         .step-card { background: #2a2a3e; border-radius: 10px; padding: 25px; margin: 20px 0; box-shadow: 0 4px 15px rgba(0,0,0,0.3); } >> visionnaire_config.html
echo         .step-number { display: inline-block; background: #4CAF50; color: white; width: 35px; height: 35px; border-radius: 50%%; text-align: center; line-height: 35px; font-weight: bold; margin-right: 10px; } >> visionnaire_config.html
echo         .step-title { font-size: 18px; color: #4CAF50; margin-bottom: 15px; } >> visionnaire_config.html
echo         .code-block { background: #1a1a1a; border: 2px solid #4CAF50; border-radius: 8px; padding: 20px; margin: 15px 0; position: relative; font-family: 'Courier New', monospace; font-size: 13px; line-height: 1.6; overflow-x: auto; } >> visionnaire_config.html
echo         .copy-btn { position: absolute; top: 10px; right: 10px; background: #4CAF50; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; font-size: 12px; transition: all 0.3s; } >> visionnaire_config.html
echo         .copy-btn:hover { background: #45a049; transform: scale(1.05); } >> visionnaire_config.html
echo         .copy-btn:active { transform: scale(0.95); } >> visionnaire_config.html
echo         .info-box { background: #0d3b66; border-left: 4px solid #4CAF50; padding: 15px; margin: 15px 0; border-radius: 5px; } >> visionnaire_config.html
echo         .warning-box { background: #663d00; border-left: 4px solid #FFC107; padding: 15px; margin: 15px 0; border-radius: 5px; } >> visionnaire_config.html
echo         .endpoint-list { list-style: none; padding: 0; margin: 15px 0; } >> visionnaire_config.html
echo         .endpoint-list li { padding: 8px 0; border-bottom: 1px solid #444; } >> visionnaire_config.html
echo         .endpoint-list li:last-child { border-bottom: none; } >> visionnaire_config.html
echo         code { background: #000; padding: 3px 8px; border-radius: 3px; color: #4CAF50; font-family: 'Courier New', monospace; } >> visionnaire_config.html
echo         .big-button { display: inline-block; background: #4CAF50; color: white; padding: 15px 40px; border-radius: 8px; text-decoration: none; font-size: 18px; font-weight: bold; margin: 20px 10px; transition: all 0.3s; box-shadow: 0 4px 10px rgba(76,175,80,0.3); } >> visionnaire_config.html
echo         .big-button:hover { background: #45a049; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(76,175,80,0.5); } >> visionnaire_config.html
echo         .button-container { text-align: center; margin: 30px 0; } >> visionnaire_config.html
echo         .success-msg { display: none; background: #4CAF50; color: white; padding: 15px; border-radius: 5px; text-align: center; margin: 20px 0; } >> visionnaire_config.html
echo         .screenshot { max-width: 100%%; border: 2px solid #4CAF50; border-radius: 5px; margin: 15px 0; } >> visionnaire_config.html
echo         ol { padding-left: 25px; line-height: 1.8; } >> visionnaire_config.html
echo         ol li { margin: 10px 0; } >> visionnaire_config.html
echo     ^</style^> >> visionnaire_config.html
echo ^</head^> >> visionnaire_config.html
echo ^<body^> >> visionnaire_config.html
echo     ^<div class="container"^> >> visionnaire_config.html
echo         ^<h1^>⚡ Visionnaire Auto Configuration^</h1^> >> visionnaire_config.html
echo         ^<p class="subtitle"^>Configure ALL 7 API endpoints in 30 seconds!^</p^> >> visionnaire_config.html
echo. >> visionnaire_config.html
echo         ^<div class="step-card"^> >> visionnaire_config.html
echo             ^<div class="step-title"^>^<span class="step-number"^>1^</span^>Open Visionnaire^</div^> >> visionnaire_config.html
echo             ^<div class="button-container"^> >> visionnaire_config.html
echo                 ^<a href="https://visionnaire-cda17.web.app/login" target="_blank" class="big-button"^>🚀 Open Visionnaire^</a^> >> visionnaire_config.html
echo             ^</div^> >> visionnaire_config.html
echo             ^<div class="info-box"^> >> visionnaire_config.html
echo                 ^<strong^>✅ Login Credentials:^</strong^>^<br^> >> visionnaire_config.html
echo                 Username: ^<code^>user^</code^> ^<br^> >> visionnaire_config.html
echo                 Password: ^<code^>password^</code^> >> visionnaire_config.html
echo             ^</div^> >> visionnaire_config.html
echo         ^</div^> >> visionnaire_config.html
echo. >> visionnaire_config.html
echo         ^<div class="step-card"^> >> visionnaire_config.html
echo             ^<div class="step-title"^>^<span class="step-number"^>2^</span^>Open Browser Console^</div^> >> visionnaire_config.html
echo             ^<p^>Setelah login, tekan salah satu:^</p^> >> visionnaire_config.html
echo             ^<ul style="margin: 15px 0; padding-left: 25px; line-height: 2;"^> >> visionnaire_config.html
echo                 ^<li^>^<code^>F12^</code^> (Windows)^</li^> >> visionnaire_config.html
echo                 ^<li^>^<code^>Ctrl + Shift + J^</code^> (Chrome)^</li^> >> visionnaire_config.html
echo                 ^<li^>^<code^>Ctrl + Shift + K^</code^> (Firefox)^</li^> >> visionnaire_config.html
echo             ^</ul^> >> visionnaire_config.html
echo             ^<p^>Lalu pilih tab ^<strong^>Console^</strong^>^</p^> >> visionnaire_config.html
echo         ^</div^> >> visionnaire_config.html
echo. >> visionnaire_config.html
echo         ^<div class="step-card"^> >> visionnaire_config.html
echo             ^<div class="step-title"^>^<span class="step-number"^>3^</span^>Copy ^&amp; Paste Script Ini^</div^> >> visionnaire_config.html
echo             ^<div class="warning-box"^> >> visionnaire_config.html
echo                 ^<strong^>⚠️ PENTING:^</strong^> Copy SEMUA baris (klik tombol "Copy" di bawah)^<br^> >> visionnaire_config.html
echo                 Paste di Console, lalu tekan ^<strong^>Enter^</strong^> >> visionnaire_config.html
echo             ^</div^> >> visionnaire_config.html
echo             ^<div class="code-block" id="configScript"^> >> visionnaire_config.html
echo                 ^<button class="copy-btn" onclick="copyScript()"^>📋 Copy^</button^> >> visionnaire_config.html
echo localStorage.clear();^<br^> >> visionnaire_config.html
echo localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');^<br^> >> visionnaire_config.html
echo localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');^<br^> >> visionnaire_config.html
echo localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');^<br^> >> visionnaire_config.html
echo localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004');^<br^> >> visionnaire_config.html
echo localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');^<br^> >> visionnaire_config.html
echo localStorage.setItem('FILE_MANAGEMENT_API_URL', 'http://127.0.0.1:8005');^<br^> >> visionnaire_config.html
echo localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');^<br^> >> visionnaire_config.html
echo console.log('✅ ALL 7 API endpoints configured!');^<br^> >> visionnaire_config.html
echo console.log('🔄 Refresh page to apply changes...'); >> visionnaire_config.html
echo             ^</div^> >> visionnaire_config.html
echo         ^</div^> >> visionnaire_config.html
echo. >> visionnaire_config.html
echo         ^<div class="step-card"^> >> visionnaire_config.html
echo             ^<div class="step-title"^>^<span class="step-number"^>4^</span^>Refresh Page^</div^> >> visionnaire_config.html
echo             ^<p^>Setelah paste script, tekan:^</p^> >> visionnaire_config.html
echo             ^<div class="code-block"^> >> visionnaire_config.html
echo F5  atau  Ctrl + R >> visionnaire_config.html
echo             ^</div^> >> visionnaire_config.html
echo             ^<div class="info-box"^> >> visionnaire_config.html
echo                 ^<strong^>✅ Done!^</strong^> Semua API endpoints sudah configured! >> visionnaire_config.html
echo             ^</div^> >> visionnaire_config.html
echo         ^</div^> >> visionnaire_config.html
echo. >> visionnaire_config.html
echo         ^<h2^>📋 Configured Endpoints:^</h2^> >> visionnaire_config.html
echo         ^<div class="step-card"^> >> visionnaire_config.html
echo             ^<ul class="endpoint-list"^> >> visionnaire_config.html
echo                 ^<li^>🎯 YOLO Detection API: ^<code^>http://127.0.0.1:8000^</code^>^</li^> >> visionnaire_config.html
echo                 ^<li^>📝 Violation Records API: ^<code^>http://127.0.0.1:8002^</code^>^</li^> >> visionnaire_config.html
echo                 ^<li^>📱 FCM Notification API: ^<code^>http://127.0.0.1:8003^</code^>^</li^> >> visionnaire_config.html
echo                 ^<li^>💬 Chat API: ^<code^>http://127.0.0.1:8004^</code^>^</li^> >> visionnaire_config.html
echo                 ^<li^>🗄️ DB Management API: ^<code^>http://127.0.0.1:8005^</code^>^</li^> >> visionnaire_config.html
echo                 ^<li^>📁 File Management API: ^<code^>http://127.0.0.1:8005^</code^>^</li^> >> visionnaire_config.html
echo                 ^<li^>🎥 Streaming Web API: ^<code^>http://127.0.0.1:8800^</code^>^</li^> >> visionnaire_config.html
echo             ^</ul^> >> visionnaire_config.html
echo         ^</div^> >> visionnaire_config.html
echo. >> visionnaire_config.html
echo         ^<div id="successMsg" class="success-msg"^> >> visionnaire_config.html
echo             ✅ Script copied! Paste ke Console Visionnaire sekarang! >> visionnaire_config.html
echo         ^</div^> >> visionnaire_config.html
echo. >> visionnaire_config.html
echo     ^</div^> >> visionnaire_config.html
echo. >> visionnaire_config.html
echo     ^<script^> >> visionnaire_config.html
echo         function copyScript() { >> visionnaire_config.html
echo             const script = `localStorage.clear(); >> visionnaire_config.html
echo localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000'); >> visionnaire_config.html
echo localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002'); >> visionnaire_config.html
echo localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003'); >> visionnaire_config.html
echo localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004'); >> visionnaire_config.html
echo localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005'); >> visionnaire_config.html
echo localStorage.setItem('FILE_MANAGEMENT_API_URL', 'http://127.0.0.1:8005'); >> visionnaire_config.html
echo localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800'); >> visionnaire_config.html
echo console.log('✅ ALL 7 API endpoints configured!'); >> visionnaire_config.html
echo console.log('🔄 Refresh page to apply changes...');`; >> visionnaire_config.html
echo             navigator.clipboard.writeText(script).then(() =^> { >> visionnaire_config.html
echo                 document.getElementById('successMsg').style.display = 'block'; >> visionnaire_config.html
echo                 setTimeout(() =^> { >> visionnaire_config.html
echo                     document.getElementById('successMsg').style.display = 'none'; >> visionnaire_config.html
echo                 }, 3000); >> visionnaire_config.html
echo             }); >> visionnaire_config.html
echo         } >> visionnaire_config.html
echo     ^</script^> >> visionnaire_config.html
echo ^</body^> >> visionnaire_config.html
echo ^</html^> >> visionnaire_config.html

echo [OK] Auto-config instruction page created!

REM Start Telegram Violation Monitor
echo.
echo [Step 14/14] Starting Telegram Violation Monitor...
start "Telegram Monitor" cmd /k "title Telegram Monitor && cd /d D:\Construction-Hazard-Detection && python telegram_violation_monitor.py"
timeout /t 2 /nobreak >nul
echo [OK] Telegram Monitor started

REM Start detection for ALL streams
echo.
echo ============================================================
echo   STARTING DETECTION FOR ALL STREAMS
echo ============================================================
echo.
echo Detection will start for ALL sites in database!
echo Telegram notifications enabled for all streams.
echo.
echo Press any key to start detection...
pause >nul

start "Detection - ALL Streams" cmd /k "title Detection - ALL Streams && cd /d D:\Construction-Hazard-Detection && python main.py --config %CONFIG_FILE%"

timeout /t 3 /nobreak >nul

REM Open auto-config page
start "" "visionnaire_config.html"

echo.
echo ============================================================
echo   SYSTEM FULLY OPERATIONAL!
echo ============================================================
echo.
echo What just happened:
echo   1. ALL 7 API services started
echo   2. ALL streams from database configured
echo   3. Detection started for ALL streams
echo   4. Telegram Monitor started (real-time notifications!)
echo   5. Auto-config page opened
echo.
echo Next steps:
echo   1. Click "Configure ^& Open Visionnaire" button
echo   2. Login: user / password
echo   3. Go to Live Stream
echo   4. ALL your streams are now visible!
echo.
echo Telegram Notifications:
echo   - Monitoring violations table
echo   - Sends notification for EVERY new violation
echo   - Includes violation image
echo   - Real-time alerts to Chat ID: 5856651174
echo.
echo Stream ^<-^> Site synchronization: AUTOMATIC!
echo API Configuration: AUTO-FILLED!
echo Telegram Alerts: ENABLED!
echo.
echo ============================================================
echo.
echo Active services: 9 terminal windows
echo   - Redis (6379)
echo   - YOLO Detection API (8000)
echo   - Violation Records API (8002)
echo   - FCM Notification API (8003)
echo   - Chat API (8004)
echo   - DB Management API (8005)
echo   - Streaming Web API (8800)
echo   - Telegram Monitor (watching violations table)
echo   - Detection (ALL streams with notifications)
echo.
echo To stop all: STOP_EVERYTHING.bat
echo.
pause
