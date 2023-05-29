# Ethereum bridge contract

Bridge contracts allow you to build cross-chain applications between Ibax and multiple Ethereum networks

----

- <a href="#Requirements">Requirements</a>
- <a href="#Setup">Setup</a>
    - <a href="#Setup1">Installing dependencies</a>
    - <a href="#Setup2">Using the .env File</a>
- <a href="#Deploy">Deploy</a>
- <a href="#Verify">Verify</a>    

<font id="Requirements">Requirements</font>
***

We recommend following these instructions here. The following requirements:

- [Node.js](https://nodejs.org/) v12 - 16 or later
- [NPM](https://docs.npmjs.com/cli/) version 5.2 or later
- Windows, Linux or MacOS
- An Infura account
- A MetaMask account

<font id="Setup">Setup</font>
***
<font id="Setup1">Installing dependencies</font>
```shell
npm install -D truffle-plugin-verify
npm install -g truffle
npm install @openzeppelin/contracts
npm install @truffle/hdwallet-provider
npm install dotenv
```
<font id="Setup2">Using the env File</font>

You will need the mnemonic to use with the network.      The .dotenv npm package has been installed for you, and you will need to create a .env file for storing your mnemonic and any other needed private information.

The .env file is ignored by git in this project to help protect your private data.      It is good security practice to avoid committing information about your private keys to github.  The truffle-config.js file expects a MNEMONIC value to exist in .env for running commands on the testnets and an INFURA_KEY to connect to the network.

To verify smart contracts, configure ETHERSCAN_API_KEY in the.env file
***
<font id="Deploy">Deploy</font>

Refer to the trufflesuite deployment contract

***
<font id="Verify">Verify</font>

Refer to truffle-plugin-verify