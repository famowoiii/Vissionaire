# 🚀 COMPLETE STARTUP SEQUENCE

## 📋 URUTAN COMMAND LENGKAP

Ikuti command ini **satu per satu** di Command Prompt.

---

## 🧹 STEP 0: CLEANUP (HAPUS DATA LAMA)

### Terminal 1: Clean Redis Cache
```cmd
cd D:\Construction-Hazard-Detection
redis-cli.exe FLUSHALL
redis-cli.exe KEYS "*"
```

**Expected output:** `(empty array)` atau tidak ada output

---

## 🚀 STEP 1: START ALL SERVICES

### Terminal 1: Redis Server (Keep Open!)
```cmd
cd D:\Construction-Hazard-Detection
redis-server.exe redis.windows.conf
```

**Expected output:**
```
Ready to accept connections
```

**⚠️ JANGAN TUTUP TERMINAL INI!**

---

### Terminal 2: DB Management API - Port 8005 (Keep Open!)
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005
```

**Expected output:**
```
INFO:     Uvicorn running on http://0.0.0.0:8005
INFO:     Application startup complete
```

**⚠️ JANGAN TUTUP TERMINAL INI!**

---

### Terminal 3: Streaming API - Port 8800 (Keep Open!)
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

**Expected output:**
```
INFO:     Uvicorn running on http://0.0.0.0:8800
INFO:     Application startup complete
```

**⚠️ JANGAN TUTUP TERMINAL INI!**

---

## ✅ STEP 2: VERIFY ALL SERVICES

### Terminal 4: Check Services
```cmd
cd D:\Construction-Hazard-Detection
netstat -an | findstr ":8005 :8800 :3306 :6379" | findstr "LISTENING"
```

**Expected output:**
```
TCP    0.0.0.0:8005    LISTENING  ✅
TCP    0.0.0.0:8800    LISTENING  ✅
TCP    0.0.0.0:3306    LISTENING  ✅
```

**Check Redis:**
```cmd
redis-cli.exe ping
```

**Expected output:** `PONG` ✅

---

## 🎬 STEP 3: RUN DETECTION WITH TELEGRAM

### Terminal 4 (atau 5): Start Detection
```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

**Expected output:**
```
Loading configuration from config\test_stream.json
Initializing TelegramNotifier for chat: 5856651174
Starting detection for Test Site / Local Video Demo
Processing frame 1...
```

**⚠️ KEEP TERMINAL OPEN! Detection akan running terus.**

---

## 📱 STEP 4: CHECK TELEGRAM

- Buka Telegram app
- Tunggu beberapa detik/menit
- **Ketika ada violation detected**, Anda akan terima notifikasi!

---

## 🌐 STEP 5: OPEN VISIONNAIRE (OPTIONAL)

### Browser: Open Web Interface
```
URL: https://visionnaire-cda17.web.app/login

Login:
Username: user
Password: password
```

### Check Live Stream
1. Go to **Live Stream** menu
2. Select **Test Site** → **Local Video Demo**
3. ✅ Video should appear!

---

## 🛑 STEP 6: STOP EVERYTHING (WHEN DONE)

### Method 1: Close Terminals
Tutup semua terminal windows (4-5 windows)

### Method 2: Use Stop Script
```cmd
cd D:\Construction-Hazard-Detection
STOP_EVERYTHING.bat
```

### Method 3: Manual Kill
```cmd
taskkill /F /IM python.exe /T
taskkill /F /IM uvicorn.exe /T
redis-cli.exe shutdown
```

---

## 📊 COMPLETE COMMAND CHECKLIST

Copy-paste commands ini **satu per satu**:

### ✅ Cleanup
```cmd
cd D:\Construction-Hazard-Detection
redis-cli.exe FLUSHALL
```

### ✅ Terminal 1 - Redis
```cmd
cd D:\Construction-Hazard-Detection
redis-server.exe redis.windows.conf
```

### ✅ Terminal 2 - DB API
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005
```

### ✅ Terminal 3 - Streaming API
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

### ✅ Terminal 4 - Verify
```cmd
cd D:\Construction-Hazard-Detection
netstat -an | findstr ":8005 :8800 :6379" | findstr "LISTENING"
redis-cli.exe ping
```

### ✅ Terminal 4/5 - Detection
```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

---

## 🎯 MINIMAL TERMINALS NEEDED

**Minimum 4 terminal windows:**
1. Redis Server ✅
2. DB Management API ✅
3. Streaming API ✅
4. Detection (main.py) ✅

**Total: 4 windows running simultaneously**

---

## 💡 QUICK START (One Command Per Terminal)

### Terminal 1:
```cmd
cd D:\Construction-Hazard-Detection && redis-server.exe redis.windows.conf
```

### Terminal 2:
```cmd
cd D:\Construction-Hazard-Detection && uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005
```

### Terminal 3:
```cmd
cd D:\Construction-Hazard-Detection && uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

### Terminal 4 (after services started):
```cmd
cd D:\Construction-Hazard-Detection && python main.py --config config\test_stream.json
```

---

## 🔧 TROUBLESHOOTING

### Redis cache masih ada data lama?
```cmd
redis-cli.exe FLUSHALL
redis-cli.exe KEYS "*"
```

Should return: `(empty array)`

### Port sudah dipakai?
```cmd
netstat -ano | findstr ":8005"
taskkill /F /PID [PID]
```

### MySQL tidak running?
- Buka XAMPP
- Start MySQL
- Verify: `netstat -an | findstr ":3306"`

---

## 📝 WHAT TO EXPECT

### During Detection:
```
Loading configuration...
✅ Telegram notifications enabled for chat: 5856651174
Starting video processing...
Frame 1: Processing...
Frame 2: Processing...
⚠️ Violation detected: Worker without helmet
📱 Sending notification to Telegram...
✅ Notification sent successfully!
```

### On Telegram:
```
🚨 Safety Violation Detected

Site: Test Site
Camera: Local Video Demo
Time: 2025-01-21 20:30:15

⚠️ Violations:
• Worker without safety helmet

[Photo attached]
```

---

## ✅ SUCCESS INDICATORS

- ✅ Redis: `PONG` response
- ✅ DB API: Port 8005 LISTENING
- ✅ Streaming API: Port 8800 LISTENING
- ✅ Detection: Processing frames
- ✅ Telegram: Notification received

---

**READY TO START!** 🚀

Follow commands above step-by-step.
