import time
from collections import defaultdict, deque
from typing import Deque, Dict

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse

from .config import get_settings


class MobileRateLimitMiddleware(BaseHTTPMiddleware):
    def __init__(self, app):
        super().__init__(app)
        self._buckets: Dict[str, Deque[float]] = defaultdict(deque)

    async def dispatch(self, request: Request, call_next):
        settings = get_settings()
        path = request.url.path
        if request.method == 'POST' and path in ('/api/students', '/api/progress'):
            now = time.time()
            window_start = now - 60.0
            client = request.client.host if request.client else 'unknown'
            key = f'{client}:{path}'
            bucket = self._buckets[key]

            while bucket and bucket[0] < window_start:
                bucket.popleft()

            if len(bucket) >= settings.mobile_rate_limit_per_minute:
                return JSONResponse(
                    status_code=429,
                    content={'detail': 'Rate limit exceeded for mobile sync endpoint.'},
                )
            bucket.append(now)

        return await call_next(request)
