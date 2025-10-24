# 🚀 COMPLETE STARTUP GUIDE - Construction Hazard Detection

## 📋 PANDUAN LENGKAP: Dari NOL sampai RUNNING

Ikuti langkah-langkah ini **SECARA BERURUTAN** untuk menjalankan aplikasi.

---

## ✅ PREREQUISITE CHECK

Sebelum mulai, pastikan terinstall:

### 1. **MySQL/XAMPP**
```cmd
REM Check MySQL
netstat -an | findstr ":3306"
```
Harus muncul: `LISTENING`

**Jika belum running:**
- Buka XAMPP Control Panel
- Klik **Start** pada MySQL

### 2. **Redis**
```cmd
REM Check Redis
redis-cli.exe ping
```
Harus return: `PONG`

**Jika belum running:**
```cmd
redis-server.exe redis.windows.conf
```

### 3. **Python & Dependencies**
```cmd
python --version
pip list | findstr ultralytics
```

**Jika dependencies belum lengkap:**
```cmd
pip install -r requirements.txt
```

### 4. **YOLO Models**
```cmd
dir models\pt\*.pt
```
Harus ada 5 files:
- `best_yolo11n.pt`
- `best_yolo11s.pt`
- `best_yolo11m.pt`
- `best_yolo11l.pt`
- `best_yolo11x.pt`

**Jika belum ada:**
```cmd
huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 --repo-type model --include "models/pt/*.pt" --local-dir .
```

---

## 🗄️ STEP 1: SETUP DATABASE

### 1.1 Buka MySQL Command Line

**Via XAMPP:**
```
XAMPP Control Panel → MySQL → Shell
```

**Atau via CMD:**
```cmd
"C:\xampp\mysql\bin\mysql.exe" -u root
```

### 1.2 Initialize Database

```cmd
cd D:\Construction-Hazard-Detection
powershell -Command "Get-Content scripts/init.sql | & 'C:\xampp\mysql\bin\mysql.exe' -u root"
```

**Verify:**
```cmd
"C:\xampp\mysql\bin\mysql.exe" -u root -e "USE construction_hazard_detection; SELECT username, role FROM users;"
```

Harus muncul:
```
username | role
user     | admin
```

---

## 🔧 STEP 2: START ALL SERVICES

Buka **4 Command Prompt windows** (atau lebih) dan jalankan masing-masing service:

### 2.1 Terminal 1: Start Redis (Jika belum running)

```cmd
cd D:\Construction-Hazard-Detection
redis-server.exe redis.windows.conf
```

**Leave this window open!**

### 2.2 Terminal 2: Start DB Management API (Port 8005)

```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005 --reload
```

**Wait for:**
```
INFO: Uvicorn running on http://0.0.0.0:8005
INFO: Application startup complete.
```

**Leave this window open!**

### 2.3 Terminal 3: Start Streaming API (Port 8800)

```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800 --reload
```

**Wait for:**
```
INFO: Uvicorn running on http://0.0.0.0:8800
INFO: Application startup complete.
```

**Leave this window open!**

### 2.4 Terminal 4: Start YOLO Detection API (Port 8000) - OPTIONAL

**Hanya jika ingin pakai server inference:**

```cmd
cd D:\Construction-Hazard-Detection\examples\YOLO_server_api
python main.py
```

**Leave this window open!**

---

## ✅ STEP 3: VERIFY SERVICES RUNNING

Buka Terminal baru dan check:

```cmd
netstat -an | findstr ":8005 :8800 :3306 :6379" | findstr "LISTENING"
```

**Expected output:**
```
TCP    0.0.0.0:8005    LISTENING  ✅ DB Management
TCP    0.0.0.0:8800    LISTENING  ✅ Streaming API
TCP    0.0.0.0:3306    LISTENING  ✅ MySQL
```

**Check Redis:**
```cmd
redis-cli.exe ping
```
Must return: `PONG` ✅

---

## 🌐 STEP 4: CONFIGURE VISIONNAIRE WEB

### 4.1 Open Visionnaire

```
https://visionnaire-cda17.web.app/login
```

### 4.2 Configure API Endpoints

**Press F12** → Go to **Console** tab

**Paste this code:**

```javascript
// Clear old settings
localStorage.clear();

// Set API endpoints
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');

console.log('✅ API endpoints configured!');

// Reload page
location.reload();
```

**Press Enter**

Page will reload automatically.

### 4.3 Login

```
Username: user
Password: password
```

**Click Login** ✅

---

## 🎥 STEP 5: ADD VIDEO STREAM

### Option A: Via Visionnaire Web Interface

#### 5.1 Add Site

1. Click **"Sites"** in menu
2. Click **"Add Site"** button
3. Fill in:
   - **Site Name:** Test Site
   - **Description:** Testing detection
