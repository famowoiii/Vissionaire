# 🎥 VIDEO TEST GUIDE - Construction Hazard Detection

## ✅ CONGRATULATIONS! Login Sudah Berhasil!

Sekarang mari kita test detection dengan video.

---

## 📹 VIDEO SOURCES UNTUK TESTING

### **OPTION 1: Local Video (SUDAH ADA!)** ⚡

**Path:**
```
D:\Construction-Hazard-Detection\tests\videos\test.mp4
```

**Size:** 1.3 MB

**Config sudah siap:**
```
D:\Construction-Hazard-Detection\config\test_stream.json
```

---

### **OPTION 2: YouTube Videos (FREE)** 🌐

#### Construction Safety Videos:

**1. Construction Site Safety Video:**
```
https://www.youtube.com/watch?v=9kHbqXCL8Sc
```

**2. Construction Worker Safety:**
```
https://www.youtube.com/watch?v=8QlqwXUxUws
```

**3. Heavy Machinery at Construction Site:**
```
https://www.youtube.com/watch?v=QQF6x24RVNU
```

**4. Construction Site Live Feed (Long):**
```
https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

**5. PPE Safety Demo:**
```
https://www.youtube.com/watch?v=L_LUpnjgPso
```

---

### **OPTION 3: EarthCam Construction Live Feeds** 📡

**Times Square Construction:**
```
https://www.earthcam.com/usa/newyork/timessquare/?cam=tsrobo1
```

**Hudson Yards Construction:**
```
https://www.earthcam.com/usa/newyork/hudsonyards/?cam=hudsonyards1
```

**Generic Construction Cams:**
```
https://www.earthcam.com/cams/category/construction
```

---

### **OPTION 4: RTSP Test Streams** 🎬

**Public RTSP Test Stream:**
```
rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4
```

**Note:** Untuk production, gunakan RTSP dari camera CCTV Anda sendiri.

---

## 🚀 CARA TEST - PILIH SALAH SATU

### **METHOD 1: Test dengan Config File (TERCEPAT)** ⚡

Config sudah siap pakai!

#### Step 1: Jalankan Detection

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

#### Step 2: Monitor di Visionnaire

1. Login ke: https://visionnaire-cda17.web.app/login
2. Klik **"Live Stream"** di menu
3. Pilih **"Test Site"** → **"Local Video Demo"**
4. Lihat detection real-time!

**Video Path:**
```
D:\Construction-Hazard-Detection\tests\videos\test.mp4
```

---

### **METHOD 2: Test via Visionnaire Web** 🌐

Setup stream via web interface.

#### Step 1: Login

```
https://visionnaire-cda17.web.app/login
Username: user
Password: password
```

#### Step 2: Tambah Site

1. Klik **"Sites"** di menu
2. Klik **"Add Site"**
3. Masukkan:
   - **Name:** Test Construction Site
   - **Description:** Testing hazard detection

#### Step 3: Tambah Stream

1. Klik site yang baru dibuat
2. Klik **"Add Stream"**
3. Configure:

**For Local Video:**
```
Stream Name: Test Video
Video URL: D:\Construction-Hazard-Detection\tests\videos\test.mp4
Model: yolo11n
Detection Items:
  ☑ Detect no safety vest or helmet
  ☑ Detect near machinery or vehicle
  ☑ Detect in restricted area
Work Hours: 0-24
Store in Redis: ☑ (for live view)
```

**For YouTube:**
```
Stream Name: YouTube Test
Video URL: https://www.youtube.com/watch?v=9kHbqXCL8Sc
Model: yolo11n
(same detection settings)
```

#### Step 4: Start Detection

```cmd
cd D:\Construction-Hazard-Detection
python main.py
```

Atau specific site:
```cmd
python main.py --poll 10
```

#### Step 5: View Results

Di Visionnaire:
- **Live Stream** - Real-time detection view
- **Dashboard** - Statistics
- **Violations** - Detected hazards history

---

### **METHOD 3: Quick Test Single Video** 🎯

Test cepat tanpa database.

#### Create Test Config

Save as `my_test.json`:

```json
[
  {
    "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Quick Test",
    "stream_name": "Camera 1",
    "model_key": "yolo11n",
    "detect_with_server": false,
    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": true,
      "detect_in_restricted_area": true,
      "detect_in_utility_pole_restricted_area": false,
      "detect_machinery_close_to_pole": false
    },
    "work_start_hour": 0,
    "work_end_hour": 24,
    "store_in_redis": true
  }
]
```

#### Run Test

```cmd
python main.py --config my_test.json
```

---

## 🎬 RECOMMENDED TEST VIDEOS

### **Untuk Demo/Competition:**

**1. Local Test Video (Sudah Ada):**
```
D:\Construction-Hazard-Detection\tests\videos\test.mp4
```
- ✅ Fast (local)
- ✅ Reliable
- ✅ Small size (1.3MB)

**2. YouTube Construction Safety:**
```
https://www.youtube.com/watch?v=9kHbqXCL8Sc
```
- ✅ Good quality
- ✅ Shows PPE violations
- ✅ Worker activities

**3. Live Construction Cam (EarthCam):**
```
https://www.earthcam.com/cams/category/construction
```
- ✅ Real-time feed
- ✅ Impressive for demo
- ⚠️ Needs stable internet

---

## 📋 EXAMPLE CONFIGS

### **Config 1: Local Video (Fast)**

```json
[
  {
    "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Local Test",
    "stream_name": "Test Video",
    "model_key": "yolo11n",
    "detect_with_server": false,
    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": true,
      "detect_in_restricted_area": true,
      "detect_in_utility_pole_restricted_area": false,
      "detect_machinery_close_to_pole": false
    },
    "work_start_hour": 0,
    "work_end_hour": 24,
    "store_in_redis": true
  }
]
```

### **Config 2: YouTube Video**

```json
[
  {
    "video_url": "https://www.youtube.com/watch?v=9kHbqXCL8Sc",
    "site": "YouTube Demo",
    "stream_name": "Construction Safety",
    "model_key": "yolo11n",
    "detect_with_server": false,
    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": true,
      "detect_in_restricted_area": false,
      "detect_in_utility_pole_restricted_area": false,
      "detect_machinery_close_to_pole": false
    },
    "work_start_hour": 0,
    "work_end_hour": 24,
    "store_in_redis": true
  }
]
```

### **Config 3: Multiple Streams**

```json
[
  {
    "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Site A",
    "stream_name": "Camera 1",
    "model_key": "yolo11n",
    "detect_with_server": false,
    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": true,
      "detect_in_restricted_area": true,
      "detect_in_utility_pole_restricted_area": false,
      "detect_machinery_close_to_pole": false
    },
    "work_start_hour": 7,
    "work_end_hour": 18,
    "store_in_redis": true
  },
  {
    "video_url": "https://www.youtube.com/watch?v=9kHbqXCL8Sc",
    "site": "Site B",
    "stream_name": "Camera 2",
    "model_key": "yolo11n",
    "detect_with_server": false,
    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": false,
      "detect_in_restricted_area": false,
      "detect_in_utility_pole_restricted_area": false,
      "detect_machinery_close_to_pole": false
    },
    "work_start_hour": 0,
    "work_end_hour": 24,
    "store_in_redis": true
  }
]
```

---

## 🎯 QUICK START COMMANDS

### **Test dengan Local Video:**

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

### **Test dengan YouTube:**

1. Create config:
```cmd
notepad youtube_test.json
```

2. Paste config di atas (Config 2)

3. Run:
```cmd
python main.py --config youtube_test.json
```

### **Monitor via Visionnaire:**

```
https://visionnaire-cda17.web.app/login
Username: user
Password: password

