# 🔧 FIX: Stream Menampilkan Data Lama (puki/pukimak)

## 📋 MASALAH
Ketika membuat site baru "coba_guys" dan "Test Site", stream yang muncul malah menampilkan nama lama "puki" dengan kamera "pukimak".

## 🔍 PENYEBAB
Redis cache masih menyimpan data lama dari testing sebelumnya.

## ✅ SOLUSI SUDAH DILAKUKAN

### 1. Redis Cache Dibersihkan ✅
```cmd
redis-cli.exe FLUSHALL
```
Cache lama sudah dihapus!

### 2. Database Dicek ✅
Database sudah benar:
- Site "Test Site" (ID: 1) → Stream "1"
- Site "Coba_Guys" (ID: 2) → Stream "Proyek"

---

## 🚀 LANGKAH SELANJUTNYA

### Step 1: Restart Streaming API

**Tutup terminal Streaming API yang sedang berjalan**, lalu buka terminal baru:

```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

### Step 2: Jalankan Detection dengan Konfigurasi yang Benar

Buka terminal baru:

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

### Step 3: Refresh Browser Visionnaire

1. Buka Visionnaire: https://visionnaire-cda17.web.app/login
2. **Hard refresh**: `Ctrl + Shift + R` atau `Ctrl + F5`
3. Login dengan: `user` / `password`
4. Buka menu **Live Stream**
5. Sekarang seharusnya muncul:
   - **Test Site** → Stream "1"
   - **Coba_Guys** → Stream "Proyek"

---

## 📝 JIKA MASIH MUNCUL DATA LAMA

### Option 1: Clear Browser Cache

**Chrome/Edge:**
1. Press `F12`
2. Right-click pada Reload button
3. Pilih **"Empty Cache and Hard Reload"**

**Firefox:**
1. Press `Ctrl + Shift + Delete`
2. Pilih "Cached Web Content"
3. Klik Clear

### Option 2: Clear localStorage di Browser

Press `F12` → Console → Paste:
```javascript
localStorage.clear();
location.reload();
```

Lalu configure ulang localStorage:
```javascript
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
location.reload();
```

### Option 3: Verify Redis Benar-Benar Kosong

```cmd
redis-cli.exe KEYS "*"
```

Harusnya return: `(empty array)` atau tidak ada output.

Jika masih ada keys lama:
```cmd
redis-cli.exe FLUSHALL
```

---

## 🎯 CHECKLIST LENGKAP

```
□ Redis cache sudah dibersihkan (FLUSHALL) ✅
□ Database memiliki site yang benar ✅
□ Tutup dan restart Streaming API
□ Jalankan detection (main.py)
□ Hard refresh browser (Ctrl + Shift + R)
□ Clear localStorage jika perlu
□ ✅ Stream sekarang menampilkan data yang benar!
```

---

## 📊 EXPECTED RESULT

Setelah langkah di atas, di Visionnaire Live Stream seharusnya muncul:

**Site: Test Site**
- Stream: "1"
- Video: test.mp4

**Site: Coba_Guys**
- Stream: "Proyek"
- Video: test.mp4

---

## 🔧 TROUBLESHOOTING

### Stream masih tidak muncul?

**Check detection running:**
```cmd
REM Di terminal detection, pastikan ada output seperti:
Processing frame...
Sending to Redis: Test Site / 1
```

**Check Streaming API logs:**
```cmd
REM Di terminal Streaming API, pastikan ada:
WebSocket connection established
Sending frame to client
```

**Check Redis memiliki frame baru:**
```cmd
redis-cli.exe KEYS "*"
```

Harusnya muncul key seperti:
```
stream_frame:VGVzdCBTaXRl|MQ==
```

(Base64 untuk "Test Site" dan "1")

---

## 💡 TIPS

**Untuk mengubah nama stream yang lebih jelas:**

Update database via SQL atau Visionnaire web interface untuk mengubah stream_name dari "1" menjadi nama yang lebih deskriptif seperti "Local Video Demo".

---

## 📞 SUMMARY

**Root Cause:** Redis cache menyimpan data lama (puki/pukimak)

**Fix:**
1. ✅ Redis FLUSHALL (sudah dilakukan)
2. Restart Streaming API
3. Restart detection (main.py)
4. Hard refresh browser

**Result:** Stream sekarang akan menampilkan "Test Site" dan "Coba_Guys" yang benar!
