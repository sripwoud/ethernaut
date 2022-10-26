pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/TelephoneFactory.sol';
import 'levels/Telephone.sol';
import 'src/TelephoneHack.sol';
import 'utils/TestUtils.sol';

contract TelephoneTest is Test {
  address player;
  Utils utils;
  TelephoneFactory telephoneFactory;
  address payable telephoneAddress;
  TelephoneHack telephoneHack;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    telephoneFactory = new TelephoneFactory();
    telephoneAddress = payable(telephoneFactory.createInstance(player));
    telephoneHack = new TelephoneHack(telephoneAddress);
  }

  function testHack() public {
    vm.prank(player);
    telephoneHack.hack();
    assertTrue(telephoneFactory.validateInstance(telephoneAddress, player), 'Level not solved');
  }
}
