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
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    struct Item {
        string name;
        uint8 itemId;
        uint256 price;
    }
    mapping (uint8 => Item) public items;
    uint8 public tokenId;
    
    event ItemPurchased(address indexed buyer, uint8 itemId, string itemName, uint256 price);
    event GameOutcome(address indexed player, uint256 num, bool won, string result);

    constructor(address initialOwner, uint tokenSupply) ERC20("Degen", "DGN") Ownable(initialOwner) {
        mint(initialOwner, tokenSupply);
        
        items[1] = Item("Bronze Coin", 1, 100);
        items[2] = Item("Silver Coin", 2, 700);
        items[3] = Item("Gold Coin", 3, 1200);
        items[4] = Item("Brass Coin", 4, 2200);
        items[5] = Item("Diamond Coin", 5, 2400);
        tokenId = 6;
    }

    // Overriding decimals to 0
    function decimals() override public pure returns (uint8){
        return 0;
    }

    // Minting tokens - Only the owner can mint tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transferring tokens using the standard ERC20 transfer method
    function transferToken(address _recipient, uint256 _amount) external {
        transfer(_recipient, _amount); // The ERC20 transfer function handles balance checks and transfer
    }

    // Redeeming tokens (store items or bonuses)
    function welcomeBonus() public {
        require(balanceOf(msg.sender) == 0, "You've already claimed your welcome bonus");
        _mint(msg.sender, 50);
    }

    function addItem(string memory _name, uint256 _price) public onlyOwner {
        items[tokenId] = Item(_name, tokenId, _price);
        tokenId++;
    }

    function isLessThanFive(bool _prediction, uint256 _betAmount) public {
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 10;

        if (_prediction == (randomNumber < 5)) {
            _mint(msg.sender, _betAmount * 2);
            emit GameOutcome(msg.sender, randomNumber, true, "won");
        } else {
            burn(_betAmount);
            emit GameOutcome(msg.sender, randomNumber, false, "lost");
        }
    }

    // Redeem tokens for items
    function purchaseItem(uint8 _itemId) external {
        require(items[_itemId].price != 0, "Item not found");
        require(balanceOf(msg.sender) >= items[_itemId].price, "Insufficient balance");

        burn(items[_itemId].price);

        emit ItemPurchased(msg.sender, _itemId, items[_itemId].name, items[_itemId].price);
    }

    // Checking token balance - No need for an additional function as ERC20 provides balanceOf()
    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Burning tokens - Uses the ERC20Burnable function
    function burnToken(uint256 _amount) external {
        burn(_amount);
    }
}

```
To run this program, follow these steps:

1. **Open Remix IDE**: Navigate to [Remix Ethereum](https://remix.ethereum.org/).
2. **Create a New File**: Create a new Solidity file (e.g., `DegenToken.sol`) and paste your Solidity code.
3. **Compile the Contract**: 
   - Click on the "Solidity Compiler" tab in the left-hand sidebar.
   - Select the compiler version `0.8.18` (or any compatible version).
   - Click on the "Compile DegenToken.sol" button.
4. **Deploy the Contract**:
   - Go to the "Deploy & Run Transactions" tab in the left-hand sidebar.
   - Select the `DegenToken` contract from the dropdown menu.
   - Click on the "Deploy" button.
   - Confirm the transaction in MetaMask.

### Interacting with the Contract

After deploying the contract, you can interact with its functions through the Remix interface:

- **Minting Tokens**: Call the `mint` function to create new tokens (only available to the owner).
- **Transferring Tokens**: Use the standard `transfer` function to send tokens to another address.
- **Redeeming Tokens**: Call the `purchaseItem` function to redeem tokens for in-game items.
- **Checking Balance**: Use the `balanceOf` function to check your token balance.
- **Burning Tokens**: Call the `burn` function to destroy tokens from your balance.
- **Game Mechanic**: Engage in the game by calling the `isLessThanFive` function with your bet.

    
## Testing
The smart contract has been thoroughly tested to ensure that all functionalities work as expected. All tests have passed successfully.

## Deployment
The smart contract has been deployed to the Avalanche Fuji Testnet for testing purposes.

## Verification
The smart contract has been verified on Snowtrace to provide transparency and ensure trustworthiness.

## Access
The smart contract address on the Avalanche Fuji Testnet is "0x52EA7E679ECdd8dcaD51032f1117Da3bA9756cD2". Users can interact with the contract using compatible wallets and dApps.

## License
[MIT License](../../LICENSE)
