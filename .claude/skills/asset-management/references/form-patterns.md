# Form Component Patterns

Standard patterns for asset management forms using template components.

## Standard Layout

All forms use this three-column grid with shared components from template:

```typescript
import {
  AccountDashboard,
  TransactionFormFooter,
  TransactionReview,
  FeatureErrorBoundary
} from '@/components'
import { Card, CardContent, Input, Label } from '@/components/ui'
import { useAssetMutation, useFee } from '@/hooks'

function CreateAssetInner() {
  const [formData, setFormData] = useState({ ... })
  const { mutation, transaction } = useAssetMutation({ ... })
  const feeState = useFee(transaction, selectedAccount?.address)

  return (
    <div className="space-y-6">
      {/* 1. Balance display */}
      <AccountDashboard />

      {/* 2. Form card */}
      <Card>
        <CardContent className="pt-6">
          <form onSubmit={handleSubmit}>
            {/* 3. Three-column grid */}
            <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
              {/* Left 2 cols: Form fields */}
              <div className="space-y-4 lg:col-span-2">
                <div>
                  <Label>Field Name</Label>
                  <Input {...} />
                </div>
              </div>

              {/* Right 1 col: Review */}
              <div className="lg:col-span-1">
                <TransactionReview data={formData} />
              </div>
            </div>

            {/* 4. Footer with fee + submit */}
            <TransactionFormFooter
              feeState={feeState}
              isDisabled={!isFormValid}
              isPending={mutation.isPending}
              actionText="Submit"
            />
          </form>
        </CardContent>
      </Card>
    </div>
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

## Destructive Variant

For destroy operations, use `variant="destructive"`:

```typescript
<TransactionFormFooter
  variant="destructive"
  actionText="Destroy Asset"
  {...}
/>

<TransactionReview
  variant="destructive"
  data={formData}
/>
```

