pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/ReentranceFactory.sol';
import 'levels/Reentrance.sol';
import 'src/ReentranceHack.sol';
import 'utils/TestUtils.sol';

contract ReentranceTest is Test {
  address player;
  Utils utils;
  ReentranceFactory reentranceFactory;
  address payable reentranceAddress;
  Reentrance reentrance;
  ReentranceHack reentranceHack;
  uint256 amount = 0.002 ether;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    reentranceFactory = new ReentranceFactory();
    reentranceAddress = payable(reentranceFactory.createInstance{value: amount}(player));
    reentrance = Reentrance(reentranceAddress);
    reentranceHack = new ReentranceHack(reentranceAddress);
  }

  function testHack() public {
    reentranceHack.donate{value: amount}();
    reentranceHack.withdraw();

    assertTrue(reentranceFactory.validateInstance(reentranceAddress, player), 'Level not solved');
  }
}