4. Click **"Save"**

#### 5.2 Add Stream

1. Click on the site you just created
2. Click **"Add Stream"** button
3. Fill in:

**For Local Video:**
```
Stream Name: Local Test
Video URL: D:/Construction-Hazard-Detection/tests/videos/test.mp4
Model: yolo11n
Work Start Hour: 0
Work End Hour: 24
Store in Redis: ☑ (MUST CHECK THIS!)
```

**Detection Items** (check what you want):
```
☑ Detect no safety vest or helmet
☑ Detect near machinery or vehicle
☐ Detect in restricted area
☐ Detect in utility pole restricted area
☐ Detect machinery close to pole
```

4. Click **"Save"**

### Option B: Via Config File (Faster)

Config file already exists at `config/test_stream.json`:

```json
[
  {
    "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Test Site",
    "stream_name": "Local Video Demo",
    "model_key": "yolo11n",
    "detect_with_server": false,
    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": true,
      "detect_in_restricted_area": true
    },
    "work_start_hour": 0,
    "work_end_hour": 24,
    "store_in_redis": true
  }
]
```

**You can use this directly!** (Skip to Step 6)

---

## 🎬 STEP 6: START DETECTION

Open **NEW Terminal** (Terminal 5):

### Option A: With Config File (Recommended for Testing)

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

### Option B: With Database Polling (If you added via Visionnaire)

```cmd
cd D:\Construction-Hazard-Detection
python main.py --poll 10
```

**Expected Output:**
```
Loading model: yolo11n
Model loaded successfully
Processing stream: Test Site - Local Video Demo
Processing frame 1...
Processing frame 2...
FPS: 5.2
```

**Leave this window open!** Detection is running.

---

## 👀 STEP 7: VIEW LIVE STREAM

### 7.1 Go to Visionnaire

Already open at: `https://visionnaire-cda17.web.app`

### 7.2 Navigate to Live Stream

1. Click **"Live Stream"** in menu
2. Select **"Test Site"**
3. Select **"Local Video Demo"** (or your stream name)

### 7.3 See Detection!

You should see:
- ✅ Live video feed
- ✅ Bounding boxes on detected objects
- ✅ Labels (Hardhat, Safety-Vest, Person, etc.)
- ✅ Warnings for violations

---

## 🎯 STEP 8: MONITOR & MANAGE

### 8.1 Dashboard

Click **"Dashboard"** to see:
- Total violations
- Statistics by site
- Recent detections

### 8.2 Violations History

Click **"Violations"** to see:
- All detected violations
- Images with detections
- Timestamps
- Export data

### 8.3 Manage Streams

Click **"Streams"** to:
- Add more streams
- Edit existing streams
- Enable/disable streams
- Change detection settings

---

## 🔄 RESTART PROCEDURE

### When You Need to Restart:

#### Quick Restart (Keep services running):

**Stop detection:**
- Close Terminal 5 (where `main.py` is running)

**Restart detection:**
```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

#### Full Restart (All services):

**Stop everything:**
```cmd
REM Kill all Python processes
taskkill /F /IM python.exe /T

REM Stop Redis (if you want)
redis-cli.exe shutdown
```

**Restart from Step 2** (Start All Services)

---

## 📝 DAILY STARTUP CHECKLIST

Use this checklist every time you start the system:

```
□ Step 1: Check XAMPP MySQL is running
□ Step 2: Start Redis (Terminal 1)
□ Step 3: Start DB Management API (Terminal 2)
□ Step 4: Start Streaming API (Terminal 3)
□ Step 5: Verify all services with netstat
□ Step 6: Open Visionnaire and login
□ Step 7: Start main.py detection (Terminal 4)
□ Step 8: Check Live Stream in Visionnaire
□ ✅ System Running!
```

---

## 🚀 QUICK START SCRIPT

Untuk memudahkan, gunakan batch script ini:

### Create: `START_EVERYTHING.bat`

```batch
@echo off
echo ================================================
echo   Starting Construction Hazard Detection
echo ================================================

REM Check MySQL
netstat -an | findstr ":3306" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo [ERROR] MySQL not running! Start XAMPP MySQL first.
    pause
    exit /b 1
)
echo [OK] MySQL running

REM Start Redis
redis-cli.exe ping >nul 2>&1
if errorlevel 1 (
    echo [STARTING] Redis...
    start "Redis Server" cmd /k "redis-server.exe redis.windows.conf"
    timeout /t 3 /nobreak >nul
)
echo [OK] Redis running

REM Start DB Management API
echo [STARTING] DB Management API (Port 8005)...
start "DB Management API" cmd /k "uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005"
timeout /t 5 /nobreak >nul

