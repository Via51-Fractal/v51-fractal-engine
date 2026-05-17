import React, { useState, useEffect, useRef } from 'react';
import { Activity, Shield, Database, Layout, Send, Cpu, Terminal, ChevronUp, ChevronDown, Key, Search } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sonda forense activa. Use el botón "PROBAR NÚCLEO" para identificar modelos disponibles.' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY;

  const probeModels = async () => {
    setLoading(true);
    try {
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models?key=${GEMINI_API_KEY}`);
      const data = await response.json();
      if (data.models) {
        const modelNames = data.models.map((m: any) => m.name.replace('models/', '')).join(', ');
        setMessages(prev => [...prev, { role: 'ai', text: `DIAGNÓSTICO: Modelos permitidos para su llave: ${modelNames}` }]);
      } else {
        setMessages(prev => [...prev, { role: 'ai', text: `ERROR FORENSE: Google no devolvió modelos. Mensaje: ${data.error?.message || 'Desconocido'}` }]);
      }
    } catch (e) {
      setMessages(prev => [...prev, { role: 'ai', text: 'FALLO DE CONEXIÓN: No hay respuesta del servidor de Google.' }]);
    } finally {
      setLoading(false);
    }
  };

  const handleExecute = async () => {
    if (!input.trim() || loading) return;
    setMessages(prev => [...prev, { role: 'user', text: input }]);
    const currentInput = input;
    setInput('');
    setLoading(true);

    try {
      // Intentamos con el endpoint v1 (más estable)
      const response = await fetch(`https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: currentInput }] }] })
      });
      const data = await response.json();
      if (data.candidates) {
        setMessages(prev => [...prev, { role: 'ai', text: data.candidates[0].content.parts[0].text }]);
      } else {
        setMessages(prev => [...prev, { role: 'ai', text: `SISTEMA: ${data.error?.message || 'Error de respuesta'}` }]);
      }
    } catch (error) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR DE FASE: Interferencia en la línea.' }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="h-screen bg-[#020617] text-slate-200 font-sans p-4 flex flex-col overflow-hidden">
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2">
        <div className="flex items-center gap-3">
          <Cpu className="text-purple-500" size={20} />
          <h1 className="text-xl font-black tracking-tighter text-white uppercase">V51 Gamma</h1>
        </div>
        <button onClick={probeModels} className="bg-blue-600/20 text-blue-400 border border-blue-500/30 px-4 py-1 rounded-full text-[10px] font-bold hover:bg-blue-600/40 transition-all flex items-center gap-2">
          <Search size={10} /> PROBAR NÚCLEO
        </button>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden">
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-4 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex ${m.role === 'ai' ? 'justify-start' : 'justify-end'}`}>
                <div className={`max-w-[90%] p-3 rounded-2xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white'}`}>
                  <p className="text-xs leading-relaxed whitespace-pre-wrap">{m.text}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="p-3 bg-black/40 border-t border-white/5">
            <div className="flex gap-2 bg-slate-950 p-1 rounded-2xl border border-white/10">
              <textarea 
                value={input}
                onChange={(e) => setInput(e.target.value)}
                placeholder="Escriba su orden..."
                className="flex-1 bg-transparent border-none text-xs p-4 focus:outline-none resize-none h-20"
              />
              <button onClick={handleExecute} className="bg-purple-600 text-white px-4 rounded-xl m-1"><Send size={16}/></button>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};
export default App;