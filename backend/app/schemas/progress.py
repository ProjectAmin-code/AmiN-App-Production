from datetime import datetime
from typing import Any, Dict

from pydantic import BaseModel, Field


class ProgressUpsertRequest(BaseModel):
    userId: str = Field(min_length=6, max_length=64)
    lessonId: str = Field(min_length=1, max_length=128)
    status: str = Field(min_length=1, max_length=32)
    score: int = Field(ge=0, le=100)
    updatedAt: datetime


class ProgressItem(BaseModel):
    lessonId: str
    score: int
    status: str
    updatedAt: datetime


class LegacyProgressRequest(BaseModel):
    userName: str = Field(min_length=1, max_length=255)
    capturedAtUtc: datetime
    progress: Dict[str, Any]
