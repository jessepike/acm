---
project: "ACM (Agentic Context Management)"
stage: "Develop"
updated: "2026-01-29"
---

# Status

## Current State

- **Stage:** Develop (ACM framework itself)
- **Focus:** Spec updates and prompt improvements from develop stage debrief

## What's Complete

### Discover Stage (v1.2.0)
- [x] Phase model: Exploration → Crystallization → Review Loop → Finalization
- [x] Two-phase review: Internal (Ralph Loop) + External (GPT/Gemini)
- [x] YAGNI principle integrated into review prompts
- [x] Exit criteria defined
- [x] Prompts created: `ralph-review-prompt.md`, `external-review-prompt.md`
- [x] Validated with real project (portfolio site)

### Design Stage Spec
- [x] ACM-DESIGN-SPEC.md — phases, inputs, outputs, exit criteria

### Develop Stage Spec
- [x] ACM-DEVELOP-SPEC.md (v1.2.0) — phases, intake, planning, build, review, phase boundary protocol

### Supporting Specs
- [x] ACM-BRIEF-SPEC.md (v2.1.0)
- [x] ACM-INTENT-SPEC.md
- [x] ACM-PROJECT-TYPES-SPEC.md (v2.0.0)
- [x] ACM-STATUS-SPEC.md (v1.1.0)
- [x] ACM-TAXONOMY.md (v1.4.0)
- [x] ACM-README-SPEC.md (v1.0.0)
- [x] ACM-CONTEXT-ARTIFACT-SPEC.md (v1.0.0)
- [x] ACM-STAGES-SPEC.md (v1.1.0)
- [x] ACM-ENV-SPEC.md (v1.0.0)
- [x] ACM-ENVIRONMENT-SPEC.md (v1.0.0) — environment layer architecture (six primitives, two layers)

### acm-env Plugin (v1.0.0)
- [x] Plugin scaffold (`~/.claude/plugins/acm-env/`)
- [x] plugin.json manifest
- [x] baseline.yaml — machine-parseable baseline spec
- [x] `/acm-env:status` — health dashboard command
- [x] `/acm-env:setup` — smart mode detection setup
- [x] `/acm-env:audit` — deep audit with plugin delegation
- [x] `/acm-env:reset` — interactive reset wizard
- [x] SessionStart hook — <100ms drift detection
- [x] env-auditor skill — natural language trigger
- [x] check-deps.sh — dependency availability checker
- [x] ACM artifact updates (taxonomy, context-artifact spec, stages spec)

### Debrief Improvements (2026-01-29)
- [x] B1: Hardened start-develop-prompt.md (v2.0.0) — explicit STOP gate, registry query, phase boundary protocol
- [x] B3: Phase boundary protocol added to ACM-DEVELOP-SPEC.md (v1.2.0) — agent-driven `/clear` + re-read + confirm
- [x] B4: Review scoring across all 6 review prompts — Critical/High/Low severity, min 2 max 10 cycles, stop at zero C+H
- [x] B17: ACM-ENVIRONMENT-SPEC.md (v1.0.0) — six primitives, two-layer model, physical layout
- [x] BACKLOG.md created with 22 tracked items
- [x] KB/REVIEW-CYCLE-GUIDANCE.md updated to v2.0.0
- [x] Capability registry extraction brief created (`docs/inbox/capabilities-registry-brief.md`)

### Infrastructure
- [x] Stubs folder for init script
- [x] Init script updated
- [x] Experiment folder with Ralph validation

## What's Next

See `BACKLOG.md` for full backlog. Immediate priorities:

### In Progress (separate agent)
- [ ] B2: Extract capability registry → `~/code/_shared/capabilities-registry/` (brief at `docs/inbox/capabilities-registry-brief.md`)

### Next Up (medium priority — start here)
- [ ] B5: Prompt output — emit ready-to-copy commands with resolved paths
- [ ] B6: Ralph Loop command reliability — audit for path issues
- [ ] B7: Full prompt audit — all develop-stage prompts for stale paths and assumptions
- [ ] B8: Update "commands" → "skills" terminology across all specs (per Claude Code 2.1.3)

### After That
- [ ] B10: Wire acm-env → capabilities-registry (blocked by B2)
- [ ] B15: Deliver stage spec
- [ ] B18-B19: Memory layer spec and scaffold

## Pending Decisions

- Rename consideration: "Agentic Development Environment" — deferred until acm-env proves concept

## Blockers

- None

## Session Log

| Date | Summary |
|------|---------|
| 2026-01-27 | Discover stage complete. Two-phase review validated. YAGNI integrated. Ready for Design stage spec. |
| 2026-01-28 | Design and Develop stage specs complete. Supporting specs updated. |
| 2026-01-29 | Brainstormed and implemented acm-env plugin. Created ACM-ENV-SPEC.md. Built full plugin scaffold with 4 commands, SessionStart hook, env-auditor skill, baseline.yaml, and dependency checker. Updated ACM-TAXONOMY.md (environment terms + 8 design decisions), ACM-CONTEXT-ARTIFACT-SPEC.md (replaced deferred acm-validate/acm-prune with acm-env reference), ACM-STAGES-SPEC.md (added acm-env as meta layer manager). |
| 2026-01-29 | Develop stage debrief session. Defined environment layer architecture (six primitives: orchestration, capabilities, knowledge, memory, maintenance, validation). Created ACM-ENVIRONMENT-SPEC.md, BACKLOG.md. Completed B1 (hardened start-develop prompt v2.0.0), B3 (phase boundary protocol in develop spec v1.2.0), B4 (review scoring across all 6 prompts — Critical/High/Low, min 2 max 10 cycles). Created capabilities-registry extraction brief for separate agent. Researched Claude Code 2.1.3 (commands folded into skills). Analyzed agent-harness sync system. Key decisions: registry as peer repo, memory as own repo, knowledge stays in ACM, workers are skills not separate repo, vendor is metadata not folder structure. |

---

## Notes for Next Session

B1/B3/B4/B17 are done. B2 (capability registry extraction) is being worked by a separate agent using the brief at `docs/inbox/capabilities-registry-brief.md`.

**Start with B5-B8** (medium priority prompt and terminology updates):
1. B5: Review all prompts — ensure they emit ready-to-copy commands with resolved paths (no `[PLACEHOLDER]` that forces manual editing)
2. B6: Audit Ralph Loop command invocations across all prompts for path reliability
3. B7: Full audit of all develop-stage prompts for stale paths, assumptions, outdated references
4. B8: Update "commands" → "skills" terminology across all ACM specs and prompts (Claude Code 2.1.3 merged commands into skills)

Reference files:
- `BACKLOG.md` — full backlog with status
- `ACM-ENVIRONMENT-SPEC.md` — environment layer architecture
- `kb/README.md` — recently addressed items from debrief
