@echo off
title System Health Check
color 0E

echo ============================================================
echo    Construction Hazard Detection
echo    System Health Check
echo ============================================================
echo.

REM Check 1: Python
echo [1/6] Python Installation...
python --version 2>nul
if errorlevel 1 (
    echo [FAIL] Python not found
) else (
    echo [PASS] Python installed
)
echo.

REM Check 2: MySQL
echo [2/6] MySQL Connection...
python -c "import pymysql; conn = pymysql.connect(host='127.0.0.1', user='root', password='', db='construction_hazard_detection'); print('[PASS] MySQL connected'); conn.close()" 2>nul
if errorlevel 1 (
    echo [FAIL] Cannot connect to MySQL
    echo Reason: MySQL not running or database not created
)
echo.

REM Check 3: Redis
echo [3/6] Redis Connection...
python -c "import redis; r = redis.Redis(host='127.0.0.1', port=6379); r.ping(); print('[PASS] Redis connected')" 2>nul
if errorlevel 1 (
    echo [FAIL] Cannot connect to Redis
    echo Reason: Redis server not running
)
echo.

REM Check 4: Database Tables
echo [4/6] Database Tables...
python -c "import pymysql; conn = pymysql.connect(host='127.0.0.1', user='root', password='', db='construction_hazard_detection'); cur = conn.cursor(); cur.execute('SHOW TABLES'); tables = cur.fetchall(); print(f'[PASS] Found {len(tables)} tables'); [print(f'  - {t[0]}') for t in tables]; conn.close()" 2>nul
if errorlevel 1 (
    echo [FAIL] Cannot read database tables
    echo Reason: Database not imported
)
echo.

REM Check 5: Backend APIs
echo [5/6] Backend API Services...
python -c "import requests; r = requests.get('http://127.0.0.1:8005/docs', timeout=2); print('[PASS] DB Management API (8005)' if r.status_code == 200 else '[FAIL]')" 2>nul
if errorlevel 1 (echo [FAIL] DB Management API not responding)

python -c "import requests; r = requests.get('http://127.0.0.1:8800/docs', timeout=2); print('[PASS] Streaming API (8800)' if r.status_code == 200 else '[FAIL]')" 2>nul
if errorlevel 1 (echo [FAIL] Streaming API not responding)

python -c "import requests; r = requests.get('http://127.0.0.1:8000/docs', timeout=2); print('[PASS] YOLO API (8000)' if r.status_code == 200 else '[FAIL]')" 2>nul
if errorlevel 1 (echo [FAIL] YOLO API not responding)
echo.

REM Check 6: Detection Service
echo [6/6] Detection Service...
tasklist | findstr python.exe >nul 2>&1
if errorlevel 1 (
    echo [FAIL] No Python processes running
) else (
    echo [PASS] Python processes detected
    tasklist | findstr python.exe
)
echo.

REM Check Redis data
echo Redis Data Check...
python -c "import redis; r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True); keys = r.keys('*'); print(f'[INFO] Redis has {len(keys)} keys'); [print(f'  - {k}') for k in keys[:5]] if keys else print('  (empty - detection may not be running)')" 2>nul
echo.

echo ============================================================
echo    Health Check Complete
echo ============================================================
echo.
echo If any checks failed, please:
echo   1. Run FIRST_TIME_SETUP.bat (if first time)
echo   2. Make sure MySQL and Redis are running
echo   3. Run START_SYSTEM.bat to start services
echo.
pause
