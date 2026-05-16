import { createClient } from '@supabase/supabase-js';

// Estos valores deben ser reemplazados con los de tu proyecto en Supabase
const supabaseUrl = 'https://ibhhzgtxaqwdykedhtvk.supabase.co';
const supabaseKey = 'sb_publishable_BJ5ike7tqjI4oE_64Dw80w_wy4SkzaK';

export const supabase = createClient(supabaseUrl, supabaseKey);
