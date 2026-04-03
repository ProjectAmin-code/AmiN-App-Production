from sqlalchemy.orm import Session

from .progress_service import ProgressService


class DashboardService:
    def __init__(self, db: Session):
        self.db = db
        self.progress_service = ProgressService(db)

    def summary(self):
        return self.progress_service.summary()
