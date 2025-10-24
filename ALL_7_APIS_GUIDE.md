# 🚀 COMPLETE GUIDE - ALL 7 API SERVICES

## 📋 OVERVIEW

Aplikasi Construction Hazard Detection memiliki **7 API Services**:

| # | Service Name | Port | Purpose | Required |
|---|--------------|------|---------|----------|
| 1 | **YOLO Detection API** | 8000 | YOLO model inference | ✅ Yes |
| 2 | **Violation Records API** | 8002 | Save violation records | ✅ Yes |
| 3 | **FCM Notification API** | 8003 | Push notifications | ⚠️ Optional |
| 4 | **Chat API (Line Bot)** | 8004 | LINE chatbot integration | ⚠️ Optional |
| 5 | **DB Management API** | 8005 | User/site management & auth | ✅ Yes |
| 6 | **File Management API** | - | File uploads/downloads | ⚠️ Optional |
| 7 | **Streaming Web API** | 8800 | WebSocket live streaming | ✅ Yes |

**Plus:**
- **MySQL Database** (Port 3306) - Required
- **Redis Cache** (Port 6379) - Required

---

## 🎯 QUICK START - ALL 7 APIS

### **Method 1: Automatic Startup (RECOMMENDED)**

```cmd
cd D:\Construction-Hazard-Detection
START_ALL_7_APIS.bat
```

Atau via Command Prompt:
```cmd
cd /d D:\Construction-Hazard-Detection
cmd /c START_ALL_7_APIS.bat
```

### **Method 2: Manual (Full Control)**

Open **7 separate terminal windows:**

#### Terminal 1: Redis
```cmd
cd D:\Construction-Hazard-Detection
redis-server.exe redis.windows.conf
```

#### Terminal 2: YOLO Detection API (Port 8000)
```cmd
cd D:\Construction-Hazard-Detection\examples\YOLO_server_api
python main.py
```

#### Terminal 3: Violation Records API (Port 8002)
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.violation_records.app:app --host 0.0.0.0 --port 8002
```

#### Terminal 4: FCM Notification API (Port 8003)
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.local_notification_server.app:app --host 0.0.0.0 --port 8003
```

#### Terminal 5: Chat API (Port 8004) - Optional
```cmd
cd D:\Construction-Hazard-Detection\examples\line_chatbot
python line_bot.py
```

#### Terminal 6: DB Management API (Port 8005)
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005
```

#### Terminal 7: Streaming Web API (Port 8800)
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

---

## 🔧 DETAILED API CONFIGURATION

### **1. YOLO Detection API (Port 8000)**

**Purpose:** Run YOLO model inference

**Endpoint:** `http://127.0.0.1:8000`

**Documentation:** `http://127.0.0.1:8000/docs`

**Key Features:**
- Object detection using YOLO11 models
- WebSocket support for real-time detection
- Model variants: yolo11n, yolo11s, yolo11m, yolo11l, yolo11x
- GPU acceleration support

**Configuration:**
```env
# In .env or examples/YOLO_server_api/backend/config.py
USE_TENSORRT=false
USE_SAHI=false
MODEL_VARIANTS=yolo11x,yolo11l,yolo11m,yolo11s,yolo11n
LAZY_LOAD_MODELS=true
MAX_LOADED_MODELS=5
```

**Test:**
```bash
curl http://127.0.0.1:8000/health
curl http://127.0.0.1:8000/docs
```

---

### **2. Violation Records API (Port 8002)**

**Purpose:** Store and retrieve violation records

**Endpoint:** `http://127.0.0.1:8002`

**Documentation:** `http://127.0.0.1:8002/docs`

**Key Features:**
- Save violation records to database
- Image upload and storage
- Query violation history
- Export violation data

**Database Table:** `violations`

**Test:**
```bash
curl http://127.0.0.1:8002/docs
```

---

### **3. FCM Notification API (Port 8003)**

**Purpose:** Send push notifications via Firebase Cloud Messaging

**Endpoint:** `http://127.0.0.1:8003`

**Documentation:** `http://127.0.0.1:8003/docs`

**Key Features:**
- Send FCM push notifications
- Site-based notifications
- User-targeted notifications
- Notification templates

