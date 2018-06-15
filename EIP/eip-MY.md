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
<!--You can leave these HTML comments in your merged EIP and delete the visible duplicate text guides, they will not appear and may be helpful to refer to if you edit it again. This is the suggested template for new EIPs. Note that an EIP number will be assigned by an editor. When opening a pull request to submit your EIP, please use an abbreviated title in the filename, `eip-draft_title_abbrev.md`. The title should be 44 characters or less.-->

## Simple Summary
<!--"If you can't explain it simply, you don't understand it well enough." Provide a simplified and layman-accessible explanation of the EIP.-->
A standard for dApp developers to register descriptions of their smart contracts, then wallet could display those descriptions to users upon signing transactions, making better user experience.

## Abstract
<!--A short (~200 word) description of the technical issue being addressed.-->
This EIP specifies a registry for human readable contract descriptions , permitting contracts owners register descriptions to contract functions and then wallets (such as MetaMask, Imtoken, Status, Toshi etc.) could query and display those descriptions to users when they about to sign Ethereum transactions.

## Motivation
<!--The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.-->
When users interact with dApps, they often need to confirm transactions. But the confirmation UI which presented by installed wallet(such as MetaMask, Imtoken, Status, Toshi etc.) do NOT show proper messages to explain what the transaction all about. This situation often made user confused and hesitated to confirm. Thought there is EIP-926, Address metadata registry could be used to associate description messages with contract address, a simple and consistent standard could fix the issue far more efficiently. Then the overall Ethereum dApp user experience gets improved. 

## Specification
<!--The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).-->

### Interface

```
pragma solidity ^0.4.20;

/**
   @title Owned, a standard interface to check smart contract owner

   Any contract implemente ERC*** should support this inferface, having public ower() function to return contract owner's address

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

  //event emitted after a contract description registered
  event DescRegistered(address indexed contractAddr, bytes4 selector, bytes5 lang, string desc);

  /**
   * @dev Throws if called by any account other than contract owner.
   */
  modifier onlyContractOwner(address contractAddr){
    require(Owned(contractAddr).owner() == msg.sender);
    _;
  }

  /**
   * @dev Allows the contract owner to register human readable description of contract and it's functions.
   * @param contractAddr The address of the contract which description assciatated with.
   * @param selector The selector of function which description assciatated with, use empty bytes to assciatate description to the whole contract.
   * @param lang ISO 639 language code of the description. Every contract should at least register description in english which language code is "en".
   * @param desc Description string in UTF8 encoding which supports argument injection,such as "Deposite $(_value)[18]$ Ether".
   */
  function attachDesc(address contractAddr, bytes4 selector, bytes5 lang, string desc) external onlyContractOwner(contractAddr){
    desc_store[contractAddr][selector][lang] = desc;
    emit DescRegistered(contractAddr, selector, lang, desc);
  }

  /**
   * @dev Allows anyone query contract description messages from this registry.
   * @param contractAddr The address of the contract to query.
   * @param selector The selector of function to query, use contract name's selector to query description of the whole contract.
   * @param lang ISO 639 language code of the description. If there is no description in specified language, "en" used as defaut.
   * @return Description string in UTF8 encoding which supports argument injection,such as "Deposite $(_value)[18]$ Ether".
   */
  function getDesc(address contractAddr, bytes4 selector, bytes5 lang) constant external returns (string) {
    if(bytes(desc_store[contractAddr][selector][lang]).length != 0) return desc_store[contractAddr][selector][lang];
    else return desc_store[contractAddr][selector]["en"];
  }

}
```

`attachDesc()` submit description to be associated with contract address, function selector and specified language, while `getDesc()` returns the description of supplied contract address, function select and language. Any contract utilize this registry should have public owner() function for registry to check description submitter is contract owner.

### Parameters
* contractAddr, The address of the contract which descriptions are assciatated with.
* selector, The selector of function which description is assciatated with. Use empty bytes to assciatate description to the whole contract. Since user don't interact with constructor function, so no description is needed.
* lang, ISO 639 language code of the description, such as en/de/ru/zh_CN. Defaut language is en.
* desc, Description message in UTF8 encoding which supports argument injection,such as "Deposite $(_value)[18]$ Ether".

### Argument Injection
Description messages can be argumented by client software with transaction parameters. This would help in showing end-users that the expected values are being passed to the function. To inject a function argument into the text, use the opening and closing pairs: "$(" and ")$" , for example $(ARGUMENT_NAME)$.

An optional helper can be included in this syntax to display numeric values (such as a token's value) with their appropriate decimal places. To do this, square brackets containing the number of decimal places between 0 and 18 can be included before the ending $ character: $(ARGUMENT_NAME)[18]$. All variables can be parsed and displayed automatically by client software by simply looking at the parameter name and type defined in the ABI.

This part draw lessons from [ERC: URI Format for Calling Functions #1138](https://github.com/ethereum/EIPs/issues/1138)

## Rationale
<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

### Store hash or message itself
An alternative design is store hash rather than description message itself. This approach would surely cost less gas to submit descriptions than the current one, but it will bring other issues such as:
* Description consumers (most likely wallet software) have to resort to off-chain web service to retrieve messages, make the architecture more complex and vulnerable to censorship and network outrage.
* Contract owners may intend to introduce their contract in detail that makes the messages too long to read. If message stored on Ethereum blockchain, the cost and gas limit may lead more refined message which is easy to read by users.


## Backwards Compatibility
<!--All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.-->
There are no backwards compatibility concerns.

## Test Cases and Reference Implementation
<!--Test cases for an implementation are mandatory for EIPs that are affecting consensus changes. Other EIPs can choose to include links to test cases if applicable.-->
<!--The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.-->
Test cases and a reference implementation are available at [https://github.com/toliuyi/contract-description/](https://github.com/toliuyi/contract-description/)

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
