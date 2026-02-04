# Status Archive

Historical session logs and completed work archived from status.md per ADF-STATUS-SPEC pruning rules.

---

## What's Complete (as of 2026-02-04)

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

### Deliver Stage Spec
- [x] ADF-DELIVER-SPEC.md (v1.0.0) — 8-phase model, 3-tier testing, project-type guidance

### Supporting Specs (all complete)
- ADF-BRIEF-SPEC.md (v2.1.0)
- ADF-INTENT-SPEC.md (v1.0.1)
- ADF-PROJECT-TYPES-SPEC.md (v2.0.0)
- ADF-STATUS-SPEC.md (v1.1.0)
- ADF-TAXONOMY.md (v1.4.0)
- ADF-README-SPEC.md (v1.0.0)
- ADF-CONTEXT-ARTIFACT-SPEC.md (v1.0.0)
- ADF-STAGES-SPEC.md (v1.2.0)
- ADF-ENV-PLUGIN-SPEC.md (v1.0.0)
- ADF-ARCHITECTURE-SPEC.md (v2.1.0)
- ADF-RULES-SPEC.md (v1.0.0)
- ADF-REVIEW-SPEC.md (v1.2.0)
- ADF-BACKLOG-SPEC.md (v1.0.0)
- ADF-FOLDER-STRUCTURE-SPEC.md (v1.2.0)
- ADF-TASKS-SPEC.md (v1.0.0)

### ADF MCP Server
- [x] 13 tools implemented, 59 tests passing
- [x] Companion skill (skills/adf-workflow/)
- [x] Consumer wiring (.mcp.json)

### adf-env Plugin (v2.1.0)
- [x] 6 commands: status, setup, audit, reset, refresh, capabilities, init
- [x] SessionStart hook, Stop hook
- [x] env-auditor skill
- [x] baseline.yaml governance

### adf-review Plugin (v2.0.1)
- [x] 3 commands: artifact, artifact-internal, artifact-external
- [x] Unified review orchestration

### External Review MCP Server
- [x] 34 tests, multi-model support (Gemini, GPT, Kimi)
- [x] Cost tracking, parallel execution

### Capabilities Registry
- [x] 44 capabilities registered
- [x] All ADF components registered

---

## Archived Session Log

| Date | Summary |
|------|---------|
| 2026-01-27 | Discover stage complete. Two-phase review validated. YAGNI integrated. |
| 2026-01-28 | Design and Develop stage specs complete. |
| 2026-01-29 | Built acm-env plugin, capabilities registry. Environment layer architecture defined. |
| 2026-01-30 | Plugin installation fixes, audit delegation, registry governance (21→39 capabilities). |
| 2026-01-31 | B34 MCP Server Registry complete. ADF MCP Server build complete. |
| 2026-02-01 | ADF-DEVELOP-SPEC v2.0.0. External review pricing. acm-review plugin created. |
| 2026-02-02 | B15 Deliver spec. ACM→ADF rename complete. adf-env:init command. |
| 2026-02-03 | Stage transition cleanup. adf-review skill unified. Archive rules created. |

---

## Decisions Log

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | Single `--scope` flag for status | Same operation at different scopes |
| D2 | Project scope is default | Most common use case |
| D3 | Project view includes user-level | Full picture needed |
| D4 | Status vs inventory separate | Validation ≠ discovery |
| D5 | ADF owns implementation, registry owns discovery | Clear separation of concerns |
