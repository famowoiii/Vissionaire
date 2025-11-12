@echo off
chcp 65001 >nul
color 0C
cls

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                   MYSQL FIX AND DIAGNOSTIC TOOL               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

echo [DIAGNOSTIC] Checking MySQL status...
echo.

REM Check if port 3306 is listening
netstat -ano | findstr ":3306" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo ❌ MySQL is NOT running on port 3306
    echo.
    goto :fix_mysql
) else (
    echo ✓ Port 3306 is listening
    echo.
)

REM Try to connect
echo [TEST] Testing MySQL connection...
"C:\xampp\mysql\bin\mysql.exe" -u root -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ❌ Cannot connect to MySQL
    echo.
    goto :fix_mysql
) else (
    echo ✓ MySQL connection works!
    echo.
    echo MySQL is working fine. You can use it now.
    pause
    exit /b 0
)

:fix_mysql
echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                   MYSQL NEEDS TO BE FIXED                     ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo Possible causes:
echo 1. MySQL service is not running
echo 2. Port 3306 is blocked by firewall
echo 3. MySQL configuration error
echo 4. Another MySQL instance is running
echo.

echo [FIX 1] Checking MySQL error log...
if exist "C:\xampp\mysql\data\mysql_error.log" (
    echo.
    echo Last 10 lines of error log:
    echo ----------------------------------------
    powershell -Command "Get-Content 'C:\xampp\mysql\data\mysql_error.log' -Tail 10"
    echo ----------------------------------------
    echo.
)

echo [FIX 2] Killing any hanging MySQL processes...
taskkill /F /IM mysqld.exe 2>nul
timeout /t 2 >nul

echo [FIX 3] Starting MySQL via XAMPP...
echo.
echo MANUAL STEPS REQUIRED:
echo ═══════════════════════════════════════════════════════════════
echo.
echo 1. Open XAMPP Control Panel
echo 2. Click "Stop" button next to MySQL (if it's running)
echo 3. Wait 5 seconds
echo 4. Click "Start" button next to MySQL
echo 5. Check if the status turns GREEN
echo.
echo If MySQL FAILS to start:
echo   - Click "Logs" button
echo   - Look for error messages
echo   - Common issues:
echo     • Port 3306 already used by another program
echo     • Corrupted MySQL data files
echo     • Missing my.ini configuration
echo.
echo ═══════════════════════════════════════════════════════════════
echo.
echo After you start MySQL successfully, press any key to verify...
pause

echo.
echo [VERIFY] Testing connection again...
"C:\xampp\mysql\bin\mysql.exe" -u root -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ❌ Still cannot connect!
    echo.
    echo Please check XAMPP Control Panel for error messages.
    echo Click the "Logs" button next to MySQL to see what's wrong.
    echo.
) else (
    echo ✓ MySQL is working now!
    echo.
    echo You can proceed with database import.
    echo.
)

pause
