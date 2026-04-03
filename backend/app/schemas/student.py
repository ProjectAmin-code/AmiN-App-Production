from datetime import datetime

from pydantic import BaseModel, Field


class StudentUpsertRequest(BaseModel):
    userId: str = Field(min_length=6, max_length=64)
    name: str = Field(min_length=1, max_length=255)
    createdAt: datetime
    updatedAt: datetime


class StudentResponse(BaseModel):
    userId: str
    name: str
    createdAt: datetime
    updatedAt: datetime
    lastSeen: datetime


class StudentListItem(StudentResponse):
    lessonsCompleted: int
