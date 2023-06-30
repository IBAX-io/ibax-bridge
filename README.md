# Ethereum bridge contract

Bridge contracts allow you to build cross-chain applications between IBAX Network and multiple Ethereum VM networks

----

- [Requirements](#requirements)
- [Setup](#setup)
    - [Installing dependencies](#installing-dependencies)
    - [Using the .env File](#using-the-env-file)
- [Deploy](#deploy)
- [Verify](#verify)    

## Requirements

----

We recommend following these instructions here. The following requirements:

- [Node.js](https://nodejs.org/) v12 - 16 or later
- [NPM](https://docs.npmjs.com/cli/) version 5.2 or later
- Windows, Linux or MacOS
- An Infura account
- A MetaMask account

## Setup

----

### Installing dependencies
```shell
npm install -D truffle-plugin-verify
npm install -g truffle
npm install @openzeppelin/contracts
npm install @truffle/hdwallet-provider
npm install dotenv
```
### Using the env File

You will need the mnemonic to use with the network.      The .dotenv npm package has been installed for you, and you will need to create a .env file for storing your mnemonic and any other needed private information.

The .env file is ignored by git in this project to help protect your private data.      It is good security practice to avoid committing information about your private keys to github.  The truffle-config.js file expects a MNEMONIC value to exist in .env for running commands on the testnets and an INFURA_KEY to connect to the network.

To verify smart contracts, configure ETHERSCAN_API_KEY in the.env file

----

## Deploy

Refer to the trufflesuite deployment contract

----

## Verify

Refer to truffle-plugin-verify




