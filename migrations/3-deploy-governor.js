const Governance = artifacts.require("Governance")
const GovernanceToken = artifacts.require("GovernanceToken")
const Timelock = artifacts.require("Timelock")

module.exports = async function (deployer) {
    // Deploy governanace
    const quorum = 5 // Percentage of total supply of tokens needed to aprove proposals (5%)
    const votingDelay = 10 // How many blocks after proposal until voting becomes active
    const votingPeriod = 100 // How many blocks to allow voters to vote

    const governanceToken = await GovernanceToken.deployed()
    const timeLock = await Timelock.deployed()

    await deployer.deploy(Governance, governanceToken.address, timeLock.address, quorum, votingDelay, votingPeriod)
    const governance = await Governance.deployed()

    console.log("Deploy Governance:", governance.address);
}