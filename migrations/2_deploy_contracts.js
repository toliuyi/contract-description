var ContractInfo = artifacts.require("ContractInfo");

module.exports = function(deployer) {
  deployer.deploy(ContractInfo);
};