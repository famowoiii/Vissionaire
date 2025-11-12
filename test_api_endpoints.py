"""Test if API endpoints are accessible"""
import requests
import json

API_BASE = "http://127.0.0.1:8005"

print("="*60)
print("API CONNECTIVITY TEST")
print("="*60)

# Test 1: Check if API is running
print("\n[TEST 1] Checking if API is running...")
try:
    response = requests.get(f"{API_BASE}/docs", timeout=5)
    if response.status_code == 200:
        print("[OK] API is running and accessible")
    else:
        print(f"[WARNING] API responded with status {response.status_code}")
except Exception as e:
    print(f"[ERROR] Cannot connect to API: {e}")
    print("\nPossible causes:")
    print("  - API is not running (check start_all_apis.bat)")
    print("  - Port 8005 is blocked by firewall")
    print("  - Wrong API URL")
    exit(1)

# Test 2: Check sites endpoint
print("\n[TEST 2] Fetching sites...")
try:
    response = requests.get(f"{API_BASE}/api/v1/sites", timeout=5)
    if response.status_code == 200:
        sites = response.json()
        print(f"[OK] Found {len(sites)} sites:")
        for site in sites:
            print(f"  - ID: {site.get('id')} | Name: {site.get('name')}")
    else:
        print(f"[ERROR] Status {response.status_code}: {response.text}")
except Exception as e:
    print(f"[ERROR] Cannot fetch sites: {e}")

# Test 3: Check streams endpoint
print("\n[TEST 3] Fetching streams...")
try:
    response = requests.get(f"{API_BASE}/api/v1/streams", timeout=5)
    if response.status_code == 200:
        streams = response.json()
        print(f"[OK] Found {len(streams)} streams:")
        for stream in streams:
            print(f"  - ID: {stream.get('id')} | Name: {stream.get('stream_name')}")
            print(f"    Site: {stream.get('site_id')}")
            print(f"    URL: {stream.get('video_url')[:50]}...")
    elif response.status_code == 401:
        print("[WARNING] Authentication required")
        print("This is normal - web interface needs to login first")
    else:
        print(f"[ERROR] Status {response.status_code}: {response.text}")
except Exception as e:
    print(f"[ERROR] Cannot fetch streams: {e}")

# Test 4: Check CORS headers
print("\n[TEST 4] Checking CORS configuration...")
try:
    response = requests.options(f"{API_BASE}/api/v1/sites", timeout=5)
    cors_headers = response.headers.get('Access-Control-Allow-Origin', 'NOT SET')
    print(f"  CORS Allow-Origin: {cors_headers}")
    if cors_headers == '*' or 'visionnaire-cda17.web.app' in cors_headers:
        print("  [OK] CORS is configured correctly")
    else:
        print("  [WARNING] CORS might block web interface")
except Exception as e:
    print(f"  [INFO] Could not check CORS: {e}")

print("\n" + "="*60)
print("SUMMARY:")
print("="*60)
print("\nIf all tests passed, the issue is likely:")
print("  1. API URLs not configured in web interface")
print("  2. Browser cache issue")
print("  3. Web interface not using correct API URL")
print("\nNEXT STEPS:")
print("  1. Open browser Developer Tools (F12)")
print("  2. Go to Console tab")
print("  3. Check for error messages")
print("  4. Look for failed network requests")
print("="*60)
