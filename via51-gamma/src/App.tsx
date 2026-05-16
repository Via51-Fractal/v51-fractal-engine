import React, { useState } from 'react';

const App = () => {
  const [messages, setMessages] = useState([{ role: 'ai', text: 'Gobernador, sistema Gamma purificado. Monitor de canales y consola de IA activos. ¿Cuál es su orden?' }]);
  const [input, setInput] = useState('');

  const nodes = [
    { id: 'ALFA', url: 'https://alfa.via51.org', color: '#22c55e', role: 'Entrega' },
    { id: 'BETA', url: 'https://beta.via51.org', color: '#eab308', role: 'Datos' },
    { id: 'HOLDING', url: 'https://holding.via51.org', color: '#06b6d4', role: 'Estrategia' },
    { id: 'ROOT', url: 'https://via51.org', color: '#3b82f6', role: 'Maestro' }
  ];

  return (
    <div className="min-h-screen bg-[#020617] text-slate-200 font-sans p-4 md:p-8 flex flex-col gap-6">
      {/* Header Soberano */}
      <header className="flex justify-between items-center bg-slate-900/50 p-6 rounded-3xl border border-white/5">
        <div>
          <h1 className="text-2xl font-black tracking-tighter text-purple-500 uppercase">V51 Gamma Command</h1>
          <p className="text-[10px] text-slate-500 uppercase tracking-[0.3em]">Soberanía Nivel 9A</p>
        </div>
        <div className="text-right">
          <div className="h-2 w-2 bg-green-500 rounded-full animate-pulse inline-block mr-2"></div>
          <span className="text-xs font-mono text-green-400">SISTEMA EN FASE</span>
        </div>
      </header>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 flex-1">
        {/* Panel Izquierdo: Monitor de Canales */}
        <aside className="lg:col-span-1 space-y-4">
          <h3 className="text-xs font-bold text-slate-500 uppercase px-2">Red Trifásica</h3>
          {nodes.map(node => (
            <a key={node.id} href={node.url} target="_blank" className="block p-4 rounded-2xl bg-slate-900/40 border border-white/5 hover:border-purple-500/50 transition-all group">
              <div className="flex justify-between items-center">
                <span className="font-bold text-lg" style={{color: node.color}}>{node.id}</span>
                <div className="h-1.5 w-1.5 rounded-full" style={{backgroundColor: node.color}}></div>
              </div>
              <p className="text-[10px] text-slate-500 uppercase mt-1">{node.role}</p>
            </a>
          ))}
        </aside>

        {/* Panel Central: Consola de IA */}
        <main className="lg:col-span-3 flex flex-col bg-slate-900/40 rounded-[2.5rem] border border-white/5 overflow-hidden">
          <div className="p-6 border-b border-white/5 bg-purple-500/5">
            <h2 className="font-bold text-purple-400 uppercase text-sm tracking-widest">Consola Agéntica (Gemini Core)</h2>
          </div>
          
          <div className="flex-1 p-6 overflow-y-auto space-y-4 min-h-[400px]">
            {messages.map((m, i) => (
              <div key={i} className={`flex ${m.role === 'ai' ? 'justify-start' : 'justify-end'}`}>
                <div className={`max-w-[85%] p-4 rounded-2xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white'}`}>
                  <p className="text-sm leading-relaxed">{m.text}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="p-6 bg-black/20 border-t border-white/5">
            <div className="flex gap-3">
              <input 
                type="text"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                placeholder="Ingrese instrucción de mando..."
                className="flex-1 bg-slate-950 border border-white/10 rounded-2xl px-6 py-3 text-sm focus:outline-none focus:border-purple-500 transition-all"
              />
              <button className="bg-purple-600 hover:bg-purple-500 text-white px-8 py-3 rounded-2xl font-bold text-sm transition-all uppercase tracking-widest">
                Ejecutar
              </button>
            </div>
          </div>
        </main>
      </div>

      <footer className="text-center py-4">
        <p className="text-[10px] text-slate-600 italic">"El orden digital precede a la prosperidad nacional."</p>
      </footer>
    </div>
  );
};

export default App;
