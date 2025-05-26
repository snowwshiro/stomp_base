import React from 'react';
import { createRoot } from 'react-dom/client';
import Layout from './components/Layout';
import Dashboard from './components/Dashboard';

const container = document.getElementById('root');
if (container) {
  const root = createRoot(container);
  root.render(
    <React.StrictMode>
      <Layout>
        <Dashboard />
      </Layout>
    </React.StrictMode>
  );
}
