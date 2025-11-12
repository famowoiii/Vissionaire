"""Simple MySQL connection test"""
import asyncio
import os
from dotenv import load_dotenv
from asyncmy import connect
from sqlalchemy.engine.url import make_url

load_dotenv()

async def test():
    database_url = os.getenv('DATABASE_URL')
    print(f'DATABASE_URL: {database_url}')

    if not database_url:
        print('ERROR: DATABASE_URL not found in environment')
        return False

    try:
        url = make_url(database_url)
        print(f'Connecting to: {url.host}:{url.port or 3306}')
        print(f'Database: {url.database}')
        print(f'User: {url.username}')

        conn = await connect(
            host=url.host,
            port=url.port or 3306,
            user=url.username,
            password=url.password or '',
            db=url.database,
        )

        print('SUCCESS: Connected to MySQL!')

        # Test query
        async with conn.cursor() as cursor:
            await cursor.execute("SELECT VERSION()")
            version = await cursor.fetchone()
            print(f'MySQL Version: {version[0]}')

            await cursor.execute("SHOW TABLES")
            tables = await cursor.fetchall()
            print(f'Found {len(tables)} tables:')
            for table in tables:
                print(f'  - {table[0]}')

        await conn.ensure_closed()
        return True

    except Exception as e:
        print(f'ERROR: {type(e).__name__}: {e}')
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = asyncio.run(test())
    exit(0 if success else 1)
