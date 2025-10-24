"""
Telegram Violation Monitor
Monitors violation_records table and sends Telegram notifications for new violations
"""
import asyncio
import json
import os
import sys
from datetime import datetime, timedelta
from dotenv import load_dotenv
from asyncmy import create_pool
from sqlalchemy.engine.url import make_url
from src.notifiers import TelegramNotifier

# Fix Windows console encoding
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

load_dotenv()


async def monitor_violations():
    """Monitor violation_records table and send Telegram for new violations"""

    print("=" * 60)
    print("  TELEGRAM VIOLATION MONITOR")
    print("  Real-time Telegram notifications for safety violations")
    print("=" * 60)
    print()

    # Get database connection
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("❌ DATABASE_URL not found in .env!")
        return

    url = make_url(database_url)

    try:
        pool = await create_pool(
            host=url.host,
            port=url.port or 3306,
            user=url.username,
            password=url.password or '',
            db=url.database,
            autocommit=True,
            maxsize=5
        )
        print("✅ Connected to database")
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        return

    # Initialize Telegram notifier
    telegram_notifier = TelegramNotifier()
    chat_id = "5856651174"  # Your Telegram chat ID

    # Check bot token
    bot_token = os.getenv('TELEGRAM_BOT_TOKEN')
    if not bot_token:
        print("❌ TELEGRAM_BOT_TOKEN not found in .env!")
        return

    print(f"✅ Telegram bot configured")
    print(f"📱 Chat ID: {chat_id}")
    print()

    # Track last checked violation ID to avoid duplicates
    last_violation_id = 0

    # Get initial last violation ID
    try:
        async with pool.acquire() as conn:
            async with conn.cursor() as cursor:
                await cursor.execute("""
                    SELECT COALESCE(MAX(id), 0) FROM violations
                """)
                result = await cursor.fetchone()
                last_violation_id = result[0] if result else 0
                print(f"🔍 Starting from violation ID: {last_violation_id}")
    except Exception as e:
        print(f"❌ Failed to get last violation ID: {e}")

    print()
    print("🚀 Monitoring started! Waiting for new violations...")
    print("   Press Ctrl+C to stop")
    print()

    violation_count = 0

    while True:
        try:
            async with pool.acquire() as conn:
                async with conn.cursor() as cursor:
                    # Get new violations since last check
                    await cursor.execute("""
                        SELECT id, site, stream_name, detection_time,
                               warnings_json, image_path
                        FROM violations
                        WHERE id > %s
                        ORDER BY id ASC
                    """, (last_violation_id,))

                    violations = await cursor.fetchall()

                    for violation in violations:
                        vid_id, site, stream, det_time, warnings_json, image_path = violation

                        # Parse warnings
                        try:
                            warnings = json.loads(warnings_json) if warnings_json else []
                        except:
                            warnings = []

                        # Format message
                        message = f"""⚠️ Safety Violation Detected!

Site: {site}
Stream: {stream}
Time: {det_time.strftime('%Y-%m-%d %H:%M:%S')}

Violations:
"""
                        if warnings:
                            for warning in warnings:
                                message += f"• {warning}\n"
                        else:
                            message += "• General safety violation\n"

                        message += f"\nViolation ID: {vid_id}"

                        # Send notification
                        try:
                            # Read image if exists
                            photo = None
                            if image_path and os.path.exists(image_path):
                                with open(image_path, 'rb') as f:
                                    photo = f.read()
                                print(f"📸 Image found: {image_path}")

                            # Send Telegram notification
                            response = await telegram_notifier.send_notification(
                                chat_id=chat_id,
                                message=message,
                                photo=photo
                            )

                            violation_count += 1

                            print(f"✅ [{violation_count}] Telegram sent for violation #{vid_id}")
                            print(f"   Site: {site} | Stream: {stream}")
                            print(f"   Time: {det_time.strftime('%H:%M:%S')}")
                            if response:
                                print(f"   Message ID: {response.message_id}")
                            print()

                        except Exception as e:
                            print(f"❌ Failed to send Telegram for violation #{vid_id}: {e}")
                            print()

                        # Update last processed violation ID
                        last_violation_id = vid_id

        except Exception as e:
            print(f"❌ Monitor error: {e}")

        # Check every 3 seconds
        await asyncio.sleep(3)


async def test_connection():
    """Test Telegram connection before starting monitor"""
    print("Testing Telegram connection...")

    telegram_notifier = TelegramNotifier()
    chat_id = "5856651174"

    try:
        response = await telegram_notifier.send_notification(
            chat_id=chat_id,
            message="🔔 Telegram Violation Monitor started!\n\nMonitoring for safety violations..."
        )

        if response:
            print(f"✅ Test message sent! Message ID: {response.message_id}")
            print()
            return True
        else:
            print("❌ Test message failed!")
            return False

    except Exception as e:
        print(f"❌ Telegram test failed: {e}")
        return False


async def main():
    """Main entry point"""
    # Test connection first
    if not await test_connection():
        print("\n⚠️ Telegram connection test failed!")
        print("Please check:")
        print("  1. TELEGRAM_BOT_TOKEN in .env")
        print("  2. Chat ID is correct (5856651174)")
        print("  3. You have started a conversation with the bot")
        return

    # Start monitoring
    await monitor_violations()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n")
        print("=" * 60)
        print("  Monitor stopped by user")
        print("=" * 60)
    except Exception as e:
        print(f"\n❌ Fatal error: {e}")
