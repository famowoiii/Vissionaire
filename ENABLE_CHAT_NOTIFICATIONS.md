# 💬 CARA MENGAKTIFKAN FITUR CHAT/NOTIFICATIONS

## 📋 OVERVIEW

Aplikasi Construction Hazard Detection **mendukung notifications via chat apps**, tapi **belum diaktifkan** di konfigurasi Anda saat ini.

**Chat apps yang didukung:**
- 📱 **LINE** (Recommended untuk Indonesia/Asia)
- 💬 **Telegram**
- 🔵 **Facebook Messenger**
- 🟢 **WeChat**

**MASALAH SAAT INI:**
```json
"notifications": {},  // KOSONG - tidak ada chat notifications!
```

---

## 🔍 KENAPA CHAT TIDAK AKTIF?

### 1. **Notifications Config Kosong**

File: `D:\Construction-Hazard-Detection\config\test_stream.json` line 7:

```json
"notifications": {},  // ❌ KOSONG!
```

Seharusnya seperti ini (contoh):

```json
"notifications": {
  "YOUR_LINE_TOKEN_1": "en",
  "YOUR_LINE_TOKEN_2": "zh-tw"
}
```

### 2. **Credentials Tidak Dikonfigurasi**

File `.env` **tidak ada** LINE/Telegram/WeChat credentials:

```bash
# ❌ TIDAK ADA:
# LINE_CHANNEL_ACCESS_TOKEN='...'
# LINE_CHANNEL_SECRET='...'
# TELEGRAM_BOT_TOKEN='...'
# WECHAT_CREDENTIALS='...'
```

### 3. **LINE Chatbot Service Tidak Berjalan**

Service LINE chatbot ada di:
- `examples/line_chatbot/line_bot.py`

Tapi **tidak dijalankan** di terminal Anda (hanya 5 terminal untuk API lain).

---

## ✅ CARA MENGAKTIFKAN CHAT NOTIFICATIONS

### **OPSI 1: LINE (Recommended)** 📱

LINE adalah yang paling populer di Asia dan mudah disetup.

#### Step 1: Buat LINE Bot

1. **Buka LINE Developer Console:**
   https://developers.line.biz/console/

2. **Sign in** dengan akun LINE Anda

3. **Create Provider:**
   - Klik "Create" di bagian Provider
   - Nama provider: `Construction Hazard Alert`

4. **Create Channel:**
   - Di dalam provider, klik "Create Channel"
   - Channel type: **Messaging API**
   - Channel name: `Construction Alert Bot`
   - Channel description: `Real-time construction hazard notifications`
   - Category: Pilih yang sesuai (e.g., "Productivity")
   - Subcategory: Pilih yang sesuai

5. **Get Credentials:**
   - Setelah channel dibuat, masuk ke channel settings
   - **Channel Secret:** Copy dari "Basic settings" tab
   - **Channel Access Token:**
     - Go to "Messaging API" tab
     - Scroll ke bawah ke "Channel access token"
     - Klik "Issue" untuk generate token
     - Copy token yang muncul

#### Step 2: Configure .env

Edit `D:\Construction-Hazard-Detection\.env` dan tambahkan:

```bash
# LINE Bot Configuration
LINE_CHANNEL_ACCESS_TOKEN='YOUR_CHANNEL_ACCESS_TOKEN_HERE'
LINE_CHANNEL_SECRET='YOUR_CHANNEL_SECRET_HERE'

# Optional: Cloudinary untuk image upload (jika ingin kirim gambar deteksi)
CLOUDINARY_CLOUD_NAME='your_cloud_name'
CLOUDINARY_API_KEY='your_api_key'
CLOUDINARY_API_SECRET='your_api_secret'
```

#### Step 3: Update line_bot.py

Edit `D:\Construction-Hazard-Detection\examples\line_chatbot\line_bot.py` lines 30 & 34:

**Dari:**
```python
configuration: Configuration = Configuration(
    access_token='YOUR_LINE_CHANNEL_ACCESS_TOKEN',
)
# ...
handler: WebhookHandler = WebhookHandler('YOUR_LINE_CHANNEL_SECRET')
```

