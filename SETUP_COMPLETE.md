# ✅ SETUP COMPLETE - Construction Hazard Detection System

## 🎉 STATUS: SIAP DIGUNAKAN!

Semua komponen sistem sudah dikonfigurasi dan siap untuk dijalankan.

---

## 📊 SYSTEM STATUS

### ✅ Prerequisites
- **Redis Server**: Running (Port 6379)
- **MySQL Database**: Running (Port 3306)
- **YOLO Models**: Available (5 models)
  - `best_yolo11n.pt` - Nano (fastest)
  - `best_yolo11s.pt` - Small
  - `best_yolo11m.pt` - Medium
  - `best_yolo11l.pt` - Large
  - `best_yolo11x.pt` - Extra Large (most accurate)

### ✅ API Services (Started)
- **Port 8000**: YOLO Detection API ✅
- **Port 8002**: Violation Record API ✅
- **Port 8003**: FCM/Notification API ✅
- **Port 8005**: DB Management API ✅
- **Port 8800**: Streaming Web API ✅

---

## 🚀 CARA MENGGUNAKAN SISTEM

### Method 1: Menggunakan Visionnaire Web (RECOMMENDED)

#### Step 1: Akses Visionnaire
```
https://visionnaire-cda17.web.app/login
```

#### Step 2: Configure API Endpoints

Tekan **F12** untuk membuka Developer Console, lalu paste:

```javascript
// Configure all API endpoints
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');

console.log('✅ All API endpoints configured!');
location.reload();
```

#### Step 3: Login
- **Username**: `user`
- **Password**: `password`

#### Step 4: Tambah Stream untuk Detection

1. Klik **"Sites"** → **"Add Site"**
2. Masukkan nama site (contoh: "Construction Site A")
3. Klik **"Streams"** → **"Add Stream"**
4. Configure stream:
   - **Stream Name**: Camera 1
   - **Video URL**:
     - RTSP: `rtsp://your-ip:554/stream`
     - YouTube: `https://www.youtube.com/watch?v=VIDEO_ID`
     - Local: `D:/videos/construction.mp4`
   - **Model**: `yolo11n` (recommended untuk start)
   - **Detection Items**: Pilih yang diinginkan
     - ☑ Detect no safety vest or helmet
     - ☑ Detect near machinery or vehicle
     - ☐ Detect in restricted area
     - ☐ Detect in utility pole restricted area
     - ☐ Detect machinery close to pole
   - **Work Hours**: 7:00 - 18:00 (default)
   - **Store in Redis**: ☑ (untuk live streaming)

5. **Save**

#### Step 5: Start Detection

Detection akan otomatis dimulai jika main.py sudah running.

Untuk start manual:
```cmd
python main.py
```

Atau untuk test dengan config file:
```cmd
python main.py --config config/test_stream.json
```

#### Step 6: Monitor via Visionnaire

- **Dashboard**: Overview violations dan statistik
- **Live Stream**: Real-time detection feed
- **Violations**: History dan detail pelanggaran
- **Sites/Streams**: Manage konfigurasi

---

### Method 2: Run Manual Detection (Testing)

#### Test dengan Video File

```cmd
python main.py --config config/test_stream.json
```

Example config file (`config/test_stream.json`):
```json
[
  {
    "video_url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
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

---

## 🔧 API ENDPOINTS TERSEDIA

| Service | Port | URL | Documentation |
|---------|------|-----|---------------|
| **YOLO Detection** | 8000 | http://127.0.0.1:8000 | http://127.0.0.1:8000/docs |
| **Violation Records** | 8002 | http://127.0.0.1:8002 | http://127.0.0.1:8002/docs |
| **FCM Notifications** | 8003 | http://127.0.0.1:8003 | http://127.0.0.1:8003/docs |
| **DB Management** | 8005 | http://127.0.0.1:8005 | http://127.0.0.1:8005/docs |
| **Streaming API** | 8800 | http://127.0.0.1:8800 | http://127.0.0.1:8800/docs |

### Test Endpoints

Buka di browser:
```
http://127.0.0.1:8000/docs  - YOLO API Swagger
http://127.0.0.1:8005/docs  - DB Management Swagger
http://127.0.0.1:8800/docs  - Streaming API Swagger
```

Atau gunakan curl:
```bash
# Test YOLO API
curl http://127.0.0.1:8000/health

