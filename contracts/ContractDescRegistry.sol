pragma solidity ^0.4.20;

/**
   @title Owned, a standard interface to check smart contract owner

   Any contract implemente ERC*** should support this inferface, that to say has public ower() function to 
   return owner's address

 */
contract Owned {
  /**
   * @dev Return contract owner address. 
   * @return owner address
   */
  function owner() public view returns (address);
}

/**
   @title ContractDescRegistry Human readable contract description registry. Implimentation of ERC***.

   Allow contract owners register human readable descriptions to contract functions. Wallets such as
   MetaMask, Imtoken, Status, Toshi etc. could display those descriptions to users when they about to sign
   Ethereum transactions.

 */
contract ContractDescRegistry {

  //inforamtion storage, contract address => function selector => language code => description
  mapping (address => mapping( bytes4 =>mapping (bytes5 => string))) public desc_store;

  //event emitted after contract description registered
  event DescRegistered(address indexed contractAddr, bytes4 selector, bytes5 lang, string desc);

  /**
   * @dev Throws if called by any account other than contract owner.
   */
  modifier onlyContractOwner(address contractAddr){
    require(Owned(contractAddr).owner() == msg.sender);
    _;
  }

  /**
   * @dev Allows the contract owner to attach human readable description of contract and it's functions.
   * @param contractAddr The address of the contract which info attached to.
   * @param selector The selector of function which info attached to, use contract name's selector to attach
   description for the whole contract.
   * @param lang ISO 639 language code of the description. Every contract should at least attach english info
   which language code is "en".
   * @param desc in UTF8 encoding.
   */
  function attachDesc(address contractAddr, bytes4 selector, bytes5 lang, string desc) external onlyContractOwner(contractAddr){
    desc_store[contractAddr][selector][lang] = desc;
    emit DescRegistered(contractAddr, selector, lang, desc);
  }

  /**
   * @dev Allows anyone query contract description from this registry.
   * @param contractAddr The address of the contract to query.
   * @param selector The selector of function to query, use contract name's selector to query
   description for the whole contract.
   * @param lang ISO 639 language code of the description. If there is no description attached in specified language, "en" used as defaut.
   * @return description string in UTF8 encoding.
   */
  function getDesc(address contractAddr, bytes4 selector, bytes5 lang) constant external returns (string) {
    if(bytes(desc_store[contractAddr][selector][lang]).length != 0) return desc_store[contractAddr][selector][lang];
    else return desc_store[contractAddr][selector]["en"];
  }

}