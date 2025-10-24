# 🔐 Panduan Login ke Visionnaire Web App

## 📋 Credentials Login

Setelah reset password, gunakan credentials berikut:

```
Username: user
Password: password
```

---

## 🌐 MASALAH: Tidak Bisa Login di https://visionnaire-cda17.web.app

**Penyebab:** Web app di Firebase tidak bisa connect ke `http://127.0.0.1:8005` karena:
- 127.0.0.1 adalah localhost (hanya bisa diakses dari komputer Anda)
- Browser security (CORS) block koneksi dari domain eksternal ke localhost

---

## ✅ SOLUSI 1: Gunakan Ngrok (RECOMMENDED)

Ngrok membuat tunnel dari internet ke localhost, sehingga Firebase app bisa connect.

### Langkah-langkah:

1. **Download Ngrok:**
   - Download dari: https://ngrok.com/download
   - Extract `ngrok.exe` ke folder project

2. **Jalankan Ngrok:**
   ```bash
   cd D:\Construction-Hazard-Detection
   ngrok http 8005
   ```

3. **Copy URL Ngrok:**
   - Setelah running, Anda akan lihat URL seperti:
   ```
   Forwarding  https://abc123xyz.ngrok-free.app -> http://localhost:8005
   ```
   - **COPY URL HTTPS tersebut!**

4. **Konfigurasi di Visionnaire:**
   - Buka: https://visionnaire-cda17.web.app/
   - Tekan F12 untuk buka Developer Tools
   - Masuk ke tab **Console**
   - Jalankan command (ganti URL dengan URL ngrok Anda):
   ```javascript
   localStorage.setItem('MANAGEMENT_API', 'https://abc123xyz.ngrok-free.app');
   ```
   - Refresh page (F5)

5. **Login:**
   - Username: `user`
   - Password: `password`

### ⚠️ Catatan Ngrok:
- URL ngrok berubah setiap restart (kecuali pakai ngrok pro/paid)
- Keep terminal ngrok tetap running
- Allow Windows Firewall jika diminta

---

## ✅ SOLUSI 2: Gunakan Web Interface Lokal

Jika tidak mau pakai ngrok, gunakan web interface lokal yang sudah ada di project.

### Opsi A: Via Port 8800 (Streaming API)

1. Pastikan Streaming API running (port 8800)
2. Buka browser: **http://localhost:8800**
3. Login dengan credentials di atas

### Opsi B: Serve Static Files

1. Jalankan batch file yang sudah dibuat:
   ```bash
   start_local_web.bat
   ```

2. Buka browser: **http://localhost:3000**

3. Login dengan credentials di atas

---

## ✅ SOLUSI 3: Akses API Docs Langsung

Untuk testing tanpa web UI:

1. Buka: **http://localhost:8005/docs**
2. Scroll ke endpoint `/auth/login`
3. Click "Try it out"
4. Masukkan JSON:
   ```json
   {
     "username": "user",
     "password": "password"
   }
   ```
5. Click "Execute"
6. Copy `access_token` dari response
7. Gunakan token untuk access endpoint lain

---

## 🔧 Troubleshooting

### Error: "Failed to connect to API"
- **Cek API running:**
  ```bash
  netstat -ano | grep 8005
  ```
  Harus ada output yang menunjukkan port 8005 LISTENING

- **Start API jika belum running:**
  ```bash
  cd examples/db_management
  uvicorn main:app --host 127.0.0.1 --port 8005
  ```

### Error: "Invalid credentials"
- **Reset password:**
  ```bash
  python reset_user_password.py
  ```

### Error: "CORS policy blocked"
- Gunakan Solusi 1 (Ngrok)
- Atau gunakan Solusi 2 (Web interface lokal)

### Ngrok: "Session Expired"
- Free plan ngrok memiliki batas waktu
- Restart ngrok untuk mendapat URL baru
- Update localStorage dengan URL ngrok yang baru

---

## 📝 Quick Reference

| Service | Port | URL Local | Purpose |
|---------|------|-----------|---------|
| DB Management API | 8005 | http://localhost:8005 | User auth, stream config |
| Streaming API | 8800 | http://localhost:8800 | Video streaming, websocket |
| YOLO Detection API | 8000 | http://localhost:8000 | Object detection |
| Redis | 6379 | localhost:6379 | Caching |
| MySQL (XAMPP) | 3306 | localhost:3306 | Database |

---

## 🎯 Rekomendasi

Untuk **demo dan development**, gunakan:
- **Ngrok** (Solusi 1) - jika ingin akses dari device lain atau share dengan orang lain
- **Localhost** (Solusi 2) - jika hanya untuk development di komputer sendiri

Untuk **production**, sebaiknya:
- Deploy API ke cloud (Heroku, AWS, GCP, dll)
- Update Visionnaire Firebase config dengan URL production API
- Gunakan domain custom dengan SSL certificate

---

Dibuat: 2025-10-14
