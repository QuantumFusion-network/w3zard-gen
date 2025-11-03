#!/bin/bash

echo "🔍 Running full build..."

if pnpm build; then
  echo "✓ Build successful"
  exit 0
else
  echo "❌ Build failed"
  echo ""
  echo "This indicates a serious issue with the generated code."
  exit 1
fi
