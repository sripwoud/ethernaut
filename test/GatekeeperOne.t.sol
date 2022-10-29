pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/GatekeeperOneFactory.sol';
import 'levels/GatekeeperOne.sol';
import 'src/GatekeeperOneHack.sol';
import 'utils/TestUtils.sol';

contract GatekeeperOneTest is Test {
  address player;
  Utils utils;
  GatekeeperOneFactory gatekeeperOneFactory;
  GatekeeperOne gatekeeperOne;
  address payable gatekeeperOneAddress;
  GatekeeperOneHack gatekeeperOneHack;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    gatekeeperOneFactory = new GatekeeperOneFactory();
    gatekeeperOneAddress = payable(gatekeeperOneFactory.createInstance(player));
    gatekeeperOne = GatekeeperOne(gatekeeperOneAddress);
    gatekeeperOneHack = new GatekeeperOneHack(gatekeeperOneAddress);
  }

  function testHack() public {
    /// @dev fake tx.origin == player
    vm.prank(player, player);
    gatekeeperOneHack.hack();

    assertTrue(
      gatekeeperOneFactory.validateInstance(gatekeeperOneAddress, player), 'Level not solved'
    );
  }
}
