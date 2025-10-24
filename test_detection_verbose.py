"""
Verbose Detection Test - See what's happening
"""
import asyncio
import json
import os
import sys
from dotenv import load_dotenv

# Fix Windows console encoding
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

# Load environment variables
load_dotenv()

print("="*70)
print("  VERBOSE DETECTION TEST")
print("="*70)
print()

# Check .env
print("[1] Checking .env configuration...")
telegram_token = os.getenv('TELEGRAM_BOT_TOKEN')
if telegram_token:
    print(f"OK TELEGRAM_BOT_TOKEN found: {telegram_token[:20]}...")
else:
    print("ERROR TELEGRAM_BOT_TOKEN NOT FOUND in .env!")
    print("Please check your .env file")
    exit(1)

print()

# Check config
print("[2] Checking config file...")
config_path = "config/test_stream.json"
try:
    with open(config_path, 'r') as f:
        config = json.load(f)

    print(f"✅ Config loaded: {config_path}")

    stream = config[0]
    print(f"   Site: {stream['site']}")
    print(f"   Stream: {stream['stream_name']}")
    print(f"   Video: {stream['video_url']}")
    print(f"   Model: {stream['model_key']}")

    # Check notifications
    notifications = stream.get('notifications', {})
    if notifications:
        print(f"   Notifications: {notifications}")
        for chat_id, lang in notifications.items():
            if chat_id.startswith('telegram:'):
                print(f"   ✅ Telegram configured: {chat_id} ({lang})")
    else:
        print("   ❌ NO notifications configured!")

    # Check detection items
    detection_items = stream.get('detection_items', {})
    print(f"   Detection items enabled:")
    for item, enabled in detection_items.items():
        status = "✅" if enabled else "❌"
        print(f"      {status} {item}: {enabled}")

except FileNotFoundError:
    print(f"❌ Config file not found: {config_path}")
    exit(1)
except json.JSONDecodeError:
    print(f"❌ Invalid JSON in config file!")
    exit(1)

print()

# Check video file
print("[3] Checking video file...")
video_path = stream['video_url']
if os.path.exists(video_path):
    file_size = os.path.getsize(video_path) / (1024 * 1024)  # MB
    print(f"✅ Video file found: {video_path}")
    print(f"   Size: {file_size:.2f} MB")
else:
    print(f"❌ Video file NOT found: {video_path}")
    print("   Detection cannot run without video!")
    exit(1)

print()

# Test Telegram
print("[4] Testing Telegram bot...")
from src.notifiers.telegram_notifier import TelegramNotifier

async def test_telegram():
    notifier = TelegramNotifier()
    chat_id = "5856651174"

    message = """🧪 DETECTION TEST

This is a test from verbose detection script.

If you receive this, Telegram bot is working!

Now starting detection...
"""

    try:
        response = await notifier.send_notification(
            chat_id=chat_id,
            message=message,
            bot_token=telegram_token
        )
        print(f"✅ Telegram test successful!")
        print(f"   Message ID: {response.message_id}")
        return True
    except Exception as e:
        print(f"❌ Telegram test FAILED!")
        print(f"   Error: {e}")
        return False

success = asyncio.run(test_telegram())

if not success:
    print()
    print("Telegram not working! Fix above error first.")
    exit(1)

print()
print("="*70)
print("  ALL CHECKS PASSED!")
print("="*70)
print()
print("Now you can run detection:")
print("  python main.py --config config\\test_stream.json")
print()
print("What to expect:")
print("  1. Video will start processing")
print("  2. YOLO will detect objects (persons, vehicles, etc)")
print("  3. If violations detected:")
print("     - Console will show: ⚠️ Violation detected")
print("     - Telegram will receive notification with photo")
print()
print("If NO notifications after several minutes:")
print("  - Video might not contain violations")
print("  - Try different video with workers WITHOUT helmets/vests")
print()
print("="*70)
