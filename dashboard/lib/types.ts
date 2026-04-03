export type DashboardSummary = {
  totalStudents: number;
  activeStudentsToday: number;
  lessonsCompleted: number;
  averageScore: number;
};

export type StudentListItem = {
  userId: string;
  name: string;
  createdAt: string;
  updatedAt: string;
  lastSeen: string;
  lessonsCompleted: number;
};

export type StudentDetail = {
  userId: string;
  name: string;
  createdAt: string;
  updatedAt: string;
  lastSeen: string;
};

export type ProgressItem = {
  lessonId: string;
  score: number;
  status: string;
  updatedAt: string;
};

