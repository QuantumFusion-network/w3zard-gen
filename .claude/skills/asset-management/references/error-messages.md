# Asset Error Messages

User-friendly error messages for Assets pallet.

## Implementation

```typescript
// lib/assetErrorMessages.ts
export const ASSET_ERROR_MESSAGES: Record<string, string> = {
  NoPermission: "You don't have permission. Only the asset owner/admin can do this.",
  NotOwner: 'This operation requires asset ownership.',
  Unknown: 'This asset does not exist.',
  InUse: 'Asset is in use and cannot be destroyed.',
  AssetNotLive: 'Asset is frozen and cannot be used.',
  Frozen: 'This asset or account is frozen.',
  BalanceLow: 'Insufficient balance.',
  WouldDie: 'Operation would bring balance below minimum.',
  NoAccount: 'No account exists for this asset.',
  BadMetadata: 'Invalid metadata format.',
  MinBalanceZero: 'Minimum balance must be greater than zero.',
  Overflow: 'This operation would cause numeric overflow.',
  AlreadyExists: 'Asset ID already in use. Try a different ID.',
  NotFrozen: 'Asset must be frozen first.',
  RefsLeft: 'Cannot destroy - asset has active references.',
}

export const getAssetErrorMessage = (errorType: string): string => {
  return ASSET_ERROR_MESSAGES[errorType] ?? 'An unexpected error occurred.'
}
```

## Usage in Toast Configs

```typescript
import { getAssetErrorMessage } from './assetErrorMessages'

export const createAssetToasts: ToastConfig<CreateAssetParams> = {
  error: (params, error) => {
    const errorType = parsePalletError(error)
    const message = errorType ? getAssetErrorMessage(errorType) : 'Failed to create asset.'
    return { title: 'Creation Failed', description: message }
  },
}
```

