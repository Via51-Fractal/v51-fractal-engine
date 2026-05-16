import { supabase } from "../infrastructure/supabase";

// 1. PARA EL PORTAL ALFA (CARÁTULA)
export const getLatestSovereignEmission = async () => {
  const today = new Date().toISOString().split("T")[0];
  const { data } = await supabase
    .from("sys_production")
    .select("*")
    .eq("status", "PUBLISHED")
    .lte("publish_date", today)
    .order("publish_date", { ascending: false })
    .limit(1)
    .maybeSingle();
  return data;
};

// 2. PARA LA VISTA SOBERANA (ARTÍCULO ESPECÍFICO)
export const getEmissionByCode = async (code: string) => {
  const { data, error } = await supabase
    .from("sys_production")
    .select("*")
    .eq("issue_code", code)
    .maybeSingle();
  if (error) console.error("ERROR BUNKER:", error);
  return data;
};

// 3. PARA EL CURSOR TEMPORAL (TIMELINE)
export const getPublicEmissions = async () => {
  const today = new Date().toISOString().split("T")[0];
  const { data } = await supabase
    .from("sys_production")
    .select("issue_code, publish_date, title")
    .eq("status", "PUBLISHED")
    .lte("publish_date", today)
    .order("publish_date", { ascending: true });
  return data || [];
};

// 4. PARA EL CENTRO DE CONTROL (GESTIÓN TOTAL)
export const getAllEmissions = async () => {
  const { data } = await supabase
    .from("sys_production")
    .select("*")
    .order("created_at", { ascending: false });
  return data || [];
};

export const updateEmissionStatus = async (id: string, newStatus: string) => {
  return await supabase
    .from("sys_production")
    .update({ status: newStatus })
    .eq("id", id);
};

export const saveMasterThought = async (payload: any) => {
  // Eliminamos id si es nulo para que Supabase genere uno nuevo (INSERT)
  // O lo mantenemos si existe para actualizar (UPSERT)
  const { id, ...dataWithoutId } = payload;
  const finalPayload = id ? payload : dataWithoutId;

  return await supabase
    .from("sys_production")
    .upsert([finalPayload])
    .select();
};
