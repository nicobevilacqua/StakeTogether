import React, { useState } from 'react';

const { ethereum } = window as any;

function getAddNetworkData(network: any) {
  const { name, nativeCurrency, rpc, explorers, infoURL } = network;
  return {
    chainId: `0x${network.chainId.toString(16)}`,
    chainName: name,
    nativeCurrency,
    rpcUrls: rpc,
    blockExplorerUrls: [
      explorers && explorers.length > 0 && explorers[0].url ? explorers[0].url : infoURL,
    ],
  };
}

const expectedNetwork = {
  name: 'Localhost',
  chainId: 1337,
  nativeCurrency: {
    name: 'Ethereum',
    symbol: 'ETH',
    decimals: 18,
  },
  rpc: ['http://localhost:8545/'],
  explorers: [{ url: 'http://localhost:8545/' }],
};

const SwitchNetworkButton = () => {
  const [switching, setSwitching] = useState(false);

  async function onSwitch() {
    setSwitching(true);
    try {
      await ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [
          {
            chainId: `0x${expectedNetwork.chainId.toString(16)}`,
          },
        ],
      });
      console.log('switching');
    } catch (error: any) {
      // Missing network
      if (error.code === 4902) {
        try {
          await ethereum.request({
            method: 'wallet_addEthereumChain',
            params: [getAddNetworkData(expectedNetwork)],
          });
          console.log('Switching network');
        } catch (error: any) {
          console.error(error);
        }
        return;
      }
      console.error(error);
    }
    setSwitching(false);
  }

  return (
    <button onClick={onSwitch} disabled={switching}>
      {switching ? 'Switching' : 'Switch to correct network'}
    </button>
  );
};

export default SwitchNetworkButton;
