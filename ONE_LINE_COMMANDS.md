# ⚡ ONE-LINE COMMANDS - Run From Anywhere!

## 🚀 MAIN COMMANDS

### Start Complete System (from any directory)
```cmd
cd /d D:\Construction-Hazard-Detection && START_COMPLETE_SYSTEM.bat
```

### Start Services Only
```cmd
cd /d D:\Construction-Hazard-Detection && START_SERVICES_ONLY.bat
```

### Start Detection Only
```cmd
cd /d D:\Construction-Hazard-Detection && START_DETECTION_ONLY.bat
```

### Stop Everything
```cmd
cd /d D:\Construction-Hazard-Detection && STOP_EVERYTHING.bat
```

---

## 🧪 TEST COMMANDS

### Test Telegram Bot
```cmd
cd /d D:\Construction-Hazard-Detection && python quick_test_telegram.py
```

### Check Database
```cmd
cd /d D:\Construction-Hazard-Detection && python check_database.py
```

### Verify Services
```cmd
cd /d D:\Construction-Hazard-Detection && netstat -an | findstr ":8005 :8800 :6379" | findstr "LISTENING"
```

---

## 🔧 UTILITY COMMANDS

### Clear Redis Cache
```cmd
cd /d D:\Construction-Hazard-Detection && redis-cli.exe FLUSHALL
```

### Check Redis Keys
```cmd
cd /d D:\Construction-Hazard-Detection && redis-cli.exe KEYS "*"
```

### Ping Redis
```cmd
cd /d D:\Construction-Hazard-Detection && redis-cli.exe ping
```

---

## 📱 MANUAL START (One-Line Each)

### Terminal 1 - Redis
```cmd
cd /d D:\Construction-Hazard-Detection && redis-server.exe redis.windows.conf
```

### Terminal 2 - DB API
```cmd
cd /d D:\Construction-Hazard-Detection && uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005
```

### Terminal 3 - Streaming API
```cmd
cd /d D:\Construction-Hazard-Detection && uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

### Terminal 4 - Detection
```cmd
cd /d D:\Construction-Hazard-Detection && python main.py --config config\test_stream.json
```

---

## 🎯 MOST USED (Copy These!)

**Start everything:**
```cmd
cd /d D:\Construction-Hazard-Detection && START_COMPLETE_SYSTEM.bat
```

**Stop everything:**
```cmd
cd /d D:\Construction-Hazard-Detection && STOP_EVERYTHING.bat
```

**Test Telegram:**
```cmd
cd /d D:\Construction-Hazard-Detection && python quick_test_telegram.py
```

---

## 💡 HOW IT WORKS

`cd /d D:\Construction-Hazard-Detection` = Change to project directory (works from any drive)

- `/d` flag allows changing drives (e.g., from C: to D:)
- `&&` runs the next command only if cd succeeds

---

## 📋 BOOKMARK THESE COMMANDS!

Save this file for quick access to all one-line commands.
