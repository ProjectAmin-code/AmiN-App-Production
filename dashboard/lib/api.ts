import { clearToken, getToken } from './auth';
import { DashboardSummary, ProgressItem, StudentDetail, StudentListItem } from './types';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:8000';

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const token = getToken();
  const headers = new Headers(init?.headers);
  headers.set('Content-Type', 'application/json');
  if (token) {
    headers.set('Authorization', `Bearer ${token}`);
  }

  const res = await fetch(`${API_BASE_URL}${path}`, {
    ...init,
    headers,
    cache: 'no-store',
  });

  if (res.status === 401) {
    clearToken();
    throw new Error('Unauthorized. Please login again.');
  }

  if (!res.ok) {
    const text = await res.text();
    throw new Error(text || `Request failed (${res.status})`);
  }

  return (await res.json()) as T;
}

export async function login(username: string, password: string): Promise<string> {
  const data = await request<{ accessToken: string }>('/api/admin/login', {
    method: 'POST',
    body: JSON.stringify({ username, password }),
  });
  return data.accessToken;
}

export async function getMe(): Promise<{ username: string }> {
  return request<{ username: string }>('/api/admin/me');
}

export async function logout(): Promise<void> {
  await request('/api/admin/logout', { method: 'POST' });
}

export async function getSummary(): Promise<DashboardSummary> {
  return request<DashboardSummary>('/api/dashboard/summary');
}

export async function getStudents(search?: string): Promise<StudentListItem[]> {
  const query = search ? `?search=${encodeURIComponent(search)}` : '';
  return request<StudentListItem[]>(`/api/students${query}`);
}

export async function getStudent(userId: string): Promise<StudentDetail> {
  return request<StudentDetail>(`/api/students/${encodeURIComponent(userId)}`);
}

export async function getProgress(userId: string): Promise<ProgressItem[]> {
  return request<ProgressItem[]>(`/api/progress/${encodeURIComponent(userId)}`);
}

