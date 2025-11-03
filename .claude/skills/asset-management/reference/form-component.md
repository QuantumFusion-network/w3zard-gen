# Form Component Reference

Standard two-column layout pattern for asset management forms.

## Pattern: Form + Review Layout

All asset forms use this structure:
- Grid: 3 columns (2 for form, 1 for review)
- Form state with useState
- useAssetMutation for transaction handling
- useFee for real-time estimation
- TransactionFormFooter for consistent UX

## Minimal Example

```typescript
import { useState, type FormEvent } from 'react'
import { Card, CardContent, Input, Label } from '@/components/ui'
import {
  useAssetMutation,
  useConnectionContext,
  useFee,
  useWalletContext,
} from '@/hooks'
import {
  TransactionFormFooter,
  TransactionReview,
  FeatureErrorBoundary,
} from '@/components'
import { createAssetBatch, createAssetToasts } from '@/lib'

function CreateAssetInner() {
  const { selectedAccount } = useWalletContext()
  const { api } = useConnectionContext()
  const [formData, setFormData] = useState({
    name: '',
    symbol: '',
    // ... other fields
  })

  const { mutation, transaction } = useAssetMutation({
    params: formData,
    operationFn: (params) => createAssetBatch(api, params, selectedAccount?.address ?? ''),
    toastConfig: createAssetToasts,
    transactionKey: 'createAsset',
    isValid: (params) => params.name !== '' && params.symbol !== '',
    onSuccess: async () => {
      // Invalidate queries, reset form
    },
  })

  const feeState = useFee(transaction, selectedAccount?.address)

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    mutation.mutate()
  }

  if (!selectedAccount) return <div>Please connect wallet</div>

  return (
    <Card>
      <CardContent>
        <form onSubmit={handleSubmit}>
          <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
            {/* Form fields - 2 columns */}
            <div className="lg:col-span-2">
              <Label>Token Name</Label>
              <Input
                value={formData.name}
                onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
              />
              {/* More fields... */}
            </div>

            {/* Review - 1 column */}
            <div className="lg:col-span-1">
              <TransactionReview data={formData} />
            </div>
          </div>

          <TransactionFormFooter
            feeState={feeState}
            isDisabled={mutation.isPending}
            isPending={mutation.isPending}
            actionText="Create Asset"
          />
        </form>
      </CardContent>
    </Card>
  )
}

export function CreateAsset() {
  return (
    <FeatureErrorBoundary featureName="Create Asset">
      <CreateAssetInner />
    </FeatureErrorBoundary>
  )
}
```

## Key Points

1. Wrap in FeatureErrorBoundary
2. Use useState for form data
3. useAssetMutation with validation
4. useFee for real-time estimation
5. Two-column responsive grid
6. TransactionFormFooter for consistency
