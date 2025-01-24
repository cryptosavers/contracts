// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WhitelistManager is Ownable {
    mapping(address => bool) private whitelisted;
    address[] private whitelistedAddresses;

    event Whitelisted(address indexed account, bool isWhitelisted);

    constructor(address initialOwner) Ownable(initialOwner) {}

    // Add an address to the whitelist
    function addWhitelist(address account) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(!whitelisted[account], "Address already whitelisted");
        whitelisted[account] = true;
        whitelistedAddresses.push(account);
        emit Whitelisted(account, true);
    }

    // Remove an address from the whitelist
    function removeWhitelist(address account) external onlyOwner {
        require(whitelisted[account], "Address is not whitelisted");
        whitelisted[account] = false;

        // Remove from array
        for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
            if (whitelistedAddresses[i] == account) {
                whitelistedAddresses[i] = whitelistedAddresses[whitelistedAddresses.length - 1];
                whitelistedAddresses.pop();
                break;
            }
        }
        emit Whitelisted(account, false);
    }

    // Check if an address is whitelisted
    function isWhitelisted(address account) external view returns (bool) {
        return whitelisted[account];
    }

    // Get all whitelisted addresses
    function getWhitelistedAddresses() external view returns (address[] memory) {
        return whitelistedAddresses;
    }
}