# Test DB Management
curl http://127.0.0.1:8005/health

# Test Redis
redis-cli.exe ping
```

---

## 🎯 MODEL SELECTION

Pilih model sesuai hardware dan kebutuhan:

| Model | Speed | Accuracy | Use Case |
|-------|-------|----------|----------|
| **yolo11n** | ⚡⚡⚡⚡⚡ | ⭐⭐⭐ | CPU, real-time, testing |
| **yolo11s** | ⚡⚡⚡⚡ | ⭐⭐⭐⭐ | Balanced |
| **yolo11m** | ⚡⚡⚡ | ⭐⭐⭐⭐ | Good balance |
| **yolo11l** | ⚡⚡ | ⭐⭐⭐⭐⭐ | GPU recommended |
| **yolo11x** | ⚡ | ⭐⭐⭐⭐⭐ | Best accuracy, GPU only |

**Recommendation:**
- **CPU only**: Use `yolo11n`
- **GPU available**: Use `yolo11x` or `yolo11l`
- **For competition**: Use `yolo11x` with GPU

---

## 💡 TIPS & BEST PRACTICES

### 1. Performance Optimization

**Untuk CPU:**
```env
# Di .env atau via Visionnaire
model_key=yolo11n
capture_interval=30
```

**Untuk GPU:**
```env
model_key=yolo11x
capture_interval=5
USE_GPU=True
```

### 2. Multiple Streams

Tambahkan multiple stream configs via Visionnaire:
- Setiap stream akan run di separate process
- Monitor CPU/GPU usage dengan Task Manager
- Recommended max: 4-6 streams untuk CPU, 10+ untuk GPU

### 3. Work Hours Configuration

Detection hanya akan record violations dalam work hours:
```
work_start_hour: 7   (7:00 AM)
work_end_hour: 18    (6:00 PM)
```

Di luar jam ini, detection tetap jalan tapi tidak record violations.

### 4. Redis untuk Live Streaming

Enable `store_in_redis: true` untuk:
- Real-time streaming di Visionnaire web
- WebSocket updates
- Frame caching

Disable jika hanya butuh violation recording (save memory).

---

## 🔧 TROUBLESHOOTING

### "Service not starting"

**Check:**
```cmd
# Check if port already in use
netstat -an | findstr ":8000"

# Kill process if needed
taskkill /F /PID [PID]
```

### "Cannot connect to database"

**Check:**
```cmd
# Verify MySQL running
netstat -an | findstr ":3306"

# Test connection
mysql -u root -e "SHOW DATABASES;"

# Create database if missing
mysql -u root -e "CREATE DATABASE construction_hazard_detection;"
```

### "Model not found"

**Check:**
```cmd
# List models
dir models\pt\*.pt

