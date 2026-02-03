---
project: "ADF (Agentic Development Framework)"
stage: "Develop"
updated: "2026-02-02"
---

# Status

## Current State

- **Stage:** Develop (ADF framework itself)
- **Focus:** Project initialization automation
- **Next Action:** Test `/adf-env:init` on real projects (pike-ace, others)
- **Recently Completed:** External Review Skill + MCP Server (B14), ADF MCP Server (13 tools, 59 tests), ACM → ADF framework rename (infrastructure + content + plugins + GitHub)

## What's Complete

### Discover Stage (v1.2.0)
- [x] Phase model: Exploration → Crystallization → Review Loop → Finalization
- [x] Two-phase review: Internal (Ralph Loop) + External (GPT/Gemini)
- [x] YAGNI principle integrated into review prompts
- [x] Exit criteria defined
- [x] Prompts created: `ralph-review-prompt.md`, `external-review-prompt.md`
- [x] Validated with real project (portfolio site)

### Design Stage Spec
- [x] ADF-DESIGN-SPEC.md — phases, inputs, outputs, exit criteria

### Develop Stage Spec
- [x] ADF-DEVELOP-SPEC.md (v2.1.0) — 8 phases, three-tier testing, progressive disclosure, build-to-design verification, closeout

### Supporting Specs
- [x] ADF-BRIEF-SPEC.md (v2.1.0)
- [x] ADF-INTENT-SPEC.md
- [x] ADF-PROJECT-TYPES-SPEC.md (v2.0.0)
- [x] ADF-STATUS-SPEC.md (v1.1.0)
- [x] ADF-TAXONOMY.md (v1.4.0)
- [x] ADF-README-SPEC.md (v1.0.0)
- [x] ADF-CONTEXT-ARTIFACT-SPEC.md (v1.0.0)
- [x] ADF-STAGES-SPEC.md (v1.1.0)
- [x] ADF-ENV-PLUGIN-SPEC.md (v1.0.0)
- [x] ADF-ARCHITECTURE-SPEC.md (v2.0.0) — master framework spec (six primitives, two layers, spec map, stage overview, artifact flow, interface map, spec index). Renamed from ADF-ENVIRONMENT-SPEC.md.
- [x] ADF-RULES-SPEC.md (v1.0.0) — `.claude/rules/` enforcement layer, governance model
- [x] ADF-REVIEW-SPEC.md (v1.0.0) — two-phase review mechanism, cycle rules, severity, YAGNI enforcement

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
- [x] ADF artifact updates (taxonomy, context-artifact spec, stages spec)

### Debrief Improvements (2026-01-29)
- [x] B1: Hardened start-develop-prompt.md (v2.0.0) — explicit STOP gate, registry query, phase boundary protocol
- [x] B3: Phase boundary protocol added to ADF-DEVELOP-SPEC.md (v1.2.0) — agent-driven `/clear` + re-read + confirm
- [x] B4: Review scoring across all 6 review prompts — Critical/High/Low severity, min 2 max 10 cycles, stop at zero C+H
- [x] B17: ADF-ENVIRONMENT-SPEC.md (v1.0.0) — six primitives, two-layer model, physical layout
- [x] BACKLOG.md created with 22 tracked items
- [x] KB/REVIEW-CYCLE-GUIDANCE.md updated to v2.0.0
- [x] Capability registry extraction brief created (`docs/inbox/capabilities-registry-brief.md`)

### Prompt & Terminology Cleanup (2026-01-29)
- [x] B5: All prompts emit ready-to-copy commands with resolved paths — ralph-review uses `~/code/_shared/adf/`, external review prompts have `sed | pbcopy` assembly commands
- [x] B6: Ralph Loop command audit — added Usage sections to design-ralph and develop-ralph prompts, created `run-discover-review.sh` and `run-develop-review.sh` scripts, fixed experiment placeholder paths
- [x] B7: Full prompt audit — fixed stale registry path in develop-artifact-correction-prompt, resolved bare spec reference in start-design-prompt
- [x] B8: Updated "commands" → "skills" terminology across ADF-ENV-SPEC, ADF-CONTEXT-ARTIFACT-SPEC, ADF-TAXONOMY, capability-registry brief, experiment docs

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

### Recently Completed
- [x] B14: External Review Skill + MCP Server — Build complete (34 tests, 6 phases)

