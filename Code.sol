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
