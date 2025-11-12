"""Comprehensive check for streaming labels issue"""
import requests
import redis
import json

print("="*60)
print("COMPREHENSIVE DIAGNOSTIC - STREAMING LABELS")
print("="*60)

# 1. Check Redis connection and content
print("\n[1] Checking Redis...")
try:
    r = redis.Redis(host='127.0.0.1', port=6379, password='', decode_responses=True)
    r.ping()
    print("  [OK] Redis is connected")

    # Check for any keys
    keys = r.keys('*')
    print(f"  [INFO] Found {len(keys)} keys in Redis")
    if keys:
        print("  [INFO] Sample keys:")
        for key in keys[:5]:
            print(f"    - {key}")
    else:
        print("  [WARNING] Redis is EMPTY!")
        print("  [INFO] This is why labels are empty!")
        print("  [INFO] Need to run detection (main.py) to populate Redis")
except Exception as e:
    print(f"  [ERROR] Redis error: {e}")

# 2. Check Streaming API (8800)
print("\n[2] Checking Streaming API (8800)...")
try:
    response = requests.get("http://127.0.0.1:8800/docs", timeout=5)
    if response.status_code == 200:
        print("  [OK] Streaming API is running on port 8800")
    else:
        print(f"  [WARNING] Unexpected status: {response.status_code}")
except Exception as e:
    print(f"  [ERROR] Cannot reach Streaming API: {e}")

# 3. Test /labels endpoint (without auth first to see error)
print("\n[3] Testing /labels endpoint (without auth)...")
try:
    response = requests.get("http://127.0.0.1:8800/labels", timeout=5)
    print(f"  Status Code: {response.status_code}")
    if response.status_code == 401:
        print("  [INFO] 401 Unauthorized - This is expected without token")
        print("  [INFO] Web interface needs to send auth token")
    elif response.status_code == 200:
        print("  [OK] Success! Response:")
        print(f"    {response.json()}")
    else:
        print(f"  [WARNING] Unexpected response: {response.text}")
except Exception as e:
    print(f"  [ERROR] Request failed: {e}")

# 4. Login and test with auth
print("\n[4] Testing with authentication...")
try:
    # Login
    login_response = requests.post(
        "http://127.0.0.1:8005/login",
        json={"username": "user", "password": "password"}
    )

    if login_response.status_code == 200:
        token_data = login_response.json()
        access_token = token_data.get('access_token')
        print("  [OK] Login successful")

        # Test /labels with token
        headers = {"Authorization": f"Bearer {access_token}"}
        labels_response = requests.get(
            "http://127.0.0.1:8800/labels",
            headers=headers,
            timeout=5
        )

        print(f"  [OK] /labels response: Status {labels_response.status_code}")
        if labels_response.status_code == 200:
            data = labels_response.json()
            labels = data.get('labels', [])
            print(f"  [OK] Found {len(labels)} labels: {labels}")
            if not labels:
                print("  [INFO] Labels array is EMPTY")
                print("  [INFO] This is NORMAL if detection hasn't run yet")
        else:
            print(f"  [ERROR] Failed: {labels_response.text}")
    else:
        print(f"  [ERROR] Login failed: {login_response.text}")
except Exception as e:
    print(f"  [ERROR] Authentication test failed: {e}")

# 5. Check stream configs in DB
print("\n[5] Checking stream configurations...")
try:
    import pymysql
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='',
        db='construction_hazard_detection',
        charset='utf8mb4'
    )
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id, stream_name, store_in_redis
        FROM stream_configs
    """)
    streams = cursor.fetchall()
    print(f"  [OK] Found {len(streams)} stream configs:")
    for stream_id, stream_name, store_redis in streams:
        redis_status = "YES" if store_redis else "NO"
        print(f"    - {stream_name} (store_in_redis: {redis_status})")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"  [ERROR] Database check failed: {e}")

print("\n" + "="*60)
print("DIAGNOSIS SUMMARY:")
print("="*60)

print("""
POSSIBLE SCENARIOS:

1. If Redis is EMPTY:
   - Labels will be empty array []
   - This is NORMAL before running detection
   - SOLUTION: Run main.py to start detection

2. If /labels returns 401:
   - Web interface not sending auth token properly
   - SOLUTION: Logout & login again

3. If /labels returns 404:
   - Still calling wrong port (8000 instead of 8800)
   - SOLUTION: Clear ALL browser data, set correct URL

4. If /labels returns 200 with empty array:
   - Everything working! Just need to run detection
   - SOLUTION: Start detection with main.py
""")

print("\nNEXT STEPS:")
print("  1. Check the output above")
print("  2. Share the results with me")
print("  3. We'll determine exact solution based on results")
print("="*60)
