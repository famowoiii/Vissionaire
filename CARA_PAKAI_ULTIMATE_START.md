# 🚀 CARA PAKAI ULTIMATE START

## ✨ ULTIMATE START - Solusi 1-Klik untuk Semua Masalah!

File `ULTIMATE_START.bat` adalah solusi FINAL yang menangani SEMUA masalah:
- ✅ Auto-sync ALL streams dari database
- ✅ Auto-configure ALL API endpoints di Visionnaire
- ✅ Start ALL 7 API services
- ✅ Clear Redis cache otomatis
- ✅ Start detection untuk ALL streams
- ✅ Telegram notifications aktif
- ✅ NO manual configuration needed!

---

## 🎯 CARA MENGGUNAKAN:

### **Metode 1: Double-click (Recommended)**

1. Buka folder `D:\Construction-Hazard-Detection`
2. **Double-click** file `ULTIMATE_START.bat`
3. Tunggu semua services start (sekitar 30 detik)
4. Otomatis akan terbuka **HTML auto-config page**
5. **Klik tombol "Configure & Open Visionnaire"**
6. Login: `user` / `password`
7. Go to **Live Stream**
8. **DONE!** Semua stream dari database otomatis muncul!

---

### **Metode 2: Command Line (Alternative)**

Dari direktori mana saja:

```cmd
D:\Construction-Hazard-Detection\ULTIMATE_START.bat
```

---

## 📋 APA YANG TERJADI SAAT ANDA RUN?

### **Step 1-3: Infrastructure**
1. ✅ Check MySQL running (port 3306)
2. ✅ Clear Redis cache (`FLUSHALL`)
3. ✅ Start Redis Server (port 6379)

### **Step 4-10: ALL 7 API Services**
4. ✅ YOLO Detection API (port 8000)
5. ✅ Violation Records API (port 8002)
6. ✅ FCM Notification API (port 8003)
7. ✅ Chat API / LINE Bot (port 8004)
8. ✅ DB Management API (port 8005)
9. ✅ Streaming Web API (port 8800)
10. ⏳ Wait 15 seconds untuk semua services initialize

### **Step 11: AUTO-SYNC Database → Config**
11. 🔄 **Auto-generate config dari database**
   - Script `generate_all_streams_config.py` akan:
     - Query ALL sites dari database
     - Query ALL stream_configs dari database
     - Generate `config/auto_all_streams.json`
     - **Setiap site + stream di database = 1 stream di config**

### **Step 12: Verification**
12. ✅ Verify all 7 APIs running

### **Step 13: Auto-Config HTML Page**
13. 🌐 **Create HTML auto-config page**
   - File: `visionnaire_config.html`
   - Fungsi: Auto-fill ALL 7 API endpoints ke Visionnaire localStorage
   - No manual input needed!

### **Final: Detection Start**
- 🚀 Start detection untuk **ALL streams** dari database
- 📱 Telegram notifications enabled untuk semua
- 🌐 Open auto-config page

---

## 🎬 WORKFLOW LENGKAP:

```
[START]
  ↓
[Check MySQL]
  ↓
[Clear Redis Cache] ← Hapus old data (puki, dll)
  ↓
[Start Redis]
  ↓
[Start 7 APIs] ← Ports: 8000, 8002, 8003, 8004, 8005, 8800
  ↓
[Wait 15s]
  ↓
[Auto-generate Config] ← generate_all_streams_config.py
  ↓                        Query database → JSON config
[Verify Services]
  ↓
[Create Auto-Config HTML] ← visionnaire_config.html
  ↓                          localStorage setter
[Start Detection] ← ALL streams from auto_all_streams.json
  ↓
[Open Auto-Config Page] ← Browser opens
  ↓
[You Click Button] ← "Configure & Open Visionnaire"
  ↓
[Visionnaire Opens] ← All endpoints configured!
  ↓
[Login: user/password]
  ↓
[Go to Live Stream]
  ↓
[ALL STREAMS VISIBLE!] ← Database fully synced!
```

