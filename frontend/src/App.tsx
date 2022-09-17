import React, { useState, Suspense, StrictMode, useEffect, useCallback } from 'react';
import { Route, Routes } from 'react-router';
import { HashRouter } from 'react-router-dom';

import Withdraw from './views/Withdraw';
import Home from './views/Home';
import Dashboard from './views/Dashboard';

import WalletContext from './context/WalletContext';

import detectEthereumProvider from '@metamask/detect-provider';
import { ethers } from 'ethers';
const { ethereum } = window as any;

import { getProvider } from './utils/wallet';

const App = () => {
  const [metamask, setMetamask] = useState<boolean | null>(null);
  const [network, setNetwork] = useState<any | null>(null);
  const [address, setAddress] = useState<string | null>(null);

  const context = {
    metamask,
    setMetamask,
    network,
    setNetwork,
    address,
    setAddress,
  };

  const initializeWallet = useCallback(async () => {
    const metamask = await detectEthereumProvider();
    setMetamask(!!metamask);

    if (!metamask) {
      return;
    }

    setNetwork(ethers.providers.getNetwork(parseInt(ethereum.networkVersion, 10)));

    const [_address] = await ethereum.request({
      method: 'eth_accounts',
    });
    setAddress(_address);

    ethereum.on('accountsChanged', ([_address]: [string]) => {
      setAddress(_address);
    });

    const provider = getProvider();
    if (provider) {
      provider.on('network', (_network) => {
        setNetwork(_network);
      });
    }
  }, [setAddress, setNetwork, setMetamask]);

  useEffect(() => {
    initializeWallet();
  }, [initializeWallet]);

  return (
    <StrictMode>
      <Suspense>
        <WalletContext.Provider value={context}>
          <HashRouter>
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="withdraw" element={<Withdraw />} />
              <Route path="dashboard" element={<Dashboard />} />
            </Routes>
          </HashRouter>
        </WalletContext.Provider>
      </Suspense>
    </StrictMode>
  );
};

export default App;
