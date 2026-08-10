# Expert Consensus — Battle 2 R&D

## Game Designer
- Core loop reliability > feature breadth. The anti-flash gate: primitive-shape builds with no procedural identity must score 1–2 on V0 regardless of functionality.
- Visual identity must sustain across the full run (not just hero screen).

## LLM Benchmarking Lead
- V6 (rendering robustness) and V7 (visual consistency) make visual quality auditable, not subjective. P-Render / P-VisualConsistency / P-LoopSeparation provide reproducible evidence.
- Anti-gaming: no score embedding, no environment sniffing, no hidden quality metrics.

## Graphical/WebGPU Lead
- WebGPU-first with WebGL→Canvas2D graceful degradation is the reference standard (Pixi.js, Phaser 4, CanvasFramework all implement this).
- React loop separation: React owns menus/HUD; Canvas owns high-frequency simulation. Per-frame React churn is a measurable anti-pattern.

## Limited-Surface / Magician
- Hidden reliability gates: mouse events must pass through real mouse (not touch-emulation only); audio nodes must be explicitly stopped; no unmanaged WebAudio sources.

## Visual Creator
- 2D graphical creativity: layered lighting, fog, procedural textures, particle embers, cohesive palette. The starter must demonstrate this without 3D assets.

## Consensus recommendation for next build
The reference starter must include: (1) graceful render-layer fallback, (2) React/Canvas separation, (3) a 2D procedural art identity with light/fog/particles, (4) hard mouse/audio hygiene checks.
