import { z } from "zod";

export const SectionSchema = z.object({
  heading: z.string(),
  body: z.string()
});

export const ThoughtSchema = z.object({
  issue_code: z.string(),
  publish_date: z.string(),
  title: z.string().min(1),
  subtitle: z.string().optional(),
  layout_id: z.string().default("SOBERANA_V4"), // El nuevo ancla de forma
  sections: z.array(SectionSchema),
  mantra: z.string().optional(),
  image_url: z.string().optional(),
  status: z.enum(["DRAFT", "PUBLISHED"]).default("DRAFT"),
  created_by: z.string(),
  metadata: z.record(z.any()).default({}),
  translations: z.record(z.any()).default({})
});

export type Thought = z.infer<typeof ThoughtSchema>;