const loader = require('../loader.js')
const web3 = require('../web3.js')
const instance = require('../prompt.js');

(async () => {
  try {
    console.log('Load MagicNumber contract instance.')
    const victim = loader.web3.fromArtifact('MagicNum', instance)

    console.log('Deploy Solver contract with raw EVM bytecode...')
    const bytecode = '0x69602a60005260206000f3600052600a6016f3'
    // see https://github.com/r1oga/ethernaut#hack-17 for explainations about where bytecode comes from
    const { contractAddress } = await web3.eth.sendTransaction({ data: bytecode })

    console.log(`Deployed Solver contract address is ${contractAddress}`)

    console.log('Execute setSolver(), passing Solver address as argument...')
    await victim.methods.setSolver(contractAddress).send()

    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
