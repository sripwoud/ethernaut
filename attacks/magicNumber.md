The Contract should only return the value 0x42 = 66:

|#|OPCODE|Stack (top to bottom)|Meaning|bytecode|
|--|--|--|--|--|
|00|PUSH1 42||push  42 (hexadecimal) = 66 (decimal) to the stack|6042
|02|PUSH1 00|2a|push 00 to the stack|6000|
|05|MSTORE|00, 2a|`mstore(0, 2a)`, store 2a = 42 at memory position 0|52
|06|PUSH1 20||push 20 (hexadecimal) = 32 (decimal) to the stack (for 32 bytes of data)|6020
|08|PUSH1 00|20|push 00 to the stack|6000
|10|RETURN|00, 20|`return(memory position, number of bytes)`, return 32 bytes stored in memory position 0|f3

Concatenated this gives the following bytecode: `602a60005260206000f3`  
It is 10 (0x0a) bytes long. Using assembly code in Solidity we will the use:
- `mstore(0, 0x602a60005260206000f3)`: store the bytecode in memory at position 0.  
This will store `602a60005260206000f3` padded with 22 (0x16) `0` on the left to form a 32 bytes long bytecode.
- `return(0x16, 0x0a)`: starting from byte 22, return 10 bytes.
