/** DNA: V51_GAMMA_PHASE_1 */
export const checkSovereignty = (level: string): boolean => {
    const validLevels = ['9', '8', '1A', '1B', '1C'];
    return validLevels.includes(level);
};
