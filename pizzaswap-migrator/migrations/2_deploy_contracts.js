const Potatoe = artifacts.require("PotatoeToken.sol");
const LiquidityMigrator = artifacts.require("LiquidityMigrator.sol");

module.exports = async function (deployer) {
  await deployer.deploy(Potatoe);
  const potatoe = await Potatoe.deployed();
  let routerAddress = '';
  let pairAddress = '';
  let routerForkAddress = '';
  let pairForkAddress = '';

};
