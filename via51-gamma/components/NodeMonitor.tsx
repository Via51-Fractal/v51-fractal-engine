import React from 'react';

export const NodeMonitor = () => {
    const nodes = [
        { id: 'ALFA', url: 'https://alfa.via51.org', color: '#22c55e' },
        { id: 'BETA', url: 'https://beta.via51.org', color: '#eab308' },
        { id: 'HOLDING', url: 'https://holding.via51.org', color: '#06b6d4' },
        { id: 'ROOT', url: 'https://via51.org', color: '#3b82f6' }
    ];

    return (
        <div className="space-y-4 p-4 bg-black/20 rounded-2xl border border-white/5">
            <h3 className="text-[10px] font-bold text-slate-500 uppercase tracking-widest">Canales Activos</h3>
            {nodes.map(node => (
                <a key={node.id} href={node.url} target="_blank" className="flex items-center justify-between p-3 rounded-xl bg-white/5 hover:bg-white/10 transition-all border border-transparent hover:border-white/10">
                    <span className="text-sm font-bold" style={{ color: node.color }}>{node.id}</span>
                    <div className="h-2 w-2 rounded-full animate-pulse" style={{ backgroundColor: node.color }}></div>
                </a>
            ))}
        </div>
    );
};
