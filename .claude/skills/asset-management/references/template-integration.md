# Template Integration

How to use template infrastructure in asset management features.

## Balance Utilities

Template provides battle-tested utilities - NEVER create custom versions.

```typescript
import { toPlanck, fromPlanck, formatBalance } from '@/lib'

// User input → Planck (bigint for transactions)
const amount = toPlanck("1.5", 18)  // 1500000000000000000n

// Planck → Readable string
const readable = fromPlanck(1500000000000000000n, 18)  // "1.5"

// Format with locale and symbol
const formatted = formatBalance("1234.5678", {
  symbol: "QF",
  displayDecimals: 2,
  locale: "en-US"
})  // "1,234.57 QF"
```

## Shared Components

**TransactionFormFooter** - Consistent footer for all forms:

```typescript
import { TransactionFormFooter } from '@/components'
import { useFee } from '@/hooks'

const feeState = useFee(transaction, selectedAccount?.address)

<TransactionFormFooter
  feeState={feeState}
  isDisabled={!isFormValid}
  isPending={mutation.isPending}
  actionText="Create Asset"
/>
```

**TransactionReview** - JSON preview:

```typescript
import { TransactionReview } from '@/components'

<TransactionReview data={formData} />
```

**AccountDashboard** - Native balance + faucet:

```typescript
import { AccountDashboard } from '@/components'

<AccountDashboard />
```

## Hooks

**useAssetMutation** - Generic mutation hook:

```typescript
import { useAssetMutation } from '@/hooks'

const { mutation, transaction } = useAssetMutation({
  params: formData,
  operationFn: (params) => createAssetBatch(api, params, address),
  toastConfig: createAssetToasts,
  transactionKey: 'createAsset',
  isValid: (params) => params.name !== '',
  onSuccess: async () => {
    await invalidateAssetQueries(queryClient)
  }
})
```

**useFee** - Real-time fee estimation:

```typescript
import { useFee } from '@/hooks'

const feeState = useFee(transaction, selectedAccount?.address)
// Returns: { fee, isLoading, error }
```

**useNextAssetId** - Get next available ID:

```typescript
import { useNextAssetId } from '@/hooks'

const { nextAssetId, isLoading } = useNextAssetId()
```

## Query Helpers

```typescript
import { invalidateAssetQueries, invalidateBalanceQueries } from '@/lib'
import { useQueryClient } from '@tanstack/react-query'

const queryClient = useQueryClient()

// After mutations
await invalidateAssetQueries(queryClient)
invalidateBalanceQueries(queryClient, assetId, [address1, address2])
```

