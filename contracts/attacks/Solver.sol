pragma solidity ^0.5;

contract Solver {
  constructor() public {
    assembly {
      mstore(0, 0x602a60005260206000f3) // store bytecode, will pad with zeroes
      return(0x16, 0x0a) // starting from byte 22, return 10 bytes.
    }
  }
}

/*

00 PUSH1 2a: push 2a (hex) = 42 (decimal) to the stack -> 6042
03 PUSH1 00: push 0 to the stack -> 6000
05 MSTORE: mstore()store 42 in memory at position 0 -> 52
06 PUSH1 20: push 32 to the stack -> 6020
08 PUSH1 00: push 0 to the stack -> 6000
10: RETURN: return 32 bytes of the memory in position 0 -> f3

STACK
00

03 2a

05 00
2a

06 consume STACK

08 20

10 00
20

bytecode
602a60005260206000f3 of 10 (0x0a) bytes to pad with 22 (0x16) zeroes (for a 32 bytes length)

*/
