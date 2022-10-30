pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/MagicNumFactory.sol';
import 'levels/MagicNum.sol';
import 'utils/TestUtils.sol';
import 'forge-std/console.sol';

contract MagicNumTest is Test {
  address[] addresses;
  Utils utils;
  MagicNumFactory magicNumFactory;
  address payable magicNumAddress;
  MagicNum magicNum;

  function setUp() public {
    utils = new Utils();
    addresses = utils.createUsers(2);
    magicNumFactory = new MagicNumFactory();
    magicNumAddress = payable(magicNumFactory.createInstance(addresses[0]));
    magicNum = MagicNum(magicNumAddress);
  }

  function testHack() public {
    vm.etch(addresses[1], hex'602a60005260206000f3');
    magicNum.setSolver(addresses[1]);
    assertTrue(magicNumFactory.validateInstance(magicNumAddress, addresses[0]), 'Level not solved');
  }
}
