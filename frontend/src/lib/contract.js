import CONTRACTS_ADDRESS from "./address.json";

import abis from "../abi/index.js";
import { get } from "svelte/store";
import { Contract } from "@ethersproject/contracts";
// import { Contract as MCALLContract, Provider as MCALLProvider, setMulticallAddress } from "ethers-multicall";
import { networkDetails, signer } from "./eth";

const contractsDict = {};

export default async function getContract(contractName, abiName) {
  const _signer = await get(signer);
  const net = await get(networkDetails);
  const netName = net.name === "unknown" ? "localhost" : net.name;
  
  if (!contractsDict[netName]) {
    contractsDict[netName] = {};
  }

  const dict = contractsDict[netName];
  if(dict[contractName]) {
    return dict[contractName].connect(_signer);
  }

  if (contractName.slice(0,2) == '0x' && abiName != '') {
    dict[contractName] = new Contract(contractName, abis[abiName], _signer);
    return dict[contractName];  
  }

  if (!CONTRACTS_ADDRESS[netName]) {
    throw new Error(`No contracts address for ${netName}`);
  }

  if (!CONTRACTS_ADDRESS[netName][contractName]) {
    throw new Error(`No contracts address for ${contractName} in ${netName}`);
  }

  if (!(abis[contractName] || abis[abiName])) {
    throw new Error(`No abi for ${contractName}`);
  }

  dict[contractName] = new Contract(CONTRACTS_ADDRESS[netName][contractName], abis[abiName] || abis[contractName], _signer);
  return dict[contractName];  
}

export async function getAddress(contractName) {
  const net = await get(networkDetails);
  const netName = net.name === "unknown" ? "localhost" : net.name;
  
  if (!CONTRACTS_ADDRESS[netName]) {
    throw new Error(`No contracts address for ${netName}`);
  }

  if (!CONTRACTS_ADDRESS[netName][contractName]) {
    throw new Error(`No contracts address for ${contractName} in ${netName}`);
  }

  return CONTRACTS_ADDRESS[netName][contractName];
}