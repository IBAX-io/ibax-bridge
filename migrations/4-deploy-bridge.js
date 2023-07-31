const Bridge = artifacts.require("Bridge")
const Timelock = artifacts.require("Timelock")
const Governance = artifacts.require("Governance")

module.exports = async function (deployer) {

    await deployer.deploy(Bridge,
        "",
        [],
        3)

    const bridge = await Bridge.deployed()
    console.log("Deploy Bridge:", bridge.address);

    const governance = await Governance.deployed()
    const timelock = await Timelock.deployed()
    bridge.transferOwnership(timelock.address)

    const proposerRole = await timelock.PROPOSER_ROLE()
    const executorRole = await timelock.EXECUTOR_ROLE()
    const adminRole = await timelock.TIMELOCK_ADMIN_ROLE()

    await timelock.grantRole(proposerRole, governance.address)
    await timelock.grantRole(executorRole, governance.address)
    await timelock.revokeRole(adminRole, admin)
}