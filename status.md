---
project: "ACM (Agentic Context Management)"
stage: "Develop"
updated: "2026-01-31"
---

# Status

## Current State

- **Stage:** Develop (ACM framework itself)
- **Focus:** ACM MCP server — Develop Phase 6 (Build) — all phases complete
- **Sub-project:** ACM MCP Server — 13 tools, 59 tests, companion skill, consumer wiring, README — all done

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
- [x] ACM-ENV-PLUGIN-SPEC.md (v1.0.0)
- [x] ACM-ARCHITECTURE-SPEC.md (v1.1.0) — framework architecture (six primitives, two layers). Renamed from ACM-ENVIRONMENT-SPEC.md.
- [x] ACM-RULES-SPEC.md (v1.0.0) — `.claude/rules/` enforcement layer, governance model
- [x] ACM-REVIEW-SPEC.md (v1.0.0) — two-phase review mechanism, cycle rules, severity, YAGNI enforcement

### acm-env Plugin (v1.1.0)
- [x] Plugin scaffold (`~/.claude/plugins/acm-env/`)
- [x] plugin.json manifest
- [x] baseline.yaml v2.0.0 — plugin governance with required/available/remove lists
- [x] `/acm-env:status` — health dashboard command
- [x] `/acm-env:setup` — smart mode detection setup
- [x] `/acm-env:audit` — deep audit with plugin delegation
- [x] `/acm-env:reset` — interactive reset wizard (now with plugin + command checking)
- [x] `/acm-env:refresh` — upstream sync orchestrator with declined workflow
- [x] `/acm-env:capabilities` — registry lookup for agents/users
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

### Prompt & Terminology Cleanup (2026-01-29)
- [x] B5: All prompts emit ready-to-copy commands with resolved paths — ralph-review uses `~/code/_shared/acm/`, external review prompts have `sed | pbcopy` assembly commands
- [x] B6: Ralph Loop command audit — added Usage sections to design-ralph and develop-ralph prompts, created `run-discover-review.sh` and `run-develop-review.sh` scripts, fixed experiment placeholder paths
- [x] B7: Full prompt audit — fixed stale registry path in develop-artifact-correction-prompt, resolved bare spec reference in start-design-prompt
- [x] B8: Updated "commands" → "skills" terminology across ACM-ENV-SPEC, ACM-CONTEXT-ARTIFACT-SPEC, ACM-TAXONOMY, capability-registry brief, experiment docs

### Infrastructure
- [x] Stubs folder for init script
- [x] Init script updated
- [x] Experiment folder with Ralph validation

## What's Next

See `BACKLOG.md` for full backlog. Immediate priorities:

### Recently Completed
- [x] B23: Registered 19 plugins in capabilities-registry (21→39 capabilities)
- [x] B24: Install levels defined (`install_id`, `install_level` fields in REGISTRY-SPEC.md)
- [x] B28: `/acm-env:refresh` command — upstream sync with declined workflow
- [x] B29: `/acm-env:capabilities` command — registry lookup
- [x] B30: Fixed 4 registry scripts (check-freshness, sync, promote, generate-inventory)
- [x] B31: `declined.yaml` — 15 entries, integrated into sync pipeline
- [x] B32: baseline.yaml v2.0.0 — plugin governance with required/available/remove
- [x] B33: Environment cleanup — removed cruft plugins, legacy commands, fixed upstream URLs

### B34: MCP Server Registry (2026-01-31)
- [x] WP1: Registry schema + sources (REGISTRY-SPEC.md v1.2.0 — install_vector, parent_plugin, transport, 3 community sources)
- [x] WP2: Registry entries (4 legacy MCPs deleted + declined, 4 plugin-bundled MCPs created)
- [x] WP3: Baseline extension (v2.1.0 — mcp_servers sections at user + project level)
- [x] WP4: Extend refresh command (MCP community scan + triage production)
- [x] WP5: Extend setup command (MCP server checks section)
- [x] WP7: Regenerate inventory (39 capabilities, 4 new MCP tools)
- [x] WP6: First triage report (scanned 3 sources, 500+ servers reviewed, 0 high-relevance)

