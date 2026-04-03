from sqlalchemy.orm import Session

from ..core.security import create_access_token, hash_password, verify_password
from ..repositories.admin_repository import AdminRepository


class AdminService:
    def __init__(self, db: Session):
        self.db = db
        self.admin_repo = AdminRepository(db)

    def login(self, username: str, password: str) -> str | None:
        admin = self.admin_repo.find_by_username(username)
        if admin is None:
            return None
        if not verify_password(password, admin.password_hash):
            return None
        return create_access_token(admin.username)

    def seed_admin(self, username: str, password: str) -> None:
        password_hash = hash_password(password)
        self.admin_repo.upsert_admin(username=username, password_hash=password_hash)
