"""
Auto-generate config for ALL streams from database
"""
import asyncio
import json
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text

DATABASE_URL = 'mysql+asyncmy://root@127.0.0.1:3306/construction_hazard_detection'

async def generate_config():
    """Generate config file with ALL streams from database"""

    engine = create_async_engine(DATABASE_URL, echo=False)
    async_session = sessionmaker(
        engine, class_=AsyncSession, expire_on_commit=False
    )

    async with async_session() as session:
        # Get all streams with site info
        query = text("""
            SELECT
                s.name as site_name,
                sc.stream_name,
                sc.video_url
            FROM stream_configs sc
            JOIN sites s ON sc.site_id = s.id
            ORDER BY sc.id
        """)

        result = await session.execute(query)
        streams = result.fetchall()

        if not streams:
            print("No streams found in database!")
            return False

        # Generate config for each stream
        config = []
        for stream in streams:
            site_name = stream[0]
            stream_name = stream[1]
            video_url = stream[2] or "D:/Construction-Hazard-Detection/tests/videos/test.mp4"

            stream_config = {
                "video_url": video_url,
                "site": site_name,
                "stream_name": stream_name,
                "model_key": "yolo11n",
                "notifications": {
                    "telegram:5856651174": "en"
                },
                "detect_with_server": False,
                "expire_date": "2025-12-31T23:59:59",
                "detection_items": {
                    "detect_no_safety_vest_or_helmet": True,
                    "detect_near_machinery_or_vehicle": True,
                    "detect_in_restricted_area": True
                },
                "work_start_hour": 0,
                "work_end_hour": 24,
                "store_in_redis": True
            }

            config.append(stream_config)
            print(f"Added: {site_name} / {stream_name}")

        # Save to file
        output_file = "config/auto_all_streams.json"
        with open(output_file, 'w') as f:
            json.dump(config, f, indent=2)

        print(f"\nConfig saved to: {output_file}")
        print(f"Total streams: {len(config)}")

        return True

    await engine.dispose()

if __name__ == "__main__":
    success = asyncio.run(generate_config())
    exit(0 if success else 1)
