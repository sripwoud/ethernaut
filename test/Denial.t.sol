pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/DenialFactory.sol';
import 'levels/Denial.sol';
import 'src/DenialHack.sol';
import 'utils/TestUtils.sol';

contract DenialTest is Test {
  address player;
  Utils utils;
  DenialFactory denialFactory;
  address payable denialAddress;
  Denial denial;
  DenialHack denialHack;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    denialFactory = new DenialFactory();
    denialAddress = payable(denialFactory.createInstance{value: 1 ether}(player));
    denial = Denial(denialAddress);
    denialHack = new DenialHack();
  }

  function testHack() public {
    denial.setWithdrawPartner(address(denialHack));
    assertTrue(denialFactory.validateInstance(denialAddress, player), 'Level not solved');
  }
}
