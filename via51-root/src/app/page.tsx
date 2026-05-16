'use client';
import React from 'react';
export default function Page() {
  return (
    <main style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', textAlign: 'center' }}>
      <h1 style={{ fontSize: '60px', letterSpacing: '20px', margin: 0 }}>ROOT</h1>
      <p style={{ color: '#666', letterSpacing: '5px' }}>SISTEMA ANTIGRAVITY V3.7</p>
      <div style={{ marginTop: '50px', border: '1px solid #D4AF37', padding: '20px' }}>
        <p style={{ margin: 0 }}>OWNER MASTER 9A: FREDY H\u00C9CTOR BAZALAR GRIMALDO</p>
      </div>
      <footer style={{ position: 'absolute', bottom: '40px', color: '#222', fontSize: '10px' }}>
        VIA51 | ADN PURIFICADO
      </footer>
    </main>
  );
}