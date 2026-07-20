---
name: genmedia
description: Generate images, videos, and 3D assets with the genmedia CLI and fal.ai. Use when asked to create AI media, choose a genmedia model, estimate generation cost, inspect archived generations, or remove a connected image background.
---

# Genmedia

Use `genmedia` for AI media generation through fal.ai. It requires `FAL_API_KEY` for generation and pricing requests.

## Workflow

1. Confirm the requested medium, subject, style, composition, output dimensions or aspect ratio, and destination path. Infer only details that do not materially change the result.
2. Check support with `genmedia modality`. Generation currently supports `text-to-image`, `text-to-video`, and `text-to-3d`; other listed modalities may only support model discovery.
3. Inspect recommended models before overriding the default:

```bash
genmedia text-to-image --models-curated
genmedia text-to-video --models-curated
genmedia text-to-3d --models-curated
```

4. For a potentially expensive request or multiple outputs, query model pricing before generating:

```bash
genmedia cost fal-ai/example-model
genmedia cost --estimate fal-ai/example-model=3
```

5. Generate directly to the requested path. Verify its parent directory exists first, and do not overwrite an existing file unless the user requested it.

```bash
genmedia text-to-image -o assets/hero.png "PROMPT"
genmedia text-to-video --model fal-ai/example-model -o assets/scene.mp4 "PROMPT"
genmedia text-to-3d -o assets/object.glb "PROMPT"
```

Set the command runner timeout high enough for remote generation. Use these minimums:

| Medium | Minimum timeout |
| --- | ---: |
| `text-to-image` | 120 seconds |
| `text-to-video` | 300 seconds |
| `text-to-3d` | 300 seconds |

These are execution limits, not expected generation times. Increase them for complex or slower models; never use a timeout below the listed minimum. Text-to-3D commonly takes 160 seconds or longer.

6. Inspect the resulting file's format, dimensions, duration, transparency, or geometry as relevant. Iterate by changing one variable at a time rather than generating many unfocused variants.

## Prompt Construction

Run `genmedia tips` when prompt requirements are unclear. Prefer concrete visual decisions over quality filler such as "masterpiece" or "8k".

For images, specify:

```text
subject + action + setting + composition + lighting + medium/style + constraints
```

For video, also specify subject motion, camera motion, pacing, and what must remain stable. For 3D, specify proportions, materials, topology needs, and whether the mesh must be watertight.

State negative constraints directly: no text, no watermark, no extra objects, fixed camera, isolated background, or seamless loop. Do not request a living artist's exact style; describe the medium and visual traits instead.

## Existing Generations

Use the archive before paying to recreate a missing or previously generated asset:

```bash
genmedia archive-list
genmedia archive-list .png
genmedia archive-list .mp4
```

## Background Transparency

For a connected, mostly uniform outer background, use the built-in deterministic helper instead of regenerating:

```bash
genmedia image-fix input.png output.png
genmedia image-fix --color "#FFFFFF" --fuzz 5% input.jpg output.png
```

Start with low fuzz and increase only as needed. Write transparency to PNG, WebP, or AVIF, then verify the alpha channel. Use ImageMagick or another deterministic tool for cropping, resizing, padding, and other ordinary transforms.

## Guardrails

- Never expose, print, or commit `FAL_API_KEY`.
- Do not claim a model, price, or modality is available without checking the CLI; fal.ai endpoints change.
- Prefer curated or default models unless the user names a model or the request needs a capability they lack.
- Avoid speculative batch generation. Generate one candidate first unless the user asks for variants.
- Keep provenance clear: identify generated assets as AI-generated when reporting the result.
