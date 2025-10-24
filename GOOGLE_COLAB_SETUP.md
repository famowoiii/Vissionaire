# 🚀 SETUP DI GOOGLE COLAB (GRATIS!)

## 📋 OVERVIEW

Panduan lengkap untuk menjalankan Construction Hazard Detection di Google Colab dengan **GPU T4 GRATIS** untuk mencapai **real-time detection (25-30 FPS)** untuk kompetisi.

---

## ✅ KEUNGGULAN GOOGLE COLAB

- ✅ **100% GRATIS** (tidak perlu kartu kredit)
- ✅ **GPU NVIDIA T4** tersedia gratis
- ✅ **Performa: 25-30 FPS** (real-time!)
- ✅ **Setup 10-15 menit** (sangat cepat)
- ✅ **Tidak perlu install apapun** di komputer
- ✅ **12 GB RAM** cukup untuk YOLO
- ✅ **Akses 12 jam** per sesi (cukup untuk kompetisi)

---

## ⚠️ BATASAN GOOGLE COLAB GRATIS

- Session timeout setelah **12 jam** (bisa restart ulang)
- Idle timeout setelah **90 menit** tidak aktif (klik sesuatu di notebook untuk keep alive)
- GPU availability tergantung usage (kadang perlu tunggu)
- Tidak bisa akses dari luar (harus akses via Colab interface)

**Untuk kompetisi, batasan ini tidak masalah!**

---

## 🎯 ESTIMASI PERFORMA

| Model | Resolution | FPS (GPU T4) | Latency | Akurasi |
|-------|-----------|--------------|---------|---------|
| YOLO11n | 640x640 | 28-32 FPS | 31-35ms | ⭐⭐⭐ |
| YOLO11n | 416x416 | 45-55 FPS | 18-22ms | ⭐⭐ |
| YOLO11s | 640x640 | 22-26 FPS | 38-45ms | ⭐⭐⭐⭐ |
| YOLO11m | 640x640 | 15-18 FPS | 55-66ms | ⭐⭐⭐⭐⭐ |

**Rekomendasi: YOLO11n @ 640x640 (30 FPS + akurasi bagus)**

---

## 🚀 STEP-BY-STEP SETUP

### STEP 1: Buka Google Colab

1. Buka browser, masuk ke: **https://colab.research.google.com**
2. Login dengan akun Google Anda
3. Klik **"New Notebook"** atau **"File > New Notebook"**

### STEP 2: Enable GPU

**SANGAT PENTING!** Tanpa ini, sistem akan lambat seperti di CPU lokal Anda.

1. Klik menu **"Runtime"** (atau **"Waktu Proses"** jika bahasa Indonesia)
2. Pilih **"Change runtime type"** (atau **"Ubah jenis waktu proses"**)
3. Di **"Hardware accelerator"**, pilih **"GPU"** (bukan "None" atau "TPU")
4. Klik **"Save"**

**Verify GPU tersedia:**

Jalankan cell ini di notebook:

```python
!nvidia-smi
```

**Expected output:**

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.xx       Driver Version: 525.xx       CUDA Version: 12.0   |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
|   0  Tesla T4        Off      | 00000000:00:04.0 Off |                    0 |
+-----------------------------------------------------------------------------+
```

Jika muncul **Tesla T4** atau **T4**, berarti GPU siap! ✅

---

### STEP 3: Clone Repository

Buat cell baru dan jalankan:

```python
# Clone repository
!git clone https://github.com/yihong1120/Construction-Hazard-Detection.git
%cd Construction-Hazard-Detection

# Verify
!ls -la
```

---

### STEP 4: Install Dependencies

```python
# Upgrade pip
!pip install --upgrade pip

# Install requirements
!pip install -r requirements.txt

# Install additional dependencies jika ada error
!pip install opencv-python-headless redis mysql-connector-python asyncmy ultralytics
```

**Tunggu 3-5 menit** untuk instalasi selesai.

---

### STEP 5: Verify PyTorch CUDA

**PENTING:** Pastikan PyTorch detect GPU!

```python
import torch
import cv2

print("="*70)
print("SYSTEM CHECK")
print("="*70)
print(f"PyTorch Version: {torch.__version__}")
print(f"CUDA Available: {torch.cuda.is_available()}")
print(f"CUDA Version: {torch.version.cuda}")
print(f"OpenCV Version: {cv2.__version__}")

