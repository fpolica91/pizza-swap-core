const Factory = artifacts.require("PizzaSwapFactory.sol");
const ChloeToken = artifacts.require("ChloeToken.sol");
const OthelloToken = artifacts.require("OthelloToken.sol");

module.exports = async function (deployer, _network, addresses) {
  await deployer.deploy(Factory, addresses[0]);
  const factory = await Factory.deployed()
  await deployer.deploy(OthelloToken);
  await deployer.deploy(ChloeToken);
  const chlo = await ChloeToken.deployed()
  const otto = await OthelloToken.deployed()
  await factory.createPair(chlo.address, otto.address);
};