### Recently Completed (cont.)
- [x] B54: ADF-ARCHITECTURE-SPEC.md elevated to master framework spec v2.0.0 — spec map, framework diagram, stages overview, artifact flow, interface map, spec index, revision history

### Next Up
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
| 2026-01-29 | Brainstormed and implemented acm-env plugin. Created ADF-ENV-PLUGIN-SPEC.md. Built full plugin scaffold with 4 commands, SessionStart hook, env-auditor skill, baseline.yaml, and dependency checker. Updated ADF-TAXONOMY.md (environment terms + 8 design decisions), ADF-CONTEXT-ARTIFACT-SPEC.md (replaced deferred acm-validate/acm-prune with acm-env reference), ADF-STAGES-SPEC.md (added acm-env as meta layer manager). |
| 2026-01-29 | Develop stage debrief session. Defined environment layer architecture (six primitives: orchestration, capabilities, knowledge, memory, maintenance, validation). Created ADF-ENVIRONMENT-SPEC.md, BACKLOG.md. Completed B1 (hardened start-develop prompt v2.0.0), B3 (phase boundary protocol in develop spec v1.2.0), B4 (review scoring across all 6 prompts — Critical/High/Low, min 2 max 10 cycles). Created capabilities-registry extraction brief for separate agent. Researched Claude Code 2.1.3 (commands folded into skills). Analyzed agent-harness sync system. Key decisions: registry as peer repo, memory as own repo, knowledge stays in ADF, workers are skills not separate repo, vendor is metadata not folder structure. |
| 2026-01-29 | Completed B5-B8 (prompt and terminology cleanup). All prompts now emit ready-to-copy commands with resolved paths. Ralph Loop usage sections added to all 3 stage prompts with matching run scripts. Stale registry paths and bare spec references fixed. "Commands" → "skills" terminology updated across ADF-ENV-SPEC, ADF-CONTEXT-ARTIFACT-SPEC, ADF-TAXONOMY, capability-registry brief, and experiment docs. |
| 2026-01-29 | Built acm-env plugin (all 8 phases) and capabilities registry. acm-env: plugin scaffold, 4 commands (status/setup/audit/reset), SessionStart hook, env-auditor skill, check-deps.sh with git freshness. Capabilities registry: migrated 20 capabilities from agent-harness (16 skills + 4 tools) + acm-env plugin = 21 total. capability.yaml as source of truth, generate-inventory.sh pipeline, REGISTRY-SPEC.md. Both repos pushed to GitHub (jessepike/acm, jessepike/capabilities-registry). Renamed capability-registry → capabilities-registry everywhere. Key decisions: plugins as 4th capability type, registry consumed by all stages, capability.yaml → inventory.json → INVENTORY.md data flow. Agent-harness ready to archive (B16). |
| 2026-01-30 | Fixed and installed acm-env plugin via local marketplace. Plugin had 3 issues: plugin.json had invalid fields (author as string, commands array), hooks.json used array instead of record, plugin was never registered through marketplace system. Created `acm-plugins` local marketplace at `~/.claude/plugins/acm-plugins/`, moved plugin source inside, registered and installed. Fixed check-deps.sh to query installed_plugins.json instead of filesystem paths. Fixed hardcoded paths in all 4 commands. Rewrote audit.md with explicit delegation to claude-md-management (CLAUDE.md quality scoring) and claude-code-setup (automation recommendations) — "You MUST delegate" pattern replacing vague "if available, delegate". Added capabilities registry validation to audit (cross-references INVENTORY.md against installed plugins). Assessed spec vs intent alignment — spec is sound, implementation had gaps in delegation and registry integration. Created KB articles: CUSTOM-PLUGIN-INSTALLATION.md, PLUGIN-DEVELOPMENT-PATTERNS.md. |
| 2026-01-30 | Ran `/acm-env:audit` end-to-end with delegation. Both dependency plugins (claude-md-management, claude-code-setup) successfully invoked — no fallbacks needed. Audit found 7 recommendations: fixed acm-env path in .claude/CLAUDE.md, trimmed global CLAUDE.md from 73→60 lines (B26), fixed 4 stale `ack-src/acm/` location paths in spec frontmatter, added frontmatter to DESIGN-HANDOFF.md, deleted stale inbox item (B27). Registry validation confirmed 7 untracked plugins (B23) and built-in skills model issue (B24). No automation recommendations for this spec/docs project. |
| 2026-01-30 | Massive capabilities registry and environment governance session. Registered 19 plugins total across 3 batches (registry grew 21→39). Added `install_id`/`install_level` to REGISTRY-SPEC.md schema. Defined plugin baseline v2.0.0 (6 required user-level, 15 available project-level, 3 to remove). Cleaned environment: removed superpowers/example-skills/serena, deleted 3 legacy commands (claude-mem, remember, save), disabled frontend-design/context7/playwright at user level. Created 2 new acm-env commands: `/acm-env:refresh` (upstream sync orchestrator) and `/acm-env:capabilities` (registry lookup). Fixed 4 registry scripts: check-freshness.sh (URL parsing + macOS timeout), sync.sh (skip active + declined), promote.sh (pipefail), and 6 upstream URLs. Implemented `declined.yaml` blocklist (15 entries: 3 MCP tools, 3 cruft plugins, 9 unused LSP plugins) integrated into sync pipeline. Researched all Anthropic marketplace plugins and 3 MCP tools. Plugin bumped to v1.1.0. |
| 2026-01-30 | Environment audit and registry cleanup session. Ran full `/acm-env:audit` with both delegations (claude-md-management, claude-code-setup). Found global CLAUDE.md at 60 lines (5 over limit), serena still installed (CLI uninstall failing), no MCP servers configured. Committed all uncommitted capabilities-registry work from prior session (27 files, 18 plugins, declined.yaml, spec fixes). Bumped REGISTRY-SPEC.md to v1.1.0 — fixed directory name typo, added declined section, updated Anthropic source to include plugins, removed stale brief reference. Updated README with declined.yaml and sources. Added B34 (MCP tools eval, P1), B35 (agents deep dive, P1/L), B36 (skills deep dive, P1/L) to backlog. Both repos pushed to GitHub. |
| 2026-01-30 | B34 MCP Server Registry — Discover complete, Design draft complete. Discover: drafted brief (brief-b34-mcp-servers.md), 2 internal review cycles, signed off at v1.0. Design: intake clarification (orchestration, interface, scan scope, triage filtering), drafted design-b34-mcp-servers.md v0.1. 7 work packages, extends refresh+setup commands, 3 new capability.yaml fields (install_vector, parent_plugin, transport), 4 plugin-bundled MCP extractions, baseline v3.0.0 schema. **Next: Design internal review (Ralph Loop), then external review, then Develop.** |
| 2026-01-30 | Link Triage Pipeline session. Reviewed PRD and design doc from link-triage repo. Analyzed B22 relationship. Split into two projects: pipeline (link-triage-pipeline) and future KB. Scaffolded link-triage-pipeline with ACM structure (intent, brief, CLAUDE.md). Ran Discover stage: internal review (3 cycles, 3 High resolved), external review (2 reviewers, clean pass, 3 Design questions). Brief at v0.4 status complete. Created ADF-REVIEW-SPEC.md (v1.0.0) — two-phase review mechanism spec (internal mandatory, external user-driven). Added `.claude/rules/review-process.md` — binding rule requiring Ralph Loop plugin for all internal reviews. Refactored all 6 stage review prompts to deduplicate mechanism against spec (-403/+207 lines). **Next: Design stage for link-triage-pipeline in new session.** |
| 2026-01-30 | Rules enforcement layer session. Reviewed Claude Code `.claude/rules/` capability and integrated into ACM. Created `.claude/rules/constraints.md` (security, governance, safety, session discipline, architectural boundaries). Created ADF-RULES-SPEC.md (v1.0.0) — two-layer governance model (rules=policy, CLAUDE.md=guidance), five content categories, file organization, lifecycle. Added rules stub for init script. Updated environment spec (governance model section), taxonomy (rules term + design decision), folder structure spec, global/project CLAUDE.md specs, init script. Added session discipline enforcement: rule requiring auto-commit and status.md updates (no asking), plus acm-env Stop hook (`stop-check.sh`) that blocks session end when uncommitted changes or stale status.md detected. Added hooks governance to baseline.yaml (declared hooks inventory), status dashboard (hooks section with drift detection), and audit command (section 5: hooks governance — scans for undeclared user-level hooks). Updated ADF-ENV-PLUGIN-SPEC.md with Stop hook, hooks governance section, and hooks in user-level baseline. |

