pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/ForceFactory.sol';
import 'utils/TestUtils.sol';
import 'src/ForceHack.sol';

contract ForceTest is Test {
  address player;
  Utils utils;
  ForceFactory forceFactory;
  address payable forceAddress;
  ForceHack forceHack;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    forceFactory = new ForceFactory();
    forceAddress = payable(forceFactory.createInstance(player));
    forceHack = new ForceHack{value: 1 ether}(forceAddress);
  }

  function testHack() public {
    forceHack.hack();
    assertTrue(forceFactory.validateInstance(forceAddress, player), 'Level not solved');
  }
}
