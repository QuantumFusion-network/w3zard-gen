---
name: asset-management
description: Implements complete asset management feature for Polkadot dApps (create, mint, transfer, destroy tokens). Use when user needs token/asset management functionality or mentions creating custom tokens, minting, transfers, or portfolio views.
---

# Asset Management Feature Implementation

Implements the asset management feature for a Polkadot dApp using polkadot-api.

## Overview

This skill generates ~2,200 lines of production-ready code across 21 files:
- 19 new files (lib, hooks, components)
- 2 modified files (component exports, routing)
- Complete asset lifecycle: create → mint → transfer → destroy
- Real-time fee estimation, transaction tracking, error handling

## Template Infrastructure (Already Available)

Your template provides:
- ✅ WalletContext - Wallet connection and account selection
- ✅ ConnectionContext - polkadot-api client and connection management
- ✅ TransactionContext - Transaction lifecycle tracking
- ✅ TanStack Query - Server state management (30s stale, 5min GC)
- ✅ Error handling - Type-safe error parsing
- ✅ Sonner toasts - Transaction notifications
- ✅ shadcn/ui components - Button, Card, Input, Label, Badge, etc.

## Critical Conventions (from CLAUDE.md)

**State Management:**
- NEVER use `useReducer` - use `useState` or context
- Component state with `useState`, shared state via Context
- Server state via TanStack Query only

**TypeScript:**
- NEVER use `any` - use `unknown` and narrow types
- NEVER use type assertions (`as`) - let types prove correctness
- Prefer narrow types (literals, discriminated unions)

**Architecture:**
- Components are presentational - minimal logic
- Business logic in `lib/` folder and custom hooks
- Pure functions, immutability, early returns

**polkadot-api ONLY (NEVER @polkadot/api):**
- Use `MultiAddress.Id(address)` for addresses
- Use `Binary.fromText(string)` for strings
- Use `Utility.batch_all({ calls })` for batches
- Pallet names are capitalized: `Assets`, `Utility`
- Parameters are objects with named properties

## Implementation Order (5-Layer Dependency Tree)

Generate files in this exact order to respect dependencies:

### Layer 1: Pure Functions (No dependencies)

**1. lib/assetOperations.ts**
- Load reference: `reference/asset-operations.md` for patterns
- Exports: `createAssetBatch`, `mintTokens`, `transferTokens`, `destroyAssetBatch`
- Interfaces: `CreateAssetParams`, `MintParams`, `TransferParams`, `DestroyAssetParams`
- Key pattern: Build calls array, return `Utility.batch_all({ calls })`

**2. lib/assetToasts.ts** (new file)
- Toast configurations for all asset operations
- Use `ToastConfig<T>` interface from template
- **Important:** T is the params type (CreateAssetParams, MintParams, etc.)
- Exports: `createAssetToasts`, `mintTokensToasts`, `transferTokensToasts`, `destroyAssetToasts`

**3. lib/assetErrorMessages.ts**
- Load reference: `reference/error-messages.md` for 23 user-friendly error messages
- Exports: `ASSET_ERROR_MESSAGES` object, `getAssetErrorMessage` function
- Maps pallet error names to friendly messages with remediation steps

### Layer 2: Custom Hooks (Template dependencies only)

**4. hooks/useAssetMutation.ts**
- Load reference: `reference/mutation-hook.md` for pattern
- Generic hook for asset mutations with transaction tracking
- Uses: `useTransaction`, `useWalletContext`, `useConnectionContext` from template
- Returns: `{ execute, isLoading, error, reset }`

**5. hooks/useFee.ts**
- Real-time fee estimation with `useDeferredValue` (500ms debounce)
- Calls `transaction.getPaymentInfo(address, { at: 'best' })`
- Returns: `{ fee, isCalculating, error }`

**6. hooks/useNextAssetId.ts**
- TanStack Query hook for `api.query.Assets.Asset.getEntries()`
- Finds next available asset ID
- Returns: `{ nextAssetId, isLoading, error }`

### Layer 3: Query Helpers

**7. lib/queryHelpers.ts** (ADD to existing file if exists, or create new)
- Add: `invalidateAssetQueries`, `invalidateBalanceQueries`
- Helpers for cache invalidation after mutations

### Layer 4: Shared UI Components

**8. components/shared/FeeDisplay.tsx**
- Displays fee state (loading/error/amount)
- Uses `Badge` component from shadcn/ui
- Props: `{ fee, isCalculating, error }`

**9. components/shared/TransactionReview.tsx**
- JSON preview with `Collapsible` component
- Displays transaction details before submission
- Props: `{ params, title }`

**10. components/shared/TransactionFormFooter.tsx**
- Shared form footer with FeeDisplay + action Button
- Props: `{ fee, isCalculating, feeError, onSubmit, submitLabel, disabled }`

