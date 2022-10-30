// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

import './Ownable05.sol';

contract Level05 is Ownable05 {
  function createInstance(address _player) public payable returns (address);
  function validateInstance(address payable _instance, address _player) public returns (bool);
}