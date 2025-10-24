# 🔧 CARA CONFIG API ENDPOINTS DI VISIONNAIRE

## ❗ MASALAH:
Setelah run `ULTIMATE_START.bat`, API endpoints di Visionnaire masih pakai default, bukan localhost.

## 🎯 SOLUSI: Copy-Paste ke Browser Console

### **📋 LANGKAH-LANGKAH:**

---

### **STEP 1: Buka Visionnaire & Login**

1. Buka: https://visionnaire-cda17.web.app/login
2. Login dengan:
   - Username: `user`
   - Password: `password`

---

### **STEP 2: Buka Browser Console**

Tekan salah satu shortcut ini:

**Windows:**
- `F12` (semua browser)
- `Ctrl + Shift + J` (Chrome, Edge)
- `Ctrl + Shift + K` (Firefox)

**Mac:**
- `Cmd + Option + J` (Chrome, Edge)
- `Cmd + Option + K` (Firefox)

Lalu pilih tab **"Console"**

---

### **STEP 3: Copy & Paste Script Ini**

Copy **SELURUH** script di bawah ini, paste ke Console, lalu tekan **Enter**:

```javascript
localStorage.clear();
localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004');
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('FILE_MANAGEMENT_API_URL', 'http://127.0.0.1:8005');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
console.log('✅ ALL 7 API endpoints configured!');
console.log('🔄 Refresh page to apply changes...');
```

---

### **STEP 4: Refresh Page**

Setelah paste script di Console, tekan:
- **F5** (Windows)
- **Ctrl + R** (Windows)
- **Cmd + R** (Mac)

---

### **STEP 5: Verify**

1. Go to **Settings** (gear icon ⚙️)
2. Scroll ke **API Endpoint Configuration**
3. Verify semua endpoints sudah terisi:

```
✅ YOLO Detection API:      http://127.0.0.1:8000
✅ Violation Records API:   http://127.0.0.1:8002
✅ FCM Notification API:    http://127.0.0.1:8003
✅ Chat API:                http://127.0.0.1:8004
✅ DB Management API:       http://127.0.0.1:8005
✅ File Management API:     http://127.0.0.1:8005
✅ Streaming Web API:       http://127.0.0.1:8800
```

---

## 🎬 VISUAL GUIDE:

### **Browser Console - Chrome:**

```
1. Login ke Visionnaire
2. Tekan F12
3. Pilih tab "Console"
4. Paste script
5. Tekan Enter
6. Lihat output:
   ✅ ALL 7 API endpoints configured!
   🔄 Refresh page to apply changes...
7. Tekan F5
8. DONE!
```

---

## 🚀 ALTERNATIVE: Use Auto-Config HTML Page

Jika Anda run `ULTIMATE_START.bat`, browser otomatis buka file `visionnaire_config.html`.

**Di page tersebut:**
1. Klik tombol **"🚀 Open Visionnaire"**
2. Login
3. Tekan **F12** (buka Console)
4. Klik tombol **"📋 Copy"** di instruction page
5. Paste di Console Visionnaire
6. Tekan **Enter**
7. Tekan **F5** (refresh)
8. **DONE!**

---

## 📝 PENJELASAN:

### **Kenapa Tidak Otomatis?**

Browser security **mencegah** JavaScript dari domain berbeda mengakses localStorage:

- File HTML lokal: `file:///D:/Construction-Hazard-Detection/visionnaire_config.html`
- Visionnaire web: `https://visionnaire-cda17.web.app`

Karena domain berbeda, localStorage tidak bisa diakses cross-domain.

### **Solusi:**

**Copy-paste ke Console** adalah cara **tercepat dan termudah** untuk configure localStorage dari domain yang sama (Visionnaire).

---

## 🎯 KESIMPULAN:

**Total waktu:** 30 detik saja!

1. ✅ Login Visionnaire (10 detik)
2. ✅ Buka Console F12 (2 detik)
3. ✅ Paste script (5 detik)
4. ✅ Refresh page (2 detik)
5. ✅ **DONE!** (semua endpoints configured)

**No manual input needed!**
**Just copy-paste ONE script!**

---

## 🔗 QUICK REFERENCE:

### **Script (Copy This):**

```javascript
localStorage.clear();localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');localStorage.setItem('CHAT_API_URL', 'http://127.0.0.1:8004');localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');localStorage.setItem('FILE_MANAGEMENT_API_URL', 'http://127.0.0.1:8005');localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');console.log('✅ ALL 7 API endpoints configured!');console.log('🔄 Refresh page to apply changes...');
```

*(One-line version untuk quick copy-paste)*

---

**Selamat! API endpoints Anda sudah configured! 🎉**
