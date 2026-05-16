import React, { useState } from "react";

interface V51Content {
  title: string;
  subtitle: string;
  mantra: string;
  s1: string; c1: string;
  s2: string; c2: string;
  s3: string; c3: string;
}

export const V51Scenario = ({ data }: { data: any }) => {
  // [GOBERNANZA] Estado inicial en Español (Soberanía Local)
  const [lang, setLang] = useState<string>("es");
  
  const content: V51Content = data[lang] || data["es"];

  return (
    <div className="v51-container">
      {/* SELECTOR DE IDENTIDAD LINGÜÍSTICA */}
      <nav className="v51-nav-selector">
        {["es", "en", "qu"].map((l) => (
          <button 
            key={l} 
            onClick={() => setLang(l)}
            className={`v51-lang-btn ${lang === l ? "active" : ""}`}
          >
            {l.toUpperCase()}
          </button>
        ))}
      </nav>

      <header className="v51-header">
        <h1 className="v51-title">{content.title}</h1>
        <p className="v51-subtitle">{content.subtitle}</p>
      </header>

      <div className="v51-mantra-wrapper">
        <p className="v51-mantra-content">{content.mantra}</p>
      </div>

      <main className="v51-fractal-grid">
        {[1, 2, 3].map((n) => (
          <section key={n} className="v51-block">
            <h3 className="v51-block-title">{content[`s${n}` as keyof V51Content]}</h3>
            <p className="v51-block-body">{content[`c${n}` as keyof V51Content]}</p>
          </section>
        ))}
      </main>

      <style>{`
        .v51-container { max-width: 850px; margin: 0 auto; padding: 40px 20px; font-family: sans-serif; color: #e0e0e0; }
        
        /* SELECTOR SOBERANO */
        .v51-nav-selector { display: flex; justify-content: center; gap: 10px; margin-bottom: 40px; }
        .v51-lang-btn { 
          background: transparent; border: 1px solid #444; color: #888; 
          padding: 5px 15px; cursor: pointer; font-size: 0.8rem; transition: 0.3s;
          border-radius: 2px;
        }
        .v51-lang-btn:hover { border-color: #00ff00; color: #fff; }
        .v51-lang-btn.active { background: #00ff00; color: #000; border-color: #00ff00; font-weight: bold; }

        .v51-header { text-align: center; margin-bottom: 50px; }
        .v51-title { font-size: 2.2rem; line-height: 1.1; margin-bottom: 10px; color: #fff; }
        .v51-subtitle { color: #00ff00; text-transform: uppercase; letter-spacing: 2px; font-size: 0.9rem; }

        /* ACOTACIÓN DE MANTRA - ART 1 CARTA MAGNA */
        .v51-mantra-wrapper { 
          max-width: 550px; margin: 0 auto 60px; padding: 30px; 
          border-top: 1px solid #333; border-bottom: 1px solid #333;
          text-align: center; 
        }
        .v51-mantra-content { font-style: italic; font-size: 1.2rem; color: #fff; line-height: 1.6; }

        .v51-fractal-grid { display: flex; flex-direction: column; gap: 40px; }
        .v51-block-title { font-size: 1.4rem; color: #00ff00; margin-bottom: 15px; border-left: 3px solid #00ff00; padding-left: 15px; }
        .v51-block-body { line-height: 1.8; color: #bbb; text-align: justify; font-size: 1.05rem; }
      `}</style>
    </div>
  );
};
