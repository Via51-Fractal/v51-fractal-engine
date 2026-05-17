import React, { useState, useEffect, useRef } from 'react';
import { Cpu, Send, Layout, Database, Shield, Activity, ChevronUp, ChevronDown, Copy, ClipboardCopy, FileText, Check, Clock, XCircle, Key, RefreshCw, Eye } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema Gamma expandido. Monitores de comparación ROOT/ALFA activos en el flanco derecho. ¿Cuál es su orden?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [timer, setTimer] = useState(0);
  const [copiedIndex, setCopiedIndex] = useState<string | null>(null);
  const [refreshKey, setRefreshKey] = useState(0);
  
  const scrollRef = useRef<HTMLDivElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);
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
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: currentInput }] }] })
      });
      const data = await response.json();
      if (data.candidates) {
        setMessages(prev => [...prev, { role: 'ai', text: data.candidates[0].content.parts[0].text }]);
      } else {
        setMessages(prev => [...prev, { role: 'ai', text: `SISTEMA: Error. ${data.error?.message || ''}` }]);
      }
    } catch (error) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR DE FASE: Interferencia en la línea.' }]);
    } finally {
      setLoading(false);
    }
  };

  const copyToClipboard = (text: string, id: string) => {
    navigator.clipboard.writeText(text);
    setCopiedIndex(id);
    setTimeout(() => setCopiedIndex(null), 2000);
  };

  const nodes = [
    { id: 'ALFA', url: 'https://alfa.via51.org', color: '#22c55e' },
    { id: 'BETA', url: 'https://beta.via51.org', color: '#eab308' },
    { id: 'HOLDING', url: 'https://holding.via51.org', color: '#06b6d4' },
    { id: 'ROOT', url: 'https://via51.org', color: '#3b82f6' }
  ];

  return (
    <div className="h-screen bg-[#020617] text-slate-200 font-sans p-2 md:p-4 flex flex-col overflow-hidden">
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2">
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
          <button onClick={() => setRefreshKey(prev => prev + 1)} className="p-2 hover:bg-white/5 rounded-full text-slate-400 transition-all">
            <RefreshCw size={16} />
          </button>
          <div className="bg-green-500/10 border border-green-500/20 px-3 py-1 rounded-full flex items-center gap-2">
            <div className="h-1.5 w-1.5 bg-green-500 rounded-full animate-pulse"></div>
            <span className="text-[9px] font-mono text-green-400 uppercase font-bold tracking-widest">9A-OPERATIONAL</span>
          </div>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        {/* COLUMNA 1: SIDEBAR NODOS */}
        <aside className="w-16 flex flex-col gap-2">
          {nodes.map(node => (
            <a key={node.id} href={node.url} target="_blank" className="flex-1 flex flex-col items-center justify-center rounded-2xl bg-slate-900/40 border border-white/5 hover:border-purple-500/50 transition-all">
              <span className="font-bold text-[10px]" style={{color: node.color}}>{node.id}</span>
            </a>
          ))}
        </aside>

        {/* COLUMNA 2: CONSOLA DE IA */}
        <main className="flex-[2] flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden">
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-6 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex flex-col ${m.role === 'ai' ? 'items-start' : 'items-end'}`}>
                <div className={`max-w-[95%] p-4 rounded-3xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.text}</p>
                </div>
                <div className="flex gap-3 mt-2 px-2">
                  {m.role === 'user' && (
                    <button onClick={() => copyToClipboard(m.text, `q-${i}`)} className="flex items-center gap-1 text-[9px] text-slate-500 hover:text-purple-400 uppercase font-bold">
                      {copiedIndex === `q-${i}` ? <Check size={10}/> : <Copy size={10}/>} Copiar
                    </button>
                  )}
                  {m.role === 'ai' && (
                    <button onClick={() => copyToClipboard(`PREGUNTA:\n${messages[i-1]?.text}\n\nRESPUESTA:\n${m.text}`, `all-${i}`)} className="flex items-center gap-1 text-[9px] text-slate-500 hover:text-blue-400 uppercase font-bold">
                      {copiedIndex === `all-${i}` ? <Check size={10}/> : <ClipboardCopy size={10}/>} Copiar Q+A
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
          <div className="p-4 bg-black/40 border-t border-white/5">
            <div className="flex gap-2 bg-slate-950 p-2 rounded-2xl border border-white/10 focus-within:border-purple-500/50">
              <textarea 
                ref={textareaRef}
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => { if(e.key==='Enter' && e.ctrlKey) handleExecute() }}
                placeholder="Ctrl + Enter para enviar..."
                className="flex-1 bg-transparent border-none text-xs p-2 focus:outline-none resize-none h-16 scrollbar-hide"
              />
              <button onClick={handleExecute} disabled={loading || !input.trim()} className="bg-purple-600 text-white px-4 rounded-xl hover:bg-purple-500 transition-all">
                <Send size={16} />
              </button>
            </div>
          </div>
        </main>

        {/* COLUMNA 3: MONITORES DE TIEMPO REAL */}
        <aside className="flex-1 hidden xl:flex flex-col gap-2">
          {/* Monitor Superior: ALFA (Producción) */}
          <div className="flex-1 bg-slate-900/60 rounded-3xl border border-white/5 overflow-hidden flex flex-col">
            <div className="p-2 bg-green-500/10 border-b border-white/5 flex justify-between items-center">
              <span className="text-[9px] font-black text-green-400 uppercase tracking-widest flex items-center gap-2">
                <Eye size={10}/> PRODUCCIÓN (ALFA)
              </span>
              <span className="text-[8px] text-slate-500 font-mono">via51.org</span>
            </div>
            <iframe 
              key={`alfa-${refreshKey}`}
              src="https://via51.org" 
              className="w-full h-full border-none grayscale-[0.3] hover:grayscale-0 transition-all"
            />
          </div>

          {/* Monitor Inferior: ROOT (Laboratorio) */}
          <div className="flex-1 bg-slate-900/60 rounded-3xl border border-white/5 overflow-hidden flex flex-col">
            <div className="p-2 bg-blue-500/10 border-b border-white/5 flex justify-between items-center">
              <span className="text-[9px] font-black text-blue-400 uppercase tracking-widest flex items-center gap-2">
                <Activity size={10}/> LABORATORIO (ROOT)
              </span>
              <span className="text-[8px] text-slate-500 font-mono">root.via51.org</span>
            </div>
            <iframe 
              key={`root-${refreshKey}`}
              src="https://root.via51.org" 
              className="w-full h-full border-none grayscale-[0.3] hover:grayscale-0 transition-all"
            />
          </div>
        </aside>
      </div>
      <footer className="text-center py-1">
        <p className="text-[8px] text-slate-600 uppercase tracking-widest">"El orden digital precede a la prosperidad nacional."</p>
      </footer>
    </div>
  );
};
export default App;