**Jadi:**
```python
import os
from dotenv import load_dotenv

load_dotenv()

configuration: Configuration = Configuration(
    access_token=os.getenv('LINE_CHANNEL_ACCESS_TOKEN'),
)
# ...
handler: WebhookHandler = WebhookHandler(os.getenv('LINE_CHANNEL_SECRET'))
```

#### Step 4: Setup Webhook dengan Ngrok

LINE bot perlu webhook URL yang bisa diakses dari internet.

1. **Download ngrok:**
   https://ngrok.com/download

2. **Extract** ngrok.exe ke `D:\Construction-Hazard-Detection\`

3. **Jalankan LINE bot:**

   Buka terminal baru (Terminal 6):
   ```bash
   cd D:\Construction-Hazard-Detection\examples\line_chatbot
   python line_bot.py
   ```

4. **Expose dengan ngrok:**

   Buka terminal baru (Terminal 7):
   ```bash
   cd D:\Construction-Hazard-Detection
   ngrok http 8000
   ```

5. **Copy ngrok URL:**

   Akan muncul seperti ini:
   ```
   Forwarding   https://xxxx-xx-xx-xx.ngrok-free.app -> http://localhost:8000
   ```

   Copy URL HTTPS: `https://xxxx-xx-xx-xx.ngrok-free.app`

6. **Set Webhook di LINE Developer Console:**

   - Buka LINE Developer Console
   - Pilih channel Anda
   - Tab "Messaging API"
   - Di "Webhook settings":
     - Webhook URL: `https://xxxx-xx-xx-xx.ngrok-free.app/webhook`
     - Klik "Update"
     - Klik "Verify" untuk test connection
     - Enable "Use webhook"

#### Step 5: Get LINE User/Group Token

Ada 2 cara kirim notifikasi:

**A. Kirim ke User Tertentu (Recommended):**

1. **Add bot sebagai friend:**
   - Di LINE Developer Console, channel settings
   - Tab "Messaging API"
   - Scan QR code "Add friend"
   - Atau cari by Bot ID

2. **Get User ID:**

   Kirim message ke bot, lalu lihat di terminal line_bot.py, akan muncul:
   ```
   User ID: Uxxxxxxxxxxxxx
   ```

3. **Use User ID di config:**
   ```json
   "notifications": {
     "Uxxxxxxxxxxxxx": "en"
   }
   ```

**B. Kirim ke LINE Group (untuk team):**

1. **Invite bot ke LINE Group:**
   - Buat group di LINE
   - Add bot ke group

2. **Get Group ID:**

   Kirim message di group, lihat terminal line_bot.py:
   ```
   Group ID: Cxxxxxxxxxxxxx
   ```

3. **Use Group ID di config:**
   ```json
   "notifications": {
     "Cxxxxxxxxxxxxx": "en"
   }
   ```

#### Step 6: Update test_stream.json

Edit `D:\Construction-Hazard-Detection\config\test_stream.json` line 7:

**Dari:**
```json
"notifications": {},
```

**Jadi:**
```json
"notifications": {
  "Uxxxxxxxxxxxxx": "en",
  "Cxxxxxxxxxxxxx": "zh-tw"
},
```

Format: `"LINE_USER_OR_GROUP_ID": "language_code"`

**Language codes:**
- `"en"` = English
- `"zh-tw"` = Traditional Chinese (Taiwan)
- `"zh-cn"` = Simplified Chinese
- `"ja"` = Japanese
- `"es"` = Spanish
- `"fr"` = French
- `"de"` = German

#### Step 7: Restart Main Detection

Stop dan restart `python main.py`:

```bash
# Stop dengan Ctrl+C
# Lalu jalankan ulang:
python main.py --config config/test_stream.json
```

#### Step 8: Test!

1. Detection akan jalan seperti biasa
2. **Saat ada hazard terdeteksi**, bot akan kirim message ke LINE!
3. Message akan berisi:
   - Site name
   - Jenis hazard yang terdeteksi
   - Timestamp
   - (Optional) Gambar jika Cloudinary dikonfigurasi

---

### **OPSI 2: Telegram** 💬

