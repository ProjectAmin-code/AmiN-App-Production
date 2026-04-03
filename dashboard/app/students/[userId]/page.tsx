'use client';

import { useParams } from 'next/navigation';
import { useEffect, useState } from 'react';

import RequireAuth from '@/components/RequireAuth';
import { getProgress, getStudent } from '@/lib/api';
import { ProgressItem, StudentDetail } from '@/lib/types';

export default function StudentDetailPage() {
  const params = useParams<{ userId: string }>();
  const userId = decodeURIComponent(params.userId);

  const [student, setStudent] = useState<StudentDetail | null>(null);
  const [progress, setProgress] = useState<ProgressItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let mounted = true;

    async function load() {
      setLoading(true);
      setError('');
      try {
        const [studentData, progressData] = await Promise.all([
          getStudent(userId),
          getProgress(userId),
        ]);
        if (!mounted) {
          return;
        }
        setStudent(studentData);
        setProgress(progressData);
      } catch (err) {
        if (!mounted) {
          return;
        }
        setError(err instanceof Error ? err.message : 'Failed to load student detail.');
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    }

    load();
    return () => {
      mounted = false;
    };
  }, [userId]);

  return (
    <RequireAuth>
      <h2 style={{ marginTop: 0 }}>Student Detail</h2>
      {loading ? <p>Loading...</p> : null}
      {error ? <p style={styles.error}>{error}</p> : null}

      {student ? (
        <div style={styles.metaGrid}>
          <Meta label="Student Name" value={student.name} />
          <Meta label="User ID" value={student.userId} />
          <Meta label="Registration Date" value={formatDate(student.createdAt)} />
          <Meta label="Last Active" value={formatDate(student.lastSeen)} />
        </div>
      ) : null}

      <h3>Progress Tracking</h3>
      <div style={{ overflowX: 'auto' }}>
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

function Meta({ label, value }: { label: string; value: string }) {
  return (
    <div style={styles.metaCard}>
      <div style={styles.metaLabel}>{label}</div>
      <div style={styles.metaValue}>{value}</div>
    </div>
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
  metaGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
    gap: 10,
    marginBottom: 16,
  },
  metaCard: {
    border: '1px solid #E3EDF7',
    borderRadius: 10,
    padding: 10,
    background: '#F8FCFF',
  },
  metaLabel: {
    fontSize: 12,
    color: '#4A5568',
    fontWeight: 700,
    marginBottom: 6,
  },
  metaValue: {
    fontSize: 14,
    color: '#1D3557',
    fontWeight: 700,
  },
  error: {
    color: '#D33C3C',
    fontWeight: 700,
  },
};
