# 🚀 SETUP CONSTRUCTION HAZARD DETECTION DI VAST.AI

## 📋 OVERVIEW

Panduan ini untuk deploy Construction Hazard Detection system di Vast.ai GPU cloud dengan GTX 1070 Ti untuk mencapai **real-time detection (20-30 FPS)** untuk kompetisi.

---

## 💰 ESTIMASI BIAYA & PERFORMA

| GPU Model | CUDA Cores | RAM | Harga/jam | FPS (YOLO11n) | Real-time? |
|-----------|------------|-----|-----------|---------------|------------|
| GTX 1070 Ti | 2432 cores | 8GB | $0.10-0.30 | 25-35 FPS | ✅ YES |
| RTX 3060 | 3584 cores | 12GB | $0.20-0.40 | 35-45 FPS | ✅ YES |
| RTX 3080 | 8704 cores | 10GB | $0.40-0.80 | 50-70 FPS | ✅ YES |

**Untuk kompetisi, GTX 1070 Ti sudah sangat cukup!**

**Estimasi total biaya:**
- Testing (2 jam): $0.20-0.60
- Kompetisi (8 jam): $0.80-2.40
- **Total: ~$1-3 USD** untuk seluruh kompetisi!

---

## 🔧 STEP 1: DAFTAR & SETUP VAST.AI

### 1.1. Buat Akun Vast.ai

1. Buka: https://vast.ai
2. Sign up dengan email
3. Verifikasi email
4. Top up saldo minimal **$5** (cukup untuk testing + kompetisi)
   - Payment: Credit Card / Crypto

### 1.2. Pilih GPU Instance

1. Login ke Vast.ai dashboard
2. Klik **"Search"** di menu atas
3. **Filter yang HARUS diset:**
   ```
   GPU: GTX 1070 Ti (atau RTX 3060/3080 jika ada budget lebih)
   RAM: Minimal 16 GB
   Disk Space: Minimal 30 GB
   DLPerf: > 50 (performa deep learning)
   Internet: > 100 Mbps (untuk streaming)
   CUDA Version: 11.8 atau 12.x
   ```

4. **Sort by:** Price (termurah dulu)

5. **Pilih instance dengan:**
   - ✅ Verified host (ada checkmark hijau)
   - ✅ High reliability score (> 95%)
   - ✅ Low DLPerf price ($/TFLOPs)

6. Klik **"Rent"** pada instance pilihan Anda

### 1.3. Configure Instance

Saat rent instance, gunakan template ini:

```
Image: pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime
Docker Options: (kosongkan atau default)
Launch Mode: SSH
Disk Space: 30 GB
On-start script: (akan kita isi nanti)
```

Atau gunakan Docker image yang sudah include semua dependencies:

```
Image: nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04
```

---

## 🖥️ STEP 2: CONNECT KE INSTANCE

### 2.1. SSH Connection

Setelah instance running, Vast.ai akan memberikan:
- **SSH Command**: `ssh -p PORT_NUMBER root@IP_ADDRESS -L 8080:localhost:8080`
- **Password**: (dicopy otomatis)

**Di Windows (Git Bash atau PowerShell):**

```bash
# Copy SSH command dari Vast.ai dashboard
ssh -p 12345 root@123.45.67.89 -L 8080:localhost:8080

# Paste password saat diminta
```

**Port Forwarding Explanation:**
- `-L 8080:localhost:8080`: Forward port 8080 dari GPU instance ke localhost Anda
- Berguna untuk akses web interface dari browser lokal

### 2.2. Verifikasi GPU

Setelah login via SSH, cek GPU:

```bash
nvidia-smi
```

**Output yang diharapkan:**
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.xx       Driver Version: 525.xx       CUDA Version: 12.1   |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
|   0  GTX 1070 Ti     Off      | 00000000:01:00.0 Off |                  N/A |
+-------------------------------+----------------------+----------------------+
```

Jika muncul GTX 1070 Ti, berarti GPU siap digunakan! ✅

---

## 📦 STEP 3: INSTALL DEPENDENCIES

### 3.1. Install System Dependencies

```bash
# Update system
apt-get update && apt-get upgrade -y

# Install essential tools
apt-get install -y \
    git \
    wget \
    curl \
    vim \
    python3-pip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    redis-server \
    mysql-server

