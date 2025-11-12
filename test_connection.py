"""Test database and Redis connections"""
import asyncio
import os
from dotenv import load_dotenv
from asyncmy import connect
from sqlalchemy.engine.url import make_url
import redis

load_dotenv()

async def test_mysql():
    """Test MySQL connection"""
    database_url = os.getenv('DATABASE_URL')
    print(f"Testing MySQL connection...")
    print(f"DATABASE_URL: {database_url}")

    try:
        url = make_url(database_url)
        conn = await connect(
            host=url.host,
            port=url.port or 3306,
            user=url.username,
            password=url.password or '',
            db=url.database,
        )
        print("✓ MySQL connection successful!")

        # Check tables
        async with conn.cursor() as cursor:
            await cursor.execute("SHOW TABLES")
            tables = await cursor.fetchall()
            print(f"✓ Found {len(tables)} tables in database")
            if tables:
                for table in tables:
                    print(f"  - {table[0]}")

        await conn.close()
        return True
    except Exception as e:
        print(f"✗ MySQL connection failed: {e}")
        return False

def test_redis():
    """Test Redis connection"""
    redis_host = os.getenv('REDIS_HOST', '127.0.0.1')
    redis_port = int(os.getenv('REDIS_PORT', 6379))
    redis_password = os.getenv('REDIS_PASSWORD', '')

    print(f"\nTesting Redis connection...")
    print(f"Redis: {redis_host}:{redis_port}")

    try:
        r = redis.Redis(
            host=redis_host,
            port=redis_port,
            password=redis_password if redis_password else None,
            decode_responses=True
        )
        r.ping()
        print("✓ Redis connection successful!")
        return True
    except Exception as e:
        print(f"✗ Redis connection failed: {e}")
        return False

async def main():
    print("="*50)
    print("Connection Test")
    print("="*50)

    mysql_ok = await test_mysql()
    redis_ok = test_redis()

    print("\n" + "="*50)
    if mysql_ok and redis_ok:
        print("✓ All connections successful!")
    else:
        print("✗ Some connections failed. Please check the errors above.")
    print("="*50)

if __name__ == "__main__":
    asyncio.run(main())
