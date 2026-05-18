import React, { useState, useEffect, useRef } from 'react';
import { Cpu, Send, Layout, Database, Shield, Activity, ChevronUp, ChevronDown, Copy, ClipboardCopy, FileText, Check, Clock, Key } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema Gamma preparado para el despliegue de Calidad Mundial. Núcleo 2.5 Flash en espera de órdenes.' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [timer, setTimer] = useState(0);
  const [copiedIndex, setCopiedIndex] = useState(null);
  
  const scrollRef = useRef<HTMLDivElement>(null);
  const timerRef = useRef<any>(null);

  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY; 

  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages]);

  useEffect(() => {
    if (loading) {
      const start = Date.now();
      timerRef.current = setInterval(() => {
        setTimer(Math.floor((Date.now() - start) / 100) / 10);
      }, 100);
    } else {
      clearInterval(timerRef.current);
    }
    return () => clearInterval(timerRef.current);
  }, [loading]);

  const handleExecute = async () => {
    if (!input.trim() || loading) return;
    const userMessage = { role: 'user', text: input };
    setMessages(prev => [...prev, userMessage]);
    const currentInput = input;
    setInput('');
    setLoading(true);
    setTimer(0);

    try {
      // RECTIFICACIÓN DE SEGURIDAD: Estructura estricta para Gemini 2.5
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: currentInput }] }]
        })
      });
      
      const data = await response.json();
      
      if (data.candidates && data.candidates[0]) {
        const aiText = data.candidates[0].content.parts[0].text;
        setMessages(prev => [...prev, { role: 'ai', text: aiText }]);
      } else {
        // Captura de error real de Google para forensia
        const errorMsg = data.error ? data.error.message : "Rechazo de formato en Núcleo 2.5";
        setMessages(prev => [...prev, { role: 'ai', text: `SISTEMA: ${errorMsg}` }]);
      }
    } catch (error) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR DE FASE: Interferencia en la línea de datos.' }]);
    } finally {
      setLoading(false);
    }
  };

  const copyToClipboard = (text, id) => {
    navigator.clipboard.writeText(text);
    setCopiedIndex(id);
    setTimeout(() => setCopiedIndex(null), 2000);
  };

  return (
    <div className="h-screen bg-[#020617] text-slate-200 font-sans p-2 md:p-4 flex flex-col overflow-hidden">
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2 shadow-2xl">
        <div className="flex items-center gap-3">
          <Cpu className="text-purple-500" size={20} />
          <h1 className="text-xl font-black tracking-tighter text-white uppercase italic">V51 GAMMA PRO 2.5</h1>
        </div>
        <div className="flex items-center gap-4">
          {loading && (
            <div className="flex items-center gap-2 bg-purple-500/10 px-3 py-1 rounded-full border border-purple-500/20">
              <Clock size={12} className="text-purple-400 animate-spin" />
              <span className="text-[10px] font-mono text-purple-400 font-bold">{timer}s</span>
            </div>
          )}
          <div className="bg-green-500/10 border border-green-500/20 px-3 py-1 rounded-full flex items-center gap-2">
            <div className="h-1.5 w-1.5 bg-green-500 rounded-full animate-pulse"></div>
            <span className="text-[9px] font-mono text-green-400 uppercase font-bold">9A-OPERATIONAL</span>
          </div>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden shadow-inner">
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-6 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex flex-col ${m.role === 'ai' ? 'items-start' : 'items-end'}`}>
                <div className={`max-w-[95%] p-4 rounded-3xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.text}</p>
                </div>
                <div className="flex gap-3 mt-2 px-2">
                  {m.role === 'user' && (
                    <button onClick={() => copyToClipboard(m.text, `q-${i}`)} className="text-[9px] text-slate-500 hover:text-purple-400 uppercase font-bold flex items-center gap-1">
                      {copiedIndex === `q-${i}` ? <Check size={10}/> : <Copy size={10}/>} Copiar Pregunta
                    </button>
                  )}
                  {m.role === 'ai' && i > 0 && (
                    <button onClick={() => copyToClipboard(`PREGUNTA:\n${messages[i-1]?.text}\n\nRESPUESTA:\n${m.text}`, `all-${i}`)} className="text-[9px] text-slate-500 hover:text-blue-400 uppercase font-bold flex items-center gap-1">
                      {copiedIndex === `all-${i}` ? <Check size={10}/> : <ClipboardCopy size={10}/>} Copiar Q+A
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>

          <div className="p-4 bg-black/40 border-t border-white/5">
            <div className="flex gap-2 bg-slate-950 p-2 rounded-2xl border border-white/10 focus-within:border-purple-500/50 transition-all overflow-hidden">
              <textarea 
                placeholder="Escriba su orden estratégica (Ctrl+Enter para enviar)..."
                className="flex-1 bg-transparent border-none text-xs p-2 focus:outline-none resize-none h-20 scrollbar-hide"
                onKeyDown={(e) => { if(e.key==='Enter' && e.ctrlKey) handleExecute() }}
                onChange={(e) => setInput(e.target.value)}
                value={input}
              />
              <button onClick={handleExecute} disabled={loading || !input.trim()} className="bg-purple-600 text-white px-6 rounded-xl hover:bg-purple-500 transition-all">
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