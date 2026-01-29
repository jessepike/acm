---
type: "tracking"
description: "ACM backlog — improvements, enhancements, and future work"
version: "1.0.0"
updated: "2026-01-29"
scope: "acm"
lifecycle: "reference"
location: "acm/BACKLOG.md"
---

# ACM Backlog

## Active — High Priority

| ID | Item | Type | Component | Status |
|----|------|------|-----------|--------|
| B1 | Harden start-develop prompt — enforce STOP gate after planning phases | Prompt fix | ACM/prompts | Done |
| B2 | Extract capability registry from agent-harness → `~/code/_shared/capabilities-registry/` | Mini-project | capabilities-registry | Scoping complete |
| B3 | Phase boundary protocol — agent-driven `/clear` + re-read artifacts + confirm transition | Spec update | ACM-DEVELOP-SPEC | Done |
| B4 | Review scoring — diminishing returns detection (Critical/High/Low, min 2, max 10 cycles) | Spec + prompt | All stages | Done |
| B9 | Create REGISTRY-SPEC.md (types, tags taxonomy, .meta.yaml schema, lifecycle) | Spec | capabilities-registry | Part of B2 |
| B10 | Wire acm-env → capabilities-registry (develop spec Phase 2 points to INVENTORY.md) | Spec + prompt | ACM + registry | Blocked by B2 |
| B11 | Inventory generation script (inventory.json → INVENTORY.md, single source of truth) | Script | capabilities-registry | Part of B2 |
| B17 | Document environment layer architecture (six primitives, two layers) | Spec | ACM | Done (ACM-ENVIRONMENT-SPEC.md) |

## Active — Medium Priority

| ID | Item | Type | Component | Status |
|----|------|------|-----------|--------|
| B5 | Prompt output — emit ready-to-copy commands with resolved paths | Prompt improvement | ACM/prompts | Done |
| B6 | Ralph Loop command reliability — audit for path issues | Prompt fix | ACM/prompts | Done |
| B7 | Full prompt audit — all develop-stage prompts for stale paths and assumptions | Maintenance | ACM/prompts | Done |
| B8 | Update "commands" terminology → "skills" across all specs (per Claude Code 2.1.3) | Spec update | ACM | Pending |
| B15 | Deliver stage spec | New spec | ACM | Pending |
| B18 | Design memory layer spec (MEMORY-SPEC.md) | New spec | memory | Pending |
| B19 | Scaffold memory repo at `~/code/_shared/memory/` | Setup | memory | Pending |

## Future — Low Priority

| ID | Item | Type | Component | Status |
|----|------|------|-----------|--------|
| B12 | Auto-update from upstream sources (maintenance automation for registry) | Enhancement | capabilities-registry | Future |
| B13 | Add 2-3 community sources to registry sync | Enhancement | capabilities-registry | Future |
| B14 | Automated multi-model review orchestration | Architecture | ACM | Future |
| B16 | Archive agent-harness (after registry extraction complete) | Cleanup | agent-harness | After B2 |
| B20 | Evaluate extracting Knowledge (kb/) from ACM into own repo | Architecture review | ACM/kb | Future |
| B21 | Automated self-improvement loop (capture → distill → apply) | Architecture | memory + kb | Future |
| B22 | Community knowledge ingestion pipeline | Architecture | kb | Future |

---

## Completed

| ID | Item | Completed | Notes |
|----|------|-----------|-------|
| B17 | Document environment layer architecture | 2026-01-29 | ACM-ENVIRONMENT-SPEC.md created |
| B4 | Review scoring — diminishing returns | 2026-01-29 | Updated all 6 review prompts + KB entry. Severity: Critical/High/Low. Stop at zero C+H. Min 2, max 10. |
| B3 | Phase boundary protocol | 2026-01-29 | Added to ACM-DEVELOP-SPEC.md v1.2.0. Agent-driven /clear + re-read + confirm. |
| B1 | Harden start-develop prompt | 2026-01-29 | start-develop-prompt.md v2.0.0. Explicit STOP language, registry query, phase boundary protocol. |
