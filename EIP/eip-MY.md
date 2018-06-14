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

When users interact with Dapps, they often need to confirm transactions. But the confirmation UI which presented by installed wallet(such as MetaMask, Imtoken, Status, Toshi etc.) do NOT show proper messages to
explain what the transaction all about. This situation often made user confused and hesitated to confirm. Thought there is EIP-926, Address metadata registry, could be used to associate descriptions with contract
address, a simple and consistent standard will fix the problem far more efficiently. Then the overall Ethereum Dapp user experience gets improvement. 

## Specification

The description registry has two main fuction:

```
function attachDesc(address contractAddr, bytes4 selector, bytes5 lang, string desc) external onlyContractOwner(contractAddr);

function getDesc(address contractAddr, bytes4 selector, bytes5 lang) constant external returns (string);
```

`attachDesc()` submit description to be associated with contract address, function selector and specified language, while `getDesc()` returns the description of supplied contract address, function select and language.

## Rationale
<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->
The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->



## Backwards Compatibility

There are no backwards compatibility concerns.

## Test Cases

[Test Cases](https://github.com/toliuyi/contract-description/blob/master/test/ContractDescRegistryTest.js)

## Implementation

[Implementation](https://github.com/toliuyi/contract-description/blob/master/contracts/ContractDescRegistry.sol)

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
