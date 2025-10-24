# 🔧 WEBSOCKET STREAMING FIX GUIDE

## ✅ STATUS: Streaming API Running!

**WebSocket API:** ✅ Running di port 8800
**WebSocket Connections:** ✅ Accepted

---

## 🔍 MASALAH ANDA:

Error: "WebSocket error. Failed to connect websocket"

**Root Cause:** Detection program (`main.py`) belum running untuk send frames ke WebSocket!

---

## 📊 ARCHITECTURE EXPLAINED

```
┌─────────────────────────────────────────────────────────┐
│              STREAMING FLOW                             │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. [main.py]                                          │
│     - Capture video frames                             │
│     - Run YOLO detection                               │
│     - Send frames to Redis                             │
│     - Send frames to WebSocket API (port 8800)         │
│                                                         │
│  2. [Streaming API - Port 8800]                        │
│     - Receive frames via WebSocket                     │
│     - Store in memory/Redis                            │
│     - Broadcast to connected clients                   │
│                                                         │
│  3. [Visionnaire Web]                                  │
│     - Connect to ws://127.0.0.1:8800                  │
│     - Receive real-time frames                         │
│     - Display video with detections                    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Currently:**
- ✅ Step 2 (Streaming API) - Running
- ✅ Step 3 (Visionnaire) - Connected
- ❌ Step 1 (main.py) - NOT RUNNING ⬅️ **FIX THIS!**

---

## 🚀 SOLUTION - START DETECTION

### **Option 1: Quick Test dengan Config File** ⚡

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

**What happens:**
1. main.py reads video dari config
2. Runs YOLO detection
3. Sends frames to WebSocket (port 8800)
4. Visionnaire receives and displays frames
5. ✅ Video appears!

---

### **Option 2: Run with Database Polling**

```cmd
cd D:\Construction-Hazard-Detection
python main.py --poll 10
```

**What happens:**
1. main.py connects to database
2. Reads stream configs from `stream_configs` table
3. Starts detection for each configured stream
4. Sends frames to WebSocket
5. ✅ All configured streams appear!

---

### **Option 3: Add Stream via Visionnaire First**

#### Step 1: Add Stream in Visionnaire

1. Login: https://visionnaire-cda17.web.app/login
2. Go to **Sites** → **Add Site**
   - Name: Test Site
3. Go to **Streams** → **Add Stream**
   - Stream Name: `Video Coba`
   - Video URL: `D:\Construction-Hazard-Detection\tests\videos\test.mp4`
   - Model: `yolo11n`
   - Detection Items: ☑ All you want
   - Work Hours: `0` - `24`
   - **Store in Redis:** ☑ **MUST BE CHECKED!** ⬅️ Important!
4. Save

#### Step 2: Start Detection

```cmd
cd D:\Construction-Hazard-Detection
python main.py --poll 10
```

#### Step 3: View Stream

1. In Visionnaire, go to **Live Stream**
2. Select **Test Site** → **Video Coba**
3. ✅ Video should appear!

---

## ⚙️ IMPORTANT SETTINGS

### **1. Store in Redis MUST be Enabled**

In stream config or database:
```json
"store_in_redis": true
```

Or in database:
```sql
UPDATE stream_configs
SET store_in_redis = 1
WHERE stream_name = 'Video Coba';
```

**Why?** This tells main.py to send frames to WebSocket/Redis for streaming.

### **2. Work Hours Settings**

For testing, set to always active:
```json
"work_start_hour": 0,
"work_end_hour": 24
```

Or in database:
```sql
UPDATE stream_configs
SET work_start_hour = 0, work_end_hour = 24
WHERE stream_name = 'Video Coba';
```

### **3. Video URL Format**

**Local file (Windows):**
```
D:\Construction-Hazard-Detection\tests\videos\test.mp4
or
D:/Construction-Hazard-Detection/tests/videos/test.mp4
```

**YouTube:**
```
https://www.youtube.com/watch?v=9kHbqXCL8Sc
```

**RTSP:**
```
rtsp://your-camera-ip:554/stream
```

---

## 🧪 QUICK TEST NOW

### Test dengan Local Video:

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

**Expected Output:**
```
Starting detection...
Loading model: yolo11n
Processing frame 1...
Processing frame 2...
Sending frame to WebSocket...
```

### Then Check Visionnaire:

1. Open: https://visionnaire-cda17.web.app
2. Go to **Live Stream**
3. Select **Test Site** → **Local Video Demo**
4. ✅ You should see video with detections!

---

## 🔧 TROUBLESHOOTING

### **"No video appears in Visionnaire"**

**Check 1:** Is main.py running?
```cmd
# Check if Python process running
tasklist | findstr python
```

**Check 2:** Is store_in_redis enabled?
```cmd
# In config file
"store_in_redis": true

