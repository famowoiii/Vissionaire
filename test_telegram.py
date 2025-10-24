"""
Test Telegram Bot Notification System
"""
import asyncio
import os
import sys
import numpy as np
from dotenv import load_dotenv
from src.notifiers.telegram_notifier import TelegramNotifier

# Color codes for terminal output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'


async def test_text_message():
    """Test sending text message to Telegram"""
    print(f"\n{BLUE}{'='*60}{RESET}")
    print(f"{BLUE}TEST 1: Sending Text Message{RESET}")
    print(f"{BLUE}{'='*60}{RESET}\n")

    load_dotenv()

    # Get configuration
    bot_token = os.getenv('TELEGRAM_BOT_TOKEN')
    chat_id = input(f"{YELLOW}Enter your Telegram Chat ID: {RESET}").strip()

    if not bot_token:
        print(f"{RED}❌ ERROR: TELEGRAM_BOT_TOKEN not found in .env file!{RESET}")
        print(f"{YELLOW}Please add to .env:{RESET}")
        print(f"TELEGRAM_BOT_TOKEN=your_bot_token_here")
        return False

    if not chat_id:
        print(f"{RED}❌ ERROR: Chat ID is required!{RESET}")
        return False

    # Initialize notifier
    notifier = TelegramNotifier()

    # Prepare message
    message = """🔔 Test Notification

🏗️ Construction Hazard Detection System

This is a test message to verify Telegram bot integration.

✅ If you received this, your Telegram bot is working correctly!

System Status:
• Bot Token: Configured ✓
• Connection: Active ✓
• Notifications: Enabled ✓

Next: Test with image notification.
"""

    try:
        print(f"{YELLOW}Sending message to Telegram chat {chat_id}...{RESET}")

        response = await notifier.send_notification(
            chat_id=chat_id,
            message=message,
            bot_token=bot_token
        )

        print(f"\n{GREEN}✅ SUCCESS!{RESET}")
        print(f"{GREEN}Message sent successfully!{RESET}")
        print(f"{GREEN}Message ID: {response.message_id}{RESET}\n")
        return True

    except Exception as e:
        print(f"\n{RED}❌ FAILED!{RESET}")
        print(f"{RED}Error: {e}{RESET}\n")
        return False


async def test_image_message(chat_id: str):
    """Test sending message with image to Telegram"""
    print(f"\n{BLUE}{'='*60}{RESET}")
    print(f"{BLUE}TEST 2: Sending Message with Image{RESET}")
    print(f"{BLUE}{'='*60}{RESET}\n")

    load_dotenv()
    bot_token = os.getenv('TELEGRAM_BOT_TOKEN')

    # Initialize notifier
    notifier = TelegramNotifier()

    # Create test image (red alert background with text)
    print(f"{YELLOW}Creating test violation image...{RESET}")
    image = np.zeros((600, 800, 3), dtype=np.uint8)

    # Red background for alert
    image[:, :] = [200, 50, 50]

    # Add some variation (simulate construction site)
    image[100:500, 100:700] = [255, 200, 100]  # Warning zone

    # Prepare violation message
    message = """🚨 SAFETY VIOLATION DETECTED

Site: Test Site
Camera: Local Video Demo
Time: 2025-01-21 14:30:15

⚠️ Violations:
• Worker without safety helmet
• Worker without safety vest
• Worker in restricted area

Location: Zone A - Construction Area

📸 Violation photo attached below.

⚡ Action Required:
Please investigate immediately and ensure all workers comply with safety regulations.

Status: ACTIVE ALERT
Priority: HIGH
"""

    try:
        print(f"{YELLOW}Sending image message to Telegram...{RESET}")

        response = await notifier.send_notification(
            chat_id=chat_id,
            message=message,
            image=image,
            bot_token=bot_token
        )

        print(f"\n{GREEN}✅ SUCCESS!{RESET}")
        print(f"{GREEN}Image message sent successfully!{RESET}")
        print(f"{GREEN}Message ID: {response.message_id}{RESET}\n")
        return True

    except Exception as e:
        print(f"\n{RED}❌ FAILED!{RESET}")
        print(f"{RED}Error: {e}{RESET}\n")
        return False


