---
eip: <to be assigned>
title: Descriptions for smart contracts and their functions
author: Yi Liu (@toliuyi)
discussions-to: <email address>
status: WIP
type: Standards Track
category : ERC
created: 2018-06-15
---

## Simple Summary

A standard for owners to register descriptions of their smart contracts, then wallet could display those descriptions to users upon interacting with Dapps, making better user experience.

## Abstract

This EIP specifies a registry for human readable contract descriptions , permitting contracts owners register human readable descriptions to contract functions and wallets (such as MetaMask, Imtoken, Status, Toshi etc.) could query and display those descriptions to users when they about to sign Ethereum transactions.

## Motivation

When users interact with Dapps, they often need to confirm transactions. But the confirmation UI which presented by installed wallet(such as MetaMask, Imtoken, Status, Toshi etc.) do NOT show proper messages to explain what the transaction all about. This situation often made user confused and hesitated to confirm. Thought there is EIP-926, Address metadata registry, could be used to associate descriptions with contract address, a simple and consistent standard will fix the problem far more efficiently. Then the overall Ethereum Dapp user experience gets improvement. 

## Specification

The description registry interface should be like this:

```
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
```

`attachDesc()` submit description to be associated with contract address, function selector and specified language, while `getDesc()` returns the description of supplied contract address, function select and language. Any contract utilize this registry should have public owner() function for registry to check description submitter is contract owner.

## Rationale
<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->
The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

### Store hash or message itself
An alternative design is store hash rather than description message itself. This approach would surely cost less gas to submit descriptions than the current one, but it will bring other issues such as:
* Description consumers (most likely wallet software) have to resort to off-chain web service to retrieve messages, make the architecture more complex and vulnerable to censorship and network outrage.
* Contract owners may intend to introduce their contract in detail that makes the messages too long to read. If message stored on Ethereum blockchain, the cost and gas limit may lead more refined message which is easy to read by users.


## Backwards Compatibility

There are no backwards compatibility concerns.

## Test Cases and Reference Implementation

Test cases and a reference implementation are available at [https://github.com/toliuyi/contract-description/](https://github.com/toliuyi/contract-description/)

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
