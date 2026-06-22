#!/usr/bin/env bash
set -euo pipefail

echo "Generating SHA256 checksums..."
find 01-Wallpapers 02-Screensavers -type f -name "*.png" \
  | sort \
  | xargs shasum -a 256 > 00-Manifest/SHA256SUMS.txt

echo "Checksums written to 00-Manifest/SHA256SUMS.txt"
