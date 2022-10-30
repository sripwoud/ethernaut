// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import '0.5/Level05.sol';
import './AlienCodex.sol';

contract AlienCodexFactory is Level05 {
  function createInstance(address _player) public payable returns (address) {
    _player;
    return address(new AlienCodex());
  }

  function validateInstance(address payable _instance, address _player) public returns (bool) {
    // _player;
    AlienCodex instance = AlienCodex(_instance);
    return instance.owner() == _player;
  }
}
