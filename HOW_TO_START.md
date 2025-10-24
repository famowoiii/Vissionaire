# 🚀 HOW TO START - CARA MENJALANKAN SISTEM

## ⚡ SUPER QUICK START (1 KLIK!)

### Option 1: Start Everything (Recommended)
```cmd
START_COMPLETE_SYSTEM.bat
```

**Apa yang terjadi:**
1. ✅ Clear Redis cache (hapus data lama)
2. ✅ Start Redis Server
3. ✅ Start DB Management API (Port 8005)
4. ✅ Start Streaming API (Port 8800)
5. ✅ Start Detection dengan Telegram notifications
6. ✅ Open Visionnaire web interface

**SEMUA OTOMATIS!** Tinggal double-click file .bat!

---

## 🎯 ALTERNATIVE OPTIONS

### Option 2: Start Services Only (Manual Detection)

**Step 1:** Start services
```cmd
START_SERVICES_ONLY.bat
```

**Step 2:** Start detection (manual)
```cmd
START_DETECTION_ONLY.bat
```

Atau:
```cmd
python main.py --config config\test_stream.json
```

---

### Option 3: Manual (Full Control)

Ikuti command di: `STARTUP_SEQUENCE.md`

---

## 📁 AVAILABLE .BAT FILES

| File | Purpose |
|------|---------|
| `START_COMPLETE_SYSTEM.bat` | ⭐ Start everything automatically |
| `START_SERVICES_ONLY.bat` | Start services only (no detection) |
| `START_DETECTION_ONLY.bat` | Start detection only (services must be running) |
| `STOP_EVERYTHING.bat` | Stop all services |
| `START_ALL_7_APIS.bat` | Start all 7 API services (advanced) |
| `RESET_AND_RESTART.bat` | Clear cache and restart |

---

## 🎬 STEP-BY-STEP (RECOMMENDED)

### 1️⃣ Start MySQL (One-time)
- Buka XAMPP Control Panel
- Start MySQL
- ✅ Pastikan MySQL running

### 2️⃣ Run Startup Script
```cmd
START_COMPLETE_SYSTEM.bat
```

### 3️⃣ Wait for Services
- Script akan otomatis start semua services
- Tunggu ~30 detik
- 4 terminal windows akan terbuka

### 4️⃣ Check Telegram
- Buka Telegram app
- Tunggu detection running
- Ketika ada violation, Anda terima notifikasi!

### 5️⃣ Open Visionnaire (Optional)
- URL: https://visionnaire-cda17.web.app/login
- Username: `user`
- Password: `password`
- Live Stream → Test Site → Local Video Demo

---

## ✅ SUCCESS INDICATORS

**Terminal Windows:**
- ✅ Redis Server (Port 6379)
- ✅ DB Management API (Port 8005)
- ✅ Streaming Web API (Port 8800)
- ✅ Detection with Telegram

**Console Output:**
```
[OK] MySQL running on port 3306
[OK] Redis cache cleared
[OK] Redis running on port 6379
[OK] DB Management API (8005)
[OK] Streaming Web API (8800)

Detection started!
Telegram notifications enabled for chat: 5856651174
Processing frame...
```

**On Telegram:**
```
🚨 Safety Violation Detected
(when violation occurs)
```

---

## 🛑 HOW TO STOP

### Option 1: Use Stop Script
```cmd
STOP_EVERYTHING.bat
```

### Option 2: Close Terminals
Tutup semua 4 terminal windows yang terbuka

---

## 🔧 TROUBLESHOOTING

### "MySQL not running"
**Solution:**
1. Open XAMPP
2. Start MySQL
3. Run `START_COMPLETE_SYSTEM.bat` again

### "Port already in use"
**Solution:**
```cmd
STOP_EVERYTHING.bat
```
Wait 5 seconds, then:
```cmd
START_COMPLETE_SYSTEM.bat
```

