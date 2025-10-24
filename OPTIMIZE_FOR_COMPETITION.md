# ⚡ OPTIMASI UNTUK KOMPETISI REAL-TIME

## 🚨 MASALAH SAAT INI:

- CPU: Intel (dengan integrated GPU Intel UHD 600)
- PyTorch: CPU-only (2.7.1+cpu)
- Performa: ~10 detik untuk 1 detik video (SANGAT LAMBAT)
- Target: Real-time detection untuk kompetisi

## ❌ KENAPA LAMBAT:

1. **Tidak ada GPU NVIDIA** (Intel UHD tidak support CUDA)
2. **YOLO inference di CPU** sangat lambat
3. **Capture interval** masih terlalu sering
4. **Frame resolution** masih terlalu besar

## ✅ SOLUSI TANPA GPU:

### **OPSI A: Optimasi Maksimal di CPU Anda**

1. **Gunakan Model Terkecil (YOLO11n)**
   ```python
   # Sudah di-set di config: model_key = "yolo11n"
   ```

2. **Turunkan Resolusi Lebih Agresif**

   Edit `D:\Construction-Hazard-Detection\src\live_stream_detection.py` line 403:

   ```python
   # Dari:
   target_size = 640

   # Jadi:
   target_size = 320  # atau bahkan 256 untuk lebih cepat
   ```

3. **Skip Lebih Banyak Frame**

   Edit `D:\Construction-Hazard-Detection\main.py` line 339:

   ```python
   # Dari:
   streaming_capture = StreamCapture(stream_url=video_url, capture_interval=30)

   # Jadi:
   streaming_capture = StreamCapture(stream_url=video_url, capture_interval=2)  # hanya 2 detik, tapi proses 1 frame saja
   ```

4. **Disable Tracking (Hemat CPU)**

   Tracking konsumsi CPU banyak. Kalau tidak butuh, disable.

5. **Use INT8 Quantization**

   Convert model ke INT8 untuk inference lebih cepat:
   ```bash
   # Export YOLO11 ke ONNX INT8
   yolo export model=models/pt/best_yolo11n.pt format=onnx int8=True
   ```

### **OPSI B: Sewa Cloud GPU** ⭐ RECOMMENDED untuk Kompetisi

Untuk kompetisi, **sewa cloud GPU** lebih murah daripada beli GPU:

**Google Colab Pro:**
- $10/bulan
- GPU NVIDIA T4 atau A100
- Real-time inference 20-30 FPS

**AWS EC2 G4dn:**
- ~$0.5/jam
- GPU NVIDIA T4
- Hanya bayar saat pakai

**Paperspace Gradient:**
- Mulai gratis (limited)
- GPU NVIDIA RTX series

**Setup:**
1. Upload code ke cloud
2. Install PyTorch dengan CUDA
3. Run detection di cloud
4. Stream hasil via WebSocket

### **OPSI C: Pakai Google Colab (GRATIS)**

Colab gratis dapat GPU T4, cukup untuk testing:

1. Upload project ke Google Drive
2. Buka di Colab
3. Enable GPU di Runtime → Change runtime type
4. Install dependencies
5. Run detection

**Performa dengan GPU T4:**
- YOLO11n: ~30 FPS (real-time!)
- YOLO11s: ~20 FPS
- YOLO11m: ~15 FPS

## 📊 ESTIMASI PERFORMA:

| Setup | Hardware | FPS | Latency | Real-time? |
|-------|----------|-----|---------|------------|
| Current | CPU Intel | 0.1 | 10s | ❌ NO |
| Optimized CPU | CPU Intel | 0.3-0.5 | 2-3s | ❌ NO |
| Google Colab | GPU T4 | 25-30 | 33-40ms | ✅ YES |
| Cloud GPU | GPU A100 | 60-80 | 12-16ms | ✅ YES |

## 🎯 REKOMENDASI UNTUK KOMPETISI:

**Opsi Terbaik:**
1. **Upload ke Google Colab** (GRATIS, setup 30 menit)
2. **Atau sewa AWS GPU** ($5-10 untuk 1 hari kompetisi)

**Jangan coba:**
- ❌ Pakai CPU Intel untuk real-time (tidak akan bisa)
- ❌ Beli GPU baru (terlalu mahal, $300-1000)

**Langkah Cepat:**
1. Buat akun Google Colab
2. Upload project folder
3. Install PyTorch dengan GPU
4. Test inference speed
5. Kalau OK, pakai untuk kompetisi

## 🚀 QUICK START: Google Colab Setup

```python
# 1. Di Colab notebook
!git clone https://github.com/your-repo/Construction-Hazard-Detection.git
%cd Construction-Hazard-Detection

# 2. Install dependencies
!pip install -r requirements.txt

# 3. Download YOLO weights
!hf download yihong1120/Construction-Hazard-Detection-YOLO11 --repo-type model --include "models/pt/*.pt" --local-dir .

# 4. Test inference
import torch
print(f'CUDA available: {torch.cuda.is_available()}')
print(f'GPU: {torch.cuda.get_device_name(0)}')

# 5. Run detection
!python main.py --config config/test_stream.json
```

**Dengan GPU, Anda bisa dapat 20-30 FPS!**

---

Created: 2025-10-14
