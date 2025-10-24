# 🤖 TELEGRAM BOT SETUP GUIDE

## 📋 OVERVIEW

Sistem Construction Hazard Detection sudah memiliki **Telegram Bot** terintegrasi! Bot akan mengirim notifikasi otomatis ketika mendeteksi hazard (bahaya) di konstruksi.

**Features:**
- ✅ Kirim pesan teks alert
- ✅ Kirim foto/gambar violasi
- ✅ Multi-bahasa (English, Chinese, Japanese, dll)
- ✅ Support personal chat & group chat
- ✅ Async/non-blocking notifications

---

## 🚀 STEP 1: BUAT TELEGRAM BOT

### 1.1 Chat dengan BotFather

1. Buka Telegram
2. Cari: **@BotFather**
3. Start chat dan ketik: `/newbot`

### 1.2 Setup Bot

BotFather akan bertanya:

**Q:** "Alright, a new bot. How are we going to call it?"
**A:** Ketik nama bot Anda (contoh: `Construction Safety Bot`)

**Q:** "Good. Now let's choose a username for your bot."
**A:** Ketik username bot (harus diakhiri `bot`, contoh: `ConstructionSafetyBot`)

### 1.3 Dapatkan Bot Token

BotFather akan memberikan **Bot Token** seperti:
```
1234567890:ABCdefGHIjklMNOpqrsTUVwxyz-1234567890
```

**⚠️ PENTING:** Simpan token ini! Jangan share ke orang lain!

---

## 🔑 STEP 2: DAPATKAN CHAT ID

### 2.1 Personal Chat ID

1. Start chat dengan bot Anda (klik link dari BotFather)
2. Ketik: `/start` atau pesan apa saja
3. Buka browser, akses:
   ```
   https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
   ```

   Ganti `<YOUR_BOT_TOKEN>` dengan token Anda!

4. Cari bagian `"chat":{"id":123456789`
5. **Chat ID Anda:** angka setelah `"id":` (contoh: `123456789`)

### 2.2 Group Chat ID

1. Tambahkan bot Anda ke group
2. Ketik pesan di group (mention bot: `@YourBot test`)
3. Akses URL getUpdates (sama seperti di atas)
4. Cari `"chat":{"id":-1001234567890`
5. **Group Chat ID:** angka negatif (contoh: `-1001234567890`)

**Tip:** Group ID selalu dimulai dengan minus (-)

---

## ⚙️ STEP 3: KONFIGURASI .ENV

Edit file `.env` di folder project:

```env
# Telegram Bot Configuration
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz-1234567890
```

**Path:** `D:\Construction-Hazard-Detection\.env`

---

## 📝 STEP 4: KONFIGURASI STREAM

### Option 1: Via JSON Config File

Edit `config/test_stream.json`:

```json
[
  {
    "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Test Site",
    "stream_name": "Local Video Demo",
    "model_key": "yolo11n",
    "detect_with_server": false,

    "notifications": {
      "telegram:123456789": "en",
      "telegram:-1001234567890": "zh-tw"
    },

    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": true,
      "detect_in_restricted_area": true
    },

    "work_start_hour": 8,
    "work_end_hour": 18,
    "store_in_redis": true
  }
]
```

**Format Notifications:**
```json
"notifications": {
  "telegram:YOUR_CHAT_ID": "LANGUAGE_CODE"
}
```

**Language Codes:**
- `"en"` = English
- `"zh-tw"` = Traditional Chinese (Taiwan)
- `"zh-cn"` = Simplified Chinese
- `"ja"` = Japanese
- `"es"` = Spanish
- `"fr"` = French
- `"de"` = German

### Option 2: Via Database (Visionnaire Web)

1. Login ke Visionnaire: https://visionnaire-cda17.web.app/login
2. Go to **Sites** → Select your site
3. Go to **Stream Configuration**
4. Di bagian **Notifications**, tambahkan:
   ```
   Chat ID: telegram:123456789
   Language: en
   ```

---