if torch.cuda.is_available():
    print(f"GPU Count: {torch.cuda.device_count()}")
    print(f"GPU Name: {torch.cuda.get_device_name(0)}")
    print(f"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB")
    print("\n✅ GPU READY FOR REAL-TIME DETECTION!")
else:
    print("\n❌ WARNING: GPU NOT AVAILABLE!")
    print("Go to Runtime > Change runtime type > GPU")
```

**Expected output:**

```
======================================================================
SYSTEM CHECK
======================================================================
PyTorch Version: 2.x.x+cu118
CUDA Available: True
CUDA Version: 11.8
OpenCV Version: 4.x.x
GPU Count: 1
GPU Name: Tesla T4
GPU Memory: 15.00 GB

✅ GPU READY FOR REAL-TIME DETECTION!
```

---

### STEP 6: Download YOLO Models

```python
# Install Hugging Face CLI
!pip install -q huggingface-hub

# Download YOLO11 models
!huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 \
    --repo-type model \
    --include "models/pt/*.pt" \
    --local-dir .

# Verify download
!ls -lh models/pt/
```

**Expected output:**

```
-rw-r--r-- 1 root root  6.2M best_yolo11n.pt
-rw-r--r-- 1 root root  22M  best_yolo11s.pt
-rw-r--r-- 1 root root  52M  best_yolo11m.pt
```

---

### STEP 7: Upload Test Video

Ada 2 cara:

#### **Cara A: Upload dari komputer Anda**

```python
from google.colab import files
import os

# Create directory
!mkdir -p tests/videos

# Upload file (akan muncul dialog upload)
print("Silakan pilih file video dari komputer Anda...")
uploaded = files.upload()

# Move to tests/videos
for filename in uploaded.keys():
    os.rename(filename, f'tests/videos/{filename}')
    print(f'✅ Uploaded: tests/videos/{filename}')
```

Klik **"Choose Files"** dan pilih video dari komputer Anda.

#### **Cara B: Download sample video**

```python
# Download sample construction video
!mkdir -p tests/videos
!wget -O tests/videos/test.mp4 \
    "https://github.com/yihong1120/Construction-Hazard-Detection/raw/main/tests/videos/test.mp4"

!ls -lh tests/videos/
```

---

### STEP 8: Setup Database & Redis (Simplified untuk Colab)

Karena Colab tidak persistent, kita skip MySQL dan gunakan in-memory untuk testing:

```python
# Install Redis
!apt-get install -y redis-server > /dev/null 2>&1

# Start Redis
!redis-server --daemonize yes --bind 127.0.0.1 --port 6379

# Test Redis
!redis-cli ping
```

**Expected output:** `PONG`

Untuk MySQL, kita akan gunakan SQLite sebagai alternatif (lebih mudah di Colab):

```python
# Update .env untuk gunakan SQLite
!sed -i "s|DATABASE_URL=.*|DATABASE_URL='sqlite+aiosqlite:///./hazard_detection.db'|g" .env

# Atau manual edit
import os

env_content = """
# Database (SQLite untuk Colab)
DATABASE_URL='sqlite+aiosqlite:///./hazard_detection.db'

# Redis
REDIS_HOST='127.0.0.1'
REDIS_PORT=6379
REDIS_PASSWORD=

# API Credentials
API_USERNAME='user'
API_PASSWORD='password'

# API URLs
DETECT_API_URL='http://127.0.0.1:8000'
FCM_API_URL='http://127.0.0.1:8003'
VIOLATION_RECORD_API_URL='http://127.0.0.1:8002'
STREAMING_API_URL='http://127.0.0.1:8800'
DB_MANAGEMENT_API_URL='http://127.0.0.1:8005'

# Model
MODEL_PATH='models/pt/best_yolo11n.pt'
USE_GPU=True
"""

with open('.env', 'w') as f:
    f.write(env_content)

print("✅ .env configured for Colab")
```

---

### STEP 9: Test GPU Performance

**Sebelum run full detection, test dulu performa GPU!**

```python
import torch
import cv2
import time
from ultralytics import YOLO
import numpy as np

