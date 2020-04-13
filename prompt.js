const readline = require('readline-sync')

const instance = readline.question(
`What is the deployed level instance address?
(If necessary, first get a new instance at
https://solidity-05.ethernaut.openzeppelin.com/)
> `)

module.exports = instance
