'use client';

import { useEffect, useMemo, useState } from 'react';
import {
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts';

import RequireAuth from '@/components/RequireAuth';
import { getStudents, getSummary } from '@/lib/api';
import { DashboardSummary, StudentListItem } from '@/lib/types';

export default function DashboardPage() {
  const [summary, setSummary] = useState<DashboardSummary | null>(null);
  const [students, setStudents] = useState<StudentListItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let mounted = true;

    async function load() {
      setLoading(true);
      setError('');
      try {
        const [summaryData, studentData] = await Promise.all([
          getSummary(),
          getStudents(),
        ]);
        if (!mounted) {
          return;
        }
        setSummary(summaryData);
        setStudents(studentData);
      } catch (err) {
        if (!mounted) {
          return;
        }
        setError(err instanceof Error ? err.message : 'Failed to fetch dashboard data.');
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
  }, []);

  const chartData = useMemo(
    () =>
      students.slice(0, 10).map((student) => ({
        name: student.name,
        lessons: student.lessonsCompleted,
      })),
    [students],
  );

  return (
    <RequireAuth>
      <h2 style={styles.heading}>Dashboard Overview</h2>
      {loading ? <p>Loading...</p> : null}
      {error ? <p style={styles.error}>{error}</p> : null}

      {summary ? (
        <div style={styles.cards}>
          <StatCard label="Total Students" value={summary.totalStudents.toString()} />
          <StatCard
            label="Active Students Today"
            value={summary.activeStudentsToday.toString()}
          />
          <StatCard label="Lessons Completed" value={summary.lessonsCompleted.toString()} />
          <StatCard label="Average Score" value={`${summary.averageScore.toFixed(2)}`} />
        </div>
      ) : null}

      <div style={styles.chartBox}>
        <h3 style={styles.subheading}>Top Students by Lessons Completed</h3>
        <div style={{ width: '100%', height: 320 }}>
          <ResponsiveContainer>
            <BarChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis allowDecimals={false} />
              <Tooltip />
              <Bar dataKey="lessons" fill="#58CC02" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </RequireAuth>
  );
}

function StatCard({ label, value }: { label: string; value: string }) {
  return (
    <div style={styles.card}>
      <div style={styles.cardLabel}>{label}</div>
      <div style={styles.cardValue}>{value}</div>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  heading: {
    marginTop: 0,
    marginBottom: 12,
  },
  subheading: {
    marginTop: 0,
    marginBottom: 10,
  },
  cards: {
    display: 'grid',
    gap: 12,
    gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))',
    marginBottom: 16,
  },
  card: {
    background: '#F8FCFF',
    borderRadius: 12,
    padding: '12px 14px',
    border: '1px solid #E3EDF7',
  },
  cardLabel: {
    fontSize: 12,
    color: '#4A5568',
    fontWeight: 700,
    marginBottom: 6,
  },
  cardValue: {
    fontSize: 26,
    fontWeight: 900,
    color: '#1D3557',
  },
  chartBox: {
    marginTop: 10,
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

