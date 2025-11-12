@echo off
echo Testing MySQL connection...
echo.

"C:\xampp\mysql\bin\mysql.exe" -u root -e "SELECT VERSION();" 2>&1

if errorlevel 1 (
    echo.
    echo ERROR: Cannot connect
    echo.
    echo Trying with explicit host...
    "C:\xampp\mysql\bin\mysql.exe" -h 127.0.0.1 -u root -e "SELECT VERSION();" 2>&1
)

echo.
pause
