# 🐛 MASALAH: Telegram Notifications Tidak Terkirim

## ❗ DIAGNOSA:

### **Problem:**
- Violation records **berhasil** disimpan ke database ✅
- Tapi **TIDAK ADA** notifikasi Telegram yang terkirim ❌

### **Root Cause:**
File `main.py` **TIDAK MENGGUNAKAN** field `notifications` dari config JSON!

---

## 🔍 ANALISIS KODE:

### **Config JSON (BENAR):**
```json
{
  "notifications": {
    "telegram:5856651174": "en"
  }
}
```

### **main.py - `_run_single_stream` (MASALAH!):**

**Line 326-336: Config di-load tapi `notifications` DIABAIKAN!**
```python
async def _run_single_stream(cfg: StreamConfig) -> None:
    video_url = cfg['video_url']
    model_key = cfg['model_key']
    site = cfg['site']
    stream_name = cfg['stream_name']
    detect_with_server = cfg['detect_with_server']
    detection_items = cfg['detection_items']
    work_start_hour = cfg['work_start_hour']
    work_end_hour = cfg['work_end_hour']
    store_in_redis = cfg['store_in_redis']

    # ❌ NOTIFICATIONS TIDAK DI-EXTRACT!
```

**Line 417-449: Hanya FCM, TIDAK ADA Telegram!**
```python
if warnings and Utils.should_notify(int(ts), last_notification_time):
    # 1. Send violation record ✅
    violation_id_str = await violation_sender.send_violation(...)

    # 2. Send FCM notification ✅
    await fcm_sender.send_fcm_message_to_site(...)

    # ❌ 3. TELEGRAM NOTIFICATION TIDAK ADA!
    last_notification_time = int(ts)
```

---

## ✅ SOLUSI:

Tambahkan Telegram notification handling di `main.py`:

### **Step 1: Import TelegramNotifier**
```python
# main.py - top of file
from src.notifiers import TelegramNotifier
```

### **Step 2: Extract notifications dari config**
```python
# main.py - line ~336
async def _run_single_stream(cfg: StreamConfig) -> None:
    # ... existing code ...

    # ADD THIS:
    notifications = cfg.get('notifications', {})  # Extract notifications field
```

### **Step 3: Initialize Telegram Notifier**
```python
# main.py - line ~347 (after other initializers)
# Initialize TelegramNotifier if telegram notifications configured
telegram_notifier = TelegramNotifier()
telegram_chat_ids = []  # List of (chat_id, language) tuples

for notif_key, language in notifications.items():
    if notif_key.startswith('telegram:'):
        chat_id = notif_key.split(':', 1)[1]
        telegram_chat_ids.append((chat_id, language))
```

### **Step 4: Send Telegram Notification saat violation**
```python
# main.py - line ~442 (after FCM sender)
# Send Telegram notifications
for chat_id, language in telegram_chat_ids:
    try:
        # Format violation message
        message = format_telegram_message(
            site=site,
            stream_name=stream_name,
            warnings=warnings,
            detection_time=detection_time,
            language=language
        )

        # Send Telegram notification with image
        await telegram_notifier.send_notification(
            chat_id=chat_id,
            message=message,
            photo=frame_bytes  # Send violation image
        )
        print(f"✅ Telegram sent to {chat_id}")
    except Exception as e:
        print(f"❌ Telegram failed: {e}")
```

### **Step 5: Add helper function**
```python
# main.py - add this function
def format_telegram_message(
    site: str,
    stream_name: str,
    warnings: list,
    detection_time: datetime,
    language: str = 'en'
) -> str:
    """Format violation message for Telegram"""

    messages = {
        'en': {
            'title': '⚠️ Safety Violation Detected!',
            'site': 'Site',
            'stream': 'Stream',
            'time': 'Time',
            'violations': 'Violations'
        },
        # Add more languages as needed
    }

    msg = messages.get(language, messages['en'])

    text = f"{msg['title']}\n\n"
    text += f"{msg['site']}: {site}\n"
    text += f"{msg['stream']}: {stream_name}\n"
    text += f"{msg['time']}: {detection_time.strftime('%Y-%m-%d %H:%M:%S')}\n\n"
    text += f"{msg['violations']}:\n"

    for warning in warnings:
        text += f"• {warning}\n"

    return text
```

