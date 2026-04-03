import hashlib
from datetime import datetime, timezone
from typing import Any, Dict

from sqlalchemy.orm import Session

from ..repositories.progress_repository import ProgressRepository
from ..repositories.student_repository import StudentRepository
from ..schemas.progress import LegacyProgressRequest, ProgressUpsertRequest


class ProgressService:
    def __init__(self, db: Session):
        self.db = db
        self.progress_repo = ProgressRepository(db)
        self.student_repo = StudentRepository(db)

    def upsert_progress(self, payload: ProgressUpsertRequest):
        now = payload.updatedAt
        student = self.student_repo.get_by_user_id(payload.userId)
        if student is None:
            self.student_repo.upsert_student(
                user_id=payload.userId,
                name='Unknown',
                created_at=now,
                updated_at=now,
                last_seen=now,
            )
        else:
            self.student_repo.touch_last_seen(payload.userId, now)

        progress = self.progress_repo.upsert_progress(
            user_id=payload.userId,
            lesson_id=payload.lessonId,
            score=payload.score,
            status=payload.status,
            updated_at=payload.updatedAt,
        )
        return {
            'userId': progress.user_id,
            'lessonId': progress.lesson_id,
            'score': progress.score,
            'status': progress.status,
            'updatedAt': progress.updated_at,
        }

    def list_progress_for_user(self, user_id: str):
        rows = self.progress_repo.list_by_user_id(user_id)
        return [
            {
                'lessonId': row.lesson_id,
                'score': row.score,
                'status': row.status,
                'updatedAt': row.updated_at,
            }
            for row in rows
        ]

    def upsert_legacy_snapshot(self, payload: LegacyProgressRequest):
        user_id = self._legacy_user_id(payload.userName)
        now = payload.capturedAtUtc

        student = self.student_repo.get_by_user_id(user_id)
        if student is None:
            self.student_repo.upsert_student(
                user_id=user_id,
                name=payload.userName,
                created_at=now,
                updated_at=now,
                last_seen=now,
            )
        else:
            self.student_repo.upsert_student(
                user_id=user_id,
                name=payload.userName,
                created_at=student.created_at,
                updated_at=now,
                last_seen=now,
            )

        normalized_entries = self._legacy_entries(payload.progress)
        for entry in normalized_entries:
            self.progress_repo.upsert_progress(
                user_id=user_id,
                lesson_id=entry['lessonId'],
                score=entry['score'],
                status=entry['status'],
                updated_at=now,
            )

        return {
            'userId': user_id,
            'mappedLessons': [entry['lessonId'] for entry in normalized_entries],
        }

    def summary(self):
        return self.progress_repo.summary()

    @staticmethod
    def _legacy_user_id(user_name: str) -> str:
        digest = hashlib.sha1(user_name.encode('utf-8')).hexdigest()[:24]
        return f'legacy-{digest}'

    @staticmethod
    def _legacy_entries(progress: Dict[str, Any]):
        def ratio_to_score(key: str) -> int:
            raw = progress.get(key)
            try:
                value = float(raw)
            except (TypeError, ValueError):
                value = 0.0
            value = max(0.0, min(1.0, value))
            return int(round(value * 100))

        entries = [
            {
                'lessonId': 'ONBOARDING',
                'score': ratio_to_score('onboardingRatio'),
            },
            {
                'lessonId': 'BELAJAR',
                'score': ratio_to_score('belajarRatio'),
            },
            {
                'lessonId': 'QUIZ',
                'score': ratio_to_score('quizRatio'),
            },
            {
                'lessonId': 'GAMES',
                'score': ratio_to_score('gameRatio'),
            },
        ]

        for entry in entries:
            entry['status'] = 'completed' if entry['score'] >= 100 else 'in_progress'

        return entries
