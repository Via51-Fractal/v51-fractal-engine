import React from 'react';

interface Props {
  activeLang: 'es' | 'qu' | 'en';
  content: {
    [key: string]: { title: string; body: string };
  };
  issueCode: string;
}

export const ArticleSovereign: React.FC<Props> = ({ activeLang, content, issueCode }) => {
  const data = content[activeLang];
  if (!data) return null;

  // DNA de Trazabilidad (Art. 5 de la Carta Magna)
  const v51_dna = `V51-DNA-${issueCode}-${activeLang.toUpperCase()}-SECURED`;

  return (
    <div className="w-full flex flex-col gap-12">
      {/* TITULO: Peso Maximo y Tracking Negativo para Impacto */}
      <h1 style={{ 
        fontSize: 'clamp(2rem, 5vw, 4rem)', 
        fontWeight: 900, 
        lineHeight: 1, 
        letterSpacing: '-0.05em',
        color: 'white',
        textTransform: 'uppercase'
      }}>
        {data.title}
      </h1>

      {/* CUERPO: Contraste Optimizado y Borde de Oro */}
      <div style={{ 
        borderLeft: '3px solid #D4AF37', 
        paddingLeft: '2.5rem',
        display: 'flex',
        flexDirection: 'column',
        gap: '2rem'
      }}>
        <p style={{ 
          fontSize: 'clamp(1.1rem, 2vw, 1.8rem)', 
          lineHeight: 1.6, 
          color: '#E5E5E5', 
          fontWeight: 300,
          whiteSpace: 'pre-line'
        }}>
          {data.body}
        </p>
      </div>

      {/* SELLO DE SOBERANIA (DNA) */}
      <footer style={{ 
        marginTop: '4rem', 
        paddingTop: '2rem', 
        borderTop: '1px solid rgba(255,255,255,0.05)',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center'
      }}>
        <span style={{ fontSize: '10px', color: '#D4AF37', fontWeight: 900, letterSpacing: '0.3em' }}>
          VIA51 HOLDING
        </span>
        <span style={{ fontSize: '9px', color: 'rgba(255,255,255,0.2)', fontFamily: 'monospace' }}>
          {v51_dna}
        </span>
      </footer>
    </div>
  );
};