'use client';

import Link from 'next/link';
import { useEffect, useMemo, useState } from 'react';

import RequireAuth from '@/components/RequireAuth';
import { getStudents } from '@/lib/api';
import { StudentListItem } from '@/lib/types';

export default function StudentsPage() {
  const [students, setStudents] = useState<StudentListItem[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let mounted = true;

    async function load() {
      setLoading(true);
      setError('');
      try {
        const data = await getStudents();
        if (mounted) {
          setStudents(data);
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

    load();
    return () => {
      mounted = false;
    };
  }, []);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) {
      return students;
    }
    return students.filter((student) => student.name.toLowerCase().includes(q));
  }, [students, search]);

  return (
    <RequireAuth>
      <h2 style={{ marginTop: 0 }}>Students List</h2>
      <div style={{ marginBottom: 12 }}>
        <input
          style={styles.input}
          placeholder="Search by name"
          value={search}
          onChange={(event) => setSearch(event.target.value)}
        />
      </div>
      {loading ? <p>Loading...</p> : null}
      {error ? <p style={styles.error}>{error}</p> : null}

      <div style={{ overflowX: 'auto' }}>
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>User ID</th>
              <th>Last Active</th>
              <th>Lessons Completed</th>
            </tr>
          </thead>
          <tbody>
            {filtered.map((student) => (
              <tr key={student.userId}>
                <td>
                  <Link href={`/students/${encodeURIComponent(student.userId)}`} style={styles.link}>
                    {student.name}
                  </Link>
                </td>
                <td>{student.userId}</td>
                <td>{formatDate(student.lastSeen)}</td>
                <td>{student.lessonsCompleted}</td>
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
  input: {
    width: '100%',
    maxWidth: 320,
    border: '1px solid #D8E2EE',
    borderRadius: 10,
    padding: '9px 12px',
    fontSize: 14,
  },
  error: {
    color: '#D33C3C',
    fontWeight: 700,
  },
  link: {
    color: '#1D3557',
    fontWeight: 800,
    textDecoration: 'none',
  },
};

