import { ThoughtSchema } from "../contracts/thought.contract";
import { generateIssueCode } from "./id_generator";
import { supabase } from "../infrastructure/supabase";

export const orchestrateMasterThought = async (formData: any) => {
  try {
    const payload = {
      ...formData,
      issue_code: generateIssueCode("PENS"),
      created_by: "DNI-SOBERANO-001", // En el futuro desde Auth
      metadata: { 
        ...formData.metadata,
        v51_dna: "ACTIVO",
        ingested_at: new Date().toISOString()
      }
    };

    const validatedData = ThoughtSchema.parse(payload);
    const { data, error } = await supabase.from("sys_production").insert([validatedData]).select();

    if (error) throw error;
    return { success: true, data };
  } catch (error: any) {
    console.error("FALLO DE INYECCIÓN:", error);
    return { success: false, error: error.message };
  }
};