#!/usr/bin/env python3
"""
Export Fellowship Pack master images to all required display resolutions.

Official environment taxonomy:
  signal-day, signal-moonlight, drift, forge, hearth,
  havens-day, havens-moonlight

Place 16-bit master PNGs in:
  masters/<environment-id>/<filename>.png

Exports will be written to:
  01-Wallpapers/<environment-id>/<resolution>/<environment-id>_<resolution>.png
"""
from PIL import Image
import os

RESOLUTIONS = {
    "5120x2880": (5120, 2880),   # Apple Pro Display XDR / Studio Display
    "3840x2160": (3840, 2160),   # 4K UHD
    "2560x1440": (2560, 1440),   # MacBook Pro 14/16 native
    "2732x2048": (2732, 2048),   # iPad Pro 12.9"
}

ENVIRONMENTS = [
    "signal-day",
    "signal-moonlight",
    "drift",
    "forge",
    "hearth",
    "havens-day",
    "havens-moonlight",
]

MASTER_DIR = "masters"
EXPORT_ROOT = "01-Wallpapers"

for theme in os.listdir(MASTER_DIR):
    theme_path = os.path.join(MASTER_DIR, theme)
    if not os.path.isdir(theme_path):
        continue

    if theme not in ENVIRONMENTS:
        print(f"⚠️  Skipping unknown environment: {theme}")
        continue

    for file in os.listdir(theme_path):
        if not file.endswith(".png"):
            continue

        master_path = os.path.join(theme_path, file)
        img = Image.open(master_path).convert("RGB")

        for label, size in RESOLUTIONS.items():
            export_dir = os.path.join(EXPORT_ROOT, theme, label)
            os.makedirs(export_dir, exist_ok=True)

            resized = img.resize(size, Image.LANCZOS)
            export_path = os.path.join(export_dir, f"{theme}_{label}.png")
            resized.save(export_path, format="PNG", optimize=True)
            print(f"  → {export_path}")

print("Export complete.")
