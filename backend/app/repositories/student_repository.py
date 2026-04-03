from datetime import datetime, timezone
from typing import Optional

from sqlalchemy import case, func, select
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from ..db.models import Progress, Student


class StudentRepository:
    def __init__(self, db: Session):
        self.db = db

    def upsert_student(
        self,
        *,
        user_id: str,
        name: str,
        created_at: datetime,
        updated_at: datetime,
        last_seen: Optional[datetime] = None,
    ) -> Student:
        now = datetime.now(timezone.utc)
        stmt = insert(Student).values(
            user_id=user_id,
            name=name,
            created_at=created_at,
            updated_at=updated_at,
            last_seen=last_seen or now,
        )
        stmt = stmt.on_conflict_do_update(
            index_elements=[Student.user_id],
            set_={
                'name': name,
                'updated_at': updated_at,
                'last_seen': last_seen or now,
            },
        )
        self.db.execute(stmt)
        self.db.commit()
        return self.get_by_user_id(user_id)

    def touch_last_seen(self, user_id: str, seen_at: datetime) -> None:
        student = self.get_by_user_id(user_id)
        if student is None:
            return
        student.last_seen = seen_at
        student.updated_at = seen_at
        self.db.add(student)
        self.db.commit()

    def get_by_user_id(self, user_id: str) -> Optional[Student]:
        return self.db.scalar(select(Student).where(Student.user_id == user_id))

    def list_students(self, search: str | None = None):
        completed_expr = func.coalesce(
            func.sum(case((Progress.status == 'completed', 1), else_=0)),
            0,
        )

        stmt = (
            select(
                Student,
                completed_expr.label('lessons_completed'),
            )
            .outerjoin(Progress, Progress.user_id == Student.user_id)
            .group_by(Student.id)
            .order_by(Student.last_seen.desc())
        )
        if search:
            stmt = stmt.where(Student.name.ilike(f'%{search}%'))

        return self.db.execute(stmt).all()
