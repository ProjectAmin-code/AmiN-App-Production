import os
from pathlib import Path

import psycopg

DATABASE_URL = os.getenv(
    'DATABASE_URL',
    'postgresql://postgres:postgres@localhost:5432/amin_sync',
)


def normalize_url(url: str) -> str:
    if url.startswith('postgresql+psycopg://'):
        return url.replace('postgresql+psycopg://', 'postgresql://', 1)
    return url


def main() -> None:
    migration_path = Path(__file__).resolve().parents[1] / 'migrations' / '001_init.sql'
    sql = migration_path.read_text(encoding='utf-8')

    with psycopg.connect(normalize_url(DATABASE_URL), autocommit=True) as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql)
    print('Database initialized successfully.')


if __name__ == '__main__':
    main()
