---
project: "ACM (Agentic Context Management)"
stage: "Develop"
updated: "2026-01-30"
---

# Status

## Current State

- **Stage:** Develop (ACM framework itself)
- **Focus:** Rules enforcement layer — `.claude/rules/` governance model integrated into ACM

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
- [x] ACM-ENVIRONMENT-SPEC.md (v1.0.0) — environment layer architecture (six primitives, two layers)
- [x] ACM-RULES-SPEC.md (v1.0.0) — `.claude/rules/` enforcement layer, governance model

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

### Next Up
- [ ] B35: Deep dive — agents capability type (P1, L)
- [ ] B36: Deep dive — skills catalog leverage (P1, L)
- [ ] B34: Evaluate MCP tools for environment (P1, M)
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
| 2026-01-30 | Rules enforcement layer session. Reviewed Claude Code `.claude/rules/` capability and integrated into ACM. Created `.claude/rules/constraints.md` (security, governance, safety, session discipline, architectural boundaries). Created ACM-RULES-SPEC.md (v1.0.0) — two-layer governance model (rules=policy, CLAUDE.md=guidance), five content categories, file organization, lifecycle. Added rules stub for init script. Updated environment spec (governance model section), taxonomy (rules term + design decision), folder structure spec, global/project CLAUDE.md specs, init script. Added session discipline enforcement: rule requiring auto-commit and status.md updates (no asking), plus acm-env Stop hook (`stop-check.sh`) that blocks session end when uncommitted changes or stale status.md detected. |

---

## Notes for Next Session

acm-env v1.1.0 with 6 commands fully operational. Capabilities registry at 39 capabilities with full governance: baseline.yaml v2.0.0, declined.yaml blocklist, upstream sync with staging/promote/decline workflow.

**Next priorities:**
- B35: Deep dive — agents capability type (research, populate capabilities/agents/)
- B36: Deep dive — skills catalog leverage for ACM workflows
- B34: Evaluate MCP tools for environment
- B15: Deliver stage spec

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