# Install Python 3.10+ (jika belum ada)
apt-get install -y python3.10 python3.10-dev
```

### 3.2. Clone Project Repository

```bash
# Clone project
cd /root
git clone https://github.com/yihong1120/Construction-Hazard-Detection.git
cd Construction-Hazard-Detection

# Or jika Anda punya fork sendiri:
# git clone https://github.com/YOUR_USERNAME/Construction-Hazard-Detection.git
```

### 3.3. Install PyTorch dengan CUDA

**PENTING:** Install PyTorch dengan CUDA support!

```bash
# Untuk CUDA 12.1 (sesuaikan dengan nvidia-smi output)
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Untuk CUDA 11.8
# pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

### 3.4. Install Project Dependencies

```bash
cd /root/Construction-Hazard-Detection

# Install requirements
pip3 install -r requirements.txt

# Install additional dependencies yang mungkin diperlukan
pip3 install opencv-python-headless redis mysql-connector-python asyncmy
```

### 3.5. Verify PyTorch CUDA

**SANGAT PENTING - Cek PyTorch detect CUDA:**

```bash
python3 << EOF
import torch
print(f"PyTorch Version: {torch.__version__}")
print(f"CUDA Available: {torch.cuda.is_available()}")
print(f"CUDA Version: {torch.version.cuda}")
print(f"GPU Count: {torch.cuda.device_count()}")
if torch.cuda.is_available():
    print(f"GPU Name: {torch.cuda.get_device_name(0)}")
    print(f"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB")
EOF
```

**Expected Output:**
```
PyTorch Version: 2.x.x+cu121
CUDA Available: True
CUDA Version: 12.1
GPU Count: 1
GPU Name: NVIDIA GeForce GTX 1070 Ti
GPU Memory: 8.00 GB
```

Jika `CUDA Available: False`, **JANGAN LANJUT!** Install ulang PyTorch dengan CUDA.

---

## 🗄️ STEP 4: SETUP DATABASE & REDIS

### 4.1. Start MySQL

```bash
# Start MySQL service
service mysql start

# Login ke MySQL
mysql -u root

# Buat database dan user
CREATE DATABASE construction_hazard_detection;
CREATE USER 'hazard_user'@'localhost' IDENTIFIED BY 'hazard_password';
GRANT ALL PRIVILEGES ON construction_hazard_detection.* TO 'hazard_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# Import schema
mysql -u hazard_user -phazard_password construction_hazard_detection < scripts/init.sql
```

### 4.2. Start Redis

```bash
# Start Redis server
redis-server --daemonize yes --bind 127.0.0.1 --port 6379

# Test Redis
redis-cli ping
# Should return: PONG
```

### 4.3. Configure Environment Variables

```bash
cd /root/Construction-Hazard-Detection

# Edit .env file
nano .env
```

**Update .env dengan konfigurasi ini:**

```bash
# Database Configuration
DATABASE_URL='mysql+asyncmy://hazard_user:hazard_password@127.0.0.1:3306/construction_hazard_detection'

# Redis Configuration
REDIS_HOST='127.0.0.1'
REDIS_PORT=6379
REDIS_PASSWORD=

# API Credentials
API_USERNAME='user'
API_PASSWORD='password'

# API URLs (semua localhost karena running di satu instance)
DETECT_API_URL='http://127.0.0.1:8000'
FCM_API_URL='http://127.0.0.1:8003'
VIOLATION_RECORD_API_URL='http://127.0.0.1:8002'
STREAMING_API_URL='http://127.0.0.1:8800'
DB_MANAGEMENT_API_URL='http://127.0.0.1:8005'

# Model Configuration
MODEL_PATH='models/pt/best_yolo11n.pt'
USE_GPU=True
```

Save dan keluar (Ctrl+X, Y, Enter)

---

## 📥 STEP 5: DOWNLOAD YOLO MODELS

```bash
cd /root/Construction-Hazard-Detection

# Install Hugging Face CLI jika belum
pip3 install huggingface-hub

# Download YOLO11 models
huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 \
    --repo-type model \
    --include "models/pt/*.pt" \
    --local-dir .

# Verify download
ls -lh models/pt/
```

