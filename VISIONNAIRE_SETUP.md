# 🌐 SETUP VISIONNAIRE WEB INTERFACE - LOCAL

## 📋 PANDUAN CEPAT

Panduan untuk menghidupkan aplikasi **Construction Hazard Detection** dengan **Visionnaire Web Interface** secara lokal.

---

## 🚀 LANGKAH 1: Start Semua Services

### Jalankan Script Startup

1. **Double-click** file: `START_ALL_SERVICES.bat`

   Atau jalankan di command prompt:
   ```cmd
   START_ALL_SERVICES.bat
   ```

2. **Tunggu** sampai semua services berjalan (~20 detik)

3. **Verify** semua services aktif di Task Manager:
   - 6 command prompt windows harus terbuka
   - Redis Server
   - YOLO Detection API
   - Violation Record API
   - FCM API
   - DB Management API
   - Streaming Web API

---

## 🌐 LANGKAH 2: Configure Visionnaire Web

### Option A: Menggunakan Visionnaire Firebase (RECOMMENDED)

1. **Buka Visionnaire Web:**
   ```
   https://visionnaire-cda17.web.app/login
   ```

2. **Buka Browser Console** (tekan **F12**)

3. **Paste kode berikut** di Console tab:

   ```javascript
   // Configure API URLs untuk Local Services
   localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
   localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
   localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
   localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
   localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');

   console.log('✅ API URLs configured successfully!');

   // Reload page untuk apply settings
   location.reload();
   ```

4. **Tekan Enter** untuk execute

5. **Page akan reload** otomatis

6. **Login** dengan credentials:
   - **Username:** `user`
   - **Password:** `password`

7. **Selesai!** Anda sekarang dapat menggunakan Visionnaire dengan backend lokal Anda.

---

### Option B: Menggunakan Local Frontend (Alternative)

Jika Option A tidak work (CORS issues), gunakan local frontend:

#### 1. Build Frontend (First Time Only)

```cmd
cd examples\streaming_web\frontend
npm install
npm run build
```

#### 2. Serve Frontend

```cmd
cd examples\streaming_web\frontend\dist
python -m http.server 3000
```

#### 3. Akses Local Frontend

Buka browser:
```
http://localhost:3000
```

#### 4. Configure di Browser Console (F12)

```javascript
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
location.reload();
```

#### 5. Login

Username: `user`
Password: `password`

---

## 📊 LANGKAH 3: Menggunakan Sistem

### A. Tambah Stream untuk Detection

1. **Login** ke Visionnaire
2. **Klik** "Add Site" atau "Manage Sites"
3. **Tambahkan site** baru:
   - Site Name: `Test Site`
   - Description: `Testing detection`

4. **Tambah Stream Config:**
   - Stream Name: `Camera 1`
   - Video URL:
     - URL RTSP: `rtsp://your-camera-url`
     - YouTube: `https://youtube.com/watch?v=xxxxx`
     - Local file: `D:/videos/test.mp4`
   - Model: `yolo11n` (tercepat) atau `yolo11x` (terakurat)
   - Detection items: pilih yang diinginkan
   - Work hours: 7-18 (default)

5. **Save**

### B. Start Detection

**Metode 1: Automatic (Database Polling)**

Detection akan otomatis mulai jika service `main.py` sudah running (dari START_ALL_SERVICES.bat)

**Metode 2: Manual Test**

Untuk testing manual dengan config file:

1. Buat file config JSON:
   ```json
   [
     {
       "video_url": "https://www.youtube.com/watch?v=VIDEO_ID",
       "model_key": "yolo11n",
       "site": "Test Site",
       "stream_name": "Camera 1",
       "detect_with_server": false,
       "detection_items": {
         "detect_no_safety_vest_or_helmet": true,
         "detect_near_machinery_or_vehicle": true,
         "detect_in_restricted_area": false,
         "detect_in_utility_pole_restricted_area": false,
         "detect_machinery_close_to_pole": false
       },
       "work_start_hour": 7,
       "work_end_hour": 18,
       "store_in_redis": true
     }
   ]
   ```

