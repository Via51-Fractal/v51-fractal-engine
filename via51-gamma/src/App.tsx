import React, { useState, useEffect, useRef } from 'react';
import { Cpu, Send, Terminal, Layout, Database, Shield, Activity, ChevronUp, ChevronDown } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, núcleo Gemini 2.5 Flash sincronizado. El cerebro de la nación está operativo al 100%. ¿Cuál es su orden estratégica?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY;

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
      // CONEXIÓN AL MOTOR 2.5 FLASH (Confirmado por la sonda forense)
      const response = await fetch(`https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: currentInput }] }] })
      });
      
      const data = await response.json();
      if (data.candidates && data.candidates[0]) {
        const aiText = data.candidates[0].content.parts[0].text;
        setMessages(prev => [...prev, { role: 'ai', text: aiText }]);
      } else {
        setMessages(prev => [...prev, { role: 'ai', text: `SISTEMA: El núcleo no pudo procesar la orden. ${data.error?.message || ''}` }]);
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
    { id: 'ALFA', url: 'https://alfa.via51.org', color: '#22c55e', role: 'Entrega' },
    { id: 'BETA', url: 'https://beta.via51.org', color: '#eab308', role: 'Datos' },
    { id: 'HOLDING', url: 'https://holding.via51.org', color: '#06b6d4', role: 'Estrategia' },
    { id: 'ROOT', url: 'https://via51.org', color: '#3b82f6', role: 'Maestro' }
  ];

  return (
    <div className="h-screen bg-[#020617] text-slate-200 font-sans p-2 md:p-4 flex flex-col overflow-hidden">
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2">
        <div className="flex items-center gap-3">
          <Cpu className="text-purple-500" size={20} />
          <h1 className="text-xl font-black tracking-tighter text-white uppercase italic">V51 GAMMA PRO</h1>
        </div>
        <div className="bg-green-500/10 border border-green-500/20 px-3 py-1 rounded-full flex items-center gap-2">
          <div className="h-1.5 w-1.5 bg-green-500 rounded-full animate-pulse"></div>
          <span className="text-[9px] font-mono text-green-400 uppercase font-bold tracking-widest">9A-OPERATIONAL</span>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        <aside className="w-16 md:w-48 flex flex-col gap-2">
          {nodes.map(node => (
            <a key={node.id} href={node.url} target="_blank" className="flex-1 flex flex-col items-center justify-center rounded-2xl bg-slate-900/40 border border-white/5 hover:border-purple-500/50 transition-all group">
              <span className="font-bold text-[10px] md:text-xs" style={{color: node.color}}>{node.id}</span>
              <div className="h-1 w-1 rounded-full mt-1" style={{backgroundColor: node.color}}></div>
            </a>
          ))}
        </aside>

        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden">
          <div ref={scrollRef} className="flex-1 p-6 overflow-y-auto space-y-4 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex ${m.role === 'ai' ? 'justify-start' : 'justify-end'}`}>
                <div className={`max-w-[90%] p-4 rounded-3xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.text}</p>
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
                placeholder="Escriba su orden estratégica (Ctrl+Enter para enviar)..."
                className="flex-1 bg-transparent border-none text-xs p-2 focus:outline-none resize-none h-20 scrollbar-hide"
              />
              <div className="w-10 flex flex-col border-l border-white/10 bg-white/5">
                <button onMouseDown={() => scrollText('up')} className="flex-1 flex items-center justify-center hover:bg-white/10 text-slate-500"><ChevronUp size={14}/></button>
                <button onClick={handleExecute} disabled={loading || !input.trim()} className="flex-1 flex items-center justify-center bg-purple-600 text-white"><Send size={14}/></button>
                <button onMouseDown={() => scrollText('down')} className="flex-1 flex items-center justify-center hover:bg-white/10 text-slate-500"><ChevronDown size={14}/></button>
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