def test_gpu_performance():
    print("="*70)
    print("GPU PERFORMANCE TEST")
    print("="*70)

    # Load model
    model = YOLO('models/pt/best_yolo11n.pt')
    model.to('cuda')
    print(f"✅ Model loaded on GPU: {torch.cuda.get_device_name(0)}\n")

    # Create test frame (640x640)
    test_frame = np.random.randint(0, 255, (640, 640, 3), dtype=np.uint8)

    # Warmup
    print("Warming up GPU...")
    for _ in range(10):
        _ = model(test_frame, verbose=False)
    torch.cuda.synchronize()
    print("✅ Warmup complete\n")

    # Benchmark
    num_frames = 100
    print(f"Running inference on {num_frames} frames...\n")

    inference_times = []
    for i in range(num_frames):
        start = time.time()
        results = model(test_frame, verbose=False)
        torch.cuda.synchronize()
        inference_time = time.time() - start
        inference_times.append(inference_time)

        if (i + 1) % 20 == 0:
            avg = sum(inference_times) / len(inference_times)
            fps = 1.0 / avg
            print(f"Frame {i+1:3d}: {inference_time*1000:5.1f}ms | Avg: {avg*1000:5.1f}ms | FPS: {fps:5.1f}")

    # Results
    avg_time = sum(inference_times) / len(inference_times)
    avg_fps = 1.0 / avg_time

    print("\n" + "="*70)
    print("RESULTS")
    print("="*70)
    print(f"Average Inference Time: {avg_time*1000:.2f}ms")
    print(f"Average FPS: {avg_fps:.2f}")
    print()

    if avg_fps >= 25:
        print("✅ EXCELLENT! Real-time capable (>25 FPS)")
        print("   Status: SIAP UNTUK KOMPETISI! 🚀")
    elif avg_fps >= 20:
        print("✅ GOOD! Real-time capable (20-25 FPS)")
        print("   Status: Siap untuk kompetisi")
    else:
        print("⚠️ FPS kurang optimal")
        print("   Coba: Runtime > Factory reset runtime, lalu setup ulang")

    print("="*70)

    return avg_fps

# Run test
fps = test_gpu_performance()
```

**Expected output:**

```
======================================================================
GPU PERFORMANCE TEST
======================================================================
✅ Model loaded on GPU: Tesla T4

Warming up GPU...
✅ Warmup complete

Running inference on 100 frames...

Frame  20:  31.2ms | Avg:  32.1ms | FPS:  31.1
Frame  40:  30.8ms | Avg:  31.5ms | FPS:  31.7
Frame  60:  31.5ms | Avg:  31.3ms | FPS:  31.9
Frame  80:  30.9ms | Avg:  31.2ms | FPS:  32.0
Frame 100:  31.1ms | Avg:  31.2ms | FPS:  32.0

======================================================================
RESULTS
======================================================================
Average Inference Time: 31.20ms
Average FPS: 32.05

✅ EXCELLENT! Real-time capable (>25 FPS)
   Status: SIAP UNTUK KOMPETISI! 🚀
======================================================================
```

Jika dapat **30+ FPS**, berarti sistem Anda **SIAP UNTUK KOMPETISI!** ✅

---

### STEP 10: Run Detection pada Video

**Opsi A: Simplified Detection (Tanpa Full API Services)**

Cara paling mudah untuk testing di Colab:

```python
import cv2
import torch
from ultralytics import YOLO
from pathlib import Path
import time

# Load model
print("Loading YOLO11n model...")
model = YOLO('models/pt/best_yolo11n.pt')
model.to('cuda')
print(f"✅ Model loaded on {torch.cuda.get_device_name(0)}\n")

# Open video
video_path = 'tests/videos/test.mp4'
cap = cv2.VideoCapture(video_path)

if not cap.isOpened():
    print(f"❌ Cannot open video: {video_path}")
    exit()

# Video info
fps_video = cap.get(cv2.CAP_PROP_FPS)
total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

print(f"Video: {video_path}")
print(f"Resolution: {width}x{height}")
print(f"FPS: {fps_video}")
print(f"Total Frames: {total_frames}")
print(f"Duration: {total_frames/fps_video:.1f}s\n")

# Detection loop
print("Starting detection...\n")
print("-"*70)

frame_count = 0
detection_count = 0
start_time = time.time()

while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame_count += 1

    # Run detection
    results = model(frame, verbose=False)

    # Count detections
    boxes = results[0].boxes
    if len(boxes) > 0:
        detection_count += 1

    # Print progress every 30 frames
    if frame_count % 30 == 0:
        elapsed = time.time() - start_time
        fps_processing = frame_count / elapsed

        print(f"Frame {frame_count}/{total_frames} | "
              f"Processing FPS: {fps_processing:.1f} | "
              f"Detections: {len(boxes)} objects")

    # Optional: Visualize (comment out jika ingin lebih cepat)
    # annotated_frame = results[0].plot()
    # cv2_imshow(annotated_frame)  # Show in Colab

