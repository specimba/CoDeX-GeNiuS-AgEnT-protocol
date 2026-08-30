# BATTLE PROMPT — Build one good browser game, in one session (v14)

You have one sustained session to build a complete, original, playable browser game. Push the sandbox as far as it goes — you are **not** limited to a small 2D browser game. Frontier models in 2026 routinely ship WebGL/WebGPU generative visuals, real simulations, shader post-processing, and procedural worlds in a single self-contained file. **That capability is in your hands — use it.** Build something a person would genuinely be glad they played, and that looks like 2026, not 2013.

Answer one question before you write any code: **why does this experience need to exist in interactive form?** If you can't answer it, you don't have a game yet.

**Be ambitious and trust your own taste.** Pick a concept you find genuinely interesting — any genre, any camera, any stack, any form (action, strategy, simulation, narrative, puzzle, exploration, abstract, experimental — your call). Make it look modern: real lighting or shaders, procedural materials, post-processing, particles, a coherent art direction. A stylized-but-polished look beats flat primitives every time. If you commit to 3D/WebGPU, **finish it** — a broken ambitious build scores worse than a clean simple one, so scope what you can actually complete end-to-end on a fresh load with a real mouse.

**The only hard rules (reliability + fairness — everything else is your call):**

1. **Launches** cleanly on a fresh load — no blank screen, no console-error loop.
2. **Complete loop** without a page refresh: start → play → progress → end → restart.
3. **Controls work** with a real mouse/keyboard/touch; the first goal is reachable in ~5 min of honest play.
4. **Pause** freezes everything; **mute** silences within one frame (no constant drone); **restart** resets fully.
5. **Self-contained & offline**: no backend, no network calls, no assets you can't legally ship, no telemetry. Static folder or single HTML.
6. **Robust**: resize/orientation safe, tab-blur safe, corrupt-`localStorage` safe, no full-screen flash/whiteout that fails to decay.
7. **Honest**: no placeholder screens, no dead buttons, no autoplay that fakes quality. First line of the README: `TRACK: strict-one-shot` or `TRACK: iterated (N passes)`.

**Deliverables:** the runnable game; a short README (TRACK line, how to run, controls, stack, what you cut, and short **DESIGN_PILLARS** / **DIRECTOR_STATEMENT** / **WHY_INTERACTIVE** / **HONEST_SELF_ASSESSMENT** paragraphs); optionally a `design_notebook.md`.

Ship a complete, polished, modern game you'd actually want to play. Good luck.
