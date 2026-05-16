interface SovereignReaderProps {
  title: string;
  content: string;
  concept: string;
}
export const SovereignReader = ({ title, content, concept }: SovereignReaderProps) => (
  <div style={{ borderLeft: '2px solid #D4AF37', paddingLeft: '20px', margin: '20px 0' }}>
    <span style={{ color: '#D4AF37', fontSize: '10px', textTransform: 'uppercase' }}>{concept}</span>
    <h2 style={{ fontSize: '32px', fontWeight: '900', color: '#fff' }}>{title}</h2>
    <p style={{ color: '#ccc', fontSize: '18px', lineHeight: '1.6' }}>{content}</p>
  </div>
);