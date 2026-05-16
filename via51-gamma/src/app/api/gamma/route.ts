import { gammaModel } from "@/lib/gemini";
import { NextResponse } from "next/server";

export const dynamic = 'force-dynamic'; // EVITA EL ERROR DE BUILD

export async function POST(req: Request) {
    try {
        const { prompt } = await req.json();
        const completion = await gammaModel.chat.completions.create({
            messages: [
                { role: "system", content: "Eres el NODO GAMMA de VIA51. Responde con rigor Nivel 9A." },
                { role: "user", content: prompt }
            ],
            model: "llama-3.3-70b-versatile",
        });
        return NextResponse.json({ output: completion.choices[0].message.content });
    } catch (error: any) {
        return NextResponse.json({ error: error.message }, { status: 500 });
    }
}