const IbaxBridge = artifacts.require("IbaxBridge");

module.exports = function (deployer) {
    deployer.deploy(IbaxBridge, [], 0);
};