| 2026-01-31 | B34 MCP Server Registry — Develop complete. All 7 WPs implemented. REGISTRY-SPEC.md v1.2.0 (3 MCP fields, 3 community sources, inbox). 4 legacy MCPs deleted+declined, 4 plugin-bundled MCPs created. baseline.yaml v2.1.0 (mcp_servers governance). refresh.md extended (community scan + triage). setup.md extended (MCP server checks). Inventory regenerated (39 caps). First triage: 500+ servers scanned, 0 high-relevance. Note: 4 plugin-bundled MCP upstream URLs unreachable (anthropics/claude-code-plugins likely private). |
| 2026-01-31 | Project separation — capabilities registry bootstrapped as independent project (BACKLOG.md, status.md, .claude/CLAUDE.md). Migrated B35→CR-1, B36→CR-2, B13→CR-3 to registry backlog. Archived processed B34 inbox docs. ACM backlog now ADF-scoped only. |
| 2026-01-31 | ADF MCP Server — Develop Phase 6 build complete. All phases A-E done. 13 tools implemented, 59 tests passing, companion skill created (skills/acm-workflow/), consumer wiring (.mcp.json), README. All 9 success criteria verified. |
| 2026-01-31 | Scope-aware status command + environment cleanup. Updated `/acm-env:status` with `--scope` flag (project default, user). Project scope shows user-level foundation + project specifics + capabilities (plugins, MCP servers). User scope shows cross-project config, plugins, MCP servers, hooks. Updated ADF-ENV-PLUGIN-SPEC.md with status command docs. Ran status check — found global CLAUDE.md at 61 lines (removed frontmatter → 52, PASS). Audited MCP server state: 0 standalone user-level, 13 plugin-bundled, 0 project-level for ADF. Identified 6 unwanted plugins with bundled MCP servers (asana, firebase, gitlab, laravel-boost, linear, slack) — added to baseline remove list + declined.yaml (21→27 declined). Clarified status vs inventory separation: status=validation (PASS/FAIL), capabilities=discovery (what's available). |
| 2026-01-31 | ADF MCP Server build complete — all phases. Phase D: companion skill (skills/acm-workflow/). Phase E: consumer wiring (.mcp.json), README, all 9 success criteria verified. Manual testing via MCP Inspector + Claude in Chrome — 4 tools tested across all categories, all passing. KB article: MCP-SERVER-MANUAL-TESTING.md. Architecture spec updated to v1.3.0 — new MCP Server Interface Layer section, MCP tool references on Orchestration/Capabilities/Knowledge/Validation primitives. Archived experiments/, cleaned up transient build docs. |
| 2026-01-31 | B14 External Review Skill — Design complete. Reviewed external review spec against ACM Architecture Spec and MCP Server Brief for alignment (all clean). Updated ADF-ARCHITECTURE-SPEC v1.2.0 (added skills/ and adf-server/ to physical layout). Added Stage column to BACKLOG.md for pipeline tracking. Archived ADF MCP server docs to .archive/. Moved spec from docs/inbox/ to docs/design.md, created discover-brief.md. Phase 1 internal review: 2 Ralph Loop cycles, 3C + 3H resolved (frontmatter, artifact paths, Phase 2 min cycles, ADF MCP server integration, moonshot→openai_compat collapse). Phase 2 external review (Gemini + GPT): 1 cycle, 1C + 3H resolved (provider ID mapping, artifact_content→artifact_path, extra_params pass-through, retry policy). Design v1.3.0 complete. Added B44 (frontmatter stage tracking), B45 (stage transition cleanup). |
| 2026-01-31 | B14 Develop Phases 1-4 complete. Phase 1 (Intake): resolved 6 design questions (path validation→project root+home, partial load, no cost metadata, project .mcp.json, venv, official mcp SDK). Phase 2 (Capability Assessment): manifest.md + capabilities.md. Phase 3 (Planning): plan.md + tasks.md (11 tasks, 6 phases). HARD GATE approved. Phase 4 (Review): Ralph Loop internal review — 3 cycles, 1C + 4H resolved (TDD co-location, venv task, server entry point, requirements.txt sequencing). Plan v1.1.0 ready for build. |
| 2026-02-01 | ADF-DEVELOP-SPEC.md v2.0.0 — major revision. Added Phase 7 (Documentation) + Phase 8 (Closeout). Two-tier testing model (automated + real-world). Progressive disclosure in tasks.md. Build-to-design verification in Phase 6. Commit cadence section. Universal + type-specific exit criteria. Removed registration from Develop (→ Deliver). ADF-STAGES-SPEC.md v1.2.0 — universal exit criteria + stage boundary handoff protocol. ADF-FOLDER-STRUCTURE-SPEC.md v1.2.0 — docs/adf/ convention for stage planning artifacts. Moved B14 artifacts to docs/adf/. Added B46-B51 to backlog. |
| 2026-01-31 | B14 Develop Phases 5-6 complete — full build. Phase A: scaffold, venv, config loading (9 tests), path validation (7 tests), provider base, MCP entry point + list_models. Phase B: OpenAI-compat provider (5 tests), Google provider (5 tests) — both with retry/backoff/extra_params. Phase C: review tool with parallel asyncio.gather, partial failures (5 tests). Phase D: config.yaml + SKILL.md. Phase E: integration tests (3 tests). Phase F: .mcp.json registration. Total: 34 tests passing, all 11 tasks done. |
| 2026-02-01 | B54: Elevated ADF-ARCHITECTURE-SPEC.md to master framework spec v2.0.0. Added spec map (reading guide), framework workflow diagram, stages overview, artifact flow model, interface map, complete spec index (19 specs with verified versions), revision history. Corrected plan version discrepancies (INTENT 1.0.1, REVIEW 1.2.0) and included 3 specs plan missed (BACKLOG, GLOBAL-CLAUDE-MD, PROJECT-CLAUDE-MD). |
| 2026-02-01 | B14 External Review — pricing + orchestration. Added per-model cost tracking to MCP server (calculate_cost in base.py, pricing pass-through in openai_compat + google providers, aggregated total_cost_usd + total_tokens in review response). Updated models.yaml with pricing rates. Rewrote SKILL.md with complete orchestration loop (8 substeps: call → synthesize → classify → capture → fix → update → check → loop), action matrix, synthesis prompt template, stop condition table, cost reporting in cycle logs and final summary. |
| 2026-02-01 | acm-review plugin created. 3 commands: `/acm-review:artifact` (full P1→P2), `/acm-review:artifact-internal` (P1 only), `/acm-review:artifact-external` (P2 only). Created 3 external ralph prompts (orchestrator prompts for Claude inside Ralph Loop calling MCP review tool). Simplified SKILL.md to single-cycle engine (removed loop logic — Ralph Loop handles iteration). Updated review-process.md rules with new command patterns and expanded prompt map. Plugin registered under acm-plugins marketplace. |
| 2026-02-01 | ADF-ARCHITECTURE-SPEC.md internal review (v2.0.0 → v2.0.1). 2 Ralph Loop cycles, 1C + 5H resolved. Fixes: marked memory layer as planned (B18-B19) throughout spec (physical layout, primitive detail, component diagram), clarified artifact flow describes consumer projects not ADF repo, corrected spec index primitive assignments (STATUS + README → Orchestration), clarified registry coupling (ecosystem-aware but no functional dependency), added self-improvement loop implementation status (steps 3-4 operational, steps 1-2 awaiting memory layer). 4 Low issues accepted. |
| 2026-02-01 | External review workflow improvements (5 fixes from testing). Added `--prompt-file` to ralph-loop setup script (avoids shell pipe corruption). Updated all 3 acm-review commands to use `--prompt-file`. Added single-model warning to artifact-external (20% observed false positive rate). Updated review-process.md rules. Created B59 (review tuning sprint) with KB tracking log at `kb/EXTERNAL-REVIEW-MODEL-RELIABILITY.md` — structured per-review iteration log, tuning targets, pattern log, milestone-based recommendations (reassess at 5/10/20 reviews). |
| 2026-02-01 | Backlog cleanup + stage spec alignment + terminology sweep. Cleaned backlog: archived 6 done items (B14, B34, B40, B42, B35, B54), removed 2 superseded (B49, B50), renumbered duplicate B54→B60, sorted by priority. Closed B52 (acm-review plugin done). B55+B56+B57 batch: added universal exit criteria reference, stage boundary handoff protocol, and docs/adf/ convention to DISCOVER-SPEC (v1.3.0) and DESIGN-SPEC (v1.1.0) — both now align with DEVELOP-SPEC pattern. B53: slimmed review-process.md from 53→14 lines (enforcement-only, mechanism details now in acm-review plugin). B37: "meta layer" → "environment layer" across 5 files, 11 instances (ENV-PLUGIN-SPEC, STATUS-SPEC, STAGES-SPEC, 2 visual prompts). Git email set to jesse@keatingpike.com globally. |
| 2026-02-01 | B46+B47: Updated develop prompts. start-develop-prompt v2.1.0 — added Phase 7 (Documentation) + Phase 8 (Closeout) to sequence, two-tier testing model, build-to-design verification, docs/adf/ artifact paths. develop-ralph-review-prompt v3.1.0 — expanded Testing Strategy dimension (two-tier + project-type checks), added Build-to-Design Verification review dimension, fixed artifact paths to docs/adf/. |
| 2026-02-01 | B59 Review tuning sprint — first real test run. Ran full review (`/acm-review:artifact`) on link-triage-pipeline design.md. Phase 1 internal: 2 cycles, 0 issues (design already well-reviewed). Phase 2 external: 3 cycles (Gemini+GPT, Kimi timed out), 3 High resolved (URL PK→raindrop_id + normalized_url dedup, API call count clarification, two-step dedup logic), 6 Low logged. $0.030 total external cost. Added observation logging step (Step 5/6) to all 3 acm-review commands — agents now append to KB tracking log after every review. Logged observations #2-3 in KB. Patterns emerging: models re-raise tracked OQs despite instructions, GPT tends toward enterprise-grade suggestions for MVP projects, Kimi timeout needs investigation. |
| 2026-02-02 | B15: Deliver stage spec complete. Created ADF-DELIVER-SPEC.md v1.0.0 — 8-phase model with Review → HARD GATE → Execution pattern (correct ordering, unlike Develop). Key features: 3-tier testing model (Automated → Browser/Agent → Manual), project-type specific guidance (Artifact/App/Workflow), deployment/distribution focus, progressive disclosure in tasks.md. Created 3 supporting prompts: start-deliver-prompt.md v1.0.0, deliver-ralph-review-prompt.md v1.0.0, deliver-external-review-prompt.md v1.0.0. Identified architectural issue: Develop's HARD GATE should come AFTER review, not before (currently: Plan → HARD GATE → Review; correct: Plan → Review → HARD GATE → Execution). Added B61 to backlog for cross-cutting fix. Deliver spec uses correct pattern from the start. Unblocks B39 + B51 (ACM MCP server deliver enum support). |
| 2026-02-02 | B39+B51: ADF MCP server deliver support complete. Updated ADF-ARCHITECTURE-SPEC.md (removed "B15 pending" reference). Updated adf-server/src/tools/orchestration.ts: added "deliver" to all three enums (get_stage, get_review_prompt, get_transition_prompt), added deliver to STAGE_FILES/PROMPT_MAP/TRANSITION_FILES, added develop_to_deliver transition validation. Updated tool-guide.md with deliver references. Rebuilt MCP server successfully (58/59 tests passing, 1 pre-existing failure unrelated to changes). MCP server now serves ADF-DELIVER-SPEC.md, deliver review prompts, and start-deliver-prompt.md. Full deliver stage lifecycle now supported in framework. |
| 2026-02-02 | B60+B61: Minor polish complete. B60: Created start-discover-prompt.md v1.0.0 — entry-point prompt for Discover stage, parallel to other start prompts. Covers project setup validation, exploration phase initiation. B61: Fixed Develop HARD GATE placement — moved from after Phase 3 to after Phase 4 (Review Loop). Updated ADF-DEVELOP-SPEC.md to v2.1.0, start-develop-prompt.md to v2.2.0. Correct pattern now: Plan → Review → HARD GATE → Execution (matches Deliver). Phase 4 renamed "Review Loop & Approval" combining internal/external review + human approval. All four stages now complete and architecturally aligned. |
| 2026-02-02 | ACM → ADF content rename complete. Added backlog items B64-B66 for plugin renames (acm-env, acm-review) and consumer updates. Replaced 250+ ACM references across 76 files: file/section headings, path references (acm/ → adf/), prose ("the ACM" → "the ADF"), frontmatter (scope: "acm" → scope: "adf"). Preserved plugin names acm-env and acm-review for separate rename. 3 commits: infrastructure (9288e28), original content (3c44689), final content (cd9a324). Framework now consistently named ADF (Agentic Development Framework) throughout. |
| 2026-02-02 | ACM → ADF rename COMPLETE. Infrastructure: renamed directories acm-server → adf-server, acm-plugins → adf-plugins, acm/ → adf/. MCP server: updated server name "acm" → "adf", environment variables ACM_ROOT → ADF_ROOT, README paths. Skills: updated adf-workflow skill references. Plugins (B64-B66): marketplace ID acm-plugins → adf-plugins, plugin names acm-env → adf-env + acm-review → adf-review, all configuration files (marketplace.json, known_marketplaces.json, installed_plugins.json), version bumps to 2.0.0. GitHub: renamed repository anthropics/acm → anthropics/adf. All commits pushed (4 commits across 2 repos). Plugin system fully functional. Rename project complete. |
| 2026-02-02 | adf-env plugin v2.1.0 — added `/adf-env:init` command for project scaffolding. Built command orchestrator (commands/init.md) and specialized project-init agent (agents/project-init.md, 7 phases). Agent handles brief-first initialization: ingests concept brief, minimal classification (2 questions), creates full ADF structure, git init + .mcp.json config, validation via ADF MCP server, handoff to Discover. Infrastructure-only — no Discover work (parsing/reviews/research). Committed to adf-env plugin. Added B67 to backlog (research phase in Discover). Ready for user testing on real projects. |
| 2026-02-02 | Plugin troubleshooting + prompt improvements. Fixed adf-review plugin (v2.0.1) — updated all ACM → ADF paths in commands (acm/prompts → adf/prompts, acm/kb → adf/kb). Fixed marketplace registration issues for adf-env/adf-review. Updated start-discover-prompt.md (v1.1.0) — added Steps 5-7 with full Crystallization + Review Loop + Finalization guidance. Agents now know to check available skills and use `/adf-review:artifact` for mandatory review. Real-world tested on pike-ace project initialization. |
| 2026-02-03 | Stage transition artifact cleanup system complete. Created `.claude/rules/archive.md` (write-only access for agents). Created 3 transition prompts with cleanup checklists (discover-to-design, design-to-develop, develop-to-deliver). Added "Artifact Lifecycle" section to ADF-STAGES-SPEC.md (deliverable vs working artifacts per stage). Added Stage Handoff Template to ADF-STAGES-SPEC.md (canonical structure for status.md handoffs). Renamed `_archive/` → `.archive/` for consistency with `.claude/` naming (updated all specs, rules, prompts). Updated ADF MCP server (orchestration.ts transition prompt paths, project.ts structure validation). Updated adf-env plugin (4 files: project-init.md, audit.md, reset.md, setup.md). All changes committed and pushed. Framework now has complete stage transition discipline with artifact lifecycle governance. |

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

### B14: External Review Skill — Build Complete (2026-01-31)

**Where we are:** Develop Phase 6 (Build) complete. All 11 tasks done, 34 tests passing. Ready for Develop internal review (Phase 7).

**What was built:**
- `skills/external-review/server/` — Python MCP server with FastMCP + stdio
- `config.py` — loads `~/.claude/models.yaml` + `config.yaml`, partial load, env var resolution (9 tests)
- `path_validation.py` — restricts artifact paths to project root + home (7 tests)
- `providers/base.py` — abstract BaseProvider + ReviewResponse dataclass
- `providers/openai_compat.py` — chat completion, retry w/ backoff, extra_params (5 tests)
- `providers/google.py` — generateContent, retry w/ backoff, extra_params (5 tests)
- `external_review_server.py` — 2 MCP tools: `list_models`, `review` (parallel via asyncio.gather)
- `test_review_tool.py` — review tool tests: all succeed, partial failure, all fail, not found, unknown model (5 tests)
- `test_integration.py` — server import, list_models, full review flow (3 tests)
- `skills/external-review/config.yaml` — stage→prompt mapping, defaults, cycle rules
- `skills/external-review/SKILL.md` — orchestration instructions for Claude Code
- `.mcp.json` — external-review server registered

**What was configured this session:**
- Created `~/.claude/models.yaml` — 3 models (gemini, gpt, kimi) with `api_key_env` references
- API keys stored as env vars in `~/.zshrc` (GOOGLE_API_KEY, OPENAI_API_KEY, MOONSHOT_API_KEY)
- Created `skills/external-review/README.md` — setup, API key config, MCP tools, testing docs

**What's next:**
- Restart Claude Code (MCP servers need new env vars)
- Live test: `list_models` should show 3 models with `available: true`
- Live test: `review` with a real artifact to confirm end-to-end
- Develop internal review (Phase 7) via Ralph Loop
- Then close out B14

**Repos:**
- ACM: `~/code/_shared/adf/`
- Capabilities Registry: `~/code/_shared/capabilities-registry/`
