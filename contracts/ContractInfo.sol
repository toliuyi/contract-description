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
   @title ContractInfo Human readable contract information registry. Implimentation of ERC***.

   Allow contract owner attach human readable information to contract and it's functions. Wallets such as
   MetaMask, Imtoken, Status, Toshi etc. could display those information to users when they about to confirm
   Ethereum transaction.

 */
contract ContractInfo {

  //inforamtion storage, contract address => function selector => language code => information
  mapping (address => mapping( bytes4 =>mapping (bytes5 => string))) public info_store;

  //event emitted after contract information got set
  event InfoAttached(address indexed contractAddr, bytes4 selector, bytes5 lang, string info);

  /**
   * @dev Throws if called by any account other than contract owner.
   */
  modifier onlyContractOwner(address contractAddr){
    require(Owned(contractAddr).owner() == msg.sender);
    _;
  }

  /**
   * @dev Allows the contract owner to attach human readable information of contract and it's functions.
   * @param contractAddr The address of the contract which info attached to.
   * @param selector The selector of function which info attached to, use contract name's selector to attach
   information for the whole contract.
   * @param lang ISO 639 language code of the information. Every contract should at least attach english info
   which language code is "en".
   * @param info Information string in UTF8 encoding.
   */
  function attachInfo(address contractAddr, bytes4 selector, bytes5 lang, string info)
   public onlyContractOwner(contractAddr){
    info_store[contractAddr][selector][lang] = info;
    emit InfoAttached(contractAddr, selector, lang, info);
  }

  /**
   * @dev Allows anyone query contract information from this registry.
   * @param contractAddr The address of the contract to query.
   * @param selector The selector of function to query, use contract name's selector to query
   information for the whole contract.
   * @param lang ISO 639 language code of the information. If there is no info attached in specified language, "en" used as defaut.
   * @return Information string in UTF8 encoding.
   */
  function getInfo(address contractAddr, bytes4 selector, bytes5 lang) constant public returns (string) {
    if(bytes(info_store[contractAddr][selector][lang]).length != 0) return info_store[contractAddr][selector][lang];
    else return info_store[contractAddr][selector]["en"];
  }

}