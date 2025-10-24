# 📝 TELEGRAM CONFIGURATION EXAMPLES

## 🎯 BASIC CONFIGURATION

### Single User (English)
```json
"notifications": {
  "telegram:123456789": "en"
}
```

### Single User (Chinese Traditional)
```json
"notifications": {
  "telegram:123456789": "zh-tw"
}
```

---

## 👥 MULTIPLE USERS

### Multiple Personal Chats
```json
"notifications": {
  "telegram:123456789": "en",
  "telegram:987654321": "zh-tw",
  "telegram:555444333": "ja"
}
```

**Explanation:**
- User 1 receives alerts in English
- User 2 receives alerts in Traditional Chinese
- User 3 receives alerts in Japanese

---

## 👨‍👩‍👧‍👦 GROUP CHATS

### Single Group
```json
"notifications": {
  "telegram:-1001234567890": "en"
}
```

**Note:** Group IDs always start with `-` (negative number)!

### Multiple Groups
```json
"notifications": {
  "telegram:-1001234567890": "en",
  "telegram:-1009876543210": "zh-tw"
}
```

---

## 🌐 MIXED CONFIGURATION

### Users + Groups + Multiple Languages
```json
"notifications": {
  "telegram:123456789": "en",
  "telegram:987654321": "zh-tw",
  "telegram:-1001234567890": "en",
  "telegram:-1009876543210": "zh-cn"
}
```

**Explanation:**
- Personal chat (User 1): English
- Personal chat (User 2): Traditional Chinese
- Group chat 1: English
- Group chat 2: Simplified Chinese

---

## 🔀 TELEGRAM + LINE + OTHER PLATFORMS

### Telegram + LINE
```json
"notifications": {
  "telegram:123456789": "en",
  "Uxxxxxxxxxxxxx": "zh-tw"
}
```

**Format:**
- Telegram: `telegram:CHAT_ID`
- LINE User: `Uxxxxxxxxxxxxx` (starts with U)
- LINE Group: `Cxxxxxxxxxxxxx` (starts with C)

### All Platforms Combined
```json
"notifications": {
  "telegram:123456789": "en",
  "telegram:-1001234567890": "en",
  "Uxxxxxxxxxxxxx": "zh-tw",
  "Cxxxxxxxxxxxxx": "zh-tw"
}
```

---

## 🌍 SUPPORTED LANGUAGES

| Code | Language | Example Notification |
|------|----------|---------------------|
| `en` | English | "Safety Violation Detected" |
| `zh-tw` | 繁體中文 (Traditional) | "偵測到安全違規" |
| `zh-cn` | 简体中文 (Simplified) | "检测到安全违规" |
| `ja` | 日本語 (Japanese) | "安全違反が検出されました" |
| `es` | Español (Spanish) | "Violación de seguridad detectada" |
| `fr` | Français (French) | "Violation de sécurité détectée" |
| `de` | Deutsch (German) | "Sicherheitsverstoß erkannt" |

---

## 📋 COMPLETE STREAM CONFIG EXAMPLE

```json
[
  {
    "video_url": "rtsp://192.168.1.100:554/stream",
    "site": "Construction Site Alpha",
    "stream_name": "Main Entrance Camera",
    "model_key": "yolo11m",
    "detect_with_server": false,

    "notifications": {
      "telegram:123456789": "en",
      "telegram:987654321": "zh-tw",
      "telegram:-1001234567890": "en"
    },

    "detection_items": {
      "detect_no_safety_vest_or_helmet": true,
      "detect_near_machinery_or_vehicle": true,
      "detect_in_restricted_area": true
    },

    "work_start_hour": 8,
    "work_end_hour": 18,
    "store_in_redis": true,
    "save_violations_to_db": true,

    "violation_config": {
      "cooldown_period": 60,
      "min_confidence": 0.5
    }
  }
]
```

---

## 🔧 HOW TO GET CHAT IDs

### Personal Chat ID

1. Start chat with your bot
2. Send any message (e.g., `/start`)
3. Visit in browser:
   ```
   https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates
   ```
4. Look for: `"chat":{"id":123456789`
5. Copy the number after `"id":`

**Example API Response:**
```json
{
  "ok": true,
  "result": [
    {
      "update_id": 123456789,
      "message": {
        "message_id": 1,
        "from": {
          "id": 123456789,
          "first_name": "John"
        },
        "chat": {
          "id": 123456789,  ← YOUR CHAT ID
          "first_name": "John",
          "type": "private"
        },
        "text": "/start"
      }
    }
  ]
}
```

### Group Chat ID

