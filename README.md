# The Ethernaut
*The Ethernaut is a Web3/Solidity based wargame inspired from [overthewire.org](https://overthewire.org/wargames/), played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be 'hacked'.*

[Level 1: Fallback](#Fallback)  
[Level 2: Fallout](#Fallout)  
[Level 3: Coin Flip](#CoinFlip)  
[Level 4: Telephone](#Telephone)  
[Level 5: Token](#Token)  
[Level 6: Delegation](#Delegation)  
[Level 7: Force](#Force)  
[Level 8: Vault](#Vault)  
[Level 9: King](#King)  
[Level 10: Reentrancy](#Reentrancy)  

## <a name='Fallback'></a>Level 1 - Fallback
**Target: claim ownership of the [contract](./contracts/levels/Fallback.sol) & reduce its balance to 0.**
### Weakness
The contract's fallback function can owneship of the contract. The conditional requirements are not secure: any contributor can become owner after sending any value to the contract.
### Solidity concept: [fallback function](https://solidity.readthedocs.io/en/v0.6.2/contracts.html#fallback-function)
*A contract can have at most one fallback function, declared using fallback () external [payable] (without the function keyword). This function cannot have arguments, cannot return anything and must have external visibility. It is executed on a call to the contract if none of the other functions match the given function signature, or if no data was supplied at all and there is no receive Ether function. The fallback function always receives data, but in order to also receive Ether it must be marked payable.
Like any function, the fallback function can execute complex operations as long as there is enough gas passed on to it.*
### Hack
1. Contribute
2. Send any amount to the contract, which will trigger the fallback.
3. Conditional requirements will be met
4. Sender becomes the owner

### Takeaways
- Be careful when implementing a fallback that changes state as it can be triggered by anyone sending ETH to the contract.
- Avoid writing a fallback that can perform critical actions such as changing ownership or transfer funds.
- A common pattern is to let the fallback only emit events (e.g emit FundsReceived).

## <a name='Fallout'></a>Level 2 - Fallout
**Target: claim ownership of the [contract](./contracts/levels/Fallout.sol).**
### Weakness
The contract used a syntax deprecated since v 0.5. The function meant to be the constructor isn't one. It can actually be called after contract initialisation. It has a public visibility and can be called by anyone.
### Solidity Concept: [constructor](https://solidity.readthedocs.io/en/v0.6.2/contracts.html#constructors)
*A constructor is an optional function declared with the constructor keyword which is executed upon contract creation, and where you can run contract initialisation code.
Before the constructor code is executed, state variables are initialised to their specified value if you initialise them inline, or zero if you do not.*
**Prior to version 0.4.22, constructors were defined as functions with the same name as the contract. This syntax was deprecated and is not allowed anymore in version 0.5.0.**

The `Fal1out()` function was supposed to be named `Fallout()` and would have been the contract's constructor as syntax previous version 0.5.
### Hack
Simply call the `Fal1out() function`.
### Takeaways
- Work with the latest compiler versions which are more secure.
- Listen to the compiler warnings.
- Do test driven development to detect typos.

## <a name='CoinFlip'></a> Level 3 - Coin Flip
**Target: [guess](./contracts/levels/CoinFlip.sol) the correct outcome 10 times in a row.**
### Weakness
The contract tries to create randomness by relying on blockhashes, block number and a given `FACTOR`. This data isn't secret:
- `blockhash()` and `block.number` are global variables in solidity
- the `FACTOR` used to compute the `coinFlip` value can be reused by the attacker

### Solidity Concepts
`blockhash(uint blockNumber) returns (bytes32)`:  hash of the given block - only works for 256 most recent blocks
`block.number (uint)`: current block number
### Hack
Deploy an [attacker contract](https://github.com/r1oga/ethernaut/blob/master/contracts/attacks/HackCoinFlip.sol):
The attacker contract compute itself the `blockValue` by using the `block.number` and `blockhash()` global variables.
As `FACTOR` is known, the attacker contract can next compute`coinFlip` and `side`.
We pass the right `side` argument to the original flip function that we call from the attacker contract.
### Takeaways
There’s no true randomness on Ethereum blockchain, only "pseudo-randomness": random generators that are considered “good enough”.
There currently isn't a native way to generate them.
Everything used in smart contracts is publicly visible, including the local variables and state variables marked as private.
Miners also have control over things like blockhashes, timestamps, and whether to include certain transactions - which allows them to bias these values in their favor.
## <a name='Telephone'></a>Level 4 - Telephone
**Target: claim ownership of the [contract](./contracts/levels/Telephone.sol).**
### Weakness
A conditional requirements uses `tx.origin`
### Solidity Concepts: [tx.origin vs msg.sender](https://solidity.readthedocs.io/en/v0.6.2/security-considerations.html#tx-origin)
- `tx.origin (address payable)`:  sender of the transaction (full call chain)
- `msg.sender (address payable)`: sender of the message (current call)

In the situation where a user call a function in contract 1, that will call function of contract 2:

||at execution contract 1|at execution in contract 2|
|--|--|--|
|msg.sender|userAddress|contract1Address
|tx.origin|userAddress|userAddress|userAddress

### Hack
Deploy an attacker contract.
Call the `changeOwner` function of the original contract from the attacker contract to ensure `tx.origin != msg.sender` and pass the conditional requirement.
### Takeaways
[Don't use `tx.origin`](https://solidity.readthedocs.io/en/v0.6.2/security-considerations.html#tx-origin)
## <a name='Fallback'></a>Level 5 - Token
**Target: You are given 20 tokens to start with and you will beat the [level](./contracts/levels/Token.sol)
if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.**
### Weakness
An sum operation is performed but overflow isn't checked for.
### Solidity Concepts: bits storage, [underflow/overflow](https://solidity.readthedocs.io/en/v0.6.2/security-considerations.html#two-s-complement-underflows-overflows)
Ethereum’s smart contract storage slot are each 256 bits, or 32 bytes. Solidity supports both signed integers, and unsigned integers uint of up to 256 bits.
However *as in many programming languages, Solidity’s integer types are not actually integers. They resemble integers when the values are small, but behave differently if the numbers are larger. For example, the following is true: uint8(255) + uint8(1) == 0. This situation is called an overflow. It occurs when an operation is performed that requires a fixed size variable to store a number (or piece of data) that is outside the range of the variable’s data type. An underflow is the converse situation: uint8(0) - uint8(1) == 255.*
![over/underflow image](https://miro.medium.com/max/1400/1*xAYyHOxwWcMUU5ycSbCp8Q.jpeg)

### Hack
Provoke the overflow by transferring 21 tokens to the contract.
### Takeaway
Check for over/underflow manually:
```
if(a + c > a) {
  a = a + c;
}
```
Or use [OpenZeppelin's math library](https://docs.openzeppelin.com/contracts/2.x/api/math) that automatically checks for overflows in all the mathematical operators.


## <a name='Delegation'></a>Level 6 - Delegation
**Target: claim ownership of the [contract](./contracts/level/Delgation.sol).**
### Weakness
The `Delegation` fallback implements a `delegatecall`.
By sending the right `msg.data` we can trigger the function `pwn()` of the Delegate contract.
Since this function is executed by a `delegatecall` the context will be preserved:
`owner = msg.sender = address of contract that send data to the Delegation fallback (attacker contract)`
### Solidity Concepts: storage, call another contract's function
There are several ways to interact with other contracts from within a given contract.
#### If ABI available
If the [ABI](https://solidity.readthedocs.io/en/develop/abi-spec.html)
(like an API for smart contract) and the contract's address are known,
we can simply instantiate (e.g with a contract interface) the contract and call its functions).
```
contract Called {
	 function fun() public returns (bool);
}

contract Caller {
	 Called public called;
	 constructor (Called addr) public {
		 called = addr;
	}

	function call () {
	  called.fun();
	}
}
```
#### ABI not available: `delegatecall` or `call`
*Calling* a function means injecting a specific context (*arguments*) to a
group of commands (*function*) and commands are executing one by one with this context.
##### Bytecode
In Ethereum, a function call can be expressed by a 2 parts bytecode as long as 4 + 32 * N bytes.
- Function Selector: first 4 bytes of function call’s bytecode.
Generated by hashing target function’s name plus with the type of its arguments
excluding empty space. Ethereum uses keccak-256 hashing function to create function selector:
`functionSelectorHash = web3.utils.keccak256('func()')`
- Function Argument: convert each value of arguments into a hex string padded to 32bytes.

If there is more than one argument, they are concatenated.
In Solidity encoding the function selector together with the arguments can be done with `abi.encode`, `abi.encodePacked`, `abi.encodeWithSelector` and abi.encodeWithSignature:
`abi.encodeWithSignature("add(uint256,uint256)", valueForArg1, valueForArg2)`
##### Call: doesn't preserve context.
Can be used to invoke public functions by sending `data` in a transaction.
`contractInstance.call(bytes4(keccak256("functionName(inputType)"))`

![call diagram](https://miro.medium.com/max/1400/1*PwYIsFyDM60IW4KuDkUncA.png)
##### [DelegateCall](https://solidity.readthedocs.io/en/v0.6.2/introduction-to-smart-contracts.html#delegatecall-callcode-and-libraries): preserves context
`contractInstance.delegatecall(bytes4(keccak256("functionName(inputType)"))`  
Delegate calls preserve current calling contract's context (storage, msg.sender, msg.value).
The calling contract using delegate calls allows the called contract to mutate its state.

![delegatecall diagram](https://miro.medium.com/max/1400/1*4OB3IwTF1AkW6zH3tJv8Tw.png)

![delegatecall mtating state diagram 2](https://miro.medium.com/max/2000/1*907YyYjEuAZCeLT9XiOA7A.png)  
### Hack
1. Compute the encoded hash that will be used for `msg.data`
2. Send `msg.data` in a transaction to the contract fallback

### Takeaways
- Use the higher level call() function to inherit from libraries, especially when you don’t need to change contract storage and do not care about gas control.
- When inheriting from a library intending to alter your contract’s storage, make sure to line up your storage slots with the library’s storage slots to avoid unexpected state changes..
- Authenticate and do conditional checks on functions that invoke delegatecalls.

## <a name='Force'></a>Level 7 - Force
**Target: make the balance of the [contract](./contracts/levels/Force.sol) greater than zero.**
### Solidity Concept: [selfdestruct](https://solidity.readthedocs.io/en/v0.6.2/units-and-global-variables.html#contract-related)
3 methods exist to receive Ethers:
1.  Message calls and payable functions
	- `addr.call{value: x}('')`: returns success condition and return data, forwards all available gas, adjustable
	- `<address payable>.transfer(uint256 amount)`: reverts on failure, forwards 2300 gas stipend, not adjustable
	- `<address payable>.send(uint256 amount) returns (bool)`: returns false on failure, forwards 2300 gas stipend, not adjustable
```
function receive() payable external {}
```
2. contract designated as recipient for mining rewards
3. `selfdestruct(address payable recipient)`: destroy the current contract, sending its funds to the given Address and end execution.

### Hack
As the contract to hack has no payable function to receive ether, we send ether to it by selfdestructing another contract, designating the victim contract as the recipient.
### Takeaways
By selfdestructing a contract, it is possible to send ether to another contract even if it doesn't have any payable functions.
This is dangerous as it can result in losing ether: sending ETH to a contract without withdraw function, or to a removed contract.

## <a name='Vault'></a>Level 8 - Vault
**Target: Unlock Vault [contract](./contracts/levels/Vault.sol).**
### Weakness
The `unlock` function relies on a password with a `private` visibility.
There is no real privacy on Ethereum which is public blockchain.
The `private` visibility parameter is misleading as all data can still be read.
Indeed the contract is available, so an attacker can know in which storage slot a variable is stored in and access its value manually using `getStorageAt`.
### Solidity Concepts: storage
#### [Storage: storage vs memory](https://solidity.readthedocs.io/en/v0.6.2/introduction-to-smart-contracts.html#storage-memory-and-the-stack)
- storage: persistent data between function calls and transactions.
	- Key-value store that maps 256-bit words to 256-bit words.
	- Not possible to enumerate storage from within a contract
	- Costly to read, and even more to initialise and modify storage. Because of this cost, you should minimize what you store in persistent storage to what the contract needs to run. Store data like derived calculations, caching, and aggregates outside of the contract.
	- A contract can neither read nor write to any storage apart from its own.
- memory ~ RAM: not persistent.  A contract obtains a freshly cleared instance of memory for each message call

#### [Layout](https://solidity.readthedocs.io/en/v0.6.2/miscellaneous.html#layout-of-state-variables-in-storage)
Data stored is storage in laid out in slots according to these rules:
- Each slot allows 32 bytes = 256 bits
- Slots start at index 0
- Variables are indexed in the order they’re defined in contract
```
contract Sample {
    uint256 first;  // slot 0
    uint256 second; // slot 1
}
```
- Bytes are being used starting from the right of the slot
- If a variable takes under < 256 bits to represent, leftover space will be shared with following variables if they fit in this same slot.
- If a variable does not fit the remaining part of a storage slot, it is moved to the next storage slot.
- Structs and arrays (non elementary types) always start a new slot and occupy whole slots (but items inside a struct or array are packed tightly according to these rules).
- Constants don’t use this type of storage. (They don't occupy storage slots)

![Storage layout image](https://miro.medium.com/max/2000/1*wY8Si-mt_QZWqg0jnEDw8A.jpeg)

#### Read storage: [web3.eth.getStorageAt](https://web3js.readthedocs.io/en/v1.2.6/web3-eth.html#getstorageat)
Knowing a contract's address and the storage slot position a variable is stored in, it is possible to read its value value using the `getStorageAt` function of web3.js.
## Hack
1. Read contract to find out in slot `password` is stored in:
	- `locked` bool takes 1 bit of the first slot index 0
	- `password` is 32 bytes long. It can fit on the first slot so it goes on next slot at index 1
2. Read storage at index 1
3. Pass this value to the unlock function

## Takeaways
- [Nothing is private in the EVM]()https://solidity.readthedocs.io/en/v0.6.2/security-considerations.html#private-information-and-randomness: addresses, timestamps, state changes and storage are publicly [visible](https://etherscan.io/).
- Even if a contract set a storage variable as `private`, it is possible to read its value with `getStorageAt`
- When necessary to store sensitive value onchain, hash it first (e.g with sha256)

## <a name='King'></a>Level 9 - King
**Target: Prevent losing kingship when submitting your [contract](./contracts/levels/King.sol) instance.**
### Weakness
The contract uses `transfer` instead of a withdraw pattern to send Ether.
### Solidity Concepts: [sending and receiving Eth](https://solidity.readthedocs.io/en/v0.6.2/security-considerations.html#sending-and-receiving-ether)
- Neither contracts nor “external accounts” are currently able to prevent that someone sends them Ether. Contracts can react on and reject a regular transfer
- If a contract receives Ether (without a function being called), either the receive Ether or the fallback function is executed. **If it does not have a receive nor a fallback function, the Ether will be rejected (by throwing an exception).**

### Hack
Upon submission, the level contract sends an Ether amount higher than `prize` to the contract instance contract fallback to reclaim kingship. The fallback uses `transfer` to send the prize value to the current king which about to be replace. Only then the king address is updated. If the current king is a contract without a fallback or receive function execution will fail before the king address can be updated.
1. Deploy a malicious contract without neither a payable fallback nor a payable receive function
2. Let this malicious contract become king by sending Ether to the vKing contract
3. Submit instance

### Takeaways
- Assume any externall account or contract you don't know/own is potentially malicious
- Never assume transactions to external contracts will be successful
- Handle failed transactions on the client side in the event you do depend on transaction success to execute other core logic.

Especially when transferring ETH:
- Avoid using `send()` or `transfer()`. If using `send()` check returned value
- Prefer a ['withdraw' pattern](https://solidity.readthedocs.io/en/v0.6.2/common-patterns.html#withdrawal-from-contracts) to send ETH

## <a name='Reetrancy'></a>Level 10 - Re-entrancy
### Contract
```

```

### Weakness
### Solidity Concepts
### Hack
### Takeaways

## Credit
[Nicole Zhu](https://medium.com/@nicolezhu).  
I couldn't solve a couple of levels myself and I had to cheat 😅.
Her walkthroughs are great teaching materials on Solidity.
I also reused some of the diagram images from her posts.
