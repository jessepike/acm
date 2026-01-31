---
type: "tracking"
description: "ACM backlog — prioritized queue of potential work items"
version: "2.0.0"
updated: "2026-01-31"
scope: "acm"
lifecycle: "reference"
location: "acm/BACKLOG.md"
spec: "ACM-BACKLOG-SPEC.md"
---

# ACM Backlog

## Queue

| ID | Item | Type | Component | Pri | Size | Stage | Status |
|----|------|------|-----------|-----|------|-------|--------|
| B42 | Structured session handoff spec — define a parseable handoff format that agents produce at phase boundaries so next session can auto-orient (read order, what's done, build notes, remaining work) | Enhancement | ACM | P1 | M | — | Pending |
| B43 | Automated phase transitions — agent completes phase → commit → produce handoff → `/clear` → next session auto-resumes from handoff without human prompting. Extends Phase Boundary Protocol in ACM-DEVELOP-SPEC.md | Enhancement | ACM | P1 | L | — | Pending |
| B35 | Agents not consulting capabilities-registry before installing capabilities — review process and diagnose why | Bug | acm-env | P1 | M | — | Pending |
| B34 | Evaluate MCP tools for environment — memory-mcp, filesystem-mcp, sequentialthinking-mcp, everything-mcp | Enhancement | acm-env | P1 | M | — | Pending |
| B44 | Standardize brief frontmatter `status` field to use stage-based values (`discover-complete`, `design-in-progress`, etc.) — let ACM MCP server surface pipeline position via `check_project_health` | Enhancement | ACM | P2 | M | — | Pending |
| B15 | Deliver stage spec | New spec | ACM | P2 | M | — | Pending |
| B18 | Design memory layer spec (MEMORY-SPEC.md) | New spec | memory | P2 | L | — | Pending |
| B19 | Scaffold memory repo at `~/code/_shared/memory/` | Setup | memory | P2 | S | — | Pending |
| B36 | ACM MCP server — maintenance primitive not addressed in tool surface | Enhancement | acm-server | P3 | S | — | Pending |
| B37 | Align "meta layer" → "environment layer" terminology across all specs and prompts | Terminology | ACM | P2 | M | — | Pending |
| B38 | Connect self-improvement loop to MCP server brief — document which steps are covered vs deferred to memory/KB | Docs | ACM | P3 | S | — | Pending |
| B39 | Add `deliver` enum support to ACM MCP server once ACM-DELIVER-SPEC.md is created | Enhancement | acm-server | P2 | S | — | Blocked by B15 |
| B40 | Update ACM-STAGES-SPEC.md environment layer references to include ACM MCP server alongside acm-env | Docs | ACM | P2 | S | — | Done |
| B41 | Move ACM-*-SPEC.md + ACM-TAXONOMY.md into docs/specs/ — update all 40+ file references | Refactor | ACM | P2 | M | — | Pending |
| B14 | Automated multi-model review orchestration (external-review skill) | Architecture | ACM | P3 | L | Design | Pending |
| B20 | Evaluate extracting Knowledge (kb/) from ACM into own repo | Architecture | ACM/kb | P3 | M | — | Pending |
| B21 | Automated self-improvement loop (capture → distill → apply) | Architecture | memory + kb | P3 | L | — | Pending |
| B22 | Community knowledge ingestion pipeline | Architecture | kb | P3 | L | — | Pending |

---

## Archive

| ID | Item | Completed | Notes |
|----|------|-----------|-------|
| B33 | Environment cleanup — remove cruft plugins, legacy commands, fix upstream URLs | 2026-01-30 | Removed superpowers/example-skills/serena. Deleted 3 legacy commands. Disabled frontend-design/context7/playwright at user level. |
| B32 | Plugin baseline governance — baseline.yaml v2.0.0 | 2026-01-30 | Required (6), available (15), remove (3) plugin lists. Reset command extended with plugin checking. |
| B31 | `declined.yaml` — blocklist for evaluated-and-rejected capabilities | 2026-01-30 | 15 entries. Integrated into sync pipeline. |
| B30 | Fix 4 registry scripts | 2026-01-30 | check-freshness: URL parsing + macOS timeout. sync: skip active + declined. promote: pipefail fix. 6 upstream URLs corrected. |
| B29 | `/acm-env:capabilities` command | 2026-01-30 | Registry lookup showing install level, status, and install-level guidance. |
| B28 | `/acm-env:refresh` command | 2026-01-30 | 10-step orchestration: snapshot → sync → declined → freshness → staging → summary → promote → decline → regenerate. |
| B26 | Trim ~/.claude/CLAUDE.md to ≤55 lines | 2026-01-30 | Removed Key Artifacts table, compressed Artifact Lifecycle callouts. |
| B27 | Delete docs/inbox/capability-registry-brief.md | 2026-01-30 | B2 complete, ephemeral lifecycle. |
| B25 | Audit action workflow | 2026-01-30 | Post-audit prompt with option to add to backlog or take action. |
| B24 | Registry model — install levels and plugin scoping | 2026-01-30 | Added `install_id` and `install_level` to REGISTRY-SPEC.md and all plugin capability.yaml files. |
| B23 | Register untracked marketplace plugins | 2026-01-30 | 19 plugins total. Registry grew from 21→39 capabilities. |
| B12 | Auto-update from upstream | 2026-01-30 | `/acm-env:refresh` orchestrates sync → freshness → staging → promote workflow. |
| B17 | Document environment layer architecture | 2026-01-29 | ACM-ARCHITECTURE-SPEC.md created (originally ACM-ENVIRONMENT-SPEC.md, renamed 2026-01-31). |
| B4 | Review scoring — diminishing returns | 2026-01-29 | Severity: Critical/High/Low. Stop at zero C+H. Min 2, max 10. |
| B3 | Phase boundary protocol | 2026-01-29 | ACM-DEVELOP-SPEC.md v1.2.0. Agent-driven /clear + re-read + confirm. |
| B1 | Harden start-develop prompt | 2026-01-29 | start-develop-prompt.md v2.0.0. Explicit STOP language, registry query, phase boundary protocol. |
| B2 | Extract capability registry | 2026-01-29 | 21 capabilities migrated. Pushed to github.com/jessepike/capabilities-registry. |
| B5 | Prompt output — resolved paths | 2026-01-29 | All prompts emit ready-to-copy commands. |
| B6 | Ralph Loop command reliability | 2026-01-29 | Usage sections added, run scripts created. |
| B7 | Full prompt audit | 2026-01-29 | Fixed stale registry paths and bare spec references. |
| B8 | Commands → skills terminology | 2026-01-29 | Updated across specs, brief, experiments. |
| B9 | REGISTRY-SPEC.md | 2026-01-29 | Part of B2. 4 types, tags, capability.yaml schema, lifecycle, data flow. |
| B10 | Wire acm-env → capabilities-registry | 2026-01-29 | start-develop-prompt.md points to INVENTORY.md for capability assessment. |
| B11 | Inventory generation script | 2026-01-29 | Part of B2. capability.yaml → inventory.json → INVENTORY.md. |
| B16 | Archive agent-harness | 2026-01-29 | Registry extraction complete, agent-harness disconnected. |
