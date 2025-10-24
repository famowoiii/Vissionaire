# 🚀 QUICK START - Construction Hazard Detection

## ⚡ CARA TERCEPAT (3 Langkah)

### **Step 1: Start Services**
```cmd
Double-click: START_EVERYTHING.bat
```
Tunggu sampai semua services running (~30 detik)

### **Step 2: Configure Visionnaire (FIRST TIME ONLY)**

Browser akan terbuka otomatis ke Visionnaire.

**Press F12**, paste di Console:
```javascript
localStorage.clear();
localStorage.setItem('MANAGEMENT_API', 'http://127.0.0.1:8005');
localStorage.setItem('STREAMING_API_URL', 'http://127.0.0.1:8800');
location.reload();
```

**Login:**
```
Username: user
Password: password
```

### **Step 3: Start Detection**
```cmd
Double-click: START_DETECTION.bat
```

### **Step 4: View Results**

Di Visionnaire:
- Click **"Live Stream"**
- Select **"Test Site"** → **"Local Video Demo"**
- ✅ Video appears with detections!

---

## 🛑 STOP SYSTEM

```cmd
Double-click: STOP_EVERYTHING.bat
```

---

## 📋 FILES CREATED

1. **`START_EVERYTHING.bat`** - Start all services
2. **`START_DETECTION.bat`** - Start detection only
3. **`STOP_EVERYTHING.bat`** - Stop all services
4. **`COMPLETE_STARTUP_GUIDE.md`** - Detailed manual

---

## 🔧 TROUBLESHOOTING

**Services not starting?**
- Check XAMPP MySQL is running first
- Read `COMPLETE_STARTUP_GUIDE.md` for detailed steps

**Login failed?**
```cmd
python reset_user_password.py
```

**No video in Live Stream?**
- Make sure detection is running (START_DETECTION.bat)
- Check `WEBSOCKET_STREAMING_FIX.md`

---

## 📚 DOCUMENTATION

- `COMPLETE_STARTUP_GUIDE.md` - Full manual (READ THIS!)
- `VIDEO_TEST_GUIDE.md` - Video sources
- `WEBSOCKET_STREAMING_FIX.md` - Streaming issues
- `LOGIN_SUCCESS.md` - Login troubleshooting

---

## 🎯 DAILY WORKFLOW

**Every day:**
1. Run `START_EVERYTHING.bat`
2. Login to Visionnaire (if not already logged in)
3. Run `START_DETECTION.bat`
4. Monitor via Visionnaire web

**When done:**
1. Close detection window (Ctrl+C)
2. Run `STOP_EVERYTHING.bat` (optional)

---

**THAT'S IT! System ready in 3 steps!** 🎉
