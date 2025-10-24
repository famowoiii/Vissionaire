# Setup Ngrok untuk Akses API dari Visionnaire Firebase

## Langkah 1: Download & Install Ngrok

1. Download Ngrok dari: https://ngrok.com/download
2. Extract file `ngrok.exe` ke folder `D:\Construction-Hazard-Detection\`
3. (Optional) Sign up di ngrok.com untuk mendapat authtoken gratis

## Langkah 2: Jalankan Ngrok untuk DB Management API (Port 8005)

Buka terminal baru dan jalankan:

```bash
cd D:\Construction-Hazard-Detection
ngrok http 8005
```

Anda akan melihat output seperti:
```
Forwarding  https://abc123xyz.ngrok-free.app -> http://localhost:8005
```

**COPY URL HTTPS tersebut!** (contoh: `https://abc123xyz.ngrok-free.app`)

## Langkah 3: Konfigurasi Visionnaire Web App

1. Buka https://visionnaire-cda17.web.app/
2. Buka **Developer Tools** (F12)
3. Masuk ke tab **Console**
4. Jalankan command ini (ganti URL dengan URL ngrok Anda):

```javascript
localStorage.setItem('API_URL', 'https://abc123xyz.ngrok-free.app');
```

5. Refresh page (F5)

## Langkah 4: Login dengan Credentials

Sekarang coba login dengan:
- **Username:** `user`
- **Password:** `password`

---

## ⚠️ CATATAN PENTING:

1. **Ngrok URL berubah setiap restart** (kecuali pakai ngrok pro)
2. **Firewall warning:** Ngrok akan meminta izin firewall Windows - ALLOW
3. **Keep terminal ngrok tetap running** - jangan ditutup!
4. **CORS sudah tidak masalah** karena ngrok menyediakan URL publik dengan HTTPS

---

## Troubleshooting:

### Error "Failed to connect"
- Pastikan ngrok masih running
- Pastikan DB Management API (port 8005) masih running
- Check URL ngrok di localStorage sudah benar

### Error "Invalid credentials"
- Credentials: username=`user`, password=`password`
- Jika masih gagal, jalankan: `python reset_user_password.py`

### Ngrok "Too many connections"
- Restart ngrok
- Atau sign up untuk akun ngrok gratis (unlimited connections)
