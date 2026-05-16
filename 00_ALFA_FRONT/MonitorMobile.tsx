/** DNA: V51_ALFA_MOBILE_STABLE_FINAL */
import React from 'react';

const MonitorMobile = () => (
    <div className="min-h-screen bg-black text-white font-sans p-6 flex flex-col justify-center">
        <div className="border-l-4 border-green-500 pl-4">
            <h1 className="text-3xl font-black tracking-tighter text-green-500 uppercase">Soberanía Total</h1>
            <p className="text-xs text-slate-400 mt-1">PROYECTO: LE POMMIER • SINCRONIZADO</p>
        </div>

        <div className="mt-8 space-y-4">
            <div className="bg-slate-900 p-4 rounded-xl shadow-lg border border-slate-800">
                <p className="text-[10px] text-slate-500 uppercase font-bold tracking-widest">Estado del Sistema</p>
                <div className="flex items-center gap-2 mt-1">
                    <div className="h-3 w-3 bg-green-500 rounded-full animate-pulse"></div>
                    <p className="text-lg font-mono">9A-OPERATIONAL</p>
                </div>
            </div>
            
            <div className="bg-slate-900 p-4 rounded-xl shadow-lg border border-slate-800">
                <p className="text-[10px] text-slate-500 uppercase font-bold tracking-widest">Activos en Nube</p>
                <p className="text-xl font-bold mt-1 text-blue-400">2 Fragmentos OK</p>
            </div>
        </div>

        <footer className="mt-auto text-center pt-10">
            <p className="text-[10px] text-slate-600 italic">"Si el átomo es puro, la nación es invulnerable"</p>
        </footer>
    </div>
);

export default MonitorMobile;
