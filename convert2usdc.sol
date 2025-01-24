// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IWhitelistManager {
    function isWhitelisted(address account) external view returns (bool);
}

contract convert2usdc is Ownable {
    IERC20 public cscsToken;
    IERC20 public usdcToken;
    IWhitelistManager public whitelistManager;

    uint256 public usdcPool;
    uint256 public feePercentage = 30; // Fee percentage in basis points (0.3%)

    event Converted(address indexed account, uint256 cscsAmount, uint256 usdcAmount, uint256 fee);
    event USDCDeposited(address indexed account, uint256 amount);
    event FeeUpdated(uint256 newFeePercentage);

    constructor(
        address _cscsToken,
        address _usdcToken,
        address _whitelistManager
    ) Ownable(msg.sender) {
        require(_cscsToken != address(0), "Invalid CSCS token address");
        require(_usdcToken != address(0), "Invalid USDC token address");
        require(_whitelistManager != address(0), "Invalid whitelist manager address");

        cscsToken = IERC20(_cscsToken);
        usdcToken = IERC20(_usdcToken);
        whitelistManager = IWhitelistManager(_whitelistManager);
    }

    modifier onlyWhitelisted() {
        require(whitelistManager.isWhitelisted(msg.sender), "Not whitelisted");
        _;
    }

    // Deposit USDC into the pool
    function depositUSDC(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than zero");
        require(usdcToken.transferFrom(msg.sender, address(this), amount), "USDC transfer failed");

        usdcPool += amount;
        emit USDCDeposited(msg.sender, amount);
    }

    // Update fee percentage
    function updateFeePercentage(uint256 newFeePercentage) external onlyOwner {
        require(newFeePercentage <= 1000, "Fee percentage cannot exceed 10%");
        feePercentage = newFeePercentage;
        emit FeeUpdated(newFeePercentage);
    }

    // Convert CSCS tokens to USDC at a 1:1 ratio minus fee
    function convert(uint256 cscsAmount) external onlyWhitelisted {
        require(cscsAmount > 0, "Amount must be greater than zero");
        require(cscsToken.allowance(msg.sender, address(this)) >= cscsAmount, "Insufficient CSCS allowance");
        require(cscsToken.balanceOf(msg.sender) >= cscsAmount, "Insufficient CSCS balance");
        require(usdcPool >= cscsAmount, "Insufficient USDC pool");

        uint256 fee = (cscsAmount * feePercentage) / 10000; // Calculate fee in USDC
        uint256 usdcAmount = cscsAmount - fee; // Amount to be sent after deducting fee

        // Transfer CSCS tokens from user to the contract
        require(cscsToken.transferFrom(msg.sender, address(this), cscsAmount), "CSCS transfer failed");

        // Transfer USDC tokens from the contract to the user
        require(usdcToken.transfer(msg.sender, usdcAmount), "USDC transfer failed");

        usdcPool -= cscsAmount;
        emit Converted(msg.sender, cscsAmount, usdcAmount, fee);
    }

    // Get USDC pool balance
    function getUSDCBalance() external view returns (uint256) {
        return usdcToken.balanceOf(address(this));
    }
}
