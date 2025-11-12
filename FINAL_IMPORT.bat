@echo off
cd /d D:\Construction-Hazard-Detection

echo ========================================
echo   DATABASE IMPORT
echo ========================================
echo.
echo Importing database...
echo Please wait (this might take 30-60 seconds)...
echo.

"C:\xampp\mysql\bin\mysql.exe" -u root < scripts\init.sql

if errorlevel 1 (
    echo ERROR: Import failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   IMPORT COMPLETED!
echo ========================================
echo.
echo Verifying database...
"C:\xampp\mysql\bin\mysql.exe" -u root -e "USE construction_hazard_detection; SHOW TABLES;"

echo.
echo Checking users...
"C:\xampp\mysql\bin\mysql.exe" -u root -e "USE construction_hazard_detection; SELECT username, role FROM users;"

echo.
echo ========================================
echo   SUCCESS!
echo ========================================
echo.
echo Default Login:
echo   Username: user
echo   Password: password
echo.
pause
