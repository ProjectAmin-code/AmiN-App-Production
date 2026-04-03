'use client';

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { ReactNode, useEffect, useState } from 'react';

import { getMe, logout } from '@/lib/api';
import { clearToken, getToken } from '@/lib/auth';

export default function RequireAuth({ children }: { children: ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const [loading, setLoading] = useState(true);
  const [username, setUsername] = useState<string>('');

  useEffect(() => {
    let cancelled = false;

    async function bootstrap() {
      const token = getToken();
      if (!token) {
        router.replace('/login');
        return;
      }

      try {
        const me = await getMe();
        if (!cancelled) {
          setUsername(me.username);
          setLoading(false);
        }
      } catch {
        clearToken();
        if (!cancelled) {
          router.replace('/login');
        }
      }
    }

    bootstrap();
    return () => {
      cancelled = true;
    };
  }, [router]);

  async function handleLogout() {
    try {
      await logout();
    } finally {
      clearToken();
      router.replace('/login');
    }
  }

  if (loading) {
    return <main style={styles.center}>Loading...</main>;
  }

  return (
    <div style={styles.page}>
      <header style={styles.header}>
        <div>
          <strong>AmiN Admin Dashboard</strong>
          <div style={styles.subtle}>Signed in as {username}</div>
        </div>
        <button style={styles.logout} onClick={handleLogout}>
          Logout
        </button>
      </header>
      <nav style={styles.nav}>
        <Link href="/dashboard" style={pathname === '/dashboard' ? styles.activeLink : styles.link}>
          Overview
        </Link>
        <Link href="/students" style={pathname.startsWith('/students') ? styles.activeLink : styles.link}>
          Students
        </Link>
        <Link href="/progress" style={pathname === '/progress' ? styles.activeLink : styles.link}>
          Progress
        </Link>
      </nav>
      <section style={styles.content}>{children}</section>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  page: {
    minHeight: '100vh',
    padding: 20,
    background: '#F4F8FF',
    color: '#1D3557',
  },
  header: {
    background: '#FFFFFF',
    borderRadius: 16,
    padding: '14px 16px',
    boxShadow: '0 6px 18px rgba(11, 39, 72, 0.08)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  subtle: {
    fontSize: 12,
    color: '#4A5568',
    marginTop: 2,
  },
  nav: {
    display: 'flex',
    gap: 10,
    marginBottom: 16,
  },
  link: {
    background: '#EAF0FA',
    color: '#1D3557',
    padding: '10px 14px',
    borderRadius: 12,
    textDecoration: 'none',
    fontWeight: 700,
  },
  activeLink: {
    background: '#58CC02',
    color: '#FFFFFF',
    padding: '10px 14px',
    borderRadius: 12,
    textDecoration: 'none',
    fontWeight: 700,
  },
  content: {
    background: '#FFFFFF',
    borderRadius: 16,
    padding: 16,
    boxShadow: '0 6px 18px rgba(11, 39, 72, 0.08)',
  },
  logout: {
    border: 'none',
    background: '#FF6B6B',
    color: '#FFFFFF',
    borderRadius: 10,
    fontWeight: 700,
    padding: '8px 12px',
    cursor: 'pointer',
  },
  center: {
    minHeight: '100vh',
    display: 'grid',
    placeItems: 'center',
    background: '#F4F8FF',
  },
};

