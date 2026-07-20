---
name: image-handling
description: Inspect, edit, and clean images with deterministic local tools. Use for fixing alpha, cropping, padding, removing backgrounds, and verifying dimensions/alpha. Also for creating image-handling skills and tooling.
---

# Image Handling

Use ImageMagick (`magick`) and other local tools for deterministic image edits and validation. Use the `genmedia` skill separately for AI-based generation.

## Available Tools
- `magick`: ImageMagick CLI for cropping, trimming, padding, alpha, transparency, resizing, etc.

## Common Operations

### Inspect assets
```bash
sips -g pixelWidth -g pixelHeight -g hasAlpha *.png
```

### Fix alpha / transparency
```bash
magick in.png -alpha set -fuzz 5% -transparent white out.png
magick in.png -alpha set -fuzz 3% -transparent black out.png
magick in.png -alpha set -fill none -draw "color 0,0 floodfill" out.png
```

### Crop + pad to canvas
```bash
magick in.png -trim +repage -background none -gravity center -extent 160x160 out.png
```

### Remove baked checkerboard/background
```bash
magick in.png -alpha set -fuzz 5% -transparent "#d0d0d0" out.png
```

## Session Heuristics
- Always check `hasAlpha` before assuming transparency.
- Prefer flood-fill (`color 0,0 floodfill`) for connected white backgrounds.
- Normalize small icons to consistent square canvas (e.g. 160x160) with center gravity.
- Re-export when baked backgrounds or artifacts cannot be masked cleanly.
- Verify final dimensions/alpha match expected contracts before committing.