### Next Up
- [ ] B35: Deep dive — agents capability type (P1, L)
- [ ] B36: Deep dive — skills catalog leverage (P1, L)
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
| 2026-01-29 | Brainstormed and implemented acm-env plugin. Created ACM-ENV-PLUGIN-SPEC.md. Built full plugin scaffold with 4 commands, SessionStart hook, env-auditor skill, baseline.yaml, and dependency checker. Updated ACM-TAXONOMY.md (environment terms + 8 design decisions), ACM-CONTEXT-ARTIFACT-SPEC.md (replaced deferred acm-validate/acm-prune with acm-env reference), ACM-STAGES-SPEC.md (added acm-env as meta layer manager). |
| 2026-01-29 | Develop stage debrief session. Defined environment layer architecture (six primitives: orchestration, capabilities, knowledge, memory, maintenance, validation). Created ACM-ENVIRONMENT-SPEC.md, BACKLOG.md. Completed B1 (hardened start-develop prompt v2.0.0), B3 (phase boundary protocol in develop spec v1.2.0), B4 (review scoring across all 6 prompts — Critical/High/Low, min 2 max 10 cycles). Created capabilities-registry extraction brief for separate agent. Researched Claude Code 2.1.3 (commands folded into skills). Analyzed agent-harness sync system. Key decisions: registry as peer repo, memory as own repo, knowledge stays in ACM, workers are skills not separate repo, vendor is metadata not folder structure. |
| 2026-01-29 | Completed B5-B8 (prompt and terminology cleanup). All prompts now emit ready-to-copy commands with resolved paths. Ralph Loop usage sections added to all 3 stage prompts with matching run scripts. Stale registry paths and bare spec references fixed. "Commands" → "skills" terminology updated across ACM-ENV-SPEC, ACM-CONTEXT-ARTIFACT-SPEC, ACM-TAXONOMY, capability-registry brief, and experiment docs. |
| 2026-01-29 | Built acm-env plugin (all 8 phases) and capabilities registry. acm-env: plugin scaffold, 4 commands (status/setup/audit/reset), SessionStart hook, env-auditor skill, check-deps.sh with git freshness. Capabilities registry: migrated 20 capabilities from agent-harness (16 skills + 4 tools) + acm-env plugin = 21 total. capability.yaml as source of truth, generate-inventory.sh pipeline, REGISTRY-SPEC.md. Both repos pushed to GitHub (jessepike/acm, jessepike/capabilities-registry). Renamed capability-registry → capabilities-registry everywhere. Key decisions: plugins as 4th capability type, registry consumed by all stages, capability.yaml → inventory.json → INVENTORY.md data flow. Agent-harness ready to archive (B16). |
| 2026-01-30 | Fixed and installed acm-env plugin via local marketplace. Plugin had 3 issues: plugin.json had invalid fields (author as string, commands array), hooks.json used array instead of record, plugin was never registered through marketplace system. Created `acm-plugins` local marketplace at `~/.claude/plugins/acm-plugins/`, moved plugin source inside, registered and installed. Fixed check-deps.sh to query installed_plugins.json instead of filesystem paths. Fixed hardcoded paths in all 4 commands. Rewrote audit.md with explicit delegation to claude-md-management (CLAUDE.md quality scoring) and claude-code-setup (automation recommendations) — "You MUST delegate" pattern replacing vague "if available, delegate". Added capabilities registry validation to audit (cross-references INVENTORY.md against installed plugins). Assessed spec vs intent alignment — spec is sound, implementation had gaps in delegation and registry integration. Created KB articles: CUSTOM-PLUGIN-INSTALLATION.md, PLUGIN-DEVELOPMENT-PATTERNS.md. |
| 2026-01-30 | Ran `/acm-env:audit` end-to-end with delegation. Both dependency plugins (claude-md-management, claude-code-setup) successfully invoked — no fallbacks needed. Audit found 7 recommendations: fixed acm-env path in .claude/CLAUDE.md, trimmed global CLAUDE.md from 73→60 lines (B26), fixed 4 stale `ack-src/acm/` location paths in spec frontmatter, added frontmatter to DESIGN-HANDOFF.md, deleted stale inbox item (B27). Registry validation confirmed 7 untracked plugins (B23) and built-in skills model issue (B24). No automation recommendations for this spec/docs project. |
| 2026-01-30 | Massive capabilities registry and environment governance session. Registered 19 plugins total across 3 batches (registry grew 21→39). Added `install_id`/`install_level` to REGISTRY-SPEC.md schema. Defined plugin baseline v2.0.0 (6 required user-level, 15 available project-level, 3 to remove). Cleaned environment: removed superpowers/example-skills/serena, deleted 3 legacy commands (claude-mem, remember, save), disabled frontend-design/context7/playwright at user level. Created 2 new acm-env commands: `/acm-env:refresh` (upstream sync orchestrator) and `/acm-env:capabilities` (registry lookup). Fixed 4 registry scripts: check-freshness.sh (URL parsing + macOS timeout), sync.sh (skip active + declined), promote.sh (pipefail), and 6 upstream URLs. Implemented `declined.yaml` blocklist (15 entries: 3 MCP tools, 3 cruft plugins, 9 unused LSP plugins) integrated into sync pipeline. Researched all Anthropic marketplace plugins and 3 MCP tools. Plugin bumped to v1.1.0. |
| 2026-01-30 | Environment audit and registry cleanup session. Ran full `/acm-env:audit` with both delegations (claude-md-management, claude-code-setup). Found global CLAUDE.md at 60 lines (5 over limit), serena still installed (CLI uninstall failing), no MCP servers configured. Committed all uncommitted capabilities-registry work from prior session (27 files, 18 plugins, declined.yaml, spec fixes). Bumped REGISTRY-SPEC.md to v1.1.0 — fixed directory name typo, added declined section, updated Anthropic source to include plugins, removed stale brief reference. Updated README with declined.yaml and sources. Added B34 (MCP tools eval, P1), B35 (agents deep dive, P1/L), B36 (skills deep dive, P1/L) to backlog. Both repos pushed to GitHub. |
| 2026-01-30 | B34 MCP Server Registry — Discover complete, Design draft complete. Discover: drafted brief (brief-b34-mcp-servers.md), 2 internal review cycles, signed off at v1.0. Design: intake clarification (orchestration, interface, scan scope, triage filtering), drafted design-b34-mcp-servers.md v0.1. 7 work packages, extends refresh+setup commands, 3 new capability.yaml fields (install_vector, parent_plugin, transport), 4 plugin-bundled MCP extractions, baseline v3.0.0 schema. **Next: Design internal review (Ralph Loop), then external review, then Develop.** |
| 2026-01-30 | Link Triage Pipeline session. Reviewed PRD and design doc from link-triage repo. Analyzed B22 relationship. Split into two projects: pipeline (link-triage-pipeline) and future KB. Scaffolded link-triage-pipeline with ACM structure (intent, brief, CLAUDE.md). Ran Discover stage: internal review (3 cycles, 3 High resolved), external review (2 reviewers, clean pass, 3 Design questions). Brief at v0.4 status complete. Created ACM-REVIEW-SPEC.md (v1.0.0) — two-phase review mechanism spec (internal mandatory, external user-driven). Added `.claude/rules/review-process.md` — binding rule requiring Ralph Loop plugin for all internal reviews. Refactored all 6 stage review prompts to deduplicate mechanism against spec (-403/+207 lines). **Next: Design stage for link-triage-pipeline in new session.** |
| 2026-01-30 | Rules enforcement layer session. Reviewed Claude Code `.claude/rules/` capability and integrated into ACM. Created `.claude/rules/constraints.md` (security, governance, safety, session discipline, architectural boundaries). Created ACM-RULES-SPEC.md (v1.0.0) — two-layer governance model (rules=policy, CLAUDE.md=guidance), five content categories, file organization, lifecycle. Added rules stub for init script. Updated environment spec (governance model section), taxonomy (rules term + design decision), folder structure spec, global/project CLAUDE.md specs, init script. Added session discipline enforcement: rule requiring auto-commit and status.md updates (no asking), plus acm-env Stop hook (`stop-check.sh`) that blocks session end when uncommitted changes or stale status.md detected. Added hooks governance to baseline.yaml (declared hooks inventory), status dashboard (hooks section with drift detection), and audit command (section 5: hooks governance — scans for undeclared user-level hooks). Updated ACM-ENV-PLUGIN-SPEC.md with Stop hook, hooks governance section, and hooks in user-level baseline. |

