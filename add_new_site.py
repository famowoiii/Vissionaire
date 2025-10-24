"""
Script to add a new site to the database
"""
import asyncio
import os
from dotenv import load_dotenv
from asyncmy import connect
from sqlalchemy.engine.url import make_url

load_dotenv()

async def add_site():
    """Add a new site to the database"""
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("ERROR: DATABASE_URL not found in .env")
        return

    url = make_url(database_url)

    # Get site name from user
    print("\n=== Add New Site ===")
    site_name = input("Enter site name (e.g., 'Construction Site A'): ").strip()

    if not site_name:
        print("ERROR: Site name cannot be empty")
        return

    try:
        # Connect to database
        conn = await connect(
            host=url.host,
            port=url.port or 3306,
            user=url.username,
            password=url.password or '',
            db=url.database,
        )

        async with conn.cursor() as cursor:
            # Check if site already exists
            await cursor.execute(
                "SELECT id, name FROM sites WHERE name = %s",
                (site_name,)
            )
            existing = await cursor.fetchone()

            if existing:
                print(f"\n✓ Site '{site_name}' already exists with ID: {existing[0]}")
            else:
                # Insert new site
                await cursor.execute(
                    "INSERT INTO sites (name) VALUES (%s)",
                    (site_name,)
                )
                await conn.commit()
                site_id = cursor.lastrowid
                print(f"\n✓ Successfully added site '{site_name}' with ID: {site_id}")

        # Show all sites
        async with conn.cursor() as cursor:
            await cursor.execute("SELECT id, name FROM sites ORDER BY id")
            sites = await cursor.fetchall()
            print("\n=== All Sites in Database ===")
            for site_id, name in sites:
                print(f"  ID: {site_id} - Name: {name}")

        conn.close()

    except Exception as e:
        print(f"\nERROR: {e}")

if __name__ == "__main__":
    asyncio.run(add_site())
