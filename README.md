# CSCS to USDC Conversion Contracts

This repository contains two Solidity smart contracts designed to handle token conversions and manage whitelisted users.

## Contracts Overview

### 1. `WhitelistManager`
The `WhitelistManager` contract handles user whitelisting functionality. It allows the owner to manage whitelisted addresses, ensuring only authorized users can access certain features of other contracts.

#### Features:
- Add and remove addresses from the whitelist.
- Retrieve a list of all whitelisted addresses.
- Check if a specific address is whitelisted.

#### Key Functions:
- `addWhitelist(address account)` - Adds an address to the whitelist.
- `removeWhitelist(address account)` - Removes an address from the whitelist.
- `isWhitelisted(address account)` - Checks if an address is whitelisted.
- `getWhitelistedAddresses()` - Returns all whitelisted addresses.

### 2. `convert2usdc`
The `convert2usdc` contract facilitates the conversion of CSCS tokens to USDC. It uses the `WhitelistManager` contract to ensure only authorized users can perform conversions.

#### Features:
- Converts CSCS tokens to USDC at a 1:1 ratio minus a configurable fee.
- Allows the owner to set and update the fee percentage.
- Allows the owner to deposit USDC into the contract's pool for liquidity.
- Retrieves the current USDC pool balance.

#### Key Functions:
- `convert(uint256 cscsAmount)` - Converts CSCS tokens to USDC.
- `depositUSDC(uint256 amount)` - Deposits USDC into the pool.
- `updateFeePercentage(uint256 newFeePercentage)` - Updates the fee percentage.
- `getUSDCBalance()` - Returns the current USDC pool balance.

## Deployment Instructions

### Prerequisites:
- Install [Node.js](https://nodejs.org/).
- Install [Hardhat](https://hardhat.org/).

### Deployment Steps:

1. Clone this repository:
   ```bash
   git clone https://github.com/your-repo-url.git
   cd your-repo-directory
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Compile the contracts:
   ```bash
   npx hardhat compile
   ```

4. Deploy the `WhitelistManager` contract:
   ```javascript
   const WhitelistManager = await ethers.getContractFactory("WhitelistManager");
   const whitelistManager = await WhitelistManager.deploy();
   console.log("WhitelistManager deployed at:", whitelistManager.address);
   ```

5. Deploy the `convert2usdc` contract:
   ```javascript
   const Convert2USDC = await ethers.getContractFactory("convert2usdc");
   const convert2USDC = await Convert2USDC.deploy(
     "0xa6Ec49E06C25F63292bac1Abc1896451A0f4cFB7", // CSCS token address
     "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", // USDC token address
     whitelistManager.address // WhitelistManager address
   );
   console.log("convert2usdc deployed at:", convert2USDC.address);
   ```

## Usage

### Adding Users to the Whitelist
1. Use the `addWhitelist` function in the `WhitelistManager` contract to authorize a user.
   ```javascript
   await whitelistManager.addWhitelist("0xUserAddress");
   ```

### Depositing USDC
1. Use the `depositUSDC` function in the `convert2usdc` contract to provide liquidity.
   ```javascript
   await convert2USDC.depositUSDC(amount);
   ```

### Converting CSCS to USDC
1. Users can call the `convert` function to swap their CSCS tokens for USDC.
   ```javascript
   await convert2USDC.connect(user).convert(cscsAmount);
   ```

## Testing

1. Run tests:
   ```bash
   npx hardhat test
   ```

## License

This project is licensed under the MIT License.

## Acknowledgments

- [OpenZeppelin Contracts](https://openzeppelin.com/contracts/) for providing reusable smart contract components.
- [Hardhat](https://hardhat.org/) for contract development and testing.

