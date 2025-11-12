"""Test stream config endpoint specifically"""
import requests

BASE_URL = "http://127.0.0.1:8005"

print("="*60)
print("STREAMING WEB SETTINGS - LABEL TEST")
print("="*60)

# First, let's see what endpoints are available
print("\n[1] Testing /list_stream_configs endpoint...")
print("    (This endpoint requires site_id parameter)")

# Get site first
print("\n[2] Getting sites first...")
try:
    response = requests.get(f"{BASE_URL}/list_sites")
    if response.status_code == 200:
        sites = response.json()
        print(f"    Found {len(sites)} sites:")
        for site in sites:
            print(f"      - ID: {site['id']} | Name: {site['name']}")

            # Try to get streams for this site
            print(f"\n[3] Getting streams for site_id={site['id']}...")
            stream_response = requests.get(
                f"{BASE_URL}/list_stream_configs",
                params={"site_id": site['id']}
            )

            if stream_response.status_code == 200:
                streams = stream_response.json()
                print(f"    Found {len(streams)} streams:")
                for stream in streams:
                    print(f"      - ID: {stream['id']}")
                    print(f"        Name: {stream['stream_name']}")
                    print(f"        Video URL: {stream['video_url'][:50]}...")
                    print(f"        Store in Redis: {stream['store_in_redis']}")
            else:
                print(f"    ERROR: Status {stream_response.status_code}")
                print(f"    Response: {stream_response.text}")
    else:
        print(f"    ERROR: Cannot get sites - Status {response.status_code}")
except Exception as e:
    print(f"    ERROR: {e}")

print("\n" + "="*60)
print("DIAGNOSIS:")
print("="*60)

print("\nIf streams showed above, but web interface shows 'no labels':")
print("  1. Web interface might be calling wrong endpoint")
print("  2. Web interface might not be passing site_id correctly")
print("  3. Authentication token might be expired")
print("  4. CORS issue preventing data fetch")
print("\nNEXT STEPS:")
print("  1. Open browser Developer Tools (F12)")
print("  2. Go to 'Network' tab")
print("  3. Reload streaming web settings page")
print("  4. Look for failed requests (red color)")
print("  5. Click on failed request to see error details")
print("  6. Take screenshot and share with me")
print("="*60)
