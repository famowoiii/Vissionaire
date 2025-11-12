"""Check stream configuration and user permissions"""
import pymysql
import os
from dotenv import load_dotenv

load_dotenv()

def check_setup():
    try:
        conn = pymysql.connect(
            host='127.0.0.1',
            port=3306,
            user='root',
            password='',
            db='construction_hazard_detection',
            charset='utf8mb4'
        )
        cursor = conn.cursor()

        print("="*60)
        print("STREAM CONFIGURATION CHECKER")
        print("="*60)

        # 1. Check sites
        print("\n[1] SITES:")
        cursor.execute("SELECT id, name, group_id FROM sites")
        sites = cursor.fetchall()
        if sites:
            for site_id, name, group_id in sites:
                print(f"  ID: {site_id} | Name: {name} | Group: {group_id}")
        else:
            print("  [WARNING] No sites found!")

        # 2. Check stream_configs
        print("\n[2] STREAM CONFIGS:")
        cursor.execute("""
            SELECT sc.id, sc.stream_name, s.name as site_name, sc.video_url, sc.store_in_redis
            FROM stream_configs sc
            JOIN sites s ON sc.site_id = s.id
        """)
        streams = cursor.fetchall()
        if streams:
            for stream_id, stream_name, site_name, video_url, store_redis in streams:
                print(f"  ID: {stream_id}")
                print(f"    Name: {stream_name}")
                print(f"    Site: {site_name}")
                print(f"    URL: {video_url[:50]}...")
                print(f"    Store in Redis: {store_redis}")
                print()
        else:
            print("  [WARNING] No stream configs found!")

        # 3. Check users
        print("[3] USERS:")
        cursor.execute("SELECT id, username, role, group_id FROM users")
        users = cursor.fetchall()
        if users:
            for user_id, username, role, group_id in users:
                print(f"  ID: {user_id} | Username: {username} | Role: {role} | Group: {group_id}")
        else:
            print("  [ERROR] No users found!")

        # 4. Check user_sites (IMPORTANT!)
        print("\n[4] USER-SITE ACCESS (THIS IS KEY!):")
        cursor.execute("""
            SELECT u.username, s.name as site_name
            FROM user_sites us
            JOIN users u ON us.user_id = u.id
            JOIN sites s ON us.site_id = s.id
        """)
        user_sites = cursor.fetchall()
        if user_sites:
            for username, site_name in user_sites:
                print(f"  User '{username}' -> Site '{site_name}'")
        else:
            print("  [PROBLEM FOUND!] No user-site access configured!")
            print("  This is why streams don't show in web interface!")

        # 5. Solution
        print("\n" + "="*60)
        if not user_sites:
            print("PROBLEM IDENTIFIED:")
            print("  Users don't have access to any sites!")
            print("\nSOLUTION:")
            print("  Need to assign sites to users via user_sites table")
            print("\nQUICK FIX SQL:")
            if sites and users:
                for user_id, username, _, _ in users:
                    for site_id, site_name, _ in sites:
                        print(f"  INSERT IGNORE INTO user_sites (user_id, site_id) VALUES ({user_id}, {site_id}); -- {username} -> {site_name}")
        else:
            print("SETUP LOOKS GOOD!")
            print("If streams still don't show, try:")
            print("  1. Logout and login again")
            print("  2. Hard refresh browser (Ctrl+Shift+R)")
            print("  3. Clear browser cache")
        print("="*60)

        cursor.close()
        conn.close()

    except Exception as e:
        print(f"\n[ERROR] {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    check_setup()
