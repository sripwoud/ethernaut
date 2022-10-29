pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/GatekeeperTwoFactory.sol';
import 'src/GatekeeperTwoHack.sol';
import 'utils/TestUtils.sol';

contract GatekeeperTwoTest is Test {
  address player;
  Utils utils;
  GatekeeperTwoFactory gatekeeperTwoFactory;
  address payable gatekeeperTwoAddress;
  GatekeeperTwoHack gatekeeperTwoHack;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    gatekeeperTwoFactory = new GatekeeperTwoFactory();
    gatekeeperTwoAddress = payable(gatekeeperTwoFactory.createInstance(player));
  }

  function testHack() public {
    /// @dev Fake tx.origin == player
    vm.prank(player, player);
    gatekeeperTwoHack = new GatekeeperTwoHack(gatekeeperTwoAddress);
    assertTrue(
      gatekeeperTwoFactory.validateInstance(gatekeeperTwoAddress, player), 'Level not solved'
    );
  }
}
