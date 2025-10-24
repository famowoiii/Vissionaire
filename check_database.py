"""
Check database for sites and stream configurations
"""
import asyncio
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text

DATABASE_URL = 'mysql+asyncmy://root@127.0.0.1:3306/construction_hazard_detection'

async def check_database():
    """Check sites and stream_configs in database"""

    engine = create_async_engine(DATABASE_URL, echo=False)
    async_session = sessionmaker(
        engine, class_=AsyncSession, expire_on_commit=False
    )

    async with async_session() as session:
        print("\n" + "="*60)
        print("SITES IN DATABASE")
        print("="*60)

        # Get all sites
        result = await session.execute(text("SELECT id, name FROM sites ORDER BY id"))
        sites = result.fetchall()

        for site in sites:
            print(f"Site ID: {site[0]}, Name: {site[1]}")

        print("\n" + "="*60)
        print("STREAM CONFIGURATIONS")
        print("="*60)

        # Get all stream configs with site info
        query = text("""
            SELECT
                sc.id,
                sc.stream_name,
                sc.site_id,
                s.name as site_name,
                sc.video_url
            FROM stream_configs sc
            LEFT JOIN sites s ON sc.site_id = s.id
            ORDER BY sc.id
        """)

        result = await session.execute(query)
        streams = result.fetchall()

        if not streams:
            print("  No stream configurations found!")
        else:
            for stream in streams:
                print(f"\nStream ID: {stream[0]}")
                print(f"  Stream Name: {stream[1]}")
                print(f"  Site ID: {stream[2]}")
                print(f"  Site Name: {stream[3]}")
                print(f"  Video URL: {stream[4]}")

    await engine.dispose()

if __name__ == "__main__":
    asyncio.run(check_database())
