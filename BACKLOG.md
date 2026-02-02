---
type: "tracking"
description: "ACM backlog — prioritized queue of potential work items"
version: "2.0.0"
updated: "2026-02-01"
scope: "acm"
lifecycle: "reference"
location: "acm/BACKLOG.md"
spec: "ACM-BACKLOG-SPEC.md"
---

# ACM Backlog

## Queue

| ID | Item | Type | Component | Pri | Size | Stage | Status |
|----|------|------|-----------|-----|------|-------|--------|
| B59 | Review function tuning sprint — run 10-20 reviews, log observations in KB, tune prompts/config. Tracking: `kb/EXTERNAL-REVIEW-MODEL-RELIABILITY.md` | Enhancement | Review | P1 | M | Develop | In Progress |
| B52 | Unified review skill — single skill wrapping internal (Ralph Loop) + external (MCP server) as two phases. Replaces separate external-review skill. | Enhancement | ACM | P1 | M | — | Pending |
| B53 | Slim rules/review-process.md to enforcement-only (~10 lines) — move mechanism details (prompt map, invocation syntax, cycle counts) into review skill | Enhancement | ACM | P1 | S | — | Blocked by B52 |
| B44 | Standardize brief frontmatter `status` field to use stage-based values (`discover-complete`, `design-in-progress`, etc.) — let ACM MCP server surface pipeline position via `check_project_health` | Enhancement | ACM | P2 | M | — | Pending |
| B45 | Stage transition cleanup process — when a sub-project completes a stage or the docs/ workspace shifts to a new sub-project, archive previous stage artifacts to `_archive/{project-name}/`. Define convention in ACM-STAGES-SPEC or ACM-FOLDER-STRUCTURE-SPEC. | Enhancement | ACM | P2 | S | — | Pending |
| B15 | Deliver stage spec | New spec | ACM | P2 | M | — | Pending |
| B18 | Design memory layer spec (MEMORY-SPEC.md) | New spec | memory | P2 | L | — | Pending |
| B19 | Scaffold memory repo at `~/code/_shared/memory/` | Setup | memory | P2 | S | — | Pending |
| B37 | Align "meta layer" → "environment layer" terminology across all specs and prompts | Terminology | ACM | P2 | M | — | Pending |
| B39 | Add `deliver` enum support to ACM MCP server once ACM-DELIVER-SPEC.md is created | Enhancement | acm-server | P2 | S | — | Blocked by B15 |
| B41 | Move ACM-*-SPEC.md + ACM-TAXONOMY.md into docs/specs/ — update all 40+ file references | Refactor | ACM | P2 | M | — | Pending |
| B46 | Update start-develop-prompt.md for Phase 7-8 + testing emphasis | Enhancement | Prompts | P2 | S | — | Pending |
| B47 | Update develop-ralph-review-prompt.md to check testing strategy in plan | Enhancement | Prompts | P2 | S | — | Pending |
| B48 | Create hooks for phase boundary commit + tasks.md enforcement | Enhancement | acm-env | P2 | M | — | Pending |
| B51 | Update ACM MCP server get_stage enum to include 'deliver' once spec exists | Enhancement | acm-server | P2 | S | — | Blocked by B15 |
| B55 | Add universal exit criteria reference + stage boundary handoff to ACM-DISCOVER-SPEC.md (align with DEVELOP pattern) | Enhancement | ACM | P2 | S | — | Pending |
| B56 | Add universal exit criteria reference + stage boundary handoff to ACM-DESIGN-SPEC.md (align with DEVELOP pattern) | Enhancement | ACM | P2 | S | — | Pending |
| B57 | Add docs/acm/ convention acknowledgment to ACM-DISCOVER-SPEC.md and ACM-DESIGN-SPEC.md | Enhancement | ACM | P2 | S | — | Pending |
| B36 | ACM MCP server — maintenance primitive not addressed in tool surface | Enhancement | acm-server | P3 | S | — | Pending |
| B38 | Connect self-improvement loop to MCP server brief — document which steps are covered vs deferred to memory/KB | Docs | ACM | P3 | S | — | Pending |
| B58 | Add revision history section to all stage specs (DISCOVER, DESIGN, STAGES, ARCHITECTURE) for consistency with DEVELOP | Enhancement | ACM | P3 | S | — | Pending |
| B60 | Create start-discover-prompt.md — entry-point prompt for Discover stage, parallel to Design/Develop | Enhancement | Prompts | P3 | S | — | Pending |
| B20 | Evaluate extracting Knowledge (kb/) from ACM into own repo | Architecture | ACM/kb | P3 | M | — | Pending |
| B21 | Automated self-improvement loop (capture → distill → apply) | Architecture | memory + kb | P3 | L | — | Pending |
| B22 | Community knowledge ingestion pipeline | Architecture | kb | P3 | L | — | Pending |

---

## Archive

| ID | Item | Completed | Notes |
|----|------|-----------|-------|
| B54 | Elevate ACM-ARCHITECTURE-SPEC.md to master framework spec v2.0.0 | 2026-02-01 | Spec map, framework diagram, stages overview, artifact flow, interface map, spec index. Reviewed to v2.0.1 (memory marked planned, primitive assignments corrected). |
| B14 | Automated multi-model review orchestration (external-review skill + MCP server) | 2026-02-01 | Build complete: 34 tests, 2 MCP tools, 2 providers, config loading, path validation. acm-review plugin created with 3 commands. Pending: B59 tuning sprint, then closeout. |
| B34 | MCP Server Registry — evaluate and register MCP tools | 2026-01-31 | REGISTRY-SPEC.md v1.2.0, 4 plugin-bundled MCPs, baseline v2.1.0, refresh+setup extended, first triage (500+ scanned, 0 high-relevance). |
| B40 | Update ACM-STAGES-SPEC.md environment layer references | 2026-01-31 | ACM MCP server added alongside acm-env. |
| B42 | Structured session handoff (merged B43) | 2026-01-31 | Handoff block in tasks.md, Phase Boundary Protocol v1.3.0, tasks.md stub, start-develop-prompt updated. |
| B35 | Registry consultation enforcement | 2026-01-31 | Required Registry Summary section in capabilities.md. Start-develop prompt uses MUST language + completeness gate. |
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