cap.release()

# Summary
total_time = time.time() - start_time
avg_fps = frame_count / total_time

print("-"*70)
print("\n" + "="*70)
print("DETECTION SUMMARY")
print("="*70)
print(f"Total Frames Processed: {frame_count}")
print(f"Total Time: {total_time:.2f}s")
print(f"Average Processing FPS: {avg_fps:.2f}")
print(f"Frames with Detections: {detection_count}")
print(f"Detection Rate: {detection_count/frame_count*100:.1f}%")
print()

if avg_fps >= 25:
    print("✅ REAL-TIME PERFORMANCE ACHIEVED! 🚀")
elif avg_fps >= 15:
    print("✅ Near real-time performance")
else:
    print("⚠️ Performance below target")

print("="*70)
```

**Opsi B: Run Full System (dengan API services)**

Jika ingin run full system seperti di lokal:

```python
# Install tmux untuk manage multiple processes
!apt-get install -y tmux

# Start Redis
!redis-server --daemonize yes

# Start all API services in background
import subprocess
import time

services = [
    ("YOLO API", "examples/YOLO_server_api", "python main.py", 8000),
    ("Violation API", "examples/violation-record-api", "uvicorn main:app --host 0.0.0.0 --port 8002", 8002),
    ("FCM API", "examples/fcm-api", "uvicorn main:app --host 0.0.0.0 --port 8003", 8003),
    ("DB API", "examples/user-management-api", "uvicorn main:app --host 0.0.0.0 --port 8005", 8005),
    ("Streaming API", "examples/streaming-web-api", "uvicorn main:app --host 0.0.0.0 --port 8800", 8800),
]

print("Starting all services...")
for name, directory, command, port in services:
    subprocess.Popen(f"cd {directory} && {command}", shell=True)
    print(f"✅ Started {name} on port {port}")
    time.sleep(2)

print("\n✅ All services started! Waiting 10 seconds for initialization...")
time.sleep(10)

# Now run main detection
!python main.py --config config/test_stream.json
```

---

### STEP 11: Monitor GPU Usage

**Buka cell terpisah** dan jalankan ini untuk monitor GPU real-time:

```python
# Install watch command
!apt-get install -y watch > /dev/null 2>&1

# Monitor GPU (refresh every 1 second)
!watch -n 1 nvidia-smi
```

Atau tanpa watch:

```python
import time

for i in range(60):  # Monitor for 60 seconds
    !clear
    !nvidia-smi
    time.sleep(1)
```

**Yang harus Anda lihat:**

```
GPU-Util: 85-98%  (GPU bekerja keras - BAGUS!)
Memory-Usage: 4-8 GB / 15 GB
Temperature: 60-75°C (normal)
```

---

### STEP 12: Visualisasi Hasil Detection

```python
import cv2
from google.colab.patches import cv2_imshow
from ultralytics import YOLO
import torch

# Load model
model = YOLO('models/pt/best_yolo11n.pt')
model.to('cuda')

# Open video
cap = cv2.VideoCapture('tests/videos/test.mp4')

print("Showing first 10 frames with detections...\n")

frame_count = 0
while frame_count < 10:
    ret, frame = cap.read()
    if not ret:
        break

    # Run detection
    results = model(frame, verbose=False)

    # Annotate frame
    annotated_frame = results[0].plot()

    # Show in Colab
    print(f"Frame {frame_count + 1}:")
    cv2_imshow(annotated_frame)
    print()

    frame_count += 1

cap.release()
print("✅ Visualization complete")
```

---

### STEP 13: Download Hasil (Opsional)

Jika ingin save video hasil detection:

```python
from ultralytics import YOLO
import cv2
from google.colab import files

# Load model
model = YOLO('models/pt/best_yolo11n.pt')
model.to('cuda')

# Open video
cap = cv2.VideoCapture('tests/videos/test.mp4')

# Get video properties
fps = int(cap.get(cv2.CAP_PROP_FPS))
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

# Create video writer
output_path = 'output_detection.mp4'
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter(output_path, fourcc, fps, (width, height))

print(f"Processing video and saving to {output_path}...")

frame_count = 0
while True:
    ret, frame = cap.read()
    if not ret:
        break

    # Detection
    results = model(frame, verbose=False)
    annotated_frame = results[0].plot()

    # Write frame
    out.write(annotated_frame)

    frame_count += 1
    if frame_count % 30 == 0:
        print(f"Processed {frame_count} frames...")

