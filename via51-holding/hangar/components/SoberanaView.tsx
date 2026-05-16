import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { getEmissionByCode, getPublicEmissions } from "../../core/mechanics/thought.driver";

export const SoberanaView = () => {
  const { issueCode } = useParams();
  const navigate = useNavigate();
  const [article, setArticle] = useState(null);
  const [timeline, setTimeline] = useState([]);
  const [lang, setLang] = useState("es");

  const GOLD = "#E5B451";
  

  const labels = {
    es: { page: "PÁGINA", loading: "CONECTANDO AL BÚNKER...", mantra: "MANTRA", header: "PRODUCCIÓN SOBERANA" },
    qu: { page: "P\u0027ANQA", loading: "BÚNKERWAN TINKUCHKANI...", mantra: "HAMUT\u0027AY", header: "LLAMKAY QASIKAY" },
    en: { page: "PAGE", loading: "CONNECTING TO BUNKER...", mantra: "MANTRA", header: "SOVEREIGN PRODUCTION" }
  };

  useEffect(() => {
    const load = async () => {
      const art = await getEmissionByCode(issueCode || "");
      const time = await getPublicEmissions();
      setArticle(art);
      setTimeline(time);
    };
    load();
  }, [issueCode]);

  if (!article) return <div style={{ background: "#000", height: "100vh", display: "flex", alignItems: "center", justifyContent: "center", color: GOLD }}>{labels[lang].loading}</div>;

  const currentIndex = timeline.findIndex(t => t.issue_code === issueCode);
  const data = lang === "es" ? {
    title: article.title, subtitle: article.subtitle, theme_title: article.metadata?.theme_title,
    sections: article.sections || [], mantra: article.mantra
  } : article.translations?.[lang] || {};

  const navigateTo = (index) => {
    if (index >= 0 && index < timeline.length) navigate(`/${timeline[index].issue_code}`);
  };

  return (
    <div style={{ 
      backgroundColor: "#000",
      backgroundImage: article.image_url ? `linear-gradient(rgba(0,0,0,0.85), rgba(0,0,0,0.85)), url(${article.image_url})` : "none",
      backgroundSize: "cover",
      backgroundPosition: "center",
      backgroundAttachment: "fixed",
      color: "#fff", height: "100vh", width: "100vw", display: "flex", justifyContent: "center", overflow: "hidden", fontFamily: "sans-serif" 
    }}>
      
      <motion.main style={{ width: "100%", maxWidth: "600px", height: "100%", display: "flex", flexDirection: "column", padding: "6vh 20px 20px 20px", boxSizing: "border-box" }}>
        
        <header style={{ textAlign: "center", marginBottom: "15px" }}>
          <p style={{ color: GOLD, fontSize: "10px", letterSpacing: "6px", fontWeight: "bold", textTransform: "uppercase", margin: "0 0 10px 0" }}>{labels[lang].header}</p>
          <div style={{ display: "flex", gap: "20px", justifyContent: "center", fontSize: "10px", color: GOLD, fontWeight: "bold" }}>
            {["es", "qu", "en"].map(l => (
              <span key={l} onClick={() => setLang(l)} style={{ cursor: "pointer", opacity: lang === l ? 1 : 0.65, borderBottom: lang === l ? `1px solid ${GOLD}` : "none", textTransform: "uppercase" }}>
                {l === "es" ? "ESPAÑOL" : l === "qu" ? "RUNASIMI" : "ENGLISH"}
              </span>
            ))}
          </div>
        </header>

        <section style={{ textAlign: "center", marginBottom: "15px" }}>
          <h1 style={{ fontSize: "20px", fontWeight: "900", margin: "0 0 5px 0", lineHeight: "1.1", textTransform: "uppercase" }}>{data.title}</h1>
          <h2 style={{ fontSize: "11px", color: GOLD, margin: "0 0 12px 0", letterSpacing: "1px", textTransform: "uppercase" }}>{data.subtitle}</h2>
          <div style={{ width: "100%", height: "1px", background: GOLD, opacity: 0.3 }}></div>
        </section>

        <div style={{ flex: 1, overflowY: "auto", paddingRight: "15px", textAlign: "left", marginBottom: "15px" }}>
          {data.sections?.map((s, i) => (
            <div key={i} style={{ marginBottom: "20px" }}>
              <h4 style={{ fontSize: "13px", marginBottom: "8px", fontWeight: "800", color: "#fff", textTransform: "uppercase" }}>{s.heading}</h4>
              <div style={{ borderLeft: `3px solid ${GOLD}`, paddingLeft: "15px", color: "#ccc", fontSize: "12px", lineHeight: "1.6", textAlign: "justify" }}>{s.body}</div>
            </div>
          ))}
        </div>

        <footer style={{ width: "100%", marginTop: "auto" }}>
          {data.mantra && (
            <div style={{ marginBottom: "10px" }}>
              <div style={{ display: "flex", alignItems: "center", gap: "15px", marginBottom: "10px" }}>
                <div style={{ flex: 1, height: "1px", background: GOLD, opacity: 0.4 }}></div>
                <span style={{ color: GOLD, fontSize: "9px", fontWeight: "bold", letterSpacing: "4px" }}>{labels[lang].mantra}</span>
                <div style={{ flex: 1, height: "1px", background: GOLD, opacity: 0.4 }}></div>
              </div>
              <p style={{ color: GOLD, fontSize: "14px", fontWeight: "bold", textAlign: "center", margin: "0 auto 10px", maxWidth: "550px", lineHeight: "1.3", textTransform: "uppercase" }}>{data.mantra}</p>
              <div style={{ width: "100%", height: "1px", background: GOLD, opacity: 0.3 }}></div>
            </div>
          )}
          
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between" }}>
            <button onClick={() => navigateTo(currentIndex - 1)} style={{ background: "transparent", border: "none", color: GOLD, fontSize: "30px", cursor: "pointer", visibility: currentIndex > 0 ? "visible" : "hidden" }}></button>
            <p style={{ fontSize: "9px", color: "#666", margin: 0, letterSpacing: "4px", fontWeight: "bold", textTransform: "uppercase" }}>
              {labels[lang].page} {currentIndex + 1} / {timeline.length}
            </p>
            <button onClick={() => navigateTo(currentIndex + 1)} style={{ background: "transparent", border: "none", color: GOLD, fontSize: "35px", cursor: "pointer", visibility: currentIndex < timeline.length - 1 ? "visible" : "hidden" }}></button>
          </div>
        </footer>
      </motion.main>
    </div>
  );
};