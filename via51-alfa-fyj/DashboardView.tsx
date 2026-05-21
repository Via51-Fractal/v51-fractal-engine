import React, { useEffect, useState } from 'react';
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://ibhhzgtxaqwdykedhtvk.supabase.co',
  'sb_publishable_BJ5ike7tqjI4oE_64Dw80w_wy4SkzaK'
);

const Dashboard = () => {
  const [stats, setStats] = useState({ total: 0, count: 0 });

  useEffect(() => {
    const fetchData = async () => {
      const { data } = await supabase.from('settlements').select('total_amount');
      if (data) {
        const total = data.reduce((acc, curr) => acc + Number(curr.total_amount), 0);
        setStats({ total, count: data.length });
      }
    };
    fetchData();
  }, []);

  return (
    <div style={{ backgroundColor: '#0f172a', color: 'white', minHeight: '100vh', padding: '2rem', fontFamily: 'sans-serif' }}>
      <h1 style={{ color: '#22d3ee', fontSize: '2rem', fontWeight: 'bold' }}>VIA51 - HOLDING DIGITAL</h1>
      <p style={{ color: '#94a3b8' }}>Edificio LePommier | Dashboard de Gestión Real</p>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '1.5rem', marginTop: '2rem' }}>
        <div style={{ background: '#1e293b', padding: '1.5rem', borderRadius: '0.75rem', border: '1px solid #ef4444' }}>
          <h3 style={{ fontSize: '0.75rem', color: '#64748b', textTransform: 'uppercase' }}>Monitor de Morosidad</h3>
          <p style={{ fontSize: '2.25rem', fontWeight: 'bold', color: '#ef4444' }}>S/ {stats.total.toLocaleString('en-US', { minimumFractionDigits: 2 })}</p>
          <p style={{ fontSize: '0.7rem', color: '#94a3b8' }}>{stats.count} UNIDADES PROCESADAS</p>
        </div>
        {/* Otros KPIs se mantienen consistentes */}
      </div>
    </div>
  );
};

export default Dashboard;