REM Start Streaming API
echo [STARTING] Streaming API (Port 8800)...
start "Streaming API" cmd /k "uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800"
timeout /t 5 /nobreak >nul

echo.
echo ================================================
echo   All Services Started!
echo ================================================
echo.
echo Next steps:
echo 1. Open: https://visionnaire-cda17.web.app/login
echo 2. Login: user / password
echo 3. Run detection: python main.py --config config\test_stream.json
echo.
pause
```

### Usage:

```cmd
cd D:\Construction-Hazard-Detection
START_EVERYTHING.bat
```

Then manually start detection:
```cmd
python main.py --config config\test_stream.json
```

---

## 🔧 TROUBLESHOOTING

### Problem 1: "Port already in use"

**Solution:**
```cmd
REM Find process using the port (e.g., 8005)
netstat -ano | findstr ":8005"

REM Kill the process (replace PID with actual number)
taskkill /F /PID [PID]

REM Restart the service
```

### Problem 2: "Cannot connect to database"

**Solution:**
```cmd
REM Check MySQL
netstat -an | findstr ":3306"

REM Start XAMPP MySQL if not running

REM Verify database exists
"C:\xampp\mysql\bin\mysql.exe" -u root -e "SHOW DATABASES;" | findstr construction_hazard_detection
```

### Problem 3: "Login failed"

**Solution:**
```cmd
REM Reset password
python reset_user_password.py

REM Or re-initialize database
powershell -Command "Get-Content scripts/init.sql | & 'C:\xampp\mysql\bin\mysql.exe' -u root"
```

### Problem 4: "No video in Live Stream"

**Checklist:**
1. Is main.py running? ✓
2. Is store_in_redis enabled? ✓
3. Is Streaming API running (port 8800)? ✓
4. Check main.py output for errors
5. Check Redis: `redis-cli KEYS stream_frame:*`

### Problem 5: "WebSocket connection error"

**Solution:**
```cmd
REM Restart Streaming API
taskkill /F /IM python.exe /FI "WINDOWTITLE eq Streaming*"

cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

---

## 📊 SERVICE PORTS SUMMARY

| Service | Port | Command | Required |
|---------|------|---------|----------|
| MySQL | 3306 | XAMPP | ✅ Yes |
| Redis | 6379 | `redis-server.exe` | ✅ Yes |
| DB Management | 8005 | `uvicorn examples.db_management.app:app` | ✅ Yes |
| Streaming API | 8800 | `uvicorn examples.streaming_web.backend.app:app` | ✅ Yes |
| YOLO API | 8000 | `python examples/YOLO_server_api/main.py` | ⚠️ Optional |
| Violation API | 8002 | `uvicorn examples.violation_records.app:app` | ⚠️ Optional |
| FCM API | 8003 | `uvicorn examples.local_notification_server.app:app` | ⚠️ Optional |

**Minimum Required:**
- MySQL (3306)
- Redis (6379)
- DB Management API (8005)
- Streaming API (8800)
- main.py detection

---

## 🎓 COMPLETE WORKFLOW

```
1. Prerequisites Ready
   ├─ MySQL running
   ├─ Models downloaded
   └─ Dependencies installed

2. Start Services
   ├─ Redis (Terminal 1)
   ├─ DB Management API (Terminal 2)
   └─ Streaming API (Terminal 3)

3. Configure Visionnaire
   ├─ Set localStorage
   └─ Login

4. Add Stream
   ├─ Via Visionnaire UI
   └─ Or use config file

5. Start Detection
   └─ python main.py (Terminal 4)

6. Monitor
   ├─ Live Stream
   ├─ Dashboard
   └─ Violations

7. Stop
   ├─ Close detection (Terminal 4)
   └─ Close other services if needed
```

---

## 📱 CREDENTIALS & URLS

### Login Credentials:
```
Username: user
Password: password
```

### URLs:
```
Visionnaire Web: https://visionnaire-cda17.web.app/login
DB Management API: http://127.0.0.1:8005/docs
Streaming API: http://127.0.0.1:8800/docs
```

### Test Video:
```
Local: D:/Construction-Hazard-Detection/tests/videos/test.mp4
Config: config/test_stream.json
```

---

## 🎯 MINIMAL STARTUP COMMANDS

For daily use, just run these in order:

```cmd
REM Terminal 1
redis-server.exe redis.windows.conf

REM Terminal 2
cd D:\Construction-Hazard-Detection
uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005

REM Terminal 3
cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800

REM Terminal 4
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

Then open: https://visionnaire-cda17.web.app/login

---

**SELESAI! Anda sudah bisa menjalankan sistem sendiri!** 🎉

Bookmark file ini untuk referensi cepat!
