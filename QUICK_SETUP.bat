@echo off
chcp 65001 >nul
color 0A
cls

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║          CONSTRUCTION HAZARD DETECTION - QUICK SETUP          ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo This will setup your database in 3 simple steps!
echo.

REM ========== STEP 1: Verify MySQL ==========
echo [STEP 1/3] Verifying MySQL...
netstat -ano | findstr ":3306" | findstr "LISTENING" >nul 2>&1
if errorlevel 1 (
    echo ❌ MySQL is not running!
    echo.
    echo Please start MySQL from XAMPP Control Panel first.
    pause
    exit /b 1
)
echo ✓ MySQL is running on port 3306
echo.

REM Test connection
"C:\xampp\mysql\bin\mysql.exe" -u root -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ❌ Cannot connect to MySQL!
    echo Please check XAMPP MySQL status.
    pause
    exit /b 1
)
echo ✓ MySQL connection successful
echo.

REM ========== STEP 2: Import Database ==========
echo [STEP 2/3] Importing database...
echo This will take 10-15 seconds...
echo.

REM Drop existing database
"C:\xampp\mysql\bin\mysql.exe" -u root -e "DROP DATABASE IF EXISTS construction_hazard_detection;" 2>nul
echo   • Cleaned old database (if any)

REM Create database
"C:\xampp\mysql\bin\mysql.exe" -u root -e "CREATE DATABASE construction_hazard_detection CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
echo   • Created new database

REM Import schema
"C:\xampp\mysql\bin\mysql.exe" -u root construction_hazard_detection < scripts\init.sql 2>nul
if errorlevel 1 (
    echo ❌ Import failed!
    pause
    exit /b 1
)
echo   • Imported schema successfully
echo.

REM ========== STEP 3: Verify ==========
echo [STEP 3/3] Verifying installation...

REM Count tables
for /f "tokens=*" %%a in ('"C:\xampp\mysql\bin\mysql.exe" -u root -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='construction_hazard_detection';" 2^>nul') do set table_count=%%a
echo   • Found %table_count% tables

REM Check user
for /f "tokens=*" %%a in ('"C:\xampp\mysql\bin\mysql.exe" -u root -N -e "SELECT COUNT(*) FROM construction_hazard_detection.users;" 2^>nul') do set user_count=%%a
echo   • Found %user_count% users

echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                  SETUP COMPLETED SUCCESSFULLY!                ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo Database: construction_hazard_detection
echo Tables: %table_count%
echo Users: %user_count%
echo.
echo Default Login Credentials:
echo   • Username: user
echo   • Password: password
echo   • Role: admin
echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                      NEXT STEPS                               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo 1. Make sure Redis is running
echo 2. Run: start_all_apis.bat
echo 3. Open: https://visionnaire-cda17.web.app
echo 4. Login with credentials above
echo.
pause
