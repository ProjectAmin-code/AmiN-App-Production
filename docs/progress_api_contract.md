# Progress API Contract

## Endpoint
- `POST /api/progress`

## Request Body
```json
{
  "userName": "AmiN",
  "capturedAtUtc": "2026-03-13T10:20:30.000Z",
  "progress": {
    "onboardingReached": 3,
    "onboardingTotal": 3,
    "belajarReached": 3,
    "belajarTotal": 3,
    "learningReached": 8,
    "learningTotal": 15,
    "quizAnswered": 12,
    "quizAutoCorrect": 9,
    "quizAutoTotal": 10,
    "quizQuestionGoal": 32,
    "quizSessionsCompleted": 1,
    "gameStarsEarned": 14,
    "gameStarsPossible": 20,
    "gameSessionsCompleted": 3,
    "lastUpdatedUtcMillis": 1773397230000,
    "onboardingRatio": 1.0,
    "belajarRatio": 0.61,
    "quizRatio": 0.56,
    "gameRatio": 0.70,
    "overallRatio": 0.62
  }
}
```

## Minimal Node.js (Express) Handler
```js
app.post('/api/progress', async (req, res) => {
  const payload = req.body;
  // TODO: validate + persist in DB
  // Example: await db.collection('progress').insertOne(payload)
  res.status(200).json({ ok: true });
});
```

## Minimal FastAPI Handler
```python
from fastapi import FastAPI
from pydantic import BaseModel
from typing import Dict, Any

app = FastAPI()

class ProgressPayload(BaseModel):
    userName: str
    capturedAtUtc: str
    progress: Dict[str, Any]

@app.post("/api/progress")
async def save_progress(payload: ProgressPayload):
    # TODO: validate + persist in DB
    return {"ok": True}
```