Lebih mudah dari LINE, tidak perlu webhook!

#### Step 1: Buat Telegram Bot

1. **Buka Telegram** dan cari **@BotFather**

2. **Kirim command:**
   ```
   /newbot
   ```

3. **Ikuti instruksi:**
   - Nama bot: `Construction Hazard Alert`
   - Username: `construction_alert_bot` (harus unique)

4. **Copy Bot Token:**
   ```
   Use this token to access the HTTP API:
   1234567890:ABCdefGHIjklMNOpqrsTUVwxyz1234567890
   ```

#### Step 2: Configure .env

```bash
# Telegram Bot Configuration
TELEGRAM_BOT_TOKEN='1234567890:ABCdefGHIjklMNOpqrsTUVwxyz1234567890'
```

#### Step 3: Get Chat ID

1. **Start chat** dengan bot Anda di Telegram

2. **Kirim message** apa saja ke bot

3. **Buka browser:**
   ```
   https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
   ```

   Ganti `<YOUR_BOT_TOKEN>` dengan token Anda

4. **Lihat response JSON**, cari `"chat":{"id":123456789}`

5. **Copy Chat ID:** `123456789`

#### Step 4: Update test_stream.json

```json
"notifications": {
  "telegram:123456789": "en"
},
```

Format: `"telegram:CHAT_ID": "language_code"`

#### Step 5: Test

Restart main.py, saat ada hazard terdeteksi, akan kirim ke Telegram!

---

### **OPSI 3: WeChat** 🟢

WeChat lebih kompleks, butuh verified account (biasanya untuk bisnis).

Dokumentasi: https://developers.weixin.qq.com/doc/

#### Simplified Setup:

1. **Daftar WeChat Official Account:**
   https://mp.weixin.qq.com/

2. **Get credentials:**
   - App ID
   - App Secret

3. **Configure .env:**
   ```bash
   WECHAT_APP_ID='your_app_id'
   WECHAT_APP_SECRET='your_app_secret'
   ```

4. **Update config:**
   ```json
   "notifications": {
     "wechat:USER_OPENID": "zh-cn"
   }
   ```

---

## 🎯 RECOMMENDED SETUP UNTUK ANDA

**Saya recommend pakai LINE** karena:
- ✅ Paling populer di Indonesia/Asia
- ✅ Setup relatif mudah
- ✅ Support rich messages (gambar, buttons, etc.)
- ✅ Free untuk unlimited messages
- ✅ Bisa kirim ke group (untuk team monitoring)

**Alternative: Telegram** jika:
- Lebih mudah (no webhook needed)
- Sudah familiar dengan Telegram
- Ingin quick setup (5 menit)

---

## 📊 NOTIFICATION FLOW

```
Detection System
      │
      ├─ Hazard Detected!
      │
      ├─ Check config: notifications not empty?
      │     │
      │     ├─ Yes → Send to chat apps
      │     │         │
      │     │         ├─ LINE: line_notifier.py
      │     │         ├─ Telegram: telegram_notifier.py
      │     │         └─ WeChat: wechat_notifier.py
      │     │
      │     └─ No → Skip notifications ❌ (CURRENT STATE)
      │
      └─ Continue detection
```

---

## 🔧 TROUBLESHOOTING

### "LINE bot tidak respond"

**Check:**
1. LINE bot service running? (terminal 6)
2. Ngrok running? (terminal 7)
3. Webhook URL correct di LINE Developer Console?
4. Webhook verified (green check)?

**Test webhook:**
```bash
curl -X POST https://your-ngrok-url.ngrok-free.app/webhook
```

### "Telegram tidak kirim message"

**Check:**
1. Bot token correct?
2. Chat ID correct?
3. Bot di-start (kirim /start ke bot)?

**Test manual:**
```bash
curl "https://api.telegram.org/bot<TOKEN>/sendMessage?chat_id=<CHAT_ID>&text=Test"
```

### "Notifications masih tidak kirim"

**Check notifications config di database:**

```bash
# Jalankan di MySQL
mysql -u root

USE construction_hazard_detection;

SELECT id, stream_name, notifications FROM stream_configs;
```

