@echo off
echo ========================================
echo   Importing Database Schema
echo ========================================
echo.

REM Check if MySQL is accessible
echo Checking MySQL connection...
"C:\xampp\mysql\bin\mysql.exe" -u root -e "SELECT 1" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Cannot connect to MySQL!
    echo Please make sure XAMPP MySQL is running.
    pause
    exit /b 1
)

echo MySQL connection OK!
echo.

echo Importing init.sql...
echo This may take a few seconds...
echo.

"C:\xampp\mysql\bin\mysql.exe" -u root --default-character-set=utf8mb4 < "scripts\init.sql"

if errorlevel 1 (
    echo.
    echo ERROR: Import failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Import Successful!
echo ========================================
echo.
echo Verifying database...
echo.

"C:\xampp\mysql\bin\mysql.exe" -u root -e "USE construction_hazard_detection; SHOW TABLES; SELECT username, role FROM users;"

echo.
echo ========================================
echo   Database Ready!
echo ========================================
echo.
echo Default Login:
echo   Username: user
echo   Password: password
echo.
pause
