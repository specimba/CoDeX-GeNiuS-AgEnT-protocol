# Spawn Control

This policy exists to stop agent-thread exhaustion, token waste, and fake parallelism.

## Practical concurrency rule

- keep one primary active owner
- default to one sidecar only; two active agents total is the preferred mode
- allow up to two sidecars only when the gain is clear; that makes three active agents total
- treat four active agents as the hard ceiling for exceptional cases only
- close completed subagents quickly
- do not leave completed or idle agents open; close them and resume only if needed later
- reuse an existing subagent when the follow-up question is in the same lane

## When to spawn

Spawn only when:

- the subtask is independent
- the main line is not blocked on it immediately
- the result will materially reduce the next decision or implementation step

Do not spawn for:

- work the current owner can do directly
- vague "look around" exploration
- duplicated review of the same scope

## Thread-limit rule

If the environment is near the thread limit:

- stop spawning
- close completed agents
- close idle agents that are only "parked" visually
- switch to bounded review packets or local inspection
- run `should-compact.ps1` before opening another worker

## Reviewer rule

Reviewers should receive a bounded review packet, not the full thread, unless the full thread is strictly necessary.

## Energy rule

Parallelism is a tool, not a default.

Minimum energy / maximum workforce means:

- spawn only when the extra worker saves more time than the coordination cost it introduces
- two active agents is usually the best performance point
