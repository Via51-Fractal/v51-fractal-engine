import './globals.css';
export const metadata = { title: 'VIA51 - GAMMA', description: 'Nivel 2 de Soberanía' };
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body style={{ margin: 0, padding: 0, backgroundColor: '#000' }}>{children}</body>
    </html>
  );
}