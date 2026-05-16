import React, { useEffect, useState } from "react";
import { getSovereignThoughts } from "../../core/mechanics/thought.driver";

export const ThoughtMonitor: React.FC = () => {
  const [thoughts, setThoughts] = useState<any[]>([]);

  useEffect(() => {
    const fetchThoughts = async () => {
      const data = await getSovereignThoughts();
      setThoughts(data);
    };
    fetchThoughts();
  }, []);

  return (
    <div style={{ background: "#000", color: "#0f0", padding: "2rem", fontFamily: "monospace" }}>
      <h2 style={{ borderBottom: "1px solid #333", paddingBottom: "1rem" }}>
        V51 // MONITOR DE PRODUCCIÃN INTELECTUAL
      </h2>
      <div style={{ display: "grid", gap: "1.5rem", marginTop: "2rem" }}>
        {thoughts.map((t) => (
          <div key={t.id} style={{ border: "1px solid #111", padding: "1.5rem", background: "#050505" }}>
            <div style={{ display: "flex", justifyContent: "space-between", fontSize: "0.7rem", opacity: 0.5 }}>
              <span>ID: {t.issue_code}</span>
              <span>FECHA: {new Date(t.created_at).toLocaleString()}</span>
            </div>
            <h3 style={{ color: "#fff", margin: "0.5rem 0" }}>{t.title}</h3>
            <p style={{ color: "#888", fontSize: "0.9rem", lineHeight: "1.4" }}>
              {t.content?.substring(0, 200)}...
            </p>
            <div style={{ marginTop: "1rem", fontSize: "0.7rem" }}>
              <span style={{ background: "#0f0", color: "#000", padding: "2px 6px", fontWeight: "bold" }}>
                EFICIENCIA: {t.efficiency_index}
              </span>
              <span style={{ marginLeft: "1rem", color: "#555" }}>
                AUTOR: {t.created_by}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};