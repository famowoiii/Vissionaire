# ⚡ TELEGRAM BOT - QUICK START

## 🎯 SETUP DALAM 5 MENIT

### 1️⃣ Buat Bot (2 menit)
1. Buka Telegram, cari: **@BotFather**
2. Ketik: `/newbot`
3. Ikuti instruksi
4. **Copy Bot Token** yang diberikan

### 2️⃣ Dapatkan Chat ID (1 menit)
1. Start chat dengan bot Anda (klik link dari BotFather)
2. Ketik: `/start`
3. Buka browser:
   ```
   https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates
   ```
4. Cari: `"chat":{"id":123456789`
5. **Copy angka Chat ID**

### 3️⃣ Update .env (30 detik)
```env
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz-1234567890
```

### 4️⃣ Update Config (1 menit)
Edit `config/test_stream.json`:
```json
"notifications": {
  "telegram:123456789": "en"
}
```

Ganti `123456789` dengan Chat ID Anda!

### 5️⃣ Test! (30 detik)
```cmd
cd D:\Construction-Hazard-Detection
python test_telegram.py
```

---

## ✅ DONE!

Sekarang jalankan detection:
```cmd
python main.py --config config\test_stream.json
```

Anda akan terima notifikasi di Telegram ketika ada violation! 🎉

---

## 📚 FULL GUIDE

Baca: **TELEGRAM_BOT_SETUP.md** untuk panduan lengkap.

---

## 🔧 TROUBLESHOOTING

**Tidak ada notifikasi?**
1. Check .env ada TELEGRAM_BOT_TOKEN
2. Format benar: `telegram:123456789`
3. Sudah start chat dengan bot
4. Detection sudah running

**Chat ID untuk Group?**
- Group ID dimulai dengan `-` (minus)
- Contoh: `telegram:-1001234567890`

---

## 💡 TIPS

**Multiple Chats:**
```json
"notifications": {
  "telegram:123456789": "en",
  "telegram:987654321": "zh-tw",
  "telegram:-1001234567890": "en"
}
```

**Languages:**
- `en` = English
- `zh-tw` = 繁體中文
- `zh-cn` = 简体中文
- `ja` = 日本語
