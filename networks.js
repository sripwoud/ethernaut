require('dotenv').config()
const HDWalletProvider = require('@truffle/hdwallet-provider')

const infuraProjectId = process.env.INFURA_PROJECT_ID
const mnemonic = process.env.MNEMONIC
const provider = new HDWalletProvider(
  mnemonic,
  `https://ropsten.infura.io/v3/${infuraProjectId}`,
  0,
  1
)
module.exports = {
  networks: {
    development: {
      protocol: 'http',
      host: 'localhost',
      port: 8545,
      gas: 5000000,
      gasPrice: 5e9,
      networkId: '*'
    },
    ropsten: {
      provider,
      networkId: 3
    }
  }
}
