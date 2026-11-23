# TheTokenLauncher BEP-20 Token Contract

The fixed-supply token contract that [TheTokenLauncher](https://www.thetokenlauncher.com/bnb-token-creator/) deploys on BNB Smart Chain. The same source is used for tokens created on Base.

## Project overview

| | |
|---|---|
| Project | TheTokenLauncher |
| Website | https://www.thetokenlauncher.com/ |
| BNB Chain creator | https://www.thetokenlauncher.com/bnb-token-creator/ |
| Base creator | https://www.thetokenlauncher.com/base-token-creator/ |
| Category | Tools (no-code token creator) |
| Networks | BNB Smart Chain mainnet (chain ID 56), Base mainnet (chain ID 8453) |
| Own token | None |
| Contact | contact@thetokenlauncher.com |

TheTokenLauncher lets anyone create a BEP-20 token without writing code. The creator enters a name, symbol, decimals and total supply, then pays the service fee from their own wallet (MetaMask, Trust Wallet or any BNB Chain wallet). Once the payment confirms, TheTokenLauncher deploys this contract and the whole supply is minted straight to the creator's wallet. Ownership goes to the creator, or is renounced to the zero address if they ask for that.

## What the contract does

- Standard BEP-20 / ERC-20 interface: `name`, `symbol`, `decimals`, `totalSupply`, `balanceOf`, `transfer`, `approve`, `allowance`, `transferFrom`
- Fixed supply. The full supply is minted once in the constructor to the creator's address. There is no mint function, so no more tokens can ever be created.
- No tax, fee, blacklist, pause or max-wallet logic
- Simple ownership with `transferOwnership` and `renounceOwnership`. The owner has no power over balances or transfers.

### Constructor

```solidity
constructor(
    string memory _name,
    string memory _symbol,
    uint8 decimals_,
    uint256 initialSupply,      // whole tokens, scaled by 10 ** decimals_
    address _owner,             // admin role (creator, or the deployer when renouncing)
    address _supplyRecipient    // creator wallet, receives the full supply
)
```

## Build and test

```bash
npm install
npx hardhat compile
npx hardhat test
```

Compiler: solc 0.8.26, optimizer enabled with 200 runs. These are the settings used in production.

## Deploy your own copy

Copy `.env.example` to `.env`, add a funded private key, then run:

```bash
npx hardhat run scripts/deploy.js --network bscTestnet
npx hardhat run scripts/deploy.js --network bsc
```

Set the token details with the `TOKEN_NAME`, `TOKEN_SYMBOL`, `TOKEN_DECIMALS`, `TOKEN_SUPPLY` and `TOKEN_RECIPIENT` variables in `.env`.

## Repository layout

```
contracts/BEP20Token.sol   the deployed token contract
scripts/deploy.js          deploy script for BNB Smart Chain and Base
test/BEP20Token.test.js    unit tests
hardhat.config.js          networks and compiler settings
```

## Links

- Website: https://www.thetokenlauncher.com/
- PancakeSwap liquidity guide: https://www.thetokenlauncher.com/how-to-add-liquidity-on-pancakeswap/
- BEP-20 launch checklist: https://grahammccann2009.github.io/bnb-token-launch-checklist/

## License

MIT
