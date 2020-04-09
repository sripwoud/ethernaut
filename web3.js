const Web3 = require('web3')
const { networks: { ropsten: { provider } } } = require('./networks.js')

// use truffle hd wallet as provider
const web3 = new Web3(provider)
web3.eth.defaultAccount = process.env.ACCOUNT

module.exports = web3
