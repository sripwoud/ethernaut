// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';

contract Reentrance {
  mapping(address => uint256) balances;

  function donate(address _to) external payable {
    balances[_to] = balances[_to] + msg.value;
  }

  function balanceOf(address _who) external view returns (uint256 balance) {
    return balances[_who];
  }

  function withdraw(uint256 _amount) public {
    if (balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value: _amount}('');
      if (result) {
        _amount;
      }

      unchecked {
        balances[msg.sender] -= _amount;
      }
    }
  }

  receive() external payable { }
}