**Expected output:**
```
-rw-r--r-- 1 root root  6.2M best_yolo11n.pt
-rw-r--r-- 1 root root  22M  best_yolo11s.pt
-rw-r--r-- 1 root root  52M  best_yolo11m.pt
```

---

## 🚀 STEP 6: RUN DETECTION SYSTEM

### 6.1. Upload Test Video

**Dari komputer Windows Anda**, upload video test ke Vast.ai instance:

```bash
# Di Git Bash / PowerShell di Windows
scp -P 12345 D:\Construction-Hazard-Detection\tests\videos\test.mp4 root@123.45.67.89:/root/Construction-Hazard-Detection/tests/videos/

# Ganti 12345 dengan port SSH Anda
# Ganti 123.45.67.89 dengan IP instance Anda
```

Atau download sample video langsung di instance:

```bash
# Di SSH Vast.ai
cd /root/Construction-Hazard-Detection/tests/videos
wget https://example.com/construction-sample.mp4 -O test.mp4
```

### 6.2. Update Stream Configuration

```bash
cd /root/Construction-Hazard-Detection
nano config/test_stream.json
```

**Edit config:**

```json
[
  {
    "video_url": "/root/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Vast.ai GPU Test",
    "stream_name": "Competition Demo",
    "model_key": "yolo11n",
    "notifications": {},
    "detect_with_server": false,
    "expire_date": "2025-12-31T23:59:59",
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

### 6.3. Start All Services

**Gunakan tmux untuk manage multiple services:**

```bash
# Install tmux
apt-get install -y tmux

# Start tmux session
tmux new -s hazard_detection
```

**Di dalam tmux, buka multiple panes:**

```bash
# Pane 1 - YOLO Detection API (Port 8000)
Ctrl+B, "  # Split horizontal
cd /root/Construction-Hazard-Detection/examples/YOLO_server_api
python main.py

# Pane 2 - Violation Record API (Port 8002)
Ctrl+B, "  # Split horizontal lagi
cd /root/Construction-Hazard-Detection/examples/violation-record-api
uvicorn main:app --host 0.0.0.0 --port 8002

# Pane 3 - FCM API (Port 8003)
Ctrl+B, "
cd /root/Construction-Hazard-Detection/examples/fcm-api
uvicorn main:app --host 0.0.0.0 --port 8003

# Pane 4 - DB Management API (Port 8005)
Ctrl+B, "
cd /root/Construction-Hazard-Detection/examples/user-management-api
uvicorn main:app --host 0.0.0.0 --port 8005

# Pane 5 - Streaming API (Port 8800)
Ctrl+B, "
cd /root/Construction-Hazard-Detection/examples/streaming-web-api
uvicorn main:app --host 0.0.0.0 --port 8800

# Pane 6 - Main Detection (Terminal output)
Ctrl+B, "
cd /root/Construction-Hazard-Detection
python main.py --config config/test_stream.json
```

**Tmux shortcuts:**
- `Ctrl+B, arrow keys`: Navigate between panes
- `Ctrl+B, D`: Detach dari tmux (services tetap jalan)
- `tmux attach -t hazard_detection`: Re-attach ke session

### 6.4. Monitor GPU Usage

**Buka SSH terminal baru** (jangan di tmux):

```bash
# Watch GPU usage real-time
watch -n 1 nvidia-smi
```

**Yang harus Anda lihat:**
```
GPU-Util: 80-95%  (GPU sedang bekerja keras - BAGUS!)
Memory-Usage: 3-6 GB / 8 GB
Temperature: 60-80°C (normal untuk inference)
```

---

## 📊 STEP 7: TEST PERFORMANCE

### 7.1. Run Performance Benchmark

Buat script test:

```bash
cd /root/Construction-Hazard-Detection
nano test_gpu_performance.py
```

**Paste script ini:**

```python
#!/usr/bin/env python3
import torch
import cv2
import time
from ultralytics import YOLO

