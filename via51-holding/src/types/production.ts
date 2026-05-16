export interface ArticleNode {
  title: string;
  body: string;
}

export interface SovereignContent {
  title: string;
  subtitle: string;
  s1: string; c1: string;
  s2: string; c2: string;
  s3: string; c3: string;
  mantra: string;
}

export interface ProductionData {
  es: SovereignContent;
  qu: SovereignContent;
  en: SovereignContent;
}