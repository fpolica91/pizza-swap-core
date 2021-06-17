const Router = artifacts.require("PancakeRouter01.sol");
const WETH = artifacts.require("Weth.sol");

module.exports = async function (deployer) {
  let weth;
  const FACTORY_ADDRESS = "0xc8CBF32973ec5bB19d3A7684Da9Edf339959f364";
  await deployer.deploy(WETH);
  weth = await WETH.deployed()

  await deployer.deploy(Router, FACTORY_ADDRESS, weth.address);
};
