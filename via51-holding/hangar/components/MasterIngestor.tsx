import React, { useEffect, useState } from "react";
import { getAllEmissions, updateEmissionStatus, saveMasterThought } from "../../core/mechanics/thought.driver";
import { generateIssueCode } from "../../core/mechanics/id_generator";

export const MasterIngestor = () => {
  const [view, setView] = useState("LIST");
  const [articles, setArticles] = useState([]);
  const [form, setForm] = useState(null);
  const GOLD = "#E5B451";

  const loadArticles = async () => {
    const data = await getAllEmissions();
    setArticles(data);
  };

  useEffect(() => { loadArticles(); }, []);

  const handleSave = async () => {
    const { error } = await saveMasterThought(form);
    if (!error) { alert("ACTIVO INTELECTUAL GUARDADO"); setView("LIST"); loadArticles(); }
  };

  if (view === "LIST") return (
    <div style={{ background: "#050505", color: "#fff", minHeight: "100vh", padding: "40px", fontFamily: "monospace" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "30px" }}>
        <h2 style={{ color: GOLD, letterSpacing: "4px" }}>V51 // CENTRO DE CONTROL</h2>
        <button onClick={() => {
          setForm({
            issue_code: generateIssueCode("PENS"), title: "", subtitle: "", mantra: "", layout_id: "SOBERANA_V4",
            publish_date: new Date().toISOString().split("T")[0], status: "DRAFT", created_by: "DNI-SOBERANO-001",
            image_url: "", sections: [{ heading: "", body: "" }]
          });
          setView("EDIT");
        }} style={{ background: GOLD, color: "#000", padding: "12px 25px", fontWeight: "900", cursor: "pointer", border: "none" }}>+ NUEVO ARTÍCULO</button>
      </div>
      <table style={{ width: "100%", borderCollapse: "collapse", fontSize: "12px" }}>
        <thead>
          <tr style={{ borderBottom: "1px solid #222", color: GOLD, textAlign: "left" }}>
            <th style={{ padding: "15px" }}>CÓDIGO</th>
            <th>TÍTULO</th>
            <th>ESTADO</th>
            <th>ACCIONES</th>
          </tr>
        </thead>
        <tbody>
          {articles.map(art => (
            <tr key={art.id} style={{ borderBottom: "1px solid #111" }}>
              <td style={{ padding: "15px", color: "#555" }}>{art.issue_code}</td>
              <td style={{ fontWeight: "bold", textTransform: "uppercase" }}>{art.title}</td>
              <td>{art.status}</td>
              <td>
                <button onClick={() => { setForm(art); setView("EDIT"); }} style={{ background: "transparent", color: GOLD, border: "1px solid #333", padding: "5px 10px", cursor: "pointer" }}>EDITAR</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );

  return (
    <div style={{ background: "#050505", color: "#fff", minHeight: "100vh", padding: "40px", fontFamily: "monospace" }}>
      <h2 style={{ color: GOLD, textTransform: "uppercase" }}>Edición Soberana</h2>
      <div style={{ display: "grid", gap: "20px", maxWidth: "700px", marginTop: "20px" }}>
        <input value={form.title} onChange={e => setForm({...form, title: e.target.value})} placeholder="TÍTULO" style={{ background: "#111", color: "#fff", padding: "15px", border: "1px solid #333", textTransform: "uppercase" }} />
        <textarea value={form.mantra} onChange={e => setForm({...form, mantra: e.target.value})} placeholder="MANTRA" style={{ background: "#111", color: GOLD, padding: "15px", border: "1px solid #333", height: "60px" }} />
        <button onClick={handleSave} style={{ background: GOLD, color: "#000", padding: "20px", fontWeight: "bold", cursor: "pointer" }}>SELLAR CAMBIOS EN EL BÚNKER</button>
      </div>
    </div>
  );
};