# Asset Error Messages Reference

User-friendly error messages for Assets pallet errors.

## Implementation

```typescript
// lib/assetErrorMessages.ts

export const ASSET_ERROR_MESSAGES: Record<string, string> = {
  // Permission errors
  'Assets.NoPermission':
    'You don\'t have permission to perform this operation. Only the asset owner or admin can do this.',
  'Assets.NotOwner': 'This operation requires asset ownership.',

  // Asset state errors
  'Assets.Unknown': 'This asset does not exist.',
  'Assets.InUse': 'This asset is currently in use and cannot be destroyed.',
  'Assets.AssetNotLive': 'This asset has been frozen and cannot be used for transactions.',
  'Assets.Frozen': 'This asset or account is frozen.',

  // Balance errors
  'Assets.BalanceLow': 'Insufficient balance to perform this operation.',
  'Assets.WouldDie': 'This operation would bring the balance below the minimum required amount.',
  'Assets.NoAccount': 'No account exists for this asset. The account may need to be created first.',

  // Metadata errors
  'Assets.BadMetadata': 'Invalid metadata format. Check that name and symbol are correctly formatted.',

  // Supply errors
  'Assets.MinBalanceZero': 'Minimum balance must be greater than zero.',
  'Assets.Overflow': 'This operation would cause a numeric overflow.',

  // Existence errors
  'Assets.AlreadyExists': 'An asset with this ID already exists.',
  'Assets.NotFrozen': 'This operation requires the asset to be frozen first.',

  // Destruction errors
  'Assets.RefsLeft': 'Cannot complete destruction - asset still has active references.',
  'Assets.CallbackFailed': 'Asset destruction callback failed.',
}

export const getAssetErrorMessage = (error: string): string => {
  return ASSET_ERROR_MESSAGES[error] ||
    'An unexpected error occurred. Please check your transaction parameters.'
}
```

## Usage

```typescript
import { parseDispatchError } from '@/lib/errorParsing'
import { getAssetErrorMessage } from '@/lib/assetErrorMessages'
import { toast } from 'sonner'

try {
  await mutation.mutateAsync()
} catch (error) {
  const dispatchError = parseDispatchError(error)
  if (dispatchError) {
    const friendlyMessage = getAssetErrorMessage(dispatchError.type)
    toast.error(friendlyMessage)
  } else {
    toast.error('Transaction failed. Please try again.')
  }
}
```
