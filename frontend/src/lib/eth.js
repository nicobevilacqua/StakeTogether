import { writable, get } from "svelte/store";

import { Web3Provider } from "@ethersproject/providers";

export const wallet = writable(null);
export const provider = writable(null);
export const signer = writable(null);
export const errorTx = writable(false);
export const networkDetails = writable({});
export const chainId = writable(-1);


let _provider;

let web3Modal;



export async function init() {
    _provider = new Web3Provider(window.ethereum, "any");

    const __p = _provider;
    if(_provider) {
      const _networkDetails = await _provider.getNetwork();
      networkDetails.set(_networkDetails);
      chainId.set(_networkDetails.chainId);
      provider.set(_provider);
      const _signer = await _provider.getSigner();
      const _wallet = await _signer.getAddress();

      wallet.set(_wallet);
      signer.set(_signer);
    }
    __p.on("chainChanged", (oldNetwork) => {
      if (oldNetwork) {
        setTimeout(() => {
          init();
        }, 0);
      }
    });
    
    const _signer = await _provider.getSigner();
    const _wallet = await _signer.getAddress();

    window.ethereum.on('accountsChanged', function (accounts) {
      if (accounts[0] !== _wallet) {
        //document.location.reload()
        setTimeout(() => {
          init();
        }, 0);
      }
      // document.location.reload();
    });

    __p.on("accountsChanged", (accounts) => {
      if (accounts[0] !== _wallet) {
        //document.location.reload()
        setTimeout(() => {
          init();
        }, 0);
      }
    });
    
  provider.set(_provider);
  const _networkDetails = await _provider.getNetwork();
  networkDetails.set(_networkDetails);
  chainId.set(_networkDetails.chainId);
  provider.set(_provider);

  wallet.set(_wallet);
  signer.set(_signer);


  if (_wallet) {
    // algo
  }
}

export async function login() {
  try {
    // await window.web3Modal.connect();
    await window.ethereum.enable();
  } catch(err) {
  }
  
  await init();
}

export async function changeNetwork() {
  const chainId = `0x${(31337).toString(16)}`;
    try {
        await window.ethereum.request({
          method: 'wallet_switchEthereumChain',
          params: [{ chainId }]
        });
      } catch (err) {
        /*
          // This error code indicates that the chain has not been added to MetaMask
        if (err.code === 4902) {
          await window.ethereum.request({
            method: 'wallet_addEthereumChain',
            params: [
              {
                chainName: 'Goerly',
                chainId,
                nativeCurrency: { name: 'ETH', decimals: 18, symbol: 'ETH' },
                rpcUrls: ['https://rpc.goerli.mudit.blog/']
              }
            ]
          });
        }
        */
      }
/*
    await window.ethereum.request({
    method: "wallet_addEthereumChain",
    params: [
        {
          chainId: `0x${(5).toString(16)}`,
        }
      ]
    /*params: [
        {
          chainId: `0x${(80001).toString(16)}`,
          chainName: "Mumbai Polygon TestNet",
          nativeCurrency: {
            name: "MATIC",
            symbol: "matic",
            decimals: 18,
          },
          rpcUrls: ["https://matic-testnet-archive-rpc.bwarelabs.com/", "https://matic-mumbai.chainstacklabs.com/", "https://rpc-mumbai.matic.today/"],
          blockExplorerUrls: ["https://mumbai.polygonscan.com/"],
        },
      ],
      */
    //});
    setTimeout(() => {
      window.location.reload();
    }, 700);
  }

export async function getGasPrice() {
  let gasPrice = null;
  // let maxFeePerGas = null;
  // let maxPriorityFeePerGas = null;
  try {
    const _provider = await get(provider);
    const feeData = await _provider.getFeeData();
    gasPrice = String(feeData.gasPrice.mul(2));
    // maxFeePerGas = String(feeData.maxFeePerGas.mul(2));
    // maxPriorityFeePerGas = String(feeData.maxPriorityFeePerGas.mul(2));
  } catch(err) {
    console.log(err);
  }
  return gasPrice;
}