/** DNA: V51_ALFA_PROD_REPORT */
import React from 'react';

const MonitorProduccion = () => {
    const data = [
        { name: "BD LEPOMMIER", status: "OK", type: "DB_MACRO" },
        { name: "RECIBO LEPOMMIER", status: "SYNC", type: "DATA_RECORD" }
    ];

    return (
        <div className="p-8 bg-slate-900 border-l-4 border-green-500 text-white rounded-xl shadow-2xl">
            <h2 className="text-2xl font-black text-green-400 mb-4">REPORTE DE SALUD: LE POMMIER</h2>
            <div className="grid grid-cols-1 gap-4">
                {data.map((item) => (
                    <div key={item.name} className="bg-slate-800 p-4 rounded-lg flex justify-between">
                        <div>
                            <p className="font-bold">{item.name}</p>
                            <p className="text-xs text-slate-400">{item.type}</p>
                        </div>
                        <span className="px-3 py-1 bg-green-600 rounded-full text-xs font-bold uppercase">
                            {item.status}
                        </span>
                    </div>
                ))}
            </div>
            <p className="mt-6 text-[10px] text-slate-500 uppercase tracking-widest">
                Sincronizado por Nodo GAMMA | 2026-05-14 10:35
            </p>
        </div>
    );
};

export default MonitorProduccion;
