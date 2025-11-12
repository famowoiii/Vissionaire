@echo off
title First Time Setup - Construction Hazard Detection
color 0B

echo ============================================================
echo    Construction Hazard Detection System
echo    First Time Setup Script
echo ============================================================
echo.
echo This script will:
echo   1. Check Python installation
echo   2. Install required Python packages
echo   3. Check MySQL connection
echo   4. Import database schema
echo   5. Check Redis installation
echo.
pause

REM Step 1: Check Python
echo.
echo [1/5] Checking Python Installation...
echo ============================================================
python --version 2>nul
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH!
    echo.
    echo Please install Python 3.8 or higher from:
    echo   https://www.python.org/downloads/
    echo.
    echo Make sure to check "Add Python to PATH" during installation!
    echo.
    pause
    exit /b 1
)
echo [OK] Python is installed
echo.

REM Step 2: Install Python packages
echo [2/5] Installing Python Dependencies...
echo ============================================================
echo This may take a few minutes...
echo.
pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies!
    echo.
    echo Please check your internet connection and try again.
    echo.
    pause
    exit /b 1
)
echo [OK] All Python packages installed
echo.

REM Step 3: Check MySQL
echo [3/5] Checking MySQL Connection...
echo ============================================================
python -c "import pymysql; conn = pymysql.connect(host='127.0.0.1', user='root', password=''); conn.close(); print('MySQL connection OK')" 2>nul
if errorlevel 1 (
    echo [ERROR] Cannot connect to MySQL!
    echo.
    echo Please ensure:
    echo   1. XAMPP is installed
    echo   2. MySQL service is running in XAMPP Control Panel
    echo   3. MySQL is accessible on port 3306
    echo.
    pause
    exit /b 1
)
echo [OK] MySQL is accessible
echo.

REM Step 4: Import Database
echo [4/5] Importing Database Schema...
echo ============================================================
echo Creating database and tables...
echo.

REM Try to find MySQL executable
set MYSQL_PATH=C:\xampp\mysql\bin\mysql.exe
if not exist "%MYSQL_PATH%" (
    echo [WARNING] MySQL not found at default XAMPP location
    echo Please enter the full path to mysql.exe
    echo Example: C:\xampp\mysql\bin\mysql.exe
    set /p MYSQL_PATH="MySQL path: "
)

"%MYSQL_PATH%" -u root < scripts\init.sql 2>nul
if errorlevel 1 (
    echo [ERROR] Failed to import database!
    echo.
    echo Please try manually:
    echo   1. Open phpMyAdmin
    echo   2. Create database: construction_hazard_detection
    echo   3. Import file: scripts\init.sql
    echo.
    pause
    exit /b 1
)
echo [OK] Database imported successfully
echo.

REM Verify database
echo Verifying database tables...
python -c "import pymysql; conn = pymysql.connect(host='127.0.0.1', user='root', password='', db='construction_hazard_detection'); cur = conn.cursor(); cur.execute('SHOW TABLES'); tables = cur.fetchall(); print(f'{len(tables)} tables found'); conn.close()" 2>nul
echo.

REM Step 5: Check Redis
echo [5/5] Checking Redis Installation...
echo ============================================================
python -c "import redis; r = redis.Redis(host='127.0.0.1', port=6379); r.ping(); print('Redis OK')" 2>nul
if errorlevel 1 (
    echo [WARNING] Redis is not running or not installed!
    echo.
    echo Redis is required for streaming functionality.
    echo.
    echo Windows installation:
    echo   1. Download Redis for Windows from:
    echo      https://github.com/microsoftarchive/redis/releases
    echo   2. Install and start Redis server
    echo.
    echo Or use WSL:
    echo   wsl sudo service redis-server start
    echo.
    echo You can continue without Redis, but streaming won't work.
    echo.
    pause
) else (
    echo [OK] Redis is running
    echo.
)

REM Step 6: Create .env file if not exists
echo Creating .env file if not exists...
if not exist .env (
    echo Creating default .env configuration...
    (
        echo DATABASE_URL=mysql+asyncmy://root@127.0.0.1:3306/construction_hazard_detection
        echo JWT_SECRET_KEY=your-super-secret-jwt-key-change-this-in-production
        echo API_USERNAME=user
        echo API_PASSWORD=password
        echo DETECT_API_URL=http://127.0.0.1:8000
        echo STREAMING_API_URL=http://127.0.0.1:8800
        echo DB_MANAGEMENT_API_URL=http://127.0.0.1:8005
        echo REDIS_HOST=127.0.0.1
        echo REDIS_PORT=6379
        echo REDIS_PASSWORD=
    ) > .env
    echo [OK] .env file created
) else (
    echo [OK] .env file already exists
)
echo.

echo ============================================================
echo    SETUP COMPLETE!
echo ============================================================
echo.
echo Default credentials:
echo   Username: user
echo   Password: password
echo.
echo Next steps:
echo   1. Make sure MySQL and Redis are running
echo   2. Run START_SYSTEM.bat to start all services
echo   3. Open web interface: https://visionnaire-cda17.web.app
echo   4. Configure API URLs to use 127.0.0.1
echo.
echo For more information, see README.md
echo.
pause
