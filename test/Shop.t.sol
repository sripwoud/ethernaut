pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/ShopFactory.sol';
import 'levels/Shop.sol';
import 'src/ShopHack.sol';
import 'utils/TestUtils.sol';

contract ShopTest is Test {
  address player;
  Utils utils;
  ShopFactory shopFactory;
  address payable shopAddress;
  Shop shop;
  ShopHack shopHack;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    shopFactory = new ShopFactory();
    shopAddress = payable(shopFactory.createInstance(player));
    shopHack = new ShopHack();
  }

  function testHack() public {
    shopHack.hack(shopAddress);
    assertTrue(shopFactory.validateInstance(shopAddress, player), 'Level not solved');
  }
}
