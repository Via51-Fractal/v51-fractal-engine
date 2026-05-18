import React, { useState, useEffect, useRef } from 'react';
import { Cpu, Send, Layout, Database, Shield, Activity, ChevronUp, ChevronDown, Copy, FileText, Check, Clock, XCircle, RefreshCw, Eye, PlusCircle, Trash2, History, AlertTriangle, RotateCcw } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema de Seguridad Reforzado. Los comandos de purga ahora requieren doble validación. ¿Cuál es su orden?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [selectedNode, setSelectedNode] = useState(null);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [copiedIndex, setCopiedIndex] = useState(null);
  
  const scrollRef = useRef<HTMLDivElement>(null);
  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY; 

  const handleNodeAction = (node, action) => {
    let cmd = "";
    let msg = "";

    if (action === 'DELETE_REQUEST') {
      setConfirmDelete(true);
      return;
    }

    switch(action) {
      case 'NEW':
        cmd = `.\\V51-PREP-LAB.ps1 ${node.path}`;
        msg = `ORDEN DE CARGA: He preparado el comando para traer la base de ${node.id} al laboratorio ROOT.`;
        break;
      case 'HISTORY':
        cmd = `git log --oneline via51-${node.path}`;
        msg = `SOLICITUD DE MEMORIA: Extrayendo el histórico de maniobras de ${node.id}.`;
        break;
      case 'DELETE_CONFIRMED':
        cmd = `Remove-Item -Path C:\\via51-fractal\\via51-root\\index.html -Force`;
        msg = `ADVERTENCIA DE PURGA: Se ha generado la orden para limpiar el laboratorio ROOT. Nota: Esto no afecta a los dominios públicos.`;
        setConfirmDelete(false);
        break;
      case 'UNDO':
        cmd = `git checkout HEAD -- via51-root/index.html`;
        msg = `PROTOCOLO DE RESTAURACIÓN: He preparado el comando para deshacer el último cambio en el laboratorio y recuperar los datos.`;
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
          <h1 className="text-xl font-black tracking-tighter text-white uppercase italic">V51 GOVERNOR PRO</h1>
        </div>
        <div className="flex items-center gap-4">
          <button 
            onClick={() => handleNodeAction(null, 'UNDO')}
            className="flex items-center gap-2 px-3 py-1 bg-blue-600/20 text-blue-400 border border-blue-500/30 rounded-full text-[10px] font-bold hover:bg-blue-600/40 transition-all"
            title="Deshacer último cambio"
          >
            <RotateCcw size={12} /> DESHACER
          </button>
          <div className="bg-green-500/10 border border-green-500/20 px-3 py-1 rounded-full flex items-center gap-2">
            <div className="h-1.5 w-1.5 bg-green-500 rounded-full animate-pulse"></div>
            <span className="text-[9px] font-mono text-green-400 uppercase font-bold">9A-OPERATIONAL</span>
          </div>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        <aside className="w-20 md:w-24 flex flex-col gap-2">
          {nodes.map(node => (
            <div key={node.id} className="flex-1 flex flex-col gap-1">
              <button 
                onClick={() => { setSelectedNode(selectedNode === node.id ? null : node.id); setConfirmDelete(false); }}
                className="flex-1 flex flex-col items-center justify-center rounded-2xl bg-slate-900/40 border border-white/5 hover:border-white/20 transition-all"
                style={{ borderLeft: selectedNode === node.id ? `4px solid ${node.color}` : '1px solid rgba(255,255,255,0.1)' }}
              >
                <span className="font-bold text-[10px]" style={{color: node.color}}>{node.id}</span>
              </button>
              
              {selectedNode === node.id && (
                <div className="flex flex-col gap-1 animate-in slide-in-from-left-2">
                  <button onClick={() => handleNodeAction(node, 'NEW')} className="p-2 bg-green-600/20 text-green-400 rounded-lg flex justify-center" title="Nueva Tarea"><PlusCircle size={14}/></button>
                  <button onClick={() => handleNodeAction(node, 'HISTORY')} className="p-2 bg-blue-600/20 text-blue-400 rounded-lg flex justify-center" title="Ver Historial"><History size={14}/></button>
                  
                  {!confirmDelete ? (
                    <button onClick={() => handleNodeAction(node, 'DELETE_REQUEST')} className="p-2 bg-red-600/20 text-red-400 rounded-lg flex justify-center" title="Eliminar"><Trash2 size={14}/></button>
                  ) : (
                    <button onClick={() => handleNodeAction(node, 'DELETE_CONFIRMED')} className="p-2 bg-red-600 text-white rounded-lg flex justify-center animate-pulse" title="CONFIRMAR BORRADO"><AlertTriangle size={14}/></button>
                  )}
                </div>
              )}
            </div>
          ))}
        </aside>

        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden">
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-6 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex flex-col ${m.role === 'ai' ? 'items-start' : 'items-end'}`}>
                <div className={`max-w-[95%] p-4 rounded-3xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.text}</p>
                  {m.command && (
                    <div className="mt-4 p-3 bg-black rounded-xl border border-white/10 flex justify-between items-center gap-4">
                      <code className="text-[10px] text-green-400 font-mono break-all">{m.command}</code>
                      <button onClick={() => copyToClipboard(m.command, i)} className="p-2 bg-white/10 rounded-lg hover:bg-white/20 transition-all shrink-0">
                        {copiedIndex === i ? <Check size={14} className="text-green-400"/> : <Copy size={14}/>}
                      </button>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
          <div className="p-4 bg-black/40 border-t border-white/5">
            <textarea value={input} onChange={(e) => setInput(e.target.value)} placeholder="Dictar orden estratégica..." className="w-full bg-transparent border-none text-xs p-2 focus:outline-none resize-none h-16" />
          </div>
        </main>

        <aside className="hidden xl:flex w-64 flex flex-col gap-2">
          <div className="flex-1 bg-black/40 rounded-3xl border border-white/5 overflow-hidden flex flex-col">
            <div className="p-2 bg-green-500/10 text-[9px] font-bold text-green-400 text-center border-b border-white/5">PRODUCCIÓN (ALFA)</div>
            <iframe src="https://via51.org" className="flex-1 w-full border-none opacity-50 hover:opacity-100 transition-all"/>
          </div>
          <div className="flex-1 bg-black/40 rounded-3xl border border-white/5 overflow-hidden flex flex-col">
            <div className="p-2 bg-blue-500/10 text-[9px] font-bold text-blue-400 text-center border-b border-white/5">LABORATORIO (ROOT)</div>
            <iframe src="https://root.via51.org" className="flex-1 w-full border-none opacity-50 hover:opacity-100 transition-all"/>
          </div>
        </aside>
      </div>
    </div>
  );
};
export default App;