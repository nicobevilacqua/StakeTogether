import { ethers } from 'ethers';
const { ethereum } = window;

export function getProvider() {
  if (!ethereum) {
    return;
  }

  const provider: ethers.providers.Web3Provider = new ethers.providers.Web3Provider(
    ethereum,
    'any'
  );
  return provider;
}
