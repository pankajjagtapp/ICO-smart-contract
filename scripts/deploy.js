async function main() {
    const [deployer] = await ethers.getSigners();
  
    const TokenInstance = await ethers.getContractFactory('ICO');
    const Token = await TokenInstance.deploy();
    console.log('Deployed! Here is your address: ', Token.address);

  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });