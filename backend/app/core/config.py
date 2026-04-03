from functools import lru_cache
from typing import List

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8')

    app_name: str = Field(default='AmiN Sync API', alias='APP_NAME')
    app_env: str = Field(default='development', alias='APP_ENV')
    debug: bool = Field(default=False, alias='APP_DEBUG')
    api_prefix: str = Field(default='/api', alias='API_PREFIX')

    database_url: str = Field(
        default='postgresql+psycopg://postgres:postgres@localhost:5432/amin_sync',
        alias='DATABASE_URL',
    )

    jwt_secret_key: str = Field(default='change_me', alias='JWT_SECRET_KEY')
    jwt_algorithm: str = Field(default='HS256', alias='JWT_ALGORITHM')
    jwt_expire_minutes: int = Field(default=480, alias='JWT_EXPIRE_MINUTES')

    cors_origins: str = Field(
        default='http://localhost:3000,http://127.0.0.1:3000',
        alias='CORS_ORIGINS',
    )

    admin_username: str = Field(default='admin', alias='ADMIN_USERNAME')
    admin_password: str = Field(default='admin123', alias='ADMIN_PASSWORD')

    mobile_rate_limit_per_minute: int = Field(
        default=120,
        alias='MOBILE_RATE_LIMIT_PER_MINUTE',
    )
    legacy_progress_compat: bool = Field(default=True, alias='LEGACY_PROGRESS_COMPAT')

    @property
    def cors_origins_list(self) -> List[str]:
        return [origin.strip() for origin in self.cors_origins.split(',') if origin.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
