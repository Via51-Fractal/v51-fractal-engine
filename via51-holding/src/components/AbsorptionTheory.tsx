import { motion } from 'framer-motion';
export const AbsorptionTheory = () => (
  <div className="p-8 border border-v51-gold/10 bg-v51-gold/5">
    <h3 className="text-v51-gold font-mono text-xs tracking-widest mb-4 uppercase">TeorÃ­a de la AbsorciÃ³n</h3>
    <div className="grid grid-cols-10 gap-1 opacity-20">
      {[...Array(50)].map((_, i) => <div key={i} className="aspect-square bg-white/10" />)}
    </div>
  </div>
);