from typing import Generator

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from ..db.session import get_db
from ..repositories.admin_repository import AdminRepository
from .security import decode_access_token

bearer_scheme = HTTPBearer(auto_error=False)


def get_current_admin(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
    db: Session = Depends(get_db),
):
    if credentials is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail='Missing token')

    token_payload = decode_access_token(credentials.credentials)
    if token_payload is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail='Invalid token')

    username = token_payload.get('sub')
    if not username:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail='Invalid token payload')

    admin = AdminRepository(db).find_by_username(username)
    if admin is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail='Admin not found')
    return admin


def admin_guard(admin=Depends(get_current_admin)):
    return admin