def test_gpu_performance():
    print("="*70)
    print("GPU PERFORMANCE TEST - Construction Hazard Detection")
    print("="*70)

    # Check CUDA
    if not torch.cuda.is_available():
        print("❌ ERROR: CUDA not available!")
        return

    print(f"✅ CUDA Available: {torch.cuda.is_available()}")
    print(f"✅ GPU: {torch.cuda.get_device_name(0)}")
    print(f"✅ CUDA Version: {torch.version.cuda}")
    print()

    # Load YOLO model
    print("Loading YOLO11n model...")
    model = YOLO('models/pt/best_yolo11n.pt')
    model.to('cuda')  # Move to GPU
    print("✅ Model loaded on GPU")
    print()

    # Load test video
    video_path = 'tests/videos/test.mp4'
    cap = cv2.VideoCapture(video_path)

    if not cap.isOpened():
        print(f"❌ Cannot open video: {video_path}")
        return

    print(f"Testing with video: {video_path}")

    # Warmup (first inference always slower)
    ret, frame = cap.read()
    if ret:
        _ = model(frame, verbose=False)
        print("✅ Warmup inference done")

    # Reset video
    cap.set(cv2.CAP_PROP_POS_FRAMES, 0)

    # Benchmark
    frame_count = 0
    total_time = 0
    max_frames = 100  # Test 100 frames

    print()
    print(f"Running inference on {max_frames} frames...")
    print("-"*70)

    while frame_count < max_frames:
        ret, frame = cap.read()
        if not ret:
            break

        start_time = time.time()
        results = model(frame, verbose=False)
        inference_time = time.time() - start_time

        total_time += inference_time
        frame_count += 1

        if frame_count % 10 == 0:
            fps = frame_count / total_time
            print(f"Frame {frame_count}: {inference_time*1000:.2f}ms | Avg FPS: {fps:.2f}")

    cap.release()

    # Results
    avg_time = total_time / frame_count
    avg_fps = frame_count / total_time

    print()
    print("="*70)
    print("PERFORMANCE RESULTS")
    print("="*70)
    print(f"Total Frames Processed: {frame_count}")
    print(f"Total Time: {total_time:.2f}s")
    print(f"Average Inference Time: {avg_time*1000:.2f}ms per frame")
    print(f"Average FPS: {avg_fps:.2f}")
    print()

    if avg_fps >= 20:
        print("✅ REAL-TIME CAPABLE! (>20 FPS)")
        print("   Status: SIAP UNTUK KOMPETISI!")
    elif avg_fps >= 10:
        print("⚠️  NEAR REAL-TIME (10-20 FPS)")
        print("   Status: Masih bisa digunakan, tapi kurang optimal")
    else:
        print("❌ NOT REAL-TIME (<10 FPS)")
        print("   Status: Perlu optimasi lebih lanjut")

    print("="*70)

if __name__ == "__main__":
    test_gpu_performance()
```

**Run test:**

```bash
python3 test_gpu_performance.py
```

**Expected output:**

```
======================================================================
GPU PERFORMANCE TEST - Construction Hazard Detection
======================================================================
✅ CUDA Available: True
✅ GPU: NVIDIA GeForce GTX 1070 Ti
✅ CUDA Version: 12.1

Loading YOLO11n model...
✅ Model loaded on GPU

Testing with video: tests/videos/test.mp4
✅ Warmup inference done

Running inference on 100 frames...
----------------------------------------------------------------------
Frame 10: 35.2ms | Avg FPS: 28.4
Frame 20: 33.8ms | Avg FPS: 29.1
Frame 30: 34.5ms | Avg FPS: 28.8
...
Frame 100: 34.1ms | Avg FPS: 29.2

======================================================================
PERFORMANCE RESULTS
======================================================================
Total Frames Processed: 100
Total Time: 3.42s
Average Inference Time: 34.2ms per frame
Average FPS: 29.2

✅ REAL-TIME CAPABLE! (>20 FPS)
   Status: SIAP UNTUK KOMPETISI!
======================================================================
```

### 7.2. Optimasi Jika FPS Masih Kurang

Jika FPS < 20, coba optimasi ini:

**A. Gunakan TensorRT (Nvidia Optimization):**

```bash
# Export YOLO to TensorRT
yolo export model=models/pt/best_yolo11n.pt format=engine device=0

# Update config to use .engine file
# model_path: models/pt/best_yolo11n.engine
```

**B. Reduce Resolution:**

Edit `src/live_stream_detection.py` line 403:

```python
# Dari:
target_size = 640

