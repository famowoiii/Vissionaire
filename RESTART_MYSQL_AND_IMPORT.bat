@echo off
chcp 65001 >nul
color 0E
cls

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║         MYSQL RESTART AND DATABASE IMPORT TOOL                ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo MySQL is slow? Let's fix it!
echo.

echo [STEP 1] Stopping MySQL...
echo Please wait...
net stop mysql 2>nul
timeout /t 2 >nul

echo.
echo [STEP 2] Starting MySQL...
net start mysql 2>nul
if errorlevel 1 (
    echo.
    echo ⚠ Cannot restart MySQL via net command.
    echo.
    echo Please do this manually:
    echo 1. Open XAMPP Control Panel
    echo 2. Click "Stop" on MySQL
    echo 3. Wait 3 seconds
    echo 4. Click "Start" on MySQL
    echo 5. Come back here and press any key
    echo.
    pause
)

timeout /t 3 >nul

echo.
echo [STEP 3] Verifying MySQL is running...
netstat -an | findstr ":3306" >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: MySQL is still not running!
    echo Please start MySQL from XAMPP Control Panel.
    pause
    exit /b 1
)
echo ✓ MySQL is running
echo.

echo [STEP 4] Dropping old database (if exists)...
"C:\xampp\mysql\bin\mysql.exe" -u root --execute="DROP DATABASE IF EXISTS construction_hazard_detection;" 2>nul
echo ✓ Old database dropped
echo.

echo [STEP 5] Creating fresh database...
"C:\xampp\mysql\bin\mysql.exe" -u root --execute="CREATE DATABASE construction_hazard_detection CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
echo ✓ Database created
echo.

echo [STEP 6] Importing schema...
echo This will take 10-15 seconds...
"C:\xampp\mysql\bin\mysql.exe" -u root construction_hazard_detection < scripts\init.sql

if errorlevel 1 (
    echo ❌ Import failed!
    pause
    exit /b 1
)

echo ✓ Import successful!
echo.

echo [STEP 7] Verifying...
"C:\xampp\mysql\bin\mysql.exe" -u root --execute="USE construction_hazard_detection; SHOW TABLES;" 2>nul

echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                  SUCCESS! DATABASE IS READY                   ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo Default Login:
echo   Username: user
echo   Password: password
echo.
echo Next step: Run start_all_apis.bat
echo.
pause