Then: Live Stream → Select your site/stream
```

---

## 📊 DETECTION ITEMS EXPLAINED

```
detect_no_safety_vest_or_helmet: true
  → Deteksi pekerja tanpa helm atau rompi safety

detect_near_machinery_or_vehicle: true
  → Deteksi pekerja terlalu dekat dengan mesin/kendaraan

detect_in_restricted_area: true
  → Deteksi pekerja di area terlarang (perlu define polygon)

detect_in_utility_pole_restricted_area: false
  → Deteksi di area restricted tiang listrik (utility)

detect_machinery_close_to_pole: false
  → Deteksi mesin terlalu dekat ke tiang listrik
```

**Recommendation:**
Enable yang pertama 2-3 untuk testing awal.

---

## 🔧 MODEL SELECTION

```
yolo11n - Nano (FASTEST, recommended for CPU)
yolo11s - Small
yolo11m - Medium
yolo11l - Large (needs GPU)
yolo11x - Extra Large (best accuracy, GPU only)
```

**For your system (CPU):**
Use `yolo11n` - fastest!

**If you have GPU:**
Use `yolo11x` - most accurate!

---

## 💡 TIPS

### 1. **Start Simple**

Test dengan local video dulu (sudah ada config).

### 2. **Check Work Hours**

```
"work_start_hour": 0,
"work_end_hour": 24,
```

Set 0-24 untuk testing (always detect).

Production: Set 7-18 (jam kerja).

### 3. **Enable Redis Storage**

```
"store_in_redis": true
```

Ini untuk live view di Visionnaire.

### 4. **Monitor Performance**

Watch CMD window untuk FPS dan processing time.

### 5. **Add More Videos**

Put your own videos di `tests/videos/` folder.

---

## 🎬 WHERE TO GET MORE VIDEOS

### **Free Construction Videos:**

1. **Pexels:** https://www.pexels.com/search/videos/construction/
2. **Pixabay:** https://pixabay.com/videos/search/construction/
3. **YouTube:** Search "construction site safety"
4. **Unsplash:** https://unsplash.com/s/videos/construction

### **Live Streams:**

1. **EarthCam:** https://www.earthcam.com/cams/category/construction
2. **YouTube Live:** Search "construction site live stream"

### **Your Own Videos:**

Put `.mp4` files in:
```
D:\Construction-Hazard-Detection\tests\videos\
```

Then use full path in config:
```
"video_url": "D:/Construction-Hazard-Detection/tests/videos/YOUR_VIDEO.mp4"
```

---

## 📝 SUMMARY

### **Quick Test (5 minutes):**

```cmd
# Use existing config
python main.py --config config\test_stream.json

# View at Visionnaire
https://visionnaire-cda17.web.app/login
```

### **Video Sources:**

1. ✅ **Local:** `D:\Construction-Hazard-Detection\tests\videos\test.mp4`
2. ✅ **YouTube:** `https://www.youtube.com/watch?v=9kHbqXCL8Sc`
3. ✅ **Live Cam:** `https://www.earthcam.com/cams/category/construction`

### **Next Steps:**

1. Test dengan local video
2. Test dengan YouTube
3. Add your own videos
4. Fine-tune detection settings
5. Ready for competition! 🏆

---

**START TESTING NOW!** 🚀

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

Monitor di: https://visionnaire-cda17.web.app
