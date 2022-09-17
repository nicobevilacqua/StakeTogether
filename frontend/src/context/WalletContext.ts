import { createContext } from 'react';

type Wallet = {
  metamask: any;
  setMetamask: any;
  network: any;
  setNetwork: any;
  address: any;
  setAddress: any;
};

const context: Wallet = {
  metamask: null,
  setMetamask: () => {
    //
  },
  network: null,
  setNetwork: () => {
    //
  },
  address: null,
  setAddress: () => {
    //
  },
};

export default createContext(context);
