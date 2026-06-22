#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"

REQUIRED_DIRS=(
  "00-Manifest"
  "01-Wallpapers"
  "02-Screensavers"
  "03-Accessibility-Notes"
)

# Official cognitive environment taxonomy
REQUIRED_THEMES=(
  "signal-day"
  "signal-moonlight"
  "drift"
  "forge"
  "hearth"
  "havens-day"
  "havens-moonlight"
)

REQUIRED_RES=("5120x2880" "3840x2160" "2560x1440" "2732x2048")

echo "Validating Fellowship Pack structure..."

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ ! -d "$ROOT/$dir" ]; then
    echo "❌ Missing required directory: $dir"
    exit 1
  fi
done

echo "Checking theme coverage..."

for theme in "${REQUIRED_THEMES[@]}"; do
  if [ ! -d "$ROOT/01-Wallpapers/$theme" ]; then
    echo "❌ Missing environment directory: 01-Wallpapers/$theme"
    exit 1
  fi
done

echo "Checking resolution coverage..."

for theme in "${REQUIRED_THEMES[@]}"; do
  theme_path="$ROOT/01-Wallpapers/$theme"
  for res in "${REQUIRED_RES[@]}"; do
    if ! find "$theme_path" -type f -name "*${res}*.png" | grep -q .; then
      echo "❌ Missing resolution ${res} in ${theme}"
      exit 1
    fi
  done
done

echo "Checking sRGB profile embedding..."

if command -v identify >/dev/null 2>&1; then
  find "$ROOT/01-Wallpapers" -name "*.png" | while read img; do
    profile=$(identify -verbose "$img" | grep -i "Colorspace" || true)
    if [[ "$profile" != *"sRGB"* ]]; then
      echo "⚠️  $img does not explicitly report sRGB colorspace"
    fi
  done
else
  echo "⚠️  ImageMagick not installed; skipping color profile validation"
fi

echo "✅ Validation complete."
