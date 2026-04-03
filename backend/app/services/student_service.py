from datetime import datetime, timezone

from sqlalchemy.orm import Session

from ..repositories.student_repository import StudentRepository
from ..schemas.student import StudentUpsertRequest


class StudentService:
    def __init__(self, db: Session):
        self.db = db
        self.student_repo = StudentRepository(db)

    def upsert_student(self, payload: StudentUpsertRequest):
        student = self.student_repo.upsert_student(
            user_id=payload.userId,
            name=payload.name,
            created_at=payload.createdAt,
            updated_at=payload.updatedAt,
            last_seen=payload.updatedAt,
        )
        return {
            'userId': student.user_id,
            'name': student.name,
            'createdAt': student.created_at,
            'updatedAt': student.updated_at,
            'lastSeen': student.last_seen,
        }

    def ensure_student_exists(self, user_id: str, fallback_name: str = 'Unknown') -> None:
        existing = self.student_repo.get_by_user_id(user_id)
        now = datetime.now(timezone.utc)
        if existing is None:
            self.student_repo.upsert_student(
                user_id=user_id,
                name=fallback_name,
                created_at=now,
                updated_at=now,
                last_seen=now,
            )

    def list_students(self, search: str | None = None):
        rows = self.student_repo.list_students(search=search)
        result = []
        for student, lessons_completed in rows:
            result.append(
                {
                    'userId': student.user_id,
                    'name': student.name,
                    'createdAt': student.created_at,
                    'updatedAt': student.updated_at,
                    'lastSeen': student.last_seen,
                    'lessonsCompleted': int(lessons_completed),
                }
            )
        return result

    def get_student(self, user_id: str):
        student = self.student_repo.get_by_user_id(user_id)
        if student is None:
            return None
        return {
            'userId': student.user_id,
            'name': student.name,
            'createdAt': student.created_at,
            'updatedAt': student.updated_at,
            'lastSeen': student.last_seen,
        }
