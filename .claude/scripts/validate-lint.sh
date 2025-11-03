#!/bin/bash

echo "🔍 Running linter..."

if pnpm lint:check; then
  echo "✓ Linting passed"
  exit 0
else
  echo "⚠️  Linting issues found"
  echo ""
  echo "To auto-fix many issues, run:"
  echo "  pnpm lint:fix"
  exit 1
fi
