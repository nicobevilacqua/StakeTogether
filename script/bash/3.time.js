const { ethers, network } = require('hardhat');

// 6 meses
async function main() {
  await network.provider.send('evm_increaseTime', [6 * 24 * 30 * 60 * 60]);
  await network.provider.send('evm_mine', []);
}

main().then(() => { console.log("READY") });