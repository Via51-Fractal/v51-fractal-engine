import React, { useState, useEffect, useRef } from 'react';
import { Cpu, Send, Layout, Database, Shield, Activity, ChevronUp, ChevronDown, Copy, ClipboardCopy, FileText, Check, Clock, XCircle, Key, Eye, RefreshCw, PlusCircle, History, Trash2, AlertTriangle, RotateCcw } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema Gamma en fase total. Gestión idiomática y monitores sincronizados. ¿Cuál es su orden?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [timer, setTimer] = useState(0);
  const [selectedNode, setSelectedNode] = useState(null);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [copiedIndex, setCopiedIndex] = useState(null);
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

  const copyToClipboard = (text, id) => {
    if (!text) return;
    navigator.clipboard.writeText(text);
    setCopiedIndex(id);
    setTimeout(() => setCopiedIndex(null), 2000);
  };

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
        setMessages(prev => [...prev, { role: 'ai', text: `SISTEMA: Error en núcleo. ${data.error?.message || ''}` }]);
      }
    } catch (error) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR DE FASE: Interferencia en la línea.' }]);
    } finally {
      setLoading(false);
    }
  };

  const handleNodeAction = (node, action) => {
    let cmd = "";
    let msg = "";
    if (action === 'DELETE_REQUEST') { setConfirmDelete(true); return; }
    
    switch(action) {
      case 'NEW':
        cmd = `.\\V51-PREP-LAB.ps1 ${node.path}`;
        msg = `ORDEN DE CARGA: Preparado comando para traer base de ${node.id} al laboratorio ROOT.`;
        break;
      case 'HISTORY':
        cmd = `git log --oneline via51-${node.path}`;
        msg = `MEMORIA: Extrayendo histórico de maniobras de ${node.id}.`;
        break;
      case 'DELETE_CONFIRMED':
        cmd = `Remove-Item -Path C:\\via51-fractal\\via51-root\\index.html -Force`;
        msg = `PURGA: Orden de limpieza de laboratorio ROOT generada.`;
        setConfirmDelete(false);
        break;
      case 'UNDO':
        cmd = `git checkout HEAD -- via51-root/index.html`;
        msg = `RESTAURACIÓN: Preparado comando para deshacer cambios en ROOT.`;
        break;
    }
    setMessages(prev => [...prev, { role: 'ai', text: msg, command: cmd }]);
  };

  const nodes = [
    { id: 'ALFA', color: '#22c55e', path: 'alfa', icon: Layout },
    { id: 'BETA', color: '#eab308', path: 'beta', icon: Database },
    { id: 'GAMMA', color: '#a855f7', path: 'gamma', icon: Cpu },
    { id: 'HOLDING', color: '#06b6d4', path: 'holding', icon: Shield },
    { id: 'ROOT', color: '#3b82f6', path: 'root', icon: Activity }
  ];

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
          <button onClick={() => handleNodeAction(null, 'UNDO')} className="px-3 py-1 bg-blue-600/20 text-blue-400 border border-blue-500/30 rounded-full text-[10px] font-bold hover:bg-blue-600/40 transition-all flex items-center gap-2">
            <RotateCcw size={12} /> DESHACER
          </button>
          <button onClick={() => setRefreshKey(prev => prev + 1)} className="p-2 hover:bg-white/5 rounded-full text-slate-400 transition-all"><RefreshCw size={16} /></button>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        {/* COLUMNA 1: GESTIÓN IDIOMÁTICA */}
        <aside className="w-20 md:w-24 flex flex-col gap-2">
          {nodes.map(node => (
            <div key={node.id} className="flex-1 flex flex-col gap-1">
              <button 
                onClick={() => { setSelectedNode(selectedNode === node.id ? null : node.id); setConfirmDelete(false); }}
                className="flex-1 flex flex-col items-center justify-center rounded-2xl bg-slate-900/40 border border-white/5 hover:border-white/20 transition-all"
                style={{ borderLeft: selectedNode === node.id ? `4px solid ${node.color}` : '1px solid rgba(255,255,255,0.1)' }}
              >
                <node.icon size={16} style={{color: node.color}} />
                <span className="font-bold text-[10px] mt-1" style={{color: node.color}}>{node.id}</span>
              </button>
              {selectedNode === node.id && (
                <div className="flex flex-col gap-1 animate-in slide-in-from-left-2">
                  <button onClick={() => handleNodeAction(node, 'NEW')} className="p-2 bg-green-600/20 text-green-400 rounded-lg flex justify-center" title="Nueva Tarea"><PlusCircle size={14}/></button>
                  <button onClick={() => handleNodeAction(node, 'HISTORY')} className="p-2 bg-blue-600/20 text-blue-400 rounded-lg flex justify-center" title="Ver Historial"><History size={14}/></button>
                  {!confirmDelete ? (
                    <button onClick={() => handleNodeAction(node, 'DELETE_REQUEST')} className="p-2 bg-red-600/20 text-red-400 rounded-lg flex justify-center" title="Eliminar"><Trash2 size={14}/></button>
                  ) : (
                    <button onClick={() => handleNodeAction(node, 'DELETE_CONFIRMED')} className="p-2 bg-red-600 text-white rounded-lg flex justify-center animate-pulse"><AlertTriangle size={14}/></button>
                  )}
                </div>
              )}
            </div>
          ))}
        </aside>

        {/* COLUMNA 2: CONSOLA DE IA */}
        <main className="flex-[2] flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden shadow-inner">
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-6 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex flex-col ${m.role === 'ai' ? 'items-start' : 'items-end'}`}>
                <div className={`max-w-[95%] p-4 rounded-3xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.text}</p>
                  {m.command && (
                    <div className="mt-4 p-3 bg-black rounded-xl border border-white/10 flex justify-between items-center gap-4">
                      <code className="text-[10px] text-green-400 font-mono break-all">{m.command}</code>
                      <button onClick={() => copyToClipboard(m.command, `cmd-${i}`)} className="p-2 bg-white/10 rounded-lg hover:bg-white/20 transition-all">
                        {copiedIndex === `cmd-${i}` ? <Check size={14} className="text-green-400"/> : <Copy size={14}/>}
                      </button>
                    </div>
                  )}
                </div>
                <div className="flex gap-3 mt-2 px-2">
                  {m.role === 'user' && (
                    <button onClick={() => copyToClipboard(m.text, `q-${i}`)} className="text-[9px] text-slate-500 hover:text-purple-400 uppercase font-bold flex items-center gap-1">
                      {copiedIndex === `q-${i}` ? <Check size={10}/> : <Copy size={10}/>} Copiar Pregunta
                    </button>
                  )}
                  {m.role === 'ai' && i > 0 && messages[i-1]?.role === 'user' && (
                    <button onClick={() => copyToClipboard(`PREGUNTA:\n${messages[i-1].text}\n\nRESPUESTA:\n${m.text}`, `all-${i}`)} className="text-[9px] text-slate-500 hover:text-blue-400 uppercase font-bold flex items-center gap-1">
                      {copiedIndex === `all-${i}` ? <Check size={10}/> : <ClipboardCopy size={10}/>} Copiar Q+A
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
          <div className="p-4 bg-black/40 border-t border-white/5">
            <div className="flex gap-2 bg-slate-950 p-2 rounded-2xl border border-white/10 focus-within:border-purple-500/50 transition-all overflow-hidden shadow-2xl">
              <textarea 
                placeholder="Escriba su orden estratégica (Ctrl+Enter para enviar)..."
                className="flex-1 bg-transparent border-none text-xs p-2 focus:outline-none resize-none h-20 scrollbar-hide"
                onKeyDown={(e) => { if(e.key==='Enter' && e.ctrlKey) handleExecute() }}
                onChange={(e) => setInput(e.target.value)}
                value={input}
              />
              <div className="w-10 flex flex-col border-l border-white/10 bg-white/5">
                <button onClick={handleExecute} disabled={loading || !input.trim()} className="flex-1 flex items-center justify-center bg-purple-600 text-white hover:bg-purple-500 transition-all">
                  {loading ? <Clock size={14} className="animate-spin" /> : <Send size={14} />}
                </button>
              </div>
            </div>
          </div>
        </main>

        {/* COLUMNA 3: MONITORES */}
        <aside className="hidden xl:flex flex-1 flex flex-col gap-2">
          <div className="flex-1 bg-slate-900/60 rounded-3xl border border-white/5 overflow-hidden flex flex-col">
            <div className="p-2 bg-green-500/10 border-b border-white/5 flex justify-between px-4"><span className="text-[9px] font-black text-green-400 uppercase">PRODUCCIÓN</span><Eye size={10}/></div>
            <iframe key={`alfa-${refreshKey}`} src="https://via51.org" className="w-full h-full border-none opacity-80 hover:opacity-100 transition-all"/>
          </div>
          <div className="flex-1 bg-slate-900/60 rounded-3xl border border-white/5 overflow-hidden flex flex-col">
            <div className="p-2 bg-blue-500/10 border-b border-white/5 flex justify-between px-4"><span className="text-[9px] font-black text-blue-400 uppercase">LABORATORIO</span><Activity size={10}/></div>
            <iframe key={`root-${refreshKey}`} src="https://root.via51.org" className="w-full h-full border-none opacity-80 hover:opacity-100 transition-all"/>
          </div>
        </aside>
      </div>
    </div>
  );
};
export default App;