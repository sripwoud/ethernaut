# The Ethernaut
*The Ethernaut is a Web3/Solidity based wargame inspired from [overthewire.org](https://overthewire.org/wargames/), played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be 'hacked'.*

Solutions progressively moved to [wiki](https://github.com/r1oga/ethernaut/wiki).

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