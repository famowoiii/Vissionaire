@echo off
echo ================================================
echo   Construction Hazard Detection System
echo   QUICK START SETUP
echo ================================================
echo.

REM Check if models exist
if not exist "models\pt" (
    echo [WARNING] Model files not found!
    echo.
    echo You need to download YOLO models first.
    echo.
    echo Option 1 - Download via Hugging Face CLI:
    echo   huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 --repo-type model --include "models/pt/*.pt" --local-dir .
    echo.
    echo Option 2 - Download manually:
    echo   Visit: https://huggingface.co/yihong1120/Construction-Hazard-Detection-YOLO11/tree/main/models/pt
    echo   Download all .pt files to: models\pt\
    echo.
    echo Do you want to try downloading now? (requires huggingface-cli)
    choice /C YN /M "Press Y to download, N to skip"

    if errorlevel 2 goto skip_download
    if errorlevel 1 goto download_models
)

:check_models_exist
echo [OK] Model files found!
goto check_redis

:download_models
echo.
echo Downloading models... This may take a while.
pip install -U huggingface_hub
huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 --repo-type model --include "models/pt/*.pt" --local-dir .

if errorlevel 1 (
    echo.
    echo [ERROR] Download failed!
    echo Please download models manually from:
    echo https://huggingface.co/yihong1120/Construction-Hazard-Detection-YOLO11/tree/main/models/pt
    echo.
    pause
    exit /b 1
)

echo [OK] Models downloaded successfully!
goto check_redis

:skip_download
echo.
echo [WARNING] Skipping model download.
echo The system will NOT work without models!
echo.

:check_redis
echo.
echo Checking Redis...
redis-cli.exe ping >nul 2>&1

if errorlevel 1 (
    echo [INFO] Starting Redis server...
    start "Redis Server" cmd /k "redis-server.exe redis.windows.conf"
    timeout /t 3 /nobreak >nul

    redis-cli.exe ping >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Failed to start Redis!
        pause
        exit /b 1
    )
)

echo [OK] Redis is running!

:check_mysql
echo.
echo Checking MySQL...
netstat -an | findstr ":3306" >nul 2>&1

if errorlevel 1 (
    echo [WARNING] MySQL not running on port 3306!
    echo Please start XAMPP MySQL or your MySQL service.
    echo.
    pause
) else (
    echo [OK] MySQL is running!
)

:check_database
echo.
echo Checking database...
mysql -u root -e "USE construction_hazard_detection;" >nul 2>&1

if errorlevel 1 (
    echo [INFO] Database not found. Creating...
    mysql -u root -e "CREATE DATABASE construction_hazard_detection;"

    if errorlevel 1 (
        echo [WARNING] Could not create database automatically.
        echo Please create it manually:
        echo   mysql -u root
        echo   CREATE DATABASE construction_hazard_detection;
        echo.
    ) else (
        echo [OK] Database created!
    )
) else (
    echo [OK] Database exists!
)

echo.
echo ================================================
echo   Setup Complete!
echo ================================================
echo.
echo Next steps:
echo   1. Run START_ALL_SERVICES.bat to start all APIs
echo   2. Follow VISIONNAIRE_SETUP.md for web interface setup
echo.
echo Press any key to start services now...
pause >nul

call START_ALL_SERVICES.bat