**11. components/shared/AccountDashboard.tsx**
- Account balance display + faucet link
- Uses `useWalletContext`, queries native balance
- Shows connected account info

### Layer 5: Feature Components

**12. components/features/CreateAsset.tsx**
- Load reference: `reference/form-component.md` for form pattern
- Full form with `useAssetMutation` + `useFee` + `useNextAssetId`
- Form fields: name, symbol, decimals, minBalance, initialSupply (optional)
- Uses `createAssetBatch` operation

**13. components/features/MintTokens.tsx**
- Form with `useAssetMutation` + `useFee`
- Form fields: assetId, recipient, amount
- Uses `mintTokens` operation

**14. components/features/TransferTokens.tsx**
- Form with `useAssetMutation` + `useFee`
- Form fields: assetId, recipient, amount
- Uses `transferTokens` operation

**15. components/features/DestroyAsset.tsx**
- Form with confirmation step + `useAssetMutation` + `useFee`
- Requires typing asset ID to confirm destruction
- Uses `destroyAssetBatch` operation (5-step process)

**16. components/features/AssetList.tsx**
- Query all assets with TanStack Query
- Filter and search functionality
- Maps to `AssetCard` components

**17. components/features/AssetCard.tsx**
- Display asset info (name, symbol, supply, accounts)
- Action menu: mint, transfer, destroy
- Uses `Card` from shadch/ui

**18. components/features/AssetDashboard.tsx**
- Main dashboard combining AssetList + AccountDashboard
- Tab navigation between create/mint/transfer/destroy
- Portfolio view

### Layer 6: Integration

**19. components/index.ts** (MODIFY existing file)
- Add exports for all new shared UI components
- Maintain existing exports

**20. App.tsx** (MODIFY existing file)
- Add routes/navigation for asset management pages
- Keep existing structure intact

## Reference Documents (Load On-Demand)

**When implementing lib/assetOperations.ts:**
```bash
cat reference/asset-operations.md
```
Shows polkadot-api patterns for create/mint/transfer/destroy operations.

**When implementing hooks/useAssetMutation.ts:**
```bash
cat reference/mutation-hook.md
```
Shows generic mutation hook pattern with transaction tracking.

**When implementing feature components:**
```bash
cat reference/form-component.md
```
Shows form component pattern with validation and fee estimation.

**When implementing lib/assetErrorMessages.ts:**
```bash
cat reference/error-messages.md
```
Shows 23 user-friendly error messages for Assets pallet errors.

## Validation Steps

After generating all files:

**1. TypeScript Validation (REQUIRED):**
```bash
bash .claude/scripts/validate-typescript.sh
```
Must pass without errors.

**2. Import Verification:**
- ✅ ALL imports from `polkadot-api` and `@polkadot-api/descriptors`
- ❌ ZERO imports from `@polkadot/api` (this is critical!)

**3. Convention Adherence:**
- No `useReducer` usage
- No `any` types
- No type assertions (`as`)
- Components are presentational
- Business logic in lib/ and hooks/

**4. Optional Quality Checks:**
```bash
bash .claude/scripts/validate-lint.sh
bash .claude/scripts/validate-build.sh
```

## Expected Output

**Files Generated:** 19 new files
- 5 lib modules (operations, toasts, errors, query helpers, formatters)
- 3 hooks (mutation, fee, nextAssetId)
- 4 shared components (FeeDisplay, TransactionReview, FormFooter, AccountDashboard)
- 7 feature components (Create, Mint, Transfer, Destroy, List, Card, Dashboard)

**Files Modified:** 2 files
- components/index.ts (add exports)
- App.tsx (add routing)

**Total Lines:** ~2,200 lines of production-ready code

**Capabilities Added:**
- ✅ Create custom tokens with metadata
- ✅ Mint tokens to recipients
- ✅ Transfer tokens between accounts
- ✅ Destroy tokens safely (5-step process)
- ✅ View all tokens and balances
- ✅ Real-time fee estimation
- ✅ Transaction notifications with status tracking
- ✅ User-friendly error messages with remediation steps

## Completion Report

After successful generation, report:
1. ✅ Files generated (19) and modified (2)
2. ✅ Validation results (TypeScript compilation status)
3. ✅ Import verification (zero @polkadot/api imports)
4. ✅ Any warnings or recommendations
5. ✅ Next steps: `pnpm dev` to start dev server

## Notes

- Follow CLAUDE.md conventions strictly
- Load references only when needed (progressive loading)
- Validate thoroughly before reporting completion
- All operations use `Utility.batch_all` for atomicity
- Asset destruction is a 5-step process (freeze → start → approvals → accounts → finish)