# Download if missing
huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 --repo-type model --include "models/pt/*.pt" --local-dir .
```

### "CORS Error in Visionnaire"

**Solution 1:** Use Visionnaire Firebase (already configured)
```
https://visionnaire-cda17.web.app
```

**Solution 2:** If using local frontend, add CORS headers in backend APIs

### "Detection not showing"

**Check:**
1. Main detection running? (`python main.py`)
2. Stream config in database? (check via Visionnaire)
3. Within work hours? (default 7-18)
4. Redis has data? (`redis-cli KEYS stream_frame:*`)

---

## 📂 FILE STRUCTURE

```
D:\Construction-Hazard-Detection\
├── main.py                      # Main detection program
├── .env                         # Configuration file
├── START_ALL_SERVICES.bat       # Start all API services
├── QUICK_START.bat             # Setup script
├── VISIONNAIRE_SETUP.md        # Detailed setup guide
├── SETUP_COMPLETE.md           # This file
│
├── models/
│   └── pt/                     # YOLO models (✅ installed)
│       ├── best_yolo11n.pt
│       ├── best_yolo11s.pt
│       ├── best_yolo11m.pt
│       ├── best_yolo11l.pt
│       └── best_yolo11x.pt
│
├── examples/
│   ├── YOLO_server_api/        # Port 8000
│   ├── violation_records/       # Port 8002
│   ├── local_notification_server/ # Port 8003
│   ├── db_management/          # Port 8005
│   └── streaming_web/          # Port 8800
│
├── src/                        # Source code
└── config/                     # Config files
```

---

## 🌐 VISIONNAIRE WEB INTERFACE

### Production URL (Firebase)
```
https://visionnaire-cda17.web.app
```

**Features:**
- ✅ Real-time detection monitoring
- ✅ Site and stream management
- ✅ Violation records and history
- ✅ Dashboard with statistics
- ✅ Multi-user support
- ✅ Mobile responsive

### Local Frontend (Alternative)

Build dan run local:
```cmd
cd examples\streaming_web\frontend
npm install
npm run build
cd dist
python -m http.server 3000
```

Access: `http://localhost:3000`

---

## 🚀 NEXT STEPS

### 1. For Competition/Demo

**Option A: Use Local (Current Setup)**
- ✅ Already configured
- Run `START_ALL_SERVICES.bat`
- Access Visionnaire web
- Start detection

**Option B: Use Google Colab GPU (FREE, FASTER)**
- See `COLAB_WITH_VISIONNAIRE.md`
- Get FREE T4 GPU (30 FPS!)
- Use ngrok tunnel
- Same Visionnaire interface

**Option C: Use Cloud GPU (Vast.ai)**
- See `VASTAI_SETUP_GUIDE.md`
- Rent GPU by hour (~$0.20/hr)
- Better performance
- Public IP access

### 2. For Production

- Setup proper database backup
- Configure Firebase for notifications
- Setup SSL/HTTPS
- Add authentication
- Monitor with logging/alerting

### 3. Optimization

See `OPTIMIZE_FOR_COMPETITION.md` for:
- Model optimization
- Batch processing
- Multi-GPU setup
- Performance tuning

---

## 📞 SUPPORT & RESOURCES

### Documentation
- `VISIONNAIRE_SETUP.md` - Web interface setup
- `COLAB_WITH_VISIONNAIRE.md` - Google Colab setup
- `VASTAI_SETUP_GUIDE.md` - Cloud GPU setup
- `OPTIMIZE_FOR_COMPETITION.md` - Performance tips

### API Documentation
- http://127.0.0.1:8000/docs - YOLO API
- http://127.0.0.1:8005/docs - DB Management
- http://127.0.0.1:8800/docs - Streaming API

### Logs
Check CMD windows for each service untuk troubleshooting

---

## ✅ CHECKLIST - READY TO USE

- [x] Redis Server running
- [x] MySQL Database running
- [x] YOLO Models downloaded
- [x] All API services started (6 services)
- [x] Scripts created (START_ALL_SERVICES.bat)
- [x] Documentation complete
- [ ] Visionnaire configured (next step - follow instructions above)
- [ ] Test detection (after Visionnaire setup)

---

## 🎓 QUICK REFERENCE

### Start Services
```cmd
START_ALL_SERVICES.bat
```

### Start Detection
```cmd
python main.py
```

### Access Visionnaire
```
https://visionnaire-cda17.web.app/login
Username: user
Password: password
```

### Configure Visionnaire (F12 Console)
```javascript
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
location.reload();
```

### Test APIs
```bash
curl http://127.0.0.1:8000/docs
curl http://127.0.0.1:8005/docs
redis-cli.exe ping
```

---

**SISTEM SIAP DIGUNAKAN! 🚀**

Ikuti langkah-langkah di atas untuk mulai menggunakan Construction Hazard Detection System dengan Visionnaire Web Interface.

**Good luck!** 🎉
