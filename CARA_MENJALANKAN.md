# 🚀 CARA MENJALANKAN APLIKASI

## ⚠️ JIKA DOUBLE-CLICK .BAT TIDAK BEKERJA

Gunakan salah satu metode di bawah ini:

---

## 🎯 METHOD 1: Via Command Prompt (RECOMMENDED)

### Step 1: Buka Command Prompt

**Cara 1 - Via File Explorer:**
1. Buka folder `D:\Construction-Hazard-Detection`
2. Di address bar, ketik: `cmd` lalu Enter
3. Command Prompt akan terbuka di folder yang benar

**Cara 2 - Via Start Menu:**
1. Tekan `Win + R`
2. Ketik: `cmd`
3. Enter
4. Ketik: `cd D:\Construction-Hazard-Detection`

### Step 2: Jalankan Script

```cmd
RUN_STARTUP.cmd
```

Atau langsung:
```cmd
cmd /c RUN_STARTUP.cmd
```

---

## 🔧 METHOD 2: Right-Click → Run as Administrator

1. **Right-click** pada file `RUN_STARTUP.cmd`
2. Pilih **"Run as administrator"**
3. Jika ada UAC prompt, klik **Yes**

---

## 📝 METHOD 3: Manual Step-by-Step

Buka 4 Command Prompt windows (buka satu per satu):

### Terminal 1: Redis
```cmd
cd D:\Construction-Hazard-Detection
redis-server.exe redis.windows.conf
```
**Biarkan window ini terbuka!**

### Terminal 2: DB Management API
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005
```
**Biarkan window ini terbuka!**

### Terminal 3: Streaming API
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```
**Biarkan window ini terbuka!**

### Terminal 4: Detection
```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```
**Biarkan window ini terbuka!**

---

## ✅ VERIFY SERVICES RUNNING

Buka Terminal baru:
```cmd
netstat -an | findstr ":8005 :8800 :3306 :6379" | findstr "LISTENING"
```

**Should show:**
```
TCP    0.0.0.0:8005    LISTENING  ✅
TCP    0.0.0.0:8800    LISTENING  ✅
TCP    0.0.0.0:3306    LISTENING  ✅
```

**Check Redis:**
```cmd
redis-cli.exe ping
```
Should return: `PONG` ✅

---

## 🌐 OPEN VISIONNAIRE

### Step 1: Buka Browser

```
https://visionnaire-cda17.web.app/login
```

### Step 2: Configure (FIRST TIME ONLY)

Press **F12** → Console tab → Paste:

```javascript
localStorage.clear();
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
location.reload();
```

### Step 3: Login

```
Username: user
Password: password
```

### Step 4: View Live Stream

1. Click **"Live Stream"** in menu
2. Select **"Test Site"** → **"Local Video Demo"**
3. ✅ Video should appear!

---

## 🔄 ALTERNATIF: PowerShell

Jika Command Prompt tidak work:

```powershell
cd D:\Construction-Hazard-Detection
.\RUN_STARTUP.cmd
```

Atau:
```powershell
powershell -ExecutionPolicy Bypass -File .\RUN_STARTUP.cmd
```

---

## 🛑 CARA STOP

### Method 1: Close Windows
Tutup semua Command Prompt windows (4 windows)

### Method 2: Kill Processes
```cmd
taskkill /F /IM python.exe /T
taskkill /F /IM uvicorn.exe /T
redis-cli.exe shutdown
```

### Method 3: Via Script
```cmd
cd D:\Construction-Hazard-Detection
STOP_EVERYTHING.bat
```

Atau di Command Prompt:
```cmd
cmd /c STOP_EVERYTHING.bat
```

---

## 📋 COMPLETE COMMAND REFERENCE

### Start All (One by One):

**Terminal 1:**
```cmd
cd D:\Construction-Hazard-Detection
redis-server.exe redis.windows.conf
```

**Terminal 2:**
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005
```

**Terminal 3:**
```cmd
cd D:\Construction-Hazard-Detection
uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800
```

**Terminal 4:**
```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

---

## 🔧 TROUBLESHOOTING

### "File tidak ditemukan"

**Solution:**
```cmd
REM Pastikan di folder yang benar
cd D:\Construction-Hazard-Detection

REM Check jika file ada
dir RUN_STARTUP.cmd

REM Jika ada, jalankan
RUN_STARTUP.cmd
```

### "Access Denied"

**Solution:**
1. Right-click Command Prompt
2. Pilih "Run as administrator"
3. Jalankan command lagi

### ".bat file membuka di Notepad"

**Solution 1:** Gunakan file `.cmd` sebagai gantinya:
```cmd
RUN_STARTUP.cmd
```

**Solution 2:** Jalankan via Command Prompt:
```cmd
cmd /c START_EVERYTHING.bat
```

**Solution 3:** Fix file association (Administrator):
```cmd
assoc .bat=batfile
ftype batfile=%windir%\system32\cmd.exe /c "%1" %*
```

---

## 📝 QUICK START CHECKLIST

```
□ Buka Command Prompt di folder project
□ Jalankan: RUN_STARTUP.cmd
□ Tunggu semua services start (~30 detik)
□ Buka: https://visionnaire-cda17.web.app/login
□ Configure localStorage (F12 console - first time only)
□ Login: user / password
□ View Live Stream
□ ✅ Done!
```

---

## 💡 RECOMMENDED WAY

**Paling mudah:**

1. **Buka File Explorer**
2. **Navigate ke:** `D:\Construction-Hazard-Detection`
3. **Di address bar, ketik:** `cmd` lalu Enter
4. **Di Command Prompt, ketik:** `RUN_STARTUP.cmd`
5. ✅ **Done!**

---

## 🎯 JIKA MASIH BERMASALAH

**Copy-paste commands ini satu per satu:**

```cmd
cd D:\Construction-Hazard-Detection
redis-cli.exe ping
```
Harus return: PONG

```cmd
cd D:\Construction-Hazard-Detection
start cmd /k "uvicorn examples.db_management.app:app --host 0.0.0.0 --port 8005"
```
Window baru akan terbuka

```cmd
cd D:\Construction-Hazard-Detection
start cmd /k "uvicorn examples.streaming_web.backend.app:app --host 0.0.0.0 --port 8800"
```
Window baru akan terbuka

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

Kemudian buka: https://visionnaire-cda17.web.app/login

---

## 📞 SUMMARY

**Jika .bat tidak work, gunakan .cmd:**
- File: `RUN_STARTUP.cmd`
- Via Command Prompt: Buka CMD di folder project → ketik `RUN_STARTUP.cmd`

**Atau manual:**
- 4 Terminal windows
- Copy-paste commands di atas satu per satu

**Files available:**
- `RUN_STARTUP.cmd` ← Use this!
- `START_EVERYTHING.bat` ← If this doesn't work
- Manual commands (see METHOD 3 above)

---

**TRY THIS NOW:**

1. **Buka folder:** `D:\Construction-Hazard-Detection` di File Explorer
2. **Ketik di address bar:** `cmd`
3. **Press Enter** - CMD akan terbuka
4. **Ketik:** `RUN_STARTUP.cmd`
5. **Press Enter**

✅ Services akan start otomatis!
