const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BEP20Token", function () {
  async function deploy() {
    const [deployer, creator, other] = await ethers.getSigners();
    const token = await ethers.deployContract("BEP20Token", [
      "Test Token", "TST", 18, 1000000n, creator.address, creator.address,
    ]);
    return { token, deployer, creator, other };
  }

  it("mints the whole supply to the creator", async function () {
    const { token, creator } = await deploy();
    const total = 1000000n * 10n ** 18n;
    expect(await token.totalSupply()).to.equal(total);
    expect(await token.balanceOf(creator.address)).to.equal(total);
  });

  it("sets name, symbol, decimals and owner", async function () {
    const { token, creator } = await deploy();
    expect(await token.name()).to.equal("Test Token");
    expect(await token.symbol()).to.equal("TST");
    expect(await token.decimals()).to.equal(18);
    expect(await token.owner()).to.equal(creator.address);
  });

  it("transfers and uses allowances", async function () {
    const { token, creator, other } = await deploy();
    await token.connect(creator).transfer(other.address, 100n);
    expect(await token.balanceOf(other.address)).to.equal(100n);
    await token.connect(other).approve(creator.address, 40n);
    await token.connect(creator).transferFrom(other.address, creator.address, 40n);
    expect(await token.balanceOf(other.address)).to.equal(60n);
  });

  it("lets only the owner renounce", async function () {
    const { token, creator, other } = await deploy();
    await expect(token.connect(other).renounceOwnership()).to.be.revertedWith("Not the owner");
    await token.connect(creator).renounceOwnership();
    expect(await token.owner()).to.equal(ethers.ZeroAddress);
  });
});
