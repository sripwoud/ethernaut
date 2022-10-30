# The Ethernaut
*The Ethernaut is a Web3/Solidity based wargame inspired from [overthewire.org](https://overthewire.org/wargames/), played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be 'hacked'.*

Solutions progressively moved to [wiki](https://github.com/r1oga/ethernaut/wiki).

[Level 18: Magic Number](#MagicNumber)  
[Level 19: Denial](#Denial)  
[Level 20: Alien Codex](#AlienCodex)  
[Level 21: Shop](#Shop)  

## Requirements
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Getting started
1. Clone repository
   ```commandline
    git clone -b forge --single-branch git@github.com:r1oga/ethernaut.git
   ```
2. Run test LevelName:
   ```commandline
   forge test --mc LevelName
   ```

## <a name='MagicNumber'></a>Level 18 - MagicNumber
**Target**
> provide the Ethernaut with a "Solver", a [contract](./lib/levels/MagicNum.sol) that responds to "whatIsTheMeaningOfLife()" with the right number.

### Solidity Concepts
#### Contract creation bytecode
Smart contracts run on the Ethereum Virtual Machine (EVM). The EVM understands smart contracts as bytecode. Bytecode is a sequence of hexadecimal characters:
`0x6080604052348015600f57600080fd5b5069602a60005260206000f3600052600a6016f3fe`.
Developers on the other hand, write and read them using a more human readable format: solidity files.  
The solidity **compiler** digests `.sol` files to generate:
- contract creation bytecode: this is the smart contract format that the EVM understands
- assembly code: this is the bytecode as a sequence of **opcodes**. From a human point of view, it is less readable that Solidity code but more readable than bytecode.
- Application Binary Interface (ABI): this is like a customized interpret in a JSON format that tells applications (e.g a Dapp making function calls using web3.js) how to communicate with a specific deployed smart contract. It translates the application language (JavaScript) into bytecode that the  EVM can understand and execute.

Contract creation bytecode contain 2 different pieces of bytecode:
- **creation** code: only executed at deployment. It tells the EVM to run the constructor to initialize the contract and to store the remaining **runtime** bytecode.
- **runtime** code: this is what lives on the blockchain at what Dapps, users will interact with.

![contract creation workflow diagram](https://raw.githubusercontent.com/r1oga/ethernaut/master/img/contractCreationWorkflow.png)

#### EVM = [Stack Machine](https://en.wikipedia.org/wiki/Stack_machine)
As a stack machine, the EVM functions according to the **Last In First Out** principle: the last item entered in memory will be the first one to be consumed for the next operation.
So an operation such as ` 1 + 2 * 3` will be written `3 2 * 1 +` and will be executed by a stack machine as follows:

|Stack Level|Step 0|Step 1|Step 2|Step 3|Step 4|Step 5|Step 6|
|--|--|--|--|--|--|--|--|
|0|3|2| * |6|1|+|7|
|1||3|2||6|1
|2|||3|||6

In addition to its **stack** component, the EVM has **memory**, which is like RAM in the sense that it is cleared at the end of each message call, and **storage**, which corresponds to data persisted between message calls.
#### OPCODES
How do we control the EVM? How do we tell it what to execute?  
We have to give it a sequence of instructions in the form of OPCODES. An OPCODE can only push or consume items from the EVM’s stack, memory, or storage belonging to the contract.  
Each OPCODE takes one byte.  
Each OPCODE has a corresponding hexadecimal value: see the opcode values mapping [here](https://github.com/ethereum/py-evm/blob/master/eth/vm/opcode_values.py) (from pyevm) or in the [Ethereum Yellow Paper - appendix H](http://gavwood.com/paper.pdf).  
So "assembling" the OPCODES hexadecimal values together means reconstructing the bytecode.  
Splitting the bytecode into OPCODES bytes chunks means "disassembling" it.  

For a more detailed guide on how to deconstruct a solidity code, check this [post](https://blog.openzeppelin.com/deconstructing-a-solidity-contract-part-i-introduction-832efd2d7737/) by Alejandro Santander in collaboration with Leo Arias.
### Hack
1. Runtime code

	|# (bytes)|OPCODE|Stack (left to right = top to bottom)|Meaning|bytecode|
	|--|--|--|--|--|
	|00|PUSH1 2a||push  2a (hexadecimal) = 42 (decimal) to the stack|602a
	|02|PUSH1 00|2a|push 00 to the stack|6000|
	|05|MSTORE|00, 2a|`mstore(0, 2a)`, store 2a = 42 at memory position 0|52
	|06|PUSH1 20||push 20 (hexadecimal) = 32 (decimal) to the stack (for 32 bytes of data)|6020
	|08|PUSH1 00|20|push 00 to the stack|6000
	|10|RETURN|00, 20|`return(memory position, number of bytes)`, return 32 bytes stored in memory position 0|f3
  The assembly of these 10 bytes of OPCODES results in the following bytecode: `602a60005260206000f3`

2. Creation code
	We want to excute the following:
	- `mstore(0, 0x602a60005260206000f3)`: store the 10 bytes long bytecode in memory at position 0.  
	This will store `602a60005260206000f3` padded with 22 zeroes on the left to form a 32 bytes long bytestring.
	- `return(0x16, 0x0a)`: starting from byte 22, return the 10 bytes long runtime bytecode.

	|# (bytes)|OPCODE|Stack (left to right = top to bottom)|Meaning|bytecode|
	|--|--|--|--|--|
	|00|PUSH10 602a60005260206000f3||push the 10 bytes of runtime bytecode to the stack|69602a60005260206000f3|
	|03|PUSH 00|602a60005260206000f3|push 0 to the stack|6000
	|05|MSTORE|0, 602a60005260206000f3|`mstore(0, 0x602a60005260206000f3)`0|52
	|06|PUSH a||push a = 10 (decimal) to the stack|600a
	|08|PUSH 16|a|push 16 = 22 (decimal) to the stack|6016
	|10|RETURN|16, a|`return(0x16, 0x0a)`|f3

3. The complete contract creation bytecode is then `69602a60005260206000f3600052600a6016f3`
4. Deploy the contract with `web3.eth.sendTransaction({ data: '0x69602a60005260206000f3600052600a6016f3' })`, which returns a Promise. The deployed contract address is the value of the `contractAddress` property of the object returned when the Promise resolves.
5. Pass the address of the deployed solver contract to the `setSolver` function of the `MagicNumber` contract.


### Takeaways
Having an understanding of the EVM at a lower level, especially understanding how contracts are created and how bytecode can be dis/assembled from/to OPCODES is benefetial to smart contract developers in several ways:
- better debugging
- possibilities to finely optimize contract runtime or creation code

However both operations, assembling OPCODES into bytecode or disassembling bytecode into OPCODES, are cumbersome and tricky to manually  perform without mistakes.  So for efficiency and security reasons, developers are better off leaving it to compilers, writing solidity code and working with ABIs!
>The Ethernaut is a Web3/Solidity based wargame inspired from [overthewire.org](https://overthewire.org/wargames/), played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be 'hacked'.

## <a name='Denial'></a>Level 19 - Denial
**Target**
> This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.
If you can deny the owner from withdrawing funds when they call withdraw() (whilst the [contract](./lib/levels/Denial.sol) still has funds) you will win this level.

### Weakness
The `withdraw` function uses `call` to send ETH to an unknown address. This poses two threats:
1. Reentrancy (see [Level 10 - Reentrancy](#Reentrancy): the recipient can implement a malicious fallback that will call back ('reenter') the `withdraw` function
2. Out Of Gas (OOG) error: `call` forwards all gas. The recipient may consume it all to prevent the execution of the following instructions.
### Solidity Concepts: [error handling]()

|expression|syntax|effect|OPCODE||
|--|--|--|--|--|
|throw|`if (condition) { throw; }`|reverts all state changes and deplete gas|version<0.4.1: INVALID OPCODE  - 0xfe, after:  REVERT- 0xfd|deprecated in version 0.4.13 and removed in version 0.5.0
|assert|`assert(condition);`|reverts all state changes and depletes all gas|INVALID OPCODE - 0xfe
|revert|`if (condition) { revert(value) }`|reverts all state changes, allows returning a value, refunds remaining gas to caller|REVERT - 0xfd
|require|`require(condition, "comment")`|reverts all state changes, allows returning a value, refunds remaining gas to calle|REVERT - 0xfd

So the main difference is that `assert` depletes all gas while `revert` and `require` don't. `require` is a less verbose version of `revert`.
When to use which error handling method? According to the [solidity documentation](https://solidity.readthedocs.io/en/latest/control-structures.html#id4)
> The assert function should only be used to test for internal errors, and to check invariants. Properly functioning code should never reach a failing assert statement; if this happens there is a bug in your contract which you should fix.
> The require function should be used to ensure valid conditions that cannot be detected until execution time. This includes conditions on inputs or return values from calls to external contracts.

### Hack
We want to make the `owner.transfer(amountToSend);` instruction fail right after the `partner.call.value(amountToSend)("");` instruction. As `call` forwards all gas, we will cause an Out Of Gas error.
1. Deploy a malicious contract and set it as withdraw partner with `setWithdrawPartner`
2. Cause an Out Of Gas Error by implementing a malicious fallback (that receive the ETH sent by the `partner.call.value(amountToSend)("")` instruction)
	- Option 1: reenter in `denial.withdraw()`
	- Option 2: `assert` a false condition

### Takeaways
See [Level 10 - Reentrancy](#Reentrancy) takeaways.
## <a name='AlienCodex'></a>Level 20 - Alien Codex
**Target: claim ownership of the [contract](./lib/levels/AlienCodex.sol)**
### Weakness
`codex` is stored as a dynamic array. `retract()` reduces `codex` length without checking against underflow. So it is actually possible to set the `codex` array length to 2²⁵⁶ -1, which gives power to modify all storage slots.
### Solidity Concepts: [storage layout](https://solidity.readthedocs.io/en/v0.6.6/miscellaneous.html#mappings-and-dynamic-arrays) of dynamically sized variables
Each smart contract running on the Ethereum Virtual Machine maintains its own state using a key:value storage mapping. The number possible of keys is so **huge** that most keys actually contain empty values.  Each key is called a slot. They are  2²⁵⁶ - 1 slots. Each slot can contain 32 bytes of data.  
In the [Level 8 -Vault](#Vaultt), I listed the basic storage layout [rules](https://solidity.readthedocs.io/en/v0.6.2/miscellaneous.html#layout-of-state-variables-in-storage). Each statically sized variable gets a reserved slot which is defined at compilation time.  
But what about dynamically sized variables? As their size is not fixed beforehand, how to know which slots to reserve?  
With regular hard drive space or RAM an *allocation* step to find free space to use exists, which is followed by a *release* step to put that space back into the pool of available storage. The number of storage locations of a smart contract is so huge that it manages its storage differently. It just needs to figure a way to define a storage location to start from. Indeed the likelihood of having location clashes is (not rigorously) 0.
> Due to their unpredictable size, mapping and dynamically-sized array types use a Keccak-256 hash computation to find the starting position of the value or the array data. These starting positions are always full stack slots.
> For dynamic arrays, [the] slot stores the number of elements in the array (byte arrays and strings are an exception, see below). For mappings, the slot is unused (but it is needed so that two equal mappings after each other will use a different hash distribution). Array data is located at keccak256(p) and the value corresponding to a mapping key k is located at keccak256(k . p) where . is concatenation.

![storage of dynamic array](https://raw.githubusercontent.com/r1oga/ethernaut/master/img/dynamic.png)
![storage of mapping](https://raw.githubusercontent.com/r1oga/ethernaut/master/img/mapping.png)
## Hack
0. Analyze storage layout

  |Slot #|Variable|
  |--|--|
  |0|contact bool (1 bytes) & owner address (20 bytes), both fit on one slot|
  |1|codex.length|
  |keccak256(1)|codex[0]|
  |keccak256(1) + 1|codex[1]|
  |...||
  |2²⁵⁶ - 1|codex[2²⁵⁶ - 1 - uint(keccak256(1))]|
  |||
  |0|codex[2²⁵⁶ - 1 - uint(keccak256(1)) + 1] --> can write slot 0!|

1. call `make_contact` to be able to pass the `contacted` modifer
3. call `retract`: this provokes and underflow which leads to `code.length = 2^256 - 1`
4.  Compute codex `index` corresponding to slot 0: `2²⁵⁶ - 1 - uint(keccak256(1)) + 1 = 2²⁵⁶ - uint(keccak256(1))`
5.  Call `reverse` passing it `index` and your address left padded with 0 to total 32 bytes as `content`

## Takeaways
Modifying a dynamic array length without checking for over/underflow is very dangerous as it can expand the array's bounds to the entire storage area of 2^256 - 1. This can possibly enable modifying the whole contract storage.

## <a name='Shop'></a>Level 21 - Shop
**Target: get the item from the [shop](./lib/levels/Shop.sol) for less than the price asked.**
### Weakness
Like for the [Level 11 - Elevator](#Elevator), `Shop` never implements the `price()` function from the `Buyer` interface. An attacker can create a contract that implements its own version of this function.

### Solidity Concepts
- [Interfaces](https://solidity.readthedocs.io/en/v0.6.2/contracts.html#interfaces)
- [Inheritance](https://solidity.readthedocs.io/en/v0.6.2/contracts.html#inheritance)
- [External function call with `gas()` option](https://solidity.readthedocs.io/en/v0.5.15/control-structures.html#external-function-calls)
> When calling functions of other contracts, you can specify the amount of Wei or gas sent with the call with the special options .value() and .gas(), respectively.

- Gas cost to modify storage
![Ethereum Yellow Paper screenshot - Fee Schedule](https://raw.githubusercontent.com/r1oga/ethernaut/master/img/feeSchedule.png)

#### Hack
`buy()` is calling `price()` twice:
1. In the conditional check: the price returned must be higher than 100 to pass
2. To update the price: here is the opportunity to return a value lower than 100.

So we need to implement a malicious `price` function that:
- returns a value higher than 100 on its first call
- returns a value lower than 100 on its second call
- costs less than 3000 gas to execute. So we can't write in storate. We will read `isSold` instead to perform a conditinal check: `isSold() ? 1: 101`

### Security Takeaways
- Don't let interface function unimplemented.
- It is unsafe to approve some action by double calling even the same view function.

## Credit
[Nicole Zhu](https://medium.com/@nicolezhu).  
I couldn't solve a couple of levels myself so I cheated a bit 😅  (especially for the [Vault](#Vault) and [Gatekeeper One](#GatekeeperOne) levels).
Her walkthroughs are great teaching material on Solidity.
I also reused some of the diagram images from her posts.

[Deconstructing a Solidity Contract —Part I: Introduction](https://blog.openzeppelin.com/deconstructing-a-solidity-contract-part-i-introduction-832efd2d7737/) by Alejandro Santander from OpenZeppelin in collaboration with Leo Arias.