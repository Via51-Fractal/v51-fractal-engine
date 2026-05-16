import React from 'react';
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body style={{ margin: 0, backgroundColor: '#000', color: '#D4AF37', fontFamily: 'monospace' }}>
        {children}
      </body>
    </html>
  );
}