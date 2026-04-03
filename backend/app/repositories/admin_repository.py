from datetime import datetime, timezone
from typing import Optional

from sqlalchemy import select
from sqlalchemy.orm import Session

from ..db.models import Admin


class AdminRepository:
    def __init__(self, db: Session):
        self.db = db

    def find_by_username(self, username: str) -> Optional[Admin]:
        return self.db.scalar(select(Admin).where(Admin.username == username))

    def upsert_admin(self, username: str, password_hash: str) -> Admin:
        existing = self.find_by_username(username)
        now = datetime.now(timezone.utc)
        if existing is None:
            admin = Admin(
                username=username,
                password_hash=password_hash,
                created_at=now,
                updated_at=now,
            )
            self.db.add(admin)
            self.db.commit()
            self.db.refresh(admin)
            return admin

        existing.password_hash = password_hash
        existing.updated_at = now
        self.db.add(existing)
        self.db.commit()
        self.db.refresh(existing)
        return existing
