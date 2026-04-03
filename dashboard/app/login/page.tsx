'use client';

import { useRouter } from 'next/navigation';
import { FormEvent, useState } from 'react';

import { login } from '@/lib/api';
import { setToken } from '@/lib/auth';

export default function LoginPage() {
  const router = useRouter();
  const [username, setUsername] = useState('admin');
  const [password, setPassword] = useState('admin123');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setLoading(true);
    setError('');
    try {
      const token = await login(username, password);
      setToken(token);
      router.replace('/dashboard');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed');
    } finally {
      setLoading(false);
    }
  }

  return (
    <main style={styles.page}>
      <form style={styles.card} onSubmit={handleSubmit}>
        <h1 style={styles.title}>Admin Login</h1>
        <p style={styles.subtitle}>Sign in to access student analytics.</p>

        <label style={styles.label}>
          Username
          <input
            style={styles.input}
            value={username}
            onChange={(event) => setUsername(event.target.value)}
            placeholder="admin"
            required
          />
        </label>

        <label style={styles.label}>
          Password
          <input
            style={styles.input}
            value={password}
            onChange={(event) => setPassword(event.target.value)}
            type="password"
            placeholder="********"
            required
          />
        </label>

        {error ? <p style={styles.error}>{error}</p> : null}

        <button style={styles.button} type="submit" disabled={loading}>
          {loading ? 'Signing in...' : 'Login'}
        </button>
      </form>
    </main>
  );
}

const styles: Record<string, React.CSSProperties> = {
  page: {
    minHeight: '100vh',
    display: 'grid',
    placeItems: 'center',
    background: 'linear-gradient(180deg, #DFF3FF 0%, #F4F8FF 100%)',
    padding: 20,
  },
  card: {
    width: '100%',
    maxWidth: 420,
    background: '#FFFFFF',
    borderRadius: 16,
    boxShadow: '0 12px 28px rgba(11, 39, 72, 0.12)',
    padding: 20,
    display: 'grid',
    gap: 12,
  },
  title: {
    margin: 0,
    color: '#1D3557',
  },
  subtitle: {
    margin: 0,
    color: '#4A5568',
    fontSize: 14,
  },
  label: {
    display: 'grid',
    gap: 6,
    fontWeight: 700,
    color: '#1D3557',
    fontSize: 14,
  },
  input: {
    border: '1px solid #D8E2EE',
    borderRadius: 10,
    padding: '10px 12px',
    fontSize: 14,
    color: '#1D3557',
  },
  button: {
    border: 'none',
    borderRadius: 12,
    background: '#58CC02',
    color: '#FFFFFF',
    fontWeight: 800,
    padding: '11px 14px',
    cursor: 'pointer',
  },
  error: {
    margin: 0,
    color: '#D33C3C',
    fontSize: 13,
    fontWeight: 700,
  },
};