async def main():
    """Main test function"""
    print(f"\n{BLUE}{'='*60}{RESET}")
    print(f"{BLUE}   TELEGRAM BOT TESTING SUITE{RESET}")
    print(f"{BLUE}   Construction Hazard Detection System{RESET}")
    print(f"{BLUE}{'='*60}{RESET}\n")

    # Instructions
    print(f"{YELLOW}Before starting, make sure you have:{RESET}")
    print(f"  1. Created a Telegram bot via @BotFather")
    print(f"  2. Added TELEGRAM_BOT_TOKEN to .env file")
    print(f"  3. Started a chat with your bot (send /start)")
    print(f"  4. Obtained your Chat ID (via getUpdates API)")
    print()
    print(f"{YELLOW}Need help? Read: TELEGRAM_BOT_SETUP.md{RESET}")
    print()

    input(f"{YELLOW}Press Enter to continue...{RESET}")

    # Test 1: Text message
    success_1 = await test_text_message()

    if not success_1:
        print(f"\n{RED}First test failed. Please fix the issues and try again.{RESET}")
        print(f"\n{YELLOW}Common Issues:{RESET}")
        print(f"  • Bot token not in .env file")
        print(f"  • Wrong chat ID")
        print(f"  • Bot not started by user (/start)")
        print(f"  • Bot blocked by user")
        return

    # Ask if user wants to continue
    print(f"\n{YELLOW}Check your Telegram. Did you receive the message?{RESET}")
    continue_test = input(f"{YELLOW}Continue with image test? (y/n): {RESET}").lower()

    if continue_test != 'y':
        print(f"\n{BLUE}Test completed. Exiting...{RESET}")
        return

    # Get chat ID for second test
    chat_id = input(f"{YELLOW}Enter your Chat ID again: {RESET}").strip()

    # Test 2: Image message
    success_2 = await test_image_message(chat_id)

    # Summary
    print(f"\n{BLUE}{'='*60}{RESET}")
    print(f"{BLUE}TEST SUMMARY{RESET}")
    print(f"{BLUE}{'='*60}{RESET}\n")

    print(f"Test 1 (Text Message):  {GREEN if success_1 else RED}{'PASSED' if success_1 else 'FAILED'}{RESET}")
    print(f"Test 2 (Image Message): {GREEN if success_2 else RED}{'PASSED' if success_2 else 'FAILED'}{RESET}")

    if success_1 and success_2:
        print(f"\n{GREEN}{'='*60}{RESET}")
        print(f"{GREEN}✅ ALL TESTS PASSED!{RESET}")
        print(f"{GREEN}{'='*60}{RESET}\n")
        print(f"{GREEN}Your Telegram bot is working correctly!{RESET}")
        print(f"{GREEN}You can now use it with the detection system.{RESET}\n")

        print(f"{YELLOW}Next Steps:{RESET}")
        print(f"  1. Update config/test_stream.json with your Chat ID")
        print(f"  2. Run detection: python main.py --config config\\test_stream.json")
        print(f"  3. Receive real-time violation alerts on Telegram!")
        print()
    else:
        print(f"\n{RED}{'='*60}{RESET}")
        print(f"{RED}❌ SOME TESTS FAILED{RESET}")
        print(f"{RED}{'='*60}{RESET}\n")
        print(f"{YELLOW}Please check the errors above and try again.{RESET}")
        print(f"{YELLOW}Read TELEGRAM_BOT_SETUP.md for detailed instructions.{RESET}\n")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print(f"\n\n{YELLOW}Test interrupted by user.{RESET}")
        sys.exit(0)
    except Exception as e:
        print(f"\n{RED}Unexpected error: {e}{RESET}")
        sys.exit(1)