# Or check database
SELECT stream_name, store_in_redis FROM stream_configs;
```

**Check 3:** Check Redis
```cmd
redis-cli
KEYS stream_frame:*
```

Should show:
```
1) "stream_frame:Test%20Site|Local%20Video%20Demo"
```

**Check 4:** Check main.py output
Look for errors in CMD window where main.py is running.

---

### **"WebSocket keeps disconnecting"**

**Fix 1:** Restart Streaming API
```cmd
# Kill existing
taskkill /F /IM python.exe /FI "WINDOWTITLE eq Streaming*"

# Restart
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

**Fix 2:** Check WebSocket URL in Visionnaire
```javascript
// F12 Console
console.log(localStorage.getItem('STREAMING_API_URL'));
// Should be: http://127.0.0.1:8800
```

---

### **"Detection running but no frames sent"**

**Check:** Is `store_in_redis` enabled in config?

**Fix:** Update config:
```json
{
  "video_url": "...",
  "store_in_redis": true,  ← Add this!
  ...
}
```

Or database:
```sql
UPDATE stream_configs SET store_in_redis = 1;
```

---

## 📝 COMPLETE SETUP CHECKLIST

- [ ] MySQL running (port 3306)
- [ ] Redis running (port 6379)
- [ ] DB Management API running (port 8005)
- [x] **Streaming API running (port 8800)** ✅
- [ ] **main.py detection running** ⬅️ START THIS NOW!
- [ ] Stream config has `store_in_redis: true`
- [ ] Visionnaire localStorage configured
- [ ] Video streaming working in Visionnaire

---

## 🚀 START NOW - STEP BY STEP

### **Step 1: Verify Streaming API** ✅

Already running! You can see:
```
INFO: Uvicorn running on http://0.0.0.0:8800
INFO: WebSocket /ws/labels/Video%20Coba [accepted]
```

### **Step 2: Start Detection** ⬅️ DO THIS NOW!

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

### **Step 3: Check Video in Visionnaire**

1. Go to: https://visionnaire-cda17.web.app
2. Click **Live Stream**
3. Select your stream
4. ✅ Video should appear!

---

## 💡 TIPS

### **Tip 1: Monitor main.py Output**

Watch for:
```
Processing frame...
Sending to WebSocket...
FPS: 5.2
```

### **Tip 2: Check Redis Keys**

```cmd
redis-cli
KEYS stream_frame:*
GET stream_frame:Test%20Site|Local%20Video%20Demo
```

### **Tip 3: Check WebSocket Connections**

In Streaming API output, look for:
```
INFO: WebSocket /ws/labels/[stream_name] [accepted]
```

### **Tip 4: Use Browser Console**

F12 → Console, look for:
```
WebSocket connected
Receiving frames...
```

---

## 📊 ALL REQUIRED SERVICES

Make sure ALL are running:

```cmd
# Check all ports
netstat -an | findstr ":8000 :8005 :8800 :3306 :6379" | findstr "LISTENING"
```

Should show:
```
TCP    0.0.0.0:8000    LISTENING  (YOLO API)
TCP    0.0.0.0:8005    LISTENING  (DB Management)
TCP    0.0.0.0:8800    LISTENING  (Streaming) ✅
TCP    0.0.0.0:3306    LISTENING  (MySQL)
```

And Redis:
```cmd
redis-cli ping
# Should return: PONG
```

---

## 🎯 FINAL COMMAND TO RUN

```cmd
cd D:\Construction-Hazard-Detection

REM Make sure Redis running
redis-cli ping

REM Start detection with test video
python main.py --config config\test_stream.json
```

**Then go to Visionnaire and check Live Stream!**

---

## 📚 SUMMARY

**Problem:** WebSocket error = No frames being sent

**Solution:** Start `main.py` detection program

**Command:**
```cmd
python main.py --config config\test_stream.json
```

**Result:** Video will appear in Visionnaire Live Stream ✅

---

**TRY IT NOW!** 🚀

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

Wait a few seconds, then refresh Visionnaire Live Stream page!
