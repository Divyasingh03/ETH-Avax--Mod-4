# Degen Token (DGN)

## Overview
Degen ERC-20 Token is a cryptocurrency token deployed on the Avalanche network for Degen Gaming. This token adheres to the ERC-20 standard and provides the following functionalities:

## Functionality
1. **Minting new tokens**: The platform owner can create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
2. **Transferring tokens**: Players can transfer their tokens to others.
3. **Redeeming tokens**: Players can redeem their tokens for items in the in-game store.
4. **Checking token balance**: Players can check their token balance at any time.
5. **Burning tokens**: Anyone can burn tokens that they own, which are no longer needed.

## Contract Details
- **Name**: Degen
- **Symbol**: DGN
- **Network**: Avalanche

## Implementation
The ERC-20 token contract follows the ERC-20 standard closely to ensure interoperability with other ERC-20 tokens, wallets, and exchanges. Additional functionalities and security measures have been added to ensure the token's effectiveness and security for Degen Gaming's reward program.

## Getting Started
```solidity
/*
1. Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
2. Transferring tokens: Players should be able to transfer their tokens to others.
3. Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
4. Checking token balance: Players should be able to check their token balance at any time.
5. Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct Inventory {
        uint bronzeCoin;
        uint copperCoin;
        uint crystal;
        uint elixir;
    }

    mapping(address => Inventory) public playerInventory;

    // Numerical identifiers for items
    uint constant BRONZE_COIN = 1;
    uint constant COPPER_COIN = 2;
    uint constant CRYSTAL = 3;
    uint constant ELIXIR = 4;

    // Events
    event MintCompleted(address indexed receiver, uint quantity);
    event TokensMoved(address indexed sender, address indexed receiver, uint quantity);
    event AssetRedeemed(address indexed player, uint assetId, uint cost);
    event TokensDestroyed(address indexed sender, uint quantity);

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

    function mint(address recipient, uint quantity) external onlyOwner {
        _mint(recipient, quantity);
        emit MintCompleted(recipient, quantity);
    }

    function transferTokens(address recipient, uint quantity) public {
        require(quantity <= balanceOf(msg.sender), "Insufficient balance");
        _transfer(msg.sender, recipient, quantity);
        emit TokensMoved(msg.sender, recipient, quantity);
    }

    function redeemAsset(uint assetId, uint cost) public {
        require(assetId >= BRONZE_COIN && assetId <= ELIXIR, "Invalid asset ID");
        require(balanceOf(msg.sender) >= cost, "Insufficient balance");

        if (assetId == BRONZE_COIN) {
            playerInventory[msg.sender].bronzeCoin += 1;
        } else if (assetId == COPPER_COIN) {
            playerInventory[msg.sender].copperCoin += 1;
        } else if (assetId == CRYSTAL) {
            playerInventory[msg.sender].crystal += 1;
        } else if (assetId == ELIXIR) {
            playerInventory[msg.sender].elixir += 1;
        }

        _burn(msg.sender, cost);
        emit AssetRedeemed(msg.sender, assetId, cost);
    }

    function viewBalance() public view returns (uint) {
        return balanceOf(msg.sender);
    }
}
```
    
## Testing
The smart contract has been thoroughly tested to ensure that all functionalities work as expected. All tests have passed successfully.

## Deployment
The smart contract has been deployed to the Avalanche Fuji Testnet for testing purposes.

## Verification
The smart contract has been verified on Snowtrace to provide transparency and ensure trustworthiness.

## Access
The smart contract address on the Avalanche Fuji Testnet is "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266". Users can interact with the contract using compatible wallets and dApps.

## License
[MIT License](../../LICENSE)
