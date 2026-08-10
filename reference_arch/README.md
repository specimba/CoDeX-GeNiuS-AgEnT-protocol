# Reference Architecture Starter

- `render-layer.ts`: WebGPU → WebGL → Canvas2D graceful fallback.
- React owns menus/HUD; Canvas (or any render layer) owns the gameplay loop.
- No per-frame React churn; delta-time simulation stays in loop.

This pattern applies to ANY graphical style — 2D, 3D, mixed, procedural, or stylized. No time limit; agents may work for hours. The framework measures reliability, visual consistency, and gameplay quality — not rendering dimension.
