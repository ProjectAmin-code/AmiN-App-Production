from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .core.config import get_settings
from .core.rate_limit import MobileRateLimitMiddleware
from .db.base import init_db
from .db.session import SessionLocal
from .routers.admin_router import router as admin_router
from .routers.dashboard_router import router as dashboard_router
from .routers.progress_router import router as progress_router
from .routers.students_router import router as students_router
from .services.admin_service import AdminService


@asynccontextmanager
async def lifespan(app: FastAPI):
    settings = get_settings()
    init_db()
    db = SessionLocal()
    try:
        AdminService(db).seed_admin(settings.admin_username, settings.admin_password)
    finally:
        db.close()
    yield


def create_app() -> FastAPI:
    settings = get_settings()
    app = FastAPI(
        title=settings.app_name,
        debug=settings.debug,
        lifespan=lifespan,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins_list,
        allow_credentials=True,
        allow_methods=['*'],
        allow_headers=['*'],
    )
    app.add_middleware(MobileRateLimitMiddleware)

    app.include_router(admin_router, prefix=settings.api_prefix)
    app.include_router(students_router, prefix=settings.api_prefix)
    app.include_router(progress_router, prefix=settings.api_prefix)
    app.include_router(dashboard_router, prefix=settings.api_prefix)

    @app.get('/health')
    def health():
        return {'ok': True}

    return app


app = create_app()
