from datetime import datetime, timezone

from sqlalchemy import (
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    UniqueConstraint,
)
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    pass


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


class Student(Base):
    __tablename__ = 'students'

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[str] = mapped_column(String(64), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utc_now)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utc_now)
    last_seen: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utc_now, index=True)


class Progress(Base):
    __tablename__ = 'progress'
    __table_args__ = (
        UniqueConstraint('user_id', 'lesson_id', name='uq_progress_user_lesson'),
        Index('idx_progress_user_id', 'user_id'),
        Index('idx_progress_updated_at', 'updated_at'),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey('students.user_id', ondelete='CASCADE'),
        nullable=False,
    )
    lesson_id: Mapped[str] = mapped_column(String(128), nullable=False)
    score: Mapped[int] = mapped_column(Integer, nullable=False)
    status: Mapped[str] = mapped_column(String(32), nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utc_now)


class Admin(Base):
    __tablename__ = 'admins'

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    username: Mapped[str] = mapped_column(String(64), unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utc_now)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utc_now)