cap.release()
out.release()

print(f"✅ Video saved: {output_path}")
print(f"Total frames: {frame_count}\n")

# Download file
print("Downloading file...")
files.download(output_path)
print("✅ Download started! Check your Downloads folder")
```

---

## 💡 TIPS & TRICKS GOOGLE COLAB

### 1. Keep Session Alive

Colab akan disconnect setelah 90 menit idle. Gunakan ini:

```python
# Paste di cell terpisah dan jalankan
import time
from IPython.display import display, Javascript

def keep_alive():
    while True:
        display(Javascript('console.log("Keep alive")'))
        time.sleep(60)  # Every 60 seconds

# Run in background
import threading
thread = threading.Thread(target=keep_alive)
thread.daemon = True
thread.start()

print("✅ Keep-alive activated")
```

### 2. Check GPU Availability

```python
!nvidia-smi -L
```

Jika muncul "No devices found", restart runtime dan enable GPU lagi.

### 3. Speed Up File Operations

```python
# Mount Google Drive untuk save/load file lebih cepat
from google.colab import drive
drive.mount('/content/drive')

# Sekarang bisa save ke Drive
# output_path = '/content/drive/MyDrive/detection_output.mp4'
```

### 4. Reduce Model Size untuk Faster Loading

```python
# Export model ke TorchScript (lebih cepat load)
model = YOLO('models/pt/best_yolo11n.pt')
model.export(format='torchscript')

# Load TorchScript model
model = YOLO('models/pt/best_yolo11n.torchscript')
```

---

## 🎯 UNTUK KOMPETISI: CHECKLIST

**Sebelum Kompetisi:**

- [ ] Test di Colab, pastikan dapat 25-30 FPS
- [ ] Upload video kompetisi ke Google Drive
- [ ] Bookmark Colab notebook
- [ ] Test visualisasi dan output

**Saat Kompetisi:**

1. **Buka Colab** (5 menit sebelum kompetisi)
2. **Enable GPU** (Runtime > Change runtime type > GPU)
3. **Run all cells** dari Step 3-9 (setup займет 10-15 menit)
4. **Mount Google Drive** dan load video kompetisi
5. **Run detection** dengan config sesuai requirements kompetisi
6. **Monitor GPU** untuk pastikan tidak idle
7. **Save results** ke Google Drive atau download

**Troubleshooting Cepat:**

- **GPU not available?** → Runtime > Factory reset runtime → Setup ulang
- **Out of memory?** → Reduce batch size atau resolution
- **Slow performance?** → Check GPU utilization dengan nvidia-smi
- **Session disconnected?** → Jalankan ulang dari Step 3 (model sudah ter-download)

---

## 📊 PERBANDINGAN: COLAB vs LOKAL

| Aspek | Lokal (CPU Intel) | Google Colab (GPU T4) |
|-------|-------------------|----------------------|
| **FPS** | 0.1-0.3 | 28-32 |
| **Latency** | 3-10 detik | 30-35ms |
| **Setup Time** | 1-2 jam | 10-15 menit |
| **Biaya** | $0 | $0 |
| **Real-time?** | ❌ NO | ✅ YES |
| **Untuk Kompetisi** | ❌ Tidak cocok | ✅ Perfect! |

---

## 🔗 RESOURCES

- **Google Colab**: https://colab.research.google.com
- **YOLO Ultralytics Docs**: https://docs.ultralytics.com
- **Project GitHub**: https://github.com/yihong1120/Construction-Hazard-Detection
- **Colab FAQ**: https://research.google.com/colaboratory/faq.html

---

## ✅ QUICK START SUMMARY

```python
# 1. Enable GPU (Runtime > Change runtime type > GPU)

# 2. Setup (jalankan cell by cell)
!git clone https://github.com/yihong1120/Construction-Hazard-Detection.git
%cd Construction-Hazard-Detection
!pip install -r requirements.txt
!huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 --repo-type model --include "models/pt/*.pt" --local-dir .

# 3. Test GPU performance
from test_gpu_performance import test_gpu_performance
test_gpu_performance()  # Should get 28-32 FPS

# 4. Run detection
!python main.py --config config/test_stream.json
```

**Total setup time: 10-15 menit**
**Expected FPS: 28-32 (real-time!)**

---

**GOOD LUCK DENGAN KOMPETISI! 🚀**

**Dengan Google Colab GPU T4, Anda akan mendapatkan performa 200-300x lebih cepat dari CPU lokal!**
