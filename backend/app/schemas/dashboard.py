from pydantic import BaseModel


class DashboardSummary(BaseModel):
    totalStudents: int
    activeStudentsToday: int
    lessonsCompleted: int
    averageScore: float
