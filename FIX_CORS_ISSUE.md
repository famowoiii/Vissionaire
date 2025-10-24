# ✅ SOLUSI: Failed to Fetch Error

## 🔍 Diagnosis

Login API **BEKERJA DENGAN BAIK** melalui curl/backend.

Problem: Browser tidak bisa akses karena **CORS policy** dan **localhost limitation**.

## ✅ SOLUSI: Gunakan Ngrok (WAJIB untuk Firebase App)

Karena Anda menggunakan **https://visionnaire-cda17.web.app** (Firebase),
Anda HARUS menggunakan Ngrok untuk expose localhost API ke internet.

### Langkah-langkah:

#### 1. Download & Install Ngrok

```bash
# Download dari https://ngrok.com/download
# Extract ngrok.exe ke D:\Construction-Hazard-Detection\
```

#### 2. Jalankan Ngrok untuk Port 8005

Buka PowerShell/CMD baru:

```powershell
cd D:\Construction-Hazard-Detection
.\ngrok.exe http 8005
```

Anda akan melihat output seperti:

```
Session Status                online
Account                       your-email (Plan: Free)
Version                       3.x.x
Region                        United States (us)
Forwarding                    https://abc123xyz.ngrok-free.app -> http://localhost:8005
```

**COPY URL HTTPS tersebut!**
Contoh: `https://abc123xyz.ngrok-free.app`

#### 3. Konfigurasi Visionnaire Web App

1. Buka browser: **https://visionnaire-cda17.web.app/login**

2. Tekan **F12** untuk buka Developer Console

3. Masuk ke tab **Console**

4. Paste dan jalankan command ini (ganti URL dengan URL ngrok Anda):

```javascript
// Set API URL ke ngrok
localStorage.setItem('MANAGEMENT_API', 'https://abc123xyz.ngrok-free.app');

// Verify it's saved
console.log('API URL:', localStorage.getItem('MANAGEMENT_API'));
```

5. **Refresh page** (F5 atau Ctrl+R)

#### 4. Login!

Sekarang form login akan connect ke ngrok URL.

Login dengan credentials:
- **Username:** `user`
- **Password:** `password`

---

## 📌 PENTING:

### Ngrok URL Berubah Setiap Restart

URL ngrok seperti `https://abc123xyz.ngrok-free.app` akan **berubah** setiap kali Anda restart ngrok.

Jika Anda restart ngrok:
1. Copy URL baru
2. Update localStorage di browser:
   ```javascript
   localStorage.setItem('MANAGEMENT_API', 'https://NEW-URL.ngrok-free.app');
   ```
3. Refresh page

### Keep Ngrok Running

**Jangan tutup terminal ngrok!** Biarkan tetap running selama Anda menggunakan web app.

### Windows Firewall

Jika Windows Firewall muncul, klik **"Allow access"**.

---

## 🎯 Alternative: Ngrok Auth Token (Optional)

Untuk unlimited connections dan faster speeds:

1. Sign up di https://ngrok.com (gratis)
2. Get your authtoken dari dashboard
3. Run:
   ```bash
   ngrok config add-authtoken YOUR_TOKEN_HERE
   ```

---

## 🧪 Verify Ngrok Working

Test di browser biasa (bukan Visionnaire):

```
https://YOUR-NGROK-URL.ngrok-free.app/docs
```

Anda harus bisa lihat Swagger API docs.

---

## ❌ Troubleshooting

### "ERR_CONNECTION_REFUSED"
- Pastikan ngrok masih running
- Pastikan DB Management API (port 8005) masih running

### "Invalid Host Header"
- Normal untuk ngrok free plan
- Klik "Visit Site" button yang muncul

### "Session Expired"
- Restart ngrok untuk get URL baru
- Update localStorage dengan URL baru

### Login Masih Gagal
- Check localStorage: `console.log(localStorage.getItem('MANAGEMENT_API'))`
- Pastikan URL ngrok correct (ada https:// dan tidak ada trailing slash)
- Hard refresh: Ctrl+Shift+R

---

## 📝 Quick Commands Reference

```powershell
# Start ngrok
cd D:\Construction-Hazard-Detection
.\ngrok.exe http 8005

# Set in browser console (ganti URL)
localStorage.setItem('MANAGEMENT_API', 'https://YOUR-URL.ngrok-free.app');

# Verify
localStorage.getItem('MANAGEMENT_API');

# Clear (if needed)
localStorage.removeItem('MANAGEMENT_API');
```

---

## ✨ After Login Success

Setelah login berhasil, Anda akan dapat:
- ✅ Manage stream configurations
- ✅ View live camera feeds
- ✅ Monitor violation alerts
- ✅ Access all features

---

Created: 2025-10-14
