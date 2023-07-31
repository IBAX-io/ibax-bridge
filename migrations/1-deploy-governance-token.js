const GovernanceToken = artifacts.require("GovernanceToken")

module.exports = async function (deployer) {

    const name = "GovernanceToken"
    const symbol = "GT"
    const supply = web3.utils.toWei('1000', 'ether')    // 1000 Tokens

    // Deploy token
    await deployer.deploy(GovernanceToken, name, symbol, supply)
    const governanceToken = await GovernanceToken.deployed()
    console.log("Deploy GovernanceToken:", governanceToken.address)
}