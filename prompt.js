const readline = require('readline-sync')

const instance = readline.question(
`What is the deployed (attack) instance address?
(If necessary, first get a new instance at
https://solidity-05.ethernaut.openzeppelin.com/)
> `)

module.exports = instance
