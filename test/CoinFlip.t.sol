pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/CoinFlipFactory.sol';
import 'levels/CoinFlip.sol';
import 'src/CoinFlipHack.sol';
import 'utils/TestUtils.sol';

contract CoinFlipTest is Test {
  address player;
  Utils utils;
  CoinFlipFactory coinFlipFactory;
  address payable coinFlipAddress;
  CoinFlipHack coinFlipHack;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    coinFlipFactory = new CoinFlipFactory();
    coinFlipAddress = payable(coinFlipFactory.createInstance(player));
    coinFlipHack = new CoinFlipHack(coinFlipAddress);
  }

  function testHack() public {
    for (uint256 i = 0; i < 1; i++) {
      utils.mineBlocks(1);
      vm.prank(player);
      coinFlipHack.hack();
    }

    coinFlipFactory.validateInstance(coinFlipAddress, player);
  }
}
