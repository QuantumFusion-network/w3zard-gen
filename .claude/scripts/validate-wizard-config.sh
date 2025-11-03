#!/bin/bash
set -e

echo "🔍 Checking setup configuration..."

if [ ! -f "SETUP_PROMPT.md" ]; then
  echo "❌ SETUP_PROMPT.md not found"
  echo ""
  echo "This file should have been included when you cloned the project."
  echo ""
  echo "Please check:"
  echo "  1. Did you clone with the correct degit command?"
  echo "  2. Is the file present in your project root?"
  exit 1
fi

if [ ! -r "SETUP_PROMPT.md" ]; then
  echo "❌ SETUP_PROMPT.md exists but is not readable"
  exit 1
fi

echo "✓ Setup configuration found"
