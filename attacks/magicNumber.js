const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load MagicNumber contract instance.')
    const victim = loader.web3.fromArtifact('MagicNum', instance)

    console.log('Load Solver Contract')
    const solver = loader.web3.fromArtifact('Solver')

    console.log('Deploy Solver contract')
    const gasLimit = await web3.eth.getBlock('latest').gasLimit
    const { options: { address } } = await solver.deploy().send({ gas: 8000000 })

    console.log('Execute setSolver(), passing Solver address as argument...')
    await victim.methods.setSolver(address).send()

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
