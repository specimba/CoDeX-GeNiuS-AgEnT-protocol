// Full 2D reference starter — procedural gothic identity, no primitive-shape builds
// Canvas owns the loop; React owns HUD. Graceful WebGPU→WebGL→Canvas2D.

export const PALETTE = {
  deep: '#1a1025',
  charcoal: '#2d1f3a',
  ember: '#e67e22',
  gold: '#f4c430',
  ash: '#c9b8d0',
};

export function drawProceduralStone(ctx: CanvasRenderingContext2D, x: number, y: number, w: number, h: number) {
  // Procedural stone texture — layered gradients + noise lines
  const grad = ctx.createLinearGradient(x, y, x + w, y + h);
  grad.addColorStop(0, PALETTE.charcoal);
  grad.addColorStop(0.4, PALETTE.deep);
  grad.addColorStop(1, '#0d0815');
  ctx.fillStyle = grad;
  ctx.fillRect(x, y, w, h);
  // Embers (procedural dots)
  for (let i = 0; i < 60; i++) {
    ctx.fillStyle = `rgba(230,126,34,${0.15 + Math.random() * 0.25})`;
    ctx.beginPath();
    ctx.arc(x + Math.random() * w, y + Math.random() * h, 0.5 + Math.random() * 1.5, 0, Math.PI * 2);
    ctx.fill();
  }
}

export function drawFogOverlay(ctx: CanvasRenderingContext2D, width: number, height: number) {
  const g = ctx.createRadialGradient(width / 2, height / 2, width * 0.1, width / 2, height / 2, width);
  g.addColorStop(0, 'rgba(201,184,208,0.08)');
  g.addColorStop(0.6, 'rgba(26,16,37,0.4)');
  g.addColorStop(1, 'rgba(13,8,21,0.85)');
  ctx.fillStyle = g;
  ctx.fillRect(0, 0, width, height);
}
