#!/usr/bin/env python3
"""
Script to update database stream_configs to use local inference instead of remote server.
This fixes authentication errors when running without YOLO detection server.
"""
from __future__ import annotations

import asyncio
import os

from asyncmy import create_pool
from dotenv import load_dotenv
from sqlalchemy.engine.url import make_url

load_dotenv()


async def update_stream_configs() -> None:
    """Update all stream configs to use local inference."""
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
                # Update all configs to use local inference
                await cur.execute(
                    "UPDATE stream_configs SET detect_with_server = 0"
                )
                affected = cur.rowcount
                print(f"[OK] Updated {affected} stream config(s) to use local inference")

                # Show current configs
                await cur.execute(
                    """
                    SELECT sc.stream_name, sc.video_url, sc.detect_with_server
                    FROM stream_configs sc
                    """
                )
                rows = await cur.fetchall()

                print("\nCurrent stream configurations:")
                print("-" * 80)
                for stream_name, video_url, detect_with_server in rows:
                    mode = "REMOTE SERVER" if detect_with_server else "LOCAL INFERENCE"
                    url_short = video_url[:50] + "..." if len(video_url) > 50 else video_url
                    print(f"  {stream_name}: {mode}")
                    print(f"    URL: {url_short}")
                print("-" * 80)

        pool.close()
        await pool.wait_closed()
        print("\n[OK] Database update complete!")
        print("\nYou can now run: python main.py")

    except Exception as e:
        print(f"ERROR: Failed to update database: {e}")
        print("\nMake sure XAMPP MySQL is running and DATABASE_URL in .env is correct.")


if __name__ == '__main__':
    asyncio.run(update_stream_configs())
