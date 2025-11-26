# Error Handling Reference

Detailed error handling patterns for polkadot-api transactions and queries.

## Transaction Error Types

### Observable Errors

Errors that occur before finalization:

```typescript
import type { TxBroadcastEvent } from 'polkadot-api'

observable.subscribe({
  error: (err: unknown) => {
    if (typeof err === 'object' && err && 'type' in err) {
      const txError = err as { type: string; value?: unknown }
      
      switch (txError.type) {
        case 'Invalid':
          console.error('Transaction is invalid')
          break
        case 'Dropped':
          console.error('Transaction dropped from pool')
          break
        default:
          console.error('Unknown error:', txError)
      }
    }
  }
})
```

### Pallet Errors

Errors from chain runtime (after finalization):

```typescript
observable.subscribe({
  next: (event: TxBroadcastEvent) => {
    if (event.type === 'finalized') {
      const errorEvent = event.block.events.find(
        (e) => e.type === 'System' && e.value.type === 'ExtrinsicFailed'
      )
      
      if (errorEvent && errorEvent.value.type === 'ExtrinsicFailed') {
        const dispatchError = errorEvent.value.value.dispatchError
        
        if (dispatchError.type === 'Module') {
          const { value: moduleError } = dispatchError
          console.error(`Pallet: ${moduleError.type}, Error: ${moduleError.value.type}`)
        }
      }
    }
  }
})
```

## Query Errors

```typescript
try {
  const value = await api.query.Assets.Asset.getValue(assetId)
  if (value === undefined) {
    console.error('Asset not found')
  }
} catch (err) {
  console.error('Query failed:', err)
}
```

## Connection Errors

```typescript
import { getWsProvider } from 'polkadot-api/ws-provider'

const provider = getWsProvider('wss://test.qfnetwork.xyz')

provider.on('error', (error) => {
  console.error('WebSocket error:', error)
})

provider.on('close', (code, reason) => {
  console.log('Connection closed:', code, reason)
})
```

## User-Friendly Error Messages

Create lookup tables for pallet errors:

```typescript
// lib/errorMessages.ts
export const ASSET_ERROR_MESSAGES: Record<string, string> = {
  InUse: 'This asset ID is already in use. Try a different ID.',
  NoAccount: 'You must hold this asset before performing this operation.',
  BalanceLow: 'Insufficient balance. Check your account balance.',
}

export function getAssetErrorMessage(errorType: string): string {
  return ASSET_ERROR_MESSAGES[errorType] ?? 'An unknown error occurred.'
}
```

## Best Practices

1. Always handle observable errors
2. Parse pallet errors for user feedback
3. Log unknown errors for debugging
4. Provide remediation guidance
5. Use type narrowing before accessing properties

