# 🔧 FIX: Menampilkan Multiple Streams di Visionnaire

## 🔍 MASALAH:

**Anda punya 2 sites di database:**
1. Test Site (ID: 1) → Stream "1"
2. Coba_Guys (ID: 2) → Stream "Proyek"

**Tapi di Visionnaire hanya muncul 1 stream!**

---

## 📋 PENYEBAB:

### **Live Stream di Visionnaire hanya menampilkan streams yang SEDANG RUNNING!**

Artinya:
- ✅ Stream "Test Site / 1" → MUNCUL (karena detection running)
- ❌ Stream "Coba_Guys / Proyek" → TIDAK MUNCUL (tidak ada detection running)

**Live Stream ≠ Database Streams!**

**Live Stream** shows:
- Streams yang **SEDANG** di-detect oleh main.py
- Streams yang **ADA FRAME** di Redis

**Database Streams** shows:
- All configured streams (via Site Management)
- Might not be active/running

---

## ✅ SOLUSI:

### **Option 1: Run Detection untuk Kedua Streams (Recommended)**

Buat config dengan **BOTH streams**:

**File:** `config/both_streams.json`
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
    "detect_with_server": false,
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
    "model_key": "yolo11n",
    "notifications": {
      "telegram:5856651174": "en"
    },
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

Then run:
```cmd
python main.py --config config\both_streams.json
```

**Result:** Both streams akan muncul di Visionnaire!

---

### **Option 2: Gunakan Video Sources yang Berbeda**

Jika Anda punya 2 camera/video sources:

```json
[
  {
    "video_url": "rtsp://camera1-ip/stream",
    "site": "Test Site",
    "stream_name": "Camera 1",
    ...
  },
  {
    "video_url": "rtsp://camera2-ip/stream",
    "site": "Coba_Guys",
    "stream_name": "Camera 2",
    ...
  }
]
```

---

### **Option 3: Rename/Update Stream Names**

Via Visionnaire web interface:
1. Login → Site Management
2. Edit stream name dari "1" → "Local Video Demo"
3. Edit stream name dari "Proyek" → Something else

Tapi ini hanya mengubah **database**, tidak membuat stream **live**.

Untuk **live**, perlu **detection running**!

---

## 🎯 UNDERSTANDING: DATABASE vs LIVE STREAM

### **Database (Site Management):**
- Shows ALL configured sites & streams
- Persistent storage
- Can be edited via web interface
- ✅ Anda punya 2 sites, 2 streams

### **Live Stream (WebSocket):**
- Shows ONLY **currently active** streams
- Requires detection running (main.py)
- Data from Redis (real-time)
- ❌ Hanya 1 active (Test Site)

**To make Coba_Guys appear in Live Stream:**
→ Must run detection for that stream!

---

## 📝 QUICK FIX: CREATE BOTH_STREAMS.JSON

Saya akan buatkan file config untuk run both streams!
