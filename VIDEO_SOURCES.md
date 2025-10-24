# 🎥 Sumber Video/Stream untuk Demo Sistem Deteksi Bahaya Konstruksi

## 📡 A. Live Stream Publik (Real-time CCTV)

### 1. CamStreamer Construction Sites ⭐ RECOMMENDED

#### Logan Utah Library Construction
```
https://www.camstreamer.com/live/stream/40491-logan-utah-library-construction
```
- Lokasi: Logan, Utah, USA
- Tipe: Live streaming konstruksi perpustakaan
- Kualitas: HD
- Status: Public access

#### Kakegawa Castle Tower Construction
```
https://www.camstreamer.com/live/stream/42263-kakegawa-castle-tower-construction
```
- Lokasi: Kakegawa, Jepang
- Tipe: Konstruksi menara kastil
- Kualitas: HD
- Status: Public access

#### Albertson Hall Construction Camera
```
https://www.camstreamer.com/live/stream/33802010-albertson-hall-construction-camera
```
- Lokasi: USA
- Tipe: Konstruksi gedung universitas
- Kualitas: HD
- Status: Public access

#### NC State Facilities Live Stream
```
https://www.camstreamer.com/live/stream/145096208-nc-state-facilities-live-stream
```
- Lokasi: North Carolina State, USA
- Tipe: Multi-angle construction views
- Kualitas: HD
- Status: Public access

### 2. Taiwan Public CCTV
```
https://cctv1.kctmc.nat.gov.tw/6e559e58/
```
- Lokasi: Taiwan
- Tipe: CCTV jalan umum (kadang menangkap aktivitas konstruksi)
- Kualitas: SD-HD
- Status: Public access

### 3. Lebih Banyak CamStreamer
Kunjungi: https://camstreamer.com/live/streams/3-buildings-and-constructions
- 50+ konstruksi site dari berbagai negara
- Gratis, public access
- Real-time streaming

---

## 📹 B. Video File untuk Download (Gratis & Royalty-Free)

### 1. Pexels ⭐ HIGHLY RECOMMENDED

#### Construction Workers General
https://www.pexels.com/search/videos/construction%20workers/
- 2,000+ video gratis
- Banyak ada pekerja tanpa helm/vest (bagus untuk testing deteksi)
- Format: MP4, HD/4K
- License: Gratis untuk komersial

#### Safety Helmet Videos
https://www.pexels.com/search/videos/safety%20helmet/
- 10,000+ video gratis
- Ada yang pakai helm, ada yang tidak
- Cocok untuk testing detection accuracy

#### Safety Vest Videos
https://www.pexels.com/search/videos/safety%20vest/
- 2,626+ video gratis
- Berbagai kondisi: outdoor, indoor, siang, malam
- Kualitas HD-4K

**Cara Download dari Pexels:**
1. Klik link
2. Pilih video yang relevan
3. Klik tombol "Download"
4. Pilih resolusi (1920x1080 atau 4K)
5. Save ke komputer Anda

### 2. Pixabay

#### Construction Site Videos
https://pixabay.com/videos/search/construction%20site/
- 1,000+ video gratis
- No attribution required
- Format: MP4

#### Construction Workers Videos
https://pixabay.com/videos/search/construction%20workers/
- 500+ video gratis
- Berbagai scenario: outdoor, climbing, welding, etc.

**Cara Download dari Pixabay:**
1. Klik link
2. Pilih video
3. Klik "Free Download"
4. Pilih kualitas (Medium/Large/Original)
5. Download tanpa registrasi

### 3. Vecteezy

#### Construction Site Safety
https://www.vecteezy.com/free-videos/construction-site-safety
- 4,481 video gratis
- Fokus pada safety equipment
- Banyak contoh violations untuk testing

**Cara Download:**
1. Buat akun gratis (optional, tapi recommended)
2. Search video yang diinginkan
3. Download (ada batasan per hari untuk free account)

---

## 🎬 C. Video Sample untuk Testing Spesifik

### Skenario Testing yang Disarankan:

#### 1. No Helmet Detection
Cari video dengan kata kunci:
- "construction worker no helmet"
- "construction site accident"
- "unsafe construction practices"

**Contoh search Pexels:**
https://www.pexels.com/search/videos/construction%20worker%20no%20helmet/

#### 2. No Safety Vest Detection
Cari video dengan kata kunci:
- "construction worker casual clothes"
- "construction site visitor"

#### 3. Near Machinery Detection
Cari video dengan kata kunci:
- "excavator construction site"
- "crane construction site"
- "bulldozer construction"

**Contoh search Pixabay:**
https://pixabay.com/videos/search/excavator%20construction/

#### 4. Restricted Area Detection
Cari video dengan:
- Traffic cones visible
- Barrier tape
- Restricted zone signs

---

## 🎯 D. Cara Menggunakan Video Sumber

### Untuk Live Stream URL:
```json
{
  "video_url": "https://www.camstreamer.com/live/stream/40491-logan-utah-library-construction",
  "site": "Logan Library",
  "stream_name": "Live Demo Stream"
}
```

### Untuk Video File Lokal:
1. Download video dari Pexels/Pixabay
2. Simpan ke folder, misal: `D:/videos/construction-demo.mp4`
3. Gunakan path absolut:
```json
{
  "video_url": "D:/videos/construction-demo.mp4",
  "site": "Test Site",
  "stream_name": "Local Video Demo"
}
```

### Untuk YouTube Video:
```json
{
  "video_url": "https://www.youtube.com/watch?v=VIDEO_ID",
  "site": "YouTube Demo",
  "stream_name": "YouTube Construction"
}
```

**Note:** YouTube memerlukan library `yt-dlp` atau `pafy`. Install dengan:
```bash
pip install yt-dlp
```

---

## ⚠️ Catatan Penting

### Hak Cipta & Lisensi:
- ✅ **Pexels**: Gratis untuk komersial, tidak perlu atribusi
- ✅ **Pixabay**: Gratis untuk komersial, tidak perlu atribusi
- ✅ **Vecteezy**: Gratis dengan atribusi (untuk free account)
- ✅ **CamStreamer**: Public webcams, untuk personal/educational use
- ⚠️ **YouTube**: Tergantung license video, gunakan yang Creative Commons

### Performa:
- **Live Stream**: Butuh internet stabil, kadang ada lag
- **Video Lokal**: Performa terbaik, tidak ada lag
- **YouTube**: Butuh internet, kadang ada rate limiting

### Rekomendasi untuk Testing:
1. **Mulai dengan video lokal** (download dari Pexels) - paling stabil
2. **Test dengan live stream** - untuk real-time experience
3. **Cari video dengan variasi** - ada yang pakai helm, ada yang tidak, ada mesin, dll

---

## 📚 Resource Tambahan

### OSHA Safety Videos (Educational):
https://www.osha.gov/vtools/construction
- Video resmi tentang hazard construction
- Cocok untuk validasi model

### EarthCam Construction:
https://www.earthcam.net/construction/
- Network webcam konstruksi global
- Beberapa public, beberapa perlu login

---

## 🔍 Tips Mencari Video Bagus:

1. **Gunakan keyword spesifik**:
   - "construction worker without helmet"
   - "unsafe construction practices"
   - "construction site hazard"

2. **Filter by duration**: Pilih video 30 detik - 2 menit untuk testing cepat

3. **Pilih HD/4K**: Deteksi AI lebih akurat dengan kualitas tinggi

4. **Variety is key**: Download 5-10 video dengan skenario berbeda

---

Dibuat: 2025-01-14
Update terakhir: 2025-01-14
