const loader = require('../loader.js')

const victim = loader.web3.fromArtifact('Fallback', '0x185d5Dccb8004f547208AbeB3497b032A5324507')

const hack = async () => {
  console.log(victim._address)
}

hack()
