"""Import database schema and verify"""
import os
import asyncio
from dotenv import load_dotenv
from asyncmy import connect
from sqlalchemy.engine.url import make_url

load_dotenv()

async def import_database():
    """Import database schema from init.sql"""
    database_url = os.getenv('DATABASE_URL')

    if not database_url:
        print('ERROR: DATABASE_URL not found in environment')
        return False

    try:
        url = make_url(database_url)

        # Read SQL file
        sql_file = 'scripts/init.sql'
        print(f'Reading SQL file: {sql_file}')

        with open(sql_file, 'r', encoding='utf-8') as f:
            sql_content = f.read()

        print(f'SQL file size: {len(sql_content)} bytes')

        # Split SQL statements (basic split by semicolon)
        statements = [s.strip() for s in sql_content.split(';') if s.strip()]
        print(f'Found {len(statements)} SQL statements')

        # Connect to MySQL without specifying database (to create it first)
        print(f'\nConnecting to MySQL at {url.host}:{url.port or 3306}...')
        conn = await connect(
            host=url.host,
            port=url.port or 3306,
            user=url.username,
            password=url.password or '',
        )

        print('Connected to MySQL!')

        # Execute statements
        success_count = 0
        error_count = 0

        async with conn.cursor() as cursor:
            for i, statement in enumerate(statements, 1):
                if not statement or statement.startswith('--'):
                    continue

                try:
                    await cursor.execute(statement)
                    success_count += 1

                    # Show progress for important statements
                    if 'CREATE DATABASE' in statement.upper():
                        print(f'  [{i}/{len(statements)}] Created database')
                    elif 'CREATE TABLE' in statement.upper():
                        table_name = statement.split('CREATE TABLE')[1].split('(')[0].strip()
                        print(f'  [{i}/{len(statements)}] Created table: {table_name}')
                    elif 'INSERT INTO' in statement.upper() and 'users' in statement.lower():
                        print(f'  [{i}/{len(statements)}] Inserted default user')

                except Exception as e:
                    error_count += 1
                    # Only show critical errors
                    if 'CREATE TABLE' in statement.upper() or 'CREATE DATABASE' in statement.upper():
                        print(f'  ERROR at statement {i}: {e}')

        await conn.commit()
        await conn.ensure_closed()

        print(f'\n{"="*60}')
        print(f'Import completed!')
        print(f'  Success: {success_count} statements')
        print(f'  Errors: {error_count} statements')
        print(f'{"="*60}')

        # Verify the import
        print('\nVerifying database...')
        conn = await connect(
            host=url.host,
            port=url.port or 3306,
            user=url.username,
            password=url.password or '',
            db='construction_hazard_detection',
        )

        async with conn.cursor() as cursor:
            # Check tables
            await cursor.execute("SHOW TABLES")
            tables = await cursor.fetchall()
            print(f'\nFound {len(tables)} tables:')
            for table in tables:
                print(f'  - {table[0]}')

            # Check users
            await cursor.execute("SELECT username, role FROM users")
            users = await cursor.fetchall()
            print(f'\nFound {len(users)} users:')
            for username, role in users:
                print(f'  - {username} ({role})')

        await conn.ensure_closed()

        print('\n' + '='*60)
        print('SUCCESS! Database is ready to use!')
        print('='*60)
        print('\nDefault login credentials:')
        print('  Username: user')
        print('  Password: password')
        print('='*60)

        return True

    except Exception as e:
        print(f'\nERROR: {type(e).__name__}: {e}')
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = asyncio.run(import_database())
    exit(0 if success else 1)
