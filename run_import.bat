@echo off
cd /d "D:\Construction-Hazard-Detection"
echo Importing database...
"C:\xampp\mysql\bin\mysql.exe" -u root --default-character-set=utf8mb4 < "scripts\init.sql" 2>&1
echo.
echo Checking result...
"C:\xampp\mysql\bin\mysql.exe" -u root -e "USE construction_hazard_detection; SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema='construction_hazard_detection'; SELECT username, role FROM users LIMIT 5;" 2>&1
