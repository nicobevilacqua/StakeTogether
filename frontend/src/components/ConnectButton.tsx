import React, { useState, useContext } from 'react';

import WalletContext from '../context/WalletContext';

const { ethereum } = window as any;

const ConnectButton: React.FC = () => {
  const [connecting, setConnecting] = useState(false);

  const { setAddress } = useContext(WalletContext);

  async function onConnect() {
    setConnecting(true);
    try {
      const [_address] = await ethereum.request({
        method: 'eth_requestAccounts',
      });

      setAddress(_address);
    } catch (error) {
      console.error(error);
    }
    setConnecting(false);
  }

  return (
    <button onClick={onConnect} disabled={connecting}>
      {connecting ? 'Connecting' : 'Connect'}
    </button>
  );
};

export default ConnectButton;
