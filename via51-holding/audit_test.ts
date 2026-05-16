
import { getPublicEmissions, getLatestSovereignEmission } from "./core/mechanics/thought.driver";

async function runAudit() {
  console.log("--- INICIANDO AUDITORÍA DE INMUNIDAD V51 ---");
  
  const latest = await getLatestSovereignEmission();
  if (!latest) throw new Error("FALLO CRÍTICO: El Driver no recupera el último artículo.");
  console.log("CHECK 1: Conexión al Bunker OK.");

  const timeline = await getPublicEmissions();
  if (!timeline || timeline.length === 0) throw new Error("FALLO CRÍTICO: El Timeline está vacío.");
  console.log(`CHECK 2: Timeline recuperado (${timeline.length} artículos).`);

  console.log("--- AUDITORÍA EXITOSA: EL SISTEMA ES ESTABLE ---");
}

runAudit().catch(err => {
  console.error(err.message);
  process.exit(1);
});