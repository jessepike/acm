---
project: "ADF (Agentic Development Framework)"
stage: "Develop"
updated: "2026-02-09"
---

# Status

## Current State
- **Phase:** Build (framework quality improvements)
- **Focus:** Session discipline enforcement, spec compliance

## Next Steps
- [x] Build ADR skill — ADF-native Architecture Decision Records (first custom skill from marketplace research)
- [ ] Build Project Health Auditor skill — code-level health metrics complementing adf-env:audit
- [ ] Build Security Review skill — proactive review-pipeline-aware security checks
- [ ] B75: Standardize status enum values (in-progress vs in_progress) — blocks Work OS connector
- [ ] B76-B77: Spec cleanup (ACM remnant, status.md format drift)

## Session Log

| Date | Summary |
|------|---------|
| 2026-02-09 | **ADR skill v1.0.0 built + registered.** Created `skills/adr/SKILL.md` and `skills/adr/references/adr-template.md`. Four workflows: create, list, update-status, link. Registered in capabilities-registry (50→55 total, including 4 previously untracked agents). Verified MCP discoverability via `query_capabilities("adr")`. |
| 2026-02-09 | **Capability deep-dive planning.** Reviewed Tier 1 capabilities (Trail of Bits security skills, Project Health Auditor, ADR, Compliance Checker) against ADF needs. Decision: build custom ADF-native skills inspired by marketplace patterns rather than importing — tighter integration with ADF governance, stage flow, and review pipeline. Prioritized build order: (1) ADR skill, (2) Project Health Auditor skill, (3) Security Review skill. Approach: use marketplace as design brief, build purpose-built skills with Opus 4.6. |
| 2026-02-09 | **Marketplace research synthesis & KB capture.** Continued from prior session's 5-agent parallel research. Collected final outputs from all research agents (SkillsLLM: 1020 skills, SkillsMP/VoltAgent/ClaudeCodePlugins detailed). Captured comprehensive findings to KB (`2186aefe`). Produced prioritized shortlist: Tier 1 direct-fit (Trail of Bits 23+ security skills, Project Health Auditor, ADR skill, Compliance Checker), Tier 2 pattern-mining (Sprint plugin, planning-with-files, rulebook-ai, claude-flow), Tier 3 utility (cclsp LSP bridge, Skill_Seekers). Cross-referenced against registry (50 capabilities) — identified gaps in security review, ADR, compliance, code health metrics. |
| 2026-02-09 | **Agent skill ecosystem research.** Analyzed 7 sources across 3 tiers: SkillsMP (25K+ skills, SKILL.md standard), SkillsLLM (1020 skills), VoltAgent/awesome-agent-skills (339+ curated from Anthropic/Trail of Bits/Sentry/Cloudflare/Microsoft), daymade/claude-code-skills, netresearch/claude-code-marketplace, ClaudeCodePlugins (313 plugins, 1336 skills, 29 categories). Mapped relevance to ADF across 6 dimensions (orchestration, governance, quality, docs, testing, review). Key findings: SKILL.md is the universal open standard; Sprint plugin closest to ADF orchestration; no ecosystem offers ADF's stage-gated orchestration, artifact spec enforcement, multi-phase review, or intent protection — these are ADF's unique differentiators. |
| 2026-02-07 | Removed redundant `skills/ecosystem-alignment/` from ADF repo (now in plugin). Registered ecosystem-alignment plugin + ecosystem-steward agent in capabilities-registry (48→50). Verified MCP discoverability via `query_capabilities`. |
| 2026-02-07 | **Ecosystem steward plugin.** (1) Created `ecosystem-alignment` plugin with `ecosystem-steward` agent, `/ecosystem:audit` command, and skill. (2) Ran first full audit — 17 findings across 6 checks (1 aligned, 4 drift, 1 gap). (3) Filed B75-B80 from audit findings. (4) Saved report to `docs/reports/ecosystem-alignment-2026-02-07.md`. Key findings: status enum mismatch (High), Krypton↔Work OS observation gap, terminology collisions. |
| 2026-02-07 | Ecosystem alignment skill: drafted `skills/ecosystem-alignment/SKILL.md` v0.1.0 — 6 checks (governing docs, interface contracts, dependency chain, terminology, intent alignment, open decisions). Audit-only, complements adf-env (per-project) and adf-review (per-artifact). Also drafted `docs/ecosystem-architecture.md` v0.1.0 — three-layer model (Process/Data/Intelligence), system map, integration points, dependency chain, current state. |
| 2026-02-07 | **Context harness analysis & KB integration.** (1) Mapped complete 9-layer ADF context harness (context, enforcement, memory, config, session state, ADF artifacts, plugins, agent memory, MCP) — captured to KB (`9631c0de`). (2) Analyzed auto-memory as ADF's unbuilt Memory primitive (B18-B19) — captured to KB (`1b556a4e`). (3) Added B74 (harness alignment audit) to BACKLOG v2.3.0. (4) Registered KB MCP server in .mcp.json — ADF agents can now query KB for cross-project knowledge. Changes from KB project session. |
| 2026-02-07 | Ecosystem synthesis continued: analyzed alignment of inbox docs against ADF-ARCHITECTURE-SPEC, identified gap (spec is inward-facing, missing ecosystem-level view). Proposed docs/ecosystem-architecture.md artifact to capture macro system map, layer model, integration points, and build dependencies. |
| 2026-02-07 | Ecosystem synthesis: reviewed inbox docs (Krypton brief v1, Work OS brief v5, memory layer research), mapped full project stack and inter-project dependencies (ADF → Work OS → Krypton). |
| 2026-02-07 | Registry audit: added kb-manager, link-triage, knowledge-base, doc-mgr to capabilities-registry (44→48). |
| 2026-02-04 | Added intent.md validation (Section 9) to adf-env audit — existence, frontmatter, sections, word count, placeholders, CLAUDE.md xref. Enhanced baseline.yaml. |
| 2026-02-04 | Quick wins: B69 (uninstall execute-plan), complete ACM→ADF rename in 13 files (specs, kb, prompts, server). |
| 2026-02-04 | Completed CLAUDE.md inheritance: adf-env:status size checks, baseline.yaml v2.2.0 with duplication validation and status.md limits. |
| 2026-02-04 | Global/Project CLAUDE.md alignment: Updated specs (v1.2.0), removed Agent Session Protocol from all stubs, added duplication detection to adf-env audit. |
| 2026-02-03 | adf-review skill unified. Stage transition cleanup. Archive rules. |

## Notes
- Historical sessions archived to `status-archive.md`. See `BACKLOG.md` for work items.
