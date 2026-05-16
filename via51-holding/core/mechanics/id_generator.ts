export const generateIssueCode = (prefix: string = "PENS"): string => {
  const date = new Date().toISOString().slice(0, 10).replace(/-/g, "");
  const randomHex = Math.random().toString(16).toUpperCase().substring(2, 6);
  return `V51-${prefix}-${date}-${randomHex}`;
};