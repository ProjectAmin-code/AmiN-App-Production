from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from ..core.auth import admin_guard
from ..db.models import Admin
from ..db.session import get_db
from ..schemas.student import StudentUpsertRequest
from ..services.student_service import StudentService

router = APIRouter(prefix='/students', tags=['students'])


@router.post('')
def upsert_student(payload: StudentUpsertRequest, db: Session = Depends(get_db)):
    return StudentService(db).upsert_student(payload)


@router.get('')
def list_students(
    search: str | None = Query(default=None),
    _admin: Admin = Depends(admin_guard),
    db: Session = Depends(get_db),
):
    return StudentService(db).list_students(search=search)


@router.get('/{user_id}')
def get_student(
    user_id: str,
    db: Session = Depends(get_db),
):
    student = StudentService(db).get_student(user_id)
    if student is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Student not found')
    return student
