@echo off
chcp 65001 >nul
color 0A
cls

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║           DATABASE IMPORT TOOL - Manual Method                ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

REM Check if MySQL is running
echo [STEP 1] Checking MySQL status...
netstat -an | findstr ":3306" >nul 2>&1
if errorlevel 1 (
    echo ❌ ERROR: MySQL is NOT running on port 3306!
    echo.
    echo Please start MySQL from XAMPP Control Panel first.
    echo.
    pause
    exit /b 1
)
echo ✓ MySQL is running on port 3306
echo.

REM Check if mysql.exe exists
echo [STEP 2] Checking MySQL client...
if not exist "C:\xampp\mysql\bin\mysql.exe" (
    echo ❌ ERROR: MySQL client not found at C:\xampp\mysql\bin\mysql.exe
    echo.
    echo Please check your XAMPP installation.
    echo.
    pause
    exit /b 1
)
echo ✓ MySQL client found
echo.

REM Check if init.sql exists
echo [STEP 3] Checking SQL file...
if not exist "scripts\init.sql" (
    echo ❌ ERROR: scripts\init.sql not found!
    echo.
    pause
    exit /b 1
)
echo ✓ SQL file found
echo.

echo [STEP 4] Importing database...
echo This may take 10-30 seconds. Please wait...
echo.

REM Import the database
C:\xampp\mysql\bin\mysql.exe -u root < scripts\init.sql

if errorlevel 1 (
    echo.
    echo ❌ ERROR: Import failed!
    echo.
    pause
    exit /b 1
)

echo ✓ Database imported successfully!
echo.

echo [STEP 5] Verifying database...
C:\xampp\mysql\bin\mysql.exe -u root --execute="USE construction_hazard_detection; SELECT COUNT(*) as Tables FROM information_schema.tables WHERE table_schema='construction_hazard_detection';" 2>nul

echo.
echo [STEP 6] Checking default user...
C:\xampp\mysql\bin\mysql.exe -u root --execute="USE construction_hazard_detection; SELECT username, role, is_active FROM users;" 2>nul

echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                  IMPORT COMPLETED SUCCESSFULLY!               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo Default Login Credentials:
echo   Username: user
echo   Password: password
echo.
echo Next step: Run start_all_apis.bat
echo.
pause
