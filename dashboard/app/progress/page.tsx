'use client';

import { useEffect, useMemo, useState } from 'react';
import {
  CartesianGrid,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts';

import RequireAuth from '@/components/RequireAuth';
import { getProgress, getStudents } from '@/lib/api';
import { ProgressItem, StudentListItem } from '@/lib/types';

export default function ProgressPage() {
  const [students, setStudents] = useState<StudentListItem[]>([]);
  const [selectedUserId, setSelectedUserId] = useState('');
  const [progress, setProgress] = useState<ProgressItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let mounted = true;

    async function loadStudents() {
      setLoading(true);
      setError('');
      try {
        const data = await getStudents();
        if (!mounted) {
          return;
        }
        setStudents(data);
        if (data.length > 0) {
          setSelectedUserId(data[0].userId);
        }
      } catch (err) {
        if (mounted) {
          setError(err instanceof Error ? err.message : 'Failed to load students.');
        }
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    }

    loadStudents();
    return () => {
      mounted = false;
    };
  }, []);

  useEffect(() => {
    let mounted = true;
    async function loadProgress() {
      if (!selectedUserId) {
        setProgress([]);
        return;
      }
      try {
        const data = await getProgress(selectedUserId);
        if (mounted) {
          setProgress(data);
        }
      } catch (err) {
        if (mounted) {
          setError(err instanceof Error ? err.message : 'Failed to load progress.');
        }
      }
    }

    loadProgress();
    return () => {
      mounted = false;
    };
  }, [selectedUserId]);

  const chartData = useMemo(
    () =>
      [...progress]
        .reverse()
        .map((row) => ({
          lesson: row.lessonId,
          score: row.score,
        })),
    [progress],
  );

  return (
    <RequireAuth>
      <h2 style={{ marginTop: 0 }}>Progress Tracking</h2>
      {loading ? <p>Loading...</p> : null}
      {error ? <p style={styles.error}>{error}</p> : null}

      <div style={styles.selectorWrap}>
        <label style={styles.label}>
          Student
          <select
            style={styles.select}
            value={selectedUserId}
            onChange={(event) => setSelectedUserId(event.target.value)}
          >
            {students.map((student) => (
              <option key={student.userId} value={student.userId}>
                {student.name} ({student.userId})
              </option>
            ))}
          </select>
        </label>
      </div>

      <div style={styles.chartBox}>
        <h3 style={{ marginTop: 0 }}>Score Trend by Lesson</h3>
        <div style={{ width: '100%', height: 280 }}>
          <ResponsiveContainer>
            <LineChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="lesson" minTickGap={12} />
              <YAxis domain={[0, 100]} />
              <Tooltip />
              <Line type="monotone" dataKey="score" stroke="#58CC02" strokeWidth={3} />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div style={{ overflowX: 'auto', marginTop: 16 }}>
        <table>
          <thead>
            <tr>
              <th>Lesson</th>
              <th>Score</th>
              <th>Status</th>
              <th>Last Updated</th>
            </tr>
          </thead>
          <tbody>
            {progress.map((row) => (
              <tr key={`${row.lessonId}-${row.updatedAt}`}>
                <td>{row.lessonId}</td>
                <td>{row.score}</td>
                <td>{row.status}</td>
                <td>{formatDate(row.updatedAt)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </RequireAuth>
  );
}

function formatDate(value: string): string {
  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) {
    return value;
  }
  return parsed.toLocaleString();
}

const styles: Record<string, React.CSSProperties> = {
  selectorWrap: {
    marginBottom: 12,
  },
  label: {
    display: 'grid',
    gap: 6,
    fontWeight: 700,
    fontSize: 14,
  },
  select: {
    border: '1px solid #D8E2EE',
    borderRadius: 10,
    padding: '9px 12px',
    fontSize: 14,
    maxWidth: 460,
  },
  chartBox: {
    marginTop: 8,
    background: '#F8FCFF',
    borderRadius: 12,
    border: '1px solid #E3EDF7',
    padding: 12,
  },
  error: {
    color: '#D33C3C',
    fontWeight: 700,
  },
};

