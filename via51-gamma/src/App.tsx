import React, { useState, useEffect, useRef } from 'react';
import { Activity, Shield, Database, Layout, Send, Cpu, Terminal } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema Gamma en modo Alta Densidad. Todo el Holding en una sola vista. Â¿CuÃ¡l es su orden?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

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
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: currentInput }] }] })
      });
      
      const data = await response.json();
      if (data.candidates && data.candidates[0]) {
        const aiText = data.candidates[0].content.parts[0].text;
        setMessages(prev => [...prev, { role: 'ai', text: aiText }]);
      } else {
        throw new Error("Respuesta incompleta");
      }
    } catch (error) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR DE FASE: Verifique su conexiÃ³n o la validez de la llave de inteligencia.' }]);
    } finally {
      setLoading(false);
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
      {/* Header Compacto */}
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2">
        <div className="flex items-center gap-3">
          <Cpu className="text-purple-500" size={20} />
          <h1 className="text-xl font-black tracking-tighter text-white uppercase">V51 Gamma</h1>
        </div>
        <div className="flex items-center gap-4">
            <span className="text-[9px] font-mono text-green-400 bg-green-500/10 px-2 py-1 rounded border border-green-500/20">9A-ACTIVE</span>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        {/* Sidebar Mini */}
        <aside className="w-16 md:w-48 flex flex-col gap-2">
          {nodes.map(node => (
            <a key={node.id} href={node.url} target="_blank" className="flex-1 flex flex-col items-center justify-center rounded-2xl bg-slate-900/40 border border-white/5 hover:border-purple-500/50 transition-all group">
              <node.icon size={18} style={{color: node.color}} />
              <span className="hidden md:block font-bold text-[10px] mt-1" style={{color: node.color}}>{node.id}</span>
            </a>
          ))}
        </aside>

        {/* Consola Principal */}
        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden">
          <div className="p-3 border-b border-white/5 bg-purple-500/5 flex justify-between items-center">
            <div className="flex items-center gap-2">
              <Terminal size={12} className="text-purple-400" />
              <h2 className="font-bold text-purple-400 uppercase text-[9px] tracking-widest">Consola AgÃ©ntica</h2>
            </div>
          </div>
          
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-4 bg-gradient-to-b from-transparent to-purple-950/5">
            {messages.map((m, i) => (
              <div key={i} className={`flex ${m.role === 'ai' ? 'justify-start' : 'justify-end'}`}>
                <div className={`max-w-[90%] p-3 rounded-2xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white'}`}>
                  <p className="text-xs leading-relaxed whitespace-pre-wrap">{m.text}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="p-3 bg-black/40 border-t border-white/5">
            <div className="flex gap-2 bg-slate-950 p-1 rounded-full border border-white/10 focus-within:border-purple-500/50">
              <input 
                type="text"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && handleExecute()}
                placeholder="Orden estratÃ©gica..."
                className="flex-1 bg-transparent border-none px-4 py-1 text-xs focus:outline-none"
                disabled={loading}
              />
              <button 
                onClick={handleExecute}
                disabled={loading || !input.trim()}
                className="bg-purple-600 hover:bg-purple-500 disabled:bg-slate-800 text-white p-2 rounded-full transition-all"
              >
                <Send size={14} />
              </button>
            </div>
          </div>
        </main>
      </div>

      <footer className="text-center py-2">
        <p className="text-[8px] text-slate-600 uppercase tracking-widest">"El orden digital precede a la prosperidad nacional."</p>
      </footer>
    </div>
  );
};

export default App;