## 🧪 STEP 5: TEST TELEGRAM BOT

### 5.1 Test Manual dengan Script

Buat file test: `test_telegram.py`

```python
import asyncio
import os
from dotenv import load_dotenv
from src.notifiers.telegram_notifier import TelegramNotifier

async def test_telegram():
    load_dotenv()

    # Your configuration
    chat_id = "123456789"  # Ganti dengan Chat ID Anda
    bot_token = os.getenv('TELEGRAM_BOT_TOKEN')

    # Initialize notifier
    notifier = TelegramNotifier()

    # Send test message
    print(f"Sending test message to Telegram chat {chat_id}...")

    message = "🔔 Test Notification from Construction Hazard Detection System!"

    try:
        response = await notifier.send_notification(
            chat_id=chat_id,
            message=message,
            bot_token=bot_token
        )
        print(f"✅ Message sent successfully!")
        print(f"Message ID: {response.message_id}")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    asyncio.run(test_telegram())
```

**Run:**
```cmd
cd D:\Construction-Hazard-Detection
python test_telegram.py
```

### 5.2 Test dengan Gambar

```python
import asyncio
import os
import numpy as np
from dotenv import load_dotenv
from src.notifiers.telegram_notifier import TelegramNotifier

async def test_telegram_with_image():
    load_dotenv()

    chat_id = "123456789"  # Ganti dengan Chat ID Anda
    notifier = TelegramNotifier()

    # Create dummy image (red square)
    image = np.zeros((400, 400, 3), dtype=np.uint8)
    image[:, :] = [255, 0, 0]  # Red color

    message = "⚠️ Safety Violation Detected!\n\nWorker without helmet at Zone A."

    try:
        response = await notifier.send_notification(
            chat_id=chat_id,
            message=message,
            image=image
        )
        print(f"✅ Image sent successfully!")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    asyncio.run(test_telegram_with_image())
```

---

## 🎯 STEP 6: JALANKAN DETECTION DENGAN TELEGRAM

```cmd
cd D:\Construction-Hazard-Detection
python main.py --config config\test_stream.json
```

**Expected Output:**
```
Loading configuration from config\test_stream.json
Initializing TelegramNotifier...
Starting detection for Test Site / Local Video Demo
✅ Telegram notifications enabled for chat: 123456789
Processing frame...
⚠️ Violation detected: Worker without safety helmet
Sending notification to Telegram...
✅ Notification sent to Telegram chat 123456789
```

---

## 📱 NOTIFICATION EXAMPLE

Ketika sistem mendeteksi violation, Anda akan terima pesan Telegram seperti:

```
🚨 Safety Violation Detected

Site: Test Site
Camera: Local Video Demo
Time: 2025-01-21 14:30:15

⚠️ Violation Type:
• Worker without safety helmet
• Worker without safety vest

Location: Zone A - Construction Area

[Attached: Photo of violation]

Please take immediate action!
```

---

## 🔧 TROUBLESHOOTING

### ❌ Error: "Bot token must be provided"

**Solution:**
```cmd
REM Check .env file
type .env | findstr TELEGRAM

REM Should show:
REM TELEGRAM_BOT_TOKEN=your_token_here
```

Pastikan token ada di `.env` file!

### ❌ Error: "Chat not found"

**Causes:**
1. Chat ID salah
2. Bot belum di-start oleh user
3. Bot sudah di-block oleh user

**Solution:**
1. Verify Chat ID dengan getUpdates API
2. Start chat dengan bot (ketik `/start`)
3. Unblock bot jika sudah di-block

### ❌ Error: "Forbidden: bot was blocked by the user"

**Solution:**
1. Buka Telegram
2. Cari bot Anda
3. Ketik `/start` untuk unblock

### ❌ Tidak ada notifikasi

**Checklist:**
```
□ TELEGRAM_BOT_TOKEN sudah di .env? ✓
□ Chat ID benar (cek dengan getUpdates)? ✓
□ Format: "telegram:123456789" di config? ✓
□ Detection sudah running? ✓
□ Violation terdeteksi? (check logs) ✓
```

