import React, { Suspense, StrictMode } from 'react';
import ReactDOM from 'react-dom/client';
import Home from './views/Home';
import reportWebVitals from './reportWebVitals';
import { Route, Routes } from 'react-router';
import { HashRouter } from 'react-router-dom';
import './index.css';
import Withdraw from './views/Withdraw';
import Dashboard from './views/Dashboard';

import '@rainbow-me/rainbowkit/styles.css';
import { getDefaultWallets, RainbowKitProvider } from '@rainbow-me/rainbowkit';
import { chain, configureChains, createClient, WagmiConfig } from 'wagmi';
import { alchemyProvider } from 'wagmi/providers/alchemy';
import { publicProvider } from 'wagmi/providers/public';

const { chains, provider } = configureChains(
  [chain.mainnet, chain.polygon, chain.optimism, chain.arbitrum],
  [alchemyProvider(), publicProvider()]
);

const { connectors } = getDefaultWallets({
  appName: 'My RainbowKit App',
  chains,
});

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
});

const root = ReactDOM.createRoot(document.getElementById('root') as HTMLElement);
root.render(
  <StrictMode>
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider chains={chains}>
        <Suspense>
          <HashRouter>
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="withdraw" element={<Withdraw />} />
              <Route path="dashboard" element={<Dashboard />} />
            </Routes>
          </HashRouter>
        </Suspense>
      </RainbowKitProvider>
    </WagmiConfig>
  </StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
