# [The Ethernaut](https://ethernaut.openzeppelin.com/)
> The Ethernaut is a Web3/Solidity based wargame inspired from [overthewire.org](https://overthewire.org/wargames/), played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be 'hacked'.

## Getting Started
1. Install [foundry](https://book.getfoundry.sh/getting-started/installation)
2. Clone repository
   ```commandline
    git clone -b forge --single-branch git@github.com:r1oga/ethernaut.git
   ```
3. Run tests
   - all
     ```commandline
     forge test --silent
     ```
   - specific `LevelName`:
     ```commandline
     forge test --mc LevelName --silent
     ```

## Solutions
See [wiki](https://github.com/r1oga/ethernaut/wiki).

## Credits
[Nicole Zhu](https://medium.com/@nicolezhu).  
I couldn't solve a couple of levels myself   , so I cheated a bit 😅  (especially for the [Vault](https://github.com/r1oga/ethernaut/wiki/08.-Vault) and [Gatekeeper One](https://github.com/r1oga/ethernaut/wiki/13.-GatekeeperOne) levels).
Her walkthroughs are great teaching material on Solidity.
I also reused some diagram images from her posts.

[Deconstructing a Solidity Contract —Part I: Introduction](https://blog.openzeppelin.com/deconstructing-a-solidity-contract-part-i-introduction-832efd2d7737/) by Alejandro Santander from OpenZeppelin in collaboration with Leo Arias.