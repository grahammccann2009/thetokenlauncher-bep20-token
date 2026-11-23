const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const name = process.env.TOKEN_NAME || "Example Token";
  const symbol = process.env.TOKEN_SYMBOL || "EXT";
  const decimals = Number(process.env.TOKEN_DECIMALS || 18);
  const supply = BigInt(process.env.TOKEN_SUPPLY || "1000000000");
  const recipient = process.env.TOKEN_RECIPIENT || deployer.address;

  console.log(`Deploying ${name} (${symbol}) on chain ${hre.network.config.chainId}`);

  const token = await hre.ethers.deployContract("BEP20Token", [
    name,
    symbol,
    decimals,
    supply,
    recipient, // owner
    recipient, // full supply goes here
  ]);
  await token.waitForDeployment();

  console.log("Token address:", await token.getAddress());
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
