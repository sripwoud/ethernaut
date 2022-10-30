// SPDX-License-Identifier: Unlicensed
// https://github.com/PraneshASP/foundry-faucet/blob/main/src/test/utils/Utils.sol
pragma solidity ^0.5.0;

import 'ds-test/test.sol';

contract Utils05 is DSTest {
  bytes32 internal nextUser = keccak256(abi.encodePacked('user address'));

  function getNextUserAddress() external returns (address payable) {
    address payable user = address(uint160(uint256(nextUser)));
    nextUser = keccak256(abi.encodePacked(nextUser));
    return user;
  }

  // create users with 100 ETH balance each
  function createUsers(uint256 userNum) external returns (address payable[] memory) {
    address payable[] memory users = new address payable[](userNum);
    for (uint256 i = 0; i < userNum; i++) {
      address payable user = this.getNextUserAddress();
//      vm.deal(user, 100 ether);
      users[i] = user;
    }

    return users;
  }

  // move block.number forward by a given number of blocks
//  function mineBlocks(uint256 numBlocks) external {
//    uint256 targetBlock = block.number + numBlocks;
//    vm.roll(targetBlock);
//  }
}
