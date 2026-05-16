import { supabase } from '@/lib/supabase'

export const MediaProcessor = {
  async processToWebP(file: File) {
    console.log(`[PROCESSOR]: Iniciando transmutación de ${file.name} a WebP...`);
    return file; 
  },

  async syncGalleries() {
    const { data: queue } = await supabase.storage.from('via51-assets').list('queue');
    const { data: processed } = await supabase.storage.from('via51-assets').list('processed');
    return { queue, processed };
  }
}