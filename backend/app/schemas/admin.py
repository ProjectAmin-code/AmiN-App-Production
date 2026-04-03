from pydantic import BaseModel, Field


class AdminLoginRequest(BaseModel):
    username: str = Field(min_length=1, max_length=64)
    password: str = Field(min_length=1, max_length=128)


class AdminLoginResponse(BaseModel):
    accessToken: str
    tokenType: str = 'bearer'


class AdminMeResponse(BaseModel):
    username: str
