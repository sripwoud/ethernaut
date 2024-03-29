// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
  mapping(address => uint256) balances;
  uint256 public totalSupply;

  constructor(uint256 _initialSupply) {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    // @dev: to simulate version <0.8.0 were arithmetic checks against over/underflow weren't yet built-in
    unchecked {
      require(balances[msg.sender] - _value >= 0);
      balances[msg.sender] -= _value;
    }
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }
}
