# ⚡ QUICK REFERENCE - Construction Hazard Detection

## 🚀 START SYSTEM

### **ONE-LINE (Run from ANY directory):**
```cmd
cd /d D:\Construction-Hazard-Detection && START_COMPLETE_SYSTEM.bat
```

### **Option 1: Complete System (⭐ RECOMMENDED)**
```cmd
START_COMPLETE_SYSTEM.bat
```
Starts everything: Redis, APIs, Detection with Telegram!

### **Option 2: Services Only**
```cmd
START_SERVICES_ONLY.bat
```
Then manually: `python main.py --config config\test_stream.json`

### **Option 3: All 7 APIs (Advanced)**
```cmd
START_ALL_7_APIS.bat
```

---

## 🌐 CONFIGURE VISIONNAIRE

**URL:** https://visionnaire-cda17.web.app/login

**Press F12 → Console → Paste:**
```javascript
localStorage.clear();
localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004');
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('FILE_MANAGEMENT_API_URL', 'http://127.0.0.1:8005');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
location.reload();
```

**Login:**
- Username: `user`
- Password: `password`

---

## 🎬 START DETECTION

```cmd
cd /d D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

---

## 📊 ALL 7 API SERVICES

### **✅ All Included in START_COMPLETE_SYSTEM.bat!**

| # | Service | Port | URL | Status |
|---|---------|------|-----|--------|
| 1 | YOLO Detection | 8000 | http://127.0.0.1:8000/docs | ✅ Auto-start |
| 2 | Violation Records | 8002 | http://127.0.0.1:8002/docs | ✅ Auto-start |
| 3 | FCM Notifications | 8003 | http://127.0.0.1:8003/docs | ✅ Auto-start |
| 4 | Chat API (LINE) | 8004 | http://127.0.0.1:8004 | ✅ Auto-start |
| 5 | DB Management | 8005 | http://127.0.0.1:8005/docs | ✅ Auto-start |
| 6 | File Management | - | (Integrated) | ✅ Auto-start |
| 7 | Streaming Web | 8800 | http://127.0.0.1:8800/docs | ✅ Auto-start |

**Plus:**
- MySQL: 3306 ✅
- Redis: 6379 ✅
- Detection + Telegram ✅

**Total:** 8 terminal windows when running!

---

## ✅ VERIFY SERVICES

```cmd
netstat -an | findstr ":8000 :8002 :8003 :8005 :8800" | findstr "LISTENING"
redis-cli.exe ping
```

---

## 🛑 STOP SYSTEM

```cmd
STOP_EVERYTHING.bat
```

Or close all terminal windows.

---

## 📁 IMPORTANT FILES

| File | Purpose |
|------|---------|
| `START_ALL_7_APIS.bat` | Start all services |
| `START_DETECTION.bat` | Start detection only |
| `STOP_EVERYTHING.bat` | Stop all services |
| `ALL_7_APIS_GUIDE.md` | Complete API guide |
| `COMPLETE_STARTUP_GUIDE.md` | Detailed manual |
| `config/test_stream.json` | Test video config |

---

## 🔧 TROUBLESHOOTING

**Services not starting?**
```cmd
REM Check MySQL
netstat -an | findstr ":3306"

REM Check if port in use
netstat -ano | findstr ":8005"
taskkill /F /PID [PID]
```

**Login failed?**
```cmd
python reset_user_password.py
```

**No video in Live Stream?**
1. Check detection running: `python main.py --config config\test_stream.json`
2. Check `store_in_redis: true` in config
3. Verify Streaming API running (port 8800)

**Stream showing old/wrong data?**
```cmd
REM Clear Redis cache
redis-cli.exe FLUSHALL

REM Or use automated script
RESET_AND_RESTART.bat
```
Then restart Streaming API and hard refresh browser (Ctrl+Shift+R)

---

## 🎯 DAILY WORKFLOW

1. **Start:** `START_ALL_7_APIS.bat`
2. **Login:** https://visionnaire-cda17.web.app/login
3. **Detect:** `python main.py --config config\test_stream.json`
4. **Monitor:** Visionnaire → Live Stream
5. **Stop:** `STOP_EVERYTHING.bat`

---

## 📱 ENABLE TELEGRAM NOTIFICATIONS

```cmd
REM Quick setup (5 minutes)
start TELEGRAM_QUICK_START.md

REM Test Telegram bot
python test_telegram.py
```

**Config format:**
```json
"notifications": {
  "telegram:YOUR_CHAT_ID": "en"
}
```

Full guide: `TELEGRAM_BOT_SETUP.md`

---

## 📞 NEED HELP?

Read documentation:
- `ALL_7_APIS_GUIDE.md` - API details
- `COMPLETE_STARTUP_GUIDE.md` - Step-by-step
- `CARA_MENJALANKAN.md` - How to run
- `WEBSOCKET_STREAMING_FIX.md` - Streaming issues
- `FIX_STREAM_ISSUE.md` - Fix old/cached stream data
- `QUICK_FIX.md` - Quick troubleshooting
- `TELEGRAM_BOT_SETUP.md` - Telegram notifications
- `TELEGRAM_QUICK_START.md` - 5-minute Telegram setup

---

**BOOKMARK THIS FILE!** 📌