| 2026-01-31 | B34 MCP Server Registry — Develop complete. All 7 WPs implemented. REGISTRY-SPEC.md v1.2.0 (3 MCP fields, 3 community sources, inbox). 4 legacy MCPs deleted+declined, 4 plugin-bundled MCPs created. baseline.yaml v2.1.0 (mcp_servers governance). refresh.md extended (community scan + triage). setup.md extended (MCP server checks). Inventory regenerated (39 caps). First triage: 500+ servers scanned, 0 high-relevance. Note: 4 plugin-bundled MCP upstream URLs unreachable (anthropics/claude-code-plugins likely private). |
| 2026-01-31 | Project separation — capabilities registry bootstrapped as independent project (BACKLOG.md, status.md, .claude/CLAUDE.md). Migrated B35→CR-1, B36→CR-2, B13→CR-3 to registry backlog. Archived processed B34 inbox docs. ACM backlog now ACM-scoped only. |
| 2026-01-31 | ACM MCP Server — Develop Phase 6 build complete. All phases A-E done. 13 tools implemented, 59 tests passing, companion skill created (skills/acm-workflow/), consumer wiring (.mcp.json), README. All 9 success criteria verified. |
| 2026-01-31 | Scope-aware status command + environment cleanup. Updated `/acm-env:status` with `--scope` flag (project default, user). Project scope shows user-level foundation + project specifics + capabilities (plugins, MCP servers). User scope shows cross-project config, plugins, MCP servers, hooks. Updated ACM-ENV-PLUGIN-SPEC.md with status command docs. Ran status check — found global CLAUDE.md at 61 lines (removed frontmatter → 52, PASS). Audited MCP server state: 0 standalone user-level, 13 plugin-bundled, 0 project-level for ACM. Identified 6 unwanted plugins with bundled MCP servers (asana, firebase, gitlab, laravel-boost, linear, slack) — added to baseline remove list + declined.yaml (21→27 declined). Clarified status vs inventory separation: status=validation (PASS/FAIL), capabilities=discovery (what's available). |

## Decisions

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | Single `--scope` flag, not two commands | Same conceptual operation at different scopes; less surface area |
| D2 | Project scope is default | Most common use case — "what's affecting my project right now?" |
| D3 | Project view includes user-level as foundation | User-level applies to every project; showing both gives full picture |
| D4 | Add capabilities section (plugins + MCP) to dashboard | Status only checked config files, not actual capability state |
| D5 | Status vs inventory are separate concerns | Status=health check (validation against baseline), capabilities=inventory (enumeration/discovery). Don't merge them. |
| D6 | No user-level standalone MCP servers needed | Plugin-bundled MCPs activate with parent plugin — correct model. No cross-project MCP servers identified yet. |
| D7 | Unwanted marketplace plugins: disable + decline, don't delete | Marketplace auto-syncs external_plugins/; manual deletion gets reversed. Baseline remove list catches accidental enablement. |

## Notes for Next Session

Scope-aware status command complete. Environment cleanup done — 6 unwanted plugins added to baseline remove + declined.yaml. Global CLAUDE.md trimmed to 52 lines (frontmatter removed). Capabilities registry at 39 capabilities, 27 declined entries.

### ACM MCP Server — Design → Develop Transition (2026-01-31)

**Where we are:** Develop stage, Phases 1-3 complete (intake, capability assessment, planning). Planning artifacts produced and committed. Awaiting human approval to begin execution phases (4-6).

**Read order for next session:**
1. `docs/design.md` — Technical spec (v0.3, both reviews done)
2. `docs/plan.md` — 5-phase build plan
3. `docs/tasks.md` — 25 atomic tasks
4. `docs/manifest.md` — Dependencies
5. `docs/capabilities.md` — No gaps, all plugins installed

**What's done:**
- Design v0.3: Phase 1 internal review (5 High fixed), Phase 2 external review (3 High + 1 Medium fixed)
- Intake validation complete, all open items resolved
- manifest.md + capabilities.md approved
- plan.md + tasks.md drafted

**What's next:**
- Human approves planning artifacts → proceed to Phase 4 (Review Loop on plan) → Phase 5 (Environment Setup) → Phase 6 (Build)
- Per ACM-DEVELOP-SPEC: run `/clear`, re-read status → plan → tasks, then begin execution

**Key decisions made this session:**
- Spec version coupling: code comments only (no runtime check)
- Server location: inside `acm/acm-server/` (node_modules gitignored)
- Companion skill: built in same pass

---

**Key files changed this session:**
- `acm-env/commands/status.md` — scope flag, capabilities sections, MCP reporting
- `ACM-ENV-PLUGIN-SPEC.md` — status command documentation
- `acm-env/skills/env-auditor/references/baseline.yaml` — 6 new remove entries
- `capabilities-registry/declined.yaml` — 6 new declined entries
- `~/.claude/CLAUDE.md` — frontmatter removed (61→52 lines)

**Next priorities:**
- B34: MCP Server Registry — Develop stage (moved to Done, was blocking)
- B15: Deliver stage spec
- B18-B19: Memory layer spec and scaffold
- Link Triage Pipeline: Design stage (new session, run from `~/code/_shared/link-triage-pipeline/`)

**Project separation:** Capabilities registry now has its own BACKLOG.md, status.md, and .claude/CLAUDE.md. B35, B36, B13 migrated to capabilities-registry as CR-1, CR-2, CR-3.

**Repos:**
- ACM: https://github.com/jessepike/acm.git → `~/code/_shared/acm/`
- Capabilities Registry: https://github.com/jessepike/capabilities-registry.git → `~/code/_shared/capabilities-registry/`
- acm-env plugin: `~/.claude/plugins/acm-plugins/plugins/acm-env/`
- acm-plugins marketplace: `~/.claude/plugins/acm-plugins/`

Reference files:
- `BACKLOG.md` — full backlog with status
- `ACM-ENVIRONMENT-SPEC.md` — environment layer architecture
- `kb/CUSTOM-PLUGIN-INSTALLATION.md` — plugin install guide
- `kb/PLUGIN-DEVELOPMENT-PATTERNS.md` — plugin dev patterns and lessons