**Configuration:**
```env
# In .env
FIREBASE_CRED_PATH=examples/local_notification_server/your-firebase-adminsdk.json
project_id=your-project-id
```

**Setup Firebase (Optional):**
1. Create Firebase project
2. Download service account JSON
3. Place in `examples/local_notification_server/`
4. Update `.env` with path and project ID

**Test:**
```bash
curl http://127.0.0.1:8003/docs
```

---

### **4. Chat API - LINE Bot (Port 8004)**

**Purpose:** LINE chatbot integration for notifications

**Endpoint:** `http://127.0.0.1:8004`

**Key Features:**
- LINE messaging integration
- Receive violation notifications via LINE
- Interactive commands
- Multi-language support

**Configuration:**
```python
# In examples/line_chatbot/line_bot.py
CHANNEL_ACCESS_TOKEN = 'your_line_channel_token'
CHANNEL_SECRET = 'your_line_channel_secret'
```

**Setup LINE Bot (Optional):**
1. Create LINE Developers account
2. Create Messaging API channel
3. Get Channel Access Token & Secret
4. Configure webhook URL
5. Update line_bot.py with credentials

**Test:**
```bash
curl http://127.0.0.1:8004/webhook
```

---

### **5. DB Management API (Port 8005)**

**Purpose:** User authentication & database management

**Endpoint:** `http://127.0.0.1:8005`

**Documentation:** `http://127.0.0.1:8005/docs`

**Key Features:**
- User authentication (login/logout)
- JWT token management
- Site management (CRUD)
- Stream configuration management
- User management
- Feature flags

**Main Endpoints:**
- `POST /login` - User login
- `POST /logout` - User logout
- `POST /refresh` - Refresh token
- `GET /sites` - List sites
- `POST /sites` - Create site
- `GET /streams` - List streams
- `POST /streams` - Create stream config

**Test:**
```bash
curl -X POST http://127.0.0.1:8005/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user","password":"password"}'
```

---

### **6. File Management API**

**Purpose:** Upload/download files (images, videos, documents)

**Note:** Integrated within other APIs, not standalone service

**Features:**
- Image upload for violations
- Firebase Storage integration
- Local file storage
- Static file serving

**Handled by:**
- Violation Records API (image uploads)
- Streaming Web API (frame images)

---

### **7. Streaming Web API (Port 8800)**

**Purpose:** Real-time video streaming via WebSocket

**Endpoint:** `http://127.0.0.1:8800`

**Documentation:** `http://127.0.0.1:8800/docs`

**Key Features:**
- WebSocket server for live video streams
- Frame broadcasting to multiple clients
- Real-time detection overlays
- Low-latency streaming

**WebSocket Endpoints:**
- `ws://127.0.0.1:8800/ws/labels/{stream_name}` - Live stream

**Test:**
```bash
curl http://127.0.0.1:8800/docs
```

---

## 🌐 VISIONNAIRE WEB CONFIGURATION

### **Complete localStorage Setup:**

Press **F12** in browser, go to **Console**, paste:

```javascript
// Clear old settings
localStorage.clear();

// Configure ALL 7 API endpoints
localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004');
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('FILE_MANAGEMENT_API_URL', 'http://127.0.0.1:8005');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');

console.log('✅ All 7 API endpoints configured!');

// Reload page
location.reload();
```

---

## ✅ VERIFY ALL SERVICES

### Check All Ports:

```cmd
netstat -an | findstr ":8000 :8002 :8003 :8004 :8005 :8800 :3306 :6379" | findstr "LISTENING"
```

**Expected Output:**
```
TCP    0.0.0.0:8000    LISTENING  ✅ YOLO API
TCP    0.0.0.0:8002    LISTENING  ✅ Violation API
TCP    0.0.0.0:8003    LISTENING  ✅ FCM API
TCP    0.0.0.0:8004    LISTENING  ✅ Chat API
TCP    0.0.0.0:8005    LISTENING  ✅ DB Management
TCP    0.0.0.0:8800    LISTENING  ✅ Streaming API
TCP    0.0.0.0:3306    LISTENING  ✅ MySQL
```

**Check Redis:**
```cmd
redis-cli.exe ping
```
Should return: `PONG` ✅

---

## 📊 SERVICE DEPENDENCIES

