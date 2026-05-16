import React, { useState } from "react";

export const ThoughtIngestor = ({ onSave }) => {
  const [form, setForm] = useState({
    title: "", subtitle: "", mantra: "", image_url: "",
    sections: [{ heading: "", body: "" }]
  });

  const addSection = () => setForm({...form, sections: [...form.sections, { heading: "", body: "" }]});
  
  const updateSection = (i, field, val) => {
    const newSections = [...form.sections];
    newSections[i][field] = val;
    setForm({...form, sections: newSections});
  };

  return (
    <div style={{ background: "#000", color: "#0f0", padding: "3rem", fontFamily: "monospace" }}>
      <h2 style={{ color: "#C5A059" }}>V51 // INGESTOR DE ACTIVOS INTELECTUALES</h2>
      <div style={{ display: "grid", gap: "1rem", maxWidth: "800px", marginTop: "2rem" }}>
        <input placeholder="T\u00CDTULO DEL TEMA" onChange={e => setForm({...form, title: e.target.value})} style={{ background: "#111", color: "#fff", padding: "1rem", border: "1px solid #333" }} />
        <input placeholder="SUBT\u00CDTULO DEL D\u00CDA" onChange={e => setForm({...form, subtitle: e.target.value})} style={{ background: "#111", color: "#fff", padding: "1rem", border: "1px solid #333" }} />
        <input placeholder="URL DE IMAGEN" onChange={e => setForm({...form, image_url: e.target.value})} style={{ background: "#111", color: "#fff", padding: "1rem", border: "1px solid #333" }} />
        
        {form.sections.map((s, i) => (
          <div key={i} style={{ border: "1px solid #222", padding: "1rem" }}>
            <input placeholder="Encabezado de Secci\u00F3n" onChange={e => updateSection(i, "heading", e.target.value)} style={{ width: "100%", background: "transparent", color: "#C5A059", border: "none", borderBottom: "1px solid #333", marginBottom: "0.5rem" }} />
            <textarea placeholder="Cuerpo de Secci\u00F3n" onChange={e => updateSection(i, "body", e.target.value)} style={{ width: "100%", height: "80px", background: "transparent", color: "#ccc", border: "none" }} />
          </div>
        ))}
        <button onClick={addSection} style={{ background: "#222", color: "#0f0", border: "1px solid #0f0", cursor: "pointer" }}>+ A\u00D1ADIR SECCI\u00D3N</button>
        <input placeholder="MANTRA DESTACADO" onChange={e => setForm({...form, mantra: e.target.value})} style={{ background: "#111", color: "#C5A059", padding: "1rem", border: "1px solid #333" }} />
        
        <button onClick={() => onSave(form)} style={{ background: "#0f0", color: "#000", padding: "1.5rem", fontWeight: "bold", cursor: "pointer", marginTop: "2rem" }}>SELLAR EN EL B\u00DANKER</button>
      </div>
    </div>
  );
};