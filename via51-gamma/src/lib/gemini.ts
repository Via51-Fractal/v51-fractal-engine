import OpenAI from 'openai';

const apiKey = process.env.NEXT_PUBLIC_GROQ_API_KEY || 'BUILD_TIME_PLACEHOLDER';

export const gammaModel = new OpenAI({
  apiKey: apiKey,
  baseURL: "https://api.groq.com/openai/v1",
  dangerouslyAllowBrowser: true
});