```
┌─────────────────────────────────────────────┐
│           USER (Visionnaire Web)            │
└──────────────────┬──────────────────────────┘
                   │
    ┌──────────────┼──────────────┐
    │              │              │
    ▼              ▼              ▼
┌────────┐  ┌──────────┐  ┌────────────┐
│ DB Mgmt│  │Streaming │  │ Violation  │
│  (8005)│  │  (8800)  │  │   (8002)   │
└───┬────┘  └────┬─────┘  └──────┬─────┘
    │            │                │
    │     ┌──────┴────────┐       │
    │     │               │       │
    ▼     ▼               ▼       ▼
┌────────────┐      ┌──────────────┐
│   MySQL    │      │  YOLO API    │
│   (3306)   │      │   (8000)     │
└────────────┘      └──────────────┘
         │                  │
         │      ┌───────────┘
         │      │
         ▼      ▼
    ┌──────────────┐
    │    Redis     │
    │    (6379)    │
    └──────────────┘
```

**Required for Basic Operation:**
1. MySQL (3306) - Database
2. Redis (6379) - Cache
3. DB Management API (8005) - Auth & config
4. Streaming API (8800) - Live video
5. YOLO API (8000) - Detection (can be local)

**Optional:**
6. Violation API (8002) - History (recommended)
7. FCM API (8003) - Notifications
8. Chat API (8004) - LINE bot

---

## 🎯 MINIMAL vs FULL SETUP

### **Minimal (4 Services):**

For basic testing:

```
✅ MySQL (3306)
✅ Redis (6379)
✅ DB Management API (8005)
✅ Streaming API (8800)
+ Detection via main.py (local YOLO)
```

### **Recommended (6 Services):**

For full features:

```
✅ MySQL (3306)
✅ Redis (6379)
✅ YOLO Detection API (8000)
✅ Violation Records API (8002)
✅ DB Management API (8005)
✅ Streaming API (8800)
+ Detection via main.py
```

### **Complete (7+ Services):**

For production:

```
✅ MySQL (3306)
✅ Redis (6379)
✅ YOLO Detection API (8000)
✅ Violation Records API (8002)
✅ FCM Notification API (8003)
✅ Chat API (8004) - if using LINE
✅ DB Management API (8005)
✅ Streaming API (8800)
+ Detection via main.py
```

---

## 🔧 TROUBLESHOOTING

### "Port already in use"

```cmd
REM Find process using port
netstat -ano | findstr ":8000"

REM Kill process (replace PID)
taskkill /F /PID [PID]
```

### "Service not starting"

Check logs in terminal window for errors.

Common issues:
- Missing dependencies: `pip install -r requirements.txt`
- Wrong directory: Ensure you're in correct folder
- Port blocked: Check firewall settings

### "Can't connect from Visionnaire"

1. Check CORS settings in APIs
2. Verify localStorage configuration
3. Check browser console for errors
4. Try CORS extension (Chrome)

---

## 📝 COMPLETE STARTUP CHECKLIST

```
□ MySQL/XAMPP running
□ Redis started
□ All models downloaded
□ Database initialized
□ .env file configured
□ Run START_ALL_7_APIS.bat
□ Verify all ports listening
□ Configure Visionnaire localStorage
□ Login to Visionnaire
□ Start detection (main.py)
□ ✅ System fully operational!
```

---

## 🚀 ONE-COMMAND STARTUP

```cmd
cd /d D:\Construction-Hazard-Detection && START_ALL_7_APIS.bat
```

Then in NEW terminal:
```cmd
cd /d D:\Construction-Hazard-Detection && python main.py --config config\test_stream.json
```

---

## 🛑 STOP ALL SERVICES

```cmd
cd /d D:\Construction-Hazard-Detection
STOP_EVERYTHING.bat
```

Or manual:
```cmd
taskkill /F /IM python.exe /T
taskkill /F /IM uvicorn.exe /T
redis-cli.exe shutdown
```

---

**ALL 7 APIS READY TO USE!** 🎉

Files created:
- ✅ `START_ALL_7_APIS.bat` - Auto-start all services
- ✅ `ALL_7_APIS_GUIDE.md` - This guide
- ✅ `STOP_EVERYTHING.bat` - Stop all services

**Next:** Run `START_ALL_7_APIS.bat` and configure Visionnaire!