---

## 🔧 FILE YANG DI-GENERATE:

### 1. **config/auto_all_streams.json**
Auto-generated dari database, contoh isi:

```json
[
  {
    "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Test Site",
    "stream_name": "1",
    "model_key": "yolo11n",
    "notifications": {
      "telegram:5856651174": "en"
    },
    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": true,
      "detect_in_restricted_area": true
    },
    "work_start_hour": 0,
    "work_end_hour": 24,
    "store_in_redis": true
  },
  {
    "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Coba_Guys",
    "stream_name": "Proyek",
    ...
  }
]
```

**Setiap site di database = 1 entry di config!**

### 2. **visionnaire_config.html**
HTML page dengan JavaScript untuk auto-configure:

```javascript
localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004');
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('FILE_MANAGEMENT_API_URL', 'http://127.0.0.1:8005');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
// Then open Visionnaire
window.open('https://visionnaire-cda17.web.app/login', '_blank');
```

---

## 🎯 HASIL AKHIR:

Setelah Anda run `ULTIMATE_START.bat`:

1. ✅ **8 Terminal Windows** akan terbuka:
   - Redis Server (6379)
   - YOLO API (8000)
   - Violation API (8002)
   - FCM API (8003)
   - Chat API (8004)
   - DB API (8005)
   - Streaming API (8800)
   - Detection (ALL streams dengan Telegram)

2. ✅ **Browser** otomatis buka `visionnaire_config.html`

3. ✅ **Klik "Configure & Open Visionnaire"**

4. ✅ **Visionnaire** otomatis configured:
   - Semua 7 API endpoints terisi
   - Login dengan user/password
   - Live Stream shows ALL sites dari database!

---

## 🔄 SYNCHRONIZATION: Database ↔ Live Stream

### **AUTOMATIC SYNC!**

Jika Anda:
1. **Add new site** di Visionnaire Site Management
2. **Add new stream** via web interface
3. **Stop detection** dan **re-run ULTIMATE_START.bat**

Maka:
- ✅ Script `generate_all_streams_config.py` akan query database lagi
- ✅ Generate config baru dengan ALL sites (termasuk yang baru)
- ✅ Detection start untuk ALL streams (old + new)
- ✅ Live Stream otomatis shows semua!

**No manual editing needed!**

---

## 📱 TELEGRAM NOTIFICATIONS:

Semua stream otomatis configured dengan:

```json
"notifications": {
  "telegram:5856651174": "en"
}
```

Bot Token: `8011504648:AAHyQuyC_EGdriKRHOR5ZdSXg3_WxursYew`

Notifikasi akan dikirim saat:
- ⚠️ Worker tanpa helmet/safety vest detected
- ⚠️ Person near machinery/vehicle detected
- ⚠️ Person in restricted area detected

---

## ❓ TROUBLESHOOTING:

### **Problem: MySQL not running**
```
[ERROR] MySQL not running!
Please start XAMPP MySQL first.
```

**Solution:**
1. Buka XAMPP Control Panel
2. Start MySQL
3. Re-run `ULTIMATE_START.bat`

---

### **Problem: Redis not responding**
```
[INFO] Redis not running yet
```

**Solution:**
- Script otomatis start Redis
- Wait 3 seconds
- Kalau masih error, coba:
  ```cmd
  taskkill /F /IM redis-server.exe
  ```
  Lalu re-run `ULTIMATE_START.bat`

---

### **Problem: Port already in use**
```
[FAIL] YOLO API (8000)
```

**Solution:**
1. Check port:
   ```cmd
   netstat -an | findstr ":8000"
   ```

2. Kill process:
   ```cmd
   netstat -ano | findstr ":8000"
   taskkill /F /PID <PID>
   ```

3. Re-run `ULTIMATE_START.bat`

---

### **Problem: No streams generated**
```
No streams found in database!
```

