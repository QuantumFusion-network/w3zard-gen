# Asset Mutation Hook Reference

Generic hook pattern for asset mutations with transaction lifecycle tracking.

## useAssetMutation Pattern

```typescript
import type { Transaction } from 'polkadot-api'
import type { ToastConfig } from '@/lib/toastConfigs'
import { useMutation } from '@tanstack/react-query'
import { useTransaction } from './useTransaction'
import { useWalletContext } from './useWalletContext'

interface AssetMutationConfig<TParams> {
  params: TParams
  operationFn: (params: TParams) => Transaction<object, string, string, unknown>
  toastConfig: ToastConfig<TParams>
  onSuccess?: () => void | Promise<void>
  transactionKey: string
  isValid?: (params: TParams) => boolean
}

export const useAssetMutation = <TParams>({
  params,
  operationFn,
  toastConfig,
  onSuccess,
  transactionKey,
  isValid,
}: AssetMutationConfig<TParams>) => {
  const { selectedAccount } = useWalletContext()
  const { executeTransaction } = useTransaction<TParams>(toastConfig)

  // Build transaction from current params (reactive for fee estimation)
  const transaction =
    selectedAccount && (!isValid || isValid(params))
      ? operationFn(params)
      : null

  const mutation = useMutation({
    mutationFn: async () => {
      if (!selectedAccount || !transaction) {
        throw new Error('No account selected or transaction not available')
      }

      const observable = transaction.signSubmitAndWatch(selectedAccount.polkadotSigner)
      await executeTransaction(transactionKey, observable, params)
    },
    onSuccess: async () => {
      if (onSuccess) {
        await onSuccess()
      }
    },
  })

  return { mutation, transaction }
}
```

## Usage Example

```typescript
const { mutation, transaction } = useAssetMutation<CreateAssetParams>({
  params: { ...formData, assetId: nextAssetId },
  operationFn: (params) => createAssetBatch(api, params, selectedAccount?.address ?? ''),
  toastConfig: createAssetToasts,
  transactionKey: 'createAsset',
  isValid: (params) => params.name !== '' && params.symbol !== '',
  onSuccess: async () => {
    await invalidateAssetQueries(queryClient)
    setFormData(initialFormData)
  },
})

const feeState = useFee(transaction, selectedAccount?.address)

const handleSubmit = (e: FormEvent) => {
  e.preventDefault()
  mutation.mutate()
}
```
