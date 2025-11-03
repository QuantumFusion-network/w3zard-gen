#!/bin/bash

echo "🔍 Running TypeScript type check..."

if pnpm typecheck; then
  echo "✓ TypeScript validation successful"
  exit 0
else
  echo "❌ TypeScript errors found"
  echo ""
  echo "Please review the errors above and fix them before proceeding."
  exit 1
fi
