// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct PlayerItems {
        uint Bracelets;
        uint Chain ;
        uint Bangles ;
        uint Rings;
    }

    mapping(address => PlayerItems) public playerItems;

    // Numerical identifiers for items
    uint constant Bracelets = 1;
    uint constant Chain= 2;
    uint constant Bangles= 3;
    uint constant  Rings = 4;

    // Events
    event Minted(address indexed to, uint amount);
    event TokensTransferred(address indexed from, address indexed to, uint amount);
    event ItemRedeemed(address indexed player, uint itemId, uint price);
    event TokensBurned(address indexed from, uint amount);

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

    function mint(address _to, uint amt) external onlyOwner {
        _mint(_to, amt);
        emit Minted(_to, amt);
    }

// 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
    function transferTokens(address _to, uint amt) public {
        require(amt <= balanceOf(msg.sender), "Insufficient balance");
        _transfer(msg.sender, _to, amt);
        emit TokensTransferred(msg.sender, _to, amt);
    }

    function redeemItem(uint _itemId, uint _price) public {
        require(_itemId >= Bracelets && _itemId <=  Rings, "Invalid item ID");
        require(balanceOf(msg.sender) >= _price, "Insufficient balance");

        if (_itemId == Bracelets) {
            playerItems[msg.sender].bracelets+= 1;
        } else if (_itemId == Chain) {
            playerItems[msg.sender].chain+= 1;
        } else if (_itemId ==Bangles ) {
            playerItems[msg.sender].bangles += 1;
        } else if (_itemId == Rings) {
            playerItems[msg.sender].rings += 1;
        }

        _burn(msg.sender, _price);
        emit ItemRedeemed(msg.sender, _itemId, _price);
    }

    function checkBalance() public view returns (uint) {
        return balanceOf(msg.sender);
    }
}
