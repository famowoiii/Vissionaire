"""Monitor detection and Redis in real-time"""
import redis
import time
import sys

print("="*60)
print("DETECTION & REDIS MONITOR")
print("="*60)
print("\nThis will monitor Redis keys every 3 seconds.")
print("Press Ctrl+C to stop.\n")

try:
    r = redis.Redis(host='127.0.0.1', port=6379, decode_responses=True)
    r.ping()
    print("[OK] Connected to Redis\n")
except Exception as e:
    print(f"[ERROR] Cannot connect to Redis: {e}")
    sys.exit(1)

print("Monitoring Redis keys...\n")
print("-"*60)

previous_count = 0
iteration = 0

try:
    while True:
        iteration += 1

        # Get all keys
        all_keys = r.keys('*')
        current_count = len(all_keys)

        # Filter for detection-related keys
        detection_keys = [k for k in all_keys if 'PIDI' in k or 'SMK3' in k or 'frame' in k.lower()]

        print(f"\n[Iteration {iteration}] {time.strftime('%H:%M:%S')}")
        print(f"  Total keys in Redis: {current_count}")
        print(f"  Detection keys: {len(detection_keys)}")

        if current_count != previous_count:
            print(f"  ✓ Keys changed! (was {previous_count}, now {current_count})")
            if detection_keys:
                print(f"  Sample detection keys:")
                for key in detection_keys[:5]:
                    print(f"    - {key}")
        else:
            if current_count == 0:
                print(f"  ⚠ Redis is still EMPTY - detection not writing data yet")
            else:
                print(f"  → No change (stable at {current_count} keys)")

        # Show all keys if small number
        if current_count > 0 and current_count <= 10:
            print(f"  All keys:")
            for key in all_keys:
                print(f"    - {key}")

        previous_count = current_count

        time.sleep(3)

except KeyboardInterrupt:
    print("\n\nMonitoring stopped.")
    print(f"Final count: {previous_count} keys in Redis")
