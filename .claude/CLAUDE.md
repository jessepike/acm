---
type: "context"
description: "ACM project context — the agentic context management framework"
version: "1.0.0"
updated: "2026-01-29"
scope: "project"
lifecycle: "reference"
location: ".claude/CLAUDE.md"
---

# ACM Project Context

## What This Is

ACM (Agentic Context Management) is the framework that defines how agentic projects are structured, managed, and maintained. It owns orchestration, knowledge, and the specs that govern all stages.

## Orientation

1. `status.md` — Current state, session log, next steps
2. `BACKLOG.md` — All tracked work items
3. `ACM-ENVIRONMENT-SPEC.md` — Environment layer architecture (six primitives)
4. `ACM-STAGES-SPEC.md` — Stage workflow (Discover → Design → Develop → Deliver)

## Context Map

| Artifact | Purpose |
|----------|---------|
| `ACM-*-SPEC.md` | Process and artifact specifications |
| `ACM-TAXONOMY.md` | Classification system and design decisions |
| `prompts/` | Stage transition and review prompts |
| `kb/` | Knowledge base — curated learnings |
| `stubs/` | Project scaffolding templates |
| `scripts/` | Init and review runner scripts |
| `experiments/` | Validation experiments (Ralph Loop) |

## Current Stage

**Develop** — building out the ACM framework itself and its environment layer.

## Related Repos

| Repo | Location | Purpose |
|------|----------|---------|
| capabilities-registry | `~/code/_shared/capabilities-registry/` | Capability catalog (skills, tools, agents, plugins) |
| acm-env plugin | `~/.claude/plugins/acm-env/` | Environment management plugin |

## Constraints

- Specs define "good" before building (spec-driven)
- YAGNI — build only what's needed now
- Token-efficient — every artifact earns its context cost
- Progressive disclosure — summary first, details on demand
