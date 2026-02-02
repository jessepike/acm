---
type: "tracking"
description: "ADF backlog — prioritized queue of potential work items"
version: "2.1.0"
updated: "2026-02-02"
scope: "adf"
lifecycle: "reference"
location: "adf/BACKLOG.md"
spec: "ADF-BACKLOG-SPEC.md"
---

# ADF Backlog

## Queue

| ID | Item | Type | Component | Pri | Size | Stage | Status |
|----|------|------|-----------|-----|------|-------|--------|
| B62 | Execute-plan orchestration skill — implementation (7 phases: Core Orchestrator → Ralph Loop Integration → Phase Validator → Parallelization → TDD → Traceability → CLI). Design v0.2 approved (docs/adf/execute-plan-design.md). Validation target: link-triage-pipeline Phase 1 (13 tasks → 13 commits). | New skill | orchestration | P1 | L | Develop | Pending |
| B59 | Review function tuning sprint — run 10-20 reviews, log observations in KB, tune prompts/config. Tracking: `kb/EXTERNAL-REVIEW-MODEL-RELIABILITY.md` | Enhancement | Review | P1 | M | Develop | In Progress |
| B44 | Standardize brief frontmatter `status` field to use stage-based values (`discover-complete`, `design-in-progress`, etc.) — let ADF MCP server surface pipeline position via `check_project_health` | Enhancement | ACM | P2 | M | — | Pending |
| B45 | Stage transition cleanup process — when a sub-project completes a stage or the docs/ workspace shifts to a new sub-project, archive previous stage artifacts to `_archive/{project-name}/`. Define convention in ADF-STAGES-SPEC or ADF-FOLDER-STRUCTURE-SPEC. | Enhancement | ACM | P2 | S | — | Pending |
| B18 | Design memory layer spec (MEMORY-SPEC.md) | New spec | memory | P2 | L | — | Pending |
| B19 | Scaffold memory repo at `~/code/_shared/memory/` | Setup | memory | P2 | S | — | Pending |
| B41 | Move ADF-*-SPEC.md + ADF-TAXONOMY.md into docs/specs/ — update all 40+ file references | Refactor | ACM | P2 | M | — | Pending |
| B48 | Create hooks for phase boundary commit + tasks.md enforcement | Enhancement | acm-env | P2 | M | — | Pending |
| B36 | ADF MCP server — maintenance primitive not addressed in tool surface | Enhancement | acm-server | P3 | S | — | Pending |
| B38 | Connect self-improvement loop to MCP server brief — document which steps are covered vs deferred to memory/KB | Docs | ACM | P3 | S | — | Pending |
| B58 | Add revision history section to all stage specs (DISCOVER, DESIGN, STAGES, ARCHITECTURE) for consistency with DEVELOP | Enhancement | ACM | P3 | S | — | Pending |
| B20 | Evaluate extracting Knowledge (kb/) from ADF into own repo | Architecture | ACM/kb | P3 | M | — | Pending |
| B21 | Automated self-improvement loop (capture → distill → apply) | Architecture | memory + kb | P3 | L | — | Pending |
| B22 | Community knowledge ingestion pipeline | Architecture | kb | P3 | L | — | Pending |
| B64 | Rename acm-env plugin to adf-env — update plugin.json, directory name, command prefixes (/acm-env:* → /adf-env:*), baseline.yaml references, consumer documentation. Breaking change for users. | Refactor | acm-env | P2 | M | — | Pending |
| B65 | Rename acm-review plugin to adf-review — update plugin.json, directory name, command prefixes (/acm-review:* → /adf-review:*), .claude/rules/review-process.md references. Breaking change for users. | Refactor | acm-review | P2 | M | — | Pending |
| B66 | Update consumer projects after plugin renames — link-triage-pipeline, capabilities-registry, and any other projects using acm-env or acm-review commands need updated command references. | Maintenance | ecosystem | P2 | S | — | Pending |

---

## Archive

