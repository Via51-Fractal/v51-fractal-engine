import React, { useState, useEffect, useRef } from 'react';
import { Cpu, Send, Search, Key, Terminal, Layout, Database, Shield, Activity } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema Gamma RE-FUNDADO. Si ve el botón azul arriba, la actualización fue exitosa. ¿Cuál es su orden?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY;

  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages]);

  // FUNCIÓN DE DIAGNÓSTICO: Prueba qué modelos puede ver su llave
  const probeSystem = async () => {
    setLoading(true);
    try {
      const res = await fetch(`https://generativelanguage.googleapis.com/v1beta/models?key=${GEMINI_API_KEY}`);
      const data = await res.json();
      const modelList = data.models ? data.models.map((m: any) => m.name.split('/')[1]).join(', ') : "Ninguno";
      setMessages(prev => [...prev, { role: 'ai', text: `DIAGNÓSTICO: Su llave tiene acceso a: ${modelList}` }]);
    } catch (e) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR: No se pudo contactar con Google.' }]);
    } finally { setLoading(false); }
  };

  const handleExecute = async () => {
    if (!input.trim() || loading) return;
    setMessages(prev => [...prev, { role: 'user', text: input }]);
    const currentInput = input;
    setInput('');
    setLoading(true);

    try {
      // Usamos el endpoint v1 (Estable) y el modelo PRO (Universal)
      const response = await fetch(`https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=${GEMINI_API_KEY}`, {
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
    } finally { setLoading(false); }
  };

  return (
    <div className="h-screen bg-[#020617] text-slate-200 font-sans p-4 flex flex-col overflow-hidden">
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2 shadow-2xl">
        <div className="flex items-center gap-3">
          <Cpu className="text-purple-500" size={20} />
          <h1 className="text-xl font-black tracking-tighter text-white uppercase italic">V51 GAMMA PRO</h1>
        </div>
        <div className="flex gap-2">
          <button onClick={probeSystem} className="bg-blue-600 text-white px-4 py-1 rounded-full text-[10px] font-bold hover:bg-blue-500 transition-all flex items-center gap-2">
            <Search size={10} /> PROBAR NÚCLEO
          </button>
          <div className="bg-green-500/10 border border-green-500/20 px-3 py-1 rounded-full flex items-center gap-2">
            <div className="h-1.5 w-1.5 bg-green-500 rounded-full animate-pulse"></div>
            <span className="text-[9px] font-mono text-green-400 uppercase font-bold">9A-SYNC</span>
          </div>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden shadow-inner">
          <div ref={scrollRef} className="flex-1 p-6 overflow-y-auto space-y-4 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex ${m.role === 'ai' ? 'justify-start' : 'justify-end'}`}>
                <div className={`max-w-[85%] p-4 rounded-3xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.text}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="p-4 bg-black/40 border-t border-white/5">
            <div className="flex gap-2 bg-slate-950 p-2 rounded-2xl border border-white/10 focus-within:border-purple-500/50">
              <textarea 
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => { if(e.key==='Enter' && e.ctrlKey) handleExecute() }}
                placeholder="Ctrl + Enter para enviar..."
                className="flex-1 bg-transparent border-none text-xs p-2 focus:outline-none resize-none h-16"
              />
              <button onClick={handleExecute} className="bg-purple-600 text-white px-6 rounded-xl hover:bg-purple-500 transition-all">
                <Send size={18} />
              </button>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};
export default App;