Pastikan `notifications` column **tidak kosong**.

**Update di database jika perlu:**
```sql
UPDATE stream_configs
SET notifications = '{"Uxxxxx": "en"}'
WHERE id = 1;
```

---

## 📝 EXAMPLE COMPLETE SETUP (LINE)

### .env
```bash
# LINE Configuration
LINE_CHANNEL_ACCESS_TOKEN='eyJhbGciOiJIUzI1NiJ9...'
LINE_CHANNEL_SECRET='abc123def456...'

# Optional: Cloudinary for images
CLOUDINARY_CLOUD_NAME='your_cloud'
CLOUDINARY_API_KEY='123456789'
CLOUDINARY_API_SECRET='abc123def'
```

### config/test_stream.json
```json
{
  "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
  "site": "Test Site",
  "stream_name": "Local Video Demo",
  "model_key": "yolo11n",
  "notifications": {
    "U1234567890abcdef": "en",
    "C9876543210fedcba": "zh-tw"
  },
  "detect_with_server": false,
  ...
}
```

### Running Services

**Terminal 1-5:** (sudah jalan)
- YOLO API, Violation API, FCM API, DB API, Streaming API

**Terminal 6:** (BARU - LINE Bot)
```bash
cd D:\Construction-Hazard-Detection\examples\line_chatbot
python line_bot.py
```

**Terminal 7:** (BARU - Ngrok)
```bash
cd D:\Construction-Hazard-Detection
ngrok http 8000
```

**Terminal 8:** (Main Detection)
```bash
cd D:\Construction-Hazard-Detection
python main.py --config config/test_stream.json
```

---

## 🎉 EXPECTED RESULT

Saat hazard terdeteksi, Anda akan menerima **message di LINE**:

```
🚨 Construction Hazard Alert

Site: Test Site
Stream: Local Video Demo

Detected Hazards:
- ⚠️ No Safety Helmet (2 workers)
- ⚠️ No Safety Vest (1 worker)
- 🚧 Near Machinery (1 person)

Time: 2025-10-15 14:35:22
Severity: High

[View Details] (button)
```

---

## 📚 ADDITIONAL RESOURCES

- **LINE Messaging API Docs:** https://developers.line.biz/en/docs/messaging-api/
- **Telegram Bot API Docs:** https://core.telegram.org/bots/api
- **WeChat Official Account Docs:** https://developers.weixin.qq.com/doc/
- **Ngrok Docs:** https://ngrok.com/docs

---

## ✅ QUICK START CHECKLIST

### For LINE:
- [ ] Buat LINE Bot di Developer Console
- [ ] Get Channel Access Token & Secret
- [ ] Add credentials ke .env
- [ ] Update line_bot.py dengan dotenv
- [ ] Run LINE bot service (terminal 6)
- [ ] Run ngrok (terminal 7)
- [ ] Set webhook URL di LINE Console
- [ ] Add bot sebagai friend / invite ke group
- [ ] Get User/Group ID
- [ ] Update notifications di test_stream.json
- [ ] Restart main.py
- [ ] Test detection → Check LINE message!

### For Telegram:
- [ ] Chat dengan @BotFather
- [ ] Create bot dengan /newbot
- [ ] Copy bot token
- [ ] Add token ke .env
- [ ] Start chat dengan bot
- [ ] Get chat ID dari getUpdates
- [ ] Update notifications di test_stream.json
- [ ] Restart main.py
- [ ] Test detection → Check Telegram message!

---

**SUMMARY:**

**MASALAH:** Chat notifications tidak aktif karena:
1. ❌ `notifications: {}` kosong di config
2. ❌ Tidak ada LINE/Telegram credentials di .env
3. ❌ Chat bot services tidak berjalan

**SOLUSI:**
1. ✅ Setup LINE/Telegram bot (5-15 menit)
2. ✅ Add credentials ke .env
3. ✅ Update notifications config
4. ✅ Run chat bot service
5. ✅ Test!

**RESULT:**
Real-time hazard alerts langsung ke HP via LINE/Telegram! 📱🚨

---

Created: 2025-10-15
For: Construction Hazard Detection - Enable Chat Notifications
