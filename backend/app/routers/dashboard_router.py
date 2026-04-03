from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from ..core.auth import admin_guard
from ..db.models import Admin
from ..db.session import get_db
from ..services.dashboard_service import DashboardService

router = APIRouter(prefix='/dashboard', tags=['dashboard'])


@router.get('/summary')
def summary(
    _admin: Admin = Depends(admin_guard),
    db: Session = Depends(get_db),
):
    return DashboardService(db).summary()
