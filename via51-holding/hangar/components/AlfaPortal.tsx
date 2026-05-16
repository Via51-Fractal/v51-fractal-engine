import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { getLatestSovereignEmission } from "../../core/mechanics/thought.driver";

export const AlfaPortal = () => {
  const navigate = useNavigate();
  const [latestArticle, setLatestArticle] = useState(null);
  const now = new Date();
  const todayISO = now.toISOString().split("T")[0];
  const todayDisplay = now.toLocaleDateString("es-PE", { year: "numeric", month: "2-digit", day: "2-digit" }).replace(/\//g, ".");

  useEffect(() => {
    getLatestSovereignEmission().then(setLatestArticle);
  }, []);

  const hasTodayImage = latestArticle?.publish_date === todayISO && latestArticle?.image_url;
  const backgroundStyle = hasTodayImage 
    ? `linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.8)), url(${latestArticle.image_url})`
    : "none";

  return (
    <div style={{ 
      backgroundColor: "#000", backgroundImage: backgroundStyle, backgroundSize: "cover", backgroundPosition: "center",
      height: "100vh", width: "100vw", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", textAlign: "center", color: "#fff", fontFamily: "sans-serif" 
    }}>
      <p style={{ color: "#E5B451", fontSize: "10px", letterSpacing: "6px", fontWeight: "bold", marginBottom: "1.5rem", textTransform: "uppercase" }}>
        VIA51 - HOLDING DIGITAL
      </p>
      <h1 style={{ fontSize: "clamp(2rem, 8vw, 3.5rem)", fontWeight: 900, letterSpacing: "0.25em", margin: "0 0 3.5rem 0", textTransform: "uppercase" }}>
        SISTEMA ANTIGRAVITY
      </h1>
      <button onClick={() => latestArticle && navigate(`/${latestArticle.issue_code}`)}
        style={{ background: "transparent", border: "1.5px solid #E5B451", padding: "1.2rem 3rem", cursor: "pointer", color: "#fff" }}>
        <p style={{ fontSize: "0.75rem", letterSpacing: "0.35em", margin: 0, fontWeight: "bold", textTransform: "uppercase" }}>
          PRODUCCIÓN SOBERANA ({todayDisplay})
        </p>
      </button>
      <footer style={{ position: "absolute", bottom: "3rem", width: "100%", textAlign: "center" }}>
        <div style={{ width: "40px", height: "1px", background: "#E5B451", margin: "0 auto 15px", opacity: 0.5 }}></div>
        <p style={{ fontSize: "9px", color: "#888", letterSpacing: "4px", textTransform: "uppercase", fontWeight: "bold" }}>
          SOBERANÍA DIGITAL E INTELIGENCIA ESTRATÉGICA
        </p>
      </footer>
    </div>
  );
};