# Asset Operations Reference

Core patterns for implementing asset pallet operations with polkadot-api.

## Key Patterns

**Use these wrappers:**
- `MultiAddress.Id(address)` for all addresses
- `Binary.fromText(string)` for all strings/metadata
- `.decodedCall` property for batch operations
- `Utility.batch_all({ calls })` for all-or-nothing batches

## createAssetBatch Pattern

```typescript
import { Binary, type TxCallData, type TypedApi } from 'polkadot-api'
import { MultiAddress, type qfn } from '@polkadot-api/descriptors'
import { parseUnits } from './utils'

type QfnApi = TypedApi<typeof qfn>

export interface CreateAssetParams {
  assetId: string
  minBalance: string
  name: string
  symbol: string
  decimals: string
  initialMintAmount: string
  initialMintBeneficiary: string
}

export const createAssetBatch = (
  api: QfnApi,
  params: CreateAssetParams,
  signerAddress: string
) => {
  const assetId = parseInt(params.assetId)
  const minBalance = BigInt(params.minBalance) * 10n ** BigInt(params.decimals)

  const createCall = api.tx.Assets.create({
    id: assetId,
    admin: MultiAddress.Id(signerAddress),
    min_balance: minBalance,
  }).decodedCall

  const metadataCall = api.tx.Assets.set_metadata({
    id: assetId,
    name: Binary.fromText(params.name),
    symbol: Binary.fromText(params.symbol),
    decimals: parseInt(params.decimals),
  }).decodedCall

  const calls: TxCallData[] = [createCall, metadataCall]

  if (params.initialMintAmount && parseFloat(params.initialMintAmount) > 0) {
    const mintAmount = parseUnits(params.initialMintAmount, parseInt(params.decimals))
    const mintCall = api.tx.Assets.mint({
      id: assetId,
      beneficiary: MultiAddress.Id(params.initialMintBeneficiary),
      amount: mintAmount,
    }).decodedCall
    calls.push(mintCall)
  }

  return api.tx.Utility.batch_all({ calls })
}
```

## Other Operations

**mintTokens:**
```typescript
export interface MintParams {
  assetId: string
  recipient: string
  amount: string
  decimals: number
}

export const mintTokens = (api: QfnApi, params: MintParams) => {
  return api.tx.Assets.mint({
    id: parseInt(params.assetId),
    beneficiary: MultiAddress.Id(params.recipient),
    amount: parseUnits(params.amount, params.decimals),
  })
}
```

**transferTokens:**
```typescript
export interface TransferParams {
  assetId: string
  recipient: string
  amount: string
  decimals: number
}

export const transferTokens = (api: QfnApi, params: TransferParams) => {
  return api.tx.Assets.transfer({
    id: parseInt(params.assetId),
    target: MultiAddress.Id(params.recipient),
    amount: parseUnits(params.amount, params.decimals),
  })
}
```

**destroyAssetBatch** (5-step process):
```typescript
export interface DestroyAssetParams {
  assetId: string
}

export const destroyAssetBatch = (api: QfnApi, params: DestroyAssetParams) => {
  const assetId = parseInt(params.assetId)

  const calls: TxCallData[] = [
    api.tx.Assets.freeze_asset({ id: assetId }).decodedCall,
    api.tx.Assets.start_destroy({ id: assetId }).decodedCall,
    api.tx.Assets.destroy_approvals({ id: assetId }).decodedCall,
    api.tx.Assets.destroy_accounts({ id: assetId }).decodedCall,
    api.tx.Assets.finish_destroy({ id: assetId }).decodedCall,
  ]

  return api.tx.Utility.batch_all({ calls })
}
```
