# 🔐 LOGIN FIX GUIDE - Construction Hazard Detection

## ✅ STATUS: CREDENTIALS VERIFIED!

**Good News:** Login credentials sudah benar dan valid di database!

```
Username: user
Password: password
Role: admin
Status: Active ✅
```

---

## 🔍 PROBLEM DIAGNOSIS

Jika Anda tidak bisa login di Visionnaire, kemungkinan penyebabnya:

### 1. **API Backend Belum Running** ⚠️

DB Management API (port 8005) harus running untuk handle login.

**Solution:**

```cmd
REM Kill semua services yang lama dulu
taskkill /F /IM python.exe /T
taskkill /F /IM uvicorn.exe /T

REM Start dengan script yang fixed
START_FIXED_SERVICES.bat
```

### 2. **Visionnaire Belum Configured** ⚠️

localStorage di browser belum diset dengan API endpoints yang benar.

**Solution:**

1. **Buka Visionnaire:**
   ```
   https://visionnaire-cda17.web.app/login
   ```

2. **Tekan F12** untuk buka Developer Console

3. **Paste ini di Console tab:**
   ```javascript
   // Clear old settings first
   localStorage.clear();

   // Set new API endpoints
   localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
   localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
   localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
   localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
   localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');

   console.log('API endpoints configured!');

   // Reload page
   location.reload();
   ```

4. **Login:**
   - Username: `user`
   - Password: `password`

### 3. **CORS Issue** ⚠️

Browser mungkin block request ke localhost.

**Solution A - Use Browser Extension:**

Install extension untuk allow CORS:
- Chrome: "Allow CORS: Access-Control-Allow-Origin"
- Firefox: "CORS Everywhere"

**Solution B - Use ngrok (Recommended for Competition):**

Lihat `COLAB_WITH_VISIONNAIRE.md` untuk setup dengan ngrok tunnel.

**Solution C - Disable Browser Security (TESTING ONLY):**

```cmd
REM Close all Chrome windows first, then run:
"C:\Program Files\Google\Chrome\Application\chrome.exe" --disable-web-security --user-data-dir="C:/chrome-dev" https://visionnaire-cda17.web.app/login
```

### 4. **Port 8005 Sudah Dipakai**

Service lain menggunakan port 8005.

**Check:**
```cmd
netstat -an | findstr ":8005"
```

**Solution:**
```cmd
REM Find process using port 8005
netstat -ano | findstr ":8005"

REM Kill the process (replace PID with actual process ID)
taskkill /F /PID [PID]

REM Restart service
START_FIXED_SERVICES.bat
```

---

## 🚀 QUICK FIX STEPS

### Step 1: Stop All Services

```cmd
taskkill /F /IM python.exe /T
taskkill /F /IM uvicorn.exe /T
```

### Step 2: Start Services with Fixed Script

```cmd
START_FIXED_SERVICES.bat
```

Wait 20-30 seconds for all services to initialize.

### Step 3: Verify Services Running

```cmd
netstat -an | findstr ":8005 :8000 :8002 :8003 :8800" | findstr "LISTENING"
```

You should see:
```
TCP    0.0.0.0:8000    LISTENING
TCP    0.0.0.0:8002    LISTENING
TCP    0.0.0.0:8003    LISTENING
TCP    0.0.0.0:8005    LISTENING
TCP    0.0.0.0:8800    LISTENING
```

### Step 4: Configure Visionnaire

```javascript
// In browser console (F12)
localStorage.clear();
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('DETECT_API_URL', 'http://127.0.0.1:8000');
localStorage.setItem('VIOLATION_RECORD_API_URL', 'http://127.0.0.1:8002');
localStorage.setItem('FCM_API_URL', 'http://127.0.0.1:8003');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
location.reload();
```

### Step 5: Login

```
Username: user
Password: password
```

---

## 🧪 TEST LOGIN LOCALLY

Run test script untuk verify credentials:

```cmd
python test_login.py
```

Expected output:
```
SUCCESS: Password is correct!
LOGIN CREDENTIALS ARE VALID
```

---

## 🔧 ALTERNATIVE: Test API Directly

### Test dengan Swagger UI

Buka di browser:
```
http://127.0.0.1:8005/docs
```

1. Find endpoint: `POST /auth/login`
2. Click "Try it out"
3. Input:
   ```json
   {
     "username": "user",
     "password": "password"
   }
   ```
4. Click "Execute"

Expected response:
```json
{
  "access_token": "...",
  "token_type": "bearer",
  "user": {
    "username": "user",
    "role": "admin"
  }
}
```

### Test dengan curl

```cmd
curl -X POST "http://127.0.0.1:8005/auth/login" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"user\",\"password\":\"password\"}"
```

### Test dengan Python

