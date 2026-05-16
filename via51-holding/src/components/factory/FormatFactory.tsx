import React from 'react';
import { ProductionData } from '../../types/production';

interface Props {
  data: ProductionData;
  lang: 'es' | 'qu' | 'en';
  format: 'TRINITY' | 'MANIFESTO';
  step?: number;
}

export const FormatFactory: React.FC<Props> = ({ data, lang, format, step = 1 }) => {
  const content = data[lang];
  const s = content[`s${step}` as keyof SovereignContent];
  const c = content[`c${step}` as keyof SovereignContent];

  if (format === 'TRINITY') {
    return (
      <div className="animate-in fade-in duration-700">
        <h2 className="text-4xl md:text-6xl font-black text-white mb-12 uppercase tracking-tighter leading-tight">
          {s}
        </h2>
        <div className="border-l-4 border-[#D4AF37] pl-10">
          <p className="text-xl md:text-3xl text-gray-200 leading-relaxed font-light whitespace-pre-line">
            {c}
          </p>
        </div>
      </div>
    );
  }

  return null; // Futuros formatos se aÃ±aden aqui
};