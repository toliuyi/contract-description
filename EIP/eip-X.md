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
<!--"If you can't explain it simply, you don't understand it well enough." Provide a simplified and layman-accessible explanation of the EIP.-->
If you can't explain it simply, you don't understand it well enough." Provide a simplified and layman-accessible explanation of the EIP.

A standard for owners to register descriptions of their smart contracts, then wallet could display those descriptions to users upon interacting with Dapps, making better user experience.

## Abstract
<!--A short (~200 word) description of the technical issue being addressed.-->
A short (~200 word) description of the technical issue being addressed.

This EIP specifies a registry for human readable contract descriptions , permitting contracts owners register human readable descriptions to contract functions and wallets (such as MetaMask, Imtoken, Status, Toshi etc.) could query and display those descriptions to users when they about to sign Ethereum transactions.

## Motivation
<!--The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.-->
The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.

When users interact with Dapps, they often need to confirm transactions. But the confirmation UI which presented by installed wallet(such as MetaMask, Imtoken, Status, Toshi etc.) do NOT show proper messages to
explain what the transaction all about. This situation often made user confused and hesitated to confirm. Thought there is EIP-926, Address metadata registry, could be used to associate descriptions with contract
address, a simple and consistent standard will fix the problem far more efficiently. Then the overall Ethereum Dapp user experience gets improvement. 

## Specification
<!--The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).-->
The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).

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
<!--All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.-->
All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.

There are no backwards compatibility concerns.

## Test Cases
<!--Test cases for an implementation are mandatory for EIPs that are affecting consensus changes. Other EIPs can choose to include links to test cases if applicable.-->
Test cases for an implementation are mandatory for EIPs that are affecting consensus changes. Other EIPs can choose to include links to test cases if applicable.

[Test Cases](https://github.com/toliuyi/contract-description/blob/master/test/ContractDescRegistryTest.js)

## Implementation
<!--The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.-->
The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.

[Implementation](https://github.com/toliuyi/contract-description/blob/master/contracts/ContractDescRegistry.sol)

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
