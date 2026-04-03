import './globals.css';

export const metadata = {
  title: 'AmiN Admin Dashboard',
  description: 'Student progress monitoring dashboard',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}

