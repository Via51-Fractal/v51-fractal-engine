import React, { useState, useEffect, useRef } from 'react';
import { Cpu, Send, Terminal, Layout, Database, Shield, Activity, ChevronUp, ChevronDown, Copy, ClipboardCopy, FileText, Check, Clock, XCircle } from 'lucide-react';

const App = () => {
  const [messages, setMessages] = useState([
    { role: 'ai', text: 'Gobernador, sistema Gamma operativo. Monitor de tiempo de proceso activado. ¿Cuál es su orden estratégica?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [timer, setTimer] = useState(0);
  const [copiedIndex, setCopiedIndex] = useState<string | null>(null);
  
  const scrollRef = useRef<HTMLDivElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const timerRef = useRef<any>(null);

  const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY; 

  useEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [messages]);

  // Lógica del Cronómetro
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

  const copyToClipboard = (text: string, id: string) => {
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
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ contents: [{ parts: [{ text: currentInput }] }] })
      });
      const data = await response.json();
      if (data.candidates) {
        setMessages(prev => [...prev, { role: 'ai', text: data.candidates[0].content.parts[0].text }]);
      } else {
        setMessages(prev => [...prev, { role: 'ai', text: `SISTEMA: Error en respuesta. ${data.error?.message || ''}` }]);
      }
    } catch (error) {
      setMessages(prev => [...prev, { role: 'ai', text: 'ERROR DE FASE: Tiempo de espera agotado o fallo de red.' }]);
    } finally {
      setLoading(false);
    }
  };

  const scrollText = (direction: 'up' | 'down') => {
    if (textareaRef.current) {
      const amount = 80;
      textareaRef.current.scrollTop += (direction === 'up' ? -amount : amount);
    }
  };

  return (
    <div className="h-screen bg-[#020617] text-slate-200 font-sans p-2 md:p-4 flex flex-col overflow-hidden">
      <header className="flex justify-between items-center bg-slate-900/50 p-4 rounded-2xl border border-white/5 mb-2">
        <div className="flex items-center gap-3">
          <Cpu className="text-purple-500" size={20} />
          <h1 className="text-xl font-black tracking-tighter text-white uppercase italic">V51 GAMMA PRO</h1>
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
            <span className="text-[9px] font-mono text-green-400 uppercase font-bold tracking-widest">9A-OPERATIONAL</span>
          </div>
        </div>
      </header>

      <div className="flex flex-1 gap-2 overflow-hidden">
        <main className="flex-1 flex flex-col bg-slate-900/40 rounded-3xl border border-white/5 overflow-hidden">
          <div ref={scrollRef} className="flex-1 p-4 overflow-y-auto space-y-6 custom-scrollbar">
            {messages.map((m, i) => (
              <div key={i} className={`flex flex-col ${m.role === 'ai' ? 'items-start' : 'items-end'}`}>
                <div className={`max-w-[90%] p-4 rounded-3xl ${m.role === 'ai' ? 'bg-white/5 text-slate-300 border border-white/10' : 'bg-purple-600 text-white shadow-lg'}`}>
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.text}</p>
                </div>
                <div className="flex gap-2 mt-2 px-2">
                  {m.role === 'user' && (
                    <button onClick={() => copyToClipboard(m.text, `q-${i}`)} className="flex items-center gap-1 text-[9px] text-slate-500 hover:text-purple-400 transition-colors uppercase font-bold">
                      {copiedIndex === `q-${i}` ? <Check size={10}/> : <Copy size={10}/>} Copiar Pregunta
                    </button>
                  )}
                  {m.role === 'ai' && (
                    <button onClick={() => copyToClipboard(m.text, `a-${i}`)} className="flex items-center gap-1 text-[9px] text-slate-500 hover:text-green-400 transition-colors uppercase font-bold">
                      {copiedIndex === `a-${i}` ? <Check size={10}/> : <FileText size={10}/>} Solo Respuesta
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>

          <div className="p-4 bg-black/40 border-t border-white/5">
            <div className="flex gap-2 bg-slate-950 p-2 rounded-2xl border border-white/10 focus-within:border-purple-500/50 transition-all overflow-hidden">
              <textarea 
                ref={textareaRef}
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => { if(e.key==='Enter' && e.ctrlKey) handleExecute() }}
                placeholder="Ctrl + Enter para enviar..."
                className="flex-1 bg-transparent border-none text-xs p-2 focus:outline-none resize-none h-20 scrollbar-hide"
              />
              <div className="w-10 flex flex-col border-l border-white/10 bg-white/5">
                <button onMouseDown={() => scrollText('up')} className="flex-1 flex items-center justify-center hover:bg-white/10 text-slate-500"><ChevronUp size={14}/></button>
                <button onClick={handleExecute} disabled={loading || !input.trim()} className={`flex-1 flex items-center justify-center transition-all ${loading ? 'bg-slate-800' : 'bg-purple-600 hover:bg-purple-500'} text-white`}>
                  {loading ? <XCircle size={14} className="animate-pulse text-red-400" /> : <Send size={14} />}
                </button>
                <button onMouseDown={() => scrollText('down')} className="flex-1 flex items-center justify-center hover:bg-white/10 text-slate-500"><ChevronDown size={14}/></button>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};
export default App;