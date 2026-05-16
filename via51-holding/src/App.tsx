import React from 'react';

export default function App() {
  return (
    <div style={{ backgroundColor: 'black', color: '#51AEE5', minHeight: '100vh', fontFamily: 'monospace', display: 'flex', flexDirection: 'column' }}>
      <header style={{ padding: '2rem', borderBottom: '1px solid rgba(81, 174, 229, 0.2)', backgroundColor: '#050505' }}>
        <h1 style={{ margin: 0, fontSize: '1.5rem', fontWeight: '900', letterSpacing: '-0.05em' }}>V51 // ZONA DE PRUEBA</h1>
        <p style={{ fontSize: '0.7rem', opacity: 0.5, letterSpacing: '0.3em' }}>PUENTE OPERATIVO Y FEEDBACK DE LÃDERES</p>
      </header>
      <main style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '2rem' }}>
        <div style={{ border: '1px dashed #51AEE5', padding: '4rem', textAlign: 'center', width: '100%' }}>
          <h2 style={{ fontSize: '1.2rem', fontWeight: 'bold', marginBottom: '1rem' }}>ZONA DE VALIDACIÃN ACTIVA</h2>
          <p style={{ fontSize: '0.8rem', opacity: 0.4 }}>Receptor de aplicaciones en fase de prueba para el Holding.</p>
          <div style={{ marginTop: '2rem', fontSize: '0.6rem', color: '#51AEE5' }}>ESTADO: BETA_TESTING [V12.5]</div>
        </div>
      </main>
    </div>
  );
}