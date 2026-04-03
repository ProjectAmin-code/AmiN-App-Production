# FastAPI Backend (AmiN Sync)

## Setup

```bash
cd backend
python -m venv .venv
.venv\\Scripts\\activate
pip install -r requirements.txt
copy .env.example .env
python scripts/init_db.py
uvicorn app.main:app --reload --port 8000
```

## API Endpoints

- `POST /api/students`
- `POST /api/progress`
- `GET /api/students` (admin auth)
- `GET /api/students/{userId}` (admin auth)
- `GET /api/progress/{userId}` (admin auth)
- `GET /api/dashboard/summary` (admin auth)
- `POST /api/admin/login`
- `POST /api/admin/logout`
- `GET /api/admin/me`

## Notes

- Mobile endpoints (`POST /api/students`, `POST /api/progress`) are open in v1.
- Legacy progress payload compatibility is controlled by `LEGACY_PROGRESS_COMPAT`.
- First admin account is seeded from `ADMIN_USERNAME` and `ADMIN_PASSWORD`.