# Jadi:
target_size = 416  # Faster inference, sedikit turun akurasi
```

**C. Use FP16 (Half Precision):**

```python
# Di YOLO inference call
results = model(frame, half=True, verbose=False)  # FP16 mode
```

---

## 🌐 STEP 8: ACCESS WEB INTERFACE

### 8.1. Port Forwarding dari Windows

**Di Git Bash / PowerShell di Windows**, reconnect SSH dengan port forwarding:

```bash
ssh -p 12345 root@123.45.67.89 \
    -L 8000:localhost:8000 \
    -L 8002:localhost:8002 \
    -L 8003:localhost:8003 \
    -L 8005:localhost:8005 \
    -L 8800:localhost:8800 \
    -L 3000:localhost:3000
```

Semua port API di Vast.ai akan forward ke localhost Windows Anda!

### 8.2. Serve Web Interface di Vast.ai

```bash
# Di SSH Vast.ai
cd /root/Construction-Hazard-Detection/examples/streaming_web/frontend/dist
python3 -m http.server 3000
```

### 8.3. Akses di Browser Windows

Buka browser di Windows Anda:

```
http://localhost:3000
```

Login dengan:
- Username: `user`
- Password: `password`

Sekarang Anda bisa akses web interface yang running di GPU cloud!

---

## 💾 STEP 9: BACKUP & DEPLOYMENT

### 9.1. Save Instance State

Jika Anda ingin save konfigurasi untuk digunakan lagi:

```bash
# Di Vast.ai instance
cd /root
tar -czf hazard_detection_backup.tar.gz Construction-Hazard-Detection

# Download ke Windows
# Di Windows Git Bash:
scp -P 12345 root@123.45.67.89:/root/hazard_detection_backup.tar.gz .
```

### 9.2. Auto-Start Script

Buat startup script untuk start semua services otomatis:

```bash
cd /root/Construction-Hazard-Detection
nano start_all_services.sh
```

**Paste script:**

```bash
#!/bin/bash

echo "Starting Construction Hazard Detection System..."

# Start Redis
redis-server --daemonize yes --bind 127.0.0.1 --port 6379

# Start MySQL
service mysql start

# Wait for services
sleep 5

# Start all APIs in background
cd /root/Construction-Hazard-Detection

# YOLO API
cd examples/YOLO_server_api
nohup python main.py > /var/log/yolo_api.log 2>&1 &

# Violation Record API
cd ../violation-record-api
nohup uvicorn main:app --host 0.0.0.0 --port 8002 > /var/log/violation_api.log 2>&1 &

# FCM API
cd ../fcm-api
nohup uvicorn main:app --host 0.0.0.0 --port 8003 > /var/log/fcm_api.log 2>&1 &

# DB Management API
cd ../user-management-api
nohup uvicorn main:app --host 0.0.0.0 --port 8005 > /var/log/db_api.log 2>&1 &

# Streaming API
cd ../streaming-web-api
nohup uvicorn main:app --host 0.0.0.0 --port 8800 > /var/log/streaming_api.log 2>&1 &

# Wait for APIs to start
sleep 10

echo "All services started!"
echo "Logs available in /var/log/"
```

```bash
chmod +x start_all_services.sh
```

**Usage:**

```bash
./start_all_services.sh
```

---

## 📝 STEP 10: UNTUK KOMPETISI

### 10.1. Checklist Sebelum Kompetisi

- [ ] Vast.ai account sudah top up cukup ($10-20 untuk aman)
- [ ] Test performance sudah >20 FPS
- [ ] Semua services bisa start tanpa error
- [ ] Web interface bisa diakses
- [ ] Video stream source sudah siap (RTSP/File/HTTP)
- [ ] Backup .env dan config files
- [ ] Catat IP dan port SSH instance

### 10.2. Saat Kompetisi

**1. Rent instance 1 jam sebelum kompetisi:**

```bash
# Login Vast.ai > Search > Rent GTX 1070 Ti
```

**2. Quick setup (5-10 menit):**

```bash
# SSH ke instance
ssh -p PORT root@IP

# Clone & setup
git clone https://github.com/yihong1120/Construction-Hazard-Detection.git
cd Construction-Hazard-Detection

# Restore dari backup (jika ada)
# scp backup dari Windows atau download dari cloud

# Install dependencies
pip3 install -r requirements-gpu.txt

