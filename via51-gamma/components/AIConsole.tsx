import React, { useState } from 'react';

export const AIConsole = () => {
    const [input, setInput] = useState('');
    const [messages, setMessages] = useState([{ role: 'ai', text: 'Gobernador, sistema Gamma listo. ¿En qué puedo asistir a la nación?' }]);

    return (
        <div className="flex flex-col h-[500px] bg-black/40 rounded-3xl border border-purple-500/20 overflow-hidden">
            <div className="flex-1 p-6 overflow-y-auto space-y-4">
                {messages.map((m, i) => (
                    <div key={i} className={lex \}>
                        <div className={max-w-[80%] p-4 rounded-2xl \}>
                            <p className="text-sm">{m.text}</p>
                        </div>
                    </div>
                ))}
            </div>
            <div className="p-4 bg-white/5 border-t border-white/10 flex gap-2">
                <input 
                    value={input} 
                    onChange={(e) => setInput(e.target.value)}
                    placeholder="Escriba una orden estratégica..." 
                    className="flex-1 bg-black/50 border border-white/10 rounded-xl px-4 py-2 text-sm focus:outline-none focus:border-purple-500"
                />
                <button className="bg-purple-600 hover:bg-purple-500 px-6 py-2 rounded-xl font-bold text-sm transition-colors">ENVIAR</button>
            </div>
        </div>
    );
};