### "Services not starting"
**Solution:**
Run each service manually (see `STARTUP_SEQUENCE.md`)

### "No Telegram notifications"
**Checklist:**
- ✅ TELEGRAM_BOT_TOKEN in .env?
- ✅ Chat ID in config: `telegram:5856651174`?
- ✅ Detection running?
- ✅ Violations detected? (check console)

Test bot:
```cmd
python quick_test_telegram.py
```

---

## 📊 WHAT TO EXPECT

### When Running Detection:

**Console Output:**
```
Loading configuration from config\test_stream.json
Initializing TelegramNotifier for chat: 5856651174
Starting video processing...
Processing frame 1/X
Processing frame 2/X
⚠️ Violation detected: Worker without safety helmet
📱 Sending Telegram notification...
✅ Notification sent successfully!
Processing frame 3/X
...
```

### On Telegram:

**First Time:**
```
🎉 SUCCESS!

Your Telegram Bot is working!
✅ Bot Token: Configured
✅ Chat ID: 5856651174
✅ Connection: Active
```

**When Violation Detected:**
```
🚨 Safety Violation Detected

Site: Test Site
Camera: Local Video Demo
Time: 2025-01-21 20:45:30

⚠️ Violations:
• Worker without safety helmet
• Worker without safety vest

[Photo attached]

Please take immediate action!
```

---

## 🎯 DAILY WORKFLOW

### Morning (Start System)
```cmd
1. Start XAMPP MySQL (if not auto-start)
2. Double-click: START_COMPLETE_SYSTEM.bat
3. Wait ~30 seconds
4. ✅ System ready!
```

### During Work
- Monitor Telegram for alerts
- Check Visionnaire Live Stream (optional)
- Respond to violations

### Evening (Stop System)
```cmd
STOP_EVERYTHING.bat
```

---

## 💡 PRO TIPS

### Auto-start at Boot (Windows)

1. Press `Win + R`
2. Type: `shell:startup`
3. Copy `START_COMPLETE_SYSTEM.bat` shortcut here
4. System will auto-start when Windows boots!

### Multiple Video Sources

Edit `config/test_stream.json`:
```json
[
  {
    "video_url": "rtsp://camera1/stream",
    "site": "Site 1",
    "stream_name": "Camera 1",
    "notifications": {"telegram:5856651174": "en"}
  },
  {
    "video_url": "rtsp://camera2/stream",
    "site": "Site 2",
    "stream_name": "Camera 2",
    "notifications": {"telegram:5856651174": "en"}
  }
]
```

### Add More Recipients

```json
"notifications": {
  "telegram:5856651174": "en",
  "telegram:1234567890": "zh-tw",
  "telegram:-1001234567890": "en"
}
```

---

## 📞 QUICK REFERENCE

**Start everything:**
```cmd
START_COMPLETE_SYSTEM.bat
```

**Stop everything:**
```cmd
STOP_EVERYTHING.bat
```

**Test Telegram:**
```cmd
python quick_test_telegram.py
```

**Check services:**
```cmd
netstat -an | findstr ":8005 :8800 :6379" | findstr "LISTENING"
redis-cli.exe ping
```

---

## 📚 DOCUMENTATION

- `STARTUP_SEQUENCE.md` - Manual startup guide
- `TELEGRAM_SETUP_COMPLETE.md` - Telegram configuration
- `QUICK_REFERENCE.md` - All commands reference
- `CARA_MENJALANKAN.md` - Bahasa Indonesia guide
- This file: `HOW_TO_START.md`

---

## ✨ YOU'RE READY!

**Recommended method:**

```cmd
START_COMPLETE_SYSTEM.bat
```

**Then check Telegram for notifications!** 🚀

---

**ANY QUESTIONS?**

Read: `QUICK_REFERENCE.md` for complete command reference.

**NEED HELP?**

Check: `STARTUP_SEQUENCE.md` for detailed step-by-step guide.