# Download models
huggingface-cli download yihong1120/Construction-Hazard-Detection-YOLO11 \
    --repo-type model --include "models/pt/*.pt" --local-dir .

# Setup database & Redis
./setup_database.sh

# Start all services
./start_all_services.sh
```

**3. Start detection:**

```bash
# Update config/test_stream.json dengan video URL kompetisi
nano config/test_stream.json

# Run main detection
python main.py --config config/test_stream.json
```

**4. Monitor:**

```bash
# Terminal 1: GPU monitoring
watch -n 1 nvidia-smi

# Terminal 2: Service logs
tail -f /var/log/*.log

# Terminal 3: Main detection output
# (sudah running dari step 3)
```

### 10.3. Troubleshooting Kompetisi

**Jika FPS tiba-tiba drop:**

```bash
# Check GPU usage
nvidia-smi

# Restart services
pkill -f python
./start_all_services.sh
python main.py --config config/test_stream.json
```

**Jika out of memory:**

```bash
# Clear GPU cache
python3 << EOF
import torch
torch.cuda.empty_cache()
EOF

# Reduce batch size atau resolution
```

**Jika connection loss:**

```bash
# Reconnect SSH dengan port forwarding
ssh -p PORT root@IP -L 8000:localhost:8000 -L 3000:localhost:3000
```

---

## 🎯 EXPECTED PERFORMANCE

Dengan GTX 1070 Ti, Anda seharusnya mendapatkan:

| Model | Resolution | FPS | Latency | Akurasi |
|-------|-----------|-----|---------|---------|
| YOLO11n | 640x640 | 28-35 | 28-35ms | ⭐⭐⭐ |
| YOLO11n | 416x416 | 40-50 | 20-25ms | ⭐⭐ |
| YOLO11s | 640x640 | 20-25 | 40-50ms | ⭐⭐⭐⭐ |
| YOLO11m | 640x640 | 12-18 | 55-80ms | ⭐⭐⭐⭐⭐ |

**Rekomendasi untuk kompetisi:**
- **YOLO11n @ 640x640**: Balance terbaik (30 FPS + akurasi bagus)
- **YOLO11n @ 416x416**: Jika butuh FPS maksimal (40+ FPS)
- **YOLO11s @ 640x640**: Jika akurasi lebih penting dari FPS

---

## 💡 TIPS & TRICKS

### Hemat Biaya

1. **Pause instance saat tidak digunakan** (tidak bisa di Vast.ai, tapi bisa destroy & recreate cepat)
2. **Gunakan spot instances** (lebih murah, tapi bisa di-interrupt)
3. **Test di local dulu**, baru rent GPU saat sudah yakin setup benar

### Maximize Performance

1. **Gunakan TensorRT** untuk inference 2x lebih cepat
2. **Set CUDA_VISIBLE_DEVICES=0** untuk force GPU 0
3. **Close browser tabs** yang tidak perlu untuk hemat bandwidth
4. **Use SSD storage** saat pilih instance (lebih cepat I/O)

### Stability

1. **Use tmux/screen** agar services tidak mati saat SSH disconnect
2. **Setup auto-restart** untuk services yang crash
3. **Monitor logs** secara real-time saat kompetisi
4. **Backup config** sebelum edit apapun

---

## 📞 SUPPORT & RESOURCES

- **Vast.ai Discord**: https://discord.gg/vastai
- **Vast.ai Docs**: https://vast.ai/docs
- **YOLO Ultralytics**: https://docs.ultralytics.com
- **Project GitHub**: https://github.com/yihong1120/Construction-Hazard-Detection

---

## ✅ QUICK REFERENCE

### Start Services (One Command)

```bash
./start_all_services.sh && python main.py --config config/test_stream.json
```

### Check Status

```bash
# GPU
nvidia-smi

# Services
ps aux | grep python
ps aux | grep uvicorn

# Logs
tail -f /var/log/*.log
```

### Stop All

```bash
pkill -f python
pkill -f uvicorn
redis-cli shutdown
service mysql stop
```

---

**Dibuat untuk kompetisi Construction Hazard Detection**
**Target: Real-time detection (20-30 FPS) dengan GPU GTX 1070 Ti**
**Estimasi biaya: $1-3 untuk seluruh kompetisi**

**GOOD LUCK! 🚀**