```python
import requests

response = requests.post(
    'http://127.0.0.1:8005/auth/login',
    json={'username': 'user', 'password': 'password'}
)

print(response.status_code)
print(response.json())
```

---

## 📝 RESET PASSWORD (If Needed)

Jika masih ada masalah, reset password:

```cmd
python reset_user_password.py
```

Ini akan reset/create user dengan credentials:
- Username: `user`
- Password: `password`

---

## 🌐 ALTERNATIVE SOLUTION: Use Google Colab

Jika localhost setup terlalu rumit, gunakan Google Colab dengan GPU:

See: `COLAB_WITH_VISIONNAIRE.md`

Benefits:
- FREE T4 GPU (30 FPS!)
- No CORS issues
- Ngrok tunnel (public access)
- Same Visionnaire interface
- Setup time: 15-20 minutes

---

## ❓ TROUBLESHOOTING

### "Cannot connect to localhost:8005"

**Check:**
```cmd
# Is service running?
netstat -an | findstr ":8005"

# Check if Python is running
tasklist | findstr python
```

**Fix:**
```cmd
START_FIXED_SERVICES.bat
```

### "401 Unauthorized" atau "Invalid credentials"

**Possible causes:**
1. Password salah
2. User tidak aktif
3. Database belum initialized

**Fix:**
```cmd
# Re-initialize database
powershell -Command "Get-Content scripts/init.sql | & 'C:\xampp\mysql\bin\mysql.exe' -u root"

# Or reset password
python reset_user_password.py
```

### "Network Error" di Visionnaire

**Possible causes:**
1. API belum running
2. CORS blocked
3. Firewall blocking

**Fix:**
```cmd
# Check firewall
netsh advfirewall firewall show rule name=all | findstr 8005

# Allow Python through firewall (run as Administrator)
netsh advfirewall firewall add rule name="Python 8005" dir=in action=allow protocol=TCP localport=8005

# Or disable firewall temporarily for testing
netsh advfirewall set allprofiles state off
```

### "Mixed Content" Error

If Visionnaire (HTTPS) can't connect to localhost (HTTP):

**Solution:** Use ngrok to create HTTPS tunnel

See `setup_ngrok.md` for instructions.

---

## 📊 SERVICE STATUS CHECK

Run this command untuk check semua services:

```cmd
@echo off
echo Checking services...
echo.
netstat -an | findstr ":8000" | findstr "LISTENING" >nul && echo [OK] YOLO API (8000) || echo [FAIL] YOLO API (8000)
netstat -an | findstr ":8002" | findstr "LISTENING" >nul && echo [OK] Violation API (8002) || echo [FAIL] Violation API (8002)
netstat -an | findstr ":8003" | findstr "LISTENING" >nul && echo [OK] FCM API (8003) || echo [FAIL] FCM API (8003)
netstat -an | findstr ":8005" | findstr "LISTENING" >nul && echo [OK] DB Management API (8005) || echo [FAIL] DB Management API (8005)
netstat -an | findstr ":8800" | findstr "LISTENING" >nul && echo [OK] Streaming API (8800) || echo [FAIL] Streaming API (8800)
netstat -an | findstr ":3306" | findstr "LISTENING" >nul && echo [OK] MySQL (3306) || echo [FAIL] MySQL (3306)
redis-cli.exe ping >nul 2>&1 && echo [OK] Redis (6379) || echo [FAIL] Redis (6379)
```

All should show [OK].

---

## 🎯 FINAL CHECKLIST

Before trying to login:

- [ ] MySQL running (port 3306)
- [ ] Redis running (port 6379)
- [ ] Database `construction_hazard_detection` exists
- [ ] User `user` exists in database (verified with test_login.py)
- [ ] DB Management API running (port 8005)
- [ ] Other APIs running (8000, 8002, 8003, 8800)
- [ ] Visionnaire localStorage configured
- [ ] CORS allowed (extension or ngrok)
- [ ] Firewall allows connections

---

## 💡 RECOMMENDED SETUP FOR COMPETITION

For hassle-free setup during competition:

### Option 1: Google Colab + Ngrok (EASIEST)
- See `COLAB_WITH_VISIONNAIRE.md`
- Setup time: 15-20 minutes
- FREE GPU (30 FPS!)
- No CORS issues
- ✅ Recommended!

### Option 2: Vast.ai GPU + Public IP
- See `VASTAI_SETUP_GUIDE.md`
- Cost: ~$0.20/hour
- High performance
- Public IP (no ngrok needed)

### Option 3: Local with Ngrok
- Keep local setup
- Add ngrok for public access
- No CORS issues
- Can show to judges remotely

---

**CREDENTIALS:**
```
Username: user
Password: password
```

**VISIONNAIRE URL:**
```
https://visionnaire-cda17.web.app/login
```

**API DOCUMENTATION:**
```
http://127.0.0.1:8005/docs
```

---

**Good luck! 🚀**
