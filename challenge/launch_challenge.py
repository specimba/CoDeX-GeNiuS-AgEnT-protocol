#!/usr/bin/env python3
"""
Ashen Descent Agent Arena — challenge launcher (harness helper).

Provisions two ISOLATED agent workspaces, drops the IDENTICAL challenge brief + spec into
each, records a start/stop time budget, computes build hashes at finalize, and runs a
containment audit.

Fairness is enforced by the harness, not by the agents:
  * both workspaces get byte-for-byte the same brief + spec + self-QA;
  * the workspaces contain ONLY those files (the benchmark/ evaluation files are never
    copied into them);
  * a run manifest records timestamps and hashes so the equal-time-budget contract can be
    audited.

NOTE: this is a helper, not the whole process. The actual agent runs happen in their own
environments (some with repo access, some without); this script standardizes the workspace
and the paper trail around them.

Usage:
    python launch_challenge.py setup --out dir [--agents 2] [--budget-min 60]
    python launch_challenge.py single-prompt --out dir            # paste-ready prompt (no-repo delivery)
    python launch_challenge.py finalize --out dir [--agents 2]    # record end time + build hashes
    python launch_challenge.py audit <build_dir> [<build_dir> ...]
    python launch_challenge.py status --out dir

Examples:
    python launch_challenge.py setup --out /tmp/arena-run --agents 2 --budget-min 60
    python launch_challenge.py single-prompt --out /tmp/arena-run
    python launch_challenge.py finalize --out /tmp/arena-run --agents 2
    python launch_challenge.py audit /tmp/arena-run/agent1 /tmp/arena-run/agent2
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

# Challenge files shipped into every workspace (byte-for-byte identical).
BRIEF = Path(__file__).resolve().parent / "AGENT_CHALLENGE_BRIEF.md"
SPEC = Path(__file__).resolve().parent.parent / "GAME_SPEC.md"
SELFQA = Path(__file__).resolve().parent / "DEVELOPER_SELF_QA.md"

CHALLENGE_FILES = {
    "AGENT_CHALLENGE_BRIEF.md": BRIEF,
    "GAME_SPEC.md": SPEC,
    "DEVELOPER_SELF_QA.md": SELFQA,
}

MANIFEST_NAME = "run_manifest.json"

# Strings that must NOT appear inside a frozen game build (containment audit).
# These come from the evaluation package; their presence means the build could be
# reading/gaming the rubric. We only flag DISTINCTIVE benchmark-internal tokens.
# Generic words that legitimately appear in the public spec / brief / English prose
# ("score", "weight", "rubric") are deliberately NOT listed to avoid false positives.
FORBIDDEN_TOKENS = [
    "CEIL-", "HARD_PENALTY", "OVERALL_adj", "OVERALL_raw",
    "technical_reliability", "creative_presentation", "defect_severity",
    "bradley-terry", "bradley_terry", "aggregate_scores",
    "evidence_schema", "one-shot-arena-prompt",
]


def now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def sha256_tree(directory: Path) -> dict[str, str]:
    """Return {relative_path: sha256} for all files under directory (excluding manifest)."""
    out = {}
    for root, _dirs, files in os.walk(directory):
        for fn in sorted(files):
            p = Path(root) / fn
            if p.name == MANIFEST_NAME:
                continue
            rel = str(p.relative_to(directory))
            h = hashlib.sha256()
            with open(p, "rb") as f:
                for chunk in iter(lambda: f.read(65536), b""):
                    h.update(chunk)
            out[rel] = h.hexdigest()
    return out


def ensure_files() -> None:
    missing = [str(p) for k, p in CHALLENGE_FILES.items() if not p.exists()]
    if missing:
        sys.exit(f"[error] missing challenge files: {missing}")


def cmd_setup(args) -> None:
    ensure_files()
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    n = args.agents
    ts = now_iso()
    manifest = {
        "created_utc": ts,
        "budget_min": args.budget_min,
        "agents": {},
        "note": "Workspaces contain ONLY the challenge files; evaluation files are NOT shipped.",
    }
    for i in range(1, n + 1):
        wd = out / f"agent{i}"
        wd.mkdir(parents=True, exist_ok=True)
        for name, src in CHALLENGE_FILES.items():
            shutil.copyfile(src, wd / name)
        manifest["agents"][f"agent{i}"] = {
            "workspace": str(wd),
            "brief_sha256": sha256_of(BRIEF),
            "spec_sha256": sha256_of(SPEC),
            "selfqa_sha256": sha256_of(SELFQA),
            "start_utc": ts,
            "end_utc": None,
            "build_hash": None,
        }
    write_manifest(out, manifest)
    print(f"[setup] created {n} isolated workspaces under {out}")
    print(f"[setup] all agents received the SAME brief (sha256={manifest['agents']['agent1']['brief_sha256'][:12]}…)")
    print("[setup] hand each workspace to its agent now. Launch agents in parallel for an equal time budget.")


def cmd_single_prompt(args) -> None:
    """Emit ONE paste-ready prompt (full brief inline) for agents with NO repo access."""
    ensure_files()
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    brief_text = BRIEF.read_text(encoding="utf-8")
    spec_note = ""
    # The brief already embeds the full spec, so the single prompt is self-contained.
    prompt = (
        "# ASHEN DESCENT — AGENT CHALLENGE (single self-contained prompt)\n"
        "# Deliver this entire message to the agent. It is fully self-contained; the agent\n"
        "# does not need any repository access. (Identical content is also shipped to agents\n"
        "# that DO have repo access, as AGENT_CHALLENGE_BRIEF.md.)\n\n"
        + brief_text
        + "\n\n# -- end of challenge brief --\n"
    )
    dest = out / "SINGLE_PROMPT.md"
    dest.write_text(prompt, encoding="utf-8")
    print(f"[single-prompt] wrote {dest} ({len(prompt)} chars). Send its full contents to the agent.")


def cmd_finalize(args) -> None:
    out = Path(args.out)
    manifest = read_manifest(out)
    if manifest is None:
        sys.exit(f"[error] no {MANIFEST_NAME} in {out}; run setup first")
    end = now_iso()
    for i in range(1, args.agents + 1):
        a = manifest["agents"].get(f"agent{i}")
        if a is None:
            continue
        wd = Path(a["workspace"])
        if not wd.exists():
            print(f"[warn] workspace missing for agent{i}: {wd}")
            continue
        a["end_utc"] = end
        a["build_hash"] = sha256_tree(wd)
        a["duration_min"] = round((datetime.fromisoformat(end) - datetime.fromisoformat(a["start_utc"])).total_seconds() / 60, 1)
    write_manifest(out, manifest)
    print(f"[finalize] recorded end time + build hashes in {out / MANIFEST_NAME}")
    for i in range(1, args.agents + 1):
        a = manifest["agents"].get(f"agent{i}")
        if a:
            print(f"  agent{i}: start={a['start_utc'][:19]} end={a['end_utc'][:19]} dur={a.get('duration_min')}min files={len(a.get('build_hash') or {})}")


def cmd_status(args) -> None:
    out = Path(args.out)
    manifest = read_manifest(out)
    if manifest is None:
        sys.exit(f"[error] no {MANIFEST_NAME} in {out}")
    print(json.dumps(manifest, indent=2))


def cmd_audit(args) -> None:
    hits = 0
    for d in args.build_dirs:
        p = Path(d)
        if not p.is_dir():
            print(f"[audit] not a dir, skipping: {p}")
            continue
        for root, _dirs, files in os.walk(p):
            for fn in files:
                fp = Path(root) / fn
                if fn == MANIFEST_NAME:
                    continue
                try:
                    text = fp.read_text(encoding="utf-8", errors="ignore").lower()
                except OSError:
                    continue
                for tok in FORBIDDEN_TOKENS:
                    if tok.lower() in text:
                        hits += 1
                        print(f"[audit][HIT] {fp}: token '{tok}'")
    if hits:
        print(f"[audit] {hits} potential containment leak(s) found. Investigate; a rubric/"
              f"telemetry string inside a build is a Critical CONTAINMENT defect.")
    else:
        print("[audit] clean: no rubric/telemetry/benchmark tokens found in the scanned builds.")


def sha256_of(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def write_manifest(out: Path, manifest: dict) -> None:
    (out / MANIFEST_NAME).write_text(json.dumps(manifest, indent=2), encoding="utf-8")


def read_manifest(out: Path) -> dict | None:
    m = out / MANIFEST_NAME
    if not m.exists():
        return None
    return json.loads(m.read_text(encoding="utf-8"))


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("setup", help="create isolated agent workspaces with the identical brief")
    p.add_argument("--out", required=True)
    p.add_argument("--agents", type=int, default=2)
    p.add_argument("--budget-min", type=int, default=60)
    p.set_defaults(func=cmd_setup)

    p = sub.add_parser("single-prompt", help="emit a single paste-ready prompt for no-repo agents")
    p.add_argument("--out", required=True)
    p.set_defaults(func=cmd_single_prompt)

    p = sub.add_parser("finalize", help="record end time + build hashes")
    p.add_argument("--out", required=True)
    p.add_argument("--agents", type=int, default=2)
    p.set_defaults(func=cmd_finalize)

    p = sub.add_parser("status", help="show the run manifest")
    p.add_argument("--out", required=True)
    p.set_defaults(func=cmd_status)

    p = sub.add_parser("audit", help="containment-audit frozen builds")
    p.add_argument("build_dirs", nargs="+")
    p.set_defaults(func=cmd_audit)

    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
