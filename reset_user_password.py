#!/usr/bin/env python3
"""
Script to reset user password or create new user for web interface login.
"""
from __future__ import annotations

import asyncio
import os
from datetime import datetime

from asyncmy import create_pool
from dotenv import load_dotenv
from sqlalchemy.engine.url import make_url
from werkzeug.security import generate_password_hash

load_dotenv()


async def reset_password(username: str, new_password: str) -> None:
    """Reset password for existing user or create new user."""
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
                # Check if user exists
                await cur.execute(
                    "SELECT id, username FROM users WHERE username = %s",
                    (username,)
                )
                user = await cur.fetchone()

                # Hash password using scrypt (same as werkzeug)
                password_hash = generate_password_hash(
                    new_password, method='scrypt'
                )

                if user:
                    # Update existing user
                    await cur.execute(
                        """
                        UPDATE users
                        SET password_hash = %s, updated_at = %s
                        WHERE username = %s
                        """,
                        (password_hash, datetime.now(), username)
                    )
                    print(f"[OK] Password updated for user: {username}")
                else:
                    # Create new user
                    await cur.execute(
                        """
                        INSERT INTO users
                        (username, password_hash, role, is_active, created_at, updated_at, group_id)
                        VALUES (%s, %s, 'admin', 1, %s, %s, 1)
                        """,
                        (username, password_hash, datetime.now(), datetime.now())
                    )
                    print(f"[OK] New user created: {username}")

                # Show login info
                print("\n" + "=" * 60)
                print("LOGIN CREDENTIALS:")
                print("=" * 60)
                print(f"  Username: {username}")
                print(f"  Password: {new_password}")
                print("=" * 60)
                print("\nYou can now login to:")
                print("  - Web Interface: http://localhost:8005")
                print("  - Or via DB Management API: http://localhost:8005/docs")

        pool.close()
        await pool.wait_closed()

    except Exception as e:
        print(f"ERROR: {e}")


async def main():
    """Main function to reset/create user."""
    print("=" * 60)
    print("USER PASSWORD RESET / CREATE")
    print("=" * 60)
    print()

    # Reset password for existing 'user' account
    USERNAME = "user"
    PASSWORD = "password"

    print(f"Setting up user: {USERNAME}")
    print(f"New password: {PASSWORD}")
    print()

    await reset_password(USERNAME, PASSWORD)


if __name__ == '__main__':
    asyncio.run(main())
