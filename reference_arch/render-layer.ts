// Reference architecture starter: WebGPU-capable React + Canvas loop
// Demonstrates graceful degradation (WebGPU → WebGL → Canvas2D)
// Gameplay loop lives in Canvas (not React re-renders); React owns menus/HUD.

export const RENDER_LAYER_ORDER = [
  'webgpu',
  'webgl',
  'canvas2d',
];

export async function tryWebGPU(canvas: HTMLCanvasElement) {
  if (!('gpu' in navigator)) return null;
  try {
    const adapter = await (navigator as any).gpu.requestAdapter();
    if (!adapter) return null;
    const device = await adapter.requestDevice();
    const ctx = canvas.getContext('webgpu') as GPUCanvasContext;
    ctx?.configure({ device, format: navigator.gpu.getPreferredCanvasFormat?.() ?? 'bgra8unorm' });
    return { adapter, device, ctx, mode: 'webgpu' };
  } catch (e) { return null; }
}

export function tryWebGL(canvas: HTMLCanvasElement) {
  const gl = canvas.getContext('webgl2') || canvas.getContext('webgl');
  return gl ? { gl, mode: 'webgl' } : null;
}

export function tryCanvas2D(canvas: HTMLCanvasElement) {
  const ctx = canvas.getContext('2d');
  return ctx ? { ctx, mode: 'canvas2d' } : null;
}
