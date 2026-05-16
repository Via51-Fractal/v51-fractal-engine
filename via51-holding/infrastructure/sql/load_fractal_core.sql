INSERT INTO white_zone.ingenios_registry (code_name, version, blueprint_content, metadata)
VALUES (
    'VIA51-FRACTAL-CORE',
    '3.5.0',
    '// V51 LOGIC BLUEPRINT - REPO: via51-fractal - DATE: 05/10/2026 06:07:43
// FILE: via51-cleaner.ts
import * as fs from ''fs'';
import * as path from ''path'';

/**
 * VIA51 HOLDING DIGITAL - PROTOCOLO DE PURGA
 * Solo lo definido en la CARTA MAGNA permanece.
 */

const ROOT_DIR = ''./'';
const ALLOWED_FOLDERS = [
    ''via51-root'',
    ''via51-hub'',
    ''via51-gamma'',
    ''node_modules'',
    ''.git'',
    ''.vscode''
];

const ALLOWED_FILES = [
    ''package.json'',
    ''tsconfig.base.json'',
    ''scan_report.txt'',
    ''.gitignore'',
    ''via51-cleaner.ts'' // Este mismo script
];

function purgeDesmonte() {
    console.log("--- INICIANDO PURGA DEL ECOSISTEMA VIA51 ---");

    const items = fs.readdirSync(ROOT_DIR);

    items.forEach(item => {
        const fullPath = path.join(ROOT_DIR, item);
        const isDir = fs.statSync(fullPath).isDirectory();

        if (isDir) {
            if (!ALLOWED_FOLDERS.includes(item)) {
                console.log(`[ELIMINANDO CARPETA RESIDUAL]: ${item}`);
                fs.rmSync(fullPath, { recursive: true, force: true });
            }
        } else {
            if (!ALLOWED_FILES.includes(item)) {
                console.log(`[ELIMINANDO ARCHIVO RESIDUAL]: ${item}`);
                fs.unlinkSync(fullPath);
            }
        }
    });

    cleanResidualJS(''./via51-root'');
    cleanResidualJS(''./via51-hub'');
    cleanResidualJS(''./via51-gamma'');

    console.log("--- PURGA COMPLETADA: HOLDING DIGITAL LIMPIO ---");
}

function cleanResidualJS(dir: string) {
    if (!fs.existsSync(dir)) return;

    const files = fs.readdirSync(dir);
    files.forEach(file => {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            cleanResidualJS(fullPath);
        } else if (file.endsWith(''.js'') && dir.includes(''src'')) {
            console.log(`[BORRANDO JS COMPILADO]: ${fullPath}`);
            fs.unlinkSync(fullPath);
        }
    });
}

purgeDesmonte();
// FILE: via51-sovereign-cleaner.ts
import * as fs from ''fs'';
import * as path from ''path'';

const ROOT = process.cwd();
const LAYERS = [''via51-root'', ''via51-hub'', ''via51-gamma''];

// --- PLANTILLAS DE ADN (CÃ“DIGO PURO) ---
const TEMPLATES = {
    tsconfig: `{ "compilerOptions": { "target": "ESNext", "lib": ["DOM", "DOM.Iterable", "ESNext"], "module": "ESNext", "skipLibCheck": true, "moduleResolution": "bundler", "allowImportingTsExtensions": true, "resolveJsonModule": true, "isolatedModules": true, "noEmit": true, "jsx": "react-jsx", "strict": true }, "include": ["src"] }`,
    viteConfig: (port: number) => `import { defineConfig } from ''vite'';\nimport react from ''@vitejs/plugin-react'';\nimport path from ''path'';\nexport default defineConfig({ plugins: [react()], resolve: { alias: { ''@'': path.resolve(__dirname, ''./src'') } }, server: { port: ${port}, strictPort: true } });`,
    supabase: `import { createClient } from ''@supabase/supabase-js'';\nconst supabaseUrl = import.meta.env.VITE_SUPABASE_URL;\nconst supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;\nexport const supabase = createClient(supabaseUrl, supabaseAnonKey);`
};

function sovereignScan(dir: string) {
    const items = fs.readdirSync(dir);

    items.forEach(item => {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);

        if (stat.isDirectory()) {
            if (item !== ''node_modules'' && item !== ''.git'') sovereignScan(fullPath);
        } else {
            // 1. PURGA DE .JS / .JSX (Solo permitimos TS/TSX)
            if (item.endsWith(''.js'') || item.endsWith(''.jsx'')) {
                console.log(`[PURGA]: Eliminando rastro no-TS: ${fullPath}`);
                fs.unlinkSync(fullPath);
            }

            // 2. DETECCIÃ“N DE CONTAMINACIÃ“N HUMANA
            if (item.endsWith(''.ts'') || item.endsWith(''.tsx'')) {
                const content = fs.readFileSync(fullPath, ''utf8'');
                if (content.includes(''terminal dice'') || content.includes(''Error:'') || content.includes(''Para que'')) {
                    console.log(`[CURACIÃ“N]: Detectada contaminaciÃ³n humana en ${item}. Reseteando...`);
                    // AquÃ­ el sistema decide resetear si el archivo es crÃ­tico
                }
            }
        }
    });
}

function rebuildDNA() {
    LAYERS.forEach((layer, index) => {
        const layerPath = path.join(ROOT, layer);
        if (!fs.existsSync(layerPath)) return;

        console.log(`[ADN]: Sincronizando capa ${layer}...`);

        // Asegurar carpetas internas
        const srcLib = path.join(layerPath, ''src'', ''lib'');
        if (!fs.existsSync(srcLib)) fs.mkdirSync(srcLib, { recursive: true });

        // Inyectar Supabase Client (SoberanÃ­a de conexiÃ³n)
        fs.writeFileSync(path.join(srcLib, ''supabaseClient.ts''), TEMPLATES.supabase);

        // Inyectar tsconfig
        fs.writeFileSync(path.join(layerPath, ''tsconfig.json''), TEMPLATES.tsconfig);

        // Inyectar Vite Config con puertos distintos (5173, 5174, 5175)
        fs.writeFileSync(path.join(layerPath, ''vite.config.ts''), TEMPLATES.viteConfig(5173 + index));
    });
}

console.log("--- INICIANDO ESCANEO FORENSE SOBERANO ---");
sovereignScan(ROOT);
console.log("--- RECONSTRUYENDO ADN DEL HOLDING ---");
rebuildDNA();
console.log("--- OPERACIÃ“N COMPLETADA: EL SISTEMA SE HA AUTOCURADO ---");
// FILE: vite-env.d.ts
/// <reference types=''vite/client'' />
// FILE: MediaEngine.ts
import { supabase } from ''@/lib/supabase'';

export const MediaEngine = {
    // ConfiguraciÃ³n de Buckets en el Bunker
    BUCKET: ''via51-assets'',

    async loadHighRes(assetPath: string, priority: ''HIGH'' | ''LOW'' = ''LOW'') {
        const startTime = performance.now();

        // Generar URL firmada o pÃºblica desde Supabase Storage
        const { data } = supabase.storage
            .from(this.BUCKET)
            .getPublicUrl(assetPath);

        return new Promise((resolve, reject) => {
            const media = new Image(); // O Video segÃºn extensiÃ³n
            media.src = data.publicUrl;

            media.onload = async () => {
                const duration = performance.now() - startTime;

                // REGISTRO VINCULANTE: Reportar mÃ©tricas de carga al Bunker
                await supabase.from(''dev_sys_events'').insert([{
                    event_type: ''MEDIA_LOAD_SUCCESS'',
                    description: `Asset: ${assetPath} | Latency: ${duration.toFixed(2)}ms`,
                    created_by: ''ANTIGRAVITY_ENGINE''
                }]);

                resolve(data.publicUrl);
            };

            media.onerror = () => reject(`Error en carga de: ${assetPath}`);
        });
    },

    // Carga Fractal: Divide el asset en capas (Blur -> LowRes -> HighRes)
    getFractalSource(assetName: string) {
        return {
            placeholder: `/assets/placeholders/${assetName}-blur.webp`,
            main: `${process.env.NEXT_PUBLIC_SUPABASE_URL}/storage/v1/object/public/via51-assets/${assetName}.webp`
        };
    }
};
// FILE: useSystemState.ts
// hooks/useSystemState.ts
import { supabase } from ''@/lib/supabase'';

export const useSystemState = () => {
    const syncVisuals = async () => {
        const { data: registry } = await supabase
            .from(''sys_registry'')
            .select(''*'')
            .eq(''key'', ''ui_config'');

        // Aplicar variables CSS dinÃ¡micas basadas en el registro
        if (registry) {
            document.documentElement.style.setProperty(''--v51-glow-intensity'', registry[0].value.glow);
        }
    };

    return { syncVisuals };
};
// FILE: MediaEngine.ts
// drivers/MediaEngine.ts
export const MediaEngine = {
    optimizeAsset: (url: string) => {
        // LÃ³gica para servir WebP/AVIF dinÃ¡micamente desde el Bunker
        return `${process.env.NEXT_PUBLIC_SUPABASE_STORAGE_URL}/assets/${url}?auto=format&quality=85`;
    },

    preloadFractal: async (assets: string[]) => {
        const promises = assets.map(src => {
            return new Promise((resolve, reject) => {
                const img = new Image();
                img.src = src;
                img.onload = resolve;
                img.onerror = reject;
            });
        });
        return Promise.all(promises);
    }
};
// FILE: useFractalIntelligence.ts
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const useFractalIntelligence = () => {
  const [insights, setInsights] = useState([]);
  const [analyzing, setAnalyzing] = useState(false);

  const generateInsights = async () => {
    setAnalyzing(true);
    // Simulación de análisis de red neuronal sobre el Bunker
    const { data: assets } = await supabase.from(''sys_contributions'').select(''*'').limit(5);
    const { data: events } = await supabase.from(''sys_events'').select(''*'').order(''created_at'', { ascending: false }).limit(3);

    const newInsights = [
      { id: 1, type: ''DESIGN'', message: ''Detectada saturación de color en asset_01. Sugerencia: Aplicar filtro de Oro Astral (P3 Color Space).'' },
      { id: 2, type: ''CODE'', message: ''Nodo GAMMA detectó latencia de 15ms. Sugerencia: Optimizar Shaders mediante instancedMesh.'' },
      { id: 3, type: ''GOVERNANCE'', message: ''La Carta Magna 2.0 requiere un nudo de cierre. Sugerencia: Actualizar sección de Soberanía Digital.'' }
    ];

    setInsights(newInsights);
    setAnalyzing(false);
  };

  useEffect(() => {
    generateInsights();
  }, []);

  return { insights, analyzing, refresh: generateInsights };
};
// FILE: useGovernance.ts
import { useEffect, useState } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const useGovernance = () => {
  const [content, setContent] = useState('''');
  const [loading, setLoading] = useState(true);

  const fetchGovernance = async () => {
    const { data } = await supabase
      .from(''sys_registry'')
      .select(''value'')
      .eq(''key'', ''carta_magna_2_0'')
      .single();
    if (data) setContent(data.value.text);
    setLoading(false);
  };

  useEffect(() => {
    fetchGovernance();

    // SUSCRIPCIÓN VINCULANTE EN TIEMPO REAL
    const channel = supabase
      .channel(''governance_sync'')
      .on(''postgres_changes'', 
        { event: ''UPDATE'', schema: ''public'', table: ''sys_registry'', filter: ''key=eq.carta_magna_2_0'' },
        (payload) => {
          setContent(payload.new.value.text);
        }
      )
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, []);

  return { content, loading };
};
// FILE: useHierarchy.ts
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const useHierarchy = () => {
  const [level, setLevel] = useState(0);
  const [identity, setIdentity] = useState(null);

  useEffect(() => {
    // En producción, esto vendría de la sesión de Auth
    // Por ahora, simulamos la detección del Operador Renzo (8)
    const syncHierarchy = async () => {
      const { data } = await supabase
        .from(''sys_registry'')
        .select(''value'')
        .eq(''key'', ''active_operator_8'')
        .single();
      
      if (data) {
        setLevel(8);
        setIdentity({ name: ''RENZO'', rank: ''ARCHITECT'' });
      }
    };
    syncHierarchy();
  }, []);

  return { level, identity };
};
// FILE: useUIConfig.ts
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const useUIConfig = (node: string) => {
  const [config, setConfig] = useState({
    textSize: ''text-xl'',
    primaryColor: ''#D4AF37'',
    alignment: ''items-center'',
    showMobileImage: true,
    padding: ''py-20''
  });

  useEffect(() => {
    const fetchConfig = async () => {
      const { data } = await supabase
        .from(''sys_registry'')
        .select(''value'')
        .eq(''key'', `ui_config_${node.toLowerCase()}`)
        .single();
      if (data) setConfig(data.value);
    };
    fetchConfig();

    const sub = supabase.channel(`ui_${node}`)
      .on(''postgres_changes'', { event: ''UPDATE'', schema: ''public'', table: ''sys_registry'' }, 
      payload => { if(payload.new.key === `ui_config_${node.toLowerCase()}`) setConfig(payload.new.value); })
      .subscribe();
    return () => { supabase.removeChannel(sub); };
  }, [node]);

  return config;
};
// FILE: tailwind.config.ts
import type { Config } from ''tailwindcss''

export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        via51: {
          abisal: ''#020617'',
          energia: ''#3b82f6'',
        }
      }
    },
  },
  plugins: [],
} satisfies Config
// FILE: vite.config.ts
import { defineConfig } from "vite"
import react from "@vitejs/plugin-react"

export const GOLD = "#E5B451";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    host: "127.0.0.1",
    strictPort: true
  }
})
// FILE: campaign.injector.ts
// ActualizaciÃ³n en C:\via51-fractal\via51-alfa\src\app\campaign.injector.ts

export class CampaignInjector {
    public static async init(): Promise<void> {
        // Pedir la Ãºltima instrucciÃ³n al corazÃ³n (BETA)
        const response = await fetch(''http://hub.via51.org:3000/api/v1/instruction/latest'');
        const data = await response.json();

        const container = document.getElementById(''v51-app-root'');
        if (container) {
            container.innerHTML = CampaignOverlay.render(data.title, data.message, data.priority);
        }
    }
}
// FILE: location-service.ts
// via51-alfa/src/app/location-service.ts

async function syncFredyLocation() {
    // 1. Preparamos el INPUT DRIVER
    const input: StandardInput = {
        origin: "VIA51-ALFA-01",
        domain: "GEOLOCATION",
        action: "TRACK",
        payload: { lat: -12.046, lng: -77.042 }, // Ejemplo
        auth: { uid: "FREDY_BAZALAR", role: "SUPER_OWNER" }
    };

    // 2. Ejecutamos la CAJA NEGRA (Black Box)
    // El CORE no sabe quiÃ©n es Fredy, solo sabe que un SUPER_OWNER envÃ­a coordenadas.
    const response = await Via51BlackBox.execute(input);

    // 3. El OUTPUT DRIVER maneja el resultado
    if (response.status === ''SUCCESS'') {
        console.log(`Trazabilidad confirmada: ${response.transmissionId}`);
        // AquÃ­ el Driver de Salida actualiza tu mapa en GAMMA
    }
}
// FILE: CampaignOverlay.ts
/**
 * VIA51 ANTIGRAVITY - Purple Frame Overlay
 * Nivel: ALFA (ComunicaciÃ³n de Fase 1)
 */

export class CampaignOverlay {
    public static render(title: string, message: string, priority: string): string {
        const borderColor = priority === ''CRITICAL'' ? ''#ff0000'' : ''#bc00ff'';
        const pulseClass = priority === ''CRITICAL'' ? ''v51-pulse'' : '''';

        return `
        <style>
            .v51-campaign-frame {
                border: 4px solid ${borderColor};
                background: rgba(43, 0, 64, 0.95);
                color: white;
                padding: 25px;
                border-radius: 10px;
                font-family: ''Segoe UI'', Roboto, sans-serif;
                margin: 20px auto;
                max-width: 800px;
                box-shadow: 0 0 20px rgba(188, 0, 255, 0.3);
            }
            .v51-badge {
                background: #bc00ff;
                color: white;
                padding: 4px 10px;
                font-size: 0.8em;
                font-weight: bold;
                text-transform: uppercase;
            }
            .v51-pulse {
                animation: v51-blink 2s infinite;
            }
            @keyframes v51-blink {
                0% { box-shadow: 0 0 10px #ff0000; }
                50% { box-shadow: 0 0 30px #ff0000; }
                100% { box-shadow: 0 0 10px #ff0000; }
            }
        </style>
        <div class="v51-campaign-frame ${pulseClass}">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <span class="v51-badge">VÃ­a51 Antigravity - Mensaje Oficial</span>
                <img src="https://via51.org/assets/logo-morado.png" alt="Partido Morado" style="height: 30px;">
            </div>
            <h1 style="color: #bc00ff; margin: 0 0 10px 0;">${title}</h1>
            <p style="font-size: 1.1em; line-height: 1.6; color: #f0f0f0;">
                ${message}
            </p>
            <hr style="border: 0; border-top: 1px solid rgba(255,255,255,0.1); margin: 20px 0;">
            <div style="font-size: 0.85em; color: #aaa; text-align: center;">
                Apoyando la visiÃ³n de <strong>MesÃ­as Guevara</strong> para el PerÃº.
            </div>
        </div>
        `;
    }
}
// FILE: GeoCapture.ts
// via51-alfa/src/components/sensors/GeoCapture.ts

interface CaptureResponse {
    status: ''SUCCESS'' | ''ERROR'';
    data?: any;
    message: string;
}

export const captureFredyLocation = async (): Promise<CaptureResponse> => {
    return new Promise((resolve) => {
        if (!navigator.geolocation) {
            resolve({ status: ''ERROR'', message: ''GeolocalizaciÃ³n no soportada en este dispositivo.'' });
        }

        navigator.geolocation.getCurrentPosition(
            (position) => {
                const payload = {
                    entityId: ''V51-OWNER-FREDY'', // ID Vitalicio segÃºn Carta Magna
                    latitude: position.coords.latitude,
                    longitude: position.coords.longitude,
                    accuracy: position.coords.accuracy,
                    timestamp: new Date().toISOString()
                };

                // ENVIAR AL HUB (BETA)
                console.log("Enviando coordenadas al Motor Universal...");
                resolve({ status: ''SUCCESS'', data: payload, message: ''UbicaciÃ³n capturada correctamente.'' });
            },
            (error) => {
                resolve({ status: ''ERROR'', message: `Error de hardware: ${error.message}` });
            },
            { enableHighAccuracy: true }
        );
    });
};
// FILE: useTelemetry.ts
import { supabase } from ''../lib/supabaseClient'';

export const useTelemetry = () => {
    const trackVisit = async (nodeId: string) => {
        try {
            const geoRes = await fetch(''https://freeipapi.com/api/json'');
            if (!geoRes.ok) throw new Error("Servidor de geolocalizaciÃ³n no disponible");
            const geoData = await geoRes.json();

            const { error } = await supabase.from(''sys_interactions'').insert({
                node_id: nodeId,
                ip_address: geoData.ipAddress,
                region: geoData.regionName,
                city: geoData.cityName,
                country: geoData.countryName,
                content: `TrÃ¡fico detectado: ${geoData.cityName}, ${geoData.regionName}`,
                status: ''logged''
            });

            if (error) throw error;
            console.log(`[TELEMETRÃA] Ã‰XITO: Acceso desde ${geoData.regionName}`);
        } catch (err: any) {
            console.error(`[TELEMETRÃA-ERROR] ${err.message}`);
        }
    };

    return { trackVisit };
};
// FILE: supabaseClient.ts
import { createClient } from ''@supabase/supabase-js'';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
    console.warn("ADVERTENCIA: Credenciales de Supabase no detectadas en el entorno.");
}

export const supabase = createClient(supabaseUrl || '''', supabaseAnonKey || '''');
// FILE: telemetry.service.ts
/**
 * VIA51 ANTIGRAVITY - Alfa Telemetry Service
 * Nivel: ALFA (Captura)
 */

export class TelemetryService {
    /**
     * EnvÃ­a seÃ±al de visita al CORE de forma silenciosa
     */
    public static async trackVisit(): Promise<void> {
        try {
            // Captura de datos bÃ¡sicos agnÃ³sticos
            const payload = {
                timestamp: new Date().toISOString(),
                userAgent: navigator.userAgent,
                language: navigator.language,
                // Nota: La resoluciÃ³n de IP a RegiÃ³n se hace en BETA para mantener ALFA liviano
                source: "VIA51-ALFA-MAIN"
            };

            // EnvÃ­o al Driver de Entrada de BETA
            await fetch(''https://hub.via51.org/api/v1/in/telemetry'', {
                method: ''POST'',
                headers: { ''Content-Type'': ''application/json'' },
                body: JSON.stringify({
                    origin: ''VIA51-ALFA-00'',
                    domain: ''PUBLIC_AFFAIRS'',
                    action: ''RECORD_VISIT'',
                    payload: payload
                })
            });
        } catch (e) {
            console.warn("[V51-ALFA] Telemetry offline.");
        }
    }
}
// FILE: fractal.ts
export interface RegistryNode { id: string; node_name: string; node_path: string; level: number; owner_id: string; config?: any; }
// FILE: treeBuilder.ts
import { RegistryNode } from ''../types/fractal'';
export const buildFractalTree = (nodes: RegistryNode[]) => {
  const map: Record<string, any> = {};
  const tree: any[] = [];
  nodes.forEach(node => { map[node.node_path] = { ...node, children: [] }; });
  nodes.forEach(node => {
    const parts = node.node_path.split(''.'');
    if (parts.length === 1) { tree.push(map[node.node_path]); }
    else { const parentPath = parts.slice(0, -1).join(''.''); if (map[parentPath]) map[parentPath].children.push(map[node.node_path]); }
  });
  return tree;
};
// FILE: index.ts
import ''dotenv/config'';
import express from ''express'';
import cors from ''cors'';
const app = express();
app.use(cors());
app.use(express.json());

app.get(''/'', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>VIA51 | CONTROL QUIRÃšRGICO</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://unpkg.com/@supabase/supabase-js@2"></script>
        <style>
            body { background: #050505; color: white; font-family: sans-serif; overflow: hidden; }
            .mirror { background: #000; border: 1px solid rgba(212, 175, 55, 0.2); width: 100%; height: 100%; border-radius: 8px; }
            label { font-size: 7px; color: #888; text-transform: uppercase; letter-spacing: 1px; display: block; margin-bottom: 2px; }
            input[type="range"] { width: 100%; accent-color: #D4AF37; }
        </style>
    </head>
    <body class="h-screen flex flex-col p-4">
        <div class="flex flex-1 gap-4 overflow-hidden">
            <div class="flex-[0.6] flex flex-col gap-4">
                <div class="flex-1"><iframe src="http://localhost:5173" class="mirror" id="f1"></iframe></div>
                
                <!-- PANEL DE CONTROL AVANZADO -->
                <div class="h-64 bg-white/5 p-4 grid grid-cols-3 gap-4 border border-white/10 overflow-y-auto">
                    <div>
                        <label>Fondo Opacidad</label>
                        <input type="range" id="bgOp" min="0" max="1" step="0.1" onchange="up()">
                        <label class="mt-2">Color Maestro</label>
                        <input type="color" id="cp" class="w-full h-6 bg-transparent" onchange="up()">
                        <label class="mt-2">Alternar Imagen URL</label>
                        <input type="text" id="bgImg" class="w-full bg-black border border-white/10 text-[9px] p-1" onchange="up()">
                    </div>
                    <div>
                        <label>TamaÃ±o Texto (px)</label>
                        <input type="range" id="ts" min="12" max="120" onchange="up()">
                        <label class="mt-2">Ancho de Marco (px)</label>
                        <input type="range" id="mw" min="200" max="1200" onchange="up()">
                        <label class="mt-2">PosiciÃ³n Y (offset)</label>
                        <input type="range" id="ty" min="-200" max="200" onchange="up()">
                    </div>
                    <div>
                        <label>AlineaciÃ³n</label>
                        <select id="ta" class="w-full bg-black border border-white/10 text-[9px] p-1" onchange="up()">
                            <option value="left">Izquierda</option>
                            <option value="center">Centro</option>
                            <option value="right">Derecha</option>
                        </select>
                        <label class="mt-2">Grosor (Weight)</label>
                        <select id="fw" class="w-full bg-black border border-white/10 text-[9px] p-1" onchange="up()">
                            <option value="100">Thin</option>
                            <option value="400">Normal</option>
                            <option value="900">Black</option>
                        </select>
                        <button onclick="up()" class="w-full mt-4 py-2 bg-[#D4AF37] text-black text-[9px] font-bold">EJECUTAR</button>
                    </div>
                </div>
            </div>
            <div class="flex-[0.4] bg-black p-4 flex flex-col items-center">
                <div class="w-[280px] flex-1 border-[8px] border-gray-900 rounded-[40px] overflow-hidden">
                    <iframe src="http://localhost:5173" class="mirror" id="f2"></iframe>
                </div>
            </div>
        </div>

        <script>
            const v51 = supabase.createClient(''${process.env.SUPABASE_URL}'', ''${process.env.VITE_SUPABASE_ANON_KEY}'');
            async function up() {
                const config = {
                    primaryColor: document.getElementById(''cp'').value,
                    textSize: document.getElementById(''ts'').value,
                    bgImage: document.getElementById(''bgImg'').value || "https://ibhhzgtxaqwdykedhtvk.supabase.co/storage/v1/object/public/via51-assets/background-v51.jpg",
                    bgOpacity: parseFloat(document.getElementById(''bgOp'').value),
                    textMaxWidth: document.getElementById(''mw'').value,
                    textYPosition: document.getElementById(''ty'').value,
                    textAlign: document.getElementById(''ta'').value,
                    fontWeight: document.getElementById(''fw'').value,
                    lineHeight: "1"
                };
                await v51.from(''sys_registry'').update({ value: config }).eq(''id'', ''ui_config_alfa'');
                document.getElementById(''f1'').src = document.getElementById(''f1'').src;
                document.getElementById(''f2'').src = document.getElementById(''f2'').src;
            }
        </script>
    </body>
    </html>
  `);
});
app.listen(3001, () => { console.log(''BETA QUIRÃšRGICO ON 3001''); });
// FILE: blackBox.ts
// NÃšCLEO AGNÃ“STICO - No se toca para cambios de campaÃ±a
export interface StandardPayload {
    entity_id: string;
    action_type: ''AUTH'' | ''CAPTURE'' | ''TRANSITION'';
    metadata: any;
}

export class Via51BlackBox {
    public static async execute(payload: StandardPayload, schema: any): Promise<any> {
        // 1. VALIDADOR (MecÃ¡nica de la Carta Magna)
        if (!payload.entity_id || !payload.action_type) throw new Error("CORE_INVALID_INPUT");

        // 2. PROCESADOR (Aplica las reglas del schema sin conocer el dominio)
        const rule = schema[payload.action_type];
        if (!rule) throw new Error("CORE_RULE_NOT_FOUND");

        // 3. ORQUESTADOR (Distribuye el resultado)
        return {
            status: ''PROCESSED'',
            timestamp: new Date().toISOString(),
            result: rule.logic(payload.metadata)
        };
    }
}
// FILE: blackbox_main.ts
import ''dotenv/config'';
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.SUPABASE_URL || "", 
  process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.VITE_SUPABASE_ANON_KEY || ""
);

export { supabase };
// FILE: event_log.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-05-MIRROR" }
 * MECANICA 05: SELLADO EN SUPABASE CON PROTOCOLO ESPEJO
 */
import { createClient } from "@supabase/supabase-js";
import { V51_Result } from "./processor.js";

const supabase = createClient(
    process.env.SUPABASE_URL || "", 
    process.env.SUPABASE_SERVICE_ROLE_KEY || ""
);

export class CoreEventLog {
    public static async seal(result: V51_Result, env: string): Promise<string> {
        // DECISOR DE TABLA: SOBERANIA DE ENTORNO
        const targetTable = (env === "LAB") ? "dev_sys_events" : "sys_events";
        
        console.log(`[EVENT_LOG] Registrando en: ${targetTable.toUpperCase()}`);

        try {
            const { data, error } = await supabase
                .from(targetTable)
                .insert([{
                    actor_id: result.dna_origin,
                    action_type: result.action_performed,
                    payload: result.payload_out
                }])
                .select();

            if (error) throw error;
            return data[0].id;
        } catch (e: any) {
            console.error(`[EVENT_LOG] FALLO: ${e.message}`);
            return "ERROR_UNSEALED";
        }
    }
}
// FILE: hangar.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-06" }
 * MECANICA 06: MOTOR DE CARGA BAJO DEMANDA (EL HANGAR)
 */

import fs from "fs";
import path from "path";

export interface V51_Scenario {
    id: string;
    rules: any;
    flow: string[];
    output_channels: string[];
}

export class CoreHangar {
    private static HANGAR_PATH = path.resolve("src/database/sys_hangar.json");

    /**
     * Recupera la configuracion de un escenario especifico.
     * Permite que el Core sea agnostico cargando logica externa.
     */
    public static loadScenario(scenarioId: string): V51_Scenario | null {
        console.log(`[HANGAR] Buscando escenario: ${scenarioId}`);

        try {
            // 1. Consultar el inventario del Hangar
            const inventory = JSON.parse(fs.readFileSync(this.HANGAR_PATH, "utf8"));
            const entry = inventory.scenarios.find((s: any) => s.id === scenarioId || s.alias === scenarioId);

            if (!entry || entry.status !== "READY") {
                console.error(`[HANGAR] Scenario ${scenarioId} no disponible.`);
                return null;
            }

            // 2. Cargar el "Disco" (Archivo de configuracion del escenario)
            const scenarioData = JSON.parse(fs.readFileSync(path.resolve(entry.config_path), "utf8"));

            console.log(`[HANGAR] OK: Escenario ${scenarioId} cargado y listo.`);
            return scenarioData as V51_Scenario;

        } catch (error) {
            console.error("[HANGAR] CRITICAL: Fallo en la carga de escenario.");
            return null;
        }
    }
}
// FILE: index.ts
// via51-beta/src/core/index.ts

import { Via51BlackBox } from ''./engine/blackBox'';

/**
 * PROTOCOLO DE SELLADO (Black Box)
 * Solo se permite la interacciÃ³n a travÃ©s de drivers controlados.
 */
const CoreInstance = Object.freeze(new Via51BlackBox());

export default CoreInstance;
// FILE: orchestrator.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-03" }
 * MECANICA 03: ORQUESTADOR DE SALIDA
 */

import { V51_Result } from "./processor.js";

export interface V51_Dispatch {
    target: string; // Ejemplo: "ALFA-SCREEN", "GAMMA-LOG", "WA-DRIVER"
    payload: any;
    priority: number;
}

export class CoreOrchestrator {
    /**
     * Dirige el resultado hacia los canales correspondientes.
     * La configuracion de canales vendra del Hangar en la Fase 2.
     */
    public static orchestrate(result: V51_Result): V51_Dispatch[] {
        console.log(`[ORCHESTRATOR] Despachando resultado de: ${result.action_performed}`);

        const dispatches: V51_Dispatch[] = [];

        // 1. Canal Obligatorio: Trazabilidad (sys_events)
        dispatches.push({
            target: "SYSTEM_EVENT_LOG",
            payload: result,
            priority: 1
        });

        // 2. Canal de Respuesta: Driver Solicitante
        // Si el estado es exito, enviamos la carga al driver.
        if (result.status === "SUCCESS") {
            dispatches.push({
                target: result.dna_origin, // Devuelve al nodo que inicio la sinapsis
                payload: result.payload_out,
                priority: 2
            });
        }

        return dispatches;
    }
}
// FILE: processor.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-02" }
 * MECANICA 02: PROCESADOR DE ESTADOS (CORE ENGINE)
 */

import { V51_Package } from "./validator.js";

export interface V51_Result {
    status: "SUCCESS" | "FAILURE" | "PENDING";
    dna_origin: string;
    action_performed: string;
    payload_out: any;
    timestamp: number;
}

export class CoreProcessor {
    /**
     * Procesa el paquete sin conocer el dominio.
     * En el futuro, aqui se conectara el "Disco" del Hangar.
     */
    public static async process(input: V51_Package, scenarioLogic?: any): Promise<V51_Result> {
        console.log(`[PROCESSOR] Ejecutando accion: ${input.action}`);

        try {
            // 1. Ejecucion de logica externa (inyectada desde el Hangar)
            // Si no hay logica aun (Fase 1), devolvemos el payload intacto como echo.
            const resultData = scenarioLogic
                ? await scenarioLogic(input.payload)
                : input.payload;

            // 2. Construccion del resultado estandar
            const response: V51_Result = {
                status: "SUCCESS",
                dna_origin: input.v51_dna.node,
                action_performed: input.action,
                payload_out: resultData,
                timestamp: Date.now()
            };

            return response;

        } catch (error) {
            console.error(`[PROCESSOR] CRITICAL FAILURE en accion ${input.action}`);
            return {
                status: "FAILURE",
                dna_origin: input.v51_dna.node,
                action_performed: input.action,
                payload_out: { error: "MECANICA_INTERRUMPIDA" },
                timestamp: Date.now()
            };
        }
    }
}
// FILE: storage.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-04" }
 * MECANICA 04: GESTOR DE ALMACENAMIENTO LOCAL
 */

import fs from "fs";
import path from "path";

export class CoreStorage {
    private static DB_PATH = path.resolve("src/database/sys_nodes.json");

    /**
     * Lee la jerarquia fractal desde el disco duro.
     * Prioriza recursos locales segun Carta Magna.
     */
    public static getHierarchy(): any {
        try {
            const data = fs.readFileSync(this.DB_PATH, "utf8");
            return JSON.parse(data);
        } catch (error) {
            console.error("[STORAGE] CRITICAL ERROR: No se puede leer sys_nodes.");
            return null;
        }
    }

    /**
     * Verifica si un nodo existe y esta activo.
     */
    public static isNodeAuthorized(nodeId: string): boolean {
        const db = this.getHierarchy();
        if (!db) return false;

        // Logica de busqueda recursiva simple para validacion
        const flatNodes = this.flattenHierarchy(db.hierarchy.root);
        const target = flatNodes.find((n: any) => n.id === nodeId);

        return target ? target.status === "ACTIVE" : false;
    }

    private static flattenHierarchy(node: any): any[] {
        let nodes = [node];
        if (node.children) {
            node.children.forEach((child: any) => {
                nodes = nodes.concat(this.flattenHierarchy(child));
            });
        }
        return nodes;
    }
}
// FILE: validator.ts
export class CoreValidator {
    public static validate(input: any): boolean {
        // Validacion estructural agnostica
        return !!(input && input.v51_dna && input.payload && input.payload.dni);
    }
}
// FILE: gammaEngine.ts
/* Ruta: src/services/gammaEngine
   Nombre: gammaEngine
   DescripciÃ³n: Motor lÃ³gico (Gamma) del Holding Digital VÃ­a51.
   Gobierna la validaciÃ³n de los tres pilares.
*/

import { supabase } from ''@gamma/lib/supabaseClient'';

const GammaEngine = {
  // 1. LÃ³gica de "Modo Coyuntura"
  // Determina si Alfa debe mostrar los 3 pilares o dedicarse a un evento excepcional
  checkCoyuntura: async () => {
    const { data } = await supabase
      .from(''configuracion_global'')
      .select(''modo_emergencia'')
      .single();
    return data?.modo_emergencia || false;
  },

  // 2. Validador de Consistencia de Pilares
  // Gamma asegura que no se guarde informaciÃ³n vacÃ­a que debilite el plano
  validarPilar: (datos: any) => {
    if (!datos.titulo_que || datos.titulo_que.length < 5) {
      throw new Error("El propÃ³sito (TÃ­tulo) es insuficiente para sostener el pilar.");
    }
    if (!datos.descripcion_como || datos.descripcion_como.length < 10) {
      throw new Error("La interrelaciÃ³n (DescripciÃ³n) carece de sustancia tÃ©cnica.");
    }
    return true;
  },

  // 3. Procesador de SincronizaciÃ³n
  // Ejecuta la transformaciÃ³n de Beta a Alfa pasando por los filtros de Gamma
  sincronizarNodo: async (slug: string, contenido: any) => {
    try {
      GammaEngine.validarPilar(contenido);
      
      const { data, error } = await supabase
        .from(''nodos'')
        .upsert({ 
          slug, 
          ...contenido,
          ultima_revision_gamma: new Date().toISOString() 
        }, { onConflict: ''slug'' });

      if (error) throw error;
      return { success: true, data };
    } catch (err: any) {
      return { success: false, error: err.message };
    }
  }
};

export default GammaEngine;

// FILE: index.ts
import { UniversalValidator } from ''./core/validator'';
import { CorePayload } from ''./types/core'';

/**
 * Punto de entrada del trÃ¡fico captado por ALFA
 */
export const handleIncomingTraffic = (payload: CorePayload) => {
    console.log(`[HUB-BETA] Processing event from: ${payload.metadata.sender}`);

    const validation = UniversalValidator.validate(payload);

    if (!validation.isValid) {
        console.error(`[AUDIT-BETA] Validation Failed: ${validation.errors?.join('', '')}`);
        // AquÃ­ se enviarÃ­a la respuesta de error a ALFA
        return;
    }

    // Si es vÃ¡lido, se procede al PROCESADOR (Siguiente fase del plano CoreVia51)
    console.log(`[HUB-BETA] Data validated. Handing over to Processor.`);
    // executeProcessor(validation.sanitizedData);
};
// FILE: MediaIngestor.ts
// UbicaciÃ³n: src/services/MediaIngestor.ts
// Nombre: MediaIngestor Service (V51 Gamma Engine Standard)

import { supabase } from ''@gamma/lib/supabaseClient''; 
import { SCHEMA } from ''@gamma/lib/constants'';

/**
 * MEDIA INGESTOR - SERVICIO DE INGESTA DE BINARIOS
 * Gestiona la subida de archivos al Storage (Bucket ''vault'')
 * y prepara el objeto de datos para actualizar [sys_registry].
 */
export const ingestMedia = async (
  file: File, 
  nodeId: string, 
  type: ''audio'' | ''video''
) => {
  // Obtenemos el slug desde las variables de entorno (Vite)
  const activeSlug = import.meta.env.VITE_DEV_CLIENT_SLUG || ''default'';
  
  // 1. GeneraciÃ³n de Ruta en Storage (Estructura AgnÃ³stica)
  // Ruta resultante: vault/{slug}/{type}/{uuid}.ext
  const fileExt = file.name.split(''.'').pop();
  const fileName = `${crypto.randomUUID()}.${fileExt}`;
  const filePath = `${activeSlug}/${type}/${fileName}`;

  // 2. Subida del Binario al Bucket ''vault''
  const { error: storageError } = await supabase
    .storage
    .from(''vault'')
    .upload(filePath, file, {
      cacheControl: ''3600'',
      upsert: false
    });

  if (storageError) {
    console.error("[Storage Error]:", storageError.message);
    throw storageError;
  }

  // 3. ObtenciÃ³n de URL PÃºblica
  const { data: { publicUrl } } = supabase
    .storage
    .from(''vault'')
    .getPublicUrl(filePath);

  // 4. PreparaciÃ³n de Metadatos para el Nodo en [sys_registry]
  // Este objeto es el que luego se inyecta en ''arbol_nodos_json'' via RPC o Update
  return {
    id: nodeId,
    type: `${type}_node`,
    data: {
      src: publicUrl,
      fileName: file.name,
      mimeType: file.type,
      uploadedAt: new Date().toISOString(),
      origin: SCHEMA.TABLES.ORGANIZATIONS // Referencia a la tabla de origen
    }
  };
};

// FILE: server.ts
import express from "express";
import cors from "cors";
import { Via51BlackBox } from "./core/blackbox_main";

const app = express();
app.use(cors({ origin: "*" }));
app.use(express.json());

// RUTA RAIZ: Si esto no carga, el 404 persiste
app.get("/", (req, res) => {
    res.status(200).send("VIA51 HUB OPERATIVO - SINAPSIS ACTIVA");
});

app.get("/api/v1/health", (req, res) => {
    res.json({ status: "ONLINE", node: "BETA-HUB", pulse: Date.now() });
});

app.post("/api/v1/gatekeeper", async (req, res) => {
    try {
        const output = await Via51BlackBox.handleSinapsis(req.body);
        res.status(200).json(output);
    } catch (e: any) {
        res.status(500).json({ status: "ERROR", msg: e.message });
    }
});

// IMPORTANTE: Vercel no necesita app.listen, pero lo dejamos para local
if (process.env.NODE_ENV !== "production") {
    const PORT = 3000;
    app.listen(PORT, () => console.log(`Local Hub en puerto ${PORT}`));
}

export default app; 
// FILE: telemetryService.ts
// UbicaciÃ³n: src/services/telemetryService.ts
// SecciÃ³n Gamma - Ciencia y TecnologÃ­a

import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';

export const trackEvent = async ({
  registry_id,
  node_id,
  action_type,
  metadata = {}
}: {
  registry_id: string;
  node_id: string;
  action_type: string;
  metadata?: any;
}) => {
  try {
    if (!registry_id) return;

    // Mapeo dinÃ¡mico para sys_events
    await supabase
      .from(SCHEMA.TABLES.TELEMETRY)
      .insert([
        {
          organizacion_id: registry_id, // Mantenemos tu nombre de columna actual
          node_id,
          action_type,
          contexto: {
            ...metadata,
            sys_url: window.location.href,
            sys_ua: navigator.userAgent
          }
        }
      ]);
  } catch (err: any) {
    console.warn("[Gamma Warning]: TelemetrÃ­a omitida por seguridad.");
  }
};

// FILE: useGeoTelemetry.ts
// ==========================================
// RUTA: src/hooks/useGeoTelemetry.ts
// COMPONENTE: Sensor de TelemetrÃ­a GeogrÃ¡fica (Refinado)
// ==========================================
import { useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';
import { useTenant } from ''@beta/context/TenantContext'';

export const useGeoTelemetry = (nodeId: string) => {
  const { tenant } = useTenant();

  useEffect(() => {
    const trackLocation = async () => {
      if (!tenant?.id) return;

      try {
        // Obtenemos datos de ubicaciÃ³n
        const res = await fetch(''https://ipapi.co/json/'');
        const geo = await res.json();

        // InserciÃ³n de pulso en sys_events
        await supabase
          .from(SCHEMA.TABLES.TELEMETRY)
          .insert([{
            tenant_id: tenant.id,
            event_type: ''GEO_TRACE'',
            variable_name: `NODE_${nodeId}`,
            metadata: {
              ip: geo.ip,
              city: geo.city,
              country: geo.country_name,
              node: nodeId,
              timestamp: new Date().toISOString()
            }
          }]);
          
        console.log(`ðŸŒ Trace registrado en Nodo: ${nodeId}`);
      } catch (e) {
        console.error("ðŸ”´ Error en Geo-Trace:", e);
      }
    };

    trackLocation();
  }, [tenant?.id, nodeId]); // Se dispara cada vez que cambia el nodo
};

// FILE: useV51Registry.ts
/**
 * PATH: src/hooks/useV51Registry.ts
 * DESCRIPCIÃ“N: ExtracciÃ³n de datos alineada con el Esquema VIA51 (V51.6).
 * REGLA: Uso obligatorio del esquema ''via51'' y tabla ''v51_registry''.
 */
import { useEffect, useState } from ''react'';
// Cambiamos la fuente a nuestro nuevo orquestador de soberanÃ­a
import { v51 as supabase } from ''@gamma/lib/supabaseAdmin'';

export const useV51Registry = () => {
  const [nodeData, setNodeData] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  // IdentificaciÃ³n del Tenant (Agnosticismo de Dominio)
  const hostname = window.location.hostname;
  const CURRENT_SLUG = hostname === ''localhost'' ? ''politica-general'' : hostname.split(''.'')[0];

  useEffect(() => {
    const fetchRegistry = async () => {
      try {
        setLoading(true);

        // PeticiÃ³n al Kernel usando el esquema ''via51''
        const { data, error: supaError } = await supabase
          .from(''v51_registry'') // Nombre de tabla real validado
          .select(''id, slug, configuration, node_tree'')
          .eq(''slug'', CURRENT_SLUG)
          .maybeSingle();

        if (supaError) throw new Error(supaError.message);

        if (!data) {
          setError("TENANT_NOT_FOUND_IN_VIA51_SCHEMA");
        } else {
          // NormalizaciÃ³n de datos para el motor de renderizado
          setNodeData({
            id: data.id,
            slug: data.slug,
            phrases: data.configuration?.campaign_phrases || ["VÃA51_ACTIVE"],
            brand: data.configuration?.brand_name || ''VÃA51_UNIT'',
            speed: data.configuration?.rotation_speed || 3000,
            tree: data.node_tree
          });
        }
      } catch (err: any) {
        console.error("V51_CORE_FETCH_ERROR:", err.message);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchRegistry();
  }, [CURRENT_SLUG]);

  return { nodeData, loading, error };
};

// FILE: campaign.schema.ts
export const CampaignSchema = {
    AUTH: {
        logic: (meta: any) => {
            // LÃ³gica de Colaboradores vs Ciudadanos
            const collaborators: any = { "12345678": { role: "LEAD" } };
            const user = collaborators[meta.dni];
            return user ? { type: ''COLLABORATOR'', ...user } : { type: ''CITIZEN'' };
        }
    },
    CAPTURE: {
        logic: (meta: any) => {
            // Registro identificado (No agnÃ³stico en el Driver, pero agnÃ³stico en el proceso)
            return { id: Date.now(), status: ''PENDING_EVALUATION'', ...meta };
        }
    }
};
// FILE: citizen.schema.ts
import fs from ''fs'';
import path from ''path'';

export const CitizenSchema = {
    V51_DNA: { id: "SCHEMA-BETA", seq: "S-05" },

    AUTH_COLLABORATOR: {
        logic: (meta: any) => {
            const dbPath = path.resolve(''src/database/citizens.json'');
            const db = JSON.parse(fs.readFileSync(dbPath, ''utf8''));
            const user = db.users[meta.dni];
            const now = Date.now();

            // LÃ³gica de 3 intentos (Bloqueo 24h)
            let lock = db.lockouts[meta.dni] || { attempts: 0, last: 0 };

            if (lock.attempts >= 3 && now - lock.last < 86400000) {
                return { status: ''LOCKED'', msg: "Acceso denegado por 24 horas." };
            }

            if (!user) {
                lock.attempts++;
                lock.last = now;
                db.lockouts[meta.dni] = lock;
                fs.writeFileSync(dbPath, JSON.stringify(db, null, 2));

                const msgs = [
                    "DNI no reconocido. Verifique gentilmente sus datos.",
                    "Parece haber un error en el nÃºmero. IntÃ©ntelo de nuevo.",
                    "Ãšltimo intento fallido. El sistema se cerrarÃ¡ por seguridad."
                ];
                return { status: ''RETRY'', msg: msgs[lock.attempts - 1] };
            }

            return { status: ''AUTHORIZED'', user };
        }
    }
};
// FILE: NodeOrchestrator.ts
/**
 * FUNCTION: NodeOrchestrator (Immune Identity Controller)
 * LOCATION: /src/core/context/NodeOrchestrator.ts
 * DATE: 2026-04-03
 * TIME: 07:48:32
 * DESCRIPTION: Detects and validates the current execution node in the fractal hierarchy.
 * Ensures that RLS (Row Level Security) context is injected into every request.
 */

export type NodeLevel = ''GAMMA'' | ''BETA'' | ''ALFA'';

interface NodeContext {
    id: string;
    level: NodeLevel;
    alias: string;
    timestamp: string;
}

export const getExecutionNode = (): NodeContext => {
    const hostname = window.location.hostname;
    const parts = hostname.split(''.'');

    // Logic to determine level based on Antigravity Topology
    let level: NodeLevel = ''ALFA'';
    if (hostname.includes(''gamma'')) level = ''GAMMA'';
    else if (hostname.includes(''hub'') || hostname.includes(''beta'')) level = ''BETA'';

    return {
        id: crypto.randomUUID(), // Local transient ID for session tracking
        level: level,
        alias: parts[0] || ''root'',
        timestamp: "2026-04-03 07:48:32"
    };
};

export const auditLog = (action: string, metadata: object) => {
    const node = getExecutionNode();
    console.log(`[AUDIT][${node.level}][${node.timestamp}] ${action}`, metadata);
    // Integration point for sys_events (Supabase) would be here
};

// FILE: blackBox.ts
// NÃšCLEO AGNÃ“STICO - No se toca para cambios de campaÃ±a
export interface StandardPayload {
    entity_id: string;
    action_type: ''AUTH'' | ''CAPTURE'' | ''TRANSITION'';
    metadata: any;
}

export class Via51BlackBox {
    public static async execute(payload: StandardPayload, schema: any): Promise<any> {
        // 1. VALIDADOR (MecÃ¡nica de la Carta Magna)
        if (!payload.entity_id || !payload.action_type) throw new Error("CORE_INVALID_INPUT");

        // 2. PROCESADOR (Aplica las reglas del schema sin conocer el dominio)
        const rule = schema[payload.action_type];
        if (!rule) throw new Error("CORE_RULE_NOT_FOUND");

        // 3. ORQUESTADOR (Distribuye el resultado)
        return {
            status: ''PROCESSED'',
            timestamp: new Date().toISOString(),
            result: rule.logic(payload.metadata)
        };
    }
}
// FILE: blackbox_main.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-07-DB" }
 * MECANICA 07: INTERFAZ DE LA CAJA NEGRA (THE BLACK BOX)
 */
import { CoreValidator, V51_Package } from "./validator";
import { CoreProcessor } from "./processor";
import { CoreOrchestrator } from "./orchestrator";
import { CoreHangar } from "./hangar";
import { CoreEventLog } from "./event_log";

export class Via51BlackBox {
    public static async handleSinapsis(pkg: V51_Package): Promise<any> {
        console.log(`[BLACKBOX] Pulso de ${pkg.v51_dna.node} [ENV: ${pkg.v51_dna.env || ''PROD''}]`);

        if (!CoreValidator.validate(pkg)) {
            return { status: "ERROR", msg: "SINAPSIS_RECHAZADA" };
        }

        const scenario = CoreHangar.loadScenario("ASUNTOS-PUBLICOS");
        if (!scenario) return { status: "ERROR", msg: "SCENARIO_MISSING" };

        const result = await CoreProcessor.process(pkg);

        // EXTRAER ENTORNO DEL DNA PARA EL SELLO
        const env = (pkg.v51_dna as any).env || "PROD";
        const tx_id = await CoreEventLog.seal(result, env);
        
        const dispatchPlan = CoreOrchestrator.orchestrate(result);

        return { ...result, tx_id, plan: dispatchPlan };
    }
}
// FILE: event_log.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-05-MIRROR" }
 * MECANICA 05: SELLADO EN SUPABASE CON PROTOCOLO ESPEJO
 */
import { createClient } from "@supabase/supabase-js";
import { V51_Result } from "./processor";

const supabase = createClient(
    process.env.SUPABASE_URL || "", 
    process.env.SUPABASE_SERVICE_ROLE_KEY || ""
);

export class CoreEventLog {
    public static async seal(result: V51_Result, env: string): Promise<string> {
        // DECISOR DE TABLA: SOBERANIA DE ENTORNO
        const targetTable = (env === "LAB") ? "dev_sys_events" : "sys_events";
        
        console.log(`[EVENT_LOG] Registrando en: ${targetTable.toUpperCase()}`);

        try {
            const { data, error } = await supabase
                .from(targetTable)
                .insert([{
                    actor_id: result.dna_origin,
                    action_type: result.action_performed,
                    payload: result.payload_out
                }])
                .select();

            if (error) throw error;
            return data[0].id;
        } catch (e: any) {
            console.error(`[EVENT_LOG] FALLO: ${e.message}`);
            return "ERROR_UNSEALED";
        }
    }
}
// FILE: hangar.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-06" }
 * MECANICA 06: MOTOR DE CARGA BAJO DEMANDA (EL HANGAR)
 */

import fs from "fs";
import path from "path";

export interface V51_Scenario {
    id: string;
    rules: any;
    flow: string[];
    output_channels: string[];
}

export class CoreHangar {
    private static HANGAR_PATH = path.resolve("src/database/sys_hangar.json");

    /**
     * Recupera la configuracion de un escenario especifico.
     * Permite que el Core sea agnostico cargando logica externa.
     */
    public static loadScenario(scenarioId: string): V51_Scenario | null {
        console.log(`[HANGAR] Buscando escenario: ${scenarioId}`);

        try {
            // 1. Consultar el inventario del Hangar
            const inventory = JSON.parse(fs.readFileSync(this.HANGAR_PATH, "utf8"));
            const entry = inventory.scenarios.find((s: any) => s.id === scenarioId || s.alias === scenarioId);

            if (!entry || entry.status !== "READY") {
                console.error(`[HANGAR] Scenario ${scenarioId} no disponible.`);
                return null;
            }

            // 2. Cargar el "Disco" (Archivo de configuracion del escenario)
            const scenarioData = JSON.parse(fs.readFileSync(path.resolve(entry.config_path), "utf8"));

            console.log(`[HANGAR] OK: Escenario ${scenarioId} cargado y listo.`);
            return scenarioData as V51_Scenario;

        } catch (error) {
            console.error("[HANGAR] CRITICAL: Fallo en la carga de escenario.");
            return null;
        }
    }
}
// FILE: index.ts
// via51-beta/src/core/index.ts

import { Via51BlackBox } from ''./engine/blackBox'';

/**
 * PROTOCOLO DE SELLADO (Black Box)
 * Solo se permite la interacciÃ³n a travÃ©s de drivers controlados.
 */
const CoreInstance = Object.freeze(new Via51BlackBox());

export default CoreInstance;
// FILE: orchestrator.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-03" }
 * MECANICA 03: ORQUESTADOR DE SALIDA
 */

import { V51_Result } from "./processor";

export interface V51_Dispatch {
    target: string; // Ejemplo: "ALFA-SCREEN", "GAMMA-LOG", "WA-DRIVER"
    payload: any;
    priority: number;
}

export class CoreOrchestrator {
    /**
     * Dirige el resultado hacia los canales correspondientes.
     * La configuracion de canales vendra del Hangar en la Fase 2.
     */
    public static orchestrate(result: V51_Result): V51_Dispatch[] {
        console.log(`[ORCHESTRATOR] Despachando resultado de: ${result.action_performed}`);

        const dispatches: V51_Dispatch[] = [];

        // 1. Canal Obligatorio: Trazabilidad (sys_events)
        dispatches.push({
            target: "SYSTEM_EVENT_LOG",
            payload: result,
            priority: 1
        });

        // 2. Canal de Respuesta: Driver Solicitante
        // Si el estado es exito, enviamos la carga al driver.
        if (result.status === "SUCCESS") {
            dispatches.push({
                target: result.dna_origin, // Devuelve al nodo que inicio la sinapsis
                payload: result.payload_out,
                priority: 2
            });
        }

        return dispatches;
    }
}
// FILE: processor.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-02" }
 * MECANICA 02: PROCESADOR DE ESTADOS (CORE ENGINE)
 */

import { V51_Package } from "./validator";

export interface V51_Result {
    status: "SUCCESS" | "FAILURE" | "PENDING";
    dna_origin: string;
    action_performed: string;
    payload_out: any;
    timestamp: number;
}

export class CoreProcessor {
    /**
     * Procesa el paquete sin conocer el dominio.
     * En el futuro, aqui se conectara el "Disco" del Hangar.
     */
    public static async process(input: V51_Package, scenarioLogic?: any): Promise<V51_Result> {
        console.log(`[PROCESSOR] Ejecutando accion: ${input.action}`);

        try {
            // 1. Ejecucion de logica externa (inyectada desde el Hangar)
            // Si no hay logica aun (Fase 1), devolvemos el payload intacto como echo.
            const resultData = scenarioLogic
                ? await scenarioLogic(input.payload)
                : input.payload;

            // 2. Construccion del resultado estandar
            const response: V51_Result = {
                status: "SUCCESS",
                dna_origin: input.v51_dna.node,
                action_performed: input.action,
                payload_out: resultData,
                timestamp: Date.now()
            };

            return response;

        } catch (error) {
            console.error(`[PROCESSOR] CRITICAL FAILURE en accion ${input.action}`);
            return {
                status: "FAILURE",
                dna_origin: input.v51_dna.node,
                action_performed: input.action,
                payload_out: { error: "MECANICA_INTERRUMPIDA" },
                timestamp: Date.now()
            };
        }
    }
}
// FILE: storage.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-04" }
 * MECANICA 04: GESTOR DE ALMACENAMIENTO LOCAL
 */

import fs from "fs";
import path from "path";

export class CoreStorage {
    private static DB_PATH = path.resolve("src/database/sys_nodes.json");

    /**
     * Lee la jerarquia fractal desde el disco duro.
     * Prioriza recursos locales segun Carta Magna.
     */
    public static getHierarchy(): any {
        try {
            const data = fs.readFileSync(this.DB_PATH, "utf8");
            return JSON.parse(data);
        } catch (error) {
            console.error("[STORAGE] CRITICAL ERROR: No se puede leer sys_nodes.");
            return null;
        }
    }

    /**
     * Verifica si un nodo existe y esta activo.
     */
    public static isNodeAuthorized(nodeId: string): boolean {
        const db = this.getHierarchy();
        if (!db) return false;

        // Logica de busqueda recursiva simple para validacion
        const flatNodes = this.flattenHierarchy(db.hierarchy.root);
        const target = flatNodes.find((n: any) => n.id === nodeId);

        return target ? target.status === "ACTIVE" : false;
    }

    private static flattenHierarchy(node: any): any[] {
        let nodes = [node];
        if (node.children) {
            node.children.forEach((child: any) => {
                nodes = nodes.concat(this.flattenHierarchy(child));
            });
        }
        return nodes;
    }
}
// FILE: validator.ts
/**
 * V51_DNA: { node: "CORE-BETA", type: "MECHANIC", seq: "M-01" }
 * MECANICA 01: VALIDADOR AGNOSTICO
 */

export interface V51_Package {
    v51_dna: {
        node: string;
        seq: string;
        pulse: number;
    };
    action: string;
    payload: any;
}

export class CoreValidator {
    /**
     * Verifica la integridad estructural de la entrada.
     * No conoce el contenido, solo la forma del contrato.
     */
    public static validate(input: V51_Package): boolean {
        try {
            // 1. Verificacion de DNA
            if (!input.v51_dna || !input.v51_dna.node || !input.v51_dna.seq) {
                console.error("[VALIDATOR] ERROR: DNA inexistente o incompleto.");
                return false;
            }

            // 2. Verificacion de Intencion
            if (!input.action || typeof input.action !== "string") {
                console.error("[VALIDATOR] ERROR: Accion no definida.");
                return false;
            }

            // 3. Verificacion de Carga
            if (input.payload === undefined) {
                console.error("[VALIDATOR] ERROR: Payload vacio.");
                return false;
            }

            console.log(`[VALIDATOR] OK: Sinapsis validada para nodo ${input.v51_dna.node}`);
            return true;
        } catch (e) {
            return false;
        }
    }
}
// FILE: identity.map.ts
// via51-beta/src/core/config/identity.map.ts

export interface FractalIdentity {
    organizationName: string; // Ej: "VÃ­a51", "Empresa X", "Gobierno Y"
    branding: {
        primaryColor: string;
        logoUrl: string;
    };
    taxonomy: {
        level1: [string, string, string];      // Ej: ["PolÃ­tica", "Social", "ProducciÃ³n"]
        level2: string;                        // Ej: "Triadas" o "Regiones"
        level3: string;                        // Ej: "CÃ©lulas" o "Puntos de Venta"
    };
}
// FILE: DriverManager.ts
/**
 * VIA51 - DRIVER MANAGER
 * Recibe el "Pedido Crudo" y lo adecua segÃºn el Dominio.
 */

export interface RawRequest {
    nodeId: string;
    domain: ''POL'' | ''SOC'' | ''PROD'';
    payload: any; // El pedido sin procesar
}

export class DriverManager {
    // El Driver adecua el pedido antes de que llegue al motor principal
    public static process(request: RawRequest) {
        console.log(`[DRIVER] Procesando pedido crudo para dominio: ${request.domain}`);

        switch (request.domain) {
            case ''POL'':
                return this.politicsDriver(request.payload);
            case ''PROD'':
                return this.productionDriver(request.payload);
            default:
                return request.payload; // Driver agnÃ³stico por defecto
        }
    }

    private static politicsDriver(raw: any) {
        // AquÃ­ el Driver "sabe" que en polÃ­tica todo debe llevar firma y nivel de acceso
        return {
            ...raw,
            processed_by: ''Politics-Driver-v1'',
            security_clearance: ''Level-1'',
            formatted_date: new Date().toISOString()
        };
    }

    private static productionDriver(raw: any) {
        // El Driver de producciÃ³n asegura que existan cantidades numÃ©ricas
        return {
            ...raw,
            qty: Number(raw.qty) || 0,
            unit: raw.unit || ''UNIDAD'',
            timestamp: Date.now()
        };
    }
}
// FILE: input.driver.ts
// via51-beta/src/core/drivers/input.driver.ts

export interface StandardInput {
    origin: string;        // ID del Nodo (Nivel 0-3)
    domain: string;        // Evento, Empresa, Persona (AgnÃ³stico para el Core)
    action: string;        // CREATE, UPDATE, NOTIFY, TRACK
    payload: any;          // Datos crudos
    auth: {                // Token de nivel de acceso
        uid: string;
        role: ''SUPER_OWNER'' | ''SUPER_COLLABORATOR'' | ''COLLABORATOR'';
    };
}
// FILE: maintenance.driver.ts
// via51-beta/src/core/drivers/maintenance.driver.ts

export class MaintenanceDriver {
    private static readonly MASTER_KEYS = [''FREDY_V51_PROPIETARIO'', ''RENZO_V51_PROPIETARIO''];

    public static async openForMaintenance(ownerId: string, securityToken: string): Promise<boolean> {
        // 1. VerificaciÃ³n de Identidad Vitalicia (Carta Magna)
        if (!this.MASTER_KEYS.includes(ownerId)) {
            console.error("ALERTA CRÃTICA: Intento de acceso no autorizado al CORE.");
            return false;
        }

        // 2. Registro en sys_events como ''MAINTENANCE_MODE_ACTIVE''
        // El sistema entra en modo ''Transparente'' solo para el Owner.
        return true;
    }
}
// FILE: messaging.driver.ts
// via51-beta/src/core/drivers/messaging.driver.ts

export interface SovereignMessage {
    id: string;
    sender_level: 0 | 1 | 2 | 3;
    recipient_id: string; // ID de nodo o "ALL"
    payload: { subject: string; body: string; priority: ''NORMAL'' | ''COMMAND''; };
    audit_hash: string;   // Firma para asegurar que el mensaje no fue alterado
}

// El CORE procesa el mensaje, lo valida contra RLS y lo entrega.
// FILE: output.driver.ts
// via51-beta/src/core/drivers/output.driver.ts

export interface StandardOutput {
    status: ''SUCCESS'' | ''FAILURE'';
    transmissionId: string; // ID Ãºnico de trazabilidad
    data: any;             // Respuesta procesada
    actions: string[];     // Lista de disparadores (ej: ["SEND_EMAIL", "UPDATE_MAP"])
}
// FILE: OutputDriver.ts
/**
 * VIA51 - OUTPUT DRIVER
 * Convierte resultados tÃ©cnicos en informaciÃ³n humana.
 */

export class OutputDriver {
    public static translate(rawResult: any, domain: string) {
        // El motor produjo un resultado, el Driver lo hace amigable
        const baseResponse = {
            timestamp: new Date().toLocaleString(),
            severity: rawResult.error ? ''CRÃTICO'' : ''Ã‰XITO'',
        };

        switch (domain) {
            case ''POL'':
                return {
                    ...baseResponse,
                    mensaje: `SoberanÃ­a confirmada: Se ha registrado una nueva directiva en el nodo de PolÃ­tica.`,
                    accion_sugerida: "Revisar en el monitor Gamma la firma digital.",
                    visual: "badge-gold"
                };
            case ''PROD'':
                return {
                    ...baseResponse,
                    mensaje: `Flujo de ProducciÃ³n actualizado: ${rawResult.qty} unidades integradas al inventario.`,
                    accion_sugerida: "Verificar balance de recursos en la TrÃ­ada de LogÃ­stica.",
                    visual: "chart-green"
                };
            default:
                return {
                    ...baseResponse,
                    mensaje: "OperaciÃ³n procesada correctamente por el NÃºcleo Antigravity.",
                    data: rawResult
                };
        }
    }
}
// FILE: surveillance.driver.ts
// via51-beta/src/core/drivers/surveillance.driver.ts

export interface DailySurveillanceReport {
    date: string;
    totalTelemetries: number;
    activeNodes: number;         // CuÃ¡ntos de los 43 nodos reportaron
    loadDistribution: {
        level0: number; // Alfa
        level1: number; // Departamentos (3)
        level2: number; // Triadas (9)
        level3: number; // Derivaciones (27)
    };
    securityAlerts: number;      // Intentos de acceso denegados por RLS
}
// FILE: theme.driver.ts
// via51-beta/src/core/drivers/theme.driver.ts

export interface V51Theme {
    mode: ''NEUROMORPHIC'' | ''MINIMALIST'' | ''CYBERNETIC'';
    colors: { primary: string; secondary: string; background: string; surface: string; };
    assets: { logo_url: string; icon_set: string; };
    typography: ''INTER_SANS'' | ''ROBOTO_MONO'';
}

// ConfiguraciÃ³n por defecto para VÃ­a51
const defaultTheme: V51Theme = {
    mode: ''CYBERNETIC'',
    colors: { primary: ''#00FF41'', secondary: ''#008F11'', background: ''#0D0208'', surface: ''#003B00'' },
    assets: { logo_url: ''/assets/v51-logo.svg'', icon_set: ''antigravity-icons'' },
    typography: ''ROBOTO_MONO''
};
// FILE: blackBox.ts
// C:\via51-fractal\via51-beta\src\core\engine\blackBox.ts

export interface StandardInput {
    origin: string;
    domain: string;
    action: string;
    payload: any;
}

export class Via51BlackBox {
    // VALIDADOR (Regla 4)
    private static validate(input: StandardInput): boolean {
        return !!(input.origin && input.action);
    }

    // PROCESADOR (Regla 4)
    public static async process(input: StandardInput): Promise<any> {
        if (!this.validate(input)) throw new Error("INVALID_CORE_INPUT");

        // El motor procesa la carga Ãºtil sin juzgar el contenido
        console.log(`[CORE] Procesando flujo para dominio: ${input.domain}`);
        return {
            processedAt: new Date().toISOString(),
            status: ''STABLE'',
            data: input.payload
        };
    }
}
// FILE: locationProcessor.ts
import { GeoLocationPayload, LocationState } from ''../entities/location.entity'';

export class LocationEngine {

    // VALIDADOR
    public static validate(payload: GeoLocationPayload): boolean {
        const isLatValid = payload.latitude >= -90 && payload.latitude <= 90;
        const isLngValid = payload.longitude >= -180 && payload.longitude <= 180;
        return isLatValid && isLngValid;
    }

    // PROCESADOR (TransiciÃ³n de Estados)
    public static processTransition(current: LocationState, event: string): LocationState {
        const stateMap: Record<string, LocationState> = {
            ''movement_detected'': ''TRACKING'',
            ''stop_detected'': ''STATIONARY'',
            ''perimeter_breach'': ''GEOFENCE_ALERT''
        };
        return stateMap[event] || current;
    }

    // ORQUESTADOR (Salida a Canales)
    public static orchestrate(result: any): void {
        // Registro inmutable en sys_events
        console.log(`[AUDIT] Location Event Logged: ${JSON.stringify(result)}`);
        // DistribuciÃ³n a Alfa o Gamma segÃºn jerarquÃ­a
    }
}
// FILE: recovery.ts
// via51-beta/src/core/engine/recovery.ts

export class RecoveryManager {
    public static async executeFractalRestart(deptId: number) {
        console.log(`[RECOVERY] Iniciando restauraciÃ³n del Departamento ${deptId}`);

        // InyecciÃ³n de seÃ±al de recuperaciÃ³n a travÃ©s del Driver de Salida
        const recoveryPayload = { action: ''FORCE_RECONNECT'', targetDept: deptId };
        await OutputDriver.broadcast(recoveryPayload);

        // Registro inmutable del reinicio autorizado
        await Database.logEvent({
            type: ''SOVEREIGNTY_RESTORED'',
            authorizedBy: ''FREDY_BAZALAR'',
            context: `REINICIO FRACTAL - DEP_03`,
            timestamp: new Date().toISOString()
        });
    }
}
// FILE: watchdog.ts
// via51-beta/src/core/engine/watchdog.ts

const THRESHOLD_MINUTES = 10;
const DEPARTMENTS = [1, 2, 3]; // PolÃ­tica, Social, ProducciÃ³n

export class SovereigntyWatchdog {
    public static async checkHealth() {
        for (const deptId of DEPARTMENTS) {
            const lastActivity = await Database.getLastEventTimestamp(deptId);
            const diffMinutes = (Date.now() - lastActivity) / 1000 / 60;

            if (diffMinutes >= THRESHOLD_MINUTES) {
                this.triggerCriticalAlert(deptId);
            }
        }
    }

    private static triggerCriticalAlert(deptId: number) {
        const deptName = [''POLÃTICA'', ''SOCIAL'', ''PRODUCCIÃ“N''][deptId - 1];

        // DRIVER DE SALIDA DE EMERGENCIA
        EmergencyDriver.dispatch({
            type: ''SOVEREIGNTY_AT_RISK'',
            priority: ''CRITICAL'',
            target: ''FREDY_BAZALAR_TERMINAL'',
            message: `ALERTA CRÃTICA: El pilar [${deptName}] ha dejado de reportar por mÃ¡s de 10 min.`
        });
    }
}
// FILE: database.types.ts
export type SysRegistry = {
    id: string;
    node_name: string;
    node_path: string; // Ltree para jerarquÃ­a fractal
    level: number;     // 0, 1, 2, 3
    owner_id: string;
};

export type UserPermission = {
    id: string;
    email: string;
    access_role: ''SuperPropietario'' | ''Supervisor'' | ''Colaborador'';
    hierarchy_level: number;
    is_immutable: boolean;
};
// FILE: index.ts
import { createClient } from ''@supabase/supabase-js'';
import { CorePayload } from ''../../types/core'';

const supabase = createClient(
    import.meta.env.VITE_SUPABASE_URL || '''',
    import.meta.env.VITE_SUPABASE_ANON_KEY || ''''
);

export class UniversalProcessor {

    public static async execute(payload: CorePayload): Promise<void> {
        const { sender, timestamp } = payload.metadata;

        try {
            const { data: permission } = await supabase
                .from(''user_permissions'')
                .select(''*'')
                .eq(''id'', sender)
                .single();

            if (!permission || permission.hierarchy_level > payload.data.requiredLevel) {
                throw new Error("INSUBORDINACIÃ“N: Nivel de jerarquÃ­a insuficiente.");
            }

            const { error: txError } = await supabase
                .from(''domain_data'')
                .upsert({
                    node_id: payload.data.nodeId,
                    payload: payload.data,
                    status: payload.data.nextStatus,
                    updated_at: new Date(timestamp).toISOString()
                });

            if (txError) throw txError;

            await this.logToSysEvents(payload, ''SUCCESS'');

            await supabase.from(''sys_payload_vault'').insert({
                node_id: payload.data.nodeId,
                payload: payload.data,
                checksum: this.generateChecksum(payload.data),
                is_active: true
            });

        } catch (error: any) {
            await this.logToSysEvents(payload, ''FAILURE'');
            console.error(`[PROCESSOR-ERROR] ${error.message}`);
            throw error;
        }
    }

    private static async logToSysEvents(payload: CorePayload, status: string) {
        await supabase.from(''sys_events'').insert({
            actor_id: payload.metadata.sender,
            action_type: payload.action,
            payload_snapshot: payload.data,
            status: status,
            node_id: payload.data.nodeId
        });
    }

    private static generateChecksum(data: any): string {
        const str = JSON.stringify(data);
        return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, (match, p1) => {
            return String.fromCharCode(parseInt(p1, 16));
        })).substring(0, 16);
    }
}
// FILE: accessControl.ts
// via51-beta/src/core/security/accessControl.ts

export class AccessValidator {

    /**
     * Verifica si el usuario tiene autoridad para acceder a la ubicaciÃ³n de un nodo
     * @param userRole Rango segÃºn Carta Magna
     * @param targetDepth Nivel del nodo (0-3)
     */
    static canAccessLocation(userRole: string, targetDepth: number): boolean {
        // Regla Inviolable: Nivel 2 (GAMMA) accede a todo.
        if (userRole === ''SUPER_OWNER'') return true;

        // Los Supervisores (Nivel 1) no pueden ver datos de Inteligencia Digital (GAMMA)
        if (userRole === ''SUPER_COLLABORATOR'' && targetDepth < 2) return true;

        return false;
    }
}
// FILE: deploy.guard.ts
// via51-beta/src/core/security/deploy.guard.ts

export class DeployGuard {
    private static readonly AUTHORIZED_SIGNATURES = [
        ''FREDY_V51_MASTER_KEY'',
        ''RENZO_V51_MASTER_KEY''
    ];

    public static async authorizeDeployment(commitHash: string, signature: string): Promise<boolean> {
        console.log(`[AUDIT] Verificando autorizaciÃ³n para commit: ${commitHash}`);

        // Verifica si la firma coincide con las llaves maestras de la Carta Magna
        if (this.AUTHORIZED_SIGNATURES.includes(signature)) {
            console.log("AUTORIZACIÃ“N CONCEDIDA: Iniciando despliegue fractal...");
            return true;
        }

        console.error("ALERTA: Intento de despliegue no autorizado bloqueado.");
        return false;
    }
}
// FILE: telemetry.interceptor.ts
// C:\via51-fractal\via51-beta\src\core\triggers\telemetry.interceptor.ts

import { StandardInput } from ''../drivers/interfaces'';
import { Via51BlackBox } from ''../engine/blackBox'';

export class TelemetryTrigger {
    /**
     * Captura automÃ¡tica de visita en Nivel 0
     */
    public static async captureVisit(ip: string, userAgent: string): Promise<void> {
        // El driver convierte IP en Data GeogrÃ¡fica (Simulado para el ejemplo)
        const geoData = await this.resolveGeo(ip);

        const input: StandardInput = {
            origin: ''VIA51-ALFA-00'', // Front-end PÃºblico
            domain: ''PUBLIC_AFFAIRS'',
            action: ''RECORD_VISIT'',
            payload: {
                ...geoData,
                browser: userAgent,
                campaign: ''MESIAS_GUEVARA_2024''
            },
            auth: { uid: ''ANONYMOUS_VISITOR'', role: ''COLLABORATOR'' } // Rol mÃ­nimo de lectura
        };

        // EnvÃ­o silencioso a la Caja Negra para registro inmutable
        await Via51BlackBox.execute(input);
    }

    private static async resolveGeo(ip: string) {
        // LÃ³gica para determinar PaÃ­s/RegiÃ³n mediante servicio de IP
        return { country: ''PerÃº'', region: ''Lima'' };
    }
}
// FILE: index.ts
import { CorePayload, ValidationResult } from ''../../types/core'';

export class UniversalValidator {
    public static validate(payload: CorePayload): ValidationResult {
        const errors: string[] = [];

        if (!payload.action) errors.push("Falta acciÃ³n");
        if (!payload.metadata?.sender) errors.push("Falta remitente");
        if (!payload.data?.nodeId) errors.push("Falta ID de nodo");

        return {
            isValid: errors.length === 0,
            errors
        };
    }
}
// FILE: schemas.ts
import { CorePayload } from ''../../types/core'';

/**
 * Define la estructura de reglas por tipo de entidad.
 * Beta no sabe quÃ© es un "Concierto", solo sabe que ''ENTITY_A'' 
 * requiere ciertos campos obligatorios.
 */
export interface DomainSchema {
    requiredFields: string[];
    dataTypes: Record<string, string>; // e.g., { "capacity": "number" }
    stateTransitions: string[];       // Estados permitidos
}

export const SchemaRegistry: Record<string, DomainSchema> = {
    // Ejemplo: ConfiguraciÃ³n para el Nivel 1 (Departamentos)
    "DEPT_PROD": {
        requiredFields: ["id", "status", "output_type"],
        dataTypes: { "id": "string", "status": "string", "output_type": "string" },
        stateTransitions: ["draft", "processing", "approved"]
    },
    "DEPT_POL": {
        requiredFields: ["id", "regulation_id", "authority"],
        dataTypes: { "id": "string", "regulation_id": "number", "authority": "string" },
        stateTransitions: ["pending", "reviewed", "enacted"]
    }
};
// FILE: sys_events.ts
export const logEvent = (payload: CorePayload, status: ''SUCCESS'' | ''FAILURE'') => {
    const auditEntry = {
        eventId: crypto.randomUUID(),
        timestamp: Date.now(),
        actor: payload.metadata.sender,
        domain: payload.domain,
        status: status
    };

    // En un entorno real, esto se inserta en una DB con RLS estricto.
    console.log(`[SYS_EVENTS] Logged: ${JSON.stringify(auditEntry)}`);
};
// FILE: blackBox.ts
// via51-beta/src/core/engine/blackBox.ts
/**
 * @file CORE VÃA51 - BLACK BOX
 * @status SEALED - IMMUTABLE
 * @access OWNER_ONLY_MAINTENANCE
 */

import { StandardInput, StandardOutput } from ''../drivers/types'';

export class Via51BlackBox {
    private static instance: Via51BlackBox;
    private isLocked: boolean = true;

    private constructor() { }

    public static getInstance(): Via51BlackBox {
        if (!this.instance) this.instance = new Via51BlackBox();
        return this.instance;
    }

    public async process(input: StandardInput): Promise<StandardOutput> {
        // 1. ValidaciÃ³n AgÃ³stica (No conoce el dominio)
        // 2. EjecuciÃ³n de Reglas Fractales (Imagen 2)
        // 3. Registro Inmutable (sys_events)
        return {
            status: ''SUCCESS'',
            transmissionId: crypto.randomUUID(),
            data: input.payload
        };
    }
}

// Congelamiento del objeto para evitar extensiones no autorizadas
export const Core = Object.freeze(Via51BlackBox.getInstance());
// FILE: useNodeStream.ts
import { useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';

export const useNodeStream = (nodeId: string | null = ''default-node'') => {
  const [data, setData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<any>(null);

  useEffect(() => {
    if (!nodeId) return;
    const fetchInitial = async () => {
      try {
        setLoading(true);
        const { data: res, error: err } = await supabase
          .from(SCHEMA.TABLES.EVENTS)
          .select(''*'')
          .eq(''node_id'', nodeId)
          .limit(10);

        if (err) throw err;
        setData(res || []);
      } catch (e) {
        setError(e);
      } finally {
        setLoading(false);
      }
    };
    fetchInitial();
  }, [nodeId]);

  return { data, loading, error };
};
// FILE: useV51Registry.ts
import { useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';

export const useV51Registry = () => {
    const [nodes, setNodes] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchRegistry = async () => {
            const { data, error } = await supabase
                .from(SCHEMA.TABLES.REGISTRY)
                .select(''*'')
                .order(''level'', { ascending: true });

            if (!error) setNodes(data || []);
            setLoading(false);
        };

        fetchRegistry();
    }, []);

    return { nodes, loading };
};
// FILE: supabaseClient.ts
import { createClient } from ''@supabase/supabase-js'';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
    console.warn("ADVERTENCIA: Credenciales de Supabase no detectadas en el entorno.");
}

export const supabase = createClient(supabaseUrl || '''', supabaseAnonKey || '''');
// FILE: veto-gatekeeper.ts
// src/middleware/veto-gatekeeper.ts

const SUPEROWNER_ID = "fredy-0000-0000-gamma-super"; // Placeholder UUID for Fredy
const VETO_SECRET_TOKEN = process.env.VETO_CLEARANCE_TOKEN; // Set in Gamma environment

interface RequestContext {
    userId: string;
    action: string;
    vetoToken?: string;
}

/**
 * THE FREDY GATEKEEPER
 * Prevents creation of new Owners (Level 2 expansion) without explicit SuperOwner clearance.
 */
export const vetoGatekeeper = (context: RequestContext) => {
    const { userId, action, vetoToken } = context;

    // 1. Vitalicio Rule: Fredy bypasses all restrictions
    if (userId === SUPEROWNER_ID) {
        console.log("[GAMMA] SuperOwner access granted. Veto bypassed.");
        return true;
    }

    // 2. Expansion Rule: Creating an OWNER requires Level 2 Veto Clearance
    if (action === "CREATE_OWNER") {
        if (!vetoToken || vetoToken !== VETO_SECRET_TOKEN) {
            throw new Error("403 Forbidden: Veto Power active. Only Fredy can authorize new Owners.");
        }
    }

    // 3. Hierarchy Check: Standard flow for Beta/Alfa
    console.log(`[BETA] Traffic processing authorized for user: ${userId}`);
    return true;
};

// FILE: stressTest.ts
// via51-beta/src/test/stressTest.ts

async function runStressTest() {
    console.log("INICIANDO RÃFAGA: 27 NODOS NIVEL 3 -> CORE");

    const nodes = Array.from({ length: 27 }, (_, i) => `V51-N3-NODE-${i + 1}`);

    const stressBurst = nodes.map(nodeId => ({
        origin: nodeId,
        domain: "TELEMETRY",
        action: "TRACK",
        payload: {
            lat: -12.046 + (Math.random() * 0.1),
            lng: -77.042 + (Math.random() * 0.1)
        },
        auth: { uid: `COLLABORATOR_${nodeId}`, role: ''COLLABORATOR'' }
    }));

    // EjecuciÃ³n en paralelo masivo hacia la Caja Negra
    const results = await Promise.all(stressBurst.map(input => Via51BlackBox.execute(input)));

    return results;
}
// FILE: core.ts
export interface ValidationResult {
    isValid: boolean;
    errors: string[];
}

export interface CorePayload {
    action: string;
    domain?: string;
    metadata: {
        sender: string;
        timestamp: string;
    };
    data: {
        nodeId: string;
        requiredLevel: number;
        nextStatus: string;
        [key: string]: any;
    };
}
// FILE: tailwind.config.ts
import type { Config } from ''tailwindcss''

export default {
    content: [
        "./index.html",
        "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                ''v51-bg'': ''#000000'',
                ''v51-text'': ''#FFFFFF'',
                ''v51-gamma'': ''#00FF41'',
            },
        },
    },
    plugins: [],
} satisfies Config
// FILE: vite.config.ts
import { defineConfig } from ''vite''
import react from ''@vitejs/plugin-react''

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5175,
    strictPort: true,
    host: true
  },
  build: {
    target: ''esnext''
  }
})
// FILE: via51.ts
const OPCIONES_CENIT = {
  VERDE: {
    fondo: ''/assets/palacio-gobierno.jpg'',    // <--- Ahora en el primer botÃ³n
    audio: ''/assets/musica-costa.mp3'', 
    titulo: ''PODER EJECUTIVO''
  },
  AMBAR: {
    fondo: ''/assets/palacio-legislativo.jpg'', // <--- Ahora en el segundo botÃ³n
    audio: ''/assets/musica-sierra.mp3'', 
    titulo: ''PODER LEGISLATIVO''
  },
  ROJO: {
    fondo: ''/assets/peru-regiones.jpg'',
    audio: ''/assets/musica-selva.mp3'',
    titulo: ''NACIÃ“N INTEGRAL''
  },
};

export default OPCIONES_CENIT;

// FILE: deploy.config.ts
/**
 * RUTA: src/core/deploy.config.ts
 * INTENCIÃ“N: Definir las variables de entorno y los parÃ¡metros de seguridad
 * que separan el motor de las aplicaciones durante la construcciÃ³n (Build).
 */

export const DEPLOY_CONFIG = {
    env: process.env.NODE_ENV || ''production'',
    core_version: "2.0",
    // El motor no debe conocer el dominio, solo recibe el path del activo
    assets_path: process.env.VITE_ASSETS_PATH || ''/assets/current_domain/'',
    security_protocol: "GAMMA_LEVEL_ENCRYPTION"
};

// FILE: processor.ts
import { createClient } from ''@supabase/supabase-js'';
import { logEvent } from ''../layers/lib/audit-logger'';

const supabase = createClient(
    import.meta.env.VITE_SUPABASE_URL || '''',
    import.meta.env.VITE_SUPABASE_ANON_KEY || ''''
);

export class GammaProcessor {
    public static async process(event: any) {
        try {
            await logEvent(event, ''SUCCESS'');
        } catch (error: any) {
            console.error(error.message);
        }
    }
}
// FILE: validator.ts
// src/core/validator.ts

export interface ValidationResult {
    isValid: boolean;
    errors: string[];
}

export class CoreValidator {
    /**
     * Agnostic validation: Compares payload against a schema definition.
     * The core doesn''t know what an "Event" or "Company" is.
     */
    public static validate(payload: any, schema: any): ValidationResult {
        const errors: string[] = [];

        // 1. Check for required entities defined in the Registry
        if (schema.requiredFields) {
            schema.requiredFields.forEach((field: string) => {
                if (payload[field] === undefined || payload[field] === null) {
                    errors.push(`Missing required field: ${field}`);
                }
            });
        }

        // 2. Type validation based on Registry rules
        for (const key in payload) {
            if (schema.properties && schema.properties[key]) {
                const expectedType = schema.properties[key].type;
                const actualType = typeof payload[key];

                if (actualType !== expectedType) {
                    errors.push(`Field ''${key}'' expected type ${expectedType} but got ${actualType}`);
                }
            }
        }

        return {
            isValid: errors.length === 0,
            errors,
        };
    }
}

// FILE: ARCHITECTURE_TRIADS.ts
// FILE: v51_engine_manifest.ts
/**
 * RUTA: src/core/manifest/v51_engine_manifest.ts
 * LUGAR: Comas, Lima, PerÃº
 * FECHA: 2026-04-04 | HORA: 08:55
 * INTENCIÃ“N: Definir la ontologÃ­a de VÃA51-CORE 2.0. Establece la jerarquÃ­a
 * de soberanÃ­a (Nivel 0) y las trÃ­adas de nÃºcleos internos/externos.
 */

export interface Via51Manifest {
    version: string;
    sovereignty: {
        level0: "FREDY_ROOT";
        protocol: "GAMMA";
    };
    internal_triad: {
        technological: "NUCLEO_TECNOLOGICO";
        processing: "NUCLEO_PROCESO_INFORMACION";
        applications: "NUCLEO_APLICACIONES";
    };
    external_triad: {
        political: "AREA_POLITICA";
        social: "AREA_SOCIAL";
        production: "AREA_PRODUCCION";
    };
    operational_state: {
        current_focus: "ELECCIONES_2026";
        exception_level: 0; // Escalamiento coyuntural de Nivel 2 a Nivel 0
    };
}

export const V51_CORE_MANIFEST: Via51Manifest = {
    version: "2.0",
    sovereignty: {
        level0: "FREDY_ROOT",
        protocol: "GAMMA",
    },
    internal_triad: {
        technological: "NUCLEO_TECNOLOGICO",
        processing: "NUCLEO_PROCESO_INFORMACION",
        applications: "NUCLEO_APLICACIONES",
    },
    external_triad: {
        political: "AREA_POLITICA",
        social: "AREA_SOCIAL",
        production: "AREA_PRODUCCION",
    },
    operational_state: {
        current_focus: "ELECCIONES_2026",
        exception_level: 0,
    },
};

// FILE: candidato-config.ts
import heroImage from ''../assets/ceo-lima.png'';

export const CAMPAIGN_DATA = {
  assets: {
    heroImage: heroImage,
  },
  
  // Mensajes en el Cenit (Rozando la frente)
  cenit: {
    linea1: "EL ÃšLTIMO EN LA CÃ‰DULA DE VOTACIÃ“N",
    linea2: "PRIMERO EN LAS CALIFICACIONES",
    interpelacion: "Ante la evidencia... Â¿TÃº quÃ© piensas? Â¿CÃ³mo te consideras?"
  },

  // La TrÃ­ada de Botones (Estilo CEO)
  botones: [
    { id: ''convencido'', etiqueta: ''INDISCUTIBLE'', subtexto: ''FIRMAR COMPROMISO'', color: ''green'' },
    { id: ''desconfiado'', etiqueta: ''PUEDE SER'', subtexto: ''VER DATA VIDENZA'', color: ''blue'' },
    { id: ''esceptico'', etiqueta: ''DIFÃCIL'', subtexto: ''PONER A PRUEBA'', color: ''red'' }
  ], // <--- LA COMA QUE CURA EL ERROR

  // Data de AuditorÃ­a del PDF de Videnza
  auditoria: {
    puntajeVidenza: "3.12",
    dimensiones: [
      { area: "Salud", nota: 3.40 },
      { area: "EducaciÃ³n", nota: 2.80 },
      { area: "EconomÃ­a", nota: 3.10 },
      { area: "Seguridad", nota: 3.05 }
    ]
  }
};

// FILE: elecciones_2026.ts
/**
 * RUTA: src/domains/politics/elecciones_2026.ts
 * LUGAR: Comas, Lima, PerÃº
 * FECHA: 2026-04-04 | HORA: 09:15
 * INTENCIÃ“N: Datos especÃ­ficos de la aplicaciÃ³n "Elecciones". 
 * Estos datos alimentan al Motor Universal.
 */

export const ELECCIONES_DATA = {
    candidate: "MesÃ­as Guevara",
    visual_asset: "/assets/video/chaski_morado.mp4",
    slogan: "Primeros en calificaciones, Ãºltimos en la lista.",
    disruption_msg: "Estamos al Ãºltimo porque les vamos a mover el piso a los corruptos.",
    accent_color: "#0047AB" // Azul Cobalto V51
};

// FILE: command.form.ts
// ActualizaciÃ³n en C:\via51-fractal\via51-gamma\src\intel\command.form.ts

public static async emitFromUI(): Promise < void> {
    const title = (document.getElementById(''ins_title'') as HTMLInputElement).value;
    const body = (document.getElementById(''ins_body'') as HTMLTextAreaElement).value;
    const priority = (document.getElementById(''ins_priority'') as HTMLSelectElement).value;

    // EL PUENTE: Enviamos al servidor BETA
    await fetch(''http://hub.via51.org:3000/api/v1/instruction/emit'', {
        method: ''POST'',
        headers: { ''Content-Type'': ''application/json'' },
        body: JSON.stringify({ title, body, priority })
});

alert("TRASCIENDE: La orden ha sido enviada al HUB BETA.");
}
// FILE: reporting.engine.ts
/**
 * VIA51 ANTIGRAVITY - Intel Reporting Engine
 * Nivel: GAMMA (Comando e Inteligencia)
 */

export interface GeoMetrics {
    region: string;
    country: string;
    count: number;
    lastUpdate: string;
}

export interface AnnouncementLog {
    id: string;
    event: string;
    candidate: string;
    content: string;
    emittedAt: string;
    emittedFrom: string;
    status: string;
}

export class ReportingEngine {
    private static announcements: AnnouncementLog[] = [];

    /**
     * Registra un aviso oficial en la trazabilidad inmutable de GAMMA
     */
    public static async logOfficialAnnouncement(content: string, location: string): Promise<string> {
        const announcementId = `V51-ANN-${Date.now()}`;
        const logEntry: AnnouncementLog = {
            id: announcementId,
            event: "CAMPAIGN_SUPPORT_EMISSION",
            candidate: "MESIAS_GUEVARA",
            content: content,
            emittedAt: new Date().toISOString(),
            emittedFrom: location,
            status: "ACTIVE_DIFUSION"
        };

        this.announcements.push(logEntry);
        console.log(`[AUDIT-LOG] Entry Created: ${announcementId}`);
        return announcementId;
    }

    /**
     * Retorna el historial de anuncios para auditorÃ­a del Super Propietario
     */
    public static getHistory(): AnnouncementLog[] {
        return [...this.announcements];
    }
}
// FILE: index.ts
// src/types/index.ts
export interface Tenant {
  id: string;
  slug: string;
  config: {
    brand_name?: string;
    campaign_phrases?: string[];
    rotation_speed?: number;
    theme?: string;
  };
  nodeTree: any;
}

// FILE: registry.ts
export const CORE_REGISTRY = {
  electoral: {
    frasePrincipal: "SISTEMA ANTIGRAVITY",
    fraseSecundaria: "NODO VÃA51-GAMMA ACTIVO",
    posicion: "center" as const,
    slides: [
      "https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1506318137071-a8e063b4b6a1?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?auto=format&fit=crop&w=800&q=80"
    ]
  }
};

// FILE: core.ts
import { supabase } from ''../lib/supabaseClient'';
import { SCHEMA } from ''../lib/constants'';

export const V51_CORE = {
    vault: {
        /**
         * Recupera el payload agnÃ³stico de un nodo.
         */
        async get(nodeId: string) {
            const { data, error } = await supabase
                .from(SCHEMA.TABLES.VAULT)
                .select(''payload, version'')
                .eq(''node_id'', nodeId)
                .eq(''is_active'', true)
                .single();

            if (error) throw new Error(`[V51-VAULT] Access Denied: ${error.message}`);
            return data.payload;
        }
    },

    events: {
        /**
         * Registra un impacto inmutable en el sistema.
         */
        async emit(nodeId: string, type: string, payload: any) {
            return await supabase.from(SCHEMA.TABLES.EVENTS).insert({
                node_id: nodeId,
                action_type: type,
                payload_snapshot: payload
            });
        }
    }
};
// FILE: identities.ts
/**
 * PATH: /v51-ecosystem/via51-gamma/src/kernel/security/identities.ts
 */

export const V51_CORE_TABLES = [
  ''v51_registry'',
  ''v51_nodes_status''
];

export const ROOT_IMMUNE_ID = "9157ae13-36ac-4259-9680-1d9bd2cada4a"; // Fredy

export const isImmune = (uid: string) => uid === ROOT_IMMUNE_ID;

// FILE: audit-logger.ts
// src/lib/audit-logger.ts
import { createClient } from ''@supabase/supabase-js''; // Assuming Supabase usage

const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!);

export interface AuditEntry {
    actor_id: string;        // WHO (User UUID)
    action_type: string;     // WHAT (e.g., STATE_TRANSITION)
    payload_snapshot: any;   // DATA (The state before/after)
    tenant_id: string;       // WHERE (The fractal node ID)
    status: ''SUCCESS'' | ''FAILURE'';
}

/**
 * IMMUTABLE LOGGING
 * Writes directly to sys_events. Level 2 (Gamma) oversight.
 */
export const logEvent = async (entry: AuditEntry) => {
    const event = {
        ...entry,
        timestamp: new Date().toISOString(),
    };

    const { error } = await supabase
        .from(''sys_events'')
        .insert([event]);

    if (error) {
        // Critical failure: If audit fails, we must alert the SuperOwner (Fredy)
        console.error(`[CRITICAL - GAMMA] Audit Logging Failed: ${error.message}`);
        // In a real scenario, this would trigger an emergency notification
    }

    return event;
};

// FILE: constants.ts
/**
 * SOVEREIGN CONSTANTS: Final Production Schema
 * Mapea la lÃ³gica heredada a la infraestructura soberana.
 */
export const SCHEMA = {
  TABLES: {
    REGISTRY: ''sys_registry'',
    ORGANIZATIONS: ''sys_registry'', // Compatibilidad heredada
    EVENTS: ''sys_events'',
    TELEMETRY: ''sys_events'',       // Compatibilidad heredada
    VAULT: ''sys_payload_vault'',
    CONFIG: ''sys_config'',
    INTERACTIONS: ''sys_interactions'',
    SECURITY: ''sys_security_rules'',
    DATA: ''sys_payload_vault''      // Compatibilidad heredada
  },
  DATA_KEYS: {
    TREE: ''node_path'',
    PAYLOAD: ''payload'',
    VERSION: ''version''
  }
};
// FILE: dataClient.ts
import { createClient } from ''@supabase/supabase-js'';

// Extraemos las variables del motor (Vite utiliza import.meta.env)
const CORE_URL = import.meta.env.VITE_CORE_DATA_URL;
const CORE_TOKEN = import.meta.env.VITE_CORE_PUBLIC_TOKEN;

// ValidaciÃ³n de tÃºnel de datos
if (!CORE_URL || !CORE_TOKEN) {
  console.error("ERROR CRÃTICO: El motor Gamma no detecta las variables de infraestructura.");
}

// ExportaciÃ³n del cliente de datos neutro
export const dataClient = createClient(CORE_URL, CORE_TOKEN);

// Mantenemos este alias solo por compatibilidad si otros componentes lo usan
export const supabase = dataClient;

// FILE: supabase.ts
// Path: C:/via51_ecosistema/via51-nodo-central/src/lib/supabase.ts
// Name: V51_Infrastructure_Supabase_Secure_Provider
// Identity: Comas, Lima, Peru | 2026-03-31 20:03:40

import { createClient } from ''@supabase/supabase-js'';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;
const MASTER_UID = import.meta.env.VITE_V51_MASTER_UID;

/**
 * VALIDACIÃ“N QUIRÃšRGICA: 
 * Si las variables no cargan, detenemos la ejecuciÃ³n del nodo 
 * para evitar fugas de datos o acceso anÃ³nimo no deseado.
 */
if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error("CRITICAL_V51_ERROR: Environment variables not loaded. Connectivity Aborted.");
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
  },
  global: {
    headers: {
      ''x-v51-master-id'': MASTER_UID, // Inyectado para auditorÃ­a en sys_events
    },
  },
});

/**
 * FunciÃ³n de VerificaciÃ³n de Privilegios Maestro
 */
export const isMasterSession = (currentUid: string): boolean => {
  return currentUid === MASTER_UID;
};

export const fetchNodeConfig = async (slug: string) => {
  return await supabase.from(''sys_registry'').select(''*, domain_data(*)'').eq(''slug'', slug).single();
};
// FILE: supabaseAdmin.ts
/**
 * PATH: /v51-gamma/src/lib/supabaseAdmin.ts
 * ROLE: Orquestador de SoberanÃ­a VÃA51
 */

import { createClient } from ''@supabase/supabase-js'';

// Constantes de SoberanÃ­a Inmutable
export const MASTER_UID = "9157ae13-36ac-4259-9680-1d9bd2cada4a";

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
    console.error("âŒ ERROR CRÃTICO: Credenciales de infraestructura no detectadas.");
}

/**
 * Cliente de Supabase configurado para el Esquema Maestro "via51"
 */
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    db: {
        schema: ''via51'' // AlineaciÃ³n con el hallazgo en image_f0ce70.png
    },
    auth: {
        persistSession: true,
        autoRefreshToken: true
    }
});

// Alias administrativo para operaciones de alto nivel
export const v51 = supabase;

// FILE: supabaseClient.ts
// path: src/lib/supabaseClient.ts
// Standard: Vite 5+ / VÃA51-Core
import { createClient } from ''@supabase/supabase-js'';

// En Vite se accede vÃ­a import.meta.env
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  // Error silencioso en producciÃ³n, pero ruidoso en desarrollo Gamma
  console.warn("âš ï¸ V51_CORE_AUTH_MISSING: Check your .env file for VITE_ prefix.");
}

export const supabase = createClient(
  supabaseUrl || '''',
  supabaseAnonKey || ''''
);

export const dataClient = supabase;
// FILE: types.ts
// src/layers/gamma/lib/types.ts
export interface TenantConfig {
    id: string;
    slug: string;
    nombre_comercial: string;
    color_tema: string;
    payload: any;
    node_path?: string;
}

export interface NodeData {
    id: string;
    titulo_que: string;
    descripcion_como: string;
    url_media: string;
    tipo_media: ''video'' | ''imagen'';
}
// FILE: via51-orchestrator.ts
// path: src/lib/via51-orchestrator.ts

import { createClient } from ''@supabase/supabase-js'';

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

/**
 * resolveNodeRegistry
 * Intenta una consulta agnÃ³stica probando ambos esquemas (el viejo y el fractal).
 */
export const resolveNodeRegistry = async (hostname: string) => {
  // Intentamos la query con el estÃ¡ndar VÃA51 (node_name)
  let { data, error } = await supabase
    .from(''sys_registry'')
    .select(''node_name, tier, config'')
    .eq(''hostname'', hostname)
    .single();

  // Si falla por columna inexistente (Error 42703), intentamos el esquema legacy
  if (error && error.code === ''42703'') {
    const legacyRequest = await supabase
      .from(''sys_registry'')
      .select(''node_tree, tier, config'')
      .eq(''hostname'', hostname)
      .single();
    
    if (!legacyRequest.error && legacyRequest.data) {
      return {
        // Mapeamos node_tree a node_name para que el resto de la app sea agnÃ³stica
        node_name: legacyRequest.data.node_tree,
        tier: legacyRequest.data.tier,
        config: legacyRequest.data.config,
        isLegacy: true
      };
    }
  }

  return data;
};

// FILE: v51-client.ts
// Path: /src/lib/supabase/v51-client.ts
// Name: V51_Supabase_Secure_Client
// Identity: Comas, Lima, Peru | 2026-03-31 18:58:00

import { createClient } from ''@supabase/supabase-js'';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

/**
 * Root Owner Check: 9157ae13-36ac-4259-9680-1d9bd2cada4a
 * Este cliente inicializa la conexiÃ³n validando el aislamiento por hostname.
 */
export const getV51Client = (tenantId?: string) => {
  return createClient(supabaseUrl, supabaseAnonKey, {
    global: {
      headers: {
        ''x-v51-tenant-id'': tenantId || ''UNKNOWN'',
      },
    },
  });
};

/**
 * Ejemplo de Query con RLS dinÃ¡mico:
 * SELECT * FROM sys_events WHERE tenant_id = current_setting(''request.headers'')::json->>''x-v51-tenant-id'';
 */
export const fetchNodeConfig = async (hostname: string) => {
  const supabase = getV51Client();
  
  const { data, error } = await supabase
    .from(''sys_registry'')
    .select(''*'')
    .eq(''node_domain'', hostname)
    .single();

  if (error) throw new Error(`CRITICAL_FAILURE: Node ${hostname} isolation breach attempt.`);
  return data;
};

// FILE: useSystemStream.ts
/**
 * SHARED HOOK: useSystemStream
 * FunciÃ³n: Monitoreo del pulso vital del sistema (Pilares y Emergencias).
 * Norma: Agnosticismo de Datos y Tipado Fuerte.
 */

import { useEffect, useState, useCallback } from ''react'';
import { dataClient } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';

// 1. DefiniciÃ³n de Interfaces (SoberanÃ­a del Dato)
interface Node {
    id: string;
    type: ''political'' | ''social'' | ''productive'';
    is_active: boolean;
    is_emergency: boolean;
    payload: any;
}

interface SystemState {
    pillars: {
        political?: Node;
        social?: Node;
        productive?: Node;
    };
    critical_event: Node | null;
}

export function useSystemStream() {
    const [data, setData] = useState<SystemState>({
        pillars: {},
        critical_event: null
    });
    const [config, setConfig] = useState({ is_critical_mode: false });
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);

    // 2. FunciÃ³n de Carga Memoizada (Estabilidad Beta)
    const fetchEngineState = useCallback(async () => {
        try {
            // EjecuciÃ³n paralela para optimizar latencia
            const [configRes, nodesRes] = await Promise.all([
                dataClient.from(SCHEMA.TABLES.CONFIG).select(''*'').single(),
                dataClient.from(SCHEMA.TABLES.REGISTRY).select(''*'').eq(''is_active'', true)
            ]);

            if (configRes.error) throw configRes.error;
            if (nodesRes.error) throw nodesRes.error;

            const engineConfig = configRes.data;
            const nodes: Node[] = nodesRes.data || [];

            setConfig({
                is_critical_mode: engineConfig?.operational_mode === ''CRITICAL''
            });

            setData({
                pillars: {
                    political: nodes.find(n => n.type === ''political''),
                    social: nodes.find(n => n.type === ''social''),
                    productive: nodes.find(n => n.type === ''productive''),
                },
                critical_event: nodes.find(n => n.is_emergency === true) || null
            });

        } catch (err: any) {
            console.error("[VÃA51-CORE] Stream Error:", err.message);
            setError(err);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        // InicializaciÃ³n SÃ­ncrona
        fetchEngineState();

        // 3. SuscripciÃ³n Real-time Optimizada
        const canal = dataClient
            .channel(''system-pulse'')
            .on(''postgres_changes'',
                {
                    event: ''*'',
                    schema: ''public'',
                    table: SCHEMA.TABLES.CONFIG
                },
                () => fetchEngineState()
            )
            .on(''postgres_changes'',
                {
                    event: ''*'',
                    schema: ''public'',
                    table: SCHEMA.TABLES.REGISTRY
                },
                () => fetchEngineState()
            )
            .subscribe();

        return () => {
            dataClient.removeChannel(canal);
        };
    }, [fetchEngineState]);

    return { data, config, loading, error };
}
// FILE: supabaseClient.ts
import { createClient } from ''@supabase/supabase-js'';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
    console.warn("ADVERTENCIA: Credenciales de Supabase no detectadas en el entorno.");
}

export const supabase = createClient(supabaseUrl || '''', supabaseAnonKey || '''');
// FILE: heat.map.ts
/**
 * VIA51 ANTIGRAVITY - Heat Map Visualizer
 * Nivel: GAMMA (VisualizaciÃ³n de Datos)
 */

import { GeoMetrics } from ''../intel/reporting.engine'';

export class HeatMapProcessor {
    private static heatMatrix: Map<string, number> = new Map();

    public static updateMatrix(data: GeoMetrics): void {
        const current = this.heatMatrix.get(data.region) || 0;
        const newIntensity = Math.min(current + 1, 100);
        this.heatMatrix.set(data.region, newIntensity);
        this.renderTerminalStatus(data.region, newIntensity);
    }

    private static renderTerminalStatus(region: string, intensity: number): void {
        const color = intensity > 80 ? ''CRITICAL-RED'' : intensity > 40 ? ''ALERT-ORANGE'' : ''STABLE-BLUE'';
        console.log(`[HEAT-UPDATE] ${region}: ${intensity}% Intensity [${color}]`);
    }

    public static getFullHeatData(): { region: string, intensity: number }[] {
        return Array.from(this.heatMatrix.entries()).map(([region, intensity]) => ({
            region,
            intensity
        }));
    }
}
// FILE: vite.config.ts
import { defineConfig } from "vite"
import react from "@vitejs/plugin-react"

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5151,
    host: "127.0.0.1",
    strictPort: true
  }
})
// FILE: MediaProcessor.ts
import { supabase } from ''@/lib/supabase''

export const MediaProcessor = {
  async processToWebP(file: File) {
    console.log(`[PROCESSOR]: Iniciando transmutaciÃ³n de ${file.name} a WebP...`);
    return file; 
  },

  async syncGalleries() {
    const { data: queue } = await supabase.storage.from(''via51-assets'').list(''queue'');
    const { data: processed } = await supabase.storage.from(''via51-assets'').list(''processed'');
    return { queue, processed };
  }
}
// FILE: supabase.ts
import { createClient } from ''@supabase/supabase-js'';

// Acceso directo con bypass de tipos para Vercel
const supabaseUrl = (import.meta as any).env.VITE_SUPABASE_URL;
const supabaseAnonKey = (import.meta as any).env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl || '''', supabaseAnonKey || '''');
// FILE: FractalUploader.tsx
import { useState, useCallback } from ''react'';
import { supabase } from ''@/lib/supabase'';
import { motion } from ''framer-motion'';

export const FractalUploader = () => {
    const [uploading, setUploading] = useState(false);
    const [progress, setProgress] = useState(0);
    const [status, setStatus] = useState(''READY_FOR_INJECTION'');

    const uploadAsset = async (event: React.ChangeEvent<HTMLInputElement>) => {
        try {
            setUploading(true);
            setStatus(''ANALYZING_FRACTAL_DATA...'');

            if (!event.target.files || event.target.files.length === 0) return;
            const file = event.target.files[0];
            const fileExt = file.name.split(''.'').pop();
            const fileName = `${Math.random()}-${Date.now()}.${fileExt}`;
            const filePath = `high-res/${fileName}`;

            // 1. Subida al Storage del Bunker
            const { error: uploadError, data } = await supabase.storage
                .from(''via51-assets'')
                .upload(filePath, file, {
                    cacheControl: ''3600'',
                    upsert: false
                });

            if (uploadError) throw uploadError;

            // 2. Registro Vinculante en sys_contributions
            setStatus(''REGISTERING_IN_BUNKER...'');
            await supabase.from(''sys_contributions'').insert([{
                contributor_id: ''RENZO_8'',
                asset_url: data.path,
                metadata: { size: file.size, type: file.type, name: file.name },
                status: ''ACTIVE''
            }]);

            // 3. Registro de Evento de Sistema
            await supabase.from(''dev_sys_events'').insert([{
                event_type: ''ASSET_INJECTED'',
                description: `New High-Res asset: ${file.name} (ID: ${fileName})`,
                created_by: ''RENZO_8''
            }]);

            setStatus(''INJECTION_COMPLETE_100%'');
        } catch (error: any) {
            setStatus(`ERROR: ${error.message}`);
        } finally {
            setUploading(false);
        }
    };

    return (
        <div className="mt-8 border-2 border-dashed border-v51-gold/20 p-8 bg-v51-void/50 text-center group hover:border-v51-gold/50 transition-all">
            <input
                type="file"
                id="fractal-upload"
                className="hidden"
                onChange={uploadAsset}
                disabled={uploading}
            />
            <label htmlFor="fractal-upload" className="cursor-pointer">
                <motion.div
                    animate={uploading ? { opacity: [0.5, 1, 0.5] } : {}}
                    transition={{ repeat: Infinity, duration: 1 }}
                >
                    <p className="text-v51-gold font-mono text-xs tracking-widest mb-2">
                        {status}
                    </p>
                    <p className="text-gray-500 text-[10px] uppercase">
                        Arrastra o selecciona activos de Calidad Mundial (AVIF, WEBP, MP4)
                    </p>
                </motion.div>
            </label>

            {uploading && (
                <div className="mt-4 w-full bg-v51-gold/5 h-[1px] relative">
                    <motion.div
                        className="absolute top-0 left-0 bg-v51-gold h-full"
                        initial={{ width: 0 }}
                        animate={{ width: ''100%'' }}
                        transition={{ duration: 2 }}
                    />
                </div>
            )}
        </div>
    );
};
// FILE: BindingNotification.tsx
import { useEffect, useState } from ''react'';
import { supabase } from ''@/lib/supabase'';
import { motion, AnimatePresence } from ''framer-motion'';

export const BindingNotification = () => {
  const [notification, setNotification] = useState(null);

  useEffect(() => {
    const channel = supabase
      .channel(''binding_echo'')
      .on(''postgres_changes'', 
        { event: ''INSERT'', schema: ''public'', table: ''sys_events'' }, 
        (payload) => {
          triggerNotification(payload.new);
        }
      )
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, []);

  const triggerNotification = (event) => {
    setNotification(event);
    // Auto-ocultar después de 6 segundos
    setTimeout(() => setNotification(null), 6000);
  };

  return (
    <div className="fixed bottom-10 right-10 z-[300] pointer-events-none">
      <AnimatePresence>
        {notification && (
          <motion.div
            initial={{ opacity: 0, x: 100, filter: ''blur(10px)'' }}
            animate={{ opacity: 1, x: 0, filter: ''blur(0px)'' }}
            exit={{ opacity: 0, scale: 0.8, filter: ''blur(10px)'' }}
            className="w-80 p-4 bg-v51-void/80 backdrop-blur-2xl border-l-2 border-v51-gold shadow-[0_0_30px_rgba(212,175,55,0.1)] pointer-events-auto"
          >
            <div className="flex items-center gap-3 mb-2">
              <div className="w-2 h-2 bg-v51-gold animate-pulse" />
              <span className="text-[10px] font-mono text-v51-gold tracking-[0.3em] uppercase">
                {notification.event_type}
              </span>
            </div>
            <p className="text-[11px] text-gray-300 font-light leading-relaxed mb-3">
              {notification.description}
            </p>
            <div className="flex justify-between items-center border-t border-white/5 pt-2">
              <span className="text-[8px] font-mono text-v51-copper uppercase">
                Origin: {notification.created_by}
              </span>
              <span className="text-[8px] font-mono text-gray-600">
                {new Date(notification.created_at).toLocaleTimeString()}
              </span>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};
// FILE: EventStream.tsx
import { useEffect, useState } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const EventStream = () => {
    const [events, setEvents] = useState<any[]>([]);

    useEffect(() => {
        // SuscripciÃ³n en tiempo real al Bunker
        const channel = supabase
            .channel(''public:sys_events'')
            .on(''postgres_changes'', { event: ''INSERT'', schema: ''public'', table: ''sys_events'' },
                payload => setEvents(prev => [payload.new, ...prev].slice(0, 5)))
            .subscribe();

        return () => { supabase.removeChannel(channel); };
    }, []);

    return (
        <div className="font-mono text-[10px] text-v51-gold/50 overflow-hidden h-12">
            <div className="animate-pulse flex gap-4 items-center">
                <span className="bg-v51-gold h-2 w-2 rounded-full" />
                <span>LIVE SYSTEM FEED:</span>
                {events.length > 0 ? (
                    <span>{events[0].event_type} - {events[0].description}</span>
                ) : (
                    <span>Awaiting signal from via51-fractal-engine...</span>
                )}
            </div>
        </div>
    );
};
// FILE: AssetStressTest.tsx
import { useState } from ''react'';
import { MediaEngine } from ''@/drivers/MediaEngine'';

export const AssetStressTest = () => {
    const [status, setStatus] = useState(''IDLE'');
    const [preview, setPreview] = useState<string | null>(null);

    const runTest = async () => {
        setStatus(''LOADING_FRACTAL_ASSETS...'');
        try {
            // Prueba con un asset de alta carga (ej. el Shader de la Triada)
            const url = await MediaEngine.loadHighRes(''visuals/triada-core-8k.webp'', ''HIGH'') as string;
            setPreview(url);
            setStatus(''SUCCESS: 100% RENDERED'');
        } catch (err) {
            setStatus(''ERROR: SIGNAL_LOST'');
        }
    };

    return (
        <div className="mt-6 border border-v51-gold/20 p-4 bg-v51-void">
            <h3 className="text-v51-gold font-mono mb-4 text-[10px]">MEDIA_STRESS_TEST</h3>
            <div className="flex gap-4 items-center">
                <button
                    onClick={runTest}
                    className="bg-v51-gold/10 hover:bg-v51-gold/30 border border-v51-gold px-4 py-2 text-[10px] transition-all"
                >
                    EJECUTAR SECUENCIA DE CARGA
                </button>
                <span className="font-mono text-[10px] text-v51-copper">{status}</span>
            </div>

            {preview && (
                <div className="mt-4 relative h-32 w-full overflow-hidden border border-white/5">
                    <img src={preview} alt="Test" className="object-cover w-full h-full opacity-50" />
                    <div className="absolute inset-0 bg-gradient-to-t from-black to-transparent" />
                </div>
            )}
        </div>
    );
};
// FILE: DesignSystemEditor.tsx
import { useState } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const DesignSystemEditor = ({ node }: { node: string }) => {
  const [config, setConfig] = useState({
    textSize: ''text-2xl'',
    primaryColor: ''#D4AF37'',
    alignment: ''items-center'',
    showMobileImage: true,
    padding: ''py-20''
  });

  const save = async (newConfig: any) => {
    setConfig(newConfig);
    await supabase.from(''sys_registry'').update({ value: newConfig }).eq(''key'', `ui_config_${node.toLowerCase()}`);
  };

  return (
    <div className="p-6 bg-v51-void border border-v51-gold/20 font-mono text-[10px]">
      <h3 className="text-v51-gold mb-6 tracking-widest uppercase">Visual_Engine_Controller: {node}</h3>
      
      <div className="space-y-6">
        <div>
          <label className="block text-gray-500 mb-2">TEXT_SIZE</label>
          <select className="bg-black border border-white/10 text-white p-2 w-full" 
            onChange={(e) => save({...config, textSize: e.target.value})}>
            <option value="text-sm">Small</option>
            <option value="text-xl">Medium</option>
            <option value="text-4xl">Large</option>
            <option value="text-7xl">Colossal</option>
          </select>
        </div>

        <div>
          <label className="block text-gray-500 mb-2">PRIMARY_COLOR</label>
          <input type="color" className="w-full h-8 bg-transparent" 
            onChange={(e) => save({...config, primaryColor: e.target.value})} />
        </div>

        <div>
          <label className="block text-gray-500 mb-2">MOBILE_IMAGE_VISIBILITY</label>
          <button className={`px-4 py-1 border ${config.showMobileImage ? ''border-green-500 text-green-500'' : ''border-red-500 text-red-500''}`}
            onClick={() => save({...config, showMobileImage: !config.showMobileImage})}>
            {config.showMobileImage ? ''VISIBLE'' : ''HIDDEN''}
          </button>
        </div>
      </div>
    </div>
  );
};
// FILE: DevShell.tsx
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const DevShell = () => {
    const [logs, setLogs] = useState<any[]>([]);
    const [command, setCommand] = useState('''');

    // Escucha activa de eventos de desarrollo (dev_sys_events)
    useEffect(() => {
        const sub = supabase
            .channel(''dev_logs'')
            .on(''postgres_changes'', { event: ''INSERT'', schema: ''public'', table: ''dev_sys_events'' },
                p => setLogs(prev => [p.new, ...prev]))
            .subscribe();
        return () => { supabase.removeChannel(sub); };
    }, []);

    const executeCommand = async (e: React.FormEvent) => {
        e.preventDefault();
        // InyecciÃ³n de evento utilitario
        await supabase.from(''dev_sys_events'').insert([
            { event_type: ''CMD_EXEC'', description: command, created_by: ''RENZO_8'' }
        ]);
        setCommand('''');
    };

    return (
        <div className="bg-[#050505] min-h-screen p-4 font-mono text-[12px] text-green-500 border-t-2 border-v51-gold">
            <div className="flex justify-between border-b border-green-900 pb-2 mb-4">
                <span>VIA51_ANTIGRAVITY // DEV_MODE // ALFA_NODE</span>
                <span className="animate-pulse">â— SYSTEM_LIVE</span>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                {/* Monitor de Bunker */}
                <div className="border border-green-900 p-4 bg-black/50">
                    <h2 className="text-v51-gold mb-2 underline">BUNKER_STATUS (sys_registry)</h2>
                    <RegistryList />
                </div>

                {/* Consola de Logs */}
                <div className="border border-green-900 p-4 h-[400px] overflow-y-auto flex flex-col-reverse">
                    {logs.map((log, i) => (
                        <div key={i} className="mb-1 border-l border-green-800 pl-2">
                            <span className="text-gray-500">[{new Date(log.created_at).toLocaleTimeString()}]</span>{'' ''}
                            <span className="text-v51-copper">{log.event_type}:</span> {log.description}
                        </div>
                    ))}
                </div>
            </div>

            {/* Input de Comando Vinculante */}
            <form onSubmit={executeCommand} className="mt-4 flex gap-2">
                <span className="text-v51-gold">{''>''}</span>
                <input
                    className="bg-transparent border-none outline-none w-full text-green-400"
                    value={command}
                    onChange={(e) => setCommand(e.target.value)}
                    placeholder="Ingrese comando de estructuraciÃ³n..."
                    autoFocus
                />
            </form>
        </div>
    );
};
// FILE: FractalAdvisor.tsx
import { motion, AnimatePresence } from ''framer-motion'';
import { useFractalIntelligence } from ''@/hooks/useFractalIntelligence'';

export const FractalAdvisor = () => {
  const { insights, analyzing, refresh } = useFractalIntelligence();

  return (
    <div className="w-full bg-v51-void/50 border border-v51-gold/10 p-6 backdrop-blur-md">
      <div className="flex justify-between items-center mb-6">
        <div className="flex items-center gap-3">
          <div className={`w-2 h-2 rounded-full ${analyzing ? ''bg-v51-gold animate-ping'' : ''bg-v51-gold''}`} />
          <h3 className="text-v51-gold font-mono text-[10px] tracking-[0.4em]">ANTIGRAVITY_INTELLIGENCE_FEED</h3>
        </div>
        <button onClick={refresh} className="text-[9px] text-v51-copper hover:text-white transition-colors font-mono">
          [ RE_SCAN_SYSTEM ]
        </button>
      </div>

      <div className="space-y-4">
        <AnimatePresence>
          {insights.map((insight) => (
            <motion.div
              key={insight.id}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              className="p-3 border-l border-v51-gold/30 bg-white/5 hover:bg-v51-gold/5 transition-all cursor-help group"
            >
              <div className="flex justify-between mb-1">
                <span className="text-[8px] font-mono text-v51-gold">{insight.type}</span>
                <span className="text-[8px] font-mono text-gray-600 group-hover:text-v51-copper">DECRYPTED</span>
              </div>
              <p className="text-[10px] text-gray-300 font-light leading-relaxed">
                {insight.message}
              </p>
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
    </div>
  );
};
// FILE: FractalGallery.tsx
import { useEffect, useState } from ''react'';
import { supabase } from ''@/lib/supabase'';
import { motion, AnimatePresence } from ''framer-motion'';
import { MediaEngine } from ''@/drivers/MediaEngine'';

export const FractalGallery = () => {
  const [assets, setAssets] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selected, setSelected] = useState(null);

  useEffect(() => {
    fetchAssets();
  }, []);

  const fetchAssets = async () => {
    const { data, error } = await supabase
      .from(''sys_contributions'')
      .select(''*'')
      .order(''created_at'', { ascending: false });
    
    if (!error) setAssets(data);
    setLoading(false);
  };

  return (
    <div className="p-6 bg-v51-black min-h-screen text-white">
      <header className="mb-12 flex justify-between items-end">
        <div>
          <h2 className="text-v51-gold font-mono text-2xl tracking-tighter">GALLERY_COMMAND_CENTER</h2>
          <p className="text-[10px] text-v51-copper uppercase tracking-[0.3em]">Bunker: via51-assets / Node: BETA</p>
        </div>
        <div className="text-right font-mono text-[10px] text-gray-500">
          TOTAL_ASSETS: {assets.length}
        </div>
      </header>

      {/* Grid Fractal de Activos */}
      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
        <AnimatePresence>
          {assets.map((asset) => (
            <motion.div
              key={asset.id}
              layoutId={asset.id}
              onClick={() => setSelected(asset)}
              whileHover={{ scale: 1.05, borderColor: ''rgba(212, 175, 55, 0.5)'' }}
              className="aspect-square border border-v51-gold/10 bg-v51-void cursor-pointer overflow-hidden relative group"
            >
              <img 
                src={MediaEngine.optimizeAsset(asset.asset_url)} 
                className="object-cover w-full h-full opacity-60 group-hover:opacity-100 transition-opacity"
              />
              <div className="absolute bottom-0 left-0 right-0 p-2 bg-black/80 translate-y-full group-hover:translate-y-0 transition-transform">
                <p className="text-[8px] font-mono truncate">{asset.metadata.name}</p>
              </div>
            </motion.div>
          ))}
        </AnimatePresence>
      </div>

      {/* Modal de Inspección de Alta Gama */}
      {selected && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-10 bg-black/90 backdrop-blur-xl">
          <motion.div 
            layoutId={selected.id}
            className="bg-v51-void border border-v51-gold/30 p-1 max-w-5xl w-full relative"
          >
            <button 
              onClick={() => setSelected(null)}
              className="absolute -top-10 right-0 text-v51-gold font-mono hover:text-white"
            >
              [ CLOSE_SIGNAL ]
            </button>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 p-6">
              <div className="md:col-span-2">
                <img src={MediaEngine.optimizeAsset(selected.asset_url)} className="w-full h-auto shadow-2xl" />
              </div>
              <div className="space-y-4 font-mono">
                <h3 className="text-v51-gold text-sm underline">METADATA_DECRYPTED</h3>
                <div className="text-[10px] space-y-2 text-gray-400">
                  <p><span className="text-v51-copper">ID:</span> {selected.id}</p>
                  <p><span className="text-v51-copper">CONTRIBUTOR:</span> {selected.contributor_id}</p>
                  <p><span className="text-v51-copper">TYPE:</span> {selected.metadata.type}</p>
                  <p><span className="text-v51-copper">SIZE:</span> {(selected.metadata.size / 1024 / 1024).toFixed(2)} MB</p>
                </div>
                <button className="w-full py-2 border border-v51-gold/20 hover:bg-v51-gold/10 text-[10px] text-v51-gold transition-all">
                  VINCULAR A CARTA MAGNA
                </button>
              </div>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  );
};
// FILE: GovernanceEditor.tsx
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';
import { motion } from ''framer-motion'';

export const GovernanceEditor = () => {
  const [content, setContent] = useState('''');
  const [saving, setSaving] = useState(false);
  const [status, setStatus] = useState(''READ_ONLY'');

  useEffect(() => {
    loadCartaMagna();
  }, []);

  const loadCartaMagna = async () => {
    const { data } = await supabase
      .from(''sys_registry'')
      .select(''value'')
      .eq(''key'', ''carta_magna_2_0'')
      .single();
    if (data) setContent(data.value.text);
  };

  const commitChanges = async () => {
    setSaving(true);
    setStatus(''COMMITTING_TO_BUNKER...'');
    
    // 1. Actualizar Registro
    const { error } = await supabase
      .from(''sys_registry'')
      .update({ value: { text: content }, updated_at: new Date() })
      .eq(''key'', ''carta_magna_2_0'');

    // 2. Registrar Evento Vinculante
    await supabase.from(''sys_events'').insert([{
      event_type: ''GOVERNANCE_UPDATE'',
      description: ''Carta Magna 2.0 has been re-written by Hierarchy 8'',
      created_by: ''RENZO_8''
    }]);

    if (!error) {
      setStatus(''VINCULANTE_SUCCESS'');
      setTimeout(() => setStatus(''READ_ONLY''), 3000);
    }
    setSaving(false);
  };

  return (
    <div className="p-8 border border-v51-gold/10 bg-v51-void/30 backdrop-blur-sm">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-v51-gold font-mono text-xs tracking-[0.4em]">CARTA_MAGNA_2.0_EDITOR</h3>
        <span className={`text-[9px] font-mono ${status.includes(''SUCCESS'') ? ''text-green-500'' : ''text-v51-copper''}`}>
          [{status}]
        </span>
      </div>

      <textarea
        value={content}
        onChange={(e) => setContent(e.target.value)}
        className="w-full h-96 bg-black/50 border border-v51-gold/5 p-6 font-mono text-xs text-gray-300 leading-relaxed focus:border-v51-gold/30 outline-none transition-all custom-scrollbar"
        placeholder="Escriba los nuevos nudos del Khipu digital..."
      />

      <div className="mt-6 flex justify-end gap-4">
        <button 
          onClick={loadCartaMagna}
          className="px-4 py-2 text-[10px] font-mono text-gray-500 hover:text-white transition-colors"
        >
          [ REVERT_TO_BUNKER ]
        </button>
        <motion.button
          whileTap={{ scale: 0.95 }}
          onClick={commitChanges}
          disabled={saving}
          className="px-8 py-2 bg-v51-gold/10 border border-v51-gold text-v51-gold font-mono text-[10px] hover:bg-v51-gold hover:text-black transition-all"
        >
          {saving ? ''EXECUTING...'' : ''COMMIT_VINCULANTE''}
        </motion.button>
      </div>
    </div>
  );
};
// FILE: RegistryList.tsx
const RegistryList = () => {
    const [items, setItems] = useState<any[]>([]);

    useEffect(() => {
        const fetchRegistry = async () => {
            const { data } = await supabase.from(''sys_registry'').select(''*'');
            if (data) setItems(data);
        };
        fetchRegistry();
    }, []);

    return (
        <div className="space-y-2">
            {items.map(item => (
                <div key={item.key} className="flex justify-between hover:bg-green-900/20 p-1">
                    <span className="text-gray-400">{item.key}</span>
                    <span className="text-white font-bold">{JSON.stringify(item.value)}</span>
                </div>
            ))}
        </div>
    );
};
// FILE: TriadNavigator.tsx
export const TriadNavigator = () => {
    const nodes = [
        { id: ''ALFA'', desc: ''Core / Governance'', url: ''https://via51.org'', active: true },
        { id: ''BETA'', desc: ''The Hub / Community'', url: ''https://hub.via51.org'', active: false },
        { id: ''GAMMA'', desc: ''Laboratory / Dev'', url: ''https://gamma.via51.org'', active: false },
    ];

    return (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-20 w-full max-w-5xl">
            {nodes.map((node) => (
                <motion.a
                    key={node.id}
                    href={node.url}
                    whileHover={{ y: -5, borderColor: ''rgba(212, 175, 55, 0.5)'' }}
                    className="p-6 border border-v51-gold/10 bg-v51-void/50 backdrop-blur-md rounded-sm transition-colors group"
                >
                    <h3 className="text-v51-gold font-mono text-xl mb-2">{node.id}</h3>
                    <p className="text-xs text-gray-500 group-hover:text-gray-300 transition-colors uppercase tracking-widest">
                        {node.desc}
                    </p>
                    {!node.active && (
                        <span className="text-[9px] text-v51-copper mt-4 block">ENCRIPTANDO...</span>
                    )}
                </motion.a>
            ))}
        </div>
    );
};
// FILE: VisualStyler.tsx
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const VisualStyler = () => {
  const [config, setConfig] = useState({
    heroTextSize: ''text-6xl'',
    heroColor: ''#D4AF37'',
    heroAlign: ''items-center'',
    showMobileImage: true
  });

  useEffect(() => {
    loadConfig();
  }, []);

  const loadConfig = async () => {
    const { data } = await supabase.from(''sys_registry'').select(''value'').eq(''key'', ''alfa_ui_config'').single();
    if (data) setConfig(data.value);
  };

  const updateConfig = async (newConfig) => {
    setConfig(newConfig);
    await supabase.from(''sys_registry'').update({ value: newConfig }).eq(''key'', ''alfa_ui_config'');
    await supabase.from(''sys_events'').insert([{ event_type: ''UI_RECONFIGURED'', description: ''Visual styles updated via HUB'', created_by: ''RENZO_8'' }]);
  };

  return (
    <div className="p-6 bg-v51-void/50 border border-v51-gold/10 font-mono">
      <h3 className="text-v51-gold text-xs tracking-widest mb-6 underline">VISUAL_CONFIGURATOR_BETA</h3>
      
      <div className="space-y-6">
        {/* Tamaño de Texto */}
        <div>
          <label className="text-[10px] text-gray-500 block mb-2">HERO_TEXT_SIZE</label>
          <select 
            value={config.heroTextSize} 
            onChange={(e) => updateConfig({...config, heroTextSize: e.target.value})}
            className="bg-black border border-v51-gold/20 text-v51-gold text-xs p-2 w-full"
          >
            <option value="text-4xl">SMALL</option>
            <option value="text-6xl">NORMAL</option>
            <option value="text-8xl">MASSIVE (8K)</option>
          </select>
        </div>

        {/* Color Principal */}
        <div>
          <label className="text-[10px] text-gray-500 block mb-2">PRIMARY_COLOR (HEX)</label>
          <input 
            type="color" 
            value={config.heroColor}
            onChange={(e) => updateConfig({...config, heroColor: e.target.value})}
            className="w-full h-10 bg-transparent border border-v51-gold/20 cursor-pointer"
          />
        </div>

        {/* Ubicación Relativa */}
        <div>
          <label className="text-[10px] text-gray-500 block mb-2">RELATIVE_ALIGNMENT</label>
          <div className="flex gap-2">
            {[''items-start'', ''items-center'', ''items-end''].map(align => (
              <button 
                key={align}
                onClick={() => updateConfig({...config, heroAlign: align})}
                className={`flex-1 py-2 text-[8px] border ${config.heroAlign === align ? ''bg-v51-gold text-black'' : ''border-v51-gold/20 text-v51-gold''}`}
              >
                {align.split(''-'')[1].toUpperCase()}
              </button>
            ))}
          </div>
        </div>

        {/* Visibilidad Móvil */}
        <div className="flex justify-between items-center p-3 border border-v51-gold/5 bg-black/20">
          <span className="text-[10px] text-gray-400">SHOW_VERTICAL_IMAGE_ON_MOBILE</span>
          <input 
            type="checkbox" 
            checked={config.showMobileImage}
            onChange={(e) => updateConfig({...config, showMobileImage: e.target.checked})}
            className="accent-v51-gold"
          />
        </div>
      </div>
    </div>
  );
};
// FILE: FractalField.tsx
import { useRef } from ''react'';
import { Canvas, useFrame } from ''@react-three/fiber'';
import { Points, PointMaterial } from ''@react-three/drei'';
import * as random from ''maath/random/dist/maath-random.esm'';

function ParticleField() {
  const ref = useRef();
  const [sphere] = useState(() => random.inSphere(new Float32Array(5000), { radius: 1.5 }));

  useFrame((state, delta) => {
    ref.current.rotation.x -= delta / 10;
    ref.current.rotation.y -= delta / 15;
  });

  return (
    <group rotation={[0, 0, Math.PI / 4]}>
      <Points ref={ref} positions={sphere} stride={3} frustumCulled={false}>
        <PointMaterial transparent color="#D4AF37" size={0.005} sizeAttenuation={true} depthWrite={false} />
      </Points>
    </group>
  );
}

export const FractalField = () => (
  <div className="absolute inset-0 z-0">
    <Canvas camera={{ position: [0, 0, 1] }}>
      <ParticleField />
    </Canvas>
  </div>
);
import { useState } from ''react'';
// FILE: BetaSidebar.tsx
import { motion } from ''framer-motion'';

export const BetaSidebar = () => {
  const levels = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
  return (
    <div className="w-20 h-screen border-r border-v51-gold/10 flex flex-col items-center py-8 bg-v51-void">
      <div className="mb-12">
        <div className="w-8 h-8 border border-v51-gold rotate-45 flex items-center justify-center">
          <span className="rotate-[-45deg] text-[10px] font-bold text-v51-gold">V51</span>
        </div>
      </div>
      <div className="flex-1 flex flex-col gap-4">
        {levels.map((lvl) => (
          <motion.div
            key={lvl}
            whileHover={{ scale: 1.2, color: ''#D4AF37'' }}
            className={`cursor-pointer text-xs font-mono ${lvl === 8 ? ''text-v51-gold'' : ''text-gray-600''}`}
          >
            {lvl === 8 && <span className="absolute -left-2 text-[8px]">▶</span>}
            0{lvl}
          </motion.div>
        ))}
      </div>
      <div className="mt-auto text-[8px] text-v51-copper font-mono vertical-text py-4">
        BETA_NODE_ACTIVE
      </div>
    </div>
  );
};
// FILE: FractalLayout.tsx
import { motion } from ''framer-motion'';
import { QuantumNavigator } from ''@/components/navigation/QuantumNavigator'';
import { BindingNotification } from ''@/components/data/BindingNotification'';
import { HierarchyAura } from ''@/components/visuals/HierarchyAura'';

export const FractalLayout = ({ children, nodeType }: { children: React.ReactNode, nodeType: string }) => {
  return (
    <div className="min-h-screen bg-[#050505] text-white overflow-hidden relative font-antigravity">
      {/* Capas de Jerarquía y Control */}
      <HierarchyAura />
      <QuantumNavigator />
      <BindingNotification />

      {/* Capa de Fondo Dinámica */}
      <div className={`absolute inset-0 opacity-20 pointer-events-none z-0 ${
        nodeType === ''ALFA'' ? ''bg-[radial-gradient(circle_at_center,#D4AF37_0%,transparent_70%)]'' :
        nodeType === ''BETA'' ? ''bg-[radial-gradient(circle_at_center,#B87333_0%,transparent_70%)]'' :
        ''bg-[radial-gradient(circle_at_center,#ffffff_0%,transparent_70%)]''
      }`} />

      <motion.main 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="relative z-10"
      >
        {children}
      </motion.main>
    </div>
  );
};
// FILE: QuantumNavigator.tsx
import { useState } from ''react'';
import { motion, AnimatePresence } from ''framer-motion'';
import { useRouter } from ''next/router'';

export const QuantumNavigator = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isLeaping, setIsLeaping] = useState(false);
  const router = useRouter();

  const nodes = [
    { id: ''ALFA'', path: ''/'', label: ''CORE_REALITY'', color: ''#D4AF37'' },
    { id: ''BETA'', path: ''/beta'', label: ''OPERATIONAL_HUB'', color: ''#B87333'' },
    { id: ''GAMMA'', path: ''/gamma'', label: ''LAB_EXPERIMENTAL'', color: ''#FFFFFF'' }
  ];

  const handleLeap = (path: string) => {
    setIsLeaping(true);
    setIsOpen(false);
    setTimeout(() => {
      router.push(path);
      setTimeout(() => setIsLeaping(false), 1000);
    }, 800);
  };

  return (
    <>
      {/* Botón de Acceso al Portal */}
      <div className="fixed top-6 left-1/2 -translate-x-1/2 z-[100]">
        <motion.button
          whileHover={{ scale: 1.1, letterSpacing: ''0.5em'' }}
          onClick={() => setIsOpen(!isOpen)}
          className="px-6 py-2 border border-v51-gold/30 bg-black/50 backdrop-blur-xl text-[10px] text-v51-gold font-mono tracking-[0.3em] uppercase transition-all"
        >
          {isOpen ? ''[ CLOSE_PORTAL ]'' : ''[ NODE_JUMP ]''}
        </motion.button>
      </div>

      {/* Menú del Portal */}
      <AnimatePresence>
        {isOpen && (
          <motion.div 
            initial={{ opacity: 0, backdropFilter: ''blur(0px)'' }}
            animate={{ opacity: 1, backdropFilter: ''blur(20px)'' }}
            exit={{ opacity: 0, backdropFilter: ''blur(0px)'' }}
            className="fixed inset-0 z-[90] bg-black/60 flex items-center justify-center"
          >
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 p-10">
              {nodes.map((node) => (
                <motion.div
                  key={node.id}
                  whileHover={{ y: -10 }}
                  onClick={() => handleLeap(node.path)}
                  className="group cursor-pointer p-8 border border-white/5 bg-v51-void/80 hover:border-v51-gold/50 transition-all text-center w-64"
                >
                  <h3 className="text-4xl font-bold text-white/20 group-hover:text-v51-gold transition-colors mb-4">{node.id}</h3>
                  <p className="text-[9px] font-mono text-v51-copper tracking-widest">{node.label}</p>
                  <div className="mt-6 h-[1px] w-0 group-hover:w-full bg-v51-gold transition-all duration-500 mx-auto" />
                </motion.div>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Efecto Visual: Salto Cuántico */}
      <AnimatePresence>
        {isLeaping && (
          <motion.div 
            initial={{ scale: 0, opacity: 0, borderRadius: ''100%'' }}
            animate={{ scale: 4, opacity: 1, borderRadius: ''0%'' }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.8, ease: [0.76, 0, 0.24, 1] }}
            className="fixed inset-0 z-[200] bg-v51-gold flex items-center justify-center"
          >
             <div className="text-black font-mono text-2xl font-bold tracking-[1em] animate-pulse">
               LEAPING...
             </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};
// FILE: HeroSingularity.tsx
import { motion } from ''framer-motion'';

export const HeroSingularity = () => {
    return (
        <div className="relative flex items-center justify-center h-64 w-64">
            {/* Anillos Fractales */}
            {[...Array(3)].map((_, i) => (
                <motion.div
                    key={i}
                    className="absolute border border-v51-gold/30 rounded-full"
                    initial={{ width: 100, height: 100, opacity: 0 }}
                    animate={{
                        width: [100, 300, 100],
                        height: [100, 300, 100],
                        opacity: [0.1, 0.5, 0.1],
                        rotate: i * 120
                    }}
                    transition={{
                        duration: 8,
                        repeat: Infinity,
                        delay: i * 2,
                        ease: "easeInOut"
                    }}
                />
            ))}
            <motion.div
                className="z-10 text-6xl font-bold tracking-tighter text-white"
                animate={{ scale: [0.95, 1.05, 0.95] }}
                transition={{ duration: 4, repeat: Infinity }}
            >
                VIA51
            </motion.div>
        </div>
    );
};
// FILE: HierarchyAura.tsx
import { motion } from ''framer-motion'';
import { useHierarchy } from ''@/hooks/useHierarchy'';

export const HierarchyAura = () => {
  const { level } = useHierarchy();

  if (level < 8) return null;

  return (
    <div className="fixed inset-0 pointer-events-none z-[400]">
      {/* Marco de Poder Astral */}
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="absolute inset-0 border-[1px] border-v51-gold/20 shadow-[inset_0_0_100px_rgba(212,175,55,0.05)]"
      />
      
      {/* Indicador de Rango en Esquina Superior Derecha */}
      <motion.div 
        initial={{ y: -20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        className="absolute top-6 right-10 flex items-center gap-3"
      >
        <div className="flex flex-col items-end">
          <span className="text-[8px] font-mono text-v51-gold tracking-[0.4em] uppercase">Hierarchy_Detected</span>
          <span className="text-xs font-bold text-white tracking-widest">LEVEL_0{level}</span>
        </div>
        <div className="w-1 h-8 bg-v51-gold shadow-[0_0_10px_#D4AF37]" />
      </motion.div>

      {/* Partículas de Autoridad (Sutiles) */}
      <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-transparent via-v51-gold/50 to-transparent animate-pulse" />
    </div>
  );
};
// FILE: index.tsx
import { FractalLayout } from ''@/components/layout/FractalLayout'';
import { HeroSingularity } from ''@/components/visuals/HeroSingularity'';
import { KineticGovernance } from ''@/components/visuals/KineticGovernance'';
import { useUIConfig } from ''@/hooks/useUIConfig'';

export default function AlfaLanding() {
  const ui = useUIConfig(''ALFA'');

  return (
    <FractalLayout nodeType="ALFA">
      <section className={`flex flex-col ${ui.alignment} justify-center min-h-screen ${ui.padding}`} style={{ color: ui.primaryColor }}>
        
        {/* Imagen/Hero con visibilidad dinámica */}
        <div className={`${ui.showMobileImage ? ''block'' : ''hidden md:block''}`}>
          <HeroSingularity />
        </div>
        
        <div className={`mt-12 transition-all duration-1000 ${ui.textSize}`}>
          <KineticGovernance />
        </div>

      </section>
    </FractalLayout>
  );
}
// FILE: index.tsx
import { useState } from ''react'';
import { BetaSidebar } from ''@/components/layout/BetaSidebar'';
import { FractalGallery } from ''@/components/dev/FractalGallery'';
import { GovernanceEditor } from ''@/components/dev/GovernanceEditor'';
import { FractalAdvisor } from ''@/components/dev/FractalAdvisor'';
import { EventStream } from ''@/components/data/EventStream'';

export default function BetaHub() {
  const [activeTab, setActiveTab] = useState(''GALLERY'');

  return (
    <div className="flex min-h-screen bg-v51-black overflow-hidden">
      <BetaSidebar />
      <main className="flex-1 flex flex-col relative">
        <header className="h-16 border-b border-v51-gold/5 flex items-center px-8 justify-between bg-v51-void/50 backdrop-blur-md z-10">
          <div className="flex items-center gap-4">
            <span className="text-v51-gold font-mono text-[10px] tracking-widest">OPERATOR: RENZO_8</span>
            <div className="h-4 w-[1px] bg-v51-gold/20" />
            <div className="flex gap-4">
              <button onClick={() => setActiveTab(''GALLERY'')} className={`text-[10px] font-mono ${activeTab === ''GALLERY'' ? ''text-v51-gold underline'' : ''text-gray-500''}`}>ASSET_MANAGER</button>
              <button onClick={() => setActiveTab(''GOVERNANCE'')} className={`text-[10px] font-mono ${activeTab === ''GOVERNANCE'' ? ''text-v51-gold underline'' : ''text-gray-500''}`}>GOVERNANCE_CORE</button>
            </div>
          </div>
        </header>

        <section className="flex-1 overflow-y-auto p-8 grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div className="lg:col-span-2">
            {activeTab === ''GALLERY'' ? <FractalGallery /> : <GovernanceEditor />}
          </div>
          <div className="lg:col-span-1">
            <FractalAdvisor />
          </div>
        </section>

        <footer className="h-10 border-t border-v51-gold/5 bg-v51-void px-8 flex items-center">
          <EventStream />
        </footer>
      </main>
    </div>
  );
}
// FILE: index.tsx
import { FractalField } from ''@/components/laboratory/FractalField'';
import { motion } from ''framer-motion'';
import { EventStream } from ''@/components/data/EventStream'';

export default function GammaLab() {
  return (
    <div className="relative min-h-screen bg-[#020202] text-white overflow-hidden font-mono">
      {/* Capa de Renderización Experimental */}
      <FractalField />

      {/* Interfaz de Usuario del Laboratorio */}
      <div className="relative z-10 p-10 flex flex-col h-screen">
        <header className="flex justify-between items-start border-b border-v51-gold/20 pb-6">
          <div>
            <h1 className="text-v51-gold text-2xl tracking-[0.5em] font-bold">GAMMA_NODE</h1>
            <p className="text-[10px] text-v51-copper mt-2">EXPERIMENTAL_LABORATORY // ANTIGRAVITY_PROTOTYPE</p>
          </div>
          <div className="text-right">
            <div className="text-[10px] text-gray-500">SYSTEM_LOAD: 14%</div>
            <div className="text-[10px] text-green-500 animate-pulse">NEURAL_LINK: ACTIVE</div>
          </div>
        </header>

        <main className="flex-1 flex gap-10 mt-10">
          {/* Consola de Datos Crudos */}
          <div className="w-1/3 border border-v51-gold/10 bg-black/40 backdrop-blur-md p-6">
            <h3 className="text-v51-gold text-[10px] mb-4 underline">RAW_DATA_INJECTION</h3>
            <div className="space-y-2 text-[9px] text-gray-400">
              <p className="hover:text-v51-gold cursor-crosshair">{">"} Initializing WebGL Shaders...</p>
              <p className="hover:text-v51-gold cursor-crosshair">{">"} Mapping Fractal Coordinates...</p>
              <p className="hover:text-v51-gold cursor-crosshair">{">"} Testing Latency: 12ms</p>
              <p className="text-v51-copper">{">"} Warning: Gravity Anomaly Detected</p>
            </div>
          </div>

          {/* Área de Visualización de Prototipos */}
          <div className="flex-1 border border-v51-gold/10 bg-black/20 backdrop-blur-sm flex items-center justify-center relative group">
             <div className="absolute top-4 left-4 text-[8px] text-v51-gold/30">VIEWPORT_01</div>
             <motion.div 
               animate={{ rotate: 360 }}
               transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
               className="w-48 h-48 border border-v51-gold/20 flex items-center justify-center"
             >
               <div className="w-32 h-32 border border-v51-gold/40 rotate-45" />
             </motion.div>
             <p className="absolute bottom-10 text-[10px] text-v51-gold opacity-0 group-hover:opacity-100 transition-opacity">
               PROTOTYPE_STABLE: READY FOR ALFA DEPLOYMENT
             </p>
          </div>
        </main>

        <footer className="mt-auto pt-6 border-t border-v51-gold/10">
          <EventStream />
        </footer>
      </div>
    </div>
  );
}
// FILE: index.tsx
import { FractalLayout } from ''@/components/layout/FractalLayout'';
import { HeroSingularity } from ''@/components/visuals/HeroSingularity'';
import { TriadNavigator } from ''@/components/navigation/TriadNavigator'';
import { EventStream } from ''@/components/data/EventStream'';

export default function AlfaLanding() {
    return (
        <FractalLayout nodeType="ALFA">
            <section className="relative z-20 flex flex-col items-center justify-center min-h-[70vh]">
                {/* El CorazÃ³n de la Triada */}
                <HeroSingularity />

                <div className="mt-12 text-center max-w-2xl">
                    <h2 className="text-v51-gold font-light tracking-[0.3em] text-sm mb-4">
                        ANTIGRAVITY PROTOCOL ACTIVE
                    </h2>
                    <p className="text-gray-400 font-light leading-relaxed">
                        Sincronizando la voluntad humana con la precisiÃ³n fractal.
                        Bienvenido a la infraestructura de la nueva era.
                    </p>
                </div>

                {/* NavegaciÃ³n de la Triada Fractal */}
                <TriadNavigator />
            </section>

            {/* El Pulso: Eventos en tiempo real desde el Bunker */}
            <footer className="mt-24 border-t border-v51-gold/10 pt-8">
                <EventStream />
            </footer>
        </FractalLayout>
    );
}
// FILE: App.tsx
import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AlfaPortal } from "../hangar/components/AlfaPortal";
import { SoberanaView } from "../hangar/components/SoberanaView";
import { PortalCaptura } from "../hangar/components/PortalCaptura";
import { V51Workbench } from "../hangar/components/V51Workbench";
import { registerSovereignElite } from "../core/mechanics/capture.driver";

function App() {
  const handleCapture = async (data) => {
    const res = await registerSovereignElite(data);
    if (res.success) alert("SOLICITUD RECIBIDA.");
  };

  return (
    <Router>
      <Routes>
        <Route path="/" element={<AlfaPortal />} />
        <Route path="/registro" element={<PortalCaptura onCapture={handleCapture} />} />
        <Route path="/workbench" element={<V51Workbench />} />
        <Route path="/:issueCode" element={<SoberanaView />} />
      </Routes>
    </Router>
  );
}

export default App;
// FILE: main.tsx
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
// FILE: AgnosticCapturer.tsx
import React, { useState } from ''react'';
import { supabase } from ''../lib/supabaseClient'';
import { Send, Plus, Trash2, ShieldCheck } from ''lucide-react'';

interface CapturerProps {
    selectedNode: { id: string; name: string; path: string };
    onClose: () => void;
}

const AgnosticCapturer: React.FC<CapturerProps> = ({ selectedNode, onClose }) => {
    // Estado para campos dinÃ¡micos (Agnosticismo)
    const [fields, setFields] = useState([{ key: '''', value: '''' }]);
    const [isSending, setIsSending] = useState(false);

    const addField = () => setFields([...fields, { key: '''', value: '''' }]);

    const removeField = (index: number) => {
        setFields(fields.filter((_, i) => i !== index));
    };

    const handleSendToHub = async () => {
        setIsSending(true);

        // ConstrucciÃ³n del Payload segÃºn Plano CoreVia51
        const payload = fields.reduce((acc, curr) => {
            if (curr.key) acc[curr.key] = curr.value;
            return acc;
        }, {} as Record<string, any>);

        try {
            // EnvÃ­o al HUB (Beta) - Tabla domain_data
            const { error } = await supabase.from(''domain_data'').insert({
                node_id: selectedNode.id,
                payload: payload,
                status: ''PENDIENTE'', // Estado inicial agnÃ³stico
            });

            if (error) throw error;
            alert(`Ã‰XITO: Datos enviados al nodo ${selectedNode.name}`);
            onClose();
        } catch (err) {
            console.error("ERROR DE HUB:", err);
            alert("FALLO DE VALIDACIÃ“N EN HUB BETA");
        } finally {
            setIsSending(false);
        }
    };

    return (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center p-4 z-50">
            <div className="bg-slate-900 border border-blue-500/50 w-full max-w-lg rounded-xl shadow-2xl overflow-hidden">
                {/* Cabecera de Mando */}
                <div className="bg-blue-600/20 p-4 border-b border-blue-500/30 flex justify-between items-center">
                    <div>
                        <h2 className="text-blue-400 font-black text-sm uppercase tracking-tighter">Capturador de Datos</h2>
                        <p className="text-[10px] text-slate-400">NODO DESTINO: {selectedNode.path}</p>
                    </div>
                    <button onClick={onClose} className="text-slate-500 hover:text-white">âœ•</button>
                </div>

                {/* Campos DinÃ¡micos */}
                <div className="p-6 space-y-4 max-h-[60vh] overflow-y-auto">
                    {fields.map((field, index) => (
                        <div key={index} className="flex gap-2 items-center">
                            <input
                                placeholder="Propiedad (ej: nombre_evento)"
                                className="bg-slate-800 border border-slate-700 p-2 rounded text-xs w-1/2 focus:border-blue-500 outline-none"
                                value={field.key}
                                onChange={(e) => {
                                    const newFields = [...fields];
                                    newFields[index].key = e.target.value;
                                    setFields(newFields);
                                }}
                            />
                            <input
                                placeholder="Valor"
                                className="bg-slate-800 border border-slate-700 p-2 rounded text-xs w-1/2 focus:border-blue-500 outline-none"
                                value={field.value}
                                onChange={(e) => {
                                    const newFields = [...fields];
                                    newFields[index].value = e.target.value;
                                    setFields(newFields);
                                }}
                            />
                            <button onClick={() => removeField(index)} className="text-red-500/50 hover:text-red-500">
                                <Trash2 size={16} />
                            </button>
                        </div>
                    ))}

                    <button
                        onClick={addField}
                        className="w-full py-2 border border-dashed border-slate-700 rounded text-slate-500 hover:text-blue-400 hover:border-blue-400 transition-all text-xs flex justify-center items-center gap-2"
                    >
                        <Plus size={14} /> AÃ±adir Atributo
                    </button>
                </div>

                {/* AcciÃ³n de EnvÃ­o */}
                <div className="p-4 bg-slate-800/50 border-t border-slate-800 flex justify-end gap-3">
                    <button
                        disabled={isSending}
                        onClick={handleSendToHub}
                        className="bg-blue-600 hover:bg-blue-500 text-white px-6 py-2 rounded font-bold text-xs flex items-center gap-2 transition-all disabled:opacity-50"
                    >
                        {isSending ? ''PROCESANDO EN HUB...'' : ''ENVIAR AL ECOSISTEMA''}
                        <Send size={14} />
                    </button>
                </div>
            </div>
        </div>
    );
};

export default AgnosticCapturer;
// FILE: FractalDashboard.tsx
import React, { useEffect, useState } from ''react'';
import { supabase } from ''../lib/supabaseClient'';
import { Shield, Activity, Cpu, Hexagon, Database, LayoutPanelTop } from ''lucide-react'';

export const FractalDashboard = () => {
    const [nodes, setNodes] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchNodes = async () => {
            const { data } = await supabase.from(''sys_registry'').select(''*'').order(''node_path'');
            if (data) setNodes(data);
            setLoading(false);
        };
        fetchNodes();
    }, []);

    const config = [
        { id: 0, label: ''NÃšCLEO CENTRAL'', icon: <Cpu className="text-blue-500" /> },
        { id: 1, label: ''DEPARTAMENTOS'', icon: <LayoutPanelTop className="text-emerald-500" /> },
        { id: 2, label: ''TRÃADAS OPERATIVAS'', icon: <Activity className="text-amber-500" /> },
        { id: 3, label: ''NODOS DE EJECUCIÃ“N'', icon: <Database className="text-purple-500" /> }
    ];

    if (loading) return (
        <div className="h-screen bg-[#020617] flex items-center justify-center text-blue-500 font-mono animate-pulse uppercase tracking-widest">
            Sincronizando Ecosistema VÃ­a 51...
        </div>
    );

    return (
        <div className="min-h-screen bg-[#020617] p-10 font-sans selection:bg-blue-500/30">
            <header className="flex justify-between items-end mb-16 border-b border-slate-800 pb-8">
                <div>
                    <h1 className="text-5xl font-black text-white tracking-tighter uppercase italic leading-none">
                        Via51 <span className="text-blue-600">Antigravity</span>
                    </h1>
                    <p className="text-slate-500 font-mono text-[10px] tracking-[0.4em] uppercase mt-3">
                        Holding Digital Soberano // Control de TrÃ¡fico Hub-Beta
                    </p>
                </div>
                <div className="flex items-center gap-4 bg-slate-900 border border-blue-500/20 px-6 py-3 rounded-xl shadow-2xl">
                    <Shield size={20} className="text-blue-500 animate-pulse" />
                    <span className="text-xs font-black uppercase text-blue-400 tracking-widest">SoberanÃ­a Activa</span>
                </div>
            </header>

            <div className="grid grid-cols-1 md:grid-cols-4 gap-10">
                {config.map((lvl) => (
                    <div key={lvl.id} className="space-y-6">
                        <div className="flex items-center gap-3 border-l-2 border-slate-700 pl-4 py-2 bg-slate-900/30 rounded-r-lg">
                            {lvl.icon}
                            <h2 className="text-xs font-black text-slate-400 tracking-widest uppercase">{lvl.label}</h2>
                        </div>
                        <div className="space-y-4">
                            {nodes.filter(n => n.level === lvl.id).map(node => (
                                <div key={node.id} className="bg-[#0a1024] border border-slate-800/80 p-5 rounded-xl transition-all hover:border-blue-500/50 group shadow-lg">
                                    <div className="flex justify-between items-start mb-4">
                                        <span className="text-[9px] font-mono text-slate-600 group-hover:text-blue-400">{node.node_path}</span>
                                        <Hexagon size={12} className="text-slate-800 group-hover:text-blue-500/40" />
                                    </div>
                                    <h3 className="text-slate-200 font-black text-sm uppercase group-hover:text-white transition-colors">
                                        {node.node_name}
                                    </h3>
                                </div>
                            ))}
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};
// FILE: FractalMap.tsx
import React from ''react'';
// Corregido:
export default function FractalMap() {
    return <div className="p-4 text-blue-400 font-mono">MAPA FRACTAL V51 // ACTIVO</div>;
}
// FILE: NodeEngine.tsx
import React from ''react'';

export const NodeEngine = ({ nodeData }: { nodeData: any }) => {
    return (
        <div className="p-6 rounded-xl bg-slate-900 border border-blue-500/30">
            <h2 className="text-white font-bold text-xl uppercase tracking-tighter">
                {nodeData?.node_name || "Nodo en Espera"}
            </h2>
            <p className="text-slate-500 text-xs mt-2 font-mono">
                PATH: {nodeData?.node_path || "root.void"}
            </p>
        </div>
    );
};
// FILE: UniversalForm.tsx
// via51-alfa/src/components/forms/UniversalForm.tsx

interface FormPayload {
    metadata: {
        nodeId: "V51-ALFA-N0",      // Nivel 0
        formType: "REGISTRATION" | "ENTRY" | "SURVEY",
        timestamp: string;
    };
    data: Record<string, any>;    // Los datos del usuario (Nombre, Email, etc.)
}

export const RegistrationForm = () => {
    const handleSubmit = async (formData: any) => {
        const payload: FormPayload = {
            metadata: {
                nodeId: "V51-ALFA-N0",
                formType: "REGISTRATION",
                timestamp: new Date().toISOString()
            },
            data: formData
        };

        // EnvÃ­o directo al INPUT DRIVER de la Caja Negra
        const response = await BlackBoxDriver.send(payload);
        return response;
    };

    // Renderizado dinÃ¡mico segÃºn el esquema del CORE
};
// FILE: AdminBetaRouter.tsx
import React, { useEffect } from ''react'';
import { useNodeStream } from ''@beta/hooks/useNodeStream'';

export default function AdminBetaRouter() {
  // Invocamos el Hook con las credenciales que encontramos
  const { data, loading } = useNodeStream();

  useEffect(() => {
    if (!loading) {
      console.log("--- TEST DE CONEXIÃ“N VÃA51 ---");
      console.log("Estado: Nodo Central Sincronizado");
      console.log("Registros detectados en Pacha:", data.length);
      console.table(data); // Esto mostrarÃ¡ los datos en una tabla limpia en consola
    }
  }, [data, loading]);

  return (
    <div style={{ padding: ''2rem'', backgroundColor: ''#050505'', color: ''#00ff00'', fontFamily: ''monospace'', minHeight: ''100vh'' }}>
      <h1>CAPA BETA: MÃ“DULO DE INGRESO</h1>
      <hr border-color="#333" />
      <div style={{ marginTop: ''1rem'' }}>
        {loading ? (
          <p>Buscando pulso de Pacha...</p>
        ) : (
          <p>ConexiÃ³n Exitosa. Se han detectado {data.length} nodos activos.</p>
        )}
      </div>
      <p style={{ fontSize: ''0.8rem'', color: ''#666'', marginTop: ''2rem'' }}>
        Presione F12 y revise la pestaÃ±a "Console" para ver el ADN de los datos.
      </p>
    </div>
  );
}

// FILE: AlphaMutationView.tsx
import React, { useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient''; // Ajusta la ruta si es necesario

interface AlphaProps {
  isOpen: boolean;
  pillar: string | null;
  onClose: () => void;
}

const AlphaMutationView: React.FC<AlphaProps> = ({ isOpen, pillar, onClose }) => {
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    // AquÃ­ irÃ­a tu lÃ³gica de insert en Supabase
    setTimeout(() => {
      setLoading(false);
      onClose();
    }, 1000);
  };

  return (
    <div className={`alpha-mutation-overlay ${isOpen ? ''active'' : ''''}`}>
      <div className="form-semilla-card">
        <h3>MUTACIÃ“N: {pillar}</h3>
        <form onSubmit={handleSubmit}>
          <input placeholder="PropÃ³sito de la Semilla" required />
          <textarea placeholder="Marco Legal" rows={3} required />
          <input placeholder="LÃ­nea de AcciÃ³n" required />
          
          <div className="form-actions">
            <button type="submit" className="btn-confirm" disabled={loading}>
              {loading ? ''SINCRONIZANDO...'' : ''INYECTAR''}
            </button>
            <button type="button" className="btn-cancel" onClick={onClose}>ABORTAR</button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AlphaMutationView;

// FILE: App.tsx
import { useState } from ''react'';
import { BetaSidebar } from ''@/components/layout/BetaSidebar'';
import { FractalGallery } from ''@/components/dev/FractalGallery'';
import { GovernanceEditor } from ''@/components/dev/GovernanceEditor'';
import { FractalAdvisor } from ''@/components/dev/FractalAdvisor'';
import { EventStream } from ''@/components/data/EventStream'';

export default function BetaHub() {
  const [activeTab, setActiveTab] = useState(''GALLERY'');

  return (
    <div className="flex min-h-screen bg-v51-black overflow-hidden">
      <BetaSidebar />
      <main className="flex-1 flex flex-col relative">
        <header className="h-16 border-b border-v51-gold/5 flex items-center px-8 justify-between bg-v51-void/50 backdrop-blur-md z-10">
          <div className="flex items-center gap-4">
            <span className="text-v51-gold font-mono text-[10px] tracking-widest">OPERATOR: RENZO_8</span>
            <div className="h-4 w-[1px] bg-v51-gold/20" />
            <div className="flex gap-4">
              <button onClick={() => setActiveTab(''GALLERY'')} className={`text-[10px] font-mono ${activeTab === ''GALLERY'' ? ''text-v51-gold underline'' : ''text-gray-500''}`}>ASSET_MANAGER</button>
              <button onClick={() => setActiveTab(''GOVERNANCE'')} className={`text-[10px] font-mono ${activeTab === ''GOVERNANCE'' ? ''text-v51-gold underline'' : ''text-gray-500''}`}>GOVERNANCE_CORE</button>
            </div>
          </div>
        </header>

        <section className="flex-1 overflow-y-auto p-8 grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div className="lg:col-span-2">
            {activeTab === ''GALLERY'' ? <FractalGallery /> : <GovernanceEditor />}
          </div>
          <div className="lg:col-span-1">
            <FractalAdvisor />
          </div>
        </section>

        <footer className="h-10 border-t border-v51-gold/5 bg-v51-void px-8 flex items-center">
          <EventStream />
        </footer>
      </main>
    </div>
  );
}
// FILE: main.tsx
import React from ''react'';
import ReactDOM from ''react-dom/client'';
import App from ''./App'';
import ''./index.css'';

ReactDOM.createRoot(document.getElementById(''root'')!).render(
    <React.StrictMode>
        <App />
    </React.StrictMode>
);
// FILE: useTenant.tsx
/**
 * PATH: /src/hooks/useTenant.tsx
 * ROLE: Nivel 1 - BETA (OrquestaciÃ³n de Contexto)
 * DESC: Hook maestro para la detecciÃ³n y validaciÃ³n de Tenant en el ecosistema VÃA51.
 */

import { createContext, useContext, useEffect, useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient''; // Cliente pre-configurado

interface TenantConfig {
  id: string;
  slug: string;
  name: string;
  level: ''ALFA'' | ''BETA'' | ''GAMMA'';
  settings: Record<string, any>;
}

const TenantContext = createContext<TenantConfig | null>(null);

export const TenantProvider = ({ children }: { children: React.ReactNode }) => {
  const [tenant, setTenant] = useState<TenantConfig | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const identifyTenant = async () => {
      const hostname = window.location.hostname; // e.g., mesias.via51.org
      const slug = hostname.split(''.'')[0];

      const { data, error } = await supabase
        .from(''sys_registry'')
        .select(''*'')
        .eq(''slug'', slug)
        .single();

      if (error || !data) {
        console.error(`[VÃA51 ERROR] Unauthorized Node: ${hostname}`);
        return;
      }

      setTenant(data);
      setLoading(false);
    };

    identifyTenant();
  }, []);

  return (
    <TenantContext.Provider value={tenant}>
      {!loading && children}
    </TenantContext.Provider>
  );
};

export const useTenant = () => useContext(TenantContext);

// FILE: useVia51Context.tsx
// path: src/hooks/useVia51Context.tsx
import { useEffect, useState } from ''react'';
import { fetchNodeConfig } from ''@gamma/lib/supabase'';

export const useVia51Context = () => {
  const [node, setNode] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchNodeConfig(''gamma-core-node'')
      .then(setNode)
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  return { node, loading, isAlpha: node?.tier === ''ALPHA'' };
};

// FILE: DashboardMetricas.tsx
import React, { useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';

const DashboardMetricas: React.FC = () => {
  const [metricas, setMetricas] = useState<any[]>([]);
  const [totalVisitas, setTotalVisitas] = useState(0);

  const fetchMetricas = async () => {
    const { data } = await supabase
      .from(SCHEMA.TABLES.EVENTS)
      .select(''payload, timestamp'')
      .eq(''action_type'', ''VISIT'');

    if (data) {
      setTotalVisitas(data.length);
      const resumen = data.reduce((acc: Record<string, number>, curr: any) => {
        const nombre = curr.payload?.client_name || ''Desconocido'';
        acc[nombre] = (acc[nombre] || 0) + 1;
        return acc;
      }, {});
      setMetricas(Object.entries(resumen));
    }
  };

  useEffect(() => {
    fetchMetricas();

    const sub = supabase.channel(''radar-realtime'')
      .on(''postgres_changes'', { event: ''INSERT'', schema: ''public'', table: SCHEMA.TABLES.EVENTS },
        () => fetchMetricas())
      .subscribe();

    return () => {
      supabase.removeChannel(sub);
    };
  }, []);

  return (
    <div className="p-10 bg-black min-h-screen text-white font-mono">
      <header className="flex justify-between items-end mb-12 border-b border-zinc-800 pb-8">
        <div>
          <h2 className="text-2xl font-black tracking-[0.2em]">VÃA 51 | TRAFFIC_CONTROL</h2>
          <p className="text-blue-500 text-[10px] mt-2 tracking-widest">SISTEMA_MULTI_TENANT_ACTIVO</p>
        </div>
        <div className="text-right">
          <p className="text-5xl font-black text-white leading-none">{totalVisitas}</p>
          <p className="text-[9px] opacity-40 tracking-[0.3em] uppercase mt-2">Impactos_Totales</p>
        </div>
      </header>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">
        <div className="bg-zinc-900/30 p-8 rounded-sm border border-zinc-800">
          <h3 className="text-[10px] font-bold mb-8 opacity-30 uppercase tracking-[0.2em]">Performance_by_Client</h3>
          {metricas.map(([cliente, visitas]) => (
            <div key={cliente} className="flex items-center justify-between py-5 border-b border-zinc-800/50 last:border-0">
              <span className="text-sm font-medium tracking-tight text-zinc-300">{cliente}</span>
              <div className="flex items-center gap-6">
                <div className="h-[2px] w-32 bg-zinc-800 overflow-hidden">
                  <div className="h-full bg-blue-600" style={{ width: `${(visitas / totalVisitas) * 100}%` }} />
                </div>
                <span className="font-bold text-blue-500 text-sm">{visitas}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default DashboardMetricas;
// FILE: PanelCarga.tsx
import React, { useState } from ''react'';
import { createClient } from ''@supabase/supabase-js'';
import Papa from ''papaparse'';

const supabase = createClient(''SU_URL'', ''SU_KEY_ANON'');

const PanelCarga = ({ clienteId }: any) => {
  const [datos, setDatos] = useState<any[]>([]);
  const [subiendo, setSubiendo] = useState(false);

  // 1. PROCESAR EL ARCHIVO (Excel convertido a CSV)
  const manejarArchivo = (e: any) => {
    const archivo = e.target.files[0];
    Papa.parse(archivo, {
      header: true,
      skipEmptyLines: true,
      complete: (results) => {
        setDatos(results.data as any[]);
        console.log("Datos listos para mapear:", results.data);
      }
    });
  };

  // 2. SUBIDA MASIVA A SUPABASE
  const ejecutarCarga = async () => {
    setSubiendo(true);
    
    // Mapeo dinÃ¡mico: Transformamos las filas del Excel al esquema del SaaS
    const nodosParaSubir = datos.map(fila => ({
      cliente_id: clienteId,
      titulo_que: fila.nombre || fila.producto || fila.servicio,
      descripcion_como: fila.descripcion || fila.propuesta,
      url_media: fila.imagen_url,
      tipo_media: fila.tipo || ''imagen'',
      // Todo lo demÃ¡s se va al JSONB de metadatos
      metadatos: {
        precio: fila.precio,
        stock: fila.stock,
        categoria: fila.categoria,
        piso: fila.piso, // Para inmobiliaria
        estado: fila.estado
      }
    }));

    const { error } = await supabase.from(''nodos_alfa'').insert(nodosParaSubir);

    if (error) alert("Error en carga: " + error.message);
    else alert(`Â¡Ã‰xito! ${nodosParaSubir.length} Nodos Alfa creados.`);
    
    setSubiendo(false);
  };

  return (
    <div className="p-8 bg-gray-900 min-h-screen text-white font-sans">
      <h2 className="text-2xl font-bold mb-6">ADMINISTRADOR DE NODOS - VÃA 51</h2>
      
      <div className="border-2 border-dashed border-gray-700 p-10 rounded-xl text-center bg-gray-800/50">
        <input 
          type="file" 
          accept=".csv" 
          onChange={manejarArchivo}
          className="mb-4 block w-full text-sm text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-600 file:text-white hover:file:bg-blue-700"
        />
        <p className="text-gray-500">Cargue el inventario (CSV) del cliente.</p>
      </div>

      {datos.length > 0 && (
        <div className="mt-8">
          <h3 className="mb-4">PrevisualizaciÃ³n de {datos.length} Ã­tems</h3>
          <div className="max-h-60 overflow-y-auto bg-black p-4 rounded-lg border border-gray-700">
             <pre className="text-[10px] text-green-400">{JSON.stringify(datos[0], null, 2)}</pre>
          </div>
          <button 
            onClick={ejecutarCarga}
            disabled={subiendo}
            className="mt-6 w-full bg-blue-600 p-4 rounded-lg font-bold hover:bg-blue-500 transition-colors"
          >
            {subiendo ? "SINCRONIZANDO CON NODO ALFA..." : "LANZAR AL AIRE (CONEXIÃ“N SUPABASE)"}
          </button>
        </div>
      )}
    </div>
  );
};

export default PanelCarga;



// FILE: Beta.tsx
/* Ruta: src/components/Beta
Nombre: Beta
DescripciÃ³n: Panel de gestiÃ³n para el Holding Digital VÃ­a51. 
Controla el contenido de Alfa (pol).
*/

import React, { useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient''; // Cliente Supabase configurado
import ''./Beta.css'';

const Beta = () => {
  const [formData, setFormData] = useState({
    titulo_que: '''',
    descripcion_como: ''''
  });
  const [loading, setLoading] = useState(false);
  const [status, setStatus] = useState('''');

  // 1. Cargar datos actuales de ALFA (pol) al iniciar
  useEffect(() => {
    const fetchInitialData = async () => {
      const { data, error } = await supabase
        .from(''nodos'')
        .select(''titulo_que, descripcion_como'')
        .eq(''slug'', ''pol'')
        .single();

      if (data) {
        setFormData({
          titulo_que: data.titulo_que || '''',
          descripcion_como: data.descripcion_como || ''''
        });
      }
      if (error) console.error(''Error cargando Alfa:'', error.message);
    };

    fetchInitialData();
  }, []);

  // 2. Manejar cambios en los inputs
  const handleChange = (e: any) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  // 3. Ejecutar UPSERT en Supabase
  const handleGuardar = async (e: any) => {
    e.preventDefault();
    setLoading(true);
    setStatus(''Sincronizando...'');

    const { error } = await supabase
      .from(''nodos'')
      .upsert({ 
        slug: ''pol'', 
        titulo_que: formData.titulo_que, 
        descripcion_como: formData.descripcion_como 
      }, { onConflict: ''slug'' });

    setLoading(false);
    if (error) {
      setStatus(''Error: '' + error.message);
    } else {
      setStatus(''âœ… ALFA Actualizado con Ã©xito'');
      setTimeout(() => setStatus(''''), 3000);
    }
  };

  return (
    <div className="beta-container">
      <div className="beta-overlay">
        <form className="beta-panel" onSubmit={handleGuardar}>
          <h2>NODO BETA: CONTROL MAESTRO</h2>
          <hr />
          
          <div className="input-group">
            <label>TÃTULO (QUÃ‰):</label>
            <input
              type="text"
              name="titulo_que"
              value={formData.titulo_que}
              onChange={handleChange}
              placeholder="Ej: La Identidad Digital..."
              required
            />
          </div>

          <div className="input-group">
            <label>DESCRIPCIÃ“N (CÃ“MO):</label>
            <textarea
              name="descripcion_como"
              value={formData.descripcion_como}
              onChange={handleChange}
              placeholder="Ej: Una mirada pÃºblica..."
              rows={5}
              required
            />
          </div>

          <button type="submit" disabled={loading}>
            {loading ? ''PROCESANDO...'' : ''ACTUALIZAR NODO ALFA''}
          </button>

          {status && <p className="status-msg">{status}</p>}
        </form>
      </div>
    </div>
  );
};

export default Beta;


// FILE: CaptureForm.tsx
/**
 * ARCHIVO: src/components/CaptureForm.tsx
 * DESCRIPCIÃ“N: Captura datos para proyectar en la red VÃA51.
 */
import React, { useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';

export const CaptureForm = () => {
  const [form, setForm] = useState({ name: '''', dni: '''', whatsapp: '''' });
  const [status, setStatus] = useState('''');

  const sendData = async (e: React.FormEvent) => {
    e.preventDefault();
    setStatus(''ENVIANDO...'');

    // InserciÃ³n en sys_events segÃºn esquema detectado
    const { error } = await supabase.from(''sys_events'').insert([{
      event_type: ''V51_PROJECTION'',
      payload: { 
        full_name: form.name.toUpperCase(), 
        document: form.dni, 
        phone: form.whatsapp 
      }
    }]);

    if (!error) {
      setForm({ name: '''', dni: '''', whatsapp: '''' });
      setStatus(''DATOS PROYECTADOS'');
      setTimeout(() => setStatus(''''), 3000);
    } else {
      setStatus(''ERROR DE CONEXIÃ“N'');
    }
  };

  return (
    <div className="bg-zinc-950 p-8 border border-zinc-800 font-mono max-w-sm w-full">
      <h2 className="text-blue-500 text-[10px] tracking-[0.4em] mb-6 uppercase text-center">Lead_Capture_Node</h2>
      <form onSubmit={sendData} className="space-y-4">
        <input 
          placeholder="NOMBRE Y APELLIDO" 
          className="w-full bg-black border border-zinc-800 p-3 text-white text-xs outline-none focus:border-blue-500"
          value={form.name} 
          onChange={e => setForm({...form, name: e.target.value})} 
          required 
        />
        <input 
          placeholder="DNI" 
          className="w-full bg-black border border-zinc-800 p-3 text-white text-xs outline-none focus:border-blue-500"
          value={form.dni} 
          onChange={e => setForm({...form, dni: e.target.value})} 
          required 
        />
        <input 
          placeholder="WHATSAPP" 
          className="w-full bg-black border border-zinc-800 p-3 text-white text-xs outline-none focus:border-blue-500"
          value={form.whatsapp} 
          onChange={e => setForm({...form, whatsapp: e.target.value})} 
          required 
        />
        <button className="w-full bg-blue-600 py-3 font-black text-[10px] uppercase hover:bg-blue-500 transition-all">
          {status || ''ACTIVAR PROYECCIÃ“N''}
        </button>
      </form>
    </div>
  );
};

// FILE: DataProjector.tsx
/**
 * BETA LAYER: DataProjector
 * Identity: V51_Alpha_DataProjector_Core
 * FunciÃ³n: ProyecciÃ³n dinÃ¡mica de departamentos mediante Lazy Loading.
 * Norma: Agnosticismo de Interfaz y Carga Bajo Demanda.
 */

import React, { Suspense, lazy } from "react";

// 1. ImplementaciÃ³n de Lazy Loading para optimizar la carga del nodo
const SocialDept = lazy(() => import("./depts/SocialDept"));
const PoliticsDept = lazy(() => import("./depts/PoliticsDept"));
const ProductionDept = lazy(() => import("./depts/ProductionDept"));

/**
 * Interface de ProyecciÃ³n de Departamentos
 * Garantiza el tipado fuerte para la transiciÃ³n entre nodos.
 */
interface DataProjectorProps {
  activeNode: ''SOCIAL'' | ''POLITICAL'' | ''PRODUCTIVE'';
  config?: any; // ConfiguraciÃ³n inyectada desde el Registry
}

export const DataProjector: React.FC<DataProjectorProps> = ({ activeNode, config = {} }) => {
  return (
    <div className="v51-projection-container w-full min-h-[400px] bg-zinc-950/50 rounded-xl overflow-hidden border border-zinc-900">
      {/* 2. Capa de SuspensiÃ³n (UX de TransiciÃ³n Soberana) */}
      <Suspense fallback={
        <div className="flex flex-col items-center justify-center p-20 space-y-4">
          <div className="w-8 h-8 border-2 border-blue-600 border-t-transparent rounded-full animate-spin" />
          <p className="text-[10px] font-mono text-zinc-500 tracking-[0.3em] uppercase animate-pulse">
            SYNCHRONIZING_V51_NODE...
          </p>
        </div>
      }>

        {/* 3. Renderizado Condicional por Triada de Poder */}
        <div className="p-4 animate-in fade-in slide-in-from-bottom-2 duration-700">
          {activeNode === ''SOCIAL'' && <SocialDept config={config} />}
          {activeNode === ''POLITICAL'' && <PoliticsDept config={config} />}
          {activeNode === ''PRODUCTIVE'' && <ProductionDept config={config} />}
        </div>

      </Suspense>
    </div>
  );
};

export default DataProjector;
// FILE: DynamicIcon.tsx
import React from ''react'';
import * as LucideIcons from ''lucide-react'';

interface DynamicIconProps {
  iconName: string; 
  size?: number;
  className?: string;
}

/**
 * GENERADOR DE ICONOGRAFÃA AGNÃ“STICA
 * Cumple el protocolo de identidad: El cÃ³digo no conoce el icono, 
 * solo resuelve el recurso que la tabla [sys_registry] le asigna al nodo.
 */
export const DynamicIcon: React.FC<DynamicIconProps> = ({ 
  iconName, 
  size = 24, 
  className = "" 
}) => {
  // Mapeo dinÃ¡mico seguro de la librerÃ­a Lucide
  const IconComponent = (LucideIcons as any)[iconName] as React.ElementType;

  if (!IconComponent) {
    // Icono de respaldo (Fallback) para mantener la integridad visual si el slug no tiene icono definido
    return <LucideIcons.HelpCircle size={size} className={className} />;
  }

  return <IconComponent size={size} className={className} />;
};

// FILE: KernelMonitor.tsx
import React, { useEffect, useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';
import { useTenant } from ''@beta/context/TenantContext'';

export const KernelMonitor: React.FC = () => {
  const { tenant } = useTenant();
  const [telemetry, setTelemetry] = useState({ total_events: 0, geo_traces: 0, registry_count: 0, last_event: ''AWAITING'' });

  const sync_telemetry = async () => {
    if (!tenant?.id) return;

    const [events, traces, registry] = await Promise.all([
      supabase.from(SCHEMA.TABLES.TELEMETRY).select(''*'', { count: ''exact'', head: true }).eq(''tenant_id'', tenant.id),
      supabase.from(SCHEMA.TABLES.TELEMETRY).select(''*'', { count: ''exact'', head: true }).eq(''tenant_id'', tenant.id).eq(''event_type'', ''GEO_TRACE''),
      supabase.from(''sys_registry'').select(''*'', { count: ''exact'', head: true })
    ]);

    setTelemetry({
      total_events: events.count || 0,
      geo_traces: traces.count || 0,
      registry_count: registry.count || 0,
      last_event: new Date().toLocaleTimeString()
    });
  };

  useEffect(() => {
    sync_telemetry();
    const channel = supabase.channel(''kernel_pulse'')
      .on(''postgres_changes'', { event: ''*'', schema: ''public'', table: SCHEMA.TABLES.TELEMETRY }, sync_telemetry)
      .on(''postgres_changes'', { event: ''*'', schema: ''public'', table: ''sys_registry'' }, sync_telemetry)
      .subscribe();
    return () => { supabase.removeChannel(channel); };
  }, [tenant?.id]);

  return (
    <div className="fixed bottom-6 left-6 z-[1000] font-mono pointer-events-none">
      <div className="bg-black/90 border border-zinc-800 p-5 rounded-sm backdrop-blur-xl w-64">
        <div className="flex justify-between items-center border-b border-zinc-800 pb-2 mb-3">
          <span className="text-zinc-500 text-[9px] font-bold uppercase tracking-widest">Sys_Kernel_v51</span>
          <span className="text-emerald-500 text-[9px] font-bold animate-pulse">ONLINE</span>
        </div>
        <div className="space-y-2 text-[10px] uppercase">
          <div className="flex justify-between">
            <span className="text-zinc-400">Total_Events:</span>
            <span className="text-white font-bold">{telemetry.total_events}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-blue-400/80">Geo_Traces (Ext):</span>
            <span className="text-blue-400 font-bold">{telemetry.geo_traces}</span>
          </div>
          <div className="flex justify-between">
            <span className="text-emerald-400/80">Registry (Int):</span>
            <span className="text-emerald-400 font-bold">{telemetry.registry_count}</span>
          </div>
        </div>
        <div className="mt-3 pt-2 border-t border-zinc-900 text-[8px] text-zinc-600 flex justify-between">
          <span>LAST_SYNC:</span>
          <span>{telemetry.last_event}</span>
        </div>
      </div>
    </div>
  );
};

// FILE: MainOrchestrator.tsx
import { useSystem } from ''@beta/context/SystemContext'';

// Definiciones de emergencia para silenciar al compilador (Stubs)
const OPERATIONAL_MODES = { CRITICAL: ''CRITICAL'', NORMAL: ''NORMAL'' };
const AlphaCoyunturaView = ({ eventId }: any) => <div className="p-4 bg-red-900/20 border border-red-500/50 text-red-500 text-[10px] font-mono">CRITICAL_EVENT_ID: {eventId}</div>;
const PoliticalModule = () => <div className="p-4 border border-zinc-800 text-zinc-500 text-[10px] font-mono">POLITICAL_MODULE_ACTIVE</div>;
const SocialModule = () => <div className="p-4 border border-zinc-800 text-zinc-500 text-[10px] font-mono">SOCIAL_MODULE_ACTIVE</div>;
const ProductiveModule = () => <div className="p-4 border border-zinc-800 text-zinc-500 text-[10px] font-mono">PRODUCTIVE_MODULE_ACTIVE</div>;
// FILE: MotorHolding.tsx
const MotorHolding = ({ tenantData }: any) => {
  // Eliminamos cualquier referencia a "VÃ­a 51" en el HTML
  return (
    <div className="h-screen w-screen bg-black overflow-hidden font-sans select-none">
      {/* Marco dinÃ¡mico sin marcas de agua */}
      <div className={`relative h-full w-full ${tenantData.layout === ''celular'' ? ''max-w-md mx-auto border-x border-white/5'' : ''''}`}>
        
        {/* MEDIA LAYER */}
        <video autoPlay muted loop playsInline className="absolute inset-0 h-full w-full object-cover">
          <source src={tenantData.media_url} type="video/mp4" />
        </video>

        {/* CONTENIDO ESPECÃFICO DEL CLIENTE */}
        <div className="absolute bottom-10 left-0 w-full px-8 z-20">
          <h1 className="text-white text-6xl font-black uppercase leading-tight">
            {tenantData.titulo}
          </h1>
          <div className="mt-4 p-4 backdrop-blur-xl bg-black/30 rounded-lg border-l-4" 
               style={{ borderColor: tenantData.color_primario }}>
            <p className="text-white text-lg font-light italic">
              {tenantData.mensaje_fuerza}
            </p>
          </div>
        </div>

        {/* Solo mostramos crÃ©ditos si el tenant lo permite (en polÃ­tica: OFF) */}
        {tenantData.mostrar_creditos && (
          <div className="absolute top-5 right-5 text-[8px] opacity-20 text-white">
            POWERED BY PACHA
          </div>
        )}
      </div>
    </div>
  );
};


// FILE: NodeController.tsx
// src/components/NodeController.tsx
import React, { useMemo } from ''react'';
import { useTenant } from ''@beta/context/TenantContext'';
import { NodeDispatcher } from ''./NodeDispatcher'';

interface NodeControllerProps {
  nodeId: string;
  onNavigate: (id: string) => void;
  userLevel: number; // Obtenido de user_permissions.hierarchy_level
}

export const NodeController: React.FC<NodeControllerProps> = ({ nodeId, onNavigate, userLevel }) => {
  const tenant: any = useTenant();

  // FunciÃ³n de filtrado recursivo: Si el usuario no tiene nivel, el nodo y sus hijos mueren.
  const authorizedTree = useMemo(() => {
    if (!tenant?.nodeTree?.root) return null;

    const filterNodes = (node: any): any | null => {
      // Regla de Oro: Si el nivel del nodo es mayor al del usuario, se elimina.
      if (node.access_level > userLevel) return null;

      return {
        ...node,
        children: node.children
          ? node.children.map(filterNodes).filter((n: any) => n !== null)
          : []
      };
    };

    return filterNodes(tenant.nodeTree.root);
  }, [tenant, userLevel]);

  // Buscador de nodo actual dentro del Ã¡rbol ya filtrado
  const currentNode = useMemo(() => {
    if (!authorizedTree) return null;

    const findNode = (node: any, id: string): any => {
      if (node.node_id === id) return node;
      for (const child of node.children || []) {
        const found = findNode(child, id);
        if (found) return found;
      }
      return null;
    };

    return findNode(authorizedTree, nodeId);
  }, [authorizedTree, nodeId]);

  if (!currentNode) return (
    <div className="p-10 text-[10px] text-zinc-500 uppercase animate-pulse">
      ERR_SCOPE_OUT_OF_BOUNDS: Nodo no encontrado o nivel insuficiente.
    </div>
  );

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <header className="mb-8 border-b border-zinc-800 pb-4">
        <h2 className="text-xs text-blue-500 font-bold tracking-[0.2em] mb-1">
          LOCATION: {currentNode.node_id.toUpperCase()}
        </h2>
        <h1 className="text-2xl font-black">{currentNode.label}</h1>
      </header>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {currentNode.children.map((child: any) => (
          <div key={child.node_id} className="group">
            {child.node_type === ''category'' ? (
              <button
                onClick={() => onNavigate(child.node_id)}
                className="w-full text-left p-4 border border-zinc-800 hover:border-white transition-colors"
              >
                <span className="text-[9px] opacity-40 block mb-1">DIR_SUB_LEVEL</span>
                <span className="font-bold">{child.label}</span>
              </button>
            ) : (
              <NodeDispatcher
                node={child}
                userLevel={userLevel}
                tenantId={tenant?.id || ''''}
              />
            )}
          </div>
        ))}
      </div>

      {nodeId !== ''root'' && (
        <button
          onClick={() => onNavigate(''root'')}
          className="mt-8 text-[10px] text-zinc-600 hover:text-white underline underline-offset-4"
        >
          RETURN_TO_ROOT
        </button>
      )}
    </div>
  );
};

// FILE: NodeDispatcher.tsx
// src/components/NodeDispatcher.tsx
import React from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';

interface NodeActionProps {
  node: {
    node_id: string;
    label: string;
    node_type: ''category'' | ''entity'' | ''action'' | ''metric'';
    access_level: number;
    metadata?: any;
  };
  userLevel: number;
  tenantId: string;
}

export const NodeDispatcher: React.FC<NodeActionProps> = ({ node, userLevel, tenantId }) => {
  
  // Bloqueo Multinivel Inmediato
  if (userLevel < node.access_level) {
    return (
      <div className="p-2 border border-red-900/30 bg-red-950/10 text-[9px] text-red-500 uppercase">
        ACCESS_DENIED: LEVEL_{node.access_level}_REQUIRED
      </div>
    );
  }

  const handleAction = async () => {
    if (node.node_type !== ''action'') return;

    // Registro automÃ¡tico de telemetrÃ­a (AuditorÃ­a Estandarizada)
    const { error } = await supabase
      .from(''sys_events'')
      .insert([{
        event_type: ''NODE_ACTION_EXECUTE'',
        tenant_id: tenantId,
        layer_id: ''FRONTEND_DISPATCHER'',
        metric_id: node.node_id,
        payload: { 
          label: node.label,
          executed_at: new Date().toISOString()
        }
      }]);

    if (error) console.error("DISPATCH_LOG_FAIL:", error.message);
    
    // AquÃ­ se dispararÃ­a la lÃ³gica especÃ­fica contenida en metadata
    alert(`EXECUTING: ${node.label}`);
  };

  return (
    <div 
      onClick={handleAction}
      className={`p-4 border transition-all cursor-pointer ${
        node.node_type === ''action'' 
          ? ''border-blue-900/50 hover:bg-blue-950/20'' 
          : ''border-zinc-800''
      }`}
    >
      <div className="flex justify-between items-center">
        <span className="text-[11px] font-bold tracking-widest">{node.label}</span>
        <span className="text-[8px] opacity-40">TYPE_{node.node_type}</span>
      </div>
      {node.metadata?.description && (
        <p className="text-[9px] text-zinc-500 mt-2">{node.metadata.description}</p>
      )}
    </div>
  );
};

// FILE: NodeEngine.tsx
import React from ''react'';

export const NodeEngine = ({ status }: { status: string }) => {
  return (
    <div className="p-4 rounded-lg border border-blue-500/20 bg-blue-500/5">
      <div className="flex items-center gap-2">
        <div className="w-2 h-2 rounded-full bg-blue-500 animate-ping" />
        <span className="text-[10px] font-mono text-blue-400 uppercase tracking-widest">
          Hub Status: {status}
        </span>
      </div>
    </div>
  );
};
// FILE: PanelBeta.tsx
/* Ruta: src/components/PanelBeta
   Nombre: PanelBeta
   DescripciÃ³n: Interfaz de procesamiento y carga de datos (BETA).
*/

import React, { useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import ''./PanelBeta.css'';

const PanelBeta = ({ destino }: any) => {
  const [datos, setDatos] = useState({ titulo_que: '''', descripcion_como: '''' });
  const [estadoSinc, setEstadoSinc] = useState('''');

  useEffect(() => {
    // Carga inicial del registro ALFA correspondiente al eje
    const cargarDatos = async () => {
      const { data } = await supabase
        .from(''nodos'')
        .select(''*'')
        .eq(''slug'', destino === ''politico'' ? ''pol'' : ''raiz'')
        .single();
      if (data) setDatos(data);
    };
    cargarDatos();
  }, [destino]);

  const enviarProcesamiento = async (e: any) => {
    e.preventDefault();
    setEstadoSinc(''Procesando en Beta...'');
    
    const { error } = await supabase
      .from(''nodos'')
      .upsert({ 
        slug: ''pol'', 
        titulo_que: datos.titulo_que, 
        descripcion_como: datos.descripcion_como 
      }, { onConflict: ''slug'' });

    setEstadoSinc(error ? ''Error en Gamma'' : ''âœ… Sincronizado con Alfa'');
  };

  return (
    <div className="contenedor-beta">
      <form className="formulario-procesamiento" onSubmit={enviarProcesamiento}>
        <header>
          <h2>BETA: PROCESAMIENTO {destino.toUpperCase()}</h2>
          <p>Sosteniendo el pilar del desarrollo nacional</p>
        </header>
        
        <input 
          value={datos.titulo_que} 
          onChange={(e: any) => setDatos({...datos, titulo_que: e.target.value})}
          placeholder="RazÃ³n de ser y propÃ³sito (PolÃ­tica)"
        />
        
        <textarea 
          value={datos.descripcion_como} 
          onChange={(e: any) => setDatos({...datos, descripcion_como: e.target.value})}
          placeholder="Interrelaciones y transformaciones (Social/Productivo)"
        />

        <button type="submit">ACTUALIZAR PANTALLA ALFA</button>
        {estadoSinc && <span className="feedback">{estadoSinc}</span>}
      </form>
    </div>
  );
};

export default PanelBeta;


// FILE: PantallaAlfa.tsx
import React, { useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';

const PantallaAlfa: React.FC = () => {
  const [nodo, setNodo] = useState<any>(null);

  useEffect(() => {
    const subscription = supabase
      .channel(''cambios-alfa'')
      .on(''postgres_changes'',
        { event: ''UPDATE'', schema: ''public'', table: SCHEMA.TABLES.REGISTRY, filter: "slug=eq.pol" },
        (payload) => {
          setNodo(payload.new);
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(subscription);
    };
  }, []);

  if (!nodo) return null;

  return (
    <div className="p-4 bg-zinc-900 border border-zinc-800 rounded">
      <p className="text-blue-500 text-[10px] font-mono">ALFA_NODE_SYNC: {nodo.slug}</p>
    </div>
  );
};

export default PantallaAlfa;
// FILE: SystemProbe.tsx
// ==========================================
// RUTA: src/components/SystemProbe.tsx
// ==========================================
import React, { useEffect, useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';
import { useTenant } from ''@beta/context/TenantContext'';

export const SystemProbe: React.FC = () => {
  const { tenant } = useTenant();
  const [count, setCount] = useState<number>(0);
  const [status, setStatus] = useState<''ONLINE'' | ''OFFLINE''>(''OFFLINE'');

  const actualizarContador = async () => {
    if (!tenant?.id) return;
    const { count: total, error } = await supabase
      .from(SCHEMA.TABLES.TELEMETRY)
      .select(''*'', { count: ''exact'', head: true })
      .eq(''tenant_id'', tenant.id);

    if (!error && total !== null) {
      setCount(total);
      setStatus(''ONLINE'');
    }
  };

  useEffect(() => {
    actualizarContador();
    const canal = supabase
      .channel(''cambios-telemetria'')
      .on(''postgres_changes'', 
          { event: ''INSERT'', schema: ''public'', table: SCHEMA.TABLES.TELEMETRY }, 
          () => actualizarContador()
      )
      .subscribe();

    return () => { supabase.removeChannel(canal); };
  }, [tenant?.id]);

  return (
    <div className="fixed bottom-6 right-6 z-50">
      <div className="bg-black/80 border border-zinc-800 p-4 rounded-lg font-mono text-[10px] backdrop-blur-md w-48 shadow-2xl">
        <div className="flex justify-between border-b border-zinc-800 pb-2 mb-2">
          <span className="text-zinc-500 font-bold">SYS_KERNEL_PROBE</span>
          <span className="text-green-500">â— {status}</span>
        </div>
        <div className="flex justify-between items-center">
          <span className="text-zinc-400">TELEMETRY:</span>
          <span className="text-white font-bold text-xs bg-zinc-900 px-2 rounded border border-zinc-800">
            ðŸ“Š {count} EVTS
          </span>
        </div>
      </div>
    </div>
  );
};

// FILE: SentimentChart.tsx
const SentimentChart = ({ data }: any) => <div className=''h-32 w-full bg-zinc-900/50 rounded'' />; export default SentimentChart;
// FILE: BindingNotification.tsx
import { useEffect, useState } from ''react'';
import { supabase } from ''@/lib/supabase'';
import { motion, AnimatePresence } from ''framer-motion'';

export const BindingNotification = () => {
  const [notification, setNotification] = useState(null);

  useEffect(() => {
    const channel = supabase
      .channel(''binding_echo'')
      .on(''postgres_changes'', 
        { event: ''INSERT'', schema: ''public'', table: ''sys_events'' }, 
        (payload) => {
          triggerNotification(payload.new);
        }
      )
      .subscribe();

    return () => { supabase.removeChannel(channel); };
  }, []);

  const triggerNotification = (event) => {
    setNotification(event);
    // Auto-ocultar después de 6 segundos
    setTimeout(() => setNotification(null), 6000);
  };

  return (
    <div className="fixed bottom-10 right-10 z-[300] pointer-events-none">
      <AnimatePresence>
        {notification && (
          <motion.div
            initial={{ opacity: 0, x: 100, filter: ''blur(10px)'' }}
            animate={{ opacity: 1, x: 0, filter: ''blur(0px)'' }}
            exit={{ opacity: 0, scale: 0.8, filter: ''blur(10px)'' }}
            className="w-80 p-4 bg-v51-void/80 backdrop-blur-2xl border-l-2 border-v51-gold shadow-[0_0_30px_rgba(212,175,55,0.1)] pointer-events-auto"
          >
            <div className="flex items-center gap-3 mb-2">
              <div className="w-2 h-2 bg-v51-gold animate-pulse" />
              <span className="text-[10px] font-mono text-v51-gold tracking-[0.3em] uppercase">
                {notification.event_type}
              </span>
            </div>
            <p className="text-[11px] text-gray-300 font-light leading-relaxed mb-3">
              {notification.description}
            </p>
            <div className="flex justify-between items-center border-t border-white/5 pt-2">
              <span className="text-[8px] font-mono text-v51-copper uppercase">
                Origin: {notification.created_by}
              </span>
              <span className="text-[8px] font-mono text-gray-600">
                {new Date(notification.created_at).toLocaleTimeString()}
              </span>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};
// FILE: EventStream.tsx
import { useEffect, useState } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const EventStream = () => {
    const [events, setEvents] = useState<any[]>([]);

    useEffect(() => {
        // SuscripciÃ³n en tiempo real al Bunker
        const channel = supabase
            .channel(''public:sys_events'')
            .on(''postgres_changes'', { event: ''INSERT'', schema: ''public'', table: ''sys_events'' },
                payload => setEvents(prev => [payload.new, ...prev].slice(0, 5)))
            .subscribe();

        return () => { supabase.removeChannel(channel); };
    }, []);

    return (
        <div className="font-mono text-[10px] text-v51-gold/50 overflow-hidden h-12">
            <div className="animate-pulse flex gap-4 items-center">
                <span className="bg-v51-gold h-2 w-2 rounded-full" />
                <span>LIVE SYSTEM FEED:</span>
                {events.length > 0 ? (
                    <span>{events[0].event_type} - {events[0].description}</span>
                ) : (
                    <span>Awaiting signal from via51-fractal-engine...</span>
                )}
            </div>
        </div>
    );
};
// FILE: PoliticsDept.tsx
import React from ''react'';

const PoliticsDept: React.FC<{ config: any }> = ({ config }) => (
  <div className="space-y-6 animate-in fade-in duration-1000">
    <header className="flex justify-between items-center border-b border-zinc-800 pb-4">
      <h2 className="text-[10px] font-black tracking-[0.4em] text-blue-500 uppercase">Strategic_Governance</h2>
      <span className="text-[9px] px-2 py-1 bg-blue-500/10 text-blue-400 border border-blue-500/20 rounded-full font-mono">ALPHA_VETO_ACTIVE</span>
    </header>

    <div className="grid grid-cols-2 gap-4">
      <div className="p-4 bg-zinc-900/50 border border-zinc-800 rounded-sm">
        <p className="text-zinc-500 text-[9px] uppercase tracking-widest mb-1 font-mono">Consensus_Level</p>
        <p className="text-2xl font-black text-white">98.4%</p>
        <div className="w-full h-[1px] bg-zinc-800 mt-2">
          <div className="h-full bg-blue-500 w-[98%]" />
        </div>
      </div>
      <div className="p-4 bg-zinc-900/50 border border-zinc-800 rounded-sm">
        <p className="text-zinc-500 text-[9px] uppercase tracking-widest mb-1 font-mono">Authority_Index</p>
        <p className="text-2xl font-black text-white italic">LEVEL_2</p>
        <p className="text-[8px] text-zinc-600 mt-1 uppercase">Sovereign_Control_Verified</p>
      </div>
    </div>
  </div>
);

export default PoliticsDept;
// FILE: ProductionDept.tsx
import React from ''react'';

const ProductionDept: React.FC<{ config: any }> = ({ config }) => (
  <div className="space-y-6 animate-in slide-in-from-bottom-4 duration-700">
    <header className="flex justify-between items-center border-b border-zinc-800 pb-4">
      <h2 className="text-[10px] font-black tracking-[0.4em] text-amber-500 uppercase">Operational_Efficiency</h2>
      <span className="text-[9px] font-mono text-amber-600">THROUGHPUT_OPTIMIZED</span>
    </header>

    <div className="bg-zinc-900/80 p-6 rounded-sm border border-zinc-800/50 relative overflow-hidden">
      <div className="absolute top-0 right-0 p-2 opacity-10">
        <div className="w-20 h-20 border-4 border-amber-500 rounded-full" />
      </div>

      <div className="relative z-10">
        <p className="text-[9px] text-zinc-500 uppercase tracking-widest mb-4 font-mono">Vault_Storage_Load</p>
        <div className="flex items-baseline gap-2">
          <span className="text-4xl font-black text-white">42.8</span>
          <span className="text-sm font-mono text-amber-500">TB</span>
        </div>
        <p className="text-[8px] text-zinc-600 mt-2 uppercase font-mono tracking-tighter">
          Encryption_Status: <span className="text-zinc-400">SHA-256_VERIFIED</span>
        </p>
      </div>
    </div>

    <div className="p-4 border border-zinc-800 grid grid-cols-3 gap-2 text-center">
      <div>
        <p className="text-[8px] text-zinc-600 uppercase font-mono">Nodes</p>
        <p className="text-sm font-bold text-zinc-300">27/27</p>
      </div>
      <div className="border-x border-zinc-800">
        <p className="text-[8px] text-zinc-600 uppercase font-mono">Uptime</p>
        <p className="text-sm font-bold text-zinc-300">99.9%</p>
      </div>
      <div>
        <p className="text-[8px] text-zinc-600 uppercase font-mono">Latency</p>
        <p className="text-sm font-bold text-zinc-300">14ms</p>
      </div>
    </div>
  </div>
);

export default ProductionDept;
// FILE: SocialDept.tsx
import React from ''react'';

const SocialDept: React.FC<{ config: any }> = ({ config }) => (
  <div className="space-y-6 animate-in slide-in-from-right-4 duration-700">
    <header className="flex justify-between items-center border-b border-zinc-800 pb-4">
      <h2 className="text-[10px] font-black tracking-[0.4em] text-emerald-500 uppercase">Social_Cohesion_Pulse</h2>
      <div className="flex gap-1">
        <div className="w-1 h-1 bg-emerald-500 rounded-full animate-ping" />
        <span className="text-[9px] text-emerald-400 font-mono">LIVE_STREAM</span>
      </div>
    </header>

    <div className="space-y-4">
      <div className="p-4 bg-zinc-900/30 border-l-2 border-emerald-500">
        <p className="text-zinc-400 text-xs leading-relaxed italic">
          "La soberanÃ­a no se delega, se ejerce a travÃ©s del dato transparente."
        </p>
        <p className="text-[8px] text-zinc-600 mt-2 font-mono uppercase tracking-widest">â€” Citizen_Emitter_051</p>
      </div>

      <div className="flex justify-between items-end">
        <div>
          <p className="text-[9px] text-zinc-500 uppercase mb-1 font-mono">Sentiment_Flux</p>
          <div className="flex gap-1 items-end h-8">
            {[40, 70, 45, 90, 65, 80, 50].map((h, i) => (
              <div key={i} className="w-2 bg-emerald-500/30" style={{ height: `${h}%` }} />
            ))}
          </div>
        </div>
        <div className="text-right">
          <p className="text-3xl font-black text-white tracking-tighter">8.4k</p>
          <p className="text-[8px] text-zinc-500 uppercase font-mono">Active_Voices</p>
        </div>
      </div>
    </div>
  </div>
);

export default SocialDept;
// FILE: AssetStressTest.tsx
import { useState } from ''react'';
import { MediaEngine } from ''@/drivers/MediaEngine'';

export const AssetStressTest = () => {
    const [status, setStatus] = useState(''IDLE'');
    const [preview, setPreview] = useState<string | null>(null);

    const runTest = async () => {
        setStatus(''LOADING_FRACTAL_ASSETS...'');
        try {
            // Prueba con un asset de alta carga (ej. el Shader de la Triada)
            const url = await MediaEngine.loadHighRes(''visuals/triada-core-8k.webp'', ''HIGH'') as string;
            setPreview(url);
            setStatus(''SUCCESS: 100% RENDERED'');
        } catch (err) {
            setStatus(''ERROR: SIGNAL_LOST'');
        }
    };

    return (
        <div className="mt-6 border border-v51-gold/20 p-4 bg-v51-void">
            <h3 className="text-v51-gold font-mono mb-4 text-[10px]">MEDIA_STRESS_TEST</h3>
            <div className="flex gap-4 items-center">
                <button
                    onClick={runTest}
                    className="bg-v51-gold/10 hover:bg-v51-gold/30 border border-v51-gold px-4 py-2 text-[10px] transition-all"
                >
                    EJECUTAR SECUENCIA DE CARGA
                </button>
                <span className="font-mono text-[10px] text-v51-copper">{status}</span>
            </div>

            {preview && (
                <div className="mt-4 relative h-32 w-full overflow-hidden border border-white/5">
                    <img src={preview} alt="Test" className="object-cover w-full h-full opacity-50" />
                    <div className="absolute inset-0 bg-gradient-to-t from-black to-transparent" />
                </div>
            )}
        </div>
    );
};
// FILE: DesignSystemEditor.tsx
import { useState } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const DesignSystemEditor = ({ node }: { node: string }) => {
  const [config, setConfig] = useState({
    textSize: ''text-2xl'',
    primaryColor: ''#D4AF37'',
    alignment: ''items-center'',
    showMobileImage: true,
    padding: ''py-20''
  });

  const save = async (newConfig: any) => {
    setConfig(newConfig);
    await supabase.from(''sys_registry'').update({ value: newConfig }).eq(''key'', `ui_config_${node.toLowerCase()}`);
  };

  return (
    <div className="p-6 bg-v51-void border border-v51-gold/20 font-mono text-[10px]">
      <h3 className="text-v51-gold mb-6 tracking-widest uppercase">Visual_Engine_Controller: {node}</h3>
      
      <div className="space-y-6">
        <div>
          <label className="block text-gray-500 mb-2">TEXT_SIZE</label>
          <select className="bg-black border border-white/10 text-white p-2 w-full" 
            onChange={(e) => save({...config, textSize: e.target.value})}>
            <option value="text-sm">Small</option>
            <option value="text-xl">Medium</option>
            <option value="text-4xl">Large</option>
            <option value="text-7xl">Colossal</option>
          </select>
        </div>

        <div>
          <label className="block text-gray-500 mb-2">PRIMARY_COLOR</label>
          <input type="color" className="w-full h-8 bg-transparent" 
            onChange={(e) => save({...config, primaryColor: e.target.value})} />
        </div>

        <div>
          <label className="block text-gray-500 mb-2">MOBILE_IMAGE_VISIBILITY</label>
          <button className={`px-4 py-1 border ${config.showMobileImage ? ''border-green-500 text-green-500'' : ''border-red-500 text-red-500''}`}
            onClick={() => save({...config, showMobileImage: !config.showMobileImage})}>
            {config.showMobileImage ? ''VISIBLE'' : ''HIDDEN''}
          </button>
        </div>
      </div>
    </div>
  );
};
// FILE: DevShell.tsx
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const DevShell = () => {
    const [logs, setLogs] = useState<any[]>([]);
    const [command, setCommand] = useState('''');

    // Escucha activa de eventos de desarrollo (dev_sys_events)
    useEffect(() => {
        const sub = supabase
            .channel(''dev_logs'')
            .on(''postgres_changes'', { event: ''INSERT'', schema: ''public'', table: ''dev_sys_events'' },
                p => setLogs(prev => [p.new, ...prev]))
            .subscribe();
        return () => { supabase.removeChannel(sub); };
    }, []);

    const executeCommand = async (e: React.FormEvent) => {
        e.preventDefault();
        // InyecciÃ³n de evento utilitario
        await supabase.from(''dev_sys_events'').insert([
            { event_type: ''CMD_EXEC'', description: command, created_by: ''RENZO_8'' }
        ]);
        setCommand('''');
    };

    return (
        <div className="bg-[#050505] min-h-screen p-4 font-mono text-[12px] text-green-500 border-t-2 border-v51-gold">
            <div className="flex justify-between border-b border-green-900 pb-2 mb-4">
                <span>VIA51_ANTIGRAVITY // DEV_MODE // ALFA_NODE</span>
                <span className="animate-pulse">â— SYSTEM_LIVE</span>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                {/* Monitor de Bunker */}
                <div className="border border-green-900 p-4 bg-black/50">
                    <h2 className="text-v51-gold mb-2 underline">BUNKER_STATUS (sys_registry)</h2>
                    <RegistryList />
                </div>

                {/* Consola de Logs */}
                <div className="border border-green-900 p-4 h-[400px] overflow-y-auto flex flex-col-reverse">
                    {logs.map((log, i) => (
                        <div key={i} className="mb-1 border-l border-green-800 pl-2">
                            <span className="text-gray-500">[{new Date(log.created_at).toLocaleTimeString()}]</span>{'' ''}
                            <span className="text-v51-copper">{log.event_type}:</span> {log.description}
                        </div>
                    ))}
                </div>
            </div>

            {/* Input de Comando Vinculante */}
            <form onSubmit={executeCommand} className="mt-4 flex gap-2">
                <span className="text-v51-gold">{''>''}</span>
                <input
                    className="bg-transparent border-none outline-none w-full text-green-400"
                    value={command}
                    onChange={(e) => setCommand(e.target.value)}
                    placeholder="Ingrese comando de estructuraciÃ³n..."
                    autoFocus
                />
            </form>
        </div>
    );
};
// FILE: FractalAdvisor.tsx
import { motion, AnimatePresence } from ''framer-motion'';
import { useFractalIntelligence } from ''@/hooks/useFractalIntelligence'';

export const FractalAdvisor = () => {
  const { insights, analyzing, refresh } = useFractalIntelligence();

  return (
    <div className="w-full bg-v51-void/50 border border-v51-gold/10 p-6 backdrop-blur-md">
      <div className="flex justify-between items-center mb-6">
        <div className="flex items-center gap-3">
          <div className={`w-2 h-2 rounded-full ${analyzing ? ''bg-v51-gold animate-ping'' : ''bg-v51-gold''}`} />
          <h3 className="text-v51-gold font-mono text-[10px] tracking-[0.4em]">ANTIGRAVITY_INTELLIGENCE_FEED</h3>
        </div>
        <button onClick={refresh} className="text-[9px] text-v51-copper hover:text-white transition-colors font-mono">
          [ RE_SCAN_SYSTEM ]
        </button>
      </div>

      <div className="space-y-4">
        <AnimatePresence>
          {insights.map((insight) => (
            <motion.div
              key={insight.id}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              className="p-3 border-l border-v51-gold/30 bg-white/5 hover:bg-v51-gold/5 transition-all cursor-help group"
            >
              <div className="flex justify-between mb-1">
                <span className="text-[8px] font-mono text-v51-gold">{insight.type}</span>
                <span className="text-[8px] font-mono text-gray-600 group-hover:text-v51-copper">DECRYPTED</span>
              </div>
              <p className="text-[10px] text-gray-300 font-light leading-relaxed">
                {insight.message}
              </p>
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
    </div>
  );
};
// FILE: FractalGallery.tsx
import { useEffect, useState } from ''react'';
import { supabase } from ''@/lib/supabase'';
import { motion, AnimatePresence } from ''framer-motion'';
import { MediaEngine } from ''@/drivers/MediaEngine'';

export const FractalGallery = () => {
  const [assets, setAssets] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selected, setSelected] = useState(null);

  useEffect(() => {
    fetchAssets();
  }, []);

  const fetchAssets = async () => {
    const { data, error } = await supabase
      .from(''sys_contributions'')
      .select(''*'')
      .order(''created_at'', { ascending: false });
    
    if (!error) setAssets(data);
    setLoading(false);
  };

  return (
    <div className="p-6 bg-v51-black min-h-screen text-white">
      <header className="mb-12 flex justify-between items-end">
        <div>
          <h2 className="text-v51-gold font-mono text-2xl tracking-tighter">GALLERY_COMMAND_CENTER</h2>
          <p className="text-[10px] text-v51-copper uppercase tracking-[0.3em]">Bunker: via51-assets / Node: BETA</p>
        </div>
        <div className="text-right font-mono text-[10px] text-gray-500">
          TOTAL_ASSETS: {assets.length}
        </div>
      </header>

      {/* Grid Fractal de Activos */}
      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
        <AnimatePresence>
          {assets.map((asset) => (
            <motion.div
              key={asset.id}
              layoutId={asset.id}
              onClick={() => setSelected(asset)}
              whileHover={{ scale: 1.05, borderColor: ''rgba(212, 175, 55, 0.5)'' }}
              className="aspect-square border border-v51-gold/10 bg-v51-void cursor-pointer overflow-hidden relative group"
            >
              <img 
                src={MediaEngine.optimizeAsset(asset.asset_url)} 
                className="object-cover w-full h-full opacity-60 group-hover:opacity-100 transition-opacity"
              />
              <div className="absolute bottom-0 left-0 right-0 p-2 bg-black/80 translate-y-full group-hover:translate-y-0 transition-transform">
                <p className="text-[8px] font-mono truncate">{asset.metadata.name}</p>
              </div>
            </motion.div>
          ))}
        </AnimatePresence>
      </div>

      {/* Modal de Inspección de Alta Gama */}
      {selected && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-10 bg-black/90 backdrop-blur-xl">
          <motion.div 
            layoutId={selected.id}
            className="bg-v51-void border border-v51-gold/30 p-1 max-w-5xl w-full relative"
          >
            <button 
              onClick={() => setSelected(null)}
              className="absolute -top-10 right-0 text-v51-gold font-mono hover:text-white"
            >
              [ CLOSE_SIGNAL ]
            </button>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 p-6">
              <div className="md:col-span-2">
                <img src={MediaEngine.optimizeAsset(selected.asset_url)} className="w-full h-auto shadow-2xl" />
              </div>
              <div className="space-y-4 font-mono">
                <h3 className="text-v51-gold text-sm underline">METADATA_DECRYPTED</h3>
                <div className="text-[10px] space-y-2 text-gray-400">
                  <p><span className="text-v51-copper">ID:</span> {selected.id}</p>
                  <p><span className="text-v51-copper">CONTRIBUTOR:</span> {selected.contributor_id}</p>
                  <p><span className="text-v51-copper">TYPE:</span> {selected.metadata.type}</p>
                  <p><span className="text-v51-copper">SIZE:</span> {(selected.metadata.size / 1024 / 1024).toFixed(2)} MB</p>
                </div>
                <button className="w-full py-2 border border-v51-gold/20 hover:bg-v51-gold/10 text-[10px] text-v51-gold transition-all">
                  VINCULAR A CARTA MAGNA
                </button>
              </div>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  );
};
// FILE: GovernanceEditor.tsx
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';
import { motion } from ''framer-motion'';

export const GovernanceEditor = () => {
  const [content, setContent] = useState('''');
  const [saving, setSaving] = useState(false);
  const [status, setStatus] = useState(''READ_ONLY'');

  useEffect(() => {
    loadCartaMagna();
  }, []);

  const loadCartaMagna = async () => {
    const { data } = await supabase
      .from(''sys_registry'')
      .select(''value'')
      .eq(''key'', ''carta_magna_2_0'')
      .single();
    if (data) setContent(data.value.text);
  };

  const commitChanges = async () => {
    setSaving(true);
    setStatus(''COMMITTING_TO_BUNKER...'');
    
    // 1. Actualizar Registro
    const { error } = await supabase
      .from(''sys_registry'')
      .update({ value: { text: content }, updated_at: new Date() })
      .eq(''key'', ''carta_magna_2_0'');

    // 2. Registrar Evento Vinculante
    await supabase.from(''sys_events'').insert([{
      event_type: ''GOVERNANCE_UPDATE'',
      description: ''Carta Magna 2.0 has been re-written by Hierarchy 8'',
      created_by: ''RENZO_8''
    }]);

    if (!error) {
      setStatus(''VINCULANTE_SUCCESS'');
      setTimeout(() => setStatus(''READ_ONLY''), 3000);
    }
    setSaving(false);
  };

  return (
    <div className="p-8 border border-v51-gold/10 bg-v51-void/30 backdrop-blur-sm">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-v51-gold font-mono text-xs tracking-[0.4em]">CARTA_MAGNA_2.0_EDITOR</h3>
        <span className={`text-[9px] font-mono ${status.includes(''SUCCESS'') ? ''text-green-500'' : ''text-v51-copper''}`}>
          [{status}]
        </span>
      </div>

      <textarea
        value={content}
        onChange={(e) => setContent(e.target.value)}
        className="w-full h-96 bg-black/50 border border-v51-gold/5 p-6 font-mono text-xs text-gray-300 leading-relaxed focus:border-v51-gold/30 outline-none transition-all custom-scrollbar"
        placeholder="Escriba los nuevos nudos del Khipu digital..."
      />

      <div className="mt-6 flex justify-end gap-4">
        <button 
          onClick={loadCartaMagna}
          className="px-4 py-2 text-[10px] font-mono text-gray-500 hover:text-white transition-colors"
        >
          [ REVERT_TO_BUNKER ]
        </button>
        <motion.button
          whileTap={{ scale: 0.95 }}
          onClick={commitChanges}
          disabled={saving}
          className="px-8 py-2 bg-v51-gold/10 border border-v51-gold text-v51-gold font-mono text-[10px] hover:bg-v51-gold hover:text-black transition-all"
        >
          {saving ? ''EXECUTING...'' : ''COMMIT_VINCULANTE''}
        </motion.button>
      </div>
    </div>
  );
};
// FILE: RegistryList.tsx
const RegistryList = () => {
    const [items, setItems] = useState<any[]>([]);

    useEffect(() => {
        const fetchRegistry = async () => {
            const { data } = await supabase.from(''sys_registry'').select(''*'');
            if (data) setItems(data);
        };
        fetchRegistry();
    }, []);

    return (
        <div className="space-y-2">
            {items.map(item => (
                <div key={item.key} className="flex justify-between hover:bg-green-900/20 p-1">
                    <span className="text-gray-400">{item.key}</span>
                    <span className="text-white font-bold">{JSON.stringify(item.value)}</span>
                </div>
            ))}
        </div>
    );
};
// FILE: TriadNavigator.tsx
export const TriadNavigator = () => {
    const nodes = [
        { id: ''ALFA'', desc: ''Core / Governance'', url: ''https://via51.org'', active: true },
        { id: ''BETA'', desc: ''The Hub / Community'', url: ''https://hub.via51.org'', active: false },
        { id: ''GAMMA'', desc: ''Laboratory / Dev'', url: ''https://gamma.via51.org'', active: false },
    ];

    return (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-20 w-full max-w-5xl">
            {nodes.map((node) => (
                <motion.a
                    key={node.id}
                    href={node.url}
                    whileHover={{ y: -5, borderColor: ''rgba(212, 175, 55, 0.5)'' }}
                    className="p-6 border border-v51-gold/10 bg-v51-void/50 backdrop-blur-md rounded-sm transition-colors group"
                >
                    <h3 className="text-v51-gold font-mono text-xl mb-2">{node.id}</h3>
                    <p className="text-xs text-gray-500 group-hover:text-gray-300 transition-colors uppercase tracking-widest">
                        {node.desc}
                    </p>
                    {!node.active && (
                        <span className="text-[9px] text-v51-copper mt-4 block">ENCRIPTANDO...</span>
                    )}
                </motion.a>
            ))}
        </div>
    );
};
// FILE: VisualStyler.tsx
import { useState, useEffect } from ''react'';
import { supabase } from ''@/lib/supabase'';

export const VisualStyler = () => {
  const [config, setConfig] = useState({
    heroTextSize: ''text-6xl'',
    heroColor: ''#D4AF37'',
    heroAlign: ''items-center'',
    showMobileImage: true
  });

  useEffect(() => {
    loadConfig();
  }, []);

  const loadConfig = async () => {
    const { data } = await supabase.from(''sys_registry'').select(''value'').eq(''key'', ''alfa_ui_config'').single();
    if (data) setConfig(data.value);
  };

  const updateConfig = async (newConfig) => {
    setConfig(newConfig);
    await supabase.from(''sys_registry'').update({ value: newConfig }).eq(''key'', ''alfa_ui_config'');
    await supabase.from(''sys_events'').insert([{ event_type: ''UI_RECONFIGURED'', description: ''Visual styles updated via HUB'', created_by: ''RENZO_8'' }]);
  };

  return (
    <div className="p-6 bg-v51-void/50 border border-v51-gold/10 font-mono">
      <h3 className="text-v51-gold text-xs tracking-widest mb-6 underline">VISUAL_CONFIGURATOR_BETA</h3>
      
      <div className="space-y-6">
        {/* Tamaño de Texto */}
        <div>
          <label className="text-[10px] text-gray-500 block mb-2">HERO_TEXT_SIZE</label>
          <select 
            value={config.heroTextSize} 
            onChange={(e) => updateConfig({...config, heroTextSize: e.target.value})}
            className="bg-black border border-v51-gold/20 text-v51-gold text-xs p-2 w-full"
          >
            <option value="text-4xl">SMALL</option>
            <option value="text-6xl">NORMAL</option>
            <option value="text-8xl">MASSIVE (8K)</option>
          </select>
        </div>

        {/* Color Principal */}
        <div>
          <label className="text-[10px] text-gray-500 block mb-2">PRIMARY_COLOR (HEX)</label>
          <input 
            type="color" 
            value={config.heroColor}
            onChange={(e) => updateConfig({...config, heroColor: e.target.value})}
            className="w-full h-10 bg-transparent border border-v51-gold/20 cursor-pointer"
          />
        </div>

        {/* Ubicación Relativa */}
        <div>
          <label className="text-[10px] text-gray-500 block mb-2">RELATIVE_ALIGNMENT</label>
          <div className="flex gap-2">
            {[''items-start'', ''items-center'', ''items-end''].map(align => (
              <button 
                key={align}
                onClick={() => updateConfig({...config, heroAlign: align})}
                className={`flex-1 py-2 text-[8px] border ${config.heroAlign === align ? ''bg-v51-gold text-black'' : ''border-v51-gold/20 text-v51-gold''}`}
              >
                {align.split(''-'')[1].toUpperCase()}
              </button>
            ))}
          </div>
        </div>

        {/* Visibilidad Móvil */}
        <div className="flex justify-between items-center p-3 border border-v51-gold/5 bg-black/20">
          <span className="text-[10px] text-gray-400">SHOW_VERTICAL_IMAGE_ON_MOBILE</span>
          <input 
            type="checkbox" 
            checked={config.showMobileImage}
            onChange={(e) => updateConfig({...config, showMobileImage: e.target.checked})}
            className="accent-v51-gold"
          />
        </div>
      </div>
    </div>
  );
};
// FILE: ProjectedHero.tsx
// src/components/display/ProjectedHero.tsx
import React from ''react'';

export const ProjectedHero: React.FC<{ config: any }> = ({ config }) => {
  const { headline, rotation_speed = ''10s'' } = config;

  return (
    <div className="h-screen bg-black flex items-center justify-center overflow-hidden">
      {/* Frame que simula un dispositivo mÃ³vil en el centro */}
      <div className="w-[320px] h-[580px] border-2 border-zinc-800 rounded-[40px] relative flex items-center justify-center p-6 shadow-[0_0_50px_rgba(255,255,255,0.05)]">
        
        {/* Frase con animaciÃ³n de rotaciÃ³n/giro */}
        <div className="text-center">
          <h1 
            className="text-2xl font-black tracking-tighter uppercase animate-spin-slow"
            style={{ animationDuration: rotation_speed }}
          >
            {headline || "WAITING_FOR_DATA..."}
          </h1>
        </div>

        {/* DecoraciÃ³n estÃ©tica de celular */}
        <div className="absolute top-4 w-20 h-1 bg-zinc-800 rounded-full"></div>
      </div>
    </div>
  );
};

// FILE: CampaignConsole.tsx
// src/components/internal/CampaignConsole.tsx
import React, { useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';

interface CampaignConsoleProps {
  tenantId: string;
  currentConfig: any;
}

export const CampaignConsole: React.FC<CampaignConsoleProps> = ({ tenantId, currentConfig }) => {
  const [inputPhrase, setInputPhrase] = useState('''');
  const [isUpdating, setIsUpdating] = useState(false);

  const updateNarrative = async () => {
    setIsUpdating(true);
    const updatedPhrases = [...(currentConfig.campaign_phrases || []), inputPhrase];
    
    const { error } = await supabase
      .from(''sys_registry'')
      .update({ 
        configuration: { ...currentConfig, campaign_phrases: updatedPhrases } 
      })
      .eq(''id'', tenantId);

    if (!error) setInputPhrase('''');
    setIsUpdating(false);
  };

  return (
    <div className="p-4 border border-zinc-800 bg-zinc-950 font-mono">
      <h3 className="text-[10px] text-blue-500 font-bold mb-4 uppercase">NARRATIVE_INJECTOR_V1</h3>
      <div className="flex gap-2">
        <input 
          value={inputPhrase}
          onChange={(e) => setInputPhrase(e.target.value)}
          placeholder="ENTER_NEW_CAMPAIGN_PHRASE..."
          className="flex-1 bg-black border border-zinc-800 p-2 text-xs focus:border-white outline-none"
        />
        <button 
          onClick={updateNarrative}
          disabled={isUpdating}
          className="bg-white text-black px-4 py-2 text-[10px] font-black hover:bg-zinc-200 transition-all"
        >
          {isUpdating ? ''SYNCING...'' : ''INJECT''}
        </button>
      </div>
    </div>
  );
};

// FILE: InternalRegistryEngine.tsx
// ==========================================
// PATH: src/components/internal/InternalRegistryEngine.tsx
// COMPONENT: Classified Entity Engine (Input Mode)
// STANDARD: AG-Agnostic / Section Routing
// ==========================================
import React, { useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';

export const InternalRegistryEngine: React.FC<{ on_action_complete: () => void; on_abort: () => void }> = ({ on_action_complete, on_abort }) => {
  const [is_processing, set_is_processing] = useState(false);
  const [form, set_form] = useState({
    target_section: ''SECTION_BETA'', // BETA = Desarrollo, GAMMA = Ciencia
    entity_class: ''PERSON_NATURAL'',
    identity_label: '''',
    content_phrase: ''''
  });

  const execute_transaction = async (e: React.FormEvent) => {
    e.preventDefault();
    set_is_processing(true);

    try {
      const system_payload = {
        meta: { section: form.target_section },
        identity: { class: form.entity_class, label: form.identity_label },
        content: { phrase: form.content_phrase, timestamp: new Date().toISOString() }
      };

      const { error } = await supabase
        .from(''sys_registry'')
        .insert([{ 
          slug: `${form.target_section.toLowerCase()}-${Date.now()}`, 
          configuracion_json: system_payload 
        }]);

      if (error) throw error;
      on_action_complete();
    } catch (err: any) {
      console.error("TX_ERR:", err);
    } finally { set_is_processing(false); }
  };

  return (
    <div className="bg-zinc-950 border border-zinc-800 p-8 rounded-lg w-full max-w-xl font-mono text-left">
      <header className="mb-6 border-b border-zinc-800 pb-4">
        <h2 className="text-white font-bold uppercase italic">Internal_Entity_Classify</h2>
        <span className="text-[9px] text-zinc-500 uppercase tracking-widest">Targeting System v51</span>
      </header>

      <form onSubmit={execute_transaction} className="space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-[9px] text-zinc-500 uppercase">Target_Section</label>
            <select 
              className="w-full bg-zinc-900 border border-zinc-800 text-white p-2 rounded-sm outline-none focus:border-blue-500"
              value={form.target_section}
              onChange={e => set_form({...form, target_section: e.target.value})}
            >
              <option value="SECTION_BETA">BETA_DEVELOPMENT</option>
              <option value="SECTION_GAMMA">GAMMA_SCIENCE</option>
            </select>
          </div>
          <div>
            <label className="text-[9px] text-zinc-500 uppercase">Entity_Class</label>
            <select 
              className="w-full bg-zinc-900 border border-zinc-800 text-white p-2 rounded-sm outline-none focus:border-blue-500"
              value={form.entity_class}
              onChange={e => set_form({...form, entity_class: e.target.value})}
            >
              <option value="PERSON_NATURAL">PERSON</option>
              <option value="INSTITUTION_ORG">INSTITUTION</option>
            </select>
          </div>
        </div>

        <input 
          placeholder="IDENTITY_LABEL" 
          required 
          className="w-full bg-zinc-900 border border-zinc-800 text-white p-3 rounded-sm outline-none"
          onChange={e => set_form({...form, identity_label: e.target.value})}
        />

        <textarea 
          placeholder="CONTENT_PHRASE" 
          required 
          className="w-full bg-zinc-900 border border-zinc-800 text-white p-3 rounded-sm h-24 outline-none resize-none"
          onChange={e => set_form({...form, content_phrase: e.target.value})}
        />

        <div className="flex gap-2 pt-4">
          <button type="button" onClick={on_abort} className="flex-1 bg-zinc-800 text-zinc-400 py-3 text-xs uppercase font-bold">Abort</button>
          <button type="submit" disabled={is_processing} className="flex-1 bg-white text-black py-3 text-xs uppercase font-bold">
            {is_processing ? ''Committing...'' : ''Commit_to_Section''}
          </button>
        </div>
      </form>
    </div>
  );
};

// FILE: FractalField.tsx
import { useRef } from ''react'';
import { Canvas, useFrame } from ''@react-three/fiber'';
import { Points, PointMaterial } from ''@react-three/drei'';
import * as random from ''maath/random/dist/maath-random.esm'';

function ParticleField() {
  const ref = useRef();
  const [sphere] = useState(() => random.inSphere(new Float32Array(5000), { radius: 1.5 }));

  useFrame((state, delta) => {
    ref.current.rotation.x -= delta / 10;
    ref.current.rotation.y -= delta / 15;
  });

  return (
    <group rotation={[0, 0, Math.PI / 4]}>
      <Points ref={ref} positions={sphere} stride={3} frustumCulled={false}>
        <PointMaterial transparent color="#D4AF37" size={0.005} sizeAttenuation={true} depthWrite={false} />
      </Points>
    </group>
  );
}

export const FractalField = () => (
  <div className="absolute inset-0 z-0">
    <Canvas camera={{ position: [0, 0, 1] }}>
      <ParticleField />
    </Canvas>
  </div>
);
import { useState } from ''react'';
// FILE: BetaSidebar.tsx
import { motion } from ''framer-motion'';

export const BetaSidebar = () => {
  const levels = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
  return (
    <div className="w-20 h-screen border-r border-v51-gold/10 flex flex-col items-center py-8 bg-v51-void">
      <div className="mb-12">
        <div className="w-8 h-8 border border-v51-gold rotate-45 flex items-center justify-center">
          <span className="rotate-[-45deg] text-[10px] font-bold text-v51-gold">V51</span>
        </div>
      </div>
      <div className="flex-1 flex flex-col gap-4">
        {levels.map((lvl) => (
          <motion.div
            key={lvl}
            whileHover={{ scale: 1.2, color: ''#D4AF37'' }}
            className={`cursor-pointer text-xs font-mono ${lvl === 8 ? ''text-v51-gold'' : ''text-gray-600''}`}
          >
            {lvl === 8 && <span className="absolute -left-2 text-[8px]">▶</span>}
            0{lvl}
          </motion.div>
        ))}
      </div>
      <div className="mt-auto text-[8px] text-v51-copper font-mono vertical-text py-4">
        BETA_NODE_ACTIVE
      </div>
    </div>
  );
};
// FILE: FractalLayout.tsx
import { motion } from ''framer-motion'';
import { QuantumNavigator } from ''@/components/navigation/QuantumNavigator'';
import { BindingNotification } from ''@/components/data/BindingNotification'';
import { HierarchyAura } from ''@/components/visuals/HierarchyAura'';

export const FractalLayout = ({ children, nodeType }: { children: React.ReactNode, nodeType: string }) => {
  return (
    <div className="min-h-screen bg-[#050505] text-white overflow-hidden relative font-antigravity">
      {/* Capas de Jerarquía y Control */}
      <HierarchyAura />
      <QuantumNavigator />
      <BindingNotification />

      {/* Capa de Fondo Dinámica */}
      <div className={`absolute inset-0 opacity-20 pointer-events-none z-0 ${
        nodeType === ''ALFA'' ? ''bg-[radial-gradient(circle_at_center,#D4AF37_0%,transparent_70%)]'' :
        nodeType === ''BETA'' ? ''bg-[radial-gradient(circle_at_center,#B87333_0%,transparent_70%)]'' :
        ''bg-[radial-gradient(circle_at_center,#ffffff_0%,transparent_70%)]''
      }`} />

      <motion.main 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="relative z-10"
      >
        {children}
      </motion.main>
    </div>
  );
};
// FILE: PortalHub.tsx
/**
 * PATH: src/layers/beta/components/layout/PortalHub.tsx
 * ROLE: Nivel 2 - ALFA (EjecuciÃ³n)
 * DESC: Fachada tripartita del ecosistema VÃA51.
 */

import React from ''react'';
import { useTenant } from ''@beta/hooks/useTenant'';

const SECTORS = [
  { id: ''political'', label: ''DEPARTAMENTO POLÃTICO'', color: ''bg-red-900/20'', border: ''border-red-500'' },
  { id: ''social'', label: ''DEPARTAMENTO SOCIAL'', color: ''bg-blue-900/20'', border: ''border-blue-500'' },
  { id: ''productive'', label: ''DEPARTAMENTO PRODUCTIVO'', color: ''bg-emerald-900/20'', border: ''border-emerald-500'' }
];

export const PortalHub: React.FC = () => {
  // 1. CORRECCIÃ“N CRÃTICA: Destructurar el hook para obtener el dato real
  const { tenant, loading } = useTenant();

  // 2. SALVAGUARDA DE SOBERANÃA: No renderizar si no hay datos
  if (loading) {
    return <div className="min-h-screen bg-black flex items-center justify-center font-mono text-zinc-500 animate-pulse uppercase tracking-[0.5em]">Syncing_Node...</div>;
  }

  return (
    <div className="min-h-screen bg-black text-white font-mono selection:bg-white selection:text-black">
      {/* HUD de NavegaciÃ³n */}
      <nav className="border-b border-white/10 p-4 flex justify-between items-center bg-zinc-900/50 backdrop-blur-md sticky top-0 z-50">
        <div className="flex items-center gap-4">
          <span className="text-xl font-black tracking-tighter uppercase">VÃA51 // {tenant?.slug || ''CORE''}</span>
          <div className="px-2 py-0.5 border border-white/20 text-[10px] opacity-50 uppercase">Node_Alfa_Active</div>
        </div>
        <div className="text-[10px] text-right uppercase opacity-40">
          {/* LÃ­nea 24 blindada con Optional Chaining y valor por defecto */}
          UID: {tenant?.id?.substring(0, 8) || ''00000000''}...<br />
          Layer: ALFA_EXECUTION
        </div>
      </nav>

      {/* Main Fractal Grid */}
      <main className="grid grid-cols-1 md:grid-cols-3 min-h-[calc(100vh-64px)] divide-x divide-white/10">
        {SECTORS.map((sector) => (
          <section
            key={sector.id}
            className="group relative overflow-hidden flex flex-col items-center justify-center p-8 transition-all duration-700 hover:bg-white/[0.02] cursor-pointer"
          >
            <div className="absolute inset-0 opacity-10 group-hover:opacity-20 transition-opacity pointer-events-none bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-white/20 via-transparent to-transparent" />

            <div className={`w-full border-l-4 ${sector.border} pl-6 transition-all duration-500 group-hover:translate-x-2`}>
              <h2 className="text-4xl font-bold tracking-tighter mb-2">{sector.label}</h2>
              <p className="text-xs text-white/40 max-w-[200px] leading-tight uppercase">
                ACCESO A MÃ“DULOS DE PROFUNDIDAD TÃ‰CNICA NIVEL {sector.id === ''political'' ? ''V'' : ''III''}.
              </p>
            </div>

            <div className="absolute bottom-10 left-10 flex gap-1">
              {[1, 2, 3, 4, 5].map((i) => (
                <div key={i} className="w-1 h-4 bg-white/10 group-hover:bg-white/40 transition-colors" style={{ transitionDelay: `${i * 100}ms` }} />
              ))}
            </div>

            <button className="mt-12 px-6 py-2 border border-white/20 text-xs hover:bg-white hover:text-black transition-all uppercase tracking-widest font-bold">
              Initialize_Sector
            </button>
          </section>
        ))}
      </main>

      <footer className="fixed bottom-0 w-full p-2 bg-black border-t border-white/5 flex justify-between text-[9px] text-white/30 uppercase tracking-widest">
        <span>Fractal_System_v51.6_Active</span>
        <span>Environment: Production</span>
        <span>Latency: 24ms</span>
      </footer>
    </div>
  );
};

export default PortalHub;
// FILE: UniversalLayout.tsx
/**
 * FUNCIÃ“N: Contenedor Maestro Universal (Mobile-First)
 * LUGAR: /src/components/layout/UniversalLayout.tsx
 * IDENTIDAD: V51-CORE | 03-Abr-2026
 * DESCRIPCIÃ“N: Implementa la estÃ©tica de "Puente de Escucha" (Cobalto/Limpio).
 */

import React, { ReactNode } from ''react'';

interface LayoutProps {
    children: ReactNode;
}

const UniversalLayout: React.FC<LayoutProps> = ({ children }) => {
    return (
        <div className="min-h-screen bg-slate-50 flex justify-center items-start antialiased font-sans">
            {/* Contenedor tipo App: Centrado en PC, Full width en MÃ³vil */}
            <main className="w-full max-w-md min-h-screen bg-white shadow-2xl border-x border-slate-100 flex flex-col relative">

                {/* Header de Identidad Blanca/Limpia */}
                <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-100 p-4 flex items-center justify-between">
                    <div className="flex items-center gap-2">
                        <div className="w-3 h-3 rounded-full bg-blue-600 animate-pulse" />
                        <span className="font-bold tracking-tight text-slate-800 uppercase text-sm">Sistema Activo</span>
                    </div>
                    <div className="text-[10px] text-slate-400 font-mono">NODE_ID: 12-A</div>
                </header>

                {/* Ãrea de Contenido DinÃ¡mico */}
                <section className="flex-1 p-4 overflow-y-auto overflow-x-hidden">
                    {children}
                </section>

                {/* Footer Minimalista */}
                <footer className="p-6 text-center">
                    <p className="text-[11px] text-slate-300 uppercase tracking-widest font-medium">
                        Infraestructura de Escucha Ciudadana
                    </p>
                    <p className="text-[9px] text-slate-200 mt-1 font-mono">V51.6_BETA_DEPLOY</p>
                </footer>
            </main>
        </div>
    );
};

export default UniversalLayout;

// FILE: QuantumNavigator.tsx
import { useState } from ''react'';
import { motion, AnimatePresence } from ''framer-motion'';
import { useRouter } from ''next/router'';

export const QuantumNavigator = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isLeaping, setIsLeaping] = useState(false);
  const router = useRouter();

  const nodes = [
    { id: ''ALFA'', path: ''/'', label: ''CORE_REALITY'', color: ''#D4AF37'' },
    { id: ''BETA'', path: ''/beta'', label: ''OPERATIONAL_HUB'', color: ''#B87333'' },
    { id: ''GAMMA'', path: ''/gamma'', label: ''LAB_EXPERIMENTAL'', color: ''#FFFFFF'' }
  ];

  const handleLeap = (path: string) => {
    setIsLeaping(true);
    setIsOpen(false);
    setTimeout(() => {
      router.push(path);
      setTimeout(() => setIsLeaping(false), 1000);
    }, 800);
  };

  return (
    <>
      {/* Botón de Acceso al Portal */}
      <div className="fixed top-6 left-1/2 -translate-x-1/2 z-[100]">
        <motion.button
          whileHover={{ scale: 1.1, letterSpacing: ''0.5em'' }}
          onClick={() => setIsOpen(!isOpen)}
          className="px-6 py-2 border border-v51-gold/30 bg-black/50 backdrop-blur-xl text-[10px] text-v51-gold font-mono tracking-[0.3em] uppercase transition-all"
        >
          {isOpen ? ''[ CLOSE_PORTAL ]'' : ''[ NODE_JUMP ]''}
        </motion.button>
      </div>

      {/* Menú del Portal */}
      <AnimatePresence>
        {isOpen && (
          <motion.div 
            initial={{ opacity: 0, backdropFilter: ''blur(0px)'' }}
            animate={{ opacity: 1, backdropFilter: ''blur(20px)'' }}
            exit={{ opacity: 0, backdropFilter: ''blur(0px)'' }}
            className="fixed inset-0 z-[90] bg-black/60 flex items-center justify-center"
          >
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 p-10">
              {nodes.map((node) => (
                <motion.div
                  key={node.id}
                  whileHover={{ y: -10 }}
                  onClick={() => handleLeap(node.path)}
                  className="group cursor-pointer p-8 border border-white/5 bg-v51-void/80 hover:border-v51-gold/50 transition-all text-center w-64"
                >
                  <h3 className="text-4xl font-bold text-white/20 group-hover:text-v51-gold transition-colors mb-4">{node.id}</h3>
                  <p className="text-[9px] font-mono text-v51-copper tracking-widest">{node.label}</p>
                  <div className="mt-6 h-[1px] w-0 group-hover:w-full bg-v51-gold transition-all duration-500 mx-auto" />
                </motion.div>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Efecto Visual: Salto Cuántico */}
      <AnimatePresence>
        {isLeaping && (
          <motion.div 
            initial={{ scale: 0, opacity: 0, borderRadius: ''100%'' }}
            animate={{ scale: 4, opacity: 1, borderRadius: ''0%'' }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.8, ease: [0.76, 0, 0.24, 1] }}
            className="fixed inset-0 z-[200] bg-v51-gold flex items-center justify-center"
          >
             <div className="text-black font-mono text-2xl font-bold tracking-[1em] animate-pulse">
               LEAPING...
             </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};
// FILE: ArdDashboard.tsx
// src/components/nodes/ArdDashboard.tsx
import React from ''react'';

const ArdDashboard = () => {
  return (
    <div className="p-6 text-white font-sans">
      <header className="mb-8">
        <h1 className="text-2xl font-bold text-blue-400">ARD_CENTRAL_SYSTEM</h1>
        <p className="text-[10px] opacity-50 uppercase tracking-[0.2em]">Node Status: Active</p>
      </header>

      <div className="grid grid-cols-2 gap-4">
        <div className="bg-white/5 p-4 rounded-2xl border border-white/10">
          <span className="block text-[9px] opacity-40 mb-1">NETWORK_LATENCY</span>
          <span className="text-xl font-mono text-green-400">24ms</span>
        </div>
        <div className="bg-white/5 p-4 rounded-2xl border border-white/10">
          <span className="block text-[9px] opacity-40 mb-1">UPTIME_RELAY</span>
          <span className="text-xl font-mono">99.9%</span>
        </div>
      </div>

      <div className="mt-8 p-4 bg-blue-600/10 rounded-2xl border border-blue-500/20 text-center">
        <span className="text-xs text-blue-400 font-medium">SincronizaciÃ³n con Supabase: OK</span>
      </div>
    </div>
  );
};

export default ArdDashboard;

// FILE: MediaNodeRenderer.tsx
// Path: src/components/nodes/MediaNodeRenderer.tsx
// Name: MediaNodeRenderer Component

import React from ''react'';

interface MediaNodeProps {
  node: {
    type: string;
    data: {
      src: string;
      label?: string;
      fileName?: string;
    };
  };
}

export const MediaNodeRenderer: React.FC<MediaNodeProps> = ({ node }) => {
  const { type, data } = node;

  if (type === ''video_node'') {
    return (
      <div className="gamma-video-container border border-zinc-800 rounded-lg overflow-hidden">
        <video 
          controls 
          className="w-full h-auto aspect-video bg-black"
          src={data.src}
        >
          Your browser does not support the video tag.
        </video>
        <div className="p-2 text-xs text-zinc-500 bg-zinc-900/50">
          Source: {data.fileName || ''Remote Video Asset''}
        </div>
      </div>
    );
  }

  if (type === ''audio_node'') {
    return (
      <div className="gamma-audio-container p-4 bg-zinc-900 border border-zinc-800 rounded-lg flex flex-col gap-2">
        <span className="text-sm font-medium text-zinc-300">
          {data.label || data.fileName || ''Audio Asset''}
        </span>
        <audio 
          controls 
          className="w-full h-10 accent-emerald-500"
          src={data.src}
        />
      </div>
    );
  }

  return null;
};

// FILE: PhoneProjector.tsx
// src/components/renderers/PhoneProjector.tsx
import React, { useState, useEffect } from ''react'';

interface PhoneProjectorProps {
  phrases: string[];
  rotationSpeed?: number;
}

export const PhoneProjector: React.FC<PhoneProjectorProps> = ({ phrases, rotationSpeed = 3000 }) => {
  const [index, setIndex] = useState(0);

  useEffect(() => {
    if (phrases.length <= 1) return;
    const interval = setInterval(() => {
      setIndex((prev) => (prev + 1) % phrases.length);
    }, rotationSpeed);
    return () => clearInterval(interval);
  }, [phrases, rotationSpeed]);

  return (
    <div className="flex items-center justify-center min-h-screen bg-black p-4">
      {/* Container con Aspect Ratio de Celular */}
      <div className="relative w-[320px] h-[580px] border-[6px] border-zinc-900 rounded-[40px] bg-zinc-950 overflow-hidden shadow-2xl shadow-blue-900/20">
        <div className="absolute top-0 w-full h-10 flex justify-center items-end">
          <div className="w-20 h-4 bg-zinc-900 rounded-full"></div> {/* Notch Sim */}
        </div>
        
        <div className="h-full flex flex-col items-center justify-center p-8 text-center">
          <div className="relative h-40 w-full flex items-center justify-center">
            {phrases.length > 0 ? (
              <h2 key={index} className="text-2xl font-black tracking-tighter leading-tight animate-in fade-in zoom-in duration-700 uppercase">
                {phrases[index]}
              </h2>
            ) : (
              <span className="text-[10px] text-zinc-700 animate-pulse">WAITING_FOR_DATA_STREAM...</span>
            )}
          </div>
        </div>

        <div className="absolute bottom-4 w-full flex justify-center">
          <div className="w-10 h-1 bg-zinc-800 rounded-full"></div>
        </div>
      </div>
    </div>
  );
};

// FILE: ArdMobileDashboard.tsx
// src/components/templates/ArdMobileDashboard.tsx

import React, { useState, useEffect } from ''react'';
import { 
  ShieldCheck, 
  LayoutDashboard, 
  Database, 
  Activity, 
  User, 
  Settings, 
  Zap, 
  Globe, 
  Lock 
} from ''lucide-react'';

/**
 * @interface NodeStats
 * DefiniciÃ³n de tipos para el Ecosistema VÃA51
 */
interface NodeStats {
  events: number;
  geoTraces: number;
  registry: number;
  status: ''ONLINE'' | ''OFFLINE'' | ''MAINTENANCE'';
}

/**
 * COMPONENTE: ArdMobileDashboard
 * NODO: ard.via51.org
 * TECNOLOGÃA: React + TypeScript + Tailwind v51.6
 * REGLA: Aislamiento estricto de Tenant y Root Owner.
 */

const ArdMobileDashboard: React.FC = () => {
  const [stats, setStats] = useState<NodeStats>({
    events: 0,
    geoTraces: 0,
    registry: 0,
    status: ''ONLINE''
  });

  const ROOT_OWNER: string = ''9157ae13-36ac-4259-9680-1d9bd2cada4a'';
  const HOSTNAME: string = window.location.hostname;
  const IS_AUTHORIZED: boolean = HOSTNAME === ''ard.via51.org'' || HOSTNAME === ''localhost'';

  // ValidaciÃ³n de seguridad en capa de renderizado
  if (!IS_AUTHORIZED) {
    return (
      <div className="h-screen w-full bg-black flex items-center justify-center">
        <p className="text-red-600 font-mono font-bold tracking-tighter text-xs">
          403_FORBIDDEN_HOST_OUT_OF_SCOPE
        </p>
      </div>
    );
  }

  return (
    <main className="fixed inset-0 bg-[#080808] flex items-center justify-center p-4 overflow-hidden select-none">
      
      {/* DefiniciÃ³n de LÃ­mites: Ambient Light Bloom */}
      <div className="absolute w-[600px] h-[600px] bg-blue-600/5 rounded-full blur-[120px] pointer-events-none" />

      {/* CHASIS FÃSICO (Hardware Representation) */}
      <div className="relative w-[385px] h-[810px] bg-[#121212] rounded-[64px] p-[12px] shadow-[0_50px_100px_-20px_rgba(0,0,0,1)] ring-1 ring-white/10 flex-shrink-0">
        
        {/* Dynamic Island: Sensor Array */}
        <div className="absolute top-4 left-1/2 -translate-x-1/2 w-28 h-7 bg-black rounded-full z-[100] border border-white/5 flex items-center justify-end px-4">
          <div className="w-2 h-2 rounded-full bg-[#1a1a1a] border border-white/5" />
        </div>

        {/* Botones FÃ­sicos (Laterales Externos) */}
        <div className="absolute -left-[2px] top-32 w-[4px] h-16 bg-gradient-to-b from-[#1a1a1a] to-[#0a0a0a] rounded-l-md border-l border-white/10" />
        <div className="absolute -right-[2px] top-40 w-[4px] h-24 bg-gradient-to-b from-[#1a1a1a] to-[#0a0a0a] rounded-r-md border-r border-white/10" />

        {/* PANTALLA OLED (Viewport Interior) */}
        <div className="w-full h-full bg-[#1c1f24] rounded-[52px] overflow-hidden flex flex-col relative border border-white/10 shadow-inner">
          
          {/* Status Bar Administrativa */}
          <header className="px-8 pt-12 pb-4 flex justify-between items-center bg-[#252a31]/50 backdrop-blur-md">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-2xl bg-gradient-to-br from-blue-600 to-indigo-700 flex items-center justify-center shadow-lg shadow-blue-900/40 rotate-3">
                <span className="text-[10px] font-black text-white -rotate-3 uppercase tracking-tighter">V51</span>
              </div>
              <div className="leading-tight">
                <p className="text-[9px] text-blue-400 font-mono font-black uppercase tracking-[0.2em]">Root_Authorized</p>
                <p className="text-[11px] font-bold text-slate-200">fredy.bazalar@via51.org</p>
              </div>
            </div>
            <Settings size={18} className="text-slate-500 hover:text-white transition-colors cursor-pointer" />
          </header>

          {/* Body: Dashboard del Nodo ARD */}
          <section className="flex-1 overflow-y-auto px-6 py-6 space-y-6 scrollbar-hide">
            
            <div className="space-y-1">
              <h1 className="text-2xl font-black tracking-tighter text-white">Holding_Chassis_v51</h1>
              <div className="flex items-center gap-2">
                <div className="h-1.5 w-1.5 rounded-full bg-emerald-500 animate-pulse shadow-[0_0_8px_rgba(16,185,129,0.5)]" />
                <span className="text-[10px] font-mono text-emerald-500 uppercase font-bold tracking-widest">Sys_Kernel_v51:ONLINE</span>
              </div>
            </div>

            {/* Accesos de Nivel Gamma (Beta/Science) */}
            <div className="grid grid-cols-2 gap-3">
              <button className="flex flex-col items-center justify-center gap-2 p-5 bg-[#2a3039] rounded-[32px] border border-white/5 active:scale-95 transition-all shadow-xl group">
                <Zap className="text-blue-400 group-hover:drop-shadow-[0_0_8px_rgba(96,165,250,0.5)]" size={24} />
                <span className="text-[9px] font-black text-center text-slate-300 uppercase leading-none">Access_Beta<br/>Development</span>
              </button>
              <button className="flex flex-col items-center justify-center gap-2 p-5 bg-[#2a3039] rounded-[32px] border border-white/5 active:scale-95 transition-all shadow-xl group">
                <Globe className="text-purple-400 group-hover:drop-shadow-[0_0_8px_rgba(192,132,252,0.5)]" size={24} />
                <span className="text-[9px] font-black text-center text-slate-300 uppercase leading-none">Access_Gamma<br/>Science</span>
              </button>
            </div>

            {/* Monitor de Tablas CrÃ­ticas (sys_events / sys_registry) */}
            <div className="space-y-3">
              <div className="bg-[#252a31] p-4 rounded-3xl border border-white/5 flex justify-between items-center group">
                <div className="flex items-center gap-3">
                  <Activity size={16} className="text-blue-500" />
                  <span className="text-[10px] text-slate-400 font-mono font-bold uppercase">Total_Events</span>
                </div>
                <span className="text-lg font-mono font-bold text-white tracking-tighter">{stats.events}</span>
              </div>

              <div className="bg-[#252a31] p-4 rounded-3xl border border-white/5 flex justify-between items-center group">
                <div className="flex items-center gap-3">
                  <Database size={16} className="text-emerald-500" />
                  <span className="text-[10px] text-slate-400 font-mono font-bold uppercase">Registry (Int)</span>
                </div>
                <span className="text-lg font-mono font-bold text-white tracking-tighter">{stats.registry}</span>
              </div>
            </div>

            <div className="mt-8 pt-4 border-t border-white/5 text-center">
              <p className="text-[8px] text-slate-600 font-mono font-bold tracking-[0.3em] uppercase">
                Auth_UID: {ROOT_OWNER.substring(0, 8)}...
              </p>
            </div>
          </section>

          {/* Navigation Bar (Custom UI) */}
          <nav className="h-24 bg-[#1a1d23]/95 backdrop-blur-xl border-t border-white/10 px-8 flex justify-between items-center relative z-[110]">
            <LayoutDashboard className="text-blue-500" size={22} />
            <Database className="text-slate-600" size={22} />
            <div className="relative -mt-12">
              <div className="absolute inset-0 bg-blue-600/30 blur-2xl rounded-full scale-150" />
              <button className="w-14 h-14 bg-gradient-to-b from-blue-500 to-indigo-700 rounded-[22px] flex items-center justify-center shadow-2xl shadow-blue-500/40 border border-blue-400/50 relative">
                <Lock className="text-white" size={24} />
              </button>
            </div>
            <Activity className="text-slate-600" size={22} />
            <User className="text-slate-600" size={22} />
          </nav>

        </div>
      </div>
    </main>
  );
};

export default ArdMobileDashboard;

// FILE: MotorAlfa.tsx
import React, { useState, useEffect } from ''react'';
import { createClient } from ''@supabase/supabase-js'';

const supabase = createClient(''SU_URL'', ''SU_KEY_ANON'');

const MotorAlfa = ({ clienteSlug }: any) => {
  const [nodos, setNodos] = useState<any[]>([]);
  const [indice, setIndice] = useState(0);
  const [clienteInfo, setClienteInfo] = useState<any>(null);

  useEffect(() => {
    const cargarSaaS = async () => {
      // 1. Obtener ADN del Cliente
      const { data: cliente } = await supabase
        .from(''clientes'')
        .select(''*'')
        .eq(''slug'', clienteSlug)
        .single();
      
      if (cliente) {
        setClienteInfo(cliente);
        // 2. Cargar sus Nodos (Sus productos, propuestas o servicios)
        const { data: items } = await supabase
          .from(''nodos_alfa'')
          .select(''*'')
          .eq(''cliente_id'', cliente.id)
          .eq(''esta_activo'', true)
          .order(''prioridad'', { ascending: false });
        
        setNodos(items || []);
      }
    };
    cargarSaaS();
  }, [clienteSlug]);

  if (!clienteInfo || nodos.length === 0) return <div className="h-screen bg-black" />;

  const itemActual = nodos[indice];

  return (
    <div className="h-screen w-screen bg-black text-white flex items-center justify-center overflow-hidden">
      {/* Marco de Dispositivo Adaptativo */}
      <div className="relative aspect-[9/16] h-[92vh] border border-white/10 rounded-[2.5rem] overflow-hidden shadow-2xl"
           style={{ boxShadow: `0 0 40px ${clienteInfo.color_tema}33` }}>
        
        {/* MEDIA LAYER */}
        <div className="absolute inset-0 z-0">
          {itemActual.tipo_media === ''video'' ? (
            <video key={itemActual.url_media} autoPlay muted loop playsInline className="h-full w-full object-cover">
              <source src={itemActual.url_media} type="video/mp4" />
            </video>
          ) : (
            <img src={itemActual.url_media} className="h-full w-full object-cover" alt="SaaS Content" />
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent" />
        </div>

        {/* TRADUCTOR DE CAMPOS DINÃMICO */}
        <div className="absolute bottom-0 w-full p-8 z-10">
          <p className="text-[10px] tracking-[0.4em] mb-2" style={{ color: clienteInfo.color_tema }}>
            {clienteInfo.nombre_comercial.toUpperCase()}
          </p>
          
          <h1 className="text-4xl font-black uppercase mb-4 leading-none">
            {itemActual.titulo_que}
          </h1>

          <div className="p-4 bg-white/5 backdrop-blur-md rounded-xl border-l-4" 
               style={{ borderColor: clienteInfo.color_tema }}>
            <p className="text-sm font-light opacity-90 mb-3">
              <span className="font-bold">EL CÃ“MO:</span> {itemActual.descripcion_como}
            </p>
            
            {/* RENDERIZADO DE METADATOS (La ensalada de variables) */}
            <div className="flex flex-wrap gap-2 mt-2">
              {Object.entries(itemActual.metadatos).map(([llave, valor]) => (
                <span key={llave} className="text-[9px] bg-white/10 px-2 py-1 rounded-md uppercase">
                  {llave}: {valor as any}
                </span>
              ))}
            </div>
          </div>
          
          {/* NavegaciÃ³n de Nodos (Scroll simulado) */}
          <div className="flex justify-between mt-6">
            <button onClick={() => setIndice(prev => Math.max(0, prev - 1))} className="text-[10px] opacity-40">ANTERIOR</button>
            <button onClick={() => setIndice(prev => Math.min(nodos.length - 1, prev + 1))} className="text-[10px] font-bold">SIGUIENTE</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MotorAlfa;





// FILE: PantallaAlfa.tsx
/**
 * BETA LAYER: PantallaAlfa
 * FunciÃ³n: Interfaz de bienvenida y captura de contexto geogrÃ¡fico.
 * Norma: Inmutabilidad Visual (Tailwind) y Tipado Fuerte.
 */

import React, { useState, useEffect } from ''react'';

// Interfaz de Integridad para el Nodo Beta
interface PantallaAlfaProps {
  data: any;
  onSeleccionar?: (tipo: string) => void;
}

export default function PantallaAlfa({ data, onSeleccionar }: PantallaAlfaProps) {
  const [visitante, setVisitante] = useState({ city: ''LIMA'', ip: ''...'' });

  useEffect(() => {
    // Escaneo de Radar (IP/Ciudad)
    fetch(''https://ipapi.co/json/'')
      .then(res => res.json())
      .then(info => setVisitante({ city: info.city, ip: info.ip }))
      .catch(() => setVisitante({ city: ''LIMA'', ip: ''RADAR_ACTIVO'' }));
  }, []);

  const titulo = data?.titulo_que || "SISTEMA_VÃA51";
  const desc = data?.descripcion_como || "Protocolo de transformaciÃ³n y soberanÃ­a tecnolÃ³gica 2026.";

  return (
    <div
      onClick={() => onSeleccionar && onSeleccionar(''ALFA_TOUCH'')}
      className="min-h-screen bg-black flex flex-col items-center justify-center p-6 text-center font-sans cursor-pointer group"
    >
      {/* Sovereign Border Box */}
      <div className="border border-yellow-500/20 rounded-[40px] p-10 md:p-16 max-w-2xl transition-all group-hover:border-yellow-500/40">

        {/* Radar Info */}
        <div className="mb-10">
          <span className="text-[10px] uppercase tracking-[0.4em] text-yellow-500 font-black animate-pulse">
            {visitante.city} // {visitante.ip}
          </span>
        </div>

        {/* Hero Title */}
        <h1 className="text-5xl md:text-7xl font-black uppercase italic mb-10 leading-tight">
          <span className="text-yellow-500 block">{titulo}</span>
        </h1>

        {/* Agnostic Description */}
        <p className="text-xl md:text-2xl text-zinc-500 italic max-w-lg mx-auto border-l-4 border-yellow-500/20 pl-6 text-left leading-relaxed">
          "{desc}"
        </p>

        {/* Interaction Indicator */}
        <div className="mt-12 opacity-0 group-hover:opacity-100 transition-opacity">
          <span className="text-[9px] text-zinc-600 font-mono tracking-widest">
            CLICK_TO_PROCEED_
          </span>
        </div>
      </div>
    </div>
  );
}
// FILE: PantallaCenit.tsx
import React from ''react'';

const PantallaCenit = ({ config, onRetornar }: any) => {
  if (!config) return null;

  return (
    <div 
      className="absolute inset-0 bg-cover bg-center transition-opacity duration-700 animate-in fade-in"
      style={{ backgroundImage: `url(${config.fondo})` }}
    >
      {/* BotÃ³n de Retorno TÃ¡ctico */}
      <button
        onClick={onRetornar}
        className="absolute top-8 left-6 z-50 p-4 bg-black/30 backdrop-blur-xl rounded-full text-white border border-white/20 active:scale-90 transition-transform"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
          <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
      </button>

      {/* Capa Antigravity: Fondo Limpio */}
    </div>
  );
};

export default PantallaCenit;


// FILE: Via51.tsx
import React, { useState, useRef, useCallback } from ''react'';
import { SCHEMA } from ''@gamma/lib/constants'';
import PantallaAlfa from ''./PantallaAlfa'';
import PantallaCenit from ''./PantallaCenit'';

const TranscendenceEngine: React.FC = () => {
  const [stage, setStage] = useState<{ id: ''ALFA'' | ''CENIT''; data: any }>({
    id: ''ALFA'',
    data: null
  });

  const audioRef = useRef<HTMLAudioElement | null>(null);

  const handleActivation = useCallback((payload: any) => {
    // 1. Audio Sequence Initialization
    if (audioRef.current) audioRef.current.pause();

    const audioUrl = payload?.meta?.audio || ''/assets/audio/core_pulse.mp3'';
    audioRef.current = new Audio(audioUrl);

    // Tactic Offset for cinematic impact
    if (payload?.type === ''HIGH_PRIORITY'') audioRef.current.currentTime = 7.5;

    audioRef.current.play().catch(() => console.warn("[V51] Interaction Required for Audio"));

    // 2. Stage Mutation
    setStage({ id: ''CENIT'', data: payload });
  }, []);

  const resetSequence = useCallback(() => {
    if (audioRef.current) {
      audioRef.current.pause();
      audioRef.current.currentTime = 0;
    }
    setStage({ id: ''ALFA'', data: null });
  }, []);

  return (
    <div className="w-full h-screen bg-black overflow-hidden relative selection:bg-blue-500/30">
      {/* Cinematic Transition Layer */}
      <div className="absolute inset-0 z-0 bg-[radial-gradient(circle_at_center,rgba(0,71,255,0.05)_0%,transparent_100%)] pointer-events-none" />

      {stage.id === ''ALFA'' ? (
        <div className="animate-in fade-in zoom-in-95 duration-1000">
          <PantallaAlfa
            data={stage.data}
            onSeleccionar={(t) => handleActivation({ type: t, label: ''SYSTEM_COMMAND'' })}
          />
        </div>
      ) : (
        <div className="animate-in slide-in-from-bottom-10 duration-700">
          <PantallaCenit
            config={stage.data}
            onRetornar={resetSequence}
          />
        </div>
      )}
    </div>
  );
};

export default TranscendenceEngine;
// FILE: HeroSingularity.tsx
import { motion } from ''framer-motion'';

export const HeroSingularity = () => {
    return (
        <div className="relative flex items-center justify-center h-64 w-64">
            {/* Anillos Fractales */}
            {[...Array(3)].map((_, i) => (
                <motion.div
                    key={i}
                    className="absolute border border-v51-gold/30 rounded-full"
                    initial={{ width: 100, height: 100, opacity: 0 }}
                    animate={{
                        width: [100, 300, 100],
                        height: [100, 300, 100],
                        opacity: [0.1, 0.5, 0.1],
                        rotate: i * 120
                    }}
                    transition={{
                        duration: 8,
                        repeat: Infinity,
                        delay: i * 2,
                        ease: "easeInOut"
                    }}
                />
            ))}
            <motion.div
                className="z-10 text-6xl font-bold tracking-tighter text-white"
                animate={{ scale: [0.95, 1.05, 0.95] }}
                transition={{ duration: 4, repeat: Infinity }}
            >
                VIA51
            </motion.div>
        </div>
    );
};
// FILE: HierarchyAura.tsx
import { motion } from ''framer-motion'';
import { useHierarchy } from ''@/hooks/useHierarchy'';

export const HierarchyAura = () => {
  const { level } = useHierarchy();

  if (level < 8) return null;

  return (
    <div className="fixed inset-0 pointer-events-none z-[400]">
      {/* Marco de Poder Astral */}
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="absolute inset-0 border-[1px] border-v51-gold/20 shadow-[inset_0_0_100px_rgba(212,175,55,0.05)]"
      />
      
      {/* Indicador de Rango en Esquina Superior Derecha */}
      <motion.div 
        initial={{ y: -20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        className="absolute top-6 right-10 flex items-center gap-3"
      >
        <div className="flex flex-col items-end">
          <span className="text-[8px] font-mono text-v51-gold tracking-[0.4em] uppercase">Hierarchy_Detected</span>
          <span className="text-xs font-bold text-white tracking-widest">LEVEL_0{level}</span>
        </div>
        <div className="w-1 h-8 bg-v51-gold shadow-[0_0_10px_#D4AF37]" />
      </motion.div>

      {/* Partículas de Autoridad (Sutiles) */}
      <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-transparent via-v51-gold/50 to-transparent animate-pulse" />
    </div>
  );
};
// FILE: SystemContext.tsx
import React, { createContext, useContext, useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient''; // ImportaciÃ³n desde Gamma

// DefiniciÃ³n de la Interfaz (SoberanÃ­a del Dato)
interface SystemState {
  mode: string;
  activeCoyunturaId: string | null;
}

export const SystemContext = createContext<{ config: SystemState } | null>(null);

export const SystemProvider = ({ children }: { children: React.ReactNode }) => {
  const [config, setConfig] = useState<SystemState>({
    mode: ''NORMAL'',
    activeCoyunturaId: null
  });

  useEffect(() => {
    // SuscripciÃ³n Real-time (TrÃ¡fico Beta)
    const channel = supabase
      .channel(''system_changes'')
      .on(''postgres_changes'', { event: ''UPDATE'', schema: ''public'', table: ''sys_config'' },
        (payload: any) => {
          setConfig((prev) => ({ ...prev, ...payload.new }));
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  return (
    <SystemContext.Provider value={{ config }}>
      {children}
    </SystemContext.Provider>
  );
};

export const useSystem = () => {
  const context = useContext(SystemContext);
  if (!context) throw new Error("useSystem debe usarse dentro de SystemProvider");
  return context;
};

// FILE: TenantContext.tsx
/**
 * PATH: src/core/context/TenantContext.tsx
 * NAME: TenantContext.tsx
 * VERSION: v51.6 - Antigravity
 * LOCATION: Comas, Lima, Peru
 * DATE: March 31, 2026 | 21:58
 * DESCRIPTION: Orquestador de contexto jerÃ¡rquico para el ecosistema VÃA51.
 */

import React, { createContext, useContext, useEffect, useState } from ''react'';
import { createClient, SupabaseClient } from ''@supabase/supabase-js'';

// Estructura de Registro del Sistema (sys_registry)
interface TenantConfig {
  id: string;
  name: string;
  tier: ''ALFA'' | ''BETA'' | ''GAMMA'';
  subdomain: string;
  theme_config: object;
}

interface TenantContextType {
  tenant: TenantConfig | null;
  supabase: SupabaseClient | null;
  loading: boolean;
  error: string | null;
}

const TenantContext = createContext<TenantContextType | undefined>(undefined);

export const TenantProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [tenant, setTenant] = useState<TenantConfig | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // InicializaciÃ³n del Cliente Supabase con UID Maestro
  const supabase = createClient(
    import.meta.env.VITE_SUPABASE_URL,
    import.meta.env.VITE_SUPABASE_ANON_KEY
  );

  useEffect(() => {
    const identifyTenant = async () => {
      try {
        const hostname = window.location.hostname;
        // ExtracciÃ³n del subdominio para identificar el nodo Alfa
        const subdomain = hostname.split(''.'')[0]; 

        // Consulta quirÃºrgica a sys_registry con validaciÃ³n de Tenant
        const { data, error: sbError } = await supabase
          .from(''sys_registry'')
          .select(''*'')
          .eq(''subdomain'', subdomain)
          .single();

        if (sbError) throw new Error(`Node Identification Failed: ${sbError.message}`);

        setTenant(data as TenantConfig);
        
        // Log de AuditorÃ­a en sys_events (Solo Nivel Beta/Gamma)
        await supabase.from(''sys_events'').insert([
          { 
            event_type: ''NODE_ACCESS'', 
            payload: { hostname, tenant_id: data.id },
            master_uid: ''9157ae13-36ac-4259-9680-1d9bd2cada4a'' 
          }
        ]);

      } catch (err: any) {
        setError(err.message);
        console.error(''[VÃA51 ERROR] Critical Isolation Failure:'', err.message);
      } finally {
        setLoading(false);
      }
    };

    identifyTenant();
  }, []);

  return (
    <TenantContext.Provider value={{ tenant, supabase, loading, error }}>
      {children}
    </TenantContext.Provider>
  );
};

export const useTenant = () => {
  const context = useContext(TenantContext);
  if (context === undefined) {
    throw new Error(''useTenant must be used within a TenantProvider - Level BETA Access Required'');
  }
  return context;
};

// FILE: NodeSwitcher.tsx
import React, { useEffect, useState } from ''react'';
import PublicFeed from ''@alfa/views/PublicFeed'';
import AdminControl from ''@alfa/views/AdminControl'';
import PortalHub from ''@beta/components/layout/PortalHub'';

const NodeSwitcher: React.FC = () => {
    const [nodeType, setNodeType] = useState<''ALFA'' | ''BETA'' | ''GAMMA'' | ''LOADING''>(''LOADING'');

    useEffect(() => {
        const host = window.location.hostname;

        if (host.includes(''gamma.'')) {
            setNodeType(''GAMMA''); // Cerebro / Control Total
        } else if (host.includes(''hub.'')) {
            setNodeType(''BETA'');  // TrÃ¡fico / Portal de Sectores
        } else {
            setNodeType(''ALFA'');  // Captura / Feed PÃºblico
        }
    }, []);

    if (nodeType === ''LOADING'') return <div className="bg-black h-screen" />;

    return (
        <div className="v51-sovereign-context">
            {nodeType === ''GAMMA'' && <AdminControl />}
            {nodeType === ''BETA'' && <PortalHub />}
            {nodeType === ''ALFA'' && <PublicFeed />}
        </div>
    );
};

export default NodeSwitcher;
// FILE: RenderEngine.tsx
// src/engines/RenderEngine.tsx
import React, { useEffect, useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient''; 
import { SCHEMA } from ''@gamma/lib/constants'';
import { useTenant } from ''@beta/context/TenantContext'';

interface RenderProps {
  capaId: string;
  variableName: string;
  tituloMonitor: string;
}

export const RenderEngine: React.FC<RenderProps> = ({ capaId, variableName, tituloMonitor }) => {
  const [dato, setDato] = useState<number | null>(null);
  
  // Extraemos la identidad del Tenant actual para filtrar el flujo de datos del Holding
  const { tenant } = useTenant();

  useEffect(() => {
    if (!tenant) return;

    /**
     * 1. Consulta Inicial (Fetch)
     * Traemos el Ãºltimo valor registrado para este cliente y este nodo especÃ­fico.
     */
    const fetchLastValue = async () => {
      const { data, error } = await supabase
        .from(SCHEMA.TABLES.TELEMETRY)
        .select(''valor'')
        .eq(''capa_id'', capaId)
        .eq(''variable_name'', variableName)
        .eq(''tenant_id'', tenant.id) 
        .order(''created_at'', { ascending: false })
        .limit(1)
        .maybeSingle(); // Usamos maybeSingle para evitar errores si la tabla estÃ¡ vacÃ­a

      if (data && !error) {
        setDato(data.valor);
      }
    };

    fetchLastValue();

    /**
     * 2. SuscripciÃ³n en Tiempo Real (Realtime)
     * Escuchamos solo las inserciones que pertenecen a este Tenant.
     */
    const channel = supabase
      .channel(`realtime-${capaId}-${tenant.id}`)
      .on(''postgres_changes'', 
        { 
          event: ''INSERT'', 
          schema: ''public'', 
          table: SCHEMA.TABLES.TELEMETRY, 
          // Ajuste de Clase Mundial: comillas simples para soportar UUID/Text en el filtro
          filter: `capa_id=eq.''${capaId}''` 
        },
        (payload) => {
          // Doble validaciÃ³n de seguridad: Variable y Pertenencia al Tenant
          if (
            payload.new.variable_name === variableName && 
            payload.new.tenant_id === tenant.id
          ) {
            setDato(payload.new.valor);
          }
        }
      ).subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [capaId, variableName, tenant]);

  return (
    <div className="engine-box render">
      <h3>{tituloMonitor}</h3>
      <div className="digital-display">
        {dato !== null ? dato.toFixed(2) : ''---''}
      </div>
      {tenant && (
        <div className="tenant-tag" style={{ fontSize: ''10px'', opacity: 0.6, marginTop: ''8px'' }}>
          ORG: {tenant.name}
        </div>
      )}
    </div>
  );
};

// FILE: V51_Screen_Engine.tsx
/**
 * BETA LAYER: NodeSwitcher
 * FunciÃ³n: Conmutador LÃ³gico de Nodo por Hostname.
 * Norma: Agnosticismo de Interfaz (BifurcaciÃ³n Soberana).
 */

import React, { useEffect, useState } from ''react'';
// CORRECCIÃ“N SOBERANA: Se eliminan las llaves { } porque son exportaciones por defecto
import PublicFeed from ''@alfa/views/PublicFeed'';
import AdminControl from ''@alfa/views/AdminControl'';

const NodeSwitcher: React.FC = () => {
  const [nodeType, setNodeType] = useState<''ALFA'' | ''GAMMA'' | ''LOADING''>(''LOADING'');

  useEffect(() => {
    const hostname = window.location.hostname;

    // LÃ³gica de detecciÃ³n de soberanÃ­a de red
    if (hostname.startsWith(''gamma.'')) {
      setNodeType(''GAMMA'');
    } else {
      setNodeType(''ALFA'');
    }
  }, []);

  if (nodeType === ''LOADING'') {
    return (
      <div className="flex items-center justify-center p-20 animate-pulse">
        <span className="text-[10px] font-mono text-zinc-600 tracking-[0.4em]">
          DETECTING_NODE_AUTHORITY...
        </span>
      </div>
    );
  }

  return (
    <div className="v51-node-context transition-opacity duration-1000">
      {nodeType === ''GAMMA'' ? <AdminControl /> : <PublicFeed />}
    </div>
  );
};

export default NodeSwitcher;
// FILE: useTenant.tsx
import { useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';

export const useTenant = () => {
    const [tenant, setTenant] = useState<any>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchTenant = async () => {
            try {
                // Obtenemos el slug desde el subdominio o variable de entorno
                const slug = import.meta.env.VITE_DEV_CLIENT_SLUG || ''default'';

                const { data, error } = await supabase
                    .from(SCHEMA.TABLES.REGISTRY)
                    .select(''*, node_data:sys_payload_vault(*)'')
                    .eq(''slug'', slug)
                    .single();

                if (error) throw error;
                setTenant(data);
            } catch (err) {
                console.error("[V51-BETA] Tenant lookup failed:", err);
            } finally {
                setLoading(false);
            }
        };

        fetchTenant();
    }, []);

    return { tenant, loading };
};
// FILE: tenant-resolver.tsx
// src/middleware/tenant-resolver.tsx
export function SovereigntyProvider(props: { children: React.ReactNode }) {
    return (
        <div className="sovereign-wrapper">
            {props.children}
        </div>
    );
}

// FILE: AdminControl.tsx
/**
 * FUNCIÃ“N: Panel de Control EstratÃ©gico (Nodo GAMMA)
 * LUGAR: /views/AdminControl.tsx
 * FECHA: 02-Abr-2026 | 18:15
 * DESCRIPCIÃ“N: Dashboard de moderaciÃ³n con analÃ­tica de sentimiento en tiempo real.
 */

import React, { useState, useEffect } from ''react'';
import { supabase } from ''@gamma/lib/supabase'';
import SentimentChart from ''../components/charts/SentimentChart'';
import { motion, AnimatePresence } from ''framer-motion'';

interface Interaction {
    id: string;
    content: string;
    sender_name: string;
    status: ''pending'' | ''approved'' | ''rejected'';
    created_at: string;
}

const AdminControl: React.FC = () => {
    const [items, setItems] = useState<Interaction[]>([]);
    const [chartData, setChartData] = useState<{ time: string, volumen: number }[]>([]);

    const fetchData = async () => {
        const { data, error } = await supabase
            .from(''sys_interactions'')
            .select(''*'')
            .order(''created_at'', { ascending: true });

        if (!error && data) {
            setItems(data.filter(i => i.status === ''pending''));

            // TransformaciÃ³n de datos para la grÃ¡fica (Agrupado por minutos)
            const groups = data.reduce((acc: any, item) => {
                const time = new Date(item.created_at).toLocaleTimeString([], { hour: ''2-digit'', minute: ''2-digit'' });
                acc[time] = (acc[time] || 0) + 1;
                return acc;
            }, {});

            const formatted = Object.keys(groups).map(time => ({
                time,
                volumen: groups[time]
            }));
            setChartData(formatted);
        }
    };

    const handleAction = async (id: string, newStatus: ''approved'' | ''rejected'') => {
        const { error } = await supabase
            .from(''sys_interactions'')
            .update({ status: newStatus })
            .eq(''id'', id);

        if (!error) fetchData();
    };

    useEffect(() => {
        fetchData();
        // SuscripciÃ³n Real-time para la grÃ¡fica
        const channel = supabase.channel(''schema-db-changes'')
            .on(''postgres_changes'', { event: ''*'', schema: ''public'', table: ''sys_interactions'' }, () => fetchData())
            .subscribe();

        return () => { supabase.removeChannel(channel); };
    }, []);

    return (
        <div className="space-y-8">
            <header>
                <h2 className="text-xs font-black text-blue-600 uppercase tracking-[0.3em] mb-1">MÃ©tricas de OperaciÃ³n</h2>
                <h1 className="text-2xl font-bold text-slate-900 tracking-tight">Panel Gamma</h1>
            </header>

            {/* GrÃ¡fica de Sentimiento / Volumen */}
            <SentimentChart data={chartData} />

            <section className="space-y-4">
                <h3 className="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Cola de ModeraciÃ³n ({items.length})</h3>
                <AnimatePresence>
                    {items.map((item) => (
                        <motion.div
                            key={item.id}
                            initial={{ opacity: 0, y: 10 }}
                            animate={{ opacity: 1, y: 0 }}
                            exit={{ opacity: 0, x: -20 }}
                            className="p-5 bg-white border border-slate-200 rounded-3xl shadow-sm"
                        >
                            <div className="flex justify-between mb-3">
                                <span className="text-[10px] font-bold text-slate-800 uppercase tracking-tighter">{item.sender_name}</span>
                                <span className="text-[9px] font-mono text-slate-300">{new Date(item.created_at).toLocaleTimeString()}</span>
                            </div>
                            <p className="text-slate-600 text-sm mb-5 leading-relaxed italic">"{item.content}"</p>
                            <div className="grid grid-cols-2 gap-3">
                                <button onClick={() => handleAction(item.id, ''rejected'')} className="py-3 text-[10px] font-bold uppercase bg-slate-50 text-slate-400 rounded-xl hover:bg-red-50 hover:text-red-500 transition-all">Descartar</button>
                                <button onClick={() => handleAction(item.id, ''approved'')} className="py-3 text-[10px] font-bold uppercase bg-blue-600 text-white rounded-xl shadow-lg hover:bg-blue-700 active:scale-95 transition-all">Aprobar</button>
                            </div>
                        </motion.div>
                    ))}
                </AnimatePresence>
            </section>
        </div>
    );
};

export default AdminControl;

// FILE: CitizenEmitter.tsx
/**
 * FUNCIÃ“N: Componente de CaptaciÃ³n de Sentimiento (Nodo BETA - Ciudadano)
 * LUGAR: /views/CitizenEmitter.tsx
 * FECHA: 02-Abr-2026 | 18:15
 * DESCRIPCIÃ“N: Interfaz de entrada para el votante con validaciÃ³n de tipos y persistencia UUID.
 * ARQUITECTURA: React 18 + TypeScript + Framer Motion + Supabase.
 * OPERACIÃ“N: 12-A (Ecosistema VÃ­a51)
 */

import React, { useState, FormEvent, ChangeEvent } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { motion, AnimatePresence } from ''framer-motion'';

/**
 * IDENTIFICADOR SOBERANO:
 * UUID v5 derivado de la cadena "12-A". 
 * Garantiza integridad referencial en la base de datos PostgreSQL.
 */
const OPERACION_UUID = ''6ba7b810-9dad-11d1-80b4-00c04fd430c8'';

// DefiniciÃ³n de Esquema de Datos
interface InteractionForm {
    sender_name: string;
    content: string;
}

type NodeStatus = ''idle'' | ''transmitting'' | ''success'' | ''error'';

const CitizenEmitter: React.FC = () => {
    // Estado inicial del formulario
    const [fields, setFields] = useState<InteractionForm>({
        sender_name: '''',
        content: ''''
    });

    // Estado de flujo de red
    const [status, setStatus] = useState<NodeStatus>(''idle'');

    // LÃ³gica de ValidaciÃ³n (FricciÃ³n Cero)
    const isReady: boolean =
        fields.sender_name.trim().length >= 3 &&
        fields.content.trim().length >= 5;

    /**
     * Manejador de entrada de datos con tipado seguro
     */
    const handleInputChange = (
        e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
    ): void => {
        const { name, value } = e.target;
        setFields((prev) => ({ ...prev, [name]: value }));
    };

    /**
     * EnvÃ­o de datos al Nodo Central (Supabase)
     */
    const dispatchInteraction = async (e: FormEvent): Promise<void> => {
        e.preventDefault();
        if (!isReady || status === ''transmitting'') return;

        setStatus(''transmitting'');

        try {
            const { error } = await supabase
                .from(''sys_interactions'')
                .insert([
                    {
                        sender_name: fields.sender_name,
                        content: fields.content,
                        status: ''pending'',
                        tenant_id: OPERACION_UUID
                    }
                ]);

            if (error) throw error;

            setStatus(''success'');
            setFields({ sender_name: '''', content: '''' });

            // Retorno al estado de escucha tras 3 segundos
            setTimeout(() => setStatus(''idle''), 3000);
        } catch (err: any) {
            console.error("[ERROR_NODO_BETA]: Fallo en transmisiÃ³n", err);
            setStatus(''error'');
            setTimeout(() => setStatus(''idle''), 5000);
        }
    };

    return (
        <motion.section
            initial={{ opacity: 0, scale: 0.98 }}
            animate={{ opacity: 1, scale: 1 }}
            className="flex flex-col min-h-[80vh] px-2 py-4 justify-between"
        >
            {/* Header de Propuesta */}
            <div className="space-y-3">
                <h1 className="text-3xl font-black text-slate-900 tracking-tighter leading-none">
                    TU VOZ <br />
                    <span className="text-blue-600 uppercase">ES EL PUENTE.</span>
                </h1>
                <p className="text-slate-500 text-sm font-medium leading-relaxed max-w-[280px]">
                    EnvÃ­a tu idea. El Nodo Gamma validarÃ¡ tu mensaje para el muro pÃºblico.
                </p>
            </div>

            {/* Formulario de InteracciÃ³n */}
            <form onSubmit={dispatchInteraction} className="space-y-6 mt-8">
                <div className="space-y-1">
                    <label className="text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400 ml-1">
                        IdentificaciÃ³n (Alias)
                    </label>
                    <input
                        name="sender_name"
                        type="text"
                        value={fields.sender_name}
                        onChange={handleInputChange}
                        placeholder="Ej. VecinoActivo_51"
                        disabled={status !== ''idle''}
                        className="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-600/5 focus:border-blue-600 outline-none transition-all font-medium text-slate-800"
                    />
                </div>

                <div className="space-y-1">
                    <label className="text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400 ml-1">
                        Propuesta de Mejora
                    </label>
                    <textarea
                        name="content"
                        rows={6}
                        value={fields.content}
                        onChange={handleInputChange}
                        placeholder="Escribe aquÃ­ tu visiÃ³n..."
                        disabled={status !== ''idle''}
                        className="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-600/5 focus:border-blue-600 outline-none transition-all font-medium text-slate-800 resize-none"
                    />
                </div>

                <AnimatePresence mode="wait">
                    <motion.button
                        key={status}
                        type="submit"
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        disabled={!isReady || status === ''transmitting'' || status === ''success''}
                        className={`w-full py-5 rounded-2xl font-bold text-xs uppercase tracking-[0.3em] shadow-2xl transition-all active:scale-95
              ${status === ''success''
                                ? ''bg-green-500 text-white shadow-green-200''
                                : status === ''error''
                                    ? ''bg-red-500 text-white''
                                    : ''bg-blue-600 text-white shadow-blue-200 hover:bg-blue-700 disabled:opacity-40 disabled:grayscale''
                            }`}
                    >
                        {status === ''idle'' && ''Transmitir Propuesta''}
                        {status === ''transmitting'' && ''Sincronizando Nodos...''}
                        {status === ''success'' && ''Â¡Mensaje en el Puente!''}
                        {status === ''error'' && ''Fallo de Red - Reintentar''}
                    </motion.button>
                </AnimatePresence>
            </form>

            {/* Footer de Integridad Operativa */}
            <footer className="mt-12 flex flex-col items-center space-y-3">
                <div className="h-px w-12 bg-slate-200"></div>
                <div className="flex items-center gap-2">
                    <div className="w-2 h-2 bg-blue-600 rounded-full animate-pulse shadow-[0_0_8px_rgba(37,99,235,0.6)]"></div>
                    <span className="text-[10px] font-black text-slate-300 uppercase tracking-widest">
                        SoberanÃ­a de Datos: Nodo 12-A Activo
                    </span>
                </div>
            </footer>
        </motion.section>
    );
};

export default CitizenEmitter;

// FILE: PublicFeed.tsx
/**
 * ALFA LAYER: PublicFeed
 * Función: Visualización agnóstica de interacciones aprobadas.
 * Norma: Soberanía del Dato (Usa SCHEMA.TABLES.INTERACTIONS)
 */

import React, { useEffect, useState } from ''react'';
import { supabase } from ''@gamma/lib/supabaseClient'';
import { SCHEMA } from ''@gamma/lib/constants'';

// Interfaz de Integridad (Evita error ''never'')
interface InteractionMessage {
    id: string;
    content: string;
    sender_name: string;
    created_at: string;
}

const PublicFeed: React.FC = () => {
    const [messages, setMessages] = useState<InteractionMessage[]>([]);

    useEffect(() => {
        // Envoltura Síncrona para Lógica Asíncrona (Norma React)
        const fetchApproved = async () => {
            const { data, error } = await supabase
                .from(SCHEMA.TABLES.INTERACTIONS)
                .select(''id, content, sender_name, created_at'')
                .eq(''status'', ''approved'')
                .order(''created_at'', { ascending: false });

            if (!error) setMessages(data || []);
        };

        fetchApproved();

        // Suscripción Real-time (Tráfico Beta)
        const channel = supabase
            .channel(''public_feed'')
            .on(''postgres_changes'',
                { event: ''UPDATE'', schema: ''public'', table: SCHEMA.TABLES.INTERACTIONS },
                fetchApproved
            )
            .subscribe();

        return () => {
            supabase.removeChannel(channel);
        };
    }, []);

    return (
        <div className="space-y-6">
            <div className="pb-4 border-b border-zinc-800">
                <h2 className="text-[10px] font-black uppercase tracking-[0.3em] text-blue-500">
                    LIVE_STREAM: AGNOSTIC_INTERACTIONS
                </h2>
            </div>

            {messages.length === 0 ? (
                <div className="py-20 text-center opacity-50">
                    <p className="text-zinc-500 text-xs italic font-mono">AWAITING_VOICES...</p>
                </div>
            ) : (
                <div className="space-y-4">
                    {messages.map((msg) => (
                        <article key={msg.id} className="p-5 rounded-xl bg-zinc-900/50 border border-zinc-800 hover:border-zinc-700 transition-all animate-in fade-in duration-700">
                            <div className="flex justify-between items-start mb-3">
                                <span className="text-[10px] font-bold text-zinc-300 uppercase tracking-wider">{msg.sender_name}</span>
                                <span className="text-[9px] text-zinc-500 font-mono">
                                    {new Date(msg.created_at).toLocaleTimeString()}
                                </span>
                            </div>
                            <p className="text-sm text-zinc-400 leading-relaxed font-light">
                                {msg.content}
                            </p>
                        </article>
                    ))}
                </div>
            )}
        </div>
    );
};

export default PublicFeed;


// FILE: App.tsx
import React from "react";
import { V51CommandWorkbench } from "../hangar/components/V51CommandWorkbench";

function App() {
  return <V51CommandWorkbench />;
}
export default App;
// FILE: main.tsx
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
// FILE: layout.tsx
// FILE: CommandCenter.tsx
// LÃ³gica de Doble AprobaciÃ³n en Gamma
const handleFirstApproval = async (id: string) => {
    // 1. Aprueba Fredy
    // 2. Beta envÃ­a WhatsApp al Colaborador (Simulado)
    // 3. Queda a la espera de confirmaciÃ³n para la 2da aprobaciÃ³n
    console.log("Primera aprobaciÃ³n concedida. Enviando validaciÃ³n al colaborador...");
};
// FILE: UploadSandbox.tsx
import React, { useState } from ''react'';

export const UploadSandbox = () => {
    const [status, setStatus] = useState(''IDLE'');

    const handleUpload = async (e: any) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        const userData = Object.fromEntries(formData);

        setStatus(''UPLOADING'');

        // SimulaciÃ³n de captura de archivo
        const material = { type: ''document'', name: ''propuesta.pdf'', size: ''2MB'' };

        const res = await fetch(''http://localhost:3000/api/v1/contributions/upload'', {
            method: ''POST'',
            headers: { ''Content-Type'': ''application/json'' },
            body: JSON.stringify({ userData, material })
        });

        if (res.ok) {
            setStatus(''SUCCESS'');
            alert("Registro exitoso. Su material estÃ¡ en evaluaciÃ³n.");
        }
    };

    return (
        <div className="bg-zinc-900 p-6 border border-zinc-800">
            <h2 className="text-green-500 font-bold mb-4">SANDBOX: INSCRIPCIÃ“N Y APORTES</h2>
            <form onSubmit={handleUpload} className="space-y-3">
                <input name="name" placeholder="Nombres" required className="w-full bg-black p-2 text-xs border border-zinc-700" />
                <input name="surname" placeholder="Apellidos" required className="w-full bg-black p-2 text-xs border border-zinc-700" />
                <input name="dni" placeholder="DNI" required className="w-full bg-black p-2 text-xs border border-zinc-700" />
                <input name="email" type="email" placeholder="Email" required className="w-full bg-black p-2 text-xs border border-zinc-700" />
                <input name="phone" placeholder="Celular" required className="w-full bg-black p-2 text-xs border border-zinc-700" />

                <div className="border-2 border-dashed border-zinc-700 p-4 text-center text-[10px] text-zinc-500">
                    Arrastre aquÃ­ su material (Texto, Audio, Video)
                    <input type="file" className="hidden" id="file_up" />
                </div>

                <button className="w-full bg-green-600 text-black font-bold p-3 text-xs uppercase">
                    {status === ''UPLOADING'' ? ''Procesando...'' : ''Registrar y Subir Aporte''}
                </button>
            </form>
        </div>
    );
};
// FILE: GammaBrainRouter.tsx
/**
 * PATH: src/layers/gamma/pages/GammaBrainRouter.tsx
 * ROLE: Nivel 2 - GAMMA (Cerebro)
 * DESC: Orquestador de rutas de alto nivel y control de acceso.
 */

import React from ''react'';
// CORRECCIÃ“N SOBERANA: Se elimina la extensiÃ³n .tsx para cumplir con el estÃ¡ndar ESM
import NodeSwitcher from ''@beta/core-tools/NodeSwitcher'';

export const GammaBrainRouter: React.FC = () => {
    return (
        <div className="min-h-screen bg-[#050505] flex items-center justify-center p-6 relative overflow-hidden">
            {/* Background Texture */}
            <div className="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-blue-900/20 via-transparent to-transparent pointer-events-none" />

            <div className="w-full max-w-4xl z-10 bg-zinc-900/40 backdrop-blur-xl border border-zinc-800 p-8 md:p-12 rounded-[2rem] shadow-2xl shadow-blue-900/10">
                <header className="mb-10 text-center">
                    <h2 className="text-[10px] font-black tracking-[0.5em] text-blue-500 uppercase">
                        GAMMA_BRAIN_ROUTER_ONLINE
                    </h2>
                </header>

                {/* Punto de entrada al Switcher Beta */}
                <NodeSwitcher />
            </div>
        </div>
    );
};

export default GammaBrainRouter;
// FILE: PillarOrchestrator.tsx
import React, { useState } from ''react'';
import AlphaMutationView from ''../alfa/AlphaMutationView'';
import SystemCommand from ''./SystemCommand'';

export type PillarType = ''POLITICO'' | ''SOCIAL'' | ''PRODUCTIVO'';

const PillarOrchestrator: React.FC = () => {
  const [activePillar, setActivePillar] = useState<PillarType | null>(null);
  const [isMutationOpen, setIsMutationOpen] = useState(false);

  const handlePillarClick = (pillar: PillarType) => {
    setActivePillar(pillar);
    setIsMutationOpen(true);
  };

  const handleClose = () => {
    setIsMutationOpen(false);
    setTimeout(() => setActivePillar(null), 400); 
  };

  return (
    <div className="hero-bg">
      <SystemCommand 
        command={activePillar ? `ACTIVATING_${activePillar}` : ''WAITING_CEO_INPUT''} 
        status={activePillar ? ''active'' : ''idle''} 
      />

      <nav className="contenedor-semaforo">
        <button className="boton-ceo" onClick={() => handlePillarClick(''POLITICO'')}>EJE POLÃTICO</button>
        <button className="boton-ceo" onClick={() => handlePillarClick(''SOCIAL'')}>EJE SOCIAL</button>
        <button className="boton-ceo" onClick={() => handlePillarClick(''PRODUCTIVO'')}>EJE PRODUCTIVO</button>
      </nav>

      <AlphaMutationView 
        isOpen={isMutationOpen} 
        pillar={activePillar} 
        onClose={handleClose} 
      />
    </div>
  );
};

export default PillarOrchestrator;

// FILE: SystemCommand.tsx
import React from ''react'';

interface SystemCommandProps {
  command: string;
  status: ''active'' | ''idle'' | ''critical'';
}

const SystemCommand: React.FC<SystemCommandProps> = ({ command, status }) => {
  return (
    <div className={`system-command-display ${status}`}>
      <span className="command-label">CMD:</span>
      <code className="command-text">{command}</code>
    </div>
  );
};

export default SystemCommand;

// FILE: LoadingKernel.tsx
import React from ''react'';

const LoadingKernel = () => (
  <div className="min-h-screen bg-black flex flex-col items-center justify-center">
    {/* AnimaciÃ³n de SincronizaciÃ³n */}
    <div className="relative w-20 h-20 mb-6">
      <div className="absolute inset-0 border-t-2 border-blue-500 rounded-full animate-spin"></div>
      <div className="absolute inset-0 border-r-2 border-red-500/30 rounded-full animate-pulse"></div>
    </div>
    
    <div className="text-center">
      <h3 className="text-zinc-500 font-bold tracking-[0.5em] text-[10px] uppercase mb-2">
        Gamma Engine v3.0
      </h3>
      <p className="text-white/40 font-light text-[9px] uppercase tracking-widest">
        Sincronizando Pilares del Holding...
      </p>
    </div>
  </div>
);

export default LoadingKernel;

// FILE: V51_Lienzo_Adaptativo.tsx
/**
 * RUTA: src/layers/ui/V51_Lienzo_Adaptativo.tsx
 * LUGAR: Comas, Lima, PerÃº
 * FECHA: 2026-04-04 | HORA: 10:45
 * INTENCIÃ“N: Implementar el Portal Nivel 0. 
 * - Mobile Vertical: 100% Pantalla (Noticia Estelar).
 * - Desktop/Horizontal: Celular centrado con flancos de informaciÃ³n.
 */

import React from ''react'';

interface V51LienzoProps {
    mediaUrl: string;       // El video del Chaski / Candidato
    infoIzquierda: string;  // Frase "Primeros en calificaciones..."
    infoDerecha: string;    // Frase "Mover el piso..."
    tituloSeccion?: string; // Ej: "ELECCIONES 2026"
}

export const V51_Lienzo_Adaptativo: React.FC<V51LienzoProps> = ({
    mediaUrl,
    infoIzquierda,
    infoDerecha,
    tituloSeccion = "COYUNTURA NIVEL 0"
}) => {
    return (
        <div className="flex h-screen w-full bg-[#050505] overflow-hidden items-center justify-center selection:bg-[#0047AB]/30">

            {/* --- FLANCO IZQUIERDO (Solo visible en pantallas horizontales/grandes) --- */}
            <aside className="hidden lg:flex flex-1 h-full items-center justify-end px-12 z-10 animate-fade-in">
                <div className="max-w-xs text-right border-r-2 border-[#0047AB] pr-8 py-2">
                    <span className="text-[#0047AB] font-mono text-[10px] tracking-[0.4em] uppercase block mb-4">
                        Status_PolÃ­tico
                    </span>
                    <h2 className="text-white text-2xl font-light leading-tight tracking-tight">
                        {infoIzquierda}
                    </h2>
                </div>
            </aside>

            {/* --- LIENZO CENTRAL: EL CELULAR (Protagonismo siempre) --- */}
            <section className="relative h-full w-full lg:w-auto lg:aspect-[9/16] bg-black shadow-[0_0_100px_rgba(0,71,171,0.2)] z-20 overflow-hidden">

                {/* Notch estÃ©tico para reforzar la idea de celular */}
                <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-6 bg-[#050505] rounded-b-2xl z-30 hidden lg:block" />

                {/* Media de la Noticia Estelar */}
                <video
                    src={mediaUrl}
                    className="h-full w-full object-cover"
                    autoPlay
                    loop
                    muted
                    playsInline
                />

                {/* Etiqueta de Identidad V51 */}
                <div className="absolute bottom-8 left-0 right-0 flex flex-col items-center gap-2 pointer-events-none">
                    <div className="bg-[#0047AB] text-white px-6 py-1 shadow-lg shadow-blue-900/40">
                        <span className="text-[10px] font-black tracking-[0.5em] uppercase">
                            {tituloSeccion}
                        </span>
                    </div>
                    <span className="text-white/30 text-[8px] font-mono tracking-widest">
                        VÃA51_CORE_ENGINE_V2
                    </span>
                </div>
            </section>

            {/* --- FLANCO DERECHO (Solo visible en pantallas horizontales/grandes) --- */}
            <aside className="hidden lg:flex flex-1 h-full items-center justify-start px-12 z-10 animate-fade-in">
                <div className="max-w-xs text-left border-l-2 border-white/20 pl-8 py-2">
                    <span className="text-white/40 font-mono text-[10px] tracking-[0.4em] uppercase block mb-4">
                        AcciÃ³n_Directa
                    </span>
                    <p className="text-white/80 text-xl italic font-serif leading-snug">
                        "{infoDerecha}"
                    </p>
                </div>
            </aside>

        </div>
    );
};

// FILE: V51_Portal_Lienzo.tsx
/**
 * RUTA: src/layers/ui/V51_Portal_Lienzo.tsx
 * LUGAR: Comas, Lima, PerÃº
 * FECHA: 2026-04-04 | HORA: 10:15
 * INTENCIÃ“N: ImplementaciÃ³n del Motor Universal de VisualizaciÃ³n (Lienzo Nivel 0). 
 * Mantiene verticalidad 9:16 al centro y expande flancos en horizontal. 
 * NO CONTIENE DATOS HARDCODEADOS.
 */

import React from ''react'';

interface V51PortalProps {
    /** URL del recurso multimedia (video/imagen) de la noticia estelar */
    mediaUrl: string;
    /** Contenido dinÃ¡mico para el flanco izquierdo (Modo Horizontal) */
    leftContent?: React.ReactNode;
    /** Contenido dinÃ¡mico para el flanco derecho (Modo Horizontal) */
    rightContent?: React.ReactNode;
    /** Frase o etiqueta de estado (Opcional) */
    statusTag?: string;
}

export const V51_Portal_Lienzo: React.FC<V51PortalProps> = ({
    mediaUrl,
    leftContent,
    rightContent,
    statusTag = "COYUNTURA ACTIVA"
}) => {
    return (
        <div className="flex h-screen w-full bg-[#050505] overflow-hidden items-center justify-center">

            {/* ALA IZQUIERDA: Se activa en pantallas anchas (Landscape) */}
            <aside className="hidden lg:flex flex-1 h-full items-center justify-center p-10 animate-fade-in">
                <div className="w-full max-w-xs border-l-2 border-[#0047AB] pl-6 py-4">
                    <div className="text-[#0047AB] font-mono text-sm tracking-tighter opacity-80 mb-2">
                        NODO_ALFA_SYSTEM_DATA
                    </div>
                    <div className="text-white/90 text-lg leading-tight">
                        {leftContent}
                    </div>
                </div>
            </aside>

            {/* LIENZO CENTRAL: La "Noticia Estelar" (Celular) */}
            <section className="relative h-full aspect-[9/16] bg-black shadow-[0_0_80px_rgba(0,71,171,0.15)] z-20 overflow-hidden border-x border-white/5">

                {/* Notch/Sensor Visual Superior */}
                <div className="absolute top-4 left-1/2 -translate-x-1/2 w-20 h-1.5 bg-zinc-800/50 rounded-full z-30" />

                {/* Renderizado de Media */}
                <video
                    key={mediaUrl} // Fuerza recarga si cambia el dominio
                    src={mediaUrl}
                    className="h-full w-full object-cover"
                    autoPlay
                    loop
                    muted
                    playsInline
                />

                {/* Overlay de SoberanÃ­a Nivel 0 */}
                <div className="absolute bottom-12 left-0 right-0 flex justify-center pointer-events-none">
                    <div className="bg-[#0047AB] text-white px-4 py-1.5 rounded-sm shadow-lg">
                        <span className="text-[9px] font-bold tracking-[0.3em] uppercase">
                            {statusTag}
                        </span>
                    </div>
                </div>
            </section>

            {/* ALA DERECHA: Se activa en pantallas anchas (Landscape) */}
            <aside className="hidden lg:flex flex-1 h-full items-center justify-center p-10 animate-fade-in">
                <div className="w-full max-w-xs border-r-2 border-white/40 pr-6 py-4 text-right">
                    <div className="text-white/40 font-mono text-[10px] tracking-widest mb-2">
                        NODO_BETA_OPERATIONS
                    </div>
                    <div className="text-white/70 text-base italic font-light">
                        {rightContent}
                    </div>
                </div>
            </aside>

        </div>
    );
};

// FILE: V51_Visor_Animado.tsx
/**
 * UI COMPONENT: V51_Visor_Animado
 * FunciÃ³n: Renderizado cÃ­clico de activos visuales con transiciones suaves.
 * Capa: UI (Componente AtÃ³mico)
 */

import React, { useState, useEffect } from ''react'';

interface VisorProps {
    slides: string[];
    frasePrincipal: string;
    fraseSecundaria: string;
    posicion?: ''left'' | ''center'' | ''right'';
}

export const V51_Visor_Animado: React.FC<VisorProps> = ({
    slides,
    frasePrincipal,
    fraseSecundaria,
    posicion = ''center''
}) => {
    const [index, setIndex] = useState(0);

    // Ciclo de transiciÃ³n automÃ¡tica
    useEffect(() => {
        const timer = setInterval(() => {
            setIndex((prev) => (prev + 1) % slides.length);
        }, 5000);
        return () => clearInterval(timer);
    }, [slides.length]);

    return (
        <div className="relative w-full h-full bg-black overflow-hidden">
            {/* 1. CAPA DE IMAGEN (SoberanÃ­a Visual) */}
            {slides.map((img, i) => (
                <div
                    key={i}
                    className={`absolute inset-0 transition-opacity duration-1000 ease-in-out ${i === index ? ''opacity-100'' : ''opacity-0''
                        }`}
                >
                    <img
                        src={img}
                        alt={`Slide ${i}`}
                        className="w-full h-full object-cover"
                    />
                    {/* Overlay de profundidad para legibilidad */}
                    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/20" />
                </div>
            ))}

            {/* 2. CAPA DE TEXTO (Capa Alfa inyectada) */}
            <div className={`absolute bottom-20 w-full px-10 flex flex-col z-10 
        ${posicion === ''center'' ? ''items-center text-center'' :
                    posicion === ''left'' ? ''items-start text-left'' : ''items-end text-right''}`}>

                <h2 className="text-white text-2xl font-bold tracking-tighter leading-none mb-2 uppercase italic">
                    {frasePrincipal}
                </h2>

                <div className="h-[2px] w-12 bg-v51-cobalt mb-3" />

                <p className="text-zinc-400 text-xs font-mono tracking-widest uppercase">
                    {fraseSecundaria}
                </p>
            </div>

            {/* 3. INDICADORES FRACTALES */}
            <div className="absolute bottom-8 w-full flex justify-center gap-2 z-10">
                {slides.map((_, i) => (
                    <div
                        key={i}
                        className={`h-[2px] transition-all duration-500 ${i === index ? ''w-8 bg-v51-cobalt'' : ''w-2 bg-zinc-700''
                            }`}
                    />
                ))}
            </div>
        </div>
    );
};

export default V51_Visor_Animado;

// FILE: App.tsx
import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import { AlfaPortal } from "../hangar/components/AlfaPortal";
import { SoberanaView } from "../hangar/components/SoberanaView";
import { MasterIngestor } from "../hangar/components/MasterIngestor";
import { V51CommandWorkbench } from "../hangar/components/V51CommandWorkbench";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/v51/mando" element={<V51CommandWorkbench />} />
        <Route path="/ingestor" element={<MasterIngestor />} />
        <Route path="/" element={<AlfaPortal />} />
        <Route path="/:issueCode" element={<SoberanaView />} />
      </Routes>
    </Router>
  );
};
export default App;
// FILE: main.tsx
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
// FILE: AbsorptionTheory.tsx
import { motion } from ''framer-motion'';
export const AbsorptionTheory = () => (
  <div className="p-8 border border-v51-gold/10 bg-v51-gold/5">
    <h3 className="text-v51-gold font-mono text-xs tracking-widest mb-4 uppercase">TeorÃ­a de la AbsorciÃ³n</h3>
    <div className="grid grid-cols-10 gap-1 opacity-20">
      {[...Array(50)].map((_, i) => <div key={i} className="aspect-square bg-white/10" />)}
    </div>
  </div>
);
// FILE: DismantlingGraph.tsx
import { motion } from ''framer-motion'';
export const DismantlingGraph = () => (
  <div className="p-6 border border-red-900/20 bg-red-900/5">
    <h4 className="text-[10px] font-mono text-red-500 uppercase mb-4">Progreso de Desmantelamiento</h4>
    <div className="h-2 w-full bg-white/5"><div className="h-full bg-v51-gold" style={{width: ''2%''}}></div></div>
    <p className="text-[8px] mt-2 text-gray-500 font-mono">ESTADO: INFILTRACIÃ“N INICIADA</p>
  </div>
);
// FILE: IntelligenceSearch.tsx
export const IntelligenceSearch = () => (
  <div className="p-6 border border-white/5 bg-black">
    <input type="text" placeholder="INTERROGAR DNI..." className="w-full bg-transparent border-b border-white/10 p-2 text-[10px] outline-none focus:border-v51-gold" />
  </div>
);
// FILE: RegionalAnalysis.tsx
export const RegionalAnalysis = () => (
  <div className="p-6 border border-white/5 bg-white/[0.02]">
    <h4 className="text-[10px] font-mono text-gray-500 uppercase mb-4">ConcentraciÃ³n Regional</h4>
    <div className="space-y-2 text-[9px] font-mono">
      <div className="flex justify-between"><span>LIMA</span><span className="text-v51-gold">17,255</span></div>
      <div className="flex justify-between"><span>HUANUCO</span><span className="text-v51-gold">736</span></div>
    </div>
  </div>
);
// FILE: ArticleSovereign.tsx
import React from ''react'';

interface Props {
  activeLang: ''es'' | ''qu'' | ''en'';
  content: {
    [key: string]: { title: string; body: string };
  };
  issueCode: string;
}

export const ArticleSovereign: React.FC<Props> = ({ activeLang, content, issueCode }) => {
  const data = content[activeLang];
  if (!data) return null;

  // DNA de Trazabilidad (Art. 5 de la Carta Magna)
  const v51_dna = `V51-DNA-${issueCode}-${activeLang.toUpperCase()}-SECURED`;

  return (
    <div className="w-full flex flex-col gap-12">
      {/* TITULO: Peso Maximo y Tracking Negativo para Impacto */}
      <h1 style={{ 
        fontSize: ''clamp(2rem, 5vw, 4rem)'', 
        fontWeight: 900, 
        lineHeight: 1, 
        letterSpacing: ''-0.05em'',
        color: ''white'',
        textTransform: ''uppercase''
      }}>
        {data.title}
      </h1>

      {/* CUERPO: Contraste Optimizado y Borde de Oro */}
      <div style={{ 
        borderLeft: ''3px solid #D4AF37'', 
        paddingLeft: ''2.5rem'',
        display: ''flex'',
        flexDirection: ''column'',
        gap: ''2rem''
      }}>
        <p style={{ 
          fontSize: ''clamp(1.1rem, 2vw, 1.8rem)'', 
          lineHeight: 1.6, 
          color: ''#E5E5E5'', 
          fontWeight: 300,
          whiteSpace: ''pre-line''
        }}>
          {data.body}
        </p>
      </div>

      {/* SELLO DE SOBERANIA (DNA) */}
      <footer style={{ 
        marginTop: ''4rem'', 
        paddingTop: ''2rem'', 
        borderTop: ''1px solid rgba(255,255,255,0.05)'',
        display: ''flex'',
        justifyContent: ''space-between'',
        alignItems: ''center''
      }}>
        <span style={{ fontSize: ''10px'', color: ''#D4AF37'', fontWeight: 900, letterSpacing: ''0.3em'' }}>
          VIA51 HOLDING
        </span>
        <span style={{ fontSize: ''9px'', color: ''rgba(255,255,255,0.2)'', fontFamily: ''monospace'' }}>
          {v51_dna}
        </span>
      </footer>
    </div>
  );
};
// FILE: SovereignReader.tsx
interface SovereignReaderProps {
  title: string;
  content: string;
  concept: string;
}
export const SovereignReader = ({ title, content, concept }: SovereignReaderProps) => (
  <div style={{ borderLeft: ''2px solid #D4AF37'', paddingLeft: ''20px'', margin: ''20px 0'' }}>
    <span style={{ color: ''#D4AF37'', fontSize: ''10px'', textTransform: ''uppercase'' }}>{concept}</span>
    <h2 style={{ fontSize: ''32px'', fontWeight: ''900'', color: ''#fff'' }}>{title}</h2>
    <p style={{ color: ''#ccc'', fontSize: ''18px'', lineHeight: ''1.6'' }}>{content}</p>
  </div>
);
// FILE: index.tsx
import React from ''react'';
import { Link } from ''react-router-dom'';

const IndexPage = () => {
  return (
    <div style={{ minHeight: ''100vh'', backgroundColor: ''black'', color: ''white'', display: ''flex'', flexDirection: ''column'', alignItems: ''center'', justifyContent: ''center'', fontFamily: ''system-ui, sans-serif'' }}>
      <header style={{ textAlign: ''center'', marginBottom: ''10vh'' }}>
        <h1 style={{ fontSize: ''10px'', letterSpacing: ''1.2em'', color: ''#D4AF37'', fontWeight: 900, marginBottom: ''20px'' }}>VIA51 HOLDING</h1>
        <div style={{ fontSize: ''3rem'', fontWeight: 900, letterSpacing: ''0.3em'' }}>SISTEMA ANTIGRAVITY</div>
      </header>

      <nav style={{ display: ''flex'', flexDirection: ''column'', gap: ''2rem'', alignItems: ''center'' }}>
        <Link to="/articles/20260501001" style={{ 
          textDecoration: ''none'', color: ''white'', border: ''1px solid rgba(212,175,55,0.3)'', 
          padding: ''20px 40px'', fontSize: ''12px'', fontWeight: 900, letterSpacing: ''0.5em'',
          transition: ''all 0.5s ease''
        }}
        onMouseEnter={(e) => { e.currentTarget.style.backgroundColor = ''#D4AF37''; e.currentTarget.style.color = ''black''; }}
        onMouseLeave={(e) => { e.currentTarget.style.backgroundColor = ''transparent''; e.currentTarget.style.color = ''white''; }}
        >
          PRODUCCION SOBERANA (2026.05.01)
        </Link>
      </nav>

      <footer style={{ position: ''fixed'', bottom: ''5vh'', fontSize: ''9px'', color: ''rgba(255,255,255,0.2)'', letterSpacing: ''0.5em'' }}>
        ESTADO: OPERATIVO | BUNKER V51
      </footer>
    </div>
  );
};

export default IndexPage;
// FILE: 20260501001.tsx
import React, { useState, useEffect } from ''react'';
import { supabase } from ''../../lib/supabase'';

const ArticlePage = () => {
  const [lang, setLang] = useState<''es'' | ''qu'' | ''en''>(''es'');
  const [step, setStep] = useState(1);
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    const sync = async () => {
      const { data: res } = await supabase.from(''sys_production'').select(''content'').eq(''issue_code'', ''2026.05.01.001'').single();
      if (res?.content) {
        const raw = res.content;
        setData(typeof raw === ''string'' ? JSON.parse(raw) : raw);
      }
    };
    sync();
    window.scrollTo(0, 0);
  }, [step, lang]);

  if (!data) return <div style={{ backgroundColor: ''black'', minHeight: ''100vh'' }} />;

  const content = data[lang];
  const currentTitle = content[`s${step}`];
  const currentBody = content[`c${step}`];

  const lateralBtn = (dir: ''prev'' | ''next'') => ({
    position: ''fixed'' as const, top: ''50%'', transform: ''translateY(-50%)'',
    background: ''none'', border: ''none'', color: ''#D4AF37'', fontSize: ''4rem'',
    cursor: ''pointer'', padding: ''20px'', opacity: 0.2, transition: ''all 0.3s'',
    [dir === ''prev'' ? ''left'' : ''right'']: ''2vw'', zIndex: 100
  });

  return (
    <div style={{ minHeight: ''100vh'', backgroundColor: ''black'', color: ''white'', padding: ''8vh 5vw'', position: ''relative'', fontFamily: ''system-ui, sans-serif'' }}>
      
      {/* CABECERA - DIMENSION RECUPERADA */}
      <header style={{ textAlign: ''center'', marginBottom: ''10vh'' }}>
        <div style={{ fontSize: ''12px'', letterSpacing: ''1em'', color: ''#D4AF37'', fontWeight: 900, marginBottom: ''15px'' }}>
          {content.title.toUpperCase()}
        </div>
        <div style={{ fontSize: ''3.5rem'', fontWeight: 900, letterSpacing: ''0.3em'', textTransform: ''uppercase'', lineHeight: 1.2 }}>
          {content.subtitle}
        </div>
      </header>

      {/* NAVEGACION IDIOMA */}
      <nav style={{ display: ''flex'', justifyContent: ''center'', gap: ''3rem'', marginBottom: ''12vh'' }}>
        {[''es'', ''qu'', ''en''].map(l => (
          <button key={l} onClick={() => setLang(l as any)} style={{
            background: ''none'', border: ''none'', cursor: ''pointer'',
            color: lang === l ? ''#D4AF37'' : ''rgba(255,255,255,0.2)'',
            fontSize: ''10px'', fontWeight: 900, letterSpacing: ''0.5em'',
            borderBottom: lang === l ? ''2px solid #D4AF37'' : ''2px solid transparent'',
            paddingBottom: ''8px'', transition: ''all 0.3s''
          }}>
            {l === ''es'' ? ''ESPANOL'' : l === ''qu'' ? ''RUNASIMI'' : ''ENGLISH''}
          </button>
        ))}
      </nav>

      {/* BOTONES LATERALES (FIJOS) */}
      {step > 1 && (
        <button onClick={() => setStep(s => s - 1)} style={lateralBtn(''prev'')} onMouseEnter={e => e.currentTarget.style.opacity=''1''} onMouseLeave={e => e.currentTarget.style.opacity=''0.2''}>â€¹</button>
      )}
      {step < 3 && (
        <button onClick={() => setStep(s => s + 1)} style={lateralBtn(''next'')} onMouseEnter={e => e.currentTarget.style.opacity=''1''} onMouseLeave={e => e.currentTarget.style.opacity=''0.2''}>â€º</button>
      )}

      {/* CONTENIDO PRINCIPAL - FLUJO LIBRE */}
      <main style={{ maxWidth: ''1000px'', margin: ''0 auto'', paddingBottom: ''10vh'' }}>
        <div key={`${lang}-${step}`} style={{ animation: ''fadeIn 0.8s ease-out'' }}>
          <h2 style={{ fontSize: ''2.8rem'', fontWeight: 900, marginBottom: ''4rem'', color: ''white'', textTransform: ''uppercase'', lineHeight: 1.2 }}>
            {currentTitle}
          </h2>
          
          <div style={{ borderLeft: ''4px solid #D4AF37'', paddingLeft: ''4rem'', marginBottom: ''5rem'' }}>
            <p style={{ fontSize: ''1.8rem'', lineHeight: 1.8, color: ''#EEE'', fontWeight: 300, whiteSpace: ''pre-line'', margin: 0 }}>
              {currentBody}
            </p>
          </div>

          {/* MANTRA VINCULANTE - INTEGRADO AL FLUJO */}
          <footer style={{ paddingTop: ''4rem'', borderTop: ''1px solid rgba(212,175,55,0.4)'', textAlign: ''center'' }}>
            <p style={{ color: ''#D4AF37'', fontSize: ''1.3rem'', fontWeight: 900, letterSpacing: ''0.2em'', lineHeight: 1.6, margin: ''0 0 2rem 0'', textTransform: ''uppercase'' }}>
              {content.mantra}
            </p>
            <div style={{ fontSize: ''10px'', color: ''rgba(255,255,255,0.2)'', letterSpacing: ''0.6em'' }}>
              PAGINA {step} / 3
            </div>
          </footer>
        </div>
      </main>

      <style>{`
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        body { margin: 0; background: black; overflow-y: auto; }
        * { box-sizing: border-box; }
      `}</style>
    </div>
  );
};

export default ArticlePage;
// FILE: 20260502001.tsx
import { useState } from ''react'';

interface LangContent { ES: string; QU: string; EN: string; }
interface Section { id: string; title: LangContent; content: LangContent; }

export default function Article_05_02() {
  const [activeLang, setLang] = useState<keyof LangContent>(''ES'');
  const issueCode = ''2026.05.02.001'';

  const sections: Section[] = [
    {
      id: "01",
      title: { ES: "1. El Virus del Abandono", QU: "1. Saqerpayaypa unquynin", EN: "1. The Virus of Abandonment" },
      content: { ES: "Contenido...", QU: "Qillqasqa...", EN: "Content..." }
    }
  ];

  return (
    <div style={{ backgroundColor: ''#050505'', color: ''#fff'', minHeight: ''100vh'', padding: ''40px'' }}>
      <header style={{ textAlign: ''center'' }}>
        <h1 style={{ fontSize: ''60px'', fontWeight: ''900'' }}>{issueCode}</h1>
        <div style={{ display: ''flex'', justifyContent: ''center'', gap: ''20px'', marginTop: ''20px'' }}>
          {([''ES'', ''QU'', ''EN''] as const).map(l => (
            <button key={l} onClick={() => setLang(l)} style={{ color: activeLang === l ? ''#D4AF37'' : ''#555'', background: ''none'', border: ''none'', cursor: ''pointer'' }}>{l}</button>
          ))}
        </div>
      </header>
      <main style={{ maxWidth: ''800px'', margin: ''60px auto'' }}>
        <h2 style={{ fontSize: ''24px'' }}>{sections[0].title[activeLang]}</h2>
        <p style={{ fontSize: ''20px'', color: ''#ccc'', marginTop: ''20px'' }}>{sections[0].content[activeLang]}</p>
      </main>
    </div>
  );
}
// FILE: index.tsx
import React, { useState, useEffect } from ''react'';
import { Link } from ''react-router-dom'';
import { supabase } from ''../../lib/supabase'';

const ArticlesIndex = () => {
  const [articles, setArticles] = useState<any[]>([]);

  useEffect(() => {
    const fetchArticles = async () => {
      const { data } = await supabase.from(''sys_production'').select(''*'');
      if (data) setArticles(data);
    };
    fetchArticles();
  }, []);

  return (
    <div className="min-h-screen bg-black text-white p-20 font-sans">
      <h1 className="text-[#D4AF37] text-xs font-black tracking-[1em] mb-16">INDICE DE PRODUCCION</h1>
      <div className="flex flex-col gap-8">
        {articles.map((art: any) => (
          <Link key={art.id} to={`/articles/${art.issue_code?.replace(/\./g, '''')}`} className="no-underline group">
            <div className="text-white text-3xl font-black group-hover:text-[#D4AF37] transition-all uppercase">
              {art.title}
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
};

export default ArticlesIndex;
// FILE: tailwind.config.js
// tailwind.config.js
module.exports = {
    theme: {
        extend: {
            colors: {
                v51: {
                    black: ''#050505'', // Bunker Black
                    gold: ''#D4AF37'',  // Astral Gold
                    copper: ''#B87333'', // Andean Copper
                    void: ''#0A0A0C'',
                    glow: ''rgba(212, 175, 55, 0.15)''
                }
            },
            backgroundImage: {
                ''fractal-gradient'': "radial-gradient(circle at center, #1a1a1a 0%, #050505 100%)",
                ''khipu-pattern'': "url(''/assets/vectors/khipu-grid.svg'')"
            },
            fontFamily: {
                ''antigravity'': [''Inter'', ''Syncopate'', ''sans-serif''],
            }
        }
    }
}
// FILE: next.config.js
/** @type {import(''next'').NextConfig} */
const nextConfig = {
  async headers() {
    return [
      {
        source: ''/(.*)'',
        headers: [
          {
            key: ''Content-Security-Policy'',
            value: "frame-ancestors ''self'' http://localhost:3001 https://hub.via51.org http://localhost:3000",
          },
          {
            key: ''X-Frame-Options'',
            value: ''ALLOW-FROM http://localhost:3001'',
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
// FILE: postcss.config.js
export default {
    plugins: {
        tailwindcss: {},
        autoprefixer: {},
    },
}
// FILE: tailwind.config.js
/** @type {import(''tailwindcss'').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        v51: {
          gold: ''#D4AF37'',
          copper: ''#B87333'',
        }
      }
    },
  },
  plugins: [],
}
// FILE: postcss.config.js
export default {
    plugins: {
        tailwindcss: {},
        autoprefixer: {},
    },
}
// FILE: tailwind.config.js
/** @type {import(''tailwindcss'').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        ''v51-gold'': ''#D4AF37'',
        ''v51-black'': ''#050505''
      }
    },
  },
  plugins: [],
}
// FILE: context.json
{
    "name": "via51-ecosistema",
    "private": true,
    "workspaces": [
        "via51-root",
        "via51-hub",
        "via51-gamma"
    ],
    "scripts": {
        "build": "npm run alfa:build",
        "alfa:build": "npm run build -w via51-root",
        "beta:build": "npm run build -w via51-hub",
        "gamma:build": "npm run build -w via51-gamma"
    }
}
// FILE: data_raw_morados.json
""
// FILE: package-lock.json
{
    "name": "via51-fractal",
    "version": "1.0.0",
    "lockfileVersion": 3,
    "requires": true,
    "packages": {
        "": {
            "name": "via51-fractal",
            "version": "1.0.0",
            "dependencies": {
                "@react-three/drei": "^10.7.7",
                "@react-three/fiber": "^9.6.0",
                "@types/three": "^0.184.0",
                "three": "^0.184.0"
            },
            "devDependencies": {
                "@types/node": "^25.6.0",
                "concurrently": "^8.2.0",
                "ts-node-dev": "^2.0.0",
                "typescript": "^5.0.0",
                "vite": "^8.0.10"
            }
        },
        "node_modules/@babel/runtime": {
            "version": "7.29.2",
            "resolved": "https://registry.npmjs.org/@babel/runtime/-/runtime-7.29.2.tgz",
            "integrity": "sha512-JiDShH45zKHWyGe4ZNVRrCjBz8Nh9TMmZG1kh4QTK8hCBTWBi8Da+i7s1fJw7/lYpM4ccepSNfqzZ/QvABBi5g==",
            "license": "MIT",
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@cspotcode/source-map-support": {
            "version": "0.8.1",
            "resolved": "https://registry.npmjs.org/@cspotcode/source-map-support/-/source-map-support-0.8.1.tgz",
            "integrity": "sha512-IchNf6dN4tHoMFIn/7OE8LWZ19Y6q/67Bmf6vnGREv8RSbBVb9LPJxEcnwrcwX6ixSvaiGoomAUvu4YSxXrVgw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@jridgewell/trace-mapping": "0.3.9"
            },
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@dimforge/rapier3d-compat": {
            "version": "0.12.0",
            "resolved": "https://registry.npmjs.org/@dimforge/rapier3d-compat/-/rapier3d-compat-0.12.0.tgz",
            "integrity": "sha512-uekIGetywIgopfD97oDL5PfeezkFpNhwlzlaEYNOA0N6ghdsOvh/HYjSMek5Q2O1PYvRSDFcqFVJl4r4ZBwOow==",
            "license": "Apache-2.0"
        },
        "node_modules/@emnapi/core": {
            "version": "1.10.0",
            "resolved": "https://registry.npmjs.org/@emnapi/core/-/core-1.10.0.tgz",
            "integrity": "sha512-yq6OkJ4p82CAfPl0u9mQebQHKPJkY7WrIuk205cTYnYe+k2Z8YBh11FrbRG/H6ihirqcacOgl2BIO8oyMQLeXw==",
            "dev": true,
            "license": "MIT",
            "optional": true,
            "dependencies": {
                "@emnapi/wasi-threads": "1.2.1",
                "tslib": "^2.4.0"
            }
        },
        "node_modules/@emnapi/runtime": {
            "version": "1.10.0",
            "resolved": "https://registry.npmjs.org/@emnapi/runtime/-/runtime-1.10.0.tgz",
            "integrity": "sha512-ewvYlk86xUoGI0zQRNq/mC+16R1QeDlKQy21Ki3oSYXNgLb45GV1P6A0M+/s6nyCuNDqe5VpaY84BzXGwVbwFA==",
            "dev": true,
            "license": "MIT",
            "optional": true,
            "dependencies": {
                "tslib": "^2.4.0"
            }
        },
        "node_modules/@emnapi/wasi-threads": {
            "version": "1.2.1",
            "resolved": "https://registry.npmjs.org/@emnapi/wasi-threads/-/wasi-threads-1.2.1.tgz",
            "integrity": "sha512-uTII7OYF+/Mes/MrcIOYp5yOtSMLBWSIoLPpcgwipoiKbli6k322tcoFsxoIIxPDqW01SQGAgko4EzZi2BNv2w==",
            "dev": true,
            "license": "MIT",
            "optional": true,
            "dependencies": {
                "tslib": "^2.4.0"
            }
        },
        "node_modules/@jridgewell/resolve-uri": {
            "version": "3.1.2",
            "resolved": "https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz",
            "integrity": "sha512-bRISgCIjP20/tbWSPWMEi54QVPRZExkuD9lJL+UIxUKtwVJA8wW1Trb1jMs1RFXo1CBTNZ/5hpC9QvmKWdopKw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.0.0"
            }
        },
        "node_modules/@jridgewell/sourcemap-codec": {
            "version": "1.5.5",
            "resolved": "https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.5.tgz",
            "integrity": "sha512-cYQ9310grqxueWbl+WuIUIaiUaDcj7WOq5fVhEljNVgRfOUhY9fy2zTvfoqWsnebh8Sl70VScFbICvJnLKB0Og==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@jridgewell/trace-mapping": {
            "version": "0.3.9",
            "resolved": "https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.9.tgz",
            "integrity": "sha512-3Belt6tdc8bPgAtbcmdtNJlirVoTmEb5e2gC94PnkwEW9jI6CAHUeoG85tjWP5WquqfavoMtMwiG4P926ZKKuQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@jridgewell/resolve-uri": "^3.0.3",
                "@jridgewell/sourcemap-codec": "^1.4.10"
            }
        },
        "node_modules/@mediapipe/tasks-vision": {
            "version": "0.10.17",
            "resolved": "https://registry.npmjs.org/@mediapipe/tasks-vision/-/tasks-vision-0.10.17.tgz",
            "integrity": "sha512-CZWV/q6TTe8ta61cZXjfnnHsfWIdFhms03M9T7Cnd5y2mdpylJM0rF1qRq+wsQVRMLz1OYPVEBU9ph2Bx8cxrg==",
            "license": "Apache-2.0"
        },
        "node_modules/@monogrid/gainmap-js": {
            "version": "3.4.0",
            "resolved": "https://registry.npmjs.org/@monogrid/gainmap-js/-/gainmap-js-3.4.0.tgz",
            "integrity": "sha512-2Z0FATFHaoYJ8b+Y4y4Hgfn3FRFwuU5zRrk+9dFWp4uGAdHGqVEdP7HP+gLA3X469KXHmfupJaUbKo1b/aDKIg==",
            "license": "MIT",
            "dependencies": {
                "promise-worker-transferable": "^1.0.4"
            },
            "peerDependencies": {
                "three": ">= 0.159.0"
            }
        },
        "node_modules/@napi-rs/wasm-runtime": {
            "version": "1.1.4",
            "resolved": "https://registry.npmjs.org/@napi-rs/wasm-runtime/-/wasm-runtime-1.1.4.tgz",
            "integrity": "sha512-3NQNNgA1YSlJb/kMH1ildASP9HW7/7kYnRI2szWJaofaS1hWmbGI4H+d3+22aGzXXN9IJ+n+GiFVcGipJP18ow==",
            "dev": true,
            "license": "MIT",
            "optional": true,
            "dependencies": {
                "@tybys/wasm-util": "^0.10.1"
            },
            "funding": {
                "type": "github",
                "url": "https://github.com/sponsors/Brooooooklyn"
            },
            "peerDependencies": {
                "@emnapi/core": "^1.7.1",
                "@emnapi/runtime": "^1.7.1"
            }
        },
        "node_modules/@oxc-project/types": {
            "version": "0.127.0",
            "resolved": "https://registry.npmjs.org/@oxc-project/types/-/types-0.127.0.tgz",
            "integrity": "sha512-aIYXQBo4lCbO4z0R3FHeucQHpF46l2LbMdxRvqvuRuW2OxdnSkcng5B8+K12spgLDj93rtN3+J2Vac/TIO+ciQ==",
            "dev": true,
            "license": "MIT",
            "funding": {
                "url": "https://github.com/sponsors/Boshen"
            }
        },
        "node_modules/@react-three/drei": {
            "version": "10.7.7",
            "resolved": "https://registry.npmjs.org/@react-three/drei/-/drei-10.7.7.tgz",
            "integrity": "sha512-ff+J5iloR0k4tC++QtD/j9u3w5fzfgFAWDtAGQah9pF2B1YgOq/5JxqY0/aVoQG5r3xSZz0cv5tk2YuBob4xEQ==",
            "license": "MIT",
            "dependencies": {
                "@babel/runtime": "^7.26.0",
                "@mediapipe/tasks-vision": "0.10.17",
                "@monogrid/gainmap-js": "^3.0.6",
                "@use-gesture/react": "^10.3.1",
                "camera-controls": "^3.1.0",
                "cross-env": "^7.0.3",
                "detect-gpu": "^5.0.56",
                "glsl-noise": "^0.0.0",
                "hls.js": "^1.5.17",
                "maath": "^0.10.8",
                "meshline": "^3.3.1",
                "stats-gl": "^2.2.8",
                "stats.js": "^0.17.0",
                "suspend-react": "^0.1.3",
                "three-mesh-bvh": "^0.8.3",
                "three-stdlib": "^2.35.6",
                "troika-three-text": "^0.52.4",
                "tunnel-rat": "^0.1.2",
                "use-sync-external-store": "^1.4.0",
                "utility-types": "^3.11.0",
                "zustand": "^5.0.1"
            },
            "peerDependencies": {
                "@react-three/fiber": "^9.0.0",
                "react": "^19",
                "react-dom": "^19",
                "three": ">=0.159"
            },
            "peerDependenciesMeta": {
                "react-dom": {
                    "optional": true
                }
            }
        },
        "node_modules/@react-three/fiber": {
            "version": "9.6.0",
            "resolved": "https://registry.npmjs.org/@react-three/fiber/-/fiber-9.6.0.tgz",
            "integrity": "sha512-90abYK2q5/qDM+GACs9zRvc5KhEEpEWqWlHSd64zTPNxg+9wCJvTfyD9x2so7hlQhjRYO1Fa6flR3BC/kpTFkA==",
            "license": "MIT",
            "dependencies": {
                "@babel/runtime": "^7.17.8",
                "@types/webxr": "*",
                "base64-js": "^1.5.1",
                "buffer": "^6.0.3",
                "its-fine": "^2.0.0",
                "react-use-measure": "^2.1.7",
                "scheduler": "^0.27.0",
                "suspend-react": "^0.1.3",
                "use-sync-external-store": "^1.4.0",
                "zustand": "^5.0.3"
            },
            "peerDependencies": {
                "expo": ">=43.0",
                "expo-asset": ">=8.4",
                "expo-file-system": ">=11.0",
                "expo-gl": ">=11.0",
                "react": ">=19 <19.3",
                "react-dom": ">=19 <19.3",
                "react-native": ">=0.78",
                "three": ">=0.156"
            },
            "peerDependenciesMeta": {
                "expo": {
                    "optional": true
                },
                "expo-asset": {
                    "optional": true
                },
                "expo-file-system": {
                    "optional": true
                },
                "expo-gl": {
                    "optional": true
                },
                "react-dom": {
                    "optional": true
                },
                "react-native": {
                    "optional": true
                }
            }
        },
        "node_modules/@rolldown/binding-android-arm64": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-android-arm64/-/binding-android-arm64-1.0.0-rc.17.tgz",
            "integrity": "sha512-s70pVGhw4zqGeFnXWvAzJDlvxhlRollagdCCKRgOsgUOH3N1l0LIxf83AtGzmb5SiVM4Hjl5HyarMRfdfj3DaQ==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "android"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-darwin-arm64": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-darwin-arm64/-/binding-darwin-arm64-1.0.0-rc.17.tgz",
            "integrity": "sha512-4ksWc9n0mhlZpZ9PMZgTGjeOPRu8MB1Z3Tz0Mo02eWfWCHMW1zN82Qz/pL/rC+yQa+8ZnutMF0JjJe7PjwasYw==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "darwin"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-darwin-x64": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-darwin-x64/-/binding-darwin-x64-1.0.0-rc.17.tgz",
            "integrity": "sha512-SUSDOI6WwUVNcWxd02QEBjLdY1VPHvlEkw6T/8nYG322iYWCTxRb1vzk4E+mWWYehTp7ERibq54LSJGjmouOsw==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "darwin"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-freebsd-x64": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-freebsd-x64/-/binding-freebsd-x64-1.0.0-rc.17.tgz",
            "integrity": "sha512-hwnz3nw9dbJ05EDO/PvcjaaewqqDy7Y1rn1UO81l8iIK1GjenME75dl16ajbvSSMfv66WXSRCYKIqfgq2KCfxw==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "freebsd"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-linux-arm-gnueabihf": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-arm-gnueabihf/-/binding-linux-arm-gnueabihf-1.0.0-rc.17.tgz",
            "integrity": "sha512-IS+W7epTcwANmFSQFrS1SivEXHtl1JtuQA9wlxrZTcNi6mx+FDOYrakGevvvTwgj2JvWiK8B29/qD9BELZPyXQ==",
            "cpu": [
                "arm"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-linux-arm64-gnu": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-arm64-gnu/-/binding-linux-arm64-gnu-1.0.0-rc.17.tgz",
            "integrity": "sha512-e6usGaHKW5BMNZOymS1UcEYGowQMWcgZ71Z17Sl/h2+ZziNJ1a9n3Zvcz6LdRyIW5572wBCTH/Z+bKuZouGk9Q==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-linux-arm64-musl": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-arm64-musl/-/binding-linux-arm64-musl-1.0.0-rc.17.tgz",
            "integrity": "sha512-b/CgbwAJpmrRLp02RPfhbudf5tZnN9nsPWK82znefso832etkem8H7FSZwxrOI9djcdTP7U6YfNhbRnh7djErg==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-linux-ppc64-gnu": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-ppc64-gnu/-/binding-linux-ppc64-gnu-1.0.0-rc.17.tgz",
            "integrity": "sha512-4EII1iNGRUN5WwGbF/kOh/EIkoDN9HsupgLQoXfY+D1oyJm7/F4t5PYU5n8SWZgG0FEwakyM8pGgwcBYruGTlA==",
            "cpu": [
                "ppc64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-linux-s390x-gnu": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-s390x-gnu/-/binding-linux-s390x-gnu-1.0.0-rc.17.tgz",
            "integrity": "sha512-AH8oq3XqQo4IibpVXvPeLDI5pzkpYn0WiZAfT05kFzoJ6tQNzwRdDYQ45M8I/gslbodRZwW8uxLhbSBbkv96rA==",
            "cpu": [
                "s390x"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-linux-x64-gnu": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-x64-gnu/-/binding-linux-x64-gnu-1.0.0-rc.17.tgz",
            "integrity": "sha512-cLnjV3xfo7KslbU41Z7z8BH/E1y5mzUYzAqih1d1MDaIGZRCMqTijqLv76/P7fyHuvUcfGsIpqCdddbxLLK9rA==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-linux-x64-musl": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-linux-x64-musl/-/binding-linux-x64-musl-1.0.0-rc.17.tgz",
            "integrity": "sha512-0phclDw1spsL7dUB37sIARuis2tAgomCJXAHZlpt8PXZ4Ba0dRP1e+66lsRqrfhISeN9bEGNjQs+T/Fbd7oYGw==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-openharmony-arm64": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-openharmony-arm64/-/binding-openharmony-arm64-1.0.0-rc.17.tgz",
            "integrity": "sha512-0ag/hEgXOwgw4t8QyQvUCxvEg+V0KBcA6YuOx9g0r02MprutRF5dyljgm3EmR02O292UX7UeS6HzWHAl6KgyhA==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "openharmony"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-wasm32-wasi": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-wasm32-wasi/-/binding-wasm32-wasi-1.0.0-rc.17.tgz",
            "integrity": "sha512-LEXei6vo0E5wTGwpkJ4KoT3OZJRnglwldt5ziLzOlc6qqb55z4tWNq2A+PFqCJuvWWdP53CVhG1Z9NtToDPJrA==",
            "cpu": [
                "wasm32"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "dependencies": {
                "@emnapi/core": "1.10.0",
                "@emnapi/runtime": "1.10.0",
                "@napi-rs/wasm-runtime": "^1.1.4"
            },
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-win32-arm64-msvc": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-win32-arm64-msvc/-/binding-win32-arm64-msvc-1.0.0-rc.17.tgz",
            "integrity": "sha512-gUmyzBl3SPMa6hrqFUth9sVfcLBlYsbMzBx5PlexMroZStgzGqlZ26pYG89rBb45Mnia+oil6YAIFeEWGWhoZA==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/binding-win32-x64-msvc": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/binding-win32-x64-msvc/-/binding-win32-x64-msvc-1.0.0-rc.17.tgz",
            "integrity": "sha512-3hkiolcUAvPB9FLb3UZdfjVVNWherN1f/skkGWJP/fgSQhYUZpSIRr0/I8ZK9TkF3F7kxvJAk0+IcKvPHk9qQg==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ],
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            }
        },
        "node_modules/@rolldown/pluginutils": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/@rolldown/pluginutils/-/pluginutils-1.0.0-rc.17.tgz",
            "integrity": "sha512-n8iosDOt6Ig1UhJ2AYqoIhHWh/isz0xpicHTzpKBeotdVsTEcxsSA/i3EVM7gQAj0rU27OLAxCjzlj15IWY7bg==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@tsconfig/node10": {
            "version": "1.0.12",
            "resolved": "https://registry.npmjs.org/@tsconfig/node10/-/node10-1.0.12.tgz",
            "integrity": "sha512-UCYBaeFvM11aU2y3YPZ//O5Rhj+xKyzy7mvcIoAjASbigy8mHMryP5cK7dgjlz2hWxh1g5pLw084E0a/wlUSFQ==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@tsconfig/node12": {
            "version": "1.0.11",
            "resolved": "https://registry.npmjs.org/@tsconfig/node12/-/node12-1.0.11.tgz",
            "integrity": "sha512-cqefuRsh12pWyGsIoBKJA9luFu3mRxCA+ORZvA4ktLSzIuCUtWVxGIuXigEwO5/ywWFMZ2QEGKWvkZG1zDMTag==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@tsconfig/node14": {
            "version": "1.0.3",
            "resolved": "https://registry.npmjs.org/@tsconfig/node14/-/node14-1.0.3.tgz",
            "integrity": "sha512-ysT8mhdixWK6Hw3i1V2AeRqZ5WfXg1G43mqoYlM2nc6388Fq5jcXyr5mRsqViLx/GJYdoL0bfXD8nmF+Zn/Iow==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@tsconfig/node16": {
            "version": "1.0.4",
            "resolved": "https://registry.npmjs.org/@tsconfig/node16/-/node16-1.0.4.tgz",
            "integrity": "sha512-vxhUy4J8lyeyinH7Azl1pdd43GJhZH/tP2weN8TntQblOY+A0XbT8DJk1/oCPuOOyg/Ja757rG0CgHcWC8OfMA==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@tweenjs/tween.js": {
            "version": "23.1.3",
            "resolved": "https://registry.npmjs.org/@tweenjs/tween.js/-/tween.js-23.1.3.tgz",
            "integrity": "sha512-vJmvvwFxYuGnF2axRtPYocag6Clbb5YS7kLL+SO/TeVFzHqDIWrNKYtcsPMibjDx9O+bu+psAy9NKfWklassUA==",
            "license": "MIT"
        },
        "node_modules/@tybys/wasm-util": {
            "version": "0.10.1",
            "resolved": "https://registry.npmjs.org/@tybys/wasm-util/-/wasm-util-0.10.1.tgz",
            "integrity": "sha512-9tTaPJLSiejZKx+Bmog4uSubteqTvFrVrURwkmHixBo0G4seD0zUxp98E1DzUBJxLQ3NPwXrGKDiVjwx/DpPsg==",
            "dev": true,
            "license": "MIT",
            "optional": true,
            "dependencies": {
                "tslib": "^2.4.0"
            }
        },
        "node_modules/@types/draco3d": {
            "version": "1.4.10",
            "resolved": "https://registry.npmjs.org/@types/draco3d/-/draco3d-1.4.10.tgz",
            "integrity": "sha512-AX22jp8Y7wwaBgAixaSvkoG4M/+PlAcm3Qs4OW8yT9DM4xUpWKeFhLueTAyZF39pviAdcDdeJoACapiAceqNcw==",
            "license": "MIT"
        },
        "node_modules/@types/node": {
            "version": "25.6.0",
            "resolved": "https://registry.npmjs.org/@types/node/-/node-25.6.0.tgz",
            "integrity": "sha512-+qIYRKdNYJwY3vRCZMdJbPLJAtGjQBudzZzdzwQYkEPQd+PJGixUL5QfvCLDaULoLv+RhT3LDkwEfKaAkgSmNQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "undici-types": "~7.19.0"
            }
        },
        "node_modules/@types/offscreencanvas": {
            "version": "2019.7.3",
            "resolved": "https://registry.npmjs.org/@types/offscreencanvas/-/offscreencanvas-2019.7.3.tgz",
            "integrity": "sha512-ieXiYmgSRXUDeOntE1InxjWyvEelZGP63M+cGuquuRLuIKKT1osnkXjxev9B7d1nXSug5vpunx+gNlbVxMlC9A==",
            "license": "MIT"
        },
        "node_modules/@types/react": {
            "version": "19.2.14",
            "resolved": "https://registry.npmjs.org/@types/react/-/react-19.2.14.tgz",
            "integrity": "sha512-ilcTH/UniCkMdtexkoCN0bI7pMcJDvmQFPvuPvmEaYA/NSfFTAgdUSLAoVjaRJm7+6PvcM+q1zYOwS4wTYMF9w==",
            "license": "MIT",
            "peer": true,
            "dependencies": {
                "csstype": "^3.2.2"
            }
        },
        "node_modules/@types/react-reconciler": {
            "version": "0.28.9",
            "resolved": "https://registry.npmjs.org/@types/react-reconciler/-/react-reconciler-0.28.9.tgz",
            "integrity": "sha512-HHM3nxyUZ3zAylX8ZEyrDNd2XZOnQ0D5XfunJF5FLQnZbHHYq4UWvW1QfelQNXv1ICNkwYhfxjwfnqivYB6bFg==",
            "license": "MIT",
            "peerDependencies": {
                "@types/react": "*"
            }
        },
        "node_modules/@types/stats.js": {
            "version": "0.17.4",
            "resolved": "https://registry.npmjs.org/@types/stats.js/-/stats.js-0.17.4.tgz",
            "integrity": "sha512-jIBvWWShCvlBqBNIZt0KAshWpvSjhkwkEu4ZUcASoAvhmrgAUI2t1dXrjSL4xXVLB4FznPrIsX3nKXFl/Dt4vA==",
            "license": "MIT"
        },
        "node_modules/@types/strip-bom": {
            "version": "3.0.0",
            "resolved": "https://registry.npmjs.org/@types/strip-bom/-/strip-bom-3.0.0.tgz",
            "integrity": "sha512-xevGOReSYGM7g/kUBZzPqCrR/KYAo+F0yiPc85WFTJa0MSLtyFTVTU6cJu/aV4mid7IffDIWqo69THF2o4JiEQ==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@types/strip-json-comments": {
            "version": "0.0.30",
            "resolved": "https://registry.npmjs.org/@types/strip-json-comments/-/strip-json-comments-0.0.30.tgz",
            "integrity": "sha512-7NQmHra/JILCd1QqpSzl8+mJRc8ZHz3uDm8YV1Ks9IhK0epEiTw8aIErbvH9PI+6XbqhyIQy3462nEsn7UVzjQ==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@types/three": {
            "version": "0.184.0",
            "resolved": "https://registry.npmjs.org/@types/three/-/three-0.184.0.tgz",
            "integrity": "sha512-4mY2tZAu0y0B0567w7013BBXSpsP0+Z48NJvmNo4Y/Pf76yCyz6Jw4P3tUVs10WuYNXXZ+wmHyGWpCek3amJxA==",
            "license": "MIT",
            "dependencies": {
                "@dimforge/rapier3d-compat": "~0.12.0",
                "@tweenjs/tween.js": "~23.1.3",
                "@types/stats.js": "*",
                "@types/webxr": ">=0.5.17",
                "fflate": "~0.8.2",
                "meshoptimizer": "~1.1.1"
            }
        },
        "node_modules/@types/webxr": {
            "version": "0.5.24",
            "resolved": "https://registry.npmjs.org/@types/webxr/-/webxr-0.5.24.tgz",
            "integrity": "sha512-h8fgEd/DpoS9CBrjEQXR+dIDraopAEfu4wYVNY2tEPwk60stPWhvZMf4Foo5FakuQ7HFZoa8WceaWFervK2Ovg==",
            "license": "MIT"
        },
        "node_modules/@use-gesture/core": {
            "version": "10.3.1",
            "resolved": "https://registry.npmjs.org/@use-gesture/core/-/core-10.3.1.tgz",
            "integrity": "sha512-WcINiDt8WjqBdUXye25anHiNxPc0VOrlT8F6LLkU6cycrOGUDyY/yyFmsg3k8i5OLvv25llc0QC45GhR/C8llw==",
            "license": "MIT"
        },
        "node_modules/@use-gesture/react": {
            "version": "10.3.1",
            "resolved": "https://registry.npmjs.org/@use-gesture/react/-/react-10.3.1.tgz",
            "integrity": "sha512-Yy19y6O2GJq8f7CHf7L0nxL8bf4PZCPaVOCgJrusOeFHY1LvHgYXnmnXg6N5iwAnbgbZCDjo60SiM6IPJi9C5g==",
            "license": "MIT",
            "dependencies": {
                "@use-gesture/core": "10.3.1"
            },
            "peerDependencies": {
                "react": ">= 16.8.0"
            }
        },
        "node_modules/acorn": {
            "version": "8.16.0",
            "resolved": "https://registry.npmjs.org/acorn/-/acorn-8.16.0.tgz",
            "integrity": "sha512-UVJyE9MttOsBQIDKw1skb9nAwQuR5wuGD3+82K6JgJlm/Y+KI92oNsMNGZCYdDsVtRHSak0pcV5Dno5+4jh9sw==",
            "dev": true,
            "license": "MIT",
            "bin": {
                "acorn": "bin/acorn"
            },
            "engines": {
                "node": ">=0.4.0"
            }
        },
        "node_modules/acorn-walk": {
            "version": "8.3.5",
            "resolved": "https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.5.tgz",
            "integrity": "sha512-HEHNfbars9v4pgpW6SO1KSPkfoS0xVOM/9UzkJltjlsHZmJasxg8aXkuZa7SMf8vKGIBhpUsPluQSqhJFCqebw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "acorn": "^8.11.0"
            },
            "engines": {
                "node": ">=0.4.0"
            }
        },
        "node_modules/ansi-regex": {
            "version": "5.0.1",
            "resolved": "https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz",
            "integrity": "sha512-quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/ansi-styles": {
            "version": "4.3.0",
            "resolved": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz",
            "integrity": "sha512-zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "color-convert": "^2.0.1"
            },
            "engines": {
                "node": ">=8"
            },
            "funding": {
                "url": "https://github.com/chalk/ansi-styles?sponsor=1"
            }
        },
        "node_modules/anymatch": {
            "version": "3.1.3",
            "resolved": "https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz",
            "integrity": "sha512-KMReFUr0B4t+D+OBkjR3KYqvocp2XaSzO55UcB6mgQMd3KbcE+mWTyvVV7D/zsdEbNnV6acZUutkiHQXvTr1Rw==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "normalize-path": "^3.0.0",
                "picomatch": "^2.0.4"
            },
            "engines": {
                "node": ">= 8"
            }
        },
        "node_modules/arg": {
            "version": "4.1.3",
            "resolved": "https://registry.npmjs.org/arg/-/arg-4.1.3.tgz",
            "integrity": "sha512-58S9QDqG0Xx27YwPSt9fJxivjYl432YCwfDMfZ+71RAqUrZef7LrKQZ3LHLOwCS4FLNBplP533Zx895SeOCHvA==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/balanced-match": {
            "version": "1.0.2",
            "resolved": "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz",
            "integrity": "sha512-3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/base64-js": {
            "version": "1.5.1",
            "resolved": "https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz",
            "integrity": "sha512-AKpaYlHn8t4SVbOHCy+b5+KKgvR4vrsD8vbvrbiQJps7fKDTkjkDry6ji0rUJjC0kzbNePLwzxq8iypo41qeWA==",
            "funding": [
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/feross"
                },
                {
                    "type": "patreon",
                    "url": "https://www.patreon.com/feross"
                },
                {
                    "type": "consulting",
                    "url": "https://feross.org/support"
                }
            ],
            "license": "MIT"
        },
        "node_modules/bidi-js": {
            "version": "1.0.3",
            "resolved": "https://registry.npmjs.org/bidi-js/-/bidi-js-1.0.3.tgz",
            "integrity": "sha512-RKshQI1R3YQ+n9YJz2QQ147P66ELpa1FQEg20Dk8oW9t2KgLbpDLLp9aGZ7y8WHSshDknG0bknqGw5/tyCs5tw==",
            "license": "MIT",
            "dependencies": {
                "require-from-string": "^2.0.2"
            }
        },
        "node_modules/binary-extensions": {
            "version": "2.3.0",
            "resolved": "https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz",
            "integrity": "sha512-Ceh+7ox5qe7LJuLHoY0feh3pHuUDHAcRUeyL2VYghZwfpkNIy/+8Ocg0a3UuSoYzavmylwuLWQOf3hl0jjMMIw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=8"
            },
            "funding": {
                "url": "https://github.com/sponsors/sindresorhus"
            }
        },
        "node_modules/brace-expansion": {
            "version": "1.1.14",
            "resolved": "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.14.tgz",
            "integrity": "sha512-MWPGfDxnyzKU7rNOW9SP/c50vi3xrmrua/+6hfPbCS2ABNWfx24vPidzvC7krjU/RTo235sV776ymlsMtGKj8g==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "balanced-match": "^1.0.0",
                "concat-map": "0.0.1"
            }
        },
        "node_modules/braces": {
            "version": "3.0.3",
            "resolved": "https://registry.npmjs.org/braces/-/braces-3.0.3.tgz",
            "integrity": "sha512-yQbXgO/OSZVD2IsiLlro+7Hf6Q18EJrKSEsdoMzKePKXct3gvD8oLcOQdIzGupr5Fj+EDe8gO/lxc1BzfMpxvA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "fill-range": "^7.1.1"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/buffer": {
            "version": "6.0.3",
            "resolved": "https://registry.npmjs.org/buffer/-/buffer-6.0.3.tgz",
            "integrity": "sha512-FTiCpNxtwiZZHEZbcbTIcZjERVICn9yq/pDFkTl95/AxzD1naBctN7YO68riM/gLSDY7sdrMby8hofADYuuqOA==",
            "funding": [
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/feross"
                },
                {
                    "type": "patreon",
                    "url": "https://www.patreon.com/feross"
                },
                {
                    "type": "consulting",
                    "url": "https://feross.org/support"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "base64-js": "^1.3.1",
                "ieee754": "^1.2.1"
            }
        },
        "node_modules/buffer-from": {
            "version": "1.1.2",
            "resolved": "https://registry.npmjs.org/buffer-from/-/buffer-from-1.1.2.tgz",
            "integrity": "sha512-E+XQCRwSbaaiChtv6k6Dwgc+bx+Bs6vuKJHHl5kox/BaKbhiXzqQOwK4cO22yElGp2OCmjwVhT3HmxgyPGnJfQ==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/camera-controls": {
            "version": "3.1.2",
            "resolved": "https://registry.npmjs.org/camera-controls/-/camera-controls-3.1.2.tgz",
            "integrity": "sha512-xkxfpG2ECZ6Ww5/9+kf4mfg1VEYAoe9aDSY+IwF0UEs7qEzwy0aVRfs2grImIECs/PoBtWFrh7RXsQkwG922JA==",
            "license": "MIT",
            "engines": {
                "node": ">=22.0.0",
                "npm": ">=10.5.1"
            },
            "peerDependencies": {
                "three": ">=0.126.1"
            }
        },
        "node_modules/chalk": {
            "version": "4.1.2",
            "resolved": "https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz",
            "integrity": "sha512-oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "ansi-styles": "^4.1.0",
                "supports-color": "^7.1.0"
            },
            "engines": {
                "node": ">=10"
            },
            "funding": {
                "url": "https://github.com/chalk/chalk?sponsor=1"
            }
        },
        "node_modules/chalk/node_modules/supports-color": {
            "version": "7.2.0",
            "resolved": "https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz",
            "integrity": "sha512-qpCAvRl9stuOHveKsn7HncJRvv501qIacKzQlO/+Lwxc9+0q2wLyv4Dfvt80/DPn2pqOBsJdDiogXGR9+OvwRw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "has-flag": "^4.0.0"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/chokidar": {
            "version": "3.6.0",
            "resolved": "https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz",
            "integrity": "sha512-7VT13fmjotKpGipCW9JEQAusEPE+Ei8nl6/g4FBAmIm0GOOLMua9NDDo/DWp0ZAxCr3cPq5ZpBqmPAQgDda2Pw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "anymatch": "~3.1.2",
                "braces": "~3.0.2",
                "glob-parent": "~5.1.2",
                "is-binary-path": "~2.1.0",
                "is-glob": "~4.0.1",
                "normalize-path": "~3.0.0",
                "readdirp": "~3.6.0"
            },
            "engines": {
                "node": ">= 8.10.0"
            },
            "funding": {
                "url": "https://paulmillr.com/funding/"
            },
            "optionalDependencies": {
                "fsevents": "~2.3.2"
            }
        },
        "node_modules/cliui": {
            "version": "8.0.1",
            "resolved": "https://registry.npmjs.org/cliui/-/cliui-8.0.1.tgz",
            "integrity": "sha512-BSeNnyus75C4//NQ9gQt1/csTXyo/8Sb+afLAkzAptFuMsod9HFokGNudZpi/oQV73hnVK+sR+5PVRMd+Dr7YQ==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "string-width": "^4.2.0",
                "strip-ansi": "^6.0.1",
                "wrap-ansi": "^7.0.0"
            },
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/color-convert": {
            "version": "2.0.1",
            "resolved": "https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz",
            "integrity": "sha512-RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "color-name": "~1.1.4"
            },
            "engines": {
                "node": ">=7.0.0"
            }
        },
        "node_modules/color-name": {
            "version": "1.1.4",
            "resolved": "https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz",
            "integrity": "sha512-dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/concat-map": {
            "version": "0.0.1",
            "resolved": "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz",
            "integrity": "sha512-/Srv4dswyQNBfohGpz9o6Yb3Gz3SrUDqBH5rTuhGR7ahtlbYKnVxw2bCFMRljaA7EXHaXZ8wsHdodFvbkhKmqg==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/concurrently": {
            "version": "8.2.2",
            "resolved": "https://registry.npmjs.org/concurrently/-/concurrently-8.2.2.tgz",
            "integrity": "sha512-1dP4gpXFhei8IOtlXRE/T/4H88ElHgTiUzh71YUmtjTEHMSRS2Z/fgOxHSxxusGHogsRfxNq1vyAwxSC+EVyDg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "chalk": "^4.1.2",
                "date-fns": "^2.30.0",
                "lodash": "^4.17.21",
                "rxjs": "^7.8.1",
                "shell-quote": "^1.8.1",
                "spawn-command": "0.0.2",
                "supports-color": "^8.1.1",
                "tree-kill": "^1.2.2",
                "yargs": "^17.7.2"
            },
            "bin": {
                "conc": "dist/bin/concurrently.js",
                "concurrently": "dist/bin/concurrently.js"
            },
            "engines": {
                "node": "^14.13.0 || >=16.0.0"
            },
            "funding": {
                "url": "https://github.com/open-cli-tools/concurrently?sponsor=1"
            }
        },
        "node_modules/create-require": {
            "version": "1.1.1",
            "resolved": "https://registry.npmjs.org/create-require/-/create-require-1.1.1.tgz",
            "integrity": "sha512-dcKFX3jn0MpIaXjisoRvexIJVEKzaq7z2rZKxf+MSr9TkdmHmsU4m2lcLojrj/FHl8mk5VxMmYA+ftRkP/3oKQ==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/cross-env": {
            "version": "7.0.3",
            "resolved": "https://registry.npmjs.org/cross-env/-/cross-env-7.0.3.tgz",
            "integrity": "sha512-+/HKd6EgcQCJGh2PSjZuUitQBQynKor4wrFbRg4DtAgS1aWO+gU52xpH7M9ScGgXSYmAVS9bIJ8EzuaGw0oNAw==",
            "license": "MIT",
            "dependencies": {
                "cross-spawn": "^7.0.1"
            },
            "bin": {
                "cross-env": "src/bin/cross-env.js",
                "cross-env-shell": "src/bin/cross-env-shell.js"
            },
            "engines": {
                "node": ">=10.14",
                "npm": ">=6",
                "yarn": ">=1"
            }
        },
        "node_modules/cross-spawn": {
            "version": "7.0.6",
            "resolved": "https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz",
            "integrity": "sha512-uV2QOWP2nWzsy2aMp8aRibhi9dlzF5Hgh5SHaB9OiTGEyDTiJJyx0uy51QXdyWbtAHNua4XJzUKca3OzKUd3vA==",
            "license": "MIT",
            "dependencies": {
                "path-key": "^3.1.0",
                "shebang-command": "^2.0.0",
                "which": "^2.0.1"
            },
            "engines": {
                "node": ">= 8"
            }
        },
        "node_modules/csstype": {
            "version": "3.2.3",
            "resolved": "https://registry.npmjs.org/csstype/-/csstype-3.2.3.tgz",
            "integrity": "sha512-z1HGKcYy2xA8AGQfwrn0PAy+PB7X/GSj3UVJW9qKyn43xWa+gl5nXmU4qqLMRzWVLFC8KusUX8T/0kCiOYpAIQ==",
            "license": "MIT",
            "peer": true
        },
        "node_modules/date-fns": {
            "version": "2.30.0",
            "resolved": "https://registry.npmjs.org/date-fns/-/date-fns-2.30.0.tgz",
            "integrity": "sha512-fnULvOpxnC5/Vg3NCiWelDsLiUc9bRwAPs/+LfTLNvetFCtCTN+yQz15C/fs4AwX1R9K5GLtLfn8QW+dWisaAw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/runtime": "^7.21.0"
            },
            "engines": {
                "node": ">=0.11"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/date-fns"
            }
        },
        "node_modules/detect-gpu": {
            "version": "5.0.70",
            "resolved": "https://registry.npmjs.org/detect-gpu/-/detect-gpu-5.0.70.tgz",
            "integrity": "sha512-bqerEP1Ese6nt3rFkwPnGbsUF9a4q+gMmpTVVOEzoCyeCc+y7/RvJnQZJx1JwhgQI5Ntg0Kgat8Uu7XpBqnz1w==",
            "license": "MIT",
            "dependencies": {
                "webgl-constants": "^1.1.1"
            }
        },
        "node_modules/detect-libc": {
            "version": "2.1.2",
            "resolved": "https://registry.npmjs.org/detect-libc/-/detect-libc-2.1.2.tgz",
            "integrity": "sha512-Btj2BOOO83o3WyH59e8MgXsxEQVcarkUOpEYrubB0urwnN10yQ364rsiByU11nZlqWYZm05i/of7io4mzihBtQ==",
            "dev": true,
            "license": "Apache-2.0",
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/diff": {
            "version": "4.0.4",
            "resolved": "https://registry.npmjs.org/diff/-/diff-4.0.4.tgz",
            "integrity": "sha512-X07nttJQkwkfKfvTPG/KSnE2OMdcUCao6+eXF3wmnIQRn2aPAHH3VxDbDOdegkd6JbPsXqShpvEOHfAT+nCNwQ==",
            "dev": true,
            "license": "BSD-3-Clause",
            "engines": {
                "node": ">=0.3.1"
            }
        },
        "node_modules/draco3d": {
            "version": "1.5.7",
            "resolved": "https://registry.npmjs.org/draco3d/-/draco3d-1.5.7.tgz",
            "integrity": "sha512-m6WCKt/erDXcw+70IJXnG7M3awwQPAsZvJGX5zY7beBqpELw6RDGkYVU0W43AFxye4pDZ5i2Lbyc/NNGqwjUVQ==",
            "license": "Apache-2.0"
        },
        "node_modules/dynamic-dedupe": {
            "version": "0.3.0",
            "resolved": "https://registry.npmjs.org/dynamic-dedupe/-/dynamic-dedupe-0.3.0.tgz",
            "integrity": "sha512-ssuANeD+z97meYOqd50e04Ze5qp4bPqo8cCkI4TRjZkzAUgIDTrXV1R8QCdINpiI+hw14+rYazvTRdQrz0/rFQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "xtend": "^4.0.0"
            }
        },
        "node_modules/emoji-regex": {
            "version": "8.0.0",
            "resolved": "https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz",
            "integrity": "sha512-MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/es-errors": {
            "version": "1.3.0",
            "resolved": "https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz",
            "integrity": "sha512-Zf5H2Kxt2xjTvbJvP2ZWLEICxA6j+hAmMzIlypy4xcBg1vKVnx89Wy0GbS+kf5cwCVFFzdCFh2XSCFNULS6csw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 0.4"
            }
        },
        "node_modules/escalade": {
            "version": "3.2.0",
            "resolved": "https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz",
            "integrity": "sha512-WUj2qlxaQtO4g6Pq5c29GTcWGDyd8itL8zTlipgECz3JesAiiOKotd8JU6otB3PACgG6xkJUyVhboMS+bje/jA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6"
            }
        },
        "node_modules/fflate": {
            "version": "0.8.2",
            "resolved": "https://registry.npmjs.org/fflate/-/fflate-0.8.2.tgz",
            "integrity": "sha512-cPJU47OaAoCbg0pBvzsgpTPhmhqI5eJjh/JIu8tPj5q+T7iLvW/JAYUqmE7KOB4R1ZyEhzBaIQpQpardBF5z8A==",
            "license": "MIT"
        },
        "node_modules/fill-range": {
            "version": "7.1.1",
            "resolved": "https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz",
            "integrity": "sha512-YsGpe3WHLK8ZYi4tWDg2Jy3ebRz2rXowDxnld4bkQB00cc/1Zw9AWnC0i9ztDJitivtQvaI9KaLyKrc+hBW0yg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "to-regex-range": "^5.0.1"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/fs.realpath": {
            "version": "1.0.0",
            "resolved": "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz",
            "integrity": "sha512-OO0pH2lK6a0hZnAdau5ItzHPI6pUlvI7jMVnxUQRtw4owF2wk8lOSabtGDCTP4Ggrg2MbGnWO9X8K1t4+fGMDw==",
            "dev": true,
            "license": "ISC"
        },
        "node_modules/fsevents": {
            "version": "2.3.3",
            "resolved": "https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz",
            "integrity": "sha512-5xoDfX+fL7faATnagmWPpbFtwh/R77WmMMqqHGS65C3vvB0YHrgF+B1YmZ3441tMj5n63k0212XNoJwzlhffQw==",
            "dev": true,
            "hasInstallScript": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "darwin"
            ],
            "engines": {
                "node": "^8.16.0 || ^10.6.0 || >=11.0.0"
            }
        },
        "node_modules/function-bind": {
            "version": "1.1.2",
            "resolved": "https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz",
            "integrity": "sha512-7XHNxH7qX9xG5mIwxkhumTox/MIRNcOgDrxWsMt2pAr23WHp6MrRlN7FBSFpCpr+oVO0F744iUgR82nJMfG2SA==",
            "dev": true,
            "license": "MIT",
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/get-caller-file": {
            "version": "2.0.5",
            "resolved": "https://registry.npmjs.org/get-caller-file/-/get-caller-file-2.0.5.tgz",
            "integrity": "sha512-DyFP3BM/3YHTQOCUL/w0OZHR0lpKeGrxotcHWcqNEdnltqFwXVfhEBQ94eIo34AfQpo0rGki4cyIiftY06h2Fg==",
            "dev": true,
            "license": "ISC",
            "engines": {
                "node": "6.* || 8.* || >= 10.*"
            }
        },
        "node_modules/glob": {
            "version": "7.2.3",
            "resolved": "https://registry.npmjs.org/glob/-/glob-7.2.3.tgz",
            "integrity": "sha512-nFR0zLpU2YCaRxwoCJvL6UvCH2JFyFVIvwTLsIf21AuHlMskA1hhTdk+LlYJtOlYt9v6dvszD2BGRqBL+iQK9Q==",
            "deprecated": "Old versions of glob are not supported, and contain widely publicized security vulnerabilities, which have been fixed in the current version. Please update. Support for old versions may be purchased (at exorbitant rates) by contacting i@izs.me",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "fs.realpath": "^1.0.0",
                "inflight": "^1.0.4",
                "inherits": "2",
                "minimatch": "^3.1.1",
                "once": "^1.3.0",
                "path-is-absolute": "^1.0.0"
            },
            "engines": {
                "node": "*"
            },
            "funding": {
                "url": "https://github.com/sponsors/isaacs"
            }
        },
        "node_modules/glob-parent": {
            "version": "5.1.2",
            "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
            "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "is-glob": "^4.0.1"
            },
            "engines": {
                "node": ">= 6"
            }
        },
        "node_modules/glsl-noise": {
            "version": "0.0.0",
            "resolved": "https://registry.npmjs.org/glsl-noise/-/glsl-noise-0.0.0.tgz",
            "integrity": "sha512-b/ZCF6amfAUb7dJM/MxRs7AetQEahYzJ8PtgfrmEdtw6uyGOr+ZSGtgjFm6mfsBkxJ4d2W7kg+Nlqzqvn3Bc0w==",
            "license": "MIT"
        },
        "node_modules/has-flag": {
            "version": "4.0.0",
            "resolved": "https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz",
            "integrity": "sha512-EykJT/Q1KjTWctppgIAgfSO0tKVuZUjhgMr17kqTumMl6Afv3EISleU7qZUzoXDFTAHTDC4NOoG/ZxU3EvlMPQ==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/hasown": {
            "version": "2.0.3",
            "resolved": "https://registry.npmjs.org/hasown/-/hasown-2.0.3.tgz",
            "integrity": "sha512-ej4AhfhfL2Q2zpMmLo7U1Uv9+PyhIZpgQLGT1F9miIGmiCJIoCgSmczFdrc97mWT4kVY72KA+WnnhJ5pghSvSg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "function-bind": "^1.1.2"
            },
            "engines": {
                "node": ">= 0.4"
            }
        },
        "node_modules/hls.js": {
            "version": "1.6.16",
            "resolved": "https://registry.npmjs.org/hls.js/-/hls.js-1.6.16.tgz",
            "integrity": "sha512-VSIRpLfRwlAAdGL4wiTucx2ScRipo0ed1FBatWkyt832jC4CReKstga6yIhYVwGu9LOBjuX9wzmRMeQdBJtzEA==",
            "license": "Apache-2.0"
        },
        "node_modules/ieee754": {
            "version": "1.2.1",
            "resolved": "https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz",
            "integrity": "sha512-dcyqhDvX1C46lXZcVqCpK+FtMRQVdIMN6/Df5js2zouUsqG7I6sFxitIC+7KYK29KdXOLHdu9zL4sFnoVQnqaA==",
            "funding": [
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/feross"
                },
                {
                    "type": "patreon",
                    "url": "https://www.patreon.com/feross"
                },
                {
                    "type": "consulting",
                    "url": "https://feross.org/support"
                }
            ],
            "license": "BSD-3-Clause"
        },
        "node_modules/immediate": {
            "version": "3.0.6",
            "resolved": "https://registry.npmjs.org/immediate/-/immediate-3.0.6.tgz",
            "integrity": "sha512-XXOFtyqDjNDAQxVfYxuF7g9Il/IbWmmlQg2MYKOH8ExIT1qg6xc4zyS3HaEEATgs1btfzxq15ciUiY7gjSXRGQ==",
            "license": "MIT"
        },
        "node_modules/inflight": {
            "version": "1.0.6",
            "resolved": "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz",
            "integrity": "sha512-k92I/b08q4wvFscXCLvqfsHCrjrF7yiXsQuIVvVE7N82W3+aqpzuUdBbfhWcy/FZR3/4IgflMgKLOsvPDrGCJA==",
            "deprecated": "This module is not supported, and leaks memory. Do not use it. Check out lru-cache if you want a good and tested way to coalesce async requests by a key value, which is much more comprehensive and powerful.",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "once": "^1.3.0",
                "wrappy": "1"
            }
        },
        "node_modules/inherits": {
            "version": "2.0.4",
            "resolved": "https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz",
            "integrity": "sha512-k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==",
            "dev": true,
            "license": "ISC"
        },
        "node_modules/is-binary-path": {
            "version": "2.1.0",
            "resolved": "https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz",
            "integrity": "sha512-ZMERYes6pDydyuGidse7OsHxtbI7WVeUEozgR/g7rd0xUimYNlvZRE/K2MgZTjWy725IfelLeVcEM97mmtRGXw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "binary-extensions": "^2.0.0"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/is-core-module": {
            "version": "2.16.1",
            "resolved": "https://registry.npmjs.org/is-core-module/-/is-core-module-2.16.1.tgz",
            "integrity": "sha512-UfoeMA6fIJ8wTYFEUjelnaGI67v6+N7qXJEvQuIGa99l4xsCruSYOVSQ0uPANn4dAzm8lkYPaKLrrijLq7x23w==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "hasown": "^2.0.2"
            },
            "engines": {
                "node": ">= 0.4"
            },
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/is-extglob": {
            "version": "2.1.1",
            "resolved": "https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz",
            "integrity": "sha512-SbKbANkN603Vi4jEZv49LeVJMn4yGwsbzZworEoyEiutsN3nJYdbO36zfhGJ6QEDpOZIFkDtnq5JRxmvl3jsoQ==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/is-fullwidth-code-point": {
            "version": "3.0.0",
            "resolved": "https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz",
            "integrity": "sha512-zymm5+u+sCsSWyD9qNaejV3DFvhCKclKdizYaJUuHA83RLjb7nSuGnddCHGv0hk+KY7BMAlsWeK4Ueg6EV6XQg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/is-glob": {
            "version": "4.0.3",
            "resolved": "https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz",
            "integrity": "sha512-xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "is-extglob": "^2.1.1"
            },
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/is-number": {
            "version": "7.0.0",
            "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
            "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.12.0"
            }
        },
        "node_modules/is-promise": {
            "version": "2.2.2",
            "resolved": "https://registry.npmjs.org/is-promise/-/is-promise-2.2.2.tgz",
            "integrity": "sha512-+lP4/6lKUBfQjZ2pdxThZvLUAafmZb8OAxFb8XXtiQmS35INgr85hdOGoEs124ez1FCnZJt6jau/T+alh58QFQ==",
            "license": "MIT"
        },
        "node_modules/isexe": {
            "version": "2.0.0",
            "resolved": "https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz",
            "integrity": "sha512-RHxMLp9lnKHGHRng9QFhRCMbYAcVpn69smSGcq3f36xjgVVWThj4qqLbTLlq7Ssj8B+fIQ1EuCEGI2lKsyQeIw==",
            "license": "ISC"
        },
        "node_modules/its-fine": {
            "version": "2.0.0",
            "resolved": "https://registry.npmjs.org/its-fine/-/its-fine-2.0.0.tgz",
            "integrity": "sha512-KLViCmWx94zOvpLwSlsx6yOCeMhZYaxrJV87Po5k/FoZzcPSahvK5qJ7fYhS61sZi5ikmh2S3Hz55A2l3U69ng==",
            "license": "MIT",
            "dependencies": {
                "@types/react-reconciler": "^0.28.9"
            },
            "peerDependencies": {
                "react": "^19.0.0"
            }
        },
        "node_modules/lie": {
            "version": "3.3.0",
            "resolved": "https://registry.npmjs.org/lie/-/lie-3.3.0.tgz",
            "integrity": "sha512-UaiMJzeWRlEujzAuw5LokY1L5ecNQYZKfmyZ9L7wDHb/p5etKaxXhohBcrw0EYby+G/NA52vRSN4N39dxHAIwQ==",
            "license": "MIT",
            "dependencies": {
                "immediate": "~3.0.5"
            }
        },
        "node_modules/lightningcss": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss/-/lightningcss-1.32.0.tgz",
            "integrity": "sha512-NXYBzinNrblfraPGyrbPoD19C1h9lfI/1mzgWYvXUTe414Gz/X1FD2XBZSZM7rRTrMA8JL3OtAaGifrIKhQ5yQ==",
            "dev": true,
            "license": "MPL-2.0",
            "dependencies": {
                "detect-libc": "^2.0.3"
            },
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            },
            "optionalDependencies": {
                "lightningcss-android-arm64": "1.32.0",
                "lightningcss-darwin-arm64": "1.32.0",
                "lightningcss-darwin-x64": "1.32.0",
                "lightningcss-freebsd-x64": "1.32.0",
                "lightningcss-linux-arm-gnueabihf": "1.32.0",
                "lightningcss-linux-arm64-gnu": "1.32.0",
                "lightningcss-linux-arm64-musl": "1.32.0",
                "lightningcss-linux-x64-gnu": "1.32.0",
                "lightningcss-linux-x64-musl": "1.32.0",
                "lightningcss-win32-arm64-msvc": "1.32.0",
                "lightningcss-win32-x64-msvc": "1.32.0"
            }
        },
        "node_modules/lightningcss-android-arm64": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-android-arm64/-/lightningcss-android-arm64-1.32.0.tgz",
            "integrity": "sha512-YK7/ClTt4kAK0vo6w3X+Pnm0D2cf2vPHbhOXdoNti1Ga0al1P4TBZhwjATvjNwLEBCnKvjJc2jQgHXH0NEwlAg==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "android"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-darwin-arm64": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-darwin-arm64/-/lightningcss-darwin-arm64-1.32.0.tgz",
            "integrity": "sha512-RzeG9Ju5bag2Bv1/lwlVJvBE3q6TtXskdZLLCyfg5pt+HLz9BqlICO7LZM7VHNTTn/5PRhHFBSjk5lc4cmscPQ==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "darwin"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-darwin-x64": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-darwin-x64/-/lightningcss-darwin-x64-1.32.0.tgz",
            "integrity": "sha512-U+QsBp2m/s2wqpUYT/6wnlagdZbtZdndSmut/NJqlCcMLTWp5muCrID+K5UJ6jqD2BFshejCYXniPDbNh73V8w==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "darwin"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-freebsd-x64": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-freebsd-x64/-/lightningcss-freebsd-x64-1.32.0.tgz",
            "integrity": "sha512-JCTigedEksZk3tHTTthnMdVfGf61Fky8Ji2E4YjUTEQX14xiy/lTzXnu1vwiZe3bYe0q+SpsSH/CTeDXK6WHig==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "freebsd"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-linux-arm-gnueabihf": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-linux-arm-gnueabihf/-/lightningcss-linux-arm-gnueabihf-1.32.0.tgz",
            "integrity": "sha512-x6rnnpRa2GL0zQOkt6rts3YDPzduLpWvwAF6EMhXFVZXD4tPrBkEFqzGowzCsIWsPjqSK+tyNEODUBXeeVHSkw==",
            "cpu": [
                "arm"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-linux-arm64-gnu": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-linux-arm64-gnu/-/lightningcss-linux-arm64-gnu-1.32.0.tgz",
            "integrity": "sha512-0nnMyoyOLRJXfbMOilaSRcLH3Jw5z9HDNGfT/gwCPgaDjnx0i8w7vBzFLFR1f6CMLKF8gVbebmkUN3fa/kQJpQ==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-linux-arm64-musl": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-linux-arm64-musl/-/lightningcss-linux-arm64-musl-1.32.0.tgz",
            "integrity": "sha512-UpQkoenr4UJEzgVIYpI80lDFvRmPVg6oqboNHfoH4CQIfNA+HOrZ7Mo7KZP02dC6LjghPQJeBsvXhJod/wnIBg==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-linux-x64-gnu": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-linux-x64-gnu/-/lightningcss-linux-x64-gnu-1.32.0.tgz",
            "integrity": "sha512-V7Qr52IhZmdKPVr+Vtw8o+WLsQJYCTd8loIfpDaMRWGUZfBOYEJeyJIkqGIDMZPwPx24pUMfwSxxI8phr/MbOA==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-linux-x64-musl": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-linux-x64-musl/-/lightningcss-linux-x64-musl-1.32.0.tgz",
            "integrity": "sha512-bYcLp+Vb0awsiXg/80uCRezCYHNg1/l3mt0gzHnWV9XP1W5sKa5/TCdGWaR/zBM2PeF/HbsQv/j2URNOiVuxWg==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-win32-arm64-msvc": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-win32-arm64-msvc/-/lightningcss-win32-arm64-msvc-1.32.0.tgz",
            "integrity": "sha512-8SbC8BR40pS6baCM8sbtYDSwEVQd4JlFTOlaD3gWGHfThTcABnNDBda6eTZeqbofalIJhFx0qKzgHJmcPTnGdw==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "win32"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lightningcss-win32-x64-msvc": {
            "version": "1.32.0",
            "resolved": "https://registry.npmjs.org/lightningcss-win32-x64-msvc/-/lightningcss-win32-x64-msvc-1.32.0.tgz",
            "integrity": "sha512-Amq9B/SoZYdDi1kFrojnoqPLxYhQ4Wo5XiL8EVJrVsB8ARoC1PWW6VGtT0WKCemjy8aC+louJnjS7U18x3b06Q==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MPL-2.0",
            "optional": true,
            "os": [
                "win32"
            ],
            "engines": {
                "node": ">= 12.0.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/parcel"
            }
        },
        "node_modules/lodash": {
            "version": "4.18.1",
            "resolved": "https://registry.npmjs.org/lodash/-/lodash-4.18.1.tgz",
            "integrity": "sha512-dMInicTPVE8d1e5otfwmmjlxkZoUpiVLwyeTdUsi/Caj/gfzzblBcCE5sRHV/AsjuCmxWrte2TNGSYuCeCq+0Q==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/maath": {
            "version": "0.10.8",
            "resolved": "https://registry.npmjs.org/maath/-/maath-0.10.8.tgz",
            "integrity": "sha512-tRvbDF0Pgqz+9XUa4jjfgAQ8/aPKmQdWXilFu2tMy4GWj4NOsx99HlULO4IeREfbO3a0sA145DZYyvXPkybm0g==",
            "license": "MIT",
            "peerDependencies": {
                "@types/three": ">=0.134.0",
                "three": ">=0.134.0"
            }
        },
        "node_modules/make-error": {
            "version": "1.3.6",
            "resolved": "https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz",
            "integrity": "sha512-s8UhlNe7vPKomQhC1qFelMokr/Sc3AgNbso3n74mVPA5LTZwkB9NlXf4XPamLxJE8h0gh73rM94xvwRT2CVInw==",
            "dev": true,
            "license": "ISC"
        },
        "node_modules/meshline": {
            "version": "3.3.1",
            "resolved": "https://registry.npmjs.org/meshline/-/meshline-3.3.1.tgz",
            "integrity": "sha512-/TQj+JdZkeSUOl5Mk2J7eLcYTLiQm2IDzmlSvYm7ov15anEcDJ92GHqqazxTSreeNgfnYu24kiEvvv0WlbCdFQ==",
            "license": "MIT",
            "peerDependencies": {
                "three": ">=0.137"
            }
        },
        "node_modules/meshoptimizer": {
            "version": "1.1.1",
            "resolved": "https://registry.npmjs.org/meshoptimizer/-/meshoptimizer-1.1.1.tgz",
            "integrity": "sha512-oRFNWJRDA/WTrVj7NWvqa5HqE1t9MYDj2VaWirQCzCCrAd2GHrqR/sQezCxiWATPNlKTcRaPRHPJwIRoPBAp5g==",
            "license": "MIT"
        },
        "node_modules/minimatch": {
            "version": "3.1.5",
            "resolved": "https://registry.npmjs.org/minimatch/-/minimatch-3.1.5.tgz",
            "integrity": "sha512-VgjWUsnnT6n+NUk6eZq77zeFdpW2LWDzP6zFGrCbHXiYNul5Dzqk2HHQ5uFH2DNW5Xbp8+jVzaeNt94ssEEl4w==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "brace-expansion": "^1.1.7"
            },
            "engines": {
                "node": "*"
            }
        },
        "node_modules/minimist": {
            "version": "1.2.8",
            "resolved": "https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz",
            "integrity": "sha512-2yyAR8qBkN3YuheJanUpWC5U3bb5osDywNB8RzDVlDwDHbocAJveqqj1u8+SVD7jkWT4yvsHCpWqqWqAxb0zCA==",
            "dev": true,
            "license": "MIT",
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/mkdirp": {
            "version": "1.0.4",
            "resolved": "https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz",
            "integrity": "sha512-vVqVZQyf3WLx2Shd0qJ9xuvqgAyKPLAiqITEtqW0oIUjzo3PePDd6fW9iFz30ef7Ysp/oiWqbhszeGWW2T6Gzw==",
            "dev": true,
            "license": "MIT",
            "bin": {
                "mkdirp": "bin/cmd.js"
            },
            "engines": {
                "node": ">=10"
            }
        },
        "node_modules/nanoid": {
            "version": "3.3.11",
            "resolved": "https://registry.npmjs.org/nanoid/-/nanoid-3.3.11.tgz",
            "integrity": "sha512-N8SpfPUnUp1bK+PMYW8qSWdl9U+wwNWI4QKxOYDy9JAro3WMX7p2OeVRF9v+347pnakNevPmiHhNmZ2HbFA76w==",
            "dev": true,
            "funding": [
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "bin": {
                "nanoid": "bin/nanoid.cjs"
            },
            "engines": {
                "node": "^10 || ^12 || ^13.7 || ^14 || >=15.0.1"
            }
        },
        "node_modules/normalize-path": {
            "version": "3.0.0",
            "resolved": "https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz",
            "integrity": "sha512-6eZs5Ls3WtCisHWp9S2GUy8dqkpGi4BVSz3GaqiE6ezub0512ESztXUwUB6C6IKbQkY2Pnb/mD4WYojCRwcwLA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/once": {
            "version": "1.4.0",
            "resolved": "https://registry.npmjs.org/once/-/once-1.4.0.tgz",
            "integrity": "sha512-lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "wrappy": "1"
            }
        },
        "node_modules/path-is-absolute": {
            "version": "1.0.1",
            "resolved": "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz",
            "integrity": "sha512-AVbw3UJ2e9bq64vSaS9Am0fje1Pa8pbGqTTsmXfaIiMpnr5DlDhfJOuLj9Sf95ZPVDAUerDfEk88MPmPe7UCQg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/path-key": {
            "version": "3.1.1",
            "resolved": "https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz",
            "integrity": "sha512-ojmeN0qd+y0jszEtoY48r0Peq5dwMEkIlCOu6Q5f41lfkswXuKtYrhgoTpLnyIcHm24Uhqx+5Tqm2InSwLhE6Q==",
            "license": "MIT",
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/path-parse": {
            "version": "1.0.7",
            "resolved": "https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz",
            "integrity": "sha512-LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/picocolors": {
            "version": "1.1.1",
            "resolved": "https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz",
            "integrity": "sha512-xceH2snhtb5M9liqDsmEw56le376mTZkEX/jEb/RxNFyegNul7eNslCXP9FDj/Lcu0X8KEyMceP2ntpaHrDEVA==",
            "dev": true,
            "license": "ISC"
        },
        "node_modules/picomatch": {
            "version": "2.3.2",
            "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-2.3.2.tgz",
            "integrity": "sha512-V7+vQEJ06Z+c5tSye8S+nHUfI51xoXIXjHQ99cQtKUkQqqO1kO/KCJUfZXuB47h/YBlDhah2H3hdUGXn8ie0oA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=8.6"
            },
            "funding": {
                "url": "https://github.com/sponsors/jonschlinkert"
            }
        },
        "node_modules/postcss": {
            "version": "8.5.10",
            "resolved": "https://registry.npmjs.org/postcss/-/postcss-8.5.10.tgz",
            "integrity": "sha512-pMMHxBOZKFU6HgAZ4eyGnwXF/EvPGGqUr0MnZ5+99485wwW41kW91A4LOGxSHhgugZmSChL5AlElNdwlNgcnLQ==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/postcss/"
                },
                {
                    "type": "tidelift",
                    "url": "https://tidelift.com/funding/github/npm/postcss"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "nanoid": "^3.3.11",
                "picocolors": "^1.1.1",
                "source-map-js": "^1.2.1"
            },
            "engines": {
                "node": "^10 || ^12 || >=14"
            }
        },
        "node_modules/potpack": {
            "version": "1.0.2",
            "resolved": "https://registry.npmjs.org/potpack/-/potpack-1.0.2.tgz",
            "integrity": "sha512-choctRBIV9EMT9WGAZHn3V7t0Z2pMQyl0EZE6pFc/6ml3ssw7Dlf/oAOvFwjm1HVsqfQN8GfeFyJ+d8tRzqueQ==",
            "license": "ISC"
        },
        "node_modules/promise-worker-transferable": {
            "version": "1.0.4",
            "resolved": "https://registry.npmjs.org/promise-worker-transferable/-/promise-worker-transferable-1.0.4.tgz",
            "integrity": "sha512-bN+0ehEnrXfxV2ZQvU2PetO0n4gqBD4ulq3MI1WOPLgr7/Mg9yRQkX5+0v1vagr74ZTsl7XtzlaYDo2EuCeYJw==",
            "license": "Apache-2.0",
            "dependencies": {
                "is-promise": "^2.1.0",
                "lie": "^3.0.2"
            }
        },
        "node_modules/react": {
            "version": "19.2.5",
            "resolved": "https://registry.npmjs.org/react/-/react-19.2.5.tgz",
            "integrity": "sha512-llUJLzz1zTUBrskt2pwZgLq59AemifIftw4aB7JxOqf1HY2FDaGDxgwpAPVzHU1kdWabH7FauP4i1oEeer2WCA==",
            "license": "MIT",
            "peer": true,
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/react-use-measure": {
            "version": "2.1.7",
            "resolved": "https://registry.npmjs.org/react-use-measure/-/react-use-measure-2.1.7.tgz",
            "integrity": "sha512-KrvcAo13I/60HpwGO5jpW7E9DfusKyLPLvuHlUyP5zqnmAPhNc6qTRjUQrdTADl0lpPpDVU2/Gg51UlOGHXbdg==",
            "license": "MIT",
            "peerDependencies": {
                "react": ">=16.13",
                "react-dom": ">=16.13"
            },
            "peerDependenciesMeta": {
                "react-dom": {
                    "optional": true
                }
            }
        },
        "node_modules/readdirp": {
            "version": "3.6.0",
            "resolved": "https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz",
            "integrity": "sha512-hOS089on8RduqdbhvQ5Z37A0ESjsqz6qnRcffsMU3495FuTdqSm+7bhJ29JvIOsBDEEnan5DPu9t3To9VRlMzA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "picomatch": "^2.2.1"
            },
            "engines": {
                "node": ">=8.10.0"
            }
        },
        "node_modules/require-directory": {
            "version": "2.1.1",
            "resolved": "https://registry.npmjs.org/require-directory/-/require-directory-2.1.1.tgz",
            "integrity": "sha512-fGxEI7+wsG9xrvdjsrlmL22OMTTiHRwAMroiEeMgq8gzoLC/PQr7RsRDSTLUg/bZAZtF+TVIkHc6/4RIKrui+Q==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/require-from-string": {
            "version": "2.0.2",
            "resolved": "https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz",
            "integrity": "sha512-Xf0nWe6RseziFMu+Ap9biiUbmplq6S9/p+7w7YXP/JBHhrUDDUhwa+vANyubuqfZWTveU//DYVGsDG7RKL/vEw==",
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/resolve": {
            "version": "1.22.12",
            "resolved": "https://registry.npmjs.org/resolve/-/resolve-1.22.12.tgz",
            "integrity": "sha512-TyeJ1zif53BPfHootBGwPRYT1RUt6oGWsaQr8UyZW/eAm9bKoijtvruSDEmZHm92CwS9nj7/fWttqPCgzep8CA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "es-errors": "^1.3.0",
                "is-core-module": "^2.16.1",
                "path-parse": "^1.0.7",
                "supports-preserve-symlinks-flag": "^1.0.0"
            },
            "bin": {
                "resolve": "bin/resolve"
            },
            "engines": {
                "node": ">= 0.4"
            },
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/rimraf": {
            "version": "2.7.1",
            "resolved": "https://registry.npmjs.org/rimraf/-/rimraf-2.7.1.tgz",
            "integrity": "sha512-uWjbaKIK3T1OSVptzX7Nl6PvQ3qAGtKEtVRjRuazjfL3Bx5eI409VZSqgND+4UNnmzLVdPj9FqFJNPqBZFve4w==",
            "deprecated": "Rimraf versions prior to v4 are no longer supported",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "glob": "^7.1.3"
            },
            "bin": {
                "rimraf": "bin.js"
            }
        },
        "node_modules/rolldown": {
            "version": "1.0.0-rc.17",
            "resolved": "https://registry.npmjs.org/rolldown/-/rolldown-1.0.0-rc.17.tgz",
            "integrity": "sha512-ZrT53oAKrtA4+YtBWPQbtPOxIbVDbxT0orcYERKd63VJTF13zPcgXTvD4843L8pcsI7M6MErt8QtON6lrB9tyA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@oxc-project/types": "=0.127.0",
                "@rolldown/pluginutils": "1.0.0-rc.17"
            },
            "bin": {
                "rolldown": "bin/cli.mjs"
            },
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            },
            "optionalDependencies": {
                "@rolldown/binding-android-arm64": "1.0.0-rc.17",
                "@rolldown/binding-darwin-arm64": "1.0.0-rc.17",
                "@rolldown/binding-darwin-x64": "1.0.0-rc.17",
                "@rolldown/binding-freebsd-x64": "1.0.0-rc.17",
                "@rolldown/binding-linux-arm-gnueabihf": "1.0.0-rc.17",
                "@rolldown/binding-linux-arm64-gnu": "1.0.0-rc.17",
                "@rolldown/binding-linux-arm64-musl": "1.0.0-rc.17",
                "@rolldown/binding-linux-ppc64-gnu": "1.0.0-rc.17",
                "@rolldown/binding-linux-s390x-gnu": "1.0.0-rc.17",
                "@rolldown/binding-linux-x64-gnu": "1.0.0-rc.17",
                "@rolldown/binding-linux-x64-musl": "1.0.0-rc.17",
                "@rolldown/binding-openharmony-arm64": "1.0.0-rc.17",
                "@rolldown/binding-wasm32-wasi": "1.0.0-rc.17",
                "@rolldown/binding-win32-arm64-msvc": "1.0.0-rc.17",
                "@rolldown/binding-win32-x64-msvc": "1.0.0-rc.17"
            }
        },
        "node_modules/rxjs": {
            "version": "7.8.2",
            "resolved": "https://registry.npmjs.org/rxjs/-/rxjs-7.8.2.tgz",
            "integrity": "sha512-dhKf903U/PQZY6boNNtAGdWbG85WAbjT/1xYoZIC7FAY0yWapOBQVsVrDl58W86//e1VpMNBtRV4MaXfdMySFA==",
            "dev": true,
            "license": "Apache-2.0",
            "dependencies": {
                "tslib": "^2.1.0"
            }
        },
        "node_modules/scheduler": {
            "version": "0.27.0",
            "resolved": "https://registry.npmjs.org/scheduler/-/scheduler-0.27.0.tgz",
            "integrity": "sha512-eNv+WrVbKu1f3vbYJT/xtiF5syA5HPIMtf9IgY/nKg0sWqzAUEvqY/xm7OcZc/qafLx/iO9FgOmeSAp4v5ti/Q==",
            "license": "MIT"
        },
        "node_modules/shebang-command": {
            "version": "2.0.0",
            "resolved": "https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz",
            "integrity": "sha512-kHxr2zZpYtdmrN1qDjrrX/Z1rR1kG8Dx+gkpK1G4eXmvXswmcE1hTWBWYUzlraYw1/yZp6YuDY77YtvbN0dmDA==",
            "license": "MIT",
            "dependencies": {
                "shebang-regex": "^3.0.0"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/shebang-regex": {
            "version": "3.0.0",
            "resolved": "https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz",
            "integrity": "sha512-7++dFhtcx3353uBaq8DDR4NuxBetBzC7ZQOhmTQInHEd6bSrXdiEyzCvG07Z44UYdLShWUyXt5M/yhz8ekcb1A==",
            "license": "MIT",
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/shell-quote": {
            "version": "1.8.3",
            "resolved": "https://registry.npmjs.org/shell-quote/-/shell-quote-1.8.3.tgz",
            "integrity": "sha512-ObmnIF4hXNg1BqhnHmgbDETF8dLPCggZWBjkQfhZpbszZnYur5DUljTcCHii5LC3J5E0yeO/1LIMyH+UvHQgyw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 0.4"
            },
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/source-map": {
            "version": "0.6.1",
            "resolved": "https://registry.npmjs.org/source-map/-/source-map-0.6.1.tgz",
            "integrity": "sha512-UjgapumWlbMhkBgzT7Ykc5YXUT46F0iKu8SGXq0bcwP5dz/h0Plj6enJqjz1Zbq2l5WaqYnrVbwWOWMyF3F47g==",
            "dev": true,
            "license": "BSD-3-Clause",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/source-map-js": {
            "version": "1.2.1",
            "resolved": "https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz",
            "integrity": "sha512-UXWMKhLOwVKb728IUtQPXxfYU+usdybtUrK/8uGE8CQMvrhOpwvzDBwj0QhSL7MQc7vIsISBG8VQ8+IDQxpfQA==",
            "dev": true,
            "license": "BSD-3-Clause",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/source-map-support": {
            "version": "0.5.21",
            "resolved": "https://registry.npmjs.org/source-map-support/-/source-map-support-0.5.21.tgz",
            "integrity": "sha512-uBHU3L3czsIyYXKX88fdrGovxdSCoTGDRZ6SYXtSRxLZUzHg5P/66Ht6uoUlHu9EZod+inXhKo3qQgwXUT/y1w==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "buffer-from": "^1.0.0",
                "source-map": "^0.6.0"
            }
        },
        "node_modules/spawn-command": {
            "version": "0.0.2",
            "resolved": "https://registry.npmjs.org/spawn-command/-/spawn-command-0.0.2.tgz",
            "integrity": "sha512-zC8zGoGkmc8J9ndvml8Xksr1Amk9qBujgbF0JAIWO7kXr43w0h/0GJNM/Vustixu+YE8N/MTrQ7N31FvHUACxQ==",
            "dev": true
        },
        "node_modules/stats-gl": {
            "version": "2.4.2",
            "resolved": "https://registry.npmjs.org/stats-gl/-/stats-gl-2.4.2.tgz",
            "integrity": "sha512-g5O9B0hm9CvnM36+v7SFl39T7hmAlv541tU81ME8YeSb3i1CIP5/QdDeSB3A0la0bKNHpxpwxOVRo2wFTYEosQ==",
            "license": "MIT",
            "dependencies": {
                "@types/three": "*",
                "three": "^0.170.0"
            },
            "peerDependencies": {
                "@types/three": "*",
                "three": "*"
            }
        },
        "node_modules/stats-gl/node_modules/three": {
            "version": "0.170.0",
            "resolved": "https://registry.npmjs.org/three/-/three-0.170.0.tgz",
            "integrity": "sha512-FQK+LEpYc0fBD+J8g6oSEyyNzjp+Q7Ks1C568WWaoMRLW+TkNNWmenWeGgJjV105Gd+p/2ql1ZcjYvNiPZBhuQ==",
            "license": "MIT"
        },
        "node_modules/stats.js": {
            "version": "0.17.0",
            "resolved": "https://registry.npmjs.org/stats.js/-/stats.js-0.17.0.tgz",
            "integrity": "sha512-hNKz8phvYLPEcRkeG1rsGmV5ChMjKDAWU7/OJJdDErPBNChQXxCo3WZurGpnWc6gZhAzEPFad1aVgyOANH1sMw==",
            "license": "MIT"
        },
        "node_modules/string-width": {
            "version": "4.2.3",
            "resolved": "https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz",
            "integrity": "sha512-wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "emoji-regex": "^8.0.0",
                "is-fullwidth-code-point": "^3.0.0",
                "strip-ansi": "^6.0.1"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/strip-ansi": {
            "version": "6.0.1",
            "resolved": "https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz",
            "integrity": "sha512-Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "ansi-regex": "^5.0.1"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/strip-bom": {
            "version": "3.0.0",
            "resolved": "https://registry.npmjs.org/strip-bom/-/strip-bom-3.0.0.tgz",
            "integrity": "sha512-vavAMRXOgBVNF6nyEEmL3DBK19iRpDcoIwW+swQ+CbGiu7lju6t+JklA1MHweoWtadgt4ISVUsXLyDq34ddcwA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=4"
            }
        },
        "node_modules/strip-json-comments": {
            "version": "2.0.1",
            "resolved": "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz",
            "integrity": "sha512-4gB8na07fecVVkOI6Rs4e7T6NOTki5EmL7TUduTs6bu3EdnSycntVJ4re8kgZA+wx9IueI2Y11bfbgwtzuE0KQ==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/supports-color": {
            "version": "8.1.1",
            "resolved": "https://registry.npmjs.org/supports-color/-/supports-color-8.1.1.tgz",
            "integrity": "sha512-MpUEN2OodtUzxvKQl72cUF7RQ5EiHsGvSsVG0ia9c5RbWGL2CI4C7EpPS8UTBIplnlzZiNuV56w+FuNxy3ty2Q==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "has-flag": "^4.0.0"
            },
            "engines": {
                "node": ">=10"
            },
            "funding": {
                "url": "https://github.com/chalk/supports-color?sponsor=1"
            }
        },
        "node_modules/supports-preserve-symlinks-flag": {
            "version": "1.0.0",
            "resolved": "https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz",
            "integrity": "sha512-ot0WnXS9fgdkgIcePe6RHNk1WA8+muPa6cSjeR3V8K27q9BB1rTE3R1p7Hv0z1ZyAc8s6Vvv8DIyWf681MAt0w==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 0.4"
            },
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/suspend-react": {
            "version": "0.1.3",
            "resolved": "https://registry.npmjs.org/suspend-react/-/suspend-react-0.1.3.tgz",
            "integrity": "sha512-aqldKgX9aZqpoDp3e8/BZ8Dm7x1pJl+qI3ZKxDN0i/IQTWUwBx/ManmlVJ3wowqbno6c2bmiIfs+Um6LbsjJyQ==",
            "license": "MIT",
            "peerDependencies": {
                "react": ">=17.0"
            }
        },
        "node_modules/three": {
            "version": "0.184.0",
            "resolved": "https://registry.npmjs.org/three/-/three-0.184.0.tgz",
            "integrity": "sha512-wtTRjG92pM5eUg/KuUnHsqSAlPM296brTOcLgMRqEeylYTh/CdtvKUvCyyCQTzFuStieWxvZb8mVTMvdPyUpxg==",
            "license": "MIT"
        },
        "node_modules/three-mesh-bvh": {
            "version": "0.8.3",
            "resolved": "https://registry.npmjs.org/three-mesh-bvh/-/three-mesh-bvh-0.8.3.tgz",
            "integrity": "sha512-4G5lBaF+g2auKX3P0yqx+MJC6oVt6sB5k+CchS6Ob0qvH0YIhuUk1eYr7ktsIpY+albCqE80/FVQGV190PmiAg==",
            "license": "MIT",
            "peerDependencies": {
                "three": ">= 0.159.0"
            }
        },
        "node_modules/three-stdlib": {
            "version": "2.36.1",
            "resolved": "https://registry.npmjs.org/three-stdlib/-/three-stdlib-2.36.1.tgz",
            "integrity": "sha512-XyGQrFmNQ5O/IoKm556ftwKsBg11TIb301MB5dWNicziQBEs2g3gtOYIf7pFiLa0zI2gUwhtCjv9fmjnxKZ1Cg==",
            "license": "MIT",
            "dependencies": {
                "@types/draco3d": "^1.4.0",
                "@types/offscreencanvas": "^2019.6.4",
                "@types/webxr": "^0.5.2",
                "draco3d": "^1.4.1",
                "fflate": "^0.6.9",
                "potpack": "^1.0.1"
            },
            "peerDependencies": {
                "three": ">=0.128.0"
            }
        },
        "node_modules/three-stdlib/node_modules/fflate": {
            "version": "0.6.10",
            "resolved": "https://registry.npmjs.org/fflate/-/fflate-0.6.10.tgz",
            "integrity": "sha512-IQrh3lEPM93wVCEczc9SaAOvkmcoQn/G8Bo1e8ZPlY3X3bnAxWaBdvTdvM1hP62iZp0BXWDy4vTAy4fF0+Dlpg==",
            "license": "MIT"
        },
        "node_modules/tinyglobby": {
            "version": "0.2.16",
            "resolved": "https://registry.npmjs.org/tinyglobby/-/tinyglobby-0.2.16.tgz",
            "integrity": "sha512-pn99VhoACYR8nFHhxqix+uvsbXineAasWm5ojXoN8xEwK5Kd3/TrhNn1wByuD52UxWRLy8pu+kRMniEi6Eq9Zg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "fdir": "^6.5.0",
                "picomatch": "^4.0.4"
            },
            "engines": {
                "node": ">=12.0.0"
            },
            "funding": {
                "url": "https://github.com/sponsors/SuperchupuDev"
            }
        },
        "node_modules/tinyglobby/node_modules/fdir": {
            "version": "6.5.0",
            "resolved": "https://registry.npmjs.org/fdir/-/fdir-6.5.0.tgz",
            "integrity": "sha512-tIbYtZbucOs0BRGqPJkshJUYdL+SDH7dVM8gjy+ERp3WAUjLEFJE+02kanyHtwjWOnwrKYBiwAmM0p4kLJAnXg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=12.0.0"
            },
            "peerDependencies": {
                "picomatch": "^3 || ^4"
            },
            "peerDependenciesMeta": {
                "picomatch": {
                    "optional": true
                }
            }
        },
        "node_modules/tinyglobby/node_modules/picomatch": {
            "version": "4.0.4",
            "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-4.0.4.tgz",
            "integrity": "sha512-QP88BAKvMam/3NxH6vj2o21R6MjxZUAd6nlwAS/pnGvN9IVLocLHxGYIzFhg6fUQ+5th6P4dv4eW9jX3DSIj7A==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=12"
            },
            "funding": {
                "url": "https://github.com/sponsors/jonschlinkert"
            }
        },
        "node_modules/to-regex-range": {
            "version": "5.0.1",
            "resolved": "https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz",
            "integrity": "sha512-65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "is-number": "^7.0.0"
            },
            "engines": {
                "node": ">=8.0"
            }
        },
        "node_modules/tree-kill": {
            "version": "1.2.2",
            "resolved": "https://registry.npmjs.org/tree-kill/-/tree-kill-1.2.2.tgz",
            "integrity": "sha512-L0Orpi8qGpRG//Nd+H90vFB+3iHnue1zSSGmNOOCh1GLJ7rUKVwV2HvijphGQS2UmhUZewS9VgvxYIdgr+fG1A==",
            "dev": true,
            "license": "MIT",
            "bin": {
                "tree-kill": "cli.js"
            }
        },
        "node_modules/troika-three-text": {
            "version": "0.52.4",
            "resolved": "https://registry.npmjs.org/troika-three-text/-/troika-three-text-0.52.4.tgz",
            "integrity": "sha512-V50EwcYGruV5rUZ9F4aNsrytGdKcXKALjEtQXIOBfhVoZU9VAqZNIoGQ3TMiooVqFAbR1w15T+f+8gkzoFzawg==",
            "license": "MIT",
            "dependencies": {
                "bidi-js": "^1.0.2",
                "troika-three-utils": "^0.52.4",
                "troika-worker-utils": "^0.52.0",
                "webgl-sdf-generator": "1.1.1"
            },
            "peerDependencies": {
                "three": ">=0.125.0"
            }
        },
        "node_modules/troika-three-utils": {
            "version": "0.52.4",
            "resolved": "https://registry.npmjs.org/troika-three-utils/-/troika-three-utils-0.52.4.tgz",
            "integrity": "sha512-NORAStSVa/BDiG52Mfudk4j1FG4jC4ILutB3foPnfGbOeIs9+G5vZLa0pnmnaftZUGm4UwSoqEpWdqvC7zms3A==",
            "license": "MIT",
            "peerDependencies": {
                "three": ">=0.125.0"
            }
        },
        "node_modules/troika-worker-utils": {
            "version": "0.52.0",
            "resolved": "https://registry.npmjs.org/troika-worker-utils/-/troika-worker-utils-0.52.0.tgz",
            "integrity": "sha512-W1CpvTHykaPH5brv5VHLfQo9D1OYuo0cSBEUQFFT/nBUzM8iD6Lq2/tgG/f1OelbAS1WtaTPQzE5uM49egnngw==",
            "license": "MIT"
        },
        "node_modules/ts-node": {
            "version": "10.9.2",
            "resolved": "https://registry.npmjs.org/ts-node/-/ts-node-10.9.2.tgz",
            "integrity": "sha512-f0FFpIdcHgn8zcPSbf1dRevwt047YMnaiJM3u2w2RewrB+fob/zePZcrOyQoLMMO7aBIddLcQIEK5dYjkLnGrQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@cspotcode/source-map-support": "^0.8.0",
                "@tsconfig/node10": "^1.0.7",
                "@tsconfig/node12": "^1.0.7",
                "@tsconfig/node14": "^1.0.0",
                "@tsconfig/node16": "^1.0.2",
                "acorn": "^8.4.1",
                "acorn-walk": "^8.1.1",
                "arg": "^4.1.0",
                "create-require": "^1.1.0",
                "diff": "^4.0.1",
                "make-error": "^1.1.1",
                "v8-compile-cache-lib": "^3.0.1",
                "yn": "3.1.1"
            },
            "bin": {
                "ts-node": "dist/bin.js",
                "ts-node-cwd": "dist/bin-cwd.js",
                "ts-node-esm": "dist/bin-esm.js",
                "ts-node-script": "dist/bin-script.js",
                "ts-node-transpile-only": "dist/bin-transpile.js",
                "ts-script": "dist/bin-script-deprecated.js"
            },
            "peerDependencies": {
                "@swc/core": ">=1.2.50",
                "@swc/wasm": ">=1.2.50",
                "@types/node": "*",
                "typescript": ">=2.7"
            },
            "peerDependenciesMeta": {
                "@swc/core": {
                    "optional": true
                },
                "@swc/wasm": {
                    "optional": true
                }
            }
        },
        "node_modules/ts-node-dev": {
            "version": "2.0.0",
            "resolved": "https://registry.npmjs.org/ts-node-dev/-/ts-node-dev-2.0.0.tgz",
            "integrity": "sha512-ywMrhCfH6M75yftYvrvNarLEY+SUXtUvU8/0Z6llrHQVBx12GiFk5sStF8UdfE/yfzk9IAq7O5EEbTQsxlBI8w==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "chokidar": "^3.5.1",
                "dynamic-dedupe": "^0.3.0",
                "minimist": "^1.2.6",
                "mkdirp": "^1.0.4",
                "resolve": "^1.0.0",
                "rimraf": "^2.6.1",
                "source-map-support": "^0.5.12",
                "tree-kill": "^1.2.2",
                "ts-node": "^10.4.0",
                "tsconfig": "^7.0.0"
            },
            "bin": {
                "ts-node-dev": "lib/bin.js",
                "tsnd": "lib/bin.js"
            },
            "engines": {
                "node": ">=0.8.0"
            },
            "peerDependencies": {
                "node-notifier": "*",
                "typescript": "*"
            },
            "peerDependenciesMeta": {
                "node-notifier": {
                    "optional": true
                }
            }
        },
        "node_modules/tsconfig": {
            "version": "7.0.0",
            "resolved": "https://registry.npmjs.org/tsconfig/-/tsconfig-7.0.0.tgz",
            "integrity": "sha512-vZXmzPrL+EmC4T/4rVlT2jNVMWCi/O4DIiSj3UHg1OE5kCKbk4mfrXc6dZksLgRM/TZlKnousKH9bbTazUWRRw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@types/strip-bom": "^3.0.0",
                "@types/strip-json-comments": "0.0.30",
                "strip-bom": "^3.0.0",
                "strip-json-comments": "^2.0.0"
            }
        },
        "node_modules/tslib": {
            "version": "2.8.1",
            "resolved": "https://registry.npmjs.org/tslib/-/tslib-2.8.1.tgz",
            "integrity": "sha512-oJFu94HQb+KVduSUQL7wnpmqnfmLsOA/nAh6b6EH0wCEoK0/mPeXU6c3wKDV83MkOuHPRHtSXKKU99IBazS/2w==",
            "dev": true,
            "license": "0BSD"
        },
        "node_modules/tunnel-rat": {
            "version": "0.1.2",
            "resolved": "https://registry.npmjs.org/tunnel-rat/-/tunnel-rat-0.1.2.tgz",
            "integrity": "sha512-lR5VHmkPhzdhrM092lI2nACsLO4QubF0/yoOhzX7c+wIpbN1GjHNzCc91QlpxBi+cnx8vVJ+Ur6vL5cEoQPFpQ==",
            "license": "MIT",
            "dependencies": {
                "zustand": "^4.3.2"
            }
        },
        "node_modules/tunnel-rat/node_modules/zustand": {
            "version": "4.5.7",
            "resolved": "https://registry.npmjs.org/zustand/-/zustand-4.5.7.tgz",
            "integrity": "sha512-CHOUy7mu3lbD6o6LJLfllpjkzhHXSBlX8B9+qPddUsIfeF5S/UZ5q0kmCsnRqT1UHFQZchNFDDzMbQsuesHWlw==",
            "license": "MIT",
            "dependencies": {
                "use-sync-external-store": "^1.2.2"
            },
            "engines": {
                "node": ">=12.7.0"
            },
            "peerDependencies": {
                "@types/react": ">=16.8",
                "immer": ">=9.0.6",
                "react": ">=16.8"
            },
            "peerDependenciesMeta": {
                "@types/react": {
                    "optional": true
                },
                "immer": {
                    "optional": true
                },
                "react": {
                    "optional": true
                }
            }
        },
        "node_modules/typescript": {
            "version": "5.9.3",
            "resolved": "https://registry.npmjs.org/typescript/-/typescript-5.9.3.tgz",
            "integrity": "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw==",
            "dev": true,
            "license": "Apache-2.0",
            "bin": {
                "tsc": "bin/tsc",
                "tsserver": "bin/tsserver"
            },
            "engines": {
                "node": ">=14.17"
            }
        },
        "node_modules/undici-types": {
            "version": "7.19.2",
            "resolved": "https://registry.npmjs.org/undici-types/-/undici-types-7.19.2.tgz",
            "integrity": "sha512-qYVnV5OEm2AW8cJMCpdV20CDyaN3g0AjDlOGf1OW4iaDEx8MwdtChUp4zu4H0VP3nDRF/8RKWH+IPp9uW0YGZg==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/use-sync-external-store": {
            "version": "1.6.0",
            "resolved": "https://registry.npmjs.org/use-sync-external-store/-/use-sync-external-store-1.6.0.tgz",
            "integrity": "sha512-Pp6GSwGP/NrPIrxVFAIkOQeyw8lFenOHijQWkUTrDvrF4ALqylP2C/KCkeS9dpUM3KvYRQhna5vt7IL95+ZQ9w==",
            "license": "MIT",
            "peerDependencies": {
                "react": "^16.8.0 || ^17.0.0 || ^18.0.0 || ^19.0.0"
            }
        },
        "node_modules/utility-types": {
            "version": "3.11.0",
            "resolved": "https://registry.npmjs.org/utility-types/-/utility-types-3.11.0.tgz",
            "integrity": "sha512-6Z7Ma2aVEWisaL6TvBCy7P8rm2LQoPv6dJ7ecIaIixHcwfbJ0x7mWdbcwlIM5IGQxPZSFYeqRCqlOOeKoJYMkw==",
            "license": "MIT",
            "engines": {
                "node": ">= 4"
            }
        },
        "node_modules/v8-compile-cache-lib": {
            "version": "3.0.1",
            "resolved": "https://registry.npmjs.org/v8-compile-cache-lib/-/v8-compile-cache-lib-3.0.1.tgz",
            "integrity": "sha512-wa7YjyUGfNZngI/vtK0UHAN+lgDCxBPCylVXGp0zu59Fz5aiGtNXaq3DhIov063MorB+VfufLh3JlF2KdTK3xg==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/vite": {
            "version": "8.0.10",
            "resolved": "https://registry.npmjs.org/vite/-/vite-8.0.10.tgz",
            "integrity": "sha512-rZuUu9j6J5uotLDs+cAA4O5H4K1SfPliUlQwqa6YEwSrWDZzP4rhm00oJR5snMewjxF5V/K3D4kctsUTsIU9Mw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "lightningcss": "^1.32.0",
                "picomatch": "^4.0.4",
                "postcss": "^8.5.10",
                "rolldown": "1.0.0-rc.17",
                "tinyglobby": "^0.2.16"
            },
            "bin": {
                "vite": "bin/vite.js"
            },
            "engines": {
                "node": "^20.19.0 || >=22.12.0"
            },
            "funding": {
                "url": "https://github.com/vitejs/vite?sponsor=1"
            },
            "optionalDependencies": {
                "fsevents": "~2.3.3"
            },
            "peerDependencies": {
                "@types/node": "^20.19.0 || >=22.12.0",
                "@vitejs/devtools": "^0.1.0",
                "esbuild": "^0.27.0 || ^0.28.0",
                "jiti": ">=1.21.0",
                "less": "^4.0.0",
                "sass": "^1.70.0",
                "sass-embedded": "^1.70.0",
                "stylus": ">=0.54.8",
                "sugarss": "^5.0.0",
                "terser": "^5.16.0",
                "tsx": "^4.8.1",
                "yaml": "^2.4.2"
            },
            "peerDependenciesMeta": {
                "@types/node": {
                    "optional": true
                },
                "@vitejs/devtools": {
                    "optional": true
                },
                "esbuild": {
                    "optional": true
                },
                "jiti": {
                    "optional": true
                },
                "less": {
                    "optional": true
                },
                "sass": {
                    "optional": true
                },
                "sass-embedded": {
                    "optional": true
                },
                "stylus": {
                    "optional": true
                },
                "sugarss": {
                    "optional": true
                },
                "terser": {
                    "optional": true
                },
                "tsx": {
                    "optional": true
                },
                "yaml": {
                    "optional": true
                }
            }
        },
        "node_modules/vite/node_modules/picomatch": {
            "version": "4.0.4",
            "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-4.0.4.tgz",
            "integrity": "sha512-QP88BAKvMam/3NxH6vj2o21R6MjxZUAd6nlwAS/pnGvN9IVLocLHxGYIzFhg6fUQ+5th6P4dv4eW9jX3DSIj7A==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=12"
            },
            "funding": {
                "url": "https://github.com/sponsors/jonschlinkert"
            }
        },
        "node_modules/webgl-constants": {
            "version": "1.1.1",
            "resolved": "https://registry.npmjs.org/webgl-constants/-/webgl-constants-1.1.1.tgz",
            "integrity": "sha512-LkBXKjU5r9vAW7Gcu3T5u+5cvSvh5WwINdr0C+9jpzVB41cjQAP5ePArDtk/WHYdVj0GefCgM73BA7FlIiNtdg=="
        },
        "node_modules/webgl-sdf-generator": {
            "version": "1.1.1",
            "resolved": "https://registry.npmjs.org/webgl-sdf-generator/-/webgl-sdf-generator-1.1.1.tgz",
            "integrity": "sha512-9Z0JcMTFxeE+b2x1LJTdnaT8rT8aEp7MVxkNwoycNmJWwPdzoXzMh0BjJSh/AEFP+KPYZUli814h8bJZFIZ2jA==",
            "license": "MIT"
        },
        "node_modules/which": {
            "version": "2.0.2",
            "resolved": "https://registry.npmjs.org/which/-/which-2.0.2.tgz",
            "integrity": "sha512-BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==",
            "license": "ISC",
            "dependencies": {
                "isexe": "^2.0.0"
            },
            "bin": {
                "node-which": "bin/node-which"
            },
            "engines": {
                "node": ">= 8"
            }
        },
        "node_modules/wrap-ansi": {
            "version": "7.0.0",
            "resolved": "https://registry.npmjs.org/wrap-ansi/-/wrap-ansi-7.0.0.tgz",
            "integrity": "sha512-YVGIj2kamLSTxw6NsZjoBxfSwsn0ycdesmc4p+Q21c5zPuZ1pl+NfxVdxPtdHvmNVOQ6XSYG4AUtyt/Fi7D16Q==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "ansi-styles": "^4.0.0",
                "string-width": "^4.1.0",
                "strip-ansi": "^6.0.0"
            },
            "engines": {
                "node": ">=10"
            },
            "funding": {
                "url": "https://github.com/chalk/wrap-ansi?sponsor=1"
            }
        },
        "node_modules/wrappy": {
            "version": "1.0.2",
            "resolved": "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz",
            "integrity": "sha512-l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==",
            "dev": true,
            "license": "ISC"
        },
        "node_modules/xtend": {
            "version": "4.0.2",
            "resolved": "https://registry.npmjs.org/xtend/-/xtend-4.0.2.tgz",
            "integrity": "sha512-LKYU1iAXJXUgAXn9URjiu+MWhyUXHsvfp7mcuYm9dSUKK0/CjtrUwFAxD82/mCWbtLsGjFIad0wIsod4zrTAEQ==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.4"
            }
        },
        "node_modules/y18n": {
            "version": "5.0.8",
            "resolved": "https://registry.npmjs.org/y18n/-/y18n-5.0.8.tgz",
            "integrity": "sha512-0pfFzegeDWJHJIAmTLRP2DwHjdF5s7jo9tuztdQxAhINCdvS+3nGINqPd00AphqJR/0LhANUS6/+7SCb98YOfA==",
            "dev": true,
            "license": "ISC",
            "engines": {
                "node": ">=10"
            }
        },
        "node_modules/yargs": {
            "version": "17.7.2",
            "resolved": "https://registry.npmjs.org/yargs/-/yargs-17.7.2.tgz",
            "integrity": "sha512-7dSzzRQ++CKnNI/krKnYRV7JKKPUXMEh61soaHKg9mrWEhzFWhFnxPxGl+69cD1Ou63C13NUPCnmIcrvqCuM6w==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "cliui": "^8.0.1",
                "escalade": "^3.1.1",
                "get-caller-file": "^2.0.5",
                "require-directory": "^2.1.1",
                "string-width": "^4.2.3",
                "y18n": "^5.0.5",
                "yargs-parser": "^21.1.1"
            },
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/yargs-parser": {
            "version": "21.1.1",
            "resolved": "https://registry.npmjs.org/yargs-parser/-/yargs-parser-21.1.1.tgz",
            "integrity": "sha512-tVpsJW7DdjecAiFpbIB1e3qxIQsE6NoPc5/eTdrbbIC4h0LVsWhnoa3g+m2HclBIujHzsxZ4VJVA+GUuc2/LBw==",
            "dev": true,
            "license": "ISC",
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/yn": {
            "version": "3.1.1",
            "resolved": "https://registry.npmjs.org/yn/-/yn-3.1.1.tgz",
            "integrity": "sha512-Ux4ygGWsu2c7isFWe8Yu1YluJmqVhxqK2cLXNQA5AcC3QfbGNpM7fu0Y8b/z16pXLnFxZYvWhd3fhBY9DLmC6Q==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6"
            }
        },
        "node_modules/zustand": {
            "version": "5.0.12",
            "resolved": "https://registry.npmjs.org/zustand/-/zustand-5.0.12.tgz",
            "integrity": "sha512-i77ae3aZq4dhMlRhJVCYgMLKuSiZAaUPAct2AksxQ+gOtimhGMdXljRT21P5BNpeT4kXlLIckvkPM029OljD7g==",
            "license": "MIT",
            "engines": {
                "node": ">=12.20.0"
            },
            "peerDependencies": {
                "@types/react": ">=18.0.0",
                "immer": ">=9.0.6",
                "react": ">=18.0.0",
                "use-sync-external-store": ">=1.2.0"
            },
            "peerDependenciesMeta": {
                "@types/react": {
                    "optional": true
                },
                "immer": {
                    "optional": true
                },
                "react": {
                    "optional": true
                },
                "use-sync-external-store": {
                    "optional": true
                }
            }
        }
    }
}
// FILE: package.json
{
    "name": "via51-fractal",
    "version": "1.0.0",
    "scripts": {
        "install:all": "npm install && cd via51-alfa && npm install && cd ../via51-beta && npm install && cd ../via51-gamma && npm install",
        "dev:beta": "cd via51-beta && npx ts-node-dev src/server.ts",
        "dev:alfa": "cd via51-alfa && npm run dev",
        "dev:gamma": "cd via51-gamma && npm run dev",
        "dev:fractal": "npx concurrently \"npm run dev:beta\" \"npm run dev:alfa\" \"npm run dev:gamma\""
    },
    "devDependencies": {
        "@types/node": "^25.6.0",
        "concurrently": "^8.2.0",
        "ts-node-dev": "^2.0.0",
        "typescript": "^5.0.0",
        "vite": "^8.0.10"
    },
    "dependencies": {
        "@react-three/drei": "^10.7.7",
        "@react-three/fiber": "^9.6.0",
        "@types/three": "^0.184.0",
        "three": "^0.184.0"
    }
}
// FILE: tsconfig.base.json
{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": [
      "DOM",
      "DOM.Iterable",
      "ESNext"
    ],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": false,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "types": [
      "vite/client",
      "node"
    ],
    "baseUrl": ".",
    "paths": {
      "@alfa/*": [
        "via51-alfa/src/*"
      ],
      "@beta/*": [
        "via51-beta/src/*"
      ],
      "@gamma/*": [
        "via51-gamma/src/*"
      ],
      "@gamma/lib/*": [
        "via51-gamma/src/layers/lib/*"
      ]
    }
  }
}
// FILE: tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "node",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    },
    "types": ["node", "vite/client"]
  },
  "include": ["src", "vite-env.d.ts"]
}
// FILE: tsconfig.node.json
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true,
    "strict": true
  },
  "include": ["vite.config.ts"]
}
// FILE: vercel.json
{
  "cleanUrls": true,
  "rewrites": [
    {
      "source": "/(.*)",
      "has": [
        {
          "type": "host",
          "value": "ard.via51.org"
        }
      ],
      "destination": "/internal-holding/$1"
    },
    {
      "source": "/(.*)",
      "has": [
        {
          "type": "host",
          "value": "pol.via51.org"
        }
      ],
      "destination": "/political-branch/$1"
    }
  ]
}
// FILE: package.json
{
  "type": "module"
}
// FILE: _metadata.json
{
  "hash": "9204b7f7",
  "browserHash": "c6ae5b69",
  "optimized": {
    "react": {
      "src": "../../node_modules/react/index.js",
      "file": "react.js",
      "fileHash": "e27bd139",
      "needsInterop": true
    },
    "react-dom": {
      "src": "../../node_modules/react-dom/index.js",
      "file": "react-dom.js",
      "fileHash": "1953108d",
      "needsInterop": true
    },
    "react/jsx-dev-runtime": {
      "src": "../../node_modules/react/jsx-dev-runtime.js",
      "file": "react_jsx-dev-runtime.js",
      "fileHash": "356f5923",
      "needsInterop": true
    },
    "react/jsx-runtime": {
      "src": "../../node_modules/react/jsx-runtime.js",
      "file": "react_jsx-runtime.js",
      "fileHash": "91cf719e",
      "needsInterop": true
    },
    "react-dom/client": {
      "src": "../../node_modules/react-dom/client.js",
      "file": "react-dom_client.js",
      "fileHash": "0dab094a",
      "needsInterop": true
    }
  },
  "chunks": {
    "chunk-MKFI7NYJ": {
      "file": "chunk-MKFI7NYJ.js"
    },
    "chunk-GIQZIPNC": {
      "file": "chunk-GIQZIPNC.js"
    }
  }
}
// FILE: package-lock.json
{
    "name": "via51-alfa",
    "version": "1.0.0",
    "lockfileVersion": 3,
    "requires": true,
    "packages": {
        "": {
            "name": "via51-alfa",
            "version": "1.0.0",
            "dependencies": {
                "@supabase/supabase-js": "^2.43.2",
                "framer-motion": "^12.38.0",
                "lucide-react": "^1.11.0",
                "react": "^18.3.1",
                "react-dom": "^18.3.1",
                "react-router-dom": "^7.15.0"
            },
            "devDependencies": {
                "@types/react": "^18.3.28",
                "@types/react-dom": "^18.3.7",
                "@vitejs/plugin-react": "^4.7.0",
                "autoprefixer": "^10.5.0",
                "postcss": "^8.5.10",
                "tailwindcss": "^3.4.19",
                "typescript": "^5.9.3",
                "vite": "^5.4.21"
            }
        },
        "node_modules/@alloc/quick-lru": {
            "version": "5.2.0",
            "resolved": "https://registry.npmjs.org/@alloc/quick-lru/-/quick-lru-5.2.0.tgz",
            "integrity": "sha512-UrcABB+4bUrFABwbluTIBErXwvbsU/V7TZWfmbgJfbkwiBuziS9gxdODUyuiecfdGQ85jglMW6juS3+z5TsKLw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=10"
            },
            "funding": {
                "url": "https://github.com/sponsors/sindresorhus"
            }
        },
        "node_modules/@babel/code-frame": {
            "version": "7.29.0",
            "resolved": "https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.29.0.tgz",
            "integrity": "sha512-9NhCeYjq9+3uxgdtp20LSiJXJvN0FeCtNGpJxuMFZ1Kv3cWUNb6DOhJwUvcVCzKGR66cw4njwM6hrJLqgOwbcw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/helper-validator-identifier": "^7.28.5",
                "js-tokens": "^4.0.0",
                "picocolors": "^1.1.1"
            },
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/compat-data": {
            "version": "7.29.0",
            "resolved": "https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.29.0.tgz",
            "integrity": "sha512-T1NCJqT/j9+cn8fvkt7jtwbLBfLC/1y1c7NtCeXFRgzGTsafi68MRv8yzkYSapBnFA6L3U2VSc02ciDzoAJhJg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/core": {
            "version": "7.29.0",
            "resolved": "https://registry.npmjs.org/@babel/core/-/core-7.29.0.tgz",
            "integrity": "sha512-CGOfOJqWjg2qW/Mb6zNsDm+u5vFQ8DxXfbM09z69p5Z6+mE1ikP2jUXw+j42Pf1XTYED2Rni5f95npYeuwMDQA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/code-frame": "^7.29.0",
                "@babel/generator": "^7.29.0",
                "@babel/helper-compilation-targets": "^7.28.6",
                "@babel/helper-module-transforms": "^7.28.6",
                "@babel/helpers": "^7.28.6",
                "@babel/parser": "^7.29.0",
                "@babel/template": "^7.28.6",
                "@babel/traverse": "^7.29.0",
                "@babel/types": "^7.29.0",
                "@jridgewell/remapping": "^2.3.5",
                "convert-source-map": "^2.0.0",
                "debug": "^4.1.0",
                "gensync": "^1.0.0-beta.2",
                "json5": "^2.2.3",
                "semver": "^6.3.1"
            },
            "engines": {
                "node": ">=6.9.0"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/babel"
            }
        },
        "node_modules/@babel/generator": {
            "version": "7.29.1",
            "resolved": "https://registry.npmjs.org/@babel/generator/-/generator-7.29.1.tgz",
            "integrity": "sha512-qsaF+9Qcm2Qv8SRIMMscAvG4O3lJ0F1GuMo5HR/Bp02LopNgnZBC/EkbevHFeGs4ls/oPz9v+Bsmzbkbe+0dUw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/parser": "^7.29.0",
                "@babel/types": "^7.29.0",
                "@jridgewell/gen-mapping": "^0.3.12",
                "@jridgewell/trace-mapping": "^0.3.28",
                "jsesc": "^3.0.2"
            },
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/helper-compilation-targets": {
            "version": "7.28.6",
            "resolved": "https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.28.6.tgz",
            "integrity": "sha512-JYtls3hqi15fcx5GaSNL7SCTJ2MNmjrkHXg4FSpOA/grxK8KwyZ5bubHsCq8FXCkua6xhuaaBit+3b7+VZRfcA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/compat-data": "^7.28.6",
                "@babel/helper-validator-option": "^7.27.1",
                "browserslist": "^4.24.0",
                "lru-cache": "^5.1.1",
                "semver": "^6.3.1"
            },
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/helper-globals": {
            "version": "7.28.0",
            "resolved": "https://registry.npmjs.org/@babel/helper-globals/-/helper-globals-7.28.0.tgz",
            "integrity": "sha512-+W6cISkXFa1jXsDEdYA8HeevQT/FULhxzR99pxphltZcVaugps53THCeiWA8SguxxpSp3gKPiuYfSWopkLQ4hw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/helper-module-imports": {
            "version": "7.28.6",
            "resolved": "https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.28.6.tgz",
            "integrity": "sha512-l5XkZK7r7wa9LucGw9LwZyyCUscb4x37JWTPz7swwFE/0FMQAGpiWUZn8u9DzkSBWEcK25jmvubfpw2dnAMdbw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/traverse": "^7.28.6",
                "@babel/types": "^7.28.6"
            },
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/helper-module-transforms": {
            "version": "7.28.6",
            "resolved": "https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.28.6.tgz",
            "integrity": "sha512-67oXFAYr2cDLDVGLXTEABjdBJZ6drElUSI7WKp70NrpyISso3plG9SAGEF6y7zbha/wOzUByWWTJvEDVNIUGcA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/helper-module-imports": "^7.28.6",
                "@babel/helper-validator-identifier": "^7.28.5",
                "@babel/traverse": "^7.28.6"
            },
            "engines": {
                "node": ">=6.9.0"
            },
            "peerDependencies": {
                "@babel/core": "^7.0.0"
            }
        },
        "node_modules/@babel/helper-plugin-utils": {
            "version": "7.28.6",
            "resolved": "https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.28.6.tgz",
            "integrity": "sha512-S9gzZ/bz83GRysI7gAD4wPT/AI3uCnY+9xn+Mx/KPs2JwHJIz1W8PZkg2cqyt3RNOBM8ejcXhV6y8Og7ly/Dug==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/helper-string-parser": {
            "version": "7.27.1",
            "resolved": "https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.27.1.tgz",
            "integrity": "sha512-qMlSxKbpRlAridDExk92nSobyDdpPijUq2DW6oDnUqd0iOGxmQjyqhMIihI9+zv4LPyZdRje2cavWPbCbWm3eA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/helper-validator-identifier": {
            "version": "7.28.5",
            "resolved": "https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.28.5.tgz",
            "integrity": "sha512-qSs4ifwzKJSV39ucNjsvc6WVHs6b7S03sOh2OcHF9UHfVPqWWALUsNUVzhSBiItjRZoLHx7nIarVjqKVusUZ1Q==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/helper-validator-option": {
            "version": "7.27.1",
            "resolved": "https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.27.1.tgz",
            "integrity": "sha512-YvjJow9FxbhFFKDSuFnVCe2WxXk1zWc22fFePVNEaWJEu8IrZVlda6N0uHwzZrUM1il7NC9Mlp4MaJYbYd9JSg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/helpers": {
            "version": "7.29.2",
            "resolved": "https://registry.npmjs.org/@babel/helpers/-/helpers-7.29.2.tgz",
            "integrity": "sha512-HoGuUs4sCZNezVEKdVcwqmZN8GoHirLUcLaYVNBK2J0DadGtdcqgr3BCbvH8+XUo4NGjNl3VOtSjEKNzqfFgKw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/template": "^7.28.6",
                "@babel/types": "^7.29.0"
            },
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/parser": {
            "version": "7.29.2",
            "resolved": "https://registry.npmjs.org/@babel/parser/-/parser-7.29.2.tgz",
            "integrity": "sha512-4GgRzy/+fsBa72/RZVJmGKPmZu9Byn8o4MoLpmNe1m8ZfYnz5emHLQz3U4gLud6Zwl0RZIcgiLD7Uq7ySFuDLA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/types": "^7.29.0"
            },
            "bin": {
                "parser": "bin/babel-parser.js"
            },
            "engines": {
                "node": ">=6.0.0"
            }
        },
        "node_modules/@babel/plugin-transform-react-jsx-self": {
            "version": "7.27.1",
            "resolved": "https://registry.npmjs.org/@babel/plugin-transform-react-jsx-self/-/plugin-transform-react-jsx-self-7.27.1.tgz",
            "integrity": "sha512-6UzkCs+ejGdZ5mFFC/OCUrv028ab2fp1znZmCZjAOBKiBK2jXD1O+BPSfX8X2qjJ75fZBMSnQn3Rq2mrBJK2mw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/helper-plugin-utils": "^7.27.1"
            },
            "engines": {
                "node": ">=6.9.0"
            },
            "peerDependencies": {
                "@babel/core": "^7.0.0-0"
            }
        },
        "node_modules/@babel/plugin-transform-react-jsx-source": {
            "version": "7.27.1",
            "resolved": "https://registry.npmjs.org/@babel/plugin-transform-react-jsx-source/-/plugin-transform-react-jsx-source-7.27.1.tgz",
            "integrity": "sha512-zbwoTsBruTeKB9hSq73ha66iFeJHuaFkUbwvqElnygoNbj/jHRsSeokowZFN3CZ64IvEqcmmkVe89OPXc7ldAw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/helper-plugin-utils": "^7.27.1"
            },
            "engines": {
                "node": ">=6.9.0"
            },
            "peerDependencies": {
                "@babel/core": "^7.0.0-0"
            }
        },
        "node_modules/@babel/template": {
            "version": "7.28.6",
            "resolved": "https://registry.npmjs.org/@babel/template/-/template-7.28.6.tgz",
            "integrity": "sha512-YA6Ma2KsCdGb+WC6UpBVFJGXL58MDA6oyONbjyF/+5sBgxY/dwkhLogbMT2GXXyU84/IhRw/2D1Os1B/giz+BQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/code-frame": "^7.28.6",
                "@babel/parser": "^7.28.6",
                "@babel/types": "^7.28.6"
            },
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/traverse": {
            "version": "7.29.0",
            "resolved": "https://registry.npmjs.org/@babel/traverse/-/traverse-7.29.0.tgz",
            "integrity": "sha512-4HPiQr0X7+waHfyXPZpWPfWL/J7dcN1mx9gL6WdQVMbPnF3+ZhSMs8tCxN7oHddJE9fhNE7+lxdnlyemKfJRuA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/code-frame": "^7.29.0",
                "@babel/generator": "^7.29.0",
                "@babel/helper-globals": "^7.28.0",
                "@babel/parser": "^7.29.0",
                "@babel/template": "^7.28.6",
                "@babel/types": "^7.29.0",
                "debug": "^4.3.1"
            },
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@babel/types": {
            "version": "7.29.0",
            "resolved": "https://registry.npmjs.org/@babel/types/-/types-7.29.0.tgz",
            "integrity": "sha512-LwdZHpScM4Qz8Xw2iKSzS+cfglZzJGvofQICy7W7v4caru4EaAmyUuO6BGrbyQ2mYV11W0U8j5mBhd14dd3B0A==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/helper-string-parser": "^7.27.1",
                "@babel/helper-validator-identifier": "^7.28.5"
            },
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/@esbuild/aix-ppc64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/aix-ppc64/-/aix-ppc64-0.21.5.tgz",
            "integrity": "sha512-1SDgH6ZSPTlggy1yI6+Dbkiz8xzpHJEVAlF/AM1tHPLsf5STom9rwtjE4hKAF20FfXXNTFqEYXyJNWh1GiZedQ==",
            "cpu": [
                "ppc64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "aix"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/android-arm": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.21.5.tgz",
            "integrity": "sha512-vCPvzSjpPHEi1siZdlvAlsPxXl7WbOVUBBAowWug4rJHb68Ox8KualB+1ocNvT5fjv6wpkX6o/iEpbDrf68zcg==",
            "cpu": [
                "arm"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "android"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/android-arm64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.21.5.tgz",
            "integrity": "sha512-c0uX9VAUBQ7dTDCjq+wdyGLowMdtR/GoC2U5IYk/7D1H1JYC0qseD7+11iMP2mRLN9RcCMRcjC4YMclCzGwS/A==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "android"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/android-x64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.21.5.tgz",
            "integrity": "sha512-D7aPRUUNHRBwHxzxRvp856rjUHRFW1SdQATKXH2hqA0kAZb1hKmi02OpYRacl0TxIGz/ZmXWlbZgjwWYaCakTA==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "android"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/darwin-arm64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.21.5.tgz",
            "integrity": "sha512-DwqXqZyuk5AiWWf3UfLiRDJ5EDd49zg6O9wclZ7kUMv2WRFr4HKjXp/5t8JZ11QbQfUS6/cRCKGwYhtNAY88kQ==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "darwin"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/darwin-x64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.21.5.tgz",
            "integrity": "sha512-se/JjF8NlmKVG4kNIuyWMV/22ZaerB+qaSi5MdrXtd6R08kvs2qCN4C09miupktDitvh8jRFflwGFBQcxZRjbw==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "darwin"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/freebsd-arm64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.21.5.tgz",
            "integrity": "sha512-5JcRxxRDUJLX8JXp/wcBCy3pENnCgBR9bN6JsY4OmhfUtIHe3ZW0mawA7+RDAcMLrMIZaf03NlQiX9DGyB8h4g==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "freebsd"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/freebsd-x64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.21.5.tgz",
            "integrity": "sha512-J95kNBj1zkbMXtHVH29bBriQygMXqoVQOQYA+ISs0/2l3T9/kj42ow2mpqerRBxDJnmkUDCaQT/dfNXWX/ZZCQ==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "freebsd"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-arm": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.21.5.tgz",
            "integrity": "sha512-bPb5AHZtbeNGjCKVZ9UGqGwo8EUu4cLq68E95A53KlxAPRmUyYv2D6F0uUI65XisGOL1hBP5mTronbgo+0bFcA==",
            "cpu": [
                "arm"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-arm64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.21.5.tgz",
            "integrity": "sha512-ibKvmyYzKsBeX8d8I7MH/TMfWDXBF3db4qM6sy+7re0YXya+K1cem3on9XgdT2EQGMu4hQyZhan7TeQ8XkGp4Q==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-ia32": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.21.5.tgz",
            "integrity": "sha512-YvjXDqLRqPDl2dvRODYmmhz4rPeVKYvppfGYKSNGdyZkA01046pLWyRKKI3ax8fbJoK5QbxblURkwK/MWY18Tg==",
            "cpu": [
                "ia32"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-loong64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.21.5.tgz",
            "integrity": "sha512-uHf1BmMG8qEvzdrzAqg2SIG/02+4/DHB6a9Kbya0XDvwDEKCoC8ZRWI5JJvNdUjtciBGFQ5PuBlpEOXQj+JQSg==",
            "cpu": [
                "loong64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-mips64el": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.21.5.tgz",
            "integrity": "sha512-IajOmO+KJK23bj52dFSNCMsz1QP1DqM6cwLUv3W1QwyxkyIWecfafnI555fvSGqEKwjMXVLokcV5ygHW5b3Jbg==",
            "cpu": [
                "mips64el"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-ppc64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.21.5.tgz",
            "integrity": "sha512-1hHV/Z4OEfMwpLO8rp7CvlhBDnjsC3CttJXIhBi+5Aj5r+MBvy4egg7wCbe//hSsT+RvDAG7s81tAvpL2XAE4w==",
            "cpu": [
                "ppc64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-riscv64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.21.5.tgz",
            "integrity": "sha512-2HdXDMd9GMgTGrPWnJzP2ALSokE/0O5HhTUvWIbD3YdjME8JwvSCnNGBnTThKGEB91OZhzrJ4qIIxk/SBmyDDA==",
            "cpu": [
                "riscv64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-s390x": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.21.5.tgz",
            "integrity": "sha512-zus5sxzqBJD3eXxwvjN1yQkRepANgxE9lgOW2qLnmr8ikMTphkjgXu1HR01K4FJg8h1kEEDAqDcZQtbrRnB41A==",
            "cpu": [
                "s390x"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/linux-x64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.21.5.tgz",
            "integrity": "sha512-1rYdTpyv03iycF1+BhzrzQJCdOuAOtaqHTWJZCWvijKD2N5Xu0TtVC8/+1faWqcP9iBCWOmjmhoH94dH82BxPQ==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/netbsd-x64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.21.5.tgz",
            "integrity": "sha512-Woi2MXzXjMULccIwMnLciyZH4nCIMpWQAs049KEeMvOcNADVxo0UBIQPfSmxB3CWKedngg7sWZdLvLczpe0tLg==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "netbsd"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/openbsd-x64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.21.5.tgz",
            "integrity": "sha512-HLNNw99xsvx12lFBUwoT8EVCsSvRNDVxNpjZ7bPn947b8gJPzeHWyNVhFsaerc0n3TsbOINvRP2byTZ5LKezow==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "openbsd"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/sunos-x64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.21.5.tgz",
            "integrity": "sha512-6+gjmFpfy0BHU5Tpptkuh8+uw3mnrvgs+dSPQXQOv3ekbordwnzTVEb4qnIvQcYXq6gzkyTnoZ9dZG+D4garKg==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "sunos"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/win32-arm64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.21.5.tgz",
            "integrity": "sha512-Z0gOTd75VvXqyq7nsl93zwahcTROgqvuAcYDUr+vOv8uHhNSKROyU961kgtCD1e95IqPKSQKH7tBTslnS3tA8A==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/win32-ia32": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.21.5.tgz",
            "integrity": "sha512-SWXFF1CL2RVNMaVs+BBClwtfZSvDgtL//G/smwAc5oVK/UPu2Gu9tIaRgFmYFFKrmg3SyAjSrElf0TiJ1v8fYA==",
            "cpu": [
                "ia32"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@esbuild/win32-x64": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.21.5.tgz",
            "integrity": "sha512-tQd/1efJuzPC6rCFwEvLtci/xNFcTZknmXs98FYDfGE4wP9ClFV98nyKrzJKVPMhdDnjzLhdUyMX4PsQAPjwIw==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ],
            "engines": {
                "node": ">=12"
            }
        },
        "node_modules/@jridgewell/gen-mapping": {
            "version": "0.3.13",
            "resolved": "https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.13.tgz",
            "integrity": "sha512-2kkt/7niJ6MgEPxF0bYdQ6etZaA+fQvDcLKckhy1yIQOzaoKjBBjSj63/aLVjYE3qhRt5dvM+uUyfCg6UKCBbA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@jridgewell/sourcemap-codec": "^1.5.0",
                "@jridgewell/trace-mapping": "^0.3.24"
            }
        },
        "node_modules/@jridgewell/remapping": {
            "version": "2.3.5",
            "resolved": "https://registry.npmjs.org/@jridgewell/remapping/-/remapping-2.3.5.tgz",
            "integrity": "sha512-LI9u/+laYG4Ds1TDKSJW2YPrIlcVYOwi2fUC6xB43lueCjgxV4lffOCZCtYFiH6TNOX+tQKXx97T4IKHbhyHEQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@jridgewell/gen-mapping": "^0.3.5",
                "@jridgewell/trace-mapping": "^0.3.24"
            }
        },
        "node_modules/@jridgewell/resolve-uri": {
            "version": "3.1.2",
            "resolved": "https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz",
            "integrity": "sha512-bRISgCIjP20/tbWSPWMEi54QVPRZExkuD9lJL+UIxUKtwVJA8wW1Trb1jMs1RFXo1CBTNZ/5hpC9QvmKWdopKw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.0.0"
            }
        },
        "node_modules/@jridgewell/sourcemap-codec": {
            "version": "1.5.5",
            "resolved": "https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.5.tgz",
            "integrity": "sha512-cYQ9310grqxueWbl+WuIUIaiUaDcj7WOq5fVhEljNVgRfOUhY9fy2zTvfoqWsnebh8Sl70VScFbICvJnLKB0Og==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@jridgewell/trace-mapping": {
            "version": "0.3.31",
            "resolved": "https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.31.tgz",
            "integrity": "sha512-zzNR+SdQSDJzc8joaeP8QQoCQr8NuYx2dIIytl1QeBEZHJ9uW6hebsrYgbz8hJwUQao3TWCMtmfV8Nu1twOLAw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@jridgewell/resolve-uri": "^3.1.0",
                "@jridgewell/sourcemap-codec": "^1.4.14"
            }
        },
        "node_modules/@nodelib/fs.scandir": {
            "version": "2.1.5",
            "resolved": "https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz",
            "integrity": "sha512-vq24Bq3ym5HEQm2NKCr3yXDwjc7vTsEThRDnkp2DK9p1uqLR+DHurm/NOTo0KG7HYHU7eppKZj3MyqYuMBf62g==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@nodelib/fs.stat": "2.0.5",
                "run-parallel": "^1.1.9"
            },
            "engines": {
                "node": ">= 8"
            }
        },
        "node_modules/@nodelib/fs.stat": {
            "version": "2.0.5",
            "resolved": "https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz",
            "integrity": "sha512-RkhPPp2zrqDAQA/2jNhnztcPAlv64XdhIp7a7454A5ovI7Bukxgt7MX7udwAu3zg1DcpPU0rz3VV1SeaqvY4+A==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 8"
            }
        },
        "node_modules/@nodelib/fs.walk": {
            "version": "1.2.8",
            "resolved": "https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz",
            "integrity": "sha512-oGB+UxlgWcgQkgwo8GcEGwemoTFt3FIO9ababBmaGwXIoBKZ+GTy0pP185beGg7Llih/NSHSV2XAs1lnznocSg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@nodelib/fs.scandir": "2.1.5",
                "fastq": "^1.6.0"
            },
            "engines": {
                "node": ">= 8"
            }
        },
        "node_modules/@rolldown/pluginutils": {
            "version": "1.0.0-beta.27",
            "resolved": "https://registry.npmjs.org/@rolldown/pluginutils/-/pluginutils-1.0.0-beta.27.tgz",
            "integrity": "sha512-+d0F4MKMCbeVUJwG96uQ4SgAznZNSq93I3V+9NHA4OpvqG8mRCpGdKmK8l/dl02h2CCDHwW2FqilnTyDcAnqjA==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@rollup/rollup-android-arm-eabi": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-android-arm-eabi/-/rollup-android-arm-eabi-4.60.2.tgz",
            "integrity": "sha512-dnlp69efPPg6Uaw2dVqzWRfAWRnYVb1XJ8CyyhIbZeaq4CA5/mLeZ1IEt9QqQxmbdvagjLIm2ZL8BxXv5lH4Yw==",
            "cpu": [
                "arm"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "android"
            ]
        },
        "node_modules/@rollup/rollup-android-arm64": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-android-arm64/-/rollup-android-arm64-4.60.2.tgz",
            "integrity": "sha512-OqZTwDRDchGRHHm/hwLOL7uVPB9aUvI0am/eQuWMNyFHf5PSEQmyEeYYheA0EPPKUO/l0uigCp+iaTjoLjVoHg==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "android"
            ]
        },
        "node_modules/@rollup/rollup-darwin-arm64": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.60.2.tgz",
            "integrity": "sha512-UwRE7CGpvSVEQS8gUMBe1uADWjNnVgP3Iusyda1nSRwNDCsRjnGc7w6El6WLQsXmZTbLZx9cecegumcitNfpmA==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "darwin"
            ]
        },
        "node_modules/@rollup/rollup-darwin-x64": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-darwin-x64/-/rollup-darwin-x64-4.60.2.tgz",
            "integrity": "sha512-gjEtURKLCC5VXm1I+2i1u9OhxFsKAQJKTVB8WvDAHF+oZlq0GTVFOlTlO1q3AlCTE/DF32c16ESvfgqR7343/g==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "darwin"
            ]
        },
        "node_modules/@rollup/rollup-freebsd-arm64": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-freebsd-arm64/-/rollup-freebsd-arm64-4.60.2.tgz",
            "integrity": "sha512-Bcl6CYDeAgE70cqZaMojOi/eK63h5Me97ZqAQoh77VPjMysA/4ORQBRGo3rRy45x4MzVlU9uZxs8Uwy7ZaKnBw==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "freebsd"
            ]
        },
        "node_modules/@rollup/rollup-freebsd-x64": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-freebsd-x64/-/rollup-freebsd-x64-4.60.2.tgz",
            "integrity": "sha512-LU+TPda3mAE2QB0/Hp5VyeKJivpC6+tlOXd1VMoXV/YFMvk/MNk5iXeBfB4MQGRWyOYVJ01625vjkr0Az98OJQ==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "freebsd"
            ]
        },
        "node_modules/@rollup/rollup-linux-arm-gnueabihf": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-arm-gnueabihf/-/rollup-linux-arm-gnueabihf-4.60.2.tgz",
            "integrity": "sha512-2QxQrM+KQ7DAW4o22j+XZ6RKdxjLD7BOWTP0Bv0tmjdyhXSsr2Ul1oJDQqh9Zf5qOwTuTc7Ek83mOFaKnodPjg==",
            "cpu": [
                "arm"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-arm-musleabihf": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-arm-musleabihf/-/rollup-linux-arm-musleabihf-4.60.2.tgz",
            "integrity": "sha512-TbziEu2DVsTEOPif2mKWkMeDMLoYjx95oESa9fkQQK7r/Orta0gnkcDpzwufEcAO2BLBsD7mZkXGFqEdMRRwfw==",
            "cpu": [
                "arm"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-arm64-gnu": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-arm64-gnu/-/rollup-linux-arm64-gnu-4.60.2.tgz",
            "integrity": "sha512-bO/rVDiDUuM2YfuCUwZ1t1cP+/yqjqz+Xf2VtkdppefuOFS2OSeAfgafaHNkFn0t02hEyXngZkxtGqXcXwO8Rg==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-arm64-musl": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-arm64-musl/-/rollup-linux-arm64-musl-4.60.2.tgz",
            "integrity": "sha512-hr26p7e93Rl0Za+JwW7EAnwAvKkehh12BU1Llm9Ykiibg4uIr2rbpxG9WCf56GuvidlTG9KiiQT/TXT1yAWxTA==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-loong64-gnu": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-loong64-gnu/-/rollup-linux-loong64-gnu-4.60.2.tgz",
            "integrity": "sha512-pOjB/uSIyDt+ow3k/RcLvUAOGpysT2phDn7TTUB3n75SlIgZzM6NKAqlErPhoFU+npgY3/n+2HYIQVbF70P9/A==",
            "cpu": [
                "loong64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-loong64-musl": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-loong64-musl/-/rollup-linux-loong64-musl-4.60.2.tgz",
            "integrity": "sha512-2/w+q8jszv9Ww1c+6uJT3OwqhdmGP2/4T17cu8WuwyUuuaCDDJ2ojdyYwZzCxx0GcsZBhzi3HmH+J5pZNXnd+Q==",
            "cpu": [
                "loong64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-ppc64-gnu": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-ppc64-gnu/-/rollup-linux-ppc64-gnu-4.60.2.tgz",
            "integrity": "sha512-11+aL5vKheYgczxtPVVRhdptAM2H7fcDR5Gw4/bTcteuZBlH4oP9f5s9zYO9aGZvoGeBpqXI/9TZZihZ609wKw==",
            "cpu": [
                "ppc64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-ppc64-musl": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-ppc64-musl/-/rollup-linux-ppc64-musl-4.60.2.tgz",
            "integrity": "sha512-i16fokAGK46IVZuV8LIIwMdtqhin9hfYkCh8pf8iC3QU3LpwL+1FSFGej+O7l3E/AoknL6Dclh2oTdnRMpTzFQ==",
            "cpu": [
                "ppc64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-riscv64-gnu": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-riscv64-gnu/-/rollup-linux-riscv64-gnu-4.60.2.tgz",
            "integrity": "sha512-49FkKS6RGQoriDSK/6E2GkAsAuU5kETFCh7pG4yD/ylj9rKhTmO3elsnmBvRD4PgJPds5W2PkhC82aVwmUcJ7A==",
            "cpu": [
                "riscv64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-riscv64-musl": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-riscv64-musl/-/rollup-linux-riscv64-musl-4.60.2.tgz",
            "integrity": "sha512-mjYNkHPfGpUR00DuM1ZZIgs64Hpf4bWcz9Z41+4Q+pgDx73UwWdAYyf6EG/lRFldmdHHzgrYyge5akFUW0D3mQ==",
            "cpu": [
                "riscv64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-s390x-gnu": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-s390x-gnu/-/rollup-linux-s390x-gnu-4.60.2.tgz",
            "integrity": "sha512-ALyvJz965BQk8E9Al/JDKKDLH2kfKFLTGMlgkAbbYtZuJt9LU8DW3ZoDMCtQpXAltZxwBHevXz5u+gf0yA0YoA==",
            "cpu": [
                "s390x"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-x64-gnu": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.60.2.tgz",
            "integrity": "sha512-UQjrkIdWrKI626Du8lCQ6MJp/6V1LAo2bOK9OTu4mSn8GGXIkPXk/Vsp4bLHCd9Z9Iz2OTEaokUE90VweJgIYQ==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-linux-x64-musl": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-linux-x64-musl/-/rollup-linux-x64-musl-4.60.2.tgz",
            "integrity": "sha512-bTsRGj6VlSdn/XD4CGyzMnzaBs9bsRxy79eTqTCBsA8TMIEky7qg48aPkvJvFe1HyzQ5oMZdg7AnVlWQSKLTnw==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "linux"
            ]
        },
        "node_modules/@rollup/rollup-openbsd-x64": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-openbsd-x64/-/rollup-openbsd-x64-4.60.2.tgz",
            "integrity": "sha512-6d4Z3534xitaA1FcMWP7mQPq5zGwBmGbhphh2DwaA1aNIXUu3KTOfwrWpbwI4/Gr0uANo7NTtaykFyO2hPuFLg==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "openbsd"
            ]
        },
        "node_modules/@rollup/rollup-openharmony-arm64": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-openharmony-arm64/-/rollup-openharmony-arm64-4.60.2.tgz",
            "integrity": "sha512-NetAg5iO2uN7eB8zE5qrZ3CSil+7IJt4WDFLcC75Ymywq1VZVD6qJ6EvNLjZ3rEm6gB7XW5JdT60c6MN35Z85Q==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "openharmony"
            ]
        },
        "node_modules/@rollup/rollup-win32-arm64-msvc": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-win32-arm64-msvc/-/rollup-win32-arm64-msvc-4.60.2.tgz",
            "integrity": "sha512-NCYhOotpgWZ5kdxCZsv6Iudx0wX8980Q/oW4pNFNihpBKsDbEA1zpkfxJGC0yugsUuyDZ7gL37dbzwhR0VI7pQ==",
            "cpu": [
                "arm64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ]
        },
        "node_modules/@rollup/rollup-win32-ia32-msvc": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-win32-ia32-msvc/-/rollup-win32-ia32-msvc-4.60.2.tgz",
            "integrity": "sha512-RXsaOqXxfoUBQoOgvmmijVxJnW2IGB0eoMO7F8FAjaj0UTywUO/luSqimWBJn04WNgUkeNhh7fs7pESXajWmkg==",
            "cpu": [
                "ia32"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ]
        },
        "node_modules/@rollup/rollup-win32-x64-gnu": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-win32-x64-gnu/-/rollup-win32-x64-gnu-4.60.2.tgz",
            "integrity": "sha512-qdAzEULD+/hzObedtmV6iBpdL5TIbKVztGiK7O3/KYSf+HIzU257+MX1EXJcyIiDbMAqmbwaufcYPvyRryeZtA==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ]
        },
        "node_modules/@rollup/rollup-win32-x64-msvc": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/@rollup/rollup-win32-x64-msvc/-/rollup-win32-x64-msvc-4.60.2.tgz",
            "integrity": "sha512-Nd/SgG27WoA9e+/TdK74KnHz852TLa94ovOYySo/yMPuTmpckK/jIF2jSwS3g7ELSKXK13/cVdmg1Z/DaCWKxA==",
            "cpu": [
                "x64"
            ],
            "dev": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "win32"
            ]
        },
        "node_modules/@supabase/auth-js": {
            "version": "2.104.1",
            "resolved": "https://registry.npmjs.org/@supabase/auth-js/-/auth-js-2.104.1.tgz",
            "integrity": "sha512-pqFnDKekq1isqlqnzqzyJ3mzmho+o+FjfVTqhKY3PFlwj2anx3OPznO1kbo1ZEwD8zg1r4EAFf/7pplLyX0ocQ==",
            "license": "MIT",
            "dependencies": {
                "tslib": "2.8.1"
            },
            "engines": {
                "node": ">=20.0.0"
            }
        },
        "node_modules/@supabase/functions-js": {
            "version": "2.104.1",
            "resolved": "https://registry.npmjs.org/@supabase/functions-js/-/functions-js-2.104.1.tgz",
            "integrity": "sha512-JjAH4JN9rZzxh4plQnILPrQZXAG6ccoRS6z9hQAGmXpRSwJA+7CWbsDV2R82I8MROlGDsjqj1Ot/cWpTfdf6xg==",
            "license": "MIT",
            "dependencies": {
                "tslib": "2.8.1"
            },
            "engines": {
                "node": ">=20.0.0"
            }
        },
        "node_modules/@supabase/phoenix": {
            "version": "0.4.0",
            "resolved": "https://registry.npmjs.org/@supabase/phoenix/-/phoenix-0.4.0.tgz",
            "integrity": "sha512-RHSx8bHS02xwfHdAbX5Lpbo6PXbgyf7lTaXTlwtFDPwOIw64NnVRwFAXGojHhjtVYI+PEPNSWwkL90f4agN3bw==",
            "license": "MIT"
        },
        "node_modules/@supabase/postgrest-js": {
            "version": "2.104.1",
            "resolved": "https://registry.npmjs.org/@supabase/postgrest-js/-/postgrest-js-2.104.1.tgz",
            "integrity": "sha512-RqlLpvgXsjcc27fLyHNGm3zN0KDWXbkdTdaFtaEdX83RsTEqH7BAmshH7zoUMml5lL04naUeRjS3B81O6jZcJw==",
            "license": "MIT",
            "dependencies": {
                "tslib": "2.8.1"
            },
            "engines": {
                "node": ">=20.0.0"
            }
        },
        "node_modules/@supabase/realtime-js": {
            "version": "2.104.1",
            "resolved": "https://registry.npmjs.org/@supabase/realtime-js/-/realtime-js-2.104.1.tgz",
            "integrity": "sha512-dVJHhFB2ErBd0/2qE9G8CedCrGoAtBfL9Q4zbSMXO7b1Cpld916ljSiX21mURUqijPf1WoPQG4Bp/averUzk/g==",
            "license": "MIT",
            "dependencies": {
                "@supabase/phoenix": "^0.4.0",
                "@types/ws": "^8.18.1",
                "tslib": "2.8.1",
                "ws": "^8.18.2"
            },
            "engines": {
                "node": ">=20.0.0"
            }
        },
        "node_modules/@supabase/storage-js": {
            "version": "2.104.1",
            "resolved": "https://registry.npmjs.org/@supabase/storage-js/-/storage-js-2.104.1.tgz",
            "integrity": "sha512-2bQaLbkRshctkUVuqamwYZDEd+0cGSc9DY9sjh92DcA5hu1F/1AP8p6gxGr76sgdK9Ngi0rh+2Kdh+uC4hcnGA==",
            "license": "MIT",
            "dependencies": {
                "iceberg-js": "^0.8.1",
                "tslib": "2.8.1"
            },
            "engines": {
                "node": ">=20.0.0"
            }
        },
        "node_modules/@supabase/supabase-js": {
            "version": "2.104.1",
            "resolved": "https://registry.npmjs.org/@supabase/supabase-js/-/supabase-js-2.104.1.tgz",
            "integrity": "sha512-E0H/CtVmaGjiAy+ieZ5ZB/1EqxXcGdaFaAc23AE5zaYfz6NtCNDcmaEdoGPYMPFH5pE6drGG6e3ljPmkFoGVxQ==",
            "license": "MIT",
            "dependencies": {
                "@supabase/auth-js": "2.104.1",
                "@supabase/functions-js": "2.104.1",
                "@supabase/postgrest-js": "2.104.1",
                "@supabase/realtime-js": "2.104.1",
                "@supabase/storage-js": "2.104.1"
            },
            "engines": {
                "node": ">=20.0.0"
            }
        },
        "node_modules/@types/babel__core": {
            "version": "7.20.5",
            "resolved": "https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.5.tgz",
            "integrity": "sha512-qoQprZvz5wQFJwMDqeseRXWv3rqMvhgpbXFfVyWhbx9X47POIA6i/+dXefEmZKoAgOaTdaIgNSMqMIU61yRyzA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/parser": "^7.20.7",
                "@babel/types": "^7.20.7",
                "@types/babel__generator": "*",
                "@types/babel__template": "*",
                "@types/babel__traverse": "*"
            }
        },
        "node_modules/@types/babel__generator": {
            "version": "7.27.0",
            "resolved": "https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.27.0.tgz",
            "integrity": "sha512-ufFd2Xi92OAVPYsy+P4n7/U7e68fex0+Ee8gSG9KX7eo084CWiQ4sdxktvdl0bOPupXtVJPY19zk6EwWqUQ8lg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/types": "^7.0.0"
            }
        },
        "node_modules/@types/babel__template": {
            "version": "7.4.4",
            "resolved": "https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.4.tgz",
            "integrity": "sha512-h/NUaSyG5EyxBIp8YRxo4RMe2/qQgvyowRwVMzhYhBCONbW8PUsg4lkFMrhgZhUe5z3L3MiLDuvyJ/CaPa2A8A==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/parser": "^7.1.0",
                "@babel/types": "^7.0.0"
            }
        },
        "node_modules/@types/babel__traverse": {
            "version": "7.28.0",
            "resolved": "https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.28.0.tgz",
            "integrity": "sha512-8PvcXf70gTDZBgt9ptxJ8elBeBjcLOAcOtoO/mPJjtji1+CdGbHgm77om1GrsPxsiE+uXIpNSK64UYaIwQXd4Q==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/types": "^7.28.2"
            }
        },
        "node_modules/@types/estree": {
            "version": "1.0.8",
            "resolved": "https://registry.npmjs.org/@types/estree/-/estree-1.0.8.tgz",
            "integrity": "sha512-dWHzHa2WqEXI/O1E9OjrocMTKJl2mSrEolh1Iomrv6U+JuNwaHXsXx9bLu5gG7BUWFIN0skIQJQ/L1rIex4X6w==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@types/node": {
            "version": "25.6.0",
            "resolved": "https://registry.npmjs.org/@types/node/-/node-25.6.0.tgz",
            "integrity": "sha512-+qIYRKdNYJwY3vRCZMdJbPLJAtGjQBudzZzdzwQYkEPQd+PJGixUL5QfvCLDaULoLv+RhT3LDkwEfKaAkgSmNQ==",
            "license": "MIT",
            "dependencies": {
                "undici-types": "~7.19.0"
            }
        },
        "node_modules/@types/prop-types": {
            "version": "15.7.15",
            "resolved": "https://registry.npmjs.org/@types/prop-types/-/prop-types-15.7.15.tgz",
            "integrity": "sha512-F6bEyamV9jKGAFBEmlQnesRPGOQqS2+Uwi0Em15xenOxHaf2hv6L8YCVn3rPdPJOiJfPiCnLIRyvwVaqMY3MIw==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/@types/react": {
            "version": "18.3.28",
            "resolved": "https://registry.npmjs.org/@types/react/-/react-18.3.28.tgz",
            "integrity": "sha512-z9VXpC7MWrhfWipitjNdgCauoMLRdIILQsAEV+ZesIzBq/oUlxk0m3ApZuMFCXdnS4U7KrI+l3WRUEGQ8K1QKw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@types/prop-types": "*",
                "csstype": "^3.2.2"
            }
        },
        "node_modules/@types/react-dom": {
            "version": "18.3.7",
            "resolved": "https://registry.npmjs.org/@types/react-dom/-/react-dom-18.3.7.tgz",
            "integrity": "sha512-MEe3UeoENYVFXzoXEWsvcpg6ZvlrFNlOQ7EOsvhI3CfAXwzPfO8Qwuxd40nepsYKqyyVQnTdEfv68q91yLcKrQ==",
            "dev": true,
            "license": "MIT",
            "peerDependencies": {
                "@types/react": "^18.0.0"
            }
        },
        "node_modules/@types/ws": {
            "version": "8.18.1",
            "resolved": "https://registry.npmjs.org/@types/ws/-/ws-8.18.1.tgz",
            "integrity": "sha512-ThVF6DCVhA8kUGy+aazFQ4kXQ7E1Ty7A3ypFOe0IcJV8O/M511G99AW24irKrW56Wt44yG9+ij8FaqoBGkuBXg==",
            "license": "MIT",
            "dependencies": {
                "@types/node": "*"
            }
        },
        "node_modules/@vitejs/plugin-react": {
            "version": "4.7.0",
            "resolved": "https://registry.npmjs.org/@vitejs/plugin-react/-/plugin-react-4.7.0.tgz",
            "integrity": "sha512-gUu9hwfWvvEDBBmgtAowQCojwZmJ5mcLn3aufeCsitijs3+f2NsrPtlAWIR6OPiqljl96GVCUbLe0HyqIpVaoA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@babel/core": "^7.28.0",
                "@babel/plugin-transform-react-jsx-self": "^7.27.1",
                "@babel/plugin-transform-react-jsx-source": "^7.27.1",
                "@rolldown/pluginutils": "1.0.0-beta.27",
                "@types/babel__core": "^7.20.5",
                "react-refresh": "^0.17.0"
            },
            "engines": {
                "node": "^14.18.0 || >=16.0.0"
            },
            "peerDependencies": {
                "vite": "^4.2.0 || ^5.0.0 || ^6.0.0 || ^7.0.0"
            }
        },
        "node_modules/any-promise": {
            "version": "1.3.0",
            "resolved": "https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz",
            "integrity": "sha512-7UvmKalWRt1wgjL1RrGxoSJW/0QZFIegpeGvZG9kjp8vrRu55XTHbwnqq2GpXm9uLbcuhxm3IqX9OB4MZR1b2A==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/anymatch": {
            "version": "3.1.3",
            "resolved": "https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz",
            "integrity": "sha512-KMReFUr0B4t+D+OBkjR3KYqvocp2XaSzO55UcB6mgQMd3KbcE+mWTyvVV7D/zsdEbNnV6acZUutkiHQXvTr1Rw==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "normalize-path": "^3.0.0",
                "picomatch": "^2.0.4"
            },
            "engines": {
                "node": ">= 8"
            }
        },
        "node_modules/arg": {
            "version": "5.0.2",
            "resolved": "https://registry.npmjs.org/arg/-/arg-5.0.2.tgz",
            "integrity": "sha512-PYjyFOLKQ9y57JvQ6QLo8dAgNqswh8M1RMJYdQduT6xbWSgK36P/Z/v+p888pM69jMMfS8Xd8F6I1kQ/I9HUGg==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/autoprefixer": {
            "version": "10.5.0",
            "resolved": "https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.5.0.tgz",
            "integrity": "sha512-FMhOoZV4+qR6aTUALKX2rEqGG+oyATvwBt9IIzVR5rMa2HRWPkxf+P+PAJLD1I/H5/II+HuZcBJYEFBpq39ong==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/postcss/"
                },
                {
                    "type": "tidelift",
                    "url": "https://tidelift.com/funding/github/npm/autoprefixer"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "browserslist": "^4.28.2",
                "caniuse-lite": "^1.0.30001787",
                "fraction.js": "^5.3.4",
                "picocolors": "^1.1.1",
                "postcss-value-parser": "^4.2.0"
            },
            "bin": {
                "autoprefixer": "bin/autoprefixer"
            },
            "engines": {
                "node": "^10 || ^12 || >=14"
            },
            "peerDependencies": {
                "postcss": "^8.1.0"
            }
        },
        "node_modules/baseline-browser-mapping": {
            "version": "2.10.22",
            "resolved": "https://registry.npmjs.org/baseline-browser-mapping/-/baseline-browser-mapping-2.10.22.tgz",
            "integrity": "sha512-6qruVrb5rse6WylFkU0FhBKKGuecWseqdpQfhkawn6ztyk2QlfwSRjsDxMCLJrkfmfN21qvhl9ABgaMeRkuwww==",
            "dev": true,
            "license": "Apache-2.0",
            "bin": {
                "baseline-browser-mapping": "dist/cli.cjs"
            },
            "engines": {
                "node": ">=6.0.0"
            }
        },
        "node_modules/binary-extensions": {
            "version": "2.3.0",
            "resolved": "https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz",
            "integrity": "sha512-Ceh+7ox5qe7LJuLHoY0feh3pHuUDHAcRUeyL2VYghZwfpkNIy/+8Ocg0a3UuSoYzavmylwuLWQOf3hl0jjMMIw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=8"
            },
            "funding": {
                "url": "https://github.com/sponsors/sindresorhus"
            }
        },
        "node_modules/braces": {
            "version": "3.0.3",
            "resolved": "https://registry.npmjs.org/braces/-/braces-3.0.3.tgz",
            "integrity": "sha512-yQbXgO/OSZVD2IsiLlro+7Hf6Q18EJrKSEsdoMzKePKXct3gvD8oLcOQdIzGupr5Fj+EDe8gO/lxc1BzfMpxvA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "fill-range": "^7.1.1"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/browserslist": {
            "version": "4.28.2",
            "resolved": "https://registry.npmjs.org/browserslist/-/browserslist-4.28.2.tgz",
            "integrity": "sha512-48xSriZYYg+8qXna9kwqjIVzuQxi+KYWp2+5nCYnYKPTr0LvD89Jqk2Or5ogxz0NUMfIjhh2lIUX/LyX9B4oIg==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/browserslist"
                },
                {
                    "type": "tidelift",
                    "url": "https://tidelift.com/funding/github/npm/browserslist"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "baseline-browser-mapping": "^2.10.12",
                "caniuse-lite": "^1.0.30001782",
                "electron-to-chromium": "^1.5.328",
                "node-releases": "^2.0.36",
                "update-browserslist-db": "^1.2.3"
            },
            "bin": {
                "browserslist": "cli.js"
            },
            "engines": {
                "node": "^6 || ^7 || ^8 || ^9 || ^10 || ^11 || ^12 || >=13.7"
            }
        },
        "node_modules/camelcase-css": {
            "version": "2.0.1",
            "resolved": "https://registry.npmjs.org/camelcase-css/-/camelcase-css-2.0.1.tgz",
            "integrity": "sha512-QOSvevhslijgYwRx6Rv7zKdMF8lbRmx+uQGx2+vDc+KI/eBnsy9kit5aj23AgGu3pa4t9AgwbnXWqS+iOY+2aA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 6"
            }
        },
        "node_modules/caniuse-lite": {
            "version": "1.0.30001790",
            "resolved": "https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001790.tgz",
            "integrity": "sha512-bOoxfJPyYo+ds6W0YfptaCWbFnJYjh2Y1Eow5lRv+vI2u8ganPZqNm1JwNh0t2ELQCqIWg4B3dWEusgAmsoyOw==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/browserslist"
                },
                {
                    "type": "tidelift",
                    "url": "https://tidelift.com/funding/github/npm/caniuse-lite"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "CC-BY-4.0"
        },
        "node_modules/chokidar": {
            "version": "3.6.0",
            "resolved": "https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz",
            "integrity": "sha512-7VT13fmjotKpGipCW9JEQAusEPE+Ei8nl6/g4FBAmIm0GOOLMua9NDDo/DWp0ZAxCr3cPq5ZpBqmPAQgDda2Pw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "anymatch": "~3.1.2",
                "braces": "~3.0.2",
                "glob-parent": "~5.1.2",
                "is-binary-path": "~2.1.0",
                "is-glob": "~4.0.1",
                "normalize-path": "~3.0.0",
                "readdirp": "~3.6.0"
            },
            "engines": {
                "node": ">= 8.10.0"
            },
            "funding": {
                "url": "https://paulmillr.com/funding/"
            },
            "optionalDependencies": {
                "fsevents": "~2.3.2"
            }
        },
        "node_modules/chokidar/node_modules/glob-parent": {
            "version": "5.1.2",
            "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
            "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "is-glob": "^4.0.1"
            },
            "engines": {
                "node": ">= 6"
            }
        },
        "node_modules/commander": {
            "version": "4.1.1",
            "resolved": "https://registry.npmjs.org/commander/-/commander-4.1.1.tgz",
            "integrity": "sha512-NOKm8xhkzAjzFx8B2v5OAHT+u5pRQc2UCa2Vq9jYL/31o2wi9mxBA7LIFs3sV5VSC49z6pEhfbMULvShKj26WA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 6"
            }
        },
        "node_modules/convert-source-map": {
            "version": "2.0.0",
            "resolved": "https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz",
            "integrity": "sha512-Kvp459HrV2FEJ1CAsi1Ku+MY3kasH19TFykTz2xWmMeq6bk2NU3XXvfJ+Q61m0xktWwt+1HSYf3JZsTms3aRJg==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/cookie": {
            "version": "1.1.1",
            "resolved": "https://registry.npmjs.org/cookie/-/cookie-1.1.1.tgz",
            "integrity": "sha512-ei8Aos7ja0weRpFzJnEA9UHJ/7XQmqglbRwnf2ATjcB9Wq874VKH9kfjjirM6UhU2/E5fFYadylyhFldcqSidQ==",
            "license": "MIT",
            "engines": {
                "node": ">=18"
            },
            "funding": {
                "type": "opencollective",
                "url": "https://opencollective.com/express"
            }
        },
        "node_modules/cssesc": {
            "version": "3.0.0",
            "resolved": "https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz",
            "integrity": "sha512-/Tb/JcjK111nNScGob5MNtsntNM1aCNUDipB/TkwZFhyDrrE47SOx/18wF2bbjgc3ZzCSKW1T5nt5EbFoAz/Vg==",
            "dev": true,
            "license": "MIT",
            "bin": {
                "cssesc": "bin/cssesc"
            },
            "engines": {
                "node": ">=4"
            }
        },
        "node_modules/csstype": {
            "version": "3.2.3",
            "resolved": "https://registry.npmjs.org/csstype/-/csstype-3.2.3.tgz",
            "integrity": "sha512-z1HGKcYy2xA8AGQfwrn0PAy+PB7X/GSj3UVJW9qKyn43xWa+gl5nXmU4qqLMRzWVLFC8KusUX8T/0kCiOYpAIQ==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/debug": {
            "version": "4.4.3",
            "resolved": "https://registry.npmjs.org/debug/-/debug-4.4.3.tgz",
            "integrity": "sha512-RGwwWnwQvkVfavKVt22FGLw+xYSdzARwm0ru6DhTVA3umU5hZc28V3kO4stgYryrTlLpuvgI9GiijltAjNbcqA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "ms": "^2.1.3"
            },
            "engines": {
                "node": ">=6.0"
            },
            "peerDependenciesMeta": {
                "supports-color": {
                    "optional": true
                }
            }
        },
        "node_modules/didyoumean": {
            "version": "1.2.2",
            "resolved": "https://registry.npmjs.org/didyoumean/-/didyoumean-1.2.2.tgz",
            "integrity": "sha512-gxtyfqMg7GKyhQmb056K7M3xszy/myH8w+B4RT+QXBQsvAOdc3XymqDDPHx1BgPgsdAA5SIifona89YtRATDzw==",
            "dev": true,
            "license": "Apache-2.0"
        },
        "node_modules/dlv": {
            "version": "1.1.3",
            "resolved": "https://registry.npmjs.org/dlv/-/dlv-1.1.3.tgz",
            "integrity": "sha512-+HlytyjlPKnIG8XuRG8WvmBP8xs8P71y+SKKS6ZXWoEgLuePxtDoUEiH7WkdePWrQ5JBpE6aoVqfZfJUQkjXwA==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/electron-to-chromium": {
            "version": "1.5.344",
            "resolved": "https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.344.tgz",
            "integrity": "sha512-4MxfbmNDm+KPh066EZy+eUnkcDPcZ35wNmOWzFuh/ijvHsve6kbLTLURy88uCNK5FbpN+yk2nQY6BYh1GEt+wg==",
            "dev": true,
            "license": "ISC"
        },
        "node_modules/es-errors": {
            "version": "1.3.0",
            "resolved": "https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz",
            "integrity": "sha512-Zf5H2Kxt2xjTvbJvP2ZWLEICxA6j+hAmMzIlypy4xcBg1vKVnx89Wy0GbS+kf5cwCVFFzdCFh2XSCFNULS6csw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 0.4"
            }
        },
        "node_modules/esbuild": {
            "version": "0.21.5",
            "resolved": "https://registry.npmjs.org/esbuild/-/esbuild-0.21.5.tgz",
            "integrity": "sha512-mg3OPMV4hXywwpoDxu3Qda5xCKQi+vCTZq8S9J/EpkhB2HzKXq4SNFZE3+NK93JYxc8VMSep+lOUSC/RVKaBqw==",
            "dev": true,
            "hasInstallScript": true,
            "license": "MIT",
            "bin": {
                "esbuild": "bin/esbuild"
            },
            "engines": {
                "node": ">=12"
            },
            "optionalDependencies": {
                "@esbuild/aix-ppc64": "0.21.5",
                "@esbuild/android-arm": "0.21.5",
                "@esbuild/android-arm64": "0.21.5",
                "@esbuild/android-x64": "0.21.5",
                "@esbuild/darwin-arm64": "0.21.5",
                "@esbuild/darwin-x64": "0.21.5",
                "@esbuild/freebsd-arm64": "0.21.5",
                "@esbuild/freebsd-x64": "0.21.5",
                "@esbuild/linux-arm": "0.21.5",
                "@esbuild/linux-arm64": "0.21.5",
                "@esbuild/linux-ia32": "0.21.5",
                "@esbuild/linux-loong64": "0.21.5",
                "@esbuild/linux-mips64el": "0.21.5",
                "@esbuild/linux-ppc64": "0.21.5",
                "@esbuild/linux-riscv64": "0.21.5",
                "@esbuild/linux-s390x": "0.21.5",
                "@esbuild/linux-x64": "0.21.5",
                "@esbuild/netbsd-x64": "0.21.5",
                "@esbuild/openbsd-x64": "0.21.5",
                "@esbuild/sunos-x64": "0.21.5",
                "@esbuild/win32-arm64": "0.21.5",
                "@esbuild/win32-ia32": "0.21.5",
                "@esbuild/win32-x64": "0.21.5"
            }
        },
        "node_modules/escalade": {
            "version": "3.2.0",
            "resolved": "https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz",
            "integrity": "sha512-WUj2qlxaQtO4g6Pq5c29GTcWGDyd8itL8zTlipgECz3JesAiiOKotd8JU6otB3PACgG6xkJUyVhboMS+bje/jA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6"
            }
        },
        "node_modules/fast-glob": {
            "version": "3.3.3",
            "resolved": "https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.3.tgz",
            "integrity": "sha512-7MptL8U0cqcFdzIzwOTHoilX9x5BrNqye7Z/LuC7kCMRio1EMSyqRK3BEAUD7sXRq4iT4AzTVuZdhgQ2TCvYLg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@nodelib/fs.stat": "^2.0.2",
                "@nodelib/fs.walk": "^1.2.3",
                "glob-parent": "^5.1.2",
                "merge2": "^1.3.0",
                "micromatch": "^4.0.8"
            },
            "engines": {
                "node": ">=8.6.0"
            }
        },
        "node_modules/fast-glob/node_modules/glob-parent": {
            "version": "5.1.2",
            "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
            "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "is-glob": "^4.0.1"
            },
            "engines": {
                "node": ">= 6"
            }
        },
        "node_modules/fastq": {
            "version": "1.20.1",
            "resolved": "https://registry.npmjs.org/fastq/-/fastq-1.20.1.tgz",
            "integrity": "sha512-GGToxJ/w1x32s/D2EKND7kTil4n8OVk/9mycTc4VDza13lOvpUZTGX3mFSCtV9ksdGBVzvsyAVLM6mHFThxXxw==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "reusify": "^1.0.4"
            }
        },
        "node_modules/fill-range": {
            "version": "7.1.1",
            "resolved": "https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz",
            "integrity": "sha512-YsGpe3WHLK8ZYi4tWDg2Jy3ebRz2rXowDxnld4bkQB00cc/1Zw9AWnC0i9ztDJitivtQvaI9KaLyKrc+hBW0yg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "to-regex-range": "^5.0.1"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/fraction.js": {
            "version": "5.3.4",
            "resolved": "https://registry.npmjs.org/fraction.js/-/fraction.js-5.3.4.tgz",
            "integrity": "sha512-1X1NTtiJphryn/uLQz3whtY6jK3fTqoE3ohKs0tT+Ujr1W59oopxmoEh7Lu5p6vBaPbgoM0bzveAW4Qi5RyWDQ==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": "*"
            },
            "funding": {
                "type": "github",
                "url": "https://github.com/sponsors/rawify"
            }
        },
        "node_modules/framer-motion": {
            "version": "12.38.0",
            "resolved": "https://registry.npmjs.org/framer-motion/-/framer-motion-12.38.0.tgz",
            "integrity": "sha512-rFYkY/pigbcswl1XQSb7q424kSTQ8q6eAC+YUsSKooHQYuLdzdHjrt6uxUC+PRAO++q5IS7+TamgIw1AphxR+g==",
            "license": "MIT",
            "dependencies": {
                "motion-dom": "^12.38.0",
                "motion-utils": "^12.36.0",
                "tslib": "^2.4.0"
            },
            "peerDependencies": {
                "@emotion/is-prop-valid": "*",
                "react": "^18.0.0 || ^19.0.0",
                "react-dom": "^18.0.0 || ^19.0.0"
            },
            "peerDependenciesMeta": {
                "@emotion/is-prop-valid": {
                    "optional": true
                },
                "react": {
                    "optional": true
                },
                "react-dom": {
                    "optional": true
                }
            }
        },
        "node_modules/fsevents": {
            "version": "2.3.3",
            "resolved": "https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz",
            "integrity": "sha512-5xoDfX+fL7faATnagmWPpbFtwh/R77WmMMqqHGS65C3vvB0YHrgF+B1YmZ3441tMj5n63k0212XNoJwzlhffQw==",
            "dev": true,
            "hasInstallScript": true,
            "license": "MIT",
            "optional": true,
            "os": [
                "darwin"
            ],
            "engines": {
                "node": "^8.16.0 || ^10.6.0 || >=11.0.0"
            }
        },
        "node_modules/function-bind": {
            "version": "1.1.2",
            "resolved": "https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz",
            "integrity": "sha512-7XHNxH7qX9xG5mIwxkhumTox/MIRNcOgDrxWsMt2pAr23WHp6MrRlN7FBSFpCpr+oVO0F744iUgR82nJMfG2SA==",
            "dev": true,
            "license": "MIT",
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/gensync": {
            "version": "1.0.0-beta.2",
            "resolved": "https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz",
            "integrity": "sha512-3hN7NaskYvMDLQY55gnW3NQ+mesEAepTqlg+VEbj7zzqEMBVNhzcGYYeqFo/TlYz6eQiFcp1HcsCZO+nGgS8zg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=6.9.0"
            }
        },
        "node_modules/glob-parent": {
            "version": "6.0.2",
            "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz",
            "integrity": "sha512-XxwI8EOhVQgWp6iDL+3b0r86f4d6AX6zSU55HfB4ydCEuXLXc5FcYeOu+nnGftS4TEju/11rt4KJPTMgbfmv4A==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "is-glob": "^4.0.3"
            },
            "engines": {
                "node": ">=10.13.0"
            }
        },
        "node_modules/hasown": {
            "version": "2.0.3",
            "resolved": "https://registry.npmjs.org/hasown/-/hasown-2.0.3.tgz",
            "integrity": "sha512-ej4AhfhfL2Q2zpMmLo7U1Uv9+PyhIZpgQLGT1F9miIGmiCJIoCgSmczFdrc97mWT4kVY72KA+WnnhJ5pghSvSg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "function-bind": "^1.1.2"
            },
            "engines": {
                "node": ">= 0.4"
            }
        },
        "node_modules/iceberg-js": {
            "version": "0.8.1",
            "resolved": "https://registry.npmjs.org/iceberg-js/-/iceberg-js-0.8.1.tgz",
            "integrity": "sha512-1dhVQZXhcHje7798IVM+xoo/1ZdVfzOMIc8/rgVSijRK38EDqOJoGula9N/8ZI5RD8QTxNQtK/Gozpr+qUqRRA==",
            "license": "MIT",
            "engines": {
                "node": ">=20.0.0"
            }
        },
        "node_modules/is-binary-path": {
            "version": "2.1.0",
            "resolved": "https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz",
            "integrity": "sha512-ZMERYes6pDydyuGidse7OsHxtbI7WVeUEozgR/g7rd0xUimYNlvZRE/K2MgZTjWy725IfelLeVcEM97mmtRGXw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "binary-extensions": "^2.0.0"
            },
            "engines": {
                "node": ">=8"
            }
        },
        "node_modules/is-core-module": {
            "version": "2.16.1",
            "resolved": "https://registry.npmjs.org/is-core-module/-/is-core-module-2.16.1.tgz",
            "integrity": "sha512-UfoeMA6fIJ8wTYFEUjelnaGI67v6+N7qXJEvQuIGa99l4xsCruSYOVSQ0uPANn4dAzm8lkYPaKLrrijLq7x23w==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "hasown": "^2.0.2"
            },
            "engines": {
                "node": ">= 0.4"
            },
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/is-extglob": {
            "version": "2.1.1",
            "resolved": "https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz",
            "integrity": "sha512-SbKbANkN603Vi4jEZv49LeVJMn4yGwsbzZworEoyEiutsN3nJYdbO36zfhGJ6QEDpOZIFkDtnq5JRxmvl3jsoQ==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/is-glob": {
            "version": "4.0.3",
            "resolved": "https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz",
            "integrity": "sha512-xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "is-extglob": "^2.1.1"
            },
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/is-number": {
            "version": "7.0.0",
            "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
            "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.12.0"
            }
        },
        "node_modules/jiti": {
            "version": "1.21.7",
            "resolved": "https://registry.npmjs.org/jiti/-/jiti-1.21.7.tgz",
            "integrity": "sha512-/imKNG4EbWNrVjoNC/1H5/9GFy+tqjGBHCaSsN+P2RnPqjsLmv6UD3Ej+Kj8nBWaRAwyk7kK5ZUc+OEatnTR3A==",
            "dev": true,
            "license": "MIT",
            "bin": {
                "jiti": "bin/jiti.js"
            }
        },
        "node_modules/js-tokens": {
            "version": "4.0.0",
            "resolved": "https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz",
            "integrity": "sha512-RdJUflcE3cUzKiMqQgsCu06FPu9UdIJO0beYbPhHN4k6apgJtifcoCtT9bcxOpYBtpD2kCM6Sbzg4CausW/PKQ==",
            "license": "MIT"
        },
        "node_modules/jsesc": {
            "version": "3.1.0",
            "resolved": "https://registry.npmjs.org/jsesc/-/jsesc-3.1.0.tgz",
            "integrity": "sha512-/sM3dO2FOzXjKQhJuo0Q173wf2KOo8t4I8vHy6lF9poUp7bKT0/NHE8fPX23PwfhnykfqnC2xRxOnVw5XuGIaA==",
            "dev": true,
            "license": "MIT",
            "bin": {
                "jsesc": "bin/jsesc"
            },
            "engines": {
                "node": ">=6"
            }
        },
        "node_modules/json5": {
            "version": "2.2.3",
            "resolved": "https://registry.npmjs.org/json5/-/json5-2.2.3.tgz",
            "integrity": "sha512-XmOWe7eyHYH14cLdVPoyg+GOH3rYX++KpzrylJwSW98t3Nk+U8XOl8FWKOgwtzdb8lXGf6zYwDUzeHMWfxasyg==",
            "dev": true,
            "license": "MIT",
            "bin": {
                "json5": "lib/cli.js"
            },
            "engines": {
                "node": ">=6"
            }
        },
        "node_modules/lilconfig": {
            "version": "3.1.3",
            "resolved": "https://registry.npmjs.org/lilconfig/-/lilconfig-3.1.3.tgz",
            "integrity": "sha512-/vlFKAoH5Cgt3Ie+JLhRbwOsCQePABiU3tJ1egGvyQ+33R/vcwM2Zl2QR/LzjsBeItPt3oSVXapn+m4nQDvpzw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=14"
            },
            "funding": {
                "url": "https://github.com/sponsors/antonk52"
            }
        },
        "node_modules/lines-and-columns": {
            "version": "1.2.4",
            "resolved": "https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz",
            "integrity": "sha512-7ylylesZQ/PV29jhEDl3Ufjo6ZX7gCqJr5F7PKrqc93v7fzSymt1BpwEU8nAUXs8qzzvqhbjhK5QZg6Mt/HkBg==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/loose-envify": {
            "version": "1.4.0",
            "resolved": "https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz",
            "integrity": "sha512-lyuxPGr/Wfhrlem2CL/UcnUc1zcqKAImBDzukY7Y5F/yQiNdko6+fRLevlw1HgMySw7f611UIY408EtxRSoK3Q==",
            "license": "MIT",
            "dependencies": {
                "js-tokens": "^3.0.0 || ^4.0.0"
            },
            "bin": {
                "loose-envify": "cli.js"
            }
        },
        "node_modules/lru-cache": {
            "version": "5.1.1",
            "resolved": "https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz",
            "integrity": "sha512-KpNARQA3Iwv+jTA0utUVVbrh+Jlrr1Fv0e56GGzAFOXN7dk/FviaDW8LHmK52DlcH4WP2n6gI8vN1aesBFgo9w==",
            "dev": true,
            "license": "ISC",
            "dependencies": {
                "yallist": "^3.0.2"
            }
        },
        "node_modules/lucide-react": {
            "version": "1.11.0",
            "resolved": "https://registry.npmjs.org/lucide-react/-/lucide-react-1.11.0.tgz",
            "integrity": "sha512-UOhjdztXCgdBReRcIhsvz2siIBogfv/lhJEIViCpLt924dO+GDms9T7DNoucI23s6kEPpe988m5N0D2ajnzb2g==",
            "license": "ISC",
            "peerDependencies": {
                "react": "^16.5.1 || ^17.0.0 || ^18.0.0 || ^19.0.0"
            }
        },
        "node_modules/merge2": {
            "version": "1.4.1",
            "resolved": "https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz",
            "integrity": "sha512-8q7VEgMJW4J8tcfVPy8g09NcQwZdbwFEqhe/WZkoIzjn/3TGDwtOCYtXGxA3O8tPzpczCCDgv+P2P5y00ZJOOg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 8"
            }
        },
        "node_modules/micromatch": {
            "version": "4.0.8",
            "resolved": "https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz",
            "integrity": "sha512-PXwfBhYu0hBCPw8Dn0E+WDYb7af3dSLVWKi3HGv84IdF4TyFoC0ysxFd0Goxw7nSv4T/PzEJQxsYsEiFCKo2BA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "braces": "^3.0.3",
                "picomatch": "^2.3.1"
            },
            "engines": {
                "node": ">=8.6"
            }
        },
        "node_modules/motion-dom": {
            "version": "12.38.0",
            "resolved": "https://registry.npmjs.org/motion-dom/-/motion-dom-12.38.0.tgz",
            "integrity": "sha512-pdkHLD8QYRp8VfiNLb8xIBJis1byQ9gPT3Jnh2jqfFtAsWUA3dEepDlsWe/xMpO8McV+VdpKVcp+E+TGJEtOoA==",
            "license": "MIT",
            "dependencies": {
                "motion-utils": "^12.36.0"
            }
        },
        "node_modules/motion-utils": {
            "version": "12.36.0",
            "resolved": "https://registry.npmjs.org/motion-utils/-/motion-utils-12.36.0.tgz",
            "integrity": "sha512-eHWisygbiwVvf6PZ1vhaHCLamvkSbPIeAYxWUuL3a2PD/TROgE7FvfHWTIH4vMl798QLfMw15nRqIaRDXTlYRg==",
            "license": "MIT"
        },
        "node_modules/ms": {
            "version": "2.1.3",
            "resolved": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",
            "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/mz": {
            "version": "2.7.0",
            "resolved": "https://registry.npmjs.org/mz/-/mz-2.7.0.tgz",
            "integrity": "sha512-z81GNO7nnYMEhrGh9LeymoE4+Yr0Wn5McHIZMK5cfQCl+NDX08sCZgUc9/6MHni9IWuFLm1Z3HTCXu2z9fN62Q==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "any-promise": "^1.0.0",
                "object-assign": "^4.0.1",
                "thenify-all": "^1.0.0"
            }
        },
        "node_modules/nanoid": {
            "version": "3.3.11",
            "resolved": "https://registry.npmjs.org/nanoid/-/nanoid-3.3.11.tgz",
            "integrity": "sha512-N8SpfPUnUp1bK+PMYW8qSWdl9U+wwNWI4QKxOYDy9JAro3WMX7p2OeVRF9v+347pnakNevPmiHhNmZ2HbFA76w==",
            "dev": true,
            "funding": [
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "bin": {
                "nanoid": "bin/nanoid.cjs"
            },
            "engines": {
                "node": "^10 || ^12 || ^13.7 || ^14 || >=15.0.1"
            }
        },
        "node_modules/node-releases": {
            "version": "2.0.38",
            "resolved": "https://registry.npmjs.org/node-releases/-/node-releases-2.0.38.tgz",
            "integrity": "sha512-3qT/88Y3FbH/Kx4szpQQ4HzUbVrHPKTLVpVocKiLfoYvw9XSGOX2FmD2d6DrXbVYyAQTF2HeF6My8jmzx7/CRw==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/normalize-path": {
            "version": "3.0.0",
            "resolved": "https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz",
            "integrity": "sha512-6eZs5Ls3WtCisHWp9S2GUy8dqkpGi4BVSz3GaqiE6ezub0512ESztXUwUB6C6IKbQkY2Pnb/mD4WYojCRwcwLA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/object-assign": {
            "version": "4.1.1",
            "resolved": "https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz",
            "integrity": "sha512-rJgTQnkUnH1sFw8yT6VSU3zD3sWmu6sZhIseY8VX+GRu3P6F7Fu+JNDoXfklElbLJSnc3FUQHVe4cU5hj+BcUg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/object-hash": {
            "version": "3.0.0",
            "resolved": "https://registry.npmjs.org/object-hash/-/object-hash-3.0.0.tgz",
            "integrity": "sha512-RSn9F68PjH9HqtltsSnqYC1XXoWe9Bju5+213R98cNGttag9q9yAOTzdbsqvIa7aNm5WffBZFpWYr2aWrklWAw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 6"
            }
        },
        "node_modules/path-parse": {
            "version": "1.0.7",
            "resolved": "https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz",
            "integrity": "sha512-LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/picocolors": {
            "version": "1.1.1",
            "resolved": "https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz",
            "integrity": "sha512-xceH2snhtb5M9liqDsmEw56le376mTZkEX/jEb/RxNFyegNul7eNslCXP9FDj/Lcu0X8KEyMceP2ntpaHrDEVA==",
            "dev": true,
            "license": "ISC"
        },
        "node_modules/picomatch": {
            "version": "2.3.2",
            "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-2.3.2.tgz",
            "integrity": "sha512-V7+vQEJ06Z+c5tSye8S+nHUfI51xoXIXjHQ99cQtKUkQqqO1kO/KCJUfZXuB47h/YBlDhah2H3hdUGXn8ie0oA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=8.6"
            },
            "funding": {
                "url": "https://github.com/sponsors/jonschlinkert"
            }
        },
        "node_modules/pify": {
            "version": "2.3.0",
            "resolved": "https://registry.npmjs.org/pify/-/pify-2.3.0.tgz",
            "integrity": "sha512-udgsAY+fTnvv7kI7aaxbqwWNb0AHiB0qBO89PZKPkoTmGOgdbrHDKD+0B2X4uTfJ/FT1R09r9gTsjUjNJotuog==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/pirates": {
            "version": "4.0.7",
            "resolved": "https://registry.npmjs.org/pirates/-/pirates-4.0.7.tgz",
            "integrity": "sha512-TfySrs/5nm8fQJDcBDuUng3VOUKsd7S+zqvbOTiGXHfxX4wK31ard+hoNuvkicM/2YFzlpDgABOevKSsB4G/FA==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 6"
            }
        },
        "node_modules/postcss": {
            "version": "8.5.10",
            "resolved": "https://registry.npmjs.org/postcss/-/postcss-8.5.10.tgz",
            "integrity": "sha512-pMMHxBOZKFU6HgAZ4eyGnwXF/EvPGGqUr0MnZ5+99485wwW41kW91A4LOGxSHhgugZmSChL5AlElNdwlNgcnLQ==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/postcss/"
                },
                {
                    "type": "tidelift",
                    "url": "https://tidelift.com/funding/github/npm/postcss"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "nanoid": "^3.3.11",
                "picocolors": "^1.1.1",
                "source-map-js": "^1.2.1"
            },
            "engines": {
                "node": "^10 || ^12 || >=14"
            }
        },
        "node_modules/postcss-import": {
            "version": "15.1.0",
            "resolved": "https://registry.npmjs.org/postcss-import/-/postcss-import-15.1.0.tgz",
            "integrity": "sha512-hpr+J05B2FVYUAXHeK1YyI267J/dDDhMU6B6civm8hSY1jYJnBXxzKDKDswzJmtLHryrjhnDjqqp/49t8FALew==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "postcss-value-parser": "^4.0.0",
                "read-cache": "^1.0.0",
                "resolve": "^1.1.7"
            },
            "engines": {
                "node": ">=14.0.0"
            },
            "peerDependencies": {
                "postcss": "^8.0.0"
            }
        },
        "node_modules/postcss-js": {
            "version": "4.1.0",
            "resolved": "https://registry.npmjs.org/postcss-js/-/postcss-js-4.1.0.tgz",
            "integrity": "sha512-oIAOTqgIo7q2EOwbhb8UalYePMvYoIeRY2YKntdpFQXNosSu3vLrniGgmH9OKs/qAkfoj5oB3le/7mINW1LCfw==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/postcss/"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "camelcase-css": "^2.0.1"
            },
            "engines": {
                "node": "^12 || ^14 || >= 16"
            },
            "peerDependencies": {
                "postcss": "^8.4.21"
            }
        },
        "node_modules/postcss-load-config": {
            "version": "6.0.1",
            "resolved": "https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-6.0.1.tgz",
            "integrity": "sha512-oPtTM4oerL+UXmx+93ytZVN82RrlY/wPUV8IeDxFrzIjXOLF1pN+EmKPLbubvKHT2HC20xXsCAH2Z+CKV6Oz/g==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/postcss/"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "lilconfig": "^3.1.1"
            },
            "engines": {
                "node": ">= 18"
            },
            "peerDependencies": {
                "jiti": ">=1.21.0",
                "postcss": ">=8.0.9",
                "tsx": "^4.8.1",
                "yaml": "^2.4.2"
            },
            "peerDependenciesMeta": {
                "jiti": {
                    "optional": true
                },
                "postcss": {
                    "optional": true
                },
                "tsx": {
                    "optional": true
                },
                "yaml": {
                    "optional": true
                }
            }
        },
        "node_modules/postcss-nested": {
            "version": "6.2.0",
            "resolved": "https://registry.npmjs.org/postcss-nested/-/postcss-nested-6.2.0.tgz",
            "integrity": "sha512-HQbt28KulC5AJzG+cZtj9kvKB93CFCdLvog1WFLf1D+xmMvPGlBstkpTEZfK5+AN9hfJocyBFCNiqyS48bpgzQ==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/postcss/"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "postcss-selector-parser": "^6.1.1"
            },
            "engines": {
                "node": ">=12.0"
            },
            "peerDependencies": {
                "postcss": "^8.2.14"
            }
        },
        "node_modules/postcss-selector-parser": {
            "version": "6.1.2",
            "resolved": "https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz",
            "integrity": "sha512-Q8qQfPiZ+THO/3ZrOrO0cJJKfpYCagtMUkXbnEfmgUjwXg6z/WBeOyS9APBBPCTSiDV+s4SwQGu8yFsiMRIudg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "cssesc": "^3.0.0",
                "util-deprecate": "^1.0.2"
            },
            "engines": {
                "node": ">=4"
            }
        },
        "node_modules/postcss-value-parser": {
            "version": "4.2.0",
            "resolved": "https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz",
            "integrity": "sha512-1NNCs6uurfkVbeXG4S8JFT9t19m45ICnif8zWLd5oPSZ50QnwMfK+H3jv408d4jw/7Bttv5axS5IiHoLaVNHeQ==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/queue-microtask": {
            "version": "1.2.3",
            "resolved": "https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz",
            "integrity": "sha512-NuaNSa6flKT5JaSYQzJok04JzTL1CA6aGhv5rfLW3PgqA+M2ChpZQnAC8h8i4ZFkBS8X5RqkDBHA7r4hej3K9A==",
            "dev": true,
            "funding": [
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/feross"
                },
                {
                    "type": "patreon",
                    "url": "https://www.patreon.com/feross"
                },
                {
                    "type": "consulting",
                    "url": "https://feross.org/support"
                }
            ],
            "license": "MIT"
        },
        "node_modules/react": {
            "version": "18.3.1",
            "resolved": "https://registry.npmjs.org/react/-/react-18.3.1.tgz",
            "integrity": "sha512-wS+hAgJShR0KhEvPJArfuPVN1+Hz1t0Y6n5jLrGQbkb4urgPE/0Rve+1kMB1v/oWgHgm4WIcV+i7F2pTVj+2iQ==",
            "license": "MIT",
            "dependencies": {
                "loose-envify": "^1.1.0"
            },
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/react-dom": {
            "version": "18.3.1",
            "resolved": "https://registry.npmjs.org/react-dom/-/react-dom-18.3.1.tgz",
            "integrity": "sha512-5m4nQKp+rZRb09LNH59GM4BxTh9251/ylbKIbpe7TpGxfJ+9kv6BLkLBXIjjspbgbnIBNqlI23tRnTWT0snUIw==",
            "license": "MIT",
            "dependencies": {
                "loose-envify": "^1.1.0",
                "scheduler": "^0.23.2"
            },
            "peerDependencies": {
                "react": "^18.3.1"
            }
        },
        "node_modules/react-refresh": {
            "version": "0.17.0",
            "resolved": "https://registry.npmjs.org/react-refresh/-/react-refresh-0.17.0.tgz",
            "integrity": "sha512-z6F7K9bV85EfseRCp2bzrpyQ0Gkw1uLoCel9XBVWPg/TjRj94SkJzUTGfOa4bs7iJvBWtQG0Wq7wnI0syw3EBQ==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/react-router": {
            "version": "7.15.0",
            "resolved": "https://registry.npmjs.org/react-router/-/react-router-7.15.0.tgz",
            "integrity": "sha512-HW9vYwuM8f4yx66Izy8xfrzCM+SBJluoZcCbww9A1TySax11S5Vgw6fi3ZjMONw9J4gQwngL7PzkyIpJJpJ7RQ==",
            "license": "MIT",
            "dependencies": {
                "cookie": "^1.0.1",
                "set-cookie-parser": "^2.6.0"
            },
            "engines": {
                "node": ">=20.0.0"
            },
            "peerDependencies": {
                "react": ">=18",
                "react-dom": ">=18"
            },
            "peerDependenciesMeta": {
                "react-dom": {
                    "optional": true
                }
            }
        },
        "node_modules/react-router-dom": {
            "version": "7.15.0",
            "resolved": "https://registry.npmjs.org/react-router-dom/-/react-router-dom-7.15.0.tgz",
            "integrity": "sha512-VcrVg64Fo8nwBvDscajG8gRTLIuTC6N50nb22l2HOOV4PTOHgoGp8mUjy9wLiHYoYTSYI36tUnXZgasSRFZorQ==",
            "license": "MIT",
            "dependencies": {
                "react-router": "7.15.0"
            },
            "engines": {
                "node": ">=20.0.0"
            },
            "peerDependencies": {
                "react": ">=18",
                "react-dom": ">=18"
            }
        },
        "node_modules/read-cache": {
            "version": "1.0.0",
            "resolved": "https://registry.npmjs.org/read-cache/-/read-cache-1.0.0.tgz",
            "integrity": "sha512-Owdv/Ft7IjOgm/i0xvNDZ1LrRANRfew4b2prF3OWMQLxLfu3bS8FVhCsrSCMK4lR56Y9ya+AThoTpDCTxCmpRA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "pify": "^2.3.0"
            }
        },
        "node_modules/readdirp": {
            "version": "3.6.0",
            "resolved": "https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz",
            "integrity": "sha512-hOS089on8RduqdbhvQ5Z37A0ESjsqz6qnRcffsMU3495FuTdqSm+7bhJ29JvIOsBDEEnan5DPu9t3To9VRlMzA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "picomatch": "^2.2.1"
            },
            "engines": {
                "node": ">=8.10.0"
            }
        },
        "node_modules/resolve": {
            "version": "1.22.12",
            "resolved": "https://registry.npmjs.org/resolve/-/resolve-1.22.12.tgz",
            "integrity": "sha512-TyeJ1zif53BPfHootBGwPRYT1RUt6oGWsaQr8UyZW/eAm9bKoijtvruSDEmZHm92CwS9nj7/fWttqPCgzep8CA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "es-errors": "^1.3.0",
                "is-core-module": "^2.16.1",
                "path-parse": "^1.0.7",
                "supports-preserve-symlinks-flag": "^1.0.0"
            },
            "bin": {
                "resolve": "bin/resolve"
            },
            "engines": {
                "node": ">= 0.4"
            },
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/reusify": {
            "version": "1.1.0",
            "resolved": "https://registry.npmjs.org/reusify/-/reusify-1.1.0.tgz",
            "integrity": "sha512-g6QUff04oZpHs0eG5p83rFLhHeV00ug/Yf9nZM6fLeUrPguBTkTQOdpAWWspMh55TZfVQDPaN3NQJfbVRAxdIw==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "iojs": ">=1.0.0",
                "node": ">=0.10.0"
            }
        },
        "node_modules/rollup": {
            "version": "4.60.2",
            "resolved": "https://registry.npmjs.org/rollup/-/rollup-4.60.2.tgz",
            "integrity": "sha512-J9qZyW++QK/09NyN/zeO0dG/1GdGfyp9lV8ajHnRVLfo/uFsbji5mHnDgn/qYdUHyCkM2N+8VyspgZclfAh0eQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@types/estree": "1.0.8"
            },
            "bin": {
                "rollup": "dist/bin/rollup"
            },
            "engines": {
                "node": ">=18.0.0",
                "npm": ">=8.0.0"
            },
            "optionalDependencies": {
                "@rollup/rollup-android-arm-eabi": "4.60.2",
                "@rollup/rollup-android-arm64": "4.60.2",
                "@rollup/rollup-darwin-arm64": "4.60.2",
                "@rollup/rollup-darwin-x64": "4.60.2",
                "@rollup/rollup-freebsd-arm64": "4.60.2",
                "@rollup/rollup-freebsd-x64": "4.60.2",
                "@rollup/rollup-linux-arm-gnueabihf": "4.60.2",
                "@rollup/rollup-linux-arm-musleabihf": "4.60.2",
                "@rollup/rollup-linux-arm64-gnu": "4.60.2",
                "@rollup/rollup-linux-arm64-musl": "4.60.2",
                "@rollup/rollup-linux-loong64-gnu": "4.60.2",
                "@rollup/rollup-linux-loong64-musl": "4.60.2",
                "@rollup/rollup-linux-ppc64-gnu": "4.60.2",
                "@rollup/rollup-linux-ppc64-musl": "4.60.2",
                "@rollup/rollup-linux-riscv64-gnu": "4.60.2",
                "@rollup/rollup-linux-riscv64-musl": "4.60.2",
                "@rollup/rollup-linux-s390x-gnu": "4.60.2",
                "@rollup/rollup-linux-x64-gnu": "4.60.2",
                "@rollup/rollup-linux-x64-musl": "4.60.2",
                "@rollup/rollup-openbsd-x64": "4.60.2",
                "@rollup/rollup-openharmony-arm64": "4.60.2",
                "@rollup/rollup-win32-arm64-msvc": "4.60.2",
                "@rollup/rollup-win32-ia32-msvc": "4.60.2",
                "@rollup/rollup-win32-x64-gnu": "4.60.2",
                "@rollup/rollup-win32-x64-msvc": "4.60.2",
                "fsevents": "~2.3.2"
            }
        },
        "node_modules/run-parallel": {
            "version": "1.2.0",
            "resolved": "https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz",
            "integrity": "sha512-5l4VyZR86LZ/lDxZTR6jqL8AFE2S0IFLMP26AbjsLVADxHdhB/c0GUsH+y39UfCi3dzz8OlQuPmnaJOMoDHQBA==",
            "dev": true,
            "funding": [
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/feross"
                },
                {
                    "type": "patreon",
                    "url": "https://www.patreon.com/feross"
                },
                {
                    "type": "consulting",
                    "url": "https://feross.org/support"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "queue-microtask": "^1.2.2"
            }
        },
        "node_modules/scheduler": {
            "version": "0.23.2",
            "resolved": "https://registry.npmjs.org/scheduler/-/scheduler-0.23.2.tgz",
            "integrity": "sha512-UOShsPwz7NrMUqhR6t0hWjFduvOzbtv7toDH1/hIrfRNIDBnnBWd0CwJTGvTpngVlmwGCdP9/Zl/tVrDqcuYzQ==",
            "license": "MIT",
            "dependencies": {
                "loose-envify": "^1.1.0"
            }
        },
        "node_modules/semver": {
            "version": "6.3.1",
            "resolved": "https://registry.npmjs.org/semver/-/semver-6.3.1.tgz",
            "integrity": "sha512-BR7VvDCVHO+q2xBEWskxS6DJE1qRnb7DxzUrogb71CWoSficBxYsiAGd+Kl0mmq/MprG9yArRkyrQxTO6XjMzA==",
            "dev": true,
            "license": "ISC",
            "bin": {
                "semver": "bin/semver.js"
            }
        },
        "node_modules/set-cookie-parser": {
            "version": "2.7.2",
            "resolved": "https://registry.npmjs.org/set-cookie-parser/-/set-cookie-parser-2.7.2.tgz",
            "integrity": "sha512-oeM1lpU/UvhTxw+g3cIfxXHyJRc/uidd3yK1P242gzHds0udQBYzs3y8j4gCCW+ZJ7ad0yctld8RYO+bdurlvw==",
            "license": "MIT"
        },
        "node_modules/source-map-js": {
            "version": "1.2.1",
            "resolved": "https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz",
            "integrity": "sha512-UXWMKhLOwVKb728IUtQPXxfYU+usdybtUrK/8uGE8CQMvrhOpwvzDBwj0QhSL7MQc7vIsISBG8VQ8+IDQxpfQA==",
            "dev": true,
            "license": "BSD-3-Clause",
            "engines": {
                "node": ">=0.10.0"
            }
        },
        "node_modules/sucrase": {
            "version": "3.35.1",
            "resolved": "https://registry.npmjs.org/sucrase/-/sucrase-3.35.1.tgz",
            "integrity": "sha512-DhuTmvZWux4H1UOnWMB3sk0sbaCVOoQZjv8u1rDoTV0HTdGem9hkAZtl4JZy8P2z4Bg0nT+YMeOFyVr4zcG5Tw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@jridgewell/gen-mapping": "^0.3.2",
                "commander": "^4.0.0",
                "lines-and-columns": "^1.1.6",
                "mz": "^2.7.0",
                "pirates": "^4.0.1",
                "tinyglobby": "^0.2.11",
                "ts-interface-checker": "^0.1.9"
            },
            "bin": {
                "sucrase": "bin/sucrase",
                "sucrase-node": "bin/sucrase-node"
            },
            "engines": {
                "node": ">=16 || 14 >=14.17"
            }
        },
        "node_modules/supports-preserve-symlinks-flag": {
            "version": "1.0.0",
            "resolved": "https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz",
            "integrity": "sha512-ot0WnXS9fgdkgIcePe6RHNk1WA8+muPa6cSjeR3V8K27q9BB1rTE3R1p7Hv0z1ZyAc8s6Vvv8DIyWf681MAt0w==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">= 0.4"
            },
            "funding": {
                "url": "https://github.com/sponsors/ljharb"
            }
        },
        "node_modules/tailwindcss": {
            "version": "3.4.19",
            "resolved": "https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.4.19.tgz",
            "integrity": "sha512-3ofp+LL8E+pK/JuPLPggVAIaEuhvIz4qNcf3nA1Xn2o/7fb7s/TYpHhwGDv1ZU3PkBluUVaF8PyCHcm48cKLWQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "@alloc/quick-lru": "^5.2.0",
                "arg": "^5.0.2",
                "chokidar": "^3.6.0",
                "didyoumean": "^1.2.2",
                "dlv": "^1.1.3",
                "fast-glob": "^3.3.2",
                "glob-parent": "^6.0.2",
                "is-glob": "^4.0.3",
                "jiti": "^1.21.7",
                "lilconfig": "^3.1.3",
                "micromatch": "^4.0.8",
                "normalize-path": "^3.0.0",
                "object-hash": "^3.0.0",
                "picocolors": "^1.1.1",
                "postcss": "^8.4.47",
                "postcss-import": "^15.1.0",
                "postcss-js": "^4.0.1",
                "postcss-load-config": "^4.0.2 || ^5.0 || ^6.0",
                "postcss-nested": "^6.2.0",
                "postcss-selector-parser": "^6.1.2",
                "resolve": "^1.22.8",
                "sucrase": "^3.35.0"
            },
            "bin": {
                "tailwind": "lib/cli.js",
                "tailwindcss": "lib/cli.js"
            },
            "engines": {
                "node": ">=14.0.0"
            }
        },
        "node_modules/thenify": {
            "version": "3.3.1",
            "resolved": "https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz",
            "integrity": "sha512-RVZSIV5IG10Hk3enotrhvz0T9em6cyHBLkH/YAZuKqd8hRkKhSfCGIcP2KUY0EPxndzANBmNllzWPwak+bheSw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "any-promise": "^1.0.0"
            }
        },
        "node_modules/thenify-all": {
            "version": "1.6.0",
            "resolved": "https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz",
            "integrity": "sha512-RNxQH/qI8/t3thXJDwcstUO4zeqo64+Uy/+sNVRBx4Xn2OX+OZ9oP+iJnNFqplFra2ZUVeKCSa2oVWi3T4uVmA==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "thenify": ">= 3.1.0 < 4"
            },
            "engines": {
                "node": ">=0.8"
            }
        },
        "node_modules/tinyglobby": {
            "version": "0.2.16",
            "resolved": "https://registry.npmjs.org/tinyglobby/-/tinyglobby-0.2.16.tgz",
            "integrity": "sha512-pn99VhoACYR8nFHhxqix+uvsbXineAasWm5ojXoN8xEwK5Kd3/TrhNn1wByuD52UxWRLy8pu+kRMniEi6Eq9Zg==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "fdir": "^6.5.0",
                "picomatch": "^4.0.4"
            },
            "engines": {
                "node": ">=12.0.0"
            },
            "funding": {
                "url": "https://github.com/sponsors/SuperchupuDev"
            }
        },
        "node_modules/tinyglobby/node_modules/fdir": {
            "version": "6.5.0",
            "resolved": "https://registry.npmjs.org/fdir/-/fdir-6.5.0.tgz",
            "integrity": "sha512-tIbYtZbucOs0BRGqPJkshJUYdL+SDH7dVM8gjy+ERp3WAUjLEFJE+02kanyHtwjWOnwrKYBiwAmM0p4kLJAnXg==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=12.0.0"
            },
            "peerDependencies": {
                "picomatch": "^3 || ^4"
            },
            "peerDependenciesMeta": {
                "picomatch": {
                    "optional": true
                }
            }
        },
        "node_modules/tinyglobby/node_modules/picomatch": {
            "version": "4.0.4",
            "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-4.0.4.tgz",
            "integrity": "sha512-QP88BAKvMam/3NxH6vj2o21R6MjxZUAd6nlwAS/pnGvN9IVLocLHxGYIzFhg6fUQ+5th6P4dv4eW9jX3DSIj7A==",
            "dev": true,
            "license": "MIT",
            "engines": {
                "node": ">=12"
            },
            "funding": {
                "url": "https://github.com/sponsors/jonschlinkert"
            }
        },
        "node_modules/to-regex-range": {
            "version": "5.0.1",
            "resolved": "https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz",
            "integrity": "sha512-65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "is-number": "^7.0.0"
            },
            "engines": {
                "node": ">=8.0"
            }
        },
        "node_modules/ts-interface-checker": {
            "version": "0.1.13",
            "resolved": "https://registry.npmjs.org/ts-interface-checker/-/ts-interface-checker-0.1.13.tgz",
            "integrity": "sha512-Y/arvbn+rrz3JCKl9C4kVNfTfSm2/mEp5FSz5EsZSANGPSlQrpRI5M4PKF+mJnE52jOO90PnPSc3Ur3bTQw0gA==",
            "dev": true,
            "license": "Apache-2.0"
        },
        "node_modules/tslib": {
            "version": "2.8.1",
            "resolved": "https://registry.npmjs.org/tslib/-/tslib-2.8.1.tgz",
            "integrity": "sha512-oJFu94HQb+KVduSUQL7wnpmqnfmLsOA/nAh6b6EH0wCEoK0/mPeXU6c3wKDV83MkOuHPRHtSXKKU99IBazS/2w==",
            "license": "0BSD"
        },
        "node_modules/typescript": {
            "version": "5.9.3",
            "resolved": "https://registry.npmjs.org/typescript/-/typescript-5.9.3.tgz",
            "integrity": "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw==",
            "dev": true,
            "license": "Apache-2.0",
            "bin": {
                "tsc": "bin/tsc",
                "tsserver": "bin/tsserver"
            },
            "engines": {
                "node": ">=14.17"
            }
        },
        "node_modules/undici-types": {
            "version": "7.19.2",
            "resolved": "https://registry.npmjs.org/undici-types/-/undici-types-7.19.2.tgz",
            "integrity": "sha512-qYVnV5OEm2AW8cJMCpdV20CDyaN3g0AjDlOGf1OW4iaDEx8MwdtChUp4zu4H0VP3nDRF/8RKWH+IPp9uW0YGZg==",
            "license": "MIT"
        },
        "node_modules/update-browserslist-db": {
            "version": "1.2.3",
            "resolved": "https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.2.3.tgz",
            "integrity": "sha512-Js0m9cx+qOgDxo0eMiFGEueWztz+d4+M3rGlmKPT+T4IS/jP4ylw3Nwpu6cpTTP8R1MAC1kF4VbdLt3ARf209w==",
            "dev": true,
            "funding": [
                {
                    "type": "opencollective",
                    "url": "https://opencollective.com/browserslist"
                },
                {
                    "type": "tidelift",
                    "url": "https://tidelift.com/funding/github/npm/browserslist"
                },
                {
                    "type": "github",
                    "url": "https://github.com/sponsors/ai"
                }
            ],
            "license": "MIT",
            "dependencies": {
                "escalade": "^3.2.0",
                "picocolors": "^1.1.1"
            },
            "bin": {
                "update-browserslist-db": "cli.js"
            },
            "peerDependencies": {
                "browserslist": ">= 4.21.0"
            }
        },
        "node_modules/util-deprecate": {
            "version": "1.0.2",
            "resolved": "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz",
            "integrity": "sha512-EPD5q1uXyFxJpCrLnCc1nHnq3gOa6DZBocAIiI2TaSCA7VCJ1UJDMagCzIkXNsUYfD1daK//LTEQ8xiIbrHtcw==",
            "dev": true,
            "license": "MIT"
        },
        "node_modules/vite": {
            "version": "5.4.21",
            "resolved": "https://registry.npmjs.org/vite/-/vite-5.4.21.tgz",
            "integrity": "sha512-o5a9xKjbtuhY6Bi5S3+HvbRERmouabWbyUcpXXUA1u+GNUKoROi9byOJ8M0nHbHYHkYICiMlqxkg1KkYmm25Sw==",
            "dev": true,
            "license": "MIT",
            "dependencies": {
                "esbuild": "^0.21.3",
                "postcss": "^8.4.43",
                "rollup": "^4.20.0"
            },
            "bin": {
                "vite": "bin/vite.js"
            },
            "engines": {
                "node": "^18.0.0 || >=20.0.0"
            },
            "funding": {
                "url": "https://github.com/vitejs/vite?sponsor=1"
            },
            "optionalDependencies": {
                "fsevents": "~2.3.3"
            },
            "peerDependencies": {
                "@types/node": "^18.0.0 || >=20.0.0",
                "less": "*",
                "lightningcss": "^1.21.0",
                "sass": "*",
                "sass-embedded": "*",
                "stylus": "*",
                "sugarss": "*",
                "terser": "^5.4.0"
            },
            "peerDependenciesMeta": {
                "@types/node": {
                    "optional": true
                },
                "less": {
                    "optional": true
                },
                "lightningcss": {
                    "optional": true
                },
                "sass": {
                    "optional": true
                },
                "sass-embedded": {
                    "optional": true
                },
                "stylus": {
                    "optional": true
                },
                "sugarss": {
                    "optional": true
                },
                "terser": {
                    "optional": true
                }
            }
        },
        "node_modules/ws": {
            "version": "8.20.0",
            "resolved": "https://registry.npmjs.org/ws/-/ws-8.20.0.tgz",
            "integrity": "sha512-sAt8BhgNbzCtgGbt2OxmpuryO63ZoDk/sqaB/znQm94T4fCEsy/yV+7CdC1kJhOU9lboAEU7R3kquuycDoibVA==",
            "license": "MIT",
            "engines": {
                "node": ">=10.0.0"
            },
            "peerDependencies": {
                "bufferutil": "^4.0.1",
                "utf-8-validate": ">=5.0.2"
            },
            "peerDependenciesMeta": {
                "bufferutil": {
                    "optional": true
                },
                "utf-8-validate": {
                    "optional": true
                }
            }
        },
        "node_modules/yallist": {
            "version": "3.1.1",
            "resolved": "https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz",
            "integrity": "sha512-a4UGQaWPH59mOXUYnAG2ewncQS4i4F43Tv3JoAM+s2VDAmS9NsK8GpDMLrCHPksFT7h3K6TOoUNn2pb7RoXx4g==",
            "dev": true,
            "license": "ISC"
        }
    }
}
// FILE: package.json
{
    "name": "via51-alfa",
    "private": true,
    "version": "1.0.0",
    "type": "module",
    "scripts": {
        "dev": "vite",
        "build": "vite build",
        "preview": "vite preview"
    },
    "dependencies": {
        "@supabase/supabase-js": "^2.43.2",
        "framer-motion": "^12.38.0",
        "lucide-react": "^1.11.0",
        "react": "^18.3.1",
        "react-dom": "^18.3.1",
        "react-router-dom": "^7.15.0"
    },
    "devDependencies": {
        "@types/react": "^18.3.28",
        "@types/react-dom": "^18.3.7",
        "@vitejs/plugin-react": "^4.7.0",
        "autoprefixer": "^10.5.0",
        "postcss": "^8.5.10",
        "tailwindcss": "^3.4.19",
        "typescript": "^5.9.3",
        "vite": "^5.4.21"
    }
}
// FILE: tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "ignoreDeprecations": "5.0"
  },
  "include": ["src", "core", "hangar"]
}
// FILE: tsconfig.node.json
{
    "compilerOptions": {
        "composite": true,
        "skipLibCheck": true,
        "module": "ESNext",
        "moduleResolution": "node",
        "allowSyntheticDefaultImports": true
    },
    "include": [
        "vite.config.ts"
    ]
}
// FILE: package-lock.json
{
  "name": "via51-beta",
  "version": "1.0.0",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "": {
      "name": "via51-beta",
      "version": "1.0.0",
      "dependencies": {
        "@supabase/supabase-js": "^2.104.1",
        "cors": "^2.8.6",
        "dotenv": "^17.4.2",
        "express": "^4.22.1",
        "node-fetch": "^2.7.0"
      },
      "devDependencies": {
        "@types/cors": "^2.8.19",
        "@types/express": "^4.17.25",
        "@types/node": "^25.6.0",
        "@vercel/node": "^3.0.0",
        "tsx": "^4.21.0",
        "typescript": "^5.9.3"
      }
    },
    "node_modules/@cspotcode/source-map-support": {
      "version": "0.8.1",
      "resolved": "https://registry.npmjs.org/@cspotcode/source-map-support/-/source-map-support-0.8.1.tgz",
      "integrity": "sha512-IchNf6dN4tHoMFIn/7OE8LWZ19Y6q/67Bmf6vnGREv8RSbBVb9LPJxEcnwrcwX6ixSvaiGoomAUvu4YSxXrVgw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@jridgewell/trace-mapping": "0.3.9"
      },
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@edge-runtime/format": {
      "version": "2.2.1",
      "resolved": "https://registry.npmjs.org/@edge-runtime/format/-/format-2.2.1.tgz",
      "integrity": "sha512-JQTRVuiusQLNNLe2W9tnzBlV/GvSVcozLl4XZHk5swnRZ/v6jp8TqR8P7sqmJsQqblDZ3EztcWmLDbhRje/+8g==",
      "dev": true,
      "license": "MPL-2.0",
      "engines": {
        "node": ">=16"
      }
    },
    "node_modules/@edge-runtime/node-utils": {
      "version": "2.3.0",
      "resolved": "https://registry.npmjs.org/@edge-runtime/node-utils/-/node-utils-2.3.0.tgz",
      "integrity": "sha512-uUtx8BFoO1hNxtHjp3eqVPC/mWImGb2exOfGjMLUoipuWgjej+f4o/VP4bUI8U40gu7Teogd5VTeZUkGvJSPOQ==",
      "dev": true,
      "license": "MPL-2.0",
      "engines": {
        "node": ">=16"
      }
    },
    "node_modules/@edge-runtime/ponyfill": {
      "version": "2.4.2",
      "resolved": "https://registry.npmjs.org/@edge-runtime/ponyfill/-/ponyfill-2.4.2.tgz",
      "integrity": "sha512-oN17GjFr69chu6sDLvXxdhg0Qe8EZviGSuqzR9qOiKh4MhFYGdBBcqRNzdmYeAdeRzOW2mM9yil4RftUQ7sUOA==",
      "dev": true,
      "license": "MPL-2.0",
      "engines": {
        "node": ">=16"
      }
    },
    "node_modules/@edge-runtime/primitives": {
      "version": "4.1.0",
      "resolved": "https://registry.npmjs.org/@edge-runtime/primitives/-/primitives-4.1.0.tgz",
      "integrity": "sha512-Vw0lbJ2lvRUqc7/soqygUX216Xb8T3WBZ987oywz6aJqRxcwSVWwr9e+Nqo2m9bxobA9mdbWNNoRY6S9eko1EQ==",
      "dev": true,
      "license": "MPL-2.0",
      "engines": {
        "node": ">=16"
      }
    },
    "node_modules/@edge-runtime/vm": {
      "version": "3.2.0",
      "resolved": "https://registry.npmjs.org/@edge-runtime/vm/-/vm-3.2.0.tgz",
      "integrity": "sha512-0dEVyRLM/lG4gp1R/Ik5bfPl/1wX00xFwd5KcNH602tzBa09oF7pbTKETEhR1GjZ75K6OJnYFu8II2dyMhONMw==",
      "dev": true,
      "license": "MPL-2.0",
      "dependencies": {
        "@edge-runtime/primitives": "4.1.0"
      },
      "engines": {
        "node": ">=16"
      }
    },
    "node_modules/@esbuild/aix-ppc64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/aix-ppc64/-/aix-ppc64-0.27.7.tgz",
      "integrity": "sha512-EKX3Qwmhz1eMdEJokhALr0YiD0lhQNwDqkPYyPhiSwKrh7/4KRjQc04sZ8db+5DVVnZ1LmbNDI1uAMPEUBnQPg==",
      "cpu": [
        "ppc64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "aix"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/android-arm": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.27.7.tgz",
      "integrity": "sha512-jbPXvB4Yj2yBV7HUfE2KHe4GJX51QplCN1pGbYjvsyCZbQmies29EoJbkEc+vYuU5o45AfQn37vZlyXy4YJ8RQ==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/android-arm64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.27.7.tgz",
      "integrity": "sha512-62dPZHpIXzvChfvfLJow3q5dDtiNMkwiRzPylSCfriLvZeq0a1bWChrGx/BbUbPwOrsWKMn8idSllklzBy+dgQ==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/android-x64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.27.7.tgz",
      "integrity": "sha512-x5VpMODneVDb70PYV2VQOmIUUiBtY3D3mPBG8NxVk5CogneYhkR7MmM3yR/uMdITLrC1ml/NV1rj4bMJuy9MCg==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/darwin-arm64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.27.7.tgz",
      "integrity": "sha512-5lckdqeuBPlKUwvoCXIgI2D9/ABmPq3Rdp7IfL70393YgaASt7tbju3Ac+ePVi3KDH6N2RqePfHnXkaDtY9fkw==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/darwin-x64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.27.7.tgz",
      "integrity": "sha512-rYnXrKcXuT7Z+WL5K980jVFdvVKhCHhUwid+dDYQpH+qu+TefcomiMAJpIiC2EM3Rjtq0sO3StMV/+3w3MyyqQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/freebsd-arm64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.27.7.tgz",
      "integrity": "sha512-B48PqeCsEgOtzME2GbNM2roU29AMTuOIN91dsMO30t+Ydis3z/3Ngoj5hhnsOSSwNzS+6JppqWsuhTp6E82l2w==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "freebsd"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/freebsd-x64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.27.7.tgz",
      "integrity": "sha512-jOBDK5XEjA4m5IJK3bpAQF9/Lelu/Z9ZcdhTRLf4cajlB+8VEhFFRjWgfy3M1O4rO2GQ/b2dLwCUGpiF/eATNQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "freebsd"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-arm": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.27.7.tgz",
      "integrity": "sha512-RkT/YXYBTSULo3+af8Ib0ykH8u2MBh57o7q/DAs3lTJlyVQkgQvlrPTnjIzzRPQyavxtPtfg0EopvDyIt0j1rA==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-arm64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.27.7.tgz",
      "integrity": "sha512-RZPHBoxXuNnPQO9rvjh5jdkRmVizktkT7TCDkDmQ0W2SwHInKCAV95GRuvdSvA7w4VMwfCjUiPwDi0ZO6Nfe9A==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-ia32": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.27.7.tgz",
      "integrity": "sha512-GA48aKNkyQDbd3KtkplYWT102C5sn/EZTY4XROkxONgruHPU72l+gW+FfF8tf2cFjeHaRbWpOYa/uRBz/Xq1Pg==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-loong64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.27.7.tgz",
      "integrity": "sha512-a4POruNM2oWsD4WKvBSEKGIiWQF8fZOAsycHOt6JBpZ+JN2n2JH9WAv56SOyu9X5IqAjqSIPTaJkqN8F7XOQ5Q==",
      "cpu": [
        "loong64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-mips64el": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.27.7.tgz",
      "integrity": "sha512-KabT5I6StirGfIz0FMgl1I+R1H73Gp0ofL9A3nG3i/cYFJzKHhouBV5VWK1CSgKvVaG4q1RNpCTR2LuTVB3fIw==",
      "cpu": [
        "mips64el"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-ppc64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.27.7.tgz",
      "integrity": "sha512-gRsL4x6wsGHGRqhtI+ifpN/vpOFTQtnbsupUF5R5YTAg+y/lKelYR1hXbnBdzDjGbMYjVJLJTd2OFmMewAgwlQ==",
      "cpu": [
        "ppc64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-riscv64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.27.7.tgz",
      "integrity": "sha512-hL25LbxO1QOngGzu2U5xeXtxXcW+/GvMN3ejANqXkxZ/opySAZMrc+9LY/WyjAan41unrR3YrmtTsUpwT66InQ==",
      "cpu": [
        "riscv64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-s390x": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.27.7.tgz",
      "integrity": "sha512-2k8go8Ycu1Kb46vEelhu1vqEP+UeRVj2zY1pSuPdgvbd5ykAw82Lrro28vXUrRmzEsUV0NzCf54yARIK8r0fdw==",
      "cpu": [
        "s390x"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/linux-x64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.27.7.tgz",
      "integrity": "sha512-hzznmADPt+OmsYzw1EE33ccA+HPdIqiCRq7cQeL1Jlq2gb1+OyWBkMCrYGBJ+sxVzve2ZJEVeePbLM2iEIZSxA==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/netbsd-arm64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/netbsd-arm64/-/netbsd-arm64-0.27.7.tgz",
      "integrity": "sha512-b6pqtrQdigZBwZxAn1UpazEisvwaIDvdbMbmrly7cDTMFnw/+3lVxxCTGOrkPVnsYIosJJXAsILG9XcQS+Yu6w==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "netbsd"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/netbsd-x64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.27.7.tgz",
      "integrity": "sha512-OfatkLojr6U+WN5EDYuoQhtM+1xco+/6FSzJJnuWiUw5eVcicbyK3dq5EeV/QHT1uy6GoDhGbFpprUiHUYggrw==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "netbsd"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/openbsd-arm64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/openbsd-arm64/-/openbsd-arm64-0.27.7.tgz",
      "integrity": "sha512-AFuojMQTxAz75Fo8idVcqoQWEHIXFRbOc1TrVcFSgCZtQfSdc1RXgB3tjOn/krRHENUB4j00bfGjyl2mJrU37A==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "openbsd"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/openbsd-x64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.27.7.tgz",
      "integrity": "sha512-+A1NJmfM8WNDv5CLVQYJ5PshuRm/4cI6WMZRg1by1GwPIQPCTs1GLEUHwiiQGT5zDdyLiRM/l1G0Pv54gvtKIg==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "openbsd"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/openharmony-arm64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/openharmony-arm64/-/openharmony-arm64-0.27.7.tgz",
      "integrity": "sha512-+KrvYb/C8zA9CU/g0sR6w2RBw7IGc5J2BPnc3dYc5VJxHCSF1yNMxTV5LQ7GuKteQXZtspjFbiuW5/dOj7H4Yw==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "openharmony"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/sunos-x64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.27.7.tgz",
      "integrity": "sha512-ikktIhFBzQNt/QDyOL580ti9+5mL/YZeUPKU2ivGtGjdTYoqz6jObj6nOMfhASpS4GU4Q/Clh1QtxWAvcYKamA==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "sunos"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/win32-arm64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.27.7.tgz",
      "integrity": "sha512-7yRhbHvPqSpRUV7Q20VuDwbjW5kIMwTHpptuUzV+AA46kiPze5Z7qgt6CLCK3pWFrHeNfDd1VKgyP4O+ng17CA==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/win32-ia32": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.27.7.tgz",
      "integrity": "sha512-SmwKXe6VHIyZYbBLJrhOoCJRB/Z1tckzmgTLfFYOfpMAx63BJEaL9ExI8x7v0oAO3Zh6D/Oi1gVxEYr5oUCFhw==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@esbuild/win32-x64": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.27.7.tgz",
      "integrity": "sha512-56hiAJPhwQ1R4i+21FVF7V8kSD5zZTdHcVuRFMW0hn753vVfQN8xlx4uOPT4xoGH0Z/oVATuR82AiqSTDIpaHg==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=18"
      }
    },
    "node_modules/@fastify/busboy": {
      "version": "2.1.1",
      "resolved": "https://registry.npmjs.org/@fastify/busboy/-/busboy-2.1.1.tgz",
      "integrity": "sha512-vBZP4NlzfOlerQTnba4aqZoMhE/a9HY7HRqoOPaETQcSQuWEIyZMHGfVu6w9wGtGK5fED5qRs2DteVCjOH60sA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=14"
      }
    },
    "node_modules/@jridgewell/resolve-uri": {
      "version": "3.1.2",
      "resolved": "https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz",
      "integrity": "sha512-bRISgCIjP20/tbWSPWMEi54QVPRZExkuD9lJL+UIxUKtwVJA8wW1Trb1jMs1RFXo1CBTNZ/5hpC9QvmKWdopKw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/@jridgewell/sourcemap-codec": {
      "version": "1.5.5",
      "resolved": "https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.5.tgz",
      "integrity": "sha512-cYQ9310grqxueWbl+WuIUIaiUaDcj7WOq5fVhEljNVgRfOUhY9fy2zTvfoqWsnebh8Sl70VScFbICvJnLKB0Og==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@jridgewell/trace-mapping": {
      "version": "0.3.9",
      "resolved": "https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.9.tgz",
      "integrity": "sha512-3Belt6tdc8bPgAtbcmdtNJlirVoTmEb5e2gC94PnkwEW9jI6CAHUeoG85tjWP5WquqfavoMtMwiG4P926ZKKuQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@jridgewell/resolve-uri": "^3.0.3",
        "@jridgewell/sourcemap-codec": "^1.4.10"
      }
    },
    "node_modules/@mapbox/node-pre-gyp": {
      "version": "1.0.11",
      "resolved": "https://registry.npmjs.org/@mapbox/node-pre-gyp/-/node-pre-gyp-1.0.11.tgz",
      "integrity": "sha512-Yhlar6v9WQgUp/He7BdgzOz8lqMQ8sU+jkCq7Wx8Myc5YFJLbEe7lgui/V7G1qB1DJykHSGwreceSaD60Y0PUQ==",
      "dev": true,
      "license": "BSD-3-Clause",
      "dependencies": {
        "detect-libc": "^2.0.0",
        "https-proxy-agent": "^5.0.0",
        "make-dir": "^3.1.0",
        "node-fetch": "^2.6.7",
        "nopt": "^5.0.0",
        "npmlog": "^5.0.1",
        "rimraf": "^3.0.2",
        "semver": "^7.3.5",
        "tar": "^6.1.11"
      },
      "bin": {
        "node-pre-gyp": "bin/node-pre-gyp"
      }
    },
    "node_modules/@nodelib/fs.scandir": {
      "version": "2.1.5",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz",
      "integrity": "sha512-vq24Bq3ym5HEQm2NKCr3yXDwjc7vTsEThRDnkp2DK9p1uqLR+DHurm/NOTo0KG7HYHU7eppKZj3MyqYuMBf62g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@nodelib/fs.stat": "2.0.5",
        "run-parallel": "^1.1.9"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@nodelib/fs.stat": {
      "version": "2.0.5",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz",
      "integrity": "sha512-RkhPPp2zrqDAQA/2jNhnztcPAlv64XdhIp7a7454A5ovI7Bukxgt7MX7udwAu3zg1DcpPU0rz3VV1SeaqvY4+A==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@nodelib/fs.walk": {
      "version": "1.2.8",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz",
      "integrity": "sha512-oGB+UxlgWcgQkgwo8GcEGwemoTFt3FIO9ababBmaGwXIoBKZ+GTy0pP185beGg7Llih/NSHSV2XAs1lnznocSg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@nodelib/fs.scandir": "2.1.5",
        "fastq": "^1.6.0"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@rollup/pluginutils": {
      "version": "4.2.1",
      "resolved": "https://registry.npmjs.org/@rollup/pluginutils/-/pluginutils-4.2.1.tgz",
      "integrity": "sha512-iKnFXr7NkdZAIHiIWE+BX5ULi/ucVFYWD6TbAV+rZctiRTY2PL6tsIKhoIOaoskiWAkgu+VsbXgUVDNLHf+InQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "estree-walker": "^2.0.1",
        "picomatch": "^2.2.2"
      },
      "engines": {
        "node": ">= 8.0.0"
      }
    },
    "node_modules/@supabase/auth-js": {
      "version": "2.104.1",
      "resolved": "https://registry.npmjs.org/@supabase/auth-js/-/auth-js-2.104.1.tgz",
      "integrity": "sha512-pqFnDKekq1isqlqnzqzyJ3mzmho+o+FjfVTqhKY3PFlwj2anx3OPznO1kbo1ZEwD8zg1r4EAFf/7pplLyX0ocQ==",
      "license": "MIT",
      "dependencies": {
        "tslib": "2.8.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/functions-js": {
      "version": "2.104.1",
      "resolved": "https://registry.npmjs.org/@supabase/functions-js/-/functions-js-2.104.1.tgz",
      "integrity": "sha512-JjAH4JN9rZzxh4plQnILPrQZXAG6ccoRS6z9hQAGmXpRSwJA+7CWbsDV2R82I8MROlGDsjqj1Ot/cWpTfdf6xg==",
      "license": "MIT",
      "dependencies": {
        "tslib": "2.8.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/phoenix": {
      "version": "0.4.0",
      "resolved": "https://registry.npmjs.org/@supabase/phoenix/-/phoenix-0.4.0.tgz",
      "integrity": "sha512-RHSx8bHS02xwfHdAbX5Lpbo6PXbgyf7lTaXTlwtFDPwOIw64NnVRwFAXGojHhjtVYI+PEPNSWwkL90f4agN3bw==",
      "license": "MIT"
    },
    "node_modules/@supabase/postgrest-js": {
      "version": "2.104.1",
      "resolved": "https://registry.npmjs.org/@supabase/postgrest-js/-/postgrest-js-2.104.1.tgz",
      "integrity": "sha512-RqlLpvgXsjcc27fLyHNGm3zN0KDWXbkdTdaFtaEdX83RsTEqH7BAmshH7zoUMml5lL04naUeRjS3B81O6jZcJw==",
      "license": "MIT",
      "dependencies": {
        "tslib": "2.8.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/realtime-js": {
      "version": "2.104.1",
      "resolved": "https://registry.npmjs.org/@supabase/realtime-js/-/realtime-js-2.104.1.tgz",
      "integrity": "sha512-dVJHhFB2ErBd0/2qE9G8CedCrGoAtBfL9Q4zbSMXO7b1Cpld916ljSiX21mURUqijPf1WoPQG4Bp/averUzk/g==",
      "license": "MIT",
      "dependencies": {
        "@supabase/phoenix": "^0.4.0",
        "@types/ws": "^8.18.1",
        "tslib": "2.8.1",
        "ws": "^8.18.2"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/storage-js": {
      "version": "2.104.1",
      "resolved": "https://registry.npmjs.org/@supabase/storage-js/-/storage-js-2.104.1.tgz",
      "integrity": "sha512-2bQaLbkRshctkUVuqamwYZDEd+0cGSc9DY9sjh92DcA5hu1F/1AP8p6gxGr76sgdK9Ngi0rh+2Kdh+uC4hcnGA==",
      "license": "MIT",
      "dependencies": {
        "iceberg-js": "^0.8.1",
        "tslib": "2.8.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/supabase-js": {
      "version": "2.104.1",
      "resolved": "https://registry.npmjs.org/@supabase/supabase-js/-/supabase-js-2.104.1.tgz",
      "integrity": "sha512-E0H/CtVmaGjiAy+ieZ5ZB/1EqxXcGdaFaAc23AE5zaYfz6NtCNDcmaEdoGPYMPFH5pE6drGG6e3ljPmkFoGVxQ==",
      "license": "MIT",
      "dependencies": {
        "@supabase/auth-js": "2.104.1",
        "@supabase/functions-js": "2.104.1",
        "@supabase/postgrest-js": "2.104.1",
        "@supabase/realtime-js": "2.104.1",
        "@supabase/storage-js": "2.104.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@ts-morph/common": {
      "version": "0.11.1",
      "resolved": "https://registry.npmjs.org/@ts-morph/common/-/common-0.11.1.tgz",
      "integrity": "sha512-7hWZS0NRpEsNV8vWJzg7FEz6V8MaLNeJOmwmghqUXTpzk16V1LLZhdo+4QvE/+zv4cVci0OviuJFnqhEfoV3+g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "fast-glob": "^3.2.7",
        "minimatch": "^3.0.4",
        "mkdirp": "^1.0.4",
        "path-browserify": "^1.0.1"
      }
    },
    "node_modules/@tsconfig/node10": {
      "version": "1.0.12",
      "resolved": "https://registry.npmjs.org/@tsconfig/node10/-/node10-1.0.12.tgz",
      "integrity": "sha512-UCYBaeFvM11aU2y3YPZ//O5Rhj+xKyzy7mvcIoAjASbigy8mHMryP5cK7dgjlz2hWxh1g5pLw084E0a/wlUSFQ==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@tsconfig/node12": {
      "version": "1.0.11",
      "resolved": "https://registry.npmjs.org/@tsconfig/node12/-/node12-1.0.11.tgz",
      "integrity": "sha512-cqefuRsh12pWyGsIoBKJA9luFu3mRxCA+ORZvA4ktLSzIuCUtWVxGIuXigEwO5/ywWFMZ2QEGKWvkZG1zDMTag==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@tsconfig/node14": {
      "version": "1.0.3",
      "resolved": "https://registry.npmjs.org/@tsconfig/node14/-/node14-1.0.3.tgz",
      "integrity": "sha512-ysT8mhdixWK6Hw3i1V2AeRqZ5WfXg1G43mqoYlM2nc6388Fq5jcXyr5mRsqViLx/GJYdoL0bfXD8nmF+Zn/Iow==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@tsconfig/node16": {
      "version": "1.0.4",
      "resolved": "https://registry.npmjs.org/@tsconfig/node16/-/node16-1.0.4.tgz",
      "integrity": "sha512-vxhUy4J8lyeyinH7Azl1pdd43GJhZH/tP2weN8TntQblOY+A0XbT8DJk1/oCPuOOyg/Ja757rG0CgHcWC8OfMA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@types/body-parser": {
      "version": "1.19.6",
      "resolved": "https://registry.npmjs.org/@types/body-parser/-/body-parser-1.19.6.tgz",
      "integrity": "sha512-HLFeCYgz89uk22N5Qg3dvGvsv46B8GLvKKo1zKG4NybA8U2DiEO3w9lqGg29t/tfLRJpJ6iQxnVw4OnB7MoM9g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/connect": "*",
        "@types/node": "*"
      }
    },
    "node_modules/@types/connect": {
      "version": "3.4.38",
      "resolved": "https://registry.npmjs.org/@types/connect/-/connect-3.4.38.tgz",
      "integrity": "sha512-K6uROf1LD88uDQqJCktA4yzL1YYAK6NgfsI0v/mTgyPKWsX1CnJ0XPSDhViejru1GcRkLWb8RlzFYJRqGUbaug==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/node": "*"
      }
    },
    "node_modules/@types/cors": {
      "version": "2.8.19",
      "resolved": "https://registry.npmjs.org/@types/cors/-/cors-2.8.19.tgz",
      "integrity": "sha512-mFNylyeyqN93lfe/9CSxOGREz8cpzAhH+E93xJ4xWQf62V8sQ/24reV2nyzUWM6H6Xji+GGHpkbLe7pVoUEskg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/node": "*"
      }
    },
    "node_modules/@types/express": {
      "version": "4.17.25",
      "resolved": "https://registry.npmjs.org/@types/express/-/express-4.17.25.tgz",
      "integrity": "sha512-dVd04UKsfpINUnK0yBoYHDF3xu7xVH4BuDotC/xGuycx4CgbP48X/KF/586bcObxT0HENHXEU8Nqtu6NR+eKhw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/body-parser": "*",
        "@types/express-serve-static-core": "^4.17.33",
        "@types/qs": "*",
        "@types/serve-static": "^1"
      }
    },
    "node_modules/@types/express-serve-static-core": {
      "version": "4.19.8",
      "resolved": "https://registry.npmjs.org/@types/express-serve-static-core/-/express-serve-static-core-4.19.8.tgz",
      "integrity": "sha512-02S5fmqeoKzVZCHPZid4b8JH2eM5HzQLZWN2FohQEy/0eXTq8VXZfSN6Pcr3F6N9R/vNrj7cpgbhjie6m/1tCA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/node": "*",
        "@types/qs": "*",
        "@types/range-parser": "*",
        "@types/send": "*"
      }
    },
    "node_modules/@types/http-errors": {
      "version": "2.0.5",
      "resolved": "https://registry.npmjs.org/@types/http-errors/-/http-errors-2.0.5.tgz",
      "integrity": "sha512-r8Tayk8HJnX0FztbZN7oVqGccWgw98T/0neJphO91KkmOzug1KkofZURD4UaD5uH8AqcFLfdPErnBod0u71/qg==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@types/json-schema": {
      "version": "7.0.15",
      "resolved": "https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz",
      "integrity": "sha512-5+fP8P8MFNC+AyZCDxrB2pkZFPGzqQWUzpSeuuVLvm8VMcorNYavBqoFcxK8bQz4Qsbn4oUEEem4wDLfcysGHA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@types/mime": {
      "version": "1.3.5",
      "resolved": "https://registry.npmjs.org/@types/mime/-/mime-1.3.5.tgz",
      "integrity": "sha512-/pyBZWSLD2n0dcHE3hq8s8ZvcETHtEuF+3E7XVt0Ig2nvsVQXdghHVcEkIWjy9A0wKfTn97a/PSDYohKIlnP/w==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@types/node": {
      "version": "25.6.0",
      "resolved": "https://registry.npmjs.org/@types/node/-/node-25.6.0.tgz",
      "integrity": "sha512-+qIYRKdNYJwY3vRCZMdJbPLJAtGjQBudzZzdzwQYkEPQd+PJGixUL5QfvCLDaULoLv+RhT3LDkwEfKaAkgSmNQ==",
      "license": "MIT",
      "dependencies": {
        "undici-types": "~7.19.0"
      }
    },
    "node_modules/@types/qs": {
      "version": "6.15.0",
      "resolved": "https://registry.npmjs.org/@types/qs/-/qs-6.15.0.tgz",
      "integrity": "sha512-JawvT8iBVWpzTrz3EGw9BTQFg3BQNmwERdKE22vlTxawwtbyUSlMppvZYKLZzB5zgACXdXxbD3m1bXaMqP/9ow==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@types/range-parser": {
      "version": "1.2.7",
      "resolved": "https://registry.npmjs.org/@types/range-parser/-/range-parser-1.2.7.tgz",
      "integrity": "sha512-hKormJbkJqzQGhziax5PItDUTMAM9uE2XXQmM37dyd4hVM+5aVl7oVxMVUiVQn2oCQFN/LKCZdvSM0pFRqbSmQ==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@types/send": {
      "version": "1.2.1",
      "resolved": "https://registry.npmjs.org/@types/send/-/send-1.2.1.tgz",
      "integrity": "sha512-arsCikDvlU99zl1g69TcAB3mzZPpxgw0UQnaHeC1Nwb015xp8bknZv5rIfri9xTOcMuaVgvabfIRA7PSZVuZIQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/node": "*"
      }
    },
    "node_modules/@types/serve-static": {
      "version": "1.15.10",
      "resolved": "https://registry.npmjs.org/@types/serve-static/-/serve-static-1.15.10.tgz",
      "integrity": "sha512-tRs1dB+g8Itk72rlSI2ZrW6vZg0YrLI81iQSTkMmOqnqCaNr/8Ek4VwWcN5vZgCYWbg/JJSGBlUaYGAOP73qBw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/http-errors": "*",
        "@types/node": "*",
        "@types/send": "<1"
      }
    },
    "node_modules/@types/serve-static/node_modules/@types/send": {
      "version": "0.17.6",
      "resolved": "https://registry.npmjs.org/@types/send/-/send-0.17.6.tgz",
      "integrity": "sha512-Uqt8rPBE8SY0RK8JB1EzVOIZ32uqy8HwdxCnoCOsYrvnswqmFZ/k+9Ikidlk/ImhsdvBsloHbAlewb2IEBV/Og==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/mime": "^1",
        "@types/node": "*"
      }
    },
    "node_modules/@types/ws": {
      "version": "8.18.1",
      "resolved": "https://registry.npmjs.org/@types/ws/-/ws-8.18.1.tgz",
      "integrity": "sha512-ThVF6DCVhA8kUGy+aazFQ4kXQ7E1Ty7A3ypFOe0IcJV8O/M511G99AW24irKrW56Wt44yG9+ij8FaqoBGkuBXg==",
      "license": "MIT",
      "dependencies": {
        "@types/node": "*"
      }
    },
    "node_modules/@vercel/build-utils": {
      "version": "8.7.0",
      "resolved": "https://registry.npmjs.org/@vercel/build-utils/-/build-utils-8.7.0.tgz",
      "integrity": "sha512-ofZX+ABiW76u5khIyYyH5xK5KSuiAteqRu5hz2k1a2WHLwF7VpeBg8gdFR+HwbVnNkHtkMA64ya5Dd/lNoABkw==",
      "dev": true,
      "license": "Apache-2.0"
    },
    "node_modules/@vercel/error-utils": {
      "version": "2.0.3",
      "resolved": "https://registry.npmjs.org/@vercel/error-utils/-/error-utils-2.0.3.tgz",
      "integrity": "sha512-CqC01WZxbLUxoiVdh9B/poPbNpY9U+tO1N9oWHwTl5YAZxcqXmmWJ8KNMFItJCUUWdY3J3xv8LvAuQv2KZ5YdQ==",
      "dev": true,
      "license": "Apache-2.0"
    },
    "node_modules/@vercel/nft": {
      "version": "0.27.3",
      "resolved": "https://registry.npmjs.org/@vercel/nft/-/nft-0.27.3.tgz",
      "integrity": "sha512-oySTdDSzUAFDXpsSLk9Q943o+/Yu/+TCFxnehpFQEf/3khi2stMpTHPVNwFdvZq/Z4Ky93lE+MGHpXCRpMkSCA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@mapbox/node-pre-gyp": "^1.0.5",
        "@rollup/pluginutils": "^4.0.0",
        "acorn": "^8.6.0",
        "acorn-import-attributes": "^1.9.5",
        "async-sema": "^3.1.1",
        "bindings": "^1.4.0",
        "estree-walker": "2.0.2",
        "glob": "^7.1.3",
        "graceful-fs": "^4.2.9",
        "micromatch": "^4.0.2",
        "node-gyp-build": "^4.2.2",
        "resolve-from": "^5.0.0"
      },
      "bin": {
        "nft": "out/cli.js"
      },
      "engines": {
        "node": ">=16"
      }
    },
    "node_modules/@vercel/node": {
      "version": "3.2.29",
      "resolved": "https://registry.npmjs.org/@vercel/node/-/node-3.2.29.tgz",
      "integrity": "sha512-WRVYidBqtRyYUw36v/WyUB2v97PsiV2+LepUiOPWcW9UpszQGGT2DAzsXOYqWveXMJKFhx0aETR6Nn6i+Yps1Q==",
      "dev": true,
      "license": "Apache-2.0",
      "dependencies": {
        "@edge-runtime/node-utils": "2.3.0",
        "@edge-runtime/primitives": "4.1.0",
        "@edge-runtime/vm": "3.2.0",
        "@types/node": "16.18.11",
        "@vercel/build-utils": "8.7.0",
        "@vercel/error-utils": "2.0.3",
        "@vercel/nft": "0.27.3",
        "@vercel/static-config": "3.0.0",
        "async-listen": "3.0.0",
        "cjs-module-lexer": "1.2.3",
        "edge-runtime": "2.5.9",
        "es-module-lexer": "1.4.1",
        "esbuild": "0.14.47",
        "etag": "1.8.1",
        "node-fetch": "2.6.9",
        "path-to-regexp": "6.2.1",
        "ts-morph": "12.0.0",
        "ts-node": "10.9.1",
        "typescript": "4.9.5",
        "undici": "5.28.4"
      }
    },
    "node_modules/@vercel/node/node_modules/@types/node": {
      "version": "16.18.11",
      "resolved": "https://registry.npmjs.org/@types/node/-/node-16.18.11.tgz",
      "integrity": "sha512-3oJbGBUWuS6ahSnEq1eN2XrCyf4YsWI8OyCvo7c64zQJNplk3mO84t53o8lfTk+2ji59g5ycfc6qQ3fdHliHuA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@vercel/node/node_modules/node-fetch": {
      "version": "2.6.9",
      "resolved": "https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.9.tgz",
      "integrity": "sha512-DJm/CJkZkRjKKj4Zi4BsKVZh3ValV5IR5s7LVZnW+6YMh0W1BfNA8XSs6DLMGYlId5F3KnA70uu2qepcR08Qqg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "whatwg-url": "^5.0.0"
      },
      "engines": {
        "node": "4.x || >=6.0.0"
      },
      "peerDependencies": {
        "encoding": "^0.1.0"
      },
      "peerDependenciesMeta": {
        "encoding": {
          "optional": true
        }
      }
    },
    "node_modules/@vercel/node/node_modules/typescript": {
      "version": "4.9.5",
      "resolved": "https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz",
      "integrity": "sha512-1FXk9E2Hm+QzZQ7z+McJiHL4NW1F2EzMu9Nq9i3zAaGqibafqYwCVU6WyWAuyQRRzOlxou8xZSyXLEN8oKj24g==",
      "dev": true,
      "license": "Apache-2.0",
      "bin": {
        "tsc": "bin/tsc",
        "tsserver": "bin/tsserver"
      },
      "engines": {
        "node": ">=4.2.0"
      }
    },
    "node_modules/@vercel/static-config": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/@vercel/static-config/-/static-config-3.0.0.tgz",
      "integrity": "sha512-2qtvcBJ1bGY0dYGYh3iM7yGKkk971FujLEDXzuW5wcZsPr1GSEjO/w2iSr3qve6nDDtBImsGoDEnus5FI4+fIw==",
      "dev": true,
      "license": "Apache-2.0",
      "dependencies": {
        "ajv": "8.6.3",
        "json-schema-to-ts": "1.6.4",
        "ts-morph": "12.0.0"
      }
    },
    "node_modules/abbrev": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/abbrev/-/abbrev-1.1.1.tgz",
      "integrity": "sha512-nne9/IiQ/hzIhY6pdDnbBtz7DjPTKrY00P/zvPSm5pOFkl6xuGrGnXn/VtTNNfNtAfZ9/1RtehkszU9qcTii0Q==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/accepts": {
      "version": "1.3.8",
      "resolved": "https://registry.npmjs.org/accepts/-/accepts-1.3.8.tgz",
      "integrity": "sha512-PYAthTa2m2VKxuvSD3DPC/Gy+U+sOA1LAuT8mkmRuvw+NACSaeXEQ+NHcVF7rONl6qcaxV3Uuemwawk+7+SJLw==",
      "license": "MIT",
      "dependencies": {
        "mime-types": "~2.1.34",
        "negotiator": "0.6.3"
      },
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/acorn": {
      "version": "8.16.0",
      "resolved": "https://registry.npmjs.org/acorn/-/acorn-8.16.0.tgz",
      "integrity": "sha512-UVJyE9MttOsBQIDKw1skb9nAwQuR5wuGD3+82K6JgJlm/Y+KI92oNsMNGZCYdDsVtRHSak0pcV5Dno5+4jh9sw==",
      "dev": true,
      "license": "MIT",
      "bin": {
        "acorn": "bin/acorn"
      },
      "engines": {
        "node": ">=0.4.0"
      }
    },
    "node_modules/acorn-import-attributes": {
      "version": "1.9.5",
      "resolved": "https://registry.npmjs.org/acorn-import-attributes/-/acorn-import-attributes-1.9.5.tgz",
      "integrity": "sha512-n02Vykv5uA3eHGM/Z2dQrcD56kL8TyDb2p1+0P83PClMnC/nc+anbQRhIOWnSq4Ke/KvDPrY3C9hDtC/A3eHnQ==",
      "dev": true,
      "license": "MIT",
      "peerDependencies": {
        "acorn": "^8"
      }
    },
    "node_modules/acorn-walk": {
      "version": "8.3.5",
      "resolved": "https://registry.npmjs.org/acorn-walk/-/acorn-walk-8.3.5.tgz",
      "integrity": "sha512-HEHNfbars9v4pgpW6SO1KSPkfoS0xVOM/9UzkJltjlsHZmJasxg8aXkuZa7SMf8vKGIBhpUsPluQSqhJFCqebw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "acorn": "^8.11.0"
      },
      "engines": {
        "node": ">=0.4.0"
      }
    },
    "node_modules/agent-base": {
      "version": "6.0.2",
      "resolved": "https://registry.npmjs.org/agent-base/-/agent-base-6.0.2.tgz",
      "integrity": "sha512-RZNwNclF7+MS/8bDg70amg32dyeZGZxiDuQmZxKLAlQjr3jGyLx+4Kkk58UO7D2QdgFIQCovuSuZESne6RG6XQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "debug": "4"
      },
      "engines": {
        "node": ">= 6.0.0"
      }
    },
    "node_modules/agent-base/node_modules/debug": {
      "version": "4.4.3",
      "resolved": "https://registry.npmjs.org/debug/-/debug-4.4.3.tgz",
      "integrity": "sha512-RGwwWnwQvkVfavKVt22FGLw+xYSdzARwm0ru6DhTVA3umU5hZc28V3kO4stgYryrTlLpuvgI9GiijltAjNbcqA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "ms": "^2.1.3"
      },
      "engines": {
        "node": ">=6.0"
      },
      "peerDependenciesMeta": {
        "supports-color": {
          "optional": true
        }
      }
    },
    "node_modules/agent-base/node_modules/ms": {
      "version": "2.1.3",
      "resolved": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",
      "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/ajv": {
      "version": "8.6.3",
      "resolved": "https://registry.npmjs.org/ajv/-/ajv-8.6.3.tgz",
      "integrity": "sha512-SMJOdDP6LqTkD0Uq8qLi+gMwSt0imXLSV080qFVwJCpH9U6Mb+SUGHAXM0KNbcBPguytWyvFxcHgMLe2D2XSpw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "fast-deep-equal": "^3.1.1",
        "json-schema-traverse": "^1.0.0",
        "require-from-string": "^2.0.2",
        "uri-js": "^4.2.2"
      },
      "funding": {
        "type": "github",
        "url": "https://github.com/sponsors/epoberezkin"
      }
    },
    "node_modules/ansi-regex": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz",
      "integrity": "sha512-quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/aproba": {
      "version": "2.1.0",
      "resolved": "https://registry.npmjs.org/aproba/-/aproba-2.1.0.tgz",
      "integrity": "sha512-tLIEcj5GuR2RSTnxNKdkK0dJ/GrC7P38sUkiDmDuHfsHmbagTFAxDVIBltoklXEVIQ/f14IL8IMJ5pn9Hez1Ew==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/are-we-there-yet": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-2.0.0.tgz",
      "integrity": "sha512-Ci/qENmwHnsYo9xKIcUJN5LeDKdJ6R1Z1j9V/J5wyq8nh/mYPEpIKJbBZXtZjG04HiK7zV/p6Vs9952MrMeUIw==",
      "deprecated": "This package is no longer supported.",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "delegates": "^1.0.0",
        "readable-stream": "^3.6.0"
      },
      "engines": {
        "node": ">=10"
      }
    },
    "node_modules/arg": {
      "version": "4.1.3",
      "resolved": "https://registry.npmjs.org/arg/-/arg-4.1.3.tgz",
      "integrity": "sha512-58S9QDqG0Xx27YwPSt9fJxivjYl432YCwfDMfZ+71RAqUrZef7LrKQZ3LHLOwCS4FLNBplP533Zx895SeOCHvA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/array-flatten": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz",
      "integrity": "sha512-PCVAQswWemu6UdxsDFFX/+gVeYqKAod3D3UVm91jHwynguOwAvYPhx8nNlM++NqRcK6CxxpUafjmhIdKiHibqg==",
      "license": "MIT"
    },
    "node_modules/async-listen": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/async-listen/-/async-listen-3.0.0.tgz",
      "integrity": "sha512-V+SsTpDqkrWTimiotsyl33ePSjA5/KrithwupuvJ6ztsqPvGv6ge4OredFhPffVXiLN/QUWvE0XcqJaYgt6fOg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 14"
      }
    },
    "node_modules/async-sema": {
      "version": "3.1.1",
      "resolved": "https://registry.npmjs.org/async-sema/-/async-sema-3.1.1.tgz",
      "integrity": "sha512-tLRNUXati5MFePdAk8dw7Qt7DpxPB60ofAgn8WRhW6a2rcimZnYBP9oxHiv0OHy+Wz7kPMG+t4LGdt31+4EmGg==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/balanced-match": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz",
      "integrity": "sha512-3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/bindings": {
      "version": "1.5.0",
      "resolved": "https://registry.npmjs.org/bindings/-/bindings-1.5.0.tgz",
      "integrity": "sha512-p2q/t/mhvuOj/UeLlV6566GD/guowlr0hHxClI0W9m7MWYkL1F0hLo+0Aexs9HSPCtR1SXQ0TD3MMKrXZajbiQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "file-uri-to-path": "1.0.0"
      }
    },
    "node_modules/body-parser": {
      "version": "1.20.5",
      "resolved": "https://registry.npmjs.org/body-parser/-/body-parser-1.20.5.tgz",
      "integrity": "sha512-3grm+/2tUOvu2cjJkvsIxrv/wVpfXQW4PsQHYm7yk4vfpu7Ekl6nEsYBoJUL6qDwZUx8wUhQ8tR2qz+ad9c9OA==",
      "license": "MIT",
      "dependencies": {
        "bytes": "~3.1.2",
        "content-type": "~1.0.5",
        "debug": "2.6.9",
        "depd": "2.0.0",
        "destroy": "~1.2.0",
        "http-errors": "~2.0.1",
        "iconv-lite": "~0.4.24",
        "on-finished": "~2.4.1",
        "qs": "~6.15.1",
        "raw-body": "~2.5.3",
        "type-is": "~1.6.18",
        "unpipe": "~1.0.0"
      },
      "engines": {
        "node": ">= 0.8",
        "npm": "1.2.8000 || >= 1.4.16"
      }
    },
    "node_modules/body-parser/node_modules/qs": {
      "version": "6.15.1",
      "resolved": "https://registry.npmjs.org/qs/-/qs-6.15.1.tgz",
      "integrity": "sha512-6YHEFRL9mfgcAvql/XhwTvf5jKcOiiupt2FiJxHkiX1z4j7WL8J/jRHYLluORvc1XxB5rV20KoeK00gVJamspg==",
      "license": "BSD-3-Clause",
      "dependencies": {
        "side-channel": "^1.1.0"
      },
      "engines": {
        "node": ">=0.6"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/brace-expansion": {
      "version": "1.1.14",
      "resolved": "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.14.tgz",
      "integrity": "sha512-MWPGfDxnyzKU7rNOW9SP/c50vi3xrmrua/+6hfPbCS2ABNWfx24vPidzvC7krjU/RTo235sV776ymlsMtGKj8g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "balanced-match": "^1.0.0",
        "concat-map": "0.0.1"
      }
    },
    "node_modules/braces": {
      "version": "3.0.3",
      "resolved": "https://registry.npmjs.org/braces/-/braces-3.0.3.tgz",
      "integrity": "sha512-yQbXgO/OSZVD2IsiLlro+7Hf6Q18EJrKSEsdoMzKePKXct3gvD8oLcOQdIzGupr5Fj+EDe8gO/lxc1BzfMpxvA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "fill-range": "^7.1.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/bytes": {
      "version": "3.1.2",
      "resolved": "https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz",
      "integrity": "sha512-/Nf7TyzTx6S3yRJObOAV7956r8cr2+Oj8AC5dt8wSP3BQAoeX58NoHyCU8P8zGkNXStjTSi6fzO6F0pBdcYbEg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/call-bind-apply-helpers": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/call-bind-apply-helpers/-/call-bind-apply-helpers-1.0.2.tgz",
      "integrity": "sha512-Sp1ablJ0ivDkSzjcaJdxEunN5/XvksFJ2sMBFfq6x0ryhQV/2b/KwFe21cMpmHtPOSij8K99/wSfoEuTObmuMQ==",
      "license": "MIT",
      "dependencies": {
        "es-errors": "^1.3.0",
        "function-bind": "^1.1.2"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/call-bound": {
      "version": "1.0.4",
      "resolved": "https://registry.npmjs.org/call-bound/-/call-bound-1.0.4.tgz",
      "integrity": "sha512-+ys997U96po4Kx/ABpBCqhA9EuxJaQWDQg7295H4hBphv3IZg0boBKuwYpt4YXp6MZ5AmZQnU/tyMTlRpaSejg==",
      "license": "MIT",
      "dependencies": {
        "call-bind-apply-helpers": "^1.0.2",
        "get-intrinsic": "^1.3.0"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/chownr": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/chownr/-/chownr-2.0.0.tgz",
      "integrity": "sha512-bIomtDF5KGpdogkLd9VspvFzk9KfpyyGlS8YFVZl7TGPBHL5snIOnxeshwVgPteQ9b4Eydl+pVbIyE1DcvCWgQ==",
      "dev": true,
      "license": "ISC",
      "engines": {
        "node": ">=10"
      }
    },
    "node_modules/cjs-module-lexer": {
      "version": "1.2.3",
      "resolved": "https://registry.npmjs.org/cjs-module-lexer/-/cjs-module-lexer-1.2.3.tgz",
      "integrity": "sha512-0TNiGstbQmCFwt4akjjBg5pLRTSyj/PkWQ1ZoO2zntmg9yLqSRxwEa4iCfQLGjqhiqBfOJa7W/E8wfGrTDmlZQ==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/code-block-writer": {
      "version": "10.1.1",
      "resolved": "https://registry.npmjs.org/code-block-writer/-/code-block-writer-10.1.1.tgz",
      "integrity": "sha512-67ueh2IRGst/51p0n6FvPrnRjAGHY5F8xdjkgrYE7DDzpJe6qA07RYQ9VcoUeo5ATOjSOiWpSL3SWBRRbempMw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/color-support": {
      "version": "1.1.3",
      "resolved": "https://registry.npmjs.org/color-support/-/color-support-1.1.3.tgz",
      "integrity": "sha512-qiBjkpbMLO/HL68y+lh4q0/O1MZFj2RX6X/KmMa3+gJD3z+WwI1ZzDHysvqHGS3mP6mznPckpXmw1nI9cJjyRg==",
      "dev": true,
      "license": "ISC",
      "bin": {
        "color-support": "bin.js"
      }
    },
    "node_modules/concat-map": {
      "version": "0.0.1",
      "resolved": "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz",
      "integrity": "sha512-/Srv4dswyQNBfohGpz9o6Yb3Gz3SrUDqBH5rTuhGR7ahtlbYKnVxw2bCFMRljaA7EXHaXZ8wsHdodFvbkhKmqg==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/console-control-strings": {
      "version": "1.1.0",
      "resolved": "https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz",
      "integrity": "sha512-ty/fTekppD2fIwRvnZAVdeOiGd1c7YXEixbgJTNzqcxJWKQnjJ/V1bNEEE6hygpM3WjwHFUVK6HTjWSzV4a8sQ==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/content-disposition": {
      "version": "0.5.4",
      "resolved": "https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.4.tgz",
      "integrity": "sha512-FveZTNuGw04cxlAiWbzi6zTAL/lhehaWbTtgluJh4/E95DqMwTmha3KZN1aAWA8cFIhHzMZUvLevkw5Rqk+tSQ==",
      "license": "MIT",
      "dependencies": {
        "safe-buffer": "5.2.1"
      },
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/content-type": {
      "version": "1.0.5",
      "resolved": "https://registry.npmjs.org/content-type/-/content-type-1.0.5.tgz",
      "integrity": "sha512-nTjqfcBFEipKdXCv4YDQWCfmcLZKm81ldF0pAopTvyrFGVbcR6P/VAAd5G7N+0tTr8QqiU0tFadD6FK4NtJwOA==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/convert-hrtime": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/convert-hrtime/-/convert-hrtime-3.0.0.tgz",
      "integrity": "sha512-7V+KqSvMiHp8yWDuwfww06XleMWVVB9b9tURBx+G7UTADuo5hYPuowKloz4OzOqbPezxgo+fdQ1522WzPG4OeA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/cookie": {
      "version": "0.7.2",
      "resolved": "https://registry.npmjs.org/cookie/-/cookie-0.7.2.tgz",
      "integrity": "sha512-yki5XnKuf750l50uGTllt6kKILY4nQ1eNIQatoXEByZ5dWgnKqbnqmTrBE5B4N7lrMJKQ2ytWMiTO2o0v6Ew/w==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/cookie-signature": {
      "version": "1.0.7",
      "resolved": "https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.7.tgz",
      "integrity": "sha512-NXdYc3dLr47pBkpUCHtKSwIOQXLVn8dZEuywboCOJY/osA0wFSLlSawr3KN8qXJEyX66FcONTH8EIlVuK0yyFA==",
      "license": "MIT"
    },
    "node_modules/cors": {
      "version": "2.8.6",
      "resolved": "https://registry.npmjs.org/cors/-/cors-2.8.6.tgz",
      "integrity": "sha512-tJtZBBHA6vjIAaF6EnIaq6laBBP9aq/Y3ouVJjEfoHbRBcHBAHYcMh/w8LDrk2PvIMMq8gmopa5D4V8RmbrxGw==",
      "license": "MIT",
      "dependencies": {
        "object-assign": "^4",
        "vary": "^1"
      },
      "engines": {
        "node": ">= 0.10"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/express"
      }
    },
    "node_modules/create-require": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/create-require/-/create-require-1.1.1.tgz",
      "integrity": "sha512-dcKFX3jn0MpIaXjisoRvexIJVEKzaq7z2rZKxf+MSr9TkdmHmsU4m2lcLojrj/FHl8mk5VxMmYA+ftRkP/3oKQ==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/debug": {
      "version": "2.6.9",
      "resolved": "https://registry.npmjs.org/debug/-/debug-2.6.9.tgz",
      "integrity": "sha512-bC7ElrdJaJnPbAP+1EotYvqZsb3ecl5wi6Bfi6BJTUcNowp6cvspg0jXznRTKDjm/E7AdgFBVeAPVMNcKGsHMA==",
      "license": "MIT",
      "dependencies": {
        "ms": "2.0.0"
      }
    },
    "node_modules/delegates": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz",
      "integrity": "sha512-bd2L678uiWATM6m5Z1VzNCErI3jiGzt6HGY8OVICs40JQq/HALfbyNJmp0UDakEY4pMMaN0Ly5om/B1VI/+xfQ==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/depd": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/depd/-/depd-2.0.0.tgz",
      "integrity": "sha512-g7nH6P6dyDioJogAAGprGpCtVImJhpPk/roCzdb3fIh61/s/nPsfR6onyMwkCAR/OlC3yBC0lESvUoQEAssIrw==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/destroy": {
      "version": "1.2.0",
      "resolved": "https://registry.npmjs.org/destroy/-/destroy-1.2.0.tgz",
      "integrity": "sha512-2sJGJTaXIIaR1w4iJSNoN0hnMY7Gpc/n8D4qSCJw8QqFWXf7cuAgnEHxBpweaVcPevC2l3KpjYCx3NypQQgaJg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.8",
        "npm": "1.2.8000 || >= 1.4.16"
      }
    },
    "node_modules/detect-libc": {
      "version": "2.1.2",
      "resolved": "https://registry.npmjs.org/detect-libc/-/detect-libc-2.1.2.tgz",
      "integrity": "sha512-Btj2BOOO83o3WyH59e8MgXsxEQVcarkUOpEYrubB0urwnN10yQ364rsiByU11nZlqWYZm05i/of7io4mzihBtQ==",
      "dev": true,
      "license": "Apache-2.0",
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/diff": {
      "version": "4.0.4",
      "resolved": "https://registry.npmjs.org/diff/-/diff-4.0.4.tgz",
      "integrity": "sha512-X07nttJQkwkfKfvTPG/KSnE2OMdcUCao6+eXF3wmnIQRn2aPAHH3VxDbDOdegkd6JbPsXqShpvEOHfAT+nCNwQ==",
      "dev": true,
      "license": "BSD-3-Clause",
      "engines": {
        "node": ">=0.3.1"
      }
    },
    "node_modules/dotenv": {
      "version": "17.4.2",
      "resolved": "https://registry.npmjs.org/dotenv/-/dotenv-17.4.2.tgz",
      "integrity": "sha512-nI4U3TottKAcAD9LLud4Cb7b2QztQMUEfHbvhTH09bqXTxnSie8WnjPALV/WMCrJZ6UV/qHJ6L03OqO3LcdYZw==",
      "license": "BSD-2-Clause",
      "engines": {
        "node": ">=12"
      },
      "funding": {
        "url": "https://dotenvx.com"
      }
    },
    "node_modules/dunder-proto": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/dunder-proto/-/dunder-proto-1.0.1.tgz",
      "integrity": "sha512-KIN/nDJBQRcXw0MLVhZE9iQHmG68qAVIBg9CqmUYjmQIhgij9U5MFvrqkUL5FbtyyzZuOeOt0zdeRe4UY7ct+A==",
      "license": "MIT",
      "dependencies": {
        "call-bind-apply-helpers": "^1.0.1",
        "es-errors": "^1.3.0",
        "gopd": "^1.2.0"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/edge-runtime": {
      "version": "2.5.9",
      "resolved": "https://registry.npmjs.org/edge-runtime/-/edge-runtime-2.5.9.tgz",
      "integrity": "sha512-pk+k0oK0PVXdlT4oRp4lwh+unuKB7Ng4iZ2HB+EZ7QCEQizX360Rp/F4aRpgpRgdP2ufB35N+1KppHmYjqIGSg==",
      "dev": true,
      "license": "MPL-2.0",
      "dependencies": {
        "@edge-runtime/format": "2.2.1",
        "@edge-runtime/ponyfill": "2.4.2",
        "@edge-runtime/vm": "3.2.0",
        "async-listen": "3.0.1",
        "mri": "1.2.0",
        "picocolors": "1.0.0",
        "pretty-ms": "7.0.1",
        "signal-exit": "4.0.2",
        "time-span": "4.0.0"
      },
      "bin": {
        "edge-runtime": "dist/cli/index.js"
      },
      "engines": {
        "node": ">=16"
      }
    },
    "node_modules/edge-runtime/node_modules/async-listen": {
      "version": "3.0.1",
      "resolved": "https://registry.npmjs.org/async-listen/-/async-listen-3.0.1.tgz",
      "integrity": "sha512-cWMaNwUJnf37C/S5TfCkk/15MwbPRwVYALA2jtjkbHjCmAPiDXyNJy2q3p1KAZzDLHAWyarUWSujUoHR4pEgrA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 14"
      }
    },
    "node_modules/ee-first": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz",
      "integrity": "sha512-WMwm9LhRUo+WUaRN+vRuETqG89IgZphVSNkdFgeb6sS/E4OrDIN7t48CAewSHXc6C8lefD8KKfr5vY61brQlow==",
      "license": "MIT"
    },
    "node_modules/emoji-regex": {
      "version": "8.0.0",
      "resolved": "https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz",
      "integrity": "sha512-MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/encodeurl": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/encodeurl/-/encodeurl-2.0.0.tgz",
      "integrity": "sha512-Q0n9HRi4m6JuGIV1eFlmvJB7ZEVxu93IrMyiMsGC0lrMJMWzRgx6WGquyfQgZVb31vhGgXnfmPNNXmxnOkRBrg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/es-define-property": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.1.tgz",
      "integrity": "sha512-e3nRfgfUZ4rNGL232gUgX06QNyyez04KdjFrF+LTRoOXmrOgFKDg4BCdsjW8EnT69eqdYGmRpJwiPVYNrCaW3g==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/es-errors": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz",
      "integrity": "sha512-Zf5H2Kxt2xjTvbJvP2ZWLEICxA6j+hAmMzIlypy4xcBg1vKVnx89Wy0GbS+kf5cwCVFFzdCFh2XSCFNULS6csw==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/es-module-lexer": {
      "version": "1.4.1",
      "resolved": "https://registry.npmjs.org/es-module-lexer/-/es-module-lexer-1.4.1.tgz",
      "integrity": "sha512-cXLGjP0c4T3flZJKQSuziYoq7MlT+rnvfZjfp7h+I7K9BNX54kP9nyWvdbwjQ4u1iWbOL4u96fgeZLToQlZC7w==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/es-object-atoms": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.1.1.tgz",
      "integrity": "sha512-FGgH2h8zKNim9ljj7dankFPcICIK9Cp5bm+c2gQSYePhpaG5+esrLODihIorn+Pe6FGJzWhXQotPv73jTaldXA==",
      "license": "MIT",
      "dependencies": {
        "es-errors": "^1.3.0"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/esbuild": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild/-/esbuild-0.14.47.tgz",
      "integrity": "sha512-wI4ZiIfFxpkuxB8ju4MHrGwGLyp1+awEHAHVpx6w7a+1pmYIq8T9FGEVVwFo0iFierDoMj++Xq69GXWYn2EiwA==",
      "dev": true,
      "hasInstallScript": true,
      "license": "MIT",
      "bin": {
        "esbuild": "bin/esbuild"
      },
      "engines": {
        "node": ">=12"
      },
      "optionalDependencies": {
        "esbuild-android-64": "0.14.47",
        "esbuild-android-arm64": "0.14.47",
        "esbuild-darwin-64": "0.14.47",
        "esbuild-darwin-arm64": "0.14.47",
        "esbuild-freebsd-64": "0.14.47",
        "esbuild-freebsd-arm64": "0.14.47",
        "esbuild-linux-32": "0.14.47",
        "esbuild-linux-64": "0.14.47",
        "esbuild-linux-arm": "0.14.47",
        "esbuild-linux-arm64": "0.14.47",
        "esbuild-linux-mips64le": "0.14.47",
        "esbuild-linux-ppc64le": "0.14.47",
        "esbuild-linux-riscv64": "0.14.47",
        "esbuild-linux-s390x": "0.14.47",
        "esbuild-netbsd-64": "0.14.47",
        "esbuild-openbsd-64": "0.14.47",
        "esbuild-sunos-64": "0.14.47",
        "esbuild-windows-32": "0.14.47",
        "esbuild-windows-64": "0.14.47",
        "esbuild-windows-arm64": "0.14.47"
      }
    },
    "node_modules/esbuild-android-64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-android-64/-/esbuild-android-64-0.14.47.tgz",
      "integrity": "sha512-R13Bd9+tqLVFndncMHssZrPWe6/0Kpv2/dt4aA69soX4PRxlzsVpCvoJeFE8sOEoeVEiBkI0myjlkDodXlHa0g==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-android-arm64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-android-arm64/-/esbuild-android-arm64-0.14.47.tgz",
      "integrity": "sha512-OkwOjj7ts4lBp/TL6hdd8HftIzOy/pdtbrNA4+0oVWgGG64HrdVzAF5gxtJufAPOsEjkyh1oIYvKAUinKKQRSQ==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-darwin-64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-darwin-64/-/esbuild-darwin-64-0.14.47.tgz",
      "integrity": "sha512-R6oaW0y5/u6Eccti/TS6c/2c1xYTb1izwK3gajJwi4vIfNs1s8B1dQzI1UiC9T61YovOQVuePDcfqHLT3mUZJA==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-darwin-arm64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-darwin-arm64/-/esbuild-darwin-arm64-0.14.47.tgz",
      "integrity": "sha512-seCmearlQyvdvM/noz1L9+qblC5vcBrhUaOoLEDDoLInF/VQ9IkobGiLlyTPYP5dW1YD4LXhtBgOyevoIHGGnw==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-freebsd-64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-freebsd-64/-/esbuild-freebsd-64-0.14.47.tgz",
      "integrity": "sha512-ZH8K2Q8/Ux5kXXvQMDsJcxvkIwut69KVrYQhza/ptkW50DC089bCVrJZZ3sKzIoOx+YPTrmsZvqeZERjyYrlvQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "freebsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-freebsd-arm64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-freebsd-arm64/-/esbuild-freebsd-arm64-0.14.47.tgz",
      "integrity": "sha512-ZJMQAJQsIOhn3XTm7MPQfCzEu5b9STNC+s90zMWe2afy9EwnHV7Ov7ohEMv2lyWlc2pjqLW8QJnz2r0KZmeAEQ==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "freebsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-linux-32": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-linux-32/-/esbuild-linux-32-0.14.47.tgz",
      "integrity": "sha512-FxZOCKoEDPRYvq300lsWCTv1kcHgiiZfNrPtEhFAiqD7QZaXrad8LxyJ8fXGcWzIFzRiYZVtB3ttvITBvAFhKw==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-linux-64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-linux-64/-/esbuild-linux-64-0.14.47.tgz",
      "integrity": "sha512-nFNOk9vWVfvWYF9YNYksZptgQAdstnDCMtR6m42l5Wfugbzu11VpMCY9XrD4yFxvPo9zmzcoUL/88y0lfJZJJw==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-linux-arm": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-linux-arm/-/esbuild-linux-arm-0.14.47.tgz",
      "integrity": "sha512-ZGE1Bqg/gPRXrBpgpvH81tQHpiaGxa8c9Rx/XOylkIl2ypLuOcawXEAo8ls+5DFCcRGt/o3sV+PzpAFZobOsmA==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-linux-arm64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-linux-arm64/-/esbuild-linux-arm64-0.14.47.tgz",
      "integrity": "sha512-ywfme6HVrhWcevzmsufjd4iT3PxTfCX9HOdxA7Hd+/ZM23Y9nXeb+vG6AyA6jgq/JovkcqRHcL9XwRNpWG6XRw==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-linux-mips64le": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-linux-mips64le/-/esbuild-linux-mips64le-0.14.47.tgz",
      "integrity": "sha512-mg3D8YndZ1LvUiEdDYR3OsmeyAew4MA/dvaEJxvyygahWmpv1SlEEnhEZlhPokjsUMfRagzsEF/d/2XF+kTQGg==",
      "cpu": [
        "mips64el"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-linux-ppc64le": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-linux-ppc64le/-/esbuild-linux-ppc64le-0.14.47.tgz",
      "integrity": "sha512-WER+f3+szmnZiWoK6AsrTKGoJoErG2LlauSmk73LEZFQ/iWC+KhhDsOkn1xBUpzXWsxN9THmQFltLoaFEH8F8w==",
      "cpu": [
        "ppc64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-linux-riscv64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-linux-riscv64/-/esbuild-linux-riscv64-0.14.47.tgz",
      "integrity": "sha512-1fI6bP3A3rvI9BsaaXbMoaOjLE3lVkJtLxsgLHqlBhLlBVY7UqffWBvkrX/9zfPhhVMd9ZRFiaqXnB1T7BsL2g==",
      "cpu": [
        "riscv64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-linux-s390x": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-linux-s390x/-/esbuild-linux-s390x-0.14.47.tgz",
      "integrity": "sha512-eZrWzy0xFAhki1CWRGnhsHVz7IlSKX6yT2tj2Eg8lhAwlRE5E96Hsb0M1mPSE1dHGpt1QVwwVivXIAacF/G6mw==",
      "cpu": [
        "s390x"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-netbsd-64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-netbsd-64/-/esbuild-netbsd-64-0.14.47.tgz",
      "integrity": "sha512-Qjdjr+KQQVH5Q2Q1r6HBYswFTToPpss3gqCiSw2Fpq/ua8+eXSQyAMG+UvULPqXceOwpnPo4smyZyHdlkcPppQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "netbsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-openbsd-64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-openbsd-64/-/esbuild-openbsd-64-0.14.47.tgz",
      "integrity": "sha512-QpgN8ofL7B9z8g5zZqJE+eFvD1LehRlxr25PBkjyyasakm4599iroUpaj96rdqRlO2ShuyqwJdr+oNqWwTUmQw==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "openbsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-sunos-64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-sunos-64/-/esbuild-sunos-64-0.14.47.tgz",
      "integrity": "sha512-uOeSgLUwukLioAJOiGYm3kNl+1wJjgJA8R671GYgcPgCx7QR73zfvYqXFFcIO93/nBdIbt5hd8RItqbbf3HtAQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "sunos"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-windows-32": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-windows-32/-/esbuild-windows-32-0.14.47.tgz",
      "integrity": "sha512-H0fWsLTp2WBfKLBgwYT4OTfFly4Im/8B5f3ojDv1Kx//kiubVY0IQunP2Koc/fr/0wI7hj3IiBDbSrmKlrNgLQ==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-windows-64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-windows-64/-/esbuild-windows-64-0.14.47.tgz",
      "integrity": "sha512-/Pk5jIEH34T68r8PweKRi77W49KwanZ8X6lr3vDAtOlH5EumPE4pBHqkCUdELanvsT14yMXLQ/C/8XPi1pAtkQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/esbuild-windows-arm64": {
      "version": "0.14.47",
      "resolved": "https://registry.npmjs.org/esbuild-windows-arm64/-/esbuild-windows-arm64-0.14.47.tgz",
      "integrity": "sha512-HFSW2lnp62fl86/qPQlqw6asIwCnEsEoNIL1h2uVMgakddf+vUuMcCbtUY1i8sst7KkgHrVKCJQB33YhhOweCQ==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/escape-html": {
      "version": "1.0.3",
      "resolved": "https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz",
      "integrity": "sha512-NiSupZ4OeuGwr68lGIeym/ksIZMJodUGOSCZ/FSnTxcrekbvqrgdUxlJOMpijaKZVjAJrWrGs/6Jy8OMuyj9ow==",
      "license": "MIT"
    },
    "node_modules/estree-walker": {
      "version": "2.0.2",
      "resolved": "https://registry.npmjs.org/estree-walker/-/estree-walker-2.0.2.tgz",
      "integrity": "sha512-Rfkk/Mp/DL7JVje3u18FxFujQlTNR2q6QfMSMB7AvCBx91NGj/ba3kCfza0f6dVDbw7YlRf/nDrn7pQrCCyQ/w==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/etag": {
      "version": "1.8.1",
      "resolved": "https://registry.npmjs.org/etag/-/etag-1.8.1.tgz",
      "integrity": "sha512-aIL5Fx7mawVa300al2BnEE4iNvo1qETxLrPI/o05L7z6go7fCw1J6EQmbK4FmJ2AS7kgVF/KEZWufBfdClMcPg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/express": {
      "version": "4.22.1",
      "resolved": "https://registry.npmjs.org/express/-/express-4.22.1.tgz",
      "integrity": "sha512-F2X8g9P1X7uCPZMA3MVf9wcTqlyNp7IhH5qPCI0izhaOIYXaW9L535tGA3qmjRzpH+bZczqq7hVKxTR4NWnu+g==",
      "license": "MIT",
      "dependencies": {
        "accepts": "~1.3.8",
        "array-flatten": "1.1.1",
        "body-parser": "~1.20.3",
        "content-disposition": "~0.5.4",
        "content-type": "~1.0.4",
        "cookie": "~0.7.1",
        "cookie-signature": "~1.0.6",
        "debug": "2.6.9",
        "depd": "2.0.0",
        "encodeurl": "~2.0.0",
        "escape-html": "~1.0.3",
        "etag": "~1.8.1",
        "finalhandler": "~1.3.1",
        "fresh": "~0.5.2",
        "http-errors": "~2.0.0",
        "merge-descriptors": "1.0.3",
        "methods": "~1.1.2",
        "on-finished": "~2.4.1",
        "parseurl": "~1.3.3",
        "path-to-regexp": "~0.1.12",
        "proxy-addr": "~2.0.7",
        "qs": "~6.14.0",
        "range-parser": "~1.2.1",
        "safe-buffer": "5.2.1",
        "send": "~0.19.0",
        "serve-static": "~1.16.2",
        "setprototypeof": "1.2.0",
        "statuses": "~2.0.1",
        "type-is": "~1.6.18",
        "utils-merge": "1.0.1",
        "vary": "~1.1.2"
      },
      "engines": {
        "node": ">= 0.10.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/express"
      }
    },
    "node_modules/express/node_modules/path-to-regexp": {
      "version": "0.1.13",
      "resolved": "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.13.tgz",
      "integrity": "sha512-A/AGNMFN3c8bOlvV9RreMdrv7jsmF9XIfDeCd87+I8RNg6s78BhJxMu69NEMHBSJFxKidViTEdruRwEk/WIKqA==",
      "license": "MIT"
    },
    "node_modules/fast-deep-equal": {
      "version": "3.1.3",
      "resolved": "https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz",
      "integrity": "sha512-f3qQ9oQy9j2AhBe/H9VC91wLmKBCCU/gDOnKNAYG5hswO7BLKj09Hc5HYNz9cGI++xlpDCIgDaitVs03ATR84Q==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/fast-glob": {
      "version": "3.3.3",
      "resolved": "https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.3.tgz",
      "integrity": "sha512-7MptL8U0cqcFdzIzwOTHoilX9x5BrNqye7Z/LuC7kCMRio1EMSyqRK3BEAUD7sXRq4iT4AzTVuZdhgQ2TCvYLg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@nodelib/fs.stat": "^2.0.2",
        "@nodelib/fs.walk": "^1.2.3",
        "glob-parent": "^5.1.2",
        "merge2": "^1.3.0",
        "micromatch": "^4.0.8"
      },
      "engines": {
        "node": ">=8.6.0"
      }
    },
    "node_modules/fastq": {
      "version": "1.20.1",
      "resolved": "https://registry.npmjs.org/fastq/-/fastq-1.20.1.tgz",
      "integrity": "sha512-GGToxJ/w1x32s/D2EKND7kTil4n8OVk/9mycTc4VDza13lOvpUZTGX3mFSCtV9ksdGBVzvsyAVLM6mHFThxXxw==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "reusify": "^1.0.4"
      }
    },
    "node_modules/file-uri-to-path": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/file-uri-to-path/-/file-uri-to-path-1.0.0.tgz",
      "integrity": "sha512-0Zt+s3L7Vf1biwWZ29aARiVYLx7iMGnEUl9x33fbB/j3jR81u/O2LbqK+Bm1CDSNDKVtJ/YjwY7TUd5SkeLQLw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/fill-range": {
      "version": "7.1.1",
      "resolved": "https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz",
      "integrity": "sha512-YsGpe3WHLK8ZYi4tWDg2Jy3ebRz2rXowDxnld4bkQB00cc/1Zw9AWnC0i9ztDJitivtQvaI9KaLyKrc+hBW0yg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "to-regex-range": "^5.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/finalhandler": {
      "version": "1.3.2",
      "resolved": "https://registry.npmjs.org/finalhandler/-/finalhandler-1.3.2.tgz",
      "integrity": "sha512-aA4RyPcd3badbdABGDuTXCMTtOneUCAYH/gxoYRTZlIJdF0YPWuGqiAsIrhNnnqdXGswYk6dGujem4w80UJFhg==",
      "license": "MIT",
      "dependencies": {
        "debug": "2.6.9",
        "encodeurl": "~2.0.0",
        "escape-html": "~1.0.3",
        "on-finished": "~2.4.1",
        "parseurl": "~1.3.3",
        "statuses": "~2.0.2",
        "unpipe": "~1.0.0"
      },
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/forwarded": {
      "version": "0.2.0",
      "resolved": "https://registry.npmjs.org/forwarded/-/forwarded-0.2.0.tgz",
      "integrity": "sha512-buRG0fpBtRHSTCOASe6hD258tEubFoRLb4ZNA6NxMVHNw2gOcwHo9wyablzMzOA5z9xA9L1KNjk/Nt6MT9aYow==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/fresh": {
      "version": "0.5.2",
      "resolved": "https://registry.npmjs.org/fresh/-/fresh-0.5.2.tgz",
      "integrity": "sha512-zJ2mQYM18rEFOudeV4GShTGIQ7RbzA7ozbU9I/XBpm7kqgMywgmylMwXHxZJmkVoYkna9d2pVXVXPdYTP9ej8Q==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/fs-minipass": {
      "version": "2.1.0",
      "resolved": "https://registry.npmjs.org/fs-minipass/-/fs-minipass-2.1.0.tgz",
      "integrity": "sha512-V/JgOLFCS+R6Vcq0slCuaeWEdNC3ouDlJMNIsacH2VtALiu9mV4LPrHc5cDl8k5aw6J8jwgWWpiTo5RYhmIzvg==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "minipass": "^3.0.0"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/fs-minipass/node_modules/minipass": {
      "version": "3.3.6",
      "resolved": "https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz",
      "integrity": "sha512-DxiNidxSEK+tHG6zOIklvNOwm3hvCrbUrdtzY74U6HKTJxvIDfOUL5W5P2Ghd3DTkhhKPYGqeNUIh5qcM4YBfw==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "yallist": "^4.0.0"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/fs.realpath": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz",
      "integrity": "sha512-OO0pH2lK6a0hZnAdau5ItzHPI6pUlvI7jMVnxUQRtw4owF2wk8lOSabtGDCTP4Ggrg2MbGnWO9X8K1t4+fGMDw==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/fsevents": {
      "version": "2.3.3",
      "resolved": "https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz",
      "integrity": "sha512-5xoDfX+fL7faATnagmWPpbFtwh/R77WmMMqqHGS65C3vvB0YHrgF+B1YmZ3441tMj5n63k0212XNoJwzlhffQw==",
      "dev": true,
      "hasInstallScript": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": "^8.16.0 || ^10.6.0 || >=11.0.0"
      }
    },
    "node_modules/function-bind": {
      "version": "1.1.2",
      "resolved": "https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz",
      "integrity": "sha512-7XHNxH7qX9xG5mIwxkhumTox/MIRNcOgDrxWsMt2pAr23WHp6MrRlN7FBSFpCpr+oVO0F744iUgR82nJMfG2SA==",
      "license": "MIT",
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/gauge": {
      "version": "3.0.2",
      "resolved": "https://registry.npmjs.org/gauge/-/gauge-3.0.2.tgz",
      "integrity": "sha512-+5J6MS/5XksCuXq++uFRsnUd7Ovu1XenbeuIuNRJxYWjgQbPuFhT14lAvsWfqfAmnwluf1OwMjz39HjfLPci0Q==",
      "deprecated": "This package is no longer supported.",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "aproba": "^1.0.3 || ^2.0.0",
        "color-support": "^1.1.2",
        "console-control-strings": "^1.0.0",
        "has-unicode": "^2.0.1",
        "object-assign": "^4.1.1",
        "signal-exit": "^3.0.0",
        "string-width": "^4.2.3",
        "strip-ansi": "^6.0.1",
        "wide-align": "^1.1.2"
      },
      "engines": {
        "node": ">=10"
      }
    },
    "node_modules/gauge/node_modules/signal-exit": {
      "version": "3.0.7",
      "resolved": "https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz",
      "integrity": "sha512-wnD2ZE+l+SPC/uoS0vXeE9L1+0wuaMqKlfz9AMUo38JsyLSBWSFcHR1Rri62LZc12vLr1gb3jl7iwQhgwpAbGQ==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/get-intrinsic": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.3.0.tgz",
      "integrity": "sha512-9fSjSaos/fRIVIp+xSJlE6lfwhES7LNtKaCBIamHsjr2na1BiABJPo0mOjjz8GJDURarmCPGqaiVg5mfjb98CQ==",
      "license": "MIT",
      "dependencies": {
        "call-bind-apply-helpers": "^1.0.2",
        "es-define-property": "^1.0.1",
        "es-errors": "^1.3.0",
        "es-object-atoms": "^1.1.1",
        "function-bind": "^1.1.2",
        "get-proto": "^1.0.1",
        "gopd": "^1.2.0",
        "has-symbols": "^1.1.0",
        "hasown": "^2.0.2",
        "math-intrinsics": "^1.1.0"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/get-proto": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/get-proto/-/get-proto-1.0.1.tgz",
      "integrity": "sha512-sTSfBjoXBp89JvIKIefqw7U2CCebsc74kiY6awiGogKtoSGbgjYE/G/+l9sF3MWFPNc9IcoOC4ODfKHfxFmp0g==",
      "license": "MIT",
      "dependencies": {
        "dunder-proto": "^1.0.1",
        "es-object-atoms": "^1.0.0"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/get-tsconfig": {
      "version": "4.14.0",
      "resolved": "https://registry.npmjs.org/get-tsconfig/-/get-tsconfig-4.14.0.tgz",
      "integrity": "sha512-yTb+8DXzDREzgvYmh6s9vHsSVCHeC0G3PI5bEXNBHtmshPnO+S5O7qgLEOn0I5QvMy6kpZN8K1NKGyilLb93wA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "resolve-pkg-maps": "^1.0.0"
      },
      "funding": {
        "url": "https://github.com/privatenumber/get-tsconfig?sponsor=1"
      }
    },
    "node_modules/glob": {
      "version": "7.2.3",
      "resolved": "https://registry.npmjs.org/glob/-/glob-7.2.3.tgz",
      "integrity": "sha512-nFR0zLpU2YCaRxwoCJvL6UvCH2JFyFVIvwTLsIf21AuHlMskA1hhTdk+LlYJtOlYt9v6dvszD2BGRqBL+iQK9Q==",
      "deprecated": "Old versions of glob are not supported, and contain widely publicized security vulnerabilities, which have been fixed in the current version. Please update. Support for old versions may be purchased (at exorbitant rates) by contacting i@izs.me",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "fs.realpath": "^1.0.0",
        "inflight": "^1.0.4",
        "inherits": "2",
        "minimatch": "^3.1.1",
        "once": "^1.3.0",
        "path-is-absolute": "^1.0.0"
      },
      "engines": {
        "node": "*"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/glob-parent": {
      "version": "5.1.2",
      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
      "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "is-glob": "^4.0.1"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/gopd": {
      "version": "1.2.0",
      "resolved": "https://registry.npmjs.org/gopd/-/gopd-1.2.0.tgz",
      "integrity": "sha512-ZUKRh6/kUFoAiTAtTYPZJ3hw9wNxx+BIBOijnlG9PnrJsCcSjs1wyyD6vJpaYtgnzDrKYRSqf3OO6Rfa93xsRg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/graceful-fs": {
      "version": "4.2.11",
      "resolved": "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz",
      "integrity": "sha512-RbJ5/jmFcNNCcDV5o9eTnBLJ/HszWV0P73bc+Ff4nS/rJj+YaS6IGyiOL0VoBYX+l1Wrl3k63h/KrH+nhJ0XvQ==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/has-symbols": {
      "version": "1.1.0",
      "resolved": "https://registry.npmjs.org/has-symbols/-/has-symbols-1.1.0.tgz",
      "integrity": "sha512-1cDNdwJ2Jaohmb3sg4OmKaMBwuC48sYni5HUw2DvsC8LjGTLK9h+eb1X6RyuOHe4hT0ULCW68iomhjUoKUqlPQ==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/has-unicode": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz",
      "integrity": "sha512-8Rf9Y83NBReMnx0gFzA8JImQACstCYWUplepDa9xprwwtmgEZUF0h/i5xSA625zB/I37EtrswSST6OXxwaaIJQ==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/hasown": {
      "version": "2.0.3",
      "resolved": "https://registry.npmjs.org/hasown/-/hasown-2.0.3.tgz",
      "integrity": "sha512-ej4AhfhfL2Q2zpMmLo7U1Uv9+PyhIZpgQLGT1F9miIGmiCJIoCgSmczFdrc97mWT4kVY72KA+WnnhJ5pghSvSg==",
      "license": "MIT",
      "dependencies": {
        "function-bind": "^1.1.2"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/http-errors": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/http-errors/-/http-errors-2.0.1.tgz",
      "integrity": "sha512-4FbRdAX+bSdmo4AUFuS0WNiPz8NgFt+r8ThgNWmlrjQjt1Q7ZR9+zTlce2859x4KSXrwIsaeTqDoKQmtP8pLmQ==",
      "license": "MIT",
      "dependencies": {
        "depd": "~2.0.0",
        "inherits": "~2.0.4",
        "setprototypeof": "~1.2.0",
        "statuses": "~2.0.2",
        "toidentifier": "~1.0.1"
      },
      "engines": {
        "node": ">= 0.8"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/express"
      }
    },
    "node_modules/https-proxy-agent": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-5.0.1.tgz",
      "integrity": "sha512-dFcAjpTQFgoLMzC2VwU+C/CbS7uRL0lWmxDITmqm7C+7F0Odmj6s9l6alZc6AELXhrnggM2CeWSXHGOdX2YtwA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "agent-base": "6",
        "debug": "4"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/https-proxy-agent/node_modules/debug": {
      "version": "4.4.3",
      "resolved": "https://registry.npmjs.org/debug/-/debug-4.4.3.tgz",
      "integrity": "sha512-RGwwWnwQvkVfavKVt22FGLw+xYSdzARwm0ru6DhTVA3umU5hZc28V3kO4stgYryrTlLpuvgI9GiijltAjNbcqA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "ms": "^2.1.3"
      },
      "engines": {
        "node": ">=6.0"
      },
      "peerDependenciesMeta": {
        "supports-color": {
          "optional": true
        }
      }
    },
    "node_modules/https-proxy-agent/node_modules/ms": {
      "version": "2.1.3",
      "resolved": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",
      "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/iceberg-js": {
      "version": "0.8.1",
      "resolved": "https://registry.npmjs.org/iceberg-js/-/iceberg-js-0.8.1.tgz",
      "integrity": "sha512-1dhVQZXhcHje7798IVM+xoo/1ZdVfzOMIc8/rgVSijRK38EDqOJoGula9N/8ZI5RD8QTxNQtK/Gozpr+qUqRRA==",
      "license": "MIT",
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/iconv-lite": {
      "version": "0.4.24",
      "resolved": "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.24.tgz",
      "integrity": "sha512-v3MXnZAcvnywkTUEZomIActle7RXXeedOR31wwl7VlyoXO4Qi9arvSenNQWne1TcRwhCL1HwLI21bEqdpj8/rA==",
      "license": "MIT",
      "dependencies": {
        "safer-buffer": ">= 2.1.2 < 3"
      },
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/inflight": {
      "version": "1.0.6",
      "resolved": "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz",
      "integrity": "sha512-k92I/b08q4wvFscXCLvqfsHCrjrF7yiXsQuIVvVE7N82W3+aqpzuUdBbfhWcy/FZR3/4IgflMgKLOsvPDrGCJA==",
      "deprecated": "This module is not supported, and leaks memory. Do not use it. Check out lru-cache if you want a good and tested way to coalesce async requests by a key value, which is much more comprehensive and powerful.",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "once": "^1.3.0",
        "wrappy": "1"
      }
    },
    "node_modules/inherits": {
      "version": "2.0.4",
      "resolved": "https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz",
      "integrity": "sha512-k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==",
      "license": "ISC"
    },
    "node_modules/ipaddr.js": {
      "version": "1.9.1",
      "resolved": "https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.9.1.tgz",
      "integrity": "sha512-0KI/607xoxSToH7GjN1FfSbLoU0+btTicjsQSWQlh/hZykN8KpmMf7uYwPW3R+akZ6R/w18ZlXSHBYXiYUPO3g==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.10"
      }
    },
    "node_modules/is-extglob": {
      "version": "2.1.1",
      "resolved": "https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz",
      "integrity": "sha512-SbKbANkN603Vi4jEZv49LeVJMn4yGwsbzZworEoyEiutsN3nJYdbO36zfhGJ6QEDpOZIFkDtnq5JRxmvl3jsoQ==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/is-fullwidth-code-point": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz",
      "integrity": "sha512-zymm5+u+sCsSWyD9qNaejV3DFvhCKclKdizYaJUuHA83RLjb7nSuGnddCHGv0hk+KY7BMAlsWeK4Ueg6EV6XQg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/is-glob": {
      "version": "4.0.3",
      "resolved": "https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz",
      "integrity": "sha512-xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "is-extglob": "^2.1.1"
      },
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/is-number": {
      "version": "7.0.0",
      "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
      "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.12.0"
      }
    },
    "node_modules/json-schema-to-ts": {
      "version": "1.6.4",
      "resolved": "https://registry.npmjs.org/json-schema-to-ts/-/json-schema-to-ts-1.6.4.tgz",
      "integrity": "sha512-pR4yQ9DHz6itqswtHCm26mw45FSNfQ9rEQjosaZErhn5J3J2sIViQiz8rDaezjKAhFGpmsoczYVBgGHzFw/stA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/json-schema": "^7.0.6",
        "ts-toolbelt": "^6.15.5"
      }
    },
    "node_modules/json-schema-traverse": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz",
      "integrity": "sha512-NM8/P9n3XjXhIZn1lLhkFaACTOURQXjWhV4BA/RnOv8xvgqtqpAX9IO4mRQxSx1Rlo4tqzeqb0sOlruaOy3dug==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/make-dir": {
      "version": "3.1.0",
      "resolved": "https://registry.npmjs.org/make-dir/-/make-dir-3.1.0.tgz",
      "integrity": "sha512-g3FeP20LNwhALb/6Cz6Dd4F2ngze0jz7tbzrD2wAV+o9FeNHe4rL+yK2md0J/fiSf1sa1ADhXqi5+oVwOM/eGw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "semver": "^6.0.0"
      },
      "engines": {
        "node": ">=8"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/make-dir/node_modules/semver": {
      "version": "6.3.1",
      "resolved": "https://registry.npmjs.org/semver/-/semver-6.3.1.tgz",
      "integrity": "sha512-BR7VvDCVHO+q2xBEWskxS6DJE1qRnb7DxzUrogb71CWoSficBxYsiAGd+Kl0mmq/MprG9yArRkyrQxTO6XjMzA==",
      "dev": true,
      "license": "ISC",
      "bin": {
        "semver": "bin/semver.js"
      }
    },
    "node_modules/make-error": {
      "version": "1.3.6",
      "resolved": "https://registry.npmjs.org/make-error/-/make-error-1.3.6.tgz",
      "integrity": "sha512-s8UhlNe7vPKomQhC1qFelMokr/Sc3AgNbso3n74mVPA5LTZwkB9NlXf4XPamLxJE8h0gh73rM94xvwRT2CVInw==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/math-intrinsics": {
      "version": "1.1.0",
      "resolved": "https://registry.npmjs.org/math-intrinsics/-/math-intrinsics-1.1.0.tgz",
      "integrity": "sha512-/IXtbwEk5HTPyEwyKX6hGkYXxM9nbj64B+ilVJnC/R6B0pH5G4V3b0pVbL7DBj4tkhBAppbQUlf6F6Xl9LHu1g==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/media-typer": {
      "version": "0.3.0",
      "resolved": "https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz",
      "integrity": "sha512-dq+qelQ9akHpcOl/gUVRTxVIOkAJ1wR3QAvb4RsVjS8oVoFjDGTc679wJYmUmknUF5HwMLOgb5O+a3KxfWapPQ==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/merge-descriptors": {
      "version": "1.0.3",
      "resolved": "https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.3.tgz",
      "integrity": "sha512-gaNvAS7TZ897/rVaZ0nMtAyxNyi/pdbjbAwUpFQpN70GqnVfOiXpeUUMKRBmzXaSQ8DdTX4/0ms62r2K+hE6mQ==",
      "license": "MIT",
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/merge2": {
      "version": "1.4.1",
      "resolved": "https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz",
      "integrity": "sha512-8q7VEgMJW4J8tcfVPy8g09NcQwZdbwFEqhe/WZkoIzjn/3TGDwtOCYtXGxA3O8tPzpczCCDgv+P2P5y00ZJOOg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/methods": {
      "version": "1.1.2",
      "resolved": "https://registry.npmjs.org/methods/-/methods-1.1.2.tgz",
      "integrity": "sha512-iclAHeNqNm68zFtnZ0e+1L2yUIdvzNoauKU4WBA3VvH/vPFieF7qfRlwUZU+DA9P9bPXIS90ulxoUoCH23sV2w==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/micromatch": {
      "version": "4.0.8",
      "resolved": "https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz",
      "integrity": "sha512-PXwfBhYu0hBCPw8Dn0E+WDYb7af3dSLVWKi3HGv84IdF4TyFoC0ysxFd0Goxw7nSv4T/PzEJQxsYsEiFCKo2BA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "braces": "^3.0.3",
        "picomatch": "^2.3.1"
      },
      "engines": {
        "node": ">=8.6"
      }
    },
    "node_modules/mime": {
      "version": "1.6.0",
      "resolved": "https://registry.npmjs.org/mime/-/mime-1.6.0.tgz",
      "integrity": "sha512-x0Vn8spI+wuJ1O6S7gnbaQg8Pxh4NNHb7KSINmEWKiPE4RKOplvijn+NkmYmmRgP68mc70j2EbeTFRsrswaQeg==",
      "license": "MIT",
      "bin": {
        "mime": "cli.js"
      },
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/mime-db": {
      "version": "1.52.0",
      "resolved": "https://registry.npmjs.org/mime-db/-/mime-db-1.52.0.tgz",
      "integrity": "sha512-sPU4uV7dYlvtWJxwwxHD0PuihVNiE7TyAbQ5SWxDCB9mUYvOgroQOwYQQOKPJ8CIbE+1ETVlOoK1UC2nU3gYvg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/mime-types": {
      "version": "2.1.35",
      "resolved": "https://registry.npmjs.org/mime-types/-/mime-types-2.1.35.tgz",
      "integrity": "sha512-ZDY+bPm5zTTF+YpCrAU9nK0UgICYPT0QtT1NZWFv4s++TNkcgVaT0g6+4R2uI4MjQjzysHB1zxuWL50hzaeXiw==",
      "license": "MIT",
      "dependencies": {
        "mime-db": "1.52.0"
      },
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/minimatch": {
      "version": "3.1.5",
      "resolved": "https://registry.npmjs.org/minimatch/-/minimatch-3.1.5.tgz",
      "integrity": "sha512-VgjWUsnnT6n+NUk6eZq77zeFdpW2LWDzP6zFGrCbHXiYNul5Dzqk2HHQ5uFH2DNW5Xbp8+jVzaeNt94ssEEl4w==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "brace-expansion": "^1.1.7"
      },
      "engines": {
        "node": "*"
      }
    },
    "node_modules/minipass": {
      "version": "5.0.0",
      "resolved": "https://registry.npmjs.org/minipass/-/minipass-5.0.0.tgz",
      "integrity": "sha512-3FnjYuehv9k6ovOEbyOswadCDPX1piCfhV8ncmYtHOjuPwylVWsghTLo7rabjC3Rx5xD4HDx8Wm1xnMF7S5qFQ==",
      "dev": true,
      "license": "ISC",
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/minizlib": {
      "version": "2.1.2",
      "resolved": "https://registry.npmjs.org/minizlib/-/minizlib-2.1.2.tgz",
      "integrity": "sha512-bAxsR8BVfj60DWXHE3u30oHzfl4G7khkSuPW+qvpd7jFRHm7dLxOjUk1EHACJ/hxLY8phGJ0YhYHZo7jil7Qdg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "minipass": "^3.0.0",
        "yallist": "^4.0.0"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/minizlib/node_modules/minipass": {
      "version": "3.3.6",
      "resolved": "https://registry.npmjs.org/minipass/-/minipass-3.3.6.tgz",
      "integrity": "sha512-DxiNidxSEK+tHG6zOIklvNOwm3hvCrbUrdtzY74U6HKTJxvIDfOUL5W5P2Ghd3DTkhhKPYGqeNUIh5qcM4YBfw==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "yallist": "^4.0.0"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/mkdirp": {
      "version": "1.0.4",
      "resolved": "https://registry.npmjs.org/mkdirp/-/mkdirp-1.0.4.tgz",
      "integrity": "sha512-vVqVZQyf3WLx2Shd0qJ9xuvqgAyKPLAiqITEtqW0oIUjzo3PePDd6fW9iFz30ef7Ysp/oiWqbhszeGWW2T6Gzw==",
      "dev": true,
      "license": "MIT",
      "bin": {
        "mkdirp": "bin/cmd.js"
      },
      "engines": {
        "node": ">=10"
      }
    },
    "node_modules/mri": {
      "version": "1.2.0",
      "resolved": "https://registry.npmjs.org/mri/-/mri-1.2.0.tgz",
      "integrity": "sha512-tzzskb3bG8LvYGFF/mDTpq3jpI6Q9wc3LEmBaghu+DdCssd1FakN7Bc0hVNmEyGq1bq3RgfkCb3cmQLpNPOroA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/ms": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/ms/-/ms-2.0.0.tgz",
      "integrity": "sha512-Tpp60P6IUJDTuOq/5Z8cdskzJujfwqfOTkrwIwj7IRISpnkJnT6SyJ4PCPnGMoFjC9ddhal5KVIYtAt97ix05A==",
      "license": "MIT"
    },
    "node_modules/negotiator": {
      "version": "0.6.3",
      "resolved": "https://registry.npmjs.org/negotiator/-/negotiator-0.6.3.tgz",
      "integrity": "sha512-+EUsqGPLsM+j/zdChZjsnX51g4XrHFOIXwfnCVPGlQk/k5giakcKsuxCObBRu6DSm9opw/O6slWbJdghQM4bBg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/node-fetch": {
      "version": "2.7.0",
      "resolved": "https://registry.npmjs.org/node-fetch/-/node-fetch-2.7.0.tgz",
      "integrity": "sha512-c4FRfUm/dbcWZ7U+1Wq0AwCyFL+3nt2bEw05wfxSz+DWpWsitgmSgYmy2dQdWyKC1694ELPqMs/YzUSNozLt8A==",
      "license": "MIT",
      "dependencies": {
        "whatwg-url": "^5.0.0"
      },
      "engines": {
        "node": "4.x || >=6.0.0"
      },
      "peerDependencies": {
        "encoding": "^0.1.0"
      },
      "peerDependenciesMeta": {
        "encoding": {
          "optional": true
        }
      }
    },
    "node_modules/node-gyp-build": {
      "version": "4.8.4",
      "resolved": "https://registry.npmjs.org/node-gyp-build/-/node-gyp-build-4.8.4.tgz",
      "integrity": "sha512-LA4ZjwlnUblHVgq0oBF3Jl/6h/Nvs5fzBLwdEF4nuxnFdsfajde4WfxtJr3CaiH+F6ewcIB/q4jQ4UzPyid+CQ==",
      "dev": true,
      "license": "MIT",
      "bin": {
        "node-gyp-build": "bin.js",
        "node-gyp-build-optional": "optional.js",
        "node-gyp-build-test": "build-test.js"
      }
    },
    "node_modules/nopt": {
      "version": "5.0.0",
      "resolved": "https://registry.npmjs.org/nopt/-/nopt-5.0.0.tgz",
      "integrity": "sha512-Tbj67rffqceeLpcRXrT7vKAN8CwfPeIBgM7E6iBkmKLV7bEMwpGgYLGv0jACUsECaa/vuxP0IjEont6umdMgtQ==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "abbrev": "1"
      },
      "bin": {
        "nopt": "bin/nopt.js"
      },
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/npmlog": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/npmlog/-/npmlog-5.0.1.tgz",
      "integrity": "sha512-AqZtDUWOMKs1G/8lwylVjrdYgqA4d9nu8hc+0gzRxlDb1I10+FHBGMXs6aiQHFdCUUlqH99MUMuLfzWDNDtfxw==",
      "deprecated": "This package is no longer supported.",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "are-we-there-yet": "^2.0.0",
        "console-control-strings": "^1.1.0",
        "gauge": "^3.0.0",
        "set-blocking": "^2.0.0"
      }
    },
    "node_modules/object-assign": {
      "version": "4.1.1",
      "resolved": "https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz",
      "integrity": "sha512-rJgTQnkUnH1sFw8yT6VSU3zD3sWmu6sZhIseY8VX+GRu3P6F7Fu+JNDoXfklElbLJSnc3FUQHVe4cU5hj+BcUg==",
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/object-inspect": {
      "version": "1.13.4",
      "resolved": "https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.4.tgz",
      "integrity": "sha512-W67iLl4J2EXEGTbfeHCffrjDfitvLANg0UlX3wFUUSTx92KXRFegMHUVgSqE+wvhAbi4WqjGg9czysTV2Epbew==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/on-finished": {
      "version": "2.4.1",
      "resolved": "https://registry.npmjs.org/on-finished/-/on-finished-2.4.1.tgz",
      "integrity": "sha512-oVlzkg3ENAhCk2zdv7IJwd/QUD4z2RxRwpkcGY8psCVcCYZNq4wYnVWALHM+brtuJjePWiYF/ClmuDr8Ch5+kg==",
      "license": "MIT",
      "dependencies": {
        "ee-first": "1.1.1"
      },
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/once": {
      "version": "1.4.0",
      "resolved": "https://registry.npmjs.org/once/-/once-1.4.0.tgz",
      "integrity": "sha512-lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "wrappy": "1"
      }
    },
    "node_modules/parse-ms": {
      "version": "2.1.0",
      "resolved": "https://registry.npmjs.org/parse-ms/-/parse-ms-2.1.0.tgz",
      "integrity": "sha512-kHt7kzLoS9VBZfUsiKjv43mr91ea+U05EyKkEtqp7vNbHxmaVuEqN7XxeEVnGrMtYOAxGrDElSi96K7EgO1zCA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/parseurl": {
      "version": "1.3.3",
      "resolved": "https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz",
      "integrity": "sha512-CiyeOxFT/JZyN5m0z9PfXw4SCBJ6Sygz1Dpl0wqjlhDEGGBP1GnsUVEL0p63hoG1fcj3fHynXi9NYO4nWOL+qQ==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/path-browserify": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/path-browserify/-/path-browserify-1.0.1.tgz",
      "integrity": "sha512-b7uo2UCUOYZcnF/3ID0lulOJi/bafxa1xPe7ZPsammBSpjSWQkjNxlt635YGS2MiR9GjvuXCtz2emr3jbsz98g==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/path-is-absolute": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz",
      "integrity": "sha512-AVbw3UJ2e9bq64vSaS9Am0fje1Pa8pbGqTTsmXfaIiMpnr5DlDhfJOuLj9Sf95ZPVDAUerDfEk88MPmPe7UCQg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/path-to-regexp": {
      "version": "6.2.1",
      "resolved": "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-6.2.1.tgz",
      "integrity": "sha512-JLyh7xT1kizaEvcaXOQwOc2/Yhw6KZOvPf1S8401UyLk86CU79LN3vl7ztXGm/pZ+YjoyAJ4rxmHwbkBXJX+yw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/picocolors": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/picocolors/-/picocolors-1.0.0.tgz",
      "integrity": "sha512-1fygroTLlHu66zi26VoTDv8yRgm0Fccecssto+MhsZ0D/DGW2sm8E8AjW7NU5VVTRt5GxbeZ5qBuJr+HyLYkjQ==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/picomatch": {
      "version": "2.3.2",
      "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-2.3.2.tgz",
      "integrity": "sha512-V7+vQEJ06Z+c5tSye8S+nHUfI51xoXIXjHQ99cQtKUkQqqO1kO/KCJUfZXuB47h/YBlDhah2H3hdUGXn8ie0oA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=8.6"
      },
      "funding": {
        "url": "https://github.com/sponsors/jonschlinkert"
      }
    },
    "node_modules/pretty-ms": {
      "version": "7.0.1",
      "resolved": "https://registry.npmjs.org/pretty-ms/-/pretty-ms-7.0.1.tgz",
      "integrity": "sha512-973driJZvxiGOQ5ONsFhOF/DtzPMOMtgC11kCpUrPGMTgqp2q/1gwzCquocrN33is0VZ5GFHXZYMM9l6h67v2Q==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "parse-ms": "^2.1.0"
      },
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/proxy-addr": {
      "version": "2.0.7",
      "resolved": "https://registry.npmjs.org/proxy-addr/-/proxy-addr-2.0.7.tgz",
      "integrity": "sha512-llQsMLSUDUPT44jdrU/O37qlnifitDP+ZwrmmZcoSKyLKvtZxpyV0n2/bD/N4tBAAZ/gJEdZU7KMraoK1+XYAg==",
      "license": "MIT",
      "dependencies": {
        "forwarded": "0.2.0",
        "ipaddr.js": "1.9.1"
      },
      "engines": {
        "node": ">= 0.10"
      }
    },
    "node_modules/punycode": {
      "version": "2.3.1",
      "resolved": "https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz",
      "integrity": "sha512-vYt7UD1U9Wg6138shLtLOvdAu+8DsC/ilFtEVHcH+wydcSpNE20AfSOduf6MkRFahL5FY7X1oU7nKVZFtfq8Fg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/qs": {
      "version": "6.14.2",
      "resolved": "https://registry.npmjs.org/qs/-/qs-6.14.2.tgz",
      "integrity": "sha512-V/yCWTTF7VJ9hIh18Ugr2zhJMP01MY7c5kh4J870L7imm6/DIzBsNLTXzMwUA3yZ5b/KBqLx8Kp3uRvd7xSe3Q==",
      "license": "BSD-3-Clause",
      "dependencies": {
        "side-channel": "^1.1.0"
      },
      "engines": {
        "node": ">=0.6"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/queue-microtask": {
      "version": "1.2.3",
      "resolved": "https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz",
      "integrity": "sha512-NuaNSa6flKT5JaSYQzJok04JzTL1CA6aGhv5rfLW3PgqA+M2ChpZQnAC8h8i4ZFkBS8X5RqkDBHA7r4hej3K9A==",
      "dev": true,
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/feross"
        },
        {
          "type": "patreon",
          "url": "https://www.patreon.com/feross"
        },
        {
          "type": "consulting",
          "url": "https://feross.org/support"
        }
      ],
      "license": "MIT"
    },
    "node_modules/range-parser": {
      "version": "1.2.1",
      "resolved": "https://registry.npmjs.org/range-parser/-/range-parser-1.2.1.tgz",
      "integrity": "sha512-Hrgsx+orqoygnmhFbKaHE6c296J+HTAQXoxEF6gNupROmmGJRoyzfG3ccAveqCBrwr/2yxQ5BVd/GTl5agOwSg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/raw-body": {
      "version": "2.5.3",
      "resolved": "https://registry.npmjs.org/raw-body/-/raw-body-2.5.3.tgz",
      "integrity": "sha512-s4VSOf6yN0rvbRZGxs8Om5CWj6seneMwK3oDb4lWDH0UPhWcxwOWw5+qk24bxq87szX1ydrwylIOp2uG1ojUpA==",
      "license": "MIT",
      "dependencies": {
        "bytes": "~3.1.2",
        "http-errors": "~2.0.1",
        "iconv-lite": "~0.4.24",
        "unpipe": "~1.0.0"
      },
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/readable-stream": {
      "version": "3.6.2",
      "resolved": "https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz",
      "integrity": "sha512-9u/sniCrY3D5WdsERHzHE4G2YCXqoG5FTHUiCC4SIbr6XcLZBY05ya9EKjYek9O5xOAwjGq+1JdGBAS7Q9ScoA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "inherits": "^2.0.3",
        "string_decoder": "^1.1.1",
        "util-deprecate": "^1.0.1"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/require-from-string": {
      "version": "2.0.2",
      "resolved": "https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz",
      "integrity": "sha512-Xf0nWe6RseziFMu+Ap9biiUbmplq6S9/p+7w7YXP/JBHhrUDDUhwa+vANyubuqfZWTveU//DYVGsDG7RKL/vEw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/resolve-from": {
      "version": "5.0.0",
      "resolved": "https://registry.npmjs.org/resolve-from/-/resolve-from-5.0.0.tgz",
      "integrity": "sha512-qYg9KP24dD5qka9J47d0aVky0N+b4fTU89LN9iDnjB5waksiC49rvMB0PrUJQGoTmH50XPiqOvAjDfaijGxYZw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/resolve-pkg-maps": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/resolve-pkg-maps/-/resolve-pkg-maps-1.0.0.tgz",
      "integrity": "sha512-seS2Tj26TBVOC2NIc2rOe2y2ZO7efxITtLZcGSOnHHNOQ7CkiUBfw0Iw2ck6xkIhPwLhKNLS8BO+hEpngQlqzw==",
      "dev": true,
      "license": "MIT",
      "funding": {
        "url": "https://github.com/privatenumber/resolve-pkg-maps?sponsor=1"
      }
    },
    "node_modules/reusify": {
      "version": "1.1.0",
      "resolved": "https://registry.npmjs.org/reusify/-/reusify-1.1.0.tgz",
      "integrity": "sha512-g6QUff04oZpHs0eG5p83rFLhHeV00ug/Yf9nZM6fLeUrPguBTkTQOdpAWWspMh55TZfVQDPaN3NQJfbVRAxdIw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "iojs": ">=1.0.0",
        "node": ">=0.10.0"
      }
    },
    "node_modules/rimraf": {
      "version": "3.0.2",
      "resolved": "https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz",
      "integrity": "sha512-JZkJMZkAGFFPP2YqXZXPbMlMBgsxzE8ILs4lMIX/2o0L9UBw9O/Y3o6wFw/i9YLapcUJWwqbi3kdxIPdC62TIA==",
      "deprecated": "Rimraf versions prior to v4 are no longer supported",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "glob": "^7.1.3"
      },
      "bin": {
        "rimraf": "bin.js"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/run-parallel": {
      "version": "1.2.0",
      "resolved": "https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz",
      "integrity": "sha512-5l4VyZR86LZ/lDxZTR6jqL8AFE2S0IFLMP26AbjsLVADxHdhB/c0GUsH+y39UfCi3dzz8OlQuPmnaJOMoDHQBA==",
      "dev": true,
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/feross"
        },
        {
          "type": "patreon",
          "url": "https://www.patreon.com/feross"
        },
        {
          "type": "consulting",
          "url": "https://feross.org/support"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "queue-microtask": "^1.2.2"
      }
    },
    "node_modules/safe-buffer": {
      "version": "5.2.1",
      "resolved": "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz",
      "integrity": "sha512-rp3So07KcdmmKbGvgaNxQSJr7bGVSVk5S9Eq1F+ppbRo70+YeaDxkw5Dd8NPN+GD6bjnYm2VuPuCXmpuYvmCXQ==",
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/feross"
        },
        {
          "type": "patreon",
          "url": "https://www.patreon.com/feross"
        },
        {
          "type": "consulting",
          "url": "https://feross.org/support"
        }
      ],
      "license": "MIT"
    },
    "node_modules/safer-buffer": {
      "version": "2.1.2",
      "resolved": "https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz",
      "integrity": "sha512-YZo3K82SD7Riyi0E1EQPojLz7kpepnSQI9IyPbHHg1XXXevb5dJI7tpyN2ADxGcQbHG7vcyRHk0cbwqcQriUtg==",
      "license": "MIT"
    },
    "node_modules/semver": {
      "version": "7.7.4",
      "resolved": "https://registry.npmjs.org/semver/-/semver-7.7.4.tgz",
      "integrity": "sha512-vFKC2IEtQnVhpT78h1Yp8wzwrf8CM+MzKMHGJZfBtzhZNycRFnXsHk6E5TxIkkMsgNS7mdX3AGB7x2QM2di4lA==",
      "dev": true,
      "license": "ISC",
      "bin": {
        "semver": "bin/semver.js"
      },
      "engines": {
        "node": ">=10"
      }
    },
    "node_modules/send": {
      "version": "0.19.2",
      "resolved": "https://registry.npmjs.org/send/-/send-0.19.2.tgz",
      "integrity": "sha512-VMbMxbDeehAxpOtWJXlcUS5E8iXh6QmN+BkRX1GARS3wRaXEEgzCcB10gTQazO42tpNIya8xIyNx8fll1OFPrg==",
      "license": "MIT",
      "dependencies": {
        "debug": "2.6.9",
        "depd": "2.0.0",
        "destroy": "1.2.0",
        "encodeurl": "~2.0.0",
        "escape-html": "~1.0.3",
        "etag": "~1.8.1",
        "fresh": "~0.5.2",
        "http-errors": "~2.0.1",
        "mime": "1.6.0",
        "ms": "2.1.3",
        "on-finished": "~2.4.1",
        "range-parser": "~1.2.1",
        "statuses": "~2.0.2"
      },
      "engines": {
        "node": ">= 0.8.0"
      }
    },
    "node_modules/send/node_modules/ms": {
      "version": "2.1.3",
      "resolved": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",
      "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==",
      "license": "MIT"
    },
    "node_modules/serve-static": {
      "version": "1.16.3",
      "resolved": "https://registry.npmjs.org/serve-static/-/serve-static-1.16.3.tgz",
      "integrity": "sha512-x0RTqQel6g5SY7Lg6ZreMmsOzncHFU7nhnRWkKgWuMTu5NN0DR5oruckMqRvacAN9d5w6ARnRBXl9xhDCgfMeA==",
      "license": "MIT",
      "dependencies": {
        "encodeurl": "~2.0.0",
        "escape-html": "~1.0.3",
        "parseurl": "~1.3.3",
        "send": "~0.19.1"
      },
      "engines": {
        "node": ">= 0.8.0"
      }
    },
    "node_modules/set-blocking": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz",
      "integrity": "sha512-KiKBS8AnWGEyLzofFfmvKwpdPzqiy16LvQfK3yv/fVH7Bj13/wl3JSR1J+rfgRE9q7xUJK4qvgS8raSOeLUehw==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/setprototypeof": {
      "version": "1.2.0",
      "resolved": "https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz",
      "integrity": "sha512-E5LDX7Wrp85Kil5bhZv46j8jOeboKq5JMmYM3gVGdGH8xFpPWXUMsNrlODCrkoxMEeNi/XZIwuRvY4XNwYMJpw==",
      "license": "ISC"
    },
    "node_modules/side-channel": {
      "version": "1.1.0",
      "resolved": "https://registry.npmjs.org/side-channel/-/side-channel-1.1.0.tgz",
      "integrity": "sha512-ZX99e6tRweoUXqR+VBrslhda51Nh5MTQwou5tnUDgbtyM0dBgmhEDtWGP/xbKn6hqfPRHujUNwz5fy/wbbhnpw==",
      "license": "MIT",
      "dependencies": {
        "es-errors": "^1.3.0",
        "object-inspect": "^1.13.3",
        "side-channel-list": "^1.0.0",
        "side-channel-map": "^1.0.1",
        "side-channel-weakmap": "^1.0.2"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/side-channel-list": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/side-channel-list/-/side-channel-list-1.0.1.tgz",
      "integrity": "sha512-mjn/0bi/oUURjc5Xl7IaWi/OJJJumuoJFQJfDDyO46+hBWsfaVM65TBHq2eoZBhzl9EchxOijpkbRC8SVBQU0w==",
      "license": "MIT",
      "dependencies": {
        "es-errors": "^1.3.0",
        "object-inspect": "^1.13.4"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/side-channel-map": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/side-channel-map/-/side-channel-map-1.0.1.tgz",
      "integrity": "sha512-VCjCNfgMsby3tTdo02nbjtM/ewra6jPHmpThenkTYh8pG9ucZ/1P8So4u4FGBek/BjpOVsDCMoLA/iuBKIFXRA==",
      "license": "MIT",
      "dependencies": {
        "call-bound": "^1.0.2",
        "es-errors": "^1.3.0",
        "get-intrinsic": "^1.2.5",
        "object-inspect": "^1.13.3"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/side-channel-weakmap": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/side-channel-weakmap/-/side-channel-weakmap-1.0.2.tgz",
      "integrity": "sha512-WPS/HvHQTYnHisLo9McqBHOJk2FkHO/tlpvldyrnem4aeQp4hai3gythswg6p01oSoTl58rcpiFAjF2br2Ak2A==",
      "license": "MIT",
      "dependencies": {
        "call-bound": "^1.0.2",
        "es-errors": "^1.3.0",
        "get-intrinsic": "^1.2.5",
        "object-inspect": "^1.13.3",
        "side-channel-map": "^1.0.1"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/signal-exit": {
      "version": "4.0.2",
      "resolved": "https://registry.npmjs.org/signal-exit/-/signal-exit-4.0.2.tgz",
      "integrity": "sha512-MY2/qGx4enyjprQnFaZsHib3Yadh3IXyV2C321GY0pjGfVBu4un0uDJkwgdxqO+Rdx8JMT8IfJIRwbYVz3Ob3Q==",
      "dev": true,
      "license": "ISC",
      "engines": {
        "node": ">=14"
      },
      "funding": {
        "url": "https://github.com/sponsors/isaacs"
      }
    },
    "node_modules/statuses": {
      "version": "2.0.2",
      "resolved": "https://registry.npmjs.org/statuses/-/statuses-2.0.2.tgz",
      "integrity": "sha512-DvEy55V3DB7uknRo+4iOGT5fP1slR8wQohVdknigZPMpMstaKJQWhwiYBACJE3Ul2pTnATihhBYnRhZQHGBiRw==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/string_decoder": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz",
      "integrity": "sha512-hkRX8U1WjJFd8LsDJ2yQ/wWWxaopEsABU1XfkM8A+j0+85JAGppt16cr1Whg6KIbb4okU6Mql6BOj+uup/wKeA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "safe-buffer": "~5.2.0"
      }
    },
    "node_modules/string-width": {
      "version": "4.2.3",
      "resolved": "https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz",
      "integrity": "sha512-wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "emoji-regex": "^8.0.0",
        "is-fullwidth-code-point": "^3.0.0",
        "strip-ansi": "^6.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/strip-ansi": {
      "version": "6.0.1",
      "resolved": "https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz",
      "integrity": "sha512-Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "ansi-regex": "^5.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/tar": {
      "version": "6.2.1",
      "resolved": "https://registry.npmjs.org/tar/-/tar-6.2.1.tgz",
      "integrity": "sha512-DZ4yORTwrbTj/7MZYq2w+/ZFdI6OZ/f9SFHR+71gIVUZhOQPHzVCLpvRnPgyaMpfWxxk/4ONva3GQSyNIKRv6A==",
      "deprecated": "Old versions of tar are not supported, and contain widely publicized security vulnerabilities, which have been fixed in the current version. Please update. Support for old versions may be purchased (at exorbitant rates) by contacting i@izs.me",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "chownr": "^2.0.0",
        "fs-minipass": "^2.0.0",
        "minipass": "^5.0.0",
        "minizlib": "^2.1.1",
        "mkdirp": "^1.0.3",
        "yallist": "^4.0.0"
      },
      "engines": {
        "node": ">=10"
      }
    },
    "node_modules/time-span": {
      "version": "4.0.0",
      "resolved": "https://registry.npmjs.org/time-span/-/time-span-4.0.0.tgz",
      "integrity": "sha512-MyqZCTGLDZ77u4k+jqg4UlrzPTPZ49NDlaekU6uuFaJLzPIN1woaRXCbGeqOfxwc3Y37ZROGAJ614Rdv7Olt+g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "convert-hrtime": "^3.0.0"
      },
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/to-regex-range": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz",
      "integrity": "sha512-65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "is-number": "^7.0.0"
      },
      "engines": {
        "node": ">=8.0"
      }
    },
    "node_modules/toidentifier": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz",
      "integrity": "sha512-o5sSPKEkg/DIQNmH43V0/uerLrpzVedkUh8tGNvaeXpfpuwjKenlSox/2O/BTlZUtEe+JG7s5YhEz608PlAHRA==",
      "license": "MIT",
      "engines": {
        "node": ">=0.6"
      }
    },
    "node_modules/tr46": {
      "version": "0.0.3",
      "resolved": "https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz",
      "integrity": "sha512-N3WMsuqV66lT30CrXNbEjx4GEwlow3v6rr4mCcv6prnfwhS01rkgyFdjPNBYd9br7LpXV1+Emh01fHnq2Gdgrw==",
      "license": "MIT"
    },
    "node_modules/ts-morph": {
      "version": "12.0.0",
      "resolved": "https://registry.npmjs.org/ts-morph/-/ts-morph-12.0.0.tgz",
      "integrity": "sha512-VHC8XgU2fFW7yO1f/b3mxKDje1vmyzFXHWzOYmKEkCEwcLjDtbdLgBQviqj4ZwP4MJkQtRo6Ha2I29lq/B+VxA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@ts-morph/common": "~0.11.0",
        "code-block-writer": "^10.1.1"
      }
    },
    "node_modules/ts-node": {
      "version": "10.9.1",
      "resolved": "https://registry.npmjs.org/ts-node/-/ts-node-10.9.1.tgz",
      "integrity": "sha512-NtVysVPkxxrwFGUUxGYhfux8k78pQB3JqYBXlLRZgdGUqTO5wU/UyHop5p70iEbGhB7q5KmiZiU0Y3KlJrScEw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@cspotcode/source-map-support": "^0.8.0",
        "@tsconfig/node10": "^1.0.7",
        "@tsconfig/node12": "^1.0.7",
        "@tsconfig/node14": "^1.0.0",
        "@tsconfig/node16": "^1.0.2",
        "acorn": "^8.4.1",
        "acorn-walk": "^8.1.1",
        "arg": "^4.1.0",
        "create-require": "^1.1.0",
        "diff": "^4.0.1",
        "make-error": "^1.1.1",
        "v8-compile-cache-lib": "^3.0.1",
        "yn": "3.1.1"
      },
      "bin": {
        "ts-node": "dist/bin.js",
        "ts-node-cwd": "dist/bin-cwd.js",
        "ts-node-esm": "dist/bin-esm.js",
        "ts-node-script": "dist/bin-script.js",
        "ts-node-transpile-only": "dist/bin-transpile.js",
        "ts-script": "dist/bin-script-deprecated.js"
      },
      "peerDependencies": {
        "@swc/core": ">=1.2.50",
        "@swc/wasm": ">=1.2.50",
        "@types/node": "*",
        "typescript": ">=2.7"
      },
      "peerDependenciesMeta": {
        "@swc/core": {
          "optional": true
        },
        "@swc/wasm": {
          "optional": true
        }
      }
    },
    "node_modules/ts-toolbelt": {
      "version": "6.15.5",
      "resolved": "https://registry.npmjs.org/ts-toolbelt/-/ts-toolbelt-6.15.5.tgz",
      "integrity": "sha512-FZIXf1ksVyLcfr7M317jbB67XFJhOO1YqdTcuGaq9q5jLUoTikukZ+98TPjKiP2jC5CgmYdWWYs0s2nLSU0/1A==",
      "dev": true,
      "license": "Apache-2.0"
    },
    "node_modules/tslib": {
      "version": "2.8.1",
      "resolved": "https://registry.npmjs.org/tslib/-/tslib-2.8.1.tgz",
      "integrity": "sha512-oJFu94HQb+KVduSUQL7wnpmqnfmLsOA/nAh6b6EH0wCEoK0/mPeXU6c3wKDV83MkOuHPRHtSXKKU99IBazS/2w==",
      "license": "0BSD"
    },
    "node_modules/tsx": {
      "version": "4.21.0",
      "resolved": "https://registry.npmjs.org/tsx/-/tsx-4.21.0.tgz",
      "integrity": "sha512-5C1sg4USs1lfG0GFb2RLXsdpXqBSEhAaA/0kPL01wxzpMqLILNxIxIOKiILz+cdg/pLnOUxFYOR5yhHU666wbw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "esbuild": "~0.27.0",
        "get-tsconfig": "^4.7.5"
      },
      "bin": {
        "tsx": "dist/cli.mjs"
      },
      "engines": {
        "node": ">=18.0.0"
      },
      "optionalDependencies": {
        "fsevents": "~2.3.3"
      }
    },
    "node_modules/tsx/node_modules/esbuild": {
      "version": "0.27.7",
      "resolved": "https://registry.npmjs.org/esbuild/-/esbuild-0.27.7.tgz",
      "integrity": "sha512-IxpibTjyVnmrIQo5aqNpCgoACA/dTKLTlhMHihVHhdkxKyPO1uBBthumT0rdHmcsk9uMonIWS0m4FljWzILh3w==",
      "dev": true,
      "hasInstallScript": true,
      "license": "MIT",
      "bin": {
        "esbuild": "bin/esbuild"
      },
      "engines": {
        "node": ">=18"
      },
      "optionalDependencies": {
        "@esbuild/aix-ppc64": "0.27.7",
        "@esbuild/android-arm": "0.27.7",
        "@esbuild/android-arm64": "0.27.7",
        "@esbuild/android-x64": "0.27.7",
        "@esbuild/darwin-arm64": "0.27.7",
        "@esbuild/darwin-x64": "0.27.7",
        "@esbuild/freebsd-arm64": "0.27.7",
        "@esbuild/freebsd-x64": "0.27.7",
        "@esbuild/linux-arm": "0.27.7",
        "@esbuild/linux-arm64": "0.27.7",
        "@esbuild/linux-ia32": "0.27.7",
        "@esbuild/linux-loong64": "0.27.7",
        "@esbuild/linux-mips64el": "0.27.7",
        "@esbuild/linux-ppc64": "0.27.7",
        "@esbuild/linux-riscv64": "0.27.7",
        "@esbuild/linux-s390x": "0.27.7",
        "@esbuild/linux-x64": "0.27.7",
        "@esbuild/netbsd-arm64": "0.27.7",
        "@esbuild/netbsd-x64": "0.27.7",
        "@esbuild/openbsd-arm64": "0.27.7",
        "@esbuild/openbsd-x64": "0.27.7",
        "@esbuild/openharmony-arm64": "0.27.7",
        "@esbuild/sunos-x64": "0.27.7",
        "@esbuild/win32-arm64": "0.27.7",
        "@esbuild/win32-ia32": "0.27.7",
        "@esbuild/win32-x64": "0.27.7"
      }
    },
    "node_modules/type-is": {
      "version": "1.6.18",
      "resolved": "https://registry.npmjs.org/type-is/-/type-is-1.6.18.tgz",
      "integrity": "sha512-TkRKr9sUTxEH8MdfuCSP7VizJyzRNMjj2J2do2Jr3Kym598JVdEksuzPQCnlFPW4ky9Q+iA+ma9BGm06XQBy8g==",
      "license": "MIT",
      "dependencies": {
        "media-typer": "0.3.0",
        "mime-types": "~2.1.24"
      },
      "engines": {
        "node": ">= 0.6"
      }
    },
    "node_modules/typescript": {
      "version": "5.9.3",
      "resolved": "https://registry.npmjs.org/typescript/-/typescript-5.9.3.tgz",
      "integrity": "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw==",
      "dev": true,
      "license": "Apache-2.0",
      "bin": {
        "tsc": "bin/tsc",
        "tsserver": "bin/tsserver"
      },
      "engines": {
        "node": ">=14.17"
      }
    },
    "node_modules/undici": {
      "version": "5.28.4",
      "resolved": "https://registry.npmjs.org/undici/-/undici-5.28.4.tgz",
      "integrity": "sha512-72RFADWFqKmUb2hmmvNODKL3p9hcB6Gt2DOQMis1SEBaV6a4MH8soBvzg+95CYhCKPFedut2JY9bMfrDl9D23g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@fastify/busboy": "^2.0.0"
      },
      "engines": {
        "node": ">=14.0"
      }
    },
    "node_modules/undici-types": {
      "version": "7.19.2",
      "resolved": "https://registry.npmjs.org/undici-types/-/undici-types-7.19.2.tgz",
      "integrity": "sha512-qYVnV5OEm2AW8cJMCpdV20CDyaN3g0AjDlOGf1OW4iaDEx8MwdtChUp4zu4H0VP3nDRF/8RKWH+IPp9uW0YGZg==",
      "license": "MIT"
    },
    "node_modules/unpipe": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz",
      "integrity": "sha512-pjy2bYhSsufwWlKwPc+l3cN7+wuJlK6uz0YdJEOlQDbl6jo/YlPi4mb8agUkVC8BF7V8NuzeyPNqRksA3hztKQ==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/uri-js": {
      "version": "4.4.1",
      "resolved": "https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz",
      "integrity": "sha512-7rKUyy33Q1yc98pQ1DAmLtwX109F7TIfWlW1Ydo8Wl1ii1SeHieeh0HHfPeL2fMXK6z0s8ecKs9frCuLJvndBg==",
      "dev": true,
      "license": "BSD-2-Clause",
      "dependencies": {
        "punycode": "^2.1.0"
      }
    },
    "node_modules/util-deprecate": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz",
      "integrity": "sha512-EPD5q1uXyFxJpCrLnCc1nHnq3gOa6DZBocAIiI2TaSCA7VCJ1UJDMagCzIkXNsUYfD1daK//LTEQ8xiIbrHtcw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/utils-merge": {
      "version": "1.0.1",
      "resolved": "https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.1.tgz",
      "integrity": "sha512-pMZTvIkT1d+TFGvDOqodOclx0QWkkgi6Tdoa8gC8ffGAAqz9pzPTZWAybbsHHoED/ztMtkv/VoYTYyShUn81hA==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.4.0"
      }
    },
    "node_modules/v8-compile-cache-lib": {
      "version": "3.0.1",
      "resolved": "https://registry.npmjs.org/v8-compile-cache-lib/-/v8-compile-cache-lib-3.0.1.tgz",
      "integrity": "sha512-wa7YjyUGfNZngI/vtK0UHAN+lgDCxBPCylVXGp0zu59Fz5aiGtNXaq3DhIov063MorB+VfufLh3JlF2KdTK3xg==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/vary": {
      "version": "1.1.2",
      "resolved": "https://registry.npmjs.org/vary/-/vary-1.1.2.tgz",
      "integrity": "sha512-BNGbWLfd0eUPabhkXUVm0j8uuvREyTh5ovRa/dyow/BqAbZJyC+5fU+IzQOzmAKzYqYRAISoRhdQr3eIZ/PXqg==",
      "license": "MIT",
      "engines": {
        "node": ">= 0.8"
      }
    },
    "node_modules/webidl-conversions": {
      "version": "3.0.1",
      "resolved": "https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz",
      "integrity": "sha512-2JAn3z8AR6rjK8Sm8orRC0h/bcl/DqL7tRPdGZ4I1CjdF+EaMLmYxBHyXuKL849eucPFhvBoxMsflfOb8kxaeQ==",
      "license": "BSD-2-Clause"
    },
    "node_modules/whatwg-url": {
      "version": "5.0.0",
      "resolved": "https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz",
      "integrity": "sha512-saE57nupxk6v3HY35+jzBwYa0rKSy0XR8JSxZPwgLr7ys0IBzhGviA1/TUGJLmSVqs8pb9AnvICXEuOHLprYTw==",
      "license": "MIT",
      "dependencies": {
        "tr46": "~0.0.3",
        "webidl-conversions": "^3.0.0"
      }
    },
    "node_modules/wide-align": {
      "version": "1.1.5",
      "resolved": "https://registry.npmjs.org/wide-align/-/wide-align-1.1.5.tgz",
      "integrity": "sha512-eDMORYaPNZ4sQIuuYPDHdQvf4gyCF9rEEV/yPxGfwPkRodwEgiMUUXTx/dex+Me0wxx53S+NgUHaP7y3MGlDmg==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "string-width": "^1.0.2 || 2 || 3 || 4"
      }
    },
    "node_modules/wrappy": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz",
      "integrity": "sha512-l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/ws": {
      "version": "8.20.0",
      "resolved": "https://registry.npmjs.org/ws/-/ws-8.20.0.tgz",
      "integrity": "sha512-sAt8BhgNbzCtgGbt2OxmpuryO63ZoDk/sqaB/znQm94T4fCEsy/yV+7CdC1kJhOU9lboAEU7R3kquuycDoibVA==",
      "license": "MIT",
      "engines": {
        "node": ">=10.0.0"
      },
      "peerDependencies": {
        "bufferutil": "^4.0.1",
        "utf-8-validate": ">=5.0.2"
      },
      "peerDependenciesMeta": {
        "bufferutil": {
          "optional": true
        },
        "utf-8-validate": {
          "optional": true
        }
      }
    },
    "node_modules/yallist": {
      "version": "4.0.0",
      "resolved": "https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz",
      "integrity": "sha512-3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/yn": {
      "version": "3.1.1",
      "resolved": "https://registry.npmjs.org/yn/-/yn-3.1.1.tgz",
      "integrity": "sha512-Ux4ygGWsu2c7isFWe8Yu1YluJmqVhxqK2cLXNQA5AcC3QfbGNpM7fu0Y8b/z16pXLnFxZYvWhd3fhBY9DLmC6Q==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6"
      }
    }
  }
}
// FILE: package.json
{
  "name": "via51-beta",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "npx tsx watch api/index.ts",
    "start": "npx tsx api/index.ts"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.104.1",
    "cors": "^2.8.6",
    "dotenv": "^17.4.2",
    "express": "^4.22.1",
    "node-fetch": "^2.7.0"
  },
  "devDependencies": {
    "@types/cors": "^2.8.19",
    "@types/express": "^4.17.25",
    "@types/node": "^25.6.0",
    "@vercel/node": "^3.0.0",
    "tsx": "^4.21.0",
    "typescript": "^5.9.3"
  }
}
// FILE: tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "outDir": "./dist"
  },
  "include": ["src/**/*"]
}
// FILE: vercel.json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/api" }]
}
// FILE: citizens.json
{
  "active_cover": {
    "img": "https://i.ibb.co/L8v8z9k/Mesias-V51-Executive.jpg",
    "thought_executive": "Primero en calificaciones y al fondo de la cÃ©dula para moverles el piso a los corruptos.",
    "thought_emotive": "Â¡Hay taita lindo! Hasta que al fin te revelaste como morado... Taitita es peruano."
  }
}
// FILE: sys_events.json
{
    "v51_dna": {
        "node": "SYS-EVENTS",
        "seq": "D-02",
        "pulse": 1713000000000
    },
    "history": []
}
// FILE: sys_nodes.json
{
    "v51_dna": {
        "node": "SYS-MEMORY",
        "seq": "D-01",
        "pulse": 1713000000000
    },
    "hierarchy": {
        "root": {
            "id": "N0-V51",
            "level": 0,
            "alias": "ALFA-MENTORIA",
            "status": "ACTIVE",
            "children": [
                {
                    "id": "N1-POL",
                    "level": 1,
                    "alias": "DEPT-POLITICA",
                    "status": "ACTIVE",
                    "children": [
                        {
                            "id": "N2-POL-T1",
                            "alias": "TRIADA-ESTRATEGIA",
                            "status": "STANDBY"
                        },
                        {
                            "id": "N2-POL-T2",
                            "alias": "TRIADA-NORMATIVA",
                            "status": "STANDBY"
                        },
                        {
                            "id": "N2-POL-T3",
                            "alias": "TRIADA-INTELIGENCIA",
                            "status": "STANDBY"
                        }
                    ]
                },
                {
                    "id": "N1-SOC",
                    "level": 1,
                    "alias": "DEPT-SOCIAL",
                    "status": "ACTIVE",
                    "children": []
                },
                {
                    "id": "N1-PROD",
                    "level": 1,
                    "alias": "DEPT-PRODUCCION",
                    "status": "ACTIVE",
                    "children": []
                }
            ]
        }
    }
}
// FILE: citizen_sovereign.json
// FILE: package.json
{
  "name": "via51-gamma",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "@supabase/supabase-js": "^2.43.2",
    "framer-motion": "^10.16.4"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.0",
    "typescript": "^5.3.0",
    "vite": "^5.0.0"
  }
}
// FILE: tsconfig.json
{
  "extends": "../tsconfig.base.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
// FILE: tsconfig.node.json
{
    "compilerOptions": {
        "composite": true,
        "skipLibCheck": true,
        "module": "ESNext",
        "moduleResolution": "node",
        "allowSyntheticDefaultImports": true
    },
    "include": [
        "vite.config.ts"
    ]
}
// FILE: sample-event.json
{
    "domain_id": "events_v1",
    "meta": {
        "entity_name": "Event",
        "description": "Configuration for Concerts and Congresses"
    },
    "requiredFields": [
        "title",
        "capacity",
        "is_public"
    ],
    "properties": {
        "title": {
            "type": "string",
            "min": 5
        },
        "capacity": {
            "type": "number",
            "max_limit": 10000
        },
        "is_public": {
            "type": "boolean"
        },
        "metadata": {
            "type": "object"
        }
    },
    "transitions": [
        "draft -> processing",
        "processing -> approved",
        "approved -> published"
    ]
}
// FILE: package-lock.json
{
  "name": "via51-holding",
  "version": "1.0.0",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "": {
      "name": "via51-holding",
      "version": "1.0.0",
      "license": "ISC",
      "dependencies": {
        "@supabase/supabase-js": "^2.105.1",
        "framer-motion": "^10.16.4",
        "lucide-react": "^0.284.0",
        "react": "^18.3.1",
        "react-dom": "^18.3.1",
        "react-router-dom": "^7.14.2",
        "zod": "^4.4.2"
      },
      "devDependencies": {
        "@types/react": "^18.3.28",
        "@types/react-dom": "^18.3.7",
        "@vitejs/plugin-react": "^4.7.0",
        "autoprefixer": "^10.4.16",
        "postcss": "^8.4.31",
        "tailwindcss": "^3.3.3",
        "typescript": "^5.9.3",
        "vite": "^4.5.14"
      }
    },
    "node_modules/@alloc/quick-lru": {
      "version": "5.2.0",
      "resolved": "https://registry.npmjs.org/@alloc/quick-lru/-/quick-lru-5.2.0.tgz",
      "integrity": "sha512-UrcABB+4bUrFABwbluTIBErXwvbsU/V7TZWfmbgJfbkwiBuziS9gxdODUyuiecfdGQ85jglMW6juS3+z5TsKLw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=10"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/@babel/code-frame": {
      "version": "7.29.0",
      "resolved": "https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.29.0.tgz",
      "integrity": "sha512-9NhCeYjq9+3uxgdtp20LSiJXJvN0FeCtNGpJxuMFZ1Kv3cWUNb6DOhJwUvcVCzKGR66cw4njwM6hrJLqgOwbcw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/helper-validator-identifier": "^7.28.5",
        "js-tokens": "^4.0.0",
        "picocolors": "^1.1.1"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/compat-data": {
      "version": "7.29.0",
      "resolved": "https://registry.npmjs.org/@babel/compat-data/-/compat-data-7.29.0.tgz",
      "integrity": "sha512-T1NCJqT/j9+cn8fvkt7jtwbLBfLC/1y1c7NtCeXFRgzGTsafi68MRv8yzkYSapBnFA6L3U2VSc02ciDzoAJhJg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/core": {
      "version": "7.29.0",
      "resolved": "https://registry.npmjs.org/@babel/core/-/core-7.29.0.tgz",
      "integrity": "sha512-CGOfOJqWjg2qW/Mb6zNsDm+u5vFQ8DxXfbM09z69p5Z6+mE1ikP2jUXw+j42Pf1XTYED2Rni5f95npYeuwMDQA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/code-frame": "^7.29.0",
        "@babel/generator": "^7.29.0",
        "@babel/helper-compilation-targets": "^7.28.6",
        "@babel/helper-module-transforms": "^7.28.6",
        "@babel/helpers": "^7.28.6",
        "@babel/parser": "^7.29.0",
        "@babel/template": "^7.28.6",
        "@babel/traverse": "^7.29.0",
        "@babel/types": "^7.29.0",
        "@jridgewell/remapping": "^2.3.5",
        "convert-source-map": "^2.0.0",
        "debug": "^4.1.0",
        "gensync": "^1.0.0-beta.2",
        "json5": "^2.2.3",
        "semver": "^6.3.1"
      },
      "engines": {
        "node": ">=6.9.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/babel"
      }
    },
    "node_modules/@babel/generator": {
      "version": "7.29.1",
      "resolved": "https://registry.npmjs.org/@babel/generator/-/generator-7.29.1.tgz",
      "integrity": "sha512-qsaF+9Qcm2Qv8SRIMMscAvG4O3lJ0F1GuMo5HR/Bp02LopNgnZBC/EkbevHFeGs4ls/oPz9v+Bsmzbkbe+0dUw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/parser": "^7.29.0",
        "@babel/types": "^7.29.0",
        "@jridgewell/gen-mapping": "^0.3.12",
        "@jridgewell/trace-mapping": "^0.3.28",
        "jsesc": "^3.0.2"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-compilation-targets": {
      "version": "7.28.6",
      "resolved": "https://registry.npmjs.org/@babel/helper-compilation-targets/-/helper-compilation-targets-7.28.6.tgz",
      "integrity": "sha512-JYtls3hqi15fcx5GaSNL7SCTJ2MNmjrkHXg4FSpOA/grxK8KwyZ5bubHsCq8FXCkua6xhuaaBit+3b7+VZRfcA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/compat-data": "^7.28.6",
        "@babel/helper-validator-option": "^7.27.1",
        "browserslist": "^4.24.0",
        "lru-cache": "^5.1.1",
        "semver": "^6.3.1"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-globals": {
      "version": "7.28.0",
      "resolved": "https://registry.npmjs.org/@babel/helper-globals/-/helper-globals-7.28.0.tgz",
      "integrity": "sha512-+W6cISkXFa1jXsDEdYA8HeevQT/FULhxzR99pxphltZcVaugps53THCeiWA8SguxxpSp3gKPiuYfSWopkLQ4hw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-module-imports": {
      "version": "7.28.6",
      "resolved": "https://registry.npmjs.org/@babel/helper-module-imports/-/helper-module-imports-7.28.6.tgz",
      "integrity": "sha512-l5XkZK7r7wa9LucGw9LwZyyCUscb4x37JWTPz7swwFE/0FMQAGpiWUZn8u9DzkSBWEcK25jmvubfpw2dnAMdbw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/traverse": "^7.28.6",
        "@babel/types": "^7.28.6"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-module-transforms": {
      "version": "7.28.6",
      "resolved": "https://registry.npmjs.org/@babel/helper-module-transforms/-/helper-module-transforms-7.28.6.tgz",
      "integrity": "sha512-67oXFAYr2cDLDVGLXTEABjdBJZ6drElUSI7WKp70NrpyISso3plG9SAGEF6y7zbha/wOzUByWWTJvEDVNIUGcA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/helper-module-imports": "^7.28.6",
        "@babel/helper-validator-identifier": "^7.28.5",
        "@babel/traverse": "^7.28.6"
      },
      "engines": {
        "node": ">=6.9.0"
      },
      "peerDependencies": {
        "@babel/core": "^7.0.0"
      }
    },
    "node_modules/@babel/helper-plugin-utils": {
      "version": "7.28.6",
      "resolved": "https://registry.npmjs.org/@babel/helper-plugin-utils/-/helper-plugin-utils-7.28.6.tgz",
      "integrity": "sha512-S9gzZ/bz83GRysI7gAD4wPT/AI3uCnY+9xn+Mx/KPs2JwHJIz1W8PZkg2cqyt3RNOBM8ejcXhV6y8Og7ly/Dug==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-string-parser": {
      "version": "7.27.1",
      "resolved": "https://registry.npmjs.org/@babel/helper-string-parser/-/helper-string-parser-7.27.1.tgz",
      "integrity": "sha512-qMlSxKbpRlAridDExk92nSobyDdpPijUq2DW6oDnUqd0iOGxmQjyqhMIihI9+zv4LPyZdRje2cavWPbCbWm3eA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-validator-identifier": {
      "version": "7.28.5",
      "resolved": "https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.28.5.tgz",
      "integrity": "sha512-qSs4ifwzKJSV39ucNjsvc6WVHs6b7S03sOh2OcHF9UHfVPqWWALUsNUVzhSBiItjRZoLHx7nIarVjqKVusUZ1Q==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helper-validator-option": {
      "version": "7.27.1",
      "resolved": "https://registry.npmjs.org/@babel/helper-validator-option/-/helper-validator-option-7.27.1.tgz",
      "integrity": "sha512-YvjJow9FxbhFFKDSuFnVCe2WxXk1zWc22fFePVNEaWJEu8IrZVlda6N0uHwzZrUM1il7NC9Mlp4MaJYbYd9JSg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/helpers": {
      "version": "7.29.2",
      "resolved": "https://registry.npmjs.org/@babel/helpers/-/helpers-7.29.2.tgz",
      "integrity": "sha512-HoGuUs4sCZNezVEKdVcwqmZN8GoHirLUcLaYVNBK2J0DadGtdcqgr3BCbvH8+XUo4NGjNl3VOtSjEKNzqfFgKw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/template": "^7.28.6",
        "@babel/types": "^7.29.0"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/parser": {
      "version": "7.29.2",
      "resolved": "https://registry.npmjs.org/@babel/parser/-/parser-7.29.2.tgz",
      "integrity": "sha512-4GgRzy/+fsBa72/RZVJmGKPmZu9Byn8o4MoLpmNe1m8ZfYnz5emHLQz3U4gLud6Zwl0RZIcgiLD7Uq7ySFuDLA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/types": "^7.29.0"
      },
      "bin": {
        "parser": "bin/babel-parser.js"
      },
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/@babel/plugin-transform-react-jsx-self": {
      "version": "7.27.1",
      "resolved": "https://registry.npmjs.org/@babel/plugin-transform-react-jsx-self/-/plugin-transform-react-jsx-self-7.27.1.tgz",
      "integrity": "sha512-6UzkCs+ejGdZ5mFFC/OCUrv028ab2fp1znZmCZjAOBKiBK2jXD1O+BPSfX8X2qjJ75fZBMSnQn3Rq2mrBJK2mw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/helper-plugin-utils": "^7.27.1"
      },
      "engines": {
        "node": ">=6.9.0"
      },
      "peerDependencies": {
        "@babel/core": "^7.0.0-0"
      }
    },
    "node_modules/@babel/plugin-transform-react-jsx-source": {
      "version": "7.27.1",
      "resolved": "https://registry.npmjs.org/@babel/plugin-transform-react-jsx-source/-/plugin-transform-react-jsx-source-7.27.1.tgz",
      "integrity": "sha512-zbwoTsBruTeKB9hSq73ha66iFeJHuaFkUbwvqElnygoNbj/jHRsSeokowZFN3CZ64IvEqcmmkVe89OPXc7ldAw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/helper-plugin-utils": "^7.27.1"
      },
      "engines": {
        "node": ">=6.9.0"
      },
      "peerDependencies": {
        "@babel/core": "^7.0.0-0"
      }
    },
    "node_modules/@babel/template": {
      "version": "7.28.6",
      "resolved": "https://registry.npmjs.org/@babel/template/-/template-7.28.6.tgz",
      "integrity": "sha512-YA6Ma2KsCdGb+WC6UpBVFJGXL58MDA6oyONbjyF/+5sBgxY/dwkhLogbMT2GXXyU84/IhRw/2D1Os1B/giz+BQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/code-frame": "^7.28.6",
        "@babel/parser": "^7.28.6",
        "@babel/types": "^7.28.6"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/traverse": {
      "version": "7.29.0",
      "resolved": "https://registry.npmjs.org/@babel/traverse/-/traverse-7.29.0.tgz",
      "integrity": "sha512-4HPiQr0X7+waHfyXPZpWPfWL/J7dcN1mx9gL6WdQVMbPnF3+ZhSMs8tCxN7oHddJE9fhNE7+lxdnlyemKfJRuA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/code-frame": "^7.29.0",
        "@babel/generator": "^7.29.0",
        "@babel/helper-globals": "^7.28.0",
        "@babel/parser": "^7.29.0",
        "@babel/template": "^7.28.6",
        "@babel/types": "^7.29.0",
        "debug": "^4.3.1"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@babel/types": {
      "version": "7.29.0",
      "resolved": "https://registry.npmjs.org/@babel/types/-/types-7.29.0.tgz",
      "integrity": "sha512-LwdZHpScM4Qz8Xw2iKSzS+cfglZzJGvofQICy7W7v4caru4EaAmyUuO6BGrbyQ2mYV11W0U8j5mBhd14dd3B0A==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/helper-string-parser": "^7.27.1",
        "@babel/helper-validator-identifier": "^7.28.5"
      },
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/@emotion/is-prop-valid": {
      "version": "0.8.8",
      "resolved": "https://registry.npmjs.org/@emotion/is-prop-valid/-/is-prop-valid-0.8.8.tgz",
      "integrity": "sha512-u5WtneEAr5IDG2Wv65yhunPSMLIpuKsbuOktRojfrEiEvRyC85LgPMZI63cr7NUqT8ZIGdSVg8ZKGxIug4lXcA==",
      "license": "MIT",
      "optional": true,
      "dependencies": {
        "@emotion/memoize": "0.7.4"
      }
    },
    "node_modules/@emotion/memoize": {
      "version": "0.7.4",
      "resolved": "https://registry.npmjs.org/@emotion/memoize/-/memoize-0.7.4.tgz",
      "integrity": "sha512-Ja/Vfqe3HpuzRsG1oBtWTHk2PGZ7GR+2Vz5iYGelAw8dx32K0y7PjVuxK6z1nMpZOqAFsRUPCkK1YjJ56qJlgw==",
      "license": "MIT",
      "optional": true
    },
    "node_modules/@esbuild/android-arm": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/android-arm/-/android-arm-0.18.20.tgz",
      "integrity": "sha512-fyi7TDI/ijKKNZTUJAQqiG5T7YjJXgnzkURqmGj13C6dCqckZBLdl4h7bkhHt/t0WP+zO9/zwroDvANaOqO5Sw==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/android-arm64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/android-arm64/-/android-arm64-0.18.20.tgz",
      "integrity": "sha512-Nz4rJcchGDtENV0eMKUNa6L12zz2zBDXuhj/Vjh18zGqB44Bi7MBMSXjgunJgjRhCmKOjnPuZp4Mb6OKqtMHLQ==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/android-x64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/android-x64/-/android-x64-0.18.20.tgz",
      "integrity": "sha512-8GDdlePJA8D6zlZYJV/jnrRAi6rOiNaCC/JclcXpB+KIuvfBN4owLtgzY2bsxnx666XjJx2kDPUmnTtR8qKQUg==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "android"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/darwin-arm64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/darwin-arm64/-/darwin-arm64-0.18.20.tgz",
      "integrity": "sha512-bxRHW5kHU38zS2lPTPOyuyTm+S+eobPUnTNkdJEfAddYgEcll4xkT8DB9d2008DtTbl7uJag2HuE5NZAZgnNEA==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/darwin-x64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/darwin-x64/-/darwin-x64-0.18.20.tgz",
      "integrity": "sha512-pc5gxlMDxzm513qPGbCbDukOdsGtKhfxD1zJKXjCCcU7ju50O7MeAZ8c4krSJcOIJGFR+qx21yMMVYwiQvyTyQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/freebsd-arm64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/freebsd-arm64/-/freebsd-arm64-0.18.20.tgz",
      "integrity": "sha512-yqDQHy4QHevpMAaxhhIwYPMv1NECwOvIpGCZkECn8w2WFHXjEwrBn3CeNIYsibZ/iZEUemj++M26W3cNR5h+Tw==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "freebsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/freebsd-x64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/freebsd-x64/-/freebsd-x64-0.18.20.tgz",
      "integrity": "sha512-tgWRPPuQsd3RmBZwarGVHZQvtzfEBOreNuxEMKFcd5DaDn2PbBxfwLcj4+aenoh7ctXcbXmOQIn8HI6mCSw5MQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "freebsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-arm": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-arm/-/linux-arm-0.18.20.tgz",
      "integrity": "sha512-/5bHkMWnq1EgKr1V+Ybz3s1hWXok7mDFUMQ4cG10AfW3wL02PSZi5kFpYKrptDsgb2WAJIvRcDm+qIvXf/apvg==",
      "cpu": [
        "arm"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-arm64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-arm64/-/linux-arm64-0.18.20.tgz",
      "integrity": "sha512-2YbscF+UL7SQAVIpnWvYwM+3LskyDmPhe31pE7/aoTMFKKzIc9lLbyGUpmmb8a8AixOL61sQ/mFh3jEjHYFvdA==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-ia32": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-ia32/-/linux-ia32-0.18.20.tgz",
      "integrity": "sha512-P4etWwq6IsReT0E1KHU40bOnzMHoH73aXp96Fs8TIT6z9Hu8G6+0SHSw9i2isWrD2nbx2qo5yUqACgdfVGx7TA==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-loong64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-loong64/-/linux-loong64-0.18.20.tgz",
      "integrity": "sha512-nXW8nqBTrOpDLPgPY9uV+/1DjxoQ7DoB2N8eocyq8I9XuqJ7BiAMDMf9n1xZM9TgW0J8zrquIb/A7s3BJv7rjg==",
      "cpu": [
        "loong64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-mips64el": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-mips64el/-/linux-mips64el-0.18.20.tgz",
      "integrity": "sha512-d5NeaXZcHp8PzYy5VnXV3VSd2D328Zb+9dEq5HE6bw6+N86JVPExrA6O68OPwobntbNJ0pzCpUFZTo3w0GyetQ==",
      "cpu": [
        "mips64el"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-ppc64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-ppc64/-/linux-ppc64-0.18.20.tgz",
      "integrity": "sha512-WHPyeScRNcmANnLQkq6AfyXRFr5D6N2sKgkFo2FqguP44Nw2eyDlbTdZwd9GYk98DZG9QItIiTlFLHJHjxP3FA==",
      "cpu": [
        "ppc64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-riscv64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-riscv64/-/linux-riscv64-0.18.20.tgz",
      "integrity": "sha512-WSxo6h5ecI5XH34KC7w5veNnKkju3zBRLEQNY7mv5mtBmrP/MjNBCAlsM2u5hDBlS3NGcTQpoBvRzqBcRtpq1A==",
      "cpu": [
        "riscv64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-s390x": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-s390x/-/linux-s390x-0.18.20.tgz",
      "integrity": "sha512-+8231GMs3mAEth6Ja1iK0a1sQ3ohfcpzpRLH8uuc5/KVDFneH6jtAJLFGafpzpMRO6DzJ6AvXKze9LfFMrIHVQ==",
      "cpu": [
        "s390x"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/linux-x64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.18.20.tgz",
      "integrity": "sha512-UYqiqemphJcNsFEskc73jQ7B9jgwjWrSayxawS6UVFZGWrAAtkzjxSqnoclCXxWtfwLdzU+vTpcNYhpn43uP1w==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "linux"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/netbsd-x64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/netbsd-x64/-/netbsd-x64-0.18.20.tgz",
      "integrity": "sha512-iO1c++VP6xUBUmltHZoMtCUdPlnPGdBom6IrO4gyKPFFVBKioIImVooR5I83nTew5UOYrk3gIJhbZh8X44y06A==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "netbsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/openbsd-x64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/openbsd-x64/-/openbsd-x64-0.18.20.tgz",
      "integrity": "sha512-e5e4YSsuQfX4cxcygw/UCPIEP6wbIL+se3sxPdCiMbFLBWu0eiZOJ7WoD+ptCLrmjZBK1Wk7I6D/I3NglUGOxg==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "openbsd"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/sunos-x64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/sunos-x64/-/sunos-x64-0.18.20.tgz",
      "integrity": "sha512-kDbFRFp0YpTQVVrqUd5FTYmWo45zGaXe0X8E1G/LKFC0v8x0vWrhOWSLITcCn63lmZIxfOMXtCfti/RxN/0wnQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "sunos"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/win32-arm64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-arm64/-/win32-arm64-0.18.20.tgz",
      "integrity": "sha512-ddYFR6ItYgoaq4v4JmQQaAI5s7npztfV4Ag6NrhiaW0RrnOXqBkgwZLofVTlq1daVTQNhtI5oieTvkRPfZrePg==",
      "cpu": [
        "arm64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/win32-ia32": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-ia32/-/win32-ia32-0.18.20.tgz",
      "integrity": "sha512-Wv7QBi3ID/rROT08SABTS7eV4hX26sVduqDOTe1MvGMjNd3EjOz4b7zeexIR62GTIEKrfJXKL9LFxTYgkyeu7g==",
      "cpu": [
        "ia32"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@esbuild/win32-x64": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/@esbuild/win32-x64/-/win32-x64-0.18.20.tgz",
      "integrity": "sha512-kTdfRcSiDfQca/y9QIkng02avJ+NCaQvrMejlsB3RRv5sE9rRoeBPISaZpKxHELzRxZyLvNts1P27W3wV+8geQ==",
      "cpu": [
        "x64"
      ],
      "dev": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "win32"
      ],
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/@jridgewell/gen-mapping": {
      "version": "0.3.13",
      "resolved": "https://registry.npmjs.org/@jridgewell/gen-mapping/-/gen-mapping-0.3.13.tgz",
      "integrity": "sha512-2kkt/7niJ6MgEPxF0bYdQ6etZaA+fQvDcLKckhy1yIQOzaoKjBBjSj63/aLVjYE3qhRt5dvM+uUyfCg6UKCBbA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@jridgewell/sourcemap-codec": "^1.5.0",
        "@jridgewell/trace-mapping": "^0.3.24"
      }
    },
    "node_modules/@jridgewell/remapping": {
      "version": "2.3.5",
      "resolved": "https://registry.npmjs.org/@jridgewell/remapping/-/remapping-2.3.5.tgz",
      "integrity": "sha512-LI9u/+laYG4Ds1TDKSJW2YPrIlcVYOwi2fUC6xB43lueCjgxV4lffOCZCtYFiH6TNOX+tQKXx97T4IKHbhyHEQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@jridgewell/gen-mapping": "^0.3.5",
        "@jridgewell/trace-mapping": "^0.3.24"
      }
    },
    "node_modules/@jridgewell/resolve-uri": {
      "version": "3.1.2",
      "resolved": "https://registry.npmjs.org/@jridgewell/resolve-uri/-/resolve-uri-3.1.2.tgz",
      "integrity": "sha512-bRISgCIjP20/tbWSPWMEi54QVPRZExkuD9lJL+UIxUKtwVJA8wW1Trb1jMs1RFXo1CBTNZ/5hpC9QvmKWdopKw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/@jridgewell/sourcemap-codec": {
      "version": "1.5.5",
      "resolved": "https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.5.tgz",
      "integrity": "sha512-cYQ9310grqxueWbl+WuIUIaiUaDcj7WOq5fVhEljNVgRfOUhY9fy2zTvfoqWsnebh8Sl70VScFbICvJnLKB0Og==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@jridgewell/trace-mapping": {
      "version": "0.3.31",
      "resolved": "https://registry.npmjs.org/@jridgewell/trace-mapping/-/trace-mapping-0.3.31.tgz",
      "integrity": "sha512-zzNR+SdQSDJzc8joaeP8QQoCQr8NuYx2dIIytl1QeBEZHJ9uW6hebsrYgbz8hJwUQao3TWCMtmfV8Nu1twOLAw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@jridgewell/resolve-uri": "^3.1.0",
        "@jridgewell/sourcemap-codec": "^1.4.14"
      }
    },
    "node_modules/@nodelib/fs.scandir": {
      "version": "2.1.5",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz",
      "integrity": "sha512-vq24Bq3ym5HEQm2NKCr3yXDwjc7vTsEThRDnkp2DK9p1uqLR+DHurm/NOTo0KG7HYHU7eppKZj3MyqYuMBf62g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@nodelib/fs.stat": "2.0.5",
        "run-parallel": "^1.1.9"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@nodelib/fs.stat": {
      "version": "2.0.5",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz",
      "integrity": "sha512-RkhPPp2zrqDAQA/2jNhnztcPAlv64XdhIp7a7454A5ovI7Bukxgt7MX7udwAu3zg1DcpPU0rz3VV1SeaqvY4+A==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@nodelib/fs.walk": {
      "version": "1.2.8",
      "resolved": "https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz",
      "integrity": "sha512-oGB+UxlgWcgQkgwo8GcEGwemoTFt3FIO9ababBmaGwXIoBKZ+GTy0pP185beGg7Llih/NSHSV2XAs1lnznocSg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@nodelib/fs.scandir": "2.1.5",
        "fastq": "^1.6.0"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/@rolldown/pluginutils": {
      "version": "1.0.0-beta.27",
      "resolved": "https://registry.npmjs.org/@rolldown/pluginutils/-/pluginutils-1.0.0-beta.27.tgz",
      "integrity": "sha512-+d0F4MKMCbeVUJwG96uQ4SgAznZNSq93I3V+9NHA4OpvqG8mRCpGdKmK8l/dl02h2CCDHwW2FqilnTyDcAnqjA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@supabase/auth-js": {
      "version": "2.105.1",
      "resolved": "https://registry.npmjs.org/@supabase/auth-js/-/auth-js-2.105.1.tgz",
      "integrity": "sha512-zc4s8Xg4truwE1Q4Q8M8oUVDARMd05pKh73NyQsMbYU1HDdDN2iiKzena/yu+yJze3WrD4c092FdckPiK1rLQw==",
      "license": "MIT",
      "dependencies": {
        "tslib": "2.8.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/functions-js": {
      "version": "2.105.1",
      "resolved": "https://registry.npmjs.org/@supabase/functions-js/-/functions-js-2.105.1.tgz",
      "integrity": "sha512-dTk1e7oE51VGc1lS2S0J0NLo0Wp4JYChj74ArJKbIWgoWuFwO0wcJYjeyOV3AAEpKst8/LQWUZOUKO1tRXBrpA==",
      "license": "MIT",
      "dependencies": {
        "tslib": "2.8.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/phoenix": {
      "version": "0.4.1",
      "resolved": "https://registry.npmjs.org/@supabase/phoenix/-/phoenix-0.4.1.tgz",
      "integrity": "sha512-hWGJkDAfWUNY8k0C080u3sGNFd2ncl9erhKgP7hnGkgJWEfT5Pd/SXal4QmWXBECVlZrannMAc9sBaaRyWpiUA==",
      "license": "MIT"
    },
    "node_modules/@supabase/postgrest-js": {
      "version": "2.105.1",
      "resolved": "https://registry.npmjs.org/@supabase/postgrest-js/-/postgrest-js-2.105.1.tgz",
      "integrity": "sha512-6SbtsoWC55xfsm7gbfLqvF+yIwTQEbjt+jFGf4klDpwSnUy17Hv5x0Dq52oqwTQlw6Ta0h1D5gTP0/pApqNojA==",
      "license": "MIT",
      "dependencies": {
        "tslib": "2.8.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/realtime-js": {
      "version": "2.105.1",
      "resolved": "https://registry.npmjs.org/@supabase/realtime-js/-/realtime-js-2.105.1.tgz",
      "integrity": "sha512-3X3cUEl5cJ4lRQHr1hXHx0b98OaL97RRO2vrRZ98FD91JV/MquZHhrGJSv/+IkOnjF6E2e0RUOxE8P3Zi035ow==",
      "license": "MIT",
      "dependencies": {
        "@supabase/phoenix": "^0.4.1",
        "@types/ws": "^8.18.1",
        "tslib": "2.8.1",
        "ws": "^8.18.2"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/storage-js": {
      "version": "2.105.1",
      "resolved": "https://registry.npmjs.org/@supabase/storage-js/-/storage-js-2.105.1.tgz",
      "integrity": "sha512-owfdCNH5ikXXDusjzsgU6LavEBqGUoueOnL/9XIucld70/WJ/rbqp89K//c9QPICDNuegsmpoeasydDAiucLKQ==",
      "license": "MIT",
      "dependencies": {
        "iceberg-js": "^0.8.1",
        "tslib": "2.8.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@supabase/supabase-js": {
      "version": "2.105.1",
      "resolved": "https://registry.npmjs.org/@supabase/supabase-js/-/supabase-js-2.105.1.tgz",
      "integrity": "sha512-4gn6HmsAkCCVU7p8JmgKGhHJ5Btod4ZzSp8qKZf4JHaTxbhaIK86/usHzeLxWv7EJJDhBmILDmJOSOf9iF4CLA==",
      "license": "MIT",
      "dependencies": {
        "@supabase/auth-js": "2.105.1",
        "@supabase/functions-js": "2.105.1",
        "@supabase/postgrest-js": "2.105.1",
        "@supabase/realtime-js": "2.105.1",
        "@supabase/storage-js": "2.105.1"
      },
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/@types/babel__core": {
      "version": "7.20.5",
      "resolved": "https://registry.npmjs.org/@types/babel__core/-/babel__core-7.20.5.tgz",
      "integrity": "sha512-qoQprZvz5wQFJwMDqeseRXWv3rqMvhgpbXFfVyWhbx9X47POIA6i/+dXefEmZKoAgOaTdaIgNSMqMIU61yRyzA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/parser": "^7.20.7",
        "@babel/types": "^7.20.7",
        "@types/babel__generator": "*",
        "@types/babel__template": "*",
        "@types/babel__traverse": "*"
      }
    },
    "node_modules/@types/babel__generator": {
      "version": "7.27.0",
      "resolved": "https://registry.npmjs.org/@types/babel__generator/-/babel__generator-7.27.0.tgz",
      "integrity": "sha512-ufFd2Xi92OAVPYsy+P4n7/U7e68fex0+Ee8gSG9KX7eo084CWiQ4sdxktvdl0bOPupXtVJPY19zk6EwWqUQ8lg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/types": "^7.0.0"
      }
    },
    "node_modules/@types/babel__template": {
      "version": "7.4.4",
      "resolved": "https://registry.npmjs.org/@types/babel__template/-/babel__template-7.4.4.tgz",
      "integrity": "sha512-h/NUaSyG5EyxBIp8YRxo4RMe2/qQgvyowRwVMzhYhBCONbW8PUsg4lkFMrhgZhUe5z3L3MiLDuvyJ/CaPa2A8A==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/parser": "^7.1.0",
        "@babel/types": "^7.0.0"
      }
    },
    "node_modules/@types/babel__traverse": {
      "version": "7.28.0",
      "resolved": "https://registry.npmjs.org/@types/babel__traverse/-/babel__traverse-7.28.0.tgz",
      "integrity": "sha512-8PvcXf70gTDZBgt9ptxJ8elBeBjcLOAcOtoO/mPJjtji1+CdGbHgm77om1GrsPxsiE+uXIpNSK64UYaIwQXd4Q==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/types": "^7.28.2"
      }
    },
    "node_modules/@types/node": {
      "version": "25.6.0",
      "resolved": "https://registry.npmjs.org/@types/node/-/node-25.6.0.tgz",
      "integrity": "sha512-+qIYRKdNYJwY3vRCZMdJbPLJAtGjQBudzZzdzwQYkEPQd+PJGixUL5QfvCLDaULoLv+RhT3LDkwEfKaAkgSmNQ==",
      "license": "MIT",
      "dependencies": {
        "undici-types": "~7.19.0"
      }
    },
    "node_modules/@types/prop-types": {
      "version": "15.7.15",
      "resolved": "https://registry.npmjs.org/@types/prop-types/-/prop-types-15.7.15.tgz",
      "integrity": "sha512-F6bEyamV9jKGAFBEmlQnesRPGOQqS2+Uwi0Em15xenOxHaf2hv6L8YCVn3rPdPJOiJfPiCnLIRyvwVaqMY3MIw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/@types/react": {
      "version": "18.3.28",
      "resolved": "https://registry.npmjs.org/@types/react/-/react-18.3.28.tgz",
      "integrity": "sha512-z9VXpC7MWrhfWipitjNdgCauoMLRdIILQsAEV+ZesIzBq/oUlxk0m3ApZuMFCXdnS4U7KrI+l3WRUEGQ8K1QKw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@types/prop-types": "*",
        "csstype": "^3.2.2"
      }
    },
    "node_modules/@types/react-dom": {
      "version": "18.3.7",
      "resolved": "https://registry.npmjs.org/@types/react-dom/-/react-dom-18.3.7.tgz",
      "integrity": "sha512-MEe3UeoENYVFXzoXEWsvcpg6ZvlrFNlOQ7EOsvhI3CfAXwzPfO8Qwuxd40nepsYKqyyVQnTdEfv68q91yLcKrQ==",
      "dev": true,
      "license": "MIT",
      "peerDependencies": {
        "@types/react": "^18.0.0"
      }
    },
    "node_modules/@types/ws": {
      "version": "8.18.1",
      "resolved": "https://registry.npmjs.org/@types/ws/-/ws-8.18.1.tgz",
      "integrity": "sha512-ThVF6DCVhA8kUGy+aazFQ4kXQ7E1Ty7A3ypFOe0IcJV8O/M511G99AW24irKrW56Wt44yG9+ij8FaqoBGkuBXg==",
      "license": "MIT",
      "dependencies": {
        "@types/node": "*"
      }
    },
    "node_modules/@vitejs/plugin-react": {
      "version": "4.7.0",
      "resolved": "https://registry.npmjs.org/@vitejs/plugin-react/-/plugin-react-4.7.0.tgz",
      "integrity": "sha512-gUu9hwfWvvEDBBmgtAowQCojwZmJ5mcLn3aufeCsitijs3+f2NsrPtlAWIR6OPiqljl96GVCUbLe0HyqIpVaoA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@babel/core": "^7.28.0",
        "@babel/plugin-transform-react-jsx-self": "^7.27.1",
        "@babel/plugin-transform-react-jsx-source": "^7.27.1",
        "@rolldown/pluginutils": "1.0.0-beta.27",
        "@types/babel__core": "^7.20.5",
        "react-refresh": "^0.17.0"
      },
      "engines": {
        "node": "^14.18.0 || >=16.0.0"
      },
      "peerDependencies": {
        "vite": "^4.2.0 || ^5.0.0 || ^6.0.0 || ^7.0.0"
      }
    },
    "node_modules/any-promise": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/any-promise/-/any-promise-1.3.0.tgz",
      "integrity": "sha512-7UvmKalWRt1wgjL1RrGxoSJW/0QZFIegpeGvZG9kjp8vrRu55XTHbwnqq2GpXm9uLbcuhxm3IqX9OB4MZR1b2A==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/anymatch": {
      "version": "3.1.3",
      "resolved": "https://registry.npmjs.org/anymatch/-/anymatch-3.1.3.tgz",
      "integrity": "sha512-KMReFUr0B4t+D+OBkjR3KYqvocp2XaSzO55UcB6mgQMd3KbcE+mWTyvVV7D/zsdEbNnV6acZUutkiHQXvTr1Rw==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "normalize-path": "^3.0.0",
        "picomatch": "^2.0.4"
      },
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/arg": {
      "version": "5.0.2",
      "resolved": "https://registry.npmjs.org/arg/-/arg-5.0.2.tgz",
      "integrity": "sha512-PYjyFOLKQ9y57JvQ6QLo8dAgNqswh8M1RMJYdQduT6xbWSgK36P/Z/v+p888pM69jMMfS8Xd8F6I1kQ/I9HUGg==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/autoprefixer": {
      "version": "10.5.0",
      "resolved": "https://registry.npmjs.org/autoprefixer/-/autoprefixer-10.5.0.tgz",
      "integrity": "sha512-FMhOoZV4+qR6aTUALKX2rEqGG+oyATvwBt9IIzVR5rMa2HRWPkxf+P+PAJLD1I/H5/II+HuZcBJYEFBpq39ong==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/autoprefixer"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "browserslist": "^4.28.2",
        "caniuse-lite": "^1.0.30001787",
        "fraction.js": "^5.3.4",
        "picocolors": "^1.1.1",
        "postcss-value-parser": "^4.2.0"
      },
      "bin": {
        "autoprefixer": "bin/autoprefixer"
      },
      "engines": {
        "node": "^10 || ^12 || >=14"
      },
      "peerDependencies": {
        "postcss": "^8.1.0"
      }
    },
    "node_modules/baseline-browser-mapping": {
      "version": "2.10.24",
      "resolved": "https://registry.npmjs.org/baseline-browser-mapping/-/baseline-browser-mapping-2.10.24.tgz",
      "integrity": "sha512-I2NkZOOrj2XuguvWCK6OVh9GavsNjZjK908Rq3mIBK25+GD8vPX5w2WdxVqnQ7xx3SrZJiCiZFu+/Oz50oSYSA==",
      "dev": true,
      "license": "Apache-2.0",
      "bin": {
        "baseline-browser-mapping": "dist/cli.cjs"
      },
      "engines": {
        "node": ">=6.0.0"
      }
    },
    "node_modules/binary-extensions": {
      "version": "2.3.0",
      "resolved": "https://registry.npmjs.org/binary-extensions/-/binary-extensions-2.3.0.tgz",
      "integrity": "sha512-Ceh+7ox5qe7LJuLHoY0feh3pHuUDHAcRUeyL2VYghZwfpkNIy/+8Ocg0a3UuSoYzavmylwuLWQOf3hl0jjMMIw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=8"
      },
      "funding": {
        "url": "https://github.com/sponsors/sindresorhus"
      }
    },
    "node_modules/braces": {
      "version": "3.0.3",
      "resolved": "https://registry.npmjs.org/braces/-/braces-3.0.3.tgz",
      "integrity": "sha512-yQbXgO/OSZVD2IsiLlro+7Hf6Q18EJrKSEsdoMzKePKXct3gvD8oLcOQdIzGupr5Fj+EDe8gO/lxc1BzfMpxvA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "fill-range": "^7.1.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/browserslist": {
      "version": "4.28.2",
      "resolved": "https://registry.npmjs.org/browserslist/-/browserslist-4.28.2.tgz",
      "integrity": "sha512-48xSriZYYg+8qXna9kwqjIVzuQxi+KYWp2+5nCYnYKPTr0LvD89Jqk2Or5ogxz0NUMfIjhh2lIUX/LyX9B4oIg==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/browserslist"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/browserslist"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "baseline-browser-mapping": "^2.10.12",
        "caniuse-lite": "^1.0.30001782",
        "electron-to-chromium": "^1.5.328",
        "node-releases": "^2.0.36",
        "update-browserslist-db": "^1.2.3"
      },
      "bin": {
        "browserslist": "cli.js"
      },
      "engines": {
        "node": "^6 || ^7 || ^8 || ^9 || ^10 || ^11 || ^12 || >=13.7"
      }
    },
    "node_modules/camelcase-css": {
      "version": "2.0.1",
      "resolved": "https://registry.npmjs.org/camelcase-css/-/camelcase-css-2.0.1.tgz",
      "integrity": "sha512-QOSvevhslijgYwRx6Rv7zKdMF8lbRmx+uQGx2+vDc+KI/eBnsy9kit5aj23AgGu3pa4t9AgwbnXWqS+iOY+2aA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/caniuse-lite": {
      "version": "1.0.30001791",
      "resolved": "https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001791.tgz",
      "integrity": "sha512-yk0l/YSrOnFZk3UROpDLQD9+kC1l4meK/wed583AXrzoarMGJcbRi2Q4RaUYbKxYAsZ8sWmaSa/DsLmdBeI1vQ==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/browserslist"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/caniuse-lite"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "CC-BY-4.0"
    },
    "node_modules/chokidar": {
      "version": "3.6.0",
      "resolved": "https://registry.npmjs.org/chokidar/-/chokidar-3.6.0.tgz",
      "integrity": "sha512-7VT13fmjotKpGipCW9JEQAusEPE+Ei8nl6/g4FBAmIm0GOOLMua9NDDo/DWp0ZAxCr3cPq5ZpBqmPAQgDda2Pw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "anymatch": "~3.1.2",
        "braces": "~3.0.2",
        "glob-parent": "~5.1.2",
        "is-binary-path": "~2.1.0",
        "is-glob": "~4.0.1",
        "normalize-path": "~3.0.0",
        "readdirp": "~3.6.0"
      },
      "engines": {
        "node": ">= 8.10.0"
      },
      "funding": {
        "url": "https://paulmillr.com/funding/"
      },
      "optionalDependencies": {
        "fsevents": "~2.3.2"
      }
    },
    "node_modules/chokidar/node_modules/glob-parent": {
      "version": "5.1.2",
      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
      "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "is-glob": "^4.0.1"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/commander": {
      "version": "4.1.1",
      "resolved": "https://registry.npmjs.org/commander/-/commander-4.1.1.tgz",
      "integrity": "sha512-NOKm8xhkzAjzFx8B2v5OAHT+u5pRQc2UCa2Vq9jYL/31o2wi9mxBA7LIFs3sV5VSC49z6pEhfbMULvShKj26WA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/convert-source-map": {
      "version": "2.0.0",
      "resolved": "https://registry.npmjs.org/convert-source-map/-/convert-source-map-2.0.0.tgz",
      "integrity": "sha512-Kvp459HrV2FEJ1CAsi1Ku+MY3kasH19TFykTz2xWmMeq6bk2NU3XXvfJ+Q61m0xktWwt+1HSYf3JZsTms3aRJg==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/cookie": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/cookie/-/cookie-1.1.1.tgz",
      "integrity": "sha512-ei8Aos7ja0weRpFzJnEA9UHJ/7XQmqglbRwnf2ATjcB9Wq874VKH9kfjjirM6UhU2/E5fFYadylyhFldcqSidQ==",
      "license": "MIT",
      "engines": {
        "node": ">=18"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/express"
      }
    },
    "node_modules/cssesc": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/cssesc/-/cssesc-3.0.0.tgz",
      "integrity": "sha512-/Tb/JcjK111nNScGob5MNtsntNM1aCNUDipB/TkwZFhyDrrE47SOx/18wF2bbjgc3ZzCSKW1T5nt5EbFoAz/Vg==",
      "dev": true,
      "license": "MIT",
      "bin": {
        "cssesc": "bin/cssesc"
      },
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/csstype": {
      "version": "3.2.3",
      "resolved": "https://registry.npmjs.org/csstype/-/csstype-3.2.3.tgz",
      "integrity": "sha512-z1HGKcYy2xA8AGQfwrn0PAy+PB7X/GSj3UVJW9qKyn43xWa+gl5nXmU4qqLMRzWVLFC8KusUX8T/0kCiOYpAIQ==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/debug": {
      "version": "4.4.3",
      "resolved": "https://registry.npmjs.org/debug/-/debug-4.4.3.tgz",
      "integrity": "sha512-RGwwWnwQvkVfavKVt22FGLw+xYSdzARwm0ru6DhTVA3umU5hZc28V3kO4stgYryrTlLpuvgI9GiijltAjNbcqA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "ms": "^2.1.3"
      },
      "engines": {
        "node": ">=6.0"
      },
      "peerDependenciesMeta": {
        "supports-color": {
          "optional": true
        }
      }
    },
    "node_modules/didyoumean": {
      "version": "1.2.2",
      "resolved": "https://registry.npmjs.org/didyoumean/-/didyoumean-1.2.2.tgz",
      "integrity": "sha512-gxtyfqMg7GKyhQmb056K7M3xszy/myH8w+B4RT+QXBQsvAOdc3XymqDDPHx1BgPgsdAA5SIifona89YtRATDzw==",
      "dev": true,
      "license": "Apache-2.0"
    },
    "node_modules/dlv": {
      "version": "1.1.3",
      "resolved": "https://registry.npmjs.org/dlv/-/dlv-1.1.3.tgz",
      "integrity": "sha512-+HlytyjlPKnIG8XuRG8WvmBP8xs8P71y+SKKS6ZXWoEgLuePxtDoUEiH7WkdePWrQ5JBpE6aoVqfZfJUQkjXwA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/electron-to-chromium": {
      "version": "1.5.344",
      "resolved": "https://registry.npmjs.org/electron-to-chromium/-/electron-to-chromium-1.5.344.tgz",
      "integrity": "sha512-4MxfbmNDm+KPh066EZy+eUnkcDPcZ35wNmOWzFuh/ijvHsve6kbLTLURy88uCNK5FbpN+yk2nQY6BYh1GEt+wg==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/es-errors": {
      "version": "1.3.0",
      "resolved": "https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz",
      "integrity": "sha512-Zf5H2Kxt2xjTvbJvP2ZWLEICxA6j+hAmMzIlypy4xcBg1vKVnx89Wy0GbS+kf5cwCVFFzdCFh2XSCFNULS6csw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/esbuild": {
      "version": "0.18.20",
      "resolved": "https://registry.npmjs.org/esbuild/-/esbuild-0.18.20.tgz",
      "integrity": "sha512-ceqxoedUrcayh7Y7ZX6NdbbDzGROiyVBgC4PriJThBKSVPWnnFHZAkfI1lJT8QFkOwH4qOS2SJkS4wvpGl8BpA==",
      "dev": true,
      "hasInstallScript": true,
      "license": "MIT",
      "bin": {
        "esbuild": "bin/esbuild"
      },
      "engines": {
        "node": ">=12"
      },
      "optionalDependencies": {
        "@esbuild/android-arm": "0.18.20",
        "@esbuild/android-arm64": "0.18.20",
        "@esbuild/android-x64": "0.18.20",
        "@esbuild/darwin-arm64": "0.18.20",
        "@esbuild/darwin-x64": "0.18.20",
        "@esbuild/freebsd-arm64": "0.18.20",
        "@esbuild/freebsd-x64": "0.18.20",
        "@esbuild/linux-arm": "0.18.20",
        "@esbuild/linux-arm64": "0.18.20",
        "@esbuild/linux-ia32": "0.18.20",
        "@esbuild/linux-loong64": "0.18.20",
        "@esbuild/linux-mips64el": "0.18.20",
        "@esbuild/linux-ppc64": "0.18.20",
        "@esbuild/linux-riscv64": "0.18.20",
        "@esbuild/linux-s390x": "0.18.20",
        "@esbuild/linux-x64": "0.18.20",
        "@esbuild/netbsd-x64": "0.18.20",
        "@esbuild/openbsd-x64": "0.18.20",
        "@esbuild/sunos-x64": "0.18.20",
        "@esbuild/win32-arm64": "0.18.20",
        "@esbuild/win32-ia32": "0.18.20",
        "@esbuild/win32-x64": "0.18.20"
      }
    },
    "node_modules/escalade": {
      "version": "3.2.0",
      "resolved": "https://registry.npmjs.org/escalade/-/escalade-3.2.0.tgz",
      "integrity": "sha512-WUj2qlxaQtO4g6Pq5c29GTcWGDyd8itL8zTlipgECz3JesAiiOKotd8JU6otB3PACgG6xkJUyVhboMS+bje/jA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/fast-glob": {
      "version": "3.3.3",
      "resolved": "https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.3.tgz",
      "integrity": "sha512-7MptL8U0cqcFdzIzwOTHoilX9x5BrNqye7Z/LuC7kCMRio1EMSyqRK3BEAUD7sXRq4iT4AzTVuZdhgQ2TCvYLg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@nodelib/fs.stat": "^2.0.2",
        "@nodelib/fs.walk": "^1.2.3",
        "glob-parent": "^5.1.2",
        "merge2": "^1.3.0",
        "micromatch": "^4.0.8"
      },
      "engines": {
        "node": ">=8.6.0"
      }
    },
    "node_modules/fast-glob/node_modules/glob-parent": {
      "version": "5.1.2",
      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
      "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "is-glob": "^4.0.1"
      },
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/fastq": {
      "version": "1.20.1",
      "resolved": "https://registry.npmjs.org/fastq/-/fastq-1.20.1.tgz",
      "integrity": "sha512-GGToxJ/w1x32s/D2EKND7kTil4n8OVk/9mycTc4VDza13lOvpUZTGX3mFSCtV9ksdGBVzvsyAVLM6mHFThxXxw==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "reusify": "^1.0.4"
      }
    },
    "node_modules/fill-range": {
      "version": "7.1.1",
      "resolved": "https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz",
      "integrity": "sha512-YsGpe3WHLK8ZYi4tWDg2Jy3ebRz2rXowDxnld4bkQB00cc/1Zw9AWnC0i9ztDJitivtQvaI9KaLyKrc+hBW0yg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "to-regex-range": "^5.0.1"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/fraction.js": {
      "version": "5.3.4",
      "resolved": "https://registry.npmjs.org/fraction.js/-/fraction.js-5.3.4.tgz",
      "integrity": "sha512-1X1NTtiJphryn/uLQz3whtY6jK3fTqoE3ohKs0tT+Ujr1W59oopxmoEh7Lu5p6vBaPbgoM0bzveAW4Qi5RyWDQ==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": "*"
      },
      "funding": {
        "type": "github",
        "url": "https://github.com/sponsors/rawify"
      }
    },
    "node_modules/framer-motion": {
      "version": "10.18.0",
      "resolved": "https://registry.npmjs.org/framer-motion/-/framer-motion-10.18.0.tgz",
      "integrity": "sha512-oGlDh1Q1XqYPksuTD/usb0I70hq95OUzmL9+6Zd+Hs4XV0oaISBa/UUMSjYiq6m8EUF32132mOJ8xVZS+I0S6w==",
      "license": "MIT",
      "dependencies": {
        "tslib": "^2.4.0"
      },
      "optionalDependencies": {
        "@emotion/is-prop-valid": "^0.8.2"
      },
      "peerDependencies": {
        "react": "^18.0.0",
        "react-dom": "^18.0.0"
      },
      "peerDependenciesMeta": {
        "react": {
          "optional": true
        },
        "react-dom": {
          "optional": true
        }
      }
    },
    "node_modules/fsevents": {
      "version": "2.3.3",
      "resolved": "https://registry.npmjs.org/fsevents/-/fsevents-2.3.3.tgz",
      "integrity": "sha512-5xoDfX+fL7faATnagmWPpbFtwh/R77WmMMqqHGS65C3vvB0YHrgF+B1YmZ3441tMj5n63k0212XNoJwzlhffQw==",
      "dev": true,
      "hasInstallScript": true,
      "license": "MIT",
      "optional": true,
      "os": [
        "darwin"
      ],
      "engines": {
        "node": "^8.16.0 || ^10.6.0 || >=11.0.0"
      }
    },
    "node_modules/function-bind": {
      "version": "1.1.2",
      "resolved": "https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz",
      "integrity": "sha512-7XHNxH7qX9xG5mIwxkhumTox/MIRNcOgDrxWsMt2pAr23WHp6MrRlN7FBSFpCpr+oVO0F744iUgR82nJMfG2SA==",
      "dev": true,
      "license": "MIT",
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/gensync": {
      "version": "1.0.0-beta.2",
      "resolved": "https://registry.npmjs.org/gensync/-/gensync-1.0.0-beta.2.tgz",
      "integrity": "sha512-3hN7NaskYvMDLQY55gnW3NQ+mesEAepTqlg+VEbj7zzqEMBVNhzcGYYeqFo/TlYz6eQiFcp1HcsCZO+nGgS8zg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=6.9.0"
      }
    },
    "node_modules/glob-parent": {
      "version": "6.0.2",
      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz",
      "integrity": "sha512-XxwI8EOhVQgWp6iDL+3b0r86f4d6AX6zSU55HfB4ydCEuXLXc5FcYeOu+nnGftS4TEju/11rt4KJPTMgbfmv4A==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "is-glob": "^4.0.3"
      },
      "engines": {
        "node": ">=10.13.0"
      }
    },
    "node_modules/hasown": {
      "version": "2.0.3",
      "resolved": "https://registry.npmjs.org/hasown/-/hasown-2.0.3.tgz",
      "integrity": "sha512-ej4AhfhfL2Q2zpMmLo7U1Uv9+PyhIZpgQLGT1F9miIGmiCJIoCgSmczFdrc97mWT4kVY72KA+WnnhJ5pghSvSg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "function-bind": "^1.1.2"
      },
      "engines": {
        "node": ">= 0.4"
      }
    },
    "node_modules/iceberg-js": {
      "version": "0.8.1",
      "resolved": "https://registry.npmjs.org/iceberg-js/-/iceberg-js-0.8.1.tgz",
      "integrity": "sha512-1dhVQZXhcHje7798IVM+xoo/1ZdVfzOMIc8/rgVSijRK38EDqOJoGula9N/8ZI5RD8QTxNQtK/Gozpr+qUqRRA==",
      "license": "MIT",
      "engines": {
        "node": ">=20.0.0"
      }
    },
    "node_modules/is-binary-path": {
      "version": "2.1.0",
      "resolved": "https://registry.npmjs.org/is-binary-path/-/is-binary-path-2.1.0.tgz",
      "integrity": "sha512-ZMERYes6pDydyuGidse7OsHxtbI7WVeUEozgR/g7rd0xUimYNlvZRE/K2MgZTjWy725IfelLeVcEM97mmtRGXw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "binary-extensions": "^2.0.0"
      },
      "engines": {
        "node": ">=8"
      }
    },
    "node_modules/is-core-module": {
      "version": "2.16.1",
      "resolved": "https://registry.npmjs.org/is-core-module/-/is-core-module-2.16.1.tgz",
      "integrity": "sha512-UfoeMA6fIJ8wTYFEUjelnaGI67v6+N7qXJEvQuIGa99l4xsCruSYOVSQ0uPANn4dAzm8lkYPaKLrrijLq7x23w==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "hasown": "^2.0.2"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/is-extglob": {
      "version": "2.1.1",
      "resolved": "https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz",
      "integrity": "sha512-SbKbANkN603Vi4jEZv49LeVJMn4yGwsbzZworEoyEiutsN3nJYdbO36zfhGJ6QEDpOZIFkDtnq5JRxmvl3jsoQ==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/is-glob": {
      "version": "4.0.3",
      "resolved": "https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz",
      "integrity": "sha512-xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "is-extglob": "^2.1.1"
      },
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/is-number": {
      "version": "7.0.0",
      "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
      "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.12.0"
      }
    },
    "node_modules/jiti": {
      "version": "1.21.7",
      "resolved": "https://registry.npmjs.org/jiti/-/jiti-1.21.7.tgz",
      "integrity": "sha512-/imKNG4EbWNrVjoNC/1H5/9GFy+tqjGBHCaSsN+P2RnPqjsLmv6UD3Ej+Kj8nBWaRAwyk7kK5ZUc+OEatnTR3A==",
      "dev": true,
      "license": "MIT",
      "bin": {
        "jiti": "bin/jiti.js"
      }
    },
    "node_modules/js-tokens": {
      "version": "4.0.0",
      "resolved": "https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz",
      "integrity": "sha512-RdJUflcE3cUzKiMqQgsCu06FPu9UdIJO0beYbPhHN4k6apgJtifcoCtT9bcxOpYBtpD2kCM6Sbzg4CausW/PKQ==",
      "license": "MIT"
    },
    "node_modules/jsesc": {
      "version": "3.1.0",
      "resolved": "https://registry.npmjs.org/jsesc/-/jsesc-3.1.0.tgz",
      "integrity": "sha512-/sM3dO2FOzXjKQhJuo0Q173wf2KOo8t4I8vHy6lF9poUp7bKT0/NHE8fPX23PwfhnykfqnC2xRxOnVw5XuGIaA==",
      "dev": true,
      "license": "MIT",
      "bin": {
        "jsesc": "bin/jsesc"
      },
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/json5": {
      "version": "2.2.3",
      "resolved": "https://registry.npmjs.org/json5/-/json5-2.2.3.tgz",
      "integrity": "sha512-XmOWe7eyHYH14cLdVPoyg+GOH3rYX++KpzrylJwSW98t3Nk+U8XOl8FWKOgwtzdb8lXGf6zYwDUzeHMWfxasyg==",
      "dev": true,
      "license": "MIT",
      "bin": {
        "json5": "lib/cli.js"
      },
      "engines": {
        "node": ">=6"
      }
    },
    "node_modules/lilconfig": {
      "version": "3.1.3",
      "resolved": "https://registry.npmjs.org/lilconfig/-/lilconfig-3.1.3.tgz",
      "integrity": "sha512-/vlFKAoH5Cgt3Ie+JLhRbwOsCQePABiU3tJ1egGvyQ+33R/vcwM2Zl2QR/LzjsBeItPt3oSVXapn+m4nQDvpzw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=14"
      },
      "funding": {
        "url": "https://github.com/sponsors/antonk52"
      }
    },
    "node_modules/lines-and-columns": {
      "version": "1.2.4",
      "resolved": "https://registry.npmjs.org/lines-and-columns/-/lines-and-columns-1.2.4.tgz",
      "integrity": "sha512-7ylylesZQ/PV29jhEDl3Ufjo6ZX7gCqJr5F7PKrqc93v7fzSymt1BpwEU8nAUXs8qzzvqhbjhK5QZg6Mt/HkBg==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/loose-envify": {
      "version": "1.4.0",
      "resolved": "https://registry.npmjs.org/loose-envify/-/loose-envify-1.4.0.tgz",
      "integrity": "sha512-lyuxPGr/Wfhrlem2CL/UcnUc1zcqKAImBDzukY7Y5F/yQiNdko6+fRLevlw1HgMySw7f611UIY408EtxRSoK3Q==",
      "license": "MIT",
      "dependencies": {
        "js-tokens": "^3.0.0 || ^4.0.0"
      },
      "bin": {
        "loose-envify": "cli.js"
      }
    },
    "node_modules/lru-cache": {
      "version": "5.1.1",
      "resolved": "https://registry.npmjs.org/lru-cache/-/lru-cache-5.1.1.tgz",
      "integrity": "sha512-KpNARQA3Iwv+jTA0utUVVbrh+Jlrr1Fv0e56GGzAFOXN7dk/FviaDW8LHmK52DlcH4WP2n6gI8vN1aesBFgo9w==",
      "dev": true,
      "license": "ISC",
      "dependencies": {
        "yallist": "^3.0.2"
      }
    },
    "node_modules/lucide-react": {
      "version": "0.284.0",
      "resolved": "https://registry.npmjs.org/lucide-react/-/lucide-react-0.284.0.tgz",
      "integrity": "sha512-dVSMHYAya/TeY3+vsk+VQJEKNQN2AhIo0+Dp09B2qpzvcBuu93H98YZykFcjIAfmanFiDd8nqfXFR38L757cyQ==",
      "license": "ISC",
      "peerDependencies": {
        "react": "^16.5.1 || ^17.0.0 || ^18.0.0"
      }
    },
    "node_modules/merge2": {
      "version": "1.4.1",
      "resolved": "https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz",
      "integrity": "sha512-8q7VEgMJW4J8tcfVPy8g09NcQwZdbwFEqhe/WZkoIzjn/3TGDwtOCYtXGxA3O8tPzpczCCDgv+P2P5y00ZJOOg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 8"
      }
    },
    "node_modules/micromatch": {
      "version": "4.0.8",
      "resolved": "https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz",
      "integrity": "sha512-PXwfBhYu0hBCPw8Dn0E+WDYb7af3dSLVWKi3HGv84IdF4TyFoC0ysxFd0Goxw7nSv4T/PzEJQxsYsEiFCKo2BA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "braces": "^3.0.3",
        "picomatch": "^2.3.1"
      },
      "engines": {
        "node": ">=8.6"
      }
    },
    "node_modules/ms": {
      "version": "2.1.3",
      "resolved": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",
      "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/mz": {
      "version": "2.7.0",
      "resolved": "https://registry.npmjs.org/mz/-/mz-2.7.0.tgz",
      "integrity": "sha512-z81GNO7nnYMEhrGh9LeymoE4+Yr0Wn5McHIZMK5cfQCl+NDX08sCZgUc9/6MHni9IWuFLm1Z3HTCXu2z9fN62Q==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "any-promise": "^1.0.0",
        "object-assign": "^4.0.1",
        "thenify-all": "^1.0.0"
      }
    },
    "node_modules/nanoid": {
      "version": "3.3.11",
      "resolved": "https://registry.npmjs.org/nanoid/-/nanoid-3.3.11.tgz",
      "integrity": "sha512-N8SpfPUnUp1bK+PMYW8qSWdl9U+wwNWI4QKxOYDy9JAro3WMX7p2OeVRF9v+347pnakNevPmiHhNmZ2HbFA76w==",
      "dev": true,
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "MIT",
      "bin": {
        "nanoid": "bin/nanoid.cjs"
      },
      "engines": {
        "node": "^10 || ^12 || ^13.7 || ^14 || >=15.0.1"
      }
    },
    "node_modules/node-releases": {
      "version": "2.0.38",
      "resolved": "https://registry.npmjs.org/node-releases/-/node-releases-2.0.38.tgz",
      "integrity": "sha512-3qT/88Y3FbH/Kx4szpQQ4HzUbVrHPKTLVpVocKiLfoYvw9XSGOX2FmD2d6DrXbVYyAQTF2HeF6My8jmzx7/CRw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/normalize-path": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/normalize-path/-/normalize-path-3.0.0.tgz",
      "integrity": "sha512-6eZs5Ls3WtCisHWp9S2GUy8dqkpGi4BVSz3GaqiE6ezub0512ESztXUwUB6C6IKbQkY2Pnb/mD4WYojCRwcwLA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/object-assign": {
      "version": "4.1.1",
      "resolved": "https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz",
      "integrity": "sha512-rJgTQnkUnH1sFw8yT6VSU3zD3sWmu6sZhIseY8VX+GRu3P6F7Fu+JNDoXfklElbLJSnc3FUQHVe4cU5hj+BcUg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/object-hash": {
      "version": "3.0.0",
      "resolved": "https://registry.npmjs.org/object-hash/-/object-hash-3.0.0.tgz",
      "integrity": "sha512-RSn9F68PjH9HqtltsSnqYC1XXoWe9Bju5+213R98cNGttag9q9yAOTzdbsqvIa7aNm5WffBZFpWYr2aWrklWAw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/path-parse": {
      "version": "1.0.7",
      "resolved": "https://registry.npmjs.org/path-parse/-/path-parse-1.0.7.tgz",
      "integrity": "sha512-LDJzPVEEEPR+y48z93A0Ed0yXb8pAByGWo/k5YYdYgpY2/2EsOsksJrq7lOHxryrVOn1ejG6oAp8ahvOIQD8sw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/picocolors": {
      "version": "1.1.1",
      "resolved": "https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz",
      "integrity": "sha512-xceH2snhtb5M9liqDsmEw56le376mTZkEX/jEb/RxNFyegNul7eNslCXP9FDj/Lcu0X8KEyMceP2ntpaHrDEVA==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/picomatch": {
      "version": "2.3.2",
      "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-2.3.2.tgz",
      "integrity": "sha512-V7+vQEJ06Z+c5tSye8S+nHUfI51xoXIXjHQ99cQtKUkQqqO1kO/KCJUfZXuB47h/YBlDhah2H3hdUGXn8ie0oA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=8.6"
      },
      "funding": {
        "url": "https://github.com/sponsors/jonschlinkert"
      }
    },
    "node_modules/pify": {
      "version": "2.3.0",
      "resolved": "https://registry.npmjs.org/pify/-/pify-2.3.0.tgz",
      "integrity": "sha512-udgsAY+fTnvv7kI7aaxbqwWNb0AHiB0qBO89PZKPkoTmGOgdbrHDKD+0B2X4uTfJ/FT1R09r9gTsjUjNJotuog==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/pirates": {
      "version": "4.0.7",
      "resolved": "https://registry.npmjs.org/pirates/-/pirates-4.0.7.tgz",
      "integrity": "sha512-TfySrs/5nm8fQJDcBDuUng3VOUKsd7S+zqvbOTiGXHfxX4wK31ard+hoNuvkicM/2YFzlpDgABOevKSsB4G/FA==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 6"
      }
    },
    "node_modules/postcss": {
      "version": "8.5.12",
      "resolved": "https://registry.npmjs.org/postcss/-/postcss-8.5.12.tgz",
      "integrity": "sha512-W62t/Se6rA0Az3DfCL0AqJwXuKwBeYg6nOaIgzP+xZ7N5BFCI7DYi1qs6ygUYT6rvfi6t9k65UMLJC+PHZpDAA==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/postcss"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "nanoid": "^3.3.11",
        "picocolors": "^1.1.1",
        "source-map-js": "^1.2.1"
      },
      "engines": {
        "node": "^10 || ^12 || >=14"
      }
    },
    "node_modules/postcss-import": {
      "version": "15.1.0",
      "resolved": "https://registry.npmjs.org/postcss-import/-/postcss-import-15.1.0.tgz",
      "integrity": "sha512-hpr+J05B2FVYUAXHeK1YyI267J/dDDhMU6B6civm8hSY1jYJnBXxzKDKDswzJmtLHryrjhnDjqqp/49t8FALew==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "postcss-value-parser": "^4.0.0",
        "read-cache": "^1.0.0",
        "resolve": "^1.1.7"
      },
      "engines": {
        "node": ">=14.0.0"
      },
      "peerDependencies": {
        "postcss": "^8.0.0"
      }
    },
    "node_modules/postcss-js": {
      "version": "4.1.0",
      "resolved": "https://registry.npmjs.org/postcss-js/-/postcss-js-4.1.0.tgz",
      "integrity": "sha512-oIAOTqgIo7q2EOwbhb8UalYePMvYoIeRY2YKntdpFQXNosSu3vLrniGgmH9OKs/qAkfoj5oB3le/7mINW1LCfw==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "camelcase-css": "^2.0.1"
      },
      "engines": {
        "node": "^12 || ^14 || >= 16"
      },
      "peerDependencies": {
        "postcss": "^8.4.21"
      }
    },
    "node_modules/postcss-load-config": {
      "version": "6.0.1",
      "resolved": "https://registry.npmjs.org/postcss-load-config/-/postcss-load-config-6.0.1.tgz",
      "integrity": "sha512-oPtTM4oerL+UXmx+93ytZVN82RrlY/wPUV8IeDxFrzIjXOLF1pN+EmKPLbubvKHT2HC20xXsCAH2Z+CKV6Oz/g==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "lilconfig": "^3.1.1"
      },
      "engines": {
        "node": ">= 18"
      },
      "peerDependencies": {
        "jiti": ">=1.21.0",
        "postcss": ">=8.0.9",
        "tsx": "^4.8.1",
        "yaml": "^2.4.2"
      },
      "peerDependenciesMeta": {
        "jiti": {
          "optional": true
        },
        "postcss": {
          "optional": true
        },
        "tsx": {
          "optional": true
        },
        "yaml": {
          "optional": true
        }
      }
    },
    "node_modules/postcss-nested": {
      "version": "6.2.0",
      "resolved": "https://registry.npmjs.org/postcss-nested/-/postcss-nested-6.2.0.tgz",
      "integrity": "sha512-HQbt28KulC5AJzG+cZtj9kvKB93CFCdLvog1WFLf1D+xmMvPGlBstkpTEZfK5+AN9hfJocyBFCNiqyS48bpgzQ==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/postcss/"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "postcss-selector-parser": "^6.1.1"
      },
      "engines": {
        "node": ">=12.0"
      },
      "peerDependencies": {
        "postcss": "^8.2.14"
      }
    },
    "node_modules/postcss-selector-parser": {
      "version": "6.1.2",
      "resolved": "https://registry.npmjs.org/postcss-selector-parser/-/postcss-selector-parser-6.1.2.tgz",
      "integrity": "sha512-Q8qQfPiZ+THO/3ZrOrO0cJJKfpYCagtMUkXbnEfmgUjwXg6z/WBeOyS9APBBPCTSiDV+s4SwQGu8yFsiMRIudg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "cssesc": "^3.0.0",
        "util-deprecate": "^1.0.2"
      },
      "engines": {
        "node": ">=4"
      }
    },
    "node_modules/postcss-value-parser": {
      "version": "4.2.0",
      "resolved": "https://registry.npmjs.org/postcss-value-parser/-/postcss-value-parser-4.2.0.tgz",
      "integrity": "sha512-1NNCs6uurfkVbeXG4S8JFT9t19m45ICnif8zWLd5oPSZ50QnwMfK+H3jv408d4jw/7Bttv5axS5IiHoLaVNHeQ==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/queue-microtask": {
      "version": "1.2.3",
      "resolved": "https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz",
      "integrity": "sha512-NuaNSa6flKT5JaSYQzJok04JzTL1CA6aGhv5rfLW3PgqA+M2ChpZQnAC8h8i4ZFkBS8X5RqkDBHA7r4hej3K9A==",
      "dev": true,
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/feross"
        },
        {
          "type": "patreon",
          "url": "https://www.patreon.com/feross"
        },
        {
          "type": "consulting",
          "url": "https://feross.org/support"
        }
      ],
      "license": "MIT"
    },
    "node_modules/react": {
      "version": "18.3.1",
      "resolved": "https://registry.npmjs.org/react/-/react-18.3.1.tgz",
      "integrity": "sha512-wS+hAgJShR0KhEvPJArfuPVN1+Hz1t0Y6n5jLrGQbkb4urgPE/0Rve+1kMB1v/oWgHgm4WIcV+i7F2pTVj+2iQ==",
      "license": "MIT",
      "dependencies": {
        "loose-envify": "^1.1.0"
      },
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/react-dom": {
      "version": "18.3.1",
      "resolved": "https://registry.npmjs.org/react-dom/-/react-dom-18.3.1.tgz",
      "integrity": "sha512-5m4nQKp+rZRb09LNH59GM4BxTh9251/ylbKIbpe7TpGxfJ+9kv6BLkLBXIjjspbgbnIBNqlI23tRnTWT0snUIw==",
      "license": "MIT",
      "dependencies": {
        "loose-envify": "^1.1.0",
        "scheduler": "^0.23.2"
      },
      "peerDependencies": {
        "react": "^18.3.1"
      }
    },
    "node_modules/react-refresh": {
      "version": "0.17.0",
      "resolved": "https://registry.npmjs.org/react-refresh/-/react-refresh-0.17.0.tgz",
      "integrity": "sha512-z6F7K9bV85EfseRCp2bzrpyQ0Gkw1uLoCel9XBVWPg/TjRj94SkJzUTGfOa4bs7iJvBWtQG0Wq7wnI0syw3EBQ==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/react-router": {
      "version": "7.14.2",
      "resolved": "https://registry.npmjs.org/react-router/-/react-router-7.14.2.tgz",
      "integrity": "sha512-yCqNne6I8IB6rVCH7XUvlBK7/QKyqypBFGv+8dj4QBFJiiRX+FG7/nkdAvGElyvVZ/HQP5N19wzteuTARXi5Gw==",
      "license": "MIT",
      "dependencies": {
        "cookie": "^1.0.1",
        "set-cookie-parser": "^2.6.0"
      },
      "engines": {
        "node": ">=20.0.0"
      },
      "peerDependencies": {
        "react": ">=18",
        "react-dom": ">=18"
      },
      "peerDependenciesMeta": {
        "react-dom": {
          "optional": true
        }
      }
    },
    "node_modules/react-router-dom": {
      "version": "7.14.2",
      "resolved": "https://registry.npmjs.org/react-router-dom/-/react-router-dom-7.14.2.tgz",
      "integrity": "sha512-YZcM5ES8jJSM+KrJ9BdvHHqlnGTg5tH3sC5ChFRj4inosKctdyzBDhOyyHdGk597q2OT6NTrCA1OvB/YDwfekQ==",
      "license": "MIT",
      "dependencies": {
        "react-router": "7.14.2"
      },
      "engines": {
        "node": ">=20.0.0"
      },
      "peerDependencies": {
        "react": ">=18",
        "react-dom": ">=18"
      }
    },
    "node_modules/read-cache": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/read-cache/-/read-cache-1.0.0.tgz",
      "integrity": "sha512-Owdv/Ft7IjOgm/i0xvNDZ1LrRANRfew4b2prF3OWMQLxLfu3bS8FVhCsrSCMK4lR56Y9ya+AThoTpDCTxCmpRA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "pify": "^2.3.0"
      }
    },
    "node_modules/readdirp": {
      "version": "3.6.0",
      "resolved": "https://registry.npmjs.org/readdirp/-/readdirp-3.6.0.tgz",
      "integrity": "sha512-hOS089on8RduqdbhvQ5Z37A0ESjsqz6qnRcffsMU3495FuTdqSm+7bhJ29JvIOsBDEEnan5DPu9t3To9VRlMzA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "picomatch": "^2.2.1"
      },
      "engines": {
        "node": ">=8.10.0"
      }
    },
    "node_modules/resolve": {
      "version": "1.22.12",
      "resolved": "https://registry.npmjs.org/resolve/-/resolve-1.22.12.tgz",
      "integrity": "sha512-TyeJ1zif53BPfHootBGwPRYT1RUt6oGWsaQr8UyZW/eAm9bKoijtvruSDEmZHm92CwS9nj7/fWttqPCgzep8CA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "es-errors": "^1.3.0",
        "is-core-module": "^2.16.1",
        "path-parse": "^1.0.7",
        "supports-preserve-symlinks-flag": "^1.0.0"
      },
      "bin": {
        "resolve": "bin/resolve"
      },
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/reusify": {
      "version": "1.1.0",
      "resolved": "https://registry.npmjs.org/reusify/-/reusify-1.1.0.tgz",
      "integrity": "sha512-g6QUff04oZpHs0eG5p83rFLhHeV00ug/Yf9nZM6fLeUrPguBTkTQOdpAWWspMh55TZfVQDPaN3NQJfbVRAxdIw==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "iojs": ">=1.0.0",
        "node": ">=0.10.0"
      }
    },
    "node_modules/rollup": {
      "version": "3.30.0",
      "resolved": "https://registry.npmjs.org/rollup/-/rollup-3.30.0.tgz",
      "integrity": "sha512-kQvGasUgN+AlWGliFn2POSajRQEsULVYFGTvOZmK06d7vCD+YhZztt70kGk3qaeAXeWYL5eO7zx+rAubBc55eA==",
      "dev": true,
      "license": "MIT",
      "bin": {
        "rollup": "dist/bin/rollup"
      },
      "engines": {
        "node": ">=14.18.0",
        "npm": ">=8.0.0"
      },
      "optionalDependencies": {
        "fsevents": "~2.3.2"
      }
    },
    "node_modules/run-parallel": {
      "version": "1.2.0",
      "resolved": "https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz",
      "integrity": "sha512-5l4VyZR86LZ/lDxZTR6jqL8AFE2S0IFLMP26AbjsLVADxHdhB/c0GUsH+y39UfCi3dzz8OlQuPmnaJOMoDHQBA==",
      "dev": true,
      "funding": [
        {
          "type": "github",
          "url": "https://github.com/sponsors/feross"
        },
        {
          "type": "patreon",
          "url": "https://www.patreon.com/feross"
        },
        {
          "type": "consulting",
          "url": "https://feross.org/support"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "queue-microtask": "^1.2.2"
      }
    },
    "node_modules/scheduler": {
      "version": "0.23.2",
      "resolved": "https://registry.npmjs.org/scheduler/-/scheduler-0.23.2.tgz",
      "integrity": "sha512-UOShsPwz7NrMUqhR6t0hWjFduvOzbtv7toDH1/hIrfRNIDBnnBWd0CwJTGvTpngVlmwGCdP9/Zl/tVrDqcuYzQ==",
      "license": "MIT",
      "dependencies": {
        "loose-envify": "^1.1.0"
      }
    },
    "node_modules/semver": {
      "version": "6.3.1",
      "resolved": "https://registry.npmjs.org/semver/-/semver-6.3.1.tgz",
      "integrity": "sha512-BR7VvDCVHO+q2xBEWskxS6DJE1qRnb7DxzUrogb71CWoSficBxYsiAGd+Kl0mmq/MprG9yArRkyrQxTO6XjMzA==",
      "dev": true,
      "license": "ISC",
      "bin": {
        "semver": "bin/semver.js"
      }
    },
    "node_modules/set-cookie-parser": {
      "version": "2.7.2",
      "resolved": "https://registry.npmjs.org/set-cookie-parser/-/set-cookie-parser-2.7.2.tgz",
      "integrity": "sha512-oeM1lpU/UvhTxw+g3cIfxXHyJRc/uidd3yK1P242gzHds0udQBYzs3y8j4gCCW+ZJ7ad0yctld8RYO+bdurlvw==",
      "license": "MIT"
    },
    "node_modules/source-map-js": {
      "version": "1.2.1",
      "resolved": "https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz",
      "integrity": "sha512-UXWMKhLOwVKb728IUtQPXxfYU+usdybtUrK/8uGE8CQMvrhOpwvzDBwj0QhSL7MQc7vIsISBG8VQ8+IDQxpfQA==",
      "dev": true,
      "license": "BSD-3-Clause",
      "engines": {
        "node": ">=0.10.0"
      }
    },
    "node_modules/sucrase": {
      "version": "3.35.1",
      "resolved": "https://registry.npmjs.org/sucrase/-/sucrase-3.35.1.tgz",
      "integrity": "sha512-DhuTmvZWux4H1UOnWMB3sk0sbaCVOoQZjv8u1rDoTV0HTdGem9hkAZtl4JZy8P2z4Bg0nT+YMeOFyVr4zcG5Tw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@jridgewell/gen-mapping": "^0.3.2",
        "commander": "^4.0.0",
        "lines-and-columns": "^1.1.6",
        "mz": "^2.7.0",
        "pirates": "^4.0.1",
        "tinyglobby": "^0.2.11",
        "ts-interface-checker": "^0.1.9"
      },
      "bin": {
        "sucrase": "bin/sucrase",
        "sucrase-node": "bin/sucrase-node"
      },
      "engines": {
        "node": ">=16 || 14 >=14.17"
      }
    },
    "node_modules/supports-preserve-symlinks-flag": {
      "version": "1.0.0",
      "resolved": "https://registry.npmjs.org/supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz",
      "integrity": "sha512-ot0WnXS9fgdkgIcePe6RHNk1WA8+muPa6cSjeR3V8K27q9BB1rTE3R1p7Hv0z1ZyAc8s6Vvv8DIyWf681MAt0w==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">= 0.4"
      },
      "funding": {
        "url": "https://github.com/sponsors/ljharb"
      }
    },
    "node_modules/tailwindcss": {
      "version": "3.4.19",
      "resolved": "https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.4.19.tgz",
      "integrity": "sha512-3ofp+LL8E+pK/JuPLPggVAIaEuhvIz4qNcf3nA1Xn2o/7fb7s/TYpHhwGDv1ZU3PkBluUVaF8PyCHcm48cKLWQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "@alloc/quick-lru": "^5.2.0",
        "arg": "^5.0.2",
        "chokidar": "^3.6.0",
        "didyoumean": "^1.2.2",
        "dlv": "^1.1.3",
        "fast-glob": "^3.3.2",
        "glob-parent": "^6.0.2",
        "is-glob": "^4.0.3",
        "jiti": "^1.21.7",
        "lilconfig": "^3.1.3",
        "micromatch": "^4.0.8",
        "normalize-path": "^3.0.0",
        "object-hash": "^3.0.0",
        "picocolors": "^1.1.1",
        "postcss": "^8.4.47",
        "postcss-import": "^15.1.0",
        "postcss-js": "^4.0.1",
        "postcss-load-config": "^4.0.2 || ^5.0 || ^6.0",
        "postcss-nested": "^6.2.0",
        "postcss-selector-parser": "^6.1.2",
        "resolve": "^1.22.8",
        "sucrase": "^3.35.0"
      },
      "bin": {
        "tailwind": "lib/cli.js",
        "tailwindcss": "lib/cli.js"
      },
      "engines": {
        "node": ">=14.0.0"
      }
    },
    "node_modules/thenify": {
      "version": "3.3.1",
      "resolved": "https://registry.npmjs.org/thenify/-/thenify-3.3.1.tgz",
      "integrity": "sha512-RVZSIV5IG10Hk3enotrhvz0T9em6cyHBLkH/YAZuKqd8hRkKhSfCGIcP2KUY0EPxndzANBmNllzWPwak+bheSw==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "any-promise": "^1.0.0"
      }
    },
    "node_modules/thenify-all": {
      "version": "1.6.0",
      "resolved": "https://registry.npmjs.org/thenify-all/-/thenify-all-1.6.0.tgz",
      "integrity": "sha512-RNxQH/qI8/t3thXJDwcstUO4zeqo64+Uy/+sNVRBx4Xn2OX+OZ9oP+iJnNFqplFra2ZUVeKCSa2oVWi3T4uVmA==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "thenify": ">= 3.1.0 < 4"
      },
      "engines": {
        "node": ">=0.8"
      }
    },
    "node_modules/tinyglobby": {
      "version": "0.2.16",
      "resolved": "https://registry.npmjs.org/tinyglobby/-/tinyglobby-0.2.16.tgz",
      "integrity": "sha512-pn99VhoACYR8nFHhxqix+uvsbXineAasWm5ojXoN8xEwK5Kd3/TrhNn1wByuD52UxWRLy8pu+kRMniEi6Eq9Zg==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "fdir": "^6.5.0",
        "picomatch": "^4.0.4"
      },
      "engines": {
        "node": ">=12.0.0"
      },
      "funding": {
        "url": "https://github.com/sponsors/SuperchupuDev"
      }
    },
    "node_modules/tinyglobby/node_modules/fdir": {
      "version": "6.5.0",
      "resolved": "https://registry.npmjs.org/fdir/-/fdir-6.5.0.tgz",
      "integrity": "sha512-tIbYtZbucOs0BRGqPJkshJUYdL+SDH7dVM8gjy+ERp3WAUjLEFJE+02kanyHtwjWOnwrKYBiwAmM0p4kLJAnXg==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=12.0.0"
      },
      "peerDependencies": {
        "picomatch": "^3 || ^4"
      },
      "peerDependenciesMeta": {
        "picomatch": {
          "optional": true
        }
      }
    },
    "node_modules/tinyglobby/node_modules/picomatch": {
      "version": "4.0.4",
      "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-4.0.4.tgz",
      "integrity": "sha512-QP88BAKvMam/3NxH6vj2o21R6MjxZUAd6nlwAS/pnGvN9IVLocLHxGYIzFhg6fUQ+5th6P4dv4eW9jX3DSIj7A==",
      "dev": true,
      "license": "MIT",
      "engines": {
        "node": ">=12"
      },
      "funding": {
        "url": "https://github.com/sponsors/jonschlinkert"
      }
    },
    "node_modules/to-regex-range": {
      "version": "5.0.1",
      "resolved": "https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz",
      "integrity": "sha512-65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "is-number": "^7.0.0"
      },
      "engines": {
        "node": ">=8.0"
      }
    },
    "node_modules/ts-interface-checker": {
      "version": "0.1.13",
      "resolved": "https://registry.npmjs.org/ts-interface-checker/-/ts-interface-checker-0.1.13.tgz",
      "integrity": "sha512-Y/arvbn+rrz3JCKl9C4kVNfTfSm2/mEp5FSz5EsZSANGPSlQrpRI5M4PKF+mJnE52jOO90PnPSc3Ur3bTQw0gA==",
      "dev": true,
      "license": "Apache-2.0"
    },
    "node_modules/tslib": {
      "version": "2.8.1",
      "resolved": "https://registry.npmjs.org/tslib/-/tslib-2.8.1.tgz",
      "integrity": "sha512-oJFu94HQb+KVduSUQL7wnpmqnfmLsOA/nAh6b6EH0wCEoK0/mPeXU6c3wKDV83MkOuHPRHtSXKKU99IBazS/2w==",
      "license": "0BSD"
    },
    "node_modules/typescript": {
      "version": "5.9.3",
      "resolved": "https://registry.npmjs.org/typescript/-/typescript-5.9.3.tgz",
      "integrity": "sha512-jl1vZzPDinLr9eUt3J/t7V6FgNEw9QjvBPdysz9KfQDD41fQrC2Y4vKQdiaUpFT4bXlb1RHhLpp8wtm6M5TgSw==",
      "dev": true,
      "license": "Apache-2.0",
      "bin": {
        "tsc": "bin/tsc",
        "tsserver": "bin/tsserver"
      },
      "engines": {
        "node": ">=14.17"
      }
    },
    "node_modules/undici-types": {
      "version": "7.19.2",
      "resolved": "https://registry.npmjs.org/undici-types/-/undici-types-7.19.2.tgz",
      "integrity": "sha512-qYVnV5OEm2AW8cJMCpdV20CDyaN3g0AjDlOGf1OW4iaDEx8MwdtChUp4zu4H0VP3nDRF/8RKWH+IPp9uW0YGZg==",
      "license": "MIT"
    },
    "node_modules/update-browserslist-db": {
      "version": "1.2.3",
      "resolved": "https://registry.npmjs.org/update-browserslist-db/-/update-browserslist-db-1.2.3.tgz",
      "integrity": "sha512-Js0m9cx+qOgDxo0eMiFGEueWztz+d4+M3rGlmKPT+T4IS/jP4ylw3Nwpu6cpTTP8R1MAC1kF4VbdLt3ARf209w==",
      "dev": true,
      "funding": [
        {
          "type": "opencollective",
          "url": "https://opencollective.com/browserslist"
        },
        {
          "type": "tidelift",
          "url": "https://tidelift.com/funding/github/npm/browserslist"
        },
        {
          "type": "github",
          "url": "https://github.com/sponsors/ai"
        }
      ],
      "license": "MIT",
      "dependencies": {
        "escalade": "^3.2.0",
        "picocolors": "^1.1.1"
      },
      "bin": {
        "update-browserslist-db": "cli.js"
      },
      "peerDependencies": {
        "browserslist": ">= 4.21.0"
      }
    },
    "node_modules/util-deprecate": {
      "version": "1.0.2",
      "resolved": "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz",
      "integrity": "sha512-EPD5q1uXyFxJpCrLnCc1nHnq3gOa6DZBocAIiI2TaSCA7VCJ1UJDMagCzIkXNsUYfD1daK//LTEQ8xiIbrHtcw==",
      "dev": true,
      "license": "MIT"
    },
    "node_modules/vite": {
      "version": "4.5.14",
      "resolved": "https://registry.npmjs.org/vite/-/vite-4.5.14.tgz",
      "integrity": "sha512-+v57oAaoYNnO3hIu5Z/tJRZjq5aHM2zDve9YZ8HngVHbhk66RStobhb1sqPMIPEleV6cNKYK4eGrAbE9Ulbl2g==",
      "dev": true,
      "license": "MIT",
      "dependencies": {
        "esbuild": "^0.18.10",
        "postcss": "^8.4.27",
        "rollup": "^3.27.1"
      },
      "bin": {
        "vite": "bin/vite.js"
      },
      "engines": {
        "node": "^14.18.0 || >=16.0.0"
      },
      "funding": {
        "url": "https://github.com/vitejs/vite?sponsor=1"
      },
      "optionalDependencies": {
        "fsevents": "~2.3.2"
      },
      "peerDependencies": {
        "@types/node": ">= 14",
        "less": "*",
        "lightningcss": "^1.21.0",
        "sass": "*",
        "stylus": "*",
        "sugarss": "*",
        "terser": "^5.4.0"
      },
      "peerDependenciesMeta": {
        "@types/node": {
          "optional": true
        },
        "less": {
          "optional": true
        },
        "lightningcss": {
          "optional": true
        },
        "sass": {
          "optional": true
        },
        "stylus": {
          "optional": true
        },
        "sugarss": {
          "optional": true
        },
        "terser": {
          "optional": true
        }
      }
    },
    "node_modules/ws": {
      "version": "8.20.0",
      "resolved": "https://registry.npmjs.org/ws/-/ws-8.20.0.tgz",
      "integrity": "sha512-sAt8BhgNbzCtgGbt2OxmpuryO63ZoDk/sqaB/znQm94T4fCEsy/yV+7CdC1kJhOU9lboAEU7R3kquuycDoibVA==",
      "license": "MIT",
      "engines": {
        "node": ">=10.0.0"
      },
      "peerDependencies": {
        "bufferutil": "^4.0.1",
        "utf-8-validate": ">=5.0.2"
      },
      "peerDependenciesMeta": {
        "bufferutil": {
          "optional": true
        },
        "utf-8-validate": {
          "optional": true
        }
      }
    },
    "node_modules/yallist": {
      "version": "3.1.1",
      "resolved": "https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz",
      "integrity": "sha512-a4UGQaWPH59mOXUYnAG2ewncQS4i4F43Tv3JoAM+s2VDAmS9NsK8GpDMLrCHPksFT7h3K6TOoUNn2pb7RoXx4g==",
      "dev": true,
      "license": "ISC"
    },
    "node_modules/zod": {
      "version": "4.4.2",
      "resolved": "https://registry.npmjs.org/zod/-/zod-4.4.2.tgz",
      "integrity": "sha512-IynmDyxsEsb9RKzO3J9+4SxXnl2FTFSzNBaKKaMV6tsSk0rw9gYw9gs+JFCq/qk2LCZ78KDwyj+Z289TijSkUw==",
      "license": "MIT",
      "funding": {
        "url": "https://github.com/sponsors/colinhacks"
      }
    }
  }
}
// FILE: package.json
{
    "name":  "via51-holding",
    "private":  true,
    "version":  "1.0.0",
    "type":  "module",
    "dependencies":  {
                         "@supabase/supabase-js":  "^2.105.1",
                         "framer-motion":  "^10.16.4",
                         "lucide-react":  "^0.284.0",
                         "react":  "^18.3.1",
                         "react-dom":  "^18.3.1",
                         "react-router-dom":  "^7.14.2",
                         "zod":  "^4.4.2"
                     },
    "devDependencies":  {
                            "@types/react":  "^18.3.28",
                            "@types/react-dom":  "^18.3.7",
                            "@vitejs/plugin-react":  "^4.7.0",
                            "autoprefixer":  "^10.4.16",
                            "postcss":  "^8.4.31",
                            "tailwindcss":  "^3.3.3",
                            "typescript":  "^5.9.3",
                            "vite":  "^4.5.14"
                        },
    "description":  "",
    "main":  "tailwind.config.js",
    "keywords":  [

                 ],
    "author":  "",
    "license":  "ISC",
    "scripts":  {
                    "preview":  "vite preview",
                    "build":  "tsc && vite build",
                    "dev":  "vite"
                }
}
// FILE: tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "ignoreDeprecations": "5.0"
  },
  "include": ["src", "core", "hangar"]
}
',
    '{"type": "CORE", "size": "1.6MB", "origin": "gamma-auditoria"}'
) ON CONFLICT (code_name) DO UPDATE SET 
    blueprint_content = EXCLUDED.blueprint_content,
    updated_at = NOW();
