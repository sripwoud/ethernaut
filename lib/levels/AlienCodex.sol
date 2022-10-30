// SPDX-License-Identifier: MIT
/// @dev breaking change in 0.6.0: length of arrays is always read-only, even for storage arrays. It is no longer possible to resize storage arrays assigning a new value to their length. So need to use 0.5.0 for this level
pragma solidity ^0.5.0;

import '0.5/Ownable05.sol';

contract AlienCodex is Ownable05 {
  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }

  function make_contact() public {
    contact = true;
  }

  function record(bytes32 _content) public contacted {
    codex.push(_content);
  }

  function retract() public contacted {
    /// @dev This wouldn't compile in >=0.6.0
    codex.length--;
  }

  function revise(uint256 i, bytes32 _content) public contacted {
    codex[i] = _content;
  }
}
