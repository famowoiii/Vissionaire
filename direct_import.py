"""Direct database import using pymysql - Simple version"""
import pymysql
import time

print("="*60)
print("Database Import - Direct Method")
print("="*60)

# Wait a bit for MySQL to be ready
print("\nWaiting for MySQL to be ready...")
time.sleep(2)

try:
    # Try to connect
    print("Connecting to MySQL at 127.0.0.1:3306...")
    conn = pymysql.connect(
        host='127.0.0.1',
        port=3306,
        user='root',
        password='',
        charset='utf8mb4',
        connect_timeout=10
    )

    print("[OK] Connected to MySQL!")
    cursor = conn.cursor()

    # Drop and create database
    print("\nCreating database...")
    cursor.execute("DROP DATABASE IF EXISTS construction_hazard_detection")
    cursor.execute("CREATE DATABASE construction_hazard_detection CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci")
    cursor.execute("USE construction_hazard_detection")
    print("[OK] Database created")

    # Read and execute SQL file
    print("\nReading SQL file...")
    with open('scripts/init.sql', 'r', encoding='utf-8') as f:
        sql = f.read()

    # Split by semicolon and execute
    print("Executing SQL statements...")
    statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]

    success = 0
    for i, stmt in enumerate(statements):
        try:
            if stmt:
                cursor.execute(stmt)
                success += 1
                if 'CREATE TABLE' in stmt.upper():
                    table = stmt.split('CREATE TABLE')[1].split('(')[0].strip()
                    print(f"  [{i+1}/{len(statements)}] Created table: {table}")
        except Exception as e:
            # Ignore duplicate/exists errors
            if 'already exists' not in str(e).lower() and 'duplicate' not in str(e).lower():
                print(f"  Warning: {e}")

    conn.commit()
    print(f"\n[OK] Executed {success} statements")

    # Verify
    print("\nVerifying...")
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()
    print(f"[OK] Found {len(tables)} tables:")
    for t in tables:
        print(f"  - {t[0]}")

    cursor.execute("SELECT username, role FROM users")
    users = cursor.fetchall()
    print(f"\n[OK] Found {len(users)} users:")
    for u, r in users:
        print(f"  - {u} ({r})")

    cursor.close()
    conn.close()

    print("\n" + "="*60)
    print("SUCCESS! Database is ready!")
    print("="*60)
    print("\nDefault Login:")
    print("  Username: user")
    print("  Password: password")
    print("="*60)

except pymysql.Error as e:
    print(f"\n[ERROR] MySQL Error: {e}")
    print("\nPossible solutions:")
    print("1. Restart MySQL from XAMPP Control Panel")
    print("2. Wait 10-20 seconds and try again")
    print("3. Check MySQL error log in XAMPP")
    exit(1)
except Exception as e:
    print(f"\n[ERROR] Error: {e}")
    import traceback
    traceback.print_exc()
    exit(1)