1. Add your bot to the group
2. Send a message in the group (mention the bot: `@YourBot test`)
3. Visit the same getUpdates URL
4. Look for: `"chat":{"id":-1001234567890`
5. Copy the negative number

**Example API Response:**
```json
{
  "ok": true,
  "result": [
    {
      "update_id": 987654321,
      "message": {
        "message_id": 5,
        "from": {
          "id": 123456789,
          "first_name": "John"
        },
        "chat": {
          "id": -1001234567890,  ← GROUP CHAT ID
          "title": "Safety Team",
          "type": "group"
        },
        "text": "@YourBot test"
      }
    }
  ]
}
```

---

## ⚙️ TESTING CONFIGURATION

### Test Your Config

Create `config/my_test.json`:
```json
[
  {
    "video_url": "D:/Construction-Hazard-Detection/tests/videos/test.mp4",
    "site": "Test Site",
    "stream_name": "Demo",
    "model_key": "yolo11n",
    "detect_with_server": false,

    "notifications": {
      "telegram:YOUR_CHAT_ID": "en"
    },

    "detection_items": {
      "detect_no_safety_vest_or_helmet": true
    },

    "work_start_hour": 0,
    "work_end_hour": 24,
    "store_in_redis": false,
    "save_violations_to_db": false
  }
]
```

Replace `YOUR_CHAT_ID` with your actual Chat ID!

### Run Test
```cmd
python main.py --config config\my_test.json
```

---

## 🚨 NOTIFICATION MESSAGE FORMAT

When a violation is detected, you'll receive:

**English:**
```
🚨 Safety Violation Detected

Site: Construction Site Alpha
Camera: Main Entrance Camera
Time: 2025-01-21 14:30:15

⚠️ Violations:
• Worker without safety helmet
• Worker without safety vest

Location: Zone A - Construction Area

[Photo attached]

Please take immediate action!
```

**繁體中文:**
```
🚨 偵測到安全違規

工地: Construction Site Alpha
攝影機: Main Entrance Camera
時間: 2025-01-21 14:30:15

⚠️ 違規項目:
• 工人未戴安全帽
• 工人未穿安全背心

位置: Zone A - Construction Area

[附加照片]

請立即採取行動！
```

---

## 💡 BEST PRACTICES

### 1. Separate Notifications by Role
```json
"notifications": {
  "telegram:111111111": "en",     // Site Manager
  "telegram:222222222": "en",     // Safety Officer
  "telegram:-1001234567890": "en" // Safety Team Group
}
```

### 2. Use Different Languages for Different Teams
```json
"notifications": {
  "telegram:111111111": "en",      // International team
  "telegram:222222222": "zh-tw",   // Taiwan team
  "telegram:333333333": "ja"       // Japan team
}
```

### 3. Cooldown Period to Avoid Spam
```json
"violation_config": {
  "cooldown_period": 60,  // Don't send same violation within 60 seconds
  "min_confidence": 0.5   // Only send if detection confidence > 50%
}
```

---

## 🔐 SECURITY TIPS

1. **Don't commit .env file**
   - Add `.env` to `.gitignore`
   - Never share your Bot Token

2. **Use environment variables**
   - Store Bot Token in `.env`: `TELEGRAM_BOT_TOKEN=...`
   - Don't hardcode tokens in config files

3. **Restrict bot access**
   - Set bot privacy mode in @BotFather
   - `/setprivacy` → Disable (bot can only see commands)

4. **Use private groups**
   - Make groups invite-only
   - Don't share group links publicly

---

## 📞 TROUBLESHOOTING

### "Chat not found" Error
```json
// ❌ Wrong format
"notifications": {
  "123456789": "en"
}

// ✅ Correct format
"notifications": {
  "telegram:123456789": "en"
}
```

### Group ID Not Working
```json
// ❌ Missing minus sign
"notifications": {
  "telegram:1001234567890": "en"
}

// ✅ Correct (negative number)
"notifications": {
  "telegram:-1001234567890": "en"
}
```

### Bot Not Sending Messages
**Checklist:**
- ✅ Bot Token in `.env` file?
- ✅ Format: `telegram:CHAT_ID`?
- ✅ Started chat with bot (`/start`)?
- ✅ Detection running?
- ✅ Violations detected? (check console logs)

---

## 📚 RELATED FILES

- `TELEGRAM_BOT_SETUP.md` - Complete setup guide
- `TELEGRAM_QUICK_START.md` - 5-minute quick start
- `test_telegram.py` - Test notification script
- `config/test_stream_with_telegram.json` - Example config
- `ENABLE_CHAT_NOTIFICATIONS.md` - Multi-platform notifications

---

**Ready to receive safety alerts on Telegram!** 🚀
