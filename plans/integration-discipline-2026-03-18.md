# Integration Discipline

Date: 2026-03-18

## Purpose

This repo must separate source-of-truth system files from generated artifacts, runtime state, and temporary research extracts.

## Source Of Truth

Track in git:

- `agents/`
- `plans/`
- root policy files such as `README.md`, `WORKSTYLE.md`, and `AGENTS.md`

## Generated Or Runtime Only

Do not treat these as source by default:

- `dist/`
- `runs/`
- `temp_extract_*`
- `__pycache__/`
- `*.pyc`

## Rule

If an artifact can be regenerated safely, it should usually not be part of the normal staged boundary.

## Release Boundary

A clean pack upgrade should usually include:

- agent docs
- policy docs
- lifecycle scripts
- packaging scripts
- roadmap / design / review plans

It should usually exclude:

- generated zips
- generated manifests and checksums
- runtime ledgers
- extracted review fixtures
- interpreter cache files

## CEO-Level Reason

This keeps the company system understandable:

- source changes explain intent
- generated output stays reproducible
- review remains clean
- rollback remains simple
