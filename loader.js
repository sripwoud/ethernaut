const { setupLoader } = require('@openzeppelin/contract-loader')
const { networks: { ropsten: { provider } } } = require('./networks.js')

const loader = setupLoader({ provider, defaultSender: process.env.ACCOUNT })

module.exports = loader