2. Simpan sebagai `config/test_stream.json`

3. Run dengan config:
   ```cmd
   python main.py --config config/test_stream.json
   ```

### C. Monitor via Visionnaire

1. **Dashboard** - Lihat overview violations
2. **Live Stream** - Lihat real-time detection
3. **Violations** - History of detected violations
4. **Sites** - Manage sites dan streams

---

## 🔧 ENDPOINT API YANG TERSEDIA

| Service | Port | URL | Deskripsi |
|---------|------|-----|-----------|
| **YOLO Detection API** | 8000 | http://127.0.0.1:8000 | YOLO model inference |
| **Violation Record API** | 8002 | http://127.0.0.1:8002 | Record violations to DB |
| **FCM API** | 8003 | http://127.0.0.1:8003 | Push notifications |
| **DB Management API** | 8005 | http://127.0.0.1:8005 | User & site management |
| **Streaming API** | 8800 | http://127.0.0.1:8800 | WebSocket streaming |
| **Redis** | 6379 | 127.0.0.1:6379 | Frame caching |

### Test Endpoints

Buka di browser atau gunakan curl:

```bash
# Test YOLO Detection API
curl http://127.0.0.1:8000/docs

# Test DB Management API
curl http://127.0.0.1:8005/docs

# Test Streaming API
curl http://127.0.0.1:8800/docs

# Test Redis
redis-cli.exe ping
# Should return: PONG
```

---

## 🎯 KONFIGURASI UNTUK INFERENCE

### Model Selection

Edit di `.env` atau via Visionnaire:

```env
# Model options (from fastest to most accurate):
# yolo11n - Nano (fastest, ~5ms per frame)
# yolo11s - Small (~10ms per frame)
# yolo11m - Medium (~20ms per frame)
# yolo11l - Large (~40ms per frame)
# yolo11x - Extra Large (most accurate, ~60ms per frame)
```

### Detection dengan Server API (Remote Inference)

Jika ingin menggunakan remote GPU server:

1. Edit di database `stream_configs` table:
   ```sql
   UPDATE stream_configs
   SET detect_with_server = 1
   WHERE stream_name = 'Camera 1';
   ```

2. Atau set via Visionnaire web interface

3. Server akan menggunakan WebSocket ke YOLO Detection API

### Detection Local (No Server)

Default: menggunakan local model (`.pt` files di folder `models/pt/`)

---

## 💡 TIPS & BEST PRACTICES

### 1. Performance Optimization

**CPU Only (no GPU):**
- Gunakan model `yolo11n` (tercepat)
- Set `capture_interval` tinggi (30+ frames)
- Resize frame sebelum inference

**GPU Available:**
- Gunakan model `yolo11x` (akurat)
- Set `capture_interval` rendah (5-10 frames)
- Full resolution inference

### 2. Multiple Streams

Untuk multiple streams, add multiple configs ke database via Visionnaire:
- Max streams depends on CPU/GPU capacity
- Monitor with `nvidia-smi` (GPU) or Task Manager (CPU)

### 3. Database Setup

**MySQL (Production):**
```env
DATABASE_URL='mysql+asyncmy://root@127.0.0.1:3306/construction_hazard_detection'
```

Pastikan database sudah dibuat:
```sql
CREATE DATABASE construction_hazard_detection;
```

### 4. Redis Configuration

Redis diperlukan untuk streaming via WebSocket.

Check Redis status:
```cmd
redis-cli.exe ping
```

Start Redis jika belum running:
```cmd
redis-server.exe redis.windows.conf
```

---

## 🔧 TROUBLESHOOTING

### "Cannot connect to API"

**Check:**
1. Semua services running? (check Task Manager)
2. URLs di localStorage benar?
   ```javascript
   console.log(localStorage.getItem('MANAGEMENT_API'));
   ```
3. Firewall blocking?

**Fix:**
- Restart services: close all CMD windows, run `START_ALL_SERVICES.bat` lagi
- Clear localStorage dan set ulang
- Disable firewall temporarily untuk testing

