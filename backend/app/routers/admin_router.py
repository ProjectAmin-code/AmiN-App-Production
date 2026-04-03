from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from ..core.auth import admin_guard
from ..db.models import Admin
from ..db.session import get_db
from ..schemas.admin import AdminLoginRequest, AdminLoginResponse, AdminMeResponse
from ..services.admin_service import AdminService

router = APIRouter(prefix='/admin', tags=['admin'])


@router.post('/login', response_model=AdminLoginResponse)
def login(payload: AdminLoginRequest, db: Session = Depends(get_db)):
    token = AdminService(db).login(payload.username, payload.password)
    if token is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Invalid username or password',
        )
    return AdminLoginResponse(accessToken=token)


@router.post('/logout')
def logout(_admin: Admin = Depends(admin_guard)):
    return {'ok': True}


@router.get('/me', response_model=AdminMeResponse)
def me(admin: Admin = Depends(admin_guard)):
    return AdminMeResponse(username=admin.username)