| ID | Item | Completed | Notes |
|----|------|-----------|-------|
| B60 | Create start-discover-prompt.md | 2026-02-02 | Created entry-point prompt for Discover stage v1.0.0. Parallel to start-design/develop/deliver prompts. Covers project setup validation, state update, context loading, and exploration phase initiation. |
| B61 | Reorder Develop HARD GATE | 2026-02-02 | Fixed HARD GATE placement in ADF-DEVELOP-SPEC.md v2.1.0. Moved from after Phase 3 to after Phase 4 (Review Loop). Phase 4 now "Review Loop & Approval" combining internal/external review + human approval. Correct pattern: Plan → Review → HARD GATE → Execution (matches Deliver spec). Updated start-develop-prompt.md to v2.2.0. |
| B39 | Add deliver enum support to ADF MCP server | 2026-02-02 | Added "deliver" to get_stage, get_review_prompt, get_transition_prompt enums. Updated STAGE_FILES, PROMPT_MAP, TRANSITION_FILES mappings. Added develop_to_deliver transition validation. Rebuilt MCP server, 58/59 tests passing. |
| B51 | Update ADF MCP server get_stage enum to include deliver | 2026-02-02 | Completed with B39 — same changeset. get_stage now accepts "deliver" and serves ADF-DELIVER-SPEC.md. |
| B15 | Deliver stage spec | 2026-02-02 | ADF-DELIVER-SPEC.md v1.0.0 — 8 phases with Review → HARD GATE → Execution pattern (corrected from Develop), 3-tier testing model (automated, browser, manual), project-type specific guidance, deployment focus. Created 3 prompts: start-deliver-prompt.md, deliver-ralph-review-prompt.md, deliver-external-review-prompt.md. Also added B61 (fix Develop HARD GATE placement). Unblocks B39 + B51 (ACM MCP server deliver enum support). |
| B55 | Universal exit criteria + stage boundary handoff in DISCOVER-SPEC | 2026-02-01 | v1.3.0 — structured exit criteria (universal + discover-specific), handoff protocol, docs/adf/ convention, updated references. |
| B56 | Universal exit criteria + stage boundary handoff in DESIGN-SPEC | 2026-02-01 | v1.1.0 — structured exit criteria (universal + design-specific + type-specific), handoff protocol, docs/adf/ convention, updated references. |
| B57 | docs/adf/ convention in DISCOVER-SPEC and DESIGN-SPEC | 2026-02-01 | Planning Artifacts Convention section added to both specs. |
| B46 | Update start-develop-prompt.md for Phase 7-8 + testing | 2026-02-01 | v2.1.0 — added Phase 7 (Documentation) + Phase 8 (Closeout), two-tier testing model, build-to-design verification, docs/adf/ paths, commit cadence. |
| B47 | Update develop-ralph-review-prompt.md for testing strategy | 2026-02-01 | v3.1.0 — expanded Testing Strategy to two-tier model + project-type checks, added Build-to-Design Verification dimension, fixed artifact paths to docs/adf/. |
| B37 | Align "meta layer" → "environment layer" terminology | 2026-02-01 | Updated 5 files (ENV-PLUGIN-SPEC, STATUS-SPEC, STAGES-SPEC, 2 visual prompts). 11 instances replaced. Historical references in status.md and _archive/ left as-is. |
| B53 | Slim review-process.md to enforcement-only | 2026-02-01 | Reduced from 53 lines to 14. Removed prompt map, invocation syntax, cycle counts — all handled by acm-review plugin. |
| B52 | Unified review skill (acm-review plugin) | 2026-02-01 | 3 commands: artifact (full P1→P2), artifact-internal (P1), artifact-external (P2). Plugin registered under acm-plugins marketplace. |
| B54 | Elevate ADF-ARCHITECTURE-SPEC.md to master framework spec v2.0.0 | 2026-02-01 | Spec map, framework diagram, stages overview, artifact flow, interface map, spec index. Reviewed to v2.0.1 (memory marked planned, primitive assignments corrected). |
| B14 | Automated multi-model review orchestration (external-review skill + MCP server) | 2026-02-01 | Build complete: 34 tests, 2 MCP tools, 2 providers, config loading, path validation. acm-review plugin created with 3 commands. Pending: B59 tuning sprint, then closeout. |
| B34 | MCP Server Registry — evaluate and register MCP tools | 2026-01-31 | REGISTRY-SPEC.md v1.2.0, 4 plugin-bundled MCPs, baseline v2.1.0, refresh+setup extended, first triage (500+ scanned, 0 high-relevance). |
| B40 | Update ADF-STAGES-SPEC.md environment layer references | 2026-01-31 | ADF MCP server added alongside acm-env. |
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
| B17 | Document environment layer architecture | 2026-01-29 | ADF-ARCHITECTURE-SPEC.md created (originally ADF-ENVIRONMENT-SPEC.md, renamed 2026-01-31). |
| B4 | Review scoring — diminishing returns | 2026-01-29 | Severity: Critical/High/Low. Stop at zero C+H. Min 2, max 10. |
| B3 | Phase boundary protocol | 2026-01-29 | ADF-DEVELOP-SPEC.md v1.2.0. Agent-driven /clear + re-read + confirm. |
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
