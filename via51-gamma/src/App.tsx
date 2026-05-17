import React, { useState, useEffect, useRef } from 'react';
import { Activity, Shield, Database, Layout, Send, Cpu, Terminal } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema Gamma purificado. Conexión agéntica activa con Gemini 1.5 Flash. ¿Cuál es su orden estratégica para la nación?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

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
      const response = await fetch('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyCoJQYnR2YA06Uf-gL6casRio9aZUcDYzI', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: currentInput }] }]
        })
      });
      
      const data = await response.json();
      const aiText = data.candidates[0].content.parts[0].text;
      setMessages(prev => [...prev, { role: 'ai', text: aiText }]);
    } catch (error) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR DE FASE: Interferencia en la conexión con el núcleo de inteligencia.' }]);
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
    <div className="min-h-screen bg-[#020617] text-slate-200 font-sans p-4 md:p-8 flex flex-col gap-6">
      <header className="flex justify-between items-center bg-slate-900/50 p-6 rounded-3xl border border-white/5 backdrop-blur-xl shadow-2xl">
        <div className="flex items-center gap-4">
          <div className="p-3 bg-purple-500/10 rounded-2xl border border-purple-500/20 shadow-[0_0_15px_rgba(168,85,247,0.2)]">
            <Cpu className="text-purple-500" size={24} />
          </div>
          <div>
            <h1 className="text-2xl font-black tracking-tighter text-white uppercase">V51 Gamma Command</h1>
            <p className="text-[10px] text-slate-500 uppercase tracking-[0.3em]">Soberanía Nivel 9A • Fredy Bazalar</p>
          </div>
        </div>
        <div className="hidden md:flex items-center gap-3 bg-black/30 px-4 py-2 rounded-2xl border border-white/5">
          <div className="h-2 w-2 bg-green-500 rounded-full animate-pulse"></div>
          <span className="text-[10px] font-mono text-green-400 uppercase tracking-widest">Núcleo en Fase</span>
        </div>
      </header>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 flex-1 overflow-hidden">
        <aside className="lg:col-span-1 space-y-4 overflow-y-auto pr-2 custom-scrollbar">
          <h3 className="text-[10px] font-bold text-slate-500 uppercase px-2 tracking-[0.2em] mb-4">Red Trifásica</h3>
          {nodes.map(node => (
            <a key={node.id} href={node.url} target="_blank" className="block p-5 rounded-3xl bg-slate-900/40 border border-white/5 hover:border-purple-500/50 transition-all group hover:shadow-lg hover:shadow-purple-900/10">
              <div className="flex justify-between items-center">
                <div className="flex items-center gap-3">
                  <node.icon size={16} style={{color: node.color}} />
                  <span className="font-bold text-lg" style={{color: node.color}}>{node.id}</span>
                </div>
                <div className="h-1.5 w-1.5 rounded-full" style={{backgroundColor: node.color}}></div>
              </div>
              <p className="text-[10px] text-slate-500 uppercase mt-2 tracking-widest">{node.role}</p>
            </a>
          ))}
        </aside>

        <main className="lg:col-span-3 flex flex-col bg-slate-900/40 rounded-[2.5rem] border border-white/5 overflow-hidden backdrop-blur-sm shadow-inner">
          <div className="p-6 border-b border-white/5 bg-purple-500/5 flex justify-between items-center">
            <div className="flex items-center gap-2">
              <Terminal size={14} className="text-purple-400" />
              <h2 className="font-bold text-purple-400 uppercase text-[10px] tracking-[0.2em]">Consola Agéntica</h2>
            </div>
            {loading && <span className="text-[10px] text-purple-400 animate-pulse uppercase font-black">Procesando...</span>}
          </div>
          
          <div ref={scrollRef} className="flex-1 p-8 overflow-y-auto space-y-6 min-h-[450px] bg-gradient-to-b from-transparent to-purple-950/5">
            {messages.map((m, i) => (
              <div key={i} className={lex \ animate-in fade-in slide-in-from-bottom-2 duration-300}>
                <div className={max-w-[85%] p-5 rounded-[2rem] \}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap font-medium">\</p>
                </div>
              </div>
            ))}
          </div>

          <div className="p-6 bg-black/40 border-t border-white/5">
            <div className="flex gap-3 bg-slate-950 p-2 rounded-[2rem] border border-white/10 focus-within:border-purple-500/50 transition-all shadow-2xl">
              <input 
                type="text"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && handleExecute()}
                placeholder="Ingrese instrucción estratégica..."
                className="flex-1 bg-transparent border-none px-6 py-2 text-sm focus:outline-none placeholder:text-slate-700"
                disabled={loading}
              />
              <button 
                onClick={handleExecute}
                disabled={loading || !input.trim()}
                className="bg-purple-600 hover:bg-purple-500 disabled:bg-slate-800 text-white p-4 rounded-full transition-all flex items-center justify-center shadow-lg shadow-purple-900/40"
              >
                <Send size={18} />
              </button>
            </div>
          </div>
        </main>
      </div>

      <footer className="text-center py-4 border-t border-white/5">
        <p className="text-[9px] text-slate-600 italic uppercase tracking-[0.3em]">"El orden digital precede a la prosperidad nacional."</p>
      </footer>
    </div>
  );
};

export default App;