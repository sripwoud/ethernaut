// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Level.sol';
import './Vault.sol';

contract VaultFactory is Level {
  function createInstance(address _player) public payable override returns (address) {
    _player;
    bytes32 password = 'Everything is a polynomial';
    Vault instance = new Vault(password);
    return address(instance);
  }

  function validateInstance(address payable _instance, address) public view override returns (bool) {
    Vault instance = Vault(_instance);
    return !instance.locked();
  }
}
