import React, { useState, useEffect, useRef } from 'react';
import { Cpu, Send, Layout, Database, Shield, Activity, ChevronUp, ChevronDown, Copy, FileText, Check, Clock, XCircle, RefreshCw, Eye, List, PlusCircle, Trash2, History } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema de Gestión Idiomática activo. Seleccione un canal a la izquierda para iniciar una maniobra.' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [selectedNode, setSelectedNode] = useState(null);
  const [copiedIndex, setCopiedIndex] = useState(null);
  
  const scrollRef = useRef<HTMLDivElement>(null);
  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY; 

  const nodes = [
    { id: 'ALFA', color: '#22c55e', role: 'Entrega', path: 'alfa' },
    { id: 'BETA', color: '#eab308', role: 'Datos', path: 'beta' },
    { id: 'GAMMA', color: '#a855f7', role: 'Inteligencia', path: 'gamma' },
    { id: 'HOLDING', color: '#06b6d4', role: 'Estrategia', path: 'holding' },
    { id: 'ROOT', color: '#3b82f6', role: 'Maestro', path: 'root' }
  ];

  const handleNodeAction = (node, action) => {
    let cmd = "";
    let msg = "";

    switch(action) {
      case 'NEW':
        cmd = `.\\V51-PREP-LAB.ps1 ${node.path}`;
        msg = `Gobernador, he preparado la orden para iniciar una NUEVA TAREA en ${node.id}. Copie el comando abajo y ejecútelo en Antigravity para traer la base al laboratorio.`;
        break;
      case 'HISTORY':
        cmd = `git log --pretty=format:"%h - %an, %ar : %s" via51-${node.path}`;
        msg = `Solicitando histórico de maniobras para el nodo ${node.id}...`;
        break;
      case 'DELETE':
        cmd = `Remove-Item -Path C:\\via51-fractal\\via51-root\\index.html -Force`;
        msg = `Orden de purga de laboratorio ROOT emitida.`;
        break;
    }

    setMessages(prev => [...prev, { role: 'ai', text: msg, command: cmd }]);
  };

  const copyToClipboard = (text, id) => {
    navigator.clipboard.writeText(text);
    setCopiedIndex(id);
    setTimeout(() => setCopiedIndex(null), 2000);
  };

  return (
    <div className="h-screen bg-[#020617] text-slate-200 font-sans p-2 md:p-4 flex flex-col overflow-hidden">
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2">
        <div className="flex items-center gap-3">
          <Cpu className="text-purple-500" size={20} />
          <h1 className="text-xl font-black tracking-tighter text-white uppercase italic text-gold">V51 GOVERNOR PRO</h1>
        </div>
        <div className="bg-green-500/10 border border-green-500/20 px-3 py-1 rounded-full flex items-center gap-2">
          <div className="h-1.5 w-1.5 bg-green-500 rounded-full animate-pulse"></div>
          <span className="text-[9px] font-mono text-green-400 uppercase font-bold">9A-OPERATIONAL</span>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        {/* SIDEBAR DE NODOS CON ACCIONES */}
        <aside className="w-20 md:w-24 flex flex-col gap-2">
          {nodes.map(node => (
            <div key={node.id} className="flex-1 flex flex-col gap-1">
              <button 
                onClick={() => setSelectedNode(selectedNode === node.id ? null : node.id)}
                className="flex-1 flex flex-col items-center justify-center rounded-2xl bg-slate-900/40 border border-white/5 hover:border-white/20 transition-all"
                style={{ borderLeft: selectedNode === node.id ? `4px solid ${node.color}` : '1px solid rgba(255,255,255,0.1)' }}
              >
                <span className="font-bold text-[10px]" style={{color: node.color}}>{node.id}</span>
              </button>
              
              {selectedNode === node.id && (
                <div className="flex flex-col gap-1 animate-in slide-in-from-left-2 duration-200">
                  <button onClick={() => handleNodeAction(node, 'NEW')} className="p-2 bg-green-600/20 text-green-400 rounded-lg flex justify-center"><PlusCircle size={14}/></button>
                  <button onClick={() => handleNodeAction(node, 'HISTORY')} className="p-2 bg-blue-600/20 text-blue-400 rounded-lg flex justify-center"><History size={14}/></button>
                  <button onClick={() => handleNodeAction(node, 'DELETE')} className="p-2 bg-red-600/20 text-red-400 rounded-lg flex justify-center"><Trash2 size={14}/></button>
                </div>
              )}
            </div>
          ))}
        </aside>

        {/* CONSOLA DE MANDO */}
        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden">
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-6 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex flex-col ${m.role === 'ai' ? 'items-start' : 'items-end'}`}>
                <div className={`max-w-[95%] p-4 rounded-3xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.text}</p>
                  
                  {m.command && (
                    <div className="mt-4 p-3 bg-black rounded-xl border border-white/10 flex justify-between items-center gap-4">
                      <code className="text-[10px] text-green-400 font-mono break-all">{m.command}</code>
                      <button 
                        onClick={() => copyToClipboard(m.command, i)}
                        className="p-2 bg-white/10 rounded-lg hover:bg-white/20 transition-all shrink-0"
                      >
                        {copiedIndex === i ? <Check size={14} className="text-green-400"/> : <Copy size={14}/>}
                      </button>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
          <div className="p-4 bg-black/40 border-t border-white/5">
            <textarea 
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Dictar orden estratégica..."
              className="w-full bg-transparent border-none text-xs p-2 focus:outline-none resize-none h-16"
            />
          </div>
        </main>

        {/* MONITORES (Solo en PC) */}
        <aside className="hidden xl:flex w-64 flex-col gap-2">
          <div className="flex-1 bg-black/40 rounded-3xl border border-white/5 overflow-hidden">
             <iframe src="https://via51.org" className="w-full h-full border-none opacity-50 hover:opacity-100 transition-all"/>
          </div>
          <div className="flex-1 bg-black/40 rounded-3xl border border-white/5 overflow-hidden">
             <iframe src="https://root.via51.org" className="w-full h-full border-none opacity-50 hover:opacity-100 transition-all"/>
          </div>
        </aside>
      </div>
    </div>
  );
};
export default App;