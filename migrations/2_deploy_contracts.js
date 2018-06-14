var contract = artifacts.require("ContractDescRegistry");

module.exports = function(deployer) {
  deployer.deploy(contract);
};