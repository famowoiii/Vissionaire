"""
Check current stream and user configurations
"""
import asyncio
import os
from dotenv import load_dotenv
from asyncmy import connect
from sqlalchemy.engine.url import make_url

load_dotenv()

async def check_config():
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("ERROR: DATABASE_URL not found")
        return

    url = make_url(database_url)

    try:
        conn = await connect(
            host=url.host,
            port=url.port or 3306,
            user=url.username,
            password=url.password or '',
            db=url.database,
        )

        print("\n=== Sites ===")
        async with conn.cursor() as cursor:
            await cursor.execute("SELECT id, name FROM sites ORDER BY id")
            sites = await cursor.fetchall()
            for site_id, name in sites:
                print(f"  {site_id}: {name}")

        print("\n=== Stream Configurations ===")
        async with conn.cursor() as cursor:
            await cursor.execute("""
                SELECT sc.id, sc.stream_name, s.name as site, sc.store_in_redis, sc.video_url
                FROM stream_configs sc
                LEFT JOIN sites s ON sc.site_id = s.id
                ORDER BY sc.id
            """)
            streams = await cursor.fetchall()
            for stream_id, stream_name, site, store_redis, video_url in streams:
                print(f"  ID: {stream_id}")
                print(f"    Stream: {stream_name}")
                print(f"    Site: {site}")
                print(f"    Store in Redis: {store_redis}")
                print(f"    Video: {video_url}")
                print()

        print("\n=== User Site Access ===")
        async with conn.cursor() as cursor:
            await cursor.execute("""
                SELECT u.username, s.name as site_name
                FROM users u
                JOIN user_sites us ON u.id = us.user_id
                JOIN sites s ON us.site_id = s.id
                ORDER BY u.username, s.name
            """)
            access = await cursor.fetchall()
            for username, site_name in access:
                print(f"  {username} -> {site_name}")

        conn.close()

    except Exception as e:
        print(f"\nERROR: {e}")

if __name__ == "__main__":
    asyncio.run(check_config())
