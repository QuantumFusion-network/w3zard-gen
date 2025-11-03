#!/bin/bash
set -e

echo "🔍 Checking PAPI configuration..."

if [ ! -f ".papi/polkadot-api.json" ]; then
  echo "❌ .papi/polkadot-api.json not found"
  echo ""
  echo "PAPI configuration is missing. Please run:"
  echo "  pnpm install"
  exit 1
fi

if [ ! -d ".papi/descriptors" ]; then
  echo "❌ .papi/descriptors/ directory not found"
  echo ""
  echo "PAPI descriptors are missing. Please run:"
  echo "  pnpm install"
  exit 1
fi

if [ ! -f ".papi/metadata/qfn.scale" ]; then
  echo "❌ .papi/metadata/qfn.scale not found"
  echo ""
  echo "QFN chain metadata is missing. Please run:"
  echo "  pnpm install"
  exit 1
fi

echo "✓ PAPI configuration valid"
