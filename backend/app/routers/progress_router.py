from fastapi import APIRouter, Depends, HTTPException, Request, status
from pydantic import ValidationError
from sqlalchemy.orm import Session

from ..core.config import get_settings
from ..db.session import get_db
from ..schemas.progress import LegacyProgressRequest, ProgressUpsertRequest
from ..services.progress_service import ProgressService

router = APIRouter(prefix='/progress', tags=['progress'])


@router.post('')
async def upsert_progress(request: Request, db: Session = Depends(get_db)):
    payload_data = await request.json()
    service = ProgressService(db)

    if isinstance(payload_data, dict) and {'userId', 'lessonId', 'status', 'score', 'updatedAt'}.issubset(payload_data):
        try:
            payload = ProgressUpsertRequest.model_validate(payload_data)
        except ValidationError as error:
            raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=error.errors())
        return service.upsert_progress(payload)

    settings = get_settings()
    if settings.legacy_progress_compat and isinstance(payload_data, dict) and {'userName', 'capturedAtUtc', 'progress'}.issubset(payload_data):
        try:
            legacy_payload = LegacyProgressRequest.model_validate(payload_data)
        except ValidationError as error:
            raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=error.errors())
        mapped = service.upsert_legacy_snapshot(legacy_payload)
        return {'ok': True, 'legacyMapped': mapped}

    raise HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail='Unsupported progress payload. Send canonical or enabled legacy shape.',
    )


@router.get('/{user_id}')
def get_user_progress(
    user_id: str,
    db: Session = Depends(get_db),
):
    return ProgressService(db).list_progress_for_user(user_id)
