from datetime import datetime, timezone

from sqlalchemy import and_, cast, Date, func, select
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from ..db.models import Progress, Student


class ProgressRepository:
    def __init__(self, db: Session):
        self.db = db

    def upsert_progress(
        self,
        *,
        user_id: str,
        lesson_id: str,
        score: int,
        status: str,
        updated_at: datetime,
    ) -> Progress:
        stmt = insert(Progress).values(
            user_id=user_id,
            lesson_id=lesson_id,
            score=score,
            status=status,
            updated_at=updated_at,
        )
        stmt = stmt.on_conflict_do_update(
            index_elements=[Progress.user_id, Progress.lesson_id],
            set_={
                'score': score,
                'status': status,
                'updated_at': updated_at,
            },
        )
        self.db.execute(stmt)
        self.db.commit()
        return self.db.scalar(
            select(Progress).where(
                and_(
                    Progress.user_id == user_id,
                    Progress.lesson_id == lesson_id,
                )
            )
        )

    def list_by_user_id(self, user_id: str):
        stmt = (
            select(Progress)
            .where(Progress.user_id == user_id)
            .order_by(Progress.updated_at.desc())
        )
        return self.db.scalars(stmt).all()

    def summary(self):
        total_students = self.db.scalar(select(func.count(Student.id))) or 0

        today = datetime.now(timezone.utc).date()
        active_students_today = (
            self.db.scalar(
                select(func.count(Student.id)).where(cast(Student.last_seen, Date) == today)
            )
            or 0
        )

        lessons_completed = (
            self.db.scalar(
                select(func.count(Progress.id)).where(Progress.status == 'completed')
            )
            or 0
        )

        average_score_raw = self.db.scalar(select(func.avg(Progress.score)))
        average_score = float(round(average_score_raw or 0.0, 2))

        return {
            'totalStudents': int(total_students),
            'activeStudentsToday': int(active_students_today),
            'lessonsCompleted': int(lessons_completed),
            'averageScore': average_score,
        }
