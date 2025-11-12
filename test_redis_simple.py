"""Simple Redis connection test"""
import asyncio
import os
from dotenv import load_dotenv
import redis.asyncio as redis

load_dotenv()

async def test():
    redis_host = os.getenv('REDIS_HOST', '127.0.0.1')
    redis_port = os.getenv('REDIS_PORT', '6379')
    redis_password = os.getenv('REDIS_PASSWORD', '')

    # Build Redis URL
    if redis_password:
        redis_url = f'redis://:{redis_password}@{redis_host}:{redis_port}/0'
    else:
        redis_url = f'redis://{redis_host}:{redis_port}/0'

    print(f'Redis URL: {redis_url}')
    print(f'Testing connection...')

    try:
        client = await redis.from_url(
            redis_url,
            encoding='utf-8',
            decode_responses=False,
        )
        result = await client.ping()
        print(f'SUCCESS: Redis ping returned: {result}')
        await client.aclose()
        return True
    except ConnectionRefusedError as e:
        print(f'ERROR: Cannot connect to Redis - Connection Refused')
        print(f'Details: {e}')
        print('Make sure Redis is running on the specified host and port')
        return False
    except Exception as e:
        print(f'ERROR: {type(e).__name__}: {e}')
        return False

if __name__ == "__main__":
    success = asyncio.run(test())
    exit(0 if success else 1)