**Solution:**
1. Login ke Visionnaire
2. Go to **Site Management**
3. **Add sites** dan **streams**
4. Re-run `ULTIMATE_START.bat`

---

### **Problem: Live Stream empty**
**Penyebab:** Detection belum running atau Redis cache kosong

**Solution:**
1. Check terminal "Detection - ALL Streams"
2. Verify ada output: `Processing frame...`
3. Wait 10-15 seconds
4. Refresh Visionnaire Live Stream page

---

## 🛑 CARA STOP SEMUA:

### **Option 1: Use STOP_EVERYTHING.bat**
```cmd
D:\Construction-Hazard-Detection\STOP_EVERYTHING.bat
```

### **Option 2: Manual**
Close all 8 terminal windows yang dibuka oleh script.

---

## 📊 MONITORING:

### **Check All Services Status:**

Di terminal ULTIMATE_START.bat, Anda akan lihat:

```
[OK] MySQL running
[OK] Cache cleared
[OK] Redis started
[OK] YOLO API started
[OK] Violation API started
[OK] FCM API started
[OK] Chat API started
[OK] DB API started
[OK] Streaming API started
[OK] Auto config generated!
```

### **Verification:**
```
[OK] YOLO API (8000)
[OK] Violation API (8002)
[OK] FCM API (8003)
[WARN] Chat API (8004)  ← LINE Bot, ok if not needed
[OK] DB API (8005)
[OK] Streaming API (8800)
```

---

## 🎯 NEXT STEPS AFTER STARTUP:

1. ✅ **Auto-config page** terbuka otomatis
2. ✅ **Klik** "Configure & Open Visionnaire"
3. ✅ **Login**: `user` / `password`
4. ✅ **Go to** "Live Stream"
5. ✅ **Verify** all your sites/streams visible!

---

## 🔐 LOGIN CREDENTIALS:

**Visionnaire:**
- Username: `user`
- Password: `password`

**Database (MySQL):**
- Host: `127.0.0.1:3306`
- User: `root`
- Password: (kosong)
- Database: `construction_hazard_detection`

---

## 🌐 API ENDPOINTS (Auto-configured):

Semua endpoint ini **otomatis** terisi di Visionnaire:

| Service | URL | Port |
|---------|-----|------|
| YOLO Detection | http://127.0.0.1:8000 | 8000 |
| Violation Records | http://127.0.0.1:8002 | 8002 |
| FCM Notifications | http://127.0.0.1:8003 | 8003 |
| Chat API (LINE) | http://127.0.0.1:8004 | 8004 |
| DB Management | http://127.0.0.1:8005 | 8005 |
| File Management | http://127.0.0.1:8005 | 8005 |
| Streaming Web | http://127.0.0.1:8800 | 8800 |

**Telegram Bot:** Direct API (no port needed)

---

## 📝 SUMMARY:

**SEBELUM `ULTIMATE_START.bat`:**
- ❌ Harus start 7 APIs manual satu-satu
- ❌ Harus edit config JSON manual
- ❌ Harus input API endpoints manual di Visionnaire
- ❌ Stream tidak sync dengan database
- ❌ 15+ manual steps

**SESUDAH `ULTIMATE_START.bat`:**
- ✅ **1 double-click** → Semua start otomatis!
- ✅ Config auto-generated dari database
- ✅ API endpoints auto-configured
- ✅ Database ↔ Live Stream **AUTO-SYNC**
- ✅ **2 steps total:** Double-click → Login!

---

## 🚀 KESIMPULAN:

**`ULTIMATE_START.bat` = FULL AUTOMATION!**

Setiap kali Anda ingin start sistem:
1. Double-click `ULTIMATE_START.bat`
2. Wait 30 seconds
3. Click "Configure & Open Visionnaire"
4. Login
5. **DONE!**

**No manual configuration!**
**No manual sync!**
**Everything automatic!**

---

🎉 **SELAMAT! Sistem Anda sudah FULL AUTOMATIC!** 🎉
