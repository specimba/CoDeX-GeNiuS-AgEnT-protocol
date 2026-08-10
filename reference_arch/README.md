# Reference Architecture Starter

- `render-layer.ts`: WebGPU → WebGL → Canvas2D graceful fallback.
- React owns menus/HUD; Canvas owns the gameplay loop.
- No per-frame React churn; delta-time simulation stays in loop.

This is the architecture pattern agents should follow for the upgraded graphical bar.
