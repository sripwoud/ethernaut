const { setupLoader } = require('@openzeppelin/contract-loader')
const web3 = require('./web3.js')

const loader = setupLoader({ provider: web3 })
module.exports = loader
