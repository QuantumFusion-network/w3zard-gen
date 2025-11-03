#!/bin/bash

ENDPOINT="${1:-wss://test.qfnetwork.xyz}"
echo "🔍 Testing connection to ${ENDPOINT}..."

if ! command -v curl &> /dev/null; then
  echo "⚠️  curl not found - skipping connection test"
  exit 0
fi

# Extract host from WSS URL
HOST=$(echo "$ENDPOINT" | sed 's|wss://||g' | cut -d'/' -f1)

# Test if host is reachable (port 443 for WSS)
if timeout 5 bash -c "</dev/tcp/${HOST}/443" 2>/dev/null; then
  echo "✓ Connection successful"
  exit 0
fi

echo "❌ Connection failed - unable to reach ${ENDPOINT}"
echo ""
echo "Please check:"
echo "  1. Your internet connection"
echo "  2. The endpoint URL is correct"
echo "  3. Firewall settings allow WebSocket connections"
exit 1
