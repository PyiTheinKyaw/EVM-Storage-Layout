require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.21",
};

extendEnvironment((hre) => {
  const Web3 = require("web3");
  hre.Web3 = Web3;

  // hre.network.provider is an EIP1193-compatible provider.
  hre.web3 = new Web3(hre.network.provider);

  // web3-eth module here.
  hre.getStorageAt = hre.web3.eth.getStorageAt;
  
  //web3.utils module here.
  hre.hex2num = hre.web3.utils.hexToNumber;
  hre.hex2str = hre.web3.utils.hexToString;
  hre.soliditySha3 = hre.web3.utils.soliditySha3;
  hre.padLeft = hre.web3.utils.padLeft;
});