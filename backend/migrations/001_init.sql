-- 001_init.sql

CREATE TABLE IF NOT EXISTS students (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(64) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL,
  last_seen TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS progress (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(64) NOT NULL,
  lesson_id VARCHAR(128) NOT NULL,
  score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
  status VARCHAR(32) NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL,
  CONSTRAINT uq_progress_user_lesson UNIQUE (user_id, lesson_id),
  CONSTRAINT fk_progress_student_user_id FOREIGN KEY (user_id)
    REFERENCES students(user_id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS admins (
  id SERIAL PRIMARY KEY,
  username VARCHAR(64) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_students_last_seen ON students(last_seen DESC);
CREATE INDEX IF NOT EXISTS idx_progress_user_id ON progress(user_id);
CREATE INDEX IF NOT EXISTS idx_progress_updated_at ON progress(updated_at DESC);
