import React, { useState, useEffect, useRef } from 'react';
import { Activity, Shield, Database, Layout, Send, Cpu, Terminal, ChevronUp, ChevronDown, Key } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema Gamma en fase. Monitor de llave activo. ¿Cuál es su orden estratégica?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  // Verificación de existencia de llave
  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY;
  const isKeyLoaded = !!GEMINI_API_KEY && GEMINI_API_KEY.length > 10;

  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages]);

  const handleExecute = async () => {
    if (!input.trim() || loading) return;
    const userMessage = { role: 'user', text: input };
    setMessages(prev => [...prev, userMessage]);
    const currentInput = input;
    setInput('');
    setLoading(true);

    try {
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: currentInput }] }] })
      });
      
      const data = await response.json();
      if (data.error) {
        setMessages(prev => [...prev, { role: 'ai', text: `SISTEMA: ${data.error.message} (Verifique la llave en Vercel)` }]);
      } else if (data.candidates && data.candidates[0]) {
        const aiText = data.candidates[0].content.parts[0].text;
        setMessages(prev => [...prev, { role: 'ai', text: aiText }]);
      }
    } catch (error) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR DE FASE: Interferencia en la línea de datos.' }]);
    } finally {
      setLoading(false);
    }
  };

  const scrollText = (direction: 'up' | 'down') => {
    if (textareaRef.current) {
      const amount = 60;
      textareaRef.current.scrollTop += (direction === 'up' ? -amount : amount);
    }
  };

  const nodes = [
    { id: 'ALFA', url: 'https://alfa.via51.org', color: '#22c55e', role: 'Entrega', icon: Layout },
    { id: 'BETA', url: 'https://beta.via51.org', color: '#eab308', role: 'Datos', icon: Database },
    { id: 'HOLDING', url: 'https://holding.via51.org', color: '#06b6d4', role: 'Estrategia', icon: Shield },
    { id: 'ROOT', url: 'https://via51.org', color: '#3b82f6', role: 'Maestro', icon: Activity }
  ];

  return (
    <div className="h-screen bg-[#020617] text-slate-200 font-sans p-2 md:p-4 flex flex-col overflow-hidden">
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2">
        <div className="flex items-center gap-3">
          <Cpu className="text-purple-500" size={20} />
          <h1 className="text-xl font-black tracking-tighter text-white uppercase">V51 Gamma</h1>
        </div>
        <div className="flex items-center gap-4">
            <div className={`flex items-center gap-2 px-3 py-1 rounded-full border ${isKeyLoaded ? 'bg-green-500/10 border-green-500/20 text-green-400' : 'bg-red-500/10 border-red-500/20 text-red-400'}`}>
              <Key size={10} />
              <span className="text-[9px] font-mono uppercase tracking-widest">{isKeyLoaded ? 'Key Active' : 'Key Missing'}</span>
            </div>
            <span className="text-[9px] font-mono text-purple-400 bg-purple-500/10 px-2 py-1 rounded border border-purple-500/20 uppercase tracking-widest">9A-Activo</span>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        <aside className="w-16 md:w-48 flex flex-col gap-2">
          {nodes.map(node => (
            <a key={node.id} href={node.url} target="_blank" className="flex-1 flex flex-col items-center justify-center rounded-2xl bg-slate-900/40 border border-white/5 hover:border-purple-500/50 transition-all group">
              <node.icon size={18} style={{color: node.color}} />
              <span className="hidden md:block font-bold text-[10px] mt-1 uppercase" style={{color: node.color}}>{node.id}</span>
            </a>
          ))}
        </aside>

        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden">
          <div className="p-3 border-b border-white/5 bg-purple-500/5 flex justify-between items-center">
            <div className="flex items-center gap-2">
              <Terminal size={12} className="text-purple-400" />
              <h2 className="font-bold text-purple-400 uppercase text-[9px] tracking-widest">Consola Agéntica</h2>
            </div>
            {loading && <span className="text-[10px] text-purple-400 animate-pulse uppercase font-black">Procesando...</span>}
          </div>
          
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-4 bg-gradient-to-b from-transparent to-purple-950/5 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex ${m.role === 'ai' ? 'justify-start' : 'justify-end'}`}>
                <div className={`max-w-[90%] p-4 rounded-3xl h-auto ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap break-words">{m.text}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="p-3 bg-black/40 border-t border-white/5">
            <div className="flex gap-2 bg-slate-950 p-1 rounded-2xl border border-white/10 focus-within:border-purple-500/50 transition-all overflow-hidden">
              <textarea 
                ref={textareaRef}
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && e.ctrlKey) {
                    e.preventDefault();
                    handleExecute();
                  }
                }}
                placeholder="Escriba su orden estratégica (Ctrl+Enter para enviar)..."
                className="flex-1 bg-transparent border-none text-xs p-4 focus:outline-none resize-none h-24 scrollbar-hide"
                style={{ scrollbarWidth: 'none' }}
              />
              
              <div className="w-10 flex flex-col border-l border-white/10 bg-white/5">
                <button onMouseDown={() => scrollText('up')} className="flex-1 flex items-center justify-center hover:bg-white/10 text-slate-500 hover:text-white transition-all">
                  <ChevronUp size={16} />
                </button>
                <button onClick={handleExecute} disabled={loading || !input.trim()} className={`flex-1 flex items-center justify-center transition-all ${loading ? 'bg-slate-800' : 'bg-purple-600 hover:bg-purple-500'} text-white`}>
                  <Send size={16} />
                </button>
                <button onMouseDown={() => scrollText('down')} className="flex-1 flex items-center justify-center hover:bg-white/10 text-slate-500 hover:text-white transition-all">
                  <ChevronDown size={16} />
                </button>
              </div>
            </div>
          </div>
        </main>
      </div>
      <footer className="text-center py-2">
        <p className="text-[8px] text-slate-600 uppercase tracking-widest italic">"El orden digital precede a la prosperidad nacional."</p>
      </footer>
    </div>
  );
};
export default App;