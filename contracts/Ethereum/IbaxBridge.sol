// SPDX-License-Identifier: GPL-3.0
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

pragma solidity ^0.8.12;

contract IbaxBridge is Ownable {
    using SafeERC20 for IERC20;

    event Deposit(address indexed sender, address token, uint256 amount);

    event Withdraw(
        address indexed sender,
        address token,
        uint256 amount,
        string message
    );

    event DepositMain(address indexed sender, uint256 amount);

    event WithdrawMain(address indexed sender, uint256 amount, string message);

    address[] public signers;
    mapping(address => bool) public isSigner;
    mapping(address => uint256) public mnonce;
    mapping(address => PoolInfo) poolInfo;
    address[] public keys;
    uint256 public required;

    struct PoolInfo {
        IERC20 token;
        bool flag;
    }

    struct Signature {
        address signer;
        bytes signature;
    }
    error VerifySignError(address caller, uint256 amount);

    modifier checkAmount(uint256 amount) {
        require(amount > 0, "amount is zero");
        _;
    }
    modifier checkSigLen(Signature[] memory signatures) {
        require(
            signatures.length == required,
            "the quantity of check is incorrect"
        );
        _;
    }

    constructor(address[] memory _signers, uint256 _required) {
        require(_signers.length > 0, "signers required");
        require(
            _required > 0 && _required <= _signers.length,
            "invalid required number of signers"
        );
        for (uint256 i = 0; i < _signers.length; ++i) {
            address _signer = _signers[i];
            require(_signer != address(0), "invalid signer");
            require(!isSigner[_signer], "signer is not unique");

            isSigner[_signer] = true;
            signers.push(_signer);
        }
        required = _required;
    }

    receive() external payable {
        emit DepositMain(msg.sender, msg.value);
    }

    function poolLength() external view returns (uint256) {
        return keys.length;
    }

    function add(IERC20 token) public onlyOwner {
        require(address(token).code.length > 0, "not the contract address");
        require(!poolInfo[address(token)].flag, "repeat addition");

        poolInfo[address(token)] = PoolInfo({token: token, flag: true});
        keys.push(address(token));
    }

    function deposit(address token, uint256 amount)
        external
        payable
        checkAmount(amount)
    {
        PoolInfo storage pool = poolInfo[token];
        pool.token.safeTransferFrom(address(msg.sender), address(this), amount);
        emit Deposit(msg.sender, token, amount);
    }

    function withdraw(
        Signature[] memory signatures,
        string memory txhash,
        uint256 amount,
        uint256 _nonce
    ) external payable checkAmount(amount) checkSigLen(signatures) {
        require(_nonce == mnonce[msg.sender], "error nonce");
        string memory message = string.concat(
            txhash,
            Strings.toString(amount),
            Strings.toString(_nonce)
        );

        if (verify(signatures, message)) {
            uint256 nonce = mnonce[msg.sender];
            mnonce[msg.sender] = nonce + 1;
            payable(msg.sender).transfer(amount);
            emit WithdrawMain(msg.sender, amount, message);
        } else {
            revert VerifySignError(msg.sender, amount);
        }
    }

    function withdraw(
        address token,
        Signature[] memory signatures,
        string memory txhash,
        uint256 amount,
        uint256 _nonce
    ) external payable checkAmount(amount) checkSigLen(signatures) {
        require(address(token).code.length > 0, "not the contract address");
        require(_nonce == mnonce[msg.sender], "error nonce");
        string memory message = string.concat(
            txhash,
            Strings.toString(amount),
            Strings.toString(_nonce)
        );

        if (verify(signatures, message)) {
            PoolInfo storage pool = poolInfo[token];
            uint256 nonce = mnonce[msg.sender];
            mnonce[msg.sender] = nonce + 1;
            pool.token.safeTransfer(address(msg.sender), amount);
            emit Withdraw(msg.sender, token, amount, message);
        } else {
            revert VerifySignError(msg.sender, amount);
        }
    }

    function addSigner(address _signer) external onlyOwner {
        require(_signer != address(0), "signer required");
        require(!isSigner[_signer], "signer is not unique");

        isSigner[_signer] = true;
        signers.push(_signer);
    }

    function cancelSigner(address _signer) external onlyOwner {
        require(_signer != address(0), "signer required");
        require(isSigner[_signer], "signer is not exist");
        delete isSigner[_signer];
        for (uint256 i = 0; i < signers.length; i++) {
            if (signers[i] == _signer) {
                signers[i] = signers[signers.length - 1];
                signers.pop();
                break;
            }
        }
    }

    function updateRequired(uint256 _required) external onlyOwner {
        require(
            _required > 0 && _required <= signers.length,
            "invalid required number of signers"
        );
        required = _required;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function verify(Signature[] memory signatures, string memory message)
        internal
        view
        returns (bool)
    {
        bytes32 messageHash = getMessageHash(message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        bool res = true;
        for (uint256 i = 0; i < signatures.length; i++) {
            address relay = recover(
                ethSignedMessageHash,
                signatures[i].signature
            );
            if (!isSigner[relay]) {
                res = false;
                break;
            }
        }

        return res;
    }

    function getMessageHash(string memory message)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(message));
    }

    function getEthSignedMessageHash(bytes32 messageHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    messageHash
                )
            );
    }

    function recover(bytes32 ethSignedMessageHash, bytes memory sig)
        public
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (
            uint8 v,
            bytes32 r,
            bytes32 s
        )
    {
        require(sig.length == 65);

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }
}