### "CORS Error"

**Problem:** Browser blocking cross-origin requests

**Solutions:**

**Option 1:** Gunakan Visionnaire Firebase (sudah configured)
```
https://visionnaire-cda17.web.app
```

**Option 2:** Add CORS headers di API backend

Edit `examples/*/main.py`:
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify actual origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Option 3:** Use Chrome with disabled web security (TESTING ONLY)
```cmd
chrome.exe --disable-web-security --user-data-dir="C:/chrome-dev"
```

### "Detection not showing in Visionnaire"

**Check:**
1. Main detection running? (should see `main.py` window)
2. Stream config in database?
   ```sql
   SELECT * FROM stream_configs;
   ```
3. Redis has data?
   ```cmd
   redis-cli.exe
   KEYS stream_frame:*
   ```

**Fix:**
- Check detection logs in CMD window
- Verify video URL accessible
- Check work hours (default 7-18, must be within hours)

### "Model not found"

**Error:** `FileNotFoundError: models/pt/best_yolo11n.pt`

**Fix:** Download models:
```cmd
# Using huggingface-cli
huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 ^
    --repo-type model ^
    --include "models/pt/*.pt" ^
    --local-dir .
```

Or download manually from:
```
https://huggingface.co/yihong1120/Construction-Hazard-Detection-YOLO11/tree/main/models/pt
```

### "Database connection failed"

**Check:**
1. MySQL/XAMPP running?
2. Database exists?
3. `.env` credentials correct?

**Fix:**
```cmd
# Start XAMPP MySQL
# Create database
mysql -u root -e "CREATE DATABASE IF NOT EXISTS construction_hazard_detection;"

# Test connection
mysql -u root construction_hazard_detection -e "SHOW TABLES;"
```

---

## 📊 ARCHITECTURE DIAGRAM

```
┌─────────────────────────────────────────────────────────────┐
│                    YOUR COMPUTER                            │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ YOLO API     │  │ Violation API│  │ DB Mgmt API  │    │
│  │ Port 8000    │  │ Port 8002    │  │ Port 8005    │    │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘    │
│         │                  │                  │             │
│  ┌──────▼──────────────────▼──────────────────▼───────┐   │
│  │            Redis Cache (Port 6379)                  │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                   │
│  ┌──────────────────────▼──────────────────────────────┐   │
│  │         MySQL Database (Port 3306)                   │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          │ HTTP/WebSocket
                          │
┌─────────────────────────▼───────────────────────────────┐
│              VISIONNAIRE WEB INTERFACE                  │
│      https://visionnaire-cda17.web.app                  │
│                    (Firebase)                           │
│                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │
│  │ Dashboard   │  │ Live Stream │  │ Violations  │    │
│  └─────────────┘  └─────────────┘  └─────────────┘    │
└──────────────────────────────────────────────────────────┘
```

---

## 📝 QUICK START CHECKLIST

- [ ] MySQL/XAMPP running (port 3306)
- [ ] Database `construction_hazard_detection` created
- [ ] Models downloaded to `models/pt/`
- [ ] `.env` file configured
- [ ] Run `START_ALL_SERVICES.bat`
- [ ] All 6 services running (check Task Manager)
- [ ] Redis responding to PING
- [ ] Open Visionnaire: https://visionnaire-cda17.web.app
- [ ] Configure localStorage with API URLs (F12 console)
- [ ] Login (user/password)
- [ ] Add site and stream config
- [ ] Monitor detection!

---

## 🎓 NEXT STEPS

1. **Production Deployment:** See `VASTAI_SETUP_GUIDE.md` untuk GPU cloud
2. **Google Colab:** See `COLAB_WITH_VISIONNAIRE.md` untuk FREE GPU
3. **Optimization:** See `OPTIMIZE_FOR_COMPETITION.md`

---

**GOOD LUCK! 🚀**

Jika ada masalah, check CMD windows untuk error messages atau lihat troubleshooting section di atas.
