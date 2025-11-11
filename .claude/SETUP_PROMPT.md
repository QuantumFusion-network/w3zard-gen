# My QFN Asset Manager - Setup

Generate a Polkadot dApp with the following features.

**Project:** My QFN Asset Manager
**Description:** Asset management dApp on QF Network testnet
**Chain:** QF Network testnet (wss://test.qfnetwork.xyz)

## Feature: Asset Management

Implement complete asset management functionality including:
- Create custom tokens with metadata
- Mint tokens to recipients
- Transfer tokens between accounts
- Destroy tokens safely
- View all tokens and balances in portfolio

The asset-management skill will handle this implementation following all CLAUDE.md conventions.

## Validation

After all features are generated:
1. Run required validation:
   - bash .claude/scripts/validate-typescript.sh (pnpm typecheck)
2. Verify all imports use polkadot-api (NEVER @polkadot/api)
3. Report completion with file counts

Follow CLAUDE.md conventions.
