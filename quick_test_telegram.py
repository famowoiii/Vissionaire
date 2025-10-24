"""
Quick Telegram Bot Test - Send message now!
"""
import asyncio
import os
import sys
from dotenv import load_dotenv
from src.notifiers.telegram_notifier import TelegramNotifier

# Fix Windows console encoding
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

async def send_test():
    load_dotenv()

    # Your configuration
    chat_id = "5856651174"
    bot_token = os.getenv('TELEGRAM_BOT_TOKEN')

    print(f"\n{'='*60}")
    print(f"  TESTING TELEGRAM BOT")
    print(f"{'='*60}\n")

    print(f"Chat ID: {chat_id}")
    print(f"Bot Token: {bot_token[:20]}...")
    print(f"\nSending test message to Telegram...\n")

    notifier = TelegramNotifier()

    message = """🎉 SUCCESS!

Your Telegram Bot is working!

✅ Bot Token: Configured
✅ Chat ID: 5856651174
✅ Connection: Active

🏗️ Construction Hazard Detection System
Ready to send safety alerts!

Next: Run detection with notifications enabled.
"""

    try:
        response = await notifier.send_notification(
            chat_id=chat_id,
            message=message,
            bot_token=bot_token
        )

        print(f"SUCCESS! Message sent!")
        print(f"Message ID: {response.message_id}")
        print(f"\n{'='*60}")
        print(f"Check your Telegram app now!")
        print(f"{'='*60}\n")

    except Exception as e:
        print(f"ERROR: {e}\n")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(send_test())
