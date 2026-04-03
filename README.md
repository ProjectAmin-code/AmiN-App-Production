# AmiN Learning Platform

This repository now includes the complete student sync platform:

1. Flutter mobile app (`/lib`)
2. FastAPI + PostgreSQL backend (`/backend`)
3. Next.js admin dashboard (`/dashboard`)

## Mobile App (Flutter)

The app now syncs with event-based APIs:

- `POST /api/students` for child registration with local UUID
- `POST /api/progress` for lesson/game/quiz progress updates

Legacy snapshot payload compatibility is still retained through the backend.

### Run

```bash
flutter pub get
flutter run
```

## Backend API (FastAPI)

See [`backend/README.md`](backend/README.md) for setup.

Core endpoints:

- `POST /api/students`
- `POST /api/progress`
- `GET /api/students` (admin auth)
- `GET /api/students/{userId}` (admin auth)
- `GET /api/progress/{userId}` (admin auth)
- `GET /api/dashboard/summary` (admin auth)
- `POST /api/admin/login`
- `POST /api/admin/logout`
- `GET /api/admin/me`

## Admin Dashboard (Next.js)

See [`dashboard/README.md`](dashboard/README.md) for setup.

Pages:

- `/login`
- `/dashboard`
- `/students`
- `/students/[userId]`
- `/progress`
