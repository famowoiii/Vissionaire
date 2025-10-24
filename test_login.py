"""
Test login credentials directly against database.
This bypasses the API to verify if credentials are correct.
"""
import asyncio
import os
import sys

# Fix encoding for Windows console
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

from dotenv import load_dotenv
from asyncmy import create_pool
from sqlalchemy.engine.url import make_url
from werkzeug.security import check_password_hash

load_dotenv()


async def test_login(username: str, password: str):
    """Test login credentials."""
    print("=" * 60)
    print("TESTING LOGIN CREDENTIALS")
    print("=" * 60)
    print(f"Username: {username}")
    print(f"Password: {password}")
    print()

    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("ERROR: DATABASE_URL not found in .env")
        return

    url = make_url(database_url)

    try:
        pool = await create_pool(
            host=url.host,
            port=url.port or 3306,
            user=url.username,
            password=url.password,
            db=url.database,
            minsize=1,
            maxsize=2,
        )

        async with pool.acquire() as conn:
            async with conn.cursor() as cur:
                # Get user from database
                await cur.execute(
                    """
                    SELECT id, username, password_hash, role, is_active
                    FROM users
                    WHERE username = %s
                    """,
                    (username,)
                )
                user = await cur.fetchone()

                if not user:
                    print(f"❌ FAILED: User '{username}' not found in database!")
                    print()
                    print("Available users:")
                    await cur.execute("SELECT username, role, is_active FROM users")
                    users = await cur.fetchall()
                    for u in users:
                        print(f"  - {u[0]} (role: {u[1]}, active: {u[2]})")
                    return

                user_id, db_username, password_hash, role, is_active = user

                print(f"✅ User found in database:")
                print(f"   ID: {user_id}")
                print(f"   Username: {db_username}")
                print(f"   Role: {role}")
                print(f"   Active: {is_active}")
                print()

                # Check if account is active
                if not is_active:
                    print("❌ FAILED: Account is inactive!")
                    return

                # Verify password
                print(f"Verifying password...")
                print(f"Password hash in DB: {password_hash[:50]}...")
                print()

                if check_password_hash(password_hash, password):
                    print("✅ SUCCESS: Password is correct!")
                    print()
                    print("=" * 60)
                    print("LOGIN CREDENTIALS ARE VALID")
                    print("=" * 60)
                    print()
                    print("You can login with:")
                    print(f"  Username: {username}")
                    print(f"  Password: {password}")
                    print()
                    print("Visionnaire URL:")
                    print("  https://visionnaire-cda17.web.app/login")
                    print()
                else:
                    print("❌ FAILED: Password is incorrect!")
                    print()
                    print("The password hash in database doesn't match.")
                    print("Run reset_user_password.py to reset the password.")

        pool.close()
        await pool.wait_closed()

    except Exception as e:
        print(f"ERROR: {e}")
        import traceback
        traceback.print_exc()


async def main():
    """Main function."""
    # Test with default credentials
    await test_login("user", "password")


if __name__ == '__main__':
    asyncio.run(main())