---

## 🔧 QUICK FIX (Manual):

Jika Anda tidak ingin modify main.py sekarang, gunakan **Python script terpisah** untuk monitor violation records dan send Telegram:

### **File: `telegram_violation_monitor.py`**
```python
import asyncio
import os
from datetime import datetime, timedelta
from dotenv import load_dotenv
from asyncmy import create_pool
from sqlalchemy.engine.url import make_url
from src.notifiers import TelegramNotifier

load_dotenv()

async def monitor_violations():
    """Monitor violation_records table and send Telegram for new violations"""

    database_url = os.getenv('DATABASE_URL')
    url = make_url(database_url)

    pool = await create_pool(
        host=url.host,
        port=url.port or 3306,
        user=url.username,
        password=url.password or '',
        db=url.database,
        autocommit=True
    )

    telegram_notifier = TelegramNotifier()
    chat_id = "5856651174"
    last_check = datetime.now()

    print("🔍 Monitoring violations for Telegram notifications...")

    while True:
        try:
            async with pool.acquire() as conn:
                async with conn.cursor() as cursor:
                    # Get violations since last check
                    await cursor.execute("""
                        SELECT id, site, stream_name, detection_time, warnings_json, image_path
                        FROM violation_records
                        WHERE detection_time > %s
                        ORDER BY detection_time ASC
                    """, (last_check,))

                    violations = await cursor.fetchall()

                    for violation in violations:
                        vid_id, site, stream, det_time, warnings_json, image_path = violation

                        # Format message
                        message = f"""⚠️ Safety Violation Detected!

Site: {site}
Stream: {stream}
Time: {det_time.strftime('%Y-%m-%d %H:%M:%S')}

Violation ID: {vid_id}
"""

                        # Send notification
                        try:
                            # Read image if exists
                            photo = None
                            if image_path and os.path.exists(image_path):
                                with open(image_path, 'rb') as f:
                                    photo = f.read()

                            await telegram_notifier.send_notification(
                                chat_id=chat_id,
                                message=message,
                                photo=photo
                            )
                            print(f"✅ Sent Telegram for violation {vid_id}")
                        except Exception as e:
                            print(f"❌ Failed to send Telegram: {e}")

                    if violations:
                        last_check = violations[-1][3]  # Update to last detection time

        except Exception as e:
            print(f"❌ Monitor error: {e}")

        await asyncio.sleep(5)  # Check every 5 seconds

if __name__ == "__main__":
    asyncio.run(monitor_violations())
```

### **Usage:**
```cmd
# Terminal terpisah
cd /d D:\Construction-Hazard-Detection
python telegram_violation_monitor.py
```

Ini akan monitor database dan send Telegram untuk setiap violation baru!

---

## 📊 PERBANDINGAN:

### **SEKARANG (Broken):**
```
Violation Detected
  ↓
Send to violation_records API (port 8002) ✅
  ↓
Save to MySQL database ✅
  ↓
Send FCM notification ✅
  ↓
❌ NO Telegram notification
```

### **SETELAH FIX:**
```
Violation Detected
  ↓
Send to violation_records API (port 8002) ✅
  ↓
Save to MySQL database ✅
  ↓
Send FCM notification ✅
  ↓
✅ Send Telegram notification (with image!)
```

---

## 🎯 KESIMPULAN:

**Masalah:** Config punya `notifications: {" telegram:5856651174": "en"}` tapi main.py TIDAK MENGGUNAKANNYA!

**Root Cause:** Field `notifications` dari config JSON diabaikan di `_run_single_stream()`

**Solusi:**
1. **Permanent:** Modify main.py untuk extract & use notifications field
2. **Quick:** Run telegram_violation_monitor.py sebagai service terpisah

**Recommendation:** Gunakan quick fix dulu (telegram_violation_monitor.py) untuk testing, lalu nanti update main.py untuk permanent solution.

---

Saya bisa buatkan file `telegram_violation_monitor.py` sekarang jika Anda mau! 🚀
