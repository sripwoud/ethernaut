// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallout {
  mapping(address => uint256) allocations;
  address payable public owner;

  /// @dev Before 0.4.22,constructors were defined as functions with the same name as the contract. This syntax is deprecated since 0.5.0.
  function Fal1out() public payable {
    owner = payable(msg.sender);
    allocations[owner] = msg.value;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, 'caller is not the owner');
    _;
  }

  function allocate() public payable {
    allocations[msg.sender] = allocations[msg.sender] + msg.value;
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  function allocatorBalance(address allocator) public view returns (uint256) {
    return allocations[allocator];
  }
}
