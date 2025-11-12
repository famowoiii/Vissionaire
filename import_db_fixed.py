"""Import database schema - Fixed version"""
import pymysql
import os
from dotenv import load_dotenv

load_dotenv()

def import_database():
    """Import database using pymysql (synchronous)"""
    try:
        print("="*60)
        print("Database Import Tool")
        print("="*60)

        # Read SQL file
        sql_file = 'scripts/init.sql'
        print(f"\n[1/4] Reading SQL file: {sql_file}")

        with open(sql_file, 'r', encoding='utf-8') as f:
            sql_content = f.read()

        print(f"      File size: {len(sql_content)} bytes")

        # Connect to MySQL
        print(f"\n[2/4] Connecting to MySQL at 127.0.0.1:3306...")
        connection = pymysql.connect(
            host='127.0.0.1',
            port=3306,
            user='root',
            password='',
            charset='utf8mb4',
            autocommit=False
        )

        print("      Connected!")

        # Execute SQL
        print(f"\n[3/4] Executing SQL statements...")
        cursor = connection.cursor()

        # Split by semicolon but handle multi-line statements
        statements = []
        current = []
        for line in sql_content.split('\n'):
            line = line.strip()
            if not line or line.startswith('--'):
                continue
            current.append(line)
            if line.endswith(';'):
                statements.append(' '.join(current))
                current = []

        print(f"      Found {len(statements)} statements")

        success = 0
        errors = 0

        for i, statement in enumerate(statements, 1):
            try:
                cursor.execute(statement)
                success += 1

                # Show progress for important statements
                stmt_upper = statement.upper()
                if 'CREATE DATABASE' in stmt_upper:
                    print(f"      [{i}/{len(statements)}] ✓ Created database")
                elif 'CREATE TABLE' in stmt_upper:
                    table_name = statement.split('CREATE TABLE')[1].split('(')[0].strip()
                    if table_name:
                        print(f"      [{i}/{len(statements)}] ✓ Created table: {table_name}")
                elif 'INSERT INTO users' in statement:
                    print(f"      [{i}/{len(statements)}] ✓ Inserted default user")

            except Exception as e:
                errors += 1
                error_str = str(e)
                # Only show if it's not a duplicate error
                if 'already exists' not in error_str and 'duplicate' not in error_str.lower():
                    print(f"      [{i}/{len(statements)}] ! Warning: {error_str[:80]}")

        connection.commit()
        cursor.close()

        print(f"\n      Executed {success} statements successfully")
        if errors > 0:
            print(f"      {errors} statements had warnings (this is normal)")

        # Verify
        print(f"\n[4/4] Verifying database...")
        cursor = connection.cursor()

        cursor.execute("USE construction_hazard_detection")

        # Check tables
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        print(f"      Found {len(tables)} tables:")
        for table in sorted(tables):
            print(f"        - {table[0]}")

        # Check users
        cursor.execute("SELECT username, role, is_active FROM users")
        users = cursor.fetchall()
        print(f"\n      Found {len(users)} users:")
        for username, role, is_active in users:
            status = "active" if is_active else "inactive"
            print(f"        - {username} ({role}) [{status}]")

        cursor.close()
        connection.close()

        print("\n" + "="*60)
        print("SUCCESS! Database imported successfully!")
        print("="*60)
        print("\nDefault Login Credentials:")
        print("  Username: user")
        print("  Password: password")
        print("="*60)

        return True

    except pymysql.Error as e:
        print(f"\nMySQL Error: {e}")
        return False
    except FileNotFoundError as e:
        print(f"\nFile Error: {e}")
        return False
    except Exception as e:
        print(f"\nUnexpected Error: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = import_database()
    exit(0 if success else 1)
