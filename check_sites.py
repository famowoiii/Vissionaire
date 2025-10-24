import asyncio
from examples.auth.database import get_db
from examples.auth.models import Site, StreamConfig, User
from sqlalchemy import select
from sqlalchemy.orm import selectinload


async def check_sites():
    print("\n=== CHECKING ALL SITES AND STREAM CONFIGS ===\n")

    async for db in get_db():
        # Check all sites
        result = await db.execute(
            select(Site).options(selectinload(Site.stream_configs))
        )
        sites = result.scalars().unique().all()

        print(f"Total Sites in Database: {len(sites)}\n")

        for site in sites:
            print(f"Site: {site.name} (ID: {site.id})")
            print(f"   Group ID: {site.group_id}")
            print(f"   Stream Configs: {len(site.stream_configs)} configs")

            if site.stream_configs:
                for sc in site.stream_configs:
                    print(f"      Stream: {sc.stream_name}:")
                    print(f"         - URL: {sc.video_url}")
                    print(f"         - Store in Redis: {sc.store_in_redis}")
                    print(f"         - Model: {sc.model_key}")
            else:
                print(f"      WARNING: NO STREAM CONFIGS!")
            print()

        # Check users and their site access
        print("\n=== USER SITE ACCESS ===\n")
        result = await db.execute(select(User))
        users = result.scalars().all()

        for user in users:
            print(f"User: {user.username} (Role: {user.role})")
            if user.sites:
                print(f"   Sites: {[s.name for s in user.sites]}")
            else:
                print(f"   Sites: None (No access)")
            print()

        break


if __name__ == "__main__":
    asyncio.run(check_sites())
