/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    hardhat: {
      loggingEnabled: true,
      // url: "http://localhost:8545/",
      chainId: 31337,
    },
  }
};
