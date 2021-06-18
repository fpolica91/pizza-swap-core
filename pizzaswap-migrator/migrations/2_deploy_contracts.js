const Potatoe = artifacts.require("PotatoeToken.sol");
const LiquidityMigrator = artifacts.require("LiquidityMigrator.sol");

module.exports = async function (deployer) {
  await deployer.deploy(Potatoe);
  const potatoe = await Potatoe.deployed();
  let routerAddress = '0x10ED43C718714eb63d5aA57B78B54704E256024E';
  let pairAddress = '0x2BAa0d223c99CDf6a83735c9752F60cB9860b924';
  let routerForkAddress = '0x7e42399f2726213f553cAC5a942809485FEf3959';
  let pairForkAddress = '0xD3c4CD3B46aDdE76434560e57649b1a22024c7a6';

  await deployer.deploy(
    LiquidityMigrator,
    routerAddress,
    pairAddress,
    routerForkAddress,
    pairForkAddress,
    potatoe.address
  )
  const liquidityMigrator = await LiquidityMigrator.deployed();
  await potatoe.setLiquidator(liquidityMigrator.address);
};
