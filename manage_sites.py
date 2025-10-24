"""
Script to manage sites in the database
"""
import asyncio
import os
import sys
from dotenv import load_dotenv
from asyncmy import connect
from sqlalchemy.engine.url import make_url

load_dotenv()

async def list_sites():
    """List all sites in the database"""
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("ERROR: DATABASE_URL not found in .env")
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

        async with conn.cursor() as cursor:
            await cursor.execute("SELECT id, name FROM sites ORDER BY id")
            sites = await cursor.fetchall()
            print("\n=== All Sites in Database ===")
            if not sites:
                print("  No sites found")
            else:
                for site_id, name in sites:
                    print(f"  ID: {site_id} - Name: {name}")

        conn.close()

    except Exception as e:
        print(f"\nERROR: {e}")

async def add_site(site_name):
    """Add a new site to the database"""
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("ERROR: DATABASE_URL not found in .env")
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

        conn.close()

        # Show all sites
        await list_sites()

    except Exception as e:
        print(f"\nERROR: {e}")

async def update_stream_site(stream_name, new_site_name):
    """Update stream configuration to use a different site"""
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("ERROR: DATABASE_URL not found in .env")
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

        async with conn.cursor() as cursor:
            # Get site ID
            await cursor.execute(
                "SELECT id FROM sites WHERE name = %s",
                (new_site_name,)
            )
            site_row = await cursor.fetchone()

            if not site_row:
                print(f"\nERROR: Site '{new_site_name}' not found")
                conn.close()
                return

            site_id = site_row[0]

            # Update stream config
            await cursor.execute(
                "UPDATE stream_configs SET site_id = %s, updated_at = NOW() WHERE stream_name = %s",
                (site_id, stream_name)
            )
            await conn.commit()

            if cursor.rowcount > 0:
                print(f"\n✓ Updated stream '{stream_name}' to use site '{new_site_name}'")
            else:
                print(f"\n✗ Stream '{stream_name}' not found")

        conn.close()

    except Exception as e:
        print(f"\nERROR: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("\nUsage:")
        print("  List all sites:        python manage_sites.py list")
        print("  Add new site:          python manage_sites.py add \"Site Name\"")
        print("  Update stream site:    python manage_sites.py update \"stream_name\" \"site_name\"")
        sys.exit(1)

    command = sys.argv[1]

    if command == "list":
        asyncio.run(list_sites())
    elif command == "add" and len(sys.argv) >= 3:
        asyncio.run(add_site(sys.argv[2]))
    elif command == "update" and len(sys.argv) >= 4:
        asyncio.run(update_stream_site(sys.argv[2], sys.argv[3]))
    else:
        print("Invalid command or missing arguments")
