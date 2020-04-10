const readline = require('readline-sync')

const instance = readline.question(
`What is the deployed instance address?
(If necessary, first get a new instance at
https://solidity-05.ethernaut.openzeppelin.com/level/0xD95B091f19946d6ef0c88f8CD360c0d6E408876E)
> `)

module.exports = instance
