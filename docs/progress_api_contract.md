# Student Sync API Contract

## 1) Register Student

- `POST /api/students`

Request:

```json
{
  "userId": "uuid-v4",
  "name": "child_name",
  "createdAt": "2026-03-14T12:30:00.000Z",
  "updatedAt": "2026-03-14T12:30:00.000Z"
}
```

Behavior:

- Upsert by `userId`
- Update `name`, `updatedAt`, and `lastSeen`

## 2) Upsert Progress

- `POST /api/progress`

Request:

```json
{
  "userId": "uuid-v4",
  "lessonId": "S006",
  "status": "completed",
  "score": 80,
  "updatedAt": "2026-03-14T12:45:00.000Z"
}
```

Behavior:

- Upsert by `(userId, lessonId)`
- Update student `lastSeen`

## 3) Admin Read APIs (Auth Required)

- `GET /api/students`
- `GET /api/students/{userId}`
- `GET /api/progress/{userId}`
- `GET /api/dashboard/summary`

## 4) Admin Auth APIs

- `POST /api/admin/login`
- `POST /api/admin/logout`
- `GET /api/admin/me`

## 5) Legacy Compatibility

`POST /api/progress` also accepts temporary legacy payload:

```json
{
  "userName": "AmiN",
  "capturedAtUtc": "2026-03-13T10:20:30.000Z",
  "progress": {
    "onboardingRatio": 1.0,
    "belajarRatio": 0.7,
    "quizRatio": 0.56,
    "gameRatio": 0.70
  }
}
```

It is mapped to canonical lesson IDs:

- `ONBOARDING`
- `BELAJAR`
- `QUIZ`
- `GAMES`