**Check logs:**
```cmd
REM Di terminal detection, cari:
Sending notification to Telegram...
✅ Notification sent
```

---

## 🆚 TELEGRAM vs LINE COMPARISON

| Feature | Telegram | LINE |
|---------|----------|------|
| Setup Difficulty | ⭐ Easy | ⭐⭐ Medium |
| Bot Creation | Via @BotFather | Via LINE Developers |
| Webhook Required | ❌ No (Push only) | ✅ Yes (for interactive) |
| Global Availability | ✅ Worldwide | 🌏 Popular in Asia |
| File Size Limit | 50 MB | 200 MB (cloud) |
| Group Support | ✅ Yes | ✅ Yes |
| API Rate Limit | 30 msg/sec | Varies by plan |

**Recommendation:**
- **Telegram:** Quickest setup, great for global teams
- **LINE:** Better for Asia (Taiwan, Thailand, Japan)

---

## 🎨 CUSTOMIZE BOT

### Change Bot Profile Photo

1. Chat @BotFather
2. Ketik: `/setuserpic`
3. Pilih bot Anda
4. Upload gambar (construction safety icon recommended)

### Change Bot Description

1. Chat @BotFather
2. Ketik: `/setdescription`
3. Pilih bot Anda
4. Ketik deskripsi:
   ```
   Construction Hazard Detection Bot

   This bot sends real-time safety alerts when violations are detected at construction sites.
   ```

### Add Bot Commands

1. Chat @BotFather
2. Ketik: `/setcommands`
3. Pilih bot Anda
4. Paste:
   ```
   start - Start receiving notifications
   help - Show help message
   status - Check detection system status
   ```

---

## 📊 MULTIPLE CHATS

Anda bisa kirim notifikasi ke multiple chats:

```json
"notifications": {
  "telegram:123456789": "en",           // Personal chat (English)
  "telegram:987654321": "zh-tw",        // Another user (Chinese)
  "telegram:-1001234567890": "en",      // Group chat 1
  "telegram:-1009876543210": "ja"       // Group chat 2 (Japanese)
}
```

Semua chat akan terima notifikasi bersamaan!

---

## 🔐 SECURITY BEST PRACTICES

1. **Jangan commit Bot Token ke Git**
   ```gitignore
   .env
   .env.*
   ```

2. **Regenerate Token jika leaked**
   - Chat @BotFather
   - `/token` → pilih bot → `/revoke`

3. **Restrict Bot Access**
   - Set bot to private (tidak muncul di search)
   - Chat @BotFather → `/setjoingroups` → Disable

---

## 📝 QUICK REFERENCE COMMANDS

```bash
# Test Telegram Bot
python test_telegram.py

# Run detection with Telegram notifications
python main.py --config config\test_stream.json

# Check Bot Token in .env
type .env | findstr TELEGRAM

# Get Chat ID via API
curl "https://api.telegram.org/bot<TOKEN>/getUpdates"
```

---

## 📞 NEXT STEPS

1. ✅ Buat Telegram Bot via @BotFather
2. ✅ Dapatkan Bot Token
3. ✅ Dapatkan Chat ID
4. ✅ Update `.env` dengan TELEGRAM_BOT_TOKEN
5. ✅ Update `config/test_stream.json` dengan notifications
6. ✅ Test dengan `test_telegram.py`
7. ✅ Run detection: `python main.py --config config\test_stream.json`
8. ✅ Terima notifikasi di Telegram!

---

## 🎉 DONE!

Telegram Bot Anda sudah siap mengirim safety alerts! 🚀

**Files:**
- ✅ Source: `src/notifiers/telegram_notifier.py`
- ✅ Tests: `tests/src/notifiers/telegram_notifier_test.py`
- ✅ Config: `.env` dan `config/test_stream.json`

**Support multiple platforms:**
- Telegram ✅
- LINE ✅
- WeChat ✅
- Facebook Messenger ✅

Semua bisa jalan bersamaan!
